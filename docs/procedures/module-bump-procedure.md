# Module Version Bump - General Procedure

How one pinned module moves to a newer upstream release or commit, and how that move is verified against the modules that build on it.

## Scope

This document covers one module, EPICS base included: six stages. Stages 1 to 3 run for every module, and Stages 4 and 5 for each module with a newer upstream release. These stages precede the order decision (`release-procedure.md`, steps 3 and 4); Stage 6 runs for every module in that order (step 6). Commands and methods are written here, because `work/` is gitignored and does not survive. A pitfall that names a module (calc, asyn, pvxs, ...) records what that module once showed; its rule applies to every module.

**Out of scope:** the order of the modules, the test machines, the baseline tree they carry, and the release itself. These are in `release-procedure.md` (Order and Test machines).

## Names

In a release, this procedure covers the combined inventory of EPICS-env and
the selected site module repository. Run pin and build operations in the
module's owning checkout. Search both checkouts for consumers and retain both
repository commits with the results. `site-modules-procedure.md` describes
source preparation before an installed tree exists and the site build rules.
For a site pin change, update its owning repository's pin declarations and
references. The EPICS-env book's module-pin table describes EPICS-env pins;
the combined release record includes the site pins without adding them to
EPICS-env's `configure/RELEASE`.

A module has four names, and the commands below use them as placeholders.

| Placeholder | Name | Where it is set and used | sequencer | StreamDevice | EPICS base |
| :-- | :-- | :-- | :-- | :-- | :-- |
| `<KEY>` | key | `SRC_TAG_<KEY>`, `SRC_VER_<KEY>`, and `SRC_NAME_<KEY>` in `configure/RELEASE` | `SNCSEQ` | `STREAM` | `BASE` |
| `<module>` | repository name | `SRC_NAME_<KEY>`; the source tree `<module>-src` and every make target (`conf.<module>`, `build.<module>`, `symlink.<module>`, `distclean.<module>`) | `sequencer` | `StreamDevice` | `epics-base`; its make targets are `conf.base` and `build.base` |
| `<name>` | module name | the installed tree: the install directory `<name>-<version>`, the link `<tree>/modules/<name>`, and the `name=` and `dep=` lines of the loader metadata | `seq` | `StreamDevice` | none; base installs into `<tree>/base` |
| `<stem>` | library name | each `lib<stem>.so` the module installs, the `lib=` entries of its loader metadata, and the `_LIBS` lines of its consumers | `seq`, `pv` | `stream` | not used; every module is a consumer of base |

The repository name and the module name are the same for every module except sequencer. The library names are the module's own and can differ from both. `<tree>` is the installed tree, which `make -s print-INSTALL_LOCATION_EPICS` prints in the checkout, and `<version>` is the value of `SRC_VER_<KEY>`. Two commits also appear in the commands: `<commit>` is the candidate, the commit pushed to origin that the checks build, and `<pin-commit>` is the commit of the pin change (Stage 6, step 1); for an IN module whose pin already moved, it is the commit that moved it, which `git log --oneline -S'<new-pin>' -- configure/RELEASE` lists from the history of the checkout, where `<new-pin>` is the value of `SRC_TAG_<KEY>`.

## Roles

Maintainer and Executor have the responsibilities defined in
[`release-procedure.md`, Roles and interaction](release-procedure.md#roles-and-interaction).
The Maintainer may also act as the Executor. Their module-specific duties are:

| Role | Does | Does NOT |
| :-- | :-- | :-- |
| Maintainer | Decides IN/HOLD per newer upstream release; authorizes the pin edit; each commit and push is its own authorization | - |
| Executor | Surveys, finds the reverse dependencies, diffs the changeset, judges API/ABI compatibility, presents the finding; edits, commits, and pushes under the maintainer's authority | Edit the pin without explicit authority; treat a static pass as a release; read a module's minimum requirement as a fixed pin |

During a release, Stages 1 and 2 follow the execution mode established for
release steps 1 to 3. Stage numbers in this document are module stages,
not release steps; the release's joint assessment starts at release step 4.

Stages 1 to 4 are static and can only clear or block; Stage 6 is the real build and startup verification. Stages 1 to 3 and 6 run for every module, and Stages 4 and 5 for each module with a newer upstream release. IN, HOLD, and unchanged (Stage 5) decide whether the pin moves, not whether dependencies are inspected or Stage 6 runs.

## Working layout

```
work/<module>-bump/            # scratch; gitignored
  survey.txt                   # Stage 1 output
  reverse-deps.md              # Stage 3 reverse dependencies with evidence
  header-diff.txt              # Stage 4 diff filtered to library headers
```

Create the directory with `mkdir -p work/<module>-bump` before Stage 1.

## Stage 1 - Survey the upstream state (read-only)

Complete the survey for both repositories' inventories. The command below
covers the EPICS-env declarations; it is not evidence for a site module absent
from that file. For an unsupported site repository, use the Git inspection and
completeness requirements in `site-modules-procedure.md`, Source preparation.

```
tools/update-release.bash check > work/<module>-bump/survey.txt
```

Exit `0`: the tool completed its supported comparisons. Exit `1`: incomplete, a module was unreachable or had no repository URL; do not decide from it. Exit `2`: the comparisons completed but a module has no release tag (a usage error also exits 2; read the output). These statuses do not establish that the full survey below is complete. The output carries terminal color codes; `sed 's/\x1b\[[0-9;]*m//g'` removes them. The `Date` line of a module with an update is the date of its newest commit or tag, read with one GitHub API request per module; `GITHUB_TOKEN` raises the limit from 60 to 5000 requests an hour. A request that fails prints `Unknown (request failed)`, and an answer without a date prints `Unknown (no date in the response)`. `-v` prints first whether `GITHUB_TOKEN` is set.

**Pitfall.** A tag pin is compared with the newest tag, a commit pin with the branch head. A tag pin whose branch has moved past its newest tag reports `OK`; carrying branch commits as downstream patches is `upstream-fix-carry-procedure.md`, not a bump.

**Pitfall.** The newest tag is chosen by version sort: calc reports the old `R5-4-2` as newest. Check a reported tag with `git log -1 --format=%cs <tag>`.

For every module in both inventories, supplement the tool output with Git
inspection of its source repository, including rows reported as `OK`.
Fetch the upstream refs without changing the pinned checkout, identify the
remote's default branch, and inspect its release tags. Verify the latest
release tag against the upstream release history; version sorting alone is
not sufficient. Record the following in the module's release-record section
(or its working report outside a release), with supporting output in `work/`:

- Observation date, owning repository, module key, and baseline pin and commit.
- Latest release tag and its resolved commit and commit date, or confirmed
  absence of release tags.
- Default branch name, observed HEAD commit and commit date, or confirmed
  absence of a default branch.
- For each available upstream ref, its relationship to the baseline commit,
  the count of commits reachable from that ref but not from the baseline,
  and a summary of their changes. When no additional commits exist, record
  that explicitly. A ref behind or diverged from the baseline is not a newer candidate merely
  because it differs. When both a tag and branch exist, also record the branch
  commits after the latest tag. Use the observed commit IDs for comparisons
  so a later branch movement cannot change the recorded result.

Stage 1 is complete only when these observations cover every declared module
and reconcile with the baseline inventory. Confirmed absence is evidence;
an inaccessible repository, unresolved ref, or failed comparison is incomplete.
Recover a missing API date from the Git commit before completing the record.
Release step 3 records available changes only. Adoption, retention, and
downstream-carry decisions remain at release step 4.

## Stage 2 - Locate the pin

For a site module, read the following declarations and overrides in its own
checkout. Before a make query is safe in the selected site revision, resolve
them directly from the files and confirm the source checkout's commit with
Git. Confirm the same values with its query targets once the build tree exists.

The pin is `SRC_TAG_<KEY>` and `SRC_VER_<KEY>` in `configure/RELEASE` (the `Key` column of the book's module pins page). `RELEASE.local` next to the checkout or under `configure/` overrides it for that checkout; read the pin in effect with `make print-SRC_TAG_<KEY>`. The `RELEASE.local` that the baseline of a test machine writes holds only vendor paths and overrides no pin. Confirm that the pin is the single source of truth for the version, where `<old-tag>` is the bare name of the pinned tag without `tags/` (`R4-46`; for a commit pin, the commit id) and `<old-ver>` is the value of `SRC_VER_<KEY>`. When the pin already moved in this release, they are the values before the move, which `git show <pin-commit>^:configure/RELEASE | grep -e SRC_TAG_<KEY> -e SRC_VER_<KEY>` prints (`<pin-commit>` is the commit of Names), and the search then finds what the move left behind:

```
command grep -rnIF "<old-tag>" . | grep -v -e '\.git/' -e '^\./work/'
command grep -rnIF "<old-ver>" . | grep -v -e '\.git/' -e '^\./work/'
```

`command grep` bypasses a shell function that wraps `grep` and skips ignored files. `-F` reads each string as plain text, so the dot of a version matches only a dot, and `-I` skips binary files. Every other hit is documentation, a patch file or rule, a source tree, or the generated `configure/MODULESGEN.mk`; none is the pin. The loader suite under `examples/iocsh/tests/` names the installed versions of asyn, StreamDevice, pvxs, linStat, and EPICS base; a pin change of those updates it in the same commit. Change `SRC_TAG_` and `SRC_VER_` only; where `SRC_VER_` is derived from `SRC_TAG_`, change the tag only.

**Pitfall.** The downstream patch sets of EPICS base, pvxs, autosave, linStat, modbus and StreamDevice apply only `patch/<SRC_VER>-*.p0.patch`, so a bump silently drops the whole set (the two local StreamDevice patches have their own rules and fail `make patch` where the source differs), and a module patch stops applying when the source no longer matches. Re-examine every downstream patch of the bumped module (`upstream-fix-carry-procedure.md`, Bump obligation).

## Stage 3 - Find the reverse dependencies

Outside a release, prepare the module and its potential consumers by the same
Git-only source preparation rule, using the repositories included in that
work. No release branch or installed tree is required for this source check.

Run this stage for every module, including unchanged and HOLD modules.
List every module that uses the module under review, graded by how it uses
it, not by what its `RELEASE` declares. Use the sources prepared at their
effective pins in release step 2 (`site-modules-procedure.md`, Source
preparation). Verify the source revision before searching; an existing
directory does not establish that it matches the pin. Source inspection
precedes the installed tree and does not require `make init`.

Build-order dependents:

```
grep -n "build.<module>" configure/CONFIG_MODS_DEPS
```

The command prints nothing and exits 1 when no module lists `build.<module>`: the module has no build-order dependents.

Then read the module sources (`<module>-src/`) declared by either repository's `configure/RELEASE`; exclude sources outside the release inventory. Run the build-order search above in both checkouts, and run each source search below over both sets of source directories. A build-level consumer has `..._LIBS += <stem>` (with the module's `.dbd`) in an App Makefile or includes a header of the module; a runtime consumer installs a device-support template or db. A module can include the headers and take the symbols from its IOC's link line without naming the module: `rgamv2` includes `asynPortDriver.h`, links only `$(EPICS_BASE_IOC_LIBS)`, and `rgamv2_DEPS` lists `build.asyn`.

**Pitfall.** A `RELEASE` declaration (`ASYN = $(MODULES)/asyn`) is not a link. In the asyn example two modules declared `ASYN=` and linked nothing.

**Pitfall.** A link line the build never reaches is not a consumer: a line inside a conditional block, or in an application a downstream patch removes. `feed-core` links asyn only in `feedioc`, under `ifneq ($(BUSY),)` and `ifneq ($(ASYN),)`; `conf.feed-core` sets neither, and `feed-core-libonly.p0.patch` drops that application.

**Pitfall.** A hit under `examples/` is a program of this repository, not a module of `configure/RELEASE`: `examples/commonIocsh` links caPutLog, and the release readiness step covers it (`commonIocsh-verification-procedure.md`).

**Pitfall.** A build switch the configuration turns off: linStat's example links `pvxsIoc pvxs`, but `conf.linStat` writes `LINSTAT_BUILD_EXAMPLE = NO`; StreamDevice links sscan only under `ifneq ($(words $(SSCAN) $(SYNAPPS)), 0)`. Read `conf.<module>` and the module's `configure/CONFIG_SITE` before grading.

**Pitfall.** The source trees are gitignored. `rg` skips them unless forced, and a `grep` wrapped in a shell function that honors ignore files skips them silently; inside `find -exec` keep plain `grep`, since `find` cannot run the shell word `command`. Run two searches that fail differently and require the same result, where `<repository>` is the checkout that holds the `<module>-src` trees:

```
rg -n --no-ignore --hidden -g Makefile '[A-Za-z_]*LIB[sS][[:space:]]*\+=.*\b<stem>\b' <repository>

find <repository> -name Makefile -not -path "*/.git/*" \
  -exec grep -HnE '[A-Za-z_]*LIB[sS][[:space:]]*\+=.*\b<stem>\b' {} \;
```

```
rg -l --no-ignore --hidden -g '*.c' -g '*.cpp' -g '*.cc' -g '*.h' '#include[[:space:]]*[<"]<header-prefix>' <repository>

find <repository> \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' \) -not -path "*/.git/*" \
  -exec grep -lE '#include[[:space:]]*[<"]<header-prefix>' {} +
```

`<stem>` is the name of a library the module builds: before a build, read it from `LIBRARY_IOC` or `LIBRARY` in the Makefile of the module's application directory (`caPutLog-src/caPutLogApp/Makefile` names `caPutLog`), and after a build, from the `lib=` entries of its `cfg/iocsh.conf`. `<header-prefix>` is the prefix of the module's public headers (`asyn`); a module with several prefixes takes an alternation (ADCore: `(ND|AD)`; caPutLog: `(caPutLog|caPutJson)`). Read the prefixes from the `INC` lines of the Makefile of the module's application directory. Agreement of the two tools validates the traversal, not the pattern: keep `LIB[sS]` so that `<ioc>_LIBS`, `Common_LIBs`, and `PROD_LIBS` all match, and `.*\b<stem>\b` so that a name anywhere in the list matches (`testBusyAsyn_LIBS += busy asyn autosave`). Without `--hidden`, `rg` skips `.ci/`. A module that takes another's libraries through that module's `cfg/` files, as the areaDetector detectors do through ADCore's `commonLibraryMakefile`, shows only in the installed tree.

**Rule - the installed tree has the last word.** The reverse dependencies found in the sources are final only when a built tree agrees with them. In the installed tree `<tree>`, list the objects whose ELF `NEEDED` names the module's library, and the modules whose loader metadata records a dependency on it:

```
find <tree>/modules -type f \( -name '*.so*' -o -path '*/bin/linux-x86_64/*' \) \
  | while read -r f; do readelf -d "$f" 2>/dev/null | grep -q '\[lib<stem>\.so' && echo "$f"; done

find <tree>/modules -mindepth 1 -maxdepth 1 -type d -exec test -f {}/cfg/iocsh.conf \; \
  -exec grep -l '^dep=<name> ' {}/cfg/iocsh.conf \;
```

Read each `<stem>` from the `lib=` entries of `cfg/iocsh.conf` in the directory the link `<tree>/modules/<name>` names; an entry is a path such as `lib/linux-x86_64/libpvxs.so`, and the stem is the file name without `lib` and `.so`. Run the first command once per entry (pvxs and seq install two libraries, ADCore four). The module's own library always matches, because its `SONAME` entry names it; ignore the paths under `<tree>/modules/<name>-<version>/`. The pattern ends in `\.so` because `\[libstd` also matches `libstdc++`. The suite leaves second versions of some modules in the tree (`asyn-<commit>`, `linStat-<version>`); read only the directory the module's link names, and skip a directory without `cfg/iocsh.conf` (`commonIocsh`). For EPICS base every module is a consumer and this search is not made. In one pvxs bump the sources named linStat and the tree named none; in one sscan bump the sources named five and the tree named calc, asyn, mca, and measComp.

`work/<module>-bump/reverse-deps.md` holds the result. It lists each consumer with its kind (build-order, link-level, or runtime) and the file and line that shows it, then each hit judged not to be a consumer with its reason (a conditional block, a removed application, an example of this repository), and the line `no module consumer` when there is none.

Worked example, asyn R4-45: 11 link-level consumers (modbus, lua, std, StreamDevice, busy, scaler, mca, measComp, motor, motorMotorSim, pmac; six shared the C17 bridge, and motor/pmac were the deepest), ADCore directly and ADSimDetector, ADGenICam, ADVimba through `build.ADCore`, and 3 more at the link level. The list is a snapshot of its bump; make a fresh one for every execution.

## Stage 4 - Diff the changeset and judge API/ABI compatibility

```
cd <module>-src
git fetch --tags origin
git diff --stat <old-tag>..<new-tag>
git rev-list --count <old-tag>..<new-tag>
git diff --name-only <old-tag>..<new-tag> | wc -l
```

`<old-tag>` and `<new-tag>` are bare tag names (`R4-45`, `R4-46`); for a commit pin they are the pinned and the newer upstream commit ids, never the branch name. Count at the exact refs, never to the branch head: one pvxs survey said 73 commits and 74 files to the head where the tag held 71 and 72.

Scope the diff to the library directory (asyn: `asyn/`; an areaDetector module: `<mod>App/`) and list the changed headers:

```
git diff --stat <old-tag>..<new-tag> -- '<libdir>'
git diff --name-only <old-tag>..<new-tag> -- '<libdir>' | grep '\.h$'
```

Also read the diff of the module's Makefiles and `configure/CONFIG*`: asyn R4-46 made vxi11 opt-in behind `DRV_VXI11`, no header changed, and the StreamDevice example stopped linking (EPICS-env keeps the downstream patch `StreamDevice-no-vxi11.p0.patch`).

The break test on each changed header is symbol removal or signature change.

**Pitfall.** A removed symbol may have moved: asyn's `paramErrors.h` lost six `#define`s that reappeared in the `asynStatus` enum of `asynDriver.h` with the same names and values. Trace the symbol before calling it a break.

**Pitfall.** A mid-struct insertion (`getAutoConnectTimeout` in `asynManager`) breaks only a pre-built consumer linked against the new library. This tree rebuilds every consumer from source, so it is safe here. Additions at the end of an enum or string table are safe in a coherent rebuild.

## Stage 5 - Maintainer decision

Present every consumer and the compatibility finding, and, after a failed Stage 6, the failure and its cause. The maintainer decides IN or HOLD; a module with no newer upstream release is unchanged and needs no decision.

## Stage 6 - Real-path verification

Step 1 runs when the pin differs from the decided value: after IN with explicit authority to edit the pin, or after a HOLD that follows a failed Stage 6, where it puts the old value back. Otherwise the cycle starts at step 2.

1. Edit `SRC_TAG_<KEY>` and `SRC_VER_<KEY>` in `configure/RELEASE` (the tag only where the version is derived), the pin table of the book, `docs/src/reference/module-pins.md`, and, for asyn, StreamDevice, pvxs, linStat, and EPICS base, the installed versions that the loader suite under `examples/iocsh/tests/` names (Stage 2).
2. Rebuild the module from its pin, then every module whose `_DEPS` lists `build.<module>`, from clean, in the order of `configure/CONFIG_MODS_DEPS` (the book page `docs/src/procedures/add-or-bump-module.md`, steps 7-15). The module: `make reconf.modules`, `make print-INSTALL_LOCATION_<KEY>`, remove `<module>-src` (`make init` and `make <KEY>` skip an existing directory), `make <KEY>`, the patch targets of the `patch:` list in `configure/RULES_SRC` that name the module, `make conf.<module>`, `make check.module-deps MODULE=<module>`, `make build.<module>`, `make symlink.<module>`. Each dependent, by its repository name `<dependent>`: `make distclean.<dependent>`, `make conf.<dependent>`, `make build.<dependent>`. A module that reaches the bumped one only through another dependent rebuilds in its own cycle. The pin change rewrites the dependent's release files, and `build.<dependent>` alone relinks only the objects whose inputs changed while it writes a fresh build record for the whole module; a library left unrelinked then differs from its record the next time anything recompiles it, and `iocsh_metadata.bash` refuses the module. A calc update once showed it: the suite's repeated installation recompiled asyn after `build.asyn` had left `libasyn.so` unrelinked. `make build.<module>` first runs the `build.` targets that the module's `_DEPS` names (`configure/RULES_FUNC`), which rewrites their build records as well; read their results the same way. For EPICS base, step 2 is the baseline build (`release-procedure.md`, Test machines).
3. Start a representative IOC, the minimal example IOC that `guest-suite.bash` starts (The checks, item 3), and run `make check.deps` and `make check.env` on the installed tree. Every consumer must relink and start; a source build alone is not completion.
4. Answer a configuration question the bump reopens with real builds, for example the Ubuntu 26 C17 bridge: build with and without `-std=gnu17`, and if both pass remove the module's append in `configure/RULES_MODS_CONFIG` (or `iocStats_CONF_SITE_LINES` in `configure/CONFIG_MODS_DEPS`) and the module list in the rationale comment and the book.
5. Read the deepest consumers first: a motor change once removed `NUM_MOTOR_DRIVER_PARAMS` from `asynMotorController.h` while pmac still used it.

### The checks

For a site cycle, use `site-modules-procedure.md`, Cycle evidence, to map
these checks to the owning checkout. The scripts below are EPICS-env helpers;
their success does not establish that a site module was built or exercised.
Rebuild site consumers in their own checkout when checking an EPICS-env
dependency, and start the representative site IOC on the shared tree.
When restoring a damaged tree after a loader-suite failure, restore the site
modules at the recorded pins as well. Compare counts with evidence taken
after their installation, as `release-procedure.md`, Test machines, requires.

The checks run on the test machines of the release, in the sandbox checkout `<sandbox>/EPICS-env`, as the user that owns it and the installed tree (`release-procedure.md`, Test machines). On the local host run each command below directly; on a guest run it over SSH as shown. Bring the candidate in with `git -C <sandbox>/EPICS-env fetch origin` and `git -C <sandbox>/EPICS-env checkout <commit>`, then run the three scripts of `tools/module-check/` with the paths passed explicitly; the scripts resolve each path with `readlink`, and their defaults are `${HOME}/sandbox`, `${HOME}/sandbox/EPICS-env`, and `${HOME}/sandbox/iocsh-tests`. `<user>`, `<guest>`, and `<options>` are the account, the address, and the SSH options of the guest access (`release-procedure.md`, Test machines). Keep each output as a log in the local checkout:

```
ssh <options> <user>@<guest> 'bash <sandbox>/EPICS-env/tools/module-check/<script> <arguments>' > work/<module>-bump/<label>-<os>.log 2>&1
ssh <options> <user>@<guest> 'cd <sandbox>/EPICS-env && make check.deps' > work/<module>-bump/installed-tree-deps-<os>.log 2>&1
ssh <options> <user>@<guest> 'cd <sandbox>/EPICS-env && make check.env' > work/<module>-bump/installed-tree-env-<os>.log 2>&1
```

Run `make` inside the checkout, not with `make -C`, which breaks module dependency resolution with make 4.2.1 on Rocky Linux 8. Paths must be canonical: under a symbolic link the loader reports resolved paths and the suite fails 25 checks of a sound tree. Where a script does not yet do what a step says, `release-procedure.md` step 5a applies. `guest-update.bash` removes `<module>-src`, `guest-roundtrip.bash` removes `<parent>/EPICS-env-roundtrip`, and `guest-suite.bash` removes and recreates its log directory.

1. `guest-update.bash <module> <KEY> <commit> <sandbox>/EPICS-env` does step 2 for the module and prints the install location, the `modules/<module>` link, the SONAME of each library, the `version=` line, and the cfg files. Rebuild the dependents afterwards by hand. Until the script applies patch targets, a module that has downstream patches at its pin is built by hand in the step 2 order; a module has downstream patches when an apply target of the `patch:` list applies at least one file at that pin. `grep -o -E 'patch\.<module>\.[A-Za-z0-9.]*apply' configure/RULES_SRC | sort -u` lists the module's apply targets (`base` for EPICS base; none for asyn), and for base, pvxs, autosave, linStat, modbus and StreamDevice `ls patch/<SRC_VER>-*.p0.patch` shows whether their target applies any file. For a module whose module name differs from its repository name (sequencer) the link line prints empty; read it with `readlink <tree>/modules/<name>`.

   `make distclean.<module>` is unsafe for the bumped module or a dependent whose top Makefile passes `realuninstall` to an `iocs/` directory the build does not enter: it removes the installed `db`, `dbd`, and `doc` and exits 2. Read both facts from the module at its pin: `grep -n realuninstall <module>-src/Makefile`, and `grep -n BUILD_IOCS <module>-src/Makefile <module>-src/configure/CONFIG_SITE*` (unset counts as not `YES`). For such a module remove the source tree and rebuild it from `make <KEY>` instead.
2. `guest-roundtrip.bash <commit> <module> <sandbox>` clones the candidate into `<sandbox>/EPICS-env-roundtrip`, runs `make init`, `make patch`, `make patch.revert`, and prints the `Patching` counts and the status lines of every source tree. It clones `https://github.com/jeonghanlee/EPICS-env` unless `EPICS_ENV_REPO` names another repository, so the candidate must be on that repository. It gives make an install location inside the clone, because any make action creates the install location and the default is under the home directory; confirm `~/epics` did not appear. For EPICS base leave the module argument empty: `guest-roundtrip.bash <commit> "" <sandbox>`.
3. `guest-suite.bash <sandbox>/EPICS-env <sandbox>/iocsh-tests/<module>` starts the minimal example IOC through the installed loader and runs `examples/iocsh/tests/run_all.bash`. For EPICS base `<module>` is `base`, as in `work/base-bump/`. Compare the counts with `examples/iocsh/tests/README.md`; a machine without `docker` gives 6 for `verify_docs_and_tools`, and a machine without `/sys/class/hwmon` adds five linStat error lines to `records listed`. The suite needs `gawk`, `expect`, `strace`, `socat`, `podman`, ShellCheck, and access to GitHub and `docker.io`; it checks all but ShellCheck, so run `command -v shellcheck` first. A failed suite does not restore the tree (a link can be missing, an install half done): count the entries of `<tree>/modules` (`find <tree>/modules -mindepth 1 -maxdepth 1 | wc -l`) against the `modules entries:` line of the last `guest-update.bash` log on that test machine (in the cycle of EPICS base, which runs no `guest-update.bash`, against the same count taken once the baseline is good), and when the count differs, move `<sandbox>/epics` aside as evidence and rebuild the whole tree at the current candidate into `<sandbox>/epics`, as the baseline is built (`release-procedure.md`, Test machines). A suite that passed leaves two more entries than that count, the second versions `asyn-<commit>` and `linStat-<version>`; the comparison applies to a failed suite only.

A run is good when `guest-update.bash` ends with `UPDATE-DONE <module> <commit>`, `guest-roundtrip.bash` prints `init rc=0`, `patch rc=0`, `revert rc=0`, and `status lines in all trees: 0`, and `guest-suite.bash` prints `FAIL lines: 0` and `run_all rc=0` with a minimal IOC that exits 0 and prints one `iocRun` line; the suite script exits 0 either way, so read the lines. Run `guest-update.bash` and `guest-suite.bash` on every test machine and `guest-roundtrip.bash` on one. For EPICS base, `guest-update.bash` and `check.module-deps` do not apply: the baseline build is its step 2, and base declares no `_DEPS`. Name each log `<label>-<os>.log` in `work/<module>-bump/` (`work/base-bump/` for EPICS base), where `<os>` is the operating system of the test machine (`debian13`, `rocky8`) and `<label>` is `build` for `guest-update.bash`, `patch-round-trip` for `guest-roundtrip.bash`, `consumers` for `guest-suite.bash`, `installed-tree-deps` and `installed-tree-env` for the two make checks, and `reverse-deps` for the search of Stage 3 in the installed tree.

Then find the reverse dependencies in the installed tree (Stage 3) over `$(make -s print-INSTALL_LOCATION_EPICS)/modules`, run `make check.deps` and `make check.env`, and `grep -rn '<old version>'` over the files the pin change rewrote (`git diff --name-only <pin-commit>^ <pin-commit>`) to confirm no old version remains, where `<old version>` is the version the pin change moved away from (for a pin put back, the version of the failed decision); a module whose pin did not move rewrites no file.

**Rule - a failed Stage 6 returns to the decision.** When a check of Stage 6 fails because of the module or a dependent, not the test machine, the cycle returns to Stage 4 with the failure and its cause: choose another newer upstream release or commit, a downstream patch (`upstream-fix-carry-procedure.md`), or HOLD, and the maintainer decides again (Stage 5). Stage 6 then runs again from step 1 with the new decision, and the loop repeats until Stage 6 passes.

**Rule - `make -n` is not a read-only probe on a built tree.** GNU make remakes included makefiles even under `-n`, and the base build rules let the dependency files be remade, so a dry run regenerates them and reinstalls headers newer than the installed copy; `make -n install` in base's libcom once reinstalled `epicsString.h`. Probe a built tree with `find -newer`, `stat`, and `readelf`; the query targets (`print-<VARIABLE>`, `vars`, `conf.<module>.show`) are write-free and stay usable.
