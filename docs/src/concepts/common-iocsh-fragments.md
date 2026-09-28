# Common iocsh fragments

The common iocsh fragments are shell script files that set up site services
in an Experimental Physics and Industrial Control System (EPICS)
input/output controller (IOC). Each fragment takes its settings as macros,
so every IOC loads the same file with its own values.
[Load common iocsh fragments in an IOC](../procedures/load-common-iocsh-fragments.md)
uses them,
[Common iocsh fragment macros](../reference/common-iocsh-fragment-macros.md)
lists every macro, and
[Run the fragment verification suite](../procedures/run-fragment-verification-suite.md)
checks them against running IOCs.

## Fragment files and their services

The repository holds the fragments in `commonIocsh/iocsh`. Each service has
one fragment, except linStat and serial setup, which have more than one:

| Fragment | Service | Module the IOC links |
| --- | --- | --- |
| `iocLog.iocsh` | Sends the IOC error log to a log server | EPICS base |
| `caPutLog.iocsh` | Sends a record of each Channel Access (CA) put to a log server | caPutLog |
| `autosave.iocsh` | Saves record values and settings, and restores them at the next start | autosave |
| `reccaster.iocsh` | Publishes the IOC's record names to a recceiver service | recsync |
| `iocStatsAdmin.iocsh` | Loads the IOC status records of the iocStats module | iocStats |
| `linStat.iocsh` | Loads Linux host and process statistics through the four `linStat*.iocsh` sub-fragments | linStat |
| `serial.iocsh` | Loads a serial configuration file that the IOC owns | none |
| `setSerialParams.iocsh` | Sets the baud rate, data bits, stop bits, and parity of one asyn serial port | asyn |

## Installed location and the IOCSH_TOP macro

`make install` runs `install.commoniocsh`, which copies every
`commonIocsh/iocsh/*.iocsh` file to `modules/commonIocsh/iocsh` in the
installed tree. The directory name carries no version, so one installed tree
holds one fragment set.
[Installed tree and relocation](installed-tree.md) shows where the directory
sits in the tree.

An IOC names `modules/commonIocsh`, the directory that holds `iocsh`, in the
macro `IOCSH_TOP` and loads a fragment with `iocshLoad`:

```
iocshLoad("$(IOCSH_TOP)/iocsh/<fragment>.iocsh", "<macros>")
```

`<fragment>` is the file name without `.iocsh`, and `<macros>` is a
comma-separated list of `NAME=value` pairs. Neither the IOC build nor
`envPaths` sets `IOCSH_TOP`; the startup script sets it with `epicsEnvSet`,
or the IOC inherits it from the process environment.

`linStat.iocsh` relies on this form, because it loads its sub-fragments
from `$(IOCSH_TOP)/iocsh`:

```
iocshLoad("$(IOCSH_TOP)/iocsh/linStatHost.iocsh", "IOC=$(IOC)")
iocshLoad("$(IOCSH_TOP)/iocsh/linStatProc.iocsh", "IOC=$(IOC)")
```

The example IOC in `examples/commonIocsh` uses a form of its own. Its
startup script `caPutLog.cmd` receives the `iocsh` directory itself as
`IOCSH_TOP` and loads `$(IOCSH_TOP)/caPutLog.iocsh`.

## How a fragment receives its values

A fragment reads three kinds of values:

- **Module top macros.** `autosave.iocsh`, `reccaster.iocsh`,
  `iocStatsAdmin.iocsh`, and the linStat fragments read the install
  directory of their module from `AUTOSAVE`, `RECCASTER`, `devIocStats`, and
  `LINSTAT`. The IOC build writes `iocBoot/<ioc_name>/envPaths` with one
  `epicsEnvSet` line for each `configure/RELEASE` macro that names an
  existing directory. The startup script reads it with `< envPaths`, so each
  module macro in `configure/RELEASE` must use exactly these names.
- **The `IOC` macro.** Most fragments build record names and paths from
  `IOC`: record prefixes such as `$(IOC):`, the autosave directory
  `$(AS_TOP)/$(IOC)`, and the log prefix `proc=$(IOC)`. `envPaths` sets `IOC`
  to the name of the `iocBoot/<ioc_name>` subdirectory, and the startup
  script passes it on as `IOC=$(IOC)`.
- **Service settings.** Every other macro has a default written as
  `$(NAME=default)` in the fragment, or is required and has none.

`linStat.iocsh` and `serial.iocsh` have optional parts that an empty macro
turns on. The macros `NICENABLE`, `FSENABLE`, and `SERIAL_ENABLE` default to
`#--`, which turns the line that starts with them into an iocsh comment.
Passing the macro with an empty value, such as `NICENABLE=`, leaves the line
as a command:

```
$(NICENABLE=#--) iocshLoad("$(IOCSH_TOP)/iocsh/linStatNIC.iocsh", "IOC=$(IOC),NIC=$(NIC=)")
```

## Load order in the startup script

The fragments depend on the IOC state at the point where the startup script
loads them:

- The fragments load after `dbLoadDatabase` and the application's
  `registerRecordDeviceDriver` call. Most of them use commands and
  variables that the module database definition (DBD) files register, such
  as `asynSetOption` and `reccastTimeout`.
- Every fragment loads before `iocInit`. `dbLoadRecords` must run before
  `iocInit`, autosave restores its first pass during `iocInit`, and
  `afterIocRunning` accepts commands only before `iocInit`.
- `iocLog.iocsh` loads before any device setup. Its `iocLogInit` call
  registers the error log listener, and a message printed before that call
  does not reach the log server.
- `serial.iocsh` loads after `drvAsynSerialPortConfigure` creates each port
  that the serial configuration file names.
- `caPutLog.iocsh` needs an access security configuration file (ACF) that
  marks write access with `TRAPWRITE`. caPutLog receives puts only from that
  trap, and the IOC loads its own file with `asSetFilename` before `iocInit`.
  The fragment registers `caPutLogInit` with `afterIocRunning`, so the logger
  starts after `iocInit` completes.
- `autosave.iocsh` creates its directories with the iocsh `system` command,
  which exists only when the IOC includes `system.dbd` from EPICS base.

This ACF gives every client read access and traps every write:

```
ASG(DEFAULT) {
    RULE(1, READ)
    RULE(1, WRITE, TRAPWRITE)
}
```

## linStat entry fragment and sub-fragments

`linStat.iocsh` is the entry point for the linStat service. It always loads
`linStatHost.iocsh` and `linStatProc.iocsh`, and loads one
`linStatNIC.iocsh` and one `linStatFS.iocsh` when their enable macros are
empty. Each sub-fragment loads one database of the linStat module:

| Sub-fragment | Statistics | Record names |
| --- | --- | --- |
| `linStatHost.iocsh` | Host memory, processor, uptime, hardware sensors, and interrupts | `$(IOC):SYS_*`, `$(IOC):MEM_*`, `$(IOC):NET:HOST:*`, and others under `$(IOC):` |
| `linStatProc.iocsh` | Memory, file descriptors, threads, CA clients, and records of this IOC process | Under `$(IOC):` |
| `linStatNIC.iocsh` | One network interface | `$(IOC):NET:$(NIC):*` |
| `linStatFS.iocsh` | One mounted filesystem | `$(IOC):$(FSID):*` |

To monitor more than one network interface or filesystem, the startup script
loads `linStatNIC.iocsh` or `linStatFS.iocsh` once more for each one, with a
distinct `NIC` or `FSID`.

## iocStatsAdmin and linStat record name collisions

The database that `iocStatsAdmin.iocsh` loads, `iocAdminSoft.db`, shares
record names under `$(IOC):` with both linStat host and process databases.
`linStatHost.db`, which `linStatHost.iocsh` loads, defines these names with a
different record type:

- `$(IOC):CPU_CNT`
- `$(IOC):MEM_FREE`
- `$(IOC):MEM_MAX`
- `$(IOC):MEM_USED`
- `$(IOC):SYS_CPU_LOAD`

`linStatProc.db`, which `linStatProc.iocsh` loads, defines more names with a
different record type, such as `$(IOC):FD_CNT`, `$(IOC):IOC_CPU_LOAD`, and
`$(IOC):SYSRESET`.

When both services load with the same `IOC` value, `dbLoadRecords` reports
`already exists` for each name with a different record type. It then
reports `Failed to load` for `linStatHost.db` and `linStatProc.db`. A name
that both databases define with the same record type merges into one record
without an error, such as `$(IOC):HOSTNAME`, `$(IOC):KERNEL_VERS`, and
`$(IOC):TOD` of `linStatHost.db`. An IOC therefore loads either linStat or
iocStatsAdmin under one prefix. The integrated check of the verification
suite loads linStat and leaves out iocStatsAdmin.

`iocStatsAdmin.iocsh` also limits the length of `IOC` to 21 characters. Its
longest record name adds 39 characters to `$(IOC)`, and an EPICS record name
holds at most 60 characters.
