# Site Modules - General Procedure

The repository-specific rules for including site modules in an EPICS-env release. Their sources are prepared with the EPICS-env sources before the survey. The combined inventory follows steps 2 to 7 of `release-procedure.md`: listing, survey, compatibility decisions, dependency order, module cycles, and release readiness. The site modules build into the same installed tree once their dependencies exist.

- The site module repository holds the make system (`configure/`, `tools/`, `Makefile`), the files of EPICS-env copied, or adapted to two modules on an installed tree, as its README, Make Rules, lists, and the downstream patches of its modules (`patch/`). Its maintainer names its URL, `<site_repository>`, and the commit to build, authorizes each commit and push, and receives the report of each build.
- Every other piece of work on a site module follows the file that holds the rule, as for a module of EPICS-env: a newer version in `module-bump-procedure.md`, a downstream patch in `upstream-fix-carry-procedure.md`, a change of the make rules as the README of the site module repository, Make Rules, sets out.

## Source preparation

The Executor prepares and surveys the site sources under the roles and
interaction mode in
[`release-procedure.md`, Roles and interaction](release-procedure.md#roles-and-interaction).
The selected site repositories belong to the Maintainer's starting scope;
their separate location does not require a separate confirmation at each module.

At release step 2, clone the maintainer-selected site repository alongside
EPICS-env and check out its selected commit. Read `configure/RELEASE` in both
repositories and their `RELEASE.local` overrides. Resolve each module's source
URL, repository name, pin, and version from those declarations.

Clone every declared module into `<module>-src` under its owning checkout and
check out the effective pin using Git directly. Record the resolved commit.
For an existing source checkout, verify its origin and HEAD against the
selected source and pin before using it. Preserve a dirty checkout and prepare
a separate source directory when it cannot serve as the selected revision.
No installed tree or make action is required for this preparation.

For EPICS base, initialize and check out the submodules recorded by the
selected pin, matching `configure/RULES_BASE`, `clone.base`. Verify their
revisions before declaring source preparation complete. This also applies to
an existing base checkout: `make init` skips an existing source directory
and does not initialize its missing submodules.

Record both owning repository revisions. The inventory records the owning
repository, key, effective pin, version, resolved source commit, and local
overrides for each module. Step 2 is complete when this current baseline
covers every declared module and the required submodule revisions are checked;
adoption and retention outcomes belong to step 4.

Run the survey for both inventories in step 3. Apply the evidence and
completeness requirements of `module-bump-procedure.md`, Stage 1, to every
module: inspect both the latest release tag and the default branch HEAD,
including branch commits after the tag. Where the survey tool cannot handle
a repository, obtain the same evidence directly with Git. An inaccessible
repository is incomplete, not evidence that no changes exist.

Step 4 searches both source checkouts for dependencies and consumers of every
module, including unchanged and HOLD modules and site consumers of EPICS-env
modules. API/ABI comparison applies to the newer upstream candidates.
Step 5 places the site modules after their
dependencies in the combined order. These steps precede the baseline build;
the installed-tree confirmation follows when the test machines are ready.

## Build

Build site modules during step 6, in the dependency order of step 5, on each release test machine. Use the sandbox and user that built the shared tree. `<sandbox>/EPICS-env` holds its EPICS-env checkout; `<tree>` is the installed tree it reports. Prepare `<sandbox>/<repository_name>` at the site candidate recorded in the module plan, reusing a matching checkout or cloning it when absent. Set the installation path according to that candidate's README and verify that its `INSTALL_LOCATION_EPICS` resolves to `<tree>`; do not infer its input convention from another revision. The tree-based convention in `docs/src/procedures/add-site-modules.md` uses `INSTALL_LOCATION=<tree>` in `configure/CONFIG_SITE.local`.

For initial installation of the site modules as consumers, the book page gives
the following sequence from the site checkout. Their own cycles then use the
module-specific rebuild and dependent checks of `module-bump-procedure.md`,
Stage 6, in the owning checkout; installation alone does not complete a cycle.

```
make init
make patch
make conf
make check.module-deps
make build
make install
make symlinks
```

There are no vendor libraries; the modules install into `<tree>/modules/<module>-<version>`. `make check.module-deps` exits 2 with `Strict dependency check failed` when it has findings: a finding that names a file of a module source goes into the report, and the build goes on; any other finding is corrected in `configure/` of the repository first. On a Debian 13 host with 8 cores the site modules take about 1 minute.

The build is good when, in the clone, `LC_ALL=C make exist.modules LEVEL=1 | grep -e siteApps -e unidrv` prints the four lines of the book page, the `<module>-<version>` directory and the link of each site module, `make check.deps` and `make check.env` exit 0, and `git -C <sandbox>/<repository_name> rev-parse HEAD` prints the commit. Record that commit, the commit of EPICS-env that built the tree, the facts of the baseline as Test machines lists them, taken from the record of the baseline, and the findings of `make check.module-deps` in `<sandbox>/EPICS-env/work/site-modules/report.md` (`work/` is gitignored); that file is the report to the maintainer of the site module repository.

## Cycle evidence

Every site module has the same plan, decision, issue, results, and closure as
an EPICS-env module. Keep their status in the release record and detailed local
logs in `work/`; a standalone site report does not replace the release record.
Use the selected pins when interpreting the book's example version strings.
Keep private repository URLs and access details in the local report.

Before using `tools/module-check/` for a site cycle, verify its targets and
repository assumptions against the selected site candidate at step 5a.
An EPICS-env script run does not prove a site build or site patch round trip.
Where a script assumes EPICS-env, execute the equivalent real operations in
the site checkout and retain their logs: clean rebuild, dependent rebuilds,
installed-tree checks, and representative IOC startup.

Run the site patch round trip on one test machine in a separate, fresh
checkout of the recorded site candidate. Configure that checkout to use the
shared installed tree, following the selected candidate's installation rules.
Initialize its module sources at their pins, apply the patches, then revert
them. Record the exit status of each operation and the source status of every
declared module. All three operations must exit 0, and every module source
must finish with no tracked or untracked changes. Do not build, install, or
configure module sources in this checkout; those actions can change the
source status independently of the patches.

Use the book's Verification section for the site IOC and the patch state of
the build checkout. Its revert-and-apply check leaves patches applied for
building; it does not replace the fresh-checkout apply-and-revert round trip.
Also run the EPICS-env loader suite against the shared tree.

Record both repository commits and all module pins with the results. At release
readiness repeat site installation and verification on the final test tree
before the whole-tree checks. Both commits are inputs to the release candidate
comparison (`release-procedure.md`, Test machines).
