# Uninstall and clean

Remove the installed tree and the cloned sources of one EPICS-env clone, and
keep its `.local` settings files for the next build.

## Prerequisites

- The EPICS-env clone that built the tree, with the same
  `configure/CONFIG_SITE.local`. The targets compute the tree path from it;
  `make print-INSTALL_LOCATION_EPICS` prints the path they act on.
- Write access to the installed tree. `make uninstall` removes the tree as
  your user and does not use `sudo`.

1. Optional: to remove the installed files of one module, run its uninstall
   target before you remove the tree:

   ```bash
   make uninstall.<module>
   ```

   `<module>` is the module name without the version, such as `asyn`; the
   `Module` column of
   [Module pins and dependencies](../reference/module-pins.md#module-repositories-and-pins)
   lists every name. The target runs `make uninstall` in the module source
   tree, which reads the installed base, and leaves an empty module
   directory. `make uninstall.std` stops with an error, because a test
   input/output controller (IOC) inside the `std` sources names a base path
   that does not exist. For the same reason, `make uninstall.modules` stops
   at `std`: the modules before `std` in its order, and `std` itself, are
   emptied, and no module directory is removed.

2. Optional: to remove the build products and the installed files of one
   module and keep its sources, run its clean target before you remove the
   tree:

   ```bash
   make distclean.<module>
   ```

   The target runs `make distclean` in the module source tree. The EPICS
   `distclean` target also uninstalls, so the target leaves an empty module
   directory in the installed tree, as `make uninstall.<module>` does.
   `make clean.modules` runs this target for every module and stops at `std`
   in the same way as `make uninstall.modules`.

3. Remove the installed tree:

   ```bash
   make uninstall
   ```

   The output names the path that the target removes:

   ```
   Removing <install_location>/1.4.0/debian-13/7.0.10...
   ```

   `<install_location>` is the value of `INSTALL_LOCATION`. The target
   removes the whole tree for the current release, operating system, and base
   version, including the `vendor` directory, and leaves other trees under
   `<install_location>` in place.

4. Remove the cloned sources:

   ```bash
   make distclean
   ```

   The target removes `epics-base-src`, every module source tree, and
   `configure/MODULESGEN.mk`. Make writes
   `configure/MODULESGEN.mk` again on the next action invocation. Query-only
   invocations leave it absent and derive current module variables in memory.
   To remove only part of this set, run
   `make distclean.base`, `make distclean.modules`, or
   `make distclean.modulesgen`.

5. Remove the version file that `make install` wrote in the clone:

   ```bash
   make src_clean
   ```

   The target removes `site-template/.versions`.

The `.local` files stay: `configure/CONFIG_SITE.local`,
`configure/RELEASE.local`, and the `RELEASE.local` and `CONFIG_SITE.local`
that `make conf` wrote at the repository top. A later
[build](build-and-install.md) reuses the first two, and `make conf` rewrites
the other two.

## Verification

1. Check that the installed tree is gone:

   ```bash
   LC_ALL=C make exist
   ```

   The output is:

   ```
   No <install_location>/1.4.0/debian-13/7.0.10
   ```

2. Check that no source tree is left:

   ```bash
   ls -d *-src
   ```

   The output is:

   ```
   ls: cannot access '*-src': No such file or directory
   ```
