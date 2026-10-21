# Release - General Procedure

The entry for a release of the environment that two repositories carry:
EPICS-env and the site module repository. This file holds
the order of a release and names, at each step, the file that holds the rule.
It states a rule of its own only where no other file holds it.

- The general rules of any release live in the owner's skills: `release-cycle`
  (the phases of a release), `milestone-tracking` (the register), and
  `git-workflow` (every git and GitHub action and its authority).
- The work of this repository lives in `docs/procedures/`: one module in
  `module-bump-procedure.md`, with its table of what differs by repository;
  the base and pvxs carries in `upstream-fix-carry-procedure.md`; a fix that
  can be seen only on production hardware in
  `upstream-fix-verification-procedure.md`; the common iocsh fragments in
  `commonIocsh-verification-procedure.md`; and the record rules in
  `documentation-upkeep-procedure.md`.
- The verification and the deployment of the built products live in the
  `epics-env-pipeline` skill (`verification.md`, `site-modules.md`,
  `distribution.md`).
- The memory of one release lives in its register, `docs/milestone-<release>.md`.
- The checklist of a release, which names each check and the file that holds
  its rule, is `release-checklist.md`.
- The two products of a release: the public product is the EPICS-env tree
  that the CI workflows build and the distribution ships; the internal product
  is that tree with the modules of the site module repository.

Where a skill differs from this file, this file stands until the skill is
corrected; the request to the skills' owner and its reply are recorded in the
register when they are made. The differences known so far: the version value
is set when the line opens, not on release eve; the change log keeps this
repository's form; an issue of a module closes on the release branch, not
after the push to the default branch, and the issue that tracks the release itself is the
exception, closed after the release objects exist; the master push and the tag push are
separate rows; the next line opens by a separate decision; every guest comes
from a request to the cloud-provision session, where the pipeline skill
provisions its own machine; the release has the two repositories named above,
where the pipeline skill still builds and gates a repository the release no
longer carries; and the pipeline skill's reference for the site module
repository is `site-modules.md` here, under an older file name there.

A release runs bottom-up: base and pvxs, the EPICS-env modules, the site
modules, the combined stack, the release. It reads top-down: this file, then
the file each step names. The same module procedure repeats at every size:
one module, one repository, the two repositories together.

This session creates no guest. Every step that needs a guest asks the
cloud-provision session for it with a resource request
(`module-bump-procedure.md`, Stage 6, the guest section): cloud-provision
manages the computing resources, creates the guests, and shuts them down when
the request is finished.

## Phases

| Phase | Steps | Tags | What runs |
| :-- | :-- | :-- | :-- |
| 1. Preparation | 1 to 6 | none | the survey, the census, the decisions, and the EPICS-env modules |
| 2. Pre-tag test | 7 to 9 | the site tag at the end | the site modules, the rehearsal of the combined stack, the site tag |
| 3. Final release | 10 to 11 | the site tag exists | the candidate, the release verification, and the EPICS-env merge, tag, and release |
| 4. After the release | 12 | all | the next line and the distribution products |

## Order

1. Open the line: `release-N` from master, the register reset from the master
   generation into `docs/milestone-N.md` (`milestone-tracking`, Reset; the close
   of the previous release reset its register into that master generation), and
   the version value set in `configure/CONFIG_SITE` in the first commits (the
   branch-open rule of `epics-env-pipeline`), and the line pushed to origin (`git-workflow`, Push scope).
2. List the modules: every `SRC_TAG_<KEY>` of the two repositories,
   `SRC_TAG_BASE` included. Each ends with one recorded outcome: IN, HOLD, or
   unchanged (`module-bump-procedure.md`, Stage 5 and Record discipline). The
   outcome decides only whether the pin moves; every module runs the whole
   cycle of step 6 or step 7, by its repository.
3. Survey every module and locate each pin (`module-bump-procedure.md`,
   Stages 1 and 2; the repository table names the survey tool of each
   repository and its completeness test). A site module may be surveyed, and
   decided, at the start of its own cycle (step 7), before its plan.
4. Take the census and judge the break surface of every candidate (Stages 3 and
   4); the owner decides IN or HOLD (Stage 5). Base and pvxs are one track: a
   bump re-examines their carries (`upstream-fix-carry-procedure.md`, Bump
   obligation). A fix that only production hardware can show is proven first by
   `upstream-fix-verification-procedure.md`.
5. Order all the modules: EPICS base first, pvxs next as the same track (the
   carries are examined together, and its cycle follows the cycle of base),
   then the dependency order of `build.<module>` in `configure/CONFIG_MODS_DEPS`
   from the bottom up (a module after every module its `_DEPS` lists, and
   modules with no order between them in the order of that file), and last the
   modules whose new pin carries code identical to the old pin. The order is the owner's
   dated decision in the register. The site modules follow in the order of
   step 7.

5a. Check the tools that every module cycle uses: read the guest check
   scripts and the make targets against what Stage 6 and the repository table
   of `module-bump-procedure.md` say they do, for every repository of the
   release. A difference is fixed as one piece of work, with its own plan
   review, acceptance, commit, push, and tests, after the cycle of the first
   module has made the guests the tests need and before the cycle of the
   second module, because every later cycle runs these tools; the cycle of
   the first module uses the scripts as they are, works around a difference it
   meets by hand, and that difference is fixed as this work after it. A
   difference that concerns another repository is fixed the same way, and its
   tests run on the guests requested for that repository before its first
   module cycle: those guests are requested after the last module cycle of
   this repository closes, built at the tip of that repository's master while
   its release line is not open, and then serve its module cycles. The tools
   live in `tools/module-check/` of this repository and take a checkout path
   already; on the checkout of another repository they stop at the make
   targets of this repository (`check.module-deps`), fetch and clone without
   the agent and the proxy that repository needs, and assume root, and the
   fix removes those three. The work is recorded in the register as a row of
   its own.

6. Run one cycle per EPICS-env module, base and pvxs included, whatever its
   outcome: the module issue and the plan review (`module-bump-procedure.md`,
   Roles); the owner's acceptance and the separate implementation
   authorization (`milestone-tracking`, the plan procedure); the commit of the
   accepted plan; the pin change and its commit, for an IN module whose pin is
   not yet at the decided value; the push of the candidate, the tip that
   carries the plan commit and any pin change, because the guests fetch it
   from origin; the clean rebuild of the module and its dependents and the
   guest verification (Stage 6); the results in the register; the commit and
   push of the results, with their landing on origin observed; the issue
   closed on the release branch, with its body synced and its closing comment
   posted as `git-workflow` sets out, and its closed state read back; the
   closure commit and push, which record that landing and the closed issue and
   mark the module Complete (`milestone-tracking`, the implementation and
   closure procedure); and the lessons written into the procedures
   (`documentation-upkeep-procedure.md`), in a commit of their own after the
   closure. Each commit and push has its own authority (`git-workflow`). A HOLD
   or unchanged module records in the register why its pin did not move. The
   guests of the cycle are requested once, with the candidate of the first
   module (`module-bump-procedure.md`, Stage 6, the guest section).
7. Carry every site module through the same cycle, whatever its outcome, in
   the order of their dependencies where the site module repository declares
   them, and otherwise in the order the register records as a dated decision.
   The modules of the two repositories are carried one after another, in one
   order: the EPICS-env modules of step 6, then the site modules. This session
   runs them as it runs an EPICS-env module, asks cloud-provision for their
   guests, and records them in this repository's register; the first site
   module opens the site repository's `release-N` from master, once the owner
   confirms that no other session writes there; the first push of that line
   uses the push authority of `git-workflow`. What differs by repository is
   the one table in `module-bump-procedure.md`.
8. Rehearse the combined stack before the site tag: with every site module
   Complete and each tip pushed to its origin, build the two tips together on
   fresh guests of the default operating systems of the module checks,
   requested from cloud-provision (`module-bump-procedure.md`, Stage 6, the
   guest section), with the selectors of the repository table, and run
   `make check.deps` and `make check.env`. Record the result in the register,
   with the module count of the installed tree that passes (one link per
   module: `find <tree>/modules -mindepth 1 -maxdepth 1 -type l | wc -l`): the
   inventory
   check of the release verification expects that count, which changes between
   releases as modules are added and removed.
9. Bring the local master of the site module repository to its remote, merge
   its release line, confirm with `git diff --stat` that the merge tree equals
   the built commit or differs from it by documentation files only (the files
   under `docs/`, README files, and the change log), create its annotated tag
   on the merge commit, and push master and the tag, each action under its
   own authority (`git-workflow`). The tag name is the release number, and the
   merge subject and the tag message follow the previous release of that
   repository. A repository whose release line holds no commit beyond master
   is not merged, and its tag goes on the master commit that was built. Then
   observe master and the tag with `git ls-remote`, including the peeled tag.
10. Prepare the release (`release-cycle`, readiness): the Integrated
    Verification re-runs on the combined tree, the version check
    (`ENV_RELEASE_VERS` in `configure/CONFIG_SITE` equals the release number,
    and `make -s print-ENV_RELEASE_VERS` prints it), the
    `ChangeLog.md` entry in this repository's form
    (`### <version> <date> <name> <email>`, the email in angle brackets as in the
    existing entries, dated to the day planned for the
    merge and tag; when the merge and tag fall on another day, only that date
    changes, under the candidate rule below), the README and book paths that
    name the release (found by a search for the previous release number over
    `README.md` and `docs/src`), and the production environment tests of the two
    products (`epics-env-pipeline`: `verification.md`, and `site-modules.md` for
    the internal product), on guests requested from cloud-provision as in step 8,
    for the default operating systems of the module checks or the set the owner
    extended, and every other operating system that the internal product ships
    on (Debian 12 today), since the site module repository has no CI workflows;
    the other operating systems of the public product are covered by its CI
    workflows.
    Where the pipeline skill gates or builds a repository the release no longer
    carries, this file stands (the differences above).
    The common iocsh fragments are checked by
    `commonIocsh-verification-procedure.md`. The readiness-evidence commit is
    the candidate. Until the `release-cycle` skill carries it, the candidate
    rule is stated here: a later commit that changes only evidence,
    documentation, or tools that no build or CI file references leaves the
    candidate valid once the comparison of its inputs with the tested source
    is recorded; any other change reopens the checks it maps to. A workflow
    that ignores documentation-only pushes has no run at a documentation-only
    candidate; its run at the last commit that changes code stands, once that
    comparison is recorded.
11. Execute and verify the release in the order of `release-cycle` (execution,
    Release Verification, and cycle close) with the rows of the register's
    release plan, each row with its own authority (`git-workflow`) and a
    checkpoint commit after each mutation. The master push and the tag push are
    separate rows (one of the differences above). The merge takes the tip of the
    release line after its last pre-merge checkpoint, not the candidate, and the
    comparison of that tip with the candidate is recorded under the candidate
    rule of step 10. At the close the register is
    reset into the next generation (`milestone-tracking`, Reset; the closed
    register is read as `documentation-upkeep-procedure.md` sets out).
12. After the release: the procedures of this repository, the archive, and the
    release references of the skills are reconciled in one pass, and the skills
    items of the lessons row are sent to the session that owns the skills
    repository once the owner approves the request (ask the owner which
    session), both as `documentation-upkeep-procedure.md`, After the release,
    sets out. The owner deletes the release line of the release before the
    previous one in each repository of the release, counted in that
    repository's own line history, locally and on origin, once its tag is on
    origin and it is merged, since the tag keeps its content; no delegation scope covers the
    deletion, and a row of the release plan may carry it as soon as the release
    objects exist. The next release line opens by a separate dated decision,
    and the distribution products are built from the released tags by the
    pipeline (`distribution.md`), outside this repository.
