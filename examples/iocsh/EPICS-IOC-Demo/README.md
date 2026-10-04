# EPICS-IOC-Demo Loader Fixture

Runs the training-device startup of EPICS-IOC-Demo through the installed
`iocsh.bash` and the native `softIocPVX`. No IOC executable, application
DBD, or registrar is compiled.

## Source

| Item | Value |
| --- | --- |
| Application | <https://github.com/jeonghanlee/EPICS-IOC-Demo> |
| Revision | `e4198269aaa9d8c367446fd1d5afe8c371b4c039` |
| Original startup | `iocBoot/iocB46-182-jeonglee-Demo/st2.cmd` |

`prepare.bash` enforces the revision through its `APPLICATION_REVISION`
value. This table and the header of `st.cmd` repeat it; change them together
with that value, and compare the adapted startup with the original startup
of the new revision.

## Files

| File | Role |
| --- | --- |
| `st.cmd` | Adapted startup: one module directive and paths under `EPICS_IOC_DEMO_RUN` |
| `prepare.bash` | Checks out the application at the recorded revision, through `../checkout_application.bash` |

The application's fragment `jeonglee-DemoApp/iocsh/training_device.iocsh`,
its database `training.db`, and its protocol `training.proto` are used
unchanged from the checkout.

## Adaptations

- `module StreamDevice` replaces `< envPaths`, `dbLoadDatabase` of the
  application DBD, and the compiled `jeonglee_Demo_registerRecordDeviceDriver`
  call. asyn and calc follow from the recorded dependencies of StreamDevice.
- `DB_TOP` and `IOCSH_LOCAL_TOP` point at the application source
  directories `jeonglee-DemoApp/Db` and `jeonglee-DemoApp/iocsh`, because
  the application's installed `db` and `iocsh` directories exist only after
  its build.
- The original `cd` into the application tree is left out; the IOC keeps
  the caller's working directory.
- The simulator host and port are passed to the fragment as settings of the
  test environment.

## Run

The commands use three placeholders:

| Placeholder | Meaning |
| --- | --- |
| `<tree>` | Installed distribution directory that holds `setEpicsEnv.bash`, `base`, and `modules` |
| `<repo>` | Top of this repository |
| `<run_dir>` | New directory for this run, as an absolute path; `prepare.bash` creates it and prints the absolute path as `EPICS_IOC_DEMO_RUN=<run_dir>`, the value to use in every later command |

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

Terminal 1, the run directory and the simulator, which echoes each line it
receives and needs `socat` or `tcpsvd`; stop it with Ctrl-C.

```bash
bash <repo>/examples/iocsh/EPICS-IOC-Demo/prepare.bash <run_dir>
bash <run_dir>/src/simulator/tcpserver.bash 9399
```

Terminal 2, the IOC; leave it with `exit`.

```bash
EPICS_IOC_DEMO_RUN=<run_dir> iocsh.bash <repo>/examples/iocsh/EPICS-IOC-Demo/st.cmd
```

Terminal 3, the checks of the next section.

| Environment variable | Default | Meaning |
| --- | --- | --- |
| `EPICS_IOC_DEMO_RUN` | none, required | Run directory that `prepare.bash` filled |
| `DEMO_TCP_HOST` | `127.0.0.1` | Simulator address |
| `DEMO_TCP_PORT` | `9399` | Simulator TCP port |

## Expected Results

The device is simulated; these results describe the simulator path.

```bash
caget jeonglee:myoffice:Cmd.RTYP jeonglee:myoffice:Cmd.DTYP
caget jeonglee:myoffice:Cmd-RB.RTYP jeonglee:myoffice:Cmd-RB.DTYP
caput jeonglee:myoffice:Cmd "hello loader"
caget -a jeonglee:myoffice:Cmd-RB
```

| Check | PV or command | Expected |
| --- | --- | --- |
| Records | The two `caget` commands on `RTYP` and `DTYP` | `stringout` with `stream`, and `stringin` with `Soft Channel` |
| Communication | `caput` followed by `caget -a` | Within 2 seconds `jeonglee:myoffice:Cmd-RB` holds the same text with a new timestamp and no alarm |
| Offline | The same `caput` after the simulator is stopped and the IOC is started anew | `caput` reports `Channel write request failed`, `jeonglee:myoffice:Cmd` goes to `INVALID` severity with `COMM` status, and `Cmd-RB` is not updated: it stays `UDF`; this is a communication result, not a loader failure |
