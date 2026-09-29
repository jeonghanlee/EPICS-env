# EPICS Configuration Environment (EPICS-env)

EPICS-env builds one Experimental Physics and Industrial Control System (EPICS)
base and a pinned set of 32 EPICS modules from source, and installs them as one
tree per release, operating system (OS), and base version. The installed tree
links its libraries relative to its own location, carries a shell environment
script, and holds a set of common iocsh fragments for input/output controllers
(IOCs).

A make target drives every action: fetching the sources, applying carried
upstream patches, configuring, building, installing, linking, and checking the
result. The three verification gates are make targets as well:
`check.module-deps` checks the module dependencies before the build, and
`check.deps` and `check.env` check the library search paths and the
environment script after the install.

## Supported operating systems

The environment builds on six Linux OSs, each with one continuous integration
(CI) workflow: Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu
24.04, and Ubuntu 26.04. Every workflow builds and installs the environment,
then runs `check.env` and `check.deps` on the installed tree. Every workflow
also runs `check.module-deps` after configuration and before the build.
Debian 12, Debian 13, and Rocky 8 run it through `github.check`; Rocky 10
and both Ubuntu workflows call it as a separate stage.
[Supported platforms and CI](reference/supported-platforms-and-ci.md) lists the
container image and the build sequence of each workflow.

## How to read this book

The pages follow the order in which you meet the system:

- The tutorial, [Build and use your first EPICS environment](tutorial/first-environment.md),
  takes you from a fresh clone to a running IOC.
- The concept pages explain how the build pipeline, the module set, the
  installed tree, the verification gates, the patch carry, and the iocsh
  fragments work.
- The procedure pages each complete one task, such as a module bump or an
  upstream fix carry.
- The reference pages list exact values: make targets, variables, module
  pins, fragment macros, tools, and platforms.
- The [glossary of EPICS-env terms](glossary.md) defines each term the pages
  use.

## Topics outside this book

The cross build of EPICS base and modules for a Libera target is outside this
book. It consists of `scripts/build_base_libera.bash`,
`scripts/build_modules_libera.bash`, the `conf.modules.libera` target, and
`configure/os/CONFIG_SITE.linux-x86_64.linux-arm`.
