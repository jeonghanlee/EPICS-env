# Work Register

Release line: 1.4.0
Milestone index: 1.4.0
Canonical path: `docs/milestone-1.4.0.md`
Canonical branch or ref: `release-1.4.0`
Git upstream: `origin/release-1.4.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.4.0, number 6

Next session entry point: M1, M2, M3, M4, M7, and M9 are Complete with their issues closed. The only open milestone is M6 (global iocsh, #72), Not started with a draft plan — its plan review is the next action. M5 and M8 are parked in the Backlog (D7).

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Documentation | M1 | Rewrite the documentation set against the shipped 1.3.0 environment | Milestone | Complete | - | D1, D2, D11 | Every retained page is verified against the released 1.3.0 installation or retired by owner decision, and the book builds and publishes; [detail](#m1---documentation-rewrite) |
| Documentation | M2 | Document reproducing the mdBook site build outside CI | Milestone | Complete | - | D1, D2 | A written procedure builds the book locally with the same `jeonghanlee/mdbook` image CI uses and matches its output; [detail](#m2---reproducible-mdbook-toolchain) |
| Build | M3 | Strip `.debug_info` from MCoreUtils under the gz flavor | Milestone | Complete | - | | Under `make build.gz`, `readelf -S` on the installed `libmcoreutils.so` shows no `.debug_info` and `check_deps` exits 0; [detail](#m3---mcoreutils-gz-debug-info) |
| Modules | M4 | Re-add pyDevSup with optional-dependency support in `check.module-deps` | Milestone | Complete | - | | `make check.module-deps` passes with pyDevSup present and its guarded deps optional, and pyDevSup builds and installs on the release OS set with `check_deps` exit 0; [detail](#m4---pydevsup-re-add) |
| IOC shell | M6 | Define a global iocsh for standard site services | Milestone | Not started | Yes | | An example IOC boots one global iocsh that brings up the standard site services with site defaults; [detail](#m6---global-iocsh) |
| Build | M7 | Remove the Docker support | Milestone | Complete | - | | No `docker/` tree, `RULES_DOCKER`, or docker target remains, and `make` parses and a build passes on the OS matrix without them; [detail](#m7---remove-docker-support) |
| Build | M9 | Restore patch.StreamDevice.revert to the patch-revert aggregate | Milestone | Complete | - | | `patch.revert:` is the exact reverse of `patch:`, and a `make patch` / `make patch.revert` round-trip leaves every `-src` clean including StreamDevice; [detail](#m9---streamdevice-patch-revert) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Track the mdBook build and link-check toolchain (M2) as its own work item, separate from the M1 content rewrite. | 2026-08-08 |
| D2 | Work the two documentation milestones (M1, M2) directly on `master`, not on a `release-1.4.0` branch. | 2026-09-09 |
| D3 | Carry the 2026-08-07 document-review inventory into M1 as one body of evidence for its inventory step, not as separate work rows. | 2026-08-07 |
| D4 | Rebuild the book as a concise four-part set (Introduction, Architecture, Usage, Reference) and move working material out of it into `docs/archive/`, `docs/procedures/`, and `docs/design/makeRPath-perl-port/`. | 2026-09-10 |
| D5 | Archive the entire `docs/src/module-management/` section to `docs/archive/` and rewrite its guidance as two new Usage documents: Managing modules, and Module dependency audit. | 2026-09-10 |
| D6 | Update the book-outside repository docs (`tools/README.md`, `scripts/README.md`, `KnownIssues.md`, `ChangeLog.md`) to current, and keep them out of the book. | 2026-09-10 |
| D7 | Park M8 (module generator source-base URLs) to the Backlog and revisit only if release time permits; its design decision (Option A vs B) is deferred. | 2026-09-10 |
| D8 | Verify M3 (#68 gz `.debug_info`) and M4 (#71 pyDevSup) build-side checks together in one OS-matrix build run (gz flavor). | 2026-09-10 |
| D9 | Re-scope M2 to the current docs CI: the `jeonghanlee/mdbook` container image is the mdBook toolchain authority (its Dockerfile pins the version), so EPICS-env pins no version and adds no lychee link check; M2 delivers a local build procedure using that image. | 2026-09-11 |
| D10 | M1 plan-review decisions: `scripts/README.md` documents its eight scripts (keep the file); the module-removal convention is to comment out declarations; `ChangeLog.md` is reconstructed from recoverable history; `KnownIssues.md` is deleted in favor of GitHub issues; the docs get no Markdown lint and no link check. Resolves the six Inventory Group 2 questions (the docker one moot after M7; the SRC_URL one now Backlog M8). | 2026-09-11 |
| D11 | Work M1 on `release-1.4.0`, superseding D2: the 1.4.0 register and the M2 result already live on that branch. | 2026-09-11 |

### Milestone Details

#### M1 - Documentation Rewrite

Origin: 1.4.0 / M1
Identity History: none
GitHub Issue: #56, https://github.com/jeonghanlee/EPICS-env/issues/56
Status: Complete

##### Summary

Rebuild the user documentation as a concise four-part book (Introduction, Architecture, Usage, Reference) and move working material (past-cycle records, procedures, platform notes, makeRPath design records) out of the book. The retained Usage and Reference pages still describe earlier environments and are verified against the released 1.3.0 installation; the Architecture chapter is net-new.

##### Scope

- Rebuild the book as a concise four-part set: Introduction, Architecture, Usage (two new module guides), and Reference (EPICS Environment Parameters).
- Author one concise, net-new Architecture chapter describing what the repository assembles and how — the module set, the build system, and the install and runtime data flow.
- Rewrite the Usage guidance as two new documents — Managing modules (add, change version, change repository URL, remove, conventions), written generically without per-module examples, and Module dependency audit (`check.module-deps`) — and archive the entire current `docs/src/module-management/` section to `docs/archive/`.
- Verify the documented EPICS Base 7.0.10 behavior with all eighteen carried Base fixes.
- Verify the nine updated module versions, with motor retained at `285f44d`.
- Verify pvxs 1.5.2 with its twelve carried fixes.
- Document feed-core in place of the retired site-layer feed module.
- Verify the strict `check_deps` gate and module dependency audit.
- Verify the 1.3.0 installation path and current `setEpicsEnv.bash` behavior.
- Move working material out of the book: past-cycle records and era-specific platform notes to `docs/archive/`, general procedures to `docs/procedures/`, and makeRPath design records to `docs/design/makeRPath-perl-port/`; remove the book's Archived Notes section.
- Update `docs/README.md` and remove the obsolete `release-1.3.0` documentation deployment trigger. No Markdown lint or link check for the docs (D10).
- Update the book-outside repository docs, staying out of the book: bring `tools/README.md` current; document `scripts/README.md`'s eight scripts (`caget_pvs.bash` -> `tools/pvs_gets.bash`); reconstruct `ChangeLog.md` from recoverable history; and delete `KnownIssues.md` in favor of GitHub issues (D10).

Out of scope: editing the content of the relocated records, build-system changes, and product code changes.

##### Completion Criteria

- The book is the concise four-part set (Introduction, Architecture, Usage, Reference), and no working record, procedure, or platform note is part of it.
- The book includes the net-new Architecture chapter covering the module set, build system, and install flow.
- The Usage section is the two new module guides, and the current `docs/src/module-management/` pages are archived to `docs/archive/`.
- The new Usage docs and the retained Reference page are accurate against a real released 1.3.0 installation, with no stale 1.2.x version or path in the book sources.
- Working material is relocated to `docs/archive/`, `docs/procedures/`, and `docs/design/makeRPath-perl-port/`, and `docs/README.md` reflects the new layout.
- `mdbook build docs` exits 0, built with the same `jeonghanlee/mdbook` image CI uses (per M2). No link check or Markdown lint for the docs (D10).

##### Dependencies And Decisions

- The 1.3.0 released object and production installation are published (1.3.0 tag `9673619`, GitHub release, distributions), so the release dependency is satisfied.
- D11 places this work on `release-1.4.0`, superseding D2.
- D3 supplies the source-tree half of the inventory step; see Inventory Evidence below.
- D4 sets the four-part book structure and the relocation of working material out of the book.
- D10 records the plan-review decisions (scripts/README documented, module-removal = comment out, ChangeLog reconstructed, KnownIssues deleted, no docs Markdown lint or link check) and resolves the six Inventory Group 2 questions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: owner, 2026-09-11
Implementation Authorization: owner, 2026-09-11
Superseded Plan Artifacts: the draft plan's Markdown-lint and offline-link-check items (retired by D10) and the six open Inventory Group 2 decisions (resolved by D10)

1. Reorganize docs/: move past-cycle records and platform notes and the entire `docs/src/module-management/` section to `docs/archive/`, the procedures to `docs/procedures/`, and the makeRPath records to `docs/design/makeRPath-perl-port/`; remove the book's Archived Notes section and update `docs/README.md` and `docs/src/SUMMARY.md`.
2. Author the net-new Architecture chapter and place it after Introduction.
3. Write the two new Usage documents (Managing modules; Module dependency audit); the module-removal convention is to comment out the declaration lines (D10).
4. Verify the new Usage docs and the retained Reference page against a real released 1.3.0 installation, using the Inventory Evidence list.
5. Update the book-outside docs (D10): document `scripts/README.md`'s eight scripts (`caget_pvs.bash` -> `tools/pvs_gets.bash`), bring `tools/README.md` current, reconstruct `ChangeLog.md` from recoverable history, and delete `KnownIssues.md` in favor of GitHub issues; remove the obsolete `release-1.3.0` documentation deployment trigger.
6. Build the book with the `jeonghanlee/mdbook` image (`mdbook build docs`) and verify the published site.

##### Architecture Chapter Outline

The chapter leads with purpose and the principles that follow, then shows the mechanisms that enforce them. Six sections:

1. Purpose — the environment is the facility's single authoritative EPICS foundation (a curated Base plus module set) that every IOC and site application builds on, reproducible and rebuildable across the facility's lifetime without OS package managers or external CI.
2. Design principles — reproducible and long-lived (GNU Make only), curated and version-pinned, self-contained (single install prefix), fixes carried in-tree rather than forked, relocatable (`$ORIGIN` rpath plus versionless symlinks), controlled and auditable evolution, and proven on an OS matrix.
3. How it is organized — the top `Makefile` includes `configure/CONFIG` and `configure/RULES`, which aggregate the `CONFIG_*` and `RULES_*` fragments in two layers; the hand-edited site identity is `configure/RELEASE` (version pins) and `configure/CONFIG_SITE` (`INSTALL_LOCATION`, `ENV_RELEASE_VERS`), while the top-level `RELEASE.local` and `CONFIG_SITE.local` are generated by `conf`; the module `<name>-src/` trees, the curated pin list, `patch/`, and the vendor libraries complete the layout.
4. Build pipeline — `init` → `patch` → `conf` → `check.module-deps` → `build` → `install` → `symlinks`, and what each stage contributes toward a reproducible tree.
5. Consistency and relocatability — two independent gates (the pre-build source dependency audit `check.module-deps`, and the post-install ELF and RUNPATH audit `check.deps`); the carry mechanism (version-anchored Base and pvxs patches, distinct from a module bump); the install prefix, `$ORIGIN` rpath, and versionless symlinks that make the tree relocatable; and the prebuilt distribution as the deploy path.
6. Platforms and verification — the supported OS matrix verified by per-OS CI, and the downstream consumers (IOCs, siteApps, the global iocsh of #72) that build on this foundation.

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

Group 2 - the six entries below needed an owner decision; all are resolved by D10 (2026-09-11): scripts/README documented, KnownIssues deleted (GitHub issues), remove-a-module keeps commented declarations, the docker one is moot after M7's removal, ChangeLog reconstructed from recoverable history, and the SRC_URL idea is now Backlog M8.

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
| T1 | Documentation and production consistency | Compare every retained version, path, module reference, and command with the real released 1.3.0 installation; build the book with the `jeonghanlee/mdbook` image; inspect the published site | Released 1.3.0 installation, repository book sources, and GitHub Pages | Retained guidance matches the released environment; no stale 1.2.x book reference remains; the book builds and publishes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-12 | Released 1.3.0 distribution tree (`EPICS-env-distribution/1.3.0/`), repository book sources, and the published GitHub Pages site | Pass | All 45 Reference-page environment variables resolve in the installed Base/PVXS artifacts (`libca`/`libCom`/`libpvxs` and bin); book sources carry no stale 1.2.x version, old OS, or `/usr/local/epics` path; install path `1.3.0/<os>/7.0.10/` and pvxs 1.5.2 confirmed; `mdbook build docs` exits 0; the published site serves the new Architecture, Usage, and Reference pages and no longer serves the archived module-management or Archived Notes pages. |

##### Closure Evidence

- Implementation and verification complete 2026-09-12 on `release-1.4.0`: the four-part book (Introduction, Architecture, Usage, Reference) is built and published, working material is relocated under `docs/archive/`, `docs/procedures/`, and `docs/design/`, the book-outside docs are current, and T1 passed against the released 1.3.0 tree and the live site.
- External gate satisfied: GitHub issue #56 closed 2026-09-12 (completed), body synced to the shipped four-part book.

##### GitHub Projection

Title: Rewrite the documentation set against the shipped 1.3.0 environment
Labels: documentation
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: documentation
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone

#### M2 - Reproducible mdBook Toolchain

Origin: 1.4.0 / M2
Identity History: none
GitHub Issue: #59, https://github.com/jeonghanlee/EPICS-env/issues/59
Status: Complete

##### Summary

The documentation site is built in `.github/workflows/docs.yml` inside the `jeonghanlee/mdbook` container image, which bundles the mdBook toolchain (its Dockerfile pins the mdBook version). Nothing outside that workflow told a contributor how to build the book the same way, so a page edit could not be checked locally against what CI runs. (The earlier premise — env-var version pins and a lychee link check in `docs.yml` — no longer holds: the workflow was rebuilt to the container image and carries no link check.)

##### Scope

- Document a local build that uses the same `jeonghanlee/mdbook` image CI uses, so a contributor reproduces the CI build without installing a toolchain.
- Put that procedure where a page editor already looks (`docs/README.md`).

Out of scope: pinning a specific image version (the shared image is used as-is, owner decision D9), a lychee or other link-check step (not part of the current CI, D9), the M1 content rewrite and its Markdown lint, the deploy workflow's triggers, and any `book.toml` change.

##### Completion Criteria

- A written procedure builds the book locally with the same `jeonghanlee/mdbook` image CI uses and produces the same `docs/book` output as CI.
- The procedure is reachable from the documentation a page editor already reads (`docs/README.md`).

##### Dependencies And Decisions

- D1 separates this from the M1 content rewrite.
- D2 placed this work on `master`; it landed on `release-1.4.0`, where D11 now places the documentation work.
- D9 re-scopes M2 to the container-image toolchain (no version pin, no lychee). The mdBook version authority is the image's Dockerfile (`jeonghanlee/Dockerfiles`, `mdbook/Dockerfile`), outside this repo.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: owner, 2026-09-11
Implementation Authorization: owner, 2026-09-11
Superseded Plan Artifacts: the draft plan that pinned versions and reproduced a lychee link check (premise retired by D9)

1. Document the local build in `docs/README.md`: run `mdbook build docs` inside the `jeonghanlee/mdbook` image from the repository root.
2. Verify the documented command builds `docs/book` and leaves `docs/src` clean.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Reproducibility | Run the documented command (`mdbook build docs` in the `jeonghanlee/mdbook` image) from a clean checkout and confirm it builds `docs/book` and leaves `docs/src` clean, the same as CI | Checkout with Docker | Book builds; `docs/src` unchanged; same image as CI |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-11 | EPICS-env checkout, Docker 29.8.0, `jeonghanlee/mdbook` image | Pass | `docker run --rm -v "$PWD:/work" -w /work jeonghanlee/mdbook mdbook build docs` exits 0 and writes `docs/book`; `git status` for `docs/src` stays clean; procedure recorded in `docs/README.md`. |

##### Closure Evidence

- Local build procedure added to `docs/README.md` and verified 2026-09-11 (T1): the `jeonghanlee/mdbook` image builds `docs/book` locally, matching CI, with `docs/src` clean. Issue #59 closed 2026-09-11; milestone complete.

##### GitHub Projection

Title: Make the mdBook build and link check reproducible outside CI
Labels: documentation
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: documentation
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone

#### M3 - MCoreUtils gz debug info

Origin: 1.4.0 / M3
Identity History: none
GitHub Issue: #68, https://github.com/jeonghanlee/EPICS-env/issues/68
Status: Complete

##### Summary

Under the gz build flavor (`make build.gz`, `-g0 -gz=zlib`), the MCoreUtils module ships debug info the flavor is meant to strip: `modules/MCoreUtils-*/lib/linux-x86_64/libmcoreutils.so` carries a `.debug_info` section. Observed on all five release OSes during the 1.3.0 gz verification and confirmed again in the 1.3.0 ship build; recorded there as informational (#68), non-blocking.

##### Scope

Change `USR_CFLAGS =` to `USR_CFLAGS +=` in upstream `epics-modules/MCoreUtils`, or carry the one-line change as an EPICS-env patch under the patch system, so the appended `-g0` is not overwritten.

Out of scope: the vendor trees (`vendor/`, uldaq, open62541) build under their own systems, never receive the gz flags, and always carry debug info; they are excluded by design.

##### Completion Criteria

- Under `make build.gz`, `readelf -S` on the installed `libmcoreutils.so` reports no `.debug_info` section, matching the other modules.
- `check_deps` still exits 0.

##### Dependencies And Decisions

- D8 bundles this with M4's build in one OS-matrix run (gz flavor).
- Fixed two ways: local carry `patch/MCoreUtils-gz-debuginfo.p0.patch` (`f022b0f`), and the upstream fix submitted as epics-modules/MCoreUtils#4. The carry retires when the upstream fix merges and a MCoreUtils bump includes it.

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
| T1 | 2026-09-11 | Fresh gz VMs, release-1.4.0, Layer 1: all six OSes | Pass (6 of 6) | `readelf -S libmcoreutils.so` shows 0 `.debug_info` sections on debian12/13, ubuntu24/26, rocky8, rocky10; `check_deps` exit 0; installed `base/configure/CONFIG_SITE.local` carries `-g0 -gz=zlib`. |

##### Closure Evidence

- Verified on all six gz OSes (2026-09-11): debian12, debian13, ubuntu24, ubuntu26, rocky8, rocky10 each show 0 `.debug_info` sections in `libmcoreutils.so` with `check_deps` exit 0, confirming the carried patch `patch/MCoreUtils-gz-debuginfo.p0.patch`. Issue #68 closed 2026-09-11; milestone complete.

##### GitHub Projection

Title: MCoreUtils ships .debug_info under the gz flavor
Labels: bug
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: bug
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone

#### M4 - pyDevSup Re-add

Origin: 1.4.0 / M4
Identity History: none
GitHub Issue: #71, https://github.com/jeonghanlee/EPICS-env/issues/71
Status: Complete

##### Summary

Re-add the pyDevSup module, maintained again upstream (epics-modules/pyDevSup#41), and teach the module-dependency audit to treat its Makefile-guarded dependencies as optional. Proposed in PR #70; deferred out of 1.3.0, which stays a fixed production baseline. Re-adding a module changes the shipped module set, which is a minor-release change by this project's convention (patch releases keep the module set unchanged) and is why it lands here rather than in a 1.3.x patch.

##### Scope

- Teach the Makefile scanner in `tools/audit_module_deps.bash` to track `ifdef`/`ifndef`/`ifeq`/`ifneq` blocks and classify a token observed only inside a conditional guard as optional (the tool already has an optional class; only required-observed tokens raise `undeclared-observed`).
- Treat root-level test startup scripts (`test*.cmd`) like the existing `test/` and `iocBoot/` optional paths so their `dbLoadRecords` targets are not required-unmapped.
- Re-add pyDevSup to the module set (pin, `configure/RELEASE`, module config, `RULES_MODS_CONFIG` wiring) through the module-bump procedure, consuming PR #70.
- Re-verify across the release OS matrix.

Out of scope: the 1.3.0 release, which is unchanged.

##### Completion Criteria

- `make check.module-deps` passes with pyDevSup present and its guarded dependencies shown as optional.
- A build with none of iocStats, autosave, or caPutLog present still audits clean, exercising the guard path.
- pyDevSup builds and installs on the release OS set with `check_deps` exit 0.
- PR #70's changes are merged into release-1.4.0 (the PR kept open until testing completes), or superseded by this work.

##### Dependencies And Decisions

- Consumes PR #70 (jeonghanlee/EPICS-env#70).
- D8 bundles M4/T2 with M3/T1 (#68 gz `.debug_info`) in one OS-matrix build run (gz flavor).
- External dependency (Rocky), resolved: pyDevSup's C extensions need Python dev headers and the correct python3. ansible-provision fixed it in two commits — `af239dd` installs the RedHat dev headers (`python3-devel`; `python39-devel` for rocky8's 3.9 module) and `54b32c6` makes the python3-alternatives loop skip an absent group cleanly (rocky8 switches python3→3.9; rocky10 is native 3.12). Tracked by ansible-provision#25. Clean rocky8/rocky10 gz re-runs then passed.

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
| T1 | 2026-09-11 | Repository checkout (release-1.4.0) | Pass | `make check.module-deps` exits 0 with `Findings: none`, pyDevSup present; pyDevSup's iocStats/autosave/caPutLog deps are classified `optional` (guarded), so the trio-absent guard path raises no finding. |
| T2 | 2026-09-11 | Fresh gz VMs, release-1.4.0, Layer 1: all six OSes | Pass (6 of 6) | pyDevSup `_dbapi.so` built and installed with `check_deps` exit 0 on debian12 (py3.11), debian13, ubuntu24 (py3.12), ubuntu26 (py3.14/gcc15), rocky8 (py3.9), rocky10 (py3.12). rocky needed ansible-provision `af239dd` + `54b32c6` (see Dependencies); clean re-runs then passed. |

##### Closure Evidence

- PR #70 (tynanford; commits `f953b9b`, `e70c19f`, `f621435`) merged into release-1.4.0 at `7fffebd`, 2026-09-10; the PR is kept open for owner testing.
- T2 OS-matrix build verified on all six gz OSes 2026-09-11 (debian12, debian13, ubuntu24, ubuntu26, rocky8, rocky10): pyDevSup built and installed, `check_deps` exit 0; rocky8/rocky10 passed clean after the ansible-provision `af239dd` + `54b32c6` fixes (see Dependencies). T1 audit (`check.module-deps`) verified 2026-09-11: exit 0, `Findings: none`, and pyDevSup's guarded iocStats/autosave/caPutLog deps classified `optional`. Issue #71 closed 2026-09-11; milestone complete.

##### GitHub Projection

Title: Re-add pyDevSup with optional-dependency support in check.module-deps
Labels: enhancement
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-10; PR #70 merged into release-1.4.0 and cross-referenced; #71 open

#### M6 - Global iocsh

Origin: 1.4.0 / M6
Identity History: none
GitHub Issue: #72, https://github.com/jeonghanlee/EPICS-env/issues/72
Status: Not started

##### Summary

Each standard site service ships its own iocsh fragment, sourced ad hoc per IOC. Define a single global iocsh that an IOC sources once to bring up the common services with site-default settings, so individual IOCs stop duplicating per-service boilerplate. The service list is open and grows as services are folded in.

##### Scope

- Consolidate the per-service iocsh fragments into one global entry point covering at least autosave (`save_restore.iocsh`), caPutLog, iocLog, iocStats, reccaster (`recsync`), and linStat.
- Source each service through the global iocsh with its site-default configuration.

Out of scope: per-service behavior changes beyond relocation into the global iocsh.

##### Completion Criteria

- A single global iocsh exists that an IOC sources to enable the covered services.
- Each service keeps its site-default configuration when loaded through the global iocsh.
- An example IOC boots cleanly sourcing only the global iocsh for these services.

##### Dependencies And Decisions

- None.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Inventory the iocsh fragment and site-default parameters each listed service provides.
2. Define one global iocsh that sources those fragments with the site defaults.
3. Boot an example IOC sourcing only the global iocsh and confirm each service comes up.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | iocsh aggregation | Boot an example IOC sourcing only the global iocsh, then confirm each covered service started with its site default | Example IOC on the release OS set | Every covered service comes up with its site-default configuration |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Example IOC on the release OS set | Pending | none |

##### Closure Evidence

- None; not yet started.

##### GitHub Projection

Title: Define a global iocsh for standard site services
Labels: enhancement
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-10

#### M7 - Remove Docker Support

Origin: 1.4.0 / M7
Identity History: none
GitHub Issue: #73, https://github.com/jeonghanlee/EPICS-env/issues/73
Status: Complete

##### Summary

Remove the Docker support from the repository. The `docker/` tree is a standalone Dockerfile test from 2020 (last touched 2020-08-06) that the environment no longer needs; deleting it and its unused Make targets removes a stale maintenance surface.

##### Scope

- Delete the `docker/` directory: `Dockerfile`, `scripts/docker_builder.bash`, `scripts/README.md`, `scripts/docker_env_default.conf`.
- Delete `configure/RULES_DOCKER` and remove the `-include $(TOP)/configure/RULES_DOCKER` line from `configure/RULES`.
- Delete `docs/README.Docker.md`, the 2020 note committed with the Dockerfile in `72a8c91`; it is removed here rather than archived under M1.
- Remove the dead Docker path-filter triggers (`docker/**` and `.github/workflows/docker-image.yml`) from the seven per-OS build workflows; the `docker-image.yml` workflow itself was already removed in `378e2df`, leaving only these stale references.

Out of scope: the `docker://github/super-linter` action in `.github/workflows/linter.yml`, which is the linter mechanism, not the repository's Docker support.

##### Completion Criteria

- No `docker/` directory, `configure/RULES_DOCKER`, `docs/README.Docker.md`, or `build.docker` / `install.docker` / `prune.docker` target remains.
- No `docker/**` or `docker-image.yml` reference remains in the build workflows.
- `make` parses with no `RULES_DOCKER`, and a full build, install, and check pass on at least one release OS.

##### Dependencies And Decisions

- `docs/README.Docker.md` is deleted here and removed from the M1 platform-note archive set, since it documents this same retired Docker test.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Delete `docker/`, `configure/RULES_DOCKER`, and `docs/README.Docker.md`, and drop the include line in `configure/RULES`.
2. Remove the dead `docker/**` and `docker-image.yml` path-filter lines from the seven build workflows.
3. Confirm `make` parses and a full build, install, and check pass on a release OS with no Docker reference left.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build integrity after removal | Parse `make` and run a full `init`/`patch`/`conf`/`build`/`install`/`check` with no Docker files present | A release OS build VM | Make parses; the build, install, and checks pass; no Docker reference remains |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-11 | Fresh gz VMs, release-1.4.0, Layer 1: all six OSes | Pass (6 of 6) | Full build/install/check pass with no Docker files on debian12/13, ubuntu24/26, rocky8, rocky10; `check_deps` exit 0. |

##### Closure Evidence

- Removal landed on release-1.4.0 (working tree): `docker/`, `configure/RULES_DOCKER`, and `docs/README.Docker.md` deleted; the `RULES_DOCKER` include dropped from `configure/RULES`; the dead `docker/**` and `docker-image.yml` triggers removed from the seven build workflows; and the `README.Docker.md` links in `docs/README.md` and `docs/src/archive.md` cleaned. `make` parses with no `RULES_DOCKER`. T1's full build/install/check verified on all six gz OSes 2026-09-11 (debian12, debian13, ubuntu24, ubuntu26, rocky8, rocky10), all passing with no Docker reference present. Issue #73 closed 2026-09-11; milestone complete.

##### GitHub Projection

Title: Remove the Docker support
Labels: enhancement
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-10

#### M9 - StreamDevice Patch Revert

Origin: 1.4.0 / M9
Identity History: none
GitHub Issue: #74, https://github.com/jeonghanlee/EPICS-env/issues/74
Status: Complete

##### Summary

`configure/RULES_SRC` lists `patch.StreamDevice.apply` in the `patch:` aggregate but omits `patch.StreamDevice.revert` from `patch.revert:`, which carries a comment requiring it to be the exact reverse of `patch:` (EPICS-env #32). So `make patch.revert` never reverts the StreamDevice patch, and a `make patch` / `make patch.revert` round-trip leaves `StreamDevice-src` dirty. Found while wiring the MCoreUtils gz patch (#68), 2026-09-10.

##### Scope

- Add `patch.StreamDevice.revert` to `patch.revert:` in `configure/RULES_SRC` at the position mirroring `patch.StreamDevice.apply` in `patch:`.

Out of scope: any other patch leg; the recipe `patch.StreamDevice.revert` itself already exists in `configure/RULES_PATCH`.

##### Completion Criteria

- `patch.revert:` is the exact reverse of `patch:`.
- `make patch` then `make patch.revert` leaves every `<module>-src` clean, including `StreamDevice-src`.

##### Dependencies And Decisions

- None.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Insert `patch.StreamDevice.revert` into `patch.revert:` at its mirror position.
2. Run `make patch` then `make patch.revert` and confirm every `<module>-src` is clean.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Patch round-trip | Run `make patch` then `make patch.revert`, then `git -C <module>-src status --short` for every patched module | Repository checkout | Every module source is clean, including `StreamDevice-src` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-10 | Repository checkout | Pass | Round-trip from pristine: `make patch` and `make patch.revert` both exit 0; all module sources clean, including `StreamDevice-src`. |

##### Closure Evidence

- Fix landed on release-1.4.0 (working tree): `patch.StreamDevice.revert` added to `patch.revert:` in `configure/RULES_SRC` at the mirror position. T1 verified — a round-trip from pristine leaves every module source clean, StreamDevice included; the patch also applied and built on the six-OS gz matrix. Issue #74 closed 2026-09-11; milestone complete.

##### GitHub Projection

Title: patch.revert omits StreamDevice, breaking the round-trip contract
Labels: bug
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: bug
Observed Milestone: 1.4.0
Last Compared: 2026-09-10

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M5 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m5---epicspath-normalizerelpath) |
| Build | M8 | Teach the module generator the correct per-module source-base URLs | Milestone | Not started | No | | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m8---generator-src-url-overrides) |

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
Last Compared: 2026-09-09; remains in Backlog

#### M8 - Generator SRC URL Overrides

Origin: 1.4.0 / M8
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

The `MODULESGEN.mk` generator rule in `configure/CONFIG_MODS` writes `$(SRC_URL_EPICSMODULES)/<name>` uniformly for every module. Twelve modules live outside `epics-modules` — RECSYNC, RETOOLS, STREAM, SNMP, MOTORSIM, PVXS, PMAC, PSCDRV, LINSTAT, FEEDCORE, QPC, RGAMV2 — so `configure/CONFIG_MODS` re-defines their `SRC_GITURL_*` after the include; the effective make values are correct and builds are unaffected. The generated `configure/MODULESGEN.mk` is git-untracked (gitignored), so the twelve stale lines mislead only a maintainer who opens their own generated copy, not a reader of the committed tree. The improvement is to have the generator emit the correct base URL per module so the generated file no longer carries stale values.

##### Scope

- Teach the generator to select the correct source base per module instead of always using `SRC_URL_EPICSMODULES`, covering all twelve non-`epics-modules` modules above. The base is not derivable from the module name (RECSYNC uses `SRC_URL_CHANNELFINDER`; `SRC_URL_MD` is shared by PSCDRV and LINSTAT; `SRC_URL_JEONGHANLEE` by SNMP, QPC, and RGAMV2), so the special-case map must be carried explicitly. The chosen approach (Option A or B below) fixes which files change.
- After the generator emits correct URLs, remove the now-redundant `SRC_GITURL_*` re-definitions from `configure/CONFIG_MODS` (lines 36-54). This step must follow the generator change, never precede it.
- State where a maintainer declares the base for a new non-`epics-modules` module after this change.

Out of scope: changing any effective URL (all twelve are already correct); the `INSTALL_LOCATION_*` and `SRC_PATH_*` generator output and the `seq` and `recsync-src/client` special cases; and `configure/RELEASE` edits unless the chosen approach is Option A.

##### Completion Criteria

- The current effective values are captured as a baseline (`make print-SRC_GITURL_<M>` for the twelve modules on the unmodified tree).
- The generated `configure/MODULESGEN.mk` carries the correct base URL for all twelve modules, with no `SRC_GITURL_*` re-definition left in `configure/CONFIG_MODS`.
- The post-change effective `make print-SRC_GITURL_*` equals the captured baseline for every module — not merely equal to the regenerated file, which is circular once the override is gone.
- A clone of the twelve modules resolves and the build is unchanged.
- The procedure for declaring a new non-`epics-modules` module's base is documented where the chosen approach places it.

##### Dependencies And Decisions

- Parked to the Backlog per D7; the design decision below is deferred until it is revisited.
- Open design decision (owner call). Option A: declare per-module base variables in `configure/RELEASE` and add a one-line generator fallback; keeps the generator uniform and co-locates each base with its module, but edits `configure/RELEASE` and either duplicates a shared base or adds an indirection layer. Option B: carry a module-to-base table inside the `configure/CONFIG_MODS` generator rule; leaves `configure/RELEASE` untouched and confines the change to one file, but moves the special-case knowledge into the shell-echo loop and reduces readability. Either way the twelve non-mechanical lines move rather than disappear.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Decide the design (Option A vs B) and record it here before coding.
2. Capture the baseline `make print-SRC_GITURL_*` for the twelve modules on the current tree.
3. Implement the chosen approach so the generator emits the correct per-module base.
4. Remove the redundant `SRC_GITURL_*` re-definitions from `configure/CONFIG_MODS` (lines 36-54).
5. Regenerate, assert the post-change `make print-SRC_GITURL_*` equals the step-2 baseline for all twelve, run a clone, and confirm the build is unaffected.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Generator correctness | Capture a pre-change baseline of `make print-SRC_GITURL_*` for the twelve modules; after the change, regenerate and compare the post-change `make print-SRC_GITURL_*` against that baseline, then run a clone | Repository checkout | Post-change effective URLs equal the pre-change baseline for all twelve; clone and build unaffected |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |

##### Closure Evidence

- None; parked in the Backlog.

##### GitHub Projection

Title: Teach the module generator the correct per-module source-base URLs
Labels: none
GitHub Milestone: none
Observed State: none
Observed Labels: none
Observed Milestone: none
Last Compared: never

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-09-09 | `8339edfc0b74fc4953702ac2ec996fc4cf9402dd` (`docs/milestone-1.3.1.md`) |
