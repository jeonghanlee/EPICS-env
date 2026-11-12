# Release - General Procedure

The entry for a release of the EPICS-env environment. This file holds the order of a release and names, at each step, the file that holds the rule. It states a rule of its own only where no other file holds it.

- The work of this repository lives in `docs/procedures/`: one module in `module-bump-procedure.md`; the downstream patches of a module, EPICS base and pvxs included, in `upstream-fix-carry-procedure.md`; a fix that can be seen only on production hardware in `upstream-fix-verification-procedure.md`; the common iocsh fragments in `commonIocsh-verification-procedure.md`; and the rules for changing a procedure and for the reconciliation after the release in `documentation-upkeep-procedure.md`.
- Each release keeps a release record, `docs/milestone-<release>.md`: its decision log (the Decisions table), the plan and results of each module, the release plan, the lessons learned, and a History table that names the commit the record started from.
- The candidate is the commit that the checks build and test: for a module, the tip that carries its plan and any pin change; for the release, the commit that carries the release readiness evidence, which the candidate rule ties to the tip the release checks tested (step 7). A cycle is the work for one module (step 6).
- The checklist of a release, which names each check and the file that holds its rule, is `release-checklist.md`.
- The product of a release is the EPICS-env tree that the CI workflows build and the distribution ships.

The release inventory includes the modules of EPICS-env and the site modules
selected by the maintainer. Prepare both repositories and their module sources
at the start, before the survey. Site modules follow the same survey,
compatibility decision, dependency ordering, and module cycle as EPICS-env
modules. An installed tree is a build prerequisite, not a prerequisite for
cloning or examining sources. `site-modules-procedure.md` holds the repository
preparation and the site-specific build and evidence rules.

A release runs bottom-up: EPICS base and pvxs, then the other modules, then the release. It reads top-down: this file, then the file each step names. The same module procedure repeats for every module.

The checks run on test machines: the local host, or virtual machines (guests) created with the public `cloud-provision` repository (Test machines, below).

## Roles and interaction

| Role | Responsibility |
| --- | --- |
| Maintainer | Sets the release scope and starting inputs, grants execution authority, and decides whether changes are adopted. |
| Executor | Performs the authorized procedure, verifies source and upstream state, records evidence, and presents findings for decisions. |

These roles define responsibilities, not the type of participant performing
them. The Maintainer may also act as the Executor. The same role names apply
to the module and site procedures used by this release.

At the start of step 1, the Maintainer identifies the Executor and provides
the release number, the EPICS-env and site repository scope, the starting
revisions, and the authority needed for the planned operations.
The Executor records these inputs in the release record before proceeding.
Each commit, push, and GitHub mutation still requires its applicable
authorization; starting a release does not grant unspecified permissions.

The default is non-interactive execution: after those inputs are established,
the Executor completes the remaining work of step 1 and steps 2 and 3 without
routine confirmation between steps or modules. At the Maintainer's request,
execution is interactive, with confirmation at the requested step or module
boundaries. The Maintainer can change this preference during execution.
Both modes require the same evidence and authorizations. The Executor asks
for input when missing information, missing authority, or a blocking condition
prevents the next operation; elapsed time does not supply that input.

Step 2 establishes the current source baseline of the combined inventory:
owning repository and revision, module key, effective pin and version,
resolved source commit, and any local override. Step 3 compares that baseline
with upstream tags and branch heads and records the available changes.
These steps do not decide which changes to adopt.
At step 4, the Executor presents the dependency, compatibility, and downstream
patch findings; the Maintainer decides adoption or retention. The interaction
mode does not remove this decision or the later approvals required below.

## Phases

| Phase | Steps | What runs |
| :-- | :-- | :-- |
| 1. Preparation | 1 to 6 | the release branch, the survey, the reverse dependencies, the decisions, the order, the tools check, and the module cycles |
| 2. Final release | 7 to 8 | the candidate, the release verification, and the merge, tag, and release |
| 3. After the release | 9 | the reconciliation, the next release branch, and the distribution products |

## Order

1. Open the release branch: `release-<release>` from master, the release record `docs/milestone-<release>.md` renamed from the `docs/milestone-<hash>.md` that master carries (the previous release handed it to master in its step 8) with a History row that names the commit that carries it, the version value `ENV_RELEASE_VERS` set in `configure/CONFIG_SITE` in the first commits of the branch, and the branch pushed to origin. The release number is set by the maintainer's dated decision that opens the branch: the patch number rises for a release of fixes only, and the minor number for a change of the module set or a feature. The GitHub milestone titled with the release number and the issue that tracks the release, titled `Verify and publish EPICS-env <release>`, are opened with the branch.
2. Prepare the sources and record the current baseline: clone the selected site module repository alongside EPICS-env and clone the module sources of both at their pins (`site-modules-procedure.md`, Source preparation). Record both owning repository revisions and list every `SRC_TAG_<KEY>` from their `configure/RELEASE`, `SRC_TAG_BASE` included, with its owning repository, key, effective pin, version, resolved source commit, and local overrides. Complete this step when every declared module has a verified baseline entry and the required submodule revisions are checked. Adoption and retention outcomes belong to step 4.
3. Survey every module against that baseline and confirm each pin (`module-bump-procedure.md`, Stages 1 and 2). For every module, record both the latest release tag and the default branch HEAD, their resolved commits and dates, and the changes relative to the baseline, including branch commits after the latest tag. Follow Stage 1's evidence and completeness requirements even when the survey tool reports `OK`. Reconcile the results against both repositories; neither a successful tool exit nor a complete survey of EPICS-env alone completes this step.
4. Find the reverse dependencies of every module in both repositories, including unchanged and HOLD modules (Stage 3). For every newer upstream candidate, judge API/ABI compatibility (Stage 4); the maintainer decides IN or HOLD (Stage 5). Record each outcome in the decision log of the release record: an IN or a HOLD as a dated row with the module, old -> new, and a one-line reason; an unchanged module, one with no newer upstream release, which needs no decision, as a line shared by the modules that stand alike. A newer upstream release examined outside a release cycle goes to `docs/CLOSED_DOORS.md` instead. EPICS base and pvxs move in lockstep: a bump re-examines their downstream patches (`upstream-fix-carry-procedure.md`, Bump obligation). A fix that only production hardware can show is proven first by `upstream-fix-verification-procedure.md`.
5. Order all the modules from both repositories: EPICS base first, pvxs next in lockstep with base (their downstream patches are examined together, and its cycle follows the cycle of base). Then use the dependency order from both `configure/CONFIG_MODS_DEPS` files and the cross-repository dependencies verified in step 4. Place each module after its dependencies; break ties by declaration order, reading EPICS-env before the site repository. Place re-pins of identical code last only when no consumer requires them earlier. The order is the maintainer's dated decision in the decision log; a separate site repository is not a reason to put its modules after every EPICS-env module.

6. Run one cycle per module, EPICS base and pvxs included, whatever its outcome, in this order. Each commit and push has its own authorization from the maintainer, and a commit message carries the change, not the review.
   The step has four parts, in this order:
   - Part A, before the first cycle: read the scripts of `tools/module-check/` and the make targets against what Stage 6 of `module-bump-procedure.md` says they do, and write each difference in the section Tools of the cycle of the release record (create the section when it is absent; write `none` when nothing differs). Then compare, for every module of both repositories, the pin in `configure/RELEASE` with the pin that the Modules table of the release record shows for it (the value after `->` for a changed module), each resolved to a commit with `git -C <module>-src rev-parse <pin>^{commit}` in the source clone of step 2, and write each module whose two commits differ, or `none`, in the same section. Sub-step 3 of that module's cycle moves the pin, so the baseline build below is made from pins that may not all be at the values of the table.
   - Part B, the baseline build: the cycle of the first module, EPICS base, builds the whole tree once on each test machine from the pins that `configure/RELEASE` holds at the candidate, as the build and install page sets out (Test machines, below). Its checks, sub-step 5, use the scripts as they are, and it works around a difference it meets by hand; it writes each difference that Part A did not find in the same section of the release record. After the checks of sub-step 5, which run on the tree before the site modules are in it (the loader suite counts only the modules of this repository until Part C changes it), it installs the site modules into the same tree at the pins they hold and checks them as consumers (`site-modules-procedure.md`, Build); the cycle of each site module later does its plan, its pin edit, and its module-specific checks.
   - Part C, after the cycle of the first module (all its sub-steps) and before the cycle of pvxs: fix each difference written in the section Tools of the cycle as one piece of work, with its own plan review, acceptance, commit, push, and tests on the test machines of the baseline build, because every later cycle runs these tools. Record the work in the release record as an item of its own.
   - Part D, the cycles of the other modules, pvxs first, in the order of step 5, each with the sub-steps below.

   Site modules run these same sub-steps, including the plan, issue, results,
   and closure. Their pins and build commands belong to the site repository;
   the release record holds their decisions and cycle status. Record both
   repository commits for their candidate and evidence. On the test machines,
   build them into the shared tree once their dependencies are installed,
   using `site-modules-procedure.md` for the repository-specific actions.
   The sub-steps of one cycle, which parts B and D run:
   1. The issue: one for each cycle that moves a pin or changes the patches of a module, in the release's GitHub milestone, titled with the module and the release and labelled as the issue that tracks the release, opened at the plan step. A cycle that rebuilds a module at an unchanged pin with unchanged patches opens no issue; its plan and results in the release record are its record, and the Issue column of the Modules table says `none`.
   2. The plan, in the module's section of the release record: its claims verified against the repository and the installed tree of a test machine (the pin, the apply targets, the dependents, the installed link, library, and consumers), with the findings, or `none`, and the maintainer's rulings recorded in the plan beside its acceptance; the maintainer accepts it and authorizes the implementation, and the dates are written into the plan with the results (sub-step 8).
   3. For a module whose pin is not at the decided value or whose patches change, the pin change and its commit (`module-bump-procedure.md`, Stage 6, step 1); a cycle with an unchanged pin and unchanged patches commits nothing before its checks.
   4. The candidate: the pushed tip that carries the pin change, or, for a cycle that commits nothing, the tip of origin at the acceptance of the plan; the test machines fetch it from origin. The test machines of the cycle are prepared once, with the candidate of the first module, and carry the baseline (Test machines, below).
   5. The clean rebuild of the module and its dependents and the checks on the test machines (`module-bump-procedure.md`, Stage 6). While they run, verify the repository-side claims of the plan of the module that follows in the order of step 5 (its pin, apply targets, dependents, and library stems), so that only its installed-tree claims of sub-step 2 remain once the test machines are free. A failure that the module or a dependent causes returns the cycle to the decision (`module-bump-procedure.md`, Rule - a failed Stage 6 returns to the decision): the new decision is a dated row of the decision log, IN or HOLD with a reason that names any downstream patch it adds, and the cycle resumes at sub-step 2 with a revised plan; Stage 6 then runs again from its step 1 (`module-bump-procedure.md`).
   6. The results in the module's section, each with its observed time, test machine, and evidence; a HOLD or unchanged module records there why its pin did not move.
   7. The issue, when the cycle has one, closed on the release branch before the commit of the results, with its body synced to the results (the candidate named, the results in the release record) and a closing comment posted, and its closed state read back.
   8. One commit and push that carry the acceptance of the plan, the results, the closed issue when the cycle has one, and the mark of the module as complete, after a second-person pass over that record text; its landing on origin is observed.
   9. Nothing else: a cycle has at most two commits, the pin change and the record, apart from a lessons commit (sub-step 10).
   10. The lessons: a rule the cycle taught goes into the procedure that owns it (`documentation-upkeep-procedure.md`, At the close of every step), and a lesson no procedure holds goes into the lessons learned of the release record, in a commit of their own after the commit that marks the module complete.
7. Verify release readiness after every module cycle of step 6 is complete.
   Use the pushed release-branch tip and the selected site repository commits
   that carry the completed cycles. Follow the sequence below for every
   release; record its inputs, exceptions, and results in the release record.
   The installation and test procedures linked here own the commands and
   passing criteria; do not copy them into a new release-specific procedure.
   Run the existing repository scripts and documented commands directly with
   the recorded inputs, using the documented runners for remote execution and
   log capture. Do not create per-run helper scripts merely to combine these
   commands, or add path assumptions or passing criteria of your own. Resolve
   paths from the actual configuration and installed environment before use.

   a. Confirm the inputs and execution authority with the Maintainer. Record
      both repository commits, effective module pins and local overrides,
      target operating systems, test machines, canonical sandbox and install
      paths, and the evidence location. Use the combined inventory and
      decisions of steps 2 to 5. This step verifies their final selected state;
      it does not repeat the upstream survey or the adoption decisions.

   b. Prepare the test machines as in Test machines below. On each machine,
      prepare both repository checkouts at their selected commits before the
      build, preserving earlier checkouts in timestamped trash when reusing
      their paths. In the EPICS-env checkout, set the recorded installation
      root inside the sandbox by
      [Choose the install location and release](../src/procedures/choose-install-location.md).
      Then resolve `INSTALL_LOCATION_EPICS` and confirm it matches the recorded
      target tree. Use fresh sources and an absent or empty target tree;
      preserve an earlier tree and logs in timestamped trash. Leave other
      release trees under the installation root in place. Confirm resources,
      required tools, free disk space, and free inodes, including the space
      occupied by retained test artifacts.
      Record the checks and resolve any shortfall before building.

   c. Install the combined environment on every test machine in dependency
      order: vendor libraries, EPICS base and EPICS-env modules, then site
      modules. In the prepared EPICS-env checkout, follow the installation
      steps of
      [Build and install the environment](../src/procedures/build-and-install.md),
      using the selected candidate and the vendor configuration for the OS.
      This is the whole-tree build of step 6, Part B, at the final pins.
      Record the resolved vendor library paths, each checkout's commit,
      effective source pin, and
      configuration overrides so recovery can reproduce the same inputs.
      Complete the EPICS-env installation before adding site modules. Record the
      resolved tree path, OS point release, kernel, compiler, and build results.

      Continue in each prepared site checkout with the installation steps of
      [Site modules, Build](site-modules-procedure.md#build) and
      [Add the site modules to an installed tree](../src/procedures/add-site-modules.md).
      Use the same user and installed EPICS-env tree. For a tree-based site
      candidate, its `INSTALL_LOCATION` names that complete tree, whereas
      EPICS-env's `INSTALL_LOCATION` names the root above the release directory.
      Confirm that both checkouts resolve `INSTALL_LOCATION_EPICS` to the same
      canonical path before building the site modules. Apply the site's rule
      for dependency findings, then build, install, and create the module links.
      EPICS-env and site installation form one step; moving to the site
      checkout does not require a separate authorization.

   d. Verify the combined tree installed in item c on every test machine.
      From the EPICS-env checkout, run `make exist LEVEL=1`, `make check.deps`, and
      `make check.env`; each must exit 0. In the site checkout, verify the
      installed site directories and links. Source the installed tree's
      `setEpicsEnv.bash`, then perform the representative IOC startup and
      generated-startup checks outside the source checkouts, following
      [Add the site modules, Verification](../src/procedures/add-site-modules.md#verification).
      Require the IOC initialization-complete message, exit status 0, and the
      selected module versions in the generated startup. Record both repository
      commits, installed site versions, the module-entry count after site
      installation, and the check results. This verified combined tree is the
      baseline for the full loader suite and its recovery checks.

   e. On one test machine, run the EPICS-env patch apply-and-revert check in a
      separate fresh checkout, following `module-bump-procedure.md`, The checks,
      item 2. Supply the tested tip as the commit and an empty module argument
      to `guest-roundtrip.bash`, so the check covers every declared module.
      Repeat the site patch round trip in its own fresh checkout as specified
      in [Site modules, Cycle evidence](site-modules-procedure.md#cycle-evidence),
      using the selected site commit and shared installed tree. Both round
      trips must return every module source to its pin without tracked or
      untracked changes, even when the site patch targets have nothing to apply.

   f. On every test machine, run the full loader suite by
      `module-bump-procedure.md`, The checks, item 3, against the combined tree.
      Give `guest-suite.bash` the EPICS-env checkout, the log directory
      `<sandbox>/iocsh-tests/release`, and the site checkout, with no script
      list. This runs all 17 scripts in their defined order, including the
      eleven loader-specific scripts omitted from the individual module cycles.
      Record every script's result, the minimal IOC result, and the metadata
      counts for the combined inventory. Inspect the printed results and logs;
      the wrapper's exit status alone does not prove the suite passed.

      The suite requires at least 6 GiB free on the log volume
      (`GUEST_SUITE_MIN_FREE_KB`) and adds two module entries, the second versions
      of asyn and linStat. `verify_docs_and_tools` has six checks with
      ShellCheck, or five without it. Retain logs and copied
      trees through the test tools' trash handling, and account for their disk
      use before a retry.

      A failed or interrupted suite can leave a missing link, a partial
      installation, or a truncated `libasyn.so`. Stop dependent checks and
      preserve the failure evidence. Compare the installed entries with the
      post-site-install count from item d, allowing for the two suite-added
      entries, and inspect `libasyn.so` and `modules/asyn`. If the tree is
      damaged, recover at the recorded repository commits, source pins, and
      local overrides. Check these inputs before rebuilding; an interrupted
      suite can leave its temporary pin overrides or source checkouts in place.

      Use `tools/module-check/guest-baseline.bash` with `--rebuild` only after
      checking all of its prerequisites. Set `GUEST_CHECKOUT` explicitly to
      the canonical EPICS-env checkout recorded for this run; the script
      otherwise selects `~/sandbox/EPICS-env`, regardless of the working
      directory. Both adjacent vendor checkouts, `uldaq-env` and
      `open62541-env`, must already be built for this OS and configured to
      install into this tree's `vendor` directory. This recovery mode neither
      clones them nor configures their installation paths.

      Confirm that `INSTALL_LOCATION` is dedicated to this verification run
      and that its entire contents can be moved. The helper moves that whole
      installation root to `<install_location>.damaged-<UTC timestamp>`, not
      just the tree named by `INSTALL_LOCATION_EPICS`. Record the preserved
      path with the failed-run evidence. Do not use the helper on a root that
      also contains other releases or installations.
      After a successful helper run, complete the site installation of item c
      and the combined-tree verification of item d. The helper restores only
      EPICS-env.

      If any prerequisite is unmet, preserve only the affected tree and source
      checkouts in timestamped trash, leaving other installations in place.
      Repeat the fresh-source preparation and installation of items b and c
      at the recorded inputs and paths, then verify the combined tree by item d.
      Prepare the required vendor checkouts before rebuilding both libraries
      into the tree's `vendor` directory.
      Do not rerun clone commands over existing vendor checkout directories.
      Inspect and preserve those checkouts before preparing fresh replacements
      at the recorded revisions when they are needed.

      After either recovery path completes item d, record the resulting
      combined module-entry count before retrying the loader suite. Preserve
      failed logs and use a distinct attempt label.

   g. On every test machine, verify the common iocsh fragments by
      [the commonIocsh procedure](commonIocsh-verification-procedure.md),
      including Installed-Path Verification and Isolated-Path Verification.
      Build the `tc32sim` test IOC against the selected installed tree; the
      caPutLog check needs no IOC build.
      Then repeat the site's representative IOC check and the final installed
      tree checks: `make exist`, `make check.deps`, and `make check.env` from
      the checkout, and installed `softIocPVX` with `exit` on standard input
      after sourcing the tree's `setEpicsEnv.bash`. Each must exit 0; retain
      the site IOC observations and both repository commits with the results.
      Before running `softIocPVX`, use `command -v softIocPVX` and resolve
      the reported path with `readlink -f`. This executable belongs to pvxs:
      its path through `modules/pvxs/bin/<arch>/softIocPVX` resolves to the
      selected version's `modules/pvxs-<version>/bin/<arch>/softIocPVX`.
      Require an executable in the selected tree at the effective pvxs version
      and architecture. Do not construct a `base/bin` path or assume a path
      before inspecting the sourced environment. Record both paths with the
      exit status.

   h. Confirm successful results for the six OS CI workflows and the Linter
      at the tested source. Record their run URLs and commits. The other
      operating systems are covered by these workflows; public EPICS-env CI
      does not establish site-module results. A documentation-only tip can use
      an earlier workflow run only under the candidate rule below.

   i. Confirm that `ENV_RELEASE_VERS` in `configure/CONFIG_SITE` and its
      effective make value equal the release number set in step 1. Write the
      `ChangeLog.md` entry in the existing form
      `### <version> <date> <name> <email>`, with the email in angle brackets.
      Use the planned merge/tag day supplied by the Maintainer. Check
      `README.md` and `docs/src` for paths naming the previous release and
      update applicable release references. A later merge/tag day changes
      only the entry's date under the candidate rule.

   j. Record each check's observed time, environment, result, and evidence in
      the release record. The commit that carries the completed readiness
      evidence is the release candidate; step 8 governs its commit and push.
      Record the tested EPICS-env and site commits and their input comparison
      with that candidate. Required failed or missing results prevent readiness.

   The candidate rule applies to both repositories. A later commit that changes
   only evidence, documentation, or tools that no build or CI file references
   leaves the candidate valid once the input comparison is recorded. Any other
   change reopens the checks it affects, including site checks when site inputs
   change. A workflow that ignores documentation-only pushes can use its run
   at the last relevant code change after that comparison. Changes to a test
   or helper used by a required check reopen that check even if CI ignores it.
8. Write the release plan in the release record, one row for each action of this step, with the commits and pushes around them, and one for the branch deletion of step 9 when the plan carries it, each with its command in full, its authorization, and its expected result, and have the maintainer accept it. A value that exists only when the row runs, such as a commit hash or the files of a commit, is a placeholder in the command and is filled in when the row is shown for its authorization. Then execute and verify the release with its rows, each row with its own authorization and followed by a commit that records its result: on the release branch before the merge, and on master after it. The push of the result commits of the release branch before the merge is a row of its own, so that the merge takes a tip that origin holds. The result of that push is recorded on master after the merge, because a result commit on the release branch would need another push. Before the merge, local master is brought up to date with origin by a fast-forward, and the release branch contains it: `git rev-list --count release-<release>..master` prints 0. The merge into master, the annotated tag, the push of master, the push of the tag, and the creation of the GitHub release of the tag are separate rows. The annotated tag names the merge commit, because a result commit of the merge row can follow it and the tip of master is then another commit. The notes of the GitHub release are written from the `ChangeLog.md` entry of the release, in the form of the notes of the previous release (`gh release view <previous-release> --json body --jq .body` prints them), and are shown to the maintainer before the row. The merge takes the tip of the release branch after the last result commit before the merge, not the candidate, and the comparison of that tip with the candidate is recorded under the candidate rule of step 7. The release objects are then observed with their identifiers: the tag on origin peels to the merge commit, and the GitHub release of the tag is published. The issue that tracks the release itself closes after the release objects exist, with its body synced to the results of the rows and a closing comment that names the tag, the merge commit, and the GitHub release, unlike a module issue, which closes on the release branch; the release's milestone then closes, and every issue linked to it is read back in its final state. At the close the release record is handed to master as the starting record of the next release: a commit on master renames `docs/milestone-<release>.md` to `docs/milestone-<hash>.md`, where `<hash>` is the short hash of the commit that carries the closed record, keeps only the work that survives the release (the Deferred work, and each module or work row that is not complete, with the decisions those rows cite), and adds a History row with the full hash of that commit and the date. The result commits on master and this handover commit are pushed in the final row. The results of the handover and of the final push are not committed, because the record is already handed over; the closed record keeps them `pending`. The closed record is read at that commit, with `git show <commit>:docs/milestone-<release>.md`.
9. After the release: the procedures of this repository and the archive are reconciled in one pass (`documentation-upkeep-procedure.md`, After the release). The maintainer deletes the release branch of the release before the previous one, locally and on origin, once its tag is on origin and it is merged, since the tag keeps its content; a row of the release plan may carry the deletion as soon as the release objects exist. The next release branch opens by a separate dated decision, and the distribution products are built from the released tag outside this repository.

## Test machines

Site cycles use the same test machines and installed tree as EPICS-env cycles.
Source preparation in step 2 needs neither these machines nor a built tree.
During step 6, install the site modules at the selected pins once their build
dependencies exist, before using them as consumers in another module's checks.
A new guest holds no key for the site repository: connect with agent
forwarding (`ssh -A -o ControlMaster=no -o ControlPath=none`, with the site
key in the agent of the local host; a multiplexed connection reused from an
earlier login forwards no agent, which is why the two options are needed) and
clone there, accepting the host key of the site server on that first clone
with `GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=accept-new'`, so that
`make init` of the site checkout clones the module repositories with the same
key; for `guest-run.bash`, the hosts file line
`ssh_options=-A -o ControlMaster=no -o ControlPath=none` forwards the agent
on every command. When the agent cannot be forwarded, copy the prepared site
checkout of step 2, with its module sources at their pins, into `<sandbox>`
instead. Record the commit it is at either way.
When an EPICS-env module has a site consumer, rebuild and check that consumer
from the site checkout in the same cycle. This does not complete the consumer's
own cycle. Record the site candidate with the EPICS-env candidate, and update
the installed-module count after site installation before checking recovery
from a failed loader suite. Recovery restores both repositories' selected
modules, not only the EPICS-env baseline.

Step 7 installs and verifies the selected site modules on its test machines
before the final whole-tree checks. Record both tested commits and the site
IOC results in the release readiness evidence. The candidate comparison covers
both repositories: a change to a site module or its build inputs reopens the
affected checks even when the EPICS-env commit is unchanged. Site repository
publication is a separate authorized operation; including its tests does not
add its contents to the EPICS-env tag or its public CI workflows.

The module checks run on one test machine for each operating system of the release: by default Debian 13 and Rocky Linux 8.10. At the start of a release the maintainer may extend the set by a dated decision (Debian 12, Debian 14 once it exists, Rocky Linux 9 and 10, Ubuntu 24.04 and 26.04); a module that reopens the Ubuntu 26 C17 question uses an Ubuntu 26.04 machine. A test machine is either the local host, for its own operating system, or a virtual machine (guest) created with the public `cloud-provision` repository for an operating system the local host does not cover. Either kind is new, or already deployed with fresh source checkouts and an absent or empty target tree at `INSTALL_LOCATION_EPICS`. Before reusing paths, move the affected checkouts, target tree, and logs into timestamped trash; leave other trees under `INSTALL_LOCATION` in place. For step 7, prepare the paths in the order of item b. Reusing a machine saves resources and is the only option for a physical machine such as the local host. Ask the maintainer for the guests once per release, with the candidate of the first module, and state the purpose, the operating systems, the resources (vCPU, memory, and disk as values, those of the previous release's guests unless the build needs more, and no less than 30 GiB of disk, because the loader suite leaves about 2.7 GB of copies of the tree under its log directory on every run; record the values used), the duration (the end of the module checks), whether they are new or already deployed, that their disks are kept as evidence until the results are recorded, and who connects to them. Step 7 prepares its own test machines the same way. Tell the maintainer when the release no longer needs the guests.

On the local host, run the commands directly. Connect to a guest over SSH as the user the maintainer names, with `-o ControlMaster=no -o ControlPath=none`, and `-o StrictHostKeyChecking=accept-new` for a new guest. On a new guest, first install the host packages that base and the modules need by the commands of the step `Install required packages` of the CI workflow of its operating system (`.github/workflows/<os>.yml`), with `sudo` before the commands the workflow runs as root; `pkg_automation.bash` runs for several minutes and needs `sudo` without a prompt; on Rocky Linux the `dnf update -y` of that step upgrades the system, so reboot the guest once before the build, and a `dnf` that stalls on a download is stopped and run again. Then, on each test machine, check the tools of the loader suite with `command -v gawk expect strace socat podman shellcheck` and install the missing ones: `sudo apt-get install -y gawk expect strace socat podman shellcheck` on Debian; `sudo dnf install -y epel-release` and then `sudo dnf install -y gawk expect strace socat podman ShellCheck` on Rocky Linux; when the user cannot run `sudo` there, the administrator of the machine installs them. A test machine needs a writable `/tmp` with free inodes, because EPICS base writes a temporary file there with `antelope` and ignores `TMPDIR` (check `df -i /tmp` before any build and require free inodes in the thousands), and, for the full suite of step 7, disk for its tree copies, several gigabytes per run: `guest-suite.bash` refuses to start, with status 2, when the volume of its log directory holds less free space than `GUEST_SUITE_MIN_FREE_KB` (6 GB by default), prints the free space as `free before:` and `free after:`, and `run_all.bash` moves the copies into `<log_dir>/trash` when the run ends, whatever its result, retaining them for manual cleanup; earlier runs continue to consume disk space; the recovery after a failed or interrupted full suite is in step 7.

The baseline is the whole tree built once per release at the candidate commit of EPICS base, the first module, and again at the current candidate only when a failed full loader suite has damaged it (step 7), as the fixed environment that every module cycle rebuilds into (`module-bump-procedure.md`, Stage 6). Build it on each test machine in a sandbox in the home of the user who runs the checks: `<sandbox>` is `~/sandbox` unless the maintainer names another place; ask the maintainer at the start when it is not given, never create it under `/opt`, and write it as `readlink -f` prints it. Clone this repository (`https://github.com/jeonghanlee/EPICS-env`) into `<sandbox>/EPICS-env`, check out the candidate, set the install location inside the sandbox (`INSTALL_LOCATION=<sandbox>/epics` in `configure/CONFIG_SITE.local`; `docs/src/procedures/choose-install-location.md`) so that the user owns the tree and make never falls back to `sudo`, and build step by step as `docs/src/procedures/build-and-install.md` sets out, with the vendor libraries uldaq and open62541 built first into the installed tree's `vendor` directory. On a Debian 13 host with 8 cores the baseline takes about 25 minutes: about 3 for the vendor libraries, 1 for `make init`, 2 for `make patch`, `make conf`, and `make check.module-deps`, and 18 for `make build`, `make install`, and `make symlinks`. The baseline is good when `make exist` (as `LC_ALL=C make exist LEVEL=1` of the book page), `make check.deps`, and `make check.env` exit 0 and `git -C <sandbox>/EPICS-env rev-parse HEAD` prints the candidate; record the OS point release, the kernel, the compiler, and the count of the entries of the installed `modules` directory with `cat /etc/os-release` (and `cat /etc/debian_version`, which holds the point release, on Debian), `uname -r`, `gcc --version`, and, in the checkout, `find $(make -s print-INSTALL_LOCATION_EPICS)/modules -mindepth 1 -maxdepth 1 | wc -l`, the count that `module-bump-procedure.md`, The checks, item 3 compares after a failed loader suite, and the `ALL` count of the line `SO: Total Files with   RPATH / ALL:` of `make check.deps` (the first of its three `SO` lines; the tool pads `RPATH` with three spaces); in a release these facts go into the release record, and outside a release into the report of the work that built the tree. The test machines of step 7 install the tree at the tip that step 7 tests the same way, and `git -C <sandbox>/EPICS-env rev-parse HEAD` then prints that tip.
