# Module Version Bump — General Procedure

How to decide whether a pinned module's tag moves to a newer upstream release,
and how to carry that move through the tree without breaking the modules that
build on it.

This document is written to be executed from itself. An agent arriving with no
memory of any previous execution should be able to work through it end to end.
Every mechanism needed to reproduce the assessment — commands, the census
method, the diff filter, the break test — is written here rather than
referenced from a scratch directory, because `work/` is gitignored in this
repository and does not survive.

Applies to any pinned module in the three-layer tree (EPICS-env,
EPICS-env-support, alsu-site-modules). The worked example throughout is asyn
`tags/R4-45` -> `tags/R4-46` (M34 / #61), chosen because asyn has the most
dependents of any module in the tree; a module with fewer consumers exercises
the same stages with a smaller census. This document is the general form; each
execution keeps its own decision record under `docs/` — the register form is
`docs/module-bumps-1.3.0.md` (M6 / #21), which holds the candidate table and
the per-module IN/HOLD outcome.

## Roles

| Role | Does | Does NOT |
| :-- | :-- | :-- |
| Owner | Decides IN/HOLD per candidate; signs the result; authorizes the `configure/RELEASE` edit | — |
| Agent | Surveys, builds the dependent census from module sources, diffs the changeset, judges the API/ABI break surface, presents the full finding | Edit the pin without explicit authority; treat a static pass as a release; read a module's minimum requirement as a fixed pin |

A clean changeset review is a **recommendation to build and verify**, not a
release. The static stages (1-4) can only clear or block; they never stand in
for the real build, link, and IOC-startup verification in Stage 6.

## Working layout

```
work/<module>-bump/            # scratch; gitignored, nothing here survives
  survey.txt                   # Stage 1: update-release.bash check output
  census.md                    # Stage 3: per-layer dependent list with link evidence
  header-diff.txt              # Stage 4: old..new diff filtered to library headers
docs/module-bumps-<ver>.md     # durable decision record; this is what survives
```

Anything that must outlive the session goes into `docs/`. Treat `work/` as a
desk, not a filing cabinet.

## Stage 1 — Survey the upstream state (read-only)

Establish the starting point without touching the tree.

```
tools/update-release.bash check
```

The `check` subcommand modifies no file. Its exit code is the completeness
signal:

- `0` — survey complete: every configured remote answered (up to date or update
  available).
- `1` — survey incomplete: a module was unreachable or carried no repository
  URL. Do not read a bump decision off an incomplete survey.
- `2` — survey complete but a module is indeterminate (reachable, no release
  tag).

**Pitfall — the survey compares against the latest tag, not a branch.** A
module whose upstream branch has advanced past its newest tag reports `OK`
here. Moving a pin to *branch* commits ahead of a tag is a different operation
(`docs/upstream-fix-carry-procedure.md`), not a version bump. Do not read a
Stage 1 `OK` as "nothing to carry".

## Stage 2 — Locate the pin

A module's version lives in exactly one authoritative place:

```
configure/RELEASE:  SRC_TAG_<MODULE>   (e.g. SRC_TAG_ASYN:=tags/R4-45)
                    SRC_VER_<MODULE>   (e.g. SRC_VER_ASYN:=4.45.0)
```

Confirm there is no second authority before editing:

```
grep -rn "<old-tag>\|<old-ver>" . | grep -v '\.git/'
```

Every other hit is documentation, a tooling example, or a generated build file
— a decision record, a release note, a version-conversion comment, or
`configure/MODULESGEN.mk`, which carries the version in an install path but is
gitignored and regenerated from `SRC_VER_`. None of them is the pin. Change
`SRC_TAG_` and `SRC_VER_` only.

## Stage 3 — Build the dependent census, from module sources

This is the heart of the assessment. Enumerate every module that consumes the
bumped module, across all three layers, and grade each consumer by how it
actually uses the module — not by what its `RELEASE` declares.

**Layer 1 — EPICS-env.** Build-order dependents are declared in
`configure/CONFIG_MODS_DEPS` as `build.<module>`:

```
grep -n "build.<module>" configure/CONFIG_MODS_DEPS
```

**Layer 2 — EPICS-env-support** and **Layer 3 — alsu-site-modules.** Each is a
sibling checkout of this repository and holds its module sources only after
`make init` is run inside it. Read those module sources, not the environment
config. The definitive evidence of a link-level dependency is a
`..._LIBS += <module>` line (with the matching `<module>.dbd`) in an App
Makefile; a runtime dependency is a device-support template or db install.

**Pitfall — a `RELEASE` declaration is not a link.** A module's
`configure/RELEASE` may declare `ASYN = $(MODULES)/asyn` and never link asyn.
Grade the consumer by `..._LIBS +=` / `.dbd` in its App Makefile, not by the
`RELEASE` line. In the asyn worked example, `bpmSup` and `unidrv` declare
`ASYN=` but link nothing.

**Pitfall — the sources are gitignored, so a search tool's defaults hide
them.** The `-src` trees `make init` fetches are gitignored. `rg` honors
`.gitignore` and returns nothing for them unless forced; a plain
`grep -r --include` was also observed to skip these trees silently in this
environment. Both
failures report a clean layer that is not clean. Run two searches that fail
differently and require the same result — ripgrep forced past the ignore rules,
and `find` + `grep`, which never consults `.gitignore`:

```
rg -n --no-ignore -g Makefile '[A-Za-z_]*LIB[sS][[:space:]]*\+=[[:space:]]*<module>' <layer>

find <layer> -name Makefile -not -path "*/.git/*" \
  -exec grep -HnE '[A-Za-z_]*LIB[sS][[:space:]]*\+=[[:space:]]*<module>' {} \;
```

A divergence between the two means the ignore rules or the traversal are hiding
files — investigate before trusting the census. Agreement validates traversal
only, not the pattern: both tools run the same regex and share its blind spot,
so keep the pattern wide enough for the project's Makefile conventions. The
`LIB[sS]` tail above matches `<ioc>_LIBS`, `Common_LIBs`, and `PROD_LIBS`
alike; the narrow `LIBS +=` form missed `eventGeneratorSup`'s
`Common_LIBs += asyn` and dropped a real consumer while both tools agreed on
the wrong count.

Worked example — asyn R4-45 dependent census:

| Layer | Repo | Link-level consumers | Notes |
| :-- | :-- | :-- | :-- |
| 1 | EPICS-env | 11: modbus, lua, std, StreamDevice, busy, scaler, mca, measComp, motor, motorMotorSim, pmac | 6 share the C17 bridge; motor/pmac are the deepest consumers |
| 2 | EPICS-env-support | 1 direct: ADCore (`ADApp/ADSrc`, `ntndArrayConverterSrc`) | ADSimDetector, ADGenICam, ADVimba build on ADCore (`build.ADCore`); an asyn bump reaches them transitively |
| 3 | alsu-site-modules | 3: feed, qpc, eventGeneratorSup | rgamv2 has a runtime db template only; bpmSup/unidrv declare but do not link; siteApps unrelated |

## Stage 4 — Diff the changeset and judge the break surface

`make init` fetches the pinned (old) tag. To see the new tag without changing
the pin, fetch it into the same checkout and diff. `<old-tag>` and `<new-tag>`
are the bare tag names (`R4-45`, `R4-46`), which git resolves with or without
the `tags/` prefix the pin stores:

```
cd <module>-src
git fetch --tags origin
git diff --stat <old-tag>..<new-tag>
```

Filter the diff to the library surface the census consumers link against —
public headers and interface/device-support source — and set docs, test apps,
and CI aside. The library lives in a module-specific subdirectory, not always
`src/`: asyn's is `asyn/`, an areaDetector module's is `<mod>App/`. Identify
that subdirectory and scope the diff to it, then list the changed headers:

```
git diff --stat <old-tag>..<new-tag> -- '<libdir>/**'
git diff --name-only <old-tag>..<new-tag> -- '<libdir>/**/*.h'
```

The break test on each changed header looks for **symbol removal or signature
change**, judged from the diff itself.

**Pitfall — a removal is not a break until you trace where the symbol went.** A
symbol deleted from one header may be relocated to another with its name and
value preserved. In the asyn worked example, `paramErrors.h` "removed" six
`#define`s (`asynParamNotFound` and siblings); the same diff moved them into the
`asynStatus` enum in `asynDriver.h` with identical names and identical numeric
values (`asynDisabled + 1..6`). No consumer breaks. Stopping at the removal
would have blocked a safe bump.

**Pitfall — a mid-struct insertion is ABI-sensitive only under mixed linking.**
Inserting a function pointer into the middle of a published struct
(`getAutoConnectTimeout` in `asynManager`) shifts later member offsets. In a
full-source rebuild — where the bumped module and every census consumer compile
against the same new headers — the layout is consistent and the change is safe.
It breaks only when a pre-built old consumer links against the new library,
which this from-source tree never does. Distinguish "full-source rebuild" from
"mixed link" before calling a struct change a break.

Additive changes at the end of an enum or string table (a new exception, a new
error code) are ABI-safe in a coherent rebuild.

## Stage 5 — Owner decision

Present every census consumer and the full break-surface finding. The owner
decides IN or HOLD and signs it. Record the decision — module, old -> new,
verdict, one-line reason — in the execution's decision record
(`docs/module-bumps-<ver>.md`). The static review recommends; the owner
decides.

## Stage 6 — Real-path verification

Only after an IN decision and explicit authority to edit the pin:

1. Edit `SRC_TAG_<MODULE>` and `SRC_VER_<MODULE>` in `configure/RELEASE`.
2. Build, link, and start a representative IOC on the release OS set. Every
   census consumer must relink and pass its startup checks; a successful source
   build alone is not completion.
3. Resolve any configuration question the bump reopens — for asyn, whether it
   can leave `MODS_C17_SRC_PATHS` (the Ubuntu 26 C17 bridge), decided from a
   real build with and without the bridge entry.
4. Watch the deepest consumers first. The motor/pmac pair is the known landmine
   at the bottom of the asyn stack: a motor change once removed
   `NUM_MOTOR_DRIVER_PARAMS` from `asynMotorController.h` while pmac still
   referenced it, failing every CI platform. areaDetector at Layer 2 warrants
   the same attention.

## Record discipline

The decision record under `docs/` is what survives; `work/` does not. Record the
candidate, the old and new tags, the census, the break-surface verdict with its
evidence, the owner decision with its reason, and the Stage 6 verification
result. A module examined and held unchanged is still a recorded outcome, so
the next execution does not repeat the survey and census from nothing.
