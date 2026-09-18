# commonIocsh Fragment Verification Procedure

## Scope

This document records the reproducible verification procedure and expected
results for each `commonIocsh` service fragment, using `tc32sim` as the test
IOC on an installed EPICS-env distribution. The runnable form of every check
lives in `examples/commonIocsh/tests/` (see its README).

**Out of scope:** physical serial baud/parity correctness (Pending, requires a
physical serial endpoint); the ALS site-owned `ioc_stats.db` iocStats fragment;
recceiver/log-server end-to-end reception where a dedicated external service is
required; and the community module implementations themselves.

## Prerequisites

- An EPICS-env distribution tree for the target OS, providing `base` and the
  service modules under `.../<os>/<base-ver>/modules` (verification was run
  against `EPICS-env-distribution/1.3.0/debian-13/7.0.10`).
- The `tc32sim` test IOC, with `configure/RELEASE.local` pointing `EPICS_BASE`
  at the distribution and enabling the per-service module macros.
- The `commonIocsh` fragments, reached through `IOCSH_TOP`. Interim: the
  EPICS-env working tree `commonIocsh` directory; installed: the
  `modules/commonIocsh/iocsh` tree (D15).
- Host tools: `socat`, `nc`, and the EPICS Base `iocLogServer`.

## Common Setup

Enable the modules a given fragment needs in `configure/RELEASE.local` (kept
out of version control), then rebuild:

```bash
# configure/RELEASE.local (example)
EPICS_BASE = /path/to/EPICS-env-distribution/1.3.0/debian-13/7.0.10/base
LINSTAT     = $(MODULES)/linStat
RECCASTER   = $(MODULES)/recsync
AUTOSAVE    = $(MODULES)/autosave
devIocStats = $(MODULES)/iocStats
```

A RELEASE change requires a clean rebuild so the generated `dbd` picks up the
new module:

```bash
make -C /path/to/tc32sim clean
make -C /path/to/tc32sim
```

Each test startup sets `IOCSH_TOP` to the commonIocsh location and `IOC` to the
record-name prefix, loads the fragment with `iocshLoad`, then runs `iocInit`.
Fragments load before `iocInit`.

## Per-Service Verification

### linStat (Host, Proc, NIC, FS)

**Run:** `bash examples/commonIocsh/tests/verify_linstat.sh`

Load the aggregate `linStat.iocsh` (host and process by default; NIC and FS via
their toggles) or the individual fragments, then list the records:

```bash
# in the IOC startup, before iocInit:
# iocshLoad("$(IOCSH_TOP)/iocsh/linStat.iocsh","IOC=$(IOC),NICENABLE=,NIC=lo,FSENABLE=,FSID=ROOT,DIR=/")
# after iocInit:
# dbl > records.out
```

Expected: `$(IOC):SYS_*` and `$(IOC):NET:HOST:*` (host), `$(IOC):IOC_*` (proc),
`$(IOC):NET:<nic>:*` (per enabled NIC), and `$(IOC):<FSID>:*` (per enabled
filesystem). The FS records confirm the IOC-based prefix wraps the module `P`
macro (`P=$(IOC):$(FSID)`).

### reccaster

**Run:** `bash examples/commonIocsh/tests/verify_reccaster.sh`

Load `reccaster.iocsh` and confirm the status records are created:

```bash
# iocshLoad("$(IOCSH_TOP)/iocsh/reccaster.iocsh","IOC=$(IOC)")
# after iocInit: dbl | grep -E ':State-Sts|:Msg-I'
```

Expected: `$(IOC):State-Sts` and `$(IOC):Msg-I`, with `reccastTimeout`/
`reccastMaxHoldoff` set to the fragment defaults (20.0 / 10.0). Full delivery
to a recceiver requires a dedicated recceiver service (out of scope here).

### caPutLog

**Run:** `bash examples/commonIocsh/tests/verify_caputlog.sh`

Load `caPutLog.iocsh` with `LOG_INET` (and optional `LOG_INET_PORT`, `OPTION`).
The fragment registers `caPutLogInit` through `afterIocRunning`. Verification
drives CA puts to a test PV through the example IOC and confirms the log server
records the value changes.

The script starts an iocLogServer and the prebuilt example IOC on an isolated CA
port (`caputlog-ioc.sh`, stdin held open so the IOC stays up), then issues
`caput` 17, 17 again, and 29 on `$(TEST_PREFIX)Value` (a TRAPWRITE record under
`test.acf`).

Expected: `new=17 old=0` and `new=29 old=17` in the server file; the repeated 17
adds no line (OPTION 0). caPutLog squashes bursts and flushes after roughly 10 s,
and iocLogServer writes its file on `SIGHUP`, so the script waits in real time
and flushes before checking. `verify_caputlog.py` remains the wider Python
verifier for the other OPTION cases.

### autosave

**Run:** `bash examples/commonIocsh/tests/verify_autosave.sh`

Enable `AUTOSAVE`, load `autosave.iocsh` with `IOC` and a writable `AS_TOP`.
Verify restart retention by save, restart, restore, and a full sav comparison:

1. Start the IOC, change several target fields with `dbpf`, then `manual_save`
   the group (`values_pass1.req` for pass1 values, `settings.req` for the
   settings fields). This writes `AS_TOP/$(IOC)/save/<group>.sav`.
2. Start a fresh IOC whose save directory holds the baseline `.sav`; pass0/pass1
   restore reloads it. Re-save the restored state with `manual_save`.
3. Compare the value lines of the baseline and the re-saved file:

```bash
# baseline: AS_TOP/$(IOC)/save/<group>.sav written in step 1
# resaved:  the same <group>.sav re-written by the fresh IOC in step 2,
#           under a separate AS_TOP so the baseline stays intact
grep -vE '^#|^!|^<' "$BASELINE" | sort > b.txt
grep -vE '^#|^!|^<' "$RESAVED"  | sort > r.txt
diff b.txt r.txt
```

Expected: identical value lines. Verified groups: `values_pass1` (record `VAL`)
and `settings` (`PREC LOPR HOPR SCAN HIGH HIHI LOW LOLO HSV HHSV LSV LLSV`). The
restore log reports `<group>.sav: N of N PV's connected`.

### iocLog

**Run:** `bash examples/commonIocsh/tests/verify_ioclog.sh`

Load `iocLog.iocsh` with `LOG_INET` (and optional `LOG_INET_PORT`). The
fragment calls `iocLogInit()` directly (before `iocInit`), not through
`afterIocRunning`, so the errlog listener is registered before boot messages.

```bash
# start a receiver first (the runnable script picks a free port instead of 7004):
EPICS_IOC_LOG_FILE_NAME=/path/ioclog.txt EPICS_IOC_LOG_PORT=7004 iocLogServer &
# run the IOC with LOG_INET=127.0.0.1, LOG_INET_PORT=7004
```

Expected: the IOC connects (`log client: connected to log server ...`) and the
boot errlog (`Starting iocInit`, `iocRun: All initialization complete`) appears
in the server file with the `proc=$(IOC)` prefix. A `nc -l <port>` listener can
confirm the raw client bytes.

### iocStatsAdmin

**Run:** `bash examples/commonIocsh/tests/verify_iocstatsadmin.sh`

Enable `devIocStats`, load `iocStatsAdmin.iocsh` with `IOC`, and list records:

```bash
# iocshLoad("$(IOCSH_TOP)/iocsh/iocStatsAdmin.iocsh","IOC=$(IOC)")
# after iocInit: dbl | grep -E ':ACCESS|:HEARTBEAT|:UPTIME'
```

Expected: `iocAdminSoft.db` records under `$(IOC):` (`ACCESS`, `HEARTBEAT`,
`STARTTOD`, `TOD`, `UPTIME`, `SUSP_TASK_CNT`, ...).

### serial (serial.iocsh + setSerialParams.iocsh)

**Run:** `bash examples/commonIocsh/tests/verify_serial.sh`

Create a virtual serial port with `socat`, attach an asyn serial port to it,
and load the serial entry fragment. The IOC-owned config file calls
`setSerialParams.iocsh` once per port:

```bash
socat pty,raw,echo=0,link=/tmp/ttyA pty,raw,echo=0,link=/tmp/ttyB &
# in the IOC startup:
# drvAsynSerialPortConfigure("S1","/tmp/ttyA",0,0,0)
# iocshLoad("$(IOCSH_TOP)/iocsh/serial.iocsh","SERIAL_ENABLE=,SERIAL_CONFIG=/path/serial-config.iocsh")
# serial-config.iocsh:
#   iocshLoad("$(IOCSH_TOP)/iocsh/setSerialParams.iocsh","PORT=S1,BAUD=19200,BITS=7,STOP=2,PARITY=odd")
```

Expected software-path results:

- Applied: `asynSetOption` runs for `baud`, `bits`, `stop`, `parity` with no
  error (an invalid parameter is rejected by asyn, so no error means applied).
- Omit: with `SERIAL_ENABLE` unset the entry line is commented out; the IOC
  boots with no serial setup.
- Unreadable: a `SERIAL_CONFIG` path that does not exist makes `iocshLoad` fail
  with `Can't open ...: No such file or directory`.
- Multiple ports: each port in the config file gets its own independent
  `asynSetOption` set, with no cross-talk.

Pending: physical baud/parity correctness requires a physical serial endpoint;
a `socat` PTY establishes the software path only.

## Installed-Path Verification (Target-OS Distribution)

This verifies the fragments as installed (D15), loaded through `IOCSH_TOP` from
`modules/commonIocsh/iocsh`, against a built EPICS-env distribution on a target
OS. The fragments under test are the installed ones, not the working-tree copies
the per-service procedure above sources; the test scripts and the example IOC
source still come from an EPICS-env source tree (the build's own source tree
suffices).

Environment: a provisioned target-OS host carrying an EPICS-env distribution
built from the release branch and installed at
`<install-root>/<env-version>/<os>/<base-version>/` (for example
`/opt/epics/1.4.0/debian-13/7.0.10`), holding `base` and `modules` including the
installed `commonIocsh`.

The verification scripts take the installed locations through their environment
contract (`examples/commonIocsh/tests/common.sh`):

| Variable | Installed-path value |
| --- | --- |
| `DIST_TOP` | the distribution root, `<install-root>/<env-version>/<os>/<base-version>` |
| `COMMONIOCSH` | `${DIST_TOP}/modules/commonIocsh` (installed fragments; sets `IOCSH_TOP`) |
| `TC32SIM` | a `tc32sim` checkout (the test IOC) |
| `ARCH` | target architecture, e.g. `linux-x86_64` |

For caPutLog, build the example IOC against the distribution. Write
`examples/commonIocsh/configure/RELEASE.local` with the distribution's absolute
paths for `EPICS_BASE` and `CAPUTLOG`, then build with `CHECK_RELEASE=NO`, since
the application builds against an installed tree rather than a co-built one. Use
the distribution's real paths here, not `$(DIST_TOP)`, which does not resolve in
a Make file:

```
# examples/commonIocsh/configure/RELEASE.local
EPICS_BASE = /opt/epics/1.4.0/debian-13/7.0.10/base
CAPUTLOG   = /opt/epics/1.4.0/debian-13/7.0.10/modules/caPutLog
```

```bash
make CHECK_RELEASE=NO -C examples/commonIocsh
```

Run the full suite against the installed distribution:

```bash
DIST_TOP=<dist> COMMONIOCSH=<dist>/modules/commonIocsh TC32SIM=<tc32sim> ARCH=linux-x86_64 bash examples/commonIocsh/tests/run_all.sh
```

Expected: `OVERALL: PASS`, each of the seven services passing as specified in
the per-service sections, confirming the installed fragments load through
`IOCSH_TOP`. Run on each M6 target OS (Debian 13 and Rocky Linux 8.10, D21),
substituting the target `<os>` in the distribution paths above (for example
`rocky-8.10`).

## Notes

- `IOCSH_TOP` points at the interim working-tree `commonIocsh` during
  development and at the installed `modules/commonIocsh/iocsh` once the module
  is released (D15).
- The procedure above was run on Debian 13. Rocky Linux 8.10 uses the same
  steps against its own distribution tree (D21).
