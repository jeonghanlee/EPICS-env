# Cycle Test Plan — 1.3.0

Drafted 2026-07-17 at cycle open. Scope: the six 1.3.0 issues (#21, #26,
#27, #28, #29, #30) ordered M1-M6 in `docs/milestone.md`, plus the M7
release gate. This is a living document: verification cases discovered
during the cycle land under Added During Cycle with a date and the
milestone that surfaced them. The released register and this plan are
preserved by the release tag.

## Verification layers

1. **Change-specific verification** — designed per milestone below,
   depth chosen by blast radius. Executed on the platforms the change
   touches; full-environment claims run on real VMs (the
   epics-env-pipeline procedure), never inferred from CI alone.
2. **Automated suites** — the seven-platform GitHub workflows
   (`make github.check` path: init, patch, vars, conf,
   check.module-deps, build, symlinks) plus `make check.env`. Baseline
   at cycle start: the 1.2.1 release record (tag `1.2.1`, all seven
   workflows green). Cases demanded by acceptance criteria are added to
   the suites as permanent regression assets, not run as one-off
   checks.

## Per-milestone verification

| M | Issue | Change-specific (T1) | Suite coverage (T2) |
| :--- | :--- | :--- | :--- |
| M1 | #29 ubuntu26 C23 bridge | From-scratch ubuntu26 VM build: base + 28 modules (opcua excluded, #30), dead-link zero, `softIoc` prompt; per-module flag list is minimal with reasons | none yet — ubuntu26 CI entry is out of #29 scope |
| M2 | #30 opcua link on ubuntu26 | Diagnosis recorded (trace, PIC rebuild trial, binutils delta vs rocky10), then opcua builds, links, installs on ubuntu26 | none yet — same |
| M3 | #27 resetEpicsEnv sourcing | Source `resetEpicsEnv.bash` in a shell with `EPICS_BASE` set and `EPICS_MODULES` absent; the shell survives and reports; module-symlink loop behavior verified | `check.env` still passes on a normal tree |
| M4 | #26 ubuntu22/24 symlinks gap | Both workflows updated; a run shows `make symlinks` executing on ubuntu22 and ubuntu24 | the two workflows themselves |
| M5 | #28 check.module-deps under make -C | Reproduce on Rocky 8 Make 4.2.1 (`make -C` from outside), then the fix passes the same invocation; in-tree invocation unchanged | `check.module-deps` green in the four workflows that run `github.check` (debian12/13, rocky8/9); the other three never invoke it |
| M6 | #21 module version bumps | Begins with a fresh `tools/update-release.bash check`; the owner selects the final bump set at that point (the five named in #21 are the floor — the 2026-07-17 check already shows 16 candidates, and the list will have moved again). Then: the bumped modules build and install on debian13 and rocky8.10 VMs; PVXS 1.5.2 `cfg/CONFIG` handling verified with `INSTALL_LOCATION` set | seven-platform workflows green on the bumped set |

T-sub notation: T1 change-specific, T2 suite/regression, T3 re-run of an
earlier milestone per the matrix below, T4 standing-plan amendment.
Checkbox status lives in each issue (remote-authoritative mode); the
register mirrors it.

## Dependency re-run matrix

| Trigger | Re-runs | Shared surface |
| :--- | :--- | :--- |
| M6 (#21 bumps) | M1.T1 (ubuntu26 build minus opcua) | module set contents; iocStats 4.0.1 carries the same C23 code, pvxs 1.5.2 changes `cfg/CONFIG` handling |
| M6 (#21 bumps) | M3.T1 (resetEpicsEnv behavior) | module symlink population the script walks |
| M1 (#29 per-module conf) | one debian13 full build | module conf generation is shared; the OS-conditional flags must be a no-op elsewhere |
| M5 (#28 tool fix) | `check.module-deps` on the four `github.check` workflows | the audit tool runs inside `github.check`; rocky10/ubuntu22/ubuntu24 run explicit target lists without it |

## Release gate (M7)

Executed in order on the final `release-1.3.0` tree:

1. Cycle batch re-run — every milestone's T1 against the final tree,
   the first state where all changes coexist.
2. Full automated suites: all seven workflows green on the release
   branch.
3. Full-environment install verification on real VMs via the
   epics-env-pipeline procedure: internal branch (2 OS, 3 layers) and
   public branch (gz; all OSes whose blockers closed this cycle),
   with the pipeline verification gates all green.
4. Release sequence per the git-workflow release reference: merge, tag
   `1.3.0`, GitHub release, milestone close, register close-out.

No standing gate document exists in this repository yet; if one is
introduced, it supersedes item 4's inline listing and this section
instantiates it by reference.

## Added During Cycle

- 2026-07-17, surfaced by the M2 review pass: **M8** (#31) — sweep every
  installed module shared library on ubuntu26 for GCC 15 unnamed-namespace
  mangled registration exports (`nm -D`, `pvar_*` or registrar symbols with
  the `_ZN12_GLOBAL__N_1` prefix). M8.T1 records per-module counts and
  requires zero mangled registration exports after fixes.
- 2026-07-17, surfaced by the M2 review pass: **M9** (#32) — reverse the
  `patch.revert` prerequisite chain in `configure/RULES_SRC`. M9.T1 verifies
  `make patch` followed by `make patch.revert` returns clean module source
  trees on a fresh checkout.
- 2026-07-17, surfaced by the M4 fix: **M10** (#33) — ubuntu22/ubuntu24
  workflows also skip `make patch`; `make patch` joins the same workflow
  edit as the M4 symlinks fix. M10.T1 shares M4.T1's verification runs:
  both logs must show the patch set applying and the runs staying green.
- 2026-07-18, surfaced by the M4 verification runs: **M11** (#34) — every
  workflow pins `actions/checkout@v4` (Node 20 generation) and each run
  warns about the Node 20 deprecation. Upgrade all eight files to
  `actions/checkout@v5`; `super-linter` stays untouched (Docker action).
  M11.T1: triggered workflows green, no deprecation annotation.
- 2026-07-18, surfaced by the M5 review pass: **M12** (#35) — apply the #28
  insulation (`MAKEFLAGS='' make -s --no-print-directory`) to the nested
  `make print-*` reads in `tools/check_deps.bash` and
  `tools/prep-vendors.bash`; dormant today, activates under an outer
  `make -C` on Make 4.2.1. M12.T1: `MAKEFLAGS=w` probe clean on Rocky 8.10.
- 2026-07-18, surfaced by the M5 review pass: **M13** (#36) — the audit
  design document names `make PRINT.*` where the implementation uses
  `print-%` (different output format). M13.T1: document corrected with the
  format distinction.
- 2026-07-18, owner request: **M14** (#37) — promote BerkeleyLab feed-core
  (commit `0472d88`) into the EPICS-env module set and retire the
  site-layer `feed` copy (internal mirror at `2b77e0cb`, base-only deps).
  M14.T1: VM build/install/symlink plus audit and workflows green.
  M14.T2: alsu-site-modules builds clean without `feed` against the new
  tree — ordered before the internal distribution production in M7.T3.
- 2026-07-18, surfaced by the M5 adversarial review pass: **M15** (#38) —
  `configure/CONFIG_MODS` filters `SRC_PATH_%` names out of `.VARIABLES`,
  which includes environment-origin names; an undocumented
  `SRC_PATH_MODULES=` override now yields a silently corrupted audit
  report (duplicated module block). Guard the filter with `$(origin)`.
  M15.T1: override and exported-environment invocations match the
  clean-path report byte-for-byte.
