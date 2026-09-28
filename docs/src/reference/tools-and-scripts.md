# Tools and scripts reference

EPICS-env builds the Experimental Physics and Industrial Control System (EPICS)
base and modules with make. The `tools/` and `scripts/` directories hold the
programs around that build: checks of the installed tree, dependency and pin
surveys, process variable (PV) helpers, and scripts that set up a shell for an
installed tree. You run each Bash tool with `bash`. This command prints the
usage of one tool:

```bash
bash tools/check_env.bash --help
```

`audit_module_deps.bash` without `--top` and `check_deps.bash` without an
installed tree argument read make variables in the current directory; run them
from the repository top. `gen_dep_graph.bash`, `prep-vendors.bash`,
`update-release.bash`, and `verify_fix_build.bash` locate the checkout from
their own path.

## Programs in the tools directory

Placeholders in the `Interface` column:

- `<installed_tree>` is the installed tree for one host, the value of
  `make print-INSTALL_LOCATION_EPICS`.
- `<repo>` is the top directory of an EPICS-env checkout.
- `<name>` after `--module` is the lower-case module name, such as `asyn`.
- `<pv_list>` is a file with one PV name per line.

| Tool | Purpose | Interface | Exit status | Called by |
| --- | --- | --- | --- | --- |
| `audit_module_deps.bash` | Compares each module's declared dependencies (`<module>_DEPS`) with the dependencies found in its source tree: `configure/RELEASE.local`, Makefiles, `.dbd`, database, startup, and C or C++ source files | `--top <repo>`, `--module <name>`, `--format text` or `json`, `--platform <name>`, `--strict`, `--help` | 0 report printed with no strict failure; 1 argument error or no module matched; 2 with `--strict` when an undeclared-observed or unknown finding exists | `audit.module-deps`, `check.module-deps`, and through `github.check` the Debian 12, Debian 13, and Rocky 8 workflows |
| `check_deps.bash` | Scans the installed executables and shared libraries of base, modules, and `vendor/lib`. It reports each file that has a run-time search path (RPATH) entry. It reports each absolute RPATH or run-time library search path (RUNPATH) entry outside the system library directories. It reports each shared library that needs a tree library without `$ORIGIN` in its RPATH or RUNPATH | `-v` or `--verbose`, `--report-only`, then an optional `<installed_tree>`; without it the tool reads `INSTALL_LOCATION_EPICS` from make in the current directory | 0 no finding, or any finding with `--report-only`; 1 unknown option; 2 any finding without `--report-only`, or `readelf` not found | `audit.deps` (with `--report-only`), `check.deps`, every operating system (OS) workflow, and `prep-vendors.bash check-deps` |
| `check_env.bash` | Sources the installed `setEpicsEnv.bash` in a shell started with `env -i`, and reports each `LD_LIBRARY_PATH` entry that contains a `pvxs/bundle` path component | `--epics <installed_tree>` (required), `--strict`, `--require-run`, `--help` | 0 no finding, a finding without `--strict`, or check skipped; 1 argument error; 2 with `--strict` when a finding exists; 3 with `--require-run` when the script is absent, `EPICS_MODULES` or `EPICS_HOST_ARCH` stays empty, or `LD_LIBRARY_PATH` stays empty | `audit.env`, `check.env` (with `--strict --require-run`), and every OS workflow |
| `gen_dep_graph.bash` | Writes a Graphviz image of the module dependency graph from the `<module>_DEPS` lines, labeled with the commit and its date; needs the `dot` command | `-f <file>` (default `configure/CONFIG_MODS_DEPS`), `-o <file>` (default `epics_deps.png`; the extension sets the image format), `-v`, `-h` | 0 image written; 1 error, unknown option, or `-h`; `-f` or `-o` without a value never exits | No target or workflow |
| `prep-vendors.bash` | Clones `uldaq-env` and `open62541-env` into `${HOME}/.vendor_temp_folder`, builds and installs both into `<installed_tree>/vendor`, and builds EPICS-env against them | One command: `init`, `prep-uldaq`, `prep-open62541`, `prep-vendors`, `epics-env`, `epics-build <make_target>`, `show-env`, `check-deps` followed by `check_deps.bash` options, `all`, `OS`, or `help` | 0 success; 1 unknown command, missing argument, or `help`; otherwise the status of the failed step | No target or workflow |
| `pv_snapshot.bash` | Captures PV values with `caget` into a snapshot file, and compares two snapshots PV by PV as `SAME`, `WITHIN`, `DIFF`, `MISSING`, or `DISCONN` | `capture -l <pv_list> -o <snapshot> [-w <seconds>]`; `compare [-t <tolerance>] <before> <after>`; `--help` | 0 no difference beyond the tolerance; 1 a `DIFF`, `MISSING`, or `DISCONN` PV, or, with no message, `capture` whose last argument is `-l`, `-o`, or `-w`, or `compare -t` with nothing after it; 2 other usage or run-time errors | No target or workflow; `verify_fix_build.bash` names it in the manual steps it prints |
| `pvs_gets.bash` | Reads every PV of a list, sorted, with `caget` or `pvget`, once or in a loop | `-l <pv_list>` (required), `-f <regex>`, `-r <field>`, `-w <seconds>`, `-c`, `-n`, `-7` | 0 run finished, also when `caget` or `pvget` is missing; 1 usage error or no `-l`; `-w` runs until interrupted | No target or workflow |
| `tc32-expansion-query.cpp` | C++ source, built separately, of a program that reports whether a measComp TC-32 or E-TC32 has the EXP-32 expansion attached, through the installed uldaq library | One argument: the unique ID that the input/output controller (IOC) passes to the measComp driver | 0 query succeeded; 2 usage; 3 no device or more than one device matches; 4 a uldaq call failed | No target or workflow |
| `update-release.bash` | Surveys every module pin in `configure/RELEASE` against its remote: tag pins against the latest release tag, commit pins against the branch head | `[-v] check`, `[-v] update`, or `help`; reads `GITHUB_TOKEN` when set | `check`: 0 survey complete, 1 a module unreachable or without a repository URL, 2 a module has no release tag; `update`: 0 run finished or choice 4 taken, 1 `configure/RELEASE` not found; `help`: 1 | No target or workflow |
| `verify_fix_build.bash` | Builds a fixed module copy and a consumer IOC copy against the installed tree named by `EPICS_BASE`, then checks their RPATH or RUNPATH entries, their resolved libraries, and that nothing under the tree was written | `<module_dir> <ioc_dir>`, after `setEpicsEnv.bash` of the tree is sourced; `--help` | 0 all checks passed; 1 a precondition, build, or check failed, or a dependency confirmation was refused or had no terminal; 2 wrong argument count | No target or workflow |

## Behavior details of the tools

- `audit_module_deps.bash` reads the module list, each `<module>_DEPS`, and
  the `AUDIT_*` token lists through `make print-<VARIABLE>` in the directory
  that `--top` names. `--platform` defaults to the output of `uname -s`.
- `check_deps.bash` looks only in `bin/linux-x86_64` and `lib/linux-x86_64`
  under `base` and each module, and in `vendor/lib`. An RPATH or RUNPATH
  entry that starts with `/usr/lib`, such as `/usr/lib64` or
  `/usr/lib/x86_64-linux-gnu`, prints a note and does not count as a
  finding.
- `pvs_gets.bash` treats `-f` as a regular expression. `-r` appends
  `.<field>` to each PV name. `-7` reads with `pvget` instead of `caget`.
  `-c` sets `EPICS_CA_ADDR_LIST` to the host's Internet Protocol version 4 (IPv4) address and
  `EPICS_CA_AUTO_ADDR_LIST` to `YES`, or to `NO` together with `-n`.
- `update-release.bash update` offers four choices for each module whose pin
  differs from the latest release tag or branch head: keep the pin (the
  default), take the latest, enter a value, or exit. Choice 4 removes
  `configure/RELEASE.new` and exits 0 without writing `configure/RELEASE`.
- After the last module, `update-release.bash update` shows the difference and
  asks before it writes `configure/RELEASE`. It copies the replaced file to
  `configure/RELEASE.bak`.
- `verify_fix_build.bash` needs `configure/MODULESGEN.mk` in the checkout that
  holds it. It writes `configure/RELEASE.local` and
  `configure/CONFIG_SITE.local` in both copies. It keeps
  `module-build.log`, `ioc-build.log`, and the empty marker file `.started` in
  the parent directory of `<module_dir>`. It writes `.started` before the
  builds and fails when a file under the installed tree changes after that
  point.
- When the module dependencies of the checkout differ from those of the
  installed module, `verify_fix_build.bash` prints the difference and asks for
  confirmation on `/dev/tty`. Without a terminal, or on any answer other than
  `y` or `Y`, it exits 1.
- `tc32-expansion-query.cpp` has no make target. From the repository top,
  these commands build it against the uldaq library of an installed tree:

  ```bash
  VENDOR=<installed_tree>/vendor
  g++ -c -I"${VENDOR}/include" tools/tc32-expansion-query.cpp
  g++ -o tc32-expansion-query tc32-expansion-query.o -L"${VENDOR}/lib" -Wl,-rpath,"${VENDOR}/lib" -luldaq
  ```

  `<installed_tree>` is the installed tree, as in the table above. The second
  command compiles the source, and the third links the program in the current
  directory. The `-Wl,-rpath` option records the vendor library directory
  in the program as its RUNPATH, so it finds `libuldaq.so` at run time. The
  program and `tc32-expansion-query.o` stay in the repository top, and Git
  does not ignore them.
- `prep-vendors.bash init` empties `${HOME}/.vendor_temp_folder` and writes
  `configure/CONFIG_SITE.local`. `epics-env` and `epics-build` rewrite
  `configure/RELEASE.local`. The vendor builds use `conf.rocky8` on Rocky,
  Red Hat Enterprise Linux (RHEL), CentOS, and Fedora, and `conf` elsewhere.

## Shell scripts in the scripts directory

| Script | Use | Effect | Installed |
| --- | --- | --- | --- |
| `setEpicsEnv.bash` | Sourced, with an optional argument | Removes the paths of an EPICS environment already set in the shell, then sets `EPICS_PATH` to its own directory and exports `EPICS_BASE`, `EPICS_MODULES`, and `EPICS_HOST_ARCH`. Prepends `base/bin/<arch>`, `modules/pvxs/bin/<arch>`, and `modules/pmac/bin/<arch>` to `PATH`, and `base/lib/<arch>` to `LD_LIBRARY_PATH` | Yes: `install.base` copies it to the top of the installed tree |
| `resetEpicsEnv.bash` | Sourced | Removes the base, `pvxs`, and `pmac` executable directories from `PATH` and the base library directory from `LD_LIBRARY_PATH`, then unsets `EPICS_BASE`, `EPICS_HOST_ARCH`, and `EPICS_MODULES` | No |
| `selectEpicsEnv.bash` | Sourced, with optional arguments `<epics_top>` and `<base_version>` | Sources `<epics_top>/epics/<os_id>/<os_version>/<base_version>/setEpicsEnv.bash`; `<epics_top>` defaults to `${HOME}` and `<base_version>` to `7.0.4.1` | No |
| `build_epics.bash` | Executed with `bash`, with an optional argument `<prefix>` | Writes `configure/CONFIG_SITE.local` with `INSTALL_LOCATION:=<prefix>/epics`, so `INSTALL_LOCATION` becomes `<prefix>/epics`. Runs `init`, `patch`, `conf`, `build`, `install`, and `symlinks`, and creates `<prefix>/epics/R<base_version>` with a copy of `setEpicsEnv.bash` and `base` and `modules` links. It then clones EPICS-env-support into the current directory and builds it against the installed base | No |
| `install_apps.bash` | Executed with `bash`, with an optional argument `<prefix>` | Installs PMD 7.22.0 into `<prefix>/apps/pmd`; on Rocky it also builds splint and installs ShellCheck under `<prefix>/apps`. Writes `<prefix>/setEnv`, which sources `<prefix>/epics/R<base_version>/setEpicsEnv.bash` from `build_epics.bash` | No |

`<prefix>` defaults to `/usr/local`. `<base_version>` is an EPICS base version,
such as `7.0.10`; `build_epics.bash` and `install_apps.bash` take it from
`make print-PATH_NAME_EPICSVERS`. `<os_id>` and `<os_version>` are the `ID`
and `VERSION_ID` values in `/etc/os-release`. `<arch>` is the value of
`EPICS_HOST_ARCH`. `setEpicsEnv.bash` takes `EPICS_HOST_ARCH` from
`EpicsHostArch.pl` under `base/startup` or `base/lib/perl`, or from
`base/startup/EpicsHostArch`. It uses its argument as the architecture only
when none of these files exists or `perl` is missing. The argument `disable`
suppresses the summary it prints.

## User configuration files for make

`make user.conf` copies the two files in `configure_user/` into
`${HOME}/configure`, keeping a backup of any file it replaces. No EPICS-env
make file reads the copies in `${HOME}/configure`.

| File | Content |
| --- | --- |
| `CONFIG_USER` | `VARS_EXCLUDES` entries that hide shell, terminal, desktop, and tool variables from the variable listing |
| `RULES_USER` | The variable printing targets `vars`, `env`, `print-<VARIABLE>`, `PRINT.<VARIABLE>`, `ls.<VARIABLE>`, `tree.<VARIABLE>`, and `cat.<VARIABLE>`, the `exist` target, and the defaults `QUIET=@`, `LEVEL=2`, `FILTER=1`, and `LSOPTS="-lta"` |

## Build version record in site-template

`make src_version` writes `site-template/.versions`, holding the time it runs
and the EPICS-env commit, and installs that file at the top of the installed
tree. `make src_clean` removes `site-template/.versions`.
