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

## Files

| File | Role |
| --- | --- |
| `st.cmd` | Adapted startup: one module directive and paths under `EPICS_IOC_DEMO_RUN` |
| `prepare.bash` | Checks out the application at the recorded revision |

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

Source the selected tree's `setEpicsEnv.bash`, then:

```bash
bash examples/iocsh/EPICS-IOC-Demo/prepare.bash <run_dir>
bash <run_dir>/src/simulator/tcpserver.bash 9399
EPICS_IOC_DEMO_RUN=<run_dir> iocsh.bash examples/iocsh/EPICS-IOC-Demo/st.cmd
```

The simulator and the IOC each occupy a terminal. The simulator echoes each
line it receives and needs `socat` or `tcpsvd`.

| Environment variable | Default | Meaning |
| --- | --- | --- |
| `EPICS_IOC_DEMO_RUN` | none, required | Run directory that `prepare.bash` filled |
| `DEMO_TCP_HOST` | `127.0.0.1` | Simulator address |
| `DEMO_TCP_PORT` | `9399` | Simulator TCP port |

## Expected Results

The device is simulated; these results describe the simulator path.

| Check | PV or command | Expected |
| --- | --- | --- |
| Records | `jeonglee:myoffice:Cmd`, `jeonglee:myoffice:Cmd-RB` | `stringout` with `DTYP` `stream`, and `stringin` with `DTYP` `Soft Channel` |
| Communication | `caput jeonglee:myoffice:Cmd "<text>"` | Within 2 seconds `jeonglee:myoffice:Cmd-RB` holds the same text with a new timestamp and no alarm |
| Offline | The same write without the simulator | `jeonglee:myoffice:Cmd` goes to an `INVALID` alarm and `Cmd-RB` keeps its earlier value; this is a communication result, not a loader failure |
