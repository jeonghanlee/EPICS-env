# Common iocsh fragment macros

Each common iocsh fragment in `modules/commonIocsh/iocsh` takes its settings
as macros in the second argument of `iocshLoad`. An input/output controller
(IOC) of the Experimental Physics and Industrial Control System (EPICS) sets
`IOCSH_TOP` to `modules/commonIocsh` and loads a fragment as
`iocshLoad("$(IOCSH_TOP)/iocsh/<fragment>.iocsh", "<macros>")`.
A default in the tables below applies when the IOC does not pass the macro.
[Common iocsh fragments](../concepts/common-iocsh-fragments.md) explains the
macro sources and the load order.

## Module and database definition requirements

Each fragment needs support that the IOC links and registers. `Module top
macro` is the `configure/RELEASE` macro that the fragment reads through
`envPaths`. `DBD files` are the database definition (DBD) files that the IOC
includes, and `Library` is the library it links. The `libCom` library of
EPICS base registers the iocsh commands that `iocLog.iocsh` calls, so that
fragment needs no DBD file:

| Fragment | Module top macro | DBD files | Library |
| --- | --- | --- | --- |
| `autosave.iocsh` | `AUTOSAVE` | `asSupport.dbd`, `system.dbd` | `autosave` |
| `caPutLog.iocsh` | none | `caPutLog.dbd` | `caPutLog` |
| `iocLog.iocsh` | none | none | `Com` of EPICS base |
| `iocStatsAdmin.iocsh` | `devIocStats` | `devIocStats.dbd` | `devIocStats` |
| `linStat.iocsh` and `linStat*.iocsh` | `LINSTAT` | `linStat.dbd` | `linStat` |
| `reccaster.iocsh` | `RECCASTER` | `reccaster.dbd` | `reccaster` |
| `serial.iocsh` | none | none | none |
| `setSerialParams.iocsh` | none | `asyn.dbd`, `drvAsynSerialPort.dbd` | `asyn` |

## Macros for autosave.iocsh

`autosave.iocsh` sets the save and request file paths to
`$(AS_TOP)/$(IOC)/save` and `$(AS_TOP)/$(IOC)/req` and creates both
directories. It loads `$(AUTOSAVE)/db/save_restoreStatus.db` with the prefix
`$(IOC)-as:`. The first restore pass reads the settings and pass 0 files,
and the second reads the settings and pass 1 files. After `iocInit`, it
writes a request file for each group from the `autosaveFields`,
`autosaveFields_pass0`, and `autosaveFields_pass1` info tags and starts a
monitor set for each.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Status record prefix `$(IOC)-as:` and the per-IOC directory under `AS_TOP` |
| `AS_TOP` | Required | Writable root directory of the save and request files |
| `AUTOSAVE` | Required; from `envPaths` | Install directory of the autosave module |
| `INCOMPLETE` | `1` | Restores and saves a group even when some of its values are missing |
| `CA_RECONNECT` | `1` | Retries the connection to a process variable whose first connection failed |
| `DATED_BACKUP` | `1` | Writes dated backup files |
| `NUM_SEQ` | `3` | Number of sequenced backup files |
| `SEQ_PERIOD` | `300` | Seconds between sequenced backups |
| `SETTINGS_FILES` | `settings` | Base name of the settings group files |
| `VALUES_FILES_PASS0` | `values_pass0` | Base name of the pass 0 value group files |
| `VALUES_FILES_PASS1` | `values_pass1` | Base name of the pass 1 value group files |
| `SETTINGS_PERIOD` | `5` | Seconds between saves of the settings group |
| `VALUES_PASS0_PERIOD` | `5` | Seconds between saves of the pass 0 value group |
| `VALUES_PASS1_PERIOD` | `10` | Seconds between saves of the pass 1 value group |
| `DEAD_SECONDS` | `5` | `DEAD_SECONDS` value of `save_restoreStatus.db` |

## Macros for caPutLog.iocsh

`caPutLog.iocsh` registers
`caPutLogInit('$(LOG_INET):$(LOG_INET_PORT)', $(OPTION))` with
`afterIocRunning`, so the logger starts after `iocInit` completes. The IOC
supplies an access security configuration file that marks writes with
`TRAPWRITE`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `LOG_INET` | Required | Address of the log server that receives put records |
| `LOG_INET_PORT` | `7004` | Transmission Control Protocol (TCP) port of the log server |
| `OPTION` | `0` | `-1` disables logging; `0` logs value changes; `1` logs every put, including an unchanged value; `2` logs every put without combining bursts on one field |

## Macros for iocLog.iocsh

`iocLog.iocsh` sets the environment variables `EPICS_IOC_LOG_INET`,
`EPICS_IOC_LOG_PORT`, and `iocLogDisable`. It then sets the message prefix
to `fac=$(FACNAME) proc=$(IOC)` and calls `iocLogInit`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Name after `proc=` in each message |
| `LOG_INET` | Required | Address of the log server; written to `EPICS_IOC_LOG_INET` |
| `LOG_INET_PORT` | `7004` | TCP port of the log server; written to `EPICS_IOC_LOG_PORT` |
| `LOGDISABLE` | `0` | Written to the environment variable `iocLogDisable`; EPICS base reads its `iocLogDisable` program variable instead, so this value does not turn logging off |
| `FACNAME` | empty | Facility name after `fac=` in each message |

## Macros for iocStatsAdmin.iocsh

`iocStatsAdmin.iocsh` loads `$(devIocStats)/db/iocAdminSoft.db` with
`IOC=$(IOC)`. It creates records such as `$(IOC):ACCESS`,
`$(IOC):HEARTBEAT`, `$(IOC):STARTTOD`, and `$(IOC):UPTIME`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix; at most 21 characters |
| `devIocStats` | Required; from `envPaths` | Install directory of the iocStats module |

## Macros for linStat.iocsh

`linStat.iocsh` loads `linStatHost.iocsh` and `linStatProc.iocsh` from
`$(IOCSH_TOP)/iocsh` with `IOC=$(IOC)`. It also loads `linStatNIC.iocsh`
when `NICENABLE` is empty, and `linStatFS.iocsh` when `FSENABLE` is empty.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix, passed to every sub-fragment |
| `LINSTAT` | Required; from `envPaths` | Install directory of the linStat module |
| `IOCSH_TOP` | Required | Directory that holds the `iocsh` directory of the fragments, such as `<installed_tree>/modules/commonIocsh`; the sub-fragments load from `$(IOCSH_TOP)/iocsh` |
| `NICENABLE` | `#--` | Set to empty to load `linStatNIC.iocsh` for one network interface |
| `NIC` | empty | Network interface name, such as `eth0`; required when `NICENABLE` is empty |
| `FSENABLE` | `#--` | Set to empty to load `linStatFS.iocsh` for one filesystem |
| `FSID` | empty | Unique tag of the filesystem, such as `ROOT`; required when `FSENABLE` is empty |
| `DIR` | empty | Mount path of the filesystem, such as `/`; required when `FSENABLE` is empty |

## Macros for linStatHost.iocsh

`linStatHost.iocsh` loads `$(LINSTAT)/db/linStatHost.db` with `IOC=$(IOC)`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix |
| `LINSTAT` | Required; from `envPaths` | Install directory of the linStat module |

## Macros for linStatProc.iocsh

`linStatProc.iocsh` loads `$(LINSTAT)/db/linStatProc.db` with `IOC=$(IOC)`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix |
| `LINSTAT` | Required; from `envPaths` | Install directory of the linStat module |

## Macros for linStatNIC.iocsh

`linStatNIC.iocsh` loads `$(LINSTAT)/db/linStatNIC.db` with `IOC=$(IOC)` and
`NIC=$(NIC)`. The records are named `$(IOC):NET:$(NIC):*`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix |
| `NIC` | Required | Network interface name, such as `eth0` |
| `LINSTAT` | Required; from `envPaths` | Install directory of the linStat module |

## Macros for linStatFS.iocsh

`linStatFS.iocsh` loads `$(LINSTAT)/db/linStatFS.db` with
`P=$(IOC):$(FSID)`, `DIR=$(DIR)`, and `PERIOD=$(PERIOD)`. The records are
named `$(IOC):$(FSID):*`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix |
| `FSID` | Required | Unique tag of the filesystem, such as `ROOT` |
| `DIR` | Required | Mount path of the filesystem, such as `/` |
| `PERIOD` | `10` | Scan period in seconds |
| `LINSTAT` | Required; from `envPaths` | Install directory of the linStat module |

## Macros for reccaster.iocsh

`reccaster.iocsh` sets the reccaster variables `reccastTimeout` and
`reccastMaxHoldoff`. It loads `$(RECCASTER)/db/reccaster.db` with
`P=$(IOC):`, which creates `$(IOC):State-Sts` and `$(IOC):Msg-I`.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `IOC` | Required | Record name prefix |
| `RECCASTER` | Required; from `envPaths` | Install directory of the recsync module |
| `RECCAST_TIMEOUT` | `20.0` | Client timeout in seconds; written to `reccastTimeout` |
| `RECCAST_MAX_HOLDOFF` | `10.0` | Maximum holdoff in seconds; written to `reccastMaxHoldoff` |

## Macros for serial.iocsh

`serial.iocsh` loads the file named in `SERIAL_CONFIG` with `iocshLoad` when
`SERIAL_ENABLE` is empty. That file belongs to the IOC and loads
`setSerialParams.iocsh` once for each serial port. When `SERIAL_ENABLE` is
not passed, the line is a comment, and iocsh prints that `SERIAL_CONFIG` is
undefined. A `SERIAL_CONFIG` path that cannot be read makes iocsh print
`Can't open <path>`, and the startup script continues.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `SERIAL_ENABLE` | `#--` | Set to empty to load the serial configuration file |
| `SERIAL_CONFIG` | Required when `SERIAL_ENABLE` is empty | Path of the serial configuration file |

## Macros for setSerialParams.iocsh

`setSerialParams.iocsh` calls `asynSetOption` for `baud`, `bits`, `stop`,
and `parity` on one asyn port, with address `-1`. It does not set hardware
or software flow control.

| Macro | Required or default | Meaning |
| --- | --- | --- |
| `PORT` | Required | asyn port name that `drvAsynSerialPortConfigure` created |
| `BAUD` | `9600` | Baud rate |
| `BITS` | `8` | Data bits: `5`, `6`, `7`, or `8` |
| `STOP` | `1` | Stop bits: `1` or `2` |
| `PARITY` | `none` | Parity: `none`, `odd`, or `even` |
