# Closed Doors

Candidates examined during a review and deliberately left as they are. Each row
states why the shape is principled, so a later sweep can close the same door in
seconds instead of investigating it again. Nothing here is tracked work.

## 2026-08-08

### K1 - `base_patch_src` and `base_revert_patch_src` carry no `|| exit 1`

**Premise.** Six helpers in `configure/RULES_FUNC` loop `patch` over a wildcard
list. Four end the invocation with `|| exit 1`; `base_patch_src` and
`base_revert_patch_src` do not. Read as a list, that is an asymmetry, and the
two unguarded helpers are the older ones, which makes it look like a step the
later carry work forgot.

**Verdict: Keep.** The guard answers a specific failure - a mid-stack miss,
where one patch in a stack fails and a later success masks it, because the shell
returns the status of the last command it ran. That situation needs a stack. The
two unguarded helpers glob `$(SRC_VER_BASE).base.p0.patch`, which has no
wildcard character, so the loop iterates over at most one file and the single
`patch` is always the last command. Its failure propagates on its own. Adding
the guard changes nothing while the glob stays literal.

**Evidence.**

- The rationale was written down when the guarded helpers were added.
  `configure/RULES_FUNC:26-27` states it in the code: "`|| exit 1` fails the
  target on any mid-stack miss instead of masking it behind a later success."
  Commit `c7aac56` says "each loop gated `|| exit 1`" of the new stacked legs.
  `docs/archive/base-carry-1.3.0.md:104` and
  `docs/procedures/upstream-fix-carry-procedure.md:416` both phrase the rule as
  "so a **mid-stack** failure fails the target."
- M22 passed a three-reviewer plan review and a three-reviewer implementation
  review with zero blocking findings, so the distinction was in front of six
  readers.
- Measured 2026-08-08 on two scratch clones, one with the guard added and one
  without: a deliberately unappliable `patch/7.0.10.base.p0.patch` makes
  `make patch.base` exit 2 in both. The guard does not change the outcome.

**If this returns.** It becomes a real defect only if the glob is ever widened
to match several files - for example a `7.0.10.base-*.p0.patch` form. Add the
guard together with that change, not before it.

Examined at `11cbe64`; recorded in the commit that carries this file.

## 2026-09-24

### K2 - Four patch files with no row in the `patch/README.md` tables

**Premise.** `patch/` holds `3.15.5.base`, `7.0.5.base`, `7.0.7.base`, and
`pvxs-1.3.1` patch files that none of the per-file tables list, which reads
like the tables fell behind the directory.

**Verdict: Keep.** They are dormant history for earlier pins and are not
applied on the current pins. `patch/README.md` says so directly below the
tables.

**Evidence.**

- `patch/README.md:109-112` names all four as "Dormant history, not applied on
  the current pins".
- `configure/RULES_FUNC` applies the `.base` leg only through
  `$(SRC_VER_BASE).base.p0.patch`, and no `7.0.10.base.p0.patch` exists.

**If this returns.** It becomes a defect only if a current pin matches one of
these files again; list it in the table then.

Examined at `df483f1`; recorded in the commit that carries this file.

### K3 - `linStat{FS,Host,NIC,Proc}.iocsh` are not named by any doc or test

**Premise.** Of the twelve `commonIocsh/iocsh` fragments, four appear in no
document and no test by name, which reads like untested fragments.

**Verdict: Keep.** `linStat.iocsh` loads them itself, so every linStat test
exercises them, and the linStat documentation covers them through it.

**Evidence.**

- `commonIocsh/iocsh/linStat.iocsh:16-19` loads `linStatHost` and
  `linStatProc` always, and `linStatNIC` and `linStatFS` behind `NICENABLE`
  and `FSENABLE`; line 13 tells the user to load the NIC and FS fragments
  again per extra instance.

**If this returns.** It becomes a gap only if a sub-fragment gains behavior
that `linStat.iocsh` does not reach, such as a macro the parent never passes.

Examined at `df483f1`; recorded in the commit that carries this file.

### K4 - `pvs_gets.bash` and `pv_snapshot.bash` both read a PV list with `caget`

**Premise.** Two tools read the same kind of PV list file and call `caget`,
which reads like duplicated logic.

**Verdict: Keep.** They answer different questions. `pvs_gets.bash` is a
viewer: it sorts, filters, can watch, and hides PVs that do not answer.
`pv_snapshot.bash` records every listed PV, including the ones that do not
connect, and compares two records.

**Evidence.**

- `tools/pvs_gets.bash:151` suppresses failed reads so only working results show.
- `tools/pv_snapshot.bash` writes `__DISCONNECTED__` for a PV that does not
  connect and reports it as `DISCONN`, which a viewer must not hide.

**If this returns.** Merge them only if one tool must both display and
record; the disconnected-PV handling is the part that must not be shared.

Examined at `df483f1`; recorded in the commit that carries this file.

## 2026-09-28

### K5 - No direct autosave prerequisite in `motor_DEPS`

**Premise.** `motor_DEPS` has no direct `build.autosave` entry, while motor's
module configuration can forward AUTOSAVE to its child modules.

**Verdict: Keep.** The current configured motor RELEASE leaves AUTOSAVE
undefined. The forwarding is conditional, and the existing build ordering
already reaches autosave through busy. Keep the current prerequisites without
adding a direct autosave entry.

**Evidence.**

- `configure/CONFIG_MODS_DEPS` declares `build.busy` for motor and
  `build.autosave` for busy; the real top-level prerequisite queries returned
  that chain.
- `conf.motor` in `configure/RULES_MODS_CONFIG` writes SNCSEQ, ASYN, BUSY, LUA,
  and MODBUS. After this target ran on motor pin
  `285f44d66cf7d07a86047719de757bd1f5d92a95`, EPICS base's RELEASE parser
  resolved no AUTOSAVE value. `motor-src/modules/Makefile` forwards AUTOSAVE
  only inside `ifdef AUTOSAVE`.
- Commands, resolved values, and observation time are recorded in
  `work/m10-decisions-20260928/observations.json`
  (`2026-09-29T02:02:19.394620+00:00`). These checks ran configuration and
  prerequisite queries; they did not compile motor or start an IOC.

**If this returns.** Recheck the dependency when the pinned source or enabled
configuration gains a direct autosave consumer, or when the busy prerequisite
chain changes.

Decision Date: 2026-09-28.
Examined at `73b71d8bc8cf3c924feeacfc8942180f89c55c55`; recorded in the commit
that carries this file.

### K6 - QPC inherits ASYN without a generated `RELEASE.local`

**Premise.** `QPC_DEPS` includes asyn, but `conf.QPC` writes only
`CONFIG_SITE.local`. Most custom module targets write explicit versioned
dependency paths in a module's `RELEASE.local`.

**Verdict: Keep.** Retain `conf.QPC`, `QPC_DEPS`, and QPC's inherited,
unversioned ASYN path. The active source tree installs data and IOC fragments
without declaring a library or executable. The installed IOC fragment uses
the consuming IOC's ASYN macro at runtime. Describe this exception in the
module configuration documentation rather than adding a versioned path only
to make configuration files uniform.

**Evidence.**

- At QPC pin `913fad41df170063d910d0b4fdb083de696fac36`,
  `QPC-src/configure/RELEASE` defines `ASYN=$(MODULES)/asyn` and
  `MODULES=$(EPICS_BASE)/../modules`, and reads the parent configuration.
  After the shipped configuration and QPC patch targets ran, EPICS base's
  RELEASE parser resolved ASYN to the installation tree's `modules/asyn` path.
- `QPC-src/Makefile` includes `configure` and `digitelQpcApp`; it excludes
  `qpcApp`. The active `digitelQpcApp` Makefiles install databases, IOC
  fragments, protocols, and display files. Its
  `iocsh/gamma-pctrl.iocsh` loads `$(ASYN)/db/asynRecord.db`.
- The configuration, parser, and prerequisite observations are in
  `work/m10-decisions-20260928/observations.json`
  (`2026-09-29T02:02:19.394620+00:00`). Source inspection and these commands
  establish the configuration premise; no QPC build or IOC startup ran.

**If this returns.** Recheck the path if the active QPC tree gains a compiled
ASYN consumer or its configuration and installed fragment contract changes.
This Keep does not preserve QPC's membership in the base-only configuration
group; that membership has a separate accepted change.

Decision Date: 2026-09-28.
Examined at `73b71d8bc8cf3c924feeacfc8942180f89c55c55`; recorded in the commit
that carries this file.

### K7 - Conditional stale-cache hint on declaration errors

**Premise.** A missing or invalid `<module>_CONF_TYPE` declaration prints a
hint that mentions removing the generated `configure/MODULESGEN.mk` file.

**Verdict: Keep.** Retain the distinct missing/invalid declaration errors and
their shared `MODS_GEN_STALE_HINT`. The hint explicitly applies when the module
set just changed; it does not claim that cache removal fixes every declaration
error.

**Evidence.**

- `validate_conf_type` in `configure/CONFIG_MODS_DEPS` emits separate
  missing and invalid declaration errors. `MODS_GEN_STALE_HINT` begins with
  the condition `if the module set just changed`.
- Real top-level `print-MOD_NAMES` invocations with `motor_CONF_TYPE=` and
  `motor_CONF_TYPE=invalid` both exited 2, with the corresponding error and
  the conditional hint. Commands and complete output are recorded in
  `work/m10-decisions-20260928/observations.json`
  (`2026-09-29T02:02:19.394620+00:00`). These checks verified the diagnostics;
  they did not test recovery after a module-set change.

**If this returns.** Revisit if the condition becomes inaccurate or the
diagnostic promises recovery for a declaration error that cache regeneration
cannot repair.

Decision Date: 2026-09-28.
Examined at `73b71d8bc8cf3c924feeacfc8942180f89c55c55`; recorded in the commit
that carries this file.

## 2026-09-29

### K8 - Red Hat vendor configuration behavior

**Premise.** The Rocky 10 workflow calls `conf.rocky8` for uldaq and
open62541. The target name suggests a version mismatch.

**Verdict: Keep (configuration behavior).** Preserve the existing recipe and
`conf.rocky8` compatibility. The vendor repositories document this target
for Rocky 8 or a Red Hat variant. Its relevant difference from `conf` is
`--enable-new-dtags`; it does not select a Rocky 8 compiler, container,
source pin, or installation root. Neither examined baseline provides
`conf.rocky10`.

**Scope update.** D25 on 2026-09-29 supersedes D24's restriction on vendor
target changes and retaining the old target name in Rocky 10's calls. Add
`conf.rocky10` as an entry point to the same recipe in both vendors, then
switch the Rocky 10 consumer after publication. The underlying flags and
legacy interface remain covered by this Keep.

**Evidence.**

- `uldaq-env` at `afd6f49e65c7cd64a215f20458e43a843dea4f61`:
  [RULES_INSTALL](https://github.com/jeonghanlee/uldaq-env/blob/afd6f49e65c7cd64a215f20458e43a843dea4f61/configure/RULES_INSTALL)
  adds `-Wl,--enable-new-dtags` to the configuration flags while retaining
  the caller's installation prefix and relative library path.
- `open62541-env` at `f297d97f9a860ee1f63eba29b4f8919cdb32953a`:
  [RULES_INSTALL](https://github.com/jeonghanlee/open62541-env/blob/f297d97f9a860ee1f63eba29b4f8919cdb32953a/configure/RULES_INSTALL)
  adds the same linker option; the shared-library build and `lib`
  installation directory are also present in its ordinary `conf` target.
- The complete source archives at those commits were inspected on
  2026-09-29 (21 and 20 files respectively); neither contains a
  `conf.rocky10` target.
- [Rocky 10 run 36537862601](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862601)
  at EPICS-env `6bbb6a5e45a49aad093d0c233113f40235ed2b4a` ran both
  `conf.rocky8` calls. Its actual configure and CMake output includes
  `--enable-new-dtags` and the Rocky 10 installation prefix; package and
  vendor setup, EPICS installation, and the final environment checks all
  succeeded. This is existing execution evidence, not a new vendor build.
  Recheck with `gh run view 36537862601 --repo jeonghanlee/EPICS-env --log`.

**If this returns.** Recheck when either vendor changes the underlying
configuration flags, installation contract, or source requirements, or
when a Rocky build or installed-library check exposes a concrete
incompatibility. D25's additional target must reuse the preserved recipe.

Decision Date: 2026-09-29.
Examined at EPICS-env `ebb8544fd81701f594b2e3a651a676c9463dea10`; vendor
source commits are recorded above. Recorded in the commit that carries this
file.

## 2026-09-30

### K9 - Existing environment selector code

**Premise.** `scripts/selectEpicsEnv.bash` builds
`<epics_top>/epics/<os_id>/<os_version>/<base_version>`, whereas the current
make installation uses
`<install_location>/<env_release>/<os_id>-<os_version>/<base_version>`.
Replacing the selector interface would change how callers specify a tree.

**Verdict: Keep.** Retain the selector's existing code, arguments, defaults,
and legacy path construction. Select among installed environments by sourcing
the chosen tree's `setEpicsEnv.bash` directly. That script derives its base
and module paths from its own location. This decision preserves existing
code; it does not establish compatibility between the legacy selector path
and the current make installation layout.

**Evidence.**

- `scripts/selectEpicsEnv.bash` reads `EPICS_TOP` and `EPICS_BASE_VERSION`
  and constructs the legacy path before sourcing setup. Its SHA-256 at the
  examined commit is
  `dea22b3f238cd898717ba3565698a1f0501d5896600447fb34acb1a71cea2e20`.
- `scripts/setEpicsEnv.bash` derives SRC_PATH from BASH_SOURCE, resolving a
  filesystem symlink, and sets EPICS_PATH to that directory, EPICS_BASE to
  its base directory, and EPICS_MODULES to its modules directory.
- The real make installation-path query and source hashes are recorded in
  `work/m14-plan-20260930/baseline.json` (query observed at
  `2026-09-30T17:28:20.521287+00:00`). M14 / T5 verifies candidate byte
  preservation and real direct-source selection on 2026-09-30. Actual A/B
  source calls, including the copy with spaces in its path, and four resolved
  tool paths are recorded in `work/m14-implementation-20260930/shell-final/`.
  This evidence does not establish a successful legacy-selector installation
  run.

**If this returns.** Revisit only when a caller requires the legacy selector
to reach the current make installation layout and the owner explicitly
authorizes that interface or path change.

Decision Date: 2026-09-30.
Examined at `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`; recorded in the
commit that carries this file.

## 2026-10-01

### K10 - Retained feed-core and QPC patch contents

**Premise.** The feed-core and QPC patches remove module references from
bundled application Makefiles. Their descriptions disagree about whether
strict dependency auditing requires them.

**Verdict: Keep.** Preserve both patch contents and apply behavior. The
feed-core patch removes sim, feedApp, tests, and iocBoot from the selected
build and removes busy, asyn, and autosave references from feedApp. The QPC
patch removes module references from the unbuilt qpcApp example; the top
Makefile selects digitelQpcApp. Neither patch is required for a successful
strict dependency audit on the current pins.

**Evidence.** Actual `make check.module-deps` returned 0 with both patches
applied, feed-core only, QPC only, and neither applied on 2026-10-01. All
other patches, module selection, generated configuration, and the Rocky
10.2 image were held constant. The shipped individual patch targets set
each state. Raw commands, outputs, timestamps, and pinned source commits
are retained in `work/m15-implementation-20261001/t3-cases/four-combinations/`.
Both patch files are byte-identical to the examined commit; their apply
recipes are unchanged.

**If this returns.** Recheck when the source pins, selected build content,
or dependency audit policy changes. An audit outcome alone does not
authorize changing the selected build content.

Decision Date: 2026-10-01.
Examined at `18243e725e93b3f05c68012a5aac8360c64975f8`; recorded in the
commit that carries this file.

## 2026-10-02

### K12 - Loader metadata steps carry no host or build-type condition

**Premise.** `build.<module>` and `install.<module>` call
`tools/iocsh_metadata.bash` on every host and in every build type. The tool
needs Bash 4.3 or newer, GNU `nm` and `sha256sum`, and ELF `.so` library
names. A macOS host ships Bash 3.2 and Mach-O libraries, and
`scripts/build_modules_libera.bash` runs the same targets in a `linux-arm`
cross-compilation build. Read beside the macOS-only `mca` patch targets and
the Libera scripts, that looks like a missing platform guard.

**Verdict: Keep.** Add no host-system or cross-compilation condition. The
loader targets Linux installations of `softIocPVX`; macOS and Libera builds
are not supported targets of this work, and neither is under active
verification: the macOS patch-revert checks and the Libera cross-build checks
are both Deferred Backlog work.

**Evidence.** `make -n UNAME_S=Darwin build.linStat` and
`make -n CROSS_COMPILER_TARGET_ARCHS=linux-arm build.linStat` each print the
`iocsh_metadata.bash record` and `generate` commands. No macOS or Libera
build was run; the expected macOS failure follows from the tool's stated
requirements, not from an observed run.

**If this returns.** Recheck when macOS or Libera work resumes or a
non-Linux host joins the supported set. A guard would key on the host system
and on `CROSS_COMPILER_TARGET_ARCHS`, replacing the metadata steps and the
wrapper installation with no-ops.

Decision Date: 2026-10-02.
Examined at `6aba72c28f1cf3a093e70e875223d6147463a8df`; recorded in the
commit that carries this file.

## 2026-10-04

### K11 - Installed text metadata keeps the absolute install path

**Premise.** Installed module `configure/RELEASE*` files, base
`configure/CONFIG_SITE.local`, the base pkg-config files, `libuldaq.la`, and
the `S99caRepeater`, `S99logServer`, and `caRepeater.service` files carry
the absolute path of the tree they were installed into, and the module
`RELEASE` files are upstream copies that name foreign paths. Issue #89 read
this as a relocation defect, and the first delivery normalized and refreshed
those files.

**Verdict: Keep.** Leave the installed files as upstream installs them. The
environment is cloned and moved as a whole: binaries find their libraries
through `$ORIGIN` runpaths, `setEpicsEnv.bash` derives every path from its
own location, and module links are relative. Nothing in the environment
reads the installed text metadata: every module EPICS-env builds has
`CHECK_RELEASE = NO` written by `make conf`, and downstream IOCs build the
same way, so the installed module `RELEASE*` files are never consulted;
pkg-config and libtool `.la` files are not used; the service and init files
are installed and run by the operator outside the tree; the base
`CONFIG_SITE.local` has no effect on a downstream build. A tool that
rewrites these files adds state that a clone cannot carry and conflicts with
pulling a new distribution version.

**Evidence.** On 2026-10-03 and 2026-10-04, `grep` of `configure/` showed
`CHECK_RELEASE = NO` written at the top level and for every module that
upstream enables; the only `YES` is the `makeBaseApp` template an IOC author
owns. A copy of a native Rocky Linux 8.10 tree moved with `mv` and nothing
else built an IOC through `iocInit` with `CHECK_RELEASE=YES` once its
EPICS-env-generated declarations were relative to each module's `$(TOP)`,
and the owner confirmed on 2026-10-04 that the remaining files have no
consumer in this environment. The delivered mechanism is removed by M22 in
`docs/milestone-84ee626.md`.

**If this returns.** Recheck only when a consumer that reads installed text
metadata enters the environment, such as a downstream build that must pass
`checkRelease` or a pkg-config user; the fix then belongs in how the file is
generated at install, relative to its own location, not in a post-move
rewrite.

Decision Date: 2026-10-04.
Examined at `fbc01a5bde40d7e4723213b6ecd3e7679ea3d9d1`; recorded in the
commit that carries this file.

### K13 - Static archives are not made reproducible across reinstallation

**Premise.** A repeated `make install` on Rocky Linux 8.10 changes the
content of `modules/opcua-0.11.2/lib/linux-x86_64/libopcua.a`, while the
Debian 13 tree shows no changed file. Read beside the loader's digest
checks, that looks like an installation that is not repeatable.

**Verdict: Keep.** Add no archiver flag and no opcua patch. Two upstream
behaviors combine. The opcua `devOpcuaSup/Makefile` regenerates
`devOpcuaVersionNum.h` on every `make` through the phony prerequisite
`redo-version`, so `devOpcua.o`, `libopcua.a`, and `libopcua.so` are rebuilt
each time on every platform. GNU `ar` 2.30 on Rocky Linux 8.10 defaults to
`U` and writes member timestamps into the archive, while `ar` 2.44 on Debian
13 defaults to `D` and writes zeros, so only the Rocky archive changes. The
environment builds with `SHARED_LIBRARIES=YES` and `STATIC_BUILD=NO`: IOCs
and tools link the shared libraries, the loader records and checks only
shared libraries and DBD files, and the distribution procedure builds every
tree on a new VM. The rebuilt `libopcua.so` keeps its digest.

**Evidence.** On 2026-10-04, `make -d -n` in the opcua build directory on
Debian 13 named `devOpcua.o` as newer than `libopcua.a` after the header
rule ran; `ar --help` showed the two defaults; on Rocky Linux 8.10 a second
`make install.opcua` changed the SHA-256 digest of `libopcua.a` and left
that of `libopcua.so.0.11` unchanged, and `ar tv` listed `devOpcua.o` with
the time of that run.

**If this returns.** Recheck when an installed Rocky tree kept under version
control is reinstalled in place, or when static linking is enabled. The
smallest change is `USR_ARFLAGS += D` in the generated Base site
configuration, which affects every static archive of Base, the modules, and
applications built against the installed Base.

Decision Date: 2026-10-04.
Examined at `fc1d3c63806c8f89c63c13cb0e6cd918c40bf7a4`; recorded in the
commit that carries this file.

### K14 - The library presence check of the wrapper is not reached

**Premise.** `generate_commands` in `tools/iocsh.bash` stops with
`Library of <name> <version> is missing` when a selected library file is
absent or empty. `inspect_elf` runs before it and reads the same files, so a
missing or empty library already ends there with
`ELF inspection could not run`. Read beside the reachable DBD check in the
same function, the library check looks like dead code and the message of the
inspection looks like the wrong one.

**Verdict: Keep.** Leave both checks and their order. The ELF tool names the
file in its own line before the wrapper's line, as `Cannot read object` or
`Not a readable ELF object`, so the report identifies the file. The check in
`generate_commands` guards the commands that function writes and costs one
file test per library; it becomes the reporting check again if the inspection
is ever skipped or reordered.

**Evidence.** On 2026-10-04 on Debian 13, with a copy of `linStat-1.2.1` in a
scratch modules directory, `iocsh.bash -n examples/iocsh/st.cmd` ended with
status 1 after the library was removed, printing `Cannot read object` with
the file and then `ELF inspection could not run`, and again after it was
replaced by an empty file, with `Not a readable ELF object` as first line.

**If this returns.** Recheck when the inspection becomes optional or moves
behind command generation. The smallest change is a presence test in
`inspect_elf` before the tool runs, with the message of `generate_commands`.

Decision Date: 2026-10-04.
Examined at `3fa1ae0cbef4cdfad4e4410ffe5a2a209a8a42d4`; recorded in the
commit that carries this file.

### K15 - Metadata generation accepts a wider version text than the wrapper

**Premise.** `tools/iocsh_metadata.bash` takes `--version` unchecked and a
`--dep` version of any characters except white space and `=`.
`tools/iocsh.bash` requires a version to start with a letter or digit and to
continue with letters, digits, `.`, `_`, `+`, or `-`. A version outside that
set would pass generation and be refused at IOC start as a malformed
dependency.

**Verdict: Keep.** Add no version check to the generator. The versions are
the `SRC_VER_<MODULE_KEY>` values of `configure/RELEASE`, which also name
the install directories, and every value in use fits the narrower set. The
wrapper refuses a value outside it before any library loads and names the
metadata file.

**Evidence.** On 2026-10-04 the 34 versioned module directories of the
Debian 13 candidate, including the second versions of linStat and asyn, all
match the wrapper pattern (`grep -vcE` over the `version=` lines prints 0).

**If this returns.** Recheck when a pin introduces a version with another
character, such as `/` or `~`. The change is the wrapper pattern as a check
of `--version` and `--dep` in `main` of the generator.

Decision Date: 2026-10-04.
Examined at `3fa1ae0cbef4cdfad4e4410ffe5a2a209a8a42d4`; recorded in the
commit that carries this file.

### K16 - Generator and wrapper search DBD includes in different directories

**Premise.** When metadata generation scans a selected DBD file, it resolves
an include in the `dbd` directory of every dependency in the closure. The
wrapper gives `dbLoadDatabase` the `dbd` directory of the module, of each
module loaded earlier that has a DBD entry, of EPICS base, and of pvxs. A
selected DBD that includes a file from a dependency without a DBD entry
would pass generation and fail at IOC start.

**Verdict: Keep.** Leave both search lists. A dependency with DBD entries is
always loaded before its consumer, so its directory is on the wrapper's
path. The modules without a DBD entry are pvxs, whose directory the wrapper
always adds, the sequencer and pyDevSup, whose installed DBD files belong to
their own executables, and pcas and QPC, which install none.

**Evidence.** On 2026-10-04 on the Debian 13 candidate, the include lines of
every DBD file named in an installed `cfg/iocsh.conf` list 23 file names;
none of them exists in `modules/seq/dbd` or `modules/pyDevSup/dbd`, and
`modules/pcas` and `modules/QPC` have no `dbd` directory content.

**If this returns.** Recheck when a module declares an empty
`<module>_IOCSH_DBDS` and installs a DBD file that another module includes.
The change is to add the `dbd` directory of every selected module to the
wrapper's list, whether or not it has a DBD entry.

Decision Date: 2026-10-04.
Examined at `3fa1ae0cbef4cdfad4e4410ffe5a2a209a8a42d4`; recorded in the
commit that carries this file.

## 2026-10-05

### K17 - iocStatsAdmin and the linStat fragments are not loaded together

**Premise.** `iocStatsAdmin.iocsh` loads `iocAdminSoft.db` of devIocStats, and
`linStatHost.iocsh` and `linStatProc.iocsh` load `linStatHost.db` and
`linStatProc.db` of linStat. With the same `IOC` prefix the databases create
records of the same names with different record types, so the second load
fails on type-mismatched duplicates. Read as a defect, the fragments could be
made to coexist by renaming records or by prefixing them.

**Verdict: Keep.** Leave the databases and the record names as they are, and
state the exclusion in each fragment. linStat replaces the devIocStats
administration records, and the site moves its IOCs to linStat gradually.
Renaming records would change the process variable names that running
clients use, to support a combination that the move away from devIocStats
makes unnecessary.

**Evidence.** On 2026-10-05 on the Debian 13 candidate, loading
`linStatHost.iocsh`, `linStatProc.iocsh`, and `iocStatsAdmin.iocsh` with
`IOC=EPICSENV` through `iocsh.bash` printed 33 errors, among them
`already exists, can't load` for `EPICSENV:SYSRESET`, `EPICSENV:CA_CLNT_CNT`,
`EPICSENV:CA_CONN_CNT`, `EPICSENV:RECORD_CNT`, `EPICSENV:FD_MAX`,
`EPICSENV:FD_CNT`, and `EPICSENV:SYS_CPU_LOAD`, and the IOC then ended with a
segmentation fault. The cause of the segmentation fault was not examined. The
integrated fragment test already leaves iocStatsAdmin out for the same
reason.

**If this returns.** Recheck when an IOC must run both sets of records, or
when the segmentation fault shows up with a single set loaded. The change is
then a record prefix for one of the databases, taken with the owners of the
clients that read these names.

Decision Date: 2026-10-05.
Examined at `1bd10af193fbb4cf1f2e0deff5896af5355e06b3`; recorded in the
commit that carries this file.
