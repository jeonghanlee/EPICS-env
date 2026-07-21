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

Next session entry point: M2 (#45, dependency-check gate). M1 code + mechanism done
(readelf observable at M4); order M2 -> M3 -> the M4 release gate; the forward-port
(1.3.0 M21) follows the 1.2.2 release, and the open 1.3.0 cycle (M6, M7) resumes
after M21.

## Milestones — 1.2.2

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| M1 base DT_RUNPATH flag | base + modules emit DT_RUNPATH not DT_RPATH on Rocky/RHEL (#44) | Milestone | In progress | `SHRLIB_LDFLAGS`/`LOADABLE_SHRLIB_LDFLAGS += -Wl,--enable-new-dtags` into `os/CONFIG_SITE.linux-x86_64.linux-x86_64` (loaded after `CONFIG.gnuCommon`) via `conf.base.site` (`RULES_BASE`); mechanism gate PASS (`make -pn` flattened flag survives the `=`-reset); 2 plan-review rounds + 3-reviewer impl review, 0 blocking; readelf observable at M4 |
| M1.T1 | `readelf.base` (both tags) + `readelf.modules`: zero DT_RPATH + DT_RUNPATH present, Rocky 8.10/10.2 (Debian unchanged); site-modules verified in the alsu repo | Verification | Not started | deferred to the M4 per-OS rebuild (this host is Debian, already RUNPATH) |
| M2 dependency-check gate | `check_deps.bash` must fail on RPATH / unversioned `.so` (#45) | Milestone | Not started | `--strict`, `*.so`->`*.so*`, empty-`$ORIGIN` system-only exemption; wire prep-vendors + distribution install.bash; the exit-0 pass depends on M1 |
| M2.T1 | `install.bash check-deps --strict` exits 2 on 1.2.1 RPATH tree, exits 0 on corrected tree; broadened `find` selects real `*.so.N`; empty-`$ORIGIN` exemption correct | Verification | Not started | |
| M3 vendor confirm | `uldaq` / `open62541` emit DT_RUNPATH on the rebuild (#46) | Milestone | Not started | no code change; `readelf -d` confirm |
| M3.T1 | `readelf -d` vendor `.so`: DT_RUNPATH present, zero DT_RPATH, Rocky 8.10/10.2 | Verification | Not started | |
| M4 release gate | 1.2.2 release sequence (register-local, no tracker issue) | Milestone | Not started | gates rebuild + verify per OS and on-target `ldd`, then merge to `master`, tag `1.2.2`, GitHub release, milestone close (gate-then-publish) |
| M4.T1 | cycle batch re-run (M1.T1/M2.T1/M3.T1 on the final tree) + seven-platform suites green + per-OS on-target `ldd` no `not found` | Verification | Not started | |

Tally: Milestones 4 (In progress 1, Not started 3) · Verification subs 4 (Not started 4)

## GitHub milestones

| Milestone | State | Issues |
| :--- | :--- | :--- |
| 1.2.2 | open | #44, #45, #46 (this respin); #23 closed (historical, a #22 duplicate) |
| 1.3.0 | open | forward-port #47 (M21); the open 1.3.0 cycle #21, #37 |
| Backlog | open | #25 |
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
