# Add a module site patch

A module site patch fixes a bug in one pinned module that upstream has not
fixed. It is a patch file in `patch/` with three make targets, so `make patch`
applies it after `make init` and `make patch.revert` removes it. The example
adds `sscan-example.p0.patch`, a one-line comment change in
`sscanApp/src/sscanRecord.c`, with the target prefix `patch.sscan.example`.
[Upstream patch carry](../concepts/upstream-patch-carry.md) explains the kinds
of downstream patch; an EPICS base site patch needs no target and is described
there. Run every command from the top of the EPICS-env checkout.

## Prerequisites

- `make init` and `make patch` have run, so the source directory of the module
  holds the pinned source with its downstream patches applied.
- The fix works: you built and tested the module with it. Steps 11 through 14
  of [Add or bump a module](add-or-bump-module.md) configure, check, build, and
  link one module from its source directory.

1. Print the source directory of the module, the directory in which the patch
   applies:

   ```bash
   make print-SRC_PATH_<module_key>
   ```

   `<module_key>` is the upper-case key of the module, such as `SSCAN`. The
   `Key` column of [Module pins and dependencies](../reference/module-pins.md)
   lists it, and the `Module` column lists `<module>`, the name that the make
   targets of the module use, such as `sscan`. The command prints the
   directory:

   ```
   sscan-src
   ```

2. Make the fix in the files of that directory and leave the changes
   uncommitted, because the `.make` target of step 5 writes the patch from
   them. Note the path of each changed file relative to the directory, such as
   `sscanApp/src/sscanRecord.c`.

3. List the patch files that change the same files as the fix:

   ```bash
   grep -l '<fix_file>' patch/*.p0.patch
   ```

   `<fix_file>` is the path of one changed file from step 2. Run the command
   once for each changed file. Only a patch file whose name starts with
   `<module>-` counts, because the other patch files apply to other source
   trees. The command prints no such name when no downstream patch of the
   module changes that file. A name of this kind in the output means that the
   `.make` target of step 5 would write the changes of that patch into your
   patch file too. The target compares the source tree with the pinned commit.
   This procedure does not cover that case.

4. Choose the names of the patch file and of the targets:

   | Item | Name | Example |
   | --- | --- | --- |
   | Patch file | `<module>-<topic>.p0.patch` | `sscan-example.p0.patch` |
   | Target prefix | `patch.<module>.<topic>` | `patch.sscan.example` |

   `<topic>` is a short lower-case description of the fix.

5. To write, apply, and revert the patch, add this block at the end of
   `configure/RULES_PATCH`. Indent each recipe line with one tab:

   ```make
   .PHONY: patch.<module>.<topic>.make patch.<module>.<topic>.apply patch.<module>.<topic>.revert

   patch.<module>.<topic>.make:
   	$(QUIET) mkdir -p $(TOP)/patch
   	$(QUIET) cd $(SRC_PATH_<module_key>) && git diff --no-prefix -- <fix_files> > $(TOP)/patch/<module>-<topic>.p0.patch

   patch.<module>.<topic>.apply:
   	$(QUIET) printf "\nPatching %s with the file : %s\n" "$(SRC_PATH_<module_key>)" "<module>-<topic>.p0.patch";
   	$(QUIET) patch -d $(SRC_PATH_<module_key>) --ignore-whitespace -p0 < $(TOP)/patch/<module>-<topic>.p0.patch;

   patch.<module>.<topic>.revert:
   	$(QUIET) $(REVERT_PATCH) "$(SRC_PATH_<module_key>)" "$(TOP)/patch/<module>-<topic>.p0.patch"
   ```

   `<module_key>` is the key from step 1, and `<fix_files>` are the paths from
   step 2, separated by spaces. The `.make` target writes the patch from the
   uncommitted changes of those files only. For an added file, run
   `git add -N <added_file>` in the source directory before `git diff` in the
   same recipe line, as `patch.measComp.make` does in `configure/RULES_PATCH`.
   The `.apply` target applies the patch with `patch -p0`. The `.revert` target
   runs `tools/revert_patch.bash`, which reverses an applied patch and skips an
   unapplied one.

6. Register the targets in `configure/RULES_SRC`:

   a. In the `patch:` line, add `patch.<module>.<topic>.apply` at the end.

   b. In the `patch.revert:` line, add `patch.<module>.<topic>.revert` directly
      after `patch.revert:`. The `patch.revert:` list must stay the exact
      reverse of the `patch:` list, because stacked patches revert correctly
      only in reverse apply order.

7. Write the patch file from the uncommitted changes:

   ```bash
   make patch.<module>.<topic>.make
   ```

   The command prints nothing and writes `patch/<module>-<topic>.p0.patch`.

8. Print the patch file, and check that its paths start at the top of the
   source tree, without a prefix:

   ```bash
   cat patch/<module>-<topic>.p0.patch
   ```

   The output is a unified diff, the form that `git diff --no-prefix` writes:

   ```
   diff --git sscanApp/src/sscanRecord.c sscanApp/src/sscanRecord.c
   index 5e61cb5..d903974 100644
   --- sscanApp/src/sscanRecord.c
   +++ sscanApp/src/sscanRecord.c
   @@ -1,4 +1,4 @@
   -
   +/* example site patch */
    /*
     *      Original Author: Ned D. Arnold
     *      Date:            07-18-94
   ```

9. Record the case in `patch/README.md`, in a section of the module, with the
   rows `Case`, `Effect without the patch`, `Reproduction`, `Change`,
   `Result with the patch`, `Tested`, and `Upstream`. `Tested` gives the dates
   of the checks in the Verification section and of the continuous integration
   workflows that pass with the patch applied. The section
   `measComp c38974e site patches` is the model.

10. Add the patch to the two book pages that list module patches:

    a. In [Upstream patch carry](../concepts/upstream-patch-carry.md), add a row
       for the file and its target to the table of module site patches.

    b. In [Make targets](../reference/make-targets.md), add the target prefix to
       the `<name>` list of the `patch.<name>.apply` row.

## Verification

Revert the patch and list the changes in the source directory:

```bash
make patch.<module>.<topic>.revert
git -C <source_directory> status --short
```

`<source_directory>` is the directory from step 1. The revert command reverses
the patch, and the status command lists only the files that `make conf` writes.
`<checkout>` is the path of the EPICS-env checkout:

```
Reverting applied patch: source=sscan-src patch=<checkout>/patch/sscan-example.p0.patch
patching file sscanApp/src/sscanRecord.c
?? configure/CONFIG_SITE.local
```

Apply the patch again:

```bash
make patch.<module>.<topic>.apply
```

The command prints an empty line, the name of the patch file, and the patched
source file:

```

Patching sscan-src with the file : sscan-example.p0.patch
patching file sscanApp/src/sscanRecord.c
```

Revert and apply every downstream patch, and print the exit status of each make
command:

```bash
make patch.revert > /dev/null; echo $?
make patch > /dev/null; echo $?
```

Both commands print `0` when the patch of the module applies and reverts
together with the other patches:

```
0
0
```
