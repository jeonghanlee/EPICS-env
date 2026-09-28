# EPICS Configuration Environment

EPICS-env builds one Experimental Physics and Industrial Control System (EPICS)
base and a pinned set of 32 EPICS modules from source with make, and installs
them as one tree per release, operating system, and base version. The
installed tree links its libraries relative to its own location, carries a
shell environment script, and holds a set of common iocsh fragments for
input/output controllers (IOCs).

## Reference

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8248353.svg)](https://doi.org/10.5281/zenodo.8248353)

## Continuous Integration Status

[![Debian 13](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian13.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian13.yml)
[![Debian 12](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/debian12.yml)
[![Rocky 10](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky10.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky10.yml)
[![Rocky 8](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky8.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/rocky8.yml)
[![Ubuntu 24.04](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu24.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu24.yml)
[![Ubuntu 26.04](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu26.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/ubuntu26.yml)
[![Linter Run](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml/badge.svg)](https://github.com/jeonghanlee/EPICS-env/actions/workflows/linter.yml)

## Supported platforms

The supported operating systems are the ones with a continuous integration
workflow above:

* Primary support: Debian 13 (Trixie)
* Supported: Debian 12 (Bookworm), Rocky Linux 8.10 (Green Obsidian), Rocky
  Linux 10.2 (Red Quartz), Ubuntu 24.04 LTS (Noble Numbat), Ubuntu 26.04 LTS
  (Resolute Raccoon)

## Documentation

The EPICS-env book is published at
<https://jeonghanlee.github.io/EPICS-env/>, with its source under
[docs/src](./docs/src). Start with:

* [Build and use your first EPICS environment](./docs/src/tutorial/first-environment.md),
  a lesson from a fresh clone to a running IOC.
* [Build and install the environment](./docs/src/procedures/build-and-install.md),
  the build as a task with its verification.
* [Make targets by purpose](./docs/src/reference/make-targets.md), every make
  target.
* [Tools and scripts reference](./docs/src/reference/tools-and-scripts.md), the
  programs in `tools/` and `scripts/`.

The procedures that agents follow and the work records live under
[docs](./docs); see [docs/README.md](./docs/README.md).

## Prebuilt distribution

To use the environment without building it, download a prebuilt tree from
[EPICS-env-distribution](https://github.com/jeonghanlee/EPICS-env-distribution)
and follow its installation instructions.
