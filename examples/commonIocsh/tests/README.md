# commonIocsh Verification Scripts

Bash scripts that verify each `commonIocsh` fragment against the `tc32sim` test
IOC (and the caPutLog example IOC) on an installed EPICS-env distribution. The
method behind each check is described in
`docs/procedures/commonIocsh-verification-procedure.md`; this directory holds
the runnable form.

## Scope

This directory covers the per-service verification scripts and their shared
helpers.

**Out of scope:** physical serial baud/parity correctness (Pending, needs a
physical endpoint), the ALS site-owned `ioc_stats.db`, and recceiver delivery.

## Layout

| File | Purpose |
| --- | --- |
| `common.sh` | Shared config (paths, arch), `write_release_local`, `rebuild_ioc`, `run_ioc`, `wait_seconds`, PASS/FAIL tally |
| `run_all.sh` | Runs every `verify_*.sh` in order and prints an overall result |
| `verify_linstat.sh` | linStat host/proc default plus one NIC and one FS via `linStat.iocsh`; checks records |
| `verify_reccaster.sh` | reccaster `State-Sts` / `Msg-I` records |
| `verify_iocstatsadmin.sh` | community devIocStats `iocAdminSoft.db` records |
| `verify_autosave.sh` | save, restart a fresh IOC, restore, re-save; pass1 and settings value lines identical |
| `verify_ioclog.sh` | boot errlog reaches iocLogServer (`iocLogInit` before `iocInit`) |
| `verify_serial.sh` | socat PTY: params applied, omit skips, unreadable config errors, multiple ports independent |
| `verify_caputlog.sh` | caPutLog OPTION 0 via the example IOC on an isolated CA port |
| `caputlog-ioc.sh` | launches the example IOC for `verify_caputlog.sh` (env-driven, exec'd) |

## Prerequisites

- An EPICS-env distribution tree (`base` + `modules`), default
  `EPICS-env-distribution/1.3.0/debian-13/7.0.10`.
- The `tc32sim` IOC checkout; the scripts write its `configure/RELEASE.local`
  and rebuild it per service.
- For caPutLog: the example IOC under `examples/commonIocsh` already built
  (`make -C examples/commonIocsh`).
- Host tools: `socat`, `ss`, `python3`, and `shellcheck` for the gate.

## Usage

Run from the EPICS-env repository root. Override the defaults through the
environment when needed:

```bash
DIST_TOP=/path/to/dist/1.3.0/rocky-8.10/7.0.10 TC32SIM=/path/to/tc32sim \
  bash examples/commonIocsh/tests/run_all.sh
```

Run a single service:

```bash
bash examples/commonIocsh/tests/verify_autosave.sh
```

Each script prints `PASS:`/`FAIL:` lines and a final `PASS=n FAIL=m`; the exit
code is non-zero on any failure. `KEEP_WORKSPACE=1` keeps a script's temporary
workspace for inspection (caPutLog).

## Notes

- Waits are real time through `wait_seconds` (`timeout N tail -f /dev/null`),
  not spin loops; caPutLog squashes bursts and flushes after roughly 10 s, and
  iocLogServer writes its file on `SIGHUP`.
- Scripts that drive the IOC from outside (caPutLog) keep the IOC's stdin open so
  it stays alive; the others run their checks inside the startup and let the IOC
  exit.
- `verify_caputlog.py` is the original Python verifier for caPutLog with
  additional OPTION cases; `verify_caputlog.sh` is the bash equivalent for the
  default case.
