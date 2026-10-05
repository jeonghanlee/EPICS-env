# Add or bump a module

A module enters the Experimental Physics and Industrial Control System
(EPICS) environment through a pin in `configure/RELEASE`, and make derives its
clone, configuration, build, and install targets from that pin. This page
changes the pin of one module, or adds a module, and builds only that module.
[The module set](../concepts/module-set.md) explains how the declarations
fit together. Run every command from the top of the EPICS-env checkout. The example bumps
`caPutLog` from `dafb0b2` to `6f9eb3f`.

## Prerequisites

- EPICS base is installed at the install location; see
  [Build and install the environment](build-and-install.md).
- `make init` and `make conf` have run in the checkout, so the source trees
  of the module's dependencies and the top-level `RELEASE.local` exist.
- The module key, the module name, and the current pin of an existing module
  are listed in [Module pins and dependencies](../reference/module-pins.md#module-repositories-and-pins).

1. Optional: To list the modules whose pin differs from the latest upstream
   tag or commit, survey the pins without changing any file:

   ```bash
   tools/update-release.bash check
   ```

   The survey reads `configure/RELEASE`, not the `.local` override files. The
   entry for `caPutLog` reads:

   ```
   CAPUTLOG       : UPDATE AVAILABLE
       Current: dafb0b2
       Latest:  6f9eb3f
       Date:    2026-02-26
       >> Diff Link: https://github.com/epics-modules/caPutLog/compare/dafb0b2...6f9eb3f
   ```

   The command exits 0 when every pin was surveyed, 1 when a repository was
   unreachable or a pin has no repository Uniform Resource Locator (URL)
   comment, and 2 when a repository has no release tag.

2. Set the pin of the module.

   a. To bump a module, set `SRC_TAG_<module_key>` to the tag or commit to
      check out and `SRC_VER_<module_key>` to the version that names the
      install directory. In `configure/RELEASE` the change becomes the pin of
      the release; in `configure/RELEASE.local` it applies to this checkout
      only, because make reads `configure/RELEASE.local` after
      `configure/RELEASE`:

      ```makefile
      SRC_TAG_CAPUTLOG:=6f9eb3f
      SRC_VER_CAPUTLOG:=6f9eb3f
      ```

      A tag pin takes the form `tags/<tag>`, such as `tags/R4-46`, or the bare
      tag name, such as `2-7-9` for `pmac`.

   b. To add a module, add a block before the two `-include` lines at the end
      of `configure/RELEASE`. The comment line holds the repository URL that
      `tools/update-release.bash` surveys:

      ```makefile
      ## https://github.com/<organization>/<module>
      SRC_NAME_<module_key>:=<module>
      SRC_TAG_<module_key>:=<tag_or_commit>
      SRC_VER_<module_key>:=<version>
      ```

      `<organization>` is the GitHub organization or user that hosts the
      repository, such as `epics-modules`. `<module_key>` is an upper-case
      key of your choice, such as `CAPUTLOG`. `<module>` is the
      repository name; the source directory is `<module>-src`, and the
      module targets use `<module>`, such as `build.<module>`.
      `<tag_or_commit>` and `<version>` are the pin and the version as in
      sub-step a.

3. If you are adding a module that is not hosted under
   `https://github.com/epics-modules`, set its repository base in
   `configure/RELEASE`, in the block of the module before its triple:

   ```makefile
   SRC_BASE_<module_key>=$(SRC_URL_<org_key>)
   ```

   `<org_key>` is the upper-case key of an organization URL that
   `configure/RELEASE` defines. Most of these URLs are at the top of the
   file, such as `SRC_URL_MD`; a few are in the block of their module, such
   as `SRC_URL_PMAC`. When none matches, add a line such as
   `SRC_URL_<org_key>:=https://github.com/<organization>` to the block of the
   module, above the `SRC_BASE_<module_key>` line. Write `SRC_BASE_<module_key>` with `=` and
   not `:=`, so that a `SRC_URL_<org_key>` set in `RELEASE.local`, which
   `configure/RELEASE` reads last, reaches the module.

4. If you are adding a module, declare its build prerequisites and its
   configuration type. In `configure/CONFIG_MODS_DEPS`, declare the prerequisites:

   ```makefile
   <module>_DEPS:=null.base build.<dependency>
   ```

   `<module>_DEPS` starts with `null.base` and lists, in build order, the
   `build.<dependency>` target of each module that must be built first; a
   module that needs only EPICS base uses `null.base` alone.
   In `configure/CONFIG_MODS_TYPES`, declare the configuration type:

   ```makefile
   <module>_CONF_TYPE:=custom
   ```

   `<module>_CONF_TYPE` is `auto` or `custom`. Make stops every command with
   `Missing <module>_CONF_TYPE declaration` until this line exists.

   The build in step 13 also writes the metadata that the `iocsh.bash`
   loader reads. It expects the library `lib<module>.so` and the database
   definition file `<module>.dbd` in the installed module. When the module
   installs other names, several files, or none, declare them in
   `configure/CONFIG_MODS_IOCSH`; otherwise step 13 stops with
   `Library entry for <module> is absent` or `DBD entry for <module> is
   absent`:

   ```makefile
   <module>_IOCSH_LIBS:=<library_name>
   <module>_IOCSH_DBDS:=<dbd_file>
   ```

   `<library_name>` is the library without the `lib` prefix and the `.so`
   suffix. An empty value declares a module without a library or without a
   database definition file.
   [Loader entries in CONFIG_MODS_IOCSH](../concepts/module-set.md#loader-entries-in-config_mods_iocsh)
   lists the current declarations and what the build rejects.

5. If you are adding a module, provide its configuration target.

   a. For an `auto` module, make generates `conf.<module>`, which writes
      `INSTALL_LOCATION` into the module's `configure/CONFIG_SITE.local`.
      Choose `auto` only when the module's own `configure/CONFIG_SITE` reads
      `$(TOP)/configure/CONFIG_SITE.local` and the module needs no
      dependency path; otherwise the module installs into its source tree.
      Three optional variables in `configure/CONFIG_MODS_DEPS` extend the
      generated target, as for `iocStats`, `retools`, and `MCoreUtils`:

      ```makefile
      iocStats_CONF_RELEASE_LINES:=MAKE_TEST_IOC_APP=NO
      retools_CONF_SITE_LINES:=USR_CPPFLAGS += -DUSE_TYPED_RSET
      MCoreUtils_CONF_PLATFORM:=Linux
      ```

      The target writes `<module>_CONF_RELEASE_LINES` into the module's
      `configure/RELEASE.local` and appends `<module>_CONF_SITE_LINES` to
      its `configure/CONFIG_SITE.local`. When `<module>_CONF_PLATFORM` is
      set, the target acts only on a host whose `uname -s` output matches it.

   b. For a `custom` module, add `conf.<module>` and `conf.<module>.show` to
      `configure/RULES_MODS_CONFIG`. The rule writes each dependency path
      from its `INSTALL_LOCATION_<module_key>` variable, as `conf.modbus`
      does:

      ```makefile
      conf.modbus:
      	@echo "ASYN=$(INSTALL_LOCATION_ASYN)"                > $(TOP)/$(SRC_PATH_MODBUS)/configure/RELEASE.local
      	@echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_MODBUS)" > $(TOP)/$(SRC_PATH_MODBUS)/configure/CONFIG_SITE.local

      conf.modbus.show: conf.release.modules.show
      	cat -b $(TOP)/$(SRC_PATH_MODBUS)/configure/RELEASE.local
      	cat -b $(TOP)/$(SRC_PATH_MODBUS)/configure/CONFIG_SITE.local
      ```

      Also list `conf.<module>.show` in `QUERY_SHOW_TARGETS` in
      `configure/CONFIG_GOALS`, so the target takes the query-only path.

   c. For a `custom` module, append `conf.<module>` to
      `MODS_ZERO_CUSTOM_VARS` when the module needs only EPICS base, or to
      `MODS_ONE_VARS` when it needs other modules, in
      `configure/RULES_MODS_CONFIG`. Do not edit `MODS_ZERO_VARS`: make builds
      it from `MODS_ZERO_CUSTOM_VARS` and the generated `auto` targets.

      These lists group configuration targets; `<module>_DEPS` controls
      build order. QPC and sscan belong to `MODS_ONE_VARS` because their
      effective configuration names `ASYN` and `SNCSEQ`, respectively.

6. If another module's configuration names the added module by its key, map
   the key to the module name in `configure/CONFIG_MODS_AUDIT`, so the
   dependency audit resolves it:

   ```makefile
   AUDIT_MODULE_ALIASES+=<module_key>=<module>
   ```

7. Optional: To force regeneration of `configure/MODULESGEN.mk`, which
   holds each module's repository URL, source directory, and install
   directory, run:

   ```bash
   make reconf.modules
   ```

   Make regenerates this file automatically when `configure/RELEASE` or
   `configure/CONFIG_SITE` changes, or when the effective module triples
   change. Creating, editing, or removing a pin override in
   `configure/RELEASE.local` or `../RELEASE.local` takes effect on the next
   action invocation. Variable queries use the effective pins immediately
   without generating or rewriting the cache. This optional command removes the generated files
   under `configure/` and regenerates `MODULESGEN.mk` from the current settings.

8. Print the install directory of the module:

   ```bash
   make print-INSTALL_LOCATION_CAPUTLOG
   ```

   The last path component carries the version from step 2:

   ```
   <install_location>/1.4.0/debian-13/7.0.10/modules/caPutLog-6f9eb3f
   ```

   `<install_location>` is the `INSTALL_LOCATION` of the checkout.

9. If you are bumping a module, remove its source tree, because the clone
   target skips a directory that exists:

   ```bash
   rm -rf caPutLog-src
   ```

10. Clone the module and check out its pin:

    ```bash
    make CAPUTLOG
    ```

    The target is the module key. The last line of the output names the
    checked-out commit:

    ```
    HEAD is now at 6f9eb3f Bumped compatibility to EPICS 3.15.9 in the documentation
    ```

11. Write the configuration files of the module:

    ```bash
    make conf.caPutLog
    ```

    A few configuration targets differ from the module name, such as
    `conf.sncseq` for `sequencer`; see
    [Source configuration targets](../reference/make-targets.md#source-configuration-targets).

12. Check the declared dependencies against the module source:

    ```bash
    make check.module-deps MODULE=caPutLog
    ```

    The report ends with the findings of the module:

    ```
    Module: caPutLog
    Declared: null.base
    Observed:
    Findings:
      none
    ```

    The command exits 2 when the source uses a module that `<module>_DEPS`
    does not declare, or a token that no module name or alias matches.

13. Build and install the module:

    ```bash
    make build.caPutLog
    ```

    The target builds the modules in `<module>_DEPS` first, and each module
    installs as it builds.

14. Point the unversioned link of the module at the install directory from
    step 8:

    ```bash
    make symlink.caPutLog
    ```

15. If other modules list `build.<module>` in their `_DEPS`, reconfigure and
    rebuild them, because their configuration names the install directory
    of the pin they were built with; see
    [Build and install the environment](build-and-install.md). Until such a
    module is rebuilt, its loader metadata records the replaced pin, so
    `iocsh.bash` loads it with the replaced version of this module, and
    `make install.<module>` for it stops with
    `Declared dependencies differ from the build record`.

## Verification

List the installed module directory:

```bash
make ls.INSTALL_LOCATION_CAPUTLOG
```

The directory holds the installed module:

```
cfg
configure
dbd
include
lib
```

`cfg` holds the loader metadata that the build wrote.

Show the link in the modules directory:

```bash
make ls.INSTALL_LOCATION_MODS LSOPTS=-l | grep caPutLog
```

`<user>` is your user and group. The link points at the directory of the pin
from step 2. A bump does not
remove the install directory of the replaced pin, so `caPutLog-dafb0b2`
stays in place:

```
lrwxrwxrwx  1 <user> <user>  18 Sep 26 23:49 caPutLog -> ./caPutLog-6f9eb3f
drwxrwxr-x  6 <user> <user> 120 Sep 26 23:49 caPutLog-6f9eb3f
drwxrwxr-x  6 <user> <user> 120 Sep 26 22:48 caPutLog-dafb0b2
```
