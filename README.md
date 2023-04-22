# EPICS Configuration Enviornment
[![Linux Build](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml)
[![macOS build](https://github.com/jeonghanlee/EPICS-env/actions/workflows/macos.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/macos.yml)
[![Linter Run](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml)
[![Docker Image CI](https://github.com/jeonghanlee/EPICS-env/actions/workflows/docker-image.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/docker-image.yml)

This is the EPICS Configuration Environment for my personal purpose. There are a plenty of diverse ways we can do. However, it is designed for me to minimize my limited resources to support the reproduceable EPICS environment. I would like to use almost pure Makefile instead of packages, continuous integration tools, such as Ansible, Conda, Puppet, and even shell scripts. Unfortunately, I used "shell tricks" a bit within Makefile rules, but I tried to use the generic Makefile rules as much as I can.

## Tested
* Debian 10/11 (Physical Installation)
* Fedora 32 (Docker)
* CentOS 7 (Docker)
* Scientific Linux 7 (Docker)
* CentOS 8 (Docker, VirtualBox VM, Physical Installation)
* Rocky 8 (Docker, Physical Installation)
* Rocky 9 (Docker, Physical Installation) - WIP
* Alma 8 (Docker)
* Ubuntu 18.04/20.04 (Github Action) / Ubuntu 20 (VirtualBox VM)
* Raspbian GNU/Linux 10 (Physical Installation)
* macOS 12.0.1 (21A559) (Physical Installation)
* macOS 11.1 (20C69) (Physical Installation) (No MCoreUtils, Please see docs/README.macOS.11)
* macOS 11 (Github Action with macOS-11 runner)


## TL;DR
Note that one should install all relevant packages for EPICS base and modules. 

Note that due to `pyDevSup`, one needs to setup its python version carefully. The minimum required package is numpy. Please check `.github/workflow` action files for the relevant packages.

Note that due to `measComp`, one need to setup vendor library. Please check https://github.com/jeonghanlee/uldaq-env with `/usr/local` installation path.

```bash
make init
make conf
make patch
make build
make install
make exist
source ${HOME}/epics/debian/10/7.0.4.1/setEpicsEnv.bash
softIoc
```

## Base and Modules

All version information defined in `configure/RELEASE`, and include the following EPICS base and modules:

```bash
$ make vars FILTER=SRC_NAME_

------------------------------------------------------------
>>>>          Current Envrionment Variables             <<<<
------------------------------------------------------------

SRC_NAME_ASYN = asyn
SRC_NAME_AUTOSAVE = autosave
SRC_NAME_BASE = epics-base
SRC_NAME_CALC = calc
SRC_NAME_CAPUTLOG = caPutLog
SRC_NAME_ETHERIP = ether_ip
SRC_NAME_IOCSTATS = iocStats
SRC_NAME_LUA = lua
SRC_NAME_MCOREUTILS = MCoreUtils
SRC_NAME_MODBUS = modbus
SRC_NAME_RECSYNC = recsync
SRC_NAME_RETOOLS = retools
SRC_NAME_SNCSEQ = sequencer-2-2
SRC_NAME_SSCAN = sscan
SRC_NAME_STREAM = StreamDevice

$ make vars FILTER=SRC_TAG_

------------------------------------------------------------
>>>>          Current Envrionment Variables             <<<<
------------------------------------------------------------

SRC_TAG_ASYN = tags/R4-40
SRC_TAG_AUTOSAVE = tags/R5-10-1
SRC_TAG_BASE = tags/R7.0.4
SRC_TAG_CALC = tags/R3-7-4
SRC_TAG_CAPUTLOG = tags/R3.7
SRC_TAG_ETHERIP = tags/ether_ip-3-2
SRC_TAG_IOCSTATS = 70128c7
SRC_TAG_LUA = 5b2d131
SRC_TAG_MCOREUTILS = tags/1.2.2
SRC_TAG_MODBUS = tags/R3-1
SRC_TAG_RECSYNC = eb33785
SRC_TAG_RETOOLS = f477f09
SRC_TAG_SNCSEQ = tags/R2-2-8
SRC_TAG_SSCAN = tags/R2-11-3
SRC_TAG_STREAM = bf55d4c
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
/home/jhlee/epics-7.0.4/epics-modules
├── asyn-4.40
├── autosave-5.10.1
├── calc-3.7.4
├── caPutLog-3.7
├── ether_ip-3.2.0
├── iocStats-70128c7
├── lua-5b2d131
├── MCoreUtils-1.2.2
├── modbus-3.1.0
├── recsync-eb33785
├── retools-f477f09
├── seq-2.2.8
├── sscan-2-11-3
└── std-1dff82c
```

```bash
$ make symlinks.modules
$ make exist.modules LEVEL=0
jhlee@parity: EPICS-env (master)$ make exist.modules LEVEL=0
tree -aL 1 /opt/epics-7.0.4/epics-modules
/opt/epics-7.0.4/epics-modules
├── asyn -> /opt/epics-7.0.4/epics-modules/asyn-4.40
├── asyn-4.40
├── autosave -> /opt/epics-7.0.4/epics-modules/autosave-5.10.1
├── autosave-5.10.1
├── calc -> /opt/epics-7.0.4/epics-modules/calc-3.7.4
├── calc-3.7.4
├── caPutLog -> /opt/epics-7.0.4/epics-modules/caPutLog-3.7
├── caPutLog-3.7
├── ether_ip -> /opt/epics-7.0.4/epics-modules/ether_ip-3.2.0
├── ether_ip-3.2.0
├── iocStats -> /opt/epics-7.0.4/epics-modules/iocStats-70128c7
├── iocStats-70128c7
├── lua -> /opt/epics-7.0.4/epics-modules/lua-5b2d131
├── lua-5b2d131
├── MCoreUtils -> /opt/epics-7.0.4/epics-modules/MCoreUtils-1.2.2
├── MCoreUtils-1.2.2
├── modbus -> /opt/epics-7.0.4/epics-modules/modbus-3.1.0
├── modbus-3.1.0
├── recsync -> /opt/epics-7.0.4/epics-modules/recsync-eb33785
├── recsync-eb33785
├── retools -> /opt/epics-7.0.4/epics-modules/retools-f477f09
├── retools-f477f09
├── seq -> /opt/epics-7.0.4/epics-modules/seq-2.2.8
├── seq-2.2.8
├── sscan -> /opt/epics-7.0.4/epics-modules/sscan-2-11-3
├── sscan-2-11-3
├── std -> /opt/epics-7.0.4/epics-modules/std-1dff82c
├── std-1dff82c
├── StreamDevice -> /opt/epics-7.0.4/epics-modules/StreamDevice-2.8.15-bf55d4c
└── StreamDevice-2.8.15-bf55d4c
```

* additional makefile rules

```bash
make exist             : Show Base and Modules Installation Path  (one can use `LEVEL` argument, e.g., `make exist LEVEL=4`)
make init.modules      : Generate dynamicaly modules variables and clone all
make conf.modules      : Make conf.modules.show will print out all local configuraiton files.
make conf.modules.show : Show all local configuration (RELEASE.local, CONFIG_SITE.local, and so on)
make clean.modules     : Some module have the infinite compiling loop, so we have to clean up exist things within git repositories.
make build.modules     : Build and install each module into thier installation location
make install.modules   : We may not need this rule, beacuse of the standard EPICS buidling system default could be build and install
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

## Docker Image

See [docs/REAMDE.Docker.md](docs/README.Docker.md) :whale:
