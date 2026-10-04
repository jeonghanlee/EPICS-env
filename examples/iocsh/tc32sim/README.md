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

`prepare.bash` enforces the revision through its `APPLICATION_REVISION`
value. This table and the header of `st.cmd` repeat it; change them together
with that value, and compare the adapted startup with the original startup
of the new revision.

## Files

| File | Role |
| --- | --- |
| `st.cmd` | Adapted startup: module directives, paths under `TC32SIM_RUN`, and the installed autosave, caPutLog, and retools support |
| `prepare.bash` | Fills the run directory from the application checkout, through `../checkout_application.bash` |
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
- `IOCSH_TOP` defaults to `$(EPICS_MODULES)/commonIocsh` and can be set in
  the environment; the original fixes it to
  `$(EPICS_BASE)/../modules/commonIocsh`.
- `prepare.bash` expands `TC32-sim.db` with the installed `msi` from
  `TC32-sim.substitutions`, as the application build does, and places
  `tc32.proto` and `tcmd_group.json` beside it.
- The original `cd` into the application tree is left out; the IOC keeps
  the caller's working directory and writes its record list there.
- Access security, autosave storage, the log receiver address, and the
  simulator port are settings of the test environment.

## Run

The commands use three placeholders:

| Placeholder | Meaning |
| --- | --- |
| `<tree>` | Installed distribution directory that holds `setEpicsEnv.bash`, `base`, and `modules` |
| `<repo>` | Top of this repository |
| `<run_dir>` | New directory for this run, as an absolute path; `prepare.bash` creates it and prints the absolute path as `TC32SIM_RUN=<run_dir>`, the value to use in every later command |

Every terminal below starts with the selected environment:

```bash
source <tree>/setEpicsEnv.bash
```

On a host that runs other EPICS servers or has more than one network
interface, also give every terminal dedicated ports and loopback addresses,
for example:

```bash
export EPICS_CA_SERVER_PORT=55064 EPICS_CA_REPEATER_PORT=55065
export EPICS_PVA_SERVER_PORT=55075 EPICS_PVA_BROADCAST_PORT=55076
export EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1 EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
```

linStat rescans through a CA link to its own PV, so without those settings
its readings stop advancing on such a host, and each CA read warns about
identical PV names on multiple servers.

Terminal 1, the run directory and the simulator. Wait for `Emulator running
on port 9400`; stop it with Ctrl-C. The simulator needs `socat`.

```bash
bash <repo>/examples/iocsh/tc32sim/prepare.bash <run_dir>
bash <run_dir>/src/simulator/tc32_emulator.bash --port 9400
```

Terminal 2, the log receiver; stop it with Ctrl-C.

```bash
EPICS_IOC_LOG_FILE_NAME=<run_dir>/ioclog.txt iocLogServer
```

Terminal 3, the IOC, started from the run directory because it writes its
record list `testlab-tc32sim` into the working directory. Leave it with
`exit`.

```bash
cd <run_dir>
TC32SIM_RUN=<run_dir> iocsh.bash <repo>/examples/iocsh/tc32sim/st.cmd
```

Terminal 4, the checks of the next section.

The run directory path must not contain whitespace, because the installed
autosave fragment passes its storage path to a shell command unquoted;
`prepare.bash` rejects such a path. The run directory is disposable: the
save files of an earlier run are restored at the next start, so a new check
starts from a new run directory unless it tests restoration. On the first
start in a new run directory autosave reports that it cannot open its save
files; that is expected.

| Environment variable | Default | Meaning |
| --- | --- | --- |
| `TC32SIM_RUN` | none, required | Run directory that `prepare.bash` filled |
| `TC32SIM_TCP_PORT` | `9400` | Simulator TCP port |
| `NIC` | `lo` | Network interface for linStat |
| `LOG_INET` | `127.0.0.1` | Log receiver address for caPutLog |
| `LOG_INET_PORT` | `7004` | Log receiver port; set `EPICS_IOC_LOG_PORT` of `iocLogServer` to the same value |

## Expected Results

The device is simulated; these results describe the simulator path. Start
the checks 10 seconds after `iocInit`.

```bash
caget TC32:001:Ti0.RTYP TC32:001:Ti0.DTYP TC32:001:Ti0.SCAN TC32:001:Ti31.DTYP
caget -a TC32:001:Ti0 TC32:001:Ti31
pvget TC32:001:group
caget -a ioctestlab-tc32sim:MEM_FREE ioctestlab-tc32sim:PROCESS_ID
caget -a ioctestlab-tc32sim:NET:lo:MTU ioctestlab-tc32sim:ROOT:SIZE
caput TC32:001:Ti0.HIGH 47
caput TC32:001:Ti0Scale 2
grep -h -E 'Ti0\.HIGH|Ti0Scale' <run_dir>/autosave/ioctestlab-tc32sim/save/settings.sav
grep -h -E 'Ti0\.HIGH|Ti0Scale' <run_dir>/autosave/ioctestlab-tc32sim/save/values_pass1.sav
cat <run_dir>/ioclog.txt
```

For the restoration check, leave the IOC with `exit`, start it again with
the same command in terminal 3, and read both settings:

```bash
caget TC32:001:Ti0.HIGH TC32:001:Ti0Scale
```

| Check | PV or command | Expected |
| --- | --- | --- |
| Records | `TC32:001:Ti0` through `TC32:001:Ti31` | `ai`, `DTYP` `stream`, `SCAN` `I/O Intr` |
| Values | `TC32:001:Ti<n>` | Between 10.0 and 90.0; a second `caget -a` 2 seconds later shows a later timestamp; a read answers within 5 seconds |
| Alarms | `TC32:001:Ti<n>` | `LOW`, `HIGH`, or `HIHI` follow the limits 10, 45, and 60 of the substitution file; `INVALID` means the simulator is not connected |
| PVA group | `pvget TC32:001:group` | Prints the structure with `tc32` holding `model_number` and `ch00` holding `temp` |
| linStat | `ioctestlab-tc32sim:MEM_FREE`, `:PROCESS_ID`, `:NET:<NIC>:MTU`, `:ROOT:SIZE` | Readable; `MEM_FREE` advances its timestamp every 10 seconds |
| retools | `reGrep("^TC32:001:Ti0$")` in `st.cmd` | The IOC terminal prints `TC32:001:Ti0` after `iocInit` |
| autosave | The two `caput` and two `grep` commands | Within 15 seconds `settings.sav` holds `TC32:001:Ti0.HIGH 47` and `values_pass1.sav` holds `TC32:001:Ti0Scale.VAL 2`; after the restart `caget` returns `47` and `Kelvin` |
| caPutLog | `cat <run_dir>/ioclog.txt` | Within 15 seconds of each `caput`, one line that names the PV with `new=` and `old=` values |
