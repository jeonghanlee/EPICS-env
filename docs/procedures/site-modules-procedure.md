# Site Modules - General Procedure

The entry for the site modules of a facility: two more modules, from a site module repository outside EPICS-env, built into the installed tree of a test machine the way the baseline of that tree is built (`release-procedure.md`, Test machines). Everything else is the same: the make rules, the targets, and the checks are those of EPICS-env, and the tree holds EPICS base and the modules of EPICS-env.

- The site module repository holds the make system (`configure/`, `tools/`, `Makefile`), the files of EPICS-env copied, or adapted to two modules on an installed tree, as its README, Make Rules, lists, and the downstream patches of its modules (`patch/`). Its maintainer names its URL, `<site_repository>`, and the commit to build, authorizes each commit and push, and receives the report of each build.
- Every other piece of work on a site module follows the file that holds the rule, as for a module of EPICS-env: a newer version in `module-bump-procedure.md`, a downstream patch in `upstream-fix-carry-procedure.md`, a change of the make rules as the README of the site module repository, Make Rules, sets out.

## Build

Build the site modules on each test machine, in the sandbox that holds the tree, as the user who built it: `<sandbox>/EPICS-env` is the checkout that built the tree and `<tree>` is what `make print-INSTALL_LOCATION_EPICS` prints there. Clone the site module repository into `<sandbox>/<repository_name>`, where `<repository_name>` is the last element of `<site_repository>` without `.git`, check out the commit the maintainer names (the tip of master unless named), set the install location to the tree (`INSTALL_LOCATION=<tree>` in `configure/CONFIG_SITE.local`; `make print-INSTALL_LOCATION_EPICS` prints `<tree>`), and build step by step as `docs/src/procedures/add-site-modules.md` sets out, with the targets of this repository from its top:

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
