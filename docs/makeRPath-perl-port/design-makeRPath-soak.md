# makeRPath Perl Port — 1.2.1 Soak Design (Review Draft)

Status: **implementation written, pending re-review**. The L1 driver path fix is
applied and verified (`cases=37 pass=37 fail=0` from default paths). The soak
code — the `base.rpath` rule and edits C1–C6 (C1–C4 in the clone, C5–C6 in our
`configure/`) — is now written as `configure/RULES_RPATH` and
`patch/makeRPath-perl.base.p0.patch`. No soak run has been performed, and L2–L4
below are unverified. Review the code against this document, not the plan alone.

## Goal

Run the corrected Perl `makeRPath` as the **installed** rpath tool in a 1.2.1
build, so that base itself and every downstream IOC/module build compute their
`$ORIGIN` RUNPATH through the Perl port instead of `makeRPath.py`. Soak it for
several months in a dedicated test environment before committing to the upstream
PR form.

Out of scope: the upstream PR (separate branch — cherry-pick the upstream
baseline, corrected port, `.plt` test). The corrected port and its 37-case
parity driver are already complete under this directory. The upstream baseline
is `makeRPath.anjohnson.pl` — the file added by epics-base PR #589 and reverted
one day later by `a3d8531`; the corrected port extends it.

## Verified facts (evidence)

1. **Override hook reaches downstream.** Installed base carries
   `.../base/configure/CONFIG_SITE.local`, and installed `CONFIG_SITE:182` has
   `-include $(CONFIG)/CONFIG_SITE.local`. The installed file contains the
   `conf.base.site` output (`LINKER_USE_RPATH`, `PYTHON = python3`, ...).
   Evidence: `/home/jeonglee/alsu-epics/1.2.0/debian-13/7.0.10/base/configure/`.
   → A `MAKERPATH` override placed in `CONFIG_SITE.local` propagates to the
   install tree and is read by downstream builds.
2. **Load order makes the override win.** `epics-base-src/configure/CONFIG`
   includes `CONFIG_BASE` (line 55) before `CONFIG_SITE` (line 59, which pulls
   `CONFIG_SITE.local`). `MAKERPATH` is `=` (lazy) and consumed at
   `RULES_BUILD:217`, well after config load.
3. **Installed tool location.** `MAKERPATH = $(PYTHON) $(TOOLS)/makeRPath.py`
   with `TOOLS = $(abspath $(EPICS_BASE_HOST_BIN))` (installed bin). `makeRPath`
   installs via `src/tools/Makefile` `PERL_SCRIPTS`. So the `.pl` must land in
   `$(INSTALL_LOCATION_BASE)/bin/$(ARCH)/`.
4. **`makeRPath.py` references.** Only three: `CONFIG_BASE:58` (definition),
   `RULES_BUILD:217` (comment), `src/tools/Makefile:53` (install). No other
   invocation — removal is safe once the install line and `MAKERPATH` are
   redirected.

## Central review question — MAKERPATH mechanism

Decision "remove `makeRPath.py`" couples to this choice:

- **α — edit `CONFIG_BASE` (form A).** `CONFIG_BASE:58` → `$(PERL)
  $(TOOLS)/makeRPath.pl`. Self-consistent, no dangling default, identical to the
  upstream PR form. Cost: one tracked base-source edit.
- **β — `CONFIG_SITE.local` hook.** Leave `CONFIG_BASE`; append `MAKERPATH =
  $(PERL) $(TOOLS)/makeRPath.pl` to the generated `CONFIG_SITE.local`. Version-
  independent (epics-build skill preference). Cost: installed `CONFIG_BASE`
  default still names the removed `.py` (functionally overridden, cosmetically
  dangling) — so β pairs better with **keeping** `.py` as a fallback.

Recommendation: **α** — confirmed in review, together with removing the `.py`
source file (C3). α matches the eventual PR; clone edits are sanctioned
(rollback = re-clone).

## Planned changes (for α)

| ID | File | Change | Tree |
| :-- | :-- | :-- | :-- |
| C1 | `epics-base-src/src/tools/makeRPath.pl` | add (copy of `docs/makeRPath-perl-port/makeRPath.pl`) | clone |
| C2 | `epics-base-src/src/tools/Makefile:53` | `PERL_SCRIPTS += makeRPath.py` → `makeRPath.pl` | clone |
| C3 | `epics-base-src/src/tools/makeRPath.py` | remove the source file (matches dd4120d / form A) | clone |
| C4 | `epics-base-src/configure/CONFIG_BASE:58` | `$(PYTHON) …/makeRPath.py` → `$(PERL) $(TOOLS)/makeRPath.pl` | clone |
| C5 | `configure/RULES_RPATH` (new) + include in `configure/RULES` | opt-in `base.rpath` (prereq `clone.base`) applying C1–C4, then `conf.base build.base install.base check.rpath.base` | our repo |
| C6 | `configure/RULES_RPATH` | new `check.rpath.base`: exit non-zero if any installed RUNPATH embeds a build-tree path (`O.<arch>/` or the source tree) | our repo |

`base.rpath` depends on `clone.base` for a fresh tree, and on the
`base.rpath.prepare` preflight (see Implementation notes) for an existing clone.
`RULES_RPATH` is a temporary, self-contained file so it can be removed wholesale
after the soak.

## Implementation notes

- **Sequencing.** `base.rpath` must call `conf.base`, `build.base`,
  `install.base`, and `check.rpath.base` sequentially inside the recipe via
  `$(MAKE) <target>`, not as plain prerequisites — a plain prerequisite list can
  be reordered under `make -j`.
- **Q2 resolved — p0 patch convention.** The clone line edits follow the repo's
  existing pattern (`patch/*.base.p0.patch` applied by `patch -d $(SRC_PATH_BASE)
  -p0`): C2 (`src/tools/Makefile`) and C4 (`configure/CONFIG_BASE`) ship as
  `patch/makeRPath-perl.base.p0.patch`. C1 (`cp` the `.pl`) and C3 (`rm` the
  `.py`) stay as recipe steps to keep the generated-file copy and removal
  explicit (local convention) — a `git diff --no-prefix` patch could express the
  add/delete, but the explicit `cp`/`rm` reads more clearly in the recipe. The
  patch is generated with `git -C $(SRC_PATH_BASE) diff --no-prefix` and reverts
  by re-clone.
- **Preflight on an existing clone.** `clone.base` skips when `epics-base-src`
  already exists, so `base.rpath` must not assume a fresh tree. A
  `base.rpath.prepare` step restores the C1–C4 target files to pristine first —
  `git -C $(SRC_PATH_BASE) checkout -- src/tools/Makefile configure/CONFIG_BASE
  src/tools/makeRPath.py` and removes any stale `src/tools/makeRPath.pl`. This
  prevents C1–C4 residue from a prior run mixing into the soak. The reset is
  scoped to those files only, so unrelated clone dirt is left untouched and must
  be checked separately — the known `CONFIG_SITE_ENV` change is harmless because
  `conf.base.env` regenerates it.
- **Independent install location.** The soak installs to a dedicated root,
  isolated from the production tree: `INSTALL_LOCATION=/data/epics-1.2.1-rpath`
  via the repo's `configure/CONFIG_SITE.local` override hook, which sets
  `INSTALL_LOCATION_EPICS` and thus `INSTALL_LOCATION_BASE`. The alsu-epics tree
  is untouched.

## Verification plan

| Layer | Command | Pass condition |
| :-- | :-- | :-- |
| L1 unit | `bash docs/makeRPath-perl-port/compare_makeRPath.sh` | `cases=37 pass=37 fail=0` from default paths (line-13 fix applied, verified) |
| L2 install RUNPATH | `make check.rpath.base` (new gate; `make readelf.runpath.base` for display) | exits non-zero if any RUNPATH embeds a build-tree path; clean RUNPATH is `$ORIGIN`-relative (`$ORIGIN/.`, `$ORIGIN/../../lib/linux-x86_64`) — the #589 signature is a build-dir path after `$ORIGIN/` |
| L3 coverage | `EPICS_DEBUG_RPATH=YES make base.rpath 2> work/rpath-calls.log` | every captured `[<script> <args>]` line in `work/rpath-calls.log` maps to an L1 case: extract the arg vectors and diff against the 37 cases; add a case for any uncovered shape |
| L4 downstream | build a module against the installed base, `readelf -d` its bins | RUNPATH resolves to base `lib` via `$ORIGIN` |

Reference (upstream #589 thread): the regression produced
`$ORIGIN/../../modules/database/src/ioc/O.linux-x86_64/.../lib/linux-x86_64`
(build dir leaked); the corrected post-revert form is `$ORIGIN/.` and
`$ORIGIN/../../lib/linux-x86_64`.

## Rollback

`make distclean.base` then re-clone (`make clone.base`) restores a pristine
`epics-base-src`. Remove `configure/RULES_RPATH` and its `include` line.

## Resolved review decisions

1. Mechanism **α** — confirmed in review, with `.py` source removal (C3).
2. Clone edits delivered as the p0 patch convention: C2/C4 in
   `patch/makeRPath-perl.base.p0.patch`, C1/C3 as recipe steps.
3. `makeRPath.pl` install mode — host `PERL_SCRIPTS` → `SCRIPTS_HOST` →
   `INSTALL_BIN`, `BIN_PERMISSIONS=755`.
