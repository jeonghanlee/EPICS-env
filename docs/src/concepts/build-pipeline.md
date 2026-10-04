# Build pipeline stages

EPICS-env turns a checkout into an installed Experimental Physics and
Industrial Control System (EPICS) tree in six stages: `init`, `patch`,
`conf`, `build`, `install`, and `symlinks`. Each stage is a make target at
the repository top, and each one reads files that an earlier stage or the
configuration wrote.
[Make targets by purpose](../reference/make-targets.md#pipeline-aggregate-targets)
lists every target each stage runs, and
[Build and install the environment](../procedures/build-and-install.md) runs
the stages in order.

## What each stage reads and writes

| Stage | Reads | Writes |
| --- | --- | --- |
| `init` | The pins in `configure/RELEASE` and the generated `configure/MODULESGEN.mk` | `epics-base-src` and one `<name>-src` source tree per module, checked out at the pin |
| `patch` | The `.p0.patch` files under `patch/` | The cloned source trees |
| `conf` | The configuration variables: install location, pins, and vendor library paths | Site files in `epics-base-src/configure`, `RELEASE.local` and `CONFIG_SITE.local` at the repository top, and site files under each module's `configure` directory |
| `build` | The patched source trees and the files `conf` wrote | EPICS base and every module in the installed tree |
| `install` | The build products, configured dependencies, environment scripts, common iocsh fragments, and the EPICS-env commit | Environment scripts, `.versions`, common iocsh fragments, and on native Linux the normalized build/service metadata, refresh utility, and completed inventory |
| `symlinks` | The versioned directories in the installed tree | One unversioned link per module under `modules` |

`init` skips a source tree that already exists, so it never replaces a
checkout that `patch` has changed.
[Upstream patch carry](upstream-patch-carry.md) explains the patch files, and
[Module set and dependencies](module-set.md) explains the module site files
that `conf` writes.
[Installed tree and relocation](installed-tree.md) describes the tree that
`build`, `install`, and `symlinks` produce.

## Why configuration precedes the build

The `build` target runs `conf.base`, `build.base`, `conf.modules`, and
`build.modules`, in that order. Every build therefore reads site files
written from the variables in effect for that make run.

The configuration decides where the build puts its output and how it links:

- `conf.base` sets `INSTALL_LOCATION` for EPICS base to the `base`
  directory of the installed tree. It also selects linking with library
  search paths relative to `$ORIGIN`, the directory of the loaded file.
- `conf.modules` points every module at the installed EPICS base and sets
  each module's `INSTALL_LOCATION` to its versioned directory under
  `modules`.
- The module configuration targets write the install directory of each
  dependency into the module's `RELEASE.local`, so a module compiles against
  the dependencies already installed.

An EPICS build installs its products into `INSTALL_LOCATION` as part of the
build. A module build therefore reads EPICS base, and every module it
depends on, from the installed tree rather than from a source tree. Without
the configuration, EPICS base and each module would install into their own
source trees.

Most configuration targets rewrite their files from the first line, so a
later `make conf` or `make build` replaces the earlier content. Some targets
change files in other ways:

- `conf.base.site` adds its two lines to the EPICS base file
  `configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64` only when each line is
  absent.
- `conf.calc`, `conf.lua`, and `conf.StreamDevice` edit module files in place
  with `sed`, and `conf.StreamDevice` and `conf.pmac` remove module files.
- The `conf.gz.*` targets append compression flags to files that other
  targets wrote.

On Ubuntu 26, each of the ten modules listed in
[Source configuration targets](../reference/make-targets.md#source-configuration-targets)
writes its C17 compiler flag during its own configuration. The Ubuntu 26
condition is defined before the automatic module rules are generated, so
`conf.iocStats` and the custom configuration targets use the same condition.

## Serial execution of every target

`configure/RULES_VARS` declares `.NOTPARALLEL`. GNU Make then runs the
prerequisites of every target one at a time, in the order the target lists
them, even when you pass `-j`.

Several aggregates depend on that order:

- `patch.revert` lists the patch targets in the exact reverse order of
  `patch`.
- `github.check` runs `check.module-deps` after `conf` and before `build`.

Parallel compilation happens inside a single build. `build.base` runs the
EPICS base build with four parallel jobs; each module build runs `make`
without a `-j` option.

## Module builds in dependency order

`build.modules` has one `build.<module>` prerequisite per module, followed by
`install.modules`. Each `build.<module>` target has the prerequisites that
the `<module>_DEPS` variable in `configure/CONFIG_MODS_DEPS` lists, such as
`null.base build.sequencer build.sscan build.calc` for `asyn`.

Make runs each `build.<module>` target once per make run. A module therefore
starts to build only after every module it depends on has built and
installed. The order among modules with no dependency relation between them
carries no meaning.

After the last module builds, `install.modules` runs `make install` in every
module source tree.
[Module set and dependencies](module-set.md#build-order-from-declared-dependencies)
describes the `<module>_DEPS` graph.

## Install and link stages

The `build` stage alone leaves the installed tree without its top-level
files. `install` adds them:

- `install.base` runs the EPICS base install and copies
  `scripts/setEpicsEnv.bash` and `scripts/resetEpicsEnv.bash` to the top of
  the installed tree with mode 0644, backing up existing files.
- `install.modules` runs the install of every module.
- `install.commoniocsh` copies the common iocsh fragments to
  `modules/commonIocsh/iocsh`.
- `src_version` writes the time it runs and the EPICS-env commit to
  `.versions` and copies that file to the top of the installed tree.

On native Linux, build and install writers preserve original installed
metadata before upstream make runs. Partial targets and failed writers leave
an incomplete-install record. After every full-install prerequisite succeeds,
`install` prepares versioned dependency declarations, pkg-config and service
paths, runs the real EPICS consistency checks, and finalizes the inventory.
Only successful full installation clears incomplete state. An unfinished
refresh blocks writers until verified rollback completes.

`symlinks` creates an unversioned link, such as `modules/asyn`, for each
module. On Linux it then deletes every dangling link under `modules`.
`setEpicsEnv.bash` reaches the `pvxs` and `pmac` executables through these
links.

## Continuous integration aggregates

Two aggregates run the pipeline for continuous integration (CI):

| Aggregate | Runs, in order |
| --- | --- |
| `github` | `init`, `patch`, `vars`, `conf`, `build`, `symlinks` |
| `github.check` | `init`, `patch`, `vars`, `conf`, `check.module-deps`, `build`, `symlinks` |

`vars` prints the configuration variables into the job log. Neither aggregate
runs `install`; a CI workflow that uses `github.check` runs `make install`
after it.

`github.check` places `check.module-deps` after `patch` and `conf` because
that audit reads the patched module sources and the `RELEASE.local` files
that `conf` writes. The installed-tree checks `check.deps` and `check.env`
need an installed tree, so neither aggregate runs them.
[Build and install verification gates](verification-gates.md) explains each
check, and
[Supported platforms and CI](../reference/supported-platforms-and-ci.md)
lists which workflow runs which aggregate.
