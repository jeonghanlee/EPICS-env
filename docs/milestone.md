# Work Register

Canonical milestone and carry-forward status for this repository. Every agent
and person reads this file first. Source documents named in the table remain as
design records and operational evidence; this register holds status.

GitHub milestone assignment and issue state are authoritative; this register
mirrors them. Evidence cells hold either durable evidence (a commit hash, a
decision) or a dated judgment with the command that established it. Re-run the
command before reporting a dated judgment as current.

Next session entry point: open the 1.3.0 cycle. Release 1.2.1 shipped
2026-07-10 (merge `b485e14`, annotated tag `1.2.1`, GitHub release published,
milestone closed). The 1.3.0 milestone holds #21 (module version bumps),
#26 (ubuntu symlinks gap), #27 (resetEpicsEnv sourcing), #28
(check.module-deps under make -C), #29 (Ubuntu 26.04 C23 module bridge),
and #30 (opcua link failure on Ubuntu 26.04). Do not start
carry-forward items unless the owner explicitly reorders them.

## Milestones

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| Module dependency audit | Phase 4A inventory report | Milestone | Complete | `tools/audit_module_deps.bash`, `make audit.module-deps` (commit `2c37370`) |
| Module dependency audit | Phase 4B source evidence expansion | Milestone | Complete | DB/DBD/protocol/startup/header scanners (commit `7ff6a33`) |
| Module dependency audit | Phase 4C strict check gate | Milestone | Complete | `make check.module-deps`, exit 2 on strict findings (commit `6391d31`) |
| Module dependency audit | Phase 4D CI integration | Milestone | Complete | `make github.check` aggregate target (commit `e49badf`) |
| Module dependency audit | Phase 4 closure | Milestone | Complete | Zero strict findings, CI uses `github.check` (commit `eee95fe`) |
| Module dependency audit | Vendor dependency boundary | Milestone | Complete | Documentation-only table in `docs/README.module-dependency-audit.md` (commit `d275784`) |
| Base 7.0.10 python | Bare `python` on python3-only hosts (#18) | Milestone | Complete | Issue #18 closed; the fix is what release 1.2.1 packages |
| update-release | Tag-aware version comparison (#22) | Milestone | Complete | `git ls-remote --tags --refs` in `tools/update-release.bash:231` (commits `04adf3c`, `75eb1a8`); issue #22 closed. #23 was an accidental duplicate |
| Makefile system cleanup | Seven `configure/` fixes (#20) | Milestone | Complete | Items 1-6 in commit `9de4c90`; item 7 (`configure/RELEASE.bak`) was never tracked and was removed from the working tree. Issue #20 closed. Acceptance criteria verified 2026-07-10: `make print-PATH_NAME_MODULES` prints `modules`; `make vars` header reads `Current Environment Variables`; `grep -rl PHONEY configure/` and `grep -rl PATH_NANE_MODULES configure/` both empty; `configure/RELEASE.bak` absent |
| setEpicsEnv bundle path | Remove dead `pvxs/bundle` path (#24) | Milestone | Complete | Commit `04a7f0e`. Issue #24 closed by the `Closes #24` footer on the merge to `master` (`b485e14`) |
| setEpicsEnv bundle path | `check.env` regression guard | Milestone | Complete | `tools/check_env.bash`, `configure/RULES_ENV_CHECK`, `make check.env` in all seven CI workflows (commit `04a7f0e`). Reviewed in session rs20260709_025704; verification matrix 23/23 |
| Release 1.2.1 | Seven-platform build, tag, release notes (#19) | Milestone | Complete | Shipped 2026-07-10. Seven-platform CI green plus local Rocky 8.10 / Debian 13 VM builds; ChangeLog `f22d482`; merge to `master` `b485e14`; annotated tag `1.2.1`; GitHub release published; issue #19 closed; 1.2.1 milestone closed |
| makeRPath Perl port | Corrected port + comparison driver | Milestone | Complete | `cases=37 pass=37 fail=0` vs `makeRPath.py` (commit `d3726ff`) |
| makeRPath Perl port | Test plan documented | Milestone | Complete | `docs/makeRPath-perl-port/test-plan-makeRPath.md` (commit `9046fbb`) |
| makeRPath Perl port | Upstream baseline preserved | Milestone | Complete | `docs/makeRPath-perl-port/makeRPath.anjohnson.pl`, the file upstream PR #589 added and `a3d8531` reverted one day later (commit `19de635`, branch `feature/epics-path-relpath`) |
| makeRPath Perl port | Issue body drafted | Milestone | Complete | `docs/makeRPath-perl-port/issue-makeRPath-pl.md`. The draft proposes the hand-rolled corrected port and must be rewritten around the #25 approach before it is filed |
| makeRPath Perl port | Soak build implementation | Milestone | Conditional | `configure/RULES_RPATH`, `patch/makeRPath-perl.base.p0.patch` (commit `a74cc1c`, branch `feature/epics-path-relpath`). Code written; awaits re-review against the tree and a soak run. L2-L4 in `design-makeRPath-soak.md` unverified as of 2026-07-09 |
| makeRPath Perl port | Open upstream issue | Milestone | Not started | Deferred until after the soak run and #25. The drafted body predates #25 and proposes the approach #25 rejects; rewrite it around the `EPICS::Path` primitives before filing |
| makeRPath Perl port | Open upstream PR | Milestone | Blocked | Depends on the upstream issue; enables line-level review and CI |
| makeRPath Perl port | Maintainer calls: `-O` edge-case scope, stderr/help convention | External gate | Conditional | Await maintainer response; resolve only if raised in review |
| EPICS::Path primitives | Build `Normalize` / `RelPath` for makeRPath (#25) | Milestone | Not started | Backlog. `makeRPath` needs a no-stat lexical `..` collapse that neither `File::Spec::canonpath` nor `EPICS::Path::AbsPath` provides; build it once in the shared module rather than inside a leaf tool |
| Module version bumps | Five tag-pinned modules to 1.3.0 (#21) | Milestone | Not started | `ether_ip` 3-10, `iocStats` 4.0.1, `linStat` 1.2.1, `pmac` 2-7-9, `pvxs` 1.5.2. PVXS 1.5.2 changes `cfg/CONFIG` handling when `INSTALL_LOCATION` is set, which this repository sets |
| CI symlinks gap | ubuntu22/ubuntu24 never run `make symlinks` (#26) | Milestone | Not started | The other five reach `symlinks` via `make github.check` or an explicit call; these two run `init/conf/vars/build/install` only |
| resetEpicsEnv sourcing | `pushdd` terminates the sourcing shell (#27) | Milestone | Not started | `scripts/resetEpicsEnv.bash:27` `pushd ... \|\| exit` fires when `EPICS_BASE` is set and `EPICS_MODULES` is absent. Also tracks the live module-symlink loop that `setEpicsEnv.bash` no longer feeds |
| Module deps audit robustness | `check.module-deps` fails under `make -C` on Make 4.2.1 (#28) | Milestone | Not started | `tools/audit_module_deps.bash:118` `make_value` runs a nested `make -C "$TOP"`; the outer `make -C` on Rocky 8's Make 4.2.1 leaks `$(TOP)` into a module name. Workaround (`cd` not `-C`) is in the ansible-provision epics_env_build role. Found automating the from-source build |
| Ubuntu 26.04 support | Per-module C17 bridge for C23-default GCC 15 (#29) | Milestone | Not started | GCC 15.2 defaults to C23; `sequencer` (`lemon.c` K&R) and `iocStats` (DSET initializers) fail hard, 14 modules cascade behind sequencer, 11 pass clean. iocStats 4.0.1 carries the same code, so #21 alone does not resolve it. Found by the epics-env-pipeline Stage 3 run, 2026-07-17 |
| Ubuntu 26.04 support | opcua link failure diagnosis (#30) | Milestone | Not started | `pvar_*` registration symbols unresolved at the final IOC link although `nm` shows them exported from `libopcua`; plus a `DT_TEXTREL` warning from the non-PIC vendored open62541. Same module links clean on debian13/rocky8/rocky10 |

Tally: Complete 16 · Not started 8 · Conditional 2 · Blocked 1

## GitHub milestones

| Milestone | State | Issues |
| :--- | :--- | :--- |
| 1.2.1 | closed | all closed: #18, #20, #22, #24, #19 |
| 1.3.0 | open | #21, #26, #27, #28, #29, #30 |
| Backlog | open | #25 |
| 1.2.2 | closed | Folded into 1.3.0; held only #23, a duplicate of #22 |

## Source documents

- `docs/README.module-dependency-audit.md` — module dependency audit design,
  phase definitions, and vendor dependency boundary table.
- `docs/makeRPath-perl-port/issue-makeRPath-pl.md` — drafted upstream issue:
  regression analysis, corrected port, and inline test driver. Superseded in
  approach by issue #25; not yet rewritten.
- `docs/makeRPath-perl-port/test-plan-makeRPath.md` — 37-case test plan and
  reference behavior.
- `docs/makeRPath-perl-port/makeRPath.pl` — corrected Perl port.
- `docs/makeRPath-perl-port/makeRPath.anjohnson.pl` — the reverted upstream
  baseline the corrected port extends.
- `docs/makeRPath-perl-port/compare_makeRPath.sh` — Python-vs-Perl comparison
  driver.
- `docs/makeRPath-perl-port/design-makeRPath-soak.md` — soak design and the
  L1-L4 verification plan (branch `feature/epics-path-relpath`).
- `docs/makeRPath-perl-port/relpath-design-analysis.md` — relpath edge cases and
  the `EPICS::Path` design that issue #25 carries.

## Branches

| Branch | Carries |
| :--- | :--- |
| `1.2.1` | Release 1.2.1 (shipped); merged to `master` at `b485e14`, tag `1.2.1` |
| `feature/epics-path-relpath` | makeRPath soak build and the `EPICS::Path` design record; branches from `9046fbb` |
