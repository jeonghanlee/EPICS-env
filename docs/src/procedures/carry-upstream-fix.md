# Carry an upstream fix as a patch

EPICS-env carries upstream fixes that the pinned tag of the Experimental
Physics and Industrial Control System (EPICS) base or of pvxs does not
contain. Each fix is a carry patch, a patch file in `patch/`, which `make patch`
applies after `make init` clones the sources. A carry patch that follows the
naming below is applied without any Makefile change; a patch for any other
module has its own targets, listed in
[Upstream patch targets](../reference/make-targets.md#upstream-patch-targets).
The example regenerates the EPICS base carry patch
`7.0.10-01-b2d2758-putnotify-type-check.p0.patch` from upstream commit
`b2d2758`, a fix of one file merged without a pull request.
[Upstream patch carry](../concepts/upstream-patch-carry.md) explains the
kinds of downstream patch. Run every command from the top of the EPICS-env
checkout.

## Prerequisites

- `make init` and `make patch` have run, so `epics-base-src` and `pvxs-src`
  hold the pinned sources with the downstream patches applied.
- The fix is merged upstream as one commit or as a contiguous range of
  commits.

1. Print the pinned version, which is the first field of every patch file
   name of that source:

   ```bash
   make print-SRC_VER_BASE
   ```

   The command prints the version:

   ```
   7.0.10
   ```

   For pvxs, print `SRC_VER_PVXS` instead.

2. Revert the downstream patches, so the source tree returns to the pin:

   ```bash
   make patch.base.pr.revert
   ```

   The target reverses each file in the exact reverse of the apply order and
   stops at the first file that does not revert. The EPICS base target reverts
   the carry patches and the site patches. For pvxs, run
   `make patch.pvxs.commit.revert`.

3. Check that the source tree matches the pin:

   ```bash
   git -C epics-base-src status --short
   ```

   In `epics-base-src`, the command lists only the files that `make conf`
   writes: `configure/CONFIG_SITE_ENV`, and
   `configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64` when the two linker
   lines were added to it. In `pvxs-src`, the command prints nothing.

4. Update the clone with the upstream commits:

   ```bash
   git -C epics-base-src fetch origin
   ```

5. Choose the file name, so that the sorted file names give the apply order:

   | Source | File name | Unit |
   | --- | --- | --- |
   | EPICS base | `<base_version>-pr<pr_number>-<slug>.p0.patch` | A merged pull request |
   | EPICS base | `<base_version>-<sequence>-<sha7>-<slug>.p0.patch` | A commit merged without a pull request |
   | pvxs | `<pvxs_version>-<sequence>-<sha7>-<slug>.p0.patch` | A commit |

   `<base_version>` and `<pvxs_version>` are the pinned versions from
   step 1. `<pr_number>` is the number of the pull request, zero-padded to
   four digits. `<sequence>` is a two-digit number that follows the upstream
   merge order. `<sha7>` is the first seven characters of the commit hash,
   and `<slug>` is a short lower-case description. Make applies the files
   in byte order, so every `<sequence>` file of EPICS base applies before
   every `pr` file. Make selects only the files whose name starts with the
   pinned version, so a pin bump leaves every other patch file out.

6. Write the change of the upstream commits as a patch without path prefixes,
   which `patch -p0` applies from the top of the source tree:

   ```bash
   git -C epics-base-src diff --no-prefix b2d2758^ b2d2758 > patch/7.0.10-01-b2d2758-putnotify-type-check.p0.patch
   ```

   `b2d2758^` stands for `<first_commit>^`, the parent of the first commit
   of the fix, and `b2d2758` stands for `<last_commit>`, its last commit.
   For a fix of one commit, both name the same commit. For pvxs, run the
   command against `pvxs-src`. The example writes the file that `patch/`
   already holds, so `git status --short patch` prints nothing when the
   regenerated file equals the shipped one.

7. Apply the downstream patches, including the file from step 6:

   ```bash
   make patch.base.pr.apply
   ```

   The output begins with an empty line and the file from step 6, because its
   `<sequence>` name sorts before every `pr` file, and continues with the
   other patch files in name order:

   ```

   Patching epics-base-src with the file : <checkout>/patch/7.0.10-01-b2d2758-putnotify-type-check.p0.patch
   patching file modules/database/src/ioc/db/dbPutNotifyBlocker.cpp
   ```

   `<checkout>` is the path of the EPICS-env checkout. The target stops with
   a non-zero exit status at the first file that does not apply. If the fix
   does not apply on top of the files that sort before it, edit the fix
   against the pinned source before you carry it. For pvxs, run
   `make patch.pvxs.commit.apply`.

## Verification

Revert the downstream patches, print the exit status of make, and check the
source tree:

```bash
make patch.base.pr.revert > /dev/null; echo $?
git -C epics-base-src status --short
```

The first command prints the exit status, and the status command lists only
the files named in step 3, or for `pvxs-src` nothing:

```
0
```

Apply the downstream patches again and print the exit status of make:

```bash
make patch.base.pr.apply > /dev/null; echo $?
```

The command prints `0` when every patch file applies:

```
0
```

After the apply, the status command of step 3 also lists the files that the
patches change, such as `configure/os/CONFIG.Common.linuxCommon`.

When a patch file does not apply, the target stops at that file, and make
reports the error and exits 2:

```
make: *** [<checkout>/configure/RULES_PATCH:7: patch.base.pr.apply] Error 1
2
```

The failed `patch` leaves `<source_file>.rej` with the hunks that did not apply
beside the source file it tried to change, and `<source_file>.orig` too when
the hunks did not match the source. The status command lists them as untracked
files until you remove them.

For pvxs, the same check uses `make patch.pvxs.commit.revert`, `pvxs-src`,
and `make patch.pvxs.commit.apply`.
