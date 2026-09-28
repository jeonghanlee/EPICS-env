# Upstream Fix Verification - General Procedure

Use this procedure when a fix to a pinned upstream module can be observed only
on the hardware the production IOC drives. The fixed module and a copy of the
consumer IOC are built beside the production installation and run in its
place for the test. The installed tree is never modified, and the production
IOC is stopped only while the copy runs.

Each run keeps its own record under `docs/procedures/`, named
`<module>-<topic>-<YYYYMMDD>-<HHMMSS>.md`. Module-specific commands and
results belong there, not here.

## Inputs

| Input | Source |
| :-- | :-- |
| Production tree `<tree>`, the directory holding `base/`, `modules/`, and `vendor/` (`<install-root>/<version>/<os>/<base-version>`) | The owner names the version production runs |
| Module base commit and the fix | The base commit is always the pin of the installed module (`SRC_TAG_<MODULE>` in `configure/RELEASE`), so the copy differs from production only by the fix. A fix not yet carried: a `git diff` patch (`-p1`) of the fix, applied on the pin; when the fork branch sits on a later upstream commit and its patch does not apply on the pin, rework the patch against the pin first. The fork branch for the upstream pull request is kept separately. A fix already carried in `patch/`: the fix is among the environment patches |
| Environment patches for the module | The patch targets of the `patch:` list in `configure/RULES_SRC` that act on the module on this platform, in that order; `patch/README.md` names each file. `patch.mca.apply` acts only on macOS. For EPICS base and pvxs, the carry set `patch/<version>-*.p0.patch` applies in sorted order |
| Consumer IOC | Its repository and the commit production runs |
| Checks | The observation that shows the defect, and a list of the PVs whose values the fix must not change |

If a lab unit of the same hardware exists, run the same steps there first.

## Procedure

### 1. Place the module and the IOC in independent directories

On the production host, outside the install root and any checkout:

```
~/scratchpad/<module>-fix/
  .started      marker file; the teardown check compares against it
  <module>/     module source at the base commit, with the fix and the environment patches applied
  <ioc>/        consumer IOC at its production commit
```

Take both trees from committed sources; a working checkout carries untracked
files that can break the build. `<module>` is the installed module name in
`<tree>/modules/`. `<MODULE>` is its key in the EPICS-env checkout's
`configure/MODULESGEN.mk`, the `<MODULE>` of its
`INSTALL_LOCATION_<MODULE>:=$(INSTALL_LOCATION_MODS)/<module>-<version>` line.
`<module-source>` is a clone of the module that holds the pin: the source
directory that `make <MODULE>` clones at the pin in the EPICS-env checkout,
`<name>-src`, or the fork. `<base-commit>` is the pin.
The source directory can differ from the installed name, such as
`sequencer-src` for `seq`. Name the module directory after the installed
module and the IOC directory after the IOC binary:

```bash
mkdir -p ~/scratchpad/<module>-fix/<module> ~/scratchpad/<module>-fix/<ioc>
touch ~/scratchpad/<module>-fix/.started
git -C <module-source> archive <base-commit> | tar -x -C ~/scratchpad/<module>-fix/<module>
patch -d ~/scratchpad/<module>-fix/<module> -p1 < <fix>.patch
patch -d ~/scratchpad/<module>-fix/<module> --ignore-whitespace -p0 < <EPICS-env-checkout>/patch/<module>-<slug>.p0.patch
git -C <ioc-repo> archive <ioc-commit> | tar -x -C ~/scratchpad/<module>-fix/<ioc>
```

Apply the fix patch only for a fix not yet carried, and one environment patch
per line in `patch:` order; a carry set file uses the same `patch` command
with its own file name. `tools/verify_fix_build.bash` writes `.started` again
when it starts, so its check measures from the start of the script.

### 2. Compile the module against the production tree

Write the module's `configure/RELEASE.local` and `configure/CONFIG_SITE.local`,
with every path rewritten to `<tree>`:

- `RELEASE.local`: `EPICS_BASE=<tree>/base` and the dependency lines of the
  installed module, `<tree>/modules/<module>/configure/RELEASE.local`. These
  are the dependencies the production module was built with; a module
  installed without that file depends on base only.
- `CONFIG_SITE.local`: the module's own configuration lines from
  `make -C <EPICS-env-checkout> conf.<module>.show`, or
  `conf.<MODULE in lower case>.show` when no `conf.<module>` exists, such as
  `conf.sncseq.show` for `seq`, without
  `INSTALL_LOCATION` and with vendor paths under `<tree>/vendor`, plus
  `CHECK_RELEASE = NO` and `PROD_LDFLAGS += -Wl,--enable-new-dtags`.

Without `INSTALL_LOCATION` the build installs into its own directory.
`CHECK_RELEASE = NO` is required because the installed modules keep their
upstream `configure/RELEASE` files. Build with `make`. The module's shared
libraries are the `.so` files of the installed module,
`<tree>/modules/<module>/lib/<arch>/`. For each, the runpath that
`readelf -d` shows on the rebuilt copy in `lib/<arch>/` must name only
`<tree>` and `$ORIGIN`, and `ldd` on the rebuilt copy must resolve the same
shared libraries as on the installed one.

### 3. Point the IOC at the module and compile

Write the IOC copy's configuration:

- `configure/RELEASE.local`: `EPICS_BASE=<tree>/base` and
  `<MODULE>=<absolute path of ~/scratchpad/<module>-fix/<module>>`; make does
  not expand `~`. `<MODULE>` is the variable an IOC's
  `configure/RELEASE` uses for the module. If the copy's
  `configure/RELEASE` names the module by another variable, edit that file
  in the copy to use `<MODULE>`.
- `configure/CONFIG_SITE.local`: `CHECK_RELEASE = NO`. If the module passes
  a vendor path through an installed `cfg/CONFIG_*` file, also set that
  variable to `<tree>/vendor`.

Build with `make`. Then `ldd bin/<arch>/<ioc>` must resolve at least one of
the module's shared libraries, each from the scratch module, and every other
library from `<tree>` or the system.

### 4. Edit st.cmd and run the copy

In the copy's `iocBoot/<instance>/st.cmd`, remove any setting that hides the
defect. For example, delete `asynSetTraceMask(<port>, -1, 0)` so that asyn
errors print.

The production IOC and the copy serve the same PVs and the same device, so
only one runs at a time. The owner, or the operator the owner names, runs
this sequence:

1. Capture the `before` snapshot (step 5) while the production IOC runs.
2. Stop the production IOC.
3. Start the copy from its `iocBoot/<instance>` directory.
4. Observe the defect check, and capture the `after` snapshot.
5. Stop the copy, and restart the production IOC.
6. Capture the `restored` snapshot.

### 5. Verify: compare before and after

With the copy running, the defect observation must be gone. State it as a log
line that no longer appears over a stated time, or a report that shows the
corrected value.

The values the fix must not change must match between `before` and `after`,
within a tolerance fixed before the run. After the production restart,
`restored` must match `before`. The install tree must be unchanged:

```bash
find <tree> -type f \( -newer ~/scratchpad/<module>-fix/.started -o -cnewer ~/scratchpad/<module>-fix/.started \)
```

An empty result means nothing under the install tree was written.

## Automation

| Step | Tool |
| :-- | :-- |
| 1 | Manual; the commands above |
| 2-3, the link checks, and the install-tree check | `tools/verify_fix_build.bash` |
| 4 | Manual; it stops and starts a production IOC |
| 5, the before/after comparison | `tools/pv_snapshot.bash` |

Steps 2-3 take the production tree from the shell's EPICS environment, the
module's dependencies from the installed module, and the module's own
configuration from the EPICS-env checkout that holds the script, with every
vendor path pointed at `<tree>/vendor`. Prepare that checkout first; the
first command clones the module source, the second writes its configuration.
The configuration target is `conf.<module>`, or `conf.<MODULE in lower case>`
when the checkout defines no `conf.<module>`.

On Ubuntu 26, `conf.<module>` does not write the `-std=gnu17` flag that
`make conf` adds for sequencer, iocStats, sscan, calc, busy, StreamDevice,
lua, std, scaler, and mca. For one of these modules, append
`USR_CFLAGS += -std=gnu17` to
`<EPICS-env-checkout>/<name>-src/configure/CONFIG_SITE.local` between the
second and the fourth command below:

```bash
make -C <EPICS-env-checkout> <MODULE>
make -C <EPICS-env-checkout> conf.release.modules conf.<module>
source <tree>/setEpicsEnv.bash
<EPICS-env-checkout>/tools/verify_fix_build.bash ~/scratchpad/<module>-fix/<module> ~/scratchpad/<module>-fix/<ioc>
```

Step 5, with one PV name per line in `<pvlist>`:

```bash
<EPICS-env-checkout>/tools/pv_snapshot.bash capture -l <pvlist> -o before.txt
<EPICS-env-checkout>/tools/pv_snapshot.bash capture -l <pvlist> -o after.txt
<EPICS-env-checkout>/tools/pv_snapshot.bash capture -l <pvlist> -o restored.txt
<EPICS-env-checkout>/tools/pv_snapshot.bash compare -t <tolerance> before.txt after.txt
<EPICS-env-checkout>/tools/pv_snapshot.bash compare -t <tolerance> before.txt restored.txt
```

`compare` prints each PV as `SAME`, `WITHIN`, `DIFF`, `MISSING`, or
`DISCONN`, followed by a summary. It exits 1 when any PV is not `SAME` or
`WITHIN`, and 2 on a usage or run-time error. A `capture` whose last argument
is `-l`, `-o`, or `-w`, or a `compare -t` with nothing after it, exits 1 with
no message.

## After verification

- **Upstream:** open the upstream pull request from the fork branch. Commit,
  push, and pull request creation are owner actions.
- **Adoption:** bump the pin to a commit that contains the fix
  (`module-bump-procedure.md`), or carry the fix as a local build patch.
  A carry adds `patch/<module>-<slug>.p0.patch`, its
  `patch.<name>.make` / `.apply` / `.revert` rules, where `<name>` is the
  module or the module and a short suffix such as `measComp.tc32`, in
  `configure/RULES_PATCH`, the apply and revert rules in the `patch:` and
  `patch.revert:` lists of `configure/RULES_SRC`, and a row in
  `patch/README.md`. `upstream-fix-carry-procedure.md` covers the patch
  mechanics. A carry is removed by the bump that moves the pin past it.
- **Release:** after production moves to the release that ships the fix,
  repeat step 5 against the IOC started from the installed tree.

## Record

The run record states:

- the production version and tree;
- the module base commit and each applied patch;
- the IOC commit, or where it is kept when the IOC repository is private;
- the hardware model, variant, options, and firmware;
- the step 5 result;
- where the evidence is kept.

This repository is public. Host names, addresses, device identifiers, and PV
names stay in the site's private record.
