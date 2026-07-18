# Work Register

Canonical milestone and carry-forward status for this repository. Every agent
and person reads this file first. Source documents named below remain as
design records and operational evidence; this register holds status.

Mode: remote-authoritative. Each issue's verification checkbox list is the
status source of truth for its M-subs; this register mirrors them, and every
milestone closure ends with a reconcile pass against the tracker.

Cycle: 1.3.0, opened 2026-07-17 on branch `release-1.3.0`. Cycle test plan:
`docs/testplan_1.3.0.md` (verification layers, per-milestone subs, dependency
re-run matrix, release gate). No standing plan exists yet. The released
register and plan are preserved by the release tag.

Next session entry point: M6 (#21, module version bumps; owner picks the set). M8 (#31) and
M9 (#32), added 2026-07-17 from the M2 review pass, are independent and may
run any time before the M7 gate. Do not start carry-forward items unless
the owner explicitly reorders them.

## Milestones — 1.3.0

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| M1 Ubuntu 26.04 C23 bridge | Per-module OS-conditional C17 flags (#29) | Milestone | Complete | Eleven-module C17 bridge in `configure/RULES_MODS_CONFIG` (`b03a830`, `7cc8c1a`); final survey ledger in #29 (11 bridged / 16 clean; set is 28 modules, 27 excluding opcua) |
| M1.T1 | ubuntu26 build: base + 27 modules (opcua excluded), zero dead links, softIoc; flag list minimal | Verification | Complete | 2026-07-17 from-scratch VM build of `release-1.3.0`: 27 modules installed, flag on exactly 11 `CONFIG_SITE.local`, dead links 0, RELEASE deps resolve to one tree, softIoc CA round-trip |
| M1.T2 | debian13 full build confirms the flags are a no-op elsewhere | Verification | Complete | 2026-07-17 debian13 VM full build incl. opcua: zero flagged `CONFIG_SITE.local`, clean install, dead links 0, softIoc CA round-trip; `print-MODS_C17_BRIDGE` empty on host |
| M2 opcua on ubuntu26 | Link failure diagnosis and fix (#30) | Milestone | Complete | GCC 15 mangles the two unnamed-namespace `extern "C"` pvar exports; `patch/opcua-anon-ns-export.p0.patch` via `patch.opcua.export.apply` (`b2f957e`); diagnosis in #30 |
| M2.T1 | Diagnosis recorded, then opcua builds, links, installs on ubuntu26 | Verification | Complete | 2026-07-17 ubuntu26 VM: fresh opcua 0.11.2 + `make patch` + `build.opcua` exit 0, 0 mangled / 33 plain exports, no TEXTREL, 28-module tree, dead links 0; debian13 rebuild behavior-neutral |
| M3 resetEpicsEnv sourcing | `pushdd` terminates the sourcing shell (#27) | Milestone | Complete | Module-symlink loop commented out to match `setEpicsEnv.bash` (`ec357d3`); the only live `pushdd` call site is gone; restore-both decision deferred in #27 |
| M3.T1 | Sourcing shell survives with `EPICS_MODULES` absent; symlink loop verified | Verification | Complete | 2026-07-17: issue reproduction survives rc=0; ubuntu26 real-tree set/reset round-trip restores `PATH` and `LD_LIBRARY_PATH` exactly; shellcheck clean on both scripts |
| M3.T2 | `make check.env` stays green on a normal tree | Verification | Complete | 2026-07-17 ubuntu26 tree: `make check.env` findings 0 |
| M4 CI symlinks gap | ubuntu22/ubuntu24 never run `make symlinks` (#26) | Milestone | Complete | `make patch` + `make symlinks` added to both workflows (`b4dae49`), matching rocky10's explicit order; rehearsed on a fresh ubuntu 24.04 VM first |
| M4.T1 | Both workflows show `make symlinks` executing in a run | Verification | Complete | 2026-07-18 runs 29635291710/29635291757: success, tree shows `pvxs -> ./pvxs-1.5.1`, check.env findings 0 |
| M5 Module deps audit robustness | `check.module-deps` fails under `make -C` on Make 4.2.1 (#28) | Milestone | Complete | `make_value` insulation (`MAKEFLAGS='' make -s --no-print-directory`, `648607a`); three-reviewer pass, spin-offs #35/#36/#38; ansible `cd` workaround retires once consumers run a release with the fix |
| M5.T1 | Reproduce under `make -C` on Rocky 8 Make 4.2.1, then the fix passes the same invocation | Verification | Complete | 2026-07-18: reproduced on a fresh clone; with the fix both forms exit 0, identical output on 4.2.1 and 4.4.1; full `make -C` `github.check` completes on Rocky 8.10 |
| M5.T2 | `check.module-deps` green in the four workflows that run `github.check` | Verification | Complete | 2026-07-18 runs 29639996874-29639996941: seven platforms success; strict audit executed in the four `github.check` runs |
| M6 Module version bumps | Owner-selected bump set (#21; the five named are the floor) | Milestone | Not started | Begins with a fresh `tools/update-release.bash check` (2026-07-17 check: 16 candidates); owner decides the set then |
| M6.T1 | Bumped set builds and installs on debian13 and rocky8.10 VMs; PVXS 1.5.2 `cfg/CONFIG` with `INSTALL_LOCATION` verified | Verification | Not started | |
| M6.T2 | Seven-platform workflows green on the bumped set | Verification | Not started | |
| M6.T3 | Re-run M1.T1 and M3.T1 per the dependency re-run matrix | Verification | Not started | |
| M7 Release gate | 1.3.0 release sequence (register-local, no tracker issue) | Milestone | Not started | Gates merge to `master`, tag `1.3.0`, GitHub release, milestone close |
| M7.T1 | Cycle batch re-run: every milestone's T1 against the final tree | Verification | Not started | |
| M7.T2 | Full automated suites: all seven workflows green on the release branch | Verification | Not started | |
| M7.T3 | Full-environment install verification on real VMs (epics-env-pipeline: internal 2 OS 3 layers; public gz on unblocked OSes) | Verification | Not started | |
| M7.T4 | Release sequence executed per the git-workflow release reference | Verification | Not started | |
| M8 Mangled-export audit | GCC 15 unnamed-namespace export sweep (#31) | Milestone | Not started | Independent; runs before the M7 gate. Sweep procedure in #31 |
| M8.T1 | Sweep evidence recorded; zero mangled registration exports after fixes | Verification | Not started | |
| M9 patch.revert order | Reverse the revert chain (#32) | Milestone | Not started | Independent; runs before the M7 gate. One-line reorder in `configure/RULES_SRC` |
| M9.T1 | `make patch` then `make patch.revert` leaves module sources clean | Verification | Not started | |
| M10 ubuntu22/24 patch gap | Both workflows skip `make patch` (#33) | Milestone | Complete | Landed in the same workflow edit as M4 (`b4dae49`) |
| M10.T1 | Both workflow runs apply the patch set and stay green | Verification | Complete | 2026-07-18: both run logs show the two opcua patches applying; runs green |
| M11 checkout v5 | Upgrade actions/checkout across all workflows (#34) | Milestone | Complete | All eight files on `actions/checkout@v5` (`6af213d`); super-linter untouched |
| M11.T1 | Triggered workflows green on checkout v5; no Node 20 deprecation annotation | Verification | Complete | 2026-07-18 runs 29636101848-29636101869: seven platforms success; zero deprecation annotations (ubuntu22, rocky8 spot-checked) |
| M12 Tool insulation | check_deps and prep-vendors nested make reads (#35) | Milestone | Not started | Same latent pattern #28 fixed in the audit tool; dormant until either runs under an outer `make -C` |
| M12.T1 | Insulated reads verified with the `MAKEFLAGS=w` probe on Rocky 8.10; shellcheck clean | Verification | Not started | |
| M13 Audit doc query name | Design doc says `PRINT.*`, implementation uses `print-%` (#36) | Milestone | Not started | One-word correction plus the format distinction |
| M13.T1 | Document matches the implementation; format distinction stated | Verification | Not started | |
| M14 feed-core promotion | Add upstream feed-core `0472d88`; retire the site-layer `feed` copy (#37) | Milestone | Not started | Base-only deps per the site copy; module name: `feed-core` (owner decision, 2026-07-18) |
| M14.T1 | feed-core builds, installs, symlinks on the build VMs; audit and workflows green | Verification | Not started | |
| M14.T2 | alsu-site-modules `feed` removed; layer-3 build clean against the new tree | Verification | Not started | Must precede the internal distribution production in M7.T3 |
| M15 Module path list guard | `CONFIG_MODS` `.VARIABLES` filter picks up environment names (#38) | Milestone | Not started | Undocumented `SRC_PATH_MODULES=` override now passes silently with a duplicated module block; `$(origin)` guard proposed |
| M15.T1 | Override and exported-environment invocations match the clean-path report | Verification | Not started | |

Tally: Milestones 15 (Complete 7, Not started 8) · Verification subs 24 (Complete 10, Not started 14)

## Carry-forward

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| makeRPath Perl port | Soak build implementation | Carry-forward | Conditional | `configure/RULES_RPATH`, `patch/makeRPath-perl.base.p0.patch` (commit `a74cc1c`, branch `feature/epics-path-relpath`). Code written; awaits re-review against the tree and a soak run. L2-L4 in `design-makeRPath-soak.md` unverified as of 2026-07-09 |
| makeRPath Perl port | Open upstream issue | Carry-forward | Not started | Deferred until after the soak run and #25. The drafted body predates #25 and proposes the approach #25 rejects; rewrite it around the `EPICS::Path` primitives before filing |
| makeRPath Perl port | Open upstream PR | Carry-forward | Blocked | Depends on the upstream issue; enables line-level review and CI |
| makeRPath Perl port | Maintainer calls: `-O` edge-case scope, stderr/help convention | External gate | Conditional | Await maintainer response; resolve only if raised in review |
| EPICS::Path primitives | Build `Normalize` / `RelPath` for makeRPath (#25) | Carry-forward | Not started | Backlog. `makeRPath` needs a no-stat lexical `..` collapse that neither `File::Spec::canonpath` nor `EPICS::Path::AbsPath` provides; build it once in the shared module rather than inside a leaf tool |

The 1.2.1 cycle's sixteen completed milestone rows are preserved in the tag
(`git show 1.2.1:docs/milestone.md`) and in the pre-restructure register
(`git show 5a24f55:docs/milestone.md`).

## GitHub milestones

| Milestone | State | Issues |
| :--- | :--- | :--- |
| 1.2.1 | closed | all closed: #18, #20, #22, #24, #19 |
| 1.3.0 | open | closed: #26, #27, #28, #29, #30, #33, #34; open: #21, #31, #32, #35, #36, #37, #38 |
| Backlog | open | #25 |
| 1.2.2 | closed | Folded into 1.3.0; held only #23, a duplicate of #22 |

## Source documents

- `docs/testplan_1.3.0.md` — the 1.3.0 cycle test plan.
- `docs/README.module-dependency-audit.md` — module dependency audit design,
  phase definitions, and vendor dependency boundary table.
- `docs/makeRPath-perl-port/` — makeRPath design records, test plan, corrected
  port, comparison driver, and the `EPICS::Path` analysis behind #25.

## Branches

| Branch | Carries |
| :--- | :--- |
| `release-1.3.0` | The open 1.3.0 cycle (this register and the cycle plan) |
| `1.2.1` | Release 1.2.1 (shipped); merged to `master` at `b485e14`, tag `1.2.1` |
| `feature/epics-path-relpath` | makeRPath soak build and the `EPICS::Path` design record; branches from `9046fbb` |
