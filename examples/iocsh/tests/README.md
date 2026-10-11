# Loader Verification Suite

Scripts that check the `iocsh.bash` loader against one installed tree: the
installation and metadata, the directive forms, the dependency graph, the
refusals, the ELF inspection, the shell lifecycle, and the three example
fixtures under `examples/iocsh/`. The book page
[Run the loader verification suite](../../../docs/src/procedures/run-loader-verification-suite.md)
lists the prerequisites and the steps that build a candidate installation.

## Run

```bash
IOCSH_TEST_TREE=<installed_tree> IOCSH_TEST_REPO=<repo> IOCSH_TEST_OUT=<log_dir> bash <repo>/examples/iocsh/tests/run_all.bash
```

| Variable | Meaning |
| --- | --- |
| `IOCSH_TEST_TREE` | Installed tree that holds `setEpicsEnv.bash`, such as `<install_location>/1.5.0/debian-13/7.0.10` |
| `IOCSH_TEST_REPO` | EPICS-env checkout the tree was built from; it holds `examples/iocsh` and the configuration |
| `IOCSH_TEST_OUT` | Directory for one log per script, `<script>.log` |

`run_all.bash` prints one line per script with its exit status and the
`SUMMARY ok=<n> fail=<m>` line of the script. Names given as arguments run
alone. The scripts modify the tree and the checkout, so run the suite on a
candidate installation and not on a tree in use:
`verify_multiple_versions.bash` builds and installs a second version of
linStat and asyn and replaces their source trees for a while;
`verify_make_rules.bash` uninstalls and rebuilds linStat, reverts and applies
the Base patches again, and truncates the installed `libasyn.so` for a while;
`verify_install_metadata.bash` repeats the installation;
`verify_resolved_paths.bash` changes the default link of linStat;
`verify_relocated_tree.bash` renames the installed tree and the checkout for
the duration of one IOC start; `verify_elf_inspection.bash` edits
`configure/CONFIG_MODS_IOCSH` and the measComp configuration of the checkout
and rebuilds StreamDevice, pmac, and measComp. Each restores what it changed
when it ends; after an interrupted run, check those places. `<log_dir>` must
be an absolute path without white space, outside the checkout and outside the
install location: the relocated-tree script renames both while it runs, the
install-metadata script compares the file lists of both before and after its
queries, and the tc32sim fixture refuses a path with white space. The scripts
name the architecture `linux-x86_64` and need an x86_64 host. They source
`<installed_tree>/setEpicsEnv.bash` themselves.

`run_all.bash` can run again on the same installation: each script restores
what it changed, and the counts below hold on every run.

## Scripts in their order

| Script | Checks |
| --- | --- |
| `verify_install_metadata.bash` | Read-only make queries, the metadata of every module against the effective pins, repeated installation |
| `verify_directives.bash` | The six directive forms for `m`, `mod`, and `module` |
| `verify_dependency_graph.bash` | Dependency order, entry mapping, library-only and data-only modules, every module in one IOC |
| `verify_minimal_example.bash` | The minimal example, its PVs and library maps |
| `verify_relocated_tree.bash` | A copied tree under a path with a space, with the original tree and checkout unavailable |
| `verify_fixture_tc32sim.bash` | The tc32sim fixture: startup, data path, monitoring, autosave, caPutLog |
| `verify_fixture_ioc_demo.bash` | The EPICS-IOC-Demo fixture |
| `verify_fixture_opcua.bash` | The opcua-IOC-demo fixture, with the Eclipse Milo demo server in a container |
| `verify_multiple_versions.bash` | A second linStat and a second asyn through the shipped rules, exact and default selection, stale build identities |
| `verify_resolved_paths.bash` | A default link changed after resolution does not change the running startup |
| `verify_failure_diagnostics.bash` | The 35 refusal cases below |
| `verify_elf_inspection.bash` | ELF classes, environment candidates, injected faults, a damaged DBD, truncated libraries, generator rejections |
| `verify_docs_and_tools.bash` | Syntax and ShellCheck of the tools, the book build, the documented examples |
| `verify_shell_lifecycle.bash` | Environment switching, reset, signals, terminal input, native errors |
| `verify_readme_update_command.bash` | The update command of the tc32sim README |
| `observe_truncated_library.bash` | Three cuts of a library; observation only |
| `verify_make_rules.bash` | The link rule on an uninstalled module, a truncated dependency library, the patch round trip |

`verify_resolved_paths.bash`, `verify_failure_diagnostics.bash`, and
`verify_elf_inspection.bash` use the second versions linStat 1.1.1 and asyn
66bafcd that `verify_multiple_versions.bash` installs, so that script runs
before them; a run of one of the three on a new tree names it first.
`common.bash` holds the shared functions; every script sources it.

## Expected results

The counts were recorded on candidate installations built from one commit on
Debian 13 and on Rocky Linux 8.10, with no failed check.

| Script | Passing checks, Debian 13 | Passing checks, Rocky Linux 8.10 |
| --- | --- | --- |
| `verify_install_metadata.bash` | 12 | 12 |
| `verify_directives.bash` | 15 | 15 |
| `verify_dependency_graph.bash` | 18 | 18 |
| `verify_relocated_tree.bash` | 7 | 7 |
| `verify_fixture_tc32sim.bash` | 24 | 24 |
| `verify_fixture_ioc_demo.bash` | 10 | 10 |
| `verify_fixture_opcua.bash` | 13 | 13 |
| `verify_multiple_versions.bash` | 25 | 25 |
| `verify_resolved_paths.bash` | 11 | 11 |
| `verify_failure_diagnostics.bash` | 37 | 37 |
| `verify_elf_inspection.bash` | 31 | 31 |
| `verify_docs_and_tools.bash` | 8 | 6 |
| `verify_shell_lifecycle.bash` | 30 | 30 |
| `verify_make_rules.bash` | 33 | 33 |

`verify_docs_and_tools.bash` gives 6 on the recorded Rocky Linux 8.10 host,
which has ShellCheck and no Docker, so the two checks of the book build do not
run; a host without ShellCheck gives one check fewer. Three scripts count no checks and are
judged by their output, which each log holds:

| Script | Expected output |
| --- | --- |
| `verify_minimal_example.bash` | The line `records listed: 317`, and `none` under `suspicious lines` |
| `verify_readme_update_command.bash` | The line `32` before `ioc tc exit status 0` |
| `observe_truncated_library.bash` | Three lines `cut at <n>: softIocPVX status <s>`, in the order of a cut inside the last loadable segment, a cut behind it, and a cut near the end of the file; Debian 13 with glibc 2.41 gives 135, 0, 0 and Rocky Linux 8.10 with glibc 2.28 gives 0, 0, 0 |

The checks and the counts apply to the pins of the tree they were recorded
on, Base 7.0.10 with the versions of `configure/RELEASE`; a pin change adjusts
the scripts.

## Refusal cases

`verify_failure_diagnostics.bash` runs each case in the show mode and in a
real start, and checks a nonzero status, the message, and that no IOC
launched. Syntax and graph cases use the candidate tree; file and metadata
cases edit a copy of the tree. The cases are the descriptions of the checks in
the log, in this order:

| # | Case | The message begins |
| --- | --- | --- |
| 1 | directive without a name | `<file>:<line>: Malformed module directive` |
| 2 | three arguments | `<file>:<line>: Malformed module directive` |
| 3 | quotes on one argument only | `<file>:<line>: Malformed module directive`, with the rule of quotes on both or neither |
| 4 | parenthesized without quotes | `<file>:<line>: Malformed module directive` |
| 5 | invalid character in the name | `<file>:<line>: Malformed module directive` |
| 6 | two startup files | `Specify at most one IOC startup file` |
| 7 | unknown option | `Unknown option: -x` |
| 8 | unreadable startup file | `Cannot read startup file: <path>` |
| 9 | unknown module | `Module <name> has no installed default link: <path> (<file>:<line>)` |
| 10 | version that is not installed | `Module <name> <version> is not installed under <modules> (<file>:<line>)` |
| 11 | direct version conflict | `Module version conflict: <name>` |
| 12 | transitive version conflict | `Requested: <version> at <module> <version> (<file>:<line>)` |
| 13 | transitive conflict, other order | `Requested: <version> at <file>:<line>` |
| 14 | missing metadata | `Module <name> <version> has no loader metadata: <path>. Install it with` |
| 15 | missing library file | `iocsh_elf.bash: Cannot read object: <path>`, then `ELF inspection could not run` |
| 16 | missing DBD file | `DBD of <name> <version> is missing` |
| 17 | one-file edit: added dependency | `Metadata of <name> <version> was changed after its generation` |
| 18 | one-file edit: macro | `Metadata of <name> <version> was changed after its generation` |
| 19 | one-file edit: cycle in a dependency | `Metadata of <name> <version> was changed after its generation` |
| 20 | missing digest | `Module <name> <version> has no metadata digest: <path>. Regenerate the metadata with make install` |
| 21 | format mismatch | `Unsupported metadata format in <path>: 2 (this wrapper reads format 1)` |
| 22 | architecture mismatch | `Module <name> <version> is built for <arch>, not <arch>` |
| 23 | Base version mismatch | `Module <name> <version> is built against Base <version>, not the selected Base <version>` |
| 24 | metadata names another module | `Metadata <path> names module <name>, not <name>` |
| 25 | metadata records another version | `Metadata <path> records version <version>, not <version>` |
| 26 | line without a separator | `Malformed metadata line in <path>` |
| 27 | unknown key | `Unknown metadata key in <path>: <key>` |
| 28 | entry outside the module | `Metadata <path> has an entry outside the module's` |
| 29 | repeated entry | `Metadata <path> repeats the entry` |
| 30 | missing macro | `Metadata <path> has no valid macro name` |
| 31 | malformed dependency | `Malformed dependency in <path>` |
| 32 | dependency cycle | `Dependency cycle at <name> (<chain>)` |
| 33 | recorded dependency that is not installed | `Module <name> <version> is not installed under <modules> (<chain>)` |
| 34 | pvxs version that is not installed | `Module pvxs <version> is not installed` |
| 35 | pvxs version other than the native one | `Module pvxs <version> is requested at <file>:<line>, but the native softIocPVX already provides pvxs <version>` |

`verify_elf_inspection.bash` provokes the refusals of the ELF inspection and of
the metadata generator. Each is a check of that script, named by its
description:

| Refusal | Check description |
| --- | --- |
| A dependency that the ELF files need but the metadata does not record | `an ELF dependency that the metadata does not record is explained` |
| A dependency version edited in the metadata | `an edited dependency version is refused by the metadata digest` |
| An environment candidate of another installed version | `an environment candidate in another version directory is refused before launch` |
| A needed library without a file | `a NEEDED entry without a file is refused` |
| A failed DBD load | `a failed DBD load stops before the application DB and iocInit` |
| A truncated library, in both modes | `a library cut inside its loadable segments is refused before launch in both modes` and `the undefined mode reports the truncated object` |
| Default-rule files absent without a declaration | `default-rule files absent without a declaration fail the installation` |
| An expanded application DBD | `an expanded application DBD is rejected` |
| A DBD entry that no library exports | `a DBD entry that no library exports is rejected` |
| A library with undefined symbols | `the build fails with the undefined-symbol count` |
| The wrapper on a refused module | `the wrapper refuses the rejected module` |
