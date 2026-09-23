# Upstream Fix Verification - General Procedure

How a fix to a pinned upstream module travels from a fork branch, through
hardware verification on the production environment, to its formal adoption
in this environment - and what each step proves.

This document is written to be executed from itself. An agent arriving with no
memory of any previous execution should be able to work through it end to end.
Everything needed to reproduce the mechanics - the build layout, the checks,
the record shape - is written here rather than referenced from a scratch
directory, because `work/` is gitignored in this repository and does not
survive.

Applies to any pinned module whose defect can only be observed on hardware
the development host (where the EPICS-env checkout lives) does not have. First execution is the measComp TC-32 channel-count
fix (worked example: `docs/measComp-tc32-fix-20260912-215519.md`). This document is
the general form; each execution keeps its own record under `docs/` holding
the verification ledger and the decisions.

## Scope

This document covers the path of one fix: writing it on a fork branch,
proving it compiles, checking it on hardware where hardware exists, verifying
it on the production environment without touching the installed tree,
submitting it upstream, and choosing how this environment adopts it.

**Out of scope:** how a carry candidate is scored and selected (covered in
`upstream-fix-carry-procedure.md`), how a pin moves to a newer upstream
version (covered in `module-bump-procedure.md`), and how a release is built
and shipped (the pipeline skill). This procedure hands off to those at the
points named in Stage 5 and Stage 6.

## Roles

| Role | Does | Does NOT |
| :-- | :-- | :-- |
| Owner | Decides when the production verification runs (immediately or in a maintenance window); decides the adoption path (carry or bump); signs the record | - |
| Agent | Prepares the fork branch, the independent build, the consumer IOC copy, the checks, and the record; presents evidence | Modify the installed production tree; stop, start, or replace a running IOC; commit, push, or open the upstream PR without the owner's explicit authorization |

The line between the two roles is the installed tree and the running IOC.
Everything the agent builds lives beside production and links to it; nothing
the agent does changes what production runs.

## Working layout

```
work/<module>-fix/              # scratch on the development host; gitignored, nothing here survives
  <slug>.patch                  # Stage 3: the fix as a patch file, carried to the production host
  commit-msg-<slug>.txt         # Stage 4: commit message draft
  pr-body-<slug>.md             # Stage 4: PR body draft
~/scratchpad/<module>-fix/      # fixed scratch dir on the production host, outside the install root and any checkout
  <module>/                     # the base source (git archive or fork checkout) + the fix, built in place
  <ioc>/                        # the consumer IOC copy, linked to the scratch module
docs/<module>-<topic>-<YYYYMMDD>-<HHMMSS>.md  # durable record, named per run (see Record discipline)
```

The production-host scratch lives at a fixed path, `~/scratchpad/<module>-fix/`,
not a session-temporary directory: the owner reopens it to inspect the build
and the link evidence after the run, so it must survive the session. It sits
outside the install root and outside any git checkout. Anything that must
outlive even that goes into `docs/`; treat the scratch dir as a desk, not a
filing cabinet, and clear it only when Stage 6 has superseded it.

## What each stage proves

The stages are ordered by what they can prove, not by convenience. A later
stage is never a substitute for an earlier one, and an earlier one never
stands in for a later one.

| Stage | Proves | Does not prove |
| :-- | :-- | :-- |
| 1 Compile | the change matches the vendor API and builds against a tree of the same generation | that the device behaves as the code assumes |
| 2 Lab hardware | the device in the lab reports what the code assumes | that the production unit, its firmware, or a differently equipped unit does the same |
| 3 Production | the fix on the production unit removes the symptom and keeps the unchanged behavior | anything about the installed tree, which the stage leaves untouched |
| 4 Upstream | the maintainers accept the change | - |
| 5 Adoption | this environment ships the fix by a recorded path | - |
| 6 Release | production runs the fix from the installed tree | - |

## Stage 1 - Fix and compile check

Branch from the module's upstream default branch on the fork, not from the
pinned commit: the upstream PR in Stage 4 targets the default branch, and a
branch based there applies without rework. Record the base commit and confirm
it is identical to the upstream default branch tip at the time.

Keep the change to the code path the defect lives in. A Linux-only defect in
a module with a Windows path leaves the Windows path unchanged, and the record
says so.

First select the environment version to build against, and select it by
asking the owner - this is the opening question of the run, not something the
agent infers. A host usually carries several installed trees side by side
(for example `<root>/1.2.0/<os>/<base>`, `1.2.1`, `1.2.2`, `1.3.0`), and a fix
built and verified against a different major version does not carry over: the
module generation (asyn, base, the other dependencies) differs between them.
So the version is an owner input:

- **Ask the owner** which installed version the production IOC runs, at the
  start of the run. Record the answer and the tree's absolute path.
- **If the owner does not specify**, default to the latest installed version
  on the host and record it explicitly as the default (not a confirmed
  production version). State the default in the record so a wrong guess is
  visible and the owner can correct it.

The IOC's own files help but do not decide: `iocBoot/<instance>/envPaths`
records the tree the last build linked (a useful cross-check), while
`configure/RELEASE.local` is a source-side override that may be stale or name
a different version entirely. Cite them to the owner when they disagree; the
owner's answer, or the recorded latest-version default, is what the run uses.
Stage 1 may use a tree of the same generation for the first compile, but
Stage 3 builds against the selected tree, and the record says which version
each row used.

Build against that tree. Derive the module's two local configuration files
from what this environment generates for it:

```bash
make -C <EPICS-env-checkout> conf.<module>.show
```

The target prints files that an earlier `make conf.<module>` (or `make conf`)
wrote in the environment checkout; on a fresh checkout run that first. The
output has four parts, in order: the environment's top-level `RELEASE.local`
(the `EPICS_BASE` line), its top-level `CONFIG_SITE.local` (`CHECK_RELEASE`
and the `PROD_LDFLAGS += -Wl,--enable-new-dtags` line), then the module's own
`CONFIG_SITE.local` and `RELEASE.local`. The module's own `RELEASE.local`
carries no `EPICS_BASE` line because the environment supplies it from the
directory above.

Compose the scratch module's files from those parts, with every path
rewritten to the tree being built against:

| Scratch file | Take | Drop |
| :-- | :-- | :-- |
| `configure/RELEASE.local` | the `EPICS_BASE` line, then every line of the module's `RELEASE.local` | - |
| `configure/CONFIG_SITE.local` | every line of the module's `CONFIG_SITE.local` except the first, then the `CHECK_RELEASE = NO` and `PROD_LDFLAGS` lines from the top-level `CONFIG_SITE.local` | the `INSTALL_LOCATION` line |

One line is dropped and two are taken on purpose. `INSTALL_LOCATION` names
the environment's install path, and a build that keeps it installs there.
`CHECK_RELEASE = NO` must stay: the installed module trees keep their
upstream `configure/RELEASE` files, whose paths are the upstream authors'
examples and never match this environment's, so with the check on the build
stops in `configure.install` with one "Definition of X conflicts with Y
support" line per dependency (observed against a 1.2.0 tree: 40 conflicts,
exit 2). `PROD_LDFLAGS += -Wl,--enable-new-dtags` is taken so the build
carries `DT_RUNPATH` as production does.

Where a vendor library is involved, use the tree's `vendor/` copy for both
headers and library; a mixed link (headers from one place, library from
another) builds but proves less, and the record must name it if it happened.

Compile proves that the call shape matches the vendor API and that the change
links. It proves nothing about the device. If a vendor library exposes a
configuration query the fix depends on, a compile-only check file that
exercises the exact call shape is a useful side artifact; keep it with the
scratch tree and name it in the record.

## Stage 2 - Lab hardware check (when hardware exists)

If a unit of the same hardware is available off the production environment,
run the fixed module against it first. This is the cheapest place to find a
wrong assumption about the device.

A lab pass is a necessary condition for Stage 3, never a sufficient one.
Three things make it so:

- **Firmware.** A fix that relies on a value the device reports (an
  expansion-present flag, a channel count, a capability bit) is verified only
  for the firmware that produced the value. The production unit may run a
  different revision.
- **Equipment.** A unit without an option board proves the no-option branch.
  It proves nothing about the with-option branch, which needs a differently
  equipped unit.
- **Variant.** Sibling models (a USB and an Ethernet variant of one device)
  share a code path but not necessarily a firmware; each answers for itself.

Record what the lab unit is (model, variant, option boards, firmware revision
where readable) beside the result, so the record shows exactly which
combination has been covered.

When no lab unit exists, record the stage as skipped for that reason and go
to Stage 3 with that gap named.

## Stage 3 - Production verification by an independent build

The production tree is the reference; the fixed module is built beside it,
never into it.

### Timing

The owner decides when the run happens, on one question: is the defect
already harming operation?

| Defect impact | Run |
| :-- | :-- |
| Harms operation now (wrong values, lost data, an IOC that cannot serve) | immediately; waiting is the larger risk |
| Does not harm operation (log noise, cosmetic, a limit not yet reached) | in the next maintenance window that can spare the IOC |

The device connection and the PV names are the reason a window is needed at
all: the running IOC and the test IOC cannot serve the same device and the
same PV names at once, so the running IOC is stopped for the duration of the
test. The independent build guarantees that the installed tree is untouched;
it does not make the two IOCs run side by side.

### Build the module beside production

The build steps of this section and the next (the scratch layout, both
builds, the link checks, and the install-root-untouched check) are automated
by `tools/verify_fix_stage3.bash` for the no-hardware part of the run; the
worked example's Hardware hand-off shows the invocation. The steps are
written out here so the procedure is executable by hand and so the script's
behavior is documented; run the script or follow the steps, not both.

On the production host, create the scratch directory and, as its first
content, the timestamp file the teardown check compares against - it must
predate every build step:

```bash
mkdir -p ~/scratchpad/<module>-fix
touch ~/scratchpad/<module>-fix/.started
```

Then place the base source and apply the fix, in this order:

1. Bring the base commit's source tree to `~/scratchpad/<module>-fix/<module>/`.
   The fork need not be cloned on the production host: archive the base commit
   from any checkout of the fork and unpack it here, the same mechanism the
   consumer IOC uses below -
   `git archive <base-commit> | tar -x -C ~/scratchpad/<module>-fix/<module>`
   (or clone the fork and check out the base commit, if a checkout is easier
   to keep).
2. Apply the fix. It is not committed until Stage 4, so it travels as a patch:
   on the development host, `git diff` of the fork checkout into
   `work/<module>-fix/<slug>.patch` (a `git diff`, so `a/ b/` prefixes -
   apply with `-p1`); on the production host, apply it to the unpacked base
   tree with the tree named explicitly, not from an assumed working
   directory -
   `git -C ~/scratchpad/<module>-fix/<module> apply <EPICS-env-checkout>/work/<module>-fix/<slug>.patch`
   (or `patch -d ~/scratchpad/<module>-fix/<module> -p1 < ...`). Record the
   file's `sha256sum` in the ledger row so the build is tied to the exact
   diff.

   When the fix is already carried in EPICS-env as a `-p0` patch under
   `patch/` (a carry awaiting an upstream release), skip this step: the base
   commit is the module pin in `configure/RELEASE`, and the carried patch is
   applied with the local build patches below, all in the order the `patch:`
   list in `configure/RULES_SRC` applies them. The script takes it the same
   way - set `--base-commit` to that pin, omit `--fix-patch`, and pass every
   patch as `--local-patch` in that order. Record each patch's `sha256sum`
   and the EPICS-env commit that supplied them.

Then apply this environment's local build patches for the module - the rows
naming the module in the local build patches table of `patch/README.md`:

```bash
patch -d ~/scratchpad/<module>-fix/<module> --ignore-whitespace -p0 < <EPICS-env-checkout>/patch/<module>-<slug>.p0.patch
```

Production's module carries those patches (`make patch` applied them before
the release build), so a scratch module without them differs from production
in more than the fix. A patch that adds an installed file (a `cfg/CONFIG_*`,
for example) must show that file in the scratch build's own top after the
build; check for it.

Compose the scratch module tree's `configure/RELEASE.local` and
`configure/CONFIG_SITE.local` by the Stage 1 table, with every path rewritten
to the production tree. The `INSTALL_LOCATION` line stays dropped: without it
the build installs into its own top (`lib/`, `bin/`, `dbd/` under the
checkout), which is the EPICS default, and nothing is written under the
install root.

Build, then confirm the result links only to production and to itself:

```bash
readelf -d lib/<arch>/lib<module>.so | grep -E 'NEEDED|RUNPATH|RPATH'
```

Every `NEEDED` library resolves into the production tree or the system; the
runpath names the production tree's paths. Nothing points at another
environment version. Keep the output as evidence.

### Build the consumer IOC copy

Take the consumer IOC's top from its committed tree, not from a working
checkout - `git archive <commit> | tar -x -C ~/scratchpad/<module>-fix/<ioc>` -
and record the commit. A working checkout carries untracked leftovers (an
old `iocBoot/<ioc>*` directory, for instance) that the IOC's wildcard `DIRS`
pick up and that fail the build after the binary is already made.

In the copy's `configure/RELEASE.local`, point the fixed module at the
scratch build and every other entry at the production tree, exactly as the
running IOC has them; an IOC that derives its module paths from
`$(EPICS_BASE)/../modules` needs only `EPICS_BASE` and the module's own
entry. In the copy's `configure/CONFIG_SITE.local`, set `CHECK_RELEASE = NO`
for the reason given in Stage 1.

If the module hands its consumers a vendor path through an installed
`cfg/CONFIG_*` file, that path is self-located (`<cfg dir>/../../../vendor`),
so a module built outside the tree hands the copy a path that does not exist
and the link fails on the vendor library. The copy declares the path itself
in `configure/CONFIG_SITE.local` - `ULDAQ_DIR` for measComp, `OPEN62541`
for opcua, each `=<install-root>/<version>/vendor` - and that declaration
wins: an
application's `configure/CONFIG` reads base `CONFIG`, which pulls in the cfg
files, before it reads the application's own `CONFIG_SITE` and
`CONFIG_SITE.local`. Confirm with `make -C <ioc>App/src -pn T_A=<arch>` that
the final value is the production vendor path.

Build, then confirm the binary picks up the scratch module and nothing else
from outside production:

```bash
readelf -d bin/<arch>/<ioc> | grep -E 'NEEDED|RUNPATH|RPATH'
ldd bin/<arch>/<ioc> | grep <module>
```

The module's library resolves to the scratch path; every other library
resolves into the production tree. Keep both outputs.

### Run

At the agreed time, first capture the baseline the success criteria name from
the still-running IOC - the values the fix must not change - for example with
`caget` over the listed PVs, and keep the output. Then the owner (or the
operator the owner names) stops the running IOC, starts the copy from its own
`iocBoot` directory with the same startup commands, and runs the checks
below. The record names the `iocBoot/<instance>` that serves the production
unit and where the asyn port name for `asynReport` comes from (the variable
in that instance's `st.cmd`), so the operator does not have to work either
out. The agent prepares the commands and reads the results; the agent does
not stop or start an IOC.

### Success criteria

Before writing the criteria, read the running IOC's startup files for
anything that already hides the symptom - a trace mask set to 0, a log
filter, a disabled record, a workaround comment. An operator who lived with
the defect has often put one there, and a criterion of the form "the line no
longer appears" then passes with or without the fix. The test copy runs with
that masking removed (for an asyn trace mask, delete the
`asynSetTraceMask(<port>, -1, 0)` line or set the mask to 1 so
`ASYN_TRACE_ERROR` prints), and the record names what was found and since
when it has been in place - because it also means the production log of
today is not evidence about the symptom.

Write the criteria into the record before the run, from the defect
description, in two halves:

- **The symptom is gone.** Name the exact observation: a log line that no
  longer appears over a stated number of cycles, a value that now reads
  correctly, a report that shows the corrected count.
- **Unchanged behavior is preserved.** Name the values or channels the fix
  must not touch, the PVs that carry them, and how they are read before the
  stop (the baseline) and after the test IOC starts.

Where the fix depends on a device-reported value, add the check that the
value is what the code assumed (the driver's report, or the vendor tool's
output), so a pass is attributable to the mechanism and not to coincidence.

### Teardown and proof of no change

Stop the test IOC. The owner or operator restarts the production IOC from the
installed tree and confirms it serves as before by reading the baseline PVs
again and comparing with the capture taken before the stop. Then prove the
installed tree is unchanged:

```bash
find <install-root>/<version> -type f \( -newer ~/scratchpad/<module>-fix/.started -o -cnewer ~/scratchpad/<module>-fix/.started \)
```

`.started` is the empty file created as the first step of the build above.
`-newer` compares modification time, which a timestamp-preserving copy
(`cp -p`, `rsync -a`) would carry over unchanged; `-cnewer` compares the
inode change time, which no copy tool preserves, so the pair catches both a
fresh write and a preserved-time copy. An empty result means nothing under
the install root was written during the run. Keep the result; it is the evidence for "the installed tree was not
touched" in the record.

The scratch tree stays until the owner decides otherwise; it is the build the
record refers to.

## Stage 4 - Upstream submission

The fork branch is the staging area for the upstream PR; it is never the
pin. Once Stage 3 has passed:

- Commit the change on the fork branch with a message that states the
  defect, the mechanism, and the upstream issue reference. A body is
  warranted here because the why (a vendor library reporting a count the
  device does not honor) is not visible in the diff.
- Push the branch to the fork and open the PR against the upstream default
  branch.
- The PR body states the root cause with the vendor evidence, the exact
  change, and the verification: the tree it was built against, the hardware
  it ran on (model, variant, option boards), and the observed result. A
  pending stage is written as pending, not omitted.

Commit, push, and PR creation are owner-run or owner-delegated actions; the
agent prepares the drafts in `work/<module>-fix/` and shows them first. That
directory is this repository's gitignored scratch, not the fork's: an
upstream module rarely ignores a `work/` directory, and a draft written
inside the fork would sit there as an untracked file. The commit therefore
takes the message by absolute path,
`git -C <fork-checkout> commit -F <EPICS-env-checkout>/work/<module>-fix/commit-msg-<slug>.txt -- <file>`.

Reply to whoever reported the defect once the PR exists, with the PR
reference and the verification status.

## Stage 5 - Adoption in this environment

Stage 3 proves the fix on hardware; Stage 5 decides how this environment
ships it. Two paths, chosen by the owner on the upstream state:

| Upstream state | Path | Procedure |
| :-- | :-- | :-- |
| The fix is merged and the pin can move to a commit that contains it without breaking consumers | Bump: move `SRC_TAG_<MODULE>` and `SRC_VER_<MODULE>` to that commit | `module-bump-procedure.md`; a module pinned by sha needs no upstream tag |
| The fix is not merged, or a bump is blocked by other changes on the upstream branch | Carry: a local patch on the pinned source | this section for the names and the wiring, then `upstream-fix-carry-procedure.md` for the patch mechanics only (its naming table is for upstream carries, not for this kind of patch) |

A carry of this kind is a **local build patch** in the sense of
`patch/README.md`: one file `patch/<module>-<slug>.p0.patch`, one named
`patch.<module>.<slug>.make` / `.apply` / `.revert` rule triple in
`configure/RULES_PATCH` - `.make` regenerates the file from the module
source with `git diff --no-prefix`, as every existing local patch rule does
(a module that already carries one patch gets a second, distinct rule name,
as opcua does) - and one row in the local build patches table with target,
purpose, and rule. The rule triple is not enough on
its own: `make patch` and `make patch.revert` are the aggregate targets
`patch:` and `patch.revert:` in `configure/RULES_SRC`, which name every
module rule explicitly, the revert list in reverse order. Append the new
apply rule to the `patch:` list and the new revert rule at the mirror
position of the `patch.revert:` list; a rule left out of those lists is
never run. Generate the file with `git diff --no-prefix` from the pinned
source, dry-run it against the pinned source in both directions, and run the
round trip (`make patch` then `make patch.revert` leaves the source tree
clean) - the round trip is also what proves the aggregate wiring.

When the upstream PR is later merged, the carry is retired by the bump that
moves the pin past it; the retirement is recorded in the bump's decision
record and the row leaves `patch/README.md` with its file.

Whichever path is chosen, the active work register gets one row for the
adoption with its done-when, and the execution record (below) gets the
decision and its reason.

## Stage 6 - Release and production update

The adopted fix ships with the next release of this environment through the
pipeline, and production moves to that release by its normal update. After
the update, run the Stage 3 success criteria once more on the production
IOC started from the installed tree - the same checks, now against the
shipped module - and record the result. Only then does the record's status
read complete, and only then may the Stage 3 scratch build be removed.

## Record discipline

A record is written for every run, and it is written this way, not freely.
The record is what lets another executor - or the same one at the hardware
site - repeat exactly what was done and see what changed.

### File name and metadata

Name the record for the run, with the date and time in the name so runs sort
and never overwrite:

```
docs/<module>-<topic>-<YYYYMMDD>-<HHMMSS>.md
```

Open the file with a metadata block (front matter) that fixes who ran it,
where, when, and against what - so the run is attributable and reproducible
without reading the body:

```
---
module:             <module>
topic:              <topic>
date:               <YYYY-MM-DD>
time:               <HH:MM:SS><tz>
host:               <hostname>
user:               <username>
production_version: <version> (<how selected: owner-named | latest-default>)
patched_source:     <fork>@<base-commit> + <fix slug>
version_diff:       <one line: what separates production from the patched source>
---
```

### Sections

| Section | Content |
| :-- | :-- |
| Status | one line: the current stage and whether it passed, is pending, or was skipped |
| Defect | the symptom, the upstream issue, the vendor behavior that causes it |
| Fix | fork, branch, base commit, changed files, what the change does, which code paths it leaves alone |
| Version difference | production pin vs the patched source, stated concretely: the pin commit, the patched base commit, the commits between them (and whether any touch the defect's code), and the fix diffstat - so the reader sees exactly what production lacks |
| No-hardware verification | what was proved on this host without the device: that the patched source compiles against the selected tree, links only to it, and (where a check exists) runs; each as pass/fail with the evidence file. Summarize what the ledger's build rows prove and name the ceiling of what this host can prove - do not re-list the ledger rows |
| Hardware hand-off | the exact steps and commands to repeat the verification where the hardware is: the tree to build against, the patch and its checksum, the scratch layout, the IOC instance and port, the success criteria and baseline. Written so the hardware site runs it without this session's context |
| Verification ledger | one row per stage: date, host and tree, hardware (model, variant, options, firmware), result, evidence file or output |
| Stage 3 plan | the success criteria written before the run, the PVs the baseline is read from, and the build layout on the production host (scratch module, consumer IOC copy, patch file and its checksum) |
| Timing decision | the owner's call from the Stage 3 table and its reason |
| Upstream | PR reference once opened; merge state |
| Adoption decision | carry or bump, the reason, the register row |
| Differences and next actions | a short log: what differed from expectation during the run (version mismatch, a masked symptom, a missing lab unit), and the concrete next action each one leaves - so the next executor starts from what this run learned, not from zero |
| Open items | what is still pending, including the reply to the reporter |

A stage that did not run is written as skipped with its reason. A stage that
ran against a tree other than the one it should have is written with the
tree it actually used. The ledger is a claim only when the row names the
evidence. No-hardware verification never stands in for the hardware run; it
records what could be proved without the device and hands the rest off.
