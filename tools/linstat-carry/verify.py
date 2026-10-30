#!/usr/bin/env python3
"""Verify retained linStat carries against real source, without a full IOC build."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
from zoneinfo import ZoneInfo


PIN = "b4729e43c8ee9791975abbc7e06b870f46fb9661"
ROOT = Path(__file__).resolve().parents[2]
TIMEZONE = "America/Los_Angeles"
AXIS_EPOCH = int(datetime(2026, 7, 15, 12, tzinfo=timezone.utc).timestamp())


class Verification:
    def __init__(self, args):
        self.args = args
        self.work = args.work_dir.resolve()
        self.work.mkdir(parents=True, exist_ok=False)
        self.commands = []
        self.results = {}

    def run(self, argv, cwd=None, expected=0, data=None, env=None):
        context = dict(os.environ, LC_ALL="C")
        context.update(env or {})
        cwd = Path(cwd or self.work)
        proc = subprocess.run(
            [str(arg) for arg in argv], cwd=cwd, input=data, text=True,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=context,
            timeout=120,
        )
        self.commands.append({
            "argv": [str(arg) for arg in argv], "cwd": str(cwd),
            "time": datetime.now(timezone.utc).isoformat(), "env": env or {},
            "stdin": data, "exit_code": proc.returncode,
            "stdout": proc.stdout, "stderr": proc.stderr,
        })
        if expected is not None and proc.returncode != expected:
            raise RuntimeError(f"Unexpected exit {proc.returncode}: {argv}\n{proc.stderr}")
        return proc

    def export(self, label):
        tree = self.work / label / "linStat-src"
        tree.mkdir(parents=True)
        archive = self.work / "pin.tar"
        self.run(["tar", "-xf", archive, "-C", tree])
        return tree

    def apply(self, tree, patch):
        args = ["patch", "--batch", "--fuzz=0", "--no-backup-if-mismatch", "-p0", "-i", patch]
        self.run(args + ["--dry-run"], cwd=tree)
        self.run(args, cwd=tree)

    def compile(self, tree, table, label):
        src = tree / "statApp/src"
        base = self.args.base.resolve()
        arch = self.args.arch
        executable = self.work / label
        rtc = table == "rtc"
        command = [
            self.args.cxx, "-std=c++17", "-g", "-O1", "-fsanitize=undefined",
            "-fno-sanitize-recover=all", "-pthread",
            '-DTABLE_SOURCE="' + ("tblRTC.cpp" if rtc else "tblNetstat.cpp") + '"',
            "-DTABLE_REGISTER=" + ("linStatRTCTable" if rtc else "linStatNetstatTable"),
            '-DTABLE_NAME="' + table + '"',
            "-I" + str(src), "-I" + str(base / "include"),
            "-I" + str(base / "include/os/Linux"),
            "-I" + str(base / "include/compiler/gcc"),
            Path(__file__).with_name("table_probe.cpp"),
            src / "tblBase.cpp", src / "nlreact.cpp", src / "iochooks.cpp",
            "-L" + str(base / "lib" / arch),
            "-Wl,-rpath," + str(base / "lib" / arch),
            "-ldbCore", "-lCom", "-ldl", "-o", executable,
        ]
        self.run(command)
        return executable

    def probe(self, executable, fixture, epoch, expected=0):
        result = self.run([executable, fixture, str(epoch)], expected=expected,
                          env={"TZ": TIMEZONE, "UBSAN_OPTIONS": "print_stacktrace=1"})
        values = dict(line.split("=", 1) for line in result.stdout.splitlines() if "=" in line)
        return result, values

    def rtc(self, upstream, corrected):
        old = self.compile(upstream, "rtc", "rtc-upstream")
        new = self.compile(corrected, "rtc", "rtc-corrected")
        cases = []
        instants = [
            "2026-01-15T12:00:00", "2026-07-15T12:00:00",
            "2026-03-08T09:59:00", "2026-03-08T10:01:00",
            "2026-11-01T07:59:00", "2026-11-01T10:01:00",
        ]
        for instant in instants:
            utc = datetime.fromisoformat(instant).replace(tzinfo=timezone.utc)
            epoch = int(utc.timestamp())
            for kind, moment, ref in [("utc", utc, 0), ("local", utc.astimezone(ZoneInfo(TIMEZONE)), 1)]:
                name = instant.replace(":", "-") + "-" + kind
                fixture = self.work / (name + ".rtc")
                fixture.write_text(moment.strftime("rtc_date : %Y-%m-%d\nrtc_time : %H:%M:%S\nbatt_status : okay\n"))
                _, values = self.probe(new, fixture, epoch)
                assert values["delta"] == "0" and values["ref"] == str(ref), (name, values)
                assert values["battery"] == "2" and values["last_ok"] == "1"
                cases.append(name)
                if instant == "2026-07-15T12:00:00" and kind == "local":
                    _, before = self.probe(old, fixture, epoch)
                    assert before["delta"] == "3600", before
                    self.results["dst_before_after"] = [int(before["delta"]), int(values["delta"])]

        valid = "rtc_date : 2026-07-15\nrtc_time : 12:00:00\nbatt_status : okay\n"
        variants = {
            "bad-date": valid.replace("2026-07-15", "invalid"),
            "bad-time": valid.replace("12:00:00", "invalid"),
            "trailing-date": valid.replace("2026-07-15", "2026-07-15x"),
            "trailing-time": valid.replace("12:00:00", "12:00:00x"),
            "missing-date": valid.replace("rtc_date : 2026-07-15\n", ""),
            "missing-time": valid.replace("rtc_time : 12:00:00\n", ""),
        }
        for name, content in variants.items():
            fixture = self.work / (name + ".rtc")
            fixture.write_text(content)
            _, values = self.probe(new, fixture, AXIS_EPOCH)
            assert "delta" not in values and "ref" not in values, values
            assert values["battery"] == "2"
            if name.startswith("bad-"):
                before, _ = self.probe(old, fixture, AXIS_EPOCH, expected=None)
                assert before.returncode != 0 and "null pointer" in before.stderr
            cases.append(name)
        _, values = self.probe(new, self.work / "absent.rtc", AXIS_EPOCH)
        assert values["last_ok"] == "0" and "delta" not in values
        cases.append("missing-file")
        offset = self.work / "offset.rtc"
        offset.write_text(valid.replace("12:00:00", "11:59:55"))
        _, values = self.probe(new, offset, AXIS_EPOCH)
        assert values["delta"] == "5" and values["ref"] == "0"
        cases.append("utc-five-second-offset")
        self.results["rtc_cases"] = cases

    def netstat(self, pin, corrected):
        fixture = self.work / "netstat.capture"
        fixture.write_bytes(Path("/proc/net/netstat").read_bytes())
        observations = []
        for tree, label in [(pin, "netstat-pin"), (corrected, "netstat-corrected")]:
            executable = self.compile(tree, "netstat", label)
            _, values = self.probe(executable, fixture, AXIS_EPOCH)
            assert values["last_ok"] == "1" and len(values) > 2
            observations.append(values)
        assert observations[0] == observations[1]
        self.results["netstat_equal_values"] = len(observations[0]) - 2

    def databases(self, pin, corrected):
        msi = self.args.base.resolve() / "bin" / self.args.arch / "msi"
        legacy = []
        for tree, label in [(pin, "pin"), (corrected, "corrected")]:
            dbdir = tree / "statApp/Db"
            db = self.work / (label + "-nic.db")
            db.write_text(self.run([msi, "-S", "linStatNIC.substitutions"], cwd=dbdir).stdout)
            legacy.append(self.run([msi, "-V", "-M", "IOC=VERIFY,NIC=lo", db]).stdout)
            if label == "corrected":
                for macros in ["P=CUSTOM:NET,NIC=lo", "P=CUSTOM:NET,IOC=VERIFY,NIC=lo"]:
                    expanded = self.run([msi, "-V", "-M", macros, db]).stdout
                    names = re.findall(r'record\([^,]+,\s*"([^"]+)"', expanded)
                    assert len(names) == 48 and all(n.startswith("CUSTOM:NET:") for n in names)
                    assert "ifstat|lo|" in expanded
                netdb = self.work / "netStat.db"
                netdb.write_text(self.run([msi, "-S", "netStat.substitutions"], cwd=dbdir).stdout)
                hostdb = self.work / "host.db"
                hostdb.write_text(self.run([msi, "-I", dbdir, "-I", self.work,
                                            "-S", "linStatHost.substitutions"], cwd=dbdir).stdout)
                host = self.run([msi, "-V", "-M", "IOC=VERIFY", hostdb]).stdout
                names = set(re.findall(r'record\([^,]+,\s*"([^"]+)"', host))
                assert {"VERIFY:RTC:" + x for x in ["DLT", "REF", "BAT"]} <= names
        assert legacy[0] == legacy[1]
        self.results["nic_legacy_equal"] = True
        self.results["nic_custom_records"] = 48
        self.results["rtc_records"] = 3

    def configuration(self, pin, corrected):
        generic = []
        for tree in [pin, corrected]:
            install = tree.parent / "install"
            (install / "cfg").mkdir(parents=True)
            shutil.copyfile(tree / "configure/CONFIG_LINSTAT_VERSION", install / "cfg/CONFIG_LINSTAT_VERSION")
            (tree / "configure/RELEASE.local").write_text(f"EPICS_BASE={self.args.base.resolve()}\n")
            (tree / "configure/CONFIG_SITE.local").write_text(f"INSTALL_LOCATION={install}\n")
            probe = f"TOP={tree}\ninclude $(TOP)/configure/CONFIG\n$(info VERSION=$(LINSTAT_1_2_1))\n.PHONY: probe\nprobe:;@true\n"
            command = ["make", "--no-print-directory", "-f", "-", "probe", "EPICS_HOST_ARCH=" + self.args.arch]
            generic.append(self.run(command, cwd=tree, data=probe).stdout)
            self.run(["make", "--no-print-directory", "-f", ROOT / "configure/RULES_MODS_CONFIG", "conf.linStat",
                      "TOP=" + str(tree.parent), "SRC_PATH_MODULES=linStat-src",
                      "INSTALL_LOCATION_BASE=" + str(self.args.base.resolve()),
                      "INSTALL_LOCATION_LINSTAT=" + str(install)])
            actual = self.run(command, cwd=tree, data=probe).stdout
            assert "VERSION=YES" in actual
        assert "VERSION=\n" in generic[0] and "VERSION=YES" in generic[1]
        self.results["generic_config_fixed"] = True
        self.results["existing_recipe_resolves_both"] = True

    def execute(self):
        source = self.args.source.resolve()
        assert self.run(["git", "-C", source, "rev-parse", "HEAD"]).stdout.strip() == PIN
        assert not self.run(["git", "-C", source, "status", "--porcelain"]).stdout
        self.run(["git", "-C", source, "archive", "--format=tar", "--output=" + str(self.work / "pin.tar"), PIN])
        pin, upstream, corrected = [self.export(label) for label in ["pin", "upstream", "corrected"]]
        carries = sorted((ROOT / "patch").glob("1.2.1-[0-9][0-9]-*.p0.patch"))
        sites = sorted((ROOT / "patch").glob("1.2.1-site*.p0.patch"))
        assert len(carries) == 5 and len(sites) == 1
        for tree in [upstream, corrected]:
            for patch in carries:
                self.apply(tree, patch)
        for patch in sites:
            self.apply(corrected, patch)
        self.results["patch_sha256"] = {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in carries + sites}
        self.rtc(upstream, corrected)
        self.netstat(pin, corrected)
        self.databases(pin, corrected)
        self.configuration(pin, corrected)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", required=True, type=Path)
    parser.add_argument("--base", required=True, type=Path)
    parser.add_argument("--work-dir", required=True, type=Path, help="New directory; existing paths are refused")
    parser.add_argument("--arch", default="linux-x86_64")
    parser.add_argument("--cxx", default="g++")
    verification = Verification(parser.parse_args())
    try:
        verification.execute()
        verification.results["status"] = "PASS"
    except Exception as error:
        verification.results["status"] = "FAIL"
        verification.results["error"] = str(error)
        raise
    finally:
        report = verification.work / "report.json"
        report.write_text(json.dumps({"results": verification.results, "commands": verification.commands}, indent=2) + "\n")
        print(report)
    print("PASS: real-source RTC, netstat, MSI and CONFIG checks; full IOC acceptance remains pending.")


if __name__ == "__main__":
    main()
