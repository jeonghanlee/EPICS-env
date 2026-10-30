# modbus R3-4 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-10-30. The Maintainer selected the
recommended set: one curated patch of upstream commit `4e39e7a`. The other
eight scored commits are not carried. The patch is wired into aggregate
apply/revert and passes the targeted verification below. The source remains
pinned to `tags/R3-4`; full module and IOC acceptance remain pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md).

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, Windows, and git publication. Release decisions in the
[release record](milestone-1.5.0.md) govern later verification. The upstream
test suite was not run.

## Source range and coverage

- Upstream: `https://github.com/epics-modules/modbus`, default branch `master`.
- Pin: `tags/R3-4`, `4a1276b0efa6f378a6dcbe58a10a1d73a44c7ed3`.
- Survey tip: `768d1056cfacbf7e25820087d49b2ebe3bf3e29e`, committed 2026-09-07.
- Remote observation on 2026-10-30 confirmed 16 commits in `R3-4..master`
  and no release tag above R3-4.
- Base is 7.0.10 and asyn is 4.46.0.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 16 | `git log R3-4..origin/master`, confirmed with the GitHub compare API |
| Removed as exclusively documentation | 4 | `a59270f`, `b28d4a6`, `e7f98ea`, `768d105`; judged from the diff |
| Merge commits | 3 | `2d696bd`, `a858357`, `b1009d0`; represented by their constituent commits |
| Deferred at the applicability gate | 0 | all nine apply to R3-4 and their target code exists there |
| Scored | 9 | five independent reviewers |
| Met the rule | 1 | `4e39e7a` |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 0 | |
| Selected for carry | 1 | `4e39e7a`, curated |

Merge commits are not one of the three removal categories of the procedure.
They are not scored because their content equals their constituents. The tree
of `2d696bd` and of `a858357` equals the automatic merge of their parents. The
tree of `b1009d0` differs from the automatic merge only in
`modbusApp/Db/aoFloat64.template`, where it resolves the PINI and DESC conflict
below; it is the adaptation reference if both commits are ever selected.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`modbus-carry-1.5.0-scores.json`](modbus-carry-1.5.0-scores.json). The rule is
`total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`.

Axis columns: `sec` security (remote exposure reduced), `saf` safety (memory
safety and robustness), `bug` functional correctness fixed, `perf` runtime
performance, `ops` facility operational value, `urg` urgency (harm if not
carried before the next bump), `fit` clean apply at the pin with a low
regression surface, `loc` locality (blast radius: a leaf scores high, deep core
code scores low). Higher is better on every axis. The full definitions are in the
[carry procedure](procedures/upstream-fix-carry-procedure.md), Stage 3.

| Commit | Change | sec | saf | bug | perf | ops | urg | fit | loc | Total /80 | Rule met |
| :-- | :-- | --: | --: | --: | --: | --: | --: | --: | --: | --: | :-- |
| `4e39e7a` | Windows min/max guard, Float64 debug loop removal, explicit cast, size_t-to-int bounds | 1 | 7 | 5 | 1 | 3 | 5 | 8 | 6 | 36 | bug, safety, urgency |
| `98c38be` | CRC error trace prints expected and actual values | 0 | 0 | 1 | 0 | 3 | 2 | 10 | 10 | 26 | none |
| `6454b0e` | diagnostic addresses printed in decimal instead of octal | 0 | 0 | 1 | 0 | 3 | 2 | 9 | 9 | 24 | none |
| `f214371` | new mbbi and mbbo templates | 0 | 0 | 0 | 0 | 3 | 1 | 9 | 10 | 23 | none |
| `cc3fdce` | statistics reset in driver, plus operator screens | 0 | 2 | 2 | 0 | 5 | 2 | 6 | 5 | 22 | none |
| `ed9d64a` | optional PINI on aoFloat64 template | 0 | 0 | 1 | 0 | 3 | 1 | 6 | 9 | 20 | none |
| `a8a37b4` | ResetStatistics record in statistics template | 0 | 0 | 1 | 0 | 2 | 1 | 5 | 9 | 18 | none |
| `e75f2ab` | optional DESC on 28 templates | 0 | 0 | 0 | 0 | 4 | 1 | 5 | 7 | 17 | none |
| `d19e101` | developer asyn and Base paths in configure/RELEASE | 0 | 0 | 0 | 0 | 0 | 0 | 7 | 10 | 17 | none |

All totals are the sums of the recorded per-axis medians.

## Dependencies and conflicts

| Relation | Commits | Evidence |
| :-- | :-- | :-- |
| Prerequisite at runtime | `a8a37b4` needs `cc3fdce` | With the R3-4 driver, loading the record reports `cannot find parameter RESET_STATISTICS`. Both apply and build in either order. |
| Conflict | `ed9d64a` and `e75f2ab` | Both edit `modbusApp/Db/aoFloat64.template`. `git apply` and `patch` fail on the second in either order. |
| File overlap | `6454b0e`, `4e39e7a`, `cc3fdce` | All edit `modbusApp/src/drvModbusAsyn.cpp` in separate regions. No functional prerequisite was found. |
| No effect here | `d19e101` | It edits the upstream developer paths in `configure/RELEASE`. `conf.modbus` writes `configure/RELEASE.local` with `ASYN`, and `conf.release.modules` writes the repository `RELEASE.local` with `EPICS_BASE`; the module `configure/RELEASE` includes both after its own definitions, so both developer paths are overridden. |

All nine apply individually to R3-4 with zero fuzz. Applying all nine in
merge order fails only at `e75f2ab`. With the `b1009d0` resolution of
`aoFloat64.template`, every file of the stack equals the survey tip except four
documentation files (`device_support.rst`, `K1_Xn_Bit_Statistics.png`,
`overview.rst`, `RELEASE.md`).

## Defects in the candidates

- `4e39e7a` casts `maxChans` and `maxChars` from `size_t` to `int` before
  `std::min` in `readInt32Array` and `readOctet`. The configured request is ten
  registers. Capacity 2147483647 and ordinary capacities are unaffected. Above
  2147483647 the upstream change gives these results, each measured with the
  real driver:

  | Capacity | Registers requested | Result |
  | --: | --: | :-- |
  | 2147483648 | 0 | Modbus exception 3, status 3, no elements |
  | 2147483658 | 10 | normal reply, status 3, no elements |
  | 3000000000 | 24064 | Modbus exception 3, status 3, no elements |
  | 4294967296 | 0 | Modbus exception 3, status 3, no elements |
  | 4294967301 | 5 | status 0, reports 10 elements |
  | 4294967306 | 10 | normal |

  The `readOctet` site was inspected, not executed.
- `cc3fdce` resets the statistics on any write to `RESET_STATISTICS`, including
  value 0 ("Done").
- `cc3fdce` includes regenerated operator-screen churn in five formats.
- `f214371` has a header comment in `mbbo.template` that says "mbbi".

## Selection

Maintainer decision, 2026-10-30: carry the recommended set only.

| Order | Commit | Title | Total | Basis | Overlap |
| --: | :-- | :-- | --: | :-- | :-- |
| 1 | `4e39e7a` | curated: Windows guard, debug loop removal, explicit cast | 36 | bug, safety, urgency | none |

`Overlap` lists the other members of this selection that modify a file the commit
modifies; the selection has one member, so it is none.

The patch is `patch/3.4.0-01-4e39e7a-readfloat64array-debug-loop.p0.patch`.
It keeps three changes of the upstream commit:

- the `_WIN32` guard that undefines `min` and `max`, which has no effect on the
  Debian and Rocky targets;
- the removal of the debug loop at the top of `readFloat64Array`, which reads
  `offset` before `getAddr` assigns it;
- the explicit `(epicsUInt16)` cast in `writeFloat64Array`.

It omits the two `size_t`-to-`int` bound changes, so `readInt32Array` and
`readOctet` keep the R3-4 `size_t` bounds. The score above rates the whole
upstream commit, not this curated variant. Basis for the Maintainer decision:
the rule is met by the commit, and the curated variant removes the one
regression found.

The apply glob is `patch/$(SRC_VER_MODBUS)-*.p0.patch` (`3.4.0`), through
`patch.modbus.commit.apply` and `patch.modbus.commit.revert`.

## Verification

Real driver, asyn and Modbus interpose sources were used throughout. Only the
TCP peer was a simulated responder. Base 7.0.10 and asyn 4.46.0 were installed
copies. Builds used `CHECK_RELEASE=WARN` because the installed asyn metadata
names a different Base directory, which also fails the unmodified tree.

| Check | Result |
| :-- | :-- |
| `make patch.modbus.commit.apply` then `patch.modbus.commit.revert` | both exit 0; `modbus-src` identical to the pin afterwards; no `.orig` or `.rej` |
| Applied tree compared with the patch file | identical |
| Summary agreement for the `3.4.0` track | carry files 1, `patch/README.md` table rows 1, heading count 1; site files 0 |
| Aggregate `make patch` then `make patch.revert` on all source trees | both exit 0; 40 `Patching` lines, one of them for modbus; the status and diff digest of all 37 source trees equal their state before the run |
| Build of the applied tree with `-Wall -Wextra` | exit 0; 21 warnings in `drvModbusAsyn.cpp`, the same count as the unmodified tree |
| Each of the nine commits applied alone, and the full resolved stack | all build with exit 0 |
| Float64Array read, ordinary build, 20 runs | unmodified R3-4: 9 segmentation faults; patched: 0. Another independent test program saw 0 of 20 for the unmodified tree, so the count depends on the stack contents of the test program |
| Float64Array read, AddressSanitizer with pattern initialization | unmodified R3-4: invalid read at the debug loop; patched: normal |
| Int32Array read, capacity 10, 2147483647, 2147483648, 4294967296 | patched: ten registers requested and returned in every case |
| Upstream `4e39e7a` unmodified at capacity 2147483648 and 4294967296 | zero registers requested, exception 3, no elements |
| Statistics reset through the driver with `cc3fdce` | counters return to zero after writing 0 and after writing 1 |

The segmentation-fault counts depend on stack contents in the test program and
are not an IOC failure rate. The sanitizer run does not show that every normal
build crashes.

## Not verified

- the `(epicsUInt16)` cast in `writeFloat64Array` at run time;
- Windows, hardware, operator-screen rendering, concurrency, the CI matrix,
  `make check.deps`, an installed-tree check and a strict release-check build;
- an IOC loading the shipped templates with the patched library.

## Completion review

Independent reviewers with fresh context ran the completion reviews of the
[carry procedure](procedures/upstream-fix-carry-procedure.md). Third-person
passes (1, 2, 4) re-derived the patch content, wiring, scores, funnel, builds
and runtime claims with their own commands. Second-person passes (3, 5) read the
changed text as a reader without session context and ran the reader actions.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | third | 0 | 5 | 4 | all five minor corrected: capacity table with measured values, funnel line for the applicability gate, raw scores kept in the scores file, aggregate `make patch` and `make patch.revert` run, version-anchored lists in four documents completed |
| 2 | third | 0 | 3 | 3 | all three minor corrected: remaining family lists in the concepts page, curation recorded in the Basis cell, this section |
| 3 | second | 0 | 1 | 2 | the minor corrected: axis abbreviations defined at the score table |
| 4 | third | 0 | 4 | 5 | all four minor corrected: contradicting sentence in the release record, capacity wording of the decision row, override mechanism of `d19e101`, version-anchored list in the verification procedure |
| 5 | second | 0 | 2 | 2 | both minor corrected: the release record sentence, definition of the Overlap column |
| 6 | third | 0 | 1 | 0 | the minor corrected: the capacity quantifier in the decision row of the release record |
| 7 | second | 0 | 0 | 3 | none needed |
| 8 | third | 0 | 0 | 2 | none needed |

Info items acted on: the Summary agreement result is listed in Verification,
the independent segmentation-fault observation is stated beside the count, and
the description of the review passes names what each ran. The other info items
need no change: the status digests of the aggregate run could not be re-derived
by a reviewer who was not allowed to run `make patch` in the repository, and
`768d105` is a binary image whose path makes it documentation.

The loop ended when the last third-person pass (8) and the last second-person pass
(7) returned no finding above the floor. This is the eighth review of this
record; all eight ran with fresh context. Info items of passes 7 and 8 need no
change: the omitted bound changes arrive with a release that contains the full
upstream commit, which the Bump obligation of the procedure already covers, and
the test programs behind the runtime rows are not kept in the repository.
