# EPICS Configuration Environment

## Overview

This repository provides a self-contained, reproducible build environment for the Experimental Physics and Industrial Control System (EPICS) Base and a collection of widely-used EPICS modules. The system is designed to facilitate the installation and configuration of EPICS without reliance on external package managers or complex continuous integration tools.

The build process is managed exclusively through Makefiles, ensuring long-term reproducibility and minimizing external dependencies. The environment has been validated on various Linux distributions, and its status is continuously monitored through GitHub Actions.

## Reference
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8248353.svg)](https://doi.org/10.5281/zenodo.8248353)

## Continuous Integration Status

[![Debian 12](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml)
[![Rocky 9](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky9.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky9.yml)
[![Linux Build](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/build.yml)
[![Ubuntu 22.04](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu22.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu22.yml)
[![Linter Run](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml)

## Supported Platforms
The environment is officially supported and tested on the following operating systems:
* Primary Support: Debian 12 (Bookworm), Rocky 8 (Green Obsidian)
* Extended Testing: Debian 13 (Trixie), Rocky 9 (Blue Onyx)

For a complete list of supported platforms, please refer to the continuous integration status badges above.

## Prerequisites
Before beginning the build process, users must install all relevant system dependencies for EPICS Base and its modules.

### Module-Specific Dependencies:
* **measComp:** Requires the vendor library `uldaq`. Refer to: https://github.com/jeonghanlee/uldaq-env.
* **opcua:** Requires the `OPEN62541` library. Refer to: https://github.com/jeonghanlee/open62541-env.
* **pvxs:** Requires a mandatory make symlinks step to properly configure paths for executables and libraries. The system `libevnet` library is used instead of the bundled `pvxs` version.

## Getting Started
The following steps outline the standard procedure for building and installing EPICS:

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

## Build Command Reference

All version information and build variables are defined in the `configure/RELEASE` file. The environment includes the following EPICS Base and modules:

```bash
$ make vars FILTER=SRC_NAME_
$ make vars FILTER=SRC_TAG_
```

### Base Commands

* `make init.base`: Initializes the EPICS Base source directory.
* `make conf.base`: Configures EPICS Base. make conf.base.show displays configuration settings.
* `make patch.base`: Applies necessary patches (if required).
* `make build.base`: Compiles the EPICS Base.
* `make install.base`: Installs EPICS Base to its destination.
* `make clean.base`: Removes build artifacts.
* `make distclean.base`: Deletes the downloaded source directory.

### Module-Specific Commands
The following commands are available for managing the EPICS modules:

* `make init.modules`: Clones all module repositories and generates dynamic build variables.
* `make conf.modules`: Configures all modules. `make conf.modules.show` displays all local configurations.
* `make build.modules`: Compiles and installs each module into its designated location.
* `make install.modules`: Installs each module.
* `make clean.modules`: Cleans build artifacts within all module repositories.
* `make distclean.modules`: Deletes all downloaded module source directories.
* `make exist.modules`: Displays the installation paths for all modules.
* `make symlinks.modules`: Creates or overwrites symbolic links for all active modules and removes any dead links.

### Utilities and Examples

The build system automatically generates rules for each module, allowing for granular control. Rules follow the format `target.module_name`, where target can be build, install, clean, or uninstall.

```bash
# Example for a specific module
make build.iocStats
make clean.StreamDevice
make install.asyn

# Variable management
make vars           # Prints all important variables
make PRINT._var_name # Prints the selected variable
```

## Project Utilities

This repository includes a suite of command-line tools to assist with development and system management. For more details on these utilities, refer to the [Tools](./tools/README.md).

