# EPICS-env Release Route

Where an EPICS-env release starts, who does each step, who must authorize it,
which document answers each question on the way, and which checks distinguish
situations that look alike.

This document is a map. It restates no procedure; each step names the kind of
document that owns it. When this map and an owning document disagree, the
owning document wins and this map is corrected.

The tracked procedures under `docs/procedures/` and the book under `docs/src/`
are public. The owner's release, milestone record, environment pipeline, git,
and cross-session procedures are maintained by the repository owner outside
this repository and are not published here. Their names and where they are
kept are in the Release Runbooks section of the canonical milestone record
`docs/milestone-<X.Y.Z>.md`. This document refers to them by what they do. A
reader without those procedures can follow steps 0 to 2 as far as the public
documents they name go (the Layer 3 census needs the private Layer 3
repository); steps 3 to 9 need the owner's procedures.

## Which version, which record

`<X.Y.Z>` is the version of the release line. Three states of the working
checkout are valid:

| State | Where the version comes from |
| :-- | :-- |
| The checked-out branch is `release-<X.Y.Z>` | The branch name; `make print-ENV_RELEASE_VERS` prints the same value |
| The release branch was just opened and `ENV_RELEASE_VERS` still shows the earlier version | The branch name; the record's version-change table names the correction |
| `master` after the release merge, during the checkpoint and closure commits | The record header, and the release tag once it exists |

In any other state, including `master` used for development between two
release lines, or when the printed value and the source named in the table
differ, stop and ask before reading any record. Remote branches of earlier
releases remain and are not the open line.

Lists in this document that can change between releases (the OS set, the
modules with example IOCs, the pitfalls) come from the 1.5.0 cycle, as of
October 2026. Check the authoritative source named beside each before relying
on one.

## The procedures that overlap

| Procedure | Question it answers | Not for |
| :-- | :-- | :-- |
| Release procedure | How is a release of a repository planned, executed, verified, and closed? | Building or installing the EPICS tree |
| Milestone record procedure | What work exists, what is accepted, what is verified, what is next? | How a module is judged or built |
| Module bump procedure (`docs/procedures/module-bump-procedure.md`) | Should one pinned module move, and what does it break? | Release-wide ordering |
| Upstream fix carry procedures (`docs/procedures/upstream-fix-carry-procedure.md`, `upstream-fix-verification-procedure.md`, `patch/README.md`) | Which upstream fixes does the tree carry as patches, and how are they verified? | Version moves of a module |
| Environment pipeline procedure | How is a released tag compiled into a verified installed tree on per-OS guests, and shipped? | Deciding what goes into the release |
| Git and GitHub delegation rules | Which commit, push, tag, issue, or release object may be created, on whose authority, and what may a commit message or issue body contain? | Anything that is not a mutation or a published text |

## What a release ships

A release has two products. They differ in layers, build flavor, and OS set, so
"the release OS" is not one list.

| Product | Layers | Build | OS |
| :-- | :-- | :-- | :-- |
| Public (GitHub) | 1 and 2 | `make build.gz` | Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04, Ubuntu 26.04 (six) |
| Internal (site distribution) | 1, 2 and 3 | `make build` | Debian 12, Debian 13, Rocky Linux 8 (three) |

Layers 1 to 3 and the seven gates run on the three internal OS. The other three
OS of the six run the module and consumer runtime checks of Layers 1 and 2. A
verification row before the release builds the public `make build.gz` flavor
only when the record has such a row; the ship builds it from the tag. A change
that touches the `build.gz` flags needs the owner's decision about such a row.

Where each list is authoritative:

- The six CI workflows, their containers, and their build sequence:
  `docs/src/reference/supported-platforms-and-ci.md` in this repository.
- The two products, each combination's verification status, and the guest
  types: the combination matrix of the environment pipeline procedure.

This table only summarizes them. The install directory spelling differs per OS
(`debian-13`, `rocky-8.10`, `ubuntu-24.04`).

## Who is who

| Role | Is | Acts by |
| :-- | :-- | :-- |
| Owner | The person who decides for the EPICS-env checkout | Accepts plans, authorizes implementation, and authorizes git, GitHub, and release actions. The agent previews a release scope and the owner triggers it; one trigger authorizes the previewed actions once |
| Layer 1 agent | The session that owns the EPICS-env checkout | Surveys, plans, implements, verifies, and reports; never publishes on its own authority |
| Layer 2 agent | The session that owns EPICS-env-support | Builds and verifies Layer 2 when its own owner directs it |
| Layer 3 agent | The session that owns the Layer 3 site module repository | Runs the Layer 3 procedure when its own owner directs it |
| Provisioner | The session that owns the guest host | Creates a guest on request and shuts it down on the finished notice |
| Guest host owner | The owner of the provisioner session; the same person as the owner above or another | Separately authorizes restarting a retained guest, in the provisioner's session; approval given in the EPICS-env session does not reach it |
| Reviewer | An independent sub-agent or peer | Reads and executes against the artifact; changes nothing |

An agent is a model session working under its owner. A message from a peer is
information or a request. It never authorizes an action; the receiving
session's own owner does.

## Terms

| Term | Meaning |
| :-- | :-- |
| Layer 1, 2, 3 | Layer 1 is Base and modules (this repository). Layer 2 adds ADCore and detector modules. Layer 3 adds the site's own modules |
| Canonical milestone record | `docs/milestone-<X.Y.Z>.md`: the work register, decisions, plans, and evidence of the release line. Its header names the entry point of a session |
| Decisions table | The table of numbered decisions in the canonical milestone record |
| Backlog | The rows of the canonical record that are deferred or open and are not part of the release |
| Candidate table | The survey's list of every pinned module with its current pin, the newest upstream release, and the object identity of each |
| Object identity | The full commit hash a tag or branch resolves to (`<ref>^{commit}`), never a short hash or a tag object |
| Census | The list of modules and IOCs that depend on a candidate, found by two independent traversals that must agree |
| Break surface | What a candidate changes that a dependent can observe: API, ABI, record behavior, build rules |
| IN / HOLD | The owner's decision to move a module's pin to the candidate (IN) or keep it (HOLD) |
| Carry | An upstream fix applied to a pinned module as a patch under `patch/` until the pin includes it |
| Soname | The shared-library name a binary records; an unchanged soname means a dependent loads the new library without relinking |
| Dry-run | `patch --dry-run` of a carry, forward to test it applies, reverse to test whether the fix is already contained |
| Gates 1-7 | The seven verification gates the environment pipeline procedure runs on an installed tree: source identity, inventory count, dead symlinks, pairing, runtime scenario, binary link check, module artifact spot check |
| `check_deps` | `tools/check_deps.bash`, Gate 6: reads with `readelf` the executables and shared libraries of an installed tree and fails on an absolute RPATH or RUNPATH outside the system library directories, or on a tree library that needs another without `$ORIGIN`. Whether each library is found is checked separately by an `ldd` smoke |
| Consumer check | Cloning and building every active consumer IOC of the site against the installed tree and scanning the build for errors |
| Release Verification row | One numbered verification line in the final release plan of the canonical milestone record; each has its own pass condition and a partial or excluded result is not a Pass |
| Integrated Verification rows | The rows of the final release plan that record the combined behavior of the changed modules; updated after each shared-surface change |
| Ready | The work table's column that says whether a unit can start: Yes when its dependencies are Complete |
| Complete / Blocked / Pending / Pass | Status words of the milestone record: a work unit is Complete with its evidence, Blocked on an open external gate; a result that has not run is Pending; a Release Verification row is Pass only when its condition ran to the end |
| Version-change table | The table in the final release plan that lists each version field, its value before, and its value after |
| Version-only commit | A commit that contains only the version file change |
| ChangeLog commit | The commit that adds the release's section to `ChangeLog.md` |
| Planning commit | A commit that carries accepted plans in the canonical record before implementation of those plans starts |
| Evidence commits | The pre-change evidence commit, an interim post-change evidence commit that preserves results before the candidate, and the readiness-evidence commit; the last is the release candidate |
| Checkpoint commit | The commit that records an executed release action in the canonical record before the next dependent action |
| Source-first preparation commit | The commit that records closure evidence and issue intent in the canonical record before any issue is changed |
| Tracker, projection | The GitHub issue and milestone objects that mirror the milestone record, and the act of aligning them; the record is authoritative |
| `Closes #N` footer | The footer of a commit message that closes issue N when the commit reaches the default branch |
| Delegation trigger | A phrase the owner types that authorizes one class of git or GitHub action. Without it the agent prepares the text and the exact command, and the owner runs it |
| Release scope | The delegation scope that runs the release-sequence commands the owner previewed (merge, annotated tag, GitHub release, milestone close), once per trigger; it does not cover a push or a commit |
| Issue scope | The delegation scope that creates, edits, comments on, closes, or reopens issues, including an issue's milestone assignment; it excludes changes to the milestone object |
| Release selector | The tag or branch of Layer 2 or Layer 3 that a run builds; derived from the release line, never from a default |
| Urgent patch mode | A Layer 3 mode that patches an already installed tree instead of building a release |
| Controller | The host from which a run drives the guests |
| Accepted key | The Git key the site repository accepts, loaded in a live SSH agent on the controller; the Layer 3 run cannot clone without it |
| Capacity check, storage preflight | Checks of host resources before creating a guest, and of free space before creating a clone or tree |
| Single writer | The one session that owns a repository or file and is the only one that edits it; others send it a request |
| Finished notice | The message that tells the provisioner a guest is no longer needed so it can shut it down |
| Fresh guest / retained guest | A newly created guest; a guest shut down with its disk and evidence kept |
| Ship | Building the release tags on fresh guests and committing the verified trees to the distribution repositories; it is not part of the release procedure |

## Route from first question to closed release

Read each row from the left: when the step starts, who does it, who must
authorize it, what to read, and what it leaves behind.

| Step | When it starts | Who does it | Who authorizes | Read | Output |
| :-- | :-- | :-- | :-- | :-- | :-- |
| 0. Locate | Every session start and every resume | Layer 1 agent | Nobody (reads state; `git fetch` only updates remote-tracking refs) | `git fetch` and `git status`; the state table above; then the canonical milestone record header | Branch state, canonical path, entry point |
| 1. Survey | A release line opens, or upstream moved since the last survey | Layer 1 agent; Layer 2 and 3 agents answer census questions | Nobody (read only) | Module bump procedure, survey and census parts; `tools/update-release.bash check` | Candidate table, census with both traversals agreeing |
| 2. Decide | The survey is complete | Layer 1 agent presents the break-surface finding; owner decides | Owner | Module bump procedure, break-surface and decision parts | IN or HOLD per candidate with the object identity. The module bump procedure names `docs/module-bumps-<ver>.md` as the record; a release line may keep the decisions in the Decisions table of its canonical milestone record, where the record shows them |
| 3. Plan | Candidates are decided | Layer 1 agent drafts; owner accepts | Owner accepts each plan, separately authorizes the planning commit and any tracker changes, and separately authorizes implementation of each plan | The release procedure's planning, planning-commit, and tracker-projection parts; the milestone record procedure's plan review | Accepted module plans, a committed ordered work table, and the final release plan. The release procedure expects the final plan accepted before its execution phases, and step 5 does not start without it |
| 4. Implement one module | Its own plan is accepted and committed, its dependencies are Complete (`Ready` is Yes), and its implementation is separately authorized | Layer 1 agent | Owner for every commit and push | The milestone record procedure's implement-and-close part; module bump procedure, real-path verification part; carry procedures for patches | Pin edit, local test results, evidence, Integrated Verification rows updated after each shared-surface change |
| 5. Verify the code and the internal OS | Every work unit and gate listed in the final release milestone's dependencies is Complete (rows outside them, such as Backlog rows, do not count; a Blocked item does not), the final release plan is accepted, and its implementation is separately authorized | Layer 1 agent coordinates. On each internal OS's guest the run builds Layers 1 and 2 and then Layer 3, the Layer 2 and Layer 3 agents acting when their own owners direct them | Owner accepts the guest resource plan and authorizes the interim post-change evidence commit. Each push of the code tip has its own push authority. The version-only commit belongs to the opening of the release line: this step checks the recorded commit, and authorizes a new one only when the version-change table names a change not yet made. The provisioner acts on each guest request; restarting a guest already shut down needs the guest host owner's separate authorization | The release procedure's readiness part; the environment pipeline procedure's install-and-verify part, its verification gates, and its Layer 3 part; the Layer 2 and Layer 3 section below | First, on the combined candidate tree, the code and CI parts of the combined build and installation row, as the row lists them (workflow builds, dependency audits, patch round trip, fixtures, comparisons, example checks). Then, on the same tree, per internal OS on the same guest: Gates 1-7, `check_deps`, the consumer check, and the module and consumer runtime checks assigned to that row, each recorded. A code defect found late restarts this step. The code tip is on the remote before a guest clones it, and nothing is pushed between a build and its gates |
| 6. Verify the rest and seal the candidate | The code, CI, and internal OS parts of step 5 are recorded as Pass (the row stays Pending until all its parts are recorded) | Layer 1 agent, on guests the provisioner creates one at a time | Owner authorizes the ChangeLog commit, the readiness-evidence commit, and access to the actual devices the record names for its device row; each push has its own push authority; the provisioner acts on each guest request | The release procedure's readiness part; the environment pipeline procedure's install-and-verify part; the record's Release Verification rows | The rows assigned before the release, each Pass: the module and consumer runtime checks on the OS outside the internal three, the remaining parts of the combined build and installation row (installed roots, generated version evidence, configured consumer IOC startup), and the loader, fragment, and recovery suites with any actual-device checks. Then, in this order: the ChangeLog commit; the release-note draft from the comparison and the ChangeLog section; the documentation and release-note row; last, the readiness-evidence commit, which is the release candidate. The release procedure has no ChangeLog step; the owner sets its place, which is before the candidate. Before sealing, the candidate's history carries every `Closes #N` footer the record assigns, and after `git fetch`, `git rev-list --count release-<X.Y.Z>..master` and the same count against `origin/master` print 0 |
| 7. Cut the release | Every Release Verification row before release is Pass, and the readiness-evidence commit is the last commit of the release branch | Layer 1 agent previews; owner or delegated scope executes | Owner, per action, in the record's order: push of the release branch, merge, tag, push of master, push of the tag (after master is on the remote), GitHub release, and the issue and milestone reconciliation. A previewed release scope covers merge, tag, GitHub release, and milestone close once per trigger; each push has its own push authority; each checkpoint commit has its own commit authority | The release procedure's execution part; the git delegation rules' release sequence | Each action targets the recorded candidate or merge object, never a branch tip: the merge command names the candidate's full commit hash and the tag names the merge. Every checkpoint commit is made on master after the merge, and the first one records the release-branch push. The push carries every `Closes #N` footer the record assigns to it |
| 8. Ship | The owner orders a ship, the release tag exists, and Layer 2 and Layer 3 have the tags the ship requires (requested from those sessions) | Layer 1 agent runs the ship procedure on fresh guests | Owner: each per-OS tree commit, the merge, the tag, and each branch push and tag push of each distribution repository have their own git delegation authority. The provisioner acts on each guest request | The environment pipeline procedure's distribution part | Verified trees committed per OS |
| 9. Close | The release objects of step 7 exist. A ship is not required for the close | Layer 1 agent verifies on clean production-equivalent hosts | Owner for the source-first preparation commit, for issue closure, and for the closure commit | The release procedure's verification and close parts | Post-release rows, closure commit, next-line entry |

Steps 1-4 repeat per module. Steps 5, 6 and 9 verify the actual installed tree;
a plan, a build, or an issue state is not their result. Nothing in steps 7 and
8 runs as a side effect of an earlier step.

## Repositories and who writes them

| Repository | Role | Single writer |
| :-- | :-- | :-- |
| EPICS-env | Layer 1: Base and modules, patches, tools, this documentation | The session that owns this checkout |
| EPICS-env-support | Layer 2: ADCore and detector modules | The session that owns that repository |
| Layer 3 site module repository | Layer 3: site modules (private) | The session that owns that repository |
| Guest provisioner repository | Creates and shuts down guests | Its own session; a guest is requested by message and closed by a finished notice |
| Build automation repository | Build automation for layers 1-2 | Its own session |
| Distribution repositories (public gz, internal) | Shipped trees | Filled by a ship run |
| Consumer IOC repository of the site | Consumer IOCs for the Layer 3 consumer check | Read only; always its current `master`, full commit recorded |

A request to another session is information exchange or a delegated change.
The first needs no approval; the second needs your own owner's authorization
before it is acted on, whoever asks.

## Which document answers which question

| Question | Authoritative source | Do not take it from |
| :-- | :-- | :-- |
| What is the plan, what is accepted, what is verified for this release? | `docs/milestone-<X.Y.Z>.md` | A handoff file or an issue body |
| How is a release of this repository executed? | The release procedure | A decision row written for one cycle |
| Which OS and layer combinations ship? | `docs/src/reference/supported-platforms-and-ci.md` and the pipeline procedure's combination matrix | A peer repository's copy of the list |
| What does a gate check? | The pipeline procedure's verification gates | A summary in a milestone row |
| What does Layer 3 require? | The pipeline procedure's Layer 3 part | A retained authoring record in the Layer 3 repository |
| How are patches wired and added? | `patch/README.md`, the pipeline procedure's patch part, `configure/RULES_PATCH` | The patch file names alone |
| What did an earlier cycle decide and why not? | `docs/CLOSED_DOORS.md`, `docs/archive/` | Memory of the earlier cycle |

Handoff and plan files under `work/` are private, untracked, and carry the
state of one session. They go stale when a decision changes. Treat them as
leads, never as the current rule.

### Known divergences

- Layer 2 and Layer 3 have no line for a release until their owners open one.
  The pipeline procedure derives the release selector from the release line;
  it is never taken from a role default. Until a layer's line is open, its
  Release Verification rows stay Pending and Layer 1 work continues.
- A verification plan may set a stricter guest limit than the environment
  pipeline procedure's general limit of two running builds at once, with guests
  created one at a time. The plan's limit applies while it is in force.

## Layer 2 and Layer 3 hand-off

What each layer needs from Layer 1 before it can start, and what it reports:

| Layer | Needs from Layer 1 | Reports back |
| :-- | :-- | :-- |
| Layer 2 | A candidate Layer 1 tree per OS with the new pvxs and asyn installed; whether it is writable; which OS legs | Build exit of ADCore and detectors, `ldd` and `readelf` showing `libpvxs` and `libasyn` resolved into the candidate tree, `check_deps` |
| Layer 3 | The release selector (tag or branch), the exact `setEpicsEnv.bash` path per OS, the target hosts, the EPICS-env commit that carries `tools/check_deps.bash`, a live agent with an accepted key | Full-commit identity of every module tag, Gates 2-7, the real clone and build of every active consumer IOC |

A release line on the Layer 2 or Layer 3 repository is opened by that layer's
own session on its owner's direction. Once the owner has decided to open one,
the Layer 1 agent asks for it by message; it never writes to either repository.
The same holds for the tags those layers need before a ship.

A Layer 1 module that a higher layer actually consumes is found by reading the
templates and the common makefiles, not only files named `Makefile`; a module
can look unconsumed until a template or a common makefile is read.

## Verification pitfalls

The right column is the check that distinguishes the situation. A row applies
when its situation holds; it is not a rule for every module.

| Situation | What it looks like | Check |
| :-- | :-- | :-- |
| An object named by a short hash or a tag | An annotated tag object differs from its commit | `git rev-parse <ref>^{commit}`; record the full hash |
| Diff size of a candidate with large files | The GitHub compare API can report far fewer lines than the real diff | `git diff --shortstat <old> <new>` on a clone |
| A module's `conf.<module>` recipe | A build fails with "No rule to make target '../RELEASE.linux-x86_64.Common'" or a missing include | Read the whole recipe. Some remove files or symlinks, replace `configure/RULES_BUILD`, or edit `tests/Makefile` |
| An installed module's own `RELEASE` | "Definition of SUPPORT conflicts with ... support" from `checkRelease` | Build with `CHECK_RELEASE=NO`; this is the build setting the recipes use, not a deviation. Read the module's recipe in `configure/RULES_MODS_CONFIG`: the shared recipe writes it to the top-level `CONFIG_SITE.local`, some module recipes write it to `configure/CONFIG_SITE.local` or `configure/CONFIG_SITE`, and some delete it from `configure/Makefile`. A module whose recipe writes none needs the setting added to its recipe, because a value placed by hand in `configure/CONFIG_SITE.local` is lost when the recipe rewrites that file |
| `INSTALL_LOCATION` set away from the module's top | An in-tree example IOC can fail at link with undefined references because `<MODULE>_IOC_LIBS` is empty | If the example's `RELEASE` sets `<MODULE>=$(TOP)/../..`, point it to the installed tree in `RELEASE.local` |
| A build that failed earlier in the same directory | A later build succeeds, but a record type is missing at run time | The generated `.dbd` may be stale; clean rebuild of that directory |
| An example IOC that only builds with `BUILD_IOCS=YES` | Nothing to run | Enable it only in an isolated verification configuration; remove the option and the products afterwards. Find the modules with such IOCs by reading each module's `configure/CONFIG_SITE` and `Makefile`, not from a list; the normal build keeps `NO` and pmac is forced `NO` by its recipe |
| "The IOC started" | `iocRun: All initialization complete` printed although registration failed | Count `not registered`, `registerRecordDeviceDriver failed`, `support for ... not found`, `driver ... not found`; require zero |
| A fix in private record state | Exposed fields are identical before and after the fix | Read the private state with a probe that uses the shipped struct layout, on both the old and the new object |
| A fix that crashes the old code | Old and new both look fine on the happy path | Run the crashing input on both; the old IOC exits with the signal, the new one stays alive |
| A patch release of a shared library | The soname can be unchanged (a library whose `SHRLIB_VERSION` is major.minor, as in pvxs, keeps its soname across patch releases) | Read the soname of the new build; if unchanged, a stale install still loads without relinking, and the resolved real path into the candidate tree is the evidence |
| A carried patch at a newer pin | Forward dry-run fails | A passing reverse dry-run means the fix is already contained; check before retiring or keeping |
| A stacked carry set | A single carry fails its forward dry-run on a pristine tree | It may depend on earlier carries; test in the shipped apply order |
| A long upstream test | A test that waits for log lines looks hung under a short tool time limit | Run it directly with a longer limit and read its log |
| An ADCore-based detector example IOC | Cannot load its camera template | The example needs `busy` linked, `WITH_PVXS=YES` in the IOC's `configure/CONFIG_SITE.local`, the `ADApp` to `cfg` substitution in the IOC makefile, and `NDPvxsConfigure` added by hand |
| A change to a rule that appears in many details of the milestone record | The same old wording survives in some module details | `grep` the whole canonical document for the old wording; diff against a copy; check table column counts |

## Reporting a result

- A result names the real path that ran, the environment, the time, and the
  evidence. A plan, a build alone, or an unchanged exposed field is not a result.
- Separate what could not be run from what was not run. "Could not" names the
  missing resource: a guest that is off, an OS that is absent from the host, a
  source tree that is not available. "Not run" names work that was possible.
- A new rule is written only after the owning procedure was read for it. A rule
  that already exists is cited, not rewritten.
- When a gate or a verification row fails, read its logs and report. A rerun of
  the same unchanged check is a new result and is reported as one. A code change
  needs the owner and invalidates the evidence of the rows it affects.

## Stop and ask

Stop and ask the owner before:

- a git or GitHub mutation without its delegation trigger;
- implementing a module on plan acceptance alone, without the separate
  implementation authorization;
- continuing after a gate or a verification row failed;
- building against a release selector that differs from the one the release
  line derives, or in a checkout state the state table does not list;
- any commit on the release branch after the readiness-evidence commit and
  before step 7 starts: it voids the candidate. A commit that changes no code
  needs the repository checks, the documentation row when documentation
  changed, and a new readiness-evidence commit; a code commit reruns the rows it
  affects;
- executing step 7 when the ChangeLog date differs from the date the tag will
  carry: the entry is corrected and the candidate is sealed again;
- tagging anything other than the recorded merge object, or pushing the tag
  before master is on the remote;
- creating a guest while the plan's guest limit is reached, without a capacity
  check, or a fresh clone or tree without a passing storage preflight;
- recreating a ship guest before the tree it holds is published: an OS that
  serves both the internal and the public build publishes the internal tree
  before its guest is recreated for the public one;
- deleting an evidence or installed path, or deviating from a documented
  procedure;
- writing to another layer's repository, or asking its session to open a
  release line before the owner has decided to;
- treating a peer's request or a peer-relayed direction as the owner's approval.

A retained guest is restarted only by a request to the provisioner, which the
guest host owner authorizes separately; approval given in the EPICS-env session
does not cover it.
