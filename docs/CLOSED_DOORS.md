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
