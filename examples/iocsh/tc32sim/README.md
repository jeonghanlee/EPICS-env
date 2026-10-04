# tc32sim Loader Fixture

Runs the tc32sim application through the installed `iocsh.bash` and the
native `softIocPVX`. No IOC executable, application DBD, or registrar is
compiled.

## Source

| Item | Value |
| --- | --- |
| Application | <https://github.com/jeonghanlee/tc32sim> |
| Revision | `61645aeb78f9e7239a20397c918e2e74508cb9da` |
| Original startup | `iocBoot/ioctestlab-tc32sim/st-linstat.cmd` |

## Files

| File | Role |
| --- | --- |
| `st.cmd` | Adapted startup: module directives, paths under `TC32SIM_RUN`, and the installed autosave, caPutLog, and retools support |
| `prepare.bash` | Fills the run directory from the application checkout |
| `tc32sim.acf` | Access security policy of this fixture; every write is trapped |

The application's fragment `tc32simApp/iocsh/tc32sim.iocsh`, its protocol
`tc32.proto`, its templates and substitution file, and its group definition
`tcmd_group.json` are used unchanged from the checkout.

## Adaptations

- `module StreamDevice`, `linStat`, `retools`, `autosave`, and `caPutLog`
  replace `< envPaths`, `dbLoadDatabase` of the application DBD, and the
  compiled `tc32sim_registerRecordDeviceDriver` call. asyn and calc follow
  from the recorded dependencies of StreamDevice.
- `TOP`, `DB_TOP`, and `IOCSH_LOCAL_TOP` point into `TC32SIM_RUN`.
- `prepare.bash` expands `TC32-sim.db` with the installed `msi` from
  `TC32-sim.substitutions`, as the application build does, and places
  `tc32.proto` and `tcmd_group.json` beside it.
- The original `cd` into the application tree is left out; the IOC keeps
  the caller's working directory and writes its record list there.
- Access security, autosave storage, the log receiver address, and the
  simulator port are settings of the test environment.

## Run

Source the selected tree's `setEpicsEnv.bash`, then:

```bash
bash examples/iocsh/tc32sim/prepare.bash <run_dir>
bash <run_dir>/src/simulator/tc32_emulator.bash --port 9400
EPICS_IOC_LOG_FILE_NAME=<run_dir>/ioclog.txt iocLogServer
TC32SIM_RUN=<run_dir> iocsh.bash examples/iocsh/tc32sim/st.cmd
```

The simulator, the log server, and the IOC each occupy a terminal. The
simulator needs `socat`. The run directory is disposable: the save files of
an earlier run are restored at the next start, so a new check starts from a
new run directory unless it tests restoration.

| Environment variable | Default | Meaning |
| --- | --- | --- |
| `TC32SIM_RUN` | none, required | Run directory that `prepare.bash` filled |
| `TC32SIM_TCP_PORT` | `9400` | Simulator TCP port |
| `NIC` | `lo` | Network interface for linStat |
| `LOG_INET` | `127.0.0.1` | Log receiver address for caPutLog |
| `LOG_INET_PORT` | `7004` | Log receiver port; set `EPICS_IOC_LOG_PORT` of `iocLogServer` to the same value |

## Expected Results

The device is simulated; these results describe the simulator path.

| Check | PV or command | Expected |
| --- | --- | --- |
| Records | `TC32:001:Ti0` through `TC32:001:Ti31` | `ai`, `DTYP` `stream`, `SCAN` `I/O Intr` |
| Values | `TC32:001:Ti<n>` | Between 10.0 and 90.0; the timestamp advances within 2 seconds; a read answers within 5 seconds |
| Alarms | `TC32:001:Ti<n>` | `LOW`, `HIGH`, or `HIHI` follow the limits 10, 45, and 60 of the substitution file; `INVALID` means the simulator is not connected |
| PVA group | `TC32:001:group` | Readable; `tc32.model_number` and `ch00.temp` present |
| linStat | `ioctestlab-tc32sim:MEM_FREE`, `:PROCESS_ID`, `:NET:<NIC>:MTU`, `:ROOT:SIZE` | Readable; `MEM_FREE` advances its timestamp every 10 seconds |
| retools | `reGrep("^TC32:001:Ti0$")` in `st.cmd` | Prints `TC32:001:Ti0` |
| autosave | `caput TC32:001:Ti0.HIGH 47`, `caput TC32:001:Ti0Scale 2` | Within 15 seconds `settings.sav` holds `TC32:001:Ti0.HIGH 47` and `values_pass1.sav` holds `TC32:001:Ti0Scale.VAL 2` under `<run_dir>/autosave/ioctestlab-tc32sim/save`; both values return after the IOC restarts |
| caPutLog | The same two CA writes | The log server file gains one line per write that names the PV with `new=` and `old=` values |
