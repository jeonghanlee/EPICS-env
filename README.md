# EPICS Configuration Environment

## Reference
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8270664.svg)](https://doi.org/10.5281/zenodo.8270664)

## Github Actions
[![Debian 12](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml)
[![Rocky 9](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky9.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky9.yml)
[![Linux Build](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml)
[![Ubuntu 22.04](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu22.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu22.yml) 
[![Linter Run](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml)
[![Docker Image CI](https://github.com/jeonghanlee/EPICS-env/actions/workflows/docker-image.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/docker-image.yml)

## Introduction
This is the EPICS base and various modules Configuration Environment for the ALS-U project and my purpose. There are plenty of diverse ways we can do this. However, it is designed for me to minimize my limited resources to support the reproducible EPICS environment in various platforms. I want to use almost pure Makefile instead of packages, and continuous integration tools, such as Ansible, Conda, Puppet, and even shell scripts. Unfortunately, I used "shell tricks" within Makefile rules, but I tried to use the generic Makefile rules as much as possible. I want a system that works without looking for their dependencies over the next ten years.

## Tested

### Focus

* Debian 12 (Bookworm)
* Rocky 9   (Blue Onyx)

### Eye

* Rocky 8 (Green Obsidian)
* macOS 14 (Sonoma, with brew, python 3.11)

### Obsolete 
* ~~Scientific Linux 7~~
* ~~CentOS 8~~
* ~~macOS 12.0.1 (21A559)~~
* ~~macOS 11.1 (20C69)~~
* ~~macOS 11~~
* ~~macOS 13 (Ventura, with brew)~~
* ~~CentOS 7~~
* ~~Debian 10 (Buster)~~
* ~~Debian 11 (Bullseye)~~
* ~~Ubuntu 22.04 LTS (Jammy Jellyfish)~~
* ~~Alma 8~~
* ~~Fedora 32~~
* ~~Ubuntu 18.04/20.04~~
* ~~Raspbian GNU/Linux 10~~

## TL;DR
That you know, one should install all relevant packages for the EPICS base and modules. 

Note that due to `pyDevSup`, one must carefully set up its python version. The minimum required package is numpy. Please check the `.github/workflow` action files for the relevant packages.

Note that due to `measComp`, one needs to set up a vendor library. Please check https://github.com/jeonghanlee/uldaq-env with `/usr/local` installation path.

Note that due to `pvxs`, one needs to run `make symlinks` mandatory. It allows us to use the proper path for pvxs executable files and libraries with the environment. We use the bundle `libevnet` instead of a system library.

```bash
make init
make patch
make patch.pvxs.apply
make conf
make build
make install
make symlinks
make exist
source ${HOME}/epics/1.1.0/debian-12/7.0.7/setEpicsEnv.bash
softIoc
```

## Base and Modules

All version information is defined in `configure/RELEASE`, and include the following EPICS base and modules:

```bash
$ make vars FILTER=SRC_NAME_

------------------------------------------------------------
>>>>          Current Environment Variables             <<<<
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

