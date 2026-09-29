# Module set and dependencies

The module set is the list of Experimental Physics and Industrial Control
System (EPICS) modules that EPICS-env clones, configures, builds, and
installs beside EPICS base. The configuration files define it: `configure/RELEASE`
names each module and its pin, `configure/CONFIG_MODS` sets where each module
comes from, `configure/CONFIG_MODS_TYPES` declares each configuration type, and
`configure/CONFIG_MODS_DEPS` records its build dependencies and optional
configuration settings.
[Module pins and dependencies](../reference/module-pins.md) lists the values
for every module, and
[Add or bump a module](../procedures/add-or-bump-module.md) changes them.

## Module declaration by RELEASE triples

Each module has a module key, an upper-case name such as `ASYN` or `SNCSEQ`.
`configure/RELEASE` defines three variables per key:

| Variable | Meaning | Example for `ASYN` |
| --- | --- | --- |
| `SRC_NAME_<MODULE_KEY>` | Repository name; also the source directory name without `-src` | `asyn` |
| `SRC_TAG_<MODULE_KEY>` | Tag or commit to check out | `tags/R4-46` |
| `SRC_VER_<MODULE_KEY>` | Version in the install directory name | `4.46.0` |

The set holds every key whose `SRC_NAME_<MODULE_KEY>` variable a file
defines; `SRC_NAME_BASE` names EPICS base and stays outside the set. A
`SRC_NAME_<MODULE_KEY>` value from the environment or the make command line
does not add a module. A `RELEASE.local` file can override a triple;
[Configuration variables and override files](../reference/configuration-variables.md#override-files-and-read-order)
gives the read order.

From the triple, make derives three names for each module:

- The source tree `<name>-src` at the repository top, such as `asyn-src`.
  `recsync` builds from `recsync-src/client`.
- The install directory `modules/<name>-<version>` in the installed tree,
  such as `modules/asyn-4.46.0`.
- The target suffix `<name>`, as in `build.asyn` and `install.asyn`.

## Generated module variables in MODULESGEN.mk

`configure/CONFIG_MODS` derives module variables from the effective pins.
Actions include `configure/MODULESGEN.mk`, a generated file Git ignores.
Query-only invocations derive the same variables in memory without reading
or writing that cache. For each module key, the derivation supplies three variables:

| Variable | Value |
| --- | --- |
| `SRC_GITURL_<MODULE_KEY>` | The value of `SRC_URL_EPICSMODULES`, expanded when make writes the file, followed by `/<name>`, such as `https://github.com/epics-modules/asyn` |
| `INSTALL_LOCATION_<MODULE_KEY>` | `$(INSTALL_LOCATION_MODS)/<name>-<version>`; `$(INSTALL_LOCATION_MODS)/seq-<version>` for the sequencer |
| `SRC_PATH_<MODULE_KEY>` | `<name>-src` |

An action invocation generates the file when it is absent, or when
`configure/RELEASE` or `configure/CONFIG_SITE` carries a later modification
time. The file also records the effective module triples used to generate it.
Make regenerates it when those values change, including after creating,
editing, or removing `configure/RELEASE.local` or `../RELEASE.local`.
Make reads the regenerated file in the same run, so the install directories
follow the effective pins. An unchanged action invocation preserves the cache. Query-only invocations
use current settings even when the cache is absent or stale; they preserve
its bytes and modification time.

`make show.genmk` displays the existing cache, including stale values.
When the cache is absent, it prints the current generated configuration
without creating a file. It also displays other existing `configure/*.mk` files.

`make reconf.modules` explicitly removes the generated files under
`configure/` and regenerates `MODULESGEN.mk` from the current settings.

## Repository overrides in CONFIG_MODS

The generated repository address of every module points at
`https://github.com/epics-modules`. After it derives or reads the module variables,
`configure/CONFIG_MODS` replaces that address for the twelve modules hosted
elsewhere:

| Organization variable | Modules |
| --- | --- |
| `SRC_URL_BASE` | pvxs |
| `SRC_URL_CHANNELFINDER` | recsync |
| `SRC_URL_BRUNOSEIVAM` | retools |
| `SRC_URL_PSI` | StreamDevice |
| `SRC_URL_JEONGHANLEE` | snmp, QPC, rgamv2 |
| `SRC_URL_MOTOR` | motorMotorSim |
| `SRC_URL_PMAC` | pmac |
| `SRC_URL_MD` | pscdrv, linStat |
| `SRC_URL_BERKELEYLAB` | feed-core |

A module outside `epics-modules` therefore needs both its triple in
`configure/RELEASE` and one override line in `configure/CONFIG_MODS`.

## Build order from declared dependencies

`configure/CONFIG_MODS_DEPS` defines one `<module>_DEPS` variable per module.
Its value is `null.base`, an empty target that stands for EPICS base,
followed by one `build.<module>` entry for each module that must build
first:

```makefile
asyn_DEPS:=null.base build.sequencer build.sscan build.calc
```

Make turns each `<module>_DEPS` value into the prerequisites of
`build.<module>`, which gives the dependency order of
[the build stage](build-pipeline.md#module-builds-in-dependency-order).
The `Depends on` column of
[Module repositories and pins](../reference/module-pins.md#module-repositories-and-pins)
shows the same graph.

`<module>_DEPS` is also the declared dependency list that `check.module-deps`
compares with the references it finds in each module's source tree.
[Build and install verification gates](verification-gates.md#static-module-dependency-audit)
describes that comparison.

## Configuration types auto and custom

`configure/CONFIG_MODS_TYPES` declares each module's `<module>_CONF_TYPE`, with the
value `auto` or `custom`. The type decides where its `conf.<module>` target
comes from.

An `auto` module gets a generated `conf.<module>` target. That target writes
one line to the module's `configure/CONFIG_SITE.local`: `INSTALL_LOCATION`
set to the module's install directory. Three optional variables extend it:

| Variable | Effect | Module that sets it |
| --- | --- | --- |
| `<module>_CONF_RELEASE_LINES` | Writes the value to `configure/RELEASE.local` | `iocStats` |
| `<module>_CONF_SITE_LINES` | Appends the value to `configure/CONFIG_SITE.local` | `retools` |
| `<module>_CONF_PLATFORM` | Runs the target only when `uname -s` prints this value | `MCoreUtils` |

The `auto` modules are `MCoreUtils`, `autosave`, `caPutLog`, `ether_ip`,
`iocStats`, `pcas`, `pscdrv`, `retools`, and `snmp`. A `custom` module has a
hand-written `conf.<module>` target in `configure/RULES_MODS_CONFIG`, which
can write any site setting the module needs.

Make checks the declarations each time it reads the makefiles, before it runs
any target:

- Every module in the set must declare `<module>_CONF_TYPE`, and the value
  must be `auto` or `custom`.
- Every `auto` module must have a source path, and exactly one install
  directory name in the module set must start with `<module>-`.

A failed check stops every make command, including
`distclean.modulesgen`, with a message such as
`Missing foo_CONF_TYPE declaration`. The message names the recovery for a
stale generated file: remove `configure/MODULESGEN.mk` with `rm` and run make
again.

## Dependency paths through RELEASE.local

A module learns where EPICS base and its dependencies are installed from
`RELEASE.local` files that the configuration writes.

`conf.release.modules` writes two files at the repository top, one directory
above every module source tree:

- `RELEASE.local` sets `EPICS_BASE` to the installed `base` directory and
  clears `SUPPORT`.
- `CONFIG_SITE.local` sets `CHECK_RELEASE = NO` and adds
  `-Wl,--enable-new-dtags` to `PROD_LDFLAGS`.

A module whose `configure/RELEASE` reads `$(TOP)/../RELEASE.local`, and whose
`configure/CONFIG_SITE` reads `$(TOP)/../CONFIG_SITE.local`, picks up both
files; `asyn` and `autosave` read them this way.

Most `custom` targets for modules with dependencies write the install
directory of each dependency into the module's own
`configure/RELEASE.local`. `conf.asyn`, for example,
writes `SNCSEQ`, `SSCAN`, and `CALC`, each set to the absolute path of a
versioned directory, such as `/home/user/epics/1.4.0/debian-13/7.0.10/modules/seq-2.2.9`.
Two targets write other files:
`conf.motorMotorSim` writes the module's `configure/RELEASE` and
`configure/CONFIG_SITE`, and `conf.pmac` writes its `configure/CONFIG_SITE`
and `configure/RELEASE.local`.

The dependencies a `custom` target writes form a list separate from
`<module>_DEPS`. `check.module-deps` reads the written `RELEASE.local` as
evidence and reports where the two lists disagree.

These generated dependency paths name versioned directories, so a module
links against the dependency version the module set pins.

QPC inherits `ASYN=$(EPICS_BASE)/../modules/asyn` from its own
`configure/RELEASE`; `conf.QPC` writes only `CONFIG_SITE.local`.
Its active `digitelQpcApp` tree installs data and IOC fragments and declares
no library or executable. The installed `gamma-pctrl.iocsh` fragment uses
the consuming IOC's `ASYN` macro to locate `asynRecord.db` at startup.
That runtime macro is separate from QPC's inherited, unversioned build setting.

## Sequencer installed as seq

The sequencer module carries several names:

| Use | Name |
| --- | --- |
| Module key | `SNCSEQ` |
| Repository and source tree | `sequencer`, `sequencer-src` |
| Build and install targets | `build.sequencer`, `install.sequencer` |
| Configuration target | `conf.sncseq` |
| Install directory and unversioned link | `modules/seq-<version>`, `modules/seq` |

`configure/CONFIG_VARS` maps `sequencer` to `seq` for the install directory
and the link. The mapping ignores a `SRC_NAME_SNCSEQ` value from the
environment or the command line. The dependency audit treats `SNCSEQ`,
`seq`, and `pv` as references to `sequencer`.

## MCoreUtils on Linux only

`configure/RELEASE` defines the `MCOREUTILS` triple only when `uname -s`
prints `Linux`. On any other system, MCoreUtils is absent from the module
set, so make generates no clone, build, or install target for it. Its
`auto` configuration target also carries `Linux` as its platform.
