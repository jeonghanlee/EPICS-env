# Load common iocsh fragments in an IOC

Add the site services of the common iocsh fragments to an Experimental
Physics and Industrial Control System (EPICS) input/output controller (IOC)
built against an installed tree. The IOC application in these steps is
named `demo`. It loads the iocLog, serial, caPutLog, autosave, reccaster, and
linStat fragments, and leaves out iocStatsAdmin, whose records collide with
linStat; see
[Common iocsh fragments](../concepts/common-iocsh-fragments.md#iocstatsadmin-and-linstat-record-name-collisions).

## Prerequisites

- An installed tree built with `make install`, which holds the fragments in
  `modules/commonIocsh/iocsh`; see
  [Build and install the environment](build-and-install.md).
- An IOC application whose `iocBoot/<ioc_name>` directory has a `Makefile`
  that writes `envPaths`, such as one that `makeBaseApp.pl -i` creates.
- For `iocLog.iocsh` and `caPutLog.iocsh`: a log server, such as
  `iocLogServer` from EPICS base, listening on Transmission Control Protocol
  (TCP) port 7004 of `<log_host>`.
- For `setSerialParams.iocsh`: a serial device that the IOC can open.

1. In the IOC's `configure/RELEASE`, or the `configure/RELEASE.local` file it
   includes, name EPICS base and each module with the macro that the
   fragments read:

   ```makefile
   MODULES = <installed_tree>/modules
   AUTOSAVE = $(MODULES)/autosave
   RECCASTER = $(MODULES)/recsync
   LINSTAT = $(MODULES)/linStat
   CAPUTLOG = $(MODULES)/caPutLog
   ASYN = $(MODULES)/asyn
   EPICS_BASE = <installed_tree>/base
   ```

   `<installed_tree>` is the path that `make print-INSTALL_LOCATION_EPICS`
   prints in the EPICS-env clone that built the tree. List only the modules
   whose fragments the IOC loads.
   [Common iocsh fragment macros](../reference/common-iocsh-fragment-macros.md#module-and-database-definition-requirements)
   names the module each fragment needs.

2. In the application's `src/Makefile`, add the database definition (DBD)
   files and libraries of those modules before the line
   `demo_LIBS += $(EPICS_BASE_IOC_LIBS)`:

   ```makefile
   demo_DBD += caPutLog.dbd asSupport.dbd reccaster.dbd linStat.dbd system.dbd
   demo_DBD += asyn.dbd drvAsynSerialPort.dbd
   demo_LIBS += caPutLog autosave reccaster linStat asyn
   ```

   The `makeBaseApp.pl` template already adds `base.dbd` and
   `$(EPICS_BASE_IOC_LIBS)`.

   `system.dbd` registers the iocsh `system` command, which
   `autosave.iocsh` uses to create its directories.

3. To build the IOC against the installed modules, run this command from the
   top of the IOC application:

   ```bash
   make CHECK_RELEASE=NO
   ```

   The installed modules keep the `configure/RELEASE` files of their upstream
   sources, which name a different `EPICS_BASE`. With the release check on,
   the build stops at `Definition of EPICS_BASE conflicts with CAPUTLOG
   support`. The build writes `iocBoot/<ioc_name>/envPaths`, which sets
   `IOC` to `<ioc_name>` and sets each module macro of step 1.

4. Optional: to configure serial ports, create a serial configuration file
   in `iocBoot/<ioc_name>`, such as `serialPorts.cmd`, with one
   `setSerialParams.iocsh` line for each port:

   ```
   iocshLoad("$(IOCSH_TOP)/iocsh/setSerialParams.iocsh", "PORT=S1,BAUD=19200,BITS=8,STOP=2,PARITY=odd")
   ```

   `PORT` is the asyn port name that the startup script gives to
   `drvAsynSerialPortConfigure`.

5. To let caPutLog see puts, create an access security configuration file
   (ACF) in `iocBoot/<ioc_name>`, such as `demo.acf`, that marks writes with
   `TRAPWRITE`:

   ```
   ASG(DEFAULT) {
       RULE(1, READ)
       RULE(1, WRITE, TRAPWRITE)
   }
   ```

6. In `iocBoot/<ioc_name>/st.cmd`, set `IOCSH_TOP` and load the fragments
   between the DBD registration and `iocInit`:

   ```
   #!../../bin/linux-x86_64/demo
   < envPaths
   epicsEnvSet("IOCSH_TOP", "<installed_tree>/modules/commonIocsh")
   dbLoadDatabase("$(TOP)/dbd/demo.dbd")
   demo_registerRecordDeviceDriver(pdbbase)
   iocshLoad("$(IOCSH_TOP)/iocsh/iocLog.iocsh", "IOC=$(IOC),LOG_INET=<log_host>")
   drvAsynSerialPortConfigure("S1", "<tty_device>", 0, 0, 0)
   iocshLoad("$(IOCSH_TOP)/iocsh/serial.iocsh", "SERIAL_ENABLE=,SERIAL_CONFIG=$(TOP)/iocBoot/$(IOC)/serialPorts.cmd")
   asSetFilename("$(TOP)/iocBoot/$(IOC)/demo.acf")
   iocshLoad("$(IOCSH_TOP)/iocsh/caPutLog.iocsh", "LOG_INET=<log_host>")
   iocshLoad("$(IOCSH_TOP)/iocsh/autosave.iocsh", "IOC=$(IOC),AS_TOP=<as_top>")
   iocshLoad("$(IOCSH_TOP)/iocsh/reccaster.iocsh", "IOC=$(IOC)")
   iocshLoad("$(IOCSH_TOP)/iocsh/linStat.iocsh", "IOC=$(IOC)")
   iocInit()
   ```

   - `<log_host>` is the address of the log server.
   - `<tty_device>` is the serial device path, such as `/dev/ttyS0`.
   - `<as_top>` is a writable directory for the autosave files.

   `IOCSH_TOP` names the directory that holds `iocsh`, because
   `linStat.iocsh` loads its host and process sub-fragments from
   `$(IOCSH_TOP)/iocsh`. `iocLog.iocsh` loads first so that the log server
   receives the messages of the device setup that follows. `serial.iocsh`
   loads after the port it configures exists. Leave out the lines of any
   service the IOC does not use; to skip serial setup, leave out
   `SERIAL_ENABLE=`.

## Verification

With the log server of the prerequisites listening, boot the IOC of steps 1
to 6 and check its output:

1. Change to the boot directory of the IOC:

   ```bash
   cd <ioc_top>/iocBoot/<ioc_name>
   ```

   `<ioc_top>` is the top directory of the IOC application.

2. Start the IOC with `st.cmd`, write its output to `boot.log`, and let it
   exit at the end of input:

   ```bash
   ../../bin/linux-x86_64/demo st.cmd < /dev/null > boot.log 2>&1
   ```

3. Show the log client, serial, caPutLog, and autosave lines of the boot:

   ```bash
   grep -E 'log client|iocRun|caPutLog:|asynSetOption|afterIocRunning' boot.log
   ```

   The output of the IOC `iocdemo` is:

   ```
   log client: connected to log server at '<log_host>:7004'
   asynSetOption("S1", -1, "baud",   "19200")
   asynSetOption("S1", -1, "bits",   "8")
   asynSetOption("S1", -1, "stop",   "2")
   asynSetOption("S1", -1, "parity", "odd")
   afterIocRunning("caPutLogInit('<log_host>:7004', 0)")
   afterIocRunning("makeAutosaveFileFromDbInfo('<as_top>/iocdemo/req/settings.req','autosaveFields')")
   afterIocRunning("makeAutosaveFileFromDbInfo('<as_top>/iocdemo/req/values_pass0.req','autosaveFields_pass0')")
   afterIocRunning("makeAutosaveFileFromDbInfo('<as_top>/iocdemo/req/values_pass1.req','autosaveFields_pass1')")
   afterIocRunning("create_monitor_set('settings.req','5')")
   afterIocRunning("create_monitor_set('values_pass0.req','5')")
   afterIocRunning("create_monitor_set('values_pass1.req','10')")
   iocRun: All initialization complete
   sevr=info caPutLog: successfully initialized
   log client: connected to log server at '<log_host>:7004'
   afterIocRunning: caPutLogInit('<log_host>:7004', 0)
   afterIocRunning: makeAutosaveFileFromDbInfo('<as_top>/iocdemo/req/settings.req','autosaveFields')
   afterIocRunning: makeAutosaveFileFromDbInfo('<as_top>/iocdemo/req/values_pass0.req','autosaveFields_pass0')
   afterIocRunning: makeAutosaveFileFromDbInfo('<as_top>/iocdemo/req/values_pass1.req','autosaveFields_pass1')
   afterIocRunning: create_monitor_set('settings.req','5')
   afterIocRunning: create_monitor_set('values_pass0.req','5')
   afterIocRunning: create_monitor_set('values_pass1.req','10')
   7.0.10 > caPutLog: disabled
   ```

   The two `log client: connected` lines show that iocLog and caPutLog each
   reach the log server. The `asynSetOption` lines show that `serial.iocsh`
   ran the serial configuration file. The lines with `afterIocRunning(` are
   the commands that caPutLog and autosave register before `iocInit`, and the
   lines with `afterIocRunning:` show each one running after `iocInit`.
   `caPutLog: successfully initialized` shows that the logger started, and
   `caPutLog: disabled` shows it stopping when the IOC exits. The IOC writes
   to both standard output and standard error, so `boot.log` does not keep
   the order in which these lines run. Some of these lines carry terminal
   color codes, which the output above leaves out.
