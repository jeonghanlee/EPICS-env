# sscan ce9660c carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-10-30. The Maintainer selected one upstream
commit, the fix of the temporary path buffer in the saveData permission check.
The other scored commit is not carried. The carry file is wired into aggregate
apply/revert and passes the targeted verification below. The source remains
pinned to `ce9660c`; full module and IOC acceptance remain pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md). The move of the
pin to `ce9660c` was decided earlier (D7 of the release record); this record
covers only the commits merged after it.

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, platforms other than Linux, and git publication. Release decisions
in the [release record](milestone-1.5.0.md) govern later verification.

## Source range and coverage

- Upstream: `https://github.com/epics-modules/sscan`, default branch `master`.
- Pin: `ce9660cfc05071834391225beadf7f93b776d216`. The newest release tag,
  `R2-12`, is eight commits behind it, so no release tag exists above the pin.
- Survey tip: `23448e4bdd1c863ea1966be6869160392a82cb3d`, committed 2026-10-30.
- Four commits reached `master` after the pin on 2026-10-30: two changes dated
  2026-10-29 and the two merge commits that brought them in. An earlier
  observation of 2026-10-29 found none.
- The environment builds sscan against Base 7.0.10 and sequencer 2.2.9 on
  Linux only, with `-std=gnu17` added on Ubuntu 26.04.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 4 | GitHub compare API from the pin to `master` |
| Removed as exclusively documentation, CI or tests | 0 | |
| Merge commits | 2 | `43a31807`, `23448e4b`; represented by their constituent commits |
| Deferred at the applicability gate | 0 | the target code of both commits exists at the pin |
| Scored | 2 | five independent reviewers |
| Met the rule | 1 | `b28ac30d` |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 0 | |
| Selected for carry | 1 | `b28ac30d` |

Merge commits are not one of the three removal categories of the procedure. They
are not scored because their content equals their constituents: the tree of
`43a31807` equals the tree of `f5f4c90d`, and the whole range changes exactly
the two files and the line counts of the two commits together.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`sscan-carry-1.5.0-scores.json`](sscan-carry-1.5.0-scores.json). The rule is
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
| `b28ac30d` | `checkRWpermission()` temporary path buffer enlarged from 100 to 272 bytes and loop bounds derived from it | 1 | 3 | 6 | 0 | 5 | 3 | 9 | 9 | 36 | bug |
| `f5f4c90d` | `NINT` instead of `round` in ten `npts` computations | 0 | 0 | 0 | 0 | 1 | 0 | 9 | 8 | 18 | none |

All totals are the sums of the recorded per-axis medians. The five totals of
`b28ac30d` range from 29 to 44. The two highest come from reviewers whose
inputs reached the overflow described below and who scored safety 7 and 5; the
three lowest come from reviewers who did not reach it and scored safety 1 to 3.
The other axes differ between reviewers as well.

## Dependencies and conflicts

The two commits change different files (`sscanApp/src/sscanRecord.c` and
`sscanApp/src/saveData_writeXDR.c`), so they have no file overlap, no
prerequisite and no conflict. Each applies to the pin alone and both apply
together.

## Findings on the candidates

- `b28ac30d` fixes the permission check that saveData runs when its file system
  is mounted. The pin keeps the probe path in a 100-byte buffer and appends the
  probe name `/rix_` only as far as it fits. The lengths below count the string
  that saveData passes to the check: the file system value, then a `/`, then
  each subdirectory component where one is set followed by a `/`. A directory as an operator
  counts it is one character shorter: on the operator's side the check is right
  up to 96 characters, the overflow starts at 97, and the path is cut from 99.
  For a string of up to 97 characters the check
  gives the right result, with the probe name shortened from 95 characters on.
  At 98 or 99 characters only `/` or nothing fits after the string, the check finds the directory itself, and the loop that appends `_`
  writes one byte past the buffer: AddressSanitizer aborts the pin with a stack
  buffer overflow. From 100 characters the path is cut to its first 99
  characters. If that prefix is an existing directory the same overflow occurs;
  if the cut falls inside a name the check tests another location and can
  report success for a read-only directory, as the pin does for a read-only
  directory of 183 characters while the fix returns failure. The legacy
  `saveData.c` has a similar check with a fixed 100-byte buffer; it is not built
  and was not examined.
- `f5f4c90d` replaces `round()` by the `NINT` macro that the file already
  defines, in ten `npts` computations. Five reviewers compared the macro with
  `round()` on 2 million to 20 million random inputs and found no difference;
  the two differ only at edge values such as 0.49999999999999994, which three
  reviewers noted and which the `npts` computation does not reach in practice.
  The change removes the ten `round` references from the object file, which
  matters for vxWorks only; this environment builds no vxWorks target.

## Selection

Maintainer decision, 2026-10-30: carry `b28ac30d` only.

| Order | Commit | Title | Total | Basis | Overlap |
| --: | :-- | :-- | --: | :-- | :-- |
| 1 | `b28ac30d` | saveData permission check path buffer | 36 | bug | none |

`Overlap` lists the other members of this selection that modify a file the commit
modifies; the selection has one member, so it is none.

The patch is `patch/ce9660c-01-b28ac30-checkrwpermission-tmpfile-size.p0.patch`.
It is the upstream change unmodified (four lines added, three removed in
`sscanApp/src/saveData_writeXDR.c`). It applies alone to the pin.

The apply glob is `patch/$(SRC_VER_SSCAN)-*.p0.patch` (`ce9660c`), through
`patch.sscan.commit.apply` and `patch.sscan.commit.revert`. sscan has no other
downstream patch.

`f5f4c90d` is not carried: it misses the rule and has no practical effect on Linux. The
accepted move to `ce9660c` is unchanged.

## At the next pin change

The carry glob is anchored to the pin version, so at a pin change
`patch.sscan.commit.apply` matches no file and the carry stops applying without
a message. Follow the Bump obligation of the
[carry procedure](procedures/upstream-fix-carry-procedure.md): drop
`ce9660c-01-b28ac30-checkrwpermission-tmpfile-size.p0.patch` and its row in
`patch/README.md` once the new pin contains `b28ac30d`; otherwise move the file
to the new version prefix with `git mv`.

## Verification

The function checks used the verbatim text of `fileStatus` and
`checkRWpermission` from the pin and from the patched source, built with
AddressSanitizer and run on real directories; they are not an IOC run. The
builds used the real sscan source with Base 7.0.10 and sequencer 2.2.9
installed copies, following the `conf.sscan` recipe with the release check off.

| Check | Result |
| :-- | :-- |
| `make patch.sscan.commit.apply` then `patch.sscan.commit.revert` | both exit 0; `sscan-src` identical to the pin afterwards; a second revert reports the patch as unapplied |
| Applied tree compared with the patch file | identical |
| Aggregate `make patch` then `make patch.revert` on all source trees | both exit 0; 42 `Patching` lines, one of them for sscan; the status and diff digest of all 37 source trees equal their state before the run |
| Summary agreement for the `ce9660c` track | carry files 1, `patch/README.md` table rows 1, heading count 1; site files 0 |
| Build of the pin, and of the pin with the carry | both exit 0 with 7 compiler warning lines, the same warnings in the same files (three in `saveData_writeXDR.c`, shifted by one line, and four in `scanProg.st`) |
| Both commits applied singly and together, built by five reviewers | every build exited 0 with the same warnings as the pin |
| String of 99 characters that names an existing directory | writable: pin AddressSanitizer stack buffer overflow in `strncat`, carry success; read-only: pin the same overflow, carry failure (correct) |
| String of 183 characters that names a read-only directory | pin: success when the first 99 characters cut inside a name, stack buffer overflow in `strncat` when they are an existing directory; carry: failure |
| Strings of 94 to 101 characters without the trailing `/` that name read-only directories, names of 60 characters | pin: failure (correct) up to 97, overflow at 98 and 99, success (wrong) at 100 and 101; carry: failure (correct) at every length |
| Strings of 94 to 101 characters that end with the `/` that saveData appends, and name read-only directories, names of 60 characters | pin: failure (correct) up to 97, overflow at 98 to 100, success (wrong) at 101; carry: failure (correct) at every length. With names of one character the pin overflows at every length from 98 to 101 |
| `NINT` against `round()` | no difference on 2 million to 20 million random inputs in each of five reviewers' runs; differences only at edge values such as 0.49999999999999994 |

## Not verified

- a saveData run in an IOC with a long file system path; the checks pass the string to the function directly, with and without the trailing `/` that saveData appends;
- vxWorks, Windows and other platforms, the CI matrix, `make check.deps`, an
  installed-tree check and a strict release-check build;
- the legacy `saveData.c`, which is not built.

## Completion review

Independent reviewers with fresh context ran the completion reviews of the
[carry procedure](procedures/upstream-fix-carry-procedure.md). Third-person
passes re-derived the patch content, wiring, scores, funnel, builds and
function-level claims with their own commands. Second-person passes read the
changed text as a reader without session context and ran the reader actions.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | second | 1 | 0 | 2 | the must-fix corrected: the path-length boundaries of the Findings section, measured for lengths 94 to 101 |
| 2 | third | 0 | 4 | 3 | all four minor corrected: the explanation of the five totals, the wording about `NINT` and `round()` at edge values, the dates of the commits, the expected status output of the example in the site patch procedure |
| 3 | third | 1 | 1 | 1 | the must-fix corrected: the row for lengths 94 to 101 now names the string form and a second row gives the form with the trailing `/`; the minor corrected: step 3 of the site patch procedure counts carry patches named after the pinned version; the info acted on: the record states that no release tag exists above the pin |
| 4 | second | 1 | 0 | 0 | the must-fix corrected: the record states that the lengths count the string with the trailing `/` that saveData passes and restates the thresholds on the operator's side |
| 5 | third | 0 | 2 | 1 | both minor corrected: the writability condition of the 99-character row and the directory-name length that the 100 and 101 results depend on; the info acted on: the statement about the legacy `saveData.c` |
| 6 | second | 0 | 0 | 0 | none needed |
| 7 | third | 0 | 2 | 1 | both minor corrected: the 183-character row now states where the 99-character cut falls, and the Findings text spells the string as the file system value, a `/`, then each subdirectory component with a `/` |
