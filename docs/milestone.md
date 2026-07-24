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

Next session entry point: M4 step 5 (the two deferred code changes). M4 steps
1-4 DONE 2026-07-24 on the final 1.2.2 trees (`/opt/epics/1.2.2/`, tip 69faa21):
per-OS fresh rebuild per the decided matrix (rocky8.10 + debian13 full 3-layer,
rocky10.2 public gz 2-layer; ubuntu24 by CI green, ubuntu26 excluded), cycle
batch all PASS (gates 1-7; check_deps strict exit 0 at 156 bin/83 so, 156/83,
154/76; readelf zero DT_RPATH + RUNPATH `$ORIGIN` incl Rocky 10.2; audit.deps
exit 0), seven workflows green on 69faa21, per-OS `ldd` smoke pass (the
libCap5 bare-ldd shape is recorded as known behavior in the pipeline skill).
Step 5 next: (a) flip the seven workflows `audit.deps` -> `check.deps` (#50
staged rollout); (b) wire the updated check_deps into the distribution
`install.bash` (M2, #45 lockstep note) and confirm the strict gate exits 0.
Then step 6 publish: ChangeLog entry (drafted, uncommitted), merge to master,
tag 1.2.2, GitHub release, close milestone 1.2.2 and issues #44/#45/#46/#50.
The forward-port (1.3.0 M21) follows the 1.2.2 release, and the open 1.3.0
cycle (M6, M7) resumes after M21.

## Milestones — 1.2.2

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| M1 base DT_RUNPATH flag | base + modules emit DT_RUNPATH not DT_RPATH on Rocky/RHEL (#44) | Milestone | Complete (issue close at step 6) | `SHRLIB_LDFLAGS`/`LOADABLE_SHRLIB_LDFLAGS += -Wl,--enable-new-dtags` into `os/CONFIG_SITE.linux-x86_64.linux-x86_64` (loaded after `CONFIG.gnuCommon`) via `conf.base.site` (`RULES_BASE`); mechanism gate PASS (`make -pn` flattened flag survives the `=`-reset); 2 plan-review rounds + 3-reviewer impl review, 0 blocking; readelf observable CONFIRMED at M4 on all three 1.2.2 trees (2026-07-24) |
| M1.T1 | `readelf.base` (both tags) + `readelf.modules`: zero DT_RPATH + DT_RUNPATH present, Rocky 8.10/10.2 (Debian unchanged); site-modules verified in the alsu repo | Verification | Complete | CONFIRMED on the final 1.2.2 trees 2026-07-24: rocky8.10 + debian13 full 3-layer (78 modules) + rocky10.2 gz (64); libCom/libasyn RUNPATH `$ORIGIN`-relative, zero DT_RPATH tree-wide via check_deps |
| M2 dependency-check gate | `check_deps.bash` must fail on RPATH / unversioned `.so` (#45) | Milestone | In progress | strict default + `--report-only` opt-out, `*.so`->`*.so*`, empty-`$ORIGIN` system-only exemption; code + docs landed at 862ffb0, real-tree verify done (exit 2 on a populated RPATH tree 72/76, base lib find 1->13, libVimbaC exempt); wire prep-vendors done, distribution install.bash pending (M4 step 5b); corrected-tree exit 0 CONFIRMED on all three 1.2.2 trees (2026-07-24) |
| M2.T1 | `check_deps.bash` (strict default) exits 2 on a populated RPATH tree, exits 0 on the corrected tree; `--report-only` exits 0; broadened `find` selects real `*.so.N`; empty-`$ORIGIN` exempts system-only blob | Verification | Complete | exit-2 / find 1->13 / `--report-only` / libVimbaC-exempt verified on real tree; exit-0 CONFIRMED on the final 1.2.2 trees 2026-07-24: rocky8.10 + debian13 (156 bin/83 so) + rocky10.2 gz (154/76), ABSPATH 0, LOSTORG 0; lost-`$ORIGIN` FLAG has no natural fixture, constructed-object only |
| M3 vendor confirm | `uldaq` / `open62541` emit DT_RUNPATH on the rebuild (#46) | Milestone | Complete (issue close at step 6) | no code change; `readelf -d` CONFIRMED on the 1.2.2 rebuild 2026-07-24: vendor `.so` RUNPATH `[$ORIGIN/.]`, zero DT_RPATH — rocky8.10, rocky10.2, debian13 |
| M3.T1 | `readelf -d` vendor `.so`: DT_RUNPATH present, zero DT_RPATH, Rocky 8.10/10.2 | Verification | Complete | CONFIRMED 2026-07-24 on rocky8.10, rocky10.2 (residue cleared), debian13: `libuldaq.so.1.2.1` / `libopen62541.so.1.3.15` RUNPATH `[$ORIGIN/.]`, zero DT_RPATH |
| M5 CI wiring | wire `check_deps.bash` into CI as a post-install gate (#50) | Milestone | In progress | `RULES_DEPS_CHECK` (audit.deps/check.deps mirror of check.env) + `configure/RULES` include + `make audit.deps` in all seven workflows; code + docs landed at 2508f74, targets verified (`make audit.deps` exit 0 / `make check.deps` exit 2 on a populated RPATH tree); strict `check.deps` flip + exit-0 confirm at M4 (#50 staged rollout, = step 5a); the distribution build's `check_deps.bash ... || exit` caller is a second, independent strict gate (prep-vendors done, install.bash pending per M2); audit.deps exit 0 on all three final trees + seven workflows green at 69faa21 (2026-07-24) |
| M5.T1 | `make audit.deps` exits 0 (report-only) and `make check.deps` exits 2 on a populated RPATH tree; `make audit.deps` runs post-install in all seven workflows | Verification | In progress | `make audit.deps` 0 / `make check.deps` 2 verified on real tree; in-CI report live (seven green at 69faa21); corrected-tree strict exit 0 CONFIRMED on all three final trees 2026-07-24; flip half remains (step 5a) |
| M4 release gate | 1.2.2 release sequence (register-local, no tracker issue) | Milestone | In progress | steps 1-4 DONE 2026-07-24: per-OS rebuild + gates all PASS, seven workflows green at 69faa21, `ldd` smoke pass (libCap5 bare-ldd shape recorded in the pipeline skill); remaining — flip the seven workflows `audit.deps` -> `check.deps` (#50, step 5a); wire the distribution `install.bash` and confirm the strict gate exits 0 (step 5b); version bump 1.2.1 -> 1.2.2 DONE (2b85b39); then mirror the 1.2.1 sequence — add the 1.2.2 `ChangeLog.md` entry (dated, issue-referenced, breaking exit-code note), merge `release-1.2.2` into `master`, annotated tag `1.2.2` ("EPICS Environment 1.2.2"), GitHub release, close milestone 1.2.2 and issues #44/#45/#46/#50 |
| M4.T1 | cycle batch re-run (M1.T1/M2.T1/M3.T1/M5.T1 on the final tree) + seven-platform suites green + per-OS on-target `ldd` no `not found` | Verification | Complete | cycle batch PASS on all three final trees + seven suites green (69faa21) + per-OS `ldd` clean apart from the known libCap5 bare-ldd shape (2026-07-24) |

Tally: Milestones 5 (Complete 2, In progress 3) · Verification subs 5 (Complete 4, In progress 1)

## M4 release-gate sequence

Step order for the M4 release gate, with the dependent milestones each step
advances or closes. Steps 1-2 clear the verification residue of the four open
milestones, step 5 completes the last real work of M2 and M5, and step 6
closes all five at once.

Decided VM matrix (2026-07-23): VM rebuild covers debian13 + rocky8.10
(internal 3-layer) and rocky10 (public gz). ubuntu24 is covered by CI green
for the gate, with its first VM verification deferred to after the release
(post-release follow-up); ubuntu26 is excluded this cycle (blocked upstream,
#29/#30, no CI workflow).

| # | Step | Content | Dependent milestones |
| :-- | :-- | :-- | :-- |
| 1 | Per-OS fresh rebuild | `.clean` -> recreate -> playbook 08 -> 09 -> (internal OS) layer 3; produces the final tree | prerequisite for M1/M2/M3/M5 (the tree carrying the corrected tags) |
| 2 | Cycle batch re-run | every T1 on the final tree + the seven pipeline gates; clears the rocky10 residue | M1 (T1 readelf) · M2 (T1 check_deps exit 0) · M3 (T1 vendor) · M5 (T1 audit.deps) |
| 3 | Seven CI workflows green | full suites on `release-1.2.2`, all platforms | M1 (seven-platform build) · M3 (vendor build) · M5 (audit.deps live in all seven) |
| 4 | On-target `ldd` smoke | per-OS installed tree, zero `not found` | M4 only |
| 5 | Deferred code changes (2) | (a) flip the seven workflows to strict `check.deps` + confirm all seven exit 0; (b) wire the updated check_deps into the distribution `install.bash` + confirm the strict gate exits 0 | (a) closes M5's last real work (#50) · (b) closes M2's last real work (#45) |
| 6 | Publish (mirrors 1.2.1) | ChangeLog entry -> merge to `master` -> annotated tag `1.2.2` (irreversible, last) -> GitHub release -> close milestone and issues | closes #44 (M1), #45 (M2), #46 (M3), #50 (M5) + completes M4 |
| 7 | Post-release | forward-port and next cycle | M21 (1.3.0 line, #47) -> M6, M7 (outside this register) |

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
