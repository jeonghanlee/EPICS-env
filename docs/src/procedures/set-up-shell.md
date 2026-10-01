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

## Verification

- Check that the shell finds the EPICS tools in the installed tree:

  ```bash
  command -v softIoc caget pvget pvxget
  ```

  Each tool resolves inside `<installed_tree>`:

  ```
  <installed_tree>/base/bin/linux-x86_64/softIoc
  <installed_tree>/base/bin/linux-x86_64/caget
  <installed_tree>/base/bin/linux-x86_64/pvget
  <installed_tree>/modules/pvxs/bin/linux-x86_64/pvxget
  ```
