# opcua-IOC-demo Loader Fixture

Runs the IOC of the `opcua-server-sim` simulator through the installed
`iocsh.bash` and the native `softIocPVX`, with the installed `opcua` module,
against the simulator server. The server and the open62541 library it needs
are built from source. No IOC executable, application DBD, or registrar is
compiled, and no proprietary server file and no container tool is needed.

## Source

| Item | Value |
| --- | --- |
| Simulator | <https://github.com/jeonghanlee/opcua-server-sim> |
| Simulator revision | `899bc67c798effe35c2e02e7540c96c4e05b1620` (branch `master`) |
| open62541 build wrapper | <https://github.com/jeonghanlee/open62541-env> |
| Wrapper revision | `fc8cc33897c84dca699a3e1a7d998ce3e2748dfe` (branch `1.5`) |
| open62541 | 1.5.10, built by the simulator's own `make open62541` |
| IOC files | `ioc/st.cmd` and `ioc/composite.db` of the simulator, used unchanged |

`prepare.bash` enforces both revisions through its `SIMULATOR_REVISION` and
`ENVIRONMENT_REVISION` values. This table repeats them; change them together
with those values. Neither repository carries a tag for these revisions, so the
pin is a commit id.

## Files

| File | Role |
| --- | --- |
| `prepare.bash` | Checks out the two repositories through `../checkout_application.bash`, builds open62541 and the server with the simulator's targets, creates the server certificate, and writes the client certificate, the PKI store and the identity file |

The startup file and the database that the IOC runs are the files of the
simulator checkout. The test is `examples/iocsh/tests/verify_fixture_opcua.bash`.

## Requirements

- `git`, `make`, `cmake`, a C and a C++ compiler, `python3`, `pkg-config`,
  `openssl`, and the development files of OpenSSL and libxml2.
- Network access to GitHub for the two checkouts and for the open62541 source.
- About 0.5 GB of free disk space in the run directory, whose path has no white
  space, as the documentation of the simulator requires.
- TCP port 4840 free on the host. The commands below limit the IOC and the
  Channel Access client to the loopback interface.

## Run

Source the selected tree first, then prepare the run directory from the
directory of this README:

```bash
source <installed_tree>/setEpicsEnv.bash
bash prepare.bash <run_dir>
```

`prepare.bash` prints the two revisions and `OPCUA_SIM_RUN=<run_dir>`. In
terminal one, start the server and leave it running:

```bash
bash <run_dir>/simulator/src/scripts/run-model.bash --di <run_dir>/open62541-env/src/open62541-src/deps/ua-nodeset/DI/Opc.Ua.Di.NodeSet2.xml <run_dir>/simulator/src/models/s7-1500-composite
```

Wait for the line `Creating listen socket ... port 4840`. In terminal two,
source the same tree and start the IOC:

```bash
export SIM_IOC_DIR=<run_dir>/simulator/src/ioc SIM_OPC_PORT=4840 SIM_SECURE_DIR=<run_dir>/secure
export EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
iocsh.bash "${SIM_IOC_DIR}/st.cmd"
```

Wait for `OPC UA session OPC2: connected`. In terminal three, source the same
tree and read two values:

```bash
EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1 caget SIM:Static:Int SIM:Mode
```

The values are `42` and `8` (operating mode RUN). The IOC opens two sessions:
`OPC1` without security and anonymous, and `OPC2` signed and encrypted with the
user of the simulator's `simulation.conf`.

## Expected results

`verify_fixture_opcua.bash` has 31 checks. It prepares the run directory, starts
the server through `scripts/run-model.bash`, and starts the IOC through
`iocsh.bash`. It checks:

- the preparation, the two revisions and unmodified checkouts;
- the server: it listens on port 4840 and maps `libopen62541` from the prefix of
  the run, built as 1.5.10;
- the IOC: the `opcua` module library and `libopen62541` 1.3.15 are mapped from
  the selected tree, and the server library is not;
- both sessions connect, and the secured session names the user of the
  simulation file, mode `SignAndEncrypt` and policy `Basic256Sha256`;
- the values of the model: operating mode 8, the start values of four scalar
  records, a structure member, the size of the array record, the value read over
  the secured session, device support and scan of a record, and a subscription
  that gives at least three distinct values of `SIM:Clock:Byte` in 6 s;
- the server identity: the command `opcuaShowSecurity OPC1` of the module reports
  the application name and URI that the `server.json5` of the model configures;
- the timestamp of `SIM:Clock:Byte` advances between two reads 1.2 s apart, and a
  read of `SIM:Static:Int` through Channel Access returns 42 within 2 s;
- a second IOC session without a server restart, and the 14 records of
  `composite.db` in the IOC;
- the stop and the start of the server while the IOC runs.

## Restart behavior

- A second IOC session started while the server keeps running connects and has
  no alarm.
- When the server stops, `SIM:Static:Int` goes `INVALID` with `COMM` at once.
- When the server starts again, the record returns to no alarm without an IOC
  restart, and `SIM:Mode` and `SIM:Static:Int` have their values again. The
  return took 5 s in every run whose time was read; the test allows 60 s.

Limitation: the IOC that has lived through a stop and a start of the server
ended with exit status 139 (SIGSEGV) in four of nine runs on Debian 13, after
it had printed `OPC UA session OPC2: disconnected`; it ended with status 0 in
the other five runs on Debian 13 and in all seven runs on Rocky Linux 8.10. An
IOC that saw no server restart ended with status 0 in every run. The cause is
not investigated. The test prints the exit status of that IOC and does not
fail on it.
