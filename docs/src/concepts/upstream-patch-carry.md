# Upstream patch carry

EPICS-env builds Experimental Physics and Industrial Control System (EPICS)
base and each module from a pinned upstream tag or commit. When a pinned
source needs a fix that the pin does not contain, EPICS-env carries the fix
as a patch file under `patch/` and applies it to the cloned source during
the `patch` stage. The pin in `configure/RELEASE` stays unchanged; a carried
patch and a version bump are separate changes.
[Carry an upstream fix as a patch](../procedures/carry-upstream-fix.md) adds a patch,
[Verify a fix against an installed tree](../procedures/verify-fix-against-installed-tree.md)
tests one, and
[Upstream patch targets](../reference/make-targets.md#upstream-patch-targets)
lists the targets.

## Patch file families and names

The file name decides which target applies a patch and to which source tree:

| Family | File name | Apply target | Source tree |
| --- | --- | --- | --- |
| EPICS base carry, merged pull request | `<base_version>-pr<NNNN>-<slug>.p0.patch` | `patch.base.pr.apply` | `epics-base-src` |
| EPICS base carry, direct commit | `<base_version>-<NN>-<sha7>-<slug>.p0.patch` | `patch.base.pr.apply` | `epics-base-src` |
| pvxs carry | `<pvxs_version>-<NN>-<sha7>-<slug>.p0.patch` | `patch.pvxs.commit.apply` | `pvxs-src` |
| EPICS base site patch | `<base_version>-site<NN>-<slug>.p0.patch` | `patch.base.pr.apply` | `epics-base-src` |
| Fixed module patch | `<module>-<slug>.p0.patch` | `patch.<name>.apply` | One module |

The placeholders in the names mean:

- `<base_version>` and `<pvxs_version>` are the values of `SRC_VER_BASE` and
  `SRC_VER_PVXS`, such as `7.0.10` and `1.5.2`.
- `<NNNN>` is the number of the upstream pull request (PR) that merged the
  fix, written with four digits.
- `<NN>` is a two-digit sequence number, and `<sha7>` is the first seven
  characters of the upstream commit.
- `<slug>` is a short description of the fix.

For the pins in `configure/RELEASE`, `patch/` holds 18 EPICS base carry
patches for `7.0.10` and 12 pvxs carry patches for `1.5.2`. A site patch
holds a fix that upstream does not carry yet, so its name has no pull
request number and no commit. It applies and reverts with the carry set of
EPICS base. The one site patch, `7.0.10-site01-dbyacc-eof.p0.patch`, keeps
the database parser from ending with a segmentation fault when a file ends
inside an open construct. `patch/README.md` records the case, the
reproduction, and the tested versions.

## Version-anchored names that drop on a bump

The carry targets select their files with a pattern that starts with the
pinned version:

| Target | Pattern |
| --- | --- |
| `patch.base.pr.apply` | `patch/$(SRC_VER_BASE)-*.p0.patch` |
| `patch.pvxs.commit.apply` | `patch/$(SRC_VER_PVXS)-*.p0.patch` |

When the pin of EPICS base or pvxs moves to another version, its pattern
matches no file, and the whole carry set for that source stops applying.
Every carried fix then needs a review against the release that the pin
names, and a carry patch never reaches a version it was not written for.

The hyphen after the version keeps the carry pattern apart from the files
of the earlier form `<version>.base.p0.patch`, which no target reads. The
pvxs pattern `1.5.2-*` also never matches the file `pvxs-1.3.1.p0.patch`.

## Sorted apply and exact reverse revert

A carry target applies its files in the sorted order of their names, and the
matching revert target removes them in the exact reverse order. Patches that
touch the same file then apply and revert against the source state each one
expects.

Revert targets classify each whole patch with noninteractive dry-runs.
They skip confirmed unapplied patches and reverse confirmed applied patches.
Conflicts, partial application, required-input absence, and unresolved states
stop the invocation; earlier completed reversals remain in effect.

Later carry patches can depend on context from earlier patches. Classification
can prepare that context in a private copy of real source files, preserving
the original tree. For supported single-hunk static C function patches, it
also checks the named function to distinguish similar code in other functions.
Private hunk search positions follow that function when independent source
edits move it. Patch contents must match inside the function; an absent or
duplicate function leaves the state unresolved. A line that ends with a
semicolon is a declaration of the function and does not count as a second
definition.

Sorting compares names as text. Within the EPICS base set, the two-digit
commit form sorts before the pull request form, because a digit sorts before
`p`. The EPICS base set for `7.0.10` therefore applies
`7.0.10-01-b2d2758-putnotify-type-check.p0.patch` first, followed by the pull
request patches in ascending number. A site patch named
`<base_version>-site<NN>-<slug>.p0.patch` sorts after both, because `s`
sorts after `p`: it applies on top of the upstream fixes and reverts first.
A site patch that must apply before the pull request patches takes the name
`<base_version>-<NN>-site-<slug>.p0.patch` instead, with a sequence number
that places it among the two-digit names.

Each file goes through `patch -d <source_tree> --ignore-whitespace -p0`.
The carry targets stop at the first file that fails, so a later success cannot
hide an earlier failure. The pvxs targets also pass `--no-backup-if-mismatch`,
so a patch that applies at an offset leaves no `.orig` backup file in the
source tree.
All revert targets suppress mismatch backups and preserve existing backups.

The `patch` aggregate applies every family in a fixed order, and
`patch.revert` lists the same targets in the exact reverse order:

1. `patch.base.pr.apply`
2. `patch.mca.apply`
3. `patch.measComp.apply`
4. `patch.measComp.tc32.apply`
5. `patch.opcua.apply`
6. `patch.opcua.export.apply`
7. `patch.feed-core.apply`
8. `patch.QPC.apply`
9. `patch.pvxs.commit.apply`
10. `patch.StreamDevice.apply`

## Fixed per-module patches

A fixed patch has no version in its name, and one dedicated target pair
applies and reverts it. It keeps applying after the module pin changes,
until it fails to apply to the changed source and `make patch` stops.

| File | Target | Change |
| --- | --- | --- |
| `measComp-CONFIG_MEASCOMP.p0.patch` | `patch.measComp` | Installs `cfg/CONFIG_MEASCOMP`, so a module that names `MEASCOMP` inherits `ULDAQ_DIR` |
| `measComp-tc32-chan-count.p0.patch` | `patch.measComp.tc32` | Halves the reported TC-32 thermocouple channel count when no expansion unit is present |
| `opcua-CONFIG_OPCUA.p0.patch` | `patch.opcua` | Derives the open62541 library and include directories from `OPEN62541` in the installed `CONFIG_OPCUA` |
| `opcua-anon-ns-export.p0.patch` | `patch.opcua.export` | Moves exported registration blocks out of unnamed namespaces, which the GNU Compiler Collection (GCC) 15 needs to link them |
| `feed-core-libonly.p0.patch` | `patch.feed-core` | Trims the build to the library and drops the `busy`, `asyn`, and `autosave` references of the unused bundled application |
| `QPC-dataonly.p0.patch` | `patch.QPC` | Removes module references from the unbuilt example application `Makefile` |
| `StreamDevice-no-vxi11.p0.patch` | `patch.StreamDevice` | Removes the vxi11 driver registration, which asyn builds only with `DRV_VXI11=YES` |
| `mca-libnet.p0.patch` | `patch.mca` | Acts only on macOS; the target does nothing on Linux |

The `Target` column names the prefix of the `.apply`, `.revert`, and `.make`
targets.

The `feed-core` and `QPC` patches remove module references from `Makefile`
files that the module dependency audit `check.module-deps` reads. On the
current pins, the strict
audit passes in all four combinations: both patches applied, only `feed-core`
applied, only `QPC` applied, and neither applied. These patches define the
selected build content; passing the audit does not require them.
[Build and install verification gates](verification-gates.md#static-module-dependency-audit)
describes that audit.

## Patch file format

Every patch file is a unified diff with no path prefix, the form that
`git diff --no-prefix` writes. Paths in the file start at the top of the
source tree, such as `modules/database/src/std/rec/mbbiRecord.c` for EPICS
base, and the `-p0` option applies them from there. The `.p0.patch` suffix
marks this format.

The `.make` targets write a patch from the current changes in a source tree:

- `patch.<name>.make` writes the fixed patch of one module from the current
  changes in its source tree, limited for most modules to the files that
  patch covers.

No make target writes the EPICS base or pvxs carry files or a site patch.
A site patch is written by hand as the `git diff --no-prefix` output for
the files of the fix alone. When a patch that applies earlier changes one
of those files, take the difference against the file with that patch
applied.

## Inactive patch files

Some files under `patch/` match no active target on a Linux build of the
pinned versions:

| File | Why it does not apply |
| --- | --- |
| `3.15.5.base.p0.patch`, `7.0.5.base.p0.patch`, `7.0.7.base.p0.patch` | No target reads the `<version>.base.p0.patch` form, and their version differs from `SRC_VER_BASE` |
| `pvxs-1.3.1.p0.patch` | No active target names it, and the pvxs carry pattern does not match it |
| `mca-libnet.p0.patch` | Its targets act only on macOS |
