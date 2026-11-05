# lua 01aa7a1 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-11-01. Six upstream commits are above the
pin; two were removed as documentation and test only, and four were scored by
five independent reviewers. None meets the rule. The Maintainer carries none of
them. No patch file is generated and the pin stays at `01aa7a1`. Module build
and IOC acceptance remain pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](../procedures/upstream-fix-carry-procedure.md). The pin
`01aa7a1` was set earlier by the release record ([D9](https://github.com/jeonghanlee/EPICS-env/blob/d8dcbe12147842c34b8ec1f3f8187c18c6decc86/docs/milestone-1.5.0.md#decisions)); this record covers only the
commits merged after it.

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, platforms other than Linux, and git publication. Release decisions
in the [release record](https://github.com/jeonghanlee/EPICS-env/blob/d8dcbe12147842c34b8ec1f3f8187c18c6decc86/docs/milestone-1.5.0.md) govern later verification.

## Source range and coverage

- Upstream: `https://github.com/epics-modules/lua`, default branch `master`.
- Pin: `01aa7a1474a1ab525f1b97e042dcf7a7555ff15d`, committed 2026-10-06, a
  commit of `master` that upstream calls Release 4-0 (bundled Lua 5.5.1, device
  support in C++, extended `luascript` record, unified run and state APIs with
  deprecated aliases). The newest release tag, `R3-1`, is an ancestor of the pin
  and 178 commits behind it; no release tag contains the pin.
- Survey tip: `f68282674c3c654a135e23c58e2545318212f693`, committed 2026-10-23.
  The remote HEAD was observed at this commit on 2026-11-01 (`git ls-remote`).
  This is dated evidence: re-run `git log --reverse 01aa7a1..origin/master` in a
  clone before relying on the count of six.
- Six commits are above the pin, none a merge. The range changes 30 files
  (11 added and 19 modified, 1763 insertions and 239 deletions): device support sources, the `.dbd` files, `luaEpics.h`,
  `devUtil.h`, `lepicslib.cpp`, documentation, tests and files of the example
  IOC.
- The environment builds lua against Base 7.0.10 and asyn 4.46.0 on Linux only.
  No module links lua or includes its headers; `motor_DEPS` names `build.lua`
  only as a build-order declaration. No downstream patch is applied to lua.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 6 | `git log --reverse 01aa7a1..origin/master` of a clone |
| Removed as exclusively documentation, CI or tests | 2 | `b930a4d`: `docs/luaReleaseNotes.md` only; `f682826`: one test call in `luaApp/test/luaDtypTest.cpp` replaced by a direct put, test file only |
| Merge commits | 0 | |
| Deferred at the applicability gate | 0 | the files of all four scored commits exist at the pin |
| Scored | 4 | five independent reviewers |
| Met the rule | 0 | |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 0 | |
| Selected for carry | 0 | |

`ce8a474` changes files of the example IOC; they are neither documentation, CI
nor tests, so the commit was scored.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`lua-carry-1.5.0-scores.json`](lua-carry-1.5.0-scores.json). The rule is
`total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`.

Axis columns: `sec` security (remote exposure reduced), `saf` safety (memory
safety and robustness), `bug` functional correctness fixed, `perf` runtime
performance, `ops` facility operational value, `urg` urgency (harm if not
carried before the next bump), `fit` clean apply at the pin with a low
regression surface, `loc` locality (blast radius: a leaf scores high, deep core
code scores low). Higher is better on every axis. The full definitions are in the
[carry procedure](../procedures/upstream-fix-carry-procedure.md), Stage 3.

| Commit | Change | sec | saf | bug | perf | ops | urg | fit | loc | Total /80 | Rule met |
| :-- | :-- | --: | --: | --: | --: | --: | --: | --: | --: | --: | :-- |
| `be6052c` | 64-bit integer and `mbbiDirect`/`mbboDirect` device support; INT64 and UINT64 fields map to a new Lua type | 0 | 1 | 4 | 0 | 4 | 2 | 6 | 4 | 21 | none |
| `4db9388` | `lsi` and `lso` device support; long strings in `epics.get` and `epics.put` | 0 | 1 | 3 | 0 | 4 | 1 | 3 | 6 | 18 | none |
| `b0d29c1` | `waveform`, `aai` and `aao` device support | 0 | 2 | 1 | 0 | 5 | 1 | 2 | 5 | 16 | none |
| `ce8a474` | example IOC `08-LuaDTYPSupport` updated for the added types | 0 | 0 | 0 | 0 | 1 | 0 | 4 | 10 | 15 | none |

All totals are the sums of the recorded per-axis medians. The five totals of
`be6052c` range from 18 to 27, of `4db9388` from 16 to 22, of `b0d29c1` from 14 to
20 and of `ce8a474` from 15 to 16. The highest median total, 21, stays under the 40 of
the first condition.

## Dependencies and conflicts

`4db9388` and `b0d29c1` do not apply to the pin alone: real `patch -p1 --dry-run`
of each upstream diff on a copy of the pinned source fails hunks because they
build on the earlier commits. For `4db9388` they are in `docs/index.md`,
`docs/luaReleaseNotes.md` and the first hunk of `luaDtypTest.cpp`; its hunks of
`luaApp/src/Makefile`, `luaSupport.dbd` and `lepicslib.cpp` apply with fuzz or an
offset, so the patch fails as a whole and not in the code. For `b0d29c1` they are
in `docs/device-support.md`, `docs/index.md`, `docs/luaReleaseNotes.md`,
`luaApp/src/Makefile`, `luaSupport.dbd` and `luaDtypTest.cpp`. `4db9388` applies
after `be6052c`. `b0d29c1` does not apply after `be6052c` alone (six or more hunks
fail in the same files and the documents); as an upstream patch it needs `be6052c`
and `4db9388`. The code files of both (the device support sources, `devUtil.*`)
apply alone; only the registration hunks and the context set by the earlier
commits fail, so a curated patch of either would be possible. `be6052c` and `ce8a474` apply
alone, and the four apply without fuzz or reject in upstream order. `ce8a474`
loads its example database only with the types of the three code commits. The
three code commits change the same files (`luaApp/src/Makefile`,
`luaSupport.dbd`, `luaDtypTest.*`, `docs/*`), so any selection of one of them
carries all the earlier ones.

## Findings on the candidates

- The three code commits are new device support, not defect fixes. The only
  defect they correct is in `be6052c`: the pin stores a 64-bit integer written
  with `epics.put` to an INT64 field as a truncated value (reviewers wrote the Lua
  integers 4611686018427387905, 5000000001, 7000000000 and 9000000000 and read back
  1.0, 705032705, -1589934592 and 410065408). The pin sends a Lua integer through
  a 32-bit conversion, so integer values above 32 bits are affected, whether
  they come from an integer literal or from integer arithmetic; a Lua float such as
  `7e9` goes through the double path and is exact at the pin. `be6052c` stores
  the integers exactly.
- `be6052c` also changes what existing users observe: `epics.get` of an INT64 or UINT64 array returns a table of
  doubles at the pin and `nil` with an error after the change; `epics.get` of a scalar
  INT64 or UINT64 field returns a Lua float at the pin and a Lua integer after the
  change (all five reviewers printed a float on the pin and an integer after the
  change in their probes, and the source shows `pushnumber` becoming
  `pushinteger`), so script code that tests the subtype or formats the value
  with `%d` sees a difference; a `luascript`
  record whose string or array input (`INAA` to `JJ`) reads an INT64 or UINT64
  field goes
  INVALID with VAL 0 where the pin works, because the type `switch` of
  `luascriptRecord.cpp` has no case for the new `DB_LUA_INT64` value and falls to
  its default (checked in the source of the head); the numeric inputs `INPA` to
  `INPJ` read every field as a double and are not affected (two reviewers ran
  them on the pin and on the chain with the same result); and (one reviewer) a
  UINT64 value at or above 2^63 wraps negative. Four reviewers found the array
  regression and three the `luascript` one. They have separate causes: the
  array path of `db_get` in `lepicslib.cpp` has no `DB_LUA_INT64` case (its
  scalar path has one), and the type `switch` of `luascriptRecord.cpp` has none,
  so a curated patch of `be6052c` that repaired both regressions would have to add
  the case in both files. The change also inserts `DB_LUA_INT64` into the middle of the enumeration of `luaEpics.h`
  (safe in a coherent rebuild, which this environment does).
- `b0d29c1` guards its INT64 and UINT64 array code with `#ifdef DBF_INT64`. In
  Base 7.0.10 `DBF_INT64` is an enumerator of `dbfType` (`dbFldTypes.h`), not a
  macro, so the guard is false and that code is not compiled: an INT64 waveform
  returns NORD 3 with all zeros and no alarm. A reviewer also found that a LONG
  waveform fed fractional values stores zeros without an alarm.
- `4db9388` works for names without a dot: long strings are bounded (a 50-character string into SIZV 10
  gave 15 characters with no overflow; the `lsi` record of Base raises `SIZV` to a
  minimum of 16 at initialisation, so 15 is the buffer minus the terminator, and
  the change itself copies at most `SIZV` minus one bytes). One reviewer noted that the long-string
  hook also applies to other string fields over 40 bytes, so `DESC` stores 40
  characters instead of 39. One reviewer found by reading the source that
  `longStringDollarName` in `lepicslib.cpp` appends `$` to the whole name when the
  name contains a dot, so a record name with a dot fails `dbNameToAddr` and the
  code silently falls back to the 40-character path (the source matches that
  description; it was not executed).
- Smaller defects that reviewers reported for code that is not carried: `mbbiDirect`
  writes `VAL` unmasked; non-numeric table elements of an array become 0 without
  a message and an unsupported `FTVL` such as ENUM sets `NORD` without writing;
  `luaBufferToTable` is unused and the `aao` test never asserts the sum. None changes the
  decision.
- The 64-bit device entries (`int64in`, `int64out`) go into a new
  `luaInt64Support.dbd`, which `LUA_DEPS` pulls in only for Base 7.0 or later; the
  installed loader lists `luaSupport.dbd` alone, so a carry of `be6052c` would
  also have to add that file to the loader entry.
- Existing IOCs: `liblua.so` gains symbols and loses none; `dbdExpand`,
  `registerRecordDeviceDriver` and a link against `liblua` succeed with the new
  `luaSupport.dbd`, whose only difference is added `device()` lines.
- Shipped tests (`make runtests` in `luaApp/test`): 468 pass on the pin, 472 with
  `be6052c`, 489 with the four commits; the tests do not cover the regressions
  above.
- Consumers: no module of this environment uses lua beyond the build-order
  declaration of motor, so the effects above reach only site IOCs that this
  repository does not contain. The installed loader lists `luaSupport.dbd`
  (`lua_IOCSH_DBDS`); with the four commits that file only gains `device()` lines.

## Decision

Maintainer decision, 2026-11-01: carry none of the commits.

- None meets the rule; the highest total is 21 of 80.
- `be6052c` is the only one that corrects a defect, and it trades it for a
  regression in `epics.get` of INT64 arrays and in the string and array inputs of
  `luascript` that read INT64 or UINT64 fields, which the pin handles.
- `b0d29c1` returns zeros for INT64 waveforms without an alarm on Base 7.0.10.
- The features are not needed before the next release. That is the reason for
  rejecting `4db9388` and `b0d29c1`, not that they cannot be applied: as upstream
  patches `4db9388` needs `be6052c`, and `b0d29c1` needs `be6052c` and `4db9388`,
  while their code files apply alone and a curated patch would be possible.

The pin `01aa7a1` is unchanged ([D9](https://github.com/jeonghanlee/EPICS-env/blob/d8dcbe12147842c34b8ec1f3f8187c18c6decc86/docs/milestone-1.5.0.md#decisions)), and step 6.3 of the release procedure needs
no pin edit (`configure/RELEASE` already holds `01aa7a1`). No patch file is generated, no rule is
wired, and no patch document changes.

## Verification

The packets disagree on which hunks of `4db9388` fail on the pin (reviewers 1, 3,
4 and 5 say, in part or in full, that the `Makefile` and `luaSupport.dbd` hunks
fail; reviewer 2 says they apply); the author and three later reviews re-ran the
dry-run on the pin, and the files named in the Dependencies section are the
result. The statement that a curated patch would be possible rests on reviewer 2,
who built the pin with a partial `4db9388` (no errors, 477 shipped tests pass) and
the pin with `b0d29c1` and its `Makefile` and `.dbd` lines added by hand (no errors). Reviewers copied the pinned source from its tracked files and built the pin,
`be6052c` alone, `ce8a474` alone and the four-commit chain with the `conf.lua`
recipe (`EPICS_BASE` and `ASYN` in `configure/RELEASE.local`, an install
location and `CHECK_RELEASE = NO` in `configure/CONFIG_SITE.local`, `make`). All
builds exited 0, and the chain showed the same warning lines as the pin (16
lines on the chain in the counts of reviewers 3 and 5; reviewer 2 counted 15
lines on its pin and on its build of `be6052c` alone).
The shipped tests gave the counts above. The absolute warning count differs between
the reviewers' counts (15 and 16); compare the build of the chain with the build
of the pin on the same host. The INT64 `epics.get` and `epics.put`
results and the `DESC` length come from test programs that reviewers wrote and
ran on both the pin and the chain; the waveform, `lsi`, `lso` and example
results ran on the chain only, because that device support does not exist at the
pin. Two of the findings were checked again in the source for this record
(the `DBF_INT64` enumerator in `dbFldTypes.h`, and the type `switch` in
`luascriptRecord.cpp`).

## Not verified

- the example IOC of `08-LuaDTYPSupport`: one reviewer built it and ran its
  startup script; one ran its database and callbacks through a test IOC because
  the example program did not link; one could not link it with `BUILD_IOCS=YES`
  on the pin or on the chain; two only read it;
- builds on Rocky Linux 8 and 10, Ubuntu 24.04 and 26.04 (GCC 15) and Debian 12,
  the CI matrix, `make check.deps` and an installed-tree check;
- the removed commits `b930a4d` and `f682826`, beyond their file lists.

## At the next pin change

Nothing in the repository is tied to this assessment except the pin: there is no
lua patch file and no lua rule in `configure/RULES_SRC`, so the Bump obligation of
the [carry procedure](../procedures/upstream-fix-carry-procedure.md) has nothing to
drop or re-base. Open the question again when upstream tags a release that
contains the pin, or when the branch advances past `f682826`, and weigh these.
Test the two triggers in a clone of `https://github.com/epics-modules/lua.git`:

```
git tag --contains 01aa7a1
git ls-remote --tags --refs origin | awk -F/ '{print $3}' | grep '^R[0-9]' | sort -V | tail -3
git log --reverse 01aa7a1..origin/master
```

The first prints nothing while no release contains the pin; the second ends at
`R3-1` on 2026-11-01; the third lists the six commits of this record, and a longer
list means the branch advanced. Then weigh:

- whether the regressions of `be6052c` are fixed upstream (`epics.get` of INT64
  and UINT64 arrays, the `luascript` string and array inputs that read an INT64 or UINT64 field, the scalar
  `epics.get` subtype, the UINT64
  values at or above 2^63) and whether the `#ifdef DBF_INT64` guard of
  `devUtil.cpp` is replaced, since a bump to a release that carries the features
  makes the carry question moot;
- the known defect of the lua database hook at this pin, which the Deferred work
  table of the release record lists, and which a carry is decided for only when
  the work is assigned; none of the six commits touches the file of that hook
  (`ldatabaselib.cpp`), so they neither fix it nor change it.

The results above hold for this pin, Base 7.0.10 and asyn 4.46.0 only: the
`DBF_INT64` enumerator, the shipped test counts of 468, 472 and 489 and the
reviewers' observations are redone at a new pin by a new scoring run.

## Completion review

Independent reviewers with fresh context ran the completion reviews of the
[carry procedure](../procedures/upstream-fix-carry-procedure.md). No patch is
generated, so the reviews cover the record and the lua passages of the release
record. Third-person passes re-derived the range, the dependency dry-runs, the
scores, the source facts and the reviewers' findings with their own commands,
builds and probe programs. Second-person passes read the text from the seats of
the release manager, the module-cycle Executor, the Maintainer of the next
release, an IOC engineer, an engineer deciding a curated carry and a documentation
reconciler.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | second | 0 | 3 | 6 | the minors corrected: a section on what to re-check at the next pin change, the date of the remote observation, and the dependency of `b0d29c1` on `4db9388` as well |
| 2 | third | 0 | 4 | 5 | the minors corrected: the files that fail in the dry-runs, the `luascript` regression limited to the string and array inputs, a reviewer count and the claim that every result ran on both the pin and the chain |
| 3 | second | 0 | 5 | 6 | the minors corrected: the Lua integers that the pin truncates (a float such as `7e9` is exact), UINT64 fields in the `luascript` regression, the change of the scalar `epics.get` subtype, the warning counts and the overstated dependency of `4db9388` |
| 4 | third | 0 | 1 | 1 | the minor corrected: the `lsi` record of Base, not the change, raises `SIZV` to 16 |
| 5 | second | 0 | 2 | 1 | the minors corrected: the release row says that no pin edit is needed, and the commands that test the two triggers for the next pin change are listed |
| 6 | third | 0 | 1 | 4 | the minor corrected: a defect of `4db9388` for record names with a dot; the info acted on: the `luaInt64Support.dbd` and loader fact and the other reported defects |
| 7 | second | 0 | 4 | 3 | the minors corrected: the numeric inputs are `INPA` to `INPJ`, the reviewer counts, the split of the packets on the `4db9388` hunks and the second location of the array regression |
| 8 | third | 0 | 1 | 2 | the minor corrected: all five reviewers observed the float-to-integer change of the scalar `epics.get`; the info acted on: the two regressions have separate causes |

The Owner closed the loop after pass 8, which had returned one minor, a count of
reviewers. The reviews together returned 21 minor and 28 info findings and no
must-fix; each minor was corrected before the next pass. The link of the
procedure and the release record in this file are relative to `docs/` and need the
same adjustment as the other 1.5.0 carry records when they move to `docs/archive/`.

