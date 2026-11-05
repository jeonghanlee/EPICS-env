# Tools and scripts reference

EPICS-env builds the Experimental Physics and Industrial Control System (EPICS)
base and modules with make. The `tools/` and `scripts/` directories hold the
programs around that build: checks of the installed tree, dependency and pin
surveys, process variable (PV) helpers, scripts that set up a shell for an
installed tree, and the module checks that run on a test machine. You run each
Bash tool with `bash`. This command prints the usage of one tool:

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
- `<commit>` is a commit that is on `origin`.
- `<module>` is the name that the make targets of a module use, such as
  `sscan`, and `<module_key>` is the upper-case key of its `SRC_*` variables,
  such as `SSCAN`.
- `<parent>` is the directory that holds a clone, and `<log_dir>` is the
  directory of the suite logs, an absolute path without white space.

| Tool | Purpose | Interface | Exit status | Called by |
| --- | --- | --- | --- | --- |
| `audit_module_deps.bash` | Compares each module's declared dependencies (`<module>_DEPS`) with the dependencies found in its source tree: `configure/RELEASE.local`, Makefiles, `.dbd`, database, startup, and C or C++ source files | `--top <repo>`, `--module <name>`, `--format text` or `json`, `--platform <name>`, `--strict`, `--help` | 0 report printed with no strict failure; 1 argument error or no module matched; 2 with `--strict` when an undeclared-observed or unknown finding exists | `audit.module-deps`, `check.module-deps`, and every OS workflow: through `github.check` on Debian 12, Debian 13, and Rocky 8, and directly on Rocky 10 and both Ubuntu workflows |
| `check_deps.bash` | Scans each canonical installed executable once and scans the shared libraries of base, modules, and `vendor/lib`. It reports each file that has a run-time search path (RPATH) entry, each absolute RPATH or run-time library search path (RUNPATH) entry outside system library directories, and each shared library that needs a tree library without `$ORIGIN` in its RPATH or RUNPATH | `-v` or `--verbose`, `--report-only`, then an optional `<installed_tree>`; without a positional argument the tool reads `INSTALL_LOCATION_EPICS` from make in the current directory | 0 no finding, or any finding with `--report-only`; 1 unknown option; 2 any finding without `--report-only`, invalid installed-tree input, unresolved executable path, or `readelf` not found | `audit.deps` (with `--report-only`), `check.deps`, every operating system (OS) workflow, and `prep-vendors.bash check-deps` |
| `check_env.bash` | Sources the installed `setEpicsEnv.bash` in a shell started with `env -i`, and reports each `LD_LIBRARY_PATH` entry that contains a `pvxs/bundle` path component | `--epics <installed_tree>` (required), `--strict`, `--require-run`, `--help` | 0 no finding, a finding without `--strict`, or check skipped; 1 argument error; 2 with `--strict` when a finding exists; 3 with `--require-run` when the script is absent, `EPICS_MODULES` or `EPICS_HOST_ARCH` stays empty, or `LD_LIBRARY_PATH` stays empty | `audit.env`, `check.env` (with `--strict --require-run`), and every OS workflow |
| `gen_dep_graph.bash` | Writes a Graphviz image of the module dependency graph from the `<module>_DEPS` lines, labeled with the commit and its date; needs the `dot` command | `-f <file>` (default `configure/CONFIG_MODS_DEPS`), `-o <file>` (default `epics_deps.png`; the extension sets the image format), `-v`, `-h` | 0 image written or help; 1 rendering error, missing input file or Graphviz, or unknown option; 2 a missing option value, with a diagnostic | No target or workflow |
| `install-distribution.bash` | Builds adjacent vendor checkouts, then EPICS-env and an optional site checkout into one installation tree | `[--plan] <epics_checkout> <install_root> <build_target> [<site_checkout>]`; `<build_target>` is `build` or `build.gz`; run as the build user after preparing packages and source revisions | 0 completed; 2 invalid input; otherwise the first failed command's status | Distribution operator |
| `iocsh.bash` | Runs an IOC startup file through the installed `softIocPVX`, loading the installed modules that the file names with `module`, `mod`, or `m` directives and their recorded dependencies | `[-e <installed_tree>] [-n] [-S] [-v] [--] [<startup_file>]`; `-n` or `--show` prints the generated startup and exits; `-h` prints the usage | The exit status of `softIocPVX`; 1 on a wrapper error before the IOC starts; 0 after `-n` or `-h` | Operator; installed by `install.iocsh` |
| `iocsh_elf.bash` | Resolves the libraries that Executable and Linkable Format (ELF) files need, with `readelf`, and reports undefined symbols, truncated library files, or libraries that belong to an unselected module version | `undefined --object <file>... [--provider <file>...]`, or `inspect --base <dir> --modules <dir> [--vendor <dir>] --select <name>=<dir>... --object <file>...` | 0 nothing reported; 1 a finding; 2 the inspection could not run | `iocsh_metadata.bash generate`, `iocsh.bash`; installed by `install.iocsh` |
| `iocsh_metadata.bash` | Writes and checks the loader metadata `cfg/build-record` and `cfg/iocsh.conf` of one installed module | `record`, `generate`, or `check`, with `--module`, `--install`, `--version`, `--tag`, `--base-version`, `--base`, and per mode `--source`, `--modules`, `--pvxs`, `--macro`, `--target`, `--dep <name>=<version>`, `--libs`, `--dbds`; `-v` reports each step | 0 success; 1 a failed requirement or a stale or inconsistent file | `build.<module>`, `install.<module>`, `symlink.<module>` |
| `module-check/guest-run.bash` | Runs one command on a test machine over SSH and keeps its output as `<log_dir>/<label>-<os>.log`, with the exit status of the command as the last line, `rc=<n>`; the machines come from a hosts file outside the repository, one line `<os>=<user>@<address>` each and an optional `ssh_options=<options>` line | `<os> <label> <command> [<log_dir>]`; `<log_dir>` is absolute or relative to the current directory and defaults to `work/base-bump` of the checkout; the environment variable `GUEST_HOSTS_FILE` replaces the hosts file `work/guest-hosts.env` | 0 once the log is written, whatever the command returned, because the last line reports it (`ssh exit <n>` when ssh itself failed); 2 wrong argument count, a missing or empty hosts file, no line for `<os>`, or a log of that name that already exists | Operator on the local host, from The checks of `docs/procedures/module-bump-procedure.md`; no target or workflow |
| `module-check/cycle.bash` | Runs the checks of one module cycle on every test machine of the hosts file through `guest-run.bash`, in the order of The checks of `docs/procedures/module-bump-procedure.md`: `checkout`, `build` (`guest-update.bash`), `rebuild-<d>` for each build-order dependent from `configure/CONFIG_MODS_DEPS` at the candidate, `patch-round-trip` on the first machine, `consumers` (`guest-suite.bash` with the three module scripts and the fixture that loads the module) and `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, and `reverse-deps`, whose output it also writes to `<log_dir>/reverse-deps.md`; prints one line per Results row of the release record with the evidence lines of the row, and a note with the hits of the old version in the files of the pin commit when the pin moved after the branch point | `[-C <local_checkout>] <module> <module_key> <commit> [<site_checkout>] [<log_dir>]`; `-C` names the local checkout that holds the commit when the module belongs to the site module repository, and then `<site_checkout>` is required and is the checkout of the machines in which the module is built, rebuilt, and round-tripped; `<site_checkout>` otherwise is the path of the site checkout on the machines, an empty string for none; `<log_dir>` defaults to `work/<module>-bump` of the checkout; the environment variables `GUEST_HOSTS_FILE` and `GUEST_SANDBOX` replace the hosts file and the sandbox directory `~/sandbox` of the machines, and `CYCLE_BASE` the commit after which a moved pin is searched for; with `-C` the round trip clones the origin of `<site_checkout>` and gives make the installed tree of the EPICS-env checkout of the machines as `INSTALL_LOCATION` | 0 every row passed; 1 a log did not end with `rc=0`, where the run stopped; 2 wrong argument count, a missing hosts file, a candidate that is not a commit, or a dependent without a key in `configure/RELEASE` | Operator on the local host, from The checks of `docs/procedures/module-bump-procedure.md`; no target or workflow |
| `module-check/guest-baseline.bash` | Builds the whole tree of the sandbox checkout, the steps 1 to 11 of the build and install page: writes `configure/RELEASE.local`, clones and installs `uldaq-env` and `open62541-env` into `<installed_tree>/vendor` with `<conf_target>` as their configuration target, then runs `make init`, `make patch`, `make conf`, `make check.module-deps`, `make build`, `make install`, and `make symlinks`; with `--rebuild`, moves the install location (`make print-INSTALL_LOCATION`) aside under its own path with `.damaged-<stamp>` appended, installs the two vendor libraries again from their checkouts, and runs `make patch.revert` before `make init` | `[--rebuild] [<conf_target>]`; `<conf_target>` defaults to `conf`; the environment variable `GUEST_CHECKOUT` replaces the checkout `${HOME}/sandbox/EPICS-env` | The exit status of the first command that failed, with `BUILD-END rc=<n>` as the last line either way; 2 a wrong argument | Operator on a test machine, from the baseline build of `docs/procedures/release-procedure.md`, step 6; no target or workflow |
| `module-check/guest-roundtrip.bash` | Clones the repository at a commit into `<parent>/EPICS-env-roundtrip`, runs `make init`, `make patch`, and `make patch.revert` there, and prints the exit status of each step, the count of `Patching` lines, and the count of `git status --short` lines of every source tree | `<commit> [<module>] [<parent>]`; `<module>` adds the count of its `Patching` lines; `<parent>` defaults to `${HOME}/sandbox`; the environment variable `EPICS_ENV_REPO` replaces the repository URL, and `ROUNDTRIP_INSTALL_LOCATION` replaces the `INSTALL_LOCATION` given to every make call, which a site module repository needs to be the installed EPICS-env tree | 0 when `make init`, `make patch`, and `make patch.revert` exit 0 and no source tree shows a change after the revert; 1 preserving an existing clone failed, a make step failed, a source tree shows a change, or the parent directory, the clone, or the checkout failed; 2 wrong argument count | Operator on a test machine, from The checks of `docs/procedures/module-bump-procedure.md`; no target or workflow |
| `module-check/guest-site-install.bash` | Installs the site modules of a site checkout into the installed tree of the sandbox checkout, the sequence of the add-site-modules page: writes `INSTALL_LOCATION` into `configure/CONFIG_SITE.local` of the site checkout, prints the `modules` entry count before and after, and runs `make init`, `make patch`, `make conf`, `make check.module-deps` (its status printed as `module-deps rc=<n>`), `make build`, `make install`, `make symlinks`, and `LC_ALL=C make exist.modules LEVEL=1` filtered to the site modules | `<site_checkout> [<repo>]`; `<repo>` defaults to `${HOME}/sandbox/EPICS-env` | 0 with `SITE-INSTALL-DONE <site_commit>` as the last line; 2 wrong argument count, a `<site_checkout>` or `<repo>` that is not a directory, or a `<site_checkout>` without `configure/RELEASE`; otherwise the exit status of the first command that failed | Operator on a test machine, from the baseline build of `docs/procedures/release-procedure.md`, step 6; no target or workflow |
| `module-check/guest-suite.bash` | Starts the minimal example IOC through the installed `iocsh.bash`, runs `examples/iocsh/tests/run_all.bash` against the installed tree of a checkout, every script or the ones named, with the pins of a site checkout when one is given, and prints the counts of the scripts that ran | `[<repo>] [<log_dir>] [<site_checkout>] [<scripts>]`; `<repo>` defaults to `${HOME}/sandbox/EPICS-env`, `<log_dir>` to `${HOME}/sandbox/iocsh-tests`, `<site_checkout>` is passed to the suite as `IOCSH_TEST_SITE_REPO` (an empty string for none), and `<scripts>` is one argument of space-separated script names, empty or absent for every script; the environment variable `GUEST_SUITE_MIN_FREE_KB` (default 6291456, 6 GB) is the free space in 1024-byte blocks that the volume of `<log_dir>` must hold before the run, printed as `free before:` and `free after:` | 0 after the run, whatever the tests returned, because the output lines report them; 1 `<repo>` is not a directory or the log directory cannot be preserved or created; 2 a usage error, a symlink `<log_dir>`, a `<log_dir>` overlapping the checkout or the installed tree, a `<site_checkout>` without `configure/RELEASE`, a missing tool, or free space below `GUEST_SUITE_MIN_FREE_KB` | Operator on a test machine, from The checks of `docs/procedures/module-bump-procedure.md`; no target or workflow |
| `module-check/guest-update.bash` | Fetches and checks out a commit in a checkout, then rebuilds one module from its pin: moves its source tree to `<repo>/work/trash`, clones it, applies its downstream patches, writes its configuration, checks its dependencies, builds it, and links it | `<module> <module_key> <commit> [<repo>]`; `<repo>` defaults to `${HOME}/sandbox/EPICS-env`; the environment variable `CONF_TARGET` replaces the configuration target `conf.<module>` | 0 with `UPDATE-DONE <module> <commit>` as the last line; 2 wrong argument count, no `SRC_TAG_<module_key>` in `configure/RELEASE`, or no `<module>-src` directory; otherwise the exit status of the first command that failed | Operator on a test machine, from The checks of `docs/procedures/module-bump-procedure.md`; no target or workflow |
| `module-check/plan-facts.pl` | Prints the cycle plan block of a module as the release record drafts it, from `configure/RELEASE` and `make print-SRC_VER_<KEY>`, the pin move after the branch point of the release (`git log -S`), the outcome of the Modules table of the record, the apply targets of the `patch:` line of `configure/RULES_SRC` and the patch files at the pin, the dependents of `configure/CONFIG_MODS_DEPS` and the ones whose `distclean` is unsafe, and the library stems of an inventory file of `<installed_name>: <stem> ...` lines, one line per installed module from the `name=` and `lib=` lines of its `cfg/iocsh.conf`, read from the installed tree of a test machine | `--libs <inventory> [--record <file>] <module>`; `--record` defaults to the one `docs/milestone-*.md` of the checkout; `--help` | 0 the block was printed; 2 a usage error, a missing input, or a module without a row in the record | Operator on the local host, at the plan step of a cycle (`docs/procedures/release-procedure.md`, step 6); no target or workflow |
| `prep-vendors.bash` | Clones `uldaq-env` and `open62541-env` into `${HOME}/.vendor_temp_folder`, builds and installs both into `<installed_tree>/vendor`, and builds EPICS-env against them | One command: `init`, `prep-uldaq`, `prep-open62541`, `prep-vendors`, `epics-env`, `epics-build <make_target>`, `show-env`, `check-deps` followed by `check_deps.bash` options, `all`, `OS`, or `help` | 0 success or help; 1 unknown command, missing argument, backup failure, refused replacement, or EOF at confirmation; otherwise the status of the failed step | No target or workflow |
| `pv_snapshot.bash` | Captures PV values with `caget` into a snapshot file, and compares two snapshots PV by PV as `SAME`, `WITHIN`, `DIFF`, `MISSING`, or `DISCONN` | `capture -l <pv_list> -o <snapshot> [-w <seconds>]`; `compare [-t <tolerance>] <before> <after>`; `--help` | 0 no difference beyond the tolerance; 1 a `DIFF`, `MISSING`, or `DISCONN` PV; 2 usage or run-time errors, including a missing option value with a diagnostic | No target or workflow; `verify_fix_build.bash` names it in the manual steps it prints |
| `pvs_gets.bash` | Reads every PV of a list, sorted, with `caget` or `pvget`, once or in a loop | `-l <pv_list>` (required), `-f <regex>`, `-r <field>`, `-w <seconds>`, `-c`, `-n`, `-7` | 0 run finished; 1 usage error or no `-l`; 2 the selected client is missing or not executable, in single and watch modes; `-w` runs until interrupted when the client is available | No target or workflow |
| `revert_patch.bash` | Classifies a whole patch, reverses a confirmed applied patch, and skips a confirmed unapplied patch | `[--no-backup-if-mismatch] [--prerequisites] <source> <patch> [<ordered_patches>...]`; the ordered list includes the selected patch | 0 reversed or confirmed unapplied; 2 invalid or unresolved inputs; otherwise a failed command status | Every active `patch.*.revert` target |
| `tc32-expansion-query.cpp` | C++ source, built separately, of a program that reports whether a measComp TC-32 or E-TC32 has the EXP-32 expansion attached, through the installed uldaq library | One argument: the unique ID that the input/output controller (IOC) passes to the measComp driver | 0 query succeeded; 2 usage; 3 no device or more than one device matches; 4 a uldaq call failed | No target or workflow |
| `update-release.bash` | Surveys every module pin in `configure/RELEASE` against its remote: tag pins against the latest release tag, commit pins against the branch head | `[-v] check`, `[-v] update`, or `help`; `-v` prints whether `GITHUB_TOKEN` is set; the variable raises the GitHub API rate limit when set | `check`: 0 survey complete, 1 a module unreachable or without a repository URL, 2 a module has no release tag; `update`: 0 run finished or choice 4 taken, 1 `configure/RELEASE` not found; help: 0; usage error: 2 | No target or workflow |
| `verify_fix_build.bash` | Builds a fixed module copy and a consumer IOC copy against the installed tree named by `EPICS_BASE`, then checks their RPATH or RUNPATH entries, their resolved libraries, and that nothing under the tree was written | `<module_dir> <ioc_dir>`, after `setEpicsEnv.bash` of the tree is sourced; `--help` | 0 all checks passed; 1 a precondition, build, or check failed, or a dependency confirmation was refused or had no terminal; 2 wrong argument count | No target or workflow |

## Behavior details of the tools

- `tree-manifest.py` requires Python 3 and writes JSON to stdout for one
  directory argument. It records every descendant's relative path, type,
  and mode, plus symlink targets or regular-file sizes and SHA-256 hashes.
  It includes hidden files and empty directories without following symlinks.
  It excludes the root itself, ownership, and timestamps. Keep the tree
  unchanged while scanning and put the output outside it.
  Exit status is 0 on success, 1 for an unreadable or unsupported entry or
  invalid directory, and 2 for incorrect arguments. Compare two trees from
  the repository top, replacing `<source_tree>` and `<copied_tree>` with
  their paths and the two `<manifest_*>` values with external output files:

  ```bash
  python3 tools/tree-manifest.py <source_tree> > <manifest_before>
  python3 tools/tree-manifest.py <copied_tree> > <manifest_after>
  cmp <manifest_before> <manifest_after>
  ```

  Require both scans and `cmp` to exit 0. Run
  `python3 tools/verify_tree_manifest.py` to check copy equality, detected
  changes, and failures for invalid inputs, special files, and unreadable
  directories; the permission test is skipped when run as root.
- `audit_module_deps.bash` reads the module list, each `<module>_DEPS`, and
  the `AUDIT_*` token lists through `make print-<VARIABLE>` in the directory
  that `--top` names. `--platform` defaults to the output of `uname -s`.
- `check_deps.bash` looks only in `bin/linux-x86_64` and `lib/linux-x86_64`
  under `base` and each module, and in `vendor/lib`. An RPATH or RUNPATH
  entry that starts with `/usr/lib`, such as `/usr/lib64` or
  `/usr/lib/x86_64-linux-gnu`, prints a note and does not count as a
  finding.
- `check_deps.bash` resolves executable paths with `realpath -e` and removes
  duplicate canonical paths before calling `readelf`. Empty or non-directory
  tree paths and failed make lookups exit 2 with guidance to set
  `INSTALL_LOCATION_EPICS` or pass a valid `<installed_tree>`, including with
  `--report-only`.
- `iocsh.bash` takes the tree from the environment that `setEpicsEnv.bash`
  set, or sources `<installed_tree>/setEpicsEnv.bash` itself with `-e`. A
  directive is a complete line of the startup file in one of six forms,
  shown with `module`; `mod` and `m` take the same forms:

  ```
  module linStat
  module "linStat"
  module("linStat")
  module linStat 1.2.1
  module "linStat" "1.2.1"
  module("linStat", "1.2.1")
  ```

  Without a version the loader follows the unversioned link of the module;
  with one it uses `modules/<name>-<version>` exactly. A version is compared
  as text; there is no range and no ordering.
  [Installed module loader](../concepts/installed-module-loader.md) explains
  how the loader selects versions and dependencies and what it generates.
- `iocsh.bash` passes `softIocPVX` the copy of the startup file as
  `/dev/fd/4` and a generated startup as `/dev/fd/3`, and prints that mapping
  before it starts the IOC.
- `iocsh.bash` stops before the IOC starts, with the startup file name and
  line, when a directive is the cause. A conflict names both requests:

  ```
  iocsh.bash: Module version conflict: asyn
  Requested: 9.9.9 at st.cmd:2
  Selected:  4.46.0 at StreamDevice 2.8.26 (st.cmd:1)
  Use one version of asyn in this IOC.
  ```

  A version that is not installed reads
  `Module linStat 9.9.9 is not installed under <installed_tree>/modules (st.cmd:1)`.
  A selected `cfg/iocsh.conf` that differs from the digest in
  `cfg/iocsh.conf.sha256` stops it with
  `Metadata of <name> <version> was changed after its generation`, and a
  dependency cycle with `Dependency cycle at <name>`.
  [Run an IOC from installed modules](../procedures/run-ioc-from-installed-modules.md#refusals-of-the-loader)
  lists the refusals with their meaning and the action each needs.
- With `-e`, `iocsh.bash` discards the standard output of the sourced
  `setEpicsEnv.bash`, so `-n` prints the generated startup only.
- A command that is not registered reads `ERROR 4 line <n>: Command '<name>'
  not registered.`: `4` is the startup file, passed as `/dev/fd/4`, and `<n>`
  is the line in the original file. A registered command that fails prints its
  own messages and `Error in /dev/fd/3`, without a line number.
- The inspection of `iocsh.bash` needs `readelf`. When a library file is
  shorter than the end of its last loadable segment, it stops with
  `<file> is truncated`. The message names the repair for the place of the
  file. In a tree taken from a distribution, restore the file from that
  distribution. In a tree built from an EPICS-env checkout, remove the file
  and run `make build.<module>` for a module file or `make install.base`
  for an EPICS base file; these targets leave a damaged file in place
  unless it is removed first, because make treats the installed file as up
  to date.
  `<module>` is the make name of the module, which for the sequencer in
  `seq-<version>` is `sequencer`. A file outside the installed tree comes
  back with the package that provides it. `-n` lists the resolved files as
  `base`, `module`, `vendor`, or `system`.
- The `undefined` mode of `iocsh_elf.bash` ignores `LD_LIBRARY_PATH`.
- When `iocsh_metadata.bash record` or `generate` stops, it also prints that
  the module is installed without loader metadata and names the
  `build.<module>` target to run after the correction, preceded by
  `distclean.<module>` and the `conf` target of the module when the
  correction changes its site configuration.
  [Source configuration targets](make-targets.md#source-configuration-targets)
  lists the `conf` targets whose name differs from the module name.
  When a library that `generate` reads is truncated, it names the file and
  the repair for the place of the file instead, as `iocsh.bash` does.
  [Loader entries in CONFIG_MODS_IOCSH](../concepts/module-set.md#loader-entries-in-config_mods_iocsh)
  lists what `generate` rejects, and
  [Installed module loader](../concepts/installed-module-loader.md#how-the-metadata-is-made)
  describes the three modes.
- Five scripts of `tools/module-check/` run on a test machine as the user
  that owns the checkout and the installed tree: `guest-update.bash`,
  `guest-roundtrip.bash`, `guest-suite.bash`, and `guest-site-install.bash`
  resolve their checkout, parent, or log path with `readlink`;
  `guest-baseline.bash` runs in `${HOME}/sandbox/EPICS-env` or the checkout
  that `GUEST_CHECKOUT` names. The other three, `guest-run.bash`,
  `cycle.bash`, and `plan-facts.pl`, run on the local host from the checkout.
- `test-trash.bash` provides `test_move_to_trash <trash_dir> <path>...` to
  the verification scripts. Each existing path moves into a unique
  `<trash_dir>/<UTC timestamp>.<suffix>/entry`; `source-path` records its
  original absolute path. Symlinks move as links, missing paths are skipped,
  and a failed move stops the caller. Nothing in trash is removed
  automatically. `python3 tools/verify_test_trash.py` checks this behavior on
  temporary files and retains its evidence directory.
- `guest-update.bash` fetches `origin`, checks out `<commit>`, and runs
  `make reconf.modules`. It reads the pin with
  `make -s print-SRC_TAG_<module_key>` and stops with status 2 when the pin is
  empty or `<module>-src` is not a directory. It then moves `<module>-src` into `<checkout>/work/trash`
  and runs `make <module_key>`, the configuration target, `make
  check.module-deps MODULE=<module>`, `make build.<module>`, and `make
  symlink.<module>`; between `make <module_key>` and the configuration target
  it runs the apply targets of the module that the `patch:` list of
  `configure/RULES_SRC` names, in that order, so a module with downstream
  patches is built from patched source.
- `guest-update.bash` prints `HEAD:`, `started:`, `pin:`,
  `INSTALL_LOCATION_<module_key>:`, and one `link:` line for each link of
  the `modules` directory whose target is the install location of the module
  (`modules/seq` for `sequencer`, whose installed name differs), or
  `link: none`. It then prints
  one `SONAME` line for each library of the module, the `iocsh.conf version=`
  line, the `cfg:` entries, the `modules entries:` count of the installed
  tree, `finished:`, and `UPDATE-DONE <module> <commit>`.
- `guest-roundtrip.bash` moves an existing `<parent>/EPICS-env-roundtrip`
  into `<parent>/trash`, including a dangling symlink, without following its
  target. It stops with status 1 if preservation fails, otherwise clones the
  repository into a newly reserved directory and gives every make call an
  `INSTALL_LOCATION` inside the clone, so the run creates nothing outside
  `<parent>`; when `ROUNDTRIP_INSTALL_LOCATION` is set, make uses that
  location instead and the run is not confined to `<parent>`. The clone keeps
  the output of the three steps in `roundtrip-init.log`,
  `roundtrip-patch.log`, and `roundtrip-revert.log`.
- `guest-roundtrip.bash` prints `HEAD:`, `started:`, `init rc=`, `src trees:`,
  `patch rc=`, `Patching lines:`, with `<module>` also
  `Patching <module>-src lines:`, `revert rc=`, one `<source_tree> <count>`
  line for each source tree, `status lines in all trees:`, `finished:`, and
  `ROUNDTRIP-DONE <commit>`. The patches apply and revert completely when the
  output has `init rc=0`, `patch rc=0`, `revert rc=0`, and
  `status lines in all trees: 0`.
- `guest-suite.bash` stops with status 2 and the line `missing tools:` when
  one of these is absent: `bash`, `gawk`, `perl`, `git`, `patch`, `readelf`,
  `ldd`, `ss`, `ip`, `pgrep`, `ps`, `stat`, `timeout`, `expect`, `strace`,
  `setsid`, `mkfifo`, `truncate`, `sha256sum`, `make`, `socat`, and `docker`
  or `podman`. `<log_dir>` must not be `/`, a symlink, or overlap the
  checkout or installed tree in either direction. After preflight, an existing
  log directory moves into `<log_dir parent>/trash` before a new directory
  is created. Tree copies under `<log_dir>/copies` move into `<log_dir>/trash`
  after the suite ends; earlier runs continue to consume disk space.
  The suite modifies the checkout and the installed tree and
  restores them.
- `guest-suite.bash` reads the free space of the nearest existing parent of
  `<log_dir>` with `df -P` before the run and stops with status 2 when it is
  below `GUEST_SUITE_MIN_FREE_KB`, because the suite writes several gigabytes
  of tree copies there.
- `guest-suite.bash` sources `<installed_tree>/setEpicsEnv.bash`, runs
  `examples/iocsh/st.cmd` through `iocsh.bash` for at most 90 seconds with the
  output in `<log_dir>/minimal-ioc.log`, and runs
  `examples/iocsh/tests/run_all.bash` with `IOCSH_TEST_TREE`,
  `IOCSH_TEST_REPO`, and `IOCSH_TEST_OUT` set to the tree, the checkout, and
  `<log_dir>`, and `IOCSH_TEST_SITE_REPO` set to the site checkout when the
  third argument gives one. It prints `tree:`, `started:`, `minimal IOC exit=`,
  `iocRun lines:`, `minimal IOC ERROR lines:`, `run_all rc=`, `FAIL lines:`,
  `records listed:`, `readme update count:`, the `cut at` lines of the
  truncated-library test, `free after:`, `finished:`, and `SUITE-DONE`.
- `revert_patch.bash` runs noninteractive GNU patch dry-runs before changing
  sources. For supported single-file, single-hunk patches, it checks that
  changed lines match the uniquely named static C function in the hunk header;
  a declaration of that function, which ends with a semicolon, is not counted.
  Conflicting, partial, missing-input, and unresolved states fail with the
  source and patch identified. Both directions remaining valid is unresolved.
- Revert suppresses mismatch backups by default; `--no-backup-if-mismatch`
  accepts the same behavior explicitly. Existing target backups are preserved.
- Revert classification can copy real patch-owned source files into a private
  workspace. With `--prerequisites`, it supplies context from earlier patches
  there. For supported static C functions, a private patch adjusts only hunk
  search positions; GNU patch must match the contents inside the named function.
  Classification leaves the original source and shipped patches unchanged.
  Successful classification removes that workspace; failure retains it and
  prints its path. Fixed module targets pass no prerequisite list.
- `pvs_gets.bash` treats `-f` as a regular expression. `-r` appends
  `.<field>` to each PV name. `-7` reads with `pvget` instead of `caget`.
  `-c` sets `EPICS_CA_ADDR_LIST` to the host's Internet Protocol version 4 (IPv4) address and
  `EPICS_CA_AUTO_ADDR_LIST` to `YES`, or to `NO` together with `-n`.
- `update-release.bash update` offers four choices for each module whose pin
  differs from the latest release tag or branch head: keep the pin (the
  default), take the latest, enter a value, or exit. Choice 4 removes
  `configure/RELEASE.new` and exits 0 without writing `configure/RELEASE`.
- `update-release.bash` reads the date of the newest commit or tag of each
  module that has an update from the GitHub API, with one request for each
  module and 20 seconds for a request, counted from the DNS lookup.
  `GITHUB_TOKEN` raises the limit from 60 to 5000 requests an hour. A request
  that fails prints `Date:    Unknown (request failed)`, and an answer without
  a date prints `Date:    Unknown (no date in the response)`.
- `update-release.bash check` prints one entry for each module and ends with
  the summary. The output carries terminal color codes, which the excerpt
  omits:

  ```
  --- Checking for Updates (Read-Only) ---
  BASE           : OK (Current: tags/R7.0.10 is latest)
  RECSYNC        : UPDATE AVAILABLE
      Current: 9834b94
      Latest:  79ebf6c
      Date:    2026-10-13
      >> Diff Link: https://github.com/ChannelFinder/recsync/compare/9834b94...79ebf6c

  --- Survey Summary ---
    Modules attempted:  37
    Lookups completed:  37

  Found 8 module(s) with available updates.
  Run 'update-release.bash update' to apply changes interactively.
  ```
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
  `configure/CONFIG_SITE.local`. Vendor preparation writes that file in each
  vendor checkout. `epics-env` and `epics-build` rewrite `configure/RELEASE.local`
  with vendor paths and use the Network Time Protocol (NTP) default,
  `time.google.com`, from `CONFIG_BASE`.
- Before replacing an existing local configuration, `prep-vendors.bash` asks
  for confirmation when stdin is a terminal. It proceeds automatically when
  stdin is not a terminal. Both modes preserve a byte-identical backup as
  `<file>.bak.<YYYYMMDDTHHMMSSZ>`, using UTC and a numeric suffix on collision.
  Earlier backups remain unchanged. Backup failure, refusal, or EOF preserves
  the original and stops the invocation with status 1 before later build steps.
- The vendor builds use `conf.rocky10` on Rocky 10, `conf.rocky8` on Rocky 8,
  Red Hat Enterprise Linux (RHEL), CentOS, and Fedora, and `conf` elsewhere.
  `all` runs `init`, `prep-vendors`, and `epics-env` without a version argument.

## Shell scripts in the scripts directory

| Script | Use | Effect | Installed |
| --- | --- | --- | --- |
| `setEpicsEnv.bash` | Sourced as `[<fallback_arch>] [disable]` | Resolves its tree and architecture before replacing known environment paths, then exports `EPICS_PATH`, `EPICS_BASE`, `EPICS_MODULES`, and `EPICS_HOST_ARCH`. Prepends `modules/pmac/bin/<arch>`, `modules/pvxs/bin/<arch>`, and `base/bin/<arch>` to `PATH`, and `base/lib/<arch>` to `LD_LIBRARY_PATH`. Returns 0 on success, 2 for invalid arguments, or 1 when tree or architecture resolution fails | Yes: `install.base` copies it to the top of the installed tree with mode 0644 |
| `resetEpicsEnv.bash` | Sourced | Removes known base, `pvxs`, `pmac`, and legacy extension executable entries and the base library entry, then unsets `EPICS_PATH`, `EPICS_BASE`, `EPICS_HOST_ARCH`, `EPICS_MODULES`, and `EPICS_EXTENSIONS`. Returns 0, including when base is absent or reset is repeated | Yes: `install.base` copies it to the top of the installed tree with mode 0644 |
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
when none of these files exists or `perl` is missing. A discovery command
failure returns 1 before replacement. The argument `disable` suppresses the
summary without becoming the architecture. Setup and reset are safe under
`set -u`, compare complete path fields, and preserve independently configured
CA settings. Select among installed versions by directly sourcing each
chosen tree's setup script. The selector's legacy path differs from make's
`<install_location>/<release>/<os_id>-<os_version>/<base_version>` layout.

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
