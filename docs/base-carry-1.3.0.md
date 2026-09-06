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
| 1 | epics-base/epics-base#934 RSRV message validation | 9 | 7 | 6 | 3 | 8 | 7 | 6 | 6 | 52 | 65.0 | 1,2,3,4 |
| 2 | epics-base/epics-base#913 histogramRecord heap OOB write | 4 | 9 | 7 | 2 | 5 | 7 | 8 | 9 | 51 | 63.8 | 1,2,3,4 |
| 3 | epics-base/epics-base#920 dbStaticLib UINT64 misread | 2 | 6 | 9 | 2 | 9 | 8 | 7 | 3 | 46 | 57.5 | 1,2,3,4 |
| 3 | epics-base/epics-base#932 client input-validation + calc links | 6 | 6 | 7 | 2 | 7 | 6 | 5 | 7 | 46 | 57.5 | 1,2,3,4 |
| 3 | epics-base/epics-base#914 printfRecord %ls overflow | 3 | 8 | 6 | 2 | 4 | 6 | 8 | 9 | 46 | 57.5 | 1,2,3,4 |
| 6 | epics-base/epics-base#904 caRepeaterThread UAF | 3 | 7 | 6 | 2 | 5 | 4 | 7 | 8 | 42 | 52.5 | 1,2,3 |
| 7 | epics-base/epics-base#837 macLib mismatched delimiters | 2 | 4 | 7 | 2 | 7 | 6 | 6 | 5 | 39 | 48.8 | 2,4 |
| 7 | epics-base/epics-base#918 iocsh on-error-wait parse | 1 | 3 | 7 | 2 | 6 | 6 | 7 | 7 | 39 | 48.8 | 2,4 |
| 9 | epics-base/epics-base#870 epicsStrPrintEscaped OOB read | 4 | 7 | 6 | 2 | 5 | 5 | 4 | 5 | 38 | 47.5 | 2,3,4 |
| 10 | epics-base/epics-base#919 dbConvert UInt64->String | 1 | 4 | 8 | 2 | 7 | 7 | 5 | 3 | 37 | 46.3 | 2,4 |
| 10 | epics-base/epics-base#817 mbbiRecord COSV/LALM + AFTC | 1 | 3 | 7 | 2 | 6 | 5 | 4 | 9 | 37 | 46.3 | 2,4 |
| 10 | epics-base/epics-base#922 dbJLink assign-vs-compare | 1 | 4 | 7 | 1 | 5 | 5 | 8 | 7 | 37 | 46.3 | 2,4 |
| 13 | epics-base/epics-base#935 caget NULL check | 1 | 5 | 4 | 1 | 3 | 2 | 9 | 10 | 35 | 43.8 | 3 |
| 14 | epics-base/epics-base#915 epicsRingBytes HWM operands | 1 | 3 | 5 | 1 | 4 | 3 | 8 | 5 | 30 | 37.5 | 2 |
| 15 | epics-base/epics-base#890 makeRPath fail-hard | 3 | 2 | 5 | 2 | 4 | 4 | 3 | 2 | 25 | 31.3 | 2 (+ owner) |

Outcome: ALL FIFTEEN adopted — every candidate meets at least one
condition. epics-base/epics-base#890 additionally carries an owner rationale independent of its
score: the owner raised the silent-empty-$ORIGIN-runpath concern, discussed
it with Michael, and Michael landed the upstream protection as PR 890; we
carry it until the base bump. It guards the exact makeRPath trap this
environment documents (pipeline skill, verification reference).

## Excluded at the applicability gate (DEFER — not scored)

| PR | Reason |
| :-- | :-- |
| epics-base/epics-base#917 errlog OOB read | `errlogBufResize()` does not exist at R7.0.10 — no target code to patch; re-enters on a base bump |
| epics-base/epics-base#856 dbCa iocInit wait | its prerequisite machinery (INIT_WAIT/CA_INIT_READY, 717d69e1) is R7.0.10+45 commits — carrying it imports a new startup-semantics feature, not a bugfix; re-enters on a base bump |

Swept and not carried (out of platform, cosmetic, docs/CI-only, or
conditional-build): epics-base/epics-base#887 (gcc warning false positive — no defect), epics-base/epics-base#926,
epics-base/epics-base#924, epics-base/epics-base#902, epics-base/epics-base#877, epics-base/epics-base#875, epics-base/epics-base#871, epics-base/epics-base#831, epics-base/epics-base#940, epics-base/epics-base#937, epics-base/epics-base#897, epics-base/epics-base#882, epics-base/epics-base#866, epics-base/epics-base#816,
epics-base/epics-base#899, epics-base/epics-base#845, epics-base/epics-base#840, epics-base/epics-base#841, epics-base/epics-base#848, epics-base/epics-base#828, epics-base/epics-base#822, epics-base/epics-base#821.

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
  by `patch --dry-run`): epics-base/epics-base#934 (camessage.c hunk #4 rejected) and epics-base/epics-base#837
  (macCore.c hunk #2 rejected). These require manual per-hunk resolution
  against the R7.0.10 source; the resulting patch is validated by a clean
  forward+reverse dry-run before wiring.
- Every other PR is verified per-hunk too — blob mismatch vs R7.0.10 is
  common, so "clean apply" is proven by dry-run, never assumed.
- epics-base/epics-base#817 is curated Option A — mbbiRecord.c source hunk ONLY (the missing
  `afvl` persistence + the COS-alarm short-circuit split). Drop the bi
  feature (biRecord.c, biRecord.dbd.pod, the new-notes file), biTest, AND
  mbbiTest.c/.db + the test Makefile hunk (our CI runs no base test
  target, so carried tests would be dead weight). No dbd regen for epics-base/epics-base#817.
- epics-base/epics-base#932 changes calcRecord.dbd.pod — dbd regenerates on the normal rebuild.

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
  - epics-base/epics-base#890 negative test: force makeRPath to fail (non-zero / empty output),
    rebuild, assert the build ERRORS OUT rather than linking a binary with
    an empty `$ORIGIN` runpath.
  - epics-base/epics-base#932: in softIoc, `caput`/`dbpf` each of calc INPM..INPU (nine links)
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
(epics-base/epics-base#853, RTEMS+doc), `da27db5` dbCaLinkTest (test-only), `c592587` doc (doxygen
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

**Stage 6 naming (resolved).** `c1a26edb6` is epics-base/epics-base#948, so it takes the
`7.0.10-pr0948-<slug>.p0.patch` form of the existing carry. `b2d2758cc` merged
as a direct base commit with no associated PR (verified: 0 pulls, no `#N` in
the message), so it takes the runbook's commit-unit form
`7.0.10-<NN>-b2d2758-<slug>.p0.patch` (`NN` a merge-order sequence assigned at
Stage 6; `b2d2758` is the 7-char short sha). Patch generation + `RULES_PATCH` wiring and M33.T1/T2 verification
remain.

## Carry refresh - 2026-09-03 (epics-base/epics-base#949)

Re-run of the `R7.0.10...7.0` enumeration against the current `7.0` branch,
per `docs/upstream-fix-carry-procedure.md`, to reconcile the M33 carry above
(snapshot tip `0cc912b1`, 2026-08-10) with fixes merged after it. Runs before
the M7 release gate, so the outcome ships in 1.3.0; no released EPICS-env
(1.2.2 and earlier) carries epics-base/epics-base#934 and none is affected by the regression below.

**Stage 1 — enumerate.** `0cc912b17..origin/7.0` = 5 commits (tip `53b0fc99a`,
2026-09-02). No release tag above R7.0.10 exists, so a carry remains correct.

**Stage 2 — mechanical removal (1 swept):** `67f7ee55b` release-note heading
fix (doc-only).

**Applicability gate.** The four remaining commits are epics-base/epics-base#949
"More RSRV checks" (`df57d1040`, `f7ad63f56`, `9b7f932b5`, `53b0fc99a`),
merged 2026-09-02 as a fast-forward onto `7.0`. Target regions exist at
R7.0.10; the PR builds on `793f58221` (log_header stops logging strings
specially), which the carried epics-base/epics-base#934 patch already contains. `git apply
--check` of the PR diff against `epics-base-src` (R7.0.10 + the 17 carried
patches) is clean. PASS — scored as one unit.

**Why it is a candidate.** epics-base/epics-base#949 fixes upstream issue epics-base/epics-base#943, a regression
introduced by `4128a7c0` ("cross-check m_count message field with payload
buffer length"), which is part of the carried epics-base/epics-base#934. libca sends a scalar
`DBR_STRING` PUT with the payload truncated to `strlen+1` rounded to 8 bytes;
the epics-base/epics-base#934 cross-check rejects it as a bad message and drops the TCP circuit,
so a default-mode `caput` (string mode) fails with "Virtual circuit
disconnect" against any IOC built with the epics-base/epics-base#934 carry. String arrays and CAJ
clients (which pad to 40 bytes) are unaffected. epics-base/epics-base#949 adds a per-client 40-byte
scratch buffer so a truncated scalar-string PUT reaches `dbPut` with a fully
backed, null-terminated buffer, separates the put-notify wait/cancel path
from the next PUT, and adds `nRequest` checks to `dbPut()` / `dbPutField()`
(negative rejected; `dbPutFieldLink` zero-count `DBR_CHAR` handled,
`DBR_STRING` count != 1 rejected with `S_db_onlyOne`).

**Stage 3 — five-reviewer eight-axis median (one survivor):**

| PR | sec | saf | bug | perf | ops | urg | fit | loc | Total | % |
| :-- | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| epics-base/epics-base#949 More RSRV checks (fix for epics-base/epics-base#943) | 6 | 8 | 9 | 1 | 9 | 9 | 6 | 3 | 51 | 63.8 |

Raw per-reviewer scores (sec,saf,bug,perf,ops,urg,fit,loc):
- R1 6,8,10,2,10,10,6,3 = 55 | R2 5,8,9,1,10,9,6,3 = 51 | R3 6,8,9,1,9,9,6,3 = 51 |
  R4 6,8,9,1,9,9,6,3 = 51 | R5 6,7,9,1,9,10,5,3 = 50

No axis spreads more than one point; locality is 3 from all five. The two
recorded discounts are shared by all reviewers: fit 5-6 because the
`write_notify_action` state handling is restructured and `dbPutFieldLink`
gains a new rejection (`DBR_STRING` count != 1), with one day of upstream
soak; locality 3 because `dbAccess.c` `dbPut` / `dbPutField` /
`dbPutFieldLink` sit on every IOC put path, not only in rsrv.

**Stage 4 — rule outcome.** ADOPT: total 51 >= 40, bug 9 >= 5, safety 8 >= 5,
urgency 9 >= 5 — all four OR conditions met.

**Stage 5 - owner decision (2026-09-03).** Rule-as-is: carry epics-base/epics-base#949. No owner
override. Adopted carry grows from 17 (M33) to 18.

**Stage 6 — apply-selection list.**

| order | PR | title | total | basis | overlap |
| :--: | :-- | :-- | :--: | :-- | :-- |
| 18 (after pr0948) | epics-base/epics-base#949 | RSRV scalar-string PUT (fix for epics-base/epics-base#943) | 51 | total, bug, safety, urgency | `camessage.c` with pr0934 (the other three files are touched by no other carry) |

**Stage 6 — naming, generation, wiring.**
- File: `patch/7.0.10-pr0949-rsrv-scalar-string-put.p0.patch` (570 lines;
  `dbAccess.c`, `camessage.c`, `caservertask.c`, `server.h`).
- Generated in two steps. The upstream change is `git diff --no-prefix
  67f7ee55b 53b0fc99a` on the fetched `7.0` branch (the PR's full commit
  range, identical to `gh pr diff 949` after prefix stripping). That diff is
  then re-based: applied on a scratch R7.0.10 worktree carrying the other 17
  patches, and re-emitted from there with `git diff --no-prefix`, so every
  hunk's line numbers match the tree it is applied to. The added and removed
  lines are identical to the upstream diff; only hunk positions differ. Taken
  at upstream line numbers, the hunks applied with offsets, and GNU `patch`
  backs up an inexactly matched file, which left four `.orig` files and
  failed the residue check.
- Wiring: none required — `RULES_FUNC` `base_pr_patch_src` globs
  `$(SRC_VER_BASE)-*.p0.patch`; `pr0949` sorts after `pr0948` and after
  `pr0934`, the one carry sharing a file with it (`camessage.c`), which is
  also its semantic order (epics-base/epics-base#949 presupposes epics-base/epics-base#934).
- Forward `patch --dry-run -p0` on R7.0.10 + 17 carries: 38 hunks succeed
  with no offset, no fuzz, no rejects.
- Round-trip on a scratch R7.0.10 worktree, running the `RULES_FUNC` loop
  by hand (all 18 patches forward in sort order, then reverse in reverse
  order): 0 failures, tree identical after revert, 0 `.orig`/`.rej`.

**Verification remaining (M33.T1 method, `docs/milestone-1.3.0.md`).** The
same round-trip through the Makefile path (`make patch` then
`make patch.revert` on a pristine R7.0.10 extract); full build green;
targeted proof in softIoc that a default-mode scalar `caput` succeeds against
the patched server (the epics-base/epics-base#943 symptom), this is the one functional proof the
existing carry set did not exercise. `check_deps.bash` strict exit 0 unchanged.
