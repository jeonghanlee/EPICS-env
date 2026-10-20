# Module Version Bump - General Procedure

How to decide whether a pinned module's tag moves to a newer upstream release,
and how to carry that move through the tree without breaking the modules that
build on it.

This document is written to be executed from itself. An agent arriving with no
memory of any previous execution should be able to work through it end to end.
Every mechanism needed to reproduce the assessment - commands, the census
method, the diff filter, the break test - is written here rather than
referenced from a scratch directory, because `work/` is gitignored in this
repository and does not survive.

Applies to any pinned module in the tree of the two repositories: EPICS-env
and the site module repository that builds on it. The
site module repository can be private; outside a release cycle, an agent
without access to it records the site module repository as not surveyed, but
in a release cycle (`release-procedure.md`) every site module is surveyed and
carried, and missing access stops the release until the owner fixes it. The
worked example throughout is asyn `tags/R4-45` -> `tags/R4-46` (issue #61),
chosen because asyn has the most dependents of any module in the tree; a
module with fewer consumers exercises the same stages with a smaller census.
This document is the general form; each execution keeps its decision record
where Stage 5 says. An earlier release kept a separate
`docs/module-bumps-<ver>.md` per release; the one under `docs/archive/` is the
example of that record form.

## Roles

| Role | Does | Does NOT |
| :-- | :-- | :-- |
| Owner | Decides IN/HOLD per candidate; signs the result; accepts the plan and separately authorizes the implementation, including the pin edit; each commit, push, issue action, merge, and tag, in this repository or in another repository, is its own authorization | - |
| Agent | Surveys, builds the dependent census from module sources, diffs the changeset, judges the API/ABI break surface, presents the full finding; edits, commits, and pushes in this repository and in the site module repository alike, each action under the owner's authority | Edit the pin without explicit authority; treat a static pass as a release; read a module's minimum requirement as a fixed pin |

A clean changeset review is a **recommendation to build and verify**, not a
release. The static stages (1-4) can only clear or block; they never stand in
for the real build, link, and IOC-startup verification in Stage 6.

In a release cycle every module of the two repositories, EPICS base
included, runs every stage whether its pin moves or not, because the libraries
under it change without notice. IN, HOLD, and unchanged are outcomes recorded
at Stage 5; they decide whether the pin moves, not which stages run.
`release-procedure.md` runs Stages 1 to 5 once for all the modules in its
steps 3 to 5; the cycle of a module then runs Stage 6, with the dependents of
its Stage 3 census as the list to rebuild.

In a release cycle each module has its own issue, and its plan is reviewed in
a third-person pass and in second-person passes (the `agent-review` skill,
self-review unless the owner names another topology) before the owner accepts
it and separately authorizes the implementation. The findings of the passes
and the owner's rulings are recorded in the plan of the module's register
detail, beside its acceptance; a commit message carries the change, not the
review (`git-workflow`, Message Style). This is the practice of this
repository, not a rule of the register skill.

## What differs by repository

The same stages carry a module of any repository, and the same session runs
them: it edits, commits, and pushes, opens and closes the module's issue, and
records the module in this repository's register, as for an EPICS-env module.
`release-procedure.md` orders them. This table is the whole difference
between an EPICS-env module and a module of another repository.

| Item | EPICS-env | Site modules |
| :-- | :-- | :-- |
| Survey (Stage 1) | `tools/update-release.bash check`; exit 0 or 2 means every remote answered, 1 means incomplete | No tool; `git ls-remote --tags` of `$(SRC_URL)/$(SRC_NAME_<KEY>)` from its `configure/RELEASE`, for tag pins; complete when every key answered, and missing access to the site remote stops the release |
| Issue | This repository's tracker | None; the module is recorded in this repository's register only, which is public, so its records name roles instead of site hosts and identities |
| Candidate | This repository's tip, carrying the plan commit and any pin change | The site repository's release-line tip, carrying any pin change; the plan commit is in this repository's register |
| Census (Stage 3) | The dependents of the bumped module across the two repositories | Which changed EPICS-env modules reach this module, from fresh clones at the pinned commits; earlier census records are leads, not results. Stage 3 also runs inside the repository |
| Guests and selector | The two baseline guests of the Stage 6 guest section (`epics_env_tag=<commit>`, the EPICS-env build input) | New guests of the default operating systems of the Stage 6 guest section, or of the set the owner extended there for the release line; EPICS-env at `epics_env_tag=<the tip of this repository's release line on origin when the guests are requested>`, the site module repository added by its own playbook (`site_modules_version=<commit>`, `path_set_epics_env=<setEpicsEnv.bash of the tree>`), after the commit is pushed to the site remote. An installed repository is skipped, so a verification after a fix uses a reset or a new guest |
| Verification (Stage 6) | The guest scripts of `tools/module-check/` and `check.module-deps`, then `make check.deps` and `make check.env` | The same as EPICS-env, run on the site module repository (the guest scripts of `tools/module-check/` and `check.module-deps` take that repository), then `make check.deps` and `make check.env` in the EPICS-env checkout of the guest, because those two targets exist only there |

A module check names a commit as its selector. The tag-or-branch resolution of
the pipeline applies to the release verification and the ship runs, not to a
module check.

## Working layout

```
work/<module>-bump/            # scratch; gitignored, nothing here survives
  survey.txt                   # Stage 1: update-release.bash check output
  census.md                    # Stage 3: per-repository dependent list with link evidence
  header-diff.txt              # Stage 4: old..new diff filtered to library headers
docs/milestone-<release>.md    # durable decision record (Decisions rows)
```

Anything that must outlive the session goes into `docs/`. Treat `work/` as a
desk, not a filing cabinet.

## Stage 1 - Survey the upstream state (read-only)

Establish the starting point without touching the tree.

```
tools/update-release.bash check
```

The `check` subcommand modifies no file. Its exit code is the completeness
signal:

- `0` - survey complete: every configured remote answered (up to date or update
  available).
- `1` - survey incomplete: a module was unreachable or carried no repository
  URL. Do not read a bump decision off an incomplete survey.
- `2` - survey complete but a module is indeterminate (reachable, no release
  tag). A usage error also exits 2; read the output.

**Pitfall - a tag pin is compared against the latest tag, not a branch.** The
survey compares a tag pin with the newest release tag and a commit pin with
the branch head. A tag-pinned module whose upstream branch has advanced past
its newest tag reports `OK` here. Moving a pin to *branch* commits ahead of a
tag is a different operation
(`docs/procedures/upstream-fix-carry-procedure.md`), not a version bump. Do
not read a Stage 1 `OK` of a tag pin as "nothing to carry".

## Stage 2 - Locate the pin

A module's released version lives in one tracked place, keyed by the module
key (`ASYN`, `STREAM`, `SNCSEQ`, ...; the `Key` column of the book's module
pins reference):

```
configure/RELEASE:  SRC_TAG_<MODULE_KEY>   (e.g. SRC_TAG_ASYN:=tags/R4-46)
                    SRC_VER_<MODULE_KEY>   (e.g. SRC_VER_ASYN:=4.46.0)
```

An untracked `RELEASE.local` can override the pin: `configure/RELEASE` reads
`$(TOP)/../RELEASE.local` next to the checkout and then
`configure/RELEASE.local`, the later one winning. Both apply to that
checkout only; check it before reading the pin in effect with
`make print-SRC_TAG_<MODULE_KEY>`. Confirm there is no second authority before
editing:

```
grep -rn "<old-tag>\|<old-ver>" . | grep -v '\.git/'
```

Every other hit is documentation, a tooling example, a patch file or patch
rule, a cloned source tree (`*-src/`), or a generated build file - a decision
record, a release note, a version-conversion comment, `patch/README.md`,
`configure/RULES_PATCH`, or `configure/MODULESGEN.mk`, which carries the
version in an install path but is gitignored and regenerated from `SRC_VER_`.
None of them is the pin. Change `SRC_TAG_` and `SRC_VER_` only.

**Pitfall - carried patches are anchored to the version.** The EPICS base and
pvxs carry sets apply only the files named `patch/<SRC_VER>-*.p0.patch`, so a
bump of either silently drops its whole carry set, and a fixed module patch
in `patch/` stops applying when the new source no longer matches it. Re-examine
every carry of the bumped module under the Bump obligation of
`docs/procedures/upstream-fix-carry-procedure.md`.

## Stage 3 - Build the dependent census, from module sources

This is the heart of the assessment. Enumerate every module that consumes the
bumped module, across both repositories, and grade each consumer by how it
actually uses the module - not by what its `RELEASE` declares. Take the module
sources fresh at the pinned revisions: `make init` skips an existing source
directory, so a tree left from an earlier run can sit at another revision.

**EPICS-env.** Build-order dependents are declared in
`configure/CONFIG_MODS_DEPS` as `build.<module>`:

```
grep -n "build.<module>" configure/CONFIG_MODS_DEPS
```

**The site module repository.** It is a separate checkout, conventionally a
sibling of this repository, and holds its module sources only after
`make init` is run inside it. Read those module sources, not the environment
config. Evidence of a build-level dependency is a `..._LIBS += <module>` line
(with the matching `<module>.dbd`) in an App Makefile, or a source file that
includes a header of the module; a runtime dependency is a device-support
template or db install. A module can compile against the headers and take the
symbols from its IOC's link line without naming the module in its own
`_LIBS`: `rgamv2` includes `asynPortDriver.h` and links only
`$(EPICS_BASE_IOC_LIBS)`, yet `rgamv2_DEPS` lists `build.asyn`.

**Pitfall - a `RELEASE` declaration is not a link.** A module's
`configure/RELEASE` may declare `ASYN = $(MODULES)/asyn` and never link asyn.
Grade the consumer by `..._LIBS +=` / `.dbd` in its App Makefile, not by the
`RELEASE` line. In the asyn worked example, two site modules declare
`ASYN=` but link nothing.

**Pitfall - a link line the build never reaches is not a consumer.** A
`_LIBS +=` line inside a conditional block, or in an application that a
carried patch in `patch/` removes from the build, links nothing. Read the
module's `conf.<module>` rule and its patches before grading. `feed-core`
links asyn only in its bundled `feedioc` application, under
`ifneq ($(BUSY),)` and `ifneq ($(ASYN),)`; `conf.feed-core` sets neither,
`feed-core-libonly.p0.patch` drops that application from the build, and
`feed-core_DEPS` is `null.base`.

**Pitfall - a build switch the configuration turns off.** A link line in an
application that the module's own build does not enter links nothing. linStat's
`exampleApp/src/Makefile` links `pvxsIoc pvxs`, but `conf.linStat` writes
`LINSTAT_BUILD_EXAMPLE = NO`, so no installed linStat object links pvxs;
StreamDevice's `streamApp/Makefile` links sscan only under
`ifneq ($(words $(SSCAN) $(SYNAPPS)), 0)`, and `conf.StreamDevice` sets
neither. Read the `conf.<module>` rule and the module's `configure/CONFIG_SITE`
switches before grading a source-level link.

**Rule - the installed tree has the last word.** The source census is final
only when a built tree agrees with it. In an installed tree, list the objects
whose ELF `NEEDED` names the module's library and the modules whose loader
metadata records a dependency on it; the two lists are the build-level
consumers that must relink after the bump:

```
find <tree>/modules -type f \( -name '*.so*' -o -path '*/bin/linux-x86_64/*' \) \
  | while read -r f; do readelf -d "$f" 2>/dev/null | grep -q '\[lib<module>\.so' && echo "$f"; done

find <tree>/modules -mindepth 1 -maxdepth 1 -type d -exec grep -l '^dep=<module> ' {}/cfg/iocsh.conf \;
```

The pattern ends in `\.so` because a library name can be the prefix of another:
`\[libstd` also matches `libstdc++`, which every C++ object names, and listed
most of the tree as consumers of std. The module's own library appears in the
result through its SONAME line and is not a consumer.

In one pvxs bump the source census named linStat as a link consumer and the
installed tree named none; in one sscan bump the census named five and the
installed tree named calc, asyn, mca, and measComp.

**Pitfall - the sources are gitignored, so a search tool's defaults hide
them.** The `-src` trees `make init` fetches are gitignored. `rg` honors
`.gitignore` and returns nothing for them unless forced; a plain
`grep -r --include` was also observed to skip these trees silently when the
shell wraps `grep` in a function that honors ignore files (call
`command grep` to bypass it). Both
failures report a clean repository that is not clean. Run two searches that fail
differently and require the same result - ripgrep forced past the ignore rules,
and `find` + `grep`, which never consults `.gitignore`:

```
rg -n --no-ignore -g Makefile '[A-Za-z_]*LIB[sS][[:space:]]*\+=.*\b<module>\b' <repository>

find <repository> -name Makefile -not -path "*/.git/*" \
  -exec grep -HnE '[A-Za-z_]*LIB[sS][[:space:]]*\+=.*\b<module>\b' {} \;
```

Run the same pair for header includes, which finds a consumer such as
`rgamv2` that no link line names; `<header-prefix>` is the prefix of the
module's public headers, such as `asyn`:

```
rg -l --no-ignore -g '*.c' -g '*.cpp' -g '*.cc' -g '*.h' '#include[[:space:]]*[<"]<header-prefix>' <repository>

find <repository> \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' \) -not -path "*/.git/*" \
  -exec grep -lE '#include[[:space:]]*[<"]<header-prefix>' {} +
```

A divergence between the two means the ignore rules or the traversal are hiding
files - investigate before trusting the census. Agreement validates traversal
only, not the pattern: both tools run the same regex and share its blind spot,
so keep the pattern wide enough for the project's Makefile conventions. The
`LIB[sS]` tail above matches `<ioc>_LIBS`, `Common_LIBs`, and `PROD_LIBS`
alike, and `.*\b<module>\b` finds the module anywhere in the list, as in
`testBusyAsyn_LIBS += busy asyn autosave`. The narrow `LIBS +=` form missed a
site module's `Common_LIBs += asyn`, and a pattern that reads only the first
name after `+=` misses every later name; in both cases the two tools agreed on
the wrong count.

Worked example - asyn R4-45 dependent census, as taken for that bump:

| Repository | Link-level consumers | Notes |
| :-- | :-- | :-- |
| EPICS-env | 11: modbus, lua, std, StreamDevice, busy, scaler, mca, measComp, motor, motorMotorSim, pmac | 6 shared the C17 bridge; motor/pmac are the deepest consumers |
| EPICS-env (areaDetector, then in its own repository) | 1 direct: ADCore (`ADApp/ADSrc`, `ntndArrayConverterSrc`) | ADSimDetector, ADGenICam, ADVimba build on ADCore (`build.ADCore`); an asyn bump reaches them transitively |
| Site module repository | 3 site modules | one more has a runtime db template only; two declare `ASYN=` but do not link |

The census is a snapshot of its bump: modules have since moved into EPICS-env,
and `grep -n "build.asyn" configure/CONFIG_MODS_DEPS` counts the dependents
of today; take a fresh census for every execution.

## Stage 4 - Diff the changeset and judge the break surface

`make init` fetches the pinned (old) tag. To see the new tag without changing
the pin, fetch it into the same checkout and diff. `<old-tag>` and `<new-tag>`
are the bare tag names (`R4-45`, `R4-46`), which git resolves with or without
the `tags/` prefix the pin stores:

```
cd <module>-src
git fetch --tags origin
git diff --stat <old-tag>..<new-tag>
```

**Rule - count at the exact ref.** Record the commit and file counts between
the pinned ref and the candidate ref, never to the branch head and never from
an earlier survey note:

```
git rev-list --count <old-tag>..<new-tag>
git diff --name-only <old-tag>..<new-tag> | wc -l
```

The survey of one pvxs bump carried 73 commits and 74 files, counted to the
branch head, where the newest tag held 71 and 72.

Filter the diff to the library surface the census consumers link against -
public headers and interface/device-support source - and set docs, test apps,
and CI aside. The library lives in a module-specific subdirectory, not always
`src/`: asyn's is `asyn/`, an areaDetector module's is `<mod>App/`. Identify
that subdirectory and scope the diff to it, then list the changed headers:

```
git diff --stat <old-tag>..<new-tag> -- '<libdir>'
git diff --name-only <old-tag>..<new-tag> -- '<libdir>' | grep '\.h$'
```

**Pitfall - a build option change breaks consumers without a header change.**
Also read the diff of the module's Makefiles and `configure/CONFIG*` files. In
the asyn worked example, R4-46 made the vxi11 driver opt-in behind
`DRV_VXI11`; no header changed, but `vxi11RegisterCommands` disappeared and
the StreamDevice example stopped linking. EPICS-env carries
`StreamDevice-no-vxi11.p0.patch` for it.

The break test on each changed header looks for **symbol removal or signature
change**, judged from the diff itself.

**Pitfall - a removal is not a break until you trace where the symbol went.** A
symbol deleted from one header may be relocated to another with its name and
value preserved. In the asyn worked example, `paramErrors.h` "removed" six
`#define`s (`asynParamNotFound` and siblings); the same diff moved them into the
`asynStatus` enum in `asynDriver.h` with identical names and identical numeric
values (`asynDisabled + 1..6`). No consumer breaks. Stopping at the removal
would have blocked a safe bump.

**Pitfall - a mid-struct insertion is ABI-sensitive only under mixed linking.**
Inserting a function pointer into the middle of a published struct
(`getAutoConnectTimeout` in `asynManager`) shifts later member offsets. In a
full-source rebuild - where the bumped module and every census consumer compile
against the same new headers - the layout is consistent and the change is safe.
It breaks only when a pre-built old consumer links against the new library,
which this from-source tree never does. Distinguish "full-source rebuild" from
"mixed link" before calling a struct change a break.

Additive changes at the end of an enum or string table (a new exception, a new
error code) are ABI-safe in a coherent rebuild.

## Stage 5 - Owner decision

Present every census consumer and the full break-surface finding. The owner
decides IN or HOLD and signs it. Record the decision - module, old -> new,
verdict, one-line reason - in the execution's decision record, the Decisions
of the release register (`docs/milestone-<release>.md`). The static review
recommends; the owner decides.

## Stage 6 - Real-path verification

Every module runs this stage. Step 1 runs only after an IN decision and
explicit authority to edit the pin; a HOLD or unchanged module starts at
step 2 with its pin as it stands. For EPICS base, step 2 is the full build of
the tree at its candidate commit on fresh guests, the baseline build of the
guest section below, since every module builds on base through `null.base`;
the checks of that section follow (`guest-roundtrip.bash`, `guest-suite.bash`,
`make check.deps`, and `make check.env`). `guest-update.bash` handles a
module, not base, and `check.module-deps` audits a module's `_DEPS`
declaration, which base does not have, so neither is part of base's run.

1. Edit `SRC_TAG_<MODULE_KEY>` and `SRC_VER_<MODULE_KEY>` in
   `configure/RELEASE`.
2. Rebuild the module from its pin; a module that carries patches gets its
   apply targets, the ones of the `patch:` list in `configure/RULES_SRC` that
   name the module, applied after the clone and before its configuration
   target. `make init` and `make <MODULE_KEY>`
   skip a source directory that exists, so a fetched but unchanged
   `<name>-src` still builds the old tag. Follow the book page
   `docs/src/procedures/add-or-bump-module.md`, steps 7-15:
   `make reconf.modules`, `make print-INSTALL_LOCATION_<MODULE_KEY>`, remove
   `<name>-src`, `make <MODULE_KEY>`, the module's configuration target
   (`conf.<module>`, or a differing name such as `conf.sncseq` for
   sequencer), `make check.module-deps MODULE=<module>`,
   `make build.<module>`, `make symlink.<module>`, then rebuild every module
   whose `_DEPS` lists `build.<module>` from clean, in the order of
   `configure/CONFIG_MODS_DEPS`: `make distclean.<dependent>`, its
   configuration target, `make build.<dependent>`, except a module whose
   `distclean` is unsafe, which the guest section below describes. A module that reaches the
   updated module only through another dependent rebuilds in its own cycle. The pin change rewrites
   the dependent's release files, and `build.<dependent>` alone relinks only
   the objects whose inputs changed while it writes a fresh build record for
   the whole module; a library left unrelinked then differs from its record
   the next time anything recompiles it, and `iocsh_metadata.bash` refuses
   the module. Observed in a calc update: the loader suite's
   repeated installation recompiled asyn after `conf.asyn` and `build.asyn`
   had left `libasyn.so` unrelinked, and refused asyn's metadata.
3. Build, link, and start a representative IOC on every operating system that
   has a CI workflow (`docs/src/reference/supported-platforms-and-ci.md`), and
   run `make check.deps` and `make check.env` on the installed tree. Every
   census consumer must relink and pass its startup checks; a successful source
   build alone is not completion.
4. Resolve any configuration question the bump reopens - for example, whether
   the module still needs the Ubuntu 26 C17 bridge. Compare real builds with
   and without its `-std=gnu17` setting. If both builds pass, remove that
   module's conditional append from its custom target in
   `configure/RULES_MODS_CONFIG`, or its `iocStats_CONF_SITE_LINES` setting
   in `configure/CONFIG_MODS_DEPS` for iocStats. Update the module list in
   the C17 rationale comment and the book to match.
5. Read the results of the deepest consumers first, although they rebuild last
   in the dependency order. The motor/pmac pair is the known landmine
   at the bottom of the asyn stack: a motor change once removed
   `NUM_MOTOR_DRIVER_PARAMS` from `asynMotorController.h` while pmac still
   referenced it, failing every CI platform. The areaDetector modules warrant
   the same attention.

### On the epics-dev guests

The incremental checks of a module update run on two OS-matched virtual
machines, `debian13-epics-dev` and `rocky8-epics-dev`, the default set for
every repository; at the start of a cycle the owner may extend the set by a
dated decision in the register of that repository (Debian 12, Debian 14 once
it exists, Rocky Linux 9 and 10, Ubuntu 24.04 and 26.04, as cloud-provision
provides them). cloud-provision provisions them and the ansible-provision
`epics_build` operator builds from source at the candidate commit of EPICS
base, the first module of the cycle. Ask the cloud-provision session,
which owns the hypervisor and the provisioner, for them once per cycle with a
resource request in the form of the `agent-collaboration` skill: Purpose
first, then Platform, Resources, Duration, State, Access, and Follow-up. The
Follow-up is the EPICS-env build at that commit as `epics_env_tag` through
the operator playbooks `common`, `python`, and `epics_build`; the `epics_dev`
species would add its `epics_support` operator, which this release does not use. Send a finished notice when
the cycle no longer needs the guests, and ask the same session to shut down
the guests of an earlier cycle that this cycle does not use again, their disks
kept. The modules of a repository share one set of guests, and each of the
site module repository asks for its own set (the repository table). The
guests stay up between the updates: the baseline is built once per cycle, and
each module update rebuilds only its module and dependents into it. The checkout in a guest is `/opt/epics-env-src/EPICS-env`, root-owned, so the
scripts run as root. The two guests carry the per-module checks; Stage 6
step 3's run on every CI operating system is met once per cycle by the
release work on the combined tree, the six OS workflows and the two products.
A module that reopens Stage 6 step 4 answers it through the Ubuntu 26
workflow or a `ubuntu26-epics-dev` guest, which cloud-provision also
provisions.

Beyond the base guest, the loader suite needs `gawk`, `expect`, `strace`,
`socat`, `podman`, and ShellCheck (on Rocky Linux from EPEL), and network access to
GitHub and `docker.io`.

When the session of cloud-provision is not known, ask the owner for it. The
build on the guests runs the operator playbooks of ansible-provision there,
which the owner approves for that session each time (`agent-collaboration`,
`vm-request-handling.md`). Access to a guest comes from the private handoff
that the cloud-provision reply names: connect as the user it gives, with
`-o ControlMaster=no
-o ControlPath=none`, and `-o StrictHostKeyChecking=accept-new` for a new
guest (the `epics-env-pipeline` skill's `ssh-access.md`). Install the loader
suite's tools as root, with `apt-get install -y gawk expect strace socat podman
shellcheck` on Debian, and with `dnf install -y epel-release` and then
`dnf install -y gawk expect strace socat podman ShellCheck` on Rocky Linux. A build
through the `epics_build` operator succeeded when
`/var/tmp/epics-env-build.done` exists on the guest, and its log is
`journalctl -u epics-env-build.service`; record the OS point
release, the kernel, and the compiler with `cat /etc/os-release`, `uname -r`,
and `gcc --version`. Run each script as root over SSH and keep its output in
the local checkout:

```
ssh <options> <user>@<guest> 'sudo bash /opt/epics-env-src/EPICS-env/tools/module-check/<script> <arguments>' > work/<module>-bump/<label>-<os>.log 2>&1
ssh <options> <user>@<guest> 'sudo bash -c "cd /opt/epics-env-src/EPICS-env && make check.deps"' > work/<module>-bump/T4-deps-<os>.log 2>&1
ssh <options> <user>@<guest> 'sudo bash -c "cd /opt/epics-env-src/EPICS-env && make check.env"' > work/<module>-bump/T4-env-<os>.log 2>&1
```

Run `make` inside the checkout, not with `make -C`, which breaks the module
dependency resolution of make 4.2.1 on Rocky Linux 8. The log directory of
EPICS base is `work/base-bump/`; `<os>` is `debian13` or `rocky8`.

Three scripts under `tools/module-check/` carry the steps. First bring the
candidate into the guest with
`sudo git -C /opt/epics-env-src/EPICS-env fetch origin` and
`sudo git -C /opt/epics-env-src/EPICS-env checkout <commit>`, since the
checkout is root-owned, then run each script
from `tools/module-check/` of that checkout as root; `guest-update.bash`
repeats the checkout, which is harmless. Redirect each script's output to a
log under `work/` of the local checkout and keep it as the evidence of the
module's register rows:

1. `guest-update.bash <module> <KEY> <commit>` runs the module's own part
   of Stage 6 step 2 above at the candidate commit and prints the install
   location, the `modules/<module>` link, the SONAME of each installed library,
   the `version=` line of the loader metadata, and the cfg files: the Build
   row. Set `CONF_TARGET` when the configuration target differs from
   `conf.<module>`, as `conf.sncseq` does for sequencer, after `sudo` so that
   it reaches the script: `sudo CONF_TARGET=conf.sncseq bash … guest-update.bash`. The script handles
   one module; rebuild each dependent of Stage 6 step 2 afterwards from clean,
   with `make distclean.<dependent>`, `make conf.<dependent>`, and
   `make build.<dependent>` in that order, and record them in the same Build
   row. Read the top Makefile of every module before `make distclean.<module>`,
   the updated one or a dependent, at its pin: when it passes `realuninstall`
   to an `iocs/` directory that the build does not enter, the target removes
   the installed `db`, `dbd`, and `doc` of the module and then exits 2. For
   such a module remove its source tree and run `make <KEY>`, its
   configuration target, and `make build.<module>` instead; for the updated
   module this script does that. Several modules carry that Makefile text, so
   the check is per pin, not per name: `grep -n realuninstall <module>-src/Makefile`
   in the guest checkout shows it.
2. `guest-roundtrip.bash <commit> <module>`, on one guest (Debian 13 by
   default), clones the candidate beside the checkout, runs `make init`,
   `make patch`, and `make patch.revert`, and prints the `Patching` counts
   and the status line count of every source tree: the Patch round trip row.
3. `guest-suite.bash` checks the suite's tools, starts the minimal example
   IOC through the installed loader, runs `examples/iocsh/tests/run_all.bash`
   with `IOCSH_TEST_TREE`, `IOCSH_TEST_REPO`, and `IOCSH_TEST_OUT`, and prints
   the per-script lines, the three count-less outputs, and the `FAIL` count:
   the Consumers row. Compare the counts with the suite README; a guest
   without Docker gives 6 for `verify_docs_and_tools`, and a guest without
   `/sys/class/hwmon` adds five linStat error lines to the minimal example's
   record count, so `records listed` reads five more than the README.

Then run `make check.deps` and `make check.env` in the checkout for the
Installed tree row, and `grep -rn '<old version>'` over the files the update
rewrote for the Text agreement row; a module whose pin does not move rewrites
no file, and its Text agreement row says so.

**Rule - `make -n` is not a read-only probe on a built tree.** GNU make
remakes the makefiles it includes even under `-n`, and the Base build rules
include the per-object dependency files and let them be remade from their
sources, so a dry run inside a built checkout regenerates dependency files,
compiles generated sources, and reinstalls every header whose source is
newer than the installed copy. Observed in the Base libcom
directory of a Debian 13 guest: `make -n install` reinstalled
`epicsString.h` and remade four dependency files. The content stays the
same; only the timestamps move, and a moved timestamp makes the next real
build or install recompile what includes that header. Probe a built tree
with `find -newer`, `stat`, and `readelf` only. The EPICS-env query targets
(`print-<VARIABLE>`, `vars`, `conf.<module>.show`) are write-free by their
own rule and stay usable; a dry run of an action target is not.

## Record discipline

The decision record under `docs/` is what survives; `work/` does not. Record the
candidate, the old and new tags, the census, the break-surface verdict with its
evidence, the owner decision with its reason, and the Stage 6 verification
result. A module held (HOLD, a dated Decisions row) or found unchanged (a line in
the Decisions, shared by modules that stand alike) records why its pin did not move beside its Stage 6
result, so the next execution does not repeat the survey and census from
nothing. A
candidate examined and kept by owner decision outside any bump belongs in
`docs/CLOSED_DOORS.md`. A rule the bump taught goes into this procedure at
the step's close, and a lesson no procedure holds goes into the register's
lessons row; `documentation-upkeep-procedure.md` sets that order.
