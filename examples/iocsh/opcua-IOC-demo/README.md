# opcua-IOC-demo Loader Fixture

Runs opcua-IOC-demo through the installed `iocsh.bash` and the native
`softIocPVX`. No IOC executable, application DBD, or registrar is compiled.

## Source

| Item | Value |
| --- | --- |
| Application | <https://github.com/jeonghanlee/opcua-IOC-demo> |
| Revision | `674c5735623703ad83f9c3fded479affa88871fa` |
| Original startup | `iocBoot/iochome-opcua-IOC-demo/st.cmd` |

## Files

| File | Role |
| --- | --- |
| `st.cmd` | Adapted startup: one module directive, paths under `OPCUA_IOC_DEMO_RUN`, and the server address |
| `st-milo.cmd` | Variant of `st.cmd` for the open-source Eclipse Milo demo server |
| `prepare.bash` | Fills the run directory from the application checkout |

The application's database files, substitution files, and templates are
used unchanged from the checkout.

## Adaptations

- `module opcua` replaces `< envPaths`, `dbLoadDatabase` of the application
  DBD, and the compiled `opcua_IOC_demo_registerRecordDeviceDriver` call.
- `DB_TOP` points into `OPCUA_IOC_DEMO_RUN`. `prepare.bash` expands
  `UaDemoServer-server.db` and `Demo.WorkOrder.db` with the installed `msi`
  from the application substitution files, the application templates, and
  the templates of the installed opcua module, as the application build
  does, and places the eight plain `Demo.*.db` files beside them.
- The original `cd` commands into the application tree are left out; the
  IOC keeps the caller's working directory.
- The server address is a setting of the test environment.

## Run

Source the selected tree's `setEpicsEnv.bash`, then:

```bash
bash examples/iocsh/opcua-IOC-demo/prepare.bash <run_dir>
OPCUA_IOC_DEMO_RUN=<run_dir> iocsh.bash examples/iocsh/opcua-IOC-demo/st.cmd
```

`st.cmd` expects the Unified Automation C++ demo server, which is not part
of this repository or of the installed tree. Start it separately before the
IOC for the data-path checks.

| Environment variable | Default | Meaning |
| --- | --- | --- |
| `OPCUA_IOC_DEMO_RUN` | none, required | Run directory that `prepare.bash` filled |
| `OPCUA_SERVER` | `opc.tcp://127.0.0.1:48020` | Session address of the demo server |

## Expected Results

| Check | PV or command | Expected |
| --- | --- | --- |
| Startup | `iocInit` | Completes with or without the server; the IOC reports the OPC UA device support version and starts connecting session `OPC1` |
| Records | `OPC:DSS:bibool` and the other `OPC:` records | `DTYP` `OPCUA` |
| Without the server | `OPC:DSS:bibool` | `INVALID` severity with `COMM` status; this is a communication result, not a loader failure |
| With the server | `OPC:DSS:bibool`, `OPC:DDS:` records | No alarm; the `Demo.Dynamic` records advance their timestamps within the 200 millisecond subscription plus 2 seconds; a read answers within 5 seconds |
| Session | Session `OPC1`, subscription `SUB1` | Connected to the configured address; the server status records under `OPC:` are readable |

The checks with the server stay pending on a host that has no demo server.

## Eclipse Milo Demo Server

`st-milo.cmd` runs the same session setup against the open-source Eclipse
Milo demo server. The application's Demo databases name nodes of the Unified
Automation server, so this variant loads the application's server database
`UaDemoServer-server.db` and its generic `ai.template` with three node
identifiers of the Milo server.

```bash
docker run --rm -p 127.0.0.1:4840:4840 digitalpetri/opc-ua-demo-server
OPCUA_IOC_DEMO_RUN=<run_dir> iocsh.bash examples/iocsh/opcua-IOC-demo/st-milo.cmd
```

Start the server anew before every IOC start, and publish its port under
the same number. The open62541 1.3.15 client of the installed opcua module
takes the discovery address that this server returns once it has served a
session, and session creation on that address fails with
`BadNotImplemented`; only the first session after a server start connects.
The observed image is
`digitalpetri/opc-ua-demo-server@sha256:67700c53c5bb0e503377075cd8c70a97ee64ee7fec41f08294d6f83ab092bf13`,
server version `1.1.0-SNAPSHOT`.

| Check | PV or command | Expected |
| --- | --- | --- |
| Session | IOC output | `OPC UA session OPC1: connected as 'Anonymous'` |
| Server | `OPC:ProductName`, `OPC:ServerState` | `Eclipse Milo OPC UA Demo Server`, `Running` |
| Server time | `OPC:CurrentTime` | Advances between two reads 2 seconds apart |
| Values | `OPC:MILO:DynamicDouble-RB`, `OPC:MILO:DynamicFloat-RB`, `OPC:MILO:DynamicInt32-RB` | `DTYP` `OPCUA`, `SCAN` `I/O Intr`, no alarm; value and timestamp change between two reads 2 seconds apart; a read answers within 5 seconds |
| Second session | A second IOC start without a server restart | Records in `INVALID` severity with `COMM` status; this is the client and server behavior described above, not a loader failure |
