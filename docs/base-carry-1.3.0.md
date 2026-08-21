# Base Fix Carry — 1.3.0 (M22, #52)

The decision record for carrying post-R7.0.10 epics-base fixes as patches
on the pinned base 7.0.10. Procedure (also codified in the pipeline skill,
`references/patches.md`): applicability gate at R7.0.10 first; the
survivors scored by an independent five-reviewer panel on eight axes
(0-10 each, max 80); per-axis MEDIAN taken; a candidate is ADOPTED when it
meets ANY ONE of the four conditions:

1. total >= 50% (>= 40/80), OR
2. bug >= 5, OR
3. safety >= 5, OR
4. urgency >= 5.

This is the general rule; the owner may additionally decide, directly, to
add a candidate the conditions would drop or remove one they would adopt —
such decisions are recorded here with their rationale.

Axes: security (remote exposure reduced), safety (memory safety /
robustness), bug (functional correctness fixed), perf (runtime
performance), ops (facility value), urgency (harm if not carried before
the next base bump), fit (clean apply + low regression surface), locality
(transitive blast radius — leaf high, base low). Perf carried no
discriminating power in this wave (reviewers split neutral-vs-none).

## Five-reviewer median scores and adoption

| Rank | PR | security | safety | bug | perf | ops | urgency | fit | locality | Total | % | Adopted by |
| :--: | :-- | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :-- |
| 1 | #934 RSRV message validation | 9 | 7 | 6 | 3 | 8 | 7 | 6 | 6 | 52 | 65.0 | 1,2,3,4 |
| 2 | #913 histogramRecord heap OOB write | 4 | 9 | 7 | 2 | 5 | 7 | 8 | 9 | 51 | 63.8 | 1,2,3,4 |
| 3 | #920 dbStaticLib UINT64 misread | 2 | 6 | 9 | 2 | 9 | 8 | 7 | 3 | 46 | 57.5 | 1,2,3,4 |
| 3 | #932 client input-validation + calc links | 6 | 6 | 7 | 2 | 7 | 6 | 5 | 7 | 46 | 57.5 | 1,2,3,4 |
| 3 | #914 printfRecord %ls overflow | 3 | 8 | 6 | 2 | 4 | 6 | 8 | 9 | 46 | 57.5 | 1,2,3,4 |
| 6 | #904 caRepeaterThread UAF | 3 | 7 | 6 | 2 | 5 | 4 | 7 | 8 | 42 | 52.5 | 1,2,3 |
| 7 | #837 macLib mismatched delimiters | 2 | 4 | 7 | 2 | 7 | 6 | 6 | 5 | 39 | 48.8 | 2,4 |
| 7 | #918 iocsh on-error-wait parse | 1 | 3 | 7 | 2 | 6 | 6 | 7 | 7 | 39 | 48.8 | 2,4 |
| 9 | #870 epicsStrPrintEscaped OOB read | 4 | 7 | 6 | 2 | 5 | 5 | 4 | 5 | 38 | 47.5 | 2,3,4 |
| 10 | #919 dbConvert UInt64->String | 1 | 4 | 8 | 2 | 7 | 7 | 5 | 3 | 37 | 46.3 | 2,4 |
| 10 | #817 mbbiRecord COSV/LALM + AFTC | 1 | 3 | 7 | 2 | 6 | 5 | 4 | 9 | 37 | 46.3 | 2,4 |
| 10 | #922 dbJLink assign-vs-compare | 1 | 4 | 7 | 1 | 5 | 5 | 8 | 7 | 37 | 46.3 | 2,4 |
| 13 | #935 caget NULL check | 1 | 5 | 4 | 1 | 3 | 2 | 9 | 10 | 35 | 43.8 | 3 |
| 14 | #915 epicsRingBytes HWM operands | 1 | 3 | 5 | 1 | 4 | 3 | 8 | 5 | 30 | 37.5 | 2 |
| 15 | #890 makeRPath fail-hard | 3 | 2 | 5 | 2 | 4 | 4 | 3 | 2 | 25 | 31.3 | 2 (+ owner) |

Outcome: ALL FIFTEEN adopted — every candidate meets at least one
condition. #890 additionally carries an owner rationale independent of its
score: the owner raised the silent-empty-$ORIGIN-runpath concern, discussed
it with Michael, and Michael landed the upstream protection as PR 890; we
carry it until the base bump. It guards the exact makeRPath trap this
environment documents (pipeline skill, verification reference).

## Excluded at the applicability gate (DEFER — not scored)

| PR | Reason |
| :-- | :-- |
| #917 errlog OOB read | `errlogBufResize()` does not exist at R7.0.10 — no target code to patch; re-enters on a base bump |
| #856 dbCa iocInit wait | its prerequisite machinery (INIT_WAIT/CA_INIT_READY, 717d69e1) is R7.0.10+45 commits — carrying it imports a new startup-semantics feature, not a bugfix; re-enters on a base bump |

Swept and not carried (out of platform, cosmetic, docs/CI-only, or
conditional-build): #887 (gcc warning false positive — no defect), #926,
#924, #902, #877, #875, #871, #831, #940, #937, #897, #882, #866, #816,
#899, #845, #840, #841, #848, #828, #822, #821.

## Base-bump obligation

These patches are recorded against base 7.0.10 EXACTLY. At the next base
version change, every carry is re-examined (drop if upstream contains it,
re-base if the region moved) and the RUNPATH verification re-runs on the
new base before release — zero `DT_RPATH`, non-empty `$ORIGIN` runpath,
strict `check_deps.bash` exit 0 — so the 1.2.1-class RUNPATH regression
cannot recur. The checklist lives in the pipeline skill
(`references/patches.md`, "Base-bump retirement checklist").

## Implementation plan (revised after the three-reviewer plan review, 2026-07-25)

All fifteen target the epics-base source tree (SRC_PATH_BASE). Plan reviewed
by three Opus reviewers (wiring, content, verification); every DEFECT below
is folded in.

### Patch generation
- Generate each as a no-prefix p0 diff with `git diff --no-prefix` (NOT
  `gh pr diff`, which emits `a/ b/` = p1 and fails `patch -p0`). Header
  names the upstream PR URL and base 7.0.10.
- Two PRs do NOT apply clean to R7.0.10 (sibling post-tag drift, confirmed
  by `patch --dry-run`): #934 (camessage.c hunk #4 rejected) and #837
  (macCore.c hunk #2 rejected). These require manual per-hunk resolution
  against the R7.0.10 source; the resulting patch is validated by a clean
  forward+reverse dry-run before wiring.
- Every other PR is verified per-hunk too — blob mismatch vs R7.0.10 is
  common, so "clean apply" is proven by dry-run, never assumed.
- #817 is curated Option A — mbbiRecord.c source hunk ONLY (the missing
  `afvl` persistence + the COS-alarm short-circuit split). Drop the bi
  feature (biRecord.c, biRecord.dbd.pod, the new-notes file), biTest, AND
  mbbiTest.c/.db + the test Makefile hunk (our CI runs no base test
  target, so carried tests would be dead weight). No dbd regen for #817.
- #932 changes calcRecord.dbd.pod — dbd regenerates on the normal rebuild.

### Naming and wiring
- Files: `7.0.10-pr<NNN>-<slug>.p0.patch` with NNN ZERO-PADDED to fixed
  width (`pr0817`, `pr0890`, `pr0934`) so lexicographic `$(sort)` equals
  ascending PR order.
- Apply list built with `$(sort $(wildcard $(TOP)/patch/$(SRC_VER_BASE)-pr*.p0.patch))`
  (C-locale ascending); the loop runs `patch ... || exit 1` so a mid-stack
  failure fails the target.
- Revert reverses explicitly (`... | sort -r` / `tac`), not the same list —
  stacked patches only unapply in reverse apply order.
- pr patches vs the version `$(SRC_VER_BASE).base.p0.patch` leg: order made
  explicit (pr patches after the base.p0 leg), not left to hyphen-vs-dot
  byte accident. Wired as a dedicated `patch.base.pr.apply`/`.revert` pair
  into the aggregate `patch`/`patch.revert` next to `patch.base.*`.

### Verification (M22.T1, scope = apply-clean + no-regression + targeted proofs)
- `make patch` exits 0 with all fifteen `patching file` lines observed.
- Round-trip: `make patch` then `make patch.revert` leaves `git -C
  <base-src> status --short` empty AND no `.orig`/`.rej` residue. (No
  carried patch adds a file under Option A, so the add-file revert risk is
  designed out; assert residue-free regardless.)
- Seven-platform CI green; VM build (decided matrix) + softIoc smoke;
  strict `check_deps.bash` exit 0 unchanged (proves the patches did not
  disturb the RUNPATH/dependency posture — necessary, not sufficient).
- Targeted functional proofs (the fixes are otherwise not exercised, since
  CI runs no base test suite):
  - #890 negative test: force makeRPath to fail (non-zero / empty output),
    rebuild, assert the build ERRORS OUT rather than linking a binary with
    an empty `$ORIGIN` runpath.
  - #932: in softIoc, `caput`/`dbpf` each of calc INPM..INPU (nine links)
    and confirm they are now writable (rejected before the fix).
- Per-fix functional proof beyond the two above lives upstream and is NOT
  re-run here — recorded scope limit, not a silent gap.

## M33 refresh — 2026-08-21 (#60)

Re-run of the `R7.0.10...7.0` enumeration against the current `7.0` branch, per
`docs/upstream-fix-carry-procedure.md`, to reconcile the M22 carry above with
fixes merged after the M22 snapshot (2026-07-25).

**Stage 1 — enumerate.** `R7.0.10..origin/7.0` = 151 commits (tip `0cc912b1`,
2026-08-10). No release tag above R7.0.10 exists, so a carry remains correct.
Eight commits are new since the M22 snapshot.

**Stage 2 — mechanical removal (5 swept, defensible from the diff):**
`0cc912b1` RTEMS_VERSION sort (RTEMS-only), `6b866dd` RTEMS libbsd static IP
(#853, RTEMS+doc), `da27db5` dbCaLinkTest (test-only), `c592587` doc (doxygen
comments in headers only), `bc1b965` remove .tools/adjustver.py (tooling,
unbuilt).

**Stage 3 — five-reviewer eight-axis median (three survivors):**

| Commit | sec | saf | bug | perf | ops | urg | fit | loc | Total |
| :-- | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| c1a26edb6 db: fix dbChannel_put() for DBR_TIME_STRING | 1 | 4 | 8 | 0 | 4 | 3 | 9 | 8 | 37 |
| b2d2758cc db: dbPutNotifyBlocker type check | 4 | 7 | 5 | 0 | 4 | 4 | 8 | 7 | 39 |
| 6cf9fe9d8 Silence Repeater announcement in non-debug mode | 0 | 0 | 1 | 0 | 2 | 0 | 9 | 10 | 22 |

Raw per-reviewer scores (sec,saf,bug,perf,ops,urg,fit,loc):
- c1a26edb6 — R1 2,4,8,0,4,3,9,8 | R2 1,4,8,0,4,4,9,8 | R3 1,5,8,0,4,4,9,9 | R4 1,4,8,0,4,3,9,6 | R5 1,3,8,0,3,3,9,7
- b2d2758cc — R1 5,7,6,0,4,4,8,7 | R2 3,6,5,0,3,5,8,7 | R3 4,7,5,0,4,4,8,7 | R4 4,7,5,0,3,4,8,6 | R5 5,7,6,0,4,5,9,6
- 6cf9fe9d8 — R1 0,0,1,0,2,0,9,10 | R2 0,0,1,1,3,1,10,10 | R3 0,0,1,0,2,0,10,10 | R4 0,0,1,0,2,0,9,10 | R5 0,0,1,0,3,0,9,10

**Candidate-defect check.** R1 flagged a possible over-restriction in b2d2758cc
if `INVALID_DB_REQ` bounded at DBR_ENUM. Verified and resolved:
`dbPutNotifyBlocker.cpp` includes `modules/ca/src/client/db_access.h`, whose
`INVALID_DB_REQ(x) = ((x<0)||(x>LAST_BUFFER_TYPE))` (LAST_BUFFER_TYPE=38)
validates the full DBR request range — no valid put type is rejected (R5
confirmed independently). `type` is unsigned so the `(x<0)` branch is dead but
harmless. No carry-blocking defect in any candidate.

**Stage 4 — rule outcome.** c1a26edb6 ADOPT (bug 8); b2d2758cc ADOPT (bug 5,
safety 7); 6cf9fe9d8 DROP (total 22, misses all conditions). Both adopts miss
the 40-total threshold and pass via the bug/safety gates — the OR rule working
as intended.

**Stage 5 — owner decision (2026-08-21).** Rule-as-is: carry c1a26edb6 and
b2d2758cc; drop 6cf9fe9d8. No owner override. Adopted carry grows from 15 (M22)
to 17.

**Stage 6 naming (resolved).** `c1a26edb6` is upstream PR #948, so it takes the
`7.0.10-pr0948-<slug>.p0.patch` form of the existing carry. `b2d2758cc` merged
as a direct base commit with no associated PR (verified: 0 pulls, no `#N` in
the message), so it takes the runbook's commit-unit form
`7.0.10-<NN>-b2d2758-<slug>.p0.patch` (`NN` a merge-order sequence assigned at
Stage 6; `b2d2758` is the 7-char short sha). Patch generation + `RULES_PATCH` wiring and M33.T1/T2 verification
remain.
