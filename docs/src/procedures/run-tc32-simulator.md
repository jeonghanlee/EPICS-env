# Run a TCMD simulation with the loader

Use [tc32sim](https://github.com/jeonghanlee/tc32sim) to read simulated TC-32
temperatures through an installed EPICS-env loader. The example exposes
TCMD-style channel records and the `tcmd_group.json` PVAccess (PVA) group.
It verifies the simulator data path; physical TC-32 operation through
measComp and uldaq needs a separate hardware check.

The repository's `examples/iocsh/tc32sim` fixture prepares the application's
database and uses its protocol, templates, and group definition. It loads
StreamDevice, linStat, retools, autosave, and caPutLog from the installed
tree. No application executable or application registrar is compiled.

## Prerequisites

- An installed EPICS-env tree with those modules and their dependencies;
  [Run your first IOC with the loader](../tutorial/first-loader-ioc.md)
  introduces module directives and show mode.
- An EPICS-env checkout at the revision matching that tree, GitHub access,
  `git`, `socat`, and the installed `msi`, `iocLogServer`, CA, and PVA tools.
- Four terminals on the same test host. Reserve TCP port 9400 for the
  simulator and TCP port 7004 for the log receiver. The CA and PVA ports
  below must also be free.
- A new run directory outside both the source checkout and installed tree,
  with an existing parent and no whitespace in its path.

1. In every terminal, set the same paths and environment:

   ```bash
   source <installed_tree>/setEpicsEnv.bash
   export EPICS_ENV_REPO="$(readlink -f "<repo>")"
   export TC32SIM_RUN="$(readlink -f "<run_dir>")"
   export EPICS_CA_SERVER_PORT=55064 EPICS_CA_REPEATER_PORT=55065
   export EPICS_PVA_SERVER_PORT=55075 EPICS_PVA_BROADCAST_PORT=55076
   export EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1
   export EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
   export EPICS_PVA_AUTO_ADDR_LIST=NO EPICS_PVA_ADDR_LIST=127.0.0.1
   export EPICS_PVAS_INTF_ADDR_LIST=127.0.0.1
   export EPICS_IOC_LOG_PORT=7004 LOG_INET_PORT=7004 LOG_INET=127.0.0.1
   export TC32SIM_TCP_PORT=9400 NIC=lo
   ```

   `<installed_tree>` contains `setEpicsEnv.bash`, `base`, and `modules`.
   `<repo>` is the EPICS-env checkout. `<run_dir>` is the new run directory;
   for example, `$HOME/tc32-loader-demo` with your home directory expanded.
   `readlink -f` resolves parent symlinks even before the final directory
   exists. Stop if either path variable is empty.

2. In terminal 1, prepare the run directory:

   ```bash
   bash "$EPICS_ENV_REPO/examples/iocsh/tc32sim/prepare.bash" "$TC32SIM_RUN"
   ```

   The script clones tc32sim at its recorded revision, expands the database
   with `msi`, and prints `TC32SIM_RUN=<absolute_path>`. Confirm that this
   path equals the value used in the other terminals. Release 1.5.0 uses
   application revision `61645aeb78f9e7239a20397c918e2e74508cb9da`.

3. In terminal 1, start one simulated device:

   ```bash
   bash "$TC32SIM_RUN/src/simulator/tc32_emulator.bash" --port 9400
   ```

   Wait for `Emulator running on port 9400` and leave it running.
   One simulator supplies the 32 channels used by this fixture.

4. In terminal 2, start the log receiver:

   ```bash
   EPICS_IOC_LOG_FILE_NAME="$TC32SIM_RUN/ioclog.txt" iocLogServer
   ```

   Leave it running while the IOC uses caPutLog.

5. In terminal 3, inspect the startup from the run directory:

   ```bash
   cd "$TC32SIM_RUN"
   iocsh.bash -n "$EPICS_ENV_REPO/examples/iocsh/tc32sim/st.cmd"
   ```

   The generated startup includes the five requested modules and their
   recorded dependencies. The fixture's `st.cmd` owns the module directives;
   its `iocshLoad` calls load the application's fragments after registration.
   Show mode inspects module loading; it does not connect to the simulator.

6. In terminal 3, start the IOC:

   ```bash
   iocsh.bash "$EPICS_ENV_REPO/examples/iocsh/tc32sim/st.cmd"
   ```

   Wait for `iocRun: All initialization complete`, then allow 10 seconds
   for data updates. The run directory holds the record list and autosave
   files. Missing autosave files are expected on the first start in a new
   directory; connection failures or unknown commands are not.

7. In terminal 4, read two temperatures and their record support:

   ```bash
   caget TC32:001:Ti0.RTYP TC32:001:Ti0.DTYP TC32:001:Ti0.SCAN
   caget -a TC32:001:Ti0 TC32:001:Ti31
   ```

   The first command reports `ai`, `stream`, and `I/O Intr`. The temperatures
   lie between 10 and 90. Alarm limits can produce LOW, HIGH, or HIHI;
   INVALID indicates a failed data path.

8. In terminal 4, observe updates and inspect the TCMD-style PVA group:

   ```bash
   camonitor TC32:001:Ti0 TC32:001:Ti31
   ```

   Wait for more than one update for each channel, then press Ctrl-C.
   Channel updates can be uneven. Read the group after stopping the monitor:

   ```bash
   pvget TC32:001:group
   ```

   The structure includes `tc32.model_number` and `ch00.temp`. The group
   comes from the application's `tcmd_group.json`; a readable group alone
   does not establish that temperatures continue to update.

9. Stop the IOC with `exit` in terminal 3, then stop the log receiver and
   simulator with Ctrl-C in terminals 2 and 1. Keep the run directory if you
   need its logs or autosave state.

## Verification

The run succeeds when the IOC initializes, both temperature records update
without INVALID severity, and the PVA group has the fields above.
For autosave restoration, put logging, and all-channel monitoring, follow
the [fixture's full checks](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/tc32sim/README.md#expected-results).
Use a fresh directory for an independent run; reuse it only when testing
restoration of the saved state.
