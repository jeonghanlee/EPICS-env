# Release - General Procedure

The entry for a release of the three-layer environment: EPICS-env (Layer 1),
EPICS-env-support (Layer 2), and the site module repository (Layer 3). This
file holds the order of a release and names, at each step, the file that holds
the rule. It states a rule of its own only where no other file holds it.

- The general rules of any release live in the owner's skills: `release-cycle`
  (the phases of a release), `milestone-tracking` (the register), and
  `git-workflow` (every git and GitHub action and its authority).
- The work of this repository lives in `docs/procedures/`: one module in
  `module-bump-procedure.md`, with its table of what differs by layer; the base
  and pvxs carries in `upstream-fix-carry-procedure.md`; a fix that can be seen
  only on production hardware in `upstream-fix-verification-procedure.md`; the
  common iocsh fragments in `commonIocsh-verification-procedure.md`; and the
  record rules in `documentation-upkeep-procedure.md`.
- The verification and the deployment of the built products live in the
  `epics-env-pipeline` skill (`verification.md`, `layer3.md`, `distribution.md`).
- The memory of one release lives in its register, `docs/milestone-<release>.md`.

Where a skill still differs from this file on five points, this file stands
until the skill is corrected (the request to the skills' owner is recorded in
the register): the
version value is set when the line opens, not on release eve; the change log
keeps this repository's form; an issue of the release milestone closes on the
release branch; the master push and the tag push are separate rows; the next
line opens by a separate decision.

A release runs bottom-up: base and pvxs, the Layer 1 modules, the Layer 2 and
Layer 3 modules, the combined stack, the release. It reads top-down: this file,
then the file each step names. The same module procedure repeats at every
size: one module, one layer, the three layers together.

## Phases

| Phase | Steps | Tags | What runs |
| :-- | :-- | :-- | :-- |
| 1. Preparation | 1 to 6 | none | the survey, the census, the decisions, and the Layer 1 modules |
| 2. Pre-tag test | 7 to 9 | the companion tags at the end | the Layer 2 and Layer 3 modules, the rehearsal of the combined stack, the companion tags |
| 3. Final release | 10 to 11 | all companion tags exist | the candidate, the release verification, and the Layer 1 merge, tag, and release |
| 4. After the release | 12 | all | the next line and the distribution products |

## Order

1. Open the line: `release-N` from master, the register reset from the master
   generation into `docs/milestone-N.md` (`milestone-tracking`, Reset; the close
   of the previous release reset its register into that master generation), and
   the version value set in `configure/CONFIG_SITE` in the first commits (the
   branch-open rule of `epics-env-pipeline`).
2. List the modules: every `SRC_TAG_<KEY>` of the three repositories,
   `SRC_TAG_BASE` included. Each ends with one recorded outcome: IN, HOLD, or
   unchanged (`module-bump-procedure.md`, Stage 5 and Record discipline). The
   outcome decides only whether the pin moves; every module runs the whole
   cycle of steps 6 and 7.
3. Survey every module and locate each pin (`module-bump-procedure.md`,
   Stages 1 and 2; the layer table names the survey tool of each layer and its
   completeness test).
4. Take the census and judge the break surface of every candidate (Stages 3 and
   4); the owner decides IN or HOLD (Stage 5). Base and pvxs are one track: a
   bump re-examines their carries (`upstream-fix-carry-procedure.md`, Bump
   obligation). A fix that only production hardware can show is proven first by
   `upstream-fix-verification-procedure.md`.
5. Order all the modules: EPICS base first, pvxs with it, then the dependency
   order of `build.<module>` in `configure/CONFIG_MODS_DEPS` from the bottom up,
   and re-pins of identical code last. The order is a dated decision in the
   register.
6. Run one cycle per Layer 1 module, base and pvxs included, whatever its
   outcome: the module issue and the plan review (`module-bump-procedure.md`,
   Roles); the owner's acceptance and the separate implementation
   authorization (`milestone-tracking`, the plan procedure); the commit of the
   accepted plan; the pin change and its commit, for an IN module; the push of
   the candidate, the tip that carries the plan commit and any pin change,
   because the guests fetch it from origin; the clean rebuild of the module
   and its dependents and the guest verification (Stage 6); the results in the
   register; the commit and push of the results; the issue closed on the
   release branch; and the lessons written into the procedures
   (`documentation-upkeep-procedure.md`). Each commit and push has its own
   authority (`git-workflow`). A HOLD or unchanged module records in the
   register why its pin did not move.
7. Carry every Layer 2 and Layer 3 module through the same cycle, whatever its
   outcome, in the dependency order of each repository; Layer 3 does not wait
   for Layer 2. What differs by layer is the one table in
   `module-bump-procedure.md`. This
   repository's register keeps each companion module's name and state and a
   pointer to that repository's latest milestone file; the plan and the results
   are there.
8. Rehearse the combined stack before any companion tag: with every companion
   module Done and each tip pushed to its origin, build the three tips together
   on fresh guests of the default operating systems of the module checks
   (`module-bump-procedure.md`, Stage 6, the guest section), with the operators
   of the layer table, and run `make check.deps` and
   `make check.env`. Record the result in the Verification Results of the
   companion gates of the register and send it to each companion session.
9. Each companion repository merges its release line, confirms with
   `git diff --stat` that the merge tree equals the built commit or differs from
   it by documentation files only (the files under `docs/`, README files, and
   the change log), creates its annotated tag, and pushes, each action under
   its own authority (`module-bump-procedure.md`, Roles; `git-workflow`), and
   sends a notice after each push that names the merge commit and that diff
   result. The Layer 1 agent observes the line and the tag
   with `git ls-remote`, including the peeled tag, and closes the gates.
10. Prepare the release (`release-cycle`, readiness): the Integrated Verification
    re-runs on the combined tree, the version check, the `ChangeLog.md` entry in
    this repository's form (`### <version> <date> <name> <email>`, dated to the
    day of the merge and tag), the README and book paths that name the release,
    and the production environment tests of the two products
    (`epics-env-pipeline`: `verification.md`, and `layer3.md` for the internal
    product). The common iocsh fragments are checked by
    `commonIocsh-verification-procedure.md`. The readiness-evidence commit is
    the candidate. Until the `release-cycle`
    skill carries it, the candidate rule is stated here: a later commit that
    changes only evidence, documentation, or tools that no build or CI file
    references leaves the candidate valid once the comparison of its inputs
    with the tested source is recorded; any other change reopens the checks it
    maps to.
11. Execute and verify the release in the order of `release-cycle` (execution,
    Release Verification, and cycle close) with the rows of the register's
    release plan, each row with its own authority (`git-workflow`) and a
    checkpoint commit after each mutation. The master push and the tag push are
    separate rows (one of the five points above). At the close the register is
    reset into the next generation (`documentation-upkeep-procedure.md`).
12. After the release: the procedures of this repository, the archive, and the
    release references of the skills are reconciled in one pass
    (`documentation-upkeep-procedure.md`, After the release); the next release
    line opens by a separate dated decision; and the distribution products are
    built from the released tags by the pipeline (`distribution.md`), outside
    this repository.
