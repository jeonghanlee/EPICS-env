# opcua-IOC-demo Loader Fixture

Runs opcua-IOC-demo through the installed `iocsh.bash` and the native
`softIocPVX`. No IOC executable, application DBD, or registrar is compiled.

## Source

| Item | Value |
| --- | --- |
| Application | <https://github.com/jeonghanlee/opcua-IOC-demo> |
| Revision | `674c5735623703ad83f9c3fded479affa88871fa` |
| Original startup | `iocBoot/iochome-opcua-IOC-demo/st.cmd` |

`prepare.bash` enforces the revision through its `APPLICATION_REVISION`
value. This table and the header of `st.cmd` and `st-milo.cmd` repeat it; change them together
with that value, and compare the adapted startup with the original startup
of the new revision.

## Files

| File | Role |
| --- | --- |
| `st.cmd` | Adapted startup: one module directive, paths under `OPCUA_IOC_DEMO_RUN`, and the server address |
| `st-milo.cmd` | Variant of `st.cmd` for the open-source Eclipse Milo demo server |
| `prepare.bash` | Fills the run directory from the application checkout, through `../checkout_application.bash` |

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

The commands use three placeholders:

| Placeholder | Meaning |
| --- | --- |
| `<tree>` | Installed distribution directory that holds `setEpicsEnv.bash`, `base`, and `modules` |
| `<repo>` | Top of this repository |
| `<run_dir>` | New directory for this run, as an absolute path; `prepare.bash` creates it and prints the absolute path as `OPCUA_IOC_DEMO_RUN=<run_dir>`, the value to use in every later command |

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

The original startup `st.cmd` needs the Unified Automation C++ demo server,
which is not freely available and is not part of this repository or of the
installed tree. Without that server, use the Eclipse Milo section below;
`st.cmd` then only shows that the IOC starts.

Terminal 1, the run directory and the IOC; leave it with `exit`.

```bash
bash <repo>/examples/iocsh/opcua-IOC-demo/prepare.bash <run_dir>
OPCUA_IOC_DEMO_RUN=<run_dir> iocsh.bash <repo>/examples/iocsh/opcua-IOC-demo/st.cmd
```

Terminal 2, the checks.

```bash
caget OPC:DSS:bibool.DTYP OPC:DSS:bibool.SEVR OPC:DSS:bibool.STAT
```

| Environment variable | Default | Meaning |
| --- | --- | --- |
| `OPCUA_IOC_DEMO_RUN` | none, required | Run directory that `prepare.bash` filled |
| `OPCUA_SERVER` | `opc.tcp://127.0.0.1:48020` for `st.cmd`, `opc.tcp://127.0.0.1:4840/milo` for `st-milo.cmd` | Session address of the demo server |

| Check | PV or command | Expected |
| --- | --- | --- |
| Startup | IOC terminal | `iocInit` completes with or without the server; the IOC reports the OPC UA device support version and starts connecting session `OPC1` |
| Records | `OPC:DSS:bibool.DTYP` | `OPCUA` |
| Without the server | `OPC:DSS:bibool.SEVR`, `.STAT` | `INVALID` and `COMM`; this is a communication result, not a loader failure |
| With the server | `OPC:DSS:bibool`, `OPC:DDS:` records | No alarm; the `Demo.Dynamic` records advance their timestamps within the 200 millisecond subscription plus 2 seconds; a read answers within 5 seconds |

The row with the server stays pending on a host that has no Unified
Automation demo server.

## Eclipse Milo Demo Server

`st-milo.cmd` runs the same session setup against the open-source Eclipse
Milo demo server. The application's Demo databases name nodes of the Unified
Automation server, so this variant loads the application's server database
`UaDemoServer-server.db` and its generic `ai.template` with three node
identifiers of the Milo server. It needs `docker` or `podman` and the run directory
prepared above.

Terminal 1, the server; stop it with Ctrl-C. Wait until it reports its
bound endpoints.

```bash
docker run --rm -p 127.0.0.1:4840:4840 digitalpetri/opc-ua-demo-server
```

Terminal 2, the IOC; leave it with `exit`.

```bash
OPCUA_IOC_DEMO_RUN=<run_dir> iocsh.bash <repo>/examples/iocsh/opcua-IOC-demo/st-milo.cmd
```

Terminal 3, the checks; repeat the last command after 2 seconds.

```bash
caget OPC:ProductName OPC:ServerState
caget OPC:MILO:DynamicDouble-RB.DTYP OPC:MILO:DynamicDouble-RB.SCAN
caget -a OPC:CurrentTime OPC:MILO:DynamicDouble-RB OPC:MILO:DynamicFloat-RB OPC:MILO:DynamicInt32-RB
```

Stop the server with Ctrl-C and start it anew before every IOC start, and
publish its port under the same number. The open62541 1.3.15 client of the
installed opcua module takes the discovery address that this server returns
once it has served a session, and session creation on that address fails
with `BadNotImplemented`; only the first session after a server start
connects. The observed image is
`digitalpetri/opc-ua-demo-server@sha256:67700c53c5bb0e503377075cd8c70a97ee64ee7fec41f08294d6f83ab092bf13`,
server version `1.1.0-SNAPSHOT`.

| Check | PV or command | Expected |
| --- | --- | --- |
| Session | IOC terminal | `OPC UA session OPC1: connected as 'Anonymous'` |
| Server | `OPC:ProductName`, `OPC:ServerState` | `Eclipse Milo OPC UA Demo Server`, `Running` |
| Server time | `OPC:CurrentTime` | Later value at the second read |
| Values | `OPC:MILO:DynamicDouble-RB`, `OPC:MILO:DynamicFloat-RB`, `OPC:MILO:DynamicInt32-RB` | `DTYP` `OPCUA`, `SCAN` `I/O Intr`, no alarm; value and timestamp change between the two reads; a read answers within 5 seconds |
| Second session | A second IOC start without a server restart | Records in `INVALID` severity with `COMM` status; this is the client and server behavior described above, not a loader failure |
