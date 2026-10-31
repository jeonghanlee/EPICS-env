# StreamDevice 2.8.26 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-10-30. The Maintainer selected one upstream
commit, the scalcout string truncation fix. The other twelve scored commits are
not carried, and the two existing local patches stay. The carry file is wired
into aggregate apply/revert and passes the targeted verification below. The
source remains pinned to `tags/2.8.26`; full module and IOC acceptance remain
pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md).

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, platforms other than Linux, and git publication. Release decisions
in the [release record](milestone-1.5.0.md) govern later verification.

## Source range and coverage

- Upstream: `https://github.com/paulscherrerinstitute/StreamDevice`, default branch `master`.
- Pin: `tags/2.8.26`, `668d1d525509604ab4ccd7382022dfb469c99841`.
- Survey tip: `562dd5ad36e07989a8bbb231dcb5bd165537c7f6`, committed 2026-08-10.
- Remote observation on 2026-10-30 confirmed 19 commits in the range and no
  release tag above 2.8.26.
- Base is 7.0.10, asyn is 4.46.0 and calc provides scalcout; `PCRE` is empty.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 19 | GitHub compare API from the pin to `master` |
| Removed as exclusively documentation or CI | 6 | `2b3e4189`, `13e7f2d3` (merge of that documentation pull request), `20dde4c1`, `b9dd7171`, `deb73b28`, `f15837e1`; judged from the diff |
| Deferred at the applicability gate | 0 | the target code of every commit exists at the pin |
| Scored | 13 | five independent reviewers |
| Met the rule | 1 | `562dd5ad` |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 0 | |
| Selected for carry | 1 | `562dd5ad` |

`9080d6ca` changes a debug message text and `eb41a0dd` changes documentation
together with `configure/RELEASE`; both change code or configuration and were
scored.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`streamdevice-carry-1.5.0-scores.json`](streamdevice-carry-1.5.0-scores.json). The rule is
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
| `562dd5ad` | scalcout SVAL string truncation fixed (`sizeof(val)` to `sizeof(sval)`) | 0 | 2 | 8 | 0 | 6 | 5 | 10 | 10 | 41 | total, bug, urgency |
| `929204cb` | gcc 15 compatibility: function pointer casts in 21 device support files | 0 | 0 | 2 | 0 | 5 | 3 | 9 | 7 | 26 | none |
| `2a3ffdd7` | cleanup when `epicsExit` runs | 0 | 4 | 3 | 0 | 3 | 2 | 7 | 6 | 25 | none |
| `7debc865` | new `hv_mps` checksum for Spellman MPS supplies | 0 | 0 | 1 | 0 | 3 | 1 | 9 | 9 | 23 | none |
| `5ae38a08` | signed hexadecimal input format `%+x` | 0 | 0 | 3 | 0 | 3 | 1 | 8 | 8 | 23 | none |
| `9080d6ca` | typo in a debug message | 0 | 0 | 0 | 0 | 0 | 0 | 10 | 10 | 20 | none |
| `e95cb6f7` | `unsigned char` casts for `ctype` calls | 1 | 3 | 2 | 0 | 1 | 1 | 6 | 6 | 20 | none |
| `e87e093c` | vxi11 optional in recent asyn: replaces `asynRegistrars.dbd` by explicit DBD list | 0 | 0 | 3 | 0 | 3 | 1 | 4 | 8 | 19 | none |
| `f473f4d6` | tab indent of three dependency recipes in `src/Makefile` | 0 | 0 | 1 | 0 | 1 | 0 | 3 | 10 | 15 | none |
| `f61e6404` | checksums after regsub check the original input | 0 | 0 | 3 | 0 | 1 | 1 | 5 | 3 | 13 | none |
| `eb41a0dd` | documentation, links and versions of external packages, including `configure/RELEASE` | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 9 | 12 | none |
| `edfae34c` | compiler warning fixes | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 8 | 11 | none |
| `79ba99d7` | drop support for EPICS 3.13 (27 files) | 0 | 0 | 0 | 0 | 1 | 0 | 3 | 1 | 5 | none |

All totals are the sums of the recorded per-axis medians. A note of one reviewer in the scores file says the DBD list of `e87e093c` drops a registrar; the Dependencies table gives the checked result, that none is lost. The reviewers scored
against the baseline that the environment builds: the pin plus the two local
patches `StreamDevice-no-vxi11` and `StreamDevice-dbd-tab`. Their brief named
Debian and Rocky targets only, so `929204cb` was scored without the Ubuntu 26.04
target and without the C17 bridge; the Selection section gives the decision basis.

## Dependencies and conflicts

| Relation | Commits | Evidence |
| :-- | :-- | :-- |
| Prerequisite | `edfae34c` needs `f61e6404` | `edfae34c` edits debug lines that `f61e6404` introduces; it fails to apply without it. |
| Context chain | `79ba99d7`, `eb41a0dd`, `2a3ffdd7` | Their `CHANGELOG.md` hunks apply only after the preceding commits' `CHANGELOG.md` changes, which include a removed documentation commit. Their code hunks apply alone. |
| Documentation dependency | `eb41a0dd` | Its `docs/index.html` hunk needs `79ba99d7`, a scored commit; its `docs/setup.html` hunk needs `79ba99d7` and the removed documentation commit `2b3e4189`; its `CHANGELOG.md` hunk needs the preceding `CHANGELOG.md` changes. The binary `docs/PSI.png` applies to the pin alone with `git apply`; `patch` cannot read it. |
| Replaces a local patch | `e87e093c` and `StreamDevice-no-vxi11` | `e87e093c` deletes `streamApp/asynRegistrars.dbd`, which the local patch edits; the two cannot be stacked. Built on the pin alone, its explicit DBD list registers the same commands as the baseline plus `asynInterposeDelayRegister` and `asynInterposeEchoRegister`; no registrar is lost. With `e87e093c` in the pin, the local patch fails `make patch`, which is the signal to drop it. |
| Repeats a local patch | `f473f4d6` and `StreamDevice-dbd-tab` | Both change the same three recipe lines of `src/Makefile`. `git apply` and plain `patch` refuse the second one after either; with `patch --ignore-whitespace`, the option the repository uses, both orders apply because the changed lines coincide. The local patch adds a comment, which the upstream commit lacks. With `f473f4d6` in the pin, the local patch still applies without error and only adds its comment to the already fixed lines, so it must be dropped by hand. |
| File overlap | `src/ChecksumConverter.cc`: `7debc865`, `e95cb6f7`, `edfae34c`, `f61e6404`; `src/StreamCore.cc`: `9080d6ca`, `edfae34c`, `f61e6404`; `src/StreamEpics.cc`: `2a3ffdd7`, `79ba99d7`, `e95cb6f7`; `src/StreamFormatConverter.cc`: `5ae38a08`, `e95cb6f7`; `src/devscalcoutStream.c`: `562dd5ad`, `929204cb`; `src/devaoStream.c` and `src/devstringoutStream.c`: `79ba99d7`, `929204cb`; `CHANGELOG.md`: `2a3ffdd7`, `79ba99d7`, `eb41a0dd`; `docs/formats.html`: `5ae38a08`, `eb41a0dd`, `f61e6404`; `docs/index.html` and `docs/setup.html`: `79ba99d7`, `eb41a0dd` | Applied in upstream order with `git apply`, all 18 non-merge commits apply without rejection; `patch` rejects the `.ci` pointer change of `deb73b28`, a removed commit, and cannot read the binary `docs/PSI.png` of `eb41a0dd`. |

The pristine pin without the local patch `StreamDevice-no-vxi11` does not link
`streamApp` against asyn 4.46.0 (`vxi11RegisterCommands` is undefined).

## Defects in the candidates

- `f61e6404` does not extend `StreamFormatTypeStr[]` for its new
  `needs_original_format` type, which reads outside the array in debug output
  at `streamDebug` 2 or higher. The fix has no effect in this environment
  because the regsub converter needs PCRE.
- `5ae38a08` shifts a negative value left (undefined behavior before C++20),
  counts a `0x` prefix toward the field width, and changes the meaning of `+`
  for protocols that already use `%+x` on input.
- `2a3ffdd7` could not be shown to fix a failure at exit; its value rests on
  reading the code, and its `terminating` flag is a plain integer.
- `79ba99d7` touches 27 files, including `GNUmakefile`, which the module
  configuration rule removes.

## Selection

Maintainer decision, 2026-10-30: carry `562dd5ad` only and keep both local patches.

| Order | Commit | Title | Total | Basis | Overlap |
| --: | :-- | :-- | --: | :-- | :-- |
| 1 | `562dd5ad` | scalcout SVAL string truncation | 41 | total, bug, urgency | none |

`Overlap` lists the other members of this selection that modify a file the commit
modifies; the selection has one member, so it is none.

The patch is `patch/2.8.26-01-562dd5a-scalcout-sval-size.p0.patch`. It is the
upstream change unmodified: `devscalcoutStream.c` passed `sizeof(sco->val)`,
the size of a double, as the buffer size for the string value, so a string
reply was cut to 7 characters; the fix passes `sizeof(sco->sval)`. It applies
alone to the pin and on top of each local patch.

The apply glob is `patch/$(SRC_VER_STREAM)-*.p0.patch` (`2.8.26`), through
`patch.StreamDevice.commit.apply` and `patch.StreamDevice.commit.revert`. The
carry applies before the two local patches, which keep their own rules, and
reverts after them.

The other twelve scored commits are not carried because each misses the rule
and the Maintainer added none. `929204cb` is not carried because the C17 bridge
already builds StreamDevice on GCC 15; `e87e093c` and `f473f4d6` are not carried
because the two local patches already cover them.

## At the next pin change

The carry glob is anchored to the pin version, so at a pin change
`patch.StreamDevice.commit.apply` matches no file and the carry stops applying
without a message. Follow the Bump obligation of the
[carry procedure](procedures/upstream-fix-carry-procedure.md): drop
`2.8.26-01-562dd5a-scalcout-sval-size.p0.patch` and its row in `patch/README.md`
once the new pin contains `562dd5ad`; otherwise move the file to the new version
prefix with `git mv`. Examine the two local patches as well:
`StreamDevice-no-vxi11` fails `make patch` once the pin contains `e87e093c`,
while `StreamDevice-dbd-tab` still applies without error once the pin contains
`f473f4d6` and must then be dropped by hand. The C17 bridge for StreamDevice can
be re-examined once the pin contains `929204cb`, the fix for the errors it works
around.

## Verification

Real StreamDevice, asyn and calc sources were used throughout. Only the TCP
peer was a simulated line responder. Base 7.0.10, asyn 4.46.0 and calc were
installed copies. Builds followed the `conf.StreamDevice` recipe: `GNUmakefile`
removed, `ASYN`, `CALC`, empty `PCRE` and `EPICS_BASE` set, `CHECK_RELEASE`
off.

| Check | Result |
| :-- | :-- |
| `make patch.StreamDevice.commit.apply` then `patch.StreamDevice.commit.revert` | both exit 0; `StreamDevice-src` identical to the pin afterwards; a second revert reports the patch as unapplied |
| Applied tree compared with the patch file | identical |
| Aggregate `make patch` then `make patch.revert` on all source trees | both exit 0; 41 `Patching` lines, three of them for StreamDevice in the order carry, `no-vxi11`, `dbd-tab`; the status and diff digest of all 37 source trees equal their state before the run |
| Summary agreement for the `2.8.26` track | carry files 1, `patch/README.md` table rows 1, heading count 1; site files 0 |
| Build of the pin with both local patches | exit 0, 0 warnings |
| Build of the pin with the carry and both local patches | exit 0, 0 warnings |
| Each of the thirteen commits applied where it applies, and stacks of them, built by five reviewers | every build on the baseline, and every build with the replacing commits in place of the local patches, exited 0; the bare pin without `StreamDevice-no-vxi11` does not link |
| scalcout string read through the real IOC, device reply of 36 characters | baseline: `SVAL` holds `ABCDEFG`; with the carry: all 36 characters |
| Upstream test suite of the module on the patched tree | the tests that run here pass, except `testSpyOnLongInput`, `testTimestamp` and `testWaage`, which also fail on the baseline |
| C23 language mode as a stand-in for gcc 15, pin and `929204cb` | pin fails in the device support files; `929204cb` builds |

The `testTimestamp` test needs a Tcl package that is not installed. The
C23 result shows that `929204cb` matters only for a compiler that defaults to
that mode. Ubuntu 26.04, a supported target, uses GCC 15; for it the module
configuration rule `conf.StreamDevice` already adds `-std=gnu17` through the
C17 bridge of `configure/CONFIG_MODS_DEPS`, so the pin builds there without
`929204cb`. The bridge must stay while `929204cb` is not carried.

## Not verified

- an exit-time failure fixed by `2a3ffdd7`, which no reviewer reproduced;
- the regsub path of `f61e6404`, which needs PCRE and is not built here;
- platforms other than Linux, hardware, the CI matrix, `make check.deps`, an
  installed-tree check and a strict release-check build;
- an IOC with the production protocol files and devices.

## Completion review

Independent reviewers with fresh context ran the completion reviews of the
[carry procedure](procedures/upstream-fix-carry-procedure.md). Third-person
passes re-derived the patch content, wiring, scores, funnel, builds and runtime
claims with their own commands. Second-person passes read the changed text as a
reader without session context and ran the reader actions.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | third | 1 | 4 | 3 | the must-fix and all four minor corrected: the verify-fix procedure lists three StreamDevice files, the two local StreamDevice patches keep their own rules after a pin change, the registrar statement about `e87e093c`, the dependency row of `eb41a0dd`, this section |
| 2 | second | 0 | 2 | 3 | both minor corrected: the complete file overlap list, this section |
| 3 | third | 0 | 3 | 1 | all three minor corrected: the compiler statement and decision basis for `929204cb`, the dependency row of `eb41a0dd`, the apply statement for `f473f4d6` |
| 4 | second | 0 | 1 | 0 | the minor corrected: the apply statement for `f473f4d6` |
| 5 | third | 0 | 0 | 3 | none needed |
| 6 | second | 0 | 2 | 1 | both minor corrected: the tool named for the apply statement of the 18 commits, the consequence for `StreamDevice-dbd-tab` when `f473f4d6` is in the pin |
| 7 | second | 0 | 1 | 0 | the minor corrected: what `StreamDevice-dbd-tab` changes when `f473f4d6` is in the pin |
| 8 | second | 0 | 1 | 3 | the minor corrected: the section "At the next pin change" |

Pass 8 confirmed the correction of the minor of pass 7. Its own minor, the missing
instructions for a pin change, was corrected by adding the section above, and no
further pass was run on the corrected text.

The info items need no change: the Summary agreement formula of the procedure
has no literal form for a module with both a version-anchored glob and named
rules, and the test programs behind the runtime rows are not kept in the
repository.
