# pvxs Fix Carry — 1.3.0 (M26, #53)

The decision record for carrying post-1.5.2 pvxs fixes as patches on the
pinned pvxs 1.5.2. Procedure: `docs/upstream-fix-carry-procedure.md` —
enumerate the whole `1.5.2..master` range, remove only commits that are
exclusively documentation, CI, or test as judged from the diff, establish
dependency chains, score every survivor with a five-reviewer eight-axis
median panel, and adopt on ANY ONE of four conditions:

1. total >= 50% (>= 40/80), OR
2. bug >= 5, OR
3. safety >= 5, OR
4. urgency >= 5.

The owner may additionally decide, directly, to add a candidate the
conditions would drop or remove one they would adopt — such decisions are
recorded here with their rationale.

Axes: security (remote exposure reduced), safety (memory safety /
robustness), bug (functional correctness fixed), perf (runtime
performance), ops (facility value), urgency (harm if not carried before
the next bump), fit (clean apply + low regression surface), locality
(transitive blast radius — leaf high, core low).

Upstream state at selection (2026-07-25): `master` is 25 commits ahead of
`1.5.2`, and 1.5.2 is the newest tag — no release above the pin exists, so
a version bump is not available and a carry is the correct response.

Selection was carried out ahead of the M26 milestone being opened. That was
a deliberate owner decision to shorten the path, recorded here rather than
left as an undocumented order-of-work deviation.

Unit note: pvxs is committed directly by its maintainer rather than through
pull requests, so the carry unit is a commit and patch files carry a
sequence number to supply the ordering a hash cannot.

## Removed before scoring — exclusively documentation, CI, or test

| Commit | Subject | Reason |
| :-- | :-- | :-- |
| `0b54cc1` | doc | `documentation/`, `release.md` only |
| `a2656a2` | release notes | `documentation/` only |
| `67770b5` | doc field lookup | edits `src/pvxs/data.h`, but every changed line is inside doxygen comment blocks — the prose moved to `value.rst` and a link replaced it. Classified by path it survives; classified by content it is documentation |
| `182b336` | Revert "gha: ABI check against older Base" | `.github/workflows/` only |
| `32b9905` | testrpc: noise | `test/` only |
| `a79d65b` | testmon: cancelDuringEvent() | `test/` only — the test for the callback-guard family |

No candidate was deferred at the applicability gate. No separate gate pass
was run; the question was absorbed into the per-candidate apply checks.

## Five-reviewer median scores and adoption

Nineteen candidates, five independent reviewers, each reading the real
upstream diff before scoring. Per-axis median.

| Rank | Commit | Subject | sec | saf | bug | perf | ops | urg | fit | loc | Total | % | Rule |
| :--: | :-- | :-- | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :--: | :-- |
| 1 | `084336b` | client: slow re-try after refused CREATE_CHANNEL | 3 | 2 | 6 | 5 | 8 | 6 | 9 | 5 | 44 | 55.0 | total, bug, urgency |
| 2 | `39cc6fa` | client: fix Op early destruction (part 2) | 1 | 8 | 5 | 0 | 6 | 6 | 10 | 7 | 43 | 53.8 | total, bug, safety, urgency |
| 2 | `c969383` | clientmon: guard event callback functor | 1 | 9 | 6 | 0 | 7 | 6 | 8 | 6 | 43 | 53.8 | total, bug, safety, urgency |
| 4 | `c17812a` | clientget: guard callback functors | 1 | 8 | 6 | 0 | 7 | 6 | 8 | 6 | 42 | 52.5 | total, bug, safety, urgency |
| 5 | `9a6b4cc` | server: de-escalate onCreate exception log | 3 | 1 | 2 | 3 | 7 | 5 | 10 | 9 | 40 | 50.0 | total, urgency |
| 6 | `090bf5f` | cli: flush cerr/cout | 0 | 1 | 6 | 0 | 8 | 5 | 8 | 9 | 37 | 46.3 | bug, urgency |
| 6 | `0b3fcca` | cli: fix dtor ordering | 0 | 8 | 4 | 0 | 6 | 5 | 6 | 8 | 37 | 46.3 | safety, urgency |
| 8 | `d5ecc88` | clientintrospect: guard callback functors | 1 | 6 | 3 | 0 | 3 | 4 | 9 | 8 | 34 | 42.5 | safety |
| 9 | `eab3275` | clientdiscover: guard callback functors | 1 | 7 | 4 | 0 | 3 | 4 | 7 | 6 | 32 | 40.0 | safety |
| 10 | `086501a` | pvxmonitor: show dis/connect time | 0 | 1 | 1 | 0 | 7 | 3 | 9 | 9 | 30 | 37.5 | — (owner) |
| 11 | `67447cb` | error message copy/paste | 0 | 0 | 3 | 0 | 4 | 2 | 10 | 10 | 29 | 36.3 | — |
| 11 | `cc7bc72` | client: log error when syncCancel op dtor on worker | 0 | 5 | 3 | 0 | 5 | 4 | 7 | 5 | 29 | 36.3 | safety |
| 13 | `7490286` | pvalink: test sequence point after dbProcess | 0 | 3 | 5 | 0 | 3 | 3 | 8 | 6 | 28 | 35.0 | bug |
| 14 | `12fbe53` | minor (missing newline in a log format) | 0 | 0 | 2 | 0 | 2 | 1 | 10 | 10 | 25 | 31.3 | — |
| 15 | `2b99e3c` | JSON parsing | 0 | 2 | 1 | 0 | 5 | 2 | 6 | 8 | 24 | 30.0 | — |
| 15 | `8cb8d4b` | pvxput handle JSON | 0 | 1 | 3 | 0 | 6 | 2 | 5 | 7 | 24 | 30.0 | — |
| 17 | `27ccb3c` | QSrvWaitForLinkUpdate show current count | 0 | 0 | 2 | 0 | 1 | 1 | 9 | 9 | 22 | 27.5 | — |
| 18 | `5ab17ec` | re-write CLI argument parsing for testability | 0 | 2 | 2 | 0 | 2 | 1 | 4 | 6 | 17 | 21.3 | — |
| 19 | `2342090` | data: allow omission of leading `->` for union access | 0 | 1 | 2 | 0 | 2 | 1 | 7 | 3 | 16 | 20.0 | — |

Outcome: eleven met the rule. The rule is not a total ordering — `7490286`
met it at total 28 on bug alone and `cc7bc72` at total 29 on safety alone,
while `086501a` missed at total 30 because its value sat in ops, fit, and
locality, none of which gate.

The adopted set is dominated by one theme: freeing a callback functor while
it is still executing, which upstream states is undefined behaviour. Four
commits apply the same guard to the monitor, get, discover, and introspect
operations; two more cover related lifetime faults.

## Owner decision

| Commit | Rule outcome | Call | Rationale and verification |
| :-- | :-- | :-- | :-- |
| `086501a` | missed (total 30, no gating axis) | ADOPT | Timestamps on connect and disconnect in `pvxmonitor` are read during commissioning and fault chasing, which the ops median of 7 reflects but no gating axis captures. Verified to stand alone: `patch -p1 --dry-run` clean against 1.5.2, and the members it uses, `client::Connected::time` and `client::Disconnect::time`, are both present in 1.5.2 `src/pvxs/client.h` |

No rule-passing candidate was removed by owner decision.

## Not selected, and the JSON chain

Seven scored candidates were not carried: `67447cb` (29), `12fbe53` (25),
`2b99e3c` (24), `8cb8d4b` (24), `27ccb3c` (22), `5ab17ec` (17), `2342090`
(16).

Three of those are chained and could only be carried together. `5ab17ec`
fails `git apply --check` at 1.5.2 in `tools/Makefile` without `8cb8d4b`,
and `8cb8d4b` cannot build without the public header `2b99e3c` adds, so
adopting the tail would pull in roughly a thousand lines of new feature
code. Scoring also surfaced a defect in that new code — the JSON parser
mishandles an array nested directly inside an array, and no test covers it
— which is a further reason to wait for upstream rather than carry it.

## Apply-selection list

Twelve, in upstream merge order, which is the apply order. File names take
the form `patch/1.5.2-<NN>-<sha>-<slug>.p0.patch`.

| NN | Commit | Subject | Basis |
| :--: | :-- | :-- | :-- |
| 01 | `086501a` | pvxmonitor connect/disconnect timestamps | owner decision |
| 02 | `090bf5f` | CLI cerr/cout flush | bug, urgency |
| 03 | `7490286` | pvalink sequence point after `dbProcess` | bug |
| 04 | `0b3fcca` | CLI destructor ordering | safety, urgency |
| 05 | `084336b` | client retry slowdown after refused CREATE_CHANNEL | total, bug, urgency |
| 06 | `9a6b4cc` | server onCreate log de-escalation | total, urgency |
| 07 | `39cc6fa` | client InfoOp early-destruction guard | total, bug, safety, urgency |
| 08 | `c969383` | clientmon callback-functor guard | total, bug, safety, urgency |
| 09 | `c17812a` | clientget callback-functor guard | total, bug, safety, urgency |
| 10 | `eab3275` | clientdiscover callback-functor guard | safety |
| 11 | `d5ecc88` | clientintrospect callback-functor guard | safety |
| 12 | `cc7bc72` | syncCancel-on-worker diagnostic + pvalink opt-out | safety |

File overlaps inside the set, which fix the order: `tools/monitor.cpp` is
modified by 01, 02, and 04; the other five CLI sources by 02 and 04;
`ioc/pvalink_channel.cpp` by 03 and 12; `src/clientintrospect.cpp` by 07,
11, and 12. Commit 12 also touches the four client sources the guard
commits edit, which is why it applies last. Every overlapping pair is
dry-run verified in this order before wiring.

## Verification form for AC1 (recorded decision)

AC1 ("each proven by `patch --dry-run` against a clean pvxs 1.5.2
source") is discharged by the sequential-position proof: starting from a
clean 1.5.2 tree, each patch is dry-run proven at its stack position
01..12 — the exact path `make patch` executes. Adopted by the
three-reviewer plan round (session rs20260725_225719, convergence D1)
and acknowledged by the owner 2026-07-26. The individual-vs-pristine
table is kept as an audit annex in the execution record.

Measured basis: patch 04 (`0b3fcca`) cannot apply to pristine 1.5.2 —
its upstream parent state contains 02 (`090bf5f`), so its context lines
embed 02's edits in the six CLI sources (`tools/call.cpp` hunk 1 fails
at line 117). This is forced by commit ancestry and holds for any
faithful regeneration of the diff.

Contrast with the base carry (M22, `docs/base-carry-1.3.0.md`): there
#934 and #837 could not reach the pinned R7.0.10 state by ANY
application order (sibling post-tag drift) and were manually per-hunk
resolved, and #817 was curated by owner decision. The shared principle:
the verbatim upstream diff is the default; manual resolution is reserved
for a diff that cannot reach the pinned source state at all; every
deviation is recorded and validated by a forward+reverse dry-run round
trip. Patch 04 does not meet that bar — it applies cleanly at its stack
position — so it stays the authentic upstream diff.

## Managed with the base carry

This set is worked alongside the base carry (M22, #52) rather than as an
independent track. pvxs is the pvAccess implementation this environment
depends on, and absorption into EPICS base is the direction it is
structurally headed. Which base release does it is not settled — the timing
is the owner's estimate, not an announced base release plan — so no version
is named here.

The retirement rule follows from that. These patches are recorded against
pvxs 1.5.2 exactly, and the set is re-examined at whichever comes first: a
pvxs release above 1.5.2, or the base bump that brings pvxs into base. In
the second case the re-examination runs against the base tree — each carry
dropped if the absorbed sources already contain it, re-based if the region
moved — and it is worked together with the base carry's own retirement
checklist, not separately.

## Refresh — 2026-08-21

Re-run of the `1.5.2..master` enumeration against the current pvxs `master`, per
`docs/upstream-fix-carry-procedure.md`, to reconcile the carry above with fixes
merged after the M26 snapshot.

**Stage 1 — enumerate.** `1.5.2..origin/master` = 29 commits, survey snapshot tip
`788f838` (2026-08-04). No pvxs release tag above 1.5.2 exists, so a carry remains
correct. The M26 record fixed no snapshot commit (only the 2026-07-25 decision
date), so the delta was recovered by diffing against M26's processed set: 4
commits are new — including `1044240` and `b552fe9`, dated 2026-07-21 but merged
after M26's enumeration, which is why a date filter alone missed them (exactly the
case the runbook's snapshot-recording rule now prevents).

**Stage 2 — mechanical removal (2 swept, defensible from the diff):** `47d180a`
(bundle `RTEMS.cmake`, RTEMS-only) and `788f838` (evhelper kqueue — the whole
change sits inside `#ifdef __rtems__`, a no-op on linux).

**Stage 3 — five-reviewer eight-axis median (two survivors):**

| Commit | sec | saf | bug | perf | ops | urg | fit | loc | Total |
| :-- | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| 1044240 ioc: Remove redundant SPC_ATTRIBUTE condition | 0 | 2 | 1 | 1 | 1 | 0 | 8 | 9 | 22 |
| b552fe9 log Protocol decode fault as CRIT | 1 | 1 | 0 | 0 | 2 | 0 | 9 | 10 | 23 |

Raw per-reviewer scores (sec,saf,bug,perf,ops,urg,fit,loc):
- 1044240 — R1 0,1,1,1,1,0,8,8 | R2 0,1,1,1,1,0,8,9 | R3 0,2,1,1,1,0,9,7 | R4 0,2,0,0,1,0,9,10 | R5 0,2,1,0,1,0,8,9
- b552fe9 — R1 2,0,1,0,2,0,9,9 | R2 2,0,0,0,2,0,9,9 | R3 1,1,0,0,2,0,10,10 | R4 1,1,0,0,3,0,10,10 | R5 1,1,0,0,2,0,9,10

**Candidate findings.** All five reviewers verified against the base tree that
`1044240` is genuinely redundant — a PVA put reaches `dbPut`/`dbPutField`, both of
which return `S_db_noMod` for `SPC_ATTRIBUTE` before any write, so removing the
early throw does not let an attribute-field put through; no safety regression, but
no observable fix either. All five flagged a defect in `b552fe9`: the protocol
decode fault is remote-triggerable (any peer's malformed header), so promoting its
log to Crit lets an unauthenticated peer flood the Crit stream and trip site
alerting — a wrong-direction change, an argument against carrying beyond the low
score.

**Stage 4 — rule outcome.** Both miss the rule: 1044240 total 22, b552fe9 total 23;
neither meets total>=40, bug>=5, safety>=5, or urgency>=5.

**Stage 5 — owner decision (2026-08-21).** Rule-as-is: drop both. No owner override.
The pvxs carry is unchanged at 12 patches — nothing merged since M26 meets the bar.
