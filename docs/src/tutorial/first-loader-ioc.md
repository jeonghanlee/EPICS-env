# Run your first IOC with the loader

Create one software process variable (PV), load its record support from an
installed module, and change its value through Channel Access (CA).
This example uses the `busy` module and needs no device or IOC compilation.

## Before you start

Use an installed EPICS-env tree with the `busy` module and its dependencies,
created by [Build and install the environment](../procedures/build-and-install.md).
You need Bash, `readelf`, and two terminals on the same Linux host.
Use a test host without another IOC publishing `LOADER:Run`.

Replace `<installed_tree>` with the directory containing `setEpicsEnv.bash`,
`base`, and `modules`. In each terminal, select that tree and direct CA
searches to the local host:

```bash
source <installed_tree>/setEpicsEnv.bash
export EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1
```

## Create the database and startup

1. In terminal 1, create a working directory outside the installation:

   ```bash
   mkdir "$HOME/ioc-loader-demo"
   cd "$HOME/ioc-loader-demo"
   ```

   If that directory exists, choose a different empty directory for this
   exercise. Keep the database and startup file together in it.

2. Save this database as `busy.db` in that directory:

   ```text
   record(busy, "$(P)Run") {
       field(DESC, "Loader demonstration")
       field(ZNAM, "Idle")
       field(ONAM, "Busy")
   }
   ```

   `P` is a database macro. The startup supplies `LOADER:`, making the
   record name `LOADER:Run`. Its value is `0` (`Idle`) or `1` (`Busy`).

3. Save this startup as `st.cmd` in the same directory:

   ```text
   on error break
   module busy
   dbLoadRecords("busy.db", "P=LOADER:")
   iocInit()
   ```

   `module busy` selects the installed default version and loads its recorded
   dependencies. The loader registers record support before `dbLoadRecords`
   runs. You supply the database instances and call `iocInit()` once.

   Put module directives in this top-level startup file. They are loader
   directives, so entering them at the IOC prompt or inside an `iocshLoad`
   fragment does not load a module.

4. In terminal 1, inspect the generated startup without starting the IOC:

   ```bash
   iocsh.bash -n st.cmd
   ```

   The output includes the selected `busy` version, its libraries and DBD
   files, dependency modules, and `registerAllRecordDeviceDrivers(pdbbase)`.
   Correct any missing-module or version-conflict error before continuing.

   The generated text refers to `/dev/fd/3` and `/dev/fd/4`, which the loader
   opens for one invocation. Keep `st.cmd` as the runnable file; saved show
   output is an inspection report, not a standalone startup.

## Start the IOC and change its PV

1. In terminal 1, still in the directory containing both files, start it:

   ```bash
   iocsh.bash st.cmd
   ```

   Wait for `iocRun: All initialization complete`. Keep this terminal open.
   The relative path `busy.db` is resolved from the working directory, so
   passing an absolute startup filename alone does not change that directory.

2. In terminal 2, after the environment setup above, read the value:

   ```bash
   caget -t LOADER:Run
   ```

   The result is:

   ```text
   Idle
   ```

3. In terminal 2, set the record and read it again:

   ```bash
   caput LOADER:Run 1
   caget -t LOADER:Run
   ```

   `caput` reports the old and new values; `caget` prints `Busy`.
   Set it back to idle:

   ```bash
   caput LOADER:Run 0
   caget -t LOADER:Run
   ```

   `caget` prints `Idle`. This software example has no device action.

4. In terminal 1, type `exit` at the IOC prompt to stop the IOC.

## Select a version and environment

To see which installed directory the default selects, run this in a shell
where you sourced the environment:

```bash
readlink -f "$EPICS_MODULES/busy"
```

For release 1.5.0, the directory ends in `busy-a4a272d`. To select that
version explicitly, replace `module busy` in `st.cmd` with:

```text
module busy a4a272d
```

Use the version suffix actually installed in your tree. Re-run
`iocsh.bash -n st.cmd`; its `busy` comment must show that version.
Dependency versions come from the selected module's metadata. Adding a
different explicit dependency version can produce a version conflict.

To inspect the same startup from a shell without a sourced environment,
enter the working directory and select the tree explicitly. If you chose
another directory for the exercise, use that path in the `cd` command:

```bash
cd "$HOME/ioc-loader-demo"
LOADER_TREE="$(readlink -f "<installed_tree>")"
"$LOADER_TREE/base/bin/linux-x86_64/iocsh.bash" -e "$LOADER_TREE" -n st.cmd
```

This path applies to the Linux x86_64 installation used here. The `-e`
option selects the environment inside the loader process; it does not set
up the calling shell for `caget` or `caput`.

## Verification

The exercise succeeds when the IOC initializes, `caget` reads `Idle`,
`Busy`, and `Idle` in that order, and `exit` returns terminal 1 to its shell.
An error from `dbLoadRecords` or `iocInit` is a failed start even if the
loader's static inspection succeeded.

Continue with [Run a TCMD simulation with the loader](../procedures/run-tc32-simulator.md)
for a TCP device simulator, 32 temperature channels, and a PVAccess group.
[Run an IOC from installed modules](../procedures/run-ioc-from-installed-modules.md)
explains other applications and loader refusal messages.
