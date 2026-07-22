# Cycle Test Plan — 1.2.2 (DT_RUNPATH respin)

Cycle scope: base and modules emit `DT_RUNPATH` (not `DT_RPATH`) on Rocky/RHEL via
a version-independent base flag (M1), and `check_deps.bash` is made to gate the
regression (M2); vendor libraries are confirmed unchanged (M3); the fix ships as
1.2.2 (M4 release gate). Draft date: 2026-07-20.

Living document: cases discovered during the cycle land under "Added During Cycle"
naming the milestone that surfaced them. The released plan is preserved by the
release tag.

## Verification layers

1. **Change-specific** — per-milestone verification designed by blast radius:
   `readelf -d` dynamic-tag checks (M1, M3), gate exit-code and discovery behavior
   (M2), on-target `ldd` and per-OS rebuild (M4).
2. **Automated suites** — the seven-platform workflows plus `make check.env` and
   `make github.check`. Baseline: the suites as green at the 1.2.1 ship
   (`git show 1.2.1:docs/milestone.md`). Cases demanded by acceptance criteria
   become permanent regression assets (the default dependency gate itself is one), never
   one-off checks.

## Per-milestone verification

| Milestone | Change-specific (T1) | Suite coverage (T2) |
| :-- | :-- | :-- |
| M1 base flag (#44) | `readelf -d`: zero `DT_RPATH`, `DT_RUNPATH` present on base + every module + site-modules `.so`, Rocky 8.10/10.2; Debian unchanged | seven-platform build green on the flagged tree |
| M2 gate (#45) | `install.bash check-deps` (strict default) exits 2 on the 1.2.1 RPATH tree, exits 0 on the corrected tree; `--report-only` opts out; broadened `find` selects real `*.so.N`; empty-`$ORIGIN` exempts system-only blob, flags lost-runpath EPICS `.so` | none — CI wiring deferred to M5 |
| M3 vendor (#46) | `readelf -d` on rebuilt `uldaq` / `open62541` `.so`: `DT_RUNPATH` present, zero `DT_RPATH`, Rocky 8.10/10.2 | vendor build green in the workflows |
| M5 CI wiring (#50) | `make audit.deps` reports in all seven workflows post-install (exit 0); the strict `check.deps` gate (exit 2 on a populated RPATH tree / 0 on the corrected tree) flips live at M4 | `make audit.deps` runs in all seven platform workflows after `make install`, beside `check.env` |
| M4 release gate | see Release gate below | all seven workflows green on the release tree |

## Dependency re-run matrix

| Trigger milestone | Re-runs | Shared surface |
| :-- | :-- | :-- |
| M1 base flag lands | M2.T1 exit-0 (corrected-tree) half | the installed tree's dynamic tags — M2's "corrected tree" only exists after M1 |
| M2 gate wired into `install.bash` | M1.T1, M3.T1 under the strict gate | the shipped-tree check path |
| M5 strict flip at M4 | M5.T1 exit-0 on the corrected tree | the seven workflows' post-install gate — `audit.deps` reports until the M4 flip to `check.deps` |

## Release gate (M4)

Executed in order before the 1.2.2 release:

1. **Per-OS rebuild + cycle batch** — rebuild per OS (the decided matrix: GitLab
   rocky8.10 / debian13; GitHub debian13 / ubuntu24 / ubuntu26 / rocky8 / rocky10),
   then run M1.T1, M2.T1, M3.T1, M5.T1 against the rebuilt tree — the first state
   where all changes coexist.
2. **Full automated suites** — all seven CI workflows green on `release-1.2.2`.
3. **On-target smoke** — per-OS `ldd` on the installed tree: no `not found` for
   tree libs, on every OS of the decided matrix.
4. **Flip check.deps to strict** — once the batch and suites confirm the corrected
   tree exits 0, change the seven workflows' `make audit.deps` to `make check.deps`
   and confirm all seven exit 0.
5. **Publish (mirrors the 1.2.1 sequence)** — only after the gate is green, in
   order: add the 1.2.2 `ChangeLog.md` entry (dated, issue-referenced, with the
   breaking exit-code note); merge `release-1.2.2` into `master` ("Merge 1.2.2:
   EPICS Environment maintenance release"); annotated tag `1.2.2` (no `v` prefix,
   message "EPICS Environment 1.2.2"); GitHub release; close milestone 1.2.2 and
   issues #44/#45/#46/#50. The tag is the sole irreversible artifact, so it
   publishes last.

## Added During Cycle

(none yet)
