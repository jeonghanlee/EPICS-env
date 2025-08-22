# EPICS Configuration Environment

## Reference
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8248353.svg)](https://doi.org/10.5281/zenodo.8248353)

## Github Actions
[![Debian 12](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml)
[![Rocky 9](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky9.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky9.yml)
[![Linux Build](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml)
[![Ubuntu 22.04](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu22.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu22.yml)
[![Linter Run](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml)
## Introduction
This is the EPICS base and various modules Configuration Environment for the ALS-U project and my purpose. There are plenty of diverse ways we can do this. However, it is designed for me to minimize my limited resources to support the reproducible EPICS environment in various platforms. I want to use almost pure Makefile instead of packages, and continuous integration tools, such as Ansible, Conda, Puppet, and even shell scripts. Unfortunately, I used "shell tricks" within Makefile rules, but I tried to use the generic Makefile rules as much as possible. I want a system that works without looking for their dependencies over the next ten years.


## Tested

### Focus

* Debian 12 (Bookworm)
* Rocky 8   (Green Obsidian)

### Eye
* Debian 13 (Trixie)
* Rocky 9 (Blue Onyx)

### Others
* Please check `github` action for the further supported OSs

## TL;DR
That you know, one should install all relevant packages for the EPICS base and modules.

* Note that due to `measComp`, one needs to set up a vendor library. Please check https://github.com/jeonghanlee/uldaq-env.
* Note that due to `opcua`, one needs to set up a `OPEN62541` library. Please check https://github.com/jeonghanlee/open62541-env.
* Note that due to `pvxs`, one needs to run `make symlinks` mandatory. It allows us to use the proper path for pvxs executable files and libraries with the environment. We use the system library `libevnet` instead of the pvxs bundle.

```bash
make init
make patch
make conf
make build
make install
make symlinks
make exist
source ${HOME}/epics/1.1.1/debian-12/7.0.7/setEpicsEnv.bash
softIoc
```

## Base and Modules

All version information is defined in `configure/RELEASE`, and include the following EPICS base and modules:

```bash
$ make vars FILTER=SRC_NAME_

------------------------------------------------------------
>>>>          Current Envrionment Variables             <<<<
------------------------------------------------------------

SRC_NAME_ASYN = asyn
SRC_NAME_AUTOSAVE = autosave
SRC_NAME_BASE = epics-base
SRC_NAME_BUSY = busy
SRC_NAME_CALC = calc
SRC_NAME_CAPUTLOG = caPutLog
SRC_NAME_ETHERIP = ether_ip
SRC_NAME_IOCSTATS = iocStats
SRC_NAME_LUA = lua
SRC_NAME_MCA = mca
SRC_NAME_MCOREUTILS = MCoreUtils
SRC_NAME_MEASCOMP = measComp
SRC_NAME_MODBUS = modbus
SRC_NAME_MOTOR = motor
SRC_NAME_MOTORSIM = motorMotorSim
SRC_NAME_OPCUA = opcua
SRC_NAME_PCAS = pcas
SRC_NAME_PMAC = pmac
SRC_NAME_PSCDRV = pscdrv
SRC_NAME_PVXS = pvxs
SRC_NAME_RECSYNC = recsync
SRC_NAME_RETOOLS = retools
SRC_NAME_SCALER = scaler
SRC_NAME_SNCSEQ = sequencer
SRC_NAME_SNMP = snmp
SRC_NAME_SSCAN = sscan
SRC_NAME_STREAM = StreamDevice

$ make vars FILTER=SRC_TAG_

------------------------------------------------------------
>>>>          Current Envrionment Variables             <<<<
------------------------------------------------------------

SRC_TAG_ASYN = tags/R4-45
SRC_TAG_AUTOSAVE = 0bfbf3c
SRC_TAG_BASE = tags/R7.0.7
SRC_TAG_BUSY = 2dfe92d
SRC_TAG_CALC = f6a39b6
SRC_TAG_CAPUTLOG = 73b9e10
SRC_TAG_ETHERIP = 22fa868
SRC_TAG_IOCSTATS = 7dc2557
SRC_TAG_LUA = 17475b5
SRC_TAG_MCA = f3f9b67
SRC_TAG_MCOREUTILS = tags/1.2.2
SRC_TAG_MEASCOMP = tags/R4-3
SRC_TAG_MODBUS = tags/R3-4
SRC_TAG_MOTOR = 26efd2f
SRC_TAG_MOTORSIM = d1d0eb8
SRC_TAG_OPCUA = tags/v0.11.0
SRC_TAG_PCAS = 4f60f2d
SRC_TAG_PMAC = 2-6-5
SRC_TAG_PSCDRV = 1ed650d
SRC_TAG_PVXS = 04047e7
SRC_TAG_RECSYNC = 1.7
SRC_TAG_RETOOLS = 5ada1e1
SRC_TAG_SCALER = beb5521
SRC_TAG_SNCSEQ = tags/R2-2-9
SRC_TAG_SNMP = tags/v1.1.0.4ja
SRC_TAG_SSCAN = 6cf6740
SRC_TAG_STREAM = tags/2.8.26
```

## BASE Setup

```bash
make init.base
make conf.base
make conf.base.show
make patch.base      : if it is necessary.
make build.base
make install.base
make clean.base
make distclean.base  : this will delete the download source directory
make exist
```

## EPICS Modules Setup

```bash
make init.modules
make conf.modules
make clean.modules
make build.modules
make install.modules
make clean.modules
make distclean.modules
make exist.modules
```

```bash
$ make exist.modules
```

```bash
$ make symlinks.modules
$ make exist.modules LEVEL=0
```

* additional makefile rules

```bash
make exist             : Show Base and Modules Installation Path  (one can use `LEVEL` argument, e.g., `make exist LEVEL=4`)
make init.modules      : Generate dynamic modules variables and clone all
make conf.modules      : Make conf.modules.show will print out all local configuration files.
make conf.modules.show : Show all local configurations (RELEASE.local, CONFIG_SITE.local, and so on)
make clean.modules     : Some modules have the infinite compiling loop, so we have to clean up existing things within git repositories.
make build.modules     : Build and install each module into its installation location
make install.modules   : We may not need this rule because of the standard EPICS building system default could be to build and install
make uninstall.modules : Execute uninstall within each module source, and remove the installed module directory.
make exist.modules     : Show where the modules are installed.
make vars              : Print all important variables
make PRINT._var_name   : Print the selected variable
make symlinks.modules   : Create / Overwrite symbolic links for all modules defined within active configuration. Remove all dead links.
```

* Delete all download sources

```bash
make distclean.modules
```

## A Module Setup

If we define each module properly, all module build rules are generated automatically. For example,

```bash
make build.iocStats

make clean.StreamDevice

make install.asyn

```

The rule name is used in the form as

```bash
build_name.module_name
```

where `build_name` is one of `build`, `install`, `clean`, and `uninstall` And `module_name` is the module directory name without `-src` suffix.

