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
| M4 release gate | see Release gate below | all seven workflows green on the release tree |

## Dependency re-run matrix

| Trigger milestone | Re-runs | Shared surface |
| :-- | :-- | :-- |
| M1 base flag lands | M2.T1 exit-0 (corrected-tree) half | the installed tree's dynamic tags — M2's "corrected tree" only exists after M1 |
| M2 gate wired into `install.bash` | M1.T1, M3.T1 under the strict gate | the shipped-tree check path |

## Release gate (M4)

Executed in order before the 1.2.2 release:

1. **Cycle batch re-run** — M1.T1, M2.T1, M3.T1 against the final tree, the first
   state where all changes coexist.
2. **Full automated suites** — all seven workflows green on `release-1.2.2`.
3. **On-target smoke** — per-OS `ldd` on the installed tree: no `not found` for
   tree libs; rebuild + verify per OS (Rocky 8.10/10.2, Debian).
4. **Gate-then-publish** — only after the gate is green: merge to `master`,
   annotated tag `1.2.2` (no `v` prefix), GitHub release, close milestone 1.2.2.
   The tag is the sole irreversible artifact, so it publishes last.

## Added During Cycle

(none yet)
