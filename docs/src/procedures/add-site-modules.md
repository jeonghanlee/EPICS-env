# Add the site modules to an installed tree

The site modules of a facility live in their own repository, the site module
repository, whose `configure/` and `tools/` follow the make rules of
EPICS-env. This page builds those modules into an installed EPICS-env tree
with the same targets and checks as the modules of EPICS-env. The example
builds the two modules `siteApps` and `unidrv` of one site module repository.
Run every command from the top of the clone of the site module repository.

## Prerequisites

- An installed EPICS-env tree; see
  [Build and install the environment](build-and-install.md). `<tree>` is its
  path, `<install_location>/<release>/<os_id>-<os_version>/<base_version>`,
  the directory that holds `base`, `modules`, and `setEpicsEnv.bash`.
- Read access to the site module repository and to the repositories of its
  modules. `<site_repository>` is the Git URL of the site module repository;
  `configure/RELEASE` of that repository names the URL of each module.
- `python3` and `readelf` on `PATH`.
- For the IOC check of the Verification section, the setup script of the
  tree sourced in the shell, which puts `iocsh.bash` on `PATH`; see
  [Set up a shell with the environment](set-up-shell.md).

1. Clone the site module repository and enter the clone:

   ```bash
   git clone <site_repository> <checkout>
   cd <checkout>
   ```

   `<checkout>` is the directory of the clone.

2. In `configure/CONFIG_SITE.local`, name the installed tree:

   ```bash
   echo "INSTALL_LOCATION:=<tree>" > configure/CONFIG_SITE.local
   ```

   Unlike the `INSTALL_LOCATION` of EPICS-env, this value is the tree itself,
   not the directory above the release. The file is untracked.

3. Print the tree and the privilege check:

   ```bash
   make print-INSTALL_LOCATION_EPICS
   make print-SUDO_INFO
   ```

   The first command prints `<tree>`, and the second prints `0` when your user
   can create or write the `modules` directory of the tree. An action target
   stops with
   `INSTALL_LOCATION must name an installed EPICS-env tree with a base
   directory` when the tree has no `base` directory.

4. Clone the modules at their tags:

   ```bash
   make init
   ```

   Each module lands in a `<module>-src` directory at the top of the clone,
   such as `siteApps-src`. The output ends with the checked-out commit of the
   last module:

   ```
   HEAD is now at 3759413 Merge branch 'CT-1133' into 'master'
   ```

5. Apply the downstream patches of the modules:

   ```bash
   make patch
   ```

   The output prints one `Patching` line per patch file and the files each
   patch changes. The site module repository of the example carries one
   patch, which adds the support DBD that the loader metadata of `unidrv`
   needs:

   ```

   Patching unidrv-src with the file : unidrv-supportdbd.p0.patch
   patching file unidrvApp/src/Makefile
   patching file unidrvApp/src/unidrvSupport.dbd
   ```

6. Write the site configuration of the modules:

   ```bash
   make conf
   ```

   The command prints nothing. It writes `RELEASE.local` and
   `CONFIG_SITE.local` at the top of the clone, which point the modules at
   the `base` of the tree, and the `CONFIG_SITE.local` of each module, which
   holds its install directory. `make conf.show` prints the four files.

7. Check that every module declares the dependencies that its sources use:

   ```bash
   make check.module-deps
   ```

   The report is the one of [Add or bump a module](add-or-bump-module.md),
   step 12, for each module. The command exits 2 with
   `Strict dependency check failed` when a module source names a template or
   a token that no module or alias matches. Such a finding is a question for
   the maintainer of that module, not a condition of the build: continue with
   step 8 and report the finding with the result.

8. Build and install the modules:

   ```bash
   make build
   make install
   ```

   Each module installs into `<tree>/modules/<module>-<version>` as it builds,
   and the build writes the loader metadata `cfg/iocsh.conf` of the module;
   see [Installed module loader](../concepts/installed-module-loader.md).
   `make install` repeats the install step of each module and exits 0, so
   that the sequence is that of the EPICS-env build.

9. Create the unversioned module links:

   ```bash
   make symlinks
   ```

   The command prints nothing.

## Verification

List the site entries of the modules directory:

```bash
LC_ALL=C make exist.modules LEVEL=1 | grep -e siteApps -e unidrv
```

The modules directory holds the install directory and the link of each
module:

```
|-- siteApps -> ./siteApps-0.1.0
|-- siteApps-0.1.0
|-- unidrv -> ./unidrv-0.5.1
`-- unidrv-0.5.1
```

Run the runpath and environment gates on the tree:

```bash
make check.deps check.env > /dev/null 2>&1; echo $?
```

The output is `0`. The gates are those of
[Run the verification gates](run-verification-gates.md), run on the whole
tree, the site modules included.

Revert and apply the downstream patches, and list the changes in the source
directory of the patched module:

```bash
make patch.revert
make patch > /dev/null; echo $?
git -C unidrv-src status --short
```

The revert prints the patch and its files, the apply prints `0`, and the
status lists the files of the patch and nothing else:

```
Reverting applied patch: source=unidrv-src patch=<checkout>/patch/unidrv-supportdbd.p0.patch
patching file unidrvApp/src/Makefile
patching file unidrvApp/src/unidrvSupport.dbd
0
 M unidrvApp/src/Makefile
?? unidrvApp/src/unidrvSupport.dbd
```

Start an IOC that loads the modules through the installed loader. In a
directory outside the clone, write `st.cmd` with the modules and one record
of `unidrv`; the templates of `siteApps` use the device support of
`ether_ip`, so the IOC loads that module first:

```
module ether_ip
module siteApps
module unidrv
IO("TESTIO", "tcp://127.0.0.1:9")
dbLoadRecords("$(UNIDRV)/db/unidrv_io_stats.db", "P=STATS:,IO=TESTIO")
iocInit
```

Then, from that directory, start it through the loader, as in
[Run an IOC from installed modules](run-ioc-from-installed-modules.md):

```bash
iocsh.bash st.cmd
```

The IOC prints `iocRun: All initialization complete` and the IOC shell
prompt appears. Type `exit` to leave. In a shell without a terminal, send
the command on standard input: `printf 'exit\n' | iocsh.bash st.cmd` exits
with status 0 after the same line.

Show the generated startup of the same file:

```bash
iocsh.bash -n st.cmd
```

The output names the three modules with their installed versions:

```
# ether_ip 3.10.0
# siteApps 0.1.0
# unidrv 0.5.1
```
