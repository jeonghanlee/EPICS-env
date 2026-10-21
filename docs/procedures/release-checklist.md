# Release - Checklist

The checklist of `release-procedure.md` and the files it names. It states no
rule of its own: each section names the file and the step or stage that holds
the rules of its items. An item is checked only when its evidence exists, a
commit, a log, or a state observed on a remote; a plan, a message, or a closed
issue alone is not evidence.

Read it against the register of the release (`docs/milestone-<release>.md`).
The register holds the evidence of each item, in the Verification Results, the
Closure Evidence, and the Decisions of the work it belongs to; this file lists
the items, the same for every release.

## 1. Open the line

Rule: `release-procedure.md`, step 1; `milestone-tracking`, Reset.

- [ ] The release line `release-<release>` exists on origin and was opened from
      the tip of master.
- [ ] The version value is set in `configure/CONFIG_SITE` in the first commits
      of the line.
- [ ] The register of the previous release is reset into the register of this
      one, with its History row naming the commit that carries the register it
      was reset from.

## 2. List the modules

Rule: `release-procedure.md`, step 2.

- [ ] Every `SRC_TAG_<KEY>` of the two repositories is listed, EPICS base
      included.
- [ ] Each ends with one recorded outcome: IN, HOLD, or unchanged.

## 3. Survey and pins

Rule: `release-procedure.md`, step 3; `module-bump-procedure.md`, Stages 1 and
2 and the repository table.

- [ ] The EPICS-env survey exits 0 or 2; an exit 1 is read as incomplete.
- [ ] The site module survey is a `git ls-remote --tags` per key, and
      missing access to the site remote stops the release.
- [ ] Each pin is located, `RELEASE.local` is checked for an override, and no
      second authority for the pin remains.

## 4. Census and decision

Rule: `release-procedure.md`, step 4; `module-bump-procedure.md`, Stages 3 to 5;
`upstream-fix-carry-procedure.md`; `upstream-fix-verification-procedure.md`.

- [ ] The dependent census of each candidate is taken from module sources at
      the pinned revision, with two search tools that agree, and confirmed in
      the installed tree.
- [ ] The break surface of each candidate is judged at the exact refs, and the
      diff of the module's Makefiles and `configure/CONFIG*` files is read for
      build-option changes.
- [ ] The owner's decision, IN or HOLD, is recorded in the Decisions with its
      date and reason; a candidate that the owner keeps unchanged outside a bump
      is recorded in `docs/CLOSED_DOORS.md`.
- [ ] A bump of EPICS base or pvxs re-examines its carries, and a carried patch
      of any bumped module still applies or is re-examined.
- [ ] A fix that only production hardware can show is proven first.

## 5. Order

Rule: `release-procedure.md`, step 5.

- [ ] The order of all the modules is a dated decision: EPICS base and pvxs
      first, then the dependency order, then the re-pins of identical code.

## 5a. Tools of the cycle

Rule: `release-procedure.md`, step 5a; `module-bump-procedure.md`, Stage 6 and
the repository table.

- [ ] The guest check scripts and the make targets were read against what
      Stage 6 and the repository table say, for every repository of the
      release.
- [ ] Each difference is fixed as one piece of work after the cycle of the
      first module and before the cycle of the second, with its tests run on
      the guests of the first module.

## 6. EPICS-env modules: every module, whatever its outcome

Rule: `release-procedure.md`, step 6; `module-bump-procedure.md`, Roles and
Stage 6; `documentation-upkeep-procedure.md`, At the close of every step.

Repeat for each module, EPICS base and pvxs included.

- [ ] The module has its issue, opened at its plan step.
- [ ] The plan is reviewed in a third-person pass and a second-person pass,
      with the findings recorded in the plan of the register detail; the owner
      accepts it, and separately authorizes the implementation.
- [ ] The accepted plan is committed; for an IN outcome whose pin is not yet at
      the decided value, the pin change is committed.
- [ ] The candidate is pushed, and the guests fetch it from origin.
- [ ] The module and the modules that depend on it are rebuilt from clean on
      the guests; a module whose `distclean` is unsafe is rebuilt from a new
      source tree, and a module that carries patches has them applied.
- [ ] A configuration question that the module reopens, such as a
      compiler-standard workaround, is answered by real builds with and
      without it.
- [ ] The guest checks passed: the build, the patch round trip, the consumers,
      the installed-tree checks, and the text agreement; the results of the
      deepest consumers were read first.
- [ ] The results are in the register with their observed times, guests, and
      evidence; a HOLD or unchanged module records why its pin did not move.
- [ ] The results are committed and pushed, and their landing on origin is
      observed.
- [ ] The issue is closed on the release line with its body synced and its
      closing comment posted, and its closed state is read back.
- [ ] The closure commit records the landing and the closed issue, marks the
      module Complete, and is pushed.
- [ ] The commands that a changed procedure shows were run once on the real
      path, and the lessons of the module are written into the procedure that
      owns each rule, in a commit of their own after the closure; a lesson that
      is not a procedure rule is added to the lessons row of the Backlog.

## 6a. Guests, once per repository

Rule: `module-bump-procedure.md`, Stage 6, the guest section; the
`agent-collaboration` skill. Every guest of any step is requested here.

- [ ] The session of cloud-provision is known, and the owner approved the build
      on the guests.
- [ ] The request to that session explains the purpose and fills Platform,
      Resources, Duration, State, Access, and Follow-up.
- [ ] The guests of an earlier cycle that this cycle does not use again are shut
      down by a request to the same session, with their disks kept.
- [ ] The build succeeded on each guest: the sentinel file exists, and the OS
      point release, the kernel, and the compiler are recorded.
- [ ] A finished notice is sent when a repository no longer needs its guests.

## 7. Site modules

Rule: `release-procedure.md`, step 7; `module-bump-procedure.md`, the
repository table.

- [ ] The owner confirmed that no other session writes in the site module
      repository, and its release line is opened from master before its first
      module.
- [ ] Each module runs the checklist of step 6 with the repository table: the
      survey tool, the issue (none for a site module), the candidate, the guest
      selectors, and the verification of the repository. A site module is
      surveyed and decided before its plan.

## 8. Rehearsal of the combined stack

Rule: `release-procedure.md`, step 8.

- [ ] Every site module is Complete and each tip is pushed to its origin.
- [ ] The two tips build together on new guests, requested as in 6a, and
      `make check.deps` and `make check.env` pass; the result is in the
      register.
- [ ] The module count of the tree that passes is recorded as the count that
      the inventory check of the release verification expects.

## 9. Merge and tag of the site module repository

Rule: `release-procedure.md`, step 9.

- [ ] The local master of the site module repository is brought to its
      remote.
- [ ] The merge tree equals the built commit, or differs by documentation files
      only (`git diff --stat`).
- [ ] A repository whose release line holds no commit beyond master is not
      merged; its tag is on the master commit that was built.
- [ ] The annotated tag is on the merge commit; the branch and the tag are
      pushed as separate actions, each under its own authority.
- [ ] The line and the tag, including the peeled tag, are observed with
      `git ls-remote`.

## 10. Readiness

Rule: `release-procedure.md`, step 10; `release-cycle`, readiness;
`commonIocsh-verification-procedure.md`.

- [ ] The Integrated Verification re-ran on the combined tree.
- [ ] The version check is done.
- [ ] The change log entry is in the form of this repository and dated to the
      day planned for the merge and tag; if they fall on another day, the date
      is corrected under the candidate rule.
- [ ] The README and book paths that name the release read the release.
- [ ] The production environment tests of the two products passed, on guests
      requested as in 6a.
- [ ] The common iocsh fragments are verified.
- [ ] The readiness-evidence commit is the candidate, and a later commit leaves
      it valid only under the candidate rule of `release-procedure.md`.

## 11. Execution and verification

Rule: `release-procedure.md`, step 11; `release-cycle`, execution, release
verification, and cycle close.

- [ ] Each release row has its own preview, preflight, and authority, and a
      checkpoint commit after each mutation.
- [ ] The merge, the annotated tag, the push of master, and the push of the tag
      are separate rows.
- [ ] The merge takes the tip of the release line after its last pre-merge
      checkpoint, and its comparison with the candidate is recorded.
- [ ] The release objects are observed with their identifiers: the tag peels to
      the merge commit, and the release is published.
- [ ] The tracker is reconciled: the milestone is closed and every linked issue
      matches its final state.
- [ ] The register is reset into the next generation.

## 12. After the release

Rule: `release-procedure.md`, step 12; `documentation-upkeep-procedure.md`,
At the close of the cycle and After the release.

- [ ] The procedures of this repository, the archive, and the release
      references of the skills are reconciled in one pass.
- [ ] The skills items of the lessons row are sent to the owner of the skills
      as one request, and its reply is recorded.
- [ ] The release line of the release before the previous one is deleted
      locally and on origin, after its tag is confirmed on origin and it is
      merged.
- [ ] The next release line opens by a separate dated decision.
- [ ] The distribution products are built from the released tags by the
      pipeline.
