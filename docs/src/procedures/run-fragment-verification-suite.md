# Run the fragment verification suite

Check the common iocsh fragments of an installed tree against running
Experimental Physics and Industrial Control System (EPICS) input/output
controllers (IOCs). The suite has two parts in `examples/commonIocsh`:
`verify_caputlog.py` checks `caPutLog.iocsh` through the example IOC, and
the scripts in `tests/` check every fragment through an external test IOC
named tc32sim.
[Common iocsh fragments](../concepts/common-iocsh-fragments.md) explains
what each fragment does.

## Prerequisites

- An installed tree built with `make install`; see
  [Build and install the environment](build-and-install.md).
- An EPICS-env clone, which holds the example IOC in `examples/commonIocsh`.
- Python 3 and `stdbuf` on `PATH`.
- Transmission Control Protocol (TCP) port 7004 free on the local host.
  `verify_caputlog.py` fails a case that finds another process on that port.
- For the optional `tests/` scripts in step 5: a checkout of
  <https://github.com/jeonghanlee/tc32sim>, `socat`, `ss`, and free TCP ports
  7011 and 7013.

1. In `<example_dir>/configure/RELEASE.local`, set the installed EPICS base
   and caPutLog module:

   ```makefile
   EPICS_BASE = <installed_tree>/base
   CAPUTLOG = <installed_tree>/modules/caPutLog
   ```

   - `<example_dir>` is the `examples/commonIocsh` directory of the
     EPICS-env clone.
   - `<installed_tree>` is the path that `make print-INSTALL_LOCATION_EPICS`
     prints in the EPICS-env clone that built the tree.

2. Build the example IOC:

   ```bash
   make -C <example_dir> CHECK_RELEASE=NO
   ```

   The installed caPutLog module keeps the `configure/RELEASE` file of its
   upstream source, which names a different `EPICS_BASE`. With the release
   check on, the build stops at `Definition of EPICS_BASE conflicts with
   CAPUTLOG support`. The build writes
   `<example_dir>/bin/linux-x86_64/commonIocshExample`.

3. Change to the installed tree, so that the script arguments stay short:

   ```bash
   cd <installed_tree>
   ```

4. Run the caPutLog checks against the installed fragment:

   ```bash
   python3 <example_dir>/verify_caputlog.py --base base --iocsh-top modules/commonIocsh/iocsh --output <evidence_dir>
   ```

   - `--base` names the EPICS base directory that provides `caput` and
     `iocLogServer`.
   - `--iocsh-top` names the directory that holds `caPutLog.iocsh`. The
     example IOC takes the `iocsh` directory itself, and the default is
     `commonIocsh/iocsh` of the clone that holds the script.
   - `<evidence_dir>` is the absolute path of a directory that does not
     exist; the script creates it and refuses an existing one.

   Two more options have defaults: `--arch` sets the architecture directory
   of the IOC and base binaries, `linux-x86_64`, and `--timeout` sets the
   seconds to wait for each expected event, `30`.

   The script prints one line per case and the evidence directory:

   ```
   [ PASS ] defaults: observed expected behavior
   [ PASS ] all_puts: observed expected behavior
   [ PASS ] unfiltered: observed expected behavior
   [ PASS ] disabled: observed expected behavior
   [ PASS ] invalid_option: observed expected behavior
   [ PASS ] missing_host: observed expected behavior
   Evidence: <evidence_dir>
   ```

   For each case, the script starts `iocLogServer` from EPICS base and the
   example IOC, which loads `caPutLog.iocsh` from `--iocsh-top`. It then
   writes the test record with `caput` from EPICS base and reads what the
   log server received. It removes every inherited `EPICS_CA_*`,
   `EPICS_CAS_*`, and `EPICS_IOC_LOG_*` variable and gives each case its own
   Channel Access (CA) port on `127.0.0.1`. The cases are:

   | Case | Macros passed to `caPutLog.iocsh` | Expected behavior |
   | --- | --- | --- |
   | `defaults` | `LOG_INET=127.0.0.1` | Port 7004, option 0: puts of 17, 17, and 29 give `new=17 old=0` and `new=29 old=17`, and the repeated 17 adds no line |
   | `all_puts` | `LOG_INET`, a free `LOG_INET_PORT`, `OPTION=1` | The repeated 17 adds a line |
   | `unfiltered` | `LOG_INET`, a free `LOG_INET_PORT`, `OPTION=2` | The repeated 17 adds a line |
   | `disabled` | `LOG_INET`, a free `LOG_INET_PORT`, `OPTION=-1` | The IOC prints `caPutLogInit config: Disabled`, and the log server receives no line |
   | `invalid_option` | `LOG_INET`, a free `LOG_INET_PORT`, `OPTION=9` | The IOC prints `caPutLogInit config: Unknown (must be -1, 0, 1, or 2)`, and the log server receives no line |
   | `missing_host` | none | The IOC prints `macLib: macro LOG_INET is undefined`, and the log server receives no line |

   In the cases that log, the script also checks that `caPutLogInit` runs
   after `iocRun: All initialization complete`. A case that waits for a result
   fails after 30 seconds; a case that expects no line watches for 12
   seconds.

   The evidence directory holds `summary.json` and one directory per case.
   `summary.json` names the base, the IOC binary, the fragment path, the
   Secure Hash Algorithm 256-bit (SHA-256) digest of the fragment, and each
   case result. Each case directory holds `inputs.json`, `ioc.log`,
   `server.log`, `received.log`, and `clients.log`. The script exits with 0
   when every case passes and 1 when a case fails.

5. Optional: to check every fragment through the tc32sim test IOC, run
   `run_all.sh` from the top of the EPICS-env clone whose example IOC steps
   1 and 2 built:

   ```bash
   export DIST_TOP=<installed_tree> TC32SIM=<tc32sim_dir>
   export COMMONIOCSH=<installed_tree>/modules/commonIocsh
   bash examples/commonIocsh/tests/run_all.sh
   ```

   - `DIST_TOP` names the installed tree that provides `base`, the modules,
     `iocLogServer`, and `caput`.
   - `<tc32sim_dir>` is the tc32sim checkout.
   - `COMMONIOCSH` names the `commonIocsh` directory that holds the `iocsh`
     directory of the fragments. The scripts set `IOCSH_TOP` to it and load
     `$(IOCSH_TOP)/iocsh/<fragment>.iocsh`. Only `verify_caputlog.sh` passes
     the `iocsh` subdirectory, the form of the example IOC.

   The defaults of these three variables are paths on the developer's host,
   so set all three. The scripts read them, and these optional variables,
   through `tests/common.sh`:

   | Variable | Default | Meaning |
   | --- | --- | --- |
   | `ARCH` | `linux-x86_64` | Architecture directory of the binaries |
   | `SKIP_REBUILD` | `0` | `1` leaves `configure/RELEASE.local` of tc32sim unchanged and uses its built binary |
   | `KEEP_WORKSPACE` | `0` | `1` keeps the temporary directory of `verify_caputlog.sh` and `verify_integrated.sh` |

   The scripts use the tc32sim checkout as follows:

   - They run `<tc32sim_dir>/bin/<ARCH>/tc32sim` from
     `<tc32sim_dir>/iocBoot/ioctestlab-tc32sim`, whose `envPaths` sets `IOC`
     to `ioctestlab-tc32sim`.
   - Unless `SKIP_REBUILD=1`, each script except `verify_caputlog.sh`
     overwrites `<tc32sim_dir>/configure/RELEASE.local` with `EPICS_BASE` and
     the module macros it needs, then runs `make clean` and `make` in the
     checkout.
   - The tc32sim IOC must include `system.dbd` and asyn serial support, and
     `verify_autosave.sh` and `verify_integrated.sh` load its
     `iocsh/tc32sim.iocsh` device setup.
   - `verify_caputlog.sh` uses the example IOC of steps 1 and 2 instead of
     tc32sim.

   `run_all.sh` runs eight scripts in turn. Each script prints its `PASS:`
   and `FAIL:` lines and a `PASS=<n> FAIL=<m>` line, and `run_all.sh` prints
   a `RESULT` line after each script and an `OVERALL` line at the end:

   ```
   ==== verify_linstat.sh ====
   linStat: enabling module and rebuilding
   PASS: linStat host records present (ioctestlab-tc32sim:SYS_*)
   PASS: linStat host-net records present (ioctestlab-tc32sim:NET:HOST*)
   PASS: linStat proc records present (ioctestlab-tc32sim:IOC_*)
   PASS: linStat nic records present (ioctestlab-tc32sim:NET:lo*)
   PASS: linStat fs records present (ioctestlab-tc32sim:ROOT:*)
   --------------------
   PASS=5 FAIL=0
   RESULT verify_linstat.sh: PASS

   ==== verify_reccaster.sh ====
   reccaster: enabling module and rebuilding
   PASS: reccaster record present (ioctestlab-tc32sim:State-Sts)
   PASS: reccaster record present (ioctestlab-tc32sim:Msg-I)
   --------------------
   PASS=2 FAIL=0
   RESULT verify_reccaster.sh: PASS

   ==== verify_iocstatsadmin.sh ====
   iocStatsAdmin: enabling devIocStats and rebuilding
   PASS: iocStatsAdmin record present (ioctestlab-tc32sim:ACCESS)
   PASS: iocStatsAdmin record present (ioctestlab-tc32sim:HEARTBEAT)
   PASS: iocStatsAdmin record present (ioctestlab-tc32sim:STARTTOD)
   PASS: iocStatsAdmin record present (ioctestlab-tc32sim:UPTIME)
   --------------------
   PASS=4 FAIL=0
   RESULT verify_iocstatsadmin.sh: PASS

   ==== verify_autosave.sh ====
   autosave: enabling module and rebuilding
   PASS: autosave pass1 retained across restart (all lines identical)
   PASS: autosave settings retained across restart (all lines identical)
   --------------------
   PASS=2 FAIL=0
   RESULT verify_autosave.sh: PASS

   ==== verify_ioclog.sh ====
   iocLog: rebuilding (Base feature, no module macro)
   PASS: iocLog boot errlog received at server (proc=ioctestlab-tc32sim)
   --------------------
   PASS=1 FAIL=0
   RESULT verify_ioclog.sh: PASS

   ==== verify_serial.sh ====
   serial: rebuilding and starting virtual PTYs
   PASS: serial params applied via config (baud 19200 on S1)
   PASS: serial skipped when SERIAL_ENABLE unset
   PASS: serial unreadable config reports error
   PASS: serial multiple ports get independent settings (S1 19200, S2 115200)
   --------------------
   PASS=4 FAIL=0
   RESULT verify_serial.sh: PASS

   ==== verify_caputlog.sh ====
   caPutLog: orchestrating example IOC on isolated CA port
   PASS: caPutLog logged value change 0 -> 17 (new=17 old=0)
   PASS: caPutLog logged value change 17 -> 29 (new=29 old=17)
   PASS: caPutLog OPTION 0 suppressed the unchanged put (only the 29 change logged)
   --------------------
   PASS=3 FAIL=0
   RESULT verify_caputlog.sh: PASS

   ==== verify_integrated.sh ====
   integrated: enabling all service modules and rebuilding
   Case A: aggregate boot of all services
   PASS: aggregate linStat host records present (:SYS_*)
   PASS: aggregate linStat proc records present (:IOC_*)
   PASS: aggregate linStat nic records present (:NET:lo*)
   PASS: aggregate linStat fs records present (:ROOT:*)
   PASS: aggregate reccaster records present (:State-Sts*)
   PASS: aggregate iocInit completed with all services loaded
   PASS: aggregate record names fully resolved (no macro cross-talk)
   PASS: aggregate loaded with no duplicate record collisions across services
   PASS: iocLog boot errlog reached server alongside other services
   PASS: caPutLog initialized in aggregate (coexists with autosave afterIocRunning)
   PASS: autosave afterIocRunning fired in aggregate (values_pass1.sav written)
   Case B: restart with autosave restore
   PASS: restart restored autosave values_pass1 set and reloaded all services
   Case C: minimal boot with optional services omitted
   PASS: minimal boot completed with optional NIC/FS/serial omitted
   --------------------
   PASS=13 FAIL=0
   RESULT verify_integrated.sh: PASS

   --------------------
   OVERALL: PASS
   ```

   `verify_integrated.sh` loads iocLog, serial, caPutLog, autosave,
   reccaster, and linStat in one IOC on port 7013 and leaves out
   iocStatsAdmin. `run_all.sh` exits with 0 only when every script passes.

## Verification

- Count the passing cases in the summary file of step 4:

  ```bash
  grep -c '"result": "Pass"' <evidence_dir>/summary.json
  ```

  All six cases pass:

  ```
  6
  ```
