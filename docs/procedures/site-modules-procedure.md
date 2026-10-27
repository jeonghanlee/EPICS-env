# Site Modules - General Procedure

How the site modules of a facility are built into an installed EPICS-env tree, kept in step with the make rules of EPICS-env, and moved to newer versions, with the same procedures as the modules of EPICS-env.

## Scope

This document covers the site module repository: a repository outside EPICS-env whose `configure/` and `tools/` follow the make rules of EPICS-env, and whose modules install beside the modules of an installed tree. It names the procedure of each piece of work; the rules themselves stay in the procedure that owns them.

**Out of scope:** the modules of EPICS-env, the release of EPICS-env, and the sources of the site modules, which live in their own repositories.

## The site module repository

The repository holds the make system (`configure/`, `tools/`, `Makefile`), the downstream patches of its modules (`patch/`), its work register (`docs/milestone-<hash>.md`), and a README. It holds no procedure of its own: the procedures of this directory and the book pages apply to it as to a module of EPICS-env. Its `INSTALL_LOCATION` names an installed tree, the directory that holds `base`, `modules`, and `setEpicsEnv.bash`, and an action target stops when the tree has no `base`.

The commands are those of the book page `docs/src/procedures/add-site-modules.md`: clone, set the tree, `make init`, `make patch`, `make conf`, `make check.module-deps`, `make build`, `make symlinks`, and the checks `make check.deps`, `make check.env`, the patch round trip, and an IOC through the installed loader. The results of each run go into the work register of the site module repository, in the form of its existing entries; a check that fails is recorded there with its reason and the open question, and the register is the place a reader looks for the current result.

Each commit and push of the site module repository has its own authorization from the maintainer, as a commit of EPICS-env has.

## Keeping the make rules in step

When the `configure/` or `tools/` of EPICS-env change, the site module repository follows in a commit of its own:

- The generic rule files are byte-identical copies and are copied again: `CONFIG`, `CONFIG_MODS`, `CONFIG_MODS_AUDIT`, `RULES_MODS`, `RULES_MODS_BUILD`, `RULES_MODS_CONF_AUTO`, `RULES_MODS_AUDIT`, `RULES_DEPS_CHECK`, `RULES_ENV_CHECK`, and `RULES_VARS`, and the tools `audit_module_deps.bash`, `check_deps.bash`, `check_env.bash`, `iocsh_elf.bash`, `iocsh_metadata.bash`, and `revert_patch.bash`. `CONFIG_VARS` and `RULES_FUNC` are copies without the lines of EPICS base and pvxs.
- The files adapted to the site modules on an installed tree are compared with their EPICS-env originals and brought in line: `CONFIG_SITE`, `CONFIG_SRC`, `CONFIG_BASE`, `CONFIG_GOALS`, `CONFIG_MODS_DEPS`, `CONFIG_MODS_TYPES`, `CONFIG_MODS_IOCSH`, `RELEASE`, `RULES`, `RULES_SRC`, `RULES_PATCH`, `RULES_MODS_CONFIG`, and `RULES_INSTALL`.
- A change in a copied file that the whitespace check or the character set rule rejects is corrected in EPICS-env first, then copied.

After the copy, the commands of the book page run once on the real path before the commit, as `documentation-upkeep-procedure.md` requires of a changed procedure.

## Moving a site module to a newer version

A site module moves to a newer tag by `module-bump-procedure.md`, with its names read from the `configure/RELEASE` of the site module repository. One stage differs: Stage 1 surveys with `tools/update-release.bash`, which reads the GitHub API, and the site repositories are not on GitHub, so the survey of a site module is `git ls-remote --tags <module_url>` and the dated decision names the tag it chose. The reverse dependencies of a site module (Stage 3) are the modules of the site module repository and the IOCs of the facility that load it.

## Adding a downstream patch to a site module

A patch to a site module follows the book page `docs/src/procedures/add-module-site-patch.md` in the site module repository: a patch file in its `patch/`, a target triple in its `configure/RULES_PATCH`, and the entries in the `patch:` and `patch.revert:` lists of its `configure/RULES_SRC`. The case is recorded in the work register of the site module repository, which has no `patch/README.md`.
