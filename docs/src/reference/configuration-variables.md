# Configuration variables and override files

EPICS-env reads its settings from make variables when it builds the Experimental Physics and Industrial Control System (EPICS) base and modules. The defaults live in
tracked files under `configure/`; a site changes them in untracked `.local`
files, so the tracked files stay unchanged.

## Override files and read order

`configure/CONFIG` reads `configure/RELEASE` first and `configure/CONFIG_SITE`
second. Each file then reads its two override files, and a later file wins:

| Tracked file | Override files, in the order read |
| --- | --- |
| `configure/RELEASE` | `../RELEASE.local` (next to the repository), then `configure/RELEASE.local` |
| `configure/CONFIG_SITE` | `../CONFIG_SITE.local` (next to the repository), then `configure/CONFIG_SITE.local` |

Creating, editing, or removing either `RELEASE.local` override regenerates
`configure/MODULESGEN.mk` on the next make invocation when the effective
module triples change. Generated install directories follow the effective
`SRC_VER_<MODULE_KEY>` values without a manual `reconf.modules` step.

The variables that `configure/CONFIG_BASE` defines with `?=` accept a value
set in a `CONFIG_SITE.local` file, in the environment, or on the make command
line. `LINKER_USE_RPATH` uses `:=`, so only a value on the make command line
replaces it. Every EPICS base and module build receives `LINKER_ORIGIN_ROOT`
set to `INSTALL_LOCATION_EPICS` on its own command line, so no value set for
`LINKER_ORIGIN_ROOT` reaches a build.

`conf.release.modules` writes `RELEASE.local` and `CONFIG_SITE.local` at the
repository top for the modules to read. EPICS-env itself does not read those
two files, and each `make conf` overwrites them.

## Install location and release

| Variable | Default | Set in | Meaning |
| --- | --- | --- | --- |
| `INSTALL_LOCATION` | `${HOME}/epics` | `CONFIG_SITE.local` | Root of every installed tree |
| `ENV_RELEASE_VERS` | `1.4.0` | `CONFIG_SITE.local` | EPICS-env release number; the second level of the installed tree |

The installed tree for one host is
`$(INSTALL_LOCATION)/$(ENV_RELEASE_VERS)/<os_id>-<os_version>/$(SRC_VER_BASE)`.
`<os_id>` and `<os_version>` are the operating system `ID` and `VERSION_ID` from `/etc/os-release`.
This command prints that path for the current host:

```bash
make print-INSTALL_LOCATION_EPICS
```

When make cannot create `INSTALL_LOCATION` as the current user, it runs the
module build and install steps, the module links, and the `commonIocsh`
install through `sudo`. The EPICS base build and install and the `.versions`
install do not use `sudo`, so `INSTALL_LOCATION` must be writable by the
current user for a complete install.

## Source repositories and pins

| Variable | Default | Set in | Meaning |
| --- | --- | --- | --- |
| `SRC_URL_BASE` | `https://github.com/epics-base` | `RELEASE.local` | Organization that hosts EPICS base |
| `SRC_URL_EPICSMODULES` | `https://github.com/epics-modules` | `RELEASE.local` | Default organization for modules |
| `SRC_URL_<ORG>` | One GitHub organization each | `RELEASE.local` | Organizations for modules hosted elsewhere: `CHANNELFINDER`, `JEONGHANLEE`, `BRUNOSEIVAM`, `PSI`, `MOTOR`, `MD`, `BERKELEYLAB`, `PMAC` |
| `SRC_NAME_BASE` | `epics-base` | `RELEASE.local` | EPICS base repository name |
| `SRC_TAG_BASE` | `tags/R7.0.10` | `RELEASE.local` | EPICS base tag to check out |
| `SRC_VER_BASE` | `7.0.10` | `RELEASE.local` | EPICS base version; the last level of the installed tree |
| `SRC_NAME_<MODULE_KEY>` | Per module | `RELEASE.local` | Module repository name |
| `SRC_TAG_<MODULE_KEY>` | Per module | `RELEASE.local` | Module tag or commit to check out |
| `SRC_VER_<MODULE_KEY>` | Per module | `RELEASE.local` | Module version; part of the module install directory name |

[Module pins and dependencies](module-pins.md) lists the value of every `<MODULE_KEY>`.

## Vendor library locations

| Variable | Default | Set in | Meaning |
| --- | --- | --- | --- |
| `VENDOR_ULDAQ_PATH` | `/usr/local` | `RELEASE.local` | Install prefix of the uldaq library that `measComp` links |
| `OPEN62541_PATH` | `/usr/local` | `RELEASE.local` | Install prefix of the open62541 library that `opcua` links |

## EPICS base site settings

`conf.base.env` writes these values into
`epics-base-src/configure/CONFIG_SITE_ENV`, so they become the defaults of
every input/output controller (IOC) built against the installed base.

EPICS base compiles `CONFIG_SITE_ENV` into its `libCom` library, so a changed
value takes effect only after `make conf.base`, `make build.base`, and
`make install.base` run again.

| Variable | Default | Meaning |
| --- | --- | --- |
| `EPICS_TZ` | `"PST8PDT,M3.2.0/2,M11.1.0/2"` | Time zone rule |
| `EPICS_TS_NTP_INET` | `time.google.com` | Network Time Protocol (NTP) server |
| `IOCSH_PS1` | `"<base_version> > "` | iocsh prompt |
| `IOCSH_HISTSIZE` | `50` | Lines of iocsh command history |
| `IOCSH_HISTEDIT_DISABLE` | empty | Disables line editing in iocsh when set |
| `EPICS_IOC_LOG_INET` | empty | IOC log server address |
| `EPICS_IOC_LOG_FILE_NAME` | empty | IOC log file path |
| `EPICS_IOC_LOG_FILE_COMMAND` | empty | Command that returns a log file path after `SIGHUP` |
| `EPICS_IOC_LOG_FILE_LIMIT` | `1000000` | IOC log file size limit |

`conf.base.site` writes these values into
`epics-base-src/configure/CONFIG_SITE.local`:

| Variable | Default | Meaning |
| --- | --- | --- |
| `CROSS_COMPILER_TARGET_ARCHS` | empty | Cross target architectures for EPICS base |
| `EPICS_SITE_VERSION` | `"github.com/jeonghanlee/EPICS-env"` | Site version string built into EPICS base |
| `EPICS_VCS_VERSION` | `"EPICS-env-<base_version>-<git_describe>"` | Version string written as `GENVERSIONDEFAULT` |

## Variables set on the command line

| Variable | Default | Used by | Meaning |
| --- | --- | --- | --- |
| `VERBOSE` | unset | Every target | Prints recipe commands when set |
| `DEBUG_SHELL` | unset | Every target | Runs recipes under `/bin/sh -x` when set |
| `FILTER` | `1` (no filter) | `vars` | Prints only variables whose names start with the given prefix |
| `LEVEL` | `2` | `exist`, `exist.modules`, `tree.<VARIABLE>` | Tree depth |
| `LSOPTS` | unset | `ls.<VARIABLE>` | Options passed to `ls` |
| `MODULE` | empty (all) | `audit.module-deps`, `check.module-deps` | Audits one module |
| `FORMAT` | `text` | `audit.module-deps`, `check.module-deps` | Report format: `text` or `json` |
| `PLATFORM` | output of `uname -s` | `audit.module-deps`, `check.module-deps` | With `Linux`, dependencies found under a module's `os/Linux`, `os/posix`, and `os/default` directories count as required; with any other value they count as optional |
