# Site Modules - General Procedure

How the site modules of a facility are built into an installed EPICS-env tree, kept in step with the make rules of EPICS-env, and moved to newer versions, with the same procedures as the modules of EPICS-env.

## Scope

This document covers the site module repository: a repository outside EPICS-env whose `configure/` and `tools/` follow the make rules of EPICS-env, and whose modules install beside the modules of an installed tree. It holds the commands of a build of the site modules and names the procedure of every other piece of work on them; the rules stay in the procedure that owns them.

**Out of scope:** the modules of EPICS-env, the release of EPICS-env, and the sources of the site modules, which live in their own repositories.

## The site module repository

The repository holds the make system (`configure/`, `tools/`, `Makefile`), the downstream patches of its modules (`patch/`), and a README. It holds no procedure of its own: this directory's procedures apply to it as to a module of EPICS-env. The maintainer names its URL, `<site_repository>`, and the URL of each module is in its `configure/RELEASE`.

Its `INSTALL_LOCATION` names an installed tree, `<tree>`, the directory that holds `base`, `modules`, and `setEpicsEnv.bash`: the value that `make print-INSTALL_LOCATION_EPICS` prints in the EPICS-env checkout that built the tree. An action target stops with `INSTALL_LOCATION must name an installed EPICS-env tree with a base directory` when the tree has no `base`. `make print-<VARIABLE>` and the other query targets run without the tree.

## Build

The build runs in a clone of the site module repository, `<checkout>`, against a tree built as `release-procedure.md`, Test machines, sets out, as the user that owns the tree. In a release the tree is built at the candidate; outside a release, at the tag of the last release or at the commit the maintainer names. Every command runs from the top of `<checkout>`, and the output of each target is kept as a log, one file per command, in `work/site-modules/` of `<sandbox>/EPICS-env`, the checkout that built the tree.

1. Clone the repository and name the tree:

   ```
   git clone <site_repository> <checkout>
   echo "INSTALL_LOCATION:=<tree>" > <checkout>/configure/CONFIG_SITE.local
   ```

   `INSTALL_LOCATION=<tree>` sets the same value. `make print-INSTALL_LOCATION_EPICS` prints `<tree>`, and `make print-SUDO_INFO` prints `0` when the user can create or write the `modules` directory of the tree.

2. `make init` clones each module at its tag into `<module>-src`; `make patch` applies the downstream patches of `patch/`, one `Patching` line per file; `make conf` writes `RELEASE.local` and `CONFIG_SITE.local` at the top of the clone and the `CONFIG_SITE.local` of each module, and `make conf.show` prints them.

3. `make check.module-deps` audits the declared dependencies of each module against its sources, as `module-bump-procedure.md`, Stage 6, step 2, does for a module of EPICS-env. It exits 2 with `Strict dependency check failed` when a source names a token that no module or alias matches. A finding comes from the module source when the file it names is under `<module>-src/`; a finding in `configure/` of the repository is a declaration to correct before the build goes on. A finding from the module source is a question for the maintainer of that module: the build continues to step 4 while the question is open, and the finding goes to the maintainer with the result of the build.

4. `make build` builds and installs each module into `<tree>/modules/<module>-<version>` and writes its loader metadata `cfg/iocsh.conf`; the build fails when the metadata cannot be written (`iocsh_metadata.bash` names the reason). `make symlinks` creates the unversioned links.

## The checks

Run after the build, in `<checkout>`, with the output of each kept as a log in the same `work/site-modules/`, one file per command:

1. `LC_ALL=C make exist.modules LEVEL=1` lists the modules directory; each site module has its `<module>-<version>` directory and its link.
2. `make check.deps` and `make check.env` exit 0 on the whole tree (`release-procedure.md`, Test machines, names them as the gates of a good tree). The report of `check.deps` counts the executables and libraries it read, and the libraries of the site modules are in that count.
3. `make patch.revert` and `make patch` exit 0, and `git -C <module>-src status --short` of each patched module lists the files of its patch and nothing else; a file that the patch adds appears as `??`, and the files of a patch are its `+++` lines.
4. An IOC that loads the site modules through the installed loader reaches `iocRun`. In a directory outside the clone, write `st.cmd`; for the current module set it is these four lines, `ether_ip` first because the `siteApps` templates use its device support:

   ```
   module ether_ip
   module siteApps
   module unidrv
   iocInit
   ```

   Then, from that directory, in a shell that has sourced `<tree>/setEpicsEnv.bash`, run `printf 'exit\n' | iocsh.bash st.cmd` and require exit 0 and the line `iocRun: All initialization complete`. `iocsh.bash -n st.cmd` prints the generated startup; the line `# <module> <version>` before the `dlload` lines of each module names the version it loaded.

A build is good when every target of the build exits 0, except `make check.module-deps` as step 3 of the build allows, and the four checks pass. The report to the maintainer holds the result of each target and check, the findings of step 3, and the path of the log directory; when the tree was built for this work outside a release, the facts of the baseline that `release-procedure.md`, Test machines, says to record go in the same report.

## Keeping the make rules in step

When the `configure/` or `tools/` of EPICS-env change, the site module repository follows in a commit of its own:

- The generic rule files are byte-identical copies and are copied again: `CONFIG`, `CONFIG_MODS`, `CONFIG_MODS_AUDIT`, `RULES_MODS`, `RULES_MODS_BUILD`, `RULES_MODS_CONF_AUTO`, `RULES_MODS_AUDIT`, `RULES_DEPS_CHECK`, `RULES_ENV_CHECK`, and `RULES_VARS`, and the tools `audit_module_deps.bash`, `check_deps.bash`, `check_env.bash`, `iocsh_elf.bash`, `iocsh_metadata.bash`, and `revert_patch.bash`. `CONFIG_VARS` and `RULES_FUNC` are copies without the lines of EPICS base and pvxs.
- The files adapted to the site modules on an installed tree are compared with their EPICS-env originals and brought in line: `CONFIG_SITE`, `CONFIG_SRC`, `CONFIG_BASE`, `CONFIG_GOALS`, `CONFIG_MODS_DEPS`, `CONFIG_MODS_TYPES`, `CONFIG_MODS_IOCSH`, `RELEASE`, `RULES`, `RULES_SRC`, `RULES_PATCH`, `RULES_MODS_CONFIG`, and `RULES_INSTALL`.
- A change in a copied file that the whitespace check or the character set rule rejects is corrected in EPICS-env first, then copied.

After the copy, the build and the checks above run once on the real path before the commit, as `documentation-upkeep-procedure.md` requires of a changed procedure.

Each commit and push of the site module repository has its own authorization from the maintainer, as a commit of EPICS-env has.

## Moving a site module to a newer version

A site module moves to a newer tag by `module-bump-procedure.md`, with its names read from the `configure/RELEASE` of the site module repository. One stage differs: Stage 1 surveys with `tools/update-release.bash`, which reads the GitHub API, and the site repositories are not on GitHub, so the survey of a site module is `git ls-remote --tags <module_url>` and the dated decision names the tag it chose. The reverse dependencies of a site module (Stage 3) are the modules of the site module repository and the IOCs of the facility that load it.

## Adding a downstream patch to a site module

A patch to a site module follows `upstream-fix-carry-procedure.md` in the site module repository: a patch file in its `patch/`, a target triple in its `configure/RULES_PATCH`, and the entries in the `patch:` and `patch.revert:` lists of its `configure/RULES_SRC`, in the form of the module site patch of EPICS-env. The site module repository has no `patch/README.md`; the case of each patch is described in the comment above its targets in `configure/RULES_PATCH`.
