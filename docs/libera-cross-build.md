# Libera cross-build reference

The Libera scripts build EPICS base and nine modules for the `linux-arm`
target. This reference describes their inputs, outputs, and verification
requirements outside the EPICS-env book.

## Scope

This document covers [build_base_libera.bash](../scripts/build_base_libera.bash),
[build_modules_libera.bash](../scripts/build_modules_libera.bash), the
`conf.modules.libera` target, and the generated library profile.

**Out of scope:** native installation procedures, changes to the compiler or
sysroot, and execution of ARM products on a Libera board.

Verification status and the deferral decision belong to the
[canonical work record](milestone-84ee626.md#m20---libera-cross-build-and-generated-profile).
The [archived Libera configuration](archive/Libera_EPICS_configuration.md)
is a historical document, not a verified procedure for the current pins.

## Compiler and base inputs

The cross-build uses these architectures. The supplied
[cross site file](../configure/os/CONFIG_SITE.linux-x86_64.linux-arm) defines
the compiler and library settings:

| Setting | Value |
| --- | --- |
| Host architecture | `linux-x86_64` |
| Target architecture | `linux-arm` |
| `GNU_TARGET` | `arm-xilinx-linux-gnueabi` |
| `GNU_DIR` | `/opt/libera/Xilinx/ise/EDK/gnu/arm/lin` |
| `STATIC_BUILD` | `NO` |
| `SHARED_LIBRARIES` | `YES` |

The actual compiler and its target sysroot must be available before either
build. The module script requires an installed base with both host and ARM
products. Native base products alone do not meet that requirement.

The base script derives the repository root from its location under
`scripts/`. Its optional first argument selects an installation prefix; the
default is `/srv/liberablmOpt`, and it appends `/epics` to that prefix.

The base script overwrites `configure/CONFIG_SITE.local` with installation,
cross-architecture, and NTP settings. It initializes base, copies the supplied
cross site file into base's `configure/os`, adds the local configuration
include, and configures base before asking for build confirmation.

After confirmation, it applies base patches, builds and installs base, and
copies the upstream startup directory into the installed base. An isolated
checkout and destination are required for verification of these operations.

## Module build and outputs

The module script derives the repository root from its location under
`scripts/` and obtains the environment destination from the real make
configuration. After confirmation, it runs `init.modules`, `conf.modules`,
and `conf.modules.libera`.

It builds, installs, and links the modules in this order:

| Order | Build identifier | Installed link |
| --- | --- | --- |
| 1 | `iocStats` | `modules/iocStats` |
| 2 | `recsync` | `modules/recsync` |
| 3 | `retools` | `modules/retools` |
| 4 | `caPutLog` | `modules/caPutLog` |
| 5 | `autosave` | `modules/autosave` |
| 6 | `sequencer` | `modules/seq` |
| 7 | `sscan` | `modules/sscan` |
| 8 | `calc` | `modules/calc` |
| 9 | `asyn` | `modules/asyn` |

Sequencer uses `build.sequencer`, `install.sequencer`, and
`symlink.sequencer`. Its installed link name is `seq`.

The script derives library locations from
`MODS_INSTALL_LOCATIONS_SYMLINKS`. It replaces the `INSTALL_LOCATION` prefix
with `/opt` and appends `/lib/linux-arm` for the target board.

The script writes `.libera_epics_modules_lib_path` beside itself before
building the modules. After the module sequence, it installs that profile
with mode 0444 at the environment root. The profile assigns the
colon-separated library list to `MOD_LD_LIBRARY_PATH`.

## Environment profile behavior

[Setup](../scripts/setEpicsEnv.bash) loads the profile from the selected
installed environment when the file exists. It prepends the profile's
library list to `LD_LIBRARY_PATH` using complete-field comparison.

Repeated setup must preserve the profile directory order and retain each
profile directory exactly once. Unrelated fields must retain their bytes,
order, duplicates, and empty fields.

[Reset](../scripts/resetEpicsEnv.bash) removes the known base library entry.
It retains the profile library entries and `MOD_LD_LIBRARY_PATH`.

## Cross-base verification requirements

Verification requires an isolated checkout, HOME, installation root, real
compiler and sysroot, and the pinned source repositories. It must record the
candidate diff and hashes, tool versions, configuration, statuses, and outputs.

The isolated `configure/CONFIG_SITE.local` must select the disposable
installation root, `CROSS_COMPILER_TARGET_ARCHS=linux-arm`, and
`CROSS_COMPILER_HOST_ARCHS=linux-x86_64`.

Base preparation must use the shipped `init.base` and `patch.base` targets.
It must copy the supplied cross site file unchanged into
`epics-base-src/configure/os/CONFIG_SITE.linux-x86_64.linux-arm` and run
`conf.base`.

The effective base configuration must read `CONFIG_SITE.local` and select the
expected target architecture, `GNU_TARGET`, and `GNU_DIR`. The actual
`build.base` and `install.base` targets must produce installed host and ARM
products whose ELF architectures are inspected before the module script runs.

## Module and profile verification requirements

The real module script must run through configuration, all nine
build/install/symlink sequences, and profile installation. A real PTY must
wait for its prompt before sending confirmation. Every nested make status
and the final script status must be recorded.

Verification must check the `modules/seq` destination, inspect installed
host and ARM ELF products, and compare the profile's nine directories with
independently checked make locations and the `/opt` mapping.

The profile must come from that actual script run. Its bytes and mode must be
recorded. A manually written profile cannot substitute for this integration
test.

The installed setup must run twice in fresh Bash children with nounset
enabled and disabled. After each call, all nine profile directories must
occur once in their generated order, and the base library entry must occur
once. Unrelated library fields must retain their bytes and structure.

Reset must remove the known base library entry while retaining the profile
library entries. Documentation must agree with the actual prompts, module
order, make targets, links, profile bytes, and installation mode.

Target queries, dry runs, native builds, and static source inspection do not
verify the cross-build or generated-profile repetition. Host verification
must not execute ARM binaries or claim target-board runtime coverage.
