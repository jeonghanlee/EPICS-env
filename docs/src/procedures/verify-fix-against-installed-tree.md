# Verify a fix against an installed tree

Some module fixes show their effect only with the hardware that a running
input/output controller (IOC) drives. To verify such a fix, you build the
fixed module and a copy of that IOC beside the installed tree, and run the
copy in place of the production IOC. The procedure reads the installed tree
and never writes to it. `tools/verify_fix_build.bash` builds both copies
and checks their links, and `tools/pv_snapshot.bash` compares process
variable (PV) values before, during, and after the run. The example verifies a `StreamDevice` fix with a consumer
IOC named `sdemo`.

## Prerequisites

- The installed tree `<tree>` holds `base/`, `modules/`, `vendor/`, and
  `setEpicsEnv.bash`; see [the installed tree](../concepts/installed-tree.md).
- A moved native Linux tree has completed
  [installed metadata refresh](move-installed-tree.md) before this procedure.
  The fix-verification helper reads the selected tree and does not refresh it.
- An EPICS-env checkout `<env_checkout>` at the release that `<tree>` was
  built from.
- The fix as a patch with `a/` and `b/` path prefixes, such as the output of
  `git diff` in a fork of the module, and the commit `<base_commit>` of the
  module that the patch applies to.
- The consumer IOC repository and the commit that production runs. The IOC
  `configure/RELEASE` names the module by its key, such as `STREAM`.
- A PV list file with one PV name per line, holding the PVs whose values the
  fix must not change. Blank lines and `#` comments are ignored.
- `caget` in `PATH`, and the authority to stop and restart the production
  IOC.

1. In the checkout, clone the module source, which also generates
   `configure/MODULESGEN.mk`:

   ```bash
   make -C <env_checkout> STREAM
   ```

   `<env_checkout>` is the path of the EPICS-env checkout, and `STREAM` is the
   module key, the `Key` column of
   [Module pins and dependencies](../reference/module-pins.md#module-repositories-and-pins).

2. Write the configuration of the module in the checkout:

   ```bash
   make -C <env_checkout> conf.release.modules conf.StreamDevice
   ```

   The tool reads the module's own settings, such as vendor paths, from this
   configuration.

   On Ubuntu 26, check the generated C17 setting before building:

   ```bash
   grep -Fxc 'USR_CFLAGS += -std=gnu17' <env_checkout>/StreamDevice-src/configure/CONFIG_SITE.local
   ```

   A checkout with per-module C17 configuration prints `1`. Release `1.4.0`
   does not add this setting through `conf.StreamDevice`; the check prints
   `0` and exits 1. For that result, append the setting:

   ```bash
   printf '%s\n' 'USR_CFLAGS += -std=gnu17' >> <env_checkout>/StreamDevice-src/configure/CONFIG_SITE.local
   ```

   Repeat the check; it must print `1` before you continue. Resolve any read
   error or duplicate setting first. Repeat this check after rerunning the
   configuration command, because it rewrites the file. Skip this C17 check
   and append on other operating systems.

3. Create the scratch directories, named after the installed module and the
   IOC binary:

   ```bash
   mkdir -p <scratch_dir>/StreamDevice <scratch_dir>/sdemo
   ```

   `<scratch_dir>` is a directory outside `<tree>` and outside any checkout.
   The module directory name must equal the directory name in
   `<tree>/modules`, and the IOC directory name must equal the IOC binary
   name.

4. Export the module source at the commit the fix applies to:

   ```bash
   git -C <module_source> archive <base_commit> | tar -x -C <scratch_dir>/StreamDevice
   ```

   `<module_source>` is a clone of the module that holds `<base_commit>`,
   such as the fork of the fix or `<env_checkout>/StreamDevice-src`.
   `<base_commit>` must be the pin of the installed module, `SRC_TAG_STREAM`
   in the example; otherwise the copy carries changes unrelated to the fix.

5. If the fix is not one of the patch files in `<env_checkout>/patch`,
   apply it:

   ```bash
   patch -d <scratch_dir>/StreamDevice -p1 < <fix_patch>
   ```

   `<fix_patch>` is the path of the fix patch.

6. Apply each file from `<env_checkout>/patch` that the `patch` target
   applies to the module on this platform, in the order of that target.
   `configure/RULES_SRC` defines the `patch` target, and
   `configure/RULES_PATCH` names the file that each module target applies.
   For `StreamDevice`, the target applies one file:

   ```bash
   patch -d <scratch_dir>/StreamDevice --ignore-whitespace -p0 < <env_checkout>/patch/StreamDevice-no-vxi11.p0.patch
   ```

   The directory also holds files that no target applies on this platform,
   such as `mca-libnet.p0.patch`, which applies only on macOS.
   [Upstream patch targets](../reference/make-targets.md#upstream-patch-targets)
   lists the patch target of each module and the name pattern of each
   carry set.

7. Export the consumer IOC at its production commit:

   ```bash
   git -C <ioc_repository> archive <ioc_commit> | tar -x -C <scratch_dir>/sdemo
   ```

   `<ioc_repository>` is a clone of the IOC repository, and `<ioc_commit>` is
   the commit production runs.

8. Load the environment of the installed tree:

   ```bash
   source <tree>/setEpicsEnv.bash
   ```

   The tool takes the tree from `EPICS_BASE`, which this script sets to
   `<tree>/base`.

9. Build the module and the IOC copy against the tree:

   ```bash
   <env_checkout>/tools/verify_fix_build.bash <scratch_dir>/StreamDevice <scratch_dir>/sdemo
   ```

   The tool writes `configure/RELEASE.local` and `configure/CONFIG_SITE.local`
   in both copies. The module takes its dependencies from
   `<tree>/modules/StreamDevice/configure/RELEASE.local` and its own settings
   from `conf.StreamDevice.show` in the checkout, with vendor paths pointed at
   `<tree>/vendor`. The IOC takes the module from `<scratch_dir>/StreamDevice`
   through the module key.

   The tool then runs four checks. The copy must rebuild every library that
   the installed module provides, and each rebuilt library must resolve the
   same shared libraries. Runpaths must name only `<tree>`, `$ORIGIN`, and,
   for the IOC, the module copy. The IOC must link the module from the copy.
   Finally, the build must write no file under `<tree>`. In this output,
   `<tree>` and `<scratch_dir>` stand for the paths of the run:

   ```
   [verify_fix_build.bash] production tree: <tree>
   [verify_fix_build.bash] module: <scratch_dir>/StreamDevice
   [verify_fix_build.bash] IOC: <scratch_dir>/sdemo
   [verify_fix_build.bash] module dependencies from the production tree: 3 entries
   [verify_fix_build.bash] dependency cross-check: EPICS-env checkout matches the installed module
   [verify_fix_build.bash] module build: OK
   [verify_fix_build.bash] module libraries (libstream.so): runpath only the production tree
   [verify_fix_build.bash] module libraries resolve the same shared libraries as production
   [verify_fix_build.bash] IOC build: OK; links 1 module library from the module directory
   [verify_fix_build.bash] production tree untouched

   ----------------------------------------------------------------
   Steps 2-3 PASSED: StreamDevice and sdemo against <tree>
   Build logs: <scratch_dir>/module-build.log, <scratch_dir>/ioc-build.log
   ----------------------------------------------------------------
   Steps 4-5 (manual, one IOC at a time):
     1. tools/pv_snapshot.bash capture -l <pvlist> -o before.txt  (production running)
     2. stop the production IOC; start the copy from its iocBoot with the defect visible
     3. observe the defect check; capture after.txt
     4. stop the copy; restart production; capture restored.txt
     5. tools/pv_snapshot.bash compare -t <tolerance> before.txt after.txt
        tools/pv_snapshot.bash compare -t <tolerance> before.txt restored.txt
   ```

   The closing lines summarize steps 10 to 18 and the verification of this
   page. The tool exits 0 when every check passes or on `--help`, and 2 when
   it does not receive exactly two arguments. It exits 1 on any other
   failure, such as a missing directory, an unset `EPICS_BASE`, a failed
   build, or a failed check. When the checkout's module dependencies differ
   from those of the installed module, the tool shows the difference and asks
   for confirmation on the terminal. The file `<scratch_dir>/.started` marks
   the start of the run.

10. In the copy's `iocBoot/<instance>/st.cmd`, remove any setting that hides
    the defect, such as an `asynSetTraceMask` call that silences errors.
    `<instance>` is the directory under `iocBoot` that holds the startup
    script of the IOC, such as `iocsdemo`.

11. While the production IOC runs, capture the `before` snapshot:

    ```bash
    <env_checkout>/tools/pv_snapshot.bash capture -l <pv_list> -o before.txt
    ```

    `<pv_list>` is the PV list file. The command reports the count:

    ```
    pv_snapshot.bash: 3 PVs captured to before.txt, 0 not connected
    ```

    A PV that does not connect is written as `__DISCONNECTED__`. The option
    `-w <seconds>` sets the Channel Access (CA) timeout, 2.0 seconds by
    default.

12. Stop the production IOC.

13. Start the copy from `<scratch_dir>/sdemo/iocBoot/<instance>`, the
    directory of step 10.

14. Observe the defect check with the copy running; the defect must not
    appear.

15. While the copy runs, capture the `after` snapshot:

    ```bash
    <env_checkout>/tools/pv_snapshot.bash capture -l <pv_list> -o after.txt
    ```

16. Stop the copy.

17. Restart the production IOC.

18. Capture the `restored` snapshot:

    ```bash
    <env_checkout>/tools/pv_snapshot.bash capture -l <pv_list> -o restored.txt
    ```

## Verification

Compare the snapshot taken while the copy ran, and the snapshot taken after
the restart, with the `before` snapshot:

```bash
<env_checkout>/tools/pv_snapshot.bash compare -t 0.001 before.txt after.txt
<env_checkout>/tools/pv_snapshot.bash compare -t 0.001 before.txt restored.txt
```

`-t` sets the largest numeric difference that counts as `WITHIN`; choose it
before the run. Each command prints one line per PV and a summary:

```
SAME	VFD:Setpoint	1.5	1.5	
SAME	VFD:Mode	2	2	
SAME	VFD:Label	demo	demo	
# PVs 3: SAME 3, WITHIN 0, DIFF 0, MISSING 0, DISCONN 0; tolerance 0.001
```

Each command exits 0 when every PV is `SAME` or `WITHIN`, 1 when a PV is
`DIFF`, `MISSING`, or `DISCONN`, and 2 on a usage or runtime error. Check
that no file under the tree was written since the run started:

```bash
find <tree> -type f \( -newer <scratch_dir>/.started -o -cnewer <scratch_dir>/.started \)
```

The command prints nothing.
