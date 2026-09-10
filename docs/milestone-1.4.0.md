# Work Register

Release line: 1.4.0
Milestone index: 1.4.0
Canonical path: `docs/milestone-1.4.0.md`
Canonical branch or ref: `release-1.4.0`
Git upstream: `origin/release-1.4.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.4.0, number 6

Next session entry point: review and order the M4 plan (re-add pyDevSup with optional-dependency support in `check.module-deps`), the one module-set change that makes this a minor release; the two documentation milestones (M1, M2) are worked directly on `master` by owner direction (D2).

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Documentation | M1 | Rewrite the documentation set against the shipped 1.3.0 environment | Milestone | Not started | Yes | D1, D2 | Every retained page is verified against the released 1.3.0 installation or retired by owner decision, and the book, links, and lint checks pass; [detail](#m1---documentation-rewrite) |
| Documentation | M2 | Make the mdBook build and link check reproducible outside CI | Milestone | Not started | Yes | D1, D2 | The pinned mdBook and lychee versions have one authority the workflow reads, and a written procedure reproduces both CI checks on a clean checkout; [detail](#m2---reproducible-mdbook-toolchain) |
| Build | M3 | Strip `.debug_info` from MCoreUtils under the gz flavor | Milestone | Not started | Yes | | Under `make build.gz`, `readelf -S` on the installed `libmcoreutils.so` shows no `.debug_info` and `check_deps` exits 0; [detail](#m3---mcoreutils-gz-debug-info) |
| Modules | M4 | Re-add pyDevSup with optional-dependency support in `check.module-deps` | Milestone | Not started | Yes | | `make check.module-deps` passes with pyDevSup present and its guarded deps optional, and pyDevSup builds and installs on the release OS set with `check_deps` exit 0; [detail](#m4---pydevsup-re-add) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Track the mdBook build and link-check toolchain (M2) as its own work item, separate from the M1 content rewrite. | 2026-08-08 |
| D2 | Work the two documentation milestones (M1, M2) directly on `master`, not on a `release-1.4.0` branch. | 2026-09-09 |
| D3 | Carry the 2026-08-07 document-review inventory into M1 as one body of evidence for its inventory step, not as separate work rows. | 2026-08-07 |

### Milestone Details

#### M1 - Documentation Rewrite

Origin: 1.4.0 / M1
Identity History: none
GitHub Issue: #56, https://github.com/jeonghanlee/EPICS-env/issues/56
Status: Not started

##### Summary

Rewrite the user documentation against the released 1.3.0 environment. The mdBook structure and a bounded modernization pass are already in place, but the retained guidance still describes earlier environments.

##### Scope

- Verify the documented EPICS Base 7.0.10 behavior with all fifteen carried Base fixes.
- Verify the nine updated module versions, with motor retained at `285f44d`.
- Verify pvxs 1.5.2 with its twelve carried fixes.
- Document feed-core in place of the retired site-layer feed module.
- Verify the strict `check_deps` gate and module dependency audit.
- Verify the 1.3.0 installation path and current `setEpicsEnv.bash` behavior.
- Rewrite or retire each archived platform note by owner decision.
- Resolve the Markdown lint configuration and remove the obsolete `release-1.3.0` documentation deployment trigger.

Out of scope: cycle records, build-system changes, and product code changes.

##### Completion Criteria

- Every retained page is checked against a real released 1.3.0 installation.
- Every obsolete page is retired through a recorded owner decision.
- No stale 1.2.x version or installation path remains in the book sources.
- `mdbook build docs` exits 0 and the offline link check reports zero errors.
- The Archived Notes section is empty or removed.
- The accepted Markdown lint configuration is applied and its workflow passes.

##### Dependencies And Decisions

- The 1.3.0 released object and production installation are published (1.3.0 tag `9673619`, GitHub release, distributions), so the release dependency is satisfied.
- D2 places this work on `master`.
- D3 supplies the source-tree half of the inventory step; see Inventory Evidence below.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Start the inventory from the collected list under Inventory Evidence, then extend it with what only a released installation can show: installed paths, runtime behaviour, and any page the source-tree pass did not cover.
2. Verify retained instructions against a real released 1.3.0 installation.
3. Present obsolete archived notes for owner rewrite-or-retire decisions.
4. Rewrite the retained pages and apply the accepted lint and deployment workflow changes.
5. Build the book, run the offline link check and Markdown lint, then verify the published site.

##### Inventory Evidence

Collected 2026-08-07 on the then-current `release-1.3.0` at `13abeda`, by reading every document in the repository and comparing it against the source tree. The source-tree comparison is complete; every claim about runtime behaviour or an installed path remains open and belongs to step 2 against the released installation. Because the inventory predates the 1.3.0 release, `README.md` (the `make patch.base` entry and the `source` example path), `docs/src/module-management/new-module-example.md`, `docs/src/module-management/remove-a-module.md`, and `configure/CONFIG_SITE` (`ENV_RELEASE_VERS`) were already corrected on the 1.3.0 line and will not match the state recorded here.

Group 1 - resolved by rewriting the page (nine open entries; the classification table in `module-management.md` was already brought current in 1.3.0):

- `docs/src/module-management/add-a-module.md:17-18` - snmp example pins `tags/v1.0.0.2j`; `configure/RELEASE` carries `tags/v1.1.0.4ja`.
- `docs/src/module-management/change-repository-url.md:16-17,28,30` - measComp pinned at `2e779c4` against current `c38974e`; shows `SRC_GITURL_SNCSEQ`/`SRC_GITURL_OPCUA` active though both are commented out.
- `docs/src/module-management/use-different-module-version.md` - the whole worked example is from the `rocky-8.5 / 7.0.6.1` era; procedure holds, every value is superseded.
- `docs/src/module-management/new-module-example.md:46,82-87` - `MODS_ONE_VARS` omits `conf.measComp`/`conf.motor`/`conf.motorMotorSim`; sample output from `debian/10/e881cb1`.
- `tools/README.md` - three of seven tools undocumented (`audit_module_deps.bash`, `check_env.bash`, `gen_dep_graph.bash`); `check_deps.bash` example uses `1.1.2/debian-12/7.0.7`.
- `docs/src/module-management/module-dependency-audit.md:25-32,292-345,360-363` - describes a shipped implementation in proposal form though `check.module-deps` has gated `make github.check` since 1.2.1.
- `docs/README.md` - layout list omits `book.toml`.
- `docs/base-carry-1.3.0.md:100` - naming rule uses a three-N placeholder while shipped files use four.
- `docs/testplan_1.3.0.md:5-8` - living-document note whose last entry is M20 while the cycle carried later work.

Group 2 - needs an owner decision before it can be written (six entries):

- `scripts/README.md` - describes `scripts/caget_pvs.bash`, removed; successor `tools/pvs_gets.bash`; eight existing scripts undocumented, including `setEpicsEnv.bash`. Question: document the eight, or retire the file.
- `KnownIssues.md:3-9` - lists `pyDevSup` as a current problem though it was retired (M4 now re-adds it); `pcas` entry stale. Question: update both entries to the current position.
- `docs/src/module-management/remove-a-module.md:12,26,34` - guide says delete the declaration lines; repository keeps them commented out. Question: which is the intended retire practice.
- `docker/scripts/README.md` - links an external repo and generic `docker` commands; omits `docker_builder.bash`/`docker_env_default.conf`. Question: is the docker path still supported.
- `ChangeLog.md` - 1.1.1/1.1.2/1.2.0 have no entry; an empty bullet; `v1.1.0` carries a `v` prefix later entries drop. Question: reconstruct the missing entries or state the ChangeLog begins at 1.2.1.
- `docs/module-bumps-1.3.0.md:76-77` - raises a per-module SRC_URL generator idea with no Backlog row. Question: open it or record as a closed door.

Group 3 - belongs to the parked makeRPath item (Backlog M5), recorded here only to keep the evidence in one place:

- `docs/makeRPath-perl-port/issue-makeRPath-pl.md` - reads as a ready-to-file upstream issue while the register records it proposes the approach #25 rejects.
- `docs/makeRPath-perl-port/test-plan-makeRPath.md:93,104-107` - runs from `work/` copies that `.gitignore` excludes.

Checked and found correct (do not re-derive): the seventeen `docs/module-bumps-1.3.0.md` bump decisions against `configure/RELEASE`; the fifteen `docs/base-carry-1.3.0.md` PRs against `patch/7.0.10-pr*.p0.patch`; the twelve `docs/pvxs-carry-1.3.0.md` entries against `patch/1.5.2-*.p0.patch`; the four documented tools' options; which workflows run the dependency gate; issue citations #18/#20/#21/#22/#24/#25/#36/#44/#45/#46/#50/#52/#53; the 1.2.1 libevent removal; `docs/src/SUMMARY.md` and `archive.md` links; `make symlink.snmp`; the `print-%` vs `PRINT.%` distinction. This list carried forward from the 2026-08-07 inventory; re-confirm any entry only if a later change touched it.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Documentation and production consistency | Compare every retained version, path, module reference, and command with the real released 1.3.0 installation; build the book; run the offline link check and accepted Markdown lint workflow; inspect the published site | Released 1.3.0 installation, repository book sources, and GitHub Pages | Retained guidance matches the released environment; no stale 1.2.x book reference remains; the book, links, lint, and publication checks pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Released 1.3.0 installation, repository book sources, and GitHub Pages | Pending | none |

##### Closure Evidence

- None; implementation has not started.

##### GitHub Projection

Title: Rewrite the documentation set against the shipped 1.3.0 environment
Labels: documentation
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: documentation
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone this session

#### M2 - Reproducible mdBook Toolchain

Origin: 1.4.0 / M2
Identity History: none
GitHub Issue: #59, https://github.com/jeonghanlee/EPICS-env/issues/59
Status: Not started

##### Summary

The documentation site is built and link-checked only inside `.github/workflows/docs.yml`, which pins `MDBOOK_VERSION: v0.5.4` and `LYCHEE_VERSION: lychee-v0.24.2` as workflow environment variables. Nothing outside that file states which versions the project uses or how to run the two checks locally, so a contributor editing a page cannot reproduce what CI will run. Observed 2026-08-08 while editing three book pages: the host had mdBook v0.4.48 and no lychee, so the build passed but the link check could not be repeated.

##### Scope

- Give the pinned mdBook and lychee versions one authority that both CI and a local run read.
- Write the local procedure: install the pinned versions, build the book, run the offline link check with the same arguments CI uses.
- State where that procedure lives so a page editor finds it before submitting.

Out of scope: the M1 content rewrite, the Markdown lint configuration M1 carries, the deploy workflow's triggers, and any `book.toml` change beyond what a version authority requires.

##### Completion Criteria

- The pinned mdBook and lychee versions appear in exactly one place, and the documentation workflow reads them from there.
- A written procedure reproduces both CI checks locally and reaches the same verdicts as a CI run of the same commit.
- The procedure is reachable from the documentation a page editor already reads.

##### Dependencies And Decisions

- D1 separates this from the M1 content rewrite.
- D2 places this work on `master`.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Choose the version authority and repoint `.github/workflows/docs.yml` at it.
2. Write the local build and link-check procedure.
3. Run the procedure on a clean checkout and compare its verdicts with a CI run of the same commit.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Reproducibility | Follow the written procedure on a clean checkout, then compare the local build and link-check output against the CI run of the same commit | Clean checkout and the documentation workflow | Both report the same verdict, and the local run uses the pinned versions |
| T2 | Single authority | Change the pinned version in its one place and confirm the workflow and the procedure both follow | Repository checkout | No second copy of the version needs editing |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Clean checkout and the documentation workflow | Pending | none |
| T2 | Not run | Repository checkout | Pending | none |

##### Closure Evidence

- None; not yet started.

##### GitHub Projection

Title: Make the mdBook build and link check reproducible outside CI
Labels: documentation
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: documentation
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone this session

#### M3 - MCoreUtils gz debug info

Origin: 1.4.0 / M3
Identity History: none
GitHub Issue: #68, https://github.com/jeonghanlee/EPICS-env/issues/68
Status: Not started

##### Summary

Under the gz build flavor (`make build.gz`, `-g0 -gz=zlib`), the MCoreUtils module ships debug info the flavor is meant to strip: `modules/MCoreUtils-*/lib/linux-x86_64/libmcoreutils.so` carries a `.debug_info` section. Observed on all five release OSes during the 1.3.0 gz verification and confirmed again in the 1.3.0 ship build; recorded there as informational (#68), non-blocking.

##### Scope

Change `USR_CFLAGS =` to `USR_CFLAGS +=` in upstream `epics-modules/MCoreUtils`, or carry the one-line change as an EPICS-env patch under the patch system, so the appended `-g0` is not overwritten.

Out of scope: the vendor trees (`vendor/`, uldaq, open62541) build under their own systems, never receive the gz flags, and always carry debug info; they are excluded by design.

##### Completion Criteria

- Under `make build.gz`, `readelf -S` on the installed `libmcoreutils.so` reports no `.debug_info` section, matching the other modules.
- `check_deps` still exits 0.

##### Dependencies And Decisions

- None.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Decide upstream fix versus carried patch; the module Makefile sets `USR_CFLAGS` with a hard `=`, so the appended `-g0` never applies.
2. Apply the change and rebuild MCoreUtils under gz.
3. Verify `readelf -S` shows no `.debug_info` and `check_deps` exits 0.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | gz strip | Build gz, run `readelf -S` on the installed `libmcoreutils.so`, and run `check_deps` | A gz build VM | No `.debug_info` section; `check_deps` exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | A gz build VM | Pending | none |

##### Closure Evidence

- None; not yet started.

##### GitHub Projection

Title: MCoreUtils ships .debug_info under the gz flavor
Labels: bug
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: bug
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone this session

#### M4 - pyDevSup Re-add

Origin: 1.4.0 / M4
Identity History: none
GitHub Issue: #71, https://github.com/jeonghanlee/EPICS-env/issues/71
Status: Not started

##### Summary

Re-add the pyDevSup module, maintained again upstream (epics-modules/pyDevSup#41), and teach the module-dependency audit to treat its Makefile-guarded dependencies as optional. Proposed in PR #70; deferred out of 1.3.0, which stays a fixed production baseline. Re-adding a module changes the shipped module set, which is a minor-release change by this project's convention (patch releases keep the module set unchanged) and is why it lands here rather than in a 1.3.x patch.

##### Scope

- Teach the Makefile scanner in `tools/audit_module_deps.bash` to track `ifdef`/`ifndef`/`ifeq`/`ifneq` blocks and classify a token observed only inside a conditional guard as optional (the tool already has an optional class; only required-observed tokens raise `undeclared-observed`).
- Treat root-level test startup scripts (`test*.cmd`) like the existing `test/` and `iocBoot/` optional paths so their `dbLoadRecords` targets are not required-unmapped.
- Re-add pyDevSup to the module set (pin, `configure/RELEASE`, module config, `RULES_MODS_CONFIG` wiring) through the module-bump procedure, rebasing PR #70 onto the then-current master.
- Re-verify across the release OS matrix.

Out of scope: the 1.3.0 release, which is unchanged.

##### Completion Criteria

- `make check.module-deps` passes with pyDevSup present and its guarded dependencies shown as optional.
- A build with none of iocStats, autosave, or caPutLog present still audits clean, exercising the guard path.
- pyDevSup builds and installs on the release OS set with `check_deps` exit 0.
- PR #70 is rebased and merged, or superseded by this work.

##### Dependencies And Decisions

- Consumes PR #70 (jeonghanlee/EPICS-env#70).

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Extend the audit scanner to honor conditional guards and classify guarded deps optional.
2. Resolve the `test.cmd` startup-db unknown finding.
3. Re-add pyDevSup via the module-bump procedure.
4. Re-verify across the release OS matrix.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Audit | Run `make check.module-deps` with pyDevSup present, and again with none of iocStats/autosave/caPutLog present | Repository checkout | Passes both times; guarded deps shown optional |
| T2 | Build | Build and install pyDevSup on the release OS set and run `check_deps` | Release OS matrix | Builds and installs; `check_deps` exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |
| T2 | Not run | Release OS matrix | Pending | none |

##### Closure Evidence

- None; not yet started.

##### GitHub Projection

Title: Re-add pyDevSup with optional-dependency support in check.module-deps
Labels: enhancement
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; created and moved to the 1.4.0 milestone this session

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M5 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m5---epicspath-normalizerelpath) |

### Backlog Details

#### M5 - EPICS::Path Normalize/RelPath

Origin: 1.4.0 / M5
Identity History: none
GitHub Issue: #25, https://github.com/jeonghanlee/EPICS-env/issues/25
Status: Not started

##### Summary

`makeRPath` computes relocatable `$ORIGIN`-relative rpath entries. Removing its bare-`python` dependency (the fragility behind #18) requires re-implementing in Perl the lexical path algebra Python's `os.path` provides as primitives; the earlier straight port (upstream PR #589) regressed at exactly this point and was reverted. The proper fix builds the missing primitive once in the shared module and has `makeRPath` consume it.

##### Scope

Additive extension of `src/tools/EPICS/Path.pm`, leaving `AbsPath` untouched: `Normalize($path)` (lexical, no-stat normalization of `.`, `..`, `//`, trailing slash) and `RelPath($target, $base)` (Normalize both, then relativize). The missing operation is lexical `..` collapse without `stat`: `File::Spec->abs2rel` does not normalize embedded `..`, `canonpath` does not collapse `..`, and `Cwd::abs_path` / `EPICS::Path::AbsPath` collapse `..` only by touching the filesystem, unusable for a not-yet-existing `--final` path. Full edge catalog: `docs/makeRPath-perl-port/relpath-design-analysis.md`.

Out of scope: a straight port that hand-rolls the algebra inside the leaf tool.

##### Completion Criteria

- `makeRPath` consumes the shared `Normalize`/`RelPath` primitives.
- `AbsPath` is unchanged.
- The reverted straight-port regression does not recur on the edge catalog.

##### Dependencies And Decisions

- None; long-parked design item, low priority.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Add `Normalize` and `RelPath` to `src/tools/EPICS/Path.pm` against the edge catalog.
2. Repoint `makeRPath` at the primitives and remove its Python dependency.
3. Verify against the edge catalog and a real per-OS rpath build.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Path algebra | Run the edge catalog in `docs/makeRPath-perl-port/relpath-design-analysis.md` against the new primitives | Repository checkout | Every case matches the expected lexical result with no `stat` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |

##### Closure Evidence

- None; parked.

##### GitHub Projection

Title: Build EPICS::Path Normalize/RelPath primitives for makeRPath
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-09; remains in Backlog this session

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-09-09 | `8339edfc0b74fc4953702ac2ec996fc4cf9402dd` (`docs/milestone-1.3.1.md`) |
