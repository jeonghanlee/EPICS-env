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

Next session entry point: M4 release gate (register-local, no tracker issue). M2
(862ffb0) and M5 (2508f74) code landed; M3 is a no-code verification folded into the
M4 rebuild. Per-OS verification: debian13 + rocky8 CONFIRMED full 3-layer (check_deps exit 0
over base+modules+vendor+support+site, 78 modules, via skill-only agent runs);
rocky10 pending; version not yet bumped (installs to /opt/epics/1.2.1/). M4 rebuilds per OS, runs the cycle batch (M1.T1/M2.T1/M3.T1/M5.T1), flips
the seven workflows audit.deps -> check.deps and confirms exit 0, then merges to
master, tags 1.2.2, GitHub release, milestone close. The forward-port (1.3.0 M21)
follows the 1.2.2 release, and the open 1.3.0 cycle (M6, M7) resumes after M21.

## Milestones — 1.2.2

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| M1 base DT_RUNPATH flag | base + modules emit DT_RUNPATH not DT_RPATH on Rocky/RHEL (#44) | Milestone | In progress | `SHRLIB_LDFLAGS`/`LOADABLE_SHRLIB_LDFLAGS += -Wl,--enable-new-dtags` into `os/CONFIG_SITE.linux-x86_64.linux-x86_64` (loaded after `CONFIG.gnuCommon`) via `conf.base.site` (`RULES_BASE`); mechanism gate PASS (`make -pn` flattened flag survives the `=`-reset); 2 plan-review rounds + 3-reviewer impl review, 0 blocking; readelf observable at M4 |
| M1.T1 | `readelf.base` (both tags) + `readelf.modules`: zero DT_RPATH + DT_RUNPATH present, Rocky 8.10/10.2 (Debian unchanged); site-modules verified in the alsu repo | Verification | In progress | debian13 + rocky8 CONFIRMED full 3-layer (base+support+site, zero DT_RPATH, RUNPATH `[$ORIGIN/.]`, 78 modules); Rocky 10.2 pending |
| M2 dependency-check gate | `check_deps.bash` must fail on RPATH / unversioned `.so` (#45) | Milestone | In progress | strict default + `--report-only` opt-out, `*.so`->`*.so*`, empty-`$ORIGIN` system-only exemption; code + docs landed at 862ffb0, real-tree verify done (exit 2 on a populated RPATH tree 72/76, base lib find 1->13, libVimbaC exempt); wire prep-vendors done, distribution install.bash pending; exit-0 corrected-tree half depends on M1+M3 |
| M2.T1 | `check_deps.bash` (strict default) exits 2 on a populated RPATH tree, exits 0 on the corrected tree; `--report-only` exits 0; broadened `find` selects real `*.so.N`; empty-`$ORIGIN` exempts system-only blob | Verification | In progress | exit-2 / find 1->13 / `--report-only` / libVimbaC-exempt verified on real tree; exit-0 CONFIRMED: debian13 AND rocky8 full 3-layer trees (RPATH 0, ABSPATH 0, check_deps exit 0 over 156 bin + 83 so incl support/site); rocky10 pending; lost-`$ORIGIN` FLAG has no natural fixture, constructed-object only |
| M3 vendor confirm | `uldaq` / `open62541` emit DT_RUNPATH on the rebuild (#46) | Milestone | In progress | no code change; `readelf -d` confirm; debian13 + rocky8 vendors confirmed via the full-tree check_deps (ABSPATH 0 across 83 so) |
| M3.T1 | `readelf -d` vendor `.so`: DT_RUNPATH present, zero DT_RPATH, Rocky 8.10/10.2 | Verification | In progress | debian13 + rocky8 CONFIRMED (vendor `.so` RUNPATH `[$ORIGIN/.]`, zero DT_RPATH in the full-tree check_deps); rocky10 pending |
| M5 CI wiring | wire `check_deps.bash` into CI as a post-install gate (#50) | Milestone | In progress | `RULES_DEPS_CHECK` (audit.deps/check.deps mirror of check.env) + `configure/RULES` include + `make audit.deps` in all seven workflows; code + docs landed at 2508f74, targets verified (`make audit.deps` exit 0 / `make check.deps` exit 2 on a populated RPATH tree); strict `check.deps` flip + exit-0 confirm at M4 |
| M5.T1 | `make audit.deps` exits 0 (report-only) and `make check.deps` exits 2 on a populated RPATH tree; `make audit.deps` runs post-install in all seven workflows | Verification | In progress | `make audit.deps` 0 / `make check.deps` 2 verified on real tree; in-CI report + strict flip (exit 0 on corrected tree) at M4 |
| M4 release gate | 1.2.2 release sequence (register-local, no tracker issue) | Milestone | Not started | per-OS rebuild + verify (decided matrix) + on-target `ldd`; flip the seven workflows `audit.deps`->`check.deps` once the corrected tree exits 0; bump the EPICS-env version 1.2.1 -> 1.2.2 (the install path carries the internal version, not the tag); then mirror the 1.2.1 sequence — add the 1.2.2 `ChangeLog.md` entry (dated, issue-referenced, breaking exit-code note), merge `release-1.2.2` into `master`, annotated tag `1.2.2` ("EPICS Environment 1.2.2"), GitHub release, close milestone 1.2.2 and issues #44/#45/#46/#50 |
| M4.T1 | cycle batch re-run (M1.T1/M2.T1/M3.T1/M5.T1 on the final tree) + seven-platform suites green + per-OS on-target `ldd` no `not found` | Verification | Not started | |

Tally: Milestones 5 (In progress 4, Not started 1) · Verification subs 5 (In progress 4, Not started 1)

## Backlog (not blocking 1.2.2)

- MCoreUtils gz debug info: `MCoreUtils-src/MCoreUtilsApp/Makefile:34` sets
  `USR_CFLAGS = ...` with a hard `=`, clobbering the `-g0` the gz flavor
  appends, so `libmcoreutils.so` ships debug info in the public `build.gz`
  distribution (found on rocky10 layers-1+2 gz; `-gz=zlib` still compresses it).
  Upstream `epics-modules/MCoreUtils` (built at `SRC_VER_MCOREUTILS=1.2.3`), not
  EPICS-env-owned — fix is a `+=` override upstream or a local patch. Pre-existing
  (same in 1.2.0 / 1.2.1 public builds), not a 1.2.2 regression.

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
