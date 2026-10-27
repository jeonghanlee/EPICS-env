# Site Modules - General Procedure

How the site modules of a facility are built into an installed EPICS-env tree, kept in step with the make rules of EPICS-env, and moved to newer versions, with the same procedures as the modules of EPICS-env.

## Scope

This document covers the site module repository: a repository outside EPICS-env whose `configure/` and `tools/` follow the make rules of EPICS-env, and whose modules install beside the modules of an installed tree. It holds the commands of a build of the site modules and names the procedure of every other piece of work on them, with the substitutions a site module needs; the rules stay in the procedure that owns them.

**Out of scope:** the modules of EPICS-env, the release of EPICS-env, and the sources of the site modules, which live in their own repositories.

## The site module repository

The repository holds the make system (`configure/`, `tools/`, `Makefile`), the downstream patches of its modules (`patch/`), a `docs/` directory, a README, and a license; it holds no procedure of its own, and this directory's procedures apply to it as to a module of EPICS-env. The maintainer, who is the maintainer of the site module repository, names its URL, `<site_repository>`, authorizes each commit and push, and receives the report of each build. The URL of a module is what `make -s print-SRC_GITURL_<KEY>` prints in a clone, composed from `SRC_URL_EPICSMODULES` and `SRC_NAME_<KEY>` of `configure/RELEASE`; the `##` comment line above each pin there holds the date of the decision that set the pin.

Its `INSTALL_LOCATION` names an installed tree, `<tree>`, the directory that holds `base`, `modules`, and `setEpicsEnv.bash`: the value that `make print-INSTALL_LOCATION_EPICS` prints in the EPICS-env checkout that built the tree. An action target stops with `INSTALL_LOCATION must name an installed EPICS-env tree with a base directory` when the tree has no `base`. `make print-<VARIABLE>` and the other query targets run without the tree.

## Build

The build runs on a test machine as `release-procedure.md`, Test machines, sets out: `<sandbox>` is its sandbox, `<sandbox>/EPICS-env` the EPICS-env checkout that built the tree, and `<tree>` the installed tree. In a release the tree is built at the candidate. Outside a release it is built at the newest release tag of EPICS-env, which `git -C <sandbox>/EPICS-env tag --list '[0-9]*' --sort=-v:refname | head -1` prints (the tags of the earlier `v` form are not releases of this form); a change of a procedure after that tag does not move the tree, and the maintainer names a commit when a newer tree is needed. The clone of the site module repository is `<checkout>` = `<sandbox>/<repository_name>`, where `<repository_name>` is the last element of `<site_repository>` without `.git`, and every command runs from its top, as the user that owns the tree.

The output of every command is kept as a log in `<sandbox>/EPICS-env/work/site-modules/`, created with `mkdir -p` (`work/` is gitignored): `<target>.log` for each target of the build, `conf.show.log` included; `check-<n>-<target>.log` for each target of a check, where `<n>` is the number of the check; and `check-3-status.log`, `check-4-iocsh.log`, and `check-4-iocsh-n.log` for the three commands of the checks that are not make targets. The IOC check runs in the subdirectory `site-ioc/` of that log directory.

1. Clone the repository and name the tree:

   ```
   git clone <site_repository> <checkout>
   echo "INSTALL_LOCATION:=<tree>" > <checkout>/configure/CONFIG_SITE.local
   ```

   `INSTALL_LOCATION=<tree>` sets the same value. `make print-INSTALL_LOCATION_EPICS` prints `<tree>`, and `make print-SUDO_INFO` prints `0` when the user can create or write the `modules` directory of the tree.

2. `make init` clones each module at its tag into `<module>-src`. `make patch` applies the downstream patches of `patch/`, with one `Patching` line per patch file and one `patching file` line per file the patch changes. `make conf` prints nothing and writes `RELEASE.local` and `CONFIG_SITE.local` at the top of the clone and the `CONFIG_SITE.local` of each module; `make conf.show`, a target of the step with its own log, prints those files.

3. `make check.module-deps` audits the declared dependencies of each module against its sources, as `module-bump-procedure.md`, Stage 6, step 2, does for a module of EPICS-env. It exits 2 with `Strict dependency check failed` when a source names a token that no module or alias matches. A finding comes from the module source when the file it names is under `<module>-src/`; a finding that names `configure/` of the repository is a declaration of `CONFIG_MODS_DEPS` or `CONFIG_MODS_AUDIT` to correct before the build goes on. A finding from the module source is a question for the maintainer of that module: the build continues to step 4 while the question is open, and the finding goes into the report.

4. `make build` builds and installs each module into `<tree>/modules/<module>-<version>` and writes its loader metadata `cfg/iocsh.conf`; it exits 0 and leaves that file in each installed module. When the metadata cannot be written, `iocsh_metadata.bash` names the reason, the build stops, and the reason goes into the report. `make symlinks` creates the unversioned links and prints nothing.

## The checks

Run after the build, in `<checkout>`:

1. `LC_ALL=C make exist.modules LEVEL=1` lists the modules directory; each site module has its `<module>-<version>` directory and its link.
2. `make check.deps` and `make check.env` exit 0 on the whole tree (`release-procedure.md`, Test machines, names them as the gates of a good tree). The `SO ... / ALL` count that `check.deps` prints is the count of the baseline plus the libraries of the site modules, which shows that they are in its scan.
3. `make patch.revert` and `make patch` exit 0, and `git -C <module>-src status --short` of each module that the `patch:` list of `configure/RULES_SRC` names lists the files of its patch and nothing else; a file that the patch adds appears as `??`, and the files of a patch are its `+++` lines.
4. An IOC that loads the site modules through the installed loader reaches `iocRun`. In `site-ioc/` of the log directory, write `st.cmd`: one `module` line per site module, after a `module` line for each module of the tree whose device support the templates of the site modules name in their `DTYP` fields, then `iocInit`. For the current module set it is these four lines, `ether_ip` being the module of the tree whose device support the `siteApps` templates use:

   ```
   module ether_ip
   module siteApps
   module unidrv
   iocInit
   ```

   Then, from that directory, in a shell that has sourced `<tree>/setEpicsEnv.bash`, run `printf 'exit\n' | iocsh.bash st.cmd` and require exit 0 and the line `iocRun: All initialization complete`; then run `iocsh.bash -n st.cmd`, which prints the generated startup: the line `# <module> <version>` of each module names the version it loaded, followed by the `dlload` lines of its libraries, and a module without a library, as `siteApps`, prints its line and no `dlload`. Both outputs are logs of the check.

A build is good when every target of the build exits 0, except `make check.module-deps` as step 3 of the build allows, and the four checks pass. The report is the file `<sandbox>/EPICS-env/work/site-modules/report.md`: one line per target and check with its exit status, then the findings of step 3 and the reason of a stopped step 4, the path of the log directory, and, when the tree was built for this work outside a release, the facts of the baseline that `release-procedure.md`, Test machines, says to record. The maintainer names where the report goes, and passes a finding of a module source to the maintainer of that module.

## Keeping the make rules in step

When the `configure/` or `tools/` of EPICS-env change, the site module repository follows in a commit of its own. The copy runs from the EPICS-env checkout into the same paths of the site module repository, and `diff <epics_env_file> <site_file>` shows what differs:

- The generic rule files are byte-identical copies and are copied again: `Makefile`, and in `configure/` `CONFIG`, `CONFIG_MODS`, `CONFIG_MODS_AUDIT`, `RULES_MODS`, `RULES_MODS_BUILD`, `RULES_MODS_CONF_AUTO`, `RULES_MODS_AUDIT`, `RULES_DEPS_CHECK`, `RULES_ENV_CHECK`, and `RULES_VARS`, and in `tools/` `audit_module_deps.bash`, `check_deps.bash`, `check_env.bash`, `iocsh_elf.bash`, `iocsh_metadata.bash`, and `revert_patch.bash`. `CONFIG_VARS` and `RULES_FUNC` are copies without the lines of EPICS base and pvxs.
- The files adapted to the site modules on an installed tree are compared with their EPICS-env originals: `CONFIG_SITE`, `CONFIG_SRC`, `CONFIG_BASE`, `CONFIG_GOALS`, `CONFIG_MODS_DEPS`, `CONFIG_MODS_TYPES`, `CONFIG_MODS_IOCSH`, `RELEASE`, `RULES`, `RULES_SRC`, `RULES_PATCH`, `RULES_MODS_CONFIG`, and `RULES_INSTALL`. Every line that the EPICS-env original changed since the last copy is brought over, unless it names EPICS base, pvxs, a module of EPICS-env, the install location of a tree to be built, or the CI of EPICS-env. The known differences, which stay: the `##` comments written for the site modules, the targets left out (those of EPICS base, commonIocsh, the environment scripts, the version file, and the `github` targets), and the C17 bridge of `CONFIG_MODS_DEPS`, which names modules of EPICS-env.
- Not carried, so their absence is in step: `RULES_BASE`, `RULES_USER`, `configure/os/`, and in `tools/` `README.md`, `gen_dep_graph.bash`, `iocsh.bash`, `module-check/`, `prep-vendors.bash`, `pv_snapshot.bash`, `pvs_gets.bash`, `tc32-expansion-query.cpp`, `update-release.bash`, and `verify_fix_build.bash`. The generated and local files (`configure/*.mk`, `*.local`) are outside the comparison.
- Before the commit of the copy, `git diff --check` and the scan for non-ASCII characters, `LC_ALL=C grep -nP '[^\x00-\x7F]' <file>`, run on the changed files; a line they reject is corrected in EPICS-env first, then copied.

After the copy, the Build and The checks above run once on the real path before the commit, as `documentation-upkeep-procedure.md` requires of a changed procedure.

## Moving a site module to a newer version

A site module moves to a newer tag by `module-bump-procedure.md`, with its names read from the `configure/RELEASE` of the site module repository and these substitutions. The files of every stage go to `work/<module>-bump/` of `<sandbox>/EPICS-env`.

- Stage 1: `tools/update-release.bash` reads the GitHub API, and the site repositories are not on GitHub. The survey of a site module is `git ls-remote --tags <module_url>`, where `<module_url>` is what `make -s print-SRC_GITURL_<KEY>` prints in `<checkout>`, with its output kept in `work/<module>-bump/survey.txt`. The command lists tags in name order, not version order, and prints a `^{}` line for an annotated tag, which is ignored. The dated decision names the tag it chose, and the `##` comment above the pin takes the date of that decision. The exit codes, `GITHUB_TOKEN`, the `Date` line, and the pitfalls of Stage 1 do not apply.
- Stage 2: the pin is `SRC_TAG_<KEY>` alone, because `SRC_VER_<KEY>` derives from it; the book's module pins page and the loader suite do not exist for the site modules, and the steps that name them do not apply.
- Stage 3: the reverse dependencies of a site module are the other modules of the site module repository, searched in `<checkout>`, and the IOC repositories that the maintainer names.
- Stage 6: `<commit>` is the candidate commit of the site module repository, fetched and checked out in `<checkout>`, and `<pin-commit>` is found in its history. The three scripts of The checks of that procedure are replaced by the Build and The checks of this procedure, with their logs under `work/<module>-bump/` with the names the Build gives them, and the representative IOC of step 3 is check 4.

## Adding a downstream patch to a site module

A patch to a site module follows `upstream-fix-carry-procedure.md` for its rule and its apply list: a patch file in `patch/` of the site module repository, a target triple in its `configure/RULES_PATCH`, and the entries in the `patch:` and `patch.revert:` lists of its `configure/RULES_SRC`, in the form of the module site patch of EPICS-env, `patch/measComp-tc32-chan-count.p0.patch` with its targets `patch.measComp.tc32.make`, `.apply`, and `.revert`. The site module repository has no `patch/README.md`; the comment above the targets in `configure/RULES_PATCH` holds the items that the README subsection of that procedure holds: the case, the effect without the patch, the reproduction, the change, the result with the patch, where it was tested, and the upstream status.
