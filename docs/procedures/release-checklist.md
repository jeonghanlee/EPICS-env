# Release - Checklist

The checklist of `release-procedure.md` and the files it names. It states no rule of its own: each section names the file and the step or stage that holds the rules of its items. An item is checked only when its evidence exists, a commit, a log, or a state observed on a remote; a plan, a message, or a closed issue alone is not evidence.

Read it against the release record (`docs/milestone-<release>.md`), which holds the evidence of each item in its decision log, the results of each module, and the release plan. This file lists the items, the same for every release.

## 1. Open the release branch

Rule: `release-procedure.md`, step 1.

- [ ] The release branch `release-<release>` exists on origin and was opened from the tip of master.
- [ ] The version value `ENV_RELEASE_VERS` is set in `configure/CONFIG_SITE` in the first commits of the branch.
- [ ] The release record `docs/milestone-<release>.md` is renamed from the `docs/milestone-<hash>.md` on master, and its History table names the commit that carried that record.

## 2. List the modules

Rule: `release-procedure.md`, step 2.

- [ ] Every `SRC_TAG_<KEY>` of `configure/RELEASE` is listed, EPICS base included.
- [ ] Each ends with one recorded outcome: IN, HOLD, or unchanged.

## 3. Survey and pins

Rule: `release-procedure.md`, step 3; `module-bump-procedure.md`, Stages 1 and 2.

- [ ] The survey exits 0 or 2; an exit 1 is read as incomplete.
- [ ] Each pin is located, `RELEASE.local` is checked for an override, and the pin is the single source of truth for the version.

## 4. Reverse dependencies and decision

Rule: `release-procedure.md`, step 4; `module-bump-procedure.md`, Stages 3 to 5; `upstream-fix-carry-procedure.md`; `upstream-fix-verification-procedure.md`.

- [ ] The reverse dependencies of each module with a newer upstream release are found from module sources at the pinned revision, with two search tools that agree, and confirmed in the installed tree once the cycle of that module has its test machines.
- [ ] The API/ABI compatibility of each newer upstream release is judged at the exact refs, and the diff of the module's Makefiles and `configure/CONFIG*` files is read for build-option changes.
- [ ] Each IN or HOLD is a dated row of the decision log with the module, old -> new, and its reason; the unchanged modules are a line of the decision log; `docs/CLOSED_DOORS.md` holds only a newer upstream release examined outside a release cycle.
- [ ] A bump of EPICS base or pvxs re-examines its downstream patches, and a downstream patch of any bumped module still applies or is re-examined.
- [ ] A fix that only production hardware can show is proven first.

## 5. Order

Rule: `release-procedure.md`, step 5.

- [ ] The order of all the modules is a dated decision in the decision log: EPICS base and pvxs first, then the dependency order, then the re-pins of identical code.

## 5a. Tools of the cycle

Rule: `release-procedure.md`, step 5a; `module-bump-procedure.md`, Stage 6.

- [ ] The three scripts of `tools/module-check/` and the make targets were read against what Stage 6 says.
- [ ] The cycle of the first module worked around each difference by hand.
- [ ] Each difference was fixed as one piece of work, with its own plan review, acceptance, commit, push, and tests on the test machines of the first module, after the cycle of the first module and before the cycle of the second.
- [ ] The work is recorded in the release record as an item of its own.

## 6. Module cycles: every module, whatever its outcome

Rule: `release-procedure.md`, step 6; `module-bump-procedure.md`, Stage 6; `documentation-upkeep-procedure.md`, At the close of every step.

Repeat for each module, EPICS base and pvxs included.

- [ ] Each commit and push of the cycle had its own authorization from the maintainer, and each commit message carries the change, not the review.
- [ ] The module has its issue in the release's milestone, titled with the module and the release, labelled as the release's other issues, and opened at its plan step.
- [ ] The plan is reviewed in the two passes of step 6, with the findings and the maintainer's rulings recorded in the plan of the module's section of the release record; the maintainer accepts it, and separately authorizes the implementation.
- [ ] The accepted plan is committed; for a module whose pin is not at the decided value, the pin change is committed.
- [ ] The candidate is pushed, and the test machines fetch it from origin.
- [ ] The module and the modules that depend on it are rebuilt from clean on the test machines; a module whose `distclean` is unsafe is rebuilt from a new source tree, and a module that has downstream patches at its pin has them applied.
- [ ] A configuration question that the module reopens, such as a compiler-standard workaround, is answered by real builds with and without it.
- [ ] For a module other than EPICS base, the reverse dependencies in the installed tree were found by each library name and the module name, without the second versions that the loader suite leaves in the tree.
- [ ] The checks passed: the build, the patch apply-and-revert test, the consumers, the installed-tree checks, and no old version left in the files the pin change rewrote; the results of the deepest consumers were read first.
- [ ] A failure that the module or a dependent caused returned the cycle to the decision: a new dated row of the decision log, IN or HOLD with a reason that names any downstream patch it adds, a revised plan reviewed and accepted, and Stage 6 run again.
- [ ] The results are in the release record with their observed times, test machines, and evidence; a HOLD or unchanged module records why its pin did not move.
- [ ] The results are committed and pushed, and their landing on origin is observed.
- [ ] The issue is closed on the release branch with its body synced and its closing comment posted, and its closed state is read back.
- [ ] A commit records the landing and the closed issue, marks the module complete, and is pushed.
- [ ] The commands that a changed procedure shows were run once on the real path, the change was reviewed in two passes and the maintainer accepted its wording, and the lessons of the module are written into the procedure that owns each rule, in a commit of their own after the commit that marks the module complete; a lesson that is not a procedure rule is added to the lessons learned of the release record.

## 6a. Test machines

Rule: `release-procedure.md`, Test machines. Every test machine of any step is prepared here: those of the module cycles with the candidate of the first module (step 6), and those of step 7.

- [ ] The operating systems are the default set, Debian 13 and Rocky Linux 8.10, or the set the maintainer extended by a dated decision.
- [ ] The request for the guests that the local host does not cover states the purpose, the operating systems, the resources as values, the duration, whether they are new or already deployed, that their disks are kept as evidence until the results are recorded, and who connects; the resources used are recorded.
- [ ] Each test machine has the tools of the loader suite installed, free inodes in `/tmp` shown by `df -i /tmp` before the build, and disk for the loader suite.
- [ ] The baseline is built at the candidate of EPICS base, or at the current candidate when rebuilt after a failed loader suite, in the sandbox, with the install location inside it; the test machines of step 7 install the tree at the tip that step 7 tests the same way.
- [ ] The tree is good on each test machine: `make exist`, `make check.env`, and `make check.deps` exit 0, `git -C <sandbox>/EPICS-env rev-parse HEAD` prints the commit it was built at, and the OS point release, the kernel, the compiler, and the count of the entries of the installed `modules` directory are recorded.
- [ ] Each test machine is new, or already deployed with its sandbox checkout and its install location removed before the build; a physical machine is always the second.
- [ ] The maintainer is told when the release no longer needs its guests.

## 7. Release readiness

Rule: `release-procedure.md`, step 7; `commonIocsh-verification-procedure.md`.

- [ ] The integration tests re-ran on the tree at the tip of the release branch after the last module cycle, pushed to origin: the CI workflows and the Linter, the patch apply-and-revert test on a fresh checkout and the loader suite on the test machines of step 7 prepared as in 6a, and the common iocsh fragments.
- [ ] `ENV_RELEASE_VERS` in `configure/CONFIG_SITE` equals the release number, and `make -s print-ENV_RELEASE_VERS` prints it.
- [ ] The change log entry is in the form of this repository and dated to the day planned for the merge and tag; if they fall on another day, the date is corrected under the candidate rule.
- [ ] The README and book paths that name the release read the release.
- [ ] The production environment tests passed on the test machines of step 7 prepared as in 6a, for the default operating systems of the module checks or the set the maintainer extended: the tree installed at that tip, `make exist`, `make check.deps`, and `make check.env` exit 0, and `softIocPVX`, on the path after `setEpicsEnv.bash` of the installed tree is sourced, started and exited 0; the other operating systems pass the CI workflows.
- [ ] The commit that carries the release readiness evidence is the release candidate, the tests at the tested tip stand for it under the candidate rule of `release-procedure.md`, and a later commit leaves it valid only under that rule.

## 8. Execution and verification

Rule: `release-procedure.md`, step 8.

- [ ] The release plan has one row for each action of step 8, with the commits and pushes around them, and one for the branch deletion of step 9 when it carries it, each with its command in full, authorization, and expected result, and the maintainer accepted it. A value that exists only when the row runs is a placeholder filled in when the row is shown for its authorization.
- [ ] Each release row has its own authorization and is followed by a commit that records its result, on the release branch before the merge and on master after it.
- [ ] The push of the result commits of the release branch before the merge is a row of its own, and the result of that push is recorded on master after the merge.
- [ ] Local master is up to date with origin by a fast-forward, and `git rev-list --count release-<release>..master` prints 0 before the merge.
- [ ] The merge, the annotated tag, the push of master, the push of the tag, and the creation of the GitHub release of the tag are separate rows.
- [ ] The notes of the GitHub release are written from the `ChangeLog.md` entry of the release, in the form of the notes of the previous release, and shown to the maintainer before the row.
- [ ] The merge takes the tip of the release branch after the last result commit before the merge, and its comparison with the candidate is recorded.
- [ ] The release objects are observed with their identifiers: the tag on origin peels to the merge commit, and the GitHub release of the tag is published.
- [ ] The issue that tracks the release is closed after the release objects exist.
- [ ] The release's milestone is closed, and every issue linked to it is read back in its final state.
- [ ] The release record is handed to master as the starting record of the next release: renamed to `docs/milestone-<hash>.md` after the commit that carries the closed record, with only the surviving work and a History row naming that commit.
- [ ] The result commits on master and the handover commit are pushed in the final row, and the remote tip of master equals the handover commit.

## 9. After the release

Rule: `release-procedure.md`, step 9; `documentation-upkeep-procedure.md`, After the release.

- [ ] The lessons learned of the closed release record, read at the commit that carries it, that change a procedure are written into that procedure by rules 1 to 3 of At the close of every step and committed with the maintainer's authorization.
- [ ] Each decision record of the downstream patches of the release is moved to `docs/archive/`, or the release has none.
- [ ] The index of `docs/README.md` is in line with the procedures and the archive.
- [ ] The maintainer deleted the release branch of the release before the previous one, locally and on origin, after its tag was confirmed on origin and it was merged.
- [ ] The next release branch opens by a separate dated decision.
- [ ] The distribution products are built from the released tag.
