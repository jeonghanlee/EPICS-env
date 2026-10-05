# Make targets by purpose

The top-level `Makefile` exposes every EPICS-env action as a make target. EPICS-env builds the Experimental Physics and Industrial Control System (EPICS) base and modules. Run
each target from the repository top as `make <target>`. A run with no target
prints the configuration variables, because `vars` is the default goal.

Targets that name a module use one of three spellings. The `Module` and `Key`
columns of [Module pins and dependencies](module-pins.md#module-repositories-and-pins)
list every module name and key:

- `<MODULE_KEY>` is the upper-case key from `configure/RELEASE`, such as
  `ASYN` or `SNCSEQ`.
- `<module>` is the source directory name without its `-src` suffix, such as
  `asyn`, `sequencer`, or `recsync`.
- `conf.<module>` targets use the names listed in
  [Source configuration targets](#source-configuration-targets); a few differ from the
  source directory name, such as `conf.sncseq` for `sequencer`.

Some targets read a variable that you pass on the make command line. This
command audits only the `asyn` module:

```bash
make audit.module-deps MODULE=asyn
```

[Variables set on the command line](configuration-variables.md#variables-set-on-the-command-line)
lists every such variable and its default.

## Pipeline aggregate targets

| Target | Runs |
| --- | --- |
| `init` | `init.base` and `init.modules`: clones EPICS base and every module at its pinned tag or commit |
| `patch` | Every `patch.*.apply` target, in a fixed order |
| `patch.revert` | Every `patch.*.revert` target, in the exact reverse order of `patch` |
| `conf` | `conf.base` and `conf.modules`: writes the site files that point each source tree at its install location and dependencies |
| `build` | `conf.base`, `build.base`, `conf.modules`, and `build.modules`: builds base and every module; module builds install as they complete |
| `install` | `install.base`, `install.modules`, `install.commoniocsh`, `install.iocsh`, and `src_version` |
| `symlinks` | `symlinks.modules`: creates an unversioned link for each installed module |
| `distclean` | `distclean.base`, `distclean.modules`, and `distclean.modulesgen`: removes the cloned source trees and `configure/MODULESGEN.mk` |

## Source checkout targets

| Target | Effect |
| --- | --- |
| `init.base`, `clone.base` | Clones EPICS base into `epics-base-src`, checks out its pinned tag, and initializes its submodules; skips an existing directory |
| `init.modules`, `clone.modules` | Runs the clone target of every module |
| `<MODULE_KEY>` | Clones one module and checks out its pinned tag or commit; skips an existing directory |
| `reconf.modules` | Removes and regenerates `configure/MODULESGEN.mk` |
| `remove.genmk`, `clean.genmk` | Removes every `configure/*.mk` file |
| `show.genmk` | Prints every existing `configure/*.mk` file; if `MODULESGEN.mk` is absent, also prints its current derived configuration without creating it |

## Upstream patch targets

| Target | Effect |
| --- | --- |
| `patch.base.pr.apply`, `patch.base.pr.revert` | Applies the EPICS base patches `patch/<base_version>-*.p0.patch`, the upstream fixes and the site patches, in sorted order, or reverts them in the reverse order |
| `patch.pvxs.commit.apply`, `patch.pvxs.commit.revert` | Applies the pvxs patches `patch/<pvxs_version>-*.p0.patch` in sorted order, or reverts them in the reverse order |
| `patch.<name>.apply`, `patch.<name>.revert` | Applies or reverts one fixed module patch; `<name>` is `mca`, `measComp`, `measComp.tc32`, `opcua`, `opcua.export`, `feed-core`, `QPC`, or `StreamDevice`. The `mca` targets act only on macOS and do nothing on Linux |
| `patch.<name>.make` | Writes the current source changes of that module as its patch file; `patch.mca.make` acts only on macOS |

Revert targets skip only confirmed unapplied patches and stop on conflicts,
partial application, missing required inputs, or unresolved states. Completed
reversals remain in effect after a later error. Optional empty patch sets and
platform-inactive targets succeed without changes.

## Source configuration targets

| Target | Effect |
| --- | --- |
| `conf.base` | `conf.base.site` and `conf.base.env` |
| `conf.base.site` | Removes `epics-base-src/configure/CONFIG_SITE_ENV`, which `conf.base.env` writes again, adds two linker lines to `configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64` when absent, and writes `epics-base-src/configure/CONFIG_SITE.local`: install location, linking with a run-time library search path (RUNPATH) relative to `$ORIGIN`, site version, and `PYTHON = python3` |
| `conf.base.env` | Writes `epics-base-src/configure/CONFIG_SITE_ENV`: time zone, Network Time Protocol (NTP) server, iocsh prompt and history, and input/output controller (IOC) log settings |
| `conf.modules` | `conf.release.modules`, `conf.modules.zero`, and `conf.modules.one` |
| `conf.release.modules` | Writes the `RELEASE.local` and `CONFIG_SITE.local` files that every module reads from the repository top |
| `conf.modules.zero` | Runs the configuration targets of `MCoreUtils`, `autosave`, `caPutLog`, `ether_ip`, `iocStats`, `pcas`, `pscdrv`, `retools`, `snmp`, `recsync`, `sncseq`, `sscan`, `opcua`, `pvxs`, `linStat`, `feed-core`, `QPC`, and `pyDevSup` |
| `conf.modules.one` | Runs the configuration targets of `calc`, `asyn`, `modbus`, `lua`, `std`, `StreamDevice`, `busy`, `scaler`, `mca`, `measComp`, `motor`, `motorMotorSim`, `pmac`, and `rgamv2` |
| `conf.<module>` | Configures one module; `<module>` is one of `MCoreUtils`, `autosave`, `caPutLog`, `ether_ip`, `iocStats`, `pcas`, `pscdrv`, `retools`, `snmp`, `recsync`, `sncseq`, `sscan`, `opcua`, `pvxs`, `linStat`, `feed-core`, `QPC`, `pyDevSup`, `calc`, `asyn`, `modbus`, `lua`, `std`, `StreamDevice`, `busy`, `scaler`, `mca`, `measComp`, `motor`, `motorMotorSim`, `pmac`, or `rgamv2` |
| `conf.show`, `conf.base.show`, `conf.modules.show`, `conf.<module>.show` | Prints the files the matching configuration target writes |
| `conf.gz.base`, `conf.gz.modules` | Same as `conf.base` and `conf.modules`, and appends `-g0 -gz=zlib` to `USR_CFLAGS`, `USR_CXXFLAGS`, and `USR_LDFLAGS` |
| `user.conf` | Copies `configure_user/CONFIG_USER` and `configure_user/RULES_USER` into `${HOME}/configure` |

On Ubuntu 26, the individual configuration targets for `sncseq`, `iocStats`,
`sscan`, `calc`, `busy`, `StreamDevice`, `lua`, `std`, `scaler`, and `mca`
write `USR_CFLAGS += -std=gnu17` in the module's `configure/CONFIG_SITE.local`.
The same targets run under `conf.modules` and `conf.gz.modules`. Repeating a
configuration target rewrites the file with one copy of the flag; other
operating systems do not receive it.

`conf.std` also writes the installed base path into the std child IOC
`iocs/stdTestIOC/configure/RELEASE.local`. It replaces only `EPICS_BASE`
assignments in that file, preserves other settings, comments, and includes,
and avoids duplicate assignments on repetition or installation-root changes.

## Build and install targets

| Target | Effect |
| --- | --- |
| `build.base` | Builds EPICS base with four parallel jobs |
| `build.modules` | Builds every module in dependency order, then runs `install.modules` |
| `build.<module>` | Builds one module after the modules it depends on, then writes its build record and loader metadata under `cfg/` |
| `build.gz` | Same as `build`, with the `conf.gz.*` configuration |
| `install.base` | Installs EPICS base and copies `scripts/setEpicsEnv.bash` and `scripts/resetEpicsEnv.bash` to the top of the installed tree with mode 0644, backing up existing files |
| `install.modules`, `install.<module>` | Installs every module, or one module, and writes the loader metadata of each again from its build record |
| `install.commoniocsh` | Copies `commonIocsh/iocsh/*.iocsh` to `modules/commonIocsh/iocsh` in the installed tree |
| `install.iocsh` | Copies `tools/iocsh.bash` and `tools/iocsh_elf.bash` to `base/bin/<arch>` in the installed tree |
| `src_version` | Writes the time it runs and the EPICS-env commit to `.versions` and installs that file at the top of the installed tree |
| `symlinks.modules` | Creates every module link, then deletes dangling links under `modules` on Linux |
| `symlink.<module>`, `cleansymlink.<module>` | Creates or removes the unversioned link of one module; `symlink.<module>` first removes the link, then checks the loader metadata of an installed module and stops on a mismatch; an empty module directory, as after `uninstall.<module>`, gets a notice and no link |

## Verification and inspection targets

| Target | Effect |
| --- | --- |
| `audit.module-deps` | Reports differences between each module's declared and observed dependencies; reads `MODULE`, `FORMAT`, and `PLATFORM` |
| `check.module-deps` | Same audit, and fails when an undeclared or unknown dependency exists |
| `audit.deps` | Reports runpath defects in the installed executables and shared libraries without failing |
| `check.deps` | Same scan, and fails on any finding |
| `audit.env` | Reports each `LD_LIBRARY_PATH` entry under `pvxs/bundle` that the installed `setEpicsEnv.bash` adds |
| `check.env` | Same check, and fails on a finding or when it cannot inspect the installed tree |
| `readelf.base`, `ldd.base`, `chrpath.base`, `readelf.runpath.base` | Prints the dynamic section, resolved libraries, or runpath of the installed EPICS base files |
| `readelf.modules`, `ldd.modules`, `chrpath.modules` | Same inspection for every installed module |
| `readelf.<module>`, `ldd.<module>`, `chrpath.<module>` | Same inspection for one installed module |
| `exist` | Prints the installed tree to depth `LEVEL`, default 2 |
| `exist.modules` | Prints the installed `modules` directory to depth `LEVEL` plus 1 |

## Clean and uninstall targets

| Target | Effect |
| --- | --- |
| `clean.base` | Runs `make clean` in the EPICS base source tree |
| `clean.modules` | Runs `make distclean` in every module source tree, which also empties each installed module directory; preserves sources and user local settings, except the upstream motor-generated host RELEASE file |
| `distclean.base` | Removes the EPICS base source tree |
| `distclean.modules` | Removes every module source tree |
| `distclean.modulesgen` | Removes `configure/MODULESGEN.mk` |
| `uninstall` | Removes the whole installed tree for the current release, operating system, and base version |
| `uninstall.modules` | Runs `make uninstall` in every module, then removes every module install directory; preserves source trees and the installed base |
| `uninstall.<module>` | Runs `make uninstall` in one module |
| `src_clean` | Removes `site-template/.versions` |

## Variable printing targets

An invocation is query-only when every selected goal is `print-%`, `PRINT.%`,
`vars`, `env`, `default`, `ls.%`, `tree.%`, `cat.%`, `exist`, `exist.modules`,
`show.genmk`, or a declared `conf.*.show` target, including `conf.show`.
Pattern query names require a nonempty variable name.
These invocations create no installation directory or generated file,
including with `-n`. File-display targets read their actual files and can
fail when those files are missing.

With no explicit goals, make classifies the effective `.DEFAULT_GOAL`; the
shipped value is `vars`. Command-line default overrides retain their target
behavior, and explicit goals take precedence. A mixed query/action list or
an unknown goal takes the action path, which probes the installation root
and can regenerate the cache. `-n` does not suppress those action-path effects.

| Target | Effect |
| --- | --- |
| `vars`, `env`, `default` | Prints the configuration variables; `FILTER=<prefix>` limits the list to names that start with `<prefix>` |
| `print-<VARIABLE>` | Prints the value of one variable |
| `PRINT.<VARIABLE>` | Prints the value and the origin of one variable |
| `ls.<VARIABLE>`, `tree.<VARIABLE>`, `cat.<VARIABLE>` | Runs `ls`, `tree`, or `cat` on the path a variable holds |

## Continuous integration (CI) targets

| Target | Runs |
| --- | --- |
| `github` | `init`, `patch`, `vars`, `conf`, `build`, and `symlinks` |
| `github.check` | `init`, `patch`, `vars`, `conf`, `check.module-deps`, `build`, and `symlinks` |
