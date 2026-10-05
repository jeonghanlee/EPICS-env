# Build and use your first EPICS environment

In this lesson you build Experimental Physics and Industrial Control System
(EPICS) base and its modules from source, and open a shell on the installed
tree. You then start a soft input/output controller (IOC) that serves one
process variable (PV). Last, you read and write that PV over Channel Access
(CA) and pvAccess (PVA).

## What you build in this lesson

At the end of the lesson you have:

- An installed tree at `<install_location>/1.4.0/debian-13/7.0.10`, with EPICS
  base, every module, and the uldaq and open62541 vendor libraries.
- A shell whose `PATH` and `LD_LIBRARY_PATH` point at that tree.
- A running IOC that serves the PV `tutorial:value`, and a second shell that
  reads and writes it.

The lesson runs on a Debian 13 host. It needs:

- The host packages for EPICS base and the modules. The continuous
  integration (CI) workflows install them with
  <https://github.com/jeonghanlee/pkg_automation>; see
  [Package setup in the OS workflows](../reference/supported-platforms-and-ci.md#package-setup-in-the-os-workflows).
- Access to GitHub, and about 3.5 GB of free disk space for the sources, the
  build products, and the installed tree.
- An empty directory that you own, as the working directory of the lesson.
  The lesson starts there and keeps one shell open until the IOC stage.

The whole lesson takes about 12 to 15 minutes on a 20-core host; `make build`
is the longest step.

## Fetch EPICS-env and set the install location

1. Clone EPICS-env and enter the clone:

   ```bash
   git clone https://github.com/jeonghanlee/EPICS-env
   cd EPICS-env
   ```

2. Set the install location in `configure/CONFIG_SITE.local`:

   ```bash
   echo "INSTALL_LOCATION=<install_location>" > configure/CONFIG_SITE.local
   ```

   `<install_location>` is an absolute path that you can write to, such as
   `/home/<user>/epics-lesson`. Set it before running an action such as
   `make init` or `make build`, because actions try to create this directory.
   Query-only invocations, such as `make print-INSTALL_LOCATION_EPICS`,
   create no installation directory or generated configuration file.
   The default install location is `${HOME}/epics`.

3. Print the path of the installed tree:

   ```bash
   make print-INSTALL_LOCATION_EPICS
   ```

   The output is:

   ```
   <install_location>/1.4.0/debian-13/7.0.10
   ```

   The path adds the EPICS-env release `1.4.0`, the operating system
   `debian-13`, and the EPICS base version `7.0.10` under your location. The
   stages below create this tree and fill it.

## Build the vendor libraries

The `measComp` module links the uldaq library and the `opcua` module links the
open62541 library. In this lesson both libraries go into the `vendor`
directory of the installed tree.

1. Save the `vendor` path in a shell variable:

   ```bash
   VENDOR_PATH="$(make print-INSTALL_LOCATION_EPICS)/vendor"
   ```

2. Point the two modules at that directory in `configure/RELEASE.local`:

   ```bash
   echo "VENDOR_ULDAQ_PATH=${VENDOR_PATH}" > configure/RELEASE.local
   echo 'OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor' >> configure/RELEASE.local
   ```

   Type the second line exactly as shown. Its escapes let the installed
   `opcua` configuration find the `vendor` directory relative to its own
   location.

3. Look at the file:

   ```bash
   cat configure/RELEASE.local
   ```

   The file holds two lines:

   ```
   VENDOR_ULDAQ_PATH=<install_location>/1.4.0/debian-13/7.0.10/vendor
   OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor
   ```

4. Build uldaq into the `vendor` directory:

   ```bash
   git clone https://github.com/jeonghanlee/uldaq-env ../uldaq-env
   echo "INSTALL_LOCATION=${VENDOR_PATH}" > ../uldaq-env/configure/CONFIG_SITE.local
   make -C ../uldaq-env init conf build install
   ```

5. Build open62541 into the `vendor` directory:

   ```bash
   git clone https://github.com/jeonghanlee/open62541-env ../open62541-env
   echo "INSTALL_LOCATION=${VENDOR_PATH}" > ../open62541-env/configure/CONFIG_SITE.local
   make -C ../open62541-env init conf build install
   ```

6. List the libraries:

   ```bash
   ls "${VENDOR_PATH}/lib"
   ```

   The output lists the libraries of both packages:

   ```
   cmake
   libopen62541.so
   libopen62541.so.1
   libopen62541.so.1.3.15
   libuldaq.a
   libuldaq.la
   libuldaq.so
   libuldaq.so.1
   libuldaq.so.1.2.1
   pkgconfig
   ```

   The installed tree exists and holds its first directory, `vendor`.

## Fetch and patch the sources

1. Clone EPICS base and every module at its pinned tag or commit:

   ```bash
   make init
   ```

2. List the source trees:

   ```bash
   ls -d *-src
   ```

   The output lists 33 source trees:

   ```
   asyn-src
   autosave-src
   busy-src
   calc-src
   caPutLog-src
   epics-base-src
   ether_ip-src
   feed-core-src
   iocStats-src
   linStat-src
   lua-src
   mca-src
   MCoreUtils-src
   measComp-src
   modbus-src
   motorMotorSim-src
   motor-src
   opcua-src
   pcas-src
   pmac-src
   pscdrv-src
   pvxs-src
   pyDevSup-src
   QPC-src
   recsync-src
   retools-src
   rgamv2-src
   scaler-src
   sequencer-src
   snmp-src
   sscan-src
   std-src
   StreamDevice-src
   ```

   EPICS base and 32 modules sit next to each other at the repository top.
   [Module pins and dependencies](../reference/module-pins.md) lists the pin of
   each one. The list above follows the sort order of the `en_US.UTF-8`
   locale; under another locale, such as `C`, `ls` orders the names
   differently.

3. Apply the upstream fixes that EPICS-env carries:

   ```bash
   make patch
   ```

   The output starts with the first two patches of EPICS base:

   ```

   Patching epics-base-src with the file : <clone>/patch/7.0.10-01-b2d2758-putnotify-type-check.p0.patch
   patching file modules/database/src/ioc/db/dbPutNotifyBlocker.cpp

   Patching epics-base-src with the file : <clone>/patch/7.0.10-pr0817-mbbi-cosv-aftc.p0.patch
   patching file modules/database/src/std/rec/mbbiRecord.c
   ```

   `<clone>` is the absolute path of your EPICS-env clone. Each `Patching`
   line names one patch file from the `patch` directory; the run applies 37 of
   them.

## Configure, build, and install

1. Write the site configuration of base and every module:

   ```bash
   make conf
   ```

   The command prints one empty line. It writes, among other files,
   `RELEASE.local` at the repository top, which tells every module where the
   installed base is:

   ```bash
   cat RELEASE.local
   ```

   The file holds two lines:

   ```
   EPICS_BASE:=<install_location>/1.4.0/debian-13/7.0.10/base
   SUPPORT=
   ```

2. Build base and every module:

   ```bash
   make build
   ```

   This is the long step. Base installs into the tree as it builds, and each
   module installs when its build completes.

3. Install the setup and reset scripts, the `commonIocsh` fragments, and the
   version file, and complete the base and module installs:

   ```bash
   make install
   ```

4. Create the unversioned module links:

   ```bash
   make symlinks
   ```

   The environment script finds the `pvxs` tools through the link `pvxs`, so
   this step is required for the next stage.

5. Look at the top level of the installed tree:

   ```bash
   LC_ALL=C make exist LEVEL=1
   ```

   The output is:

   ```
   <install_location>/1.4.0/debian-13/7.0.10
   |-- .versions
   |-- base
   |-- modules
   |-- resetEpicsEnv.bash
   |-- setEpicsEnv.bash
   `-- vendor

   4 directories, 3 files
   ```

   `LC_ALL=C` makes `tree` draw its lines with American Standard Code for
   Information Interchange (ASCII) characters, as shown above.
   Repeating installation also leaves backups of replaced setup and reset
   scripts; those files add entries to the listing.

## Open a shell on the installed tree

1. Source the environment script from the installed tree:

   ```bash
   source <install_location>/1.4.0/debian-13/7.0.10/setEpicsEnv.bash
   ```

   The script prints a summary that starts with these lines:

   ```

   Set the EPICS Environment as follows:
   THIS Source NAME    : setEpicsEnv.bash
   THIS Source PATH    : <install_location>/1.4.0/debian-13/7.0.10
   EPICS_BASE          : <install_location>/1.4.0/debian-13/7.0.10/base
   EPICS_HOST_ARCH     : linux-x86_64
   EPICS_MODULES       : <install_location>/1.4.0/debian-13/7.0.10/modules
   ```

2. Find the IOC program that the lesson uses:

   ```bash
   command -v softIocPVX
   ```

   The output is:

   ```
   <install_location>/1.4.0/debian-13/7.0.10/modules/pvxs/bin/linux-x86_64/softIocPVX
   ```

   `softIocPVX` comes from the `pvxs` module. It serves its records over both
   CA and PVA; the `softIoc` program of base serves CA only.

3. Keep CA and PVA traffic of this lesson on the loopback interface:

   ```bash
   export EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1 EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
   export EPICS_PVA_AUTO_ADDR_LIST=NO EPICS_PVA_ADDR_LIST=127.0.0.1 EPICS_PVAS_INTF_ADDR_LIST=127.0.0.1
   ```

   Without these settings, a client on a host with more than one network
   interface can receive replies from the same IOC over several addresses and
   print a warning for each one.

## Start a soft IOC with one record

1. Create a directory for the IOC and enter it:

   ```bash
   mkdir ../first-ioc
   cd ../first-ioc
   ```

2. Create the file `first.db` with one analog output record:

   ```
   record(ao, "tutorial:value") {
       field(VAL, "42")
       field(PINI, "YES")
   }
   ```

   `PINI` processes the record once at start, so the PV holds `42` with a
   valid time stamp.

3. Start the IOC with the database:

   ```bash
   softIocPVX -d first.db
   ```

   The IOC prints a banner and waits at its prompt:

   ```
   INFO: PVXS QSRV2 is loaded, permitted, and ENABLED.
   Starting iocInit
   ############################################################################
   ## EPICS R7.0.10-github.com/jeonghanlee/EPICS-env
   ## Rev. R7.0.10-dirty
   ## Rev. Date Git: 2025-12-15 17:11:22 -0600
   ############################################################################
   iocRun: All initialization complete
   7.0.10 >
   ```

   The banner names the EPICS-env site version. `dirty` marks the base source
   tree that `make patch` changed. The prompt `7.0.10 >` waits for IOC shell
   commands. The output above is from a terminal; when the IOC output goes to
   a pipe, the same lines can appear in a different order.

4. At the IOC prompt, list the records:

   ```
   dbl
   ```

   The IOC prints the name of its one record:

   ```
   tutorial:value
   ```

## Read and write the PV from a second shell

1. Open a second terminal in the working directory of the lesson and set up
   the same environment without the summary:

   ```bash
   source <install_location>/1.4.0/debian-13/7.0.10/setEpicsEnv.bash disable
   export EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1 EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
   export EPICS_PVA_AUTO_ADDR_LIST=NO EPICS_PVA_ADDR_LIST=127.0.0.1 EPICS_PVAS_INTF_ADDR_LIST=127.0.0.1
   ```

2. Read the PV over CA:

   ```bash
   caget tutorial:value
   ```

   The output is:

   ```
   tutorial:value                 42
   ```

3. Read the PV over PVA:

   ```bash
   pvget tutorial:value
   ```

   The output shows the time stamp and the value:

   ```
   tutorial:value 2026-09-26 23:16:46.167  42
   ```

   PVA also carries the time stamp that `PINI` set. Your output shows the time
   at which your IOC processed the record.

4. Write the value `7` over CA:

   ```bash
   caput tutorial:value 7
   ```

   The output shows the value before and after the write:

   ```
   Old : tutorial:value                 42
   New : tutorial:value                 7
   ```

5. Read the value again:

   ```bash
   caget tutorial:value
   ```

   The output is:

   ```
   tutorial:value                 7
   ```

6. To stop the IOC, type `exit` at the IOC prompt in the first terminal.

You built an installed tree from source, set up a shell on it, and exchanged
a value with a running IOC over both protocols.

## Pages to read after this lesson

- [Build and install the environment](../procedures/build-and-install.md)
  repeats the build as a task with its verification.
- [Set up a shell with the environment](../procedures/set-up-shell.md)
  lists every variable the environment script sets.
- [Run the verification gates](../procedures/run-verification-gates.md)
  checks the tree you built.
- [Uninstall and clean](../procedures/uninstall-and-clean.md) removes the tree
  and the sources.
- [The installed tree](../concepts/installed-tree.md) explains the layout.
- [Run an IOC from installed modules](../procedures/run-ioc-from-installed-modules.md)
  runs an IOC from the installed `softIocPVX` and the modules that its startup
  file names, without compiling an IOC executable.
