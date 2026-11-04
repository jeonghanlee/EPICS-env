# pyDevSup 2.1.0 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-11-01. The Maintainer selected the two
upstream commits that met the rule: the one that stops the non-interactive
`softIocPy` from calling the deprecated `epicsThreadExitMain()`, and the one that
clears the record cache between unit test cases. The other five scored commits
are not carried. The two carry files are wired into aggregate apply/revert and
pass the targeted verification below. The source remains pinned to `2.1.0`;
full module and IOC acceptance remain pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md). The pin
`2.1.0` was set earlier by the release record (D14); this record covers only the
commits merged after it. D14 stands: its excluded head `80cdb15` is an ancestor
of the survey tip, and the three commits before it that D14 left out are scored
again here with the others.

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, platforms other than Linux, and git publication. Release decisions
in the [release record](milestone-1.5.0.md) govern later verification.

## Source range and coverage

- Upstream: `https://github.com/epics-modules/pyDevSup`, default branch `master`.
- Pin: `tags/2.1.0`, commit `b5cef38a6d9f74f9c59f967185ba6d1940637c03`,
  committed 2026-10-05. `2.1.0` is the newest release tag, so no release tag
  exists above the pin.
- Survey tip: `a38e7b57c182300ef620d224c37395f63eb8a61a`, committed 2026-10-27.
- Fourteen commits are above the pin. The range changes 24 files: the CI
  files and `CHANGELOG.md`; the Python modules `ptable.py`, `db.py` and
  `disect.py`, the C file `dbfield.c` and `devsupMain.cpp` of the installed
  package and program; the unit tests; and the example applications
  (`archApp`, `logApp`, `iocBoot`).
- What the module installs here: the `_dbapi` loadable library, the Python package
  `devsup`, the `pyDevSup` library and the `softIocPy` program, and the `.py` and
  `.db` files of the example applications.
- The environment builds pyDevSup against Base 7.0.10 and the distribution
  Python 3 with numpy on Linux only. No downstream patch is applied to pyDevSup
  before this carry.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 14 | `git log --reverse tags/2.1.0..origin/master` of a clone |
| Removed as exclusively documentation, CI or tests | 3 | `6a9a24d`: `CHANGELOG.md` only; `c91d0fb`, `5da5bb1`: CI configuration only |
| Merge commits | 4 | `80cdb15`, `f8332ec`, `875556d`, `a38e7b5`; represented by their constituent commits |
| Deferred at the applicability gate | 0 | the target code of all seven scored commits exists at the pin |
| Scored | 7 | five independent reviewers |
| Met the rule | 2 | `e3f5ae3`, `f0ad79d` |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 0 | |
| Selected for carry | 2 | `f0ad79d`, `e3f5ae3` |

`f0ad79d` is not a test-only commit: besides the harness and the tests it changes
the text of the `AttributeError` that `Record.__getattr__` raises, in the installed
`db.py`. It was judged from its diff and kept in the scored set. Merge commits are
not one of the three removal categories of the procedure; they are not scored
because their content equals their constituents.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`pyDevSup-carry-1.5.0-scores.json`](pyDevSup-carry-1.5.0-scores.json). The rule is
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
| `e3f5ae3` | non-interactive `softIocPy` sleeps in a loop instead of calling the deprecated `epicsThreadExitMain()` | 0 | 4 | 6 | 0 | 5 | 4 | 9 | 8 | 36 | bug |
| `f0ad79d` | unit test harness clears the record cache on teardown; missing-field error names the field; adds tests | 0 | 5 | 5 | 0 | 2 | 2 | 8 | 8 | 30 | bug, safety |
| `fcd5b60` | Python 3 port of `bplreport.py`, `disect.py` cleanup, Windows `.bat` files, installs `bplstorage.db` | 0 | 0 | 4 | 0 | 2 | 1 | 8 | 9 | 24 | none |
| `ba45c0a` | archiver example: two Python 3 runtime errors and the `ai` input links | 0 | 0 | 4 | 0 | 2 | 1 | 7 | 9 | 23 | none |
| `5a941d0` | Python 3 fixes in the FPM and caputlog examples and `inotifyy.py`; new `softIocPy3.6` shebang | 0 | 0 | 3 | 0 | 1 | 1 | 8 | 9 | 22 | none |
| `b34594b` | assignment in a condition of `pyField_putval` rewritten, `prset` initialised | 0 | 1 | 0 | 0 | 1 | 0 | 10 | 7 | 19 | none |
| `5d2130e` | `devsup.ptable` alarm status and message (`Parameter.stat`, `Parameter.amsg`) | 0 | 0 | 3 | 0 | 4 | 1 | 5 | 4 | 17 | none |

All totals are the sums of the recorded per-axis medians. The five totals of
`e3f5ae3` range from 21 to 46, of `f0ad79d` from 26 to 34, of `fcd5b60` from 22 to 24,
of `ba45c0a` from 21 to 25, of `5a941d0` from 21 to 24, of `b34594b` from 19 to 21 and
of `5d2130e` from 14 to 20. The lowest total of `e3f5ae3` comes from the one
reviewer who saw the program stay alive and scored the change as the removal of
a deprecation warning; the other four ran the pin and saw the error output
described below. Neither commit that meets the rule reaches the 40 of the first
condition: `e3f5ae3` meets it on `bug` (6), `f0ad79d` on `bug` (5) and `saf` (5).

## Dependencies and conflicts

- `fcd5b60` and `ba45c0a` both change `archApp/bplreport.py`. `ba45c0a` applies at an
  offset of -3 on the pin, but the installed `bplreport.py` remains Python 2
  syntax without `fcd5b60`, so `ba45c0a` needs `fcd5b60` to be usable (a
  functional prerequisite, found by all five reviewers).
- `f0ad79d` and `5d2130e` both change the unit test file `test_db.py`; both
  orders apply; `5d2130e` after `f0ad79d` applies at an offset of 98 lines in its
  first `test_db.py` hunk, and in the other order no hunk has an offset. Without `f0ad79d` the
  tests that reuse a record name segfault, so `f0ad79d` is a soft prerequisite
  of any later test that reuses a name.
- `e3f5ae3` and `b34594b` come from one upstream pull request and change
  different files.
- The selection holds `f0ad79d` and `e3f5ae3`. They change disjoint files, so no
  apply order has to be fixed beyond the upstream merge order, which the file
  names keep.

## Findings on the candidates

- `e3f5ae3` replaces `epicsThreadExitMain()` in the non-interactive branch of
  `pyIocApp/devsupMain.cpp` with a loop of `epicsThreadSleep(1000.0)`, the form
  that Base `softMain.cpp` uses. On Base 7.0.10 the call at the pin ends in
  `cantProceed`: `softIocPy -S` prints `epicsThreadExitMain() must no longer be
  used`, a `CRITICAL ERROR` line and a stack trace at every non-interactive start,
  and the main thread is suspended; the IOC keeps serving Channel Access. With
  the change the program starts without the message. Four reviewers ran this
  on the pin and on the change; the fifth saw the program alive in both and
  scored it as the removal of a compiler warning. The interactive `iocsh` path is not
  touched.
- `f0ad79d` adds `_db._rec_cache.clear()` to the teardown of the test harness
  `IOCHelper` and changes `from ..db import getRecord` to `from .. import db as
  _db` in `devsup/test/util.py`. Without it a test case that reuses a record name
  of an earlier test case holds a dangling record pointer from the previous IOC
  and the interpreter segfaults (exit 139). All five reviewers reproduced the
  segfault on the pin with the new tests and the pass with the change. Running
  IOCs are not affected. The same commit adds the field name to the
  `AttributeError` text in `db.py` and 5 unit tests (11 tests become 16 in the
  shipped suite). One reviewer noted that the change removes the module-level
  import of `getRecord` from `devsup.test.util`, so site test code that imported
  it from there (it is not in the module's `__all__`) would fail with
  `ImportError`.
- `5d2130e` changes what existing `devsup.ptable` users observe, and is a
  feature rather than a fix. Output ("set") records now receive the table alarm,
  status and message after the actions run, where the pin leaves them at no alarm;
  assigning `None` to a parameter no longer sets its `alarm` to `INVALID_ALARM`
  (a record that reads `None` is still `INVALID`/`UDF`); and `stat` and `amsg`
  are not cleared when the alarm clears, so a later alarm re-emits the old
  status and message. The four tests it adds call `Record.setSevr` on plain
  records and never go through `ptable`. Four of five reviewers judged that
  site code written against 2.1.0 could change behaviour.
- `fcd5b60`, `ba45c0a` and `5a941d0` change example applications. The installed
  `bplreport.py` is a Python 3 syntax error at the pin; `ba45c0a` fixes two
  Python 3 runtime errors there (`str.translate(None, ...)` and bytes assigned to
  a `stringin` value). `5a941d0` rewrites two shebangs to a fixed
  `softIocPy3.6`, a binary this environment does not build (all five reviewers
  reported it).
- `b34594b` rewrites one conditional; the control flow is identical.
- Consumers: no module of this environment links or imports pyDevSup. The
  `feedioc` program of feed-core would link it, and the `feed-core-libonly` patch
  removes `feedApp` from the build. No `build.pyDevSup` appears in any
  dependency line of either repository, and no installed library of the 1.3.0
  tree needs `libpyDevSup`. The changed C sources are those of the pyDevSup
  library and `softIocPy` only, and no header is installed or changed.

## Selection

Maintainer decision, 2026-11-01: carry `f0ad79d` and `e3f5ae3`.

| Order | Commit | Title | Total | Basis | Overlap |
| --: | :-- | :-- | --: | :-- | :-- |
| 1 | `f0ad79d` | unit test record cache cleared between cases | 30 | bug, safety | none |
| 2 | `e3f5ae3` | non-interactive `softIocPy` main sleeps in a loop | 36 | bug | none |

`Overlap` lists the other members of this selection that modify a file the commit
modifies; the two members change disjoint files.

The patches are `patch/2.1.0-01-f0ad79d-test-record-cache-clear.p0.patch` and
`patch/2.1.0-02-e3f5ae3-non-interactive-main-sleep.p0.patch`. Both carry the
whole upstream commit, generated with `git diff --no-prefix` from the upstream
history; `f0ad79d` includes its unit test hunks, so the shipped test suite
exercises the fix. Both apply singly to the pin.

The apply glob is `patch/$(SRC_VER_PYDEVSUP)-*.p0.patch` (`2.1.0`), through
`patch.pyDevSup.commit.apply` and `patch.pyDevSup.commit.revert`. pyDevSup has no
other downstream patch.

The five other scored commits are not carried: they miss the rule, and `5d2130e`
changes behaviour that existing users may rely on. The pin `2.1.0` is unchanged.

## At the next pin change

The carry glob is anchored to the pin version, so at a pin change
`patch.pyDevSup.commit.apply` matches no file and the carry stops applying
without a message. Follow the Bump obligation of the
[carry procedure](procedures/upstream-fix-carry-procedure.md), from the
repository root, once the new pyDevSup source is prepared:

1. Start from the new source as prepared, without the carry applied:
   `git -C pyDevSup-src status --short` must print nothing. If it lists the
   four files of the carry, restore them with
   `git -C pyDevSup-src checkout -- devsupApp/src/devsup/db.py devsupApp/src/devsup/test/test_db.py devsupApp/src/devsup/test/util.py pyIocApp/devsupMain.cpp`.
   Do not run `make patch.pyDevSup.commit.revert` for this: with the new pin set
   in `configure/RELEASE` it matches no file and does nothing, and with the old
   version on the command line, on a source that contains a fix upstream, it
   would remove the upstream change. Then test, for
   each patch separately, whether the new source contains the fix. An ancestor
   test (`git -C pyDevSup-src merge-base --is-ancestor f0ad79d <new pin>`, and the
   same for `e3f5ae3`) exits 0 when contained; exit 1, or an error such as exit 128
   for an unknown name, is not conclusive, because after a squash or rebase
   upstream the name may no longer exist. Read the source instead:
   - `f0ad79d` is contained when `grep -n '_rec_cache.clear' pyDevSup-src/devsupApp/src/devsup/test/util.py`
     prints a line in the harness teardown, next to `testdbCleanup`;
   - `e3f5ae3` is contained when
     `grep -n 'epicsThreadExitMain' pyDevSup-src/pyIocApp/devsupMain.cpp` prints
     nothing and the non-interactive branch loops on `epicsThreadSleep`.

   The command `patch -f -d pyDevSup-src -p0 --dry-run -R < patch/<file>` exits 0
   when the change is there, but its exit 1 only means that the patch does not
   fit; decide by the `grep`.
2. If both are contained, the track retires. Confirm that the glob matches
   nothing by running `make patch.pyDevSup.commit.apply SRC_VER_PYDEVSUP=<new>`
   and `make patch.pyDevSup.commit.revert SRC_VER_PYDEVSUP=<new>`; both must exit
   0 without a `Patching` or `Reverting` line.
3. Drop the two files `patch/2.1.0-01-f0ad79d-test-record-cache-clear.p0.patch`
   and `patch/2.1.0-02-e3f5ae3-non-interactive-main-sleep.p0.patch`; in
   `patch/README.md` the section "pyDevSup 2.1.0 carry (2)" and the family table
   row "Carry patch, pyDevSup"; and in `docs/src/concepts/upstream-patch-carry.md`
   the clause ", two pyDevSup carry patches for `2.1.0`" of the sentence that
   counts the carry patches, and the example value `2.1.0` in the list of
   placeholders if it names no remaining pin. The rules, their macros, their
   entries in `configure/RULES_SRC` and the lists that name them (the kind and
   glob tables, the apply order, `make-targets.md`, the two lists of
   `module-bump-procedure.md` and the list of
   `upstream-fix-verification-procedure.md`) stay, as for the retired pvxs track.
4. Re-count with all source trees prepared: `make patch | grep -c '^Patching'`
   and `make patch.revert | grep -c '^Reverting'` give the same number, two less
   than before when the other pins are unchanged (45 becomes 43). Set it where
   the count is stated: `docs/src/procedures/build-and-install.md` ("Linux, 45
   lines for the pins of this release") and the release record of that bump.
5. Check that `ls patch/2.1.0-*.p0.patch` lists nothing and that
   ``grep -c '^| `2.1.0-' patch/README.md`` prints 0.
6. Record the retirement ("dropped as contained upstream") in the decision
   record of the release that moves the pin, as the Record discipline of the
   carry procedure requires; this record moves to `docs/archive/` in the
   reconciliation after that release.

If only one patch is contained, drop that patch and keep the other under the
steps for a patch that stays; the number `NN` of the remaining file is not
renumbered. For the dropped patch apply step 3 to its file and its row only,
and change the counts that the remaining text states: "(2)" to "(1)" in the
heading of the section in `patch/README.md`, the cell "two post-release commits
carried" of the family row, the sentence "Both patches carry the whole upstream
commit, including the unit tests of `f0ad79d`" (rewrite it for the one patch
that stays, and drop the clause on the unit tests when `f0ad79d` is the dropped
patch), and "two pyDevSup carry patches" to "one pyDevSup carry patch" in
`docs/src/concepts/upstream-patch-carry.md`; the aggregate count of `Patching`
lines drops by one, and is set where step 4 names it (`docs/src/procedures/build-and-install.md`
and the release record of that bump). If neither is contained, both stay. Set `SRC_TAG_PYDEVSUP` and
`SRC_VER_PYDEVSUP` in `configure/RELEASE` to the new pin first
(`module-bump-procedure.md`); the steps below rely on that. Then:

- move each remaining file to the new version prefix with `git mv`; in
  `patch/README.md` change the file names in its rows, the version in the
  heading of the section and in the first sentence of its body, the count in the
  heading, and the pin in the family table row "Carry patch, pyDevSup"; in
  `docs/src/concepts/upstream-patch-carry.md` change the pin in the sentence that
  counts the carry patches and in the example value of the placeholders;
- run `make patch.pyDevSup.commit.apply` and `make patch.pyDevSup.commit.revert`
  on the new source: each must exit 0 and print one `Patching` or `Reverting`
  line for each remaining file, and the aggregate count of `Patching` lines drops
  by the number of dropped files (45 when both stay). Read the `patch` output: an
  offset of a few lines is fine; "with fuzz" means that the surrounding lines
  differ, and a failed hunk leaves a `.rej` file in `pyDevSup-src` that `git status`
  in the repository root does not show (`git -C pyDevSup-src status` does). Move
  any `.rej` or `.orig` file aside with `mv`
  (`find pyDevSup-src -name '*.rej' -o -name '*.orig'` must print nothing) before the
  next run;
- if the apply fails or reports fuzz, regenerate the patch. Start from a clean
  source: restore the files as in step 1, and `git -C pyDevSup-src status --short`
  must print nothing. Take the upstream change as a diff
  (`git -C <upstream clone> diff --no-prefix <sha>^ <sha>`), apply it to the clean
  source with `patch -d pyDevSup-src -p0`, and resolve the rejected hunks by hand against the new
  source. The change must not be there yet; if it is, step 1 was wrong and the fix
  is contained. Write
  `git -C pyDevSup-src diff --no-prefix -- <the files of that commit>` to the patch
  file of the new prefix (same name otherwise), restore the source as in step 1,
  then run the apply and revert check above again;
- record the outcome ("carried forward" or "re-based") in the decision record of
  the release that moves the pin, as in step 6.

## Verification

The builds used the real pyDevSup source with Base 7.0.10 and Python 3.13 with
numpy on Debian 13 (gcc 14), following the `conf.pyDevSup` recipe with the
install location redirected. To repeat them:

1. Make one copy of the pin and one of the pin with the carry from the tracked
   files of `pyDevSup-src`, running inside that directory:
   `git ls-files -z | tar --null -T - -cf - | tar -x -C <copy>`.
   Take the carry copy after `make patch.pyDevSup.commit.apply`, then run
   `make patch.pyDevSup.commit.revert`.
2. In each copy write `configure/RELEASE.local` with
   `EPICS_BASE:=<1.3.0 install>/base`, where `<1.3.0 install>` is the installed tree of release 1.3.0 for the host, `<install-root>/1.3.0/<os>/7.0.10`, the directory that holds `base/` and `modules/`; and write `configure/CONFIG_SITE.local` with
   `INSTALL_LOCATION:=<copy>/install` and `PYTHON:=python3` followed by the output
   of `python3 makehelper.py` run from the top of the copy, as `conf.pyDevSup`
   does. Run `make`; it takes about a minute.
3. Run the shipped tests with `PYTHONPATH=<copy>/install/python3.13/linux-x86_64`
   and `python3 -m nose2 -v devsup`. The reviewers found that the upstream
   target `make nose` fails with `ModuleNotFoundError` when the install location is
   redirected, which is why the same `nose2` command runs on the install.
4. Start the program: with `EPICS_CA_SERVER_PORT` set to an unused port and the
   address list on `127.0.0.1`, run
   `<copy>/install/bin/linux-x86_64/softIocPy3.13 -S -d <db file>` with a database
   of one `ai` record for eight seconds, and read the PV with `caget` after three.

| Check | Result |
| :-- | :-- |
| `make patch.pyDevSup.commit.apply` | exit 0; two `Patching` lines, four files changed in `pyDevSup-src`; the sorted diff lines of the applied tree equal those of the two patch files |
| `make patch.pyDevSup.commit.revert`, then a second revert | the first exits 0 and `pyDevSup-src` has no change; the second reports both patches as unapplied and exits 0 |
| Pin copy compared with the carry copy | exactly four files differ: `db.py`, `test_db.py`, `util.py`, `devsupMain.cpp` |
| Aggregate `make patch` then `make patch.revert` on all source trees | both exit 0; 45 `Patching` lines, two of them for pyDevSup; the status and diff digest of all 37 source trees equal their state before the run |
| Summary agreement for the `2.1.0` track | carry files 2, `patch/README.md` table rows 2, heading count 2; site files 0 |
| Build of the pin and of the pin with the carry | both exit 0; the lines that contain `warning` are 8 for the pin and 7 for the carry, and the one that differs is the `epicsThreadExitMain()` deprecation in `devsupMain.cpp` |
| Shipped tests on the pin | 11 tests, OK |
| Shipped tests on the pin with the carry | 16 tests, OK |
| New tests (`test_db.py` of the carry) on the pin's `util.py` | segmentation fault, exit 139, in `test_aao_float` |
| `softIocPy3.13 -S` with one `ai` record, pin | `caget` returns the value 1; the log has 12 lines and 3 of them contain `CRITICAL` or `epicsThreadExitMain` |
| `softIocPy3.13 -S` with one `ai` record, pin with the carry | `caget` returns the value 1; the log has 2 lines and none contains `CRITICAL` or `epicsThreadExitMain` |
| Both patches and the other five commits applied and built by five reviewers | every apply check and build exited 0 (`ba45c0a` applies at an offset of -3); the shipped tests passed on the pin (11), with `5d2130e` (15), with `f0ad79d` (16) and with all seven (20); each reproduced the exit 139 of the new tests without `f0ad79d`, and four saw the error output of `softIocPy -S` at the pin |

## Not verified

- an IOC with real site device support that uses `devsup.ptable`; the carry does
  not change `ptable`;
- the interactive `iocsh` path of `softIocPy`, which the change does not touch
  (read, not run);
- Python versions other than 3.13, and Base versions other than 7.0.10; Rocky
  Linux 8 and 10, Ubuntu 24.04 and 26.04 (GCC 15) and Debian 12, the CI matrix,
  `make check.deps` and an installed-tree check;
- the five commits that are not carried, beyond the reviewers' builds and tests.

## Completion review

Independent reviewers with fresh context ran the completion reviews of the
[carry procedure](procedures/upstream-fix-carry-procedure.md), with the briefs
and the safeguards of the ADCore record. Third-person passes re-derived the patch
content, wiring, scores, funnel, builds, tests and the steps for the next pin
change with their own commands. Second-person passes read the changed text as a
reader without session context and ran the reader actions.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | third | 0 | 1 | 3 | the minor corrected: the ADCore record still stated the earlier count of `Patching` lines in three places of its steps for the next pin change (now 45 and 44); the info acted on: the offset of `5d2130e` after `f0ad79d` applies to one order only |
| 2 | second | 0 | 1 | 4 | the minor corrected: the case of one contained patch lists the counts that change in the summary, the family row and the concept page; the info acted on: the directory of the copy command, the install tree named in the recipe, the working directory of the regeneration, and the revert warning that holds only with the old version on the command line |
| 3 | second | 0 | 0 | 2 | converged; the info acted on: the places where the changed count is set when one patch is dropped; the completion review is this section |
| 4 | third | 0 | 0 | 3 | converged; the full aggregate `make patch` and `make patch.revert`, both builds, the tests, the non-interactive start and the steps for the next pin change run in scratch copies all matched; the info acted on: a doubled comma, the singular of "carry patch" and the sentence of the summary section in the case of one dropped patch, and the cause of the `ImportError` note |
