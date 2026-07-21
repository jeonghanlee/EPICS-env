# Work Register

Canonical milestone and carry-forward status for this repository. Every agent
and person reads this file first. Source documents named below remain as design
records and operational evidence; this register holds status.

Mode: remote-authoritative. Each issue's verification checkbox list is the status
source of truth for its M-subs; this register mirrors them, and every milestone
closure ends with a reconcile pass against the tracker.

Cycle: 1.2.2 (DT_RUNPATH respin), opened 2026-07-20 on branch `release-1.2.2`.
Cycle test plan: `docs/plantest_1.2.2.md`. Milestone `1.2.2` (#2) was reopened and
repurposed from its folded state for this respin. The forward-port of the fix to
1.3.0/master is tracked as M21 on the `release-1.3.0` line (issue #47), not here.

Next session entry point: M3 (#46, vendor confirm). M2 code + docs landed at 862ffb0
(strict-default gate, --report-only); M2 stays In progress — the exit-0 corrected-tree
half and the distribution install.bash wiring carry to the M4 gate. Order M2 (residual)
-> M3 -> M5 (CI wiring) -> M4 release gate; the forward-port (1.3.0 M21) follows the
1.2.2 release, and the open 1.3.0 cycle (M6, M7) resumes after M21.

## Milestones — 1.2.2

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| M1 base DT_RUNPATH flag | base + modules emit DT_RUNPATH not DT_RPATH on Rocky/RHEL (#44) | Milestone | In progress | `SHRLIB_LDFLAGS`/`LOADABLE_SHRLIB_LDFLAGS += -Wl,--enable-new-dtags` into `os/CONFIG_SITE.linux-x86_64.linux-x86_64` (loaded after `CONFIG.gnuCommon`) via `conf.base.site` (`RULES_BASE`); mechanism gate PASS (`make -pn` flattened flag survives the `=`-reset); 2 plan-review rounds + 3-reviewer impl review, 0 blocking; readelf observable at M4 |
| M1.T1 | `readelf.base` (both tags) + `readelf.modules`: zero DT_RPATH + DT_RUNPATH present, Rocky 8.10/10.2 (Debian unchanged); site-modules verified in the alsu repo | Verification | Not started | deferred to the M4 per-OS rebuild (this host is Debian, already RUNPATH) |
| M2 dependency-check gate | `check_deps.bash` must fail on RPATH / unversioned `.so` (#45) | Milestone | In progress | strict default + `--report-only` opt-out, `*.so`->`*.so*`, empty-`$ORIGIN` system-only exemption; code + docs landed at 862ffb0, real-tree verify done (exit 2 on a populated RPATH tree 72/76, base lib find 1->13, libVimbaC exempt); wire prep-vendors done, distribution install.bash pending; exit-0 corrected-tree half depends on M1+M3 |
| M2.T1 | `check_deps.bash` (strict default) exits 2 on a populated RPATH tree, exits 0 on the corrected tree; `--report-only` exits 0; broadened `find` selects real `*.so.N`; empty-`$ORIGIN` exempts system-only blob | Verification | In progress | exit-2 / find 1->13 / `--report-only` / libVimbaC-exempt verified on real tree; exit-0 (corrected) deferred to M4 (M1+M3); lost-`$ORIGIN` FLAG has no natural fixture, constructed-object only |
| M3 vendor confirm | `uldaq` / `open62541` emit DT_RUNPATH on the rebuild (#46) | Milestone | Not started | no code change; `readelf -d` confirm |
| M3.T1 | `readelf -d` vendor `.so`: DT_RUNPATH present, zero DT_RPATH, Rocky 8.10/10.2 | Verification | Not started | |
| M5 CI wiring | wire `check_deps.bash` into CI as a post-install gate (#50) | Milestone | In progress | `RULES_DEPS_CHECK` (audit.deps/check.deps mirror of check.env) + `configure/RULES` include + `make audit.deps` in all seven workflows; targets verified (`make audit.deps` exit 0 / `make check.deps` exit 2 on a populated RPATH tree); strict `check.deps` flip + exit-0 confirm at M4 |
| M5.T1 | `make audit.deps` exits 0 (report-only) and `make check.deps` exits 2 on a populated RPATH tree; `make audit.deps` runs post-install in all seven workflows | Verification | In progress | `make audit.deps` 0 / `make check.deps` 2 verified on real tree; in-CI report + strict flip (exit 0 on corrected tree) at M4 |
| M4 release gate | 1.2.2 release sequence (register-local, no tracker issue) | Milestone | Not started | gates rebuild + verify per OS and on-target `ldd`, then merge to `master`, tag `1.2.2`, GitHub release, milestone close (gate-then-publish); flip the seven workflows from `audit.deps` to `check.deps` once the corrected tree exits 0; release notes must call out the breaking exit-code change (`check_deps.bash` default now exit 2) |
| M4.T1 | cycle batch re-run (M1.T1/M2.T1/M3.T1/M5.T1 on the final tree) + seven-platform suites green + per-OS on-target `ldd` no `not found` | Verification | Not started | |

Tally: Milestones 5 (In progress 3, Not started 2) · Verification subs 5 (In progress 2, Not started 3)

## GitHub milestones

| Milestone | State | Issues |
| :--- | :--- | :--- |
| 1.2.2 | open | #44, #45, #46, #50 (this respin); #23 closed (historical, a #22 duplicate) |
| 1.3.0 | open | forward-port #47 (M21); the open 1.3.0 cycle #21, #37 |
| Backlog | open | #25, #49 |
| 1.2.1 | closed | shipped: tag `1.2.1` = `b485e14`, all issues closed |

## Source documents

- `docs/plantest_1.2.2.md` — the 1.2.2 cycle test plan (verification layers,
  per-milestone subs, dependency re-run matrix, release gate).
- Issue bodies #44-#47 are the durable design record for the fix.

## Branches

| Branch | Carries |
| :--- | :--- |
| `release-1.2.2` | The 1.2.2 DT_RUNPATH respin cycle (this register and `docs/plantest_1.2.2.md`) |
| `release-1.3.0` | The open 1.3.0 cycle (M1-M20; M21 forward-port #47) |
| `1.2.1` | Release 1.2.1 (shipped); merged to `master` at `b485e14`, tag `1.2.1` |
| `feature/epics-path-relpath` | makeRPath soak build and the `EPICS::Path` design record |
