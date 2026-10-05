# Run an IOC from installed modules

Start an Experimental Physics and Industrial Control System (EPICS)
input/output controller (IOC) from the installed `softIocPVX`, with the
installed modules that its startup file names, and without compiling an IOC
executable. [Installed module loader](../concepts/installed-module-loader.md)
explains how the loader `iocsh.bash` works, and the
[Tools and scripts reference](../reference/tools-and-scripts.md#behavior-details-of-the-tools)
lists the directive forms and the messages.
[Run the loader verification suite](run-loader-verification-suite.md) checks
the loader against running IOCs.

## Prerequisites

- An installed tree built with `make install` and `make symlinks`; see
  [Build and install the environment](build-and-install.md).
- The setup script of that tree sourced in the shell, which puts `iocsh.bash`
  on `PATH`; see [Set up a shell with the environment](set-up-shell.md).
  Without it, call `<installed_tree>/base/bin/<arch>/iocsh.bash` by its full
  path with the option `-e <installed_tree>`.
- `readelf` on `PATH`, which the binutils package provides. The loader
  inspects the libraries before it loads them.

## Steps

1. List the installed versions to choose one:

   ```bash
   ls <installed_tree>/modules
   ```

   A directory `<name>-<version>` is an installed version. Two directives
   for one module must name the same version.

2. Write the startup file. It names the installed modules it needs, one
   directive per line, and continues with ordinary IOC shell commands. Use a
   version from step 1 for `<version>`:

   ```
   on error break
   module linStat
   module StreamDevice <version>
   epicsEnvSet("IOC", "demo")
   iocInit()
   ```

   A line that starts with `module`, `mod`, or `m` is a directive; the
   [Tools and scripts reference](../reference/tools-and-scripts.md#behavior-details-of-the-tools)
   shows its six forms. The first one follows the unversioned link of the
   module, such as `modules/linStat`; the second names the exact installed
   version. The directives work only in the startup file that you pass on the
   command line. The loader loads the recorded dependencies of each module,
   here `asyn` and `calc` for StreamDevice.

3. Start the IOC through the loader:

   ```bash
   iocsh.bash <startup_file>
   ```

   The loader prints how the files reach the IOC, the IOC reports its
   startup, and the IOC shell prompt appears. Type `exit` to leave. Step 5 of
   [Set up a shell with the environment](set-up-shell.md) shows this output
   for the minimal example of the repository. The option `-e <installed_tree>`
   sources the setup script of that tree for this start, which is the way to
   run `iocsh.bash` by its full path from a shell that has not sourced it, and
   `-S` disables the interactive IOC shell.

4. To see what the loader would run without starting the IOC, use the show
   mode:

   ```bash
   iocsh.bash -n <startup_file>
   ```

   It prints the generated startup: the `dlload` and `dbLoadDatabase`
   commands in dependency order, one `epicsEnvSet` per module, and the
   registration call. The same step of the shell setup page shows the output
   for the minimal example.

5. When a command of your startup file fails, the IOC names the file `4` and
   gives the line of your file:

   ```
   ERROR 4 line 5
   ```

   Open your startup file at that line. The loader loads a copy in which each
   directive line is a comment, so the line numbers are the same.

6. To run a complete application, use one of the example fixtures. Each
   fixture directory under `examples/iocsh` holds a startup file adapted to the
   loader, a `prepare.bash` that checks out the application at a recorded
   revision, and a `README.md` with the preparation, the commands, and the
   expected results:

   | Fixture | Application | Modules named | Needs |
   | --- | --- | --- | --- |
   | `examples/iocsh/st.cmd` | None; host and process statistics | `linStat` | Nothing else |
   | [`tc32sim`](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/tc32sim/README.md) | <https://github.com/jeonghanlee/tc32sim> | `StreamDevice`, `linStat`, `retools`, `autosave`, `caPutLog` | The application's simulator and `iocLogServer` |
   | [`EPICS-IOC-Demo`](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/EPICS-IOC-Demo/README.md) | <https://github.com/jeonghanlee/EPICS-IOC-Demo> | `StreamDevice` | The application's simulator |
   | [`opcua-IOC-demo`](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/opcua-IOC-demo/README.md) | <https://github.com/jeonghanlee/opcua-IOC-demo> | `opcua` | An OPC UA demo server |

## Refusals of the loader

The loader stops before the IOC starts when a check fails. The message goes
to the standard error output and begins with `iocsh.bash: `, or with
`iocsh_elf.bash: ` for a message of the inspection; the first column leaves
that prefix out. A message names the startup file and line when a directive
is the cause. `<name>`, `<version>`, `<path>`, and `<file>` stand for the
values of your case.

| Message begins | Meaning | Action |
| --- | --- | --- |
| `Source setEpicsEnv.bash first, or select a tree with --environment.` | The shell has no EPICS environment | Source the setup script of the tree, or give `-e <installed_tree>` |
| `--show needs a startup file.` | The option `-n` came without a startup file | Pass the startup file |
| `Cannot find required command` | A command that the loader needs, such as `readelf`, `sha256sum`, or `readlink`, is not on `PATH` | Install it; `readelf` comes with the binutils package |
| `<file>:<line>: Malformed module directive` | A line that starts like a directive matches none of the six forms | Correct the line; put quotes on both arguments or on neither |
| `Specify at most one IOC startup file` | Two startup files were given | Pass one file |
| `Unknown option` | An option that the loader does not have | Run `iocsh.bash -h` |
| `Cannot read startup file` | The file does not exist or is not readable | Correct the path |
| `Cannot resolve the pvxs module link` | `modules/pvxs` has no link, so `make symlinks` has not run on this tree | Run `make symlinks` in the checkout that built the tree |
| `Module <name> has no installed default link` | The module has no unversioned link: it is not installed, `make symlinks` has not run, or `symlink.<module>` refused the module because its metadata did not check out | Run `make symlinks`; when it stops with a metadata message, act on that message first, or name an installed version |
| `Module <name> <version> is not installed under` | No directory `<name>-<version>` in `modules` | Name a version from `ls <installed_tree>/modules`, or install it |
| `Module version conflict` | Two requests, or a request and a recorded dependency, need different versions of one module; the message names both and the chain | Use one version of the module in the IOC |
| `Module pvxs <version> is requested at` | `softIocPVX` already provides pvxs in its own version | Request that version or none |
| `Dependency cycle at` | The recorded dependencies of installed modules form a cycle | Regenerate the metadata with `make install.<module>` in the checkout that built the tree, and check the `<module>_DEPS` declarations |
| `Module <name> <version> has no loader metadata` | The build was refused or never generated `cfg/iocsh.conf` | Correct what the build message said, then run `make build.<module>` |
| `Module <name> <version> has no metadata digest` | `cfg/iocsh.conf.sha256` is missing | Regenerate with `make install.<module>` |
| `Metadata of <name> <version> was changed after its generation` | `cfg/iocsh.conf` differs from its digest: it was edited | Regenerate with `make install.<module>`; do not edit the file |
| `Unsupported metadata format` | The file has a format version that this loader does not read | Use the loader and the tree of the same distribution |
| `Module <name> <version> is built for` or `is built against Base` | The module was built for another architecture or EPICS base version | Select the tree of the running host and base version |
| `Malformed metadata line in`, `Unknown metadata key in`, `Malformed dependency in`, `Metadata <path> has an entry outside the module's`, `Metadata <path> repeats the entry`, `Metadata <path> has no valid macro name`, `Metadata <path> names module`, `Metadata <path> records version` | `cfg/iocsh.conf` is damaged | Regenerate with `make install.<module>` |
| `DBD of <name> <version> is missing` | A file that the metadata lists is absent | Install the module again with `make build.<module>` |
| `iocsh_elf.bash: Cannot read object`, then `ELF inspection could not run` | A library that the metadata lists is absent | Install the module again with `make build.<module>` |
| `iocsh_elf.bash: Not a readable ELF object`, then `ELF inspection could not run` | A library file is not an ELF file | Install the module again with `make build.<module>` |
| `<file> is truncated` | A library file is shorter than the end of its last loadable segment | The message names the repair for the place of the file; the reference describes it |
| `<name> needed by <object> resolves to no file` | A library that a selected library needs is not found | Install the missing library, for a vendor library through the vendor build |
| `<file> belongs to <directory>, but the selected` or `<file> belongs to <directory>, which is not a selected module or a recorded dependency` | `LD_LIBRARY_PATH` or `LD_PRELOAD` names a library of another installed version, or of a module that the IOC does not use | Remove the entry or select that version |

`make build.<module>` and `make install.<module>` run in the checkout that
built the tree, with its `INSTALL_LOCATION`. Some refusals come from the
installation and not from the start, because the build generates the
metadata and refuses a module whose files do not agree with it. The message
names the target to run after the correction:

| Message begins | Meaning | Action |
| --- | --- | --- |
| `Libraries of <module> leave` | A library leaves symbols undefined after its needed libraries | Name the missing library on the link line of the module; [Loader entries in CONFIG_MODS_IOCSH](../concepts/module-set.md#loader-entries-in-config_mods_iocsh) gives the steps |
| `Library entry for <module> is absent` or `DBD entry for <module> is absent` | The module installs other names than the default rule expects | Declare the entry in `configure/CONFIG_MODS_IOCSH` |
| `DBD entries of <module> have no providing library` | A selected DBD names an entry that no library exports | Correct the declaration in `configure/CONFIG_MODS_IOCSH` |
| `<file> defines Base` or `<file> includes <name> from Base or PVXS` | A selected DBD is an expanded application DBD, or includes a Base file that holds record types | Declare the support DBD in `configure/CONFIG_MODS_IOCSH` |

## Verification

1. Start the minimal example of the repository:

   ```bash
   iocsh.bash <repo>/examples/iocsh/st.cmd
   ```

   `<repo>` is the top directory of an EPICS-env checkout. The IOC prints
   `iocRun: All initialization complete` and the prompt appears.

2. Show its generated startup:

   ```bash
   iocsh.bash -n <repo>/examples/iocsh/st.cmd
   ```

   The output lists `linStat` first and ends with a comment that names the
   copy of the startup file as `/dev/fd/4`.
