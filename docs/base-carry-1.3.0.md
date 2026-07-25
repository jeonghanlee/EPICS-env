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
