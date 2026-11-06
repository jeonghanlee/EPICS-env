#!/usr/bin/env python3
"""Report tree differences, debug sections, and distribution test summaries."""

import argparse
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess
import sys


OBSERVATION_SCRIPTS = {
    "verify_minimal_example", "verify_readme_update_command", "observe_truncated_library"
}
CAPUTLOG_CASES = {
    "defaults", "all_puts", "unfiltered", "disabled", "invalid_option", "missing_host"
}
SUMMARY = r"SUMMARY ok=(\d+) fail=(\d+)"


def require(condition, message):
    if not condition:
        raise ValueError(message)


def result_lines(text, prefix, pattern, label):
    """Reject malformed result records instead of discarding unmatched lines."""
    rows = []
    for line in text.splitlines():
        if re.match(prefix, line):
            match = re.fullmatch(pattern, line)
            require(match is not None, "Malformed {}: {}".format(label, line))
            rows.append(match.groups())
    return rows


def load_manifest(path):
    entries = json.loads(path.read_text())
    require(isinstance(entries, list), "Manifest must be an array: " + str(path))
    result = {}
    for entry in entries:
        require(isinstance(entry, dict), "Manifest entry must be an object")
        name = entry.get("path")
        require(isinstance(name, str) and name and name != ".", "Invalid manifest path")
        relative = PurePosixPath(name)
        require(not relative.is_absolute() and ".." not in relative.parts
                and str(relative) == name, "Noncanonical manifest path: " + name)
        require(name not in result, "Duplicate manifest path: " + name)
        kind = entry.get("type")
        fields = {"path", "mode", "type"}
        if kind == "file":
            fields.update(("size", "sha256"))
            require(type(entry.get("size")) is int and entry["size"] >= 0,
                    "Invalid file size: " + name)
            require(isinstance(entry.get("sha256"), str)
                    and re.fullmatch(r"[0-9a-f]{64}", entry["sha256"]),
                    "Invalid SHA-256: " + name)
        elif kind == "symlink":
            fields.add("target")
            require(isinstance(entry.get("target"), str) and entry["target"],
                    "Invalid symlink target: " + name)
        else:
            require(kind == "directory", "Unsupported entry type: " + name)
        require(set(entry) == fields, "Unexpected manifest fields: " + name)
        require(isinstance(entry.get("mode"), str)
                and re.fullmatch(r"0o[0-7]{1,4}", entry["mode"]),
                "Invalid file mode: " + name)
        result[name] = entry
    return result


def differences(args):
    before, after = load_manifest(args.before), load_manifest(args.after)
    changed = []
    for name in sorted(before.keys() & after.keys()):
        fields = sorted(key for key in before[name].keys() | after[name].keys()
                        if before[name].get(key) != after[name].get(key))
        if fields:
            changed.append({"path": name, "fields": fields,
                            "before": before[name], "after": after[name]})
    report = {"added": sorted(after.keys() - before.keys()),
              "removed": sorted(before.keys() - after.keys()), "changed": changed}
    return report, int(any(report.values()))


def scan_error(error):
    raise error


def debug_sections(args):
    root = args.tree.resolve(strict=True)
    require(root.is_dir(), "Expected a tree directory")
    report = {"elf_files": 0, "archives": 0, "debug_sections": []}
    environment = dict(os.environ, LC_ALL="C")
    for directory, directories, files in os.walk(root, followlinks=False, onerror=scan_error):
        for name in sorted(directories + files):
            path = Path(directory) / name
            mode = path.lstat().st_mode
            if stat.S_ISLNK(mode) or stat.S_ISDIR(mode):
                continue
            require(stat.S_ISREG(mode), "Unsupported file type: " + str(path))
            with path.open("rb") as stream:
                magic = stream.read(8)
            require(magic != b"!<thin>\n", "Thin archive needs external members: " + str(path))
            if magic.startswith(b"\x7fELF"):
                report["elf_files"] += 1
            elif magic == b"!<arch>\n":
                report["archives"] += 1
            else:
                continue
            scan = subprocess.run(["readelf", "-SW", str(path)], env=environment,
                                  stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                  universal_newlines=True)
            require(scan.returncode == 0 and not scan.stderr.strip(),
                    "readelf failed for {}: {}".format(path, scan.stderr.strip()))
            sections = sorted(set(re.findall(
                r"^\s*\[\s*\d+\]\s+(\.(?:zdebug|debug)[^\s]*)\s", scan.stdout, re.MULTILINE)))
            if sections:
                report["debug_sections"].append({"path": path.relative_to(root).as_posix(),
                                                  "sections": sections})
    require(report["elf_files"] > 0, "No ELF files found")
    report["debug_sections"].sort(key=lambda entry: entry["path"])
    return report, 0


def runner_names(path, array):
    text = path.read_text()
    blocks = re.findall(r"^readonly (?:-a )?" + array + r"=\(\n(.*?)^\)",
                        text, re.MULTILINE | re.DOTALL)
    require(len(blocks) == 1, "Unsupported runner array: " + str(path))
    names = blocks[0].split()
    require(names and len(names) == len(set(names))
            and all(re.fullmatch(r"[a-z][a-z0-9_.]*", name) for name in names),
            "Invalid runner names: " + str(path))
    return names


def loader_results(source, run_log, logs):
    names = runner_names(source / "examples/iocsh/tests/run_all.bash", "ORDER")
    text = run_log.read_text()
    rows = result_lines(text, r"[ \t]*[\w.-]+[ \t]+exit\b",
                        r"(\w+) exit (\d+)(?:, SUMMARY ok=(\d+) fail=(\d+))?",
                        "loader result")
    require([row[0] for row in rows] == names, "Incomplete, duplicate, or unordered loader results")
    require(len(result_lines(text, r"[ \t]*run done\b", r"run done (.+)",
                             "loader completion")) == 1
            and text.rstrip().splitlines()[-1].startswith("run done "),
            "Missing loader completion marker")
    result = []
    for name, status, ok, fail in rows:
        summaries = result_lines((logs / (name + ".log")).read_text(),
                                 r"[ \t]*SUMMARY\b", SUMMARY, "loader summary")
        if name in OBSERVATION_SCRIPTS:
            require(not summaries and not ok, "Unexpected observation summary: " + name)
        else:
            require(len(summaries) == 1 and summaries[0] == (ok, fail)
                    and int(ok) + int(fail) > 0, "Missing or inconsistent summary: " + name)
        result.append({"script": name, "exit": int(status),
                       "ok": int(ok) if ok else None, "fail": int(fail) if fail else None})
    return {"scripts": result, "checks": sum(row["ok"] or 0 for row in result),
            "failed": any(row["exit"] or row["fail"] for row in result),
            "runtime_observations_require_review": sorted(OBSERVATION_SCRIPTS & set(names))}


def common_results(source, log):
    names = runner_names(source / "examples/commonIocsh/tests/run_all.sh", "SCRIPTS")
    text = log.read_text()
    starts = list(re.finditer(r"^==== ([\w.]+) ====$", text, re.MULTILINE))
    require([match[1] for match in starts] == names, "Incomplete or duplicate commonIocsh scripts")
    all_results = result_lines(text, r"[ \t]*RESULT\b", r"RESULT ([\w.]+): (PASS|FAIL)",
                               "commonIocsh result")
    require([row[0] for row in all_results] == names, "Incomplete commonIocsh results")
    overall = result_lines(text, r"[ \t]*OVERALL\b", r"OVERALL: (PASS|FAIL)",
                           "commonIocsh completion")
    require(len(overall) == 1 and text.rfind("OVERALL:") > starts[-1].start(),
            "Missing commonIocsh completion marker")
    rows = []
    for index, match in enumerate(starts):
        end = starts[index + 1].start() if index + 1 < len(starts) else len(text)
        block = text[match.end():end]
        counts = result_lines(block, r"[ \t]*PASS=", r"PASS=(\d+) FAIL=(\d+)",
                              "commonIocsh counts")
        result = re.findall(r"^RESULT ([\w.]+): (PASS|FAIL)$", block, re.MULTILINE)
        require(len(counts) == 1 and result == [all_results[index]],
                "Missing commonIocsh summary: " + match[1])
        ok, fail = map(int, counts[0])
        require(ok + fail > 0 and len(re.findall(r"^PASS: ", block, re.MULTILINE)) == ok
                and len(re.findall(r"^FAIL: ", block, re.MULTILINE)) == fail,
                "Inconsistent commonIocsh counts: " + match[1])
        rows.append({"script": match[1], "ok": ok, "fail": fail, "result": result[0][1]})
    return {"scripts": rows, "checks": sum(row["ok"] for row in rows),
            "failed": overall != [("PASS",)] or any(row["fail"] or row["result"] != "PASS" for row in rows)}


def test_results(args):
    loader = loader_results(args.loader_source or args.source, args.loader_run, args.loader_logs)
    installed = common_results(args.source, args.common_installed)
    isolated = common_results(args.source, args.common_isolated)
    summary = json.loads(args.caputlog.read_text())
    require(isinstance(summary, dict) and isinstance(summary.get("cases"), list),
            "Invalid caPutLog summary")
    cases = summary["cases"]
    require(all(isinstance(case, dict) and isinstance(case.get("case"), str) for case in cases),
            "Invalid caPutLog case")
    require(len(cases) == len(CAPUTLOG_CASES) and {case["case"] for case in cases} == CAPUTLOG_CASES,
            "Incomplete or duplicate caPutLog cases")
    require(all(case.get("result") in ("Pass", "Fail") for case in cases), "Invalid caPutLog result")
    failed = loader["failed"] or installed["failed"] or isolated["failed"] or any(
        case["result"] != "Pass" for case in cases)
    return {"loader": loader, "common_installed": installed, "common_isolated": isolated,
            "caputlog": cases, "reported_failure": failed,
            "scope": "Summary aggregation only; verify process exits, isolation, runtime observations and OS baseline separately."}, int(failed)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command")
    diff = commands.add_parser("diff", help="Classify complete manifest differences; no exemptions")
    diff.add_argument("before", type=Path)
    diff.add_argument("after", type=Path)
    diff.set_defaults(run=differences)
    debug = commands.add_parser("debug", help="List actual debug sections in ELF files and archives")
    debug.add_argument("tree", type=Path)
    debug.set_defaults(run=debug_sections)
    results = commands.add_parser("results", help="Aggregate existing loader/commonIocsh/caPutLog summaries")
    for option in ("source", "loader-run", "loader-logs", "common-installed", "common-isolated", "caputlog"):
        results.add_argument("--" + option, type=Path, required=True)
    results.add_argument("--loader-source", type=Path,
                         help="Checkout of the executed loader runner; defaults to --source")
    results.set_defaults(run=test_results)
    args = parser.parse_args()
    if args.command is None:
        parser.error("a command is required")
    try:
        report, status = args.run(args)
    except (OSError, ValueError) as error:
        print("distribution-report.py: " + str(error), file=sys.stderr)
        return 2
    json.dump(report, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return status


if __name__ == "__main__":
    sys.exit(main())
