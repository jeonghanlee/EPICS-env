# Set up a shell with the environment

Source `setEpicsEnv.bash` from the top of an installed tree to point the
current Bash shell at that tree's Experimental Physics and Industrial Control
System (EPICS) base, modules, and tools.

## Prerequisites

- An installed tree built with `make install` and `make symlinks`; see
  [Build and install the environment](build-and-install.md). The script puts
  the `pvxs` and `pmac` tools on `PATH` through the unversioned module links
  that `make symlinks` creates.
- `perl` on `PATH` for automatic architecture detection, or a fallback
  architecture supplied as described in step 3.
- For step 5 only: `readelf` on `PATH`, which the binutils package
  provides. The loader inspects the libraries it is about to load and stops
  before the IOC starts when `readelf` is missing.

1. Source the script of the installed tree:

   ```bash
   source <installed_tree>/setEpicsEnv.bash
   ```

   `<installed_tree>` is the path that `make print-INSTALL_LOCATION_EPICS`
   prints in the EPICS-env clone that built the tree.

   The script prints a summary of the values it set, followed by the full
   `PATH` and `LD_LIBRARY_PATH` and the line `Enjoy Everlasting EPICS!`. The
   summary starts with these lines:

   ```

   Set the EPICS Environment as follows:
   THIS Source NAME    : setEpicsEnv.bash
   THIS Source PATH    : <installed_tree>
   EPICS_BASE          : <installed_tree>/base
   EPICS_HOST_ARCH     : linux-x86_64
   EPICS_MODULES       : <installed_tree>/modules
   ```

   The script derives every path from its own location, so it needs no edit
   when the tree moves. To select another installed version, source that
   tree's setup script. No location or release argument is required.
   It exports these variables:

   | Variable | Value |
   | --- | --- |
   | `EPICS_PATH` | The directory that holds the script |
   | `EPICS_BASE` | `$EPICS_PATH/base` |
   | `EPICS_MODULES` | `$EPICS_PATH/modules` |
   | `EPICS_HOST_ARCH` | The detected architecture, such as `linux-x86_64`, or the supplied fallback |
   | `PATH` | Prepends `modules/pmac/bin/<arch>`, `modules/pvxs/bin/<arch>`, and `base/bin/<arch>` |
   | `LD_LIBRARY_PATH` | Prepends `base/lib/<arch>` |

   `<arch>` is the value of `EPICS_HOST_ARCH`. When `EPICS_BASE` is set before
   you source the script, the script first prints `EPICS_BASE is defined as`
   with that value. It then removes the entries of that tree from `PATH` and
   `LD_LIBRARY_PATH` and adds the entries of the sourced tree. Sourcing a
   second tree therefore replaces the known base, pvxs, and pmac paths of
   the first. Removal compares complete colon-delimited entries. Unrelated
   entries retain their bytes and order, including duplicates and empty
   entries. Repeating setup adds each managed directory once.

   Setup preserves independent settings such as `EPICS_CA_ADDR_LIST` and
   `EPICS_CA_AUTO_ADDR_LIST`. It also works with Bash nounset enabled by
   `set -u`, and preserves the caller's directory, shell options, and
   positional arguments.

2. Optional: to set the same variables without the printed summary, pass
   `disable`:

   ```bash
   source <installed_tree>/setEpicsEnv.bash disable
   ```

   In the shell of step 1, `EPICS_BASE` is set, so the script prints the tree
   that it replaces, followed by two empty lines:

   ```

   EPICS_BASE is defined as <installed_tree>/base


   ```

   In a shell where `EPICS_BASE` is not set, the script prints one empty line.

3. Optional: supply a fallback architecture when Perl or the base discovery
   scripts are unavailable:

   ```bash
   source <installed_tree>/setEpicsEnv.bash linux-x86_64 disable
   ```

   The interface is `[<fallback_arch>] [disable]`. Automatic detection takes
   priority over the fallback. `disable` controls only the summary.
   Invalid argument forms return status 2. If the script cannot determine
   its tree or architecture, it returns status 1 with a diagnostic and
   preserves the existing managed environment. A discovery command that
   fails returns status 1 before the script replaces that environment.

4. Optional: remove the environment from the shell by sourcing the installed
   reset script:

   ```bash
   source <installed_tree>/resetEpicsEnv.bash
   ```

   The output names the tree it removes:

   ```

   EPICS_BASE is defined as <installed_tree>/base

   Reset ...
   ```

   The script removes the `base`, `pvxs`, and `pmac` entries from `PATH`, the
   `base` entry from `LD_LIBRARY_PATH`, and unsets `EPICS_PATH`, `EPICS_BASE`,
   `EPICS_HOST_ARCH`, and `EPICS_MODULES`. It also removes the known legacy
   extension executable entry and unsets `EPICS_EXTENSIONS`. Missing path
   components prevent removal of the corresponding entry; variable unsetting
   also runs when base is absent. Repeated reset succeeds.

   Reset preserves independent CA settings and other unmanaged EPICS
   variables. `install.base` installs both setup and reset with mode 0644.

5. Optional: run an IOC startup file through the loader, which the setup
   script put on `PATH` with the other files of `base/bin/<arch>`:

   ```bash
   iocsh.bash <startup_file>
   ```

   The minimal example of the repository starts an IOC with host and
   process statistics:

   ```bash
   iocsh.bash <repo>/examples/iocsh/st.cmd
   ```

   `<repo>` is the top directory of an EPICS-env checkout. The loader first
   prints how the files reach the IOC, the IOC then reports its startup,
   and the IOC shell prompt appears:

   ```
   iocsh.bash: <repo>/examples/iocsh/st.cmd runs as /dev/fd/4; generated startup runs as /dev/fd/3
   ...
   iocRun: All initialization complete
   ...
   7.0.10 >
   ```

   Type `exit` at the prompt to leave the IOC.

   The startup file names the installed modules it needs, one directive per
   line, and continues with ordinary IOC shell commands. No IOC executable
   is compiled; the loader runs the installed `softIocPVX`:

   ```
   module linStat
   module StreamDevice 2.8.26
   ```

   The first form follows the unversioned link of the module, the second
   selects that exact installed version. The loader also loads the recorded
   dependencies of each module, here `asyn` and `calc` for StreamDevice,
   and sets one environment macro per module, such as `LINSTAT`, to its
   directory. To see the commands it generates without starting an IOC:

   ```bash
   iocsh.bash -n <startup_file>
   ```

   For the minimal example of the repository the output is as follows;
   the number of dependency edges depends on the libraries of the host:

   ```
   # iocsh.bash: generated startup for <repo>/examples/iocsh/st.cmd (runs as /dev/fd/3)
   # iocsh.bash: static ELF inspection of 74 dependency edges; resolved files as class, owner, file
   on error break
   # linStat 1.2.1
   dlload("<installed_tree>/modules/linStat-1.2.1/lib/linux-x86_64/liblinStat.so")
   dbLoadDatabase("<installed_tree>/modules/linStat-1.2.1/dbd/linStat.dbd", "<installed_tree>/modules/linStat-1.2.1/dbd:<installed_tree>/base/dbd:<installed_tree>/modules/pvxs-1.5.2/dbd", "")
   epicsEnvSet("LINSTAT", "<installed_tree>/modules/linStat-1.2.1")
   registerAllRecordDeviceDrivers(pdbbase)
   iocshLoad("/dev/fd/4")
   # iocsh.bash: <repo>/examples/iocsh/st.cmd runs as /dev/fd/4 with 26 lines, directives replaced by comments
   ```

   Between the second and third line the output also lists each resolved
   library as a line that starts with `# elf:`. The repository holds these
   startup files for the loader:

   | Path under `examples/iocsh` | Application | Modules named | Needs |
   | --- | --- | --- | --- |
   | `st.cmd` | None; host and process statistics | `linStat` | Nothing else |
   | `tc32sim/` | <https://github.com/jeonghanlee/tc32sim> | `StreamDevice`, `linStat`, `retools`, `autosave`, `caPutLog` | The application's simulator and `iocLogServer` |
   | `EPICS-IOC-Demo/` | <https://github.com/jeonghanlee/EPICS-IOC-Demo> | `StreamDevice` | The application's simulator |
   | `opcua-IOC-demo/` | <https://github.com/jeonghanlee/opcua-IOC-demo> | `opcua` | An OPC UA demo server |

   Each directory holds a `README.md` with the preparation, the commands,
   and the expected results. Its `prepare.bash` checks out the application
   at a recorded revision through `examples/iocsh/checkout_application.bash`
   and uses the application files unchanged.
   [Tools and scripts reference](../reference/tools-and-scripts.md#behavior-details-of-the-tools)
   gives the directive forms, the version rules, and the messages.

## Verification

- Check that the shell finds the EPICS tools in the installed tree:

  ```bash
  command -v softIoc caget pvget pvxget iocsh.bash
  ```

  Each tool resolves inside `<installed_tree>`:

  ```
  <installed_tree>/base/bin/linux-x86_64/softIoc
  <installed_tree>/base/bin/linux-x86_64/caget
  <installed_tree>/base/bin/linux-x86_64/pvget
  <installed_tree>/modules/pvxs/bin/linux-x86_64/pvxget
  <installed_tree>/base/bin/linux-x86_64/iocsh.bash
  ```
