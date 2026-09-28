# Set up a shell with the environment

Source `setEpicsEnv.bash` from the top of an installed tree to point the
current Bash shell at that tree's Experimental Physics and Industrial Control
System (EPICS) base, modules, and tools.

## Prerequisites

- An installed tree built with `make install` and `make symlinks`; see
  [Build and install the environment](build-and-install.md). The script puts
  the `pvxs` and `pmac` tools on `PATH` through the unversioned module links
  that `make symlinks` creates.
- `perl` on `PATH`. The script runs the `EpicsHostArch.pl` script of the
  installed base to find the host architecture.

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
   when the tree moves. It exports these variables:

   | Variable | Value |
   | --- | --- |
   | `EPICS_PATH` | The directory that holds the script |
   | `EPICS_BASE` | `$EPICS_PATH/base` |
   | `EPICS_MODULES` | `$EPICS_PATH/modules` |
   | `EPICS_HOST_ARCH` | The output of `EpicsHostArch.pl`, such as `linux-x86_64` |
   | `PATH` | Prepends `modules/pmac/bin/<arch>`, `modules/pvxs/bin/<arch>`, and `base/bin/<arch>` |
   | `LD_LIBRARY_PATH` | Prepends `base/lib/<arch>` |

   `<arch>` is the value of `EPICS_HOST_ARCH`. When `EPICS_BASE` is set before
   you source the script, the script first prints `EPICS_BASE is defined as`
   with that value. It then removes the entries of that tree from `PATH` and
   `LD_LIBRARY_PATH` and adds the entries of the sourced tree. Sourcing a
   second tree therefore replaces the first.

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

3. Optional: to remove the environment from the shell, go to the top of an
   EPICS-env clone and source `resetEpicsEnv.bash` from its `scripts`
   directory:

   ```bash
   source scripts/resetEpicsEnv.bash
   ```

   The output names the tree it removes:

   ```

   EPICS_BASE is defined as <installed_tree>/base

   Reset ...
   ```

   The script removes the `base`, `pvxs`, and `pmac` entries from `PATH`, the
   `base` entry from `LD_LIBRARY_PATH`, and unsets `EPICS_BASE`,
   `EPICS_HOST_ARCH`, and `EPICS_MODULES`. It leaves `EPICS_PATH` set.
   `make install` does not copy this script into the installed tree.

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
