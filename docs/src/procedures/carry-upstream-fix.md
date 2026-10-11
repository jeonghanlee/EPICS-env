# Carry an upstream fix as a patch

EPICS-env carries upstream fixes that the pinned tag of the Experimental
Physics and Industrial Control System (EPICS) base or of pvxs does not
contain. Each fix is a patch file in `patch/`, which `make patch` applies
after `make init` clones the sources. A patch file that follows the naming
below joins the carry set through the version-matched filename pattern.
Dependencies can require an explicit apply order; a patch for any other
module has its own targets, listed in
[Upstream patch targets](../reference/make-targets.md#upstream-patch-targets).
The example regenerates the pvxs carry
`1.5.2-12-cc7bc72-synccancel-diag.p0.patch` from upstream commit `cc7bc72`.
[Upstream patch carry](../concepts/upstream-patch-carry.md) explains the
carry set. Run every command from the top of the EPICS-env checkout.

## Prerequisites

- `make init` and `make patch` have run, so `epics-base-src` and `pvxs-src`
  hold the pinned sources with the carry set applied.
- The fix is merged upstream as one commit or as a contiguous range of
  commits.

1. Print the pinned version, which is the first field of every carry file
   name of that source:

   ```bash
   make print-SRC_VER_PVXS
   ```

   The command prints the version:

   ```
   1.5.2
   ```

   For EPICS base, print `SRC_VER_BASE` instead.

2. Revert the carry set, so the source tree returns to the pin:

   ```bash
   make patch.pvxs.commit.revert
   ```

   The target reverses each file in the exact reverse of the apply order and
   stops at the first file that does not revert. For EPICS base, run
   `make patch.base.pr.revert`.

3. Check that the source tree matches the pin:

   ```bash
   git -C pvxs-src status --short
   ```

   The command prints nothing. In `epics-base-src`, the command lists only
   `configure/CONFIG_SITE_ENV` and
   `configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64`, which `make conf`
   writes. `patch.base.pr.revert` also reverts the site patches.

4. Update the clone with the upstream commits:

   ```bash
   git -C pvxs-src fetch origin
   ```

5. Choose the file name for the default sorted apply order:

   | Source | File name | Unit |
   | --- | --- | --- |
   | EPICS base | `<base_version>-pr<pr_number>-<slug>.p0.patch` | A merged pull request |
   | EPICS base | `<base_version>-<sequence>-<sha7>-<slug>.p0.patch` | A commit merged without a pull request |
   | pvxs | `<pvxs_version>-<sequence>-<sha7>-<slug>.p0.patch` | A commit |

   `<base_version>` and `<pvxs_version>` are the pinned versions from
   step 1. `<pr_number>` is the number of the pull request, zero-padded to
   four digits. `<sequence>` is a two-digit number that follows the upstream
   merge order. `<sha7>` is the first seven characters of the commit hash,
   and `<slug>` is a short lower-case description. Filename sorting places
   every `<sequence>` file before every `pr` file. EPICS base applies
   PR #753 and commit cf85a1a5 first, as defined by `BASE_PR_PATCHES` in
   `configure/CONFIG_BASE`, then sorts the remaining filenames.
   To make a new EPICS base patch apply before the sorted set, add one
   `$(wildcard $(TOP)/patch/$(SRC_VER_BASE)-<pattern>.p0.patch)` term for it
   to `BASE_PR_PATCH_PREFIX` in `configure/CONFIG_BASE`, after the terms
   already there. `<pattern>` is the part of the file name after the
   version, such as `pr0999-*`. The terms apply in the order written, and a
   pattern that matches no file is dropped without an error. After step 6
   has written the patch file, run `make print-BASE_PR_PATCHES`. It prints
   the resulting apply order on one line, and the new file name must appear
   in it.
   Preserve released filenames and verify prerequisites before changing the
   order. Make selects only files whose name starts with the pinned version,
   so a pin bump leaves every other carry file out of the set.

6. Write the change of the upstream commits as a patch without path prefixes,
   which `patch -p0` applies from the top of the source tree:

   ```bash
   git -C pvxs-src diff --no-prefix cc7bc72^ cc7bc72 > patch/1.5.2-12-cc7bc72-synccancel-diag.p0.patch
   ```

   `cc7bc72^` stands for `<first_commit>^`, the parent of the first commit
   of the fix, and `cc7bc72` stands for `<last_commit>`, its last commit.
   For a fix of one commit, both name the same commit. For EPICS base, run
   the command against `epics-base-src`.

7. Apply the carry set, including the file from step 6:

   ```bash
   make patch.pvxs.commit.apply
   ```

   The output ends with the file from step 6:

   ```
   Patching pvxs-src with the file : <checkout>/patch/1.5.2-12-cc7bc72-synccancel-diag.p0.patch
   patching file ioc/pvalink_channel.cpp
   patching file src/clientdiscover.cpp
   patching file src/clientget.cpp
   patching file src/clientintrospect.cpp
   patching file src/clientmon.cpp
   patching file src/evhelper.cpp
   patching file src/evhelper.h
   ```

   `<checkout>` is the path of the EPICS-env checkout. The target stops with
   a non-zero exit status at the first file that does not apply. If the fix
   does not apply on top of the patches that precede it, edit the fix
   against the pinned source before you carry it. For EPICS base, run
   `make patch.base.pr.apply`.

## Verification

Revert the carry set, print the exit status of make, and check the source
tree:

```bash
make patch.pvxs.commit.revert > /dev/null; echo $?
git -C pvxs-src status --short
```

The first command prints the exit status, and the status command prints
nothing, or for `epics-base-src` the two files named in step 3:

```
0
```

Apply the carry set again and print the exit status of make:

```bash
make patch.pvxs.commit.apply > /dev/null; echo $?
```

The command prints `0` when every carry file applies:

```
0
```

When a carry file does not apply, the target stops at that file, and make
reports the error and exits 2:

```
make: *** [<checkout>/configure/RULES_PATCH:120: patch.pvxs.commit.apply] Error 1
2
```

For EPICS base, the same check uses `make patch.base.pr.revert`,
`epics-base-src`, and `make patch.base.pr.apply`.
