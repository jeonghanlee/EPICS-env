# ADCore ee039d2 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-10-31. The Maintainer selected one upstream
commit, the fix that clears the soft trigger busy record when a circular buffer
acquisition completes. The other two scored commits are not carried. The carry
file is wired into aggregate apply/revert and passes the targeted verification
below. The source remains pinned to `ee039d2`; full module and IOC acceptance
remain pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md). The pin
`ee039d2` was set earlier by the release record; this record covers only the
commits merged after it.

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, platforms other than Linux, and git publication. Release decisions
in the [release record](milestone-1.5.0.md) govern later verification.

## Source range and coverage

- Upstream: `https://github.com/areaDetector/ADCore`, default branch `master`.
- Pin: `ee039d24c9e89e70b31fd383b4817a40db5d6395`. The newest release tag,
  `R3-14`, is an ancestor of the pin and 185 commits behind it, so no release
  tag exists above the pin.
- Survey tip: `36840e14b683079a8eb8423278eef41f371b1914`, committed 2026-10-13.
- Ten commits are above the pin. The range changes five files: two CI files,
  `ADApp/pluginSrc/NDFileHDF5.cpp`, `ADApp/pluginSrc/NDPluginCircularBuff.cpp`
  and `ADApp/pluginTests/test_NDPluginCircularBuff.cpp`.
- The environment builds ADCore against Base 7.0.10, asyn 4.46.0 and pvxs on
  Linux only. No downstream patch is applied to ADCore before this carry.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 10 | GitHub compare API from the pin to `master` |
| Removed as exclusively documentation, CI or tests | 3 | `14bc403`, `637f9ef`, `41291f1`: CI configuration only |
| Merge commits | 4 | `71adf1e`, `1be9fde`, `f7620d6`, `36840e1`; represented by their constituent commits |
| Deferred at the applicability gate | 0 | the target code of all three scored commits exists at the pin |
| Scored | 3 | five independent reviewers |
| Met the rule | 1 | `ede4c22` |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 0 | |
| Selected for carry | 1 | `ede4c22` |

Merge commits are not one of the three removal categories of the procedure. They
are not scored because their content equals their constituents: the whole range
changes exactly the five files above, and the line counts of the three scored
commits and the three CI commits account for them.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`ADCore-carry-1.5.0-scores.json`](ADCore-carry-1.5.0-scores.json). The rule is
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
| `ede4c22` | circular buffer plugin sets the soft trigger parameter to 0 when the last acquisition completes; adds a unit test | 0 | 1 | 8 | 0 | 7 | 5 | 9 | 8 | 38 | bug, urgency |
| `3f07467` | HDF5 file plugin error message names the attribute that could not be read | 0 | 0 | 1 | 0 | 2 | 1 | 9 | 9 | 22 | none |
| `9cadb7f` | `#include <epicsTime.h>` before `epicsMath.h` in the circular buffer plugin, for a Windows compile error | 0 | 0 | 0 | 0 | 0 | 0 | 10 | 10 | 20 | none |

All totals are the sums of the recorded per-axis medians. The five totals of
`ede4c22` range from 35 to 38, of `3f07467` from 21 to 24 and of `9cadb7f` from
19 to 20. The commit that meets the rule meets it on `bug` (8) and `urgency` (5);
its total of 38 stays under the 40 of the first condition.

## Dependencies and conflicts

`ede4c22` and `9cadb7f` both change `ADApp/pluginSrc/NDPluginCircularBuff.cpp`,
in hunks that start at line 190 and line 12 of the pin, so they have a file overlap and no
prerequisite and no conflict: the five reviewers applied them singly and
together and found the hunks independent, and applying them in either order
gives the same tree. `3f07467` changes `ADApp/pluginSrc/NDFileHDF5.cpp` only.
The selection holds one commit, so no apply order has to be fixed.

## Findings on the candidates

- `ede4c22` adds `setIntegerParam(NDCircBuffSoftTrigger, 0)` in the branch of
  `NDPluginCircularBuff::processCallbacks` that ends an acquisition ("Acquisition
  Completed"). Without it the soft trigger parameter stays 1 after the last
  post-trigger frame, so the busy record that shows it stays set. The branch
  that continues with more triggers already cleared it. All five reviewers ran
  the unit test that the commit adds: on the pin with only the new test file the
  case `test_SoftTriggerClearedAfterAcquisition` fails (`softTrigger` is 1, not
  0), and with the source line it passes together with the three existing
  circular buffer cases. No reviewer found a defect in the change. One reviewer
  noted that the test depends on synchronous `cbProcess` calls and passed
  deterministically in its runs.
- `3f07467` appends the attribute name to one error message in
  `NDFileHDF5.cpp`. The format string and the argument count match. All five reviewers
  read the error path and did not run it. The change has no effect when the
  path is not taken.
- `9cadb7f` adds a Windows-only include workaround. On Linux the header
  `NDPluginDriver.h` already includes `epicsTime.h`, and the Linux object differs
  from the pin only in `__LINE__` constants.
- Consumers: `ADSimDetector` and `ADVimba` load the plugins through their
  startup scripts, and the no-IOC example of `ADSimDetector` compiles against
  the `NDFileHDF5` header; `ADGenICam` is a library with no IOC and no startup
  script. None of them compiles the changed plugin sources, and none of the
  three commits changes a header, an ABI or a database file.

## Selection

Maintainer decision, 2026-10-31: carry `ede4c22` only.

| Order | Commit | Title | Total | Basis | Overlap |
| --: | :-- | :-- | --: | :-- | :-- |
| 1 | `ede4c22` | circular buffer soft trigger cleared at the end of an acquisition | 38 | bug, urgency | none |

`Overlap` lists the other members of this selection that modify a file the commit
modifies; the selection has one member, so it is none.

The patch is `patch/ee039d2-01-ede4c22-circularbuff-softtrigger-clear.p0.patch`.
It is curated: it carries the one added source line in
`ADApp/pluginSrc/NDPluginCircularBuff.cpp` and leaves out the 30-line unit test
hunk in `ADApp/pluginTests/test_NDPluginCircularBuff.cpp` that the upstream
commit also contains. The omitted hunk is test code; the environment does not
run the module tests. It applies alone to the pin.

The apply glob is `patch/$(SRC_VER_ADCORE)-*.p0.patch` (`ee039d2`), through
`patch.ADCore.commit.apply` and `patch.ADCore.commit.revert`. ADCore has no
other downstream patch.

`3f07467` and `9cadb7f` are not carried: they miss the rule, and the second has
no effect on Linux. The pin of `ee039d2` is unchanged.

## At the next pin change

The carry glob is anchored to the pin version, so at a pin change
`patch.ADCore.commit.apply` matches no file and the carry stops applying without
a message. Follow the Bump obligation of the
[carry procedure](procedures/upstream-fix-carry-procedure.md), from the
repository root, once the new ADCore source is prepared:

1. Start from the new source as prepared, without the carry applied:
   `git -C ADCore-src status --short` must print nothing. If it lists
   ` M ADApp/pluginSrc/NDPluginCircularBuff.cpp`, restore the file with
   `git -C ADCore-src checkout -- ADApp/pluginSrc/NDPluginCircularBuff.cpp`. Do
   not run `make patch.ADCore.commit.revert` for this: on a source that contains
   the fix upstream it removes the upstream line. Then test whether the new
   source contains the fix:
   `git -C ADCore-src merge-base --is-ancestor ede4c22 <new pin>` (exit 0 means
   contained; exit 1, or an error such as exit 128 for an unknown name, is not
   conclusive, because after a squash or rebase upstream the name may no longer
   exist or may still name the old object). Read the
   source instead:
   `grep -n -B3 -A3 NDCircBuffSoftTrigger ADCore-src/ADApp/pluginSrc/NDPluginCircularBuff.cpp`.
   The fix is present when `setIntegerParam(NDCircBuffSoftTrigger, 0);` stands in
   the `else` branch that sets the status "Acquisition Completed". The command
   `patch -f -d ADCore-src -p0 --dry-run -R < patch/ee039d2-01-ede4c22-circularbuff-softtrigger-clear.p0.patch`
   exits 0 when the line is there, but its exit 1 only means that the patch does
   not fit: the line is absent, or its surrounding lines differ. Decide by the
   `grep`.
2. If it is contained, the track retires. Confirm that the glob matches
   nothing by running `make patch.ADCore.commit.apply SRC_VER_ADCORE=<new>` and
   `make patch.ADCore.commit.revert SRC_VER_ADCORE=<new>`; both must exit 0
   without a `Patching` or `Reverting` line.
3. Drop `patch/ee039d2-01-ede4c22-circularbuff-softtrigger-clear.p0.patch`; in
   `patch/README.md` the section "ADCore ee039d2 carry (1)" and the family
   table row "Carry patch, ADCore"; and in `docs/src/concepts/upstream-patch-carry.md`
   the clause ", one ADCore carry patch for `ee039d2`" of the sentence that
   counts the carry patches, and the example value `ee039d2` in the list of
   placeholders if it names no remaining pin. The rules, their
   macros, their entries in `configure/RULES_SRC` and the lists that name
   them (the kind and glob tables, the apply order, `make-targets.md`, the two
   lists of `module-bump-procedure.md` and the list of
   `upstream-fix-verification-procedure.md`) stay, as for the retired pvxs track.
4. Re-count with all source trees prepared: `make patch | grep -c '^Patching'`
   and `make patch.revert | grep -c '^Reverting'` give the same number, one less
   than before when the other pins are unchanged (45 becomes 44). Set it where
   the count is stated: `docs/src/procedures/build-and-install.md` ("Linux, 45
   lines for the pins of this release") and the release record of that bump.
5. Check that `ls patch/ee039d2-*.p0.patch` lists nothing and that
   ``grep -c '^| `ee039d2-' patch/README.md`` prints 0.
6. Record the retirement ("dropped as contained upstream") in the decision
   record of the release that moves the pin, as the Record discipline of the
   carry procedure requires; this record moves to `docs/archive/` in the
   reconciliation after that release.

If the new source does not contain the fix, the track stays. Set
`SRC_TAG_ADCORE` and `SRC_VER_ADCORE` in `configure/RELEASE` to the new pin first
(`module-bump-procedure.md`); the steps below rely on that. Then:

- move the file to the new version prefix with `git mv`; in `patch/README.md`
  change the file name in its row, the version in the heading of the section and
  in the first sentence of its body, and the pin in the family table row "Carry
  patch, ADCore"; in `docs/src/concepts/upstream-patch-carry.md` change the pin
  in the sentence that counts the carry patches and in the example value of the
  placeholders;
- run `make patch.ADCore.commit.apply` and `make patch.ADCore.commit.revert` on
  the new source: each must exit 0 and print one `Patching` or `Reverting`
  line, and the aggregate count of `Patching` lines stays as before (45). Read the `patch` output: an offset
  of a few lines is fine; "with fuzz" means that the surrounding lines differ, and
  a failed hunk leaves `ADCore-src/ADApp/pluginSrc/NDPluginCircularBuff.cpp.rej`,
  which `git status` in the repository root does not show (`git -C ADCore-src status`
  does). Move any `.rej` or `.orig` file aside with
  `mv` (`find ADCore-src -name '*.rej' -o -name '*.orig'` must print nothing)
  before the next run;
- if the apply fails or reports fuzz, regenerate the patch. Start from a clean
  source: run `git -C ADCore-src checkout -- ADApp/pluginSrc/NDPluginCircularBuff.cpp`,
  and `git -C ADCore-src status --short` must print nothing. Then, in `ADCore-src`,
  put `setIntegerParam(NDCircBuffSoftTrigger, 0);` first in the `else` branch that
  sets "Acquisition Completed" (the line must not be there yet; if it is, step 1
  was wrong and the fix is contained), write
  `git -C ADCore-src diff --no-prefix -- ADApp/pluginSrc/NDPluginCircularBuff.cpp`
  to the patch file of the new prefix (same name otherwise), restore the source
  with `git -C ADCore-src checkout -- ADApp/pluginSrc/NDPluginCircularBuff.cpp`,
  then run the apply and revert check above again;
- record the outcome ("carried forward" or "re-based") in the decision record of
  the release that moves the pin, as in step 6.

## Verification

The builds used the real ADCore source with Base 7.0.10, asyn 4.46.0 and the
pvxs 1.5.2 copy of the `1.3.0` install; the release pin is pvxs 1.5.3, which
these builds did not use. They follow the `conf.ADCore` recipe with the release
check off. The host (Debian 13, gcc 14.2) has Boost test headers but no Boost
test library, and has the HDF5 headers under `/usr/include/hdf5/serial`. To
repeat the build and the unit test run on such a host:

1. Build a Boost test library from the headers: for each
   `/usr/include/boost/test/impl/<name>.ipp` except `test_main.ipp`, write a
   source `<name>.cpp` that holds `#define BOOST_TEST_SOURCE`, then
   `#define BOOST_TEST_DYN_LINK`, then `#include <boost/test/impl/<name>.ipp>`,
   and run `g++ -O1 -fPIC -shared -o libboost_unit_test_framework.so *.cpp` in
   that directory (20 sources, about 10 seconds).
2. Make one copy of the pin for each build (the pin, and the pin with the
   carry). In each copy replace `ADApp/pluginTests/test_NDPluginCircularBuff.cpp`
   by the file of `ede4c22` (`gh api "repos/areaDetector/ADCore/contents/ADApp/pluginTests/test_NDPluginCircularBuff.cpp?ref=ede4c22" -H "Accept: application/vnd.github.raw"`),
   and give each copy its own `INSTALL_LOCATION:=<copy>/install` outside the
   production install tree. The target `conf.ADCore` in `configure/RULES_MODS_CONFIG`
   would write the paths of the 1.5.0 install, so write the two files by hand
   with its other lines:
   `configure/RELEASE.local` holds `EPICS_BASE:=`, `ASYN:=` and `PVXS:=` with
   the paths `<1.3.0 install>/base`, `<1.3.0 install>/modules/asyn-4.46.0` and
   `<1.3.0 install>/modules/pvxs-1.5.2` (the 1.3.0 install of this host is
   `~/alsu-epics/1.3.0/debian-13/7.0.10`). In `configure/CONFIG_SITE.local` the
   HDF5 and libxml2 flags come from `pkg-config` as in `conf.ADCore`; where
   they are not set, add `HDF5_INCLUDE = /usr/include/hdf5/serial` and
   `HDF5_LIB = /usr/lib/x86_64-linux-gnu/hdf5/serial`. Also add `WITH_BOOST = YES`
   and `USR_LDFLAGS += -L<library directory> -Wl,-rpath,<library directory>`.
   For the carry copy, apply the patch file with `patch -p0` from the source root
   first. Run `make -j4` in each copy.
3. Run `./plugin-test --run_test=CircularBuffTests --log_level=test_suite` in
   `<copy>/install/bin/linux-x86_64` of each copy. The exit status below is the
   status of that command.

Neither the library nor the changed test file alters ADCore code.

| Check | Result |
| :-- | :-- |
| `make patch.ADCore.commit.apply` then `patch.ADCore.commit.revert` | the patch applies; `ADCore-src` has no change afterwards; a second revert reports the patch as unapplied |
| Applied tree compared with the pin | exactly one added line, `setIntegerParam(NDCircBuffSoftTrigger, 0);` |
| Aggregate `make patch` then `make patch.revert` on all source trees | both exit 0; 43 `Patching` lines (before the pyDevSup carry added two), one of them for ADCore; the status and diff digest of all 37 source trees equal their state before the run |
| Summary agreement for the `ee039d2` track | carry files 1, `patch/README.md` table rows 1, heading count 1; site files 0 |
| Build of the pin and of the pin with the carry, each with the upstream test file | both exit 0 with no compiler warning line; the only line that contains `warning` is the release-consistency notice that `CHECK_RELEASE = NO` prints |
| Unit test `CircularBuffTests` on the pin with the upstream test file | `test_SoftTriggerClearedAfterAcquisition` fails: `check softTrigger == 0 has failed [1 != 0]`, exit status 201 |
| Unit test `CircularBuffTests` on the pin with the carry and the upstream test file | all four cases pass, exit status 0 |
| All three commits applied singly and together, built by five reviewers | the builds of four reviewers exited 0; the full make of the three-fix tree of the fifth stopped at the link of the stock `plugin-test` for the missing Boost library, its libraries built, and its separate unit test driver gave the result above; all five saw the unit test result above |

## Not verified

- an IOC run of the circular buffer plugin with a real busy record; the unit
  test drives the plugin through its asyn parameter interface;
- a build against pvxs 1.5.3, the release pin, and a GCC 15 build; other platforms, the CI matrix, `make check.deps`, an
  installed-tree check and a strict release-check build;
- the two commits that are not carried, beyond reading and compiling them.

## Completion review

Independent reviewers with fresh context ran the completion reviews of the
[carry procedure](procedures/upstream-fix-carry-procedure.md). Third-person
passes re-derived the patch content, wiring, scores, funnel, builds and
unit-test claims with their own commands. Second-person passes read the
changed text as a reader without session context and ran the reader actions.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | third | 0 | 2 | 4 | both minor corrected: the number of reviewers who did not run the error path of `3f07467`, and the Open decisions row and observation paragraph of the release record that still called the ADCore inclusion open; the info acted on: the consumer sentence, the hunk line numbers, the temporary paths and a deletion remark removed from the scores file, and this section filled |
| 2 | second | 0 | 2 | 3 | both minor corrected: the pvxs version of the builds is stated as 1.5.2 against the release pin of 1.5.3 and the 1.5.3 build is listed as not verified, and the Verification section gives the commands to repeat the build and the unit test; the info acted on: the steps at the next pin change |
| 3 | third | 0 | 3 | 4 | all three minor corrected: the consumer sentence now says that `ADGenICam` has no IOC and no startup script, the steps at the next pin change follow the Bump obligation (a confirmation run, the rules stay), and the recipe of the Verification section gives the dependency paths and a separate copy and install location for each build; the info acted on: the `warning` line of the build logs, the statement about the builds of five reviewers, and the HDF5 settings |
| 4 | second | 0 | 3 | 3 | all three minor corrected: the section on the next pin change now lists what to drop and the checks that show it is done, gives the command, the places and the expected value of the re-count, and says where the retirement is recorded; the info acted on: a content check for the case that upstream was squashed, the steps when the fix is not contained, and the order of step 2 of the recipe |
| 5 | third | 0 | 1 | 3 | the minor corrected: the steps for a fix that the new source does not contain now rename every place that names the pin, say what to do when the apply fails, and say where the outcome is recorded; the info acted on: the drop list names the clause with its comma and the example value, and the content check runs with `patch -f` so that it never prompts |
| 6 | third | 0 | 4 | 4 | all four minor corrected: the check for the fix in a new source is decided by a `grep` because exit 1 of the dry run also means that only the surrounding lines differ, the `.rej` and `.orig` residue of a failed apply, the order for regenerating the patch, and fuzz as a sign that the surroundings differ; the info acted on: the pin in `configure/RELEASE` is set before the steps |
| 7 | third | 0 | 3 | 5 | all three minor corrected: the check for the fix in a new source starts from a source with the carry reverted, the regeneration starts from a clean source and does not add the line twice, and the `Patching` count in the `sscan` record is annotated as it was before this carry; the info acted on: exit 1 of `merge-base` is not conclusive, the `.rej` file is visible with `git -C ADCore-src status`, and the 43 is the aggregate count |
| 8 | third | 1 | 0 | 3 | the must-fix corrected: step 1 of the section on the next pin change no longer runs the revert target, which removes the upstream line from a source that already contains the fix, and restores the file with `git checkout` instead; the regeneration of the patch starts the same way |
| 9 | third | 0 | 1 | 3 | the minor corrected: exit 1 of the ancestor test is not conclusive, and an unknown name gives exit 128; the info acted on: the clause for a line that is already in the source now sends the reader back to step 1 |
