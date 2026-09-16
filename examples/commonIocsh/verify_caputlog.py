#!/usr/bin/env python3
"""Verify the shipped caPutLog fragment using real EPICS processes."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import socket
import subprocess
import sys
import time
import uuid

DEFAULT_LOG_PORT = 7004
DEFAULT_TIMEOUT = 30.0
QUIET_WINDOW = 12.0
POLL_INTERVAL = 0.1


def read_text(path):
    return path.read_text(errors="replace") if path.exists() else ""


def wait_for(predicate, timeout, description, processes=()):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        for process in processes:
            if process.poll() is not None:
                raise RuntimeError(f"{description}: process exited with {process.returncode}")
        if predicate():
            return
        time.sleep(POLL_INTERVAL)
    raise RuntimeError(f"Timed out: {description}")


def free_port():
    with socket.socket() as probe:
        probe.bind(("127.0.0.1", 0))
        return probe.getsockname()[1]


def listening(port):
    try:
        with socket.create_connection(("127.0.0.1", port), timeout=0.2):
            return True
    except OSError:
        return False


def stop(process):
    if process is None or process.poll() is not None:
        return
    if process.stdin is not None:
        try:
            process.stdin.write("exit\n")
            process.stdin.flush()
            process.wait(timeout=5)
            return
        except (BrokenPipeError, subprocess.TimeoutExpired):
            pass
    process.terminate()
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        process.kill()
        process.wait()


def run_case(args, name, option, log_port, omit_host=False):
    case_dir = args.output / name
    case_dir.mkdir()
    prefix = f"M6_{uuid.uuid4().hex[:12]}:"
    pv = prefix + "Value"
    receiver_file = case_dir / "received.log"
    ioc_file = case_dir / "ioc.log"
    client_file = case_dir / "clients.log"
    env = {
        key: value for key, value in os.environ.items()
        if not key.startswith(("EPICS_CA_", "EPICS_CAS_", "EPICS_IOC_LOG_"))
    }
    env.update({
        "EXAMPLE_TOP": str(args.example),
        "IOCSH_TOP": str(args.iocsh_top),
        "TEST_PREFIX": prefix,
        "EPICS_CA_AUTO_ADDR_LIST": "NO",
        "EPICS_CA_ADDR_LIST": "127.0.0.1",
        "EPICS_CA_SERVER_PORT": str(free_port()),
        "EPICS_CAS_INTF_ADDR_LIST": "127.0.0.1",
        "EPICS_CAS_BEACON_ADDR_LIST": "127.0.0.1",
        "EPICS_CAS_AUTO_BEACON_ADDR_LIST": "NO",
        "EPICS_IOC_LOG_PORT": str(log_port),
        "EPICS_IOC_LOG_FILE_NAME": str(receiver_file),
        "EPICS_IOC_LOG_FILE_LIMIT": "1000000",
    })
    macros = [] if omit_host else ["LOG_INET=127.0.0.1"]
    if option is not None:
        macros += [f"LOG_INET_PORT={log_port}", f"OPTION={option}"]
    env["CAPUTLOG_MACROS"] = ",".join(macros)
    # These names must resolve from the iocshLoad argument, not inherited state.
    for key in ("LOG_INET", "LOG_INET_PORT", "OPTION", "EPICS_CA_PUT_LOG_ADDR"):
        env.pop(key, None)
    (case_dir / "inputs.json").write_text(json.dumps({
        "prefix": prefix, "macros": env["CAPUTLOG_MACROS"],
        "log_port": log_port, "ca_port": env["EPICS_CA_SERVER_PORT"],
    }, indent=2) + "\n")
    server = ioc = None

    def put(value):
        result = subprocess.run(
            [str(args.base_bin / "caput"), "-w", "3", pv, str(value)],
            env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            timeout=5,
        )
        with client_file.open("a") as output:
            output.write(result.stdout)
        if result.returncode != 0:
            raise RuntimeError(f"caput failed for {pv}: {result.stdout.strip()}")

    def messages():
        return [line for line in read_text(receiver_file).splitlines() if pv in line]

    try:
        with (case_dir / "server.log").open("w") as server_output, ioc_file.open("w") as ioc_output:
            # Refuse to use a receiver belonging to another process.
            with socket.socket() as probe:
                probe.bind(("127.0.0.1", log_port))
            server = subprocess.Popen(
                [str(args.base_bin / "iocLogServer")], env=env,
                stdout=server_output, stderr=subprocess.STDOUT,
            )
            wait_for(lambda: listening(log_port), args.timeout, "log server ready", (server,))
            ioc = subprocess.Popen(
                ["stdbuf", "-oL", "-eL", str(args.ioc), str(args.example / "iocBoot/caPutLog.cmd")],
                cwd=case_dir, env=env, stdin=subprocess.PIPE,
                stdout=ioc_output, stderr=subprocess.STDOUT, text=True,
            )
            wait_for(lambda: "iocRun: All initialization complete" in read_text(ioc_file),
                     args.timeout, "IOC initialized", (server, ioc))
            active = option not in (-1, 9) and not omit_host
            if active:
                wait_for(lambda: "caPutLog: successfully initialized" in read_text(ioc_file),
                         args.timeout, "caPutLog initialized", (server, ioc))
                output = read_text(ioc_file)
                if output.index("iocRun: All initialization complete") > output.index("caPutLogInit config:"):
                    raise RuntimeError("Logger initialized before IOC initialization completed")
            else:
                expected = "Disabled" if option == -1 else "Unknown (must be -1, 0, 1, or 2)"
                if omit_host:
                    expected = "macLib: macro LOG_INET is "
                wait_for(lambda: expected in read_text(ioc_file),
                         args.timeout, "expected startup diagnostic", (server, ioc))
                if "caPutLog: successfully initialized" in read_text(ioc_file):
                    raise RuntimeError("Unexpected successful initialization")

            put(17)
            if active:
                wait_for(lambda: any("new=17" in line and "old=0" in line for line in messages()),
                         args.timeout, "first real put received", (server, ioc))
                baseline = len(messages())
                put(17)
                if option in (1, 2):
                    wait_for(lambda: len(messages()) > baseline,
                             args.timeout, "unchanged put received", (server, ioc))
                else:
                    deadline = time.monotonic() + QUIET_WINDOW
                    while time.monotonic() < deadline:
                        if ioc.poll() is not None or server.poll() is not None:
                            raise RuntimeError("Process exited during unchanged-value check")
                        if len(messages()) != baseline:
                            raise RuntimeError("Default mode logged an unchanged put")
                        time.sleep(POLL_INTERVAL)
                put(29)
                wait_for(lambda: any("new=29" in line and "old=17" in line for line in messages()),
                         args.timeout, "second value change received", (server, ioc))
            else:
                deadline = time.monotonic() + QUIET_WINDOW
                while time.monotonic() < deadline:
                    if ioc.poll() is not None or server.poll() is not None:
                        raise RuntimeError("Process exited during negative check")
                    if messages():
                        raise RuntimeError("Unexpected put log for disabled/invalid startup")
                    time.sleep(POLL_INTERVAL)
            return {"case": name, "result": "Pass", "received": len(messages())}
    finally:
        stop(ioc)
        stop(server)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", type=Path, required=True)
    parser.add_argument("--arch", default="linux-x86_64")
    parser.add_argument("--iocsh-top", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--timeout", type=float, default=DEFAULT_TIMEOUT)
    args = parser.parse_args()
    args.example = Path(__file__).resolve().parent
    args.base = args.base.resolve()
    args.base_bin = args.base / "bin" / args.arch
    args.ioc = args.example / "bin" / args.arch / "commonIocshExample"
    args.iocsh_top = (args.iocsh_top or args.example.parents[1] / "commonIocsh/iocsh").resolve()
    args.output = args.output.resolve()
    for path in (args.ioc, args.base_bin / "caput", args.base_bin / "iocLogServer",
                 args.iocsh_top / "caPutLog.iocsh"):
        if not path.is_file():
            parser.error(f"Required file not found: {path}")
    if not shutil.which("stdbuf"):
        parser.error("stdbuf is required for observable IOC output")
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    args.output.mkdir(parents=True, exist_ok=False)
    results = []
    cases = [
        ("defaults", None, DEFAULT_LOG_PORT, False),
        ("all_puts", 1, free_port(), False),
        ("unfiltered", 2, free_port(), False),
        ("disabled", -1, free_port(), False),
        ("invalid_option", 9, free_port(), False),
        ("missing_host", None, DEFAULT_LOG_PORT, True),
    ]
    for name, option, port, omit_host in cases:
        try:
            result = run_case(args, name, option, port, omit_host)
        except Exception as error:
            result = {"case": name, "result": "Fail", "error": str(error)}
        results.append(result)
        print(f"[ {result['result'].upper()} ] {name}: {result.get('error', 'observed expected behavior')}",
              flush=True)
        report = {
            "base": str(args.base), "ioc": str(args.ioc),
            "fragment": str(args.iocsh_top / "caPutLog.iocsh"),
            "fragment_sha256": hashlib.sha256(
                (args.iocsh_top / "caPutLog.iocsh").read_bytes()).hexdigest(),
            "cases": results,
        }
        (args.output / "summary.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Evidence: {args.output}", flush=True)
    return int(any(result["result"] != "Pass" for result in results))


if __name__ == "__main__":
    sys.exit(main())
