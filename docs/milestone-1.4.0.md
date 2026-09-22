# Work Register

Release line: 1.4.0
Milestone index: 1.4.0
Canonical path: `docs/milestone-1.4.0.md`
Canonical branch or ref: `release-1.4.0`
Git upstream: `origin/release-1.4.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.4.0, number 6

Next session entry point: The 1.4.0 release is in progress (M11). Development milestones M1, M2, M4, M6, M7, and M9 are Complete with their issues closed. release-1.4.0 is synced with master (the origin/master merge is pushed) and the accepted release plan is recorded in M11. M12's measComp TC-32 patch and patch-system wiring are committed in dda4de1; its OS-matrix build verification (T2) remains pending. M3's MCoreUtils pin to upstream a86e5ed and removal of the local patch are prepared but not committed. A six-OS working-tree gz run passed on HEAD 30ce308 plus candidate patch SHA-256 581b4291ce81abc7d8f3bdb15d2d422d11476ef441dbd671631110f9bef039b1; M3 remains In progress because T1 still requires the committed candidate. Remaining, in order: commit and push the MCoreUtils change under the required authorization, then verify the resulting candidate with the OS-matrix CI (Release Verification 1 and M12 / T2) and the separate committed-candidate gz check (M3 / T1: make build.gz, no .debug_info in the installed libmcoreutils.so, check_deps exit 0). CI on 30ce308 predates the MCoreUtils pin, and the ordinary CI build does not replace the gz check. Both committed-candidate checks must pass before executing M11's release sequence (merge release-1.4.0 to master no-fast-forward, tag 1.4.0, push, publish the GitHub release from work/release-notes-1.4.0.md, close GitHub milestone 6), then the register close-out and closing PR #70 as superseded. Backlog: M5 (#25), M8 (#75), M10 (#76, the commonIocsh public-module promotion, D25). D12-D25 govern the accepted direction.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Documentation | M1 | Rewrite the documentation set against the shipped 1.3.0 environment | Milestone | Complete | - | D1, D2, D11 | Every retained page is verified against the released 1.3.0 installation or retired by owner decision, and the book builds and publishes; [detail](#m1---documentation-rewrite) |
| Documentation | M2 | Document reproducing the mdBook site build outside CI | Milestone | Complete | - | D1, D2 | A written procedure builds the book locally with the same `jeonghanlee/mdbook` image CI uses and matches its output; [detail](#m2---reproducible-mdbook-toolchain) |
| Build | M3 | Strip `.debug_info` from MCoreUtils under the gz flavor | Milestone | In progress | - | | Under `make build.gz`, `readelf -S` on the installed `libmcoreutils.so` shows no `.debug_info` and `check_deps` exits 0; [detail](#m3---mcoreutils-gz-debug-info) |
| Modules | M4 | Re-add pyDevSup with optional-dependency support in `check.module-deps` | Milestone | Complete | - | | `make check.module-deps` passes with pyDevSup present and its guarded deps optional, and pyDevSup builds and installs on the release OS set with `check_deps` exit 0; [detail](#m4---pydevsup-re-add) |
| IOC shell | M6 | Define a global iocsh for standard site services | Milestone | Complete | - | D12, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25 | An example IOC boots one global iocsh with the common services and optional serial configuration; standalone, integrated, and installed-path checks pass on the two verified OS targets (D21); [detail](#m6---global-iocsh) |
| Build | M7 | Remove the Docker support | Milestone | Complete | - | | No `docker/` tree, `RULES_DOCKER`, or docker target remains, and `make` parses and a build passes on the OS matrix without them; [detail](#m7---remove-docker-support) |
| Build | M9 | Restore patch.StreamDevice.revert to the patch-revert aggregate | Milestone | Complete | - | | `patch.revert:` is the exact reverse of `patch:`, and a `make patch` / `make patch.revert` round-trip leaves every `-src` clean including StreamDevice; [detail](#m9---streamdevice-patch-revert) |
| Modules | M12 | Carry the measComp TC-32 thermocouple channel-count fix | Milestone | In progress | - | | The patch on the pinned measComp applies and reverts cleanly in the round-trip, the OS-matrix build applies it, and a TC-32 without EXP-32 reports its base channel count; [detail](#m12---meascomp-tc-32-fix-carry) |
| Release | M11 | Release EPICS-env 1.4.0 | Milestone | Not started | No | M1, M2, M3, M4, M6, M7, M9, M12 | Master carries the no-fast-forward merge tagged `1.4.0`, the GitHub release `1.4.0` is published as Latest, GitHub milestone 6 is closed, and the register is closed out; [detail](#m11---release-epics-env-140) |

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
| D12 | M6 plan review: keep the global iocsh and an example IOC in EPICS-env (not the site layer), and expand M6 to supply the service startup where the module set ships none. | 2026-09-12 |
| D13 | M6 default covered services are caPutLog, linStat, and reccaster (recsync); autosave, iocLog, and iocStats are folded into the open list later. | 2026-09-12 |
| D14 | M6 fragments use EPICS Base's `afterIocRunning` iocsh command for post-iocInit work instead of the std module's `doAfterIocInit()` or a before/after iocInit split. | 2026-09-12 |
| D15 | The durable home for the M6 fragments and the global iocsh is a dedicated public module named `commonIocsh`, its own repo pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP`; per-module patching is not used. Interim: until testing completes the fragments are developed and held in EPICS-env, then promoted to the `commonIocsh` repo. | 2026-09-12 |
| D16 | Resolve the `commonIocsh`/`siteApps` overlap by layering, not duplication: `siteApps` drops its duplicate generic fragments and consumes `commonIocsh`, keeping only its site-specific profiles and databases. This de-duplication is the site owner's (coordinated with the alsu-site-modules session), not done in EPICS-env. | 2026-09-12 |
| D17 | M6 invokes the serial parameter helper optionally through the global iocsh, using ports already created by the IOC. An IOC without serial devices supplies no serial configuration. Specify the representation of multiple ports before implementing the serial integration. | 2026-09-15 |
| D18 | M6 enables linStat host and IOC process statistics by default. NIC and filesystem statistics require explicit IOC configuration of the interface and mount path. | 2026-09-15 |
| D19 | M6 preserves the autosave macro names used by the existing executable startup, including `VALUES_PASS0_PERIOD` and `VALUES_PASS1_PERIOD`, and aligns the descriptions with those names. No rename to the comment-only `VALUES_PERIOD_PASS0` or `VALUES_PERIOD_PASS1` is introduced. | 2026-09-15 |
| D20 | Resolve D17's multiple-port representation by passing one optional IOC-owned serial configuration file path to the global iocsh. The file calls the common serial helper once per existing port, with that port's parameters. Omitting the path skips serial setup; a supplied unreadable path is an error. | 2026-09-15 |
| D21 | Narrow M6's IOC verification matrix (T1/T2/T3) from the seven per-OS CI targets to two: Debian 13 and Rocky Linux 8.10. The per-fragment assertions, the T1/T2/T3 structure, and the serial cases are unchanged; only the OS breadth is reduced. | 2026-09-17 |
| D22 | Deliver M6's linStat as five commonIocsh-owned iocsh fragments: an all-in-one `linStat.iocsh` plus per-database `linStatHost.iocsh`, `linStatProc.iocsh`, `linStatNIC.iocsh`, and `linStatFS.iocsh`. Host and Proc load by default; NIC and FS are optional, loaded once per interface or mount through `iocshLoad` behind a `$(XENABLE=#)` line toggle, with the IOC supplying only the interface and mount macros. All five live in commonIocsh, not the IOC. | 2026-09-17 |
| D23 | linStat and iocStats (`iocAdminSoft.db`) both define `$(IOC):MEM_USED`, `$(IOC):MEM_FREE`, and `$(IOC):MEM_MAX` (iocStats as `ai`, linStat as `int64in`), so co-loading them under one IOC prefix collides with duplicate-record errors. The global iocsh loads linStat for system statistics and does not co-load iocStatsAdmin; an IOC that does not use linStat may still load iocStatsAdmin. Surfaced by the integrated (T2) verification. | 2026-09-18 |
| D24 | Serial physical verification is sufficient at the software path plus physical baud correctness; the parity-mismatch case and the application-level asynOctet clean echo have no further benefit and are not pursued. | 2026-09-20 |
| D25 | Defer the D15 promotion of commonIocsh to its public module (public repository and RELEASE pin). M6 completes on the interim EPICS-env home, its verification (T1/T2/T3) satisfied on the two OS targets (D21); the promotion is tracked as Backlog M10. | 2026-09-21 |

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
Observed State: closed
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
Observed State: closed
Observed Labels: documentation
Observed Milestone: 1.4.0
Last Compared: 2026-09-09; moved to the 1.4.0 milestone

#### M3 - MCoreUtils gz debug info

Origin: 1.4.0 / M3
Identity History: none
GitHub Issue: #68, https://github.com/jeonghanlee/EPICS-env/issues/68
Status: In progress

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
- The original local carry (`f022b0f`) supplied the `USR_CFLAGS +=` fix verified below. Upstream PR epics-modules/MCoreUtils#4 merged on 2026-09-11 at `a86e5ed193abaae5744f9a5545fc883a9348258d`.
- Decision Date: 2026-09-21. Pin MCoreUtils to `a86e5ed` and remove the local patch and its make/apply/revert targets. The upstream source reports `1.2.4-SNAPSHOT`; no newer release tag exists at adoption. The historical gz result below covers the carried patch, not this new source pin. M3 returns to In progress until T1 passes on the new pin. Before release, rerun T1 on fresh gz build trees for debian12, debian13, ubuntu24, ubuntu26, rocky8, and rocky10, and separately rerun Release Verification 1 on the final candidate. The ordinary OS-matrix CI does not run the gz strip check.
- Source-selection check (2026-09-21): the shipped `make MCOREUTILS` target in a fresh temporary copy selected full commit `a86e5ed193abaae5744f9a5545fc883a9348258d` with a clean checkout; its Makefile contains `USR_CFLAGS +=`, and the generated install directory uses `MCoreUtils-a86e5ed`. The `make -np patch patch.revert` output contains 11 patch targets in exact reverse order and no MCoreUtils patch target. This check did not execute a build or apply/revert the remaining patches.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: accepted 2026-09-21; upstream a86e5ed adoption and the separate gz re-verification requirement
Implementation Authorization: authorized 2026-09-21 for the source-pin change, patch removal, local source-selection checks, and related documentation. The six-OS working-tree gz run was subsequently authorized and completed on 2026-09-22; the committed-candidate T1 remains required. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: the earlier inline draft choosing between an upstream fix and a local carry

1. Pin `SRC_TAG_MCOREUTILS` and `SRC_VER_MCOREUTILS` in `configure/RELEASE` to `a86e5ed`. Remove `patch/MCoreUtils-gz-debuginfo.p0.patch`, its targets in `configure/RULES_PATCH`, and its apply/revert prerequisites in `configure/RULES_SRC`.
2. Verify that the shipped `make MCOREUTILS` target selects full commit `a86e5ed193abaae5744f9a5545fc883a9348258d`, that the upstream Makefile contains `USR_CFLAGS +=`, and that the remaining apply/revert lists are exact reverses with no MCoreUtils patch target. These source-selection checks are recorded above; they do not establish a gz build result.
3. On fresh gz build trees for the six OSes listed above, rerun T1 on the committed candidate: `make build.gz`, `readelf -S` on the installed `libmcoreutils.so`, and `make check.deps` from the EPICS-env checkout. Require no `.debug_info` section and dependency-check exit 0 on every OS. M11's Release Verification 1 remains a separate ordinary CI check.
4. Record the candidate and MCoreUtils commit identities and each OS result in Verification Results. Mark M3 Complete only after the new-pin T1 passes on all six OSes; preserve the earlier carried-patch results as historical evidence.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | gz strip | Build gz, run `readelf -S` on the installed `libmcoreutils.so`, and run `check_deps` | A gz build VM | No `.debug_info` section; `check_deps` exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-11 | Fresh gz VMs, release-1.4.0, Layer 1: all six OSes | Pass (6 of 6) | `readelf -S libmcoreutils.so` shows 0 `.debug_info` sections on debian12/13, ubuntu24/26, rocky8, rocky10; `check_deps` exit 0; installed `base/configure/CONFIG_SITE.local` carries `-g0 -gz=zlib`. |
| T1 | 2026-09-21 through 2026-09-22 | Fresh gz VMs; working-tree candidate at HEAD 30ce308 plus patch SHA-256 `581b4291ce81abc7d8f3bdb15d2d422d11476ef441dbd671631110f9bef039b1`; MCoreUtils a86e5ed; all six OSes | Pass (working-tree candidate, 6 of 6) | `make build.gz` and install passed; installed `libmcoreutils.so` carries neither `.debug_info` nor `.zdebug_info`; `check.module-deps`, `check.env`, and `check.deps` exit 0 on every OS. Evidence: `work/m3-m12-debian13-rocky8-20260921/` and `work/m3-m12-remaining-os-20260922/RESULTS.md`. |
| T1 | Not run on the committed candidate | Fresh gz VMs, committed candidate with MCoreUtils a86e5ed, same six OSes | Pending | After the MCoreUtils change is committed, rerun `make build.gz`; confirm no `.debug_info` section with `readelf -S` on the installed `libmcoreutils.so` and `check_deps` exit 0 on each OS. Record the EPICS-env candidate commit and MCoreUtils source commit with the results. |

##### Closure Evidence

- Verified on all six gz OSes (2026-09-11): debian12, debian13, ubuntu24, ubuntu26, rocky8, rocky10 each show 0 `.debug_info` sections in `libmcoreutils.so` with `check_deps` exit 0, confirming the carried patch `patch/MCoreUtils-gz-debuginfo.p0.patch`. Issue #68 closed 2026-09-11; the carried-patch verification is historical evidence. The same six OSes passed on the 2026-09-21 through 2026-09-22 working-tree candidate with MCoreUtils a86e5ed. Current completion requires the pending committed-candidate T1 re-run.

##### GitHub Projection

Title: MCoreUtils ships .debug_info under the gz flavor
Labels: bug
GitHub Milestone: 1.4.0
Observed State: closed
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
Observed State: closed
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-21; PR #70 merged into release-1.4.0 and cross-referenced; #71 open

#### M6 - Global iocsh

Origin: 1.4.0 / M6
Identity History: none
GitHub Issue: #72, https://github.com/jeonghanlee/EPICS-env/issues/72
Status: Complete

##### Summary

Define a single global iocsh that every IOC sources once to start caPutLog, linStat, reccaster (recsync), and autosave with the common defaults. Serial parameter setup is optional and applies only to ports already created and explicitly supplied by the IOC (D17). linStat defaults to host and IOC process statistics; NIC and filesystem monitoring require explicit configuration (D18). Each fragment is developed and validated individually in EPICS-env before integration. The validated fragments and global iocsh are then promoted to the public `commonIocsh` module and reached through `IOCSH_TOP` at `modules/commonIocsh/iocsh/` (D15). Verification covers the standalone fragments, the combined startup, and the installed files without the development checkout.

##### Scope

- Define one global iocsh in EPICS-env that sources caPutLog, linStat, reccaster (`recsync`), and autosave, and optionally loads an IOC-owned serial configuration file whose per-port calls use the common serial helper (D17, D20).
- Use linStat host and IOC process databases by default; load NIC and filesystem databases only for explicitly configured interfaces and paths (D18).
- Preserve the autosave macro names used by the existing executable startup and correct their descriptions (D19).
- Author each covered service's startup in EPICS-env, using the site layer only as a design reference (parameter names, load order); post-iocInit work uses Base's `afterIocRunning` rather than the site layer's before/after iocInit split (D14). The site `siteApps` fragments are Layer 3 internal and absent from the public distribution, so they cannot be a dependency.
- Collect the validated fragments and the global iocsh in one dedicated public module, `commonIocsh` (the public counterpart of the site layer's `siteApps`), held in EPICS-env until tested and then promoted to its own repo, installed under `modules/commonIocsh/iocsh/` and reached by an IOC through `IOCSH_TOP` (D15).
- Add an example IOC in EPICS-env that boots sourcing only the global iocsh for the common services, with real test databases and standalone fragment entry points for verification.
- Supply repeatable standalone, integrated, and installed-path verification, including real log reception, record registration, autosave restart, and serial configuration checks.

Out of scope: iocLog and iocStats; siteApps de-duplication (D16); serial device creation or flow-control extensions; per-service behavior changes beyond the startup composition and defaults specified here.

##### Completion Criteria

- Each covered fragment passes T1 on its own before inclusion in the global iocsh.
- A single global iocsh starts the common services and applies serial settings only when serial configuration is supplied. An IOC without serial configuration boots without requiring a serial port.
- Defaults and explicit parameter overrides produce the expected effects in both standalone and integrated startup. linStat optional databases load only when configured, and autosave retains the macro names in D19.
- The example IOC passes T2, including restart and autosave restoration, using only the global iocsh for common-service startup.
- The installed `commonIocsh` files pass T3 without access to the development checkout or siteApps, on both OS targets (Debian 13 and Rocky Linux 8.10, D21). Every required test has observed evidence; unavailable hardware or services remain Pending.

##### Dependencies And Decisions

- D12 keeps the global iocsh and the example IOC in EPICS-env (layer 1) and expands M6 to supply the service startup where it does not yet exist.
- D13 established the initial service candidates. The current plan includes autosave and optional serial setup under D17-D19; further services require a scope decision. The site layer supplies autosave and serial references, while the linStat fragment is authored from its module databases and example startup.
- Resolved by the site-layer inventory (alsu-site-modules, 2026-09-12): `siteApps` ships a global iocsh and fragments for caPutLog and reccaster but is Layer 3 internal and absent from the public distribution, so M6 cannot reuse it — EPICS-env authors its own, with the site layer as a design reference. linStat has no fragment anywhere.
- D14 uses EPICS Base's `afterIocRunning` iocsh command (libCom, `afterIocRunning.c`) for post-iocInit work: a fragment loaded before iocInit passes its after-init command to `afterIocRunning`, which Base runs at `initHookAfterIocRunning`. This removes the dependency on the std module's `doAfterIocInit()` and the site layer's before/after iocInit split.
- D17 makes serial setup optional within the global startup. Port creation precedes helper execution; D20 resolves the previously open multiple-port representation through an IOC-owned configuration file.
- D18 separates portable linStat defaults from host-specific interface and mount selections.
- D19 preserves the effective autosave interface: the reference startup executes `VALUES_PASS0_PERIOD` and `VALUES_PASS1_PERIOD`, while its comments name `VALUES_PERIOD_PASS0` and `VALUES_PERIOD_PASS1`. Only the new commonIocsh descriptions are aligned here; the site-owned reference is not edited.
- D20 keeps port-specific values in an IOC-owned `.iocsh` file. The global interface takes one optional file path, without adding numbered per-port macros. The reusable helper remains in commonIocsh; the per-IOC configuration is part of the IOC runtime.
- D21 narrows the IOC verification matrix to two OS targets, Debian 13 and Rocky Linux 8.10. The per-fragment T1 assertions, the T1/T2/T3 structure, and the serial cases are unchanged; only the OS breadth is reduced from the seven per-OS CI targets.
- D22 shapes linStat as five commonIocsh-owned fragments: an all-in-one `linStat.iocsh` and per-database Host, Proc, NIC, and FS fragments. Host and Proc load by default; NIC and FS load once per interface or mount through `iocshLoad` behind a `$(XENABLE=#)` line toggle, with the IOC supplying the interface and mount macros. This keeps every fragment in commonIocsh (D15) and follows D20's per-port serial-helper pattern.
- Behavioral prerequisites are linked module support, loadable databases, valid service configuration, writable autosave storage, and existing ports when serial setup is requested. T1 before T2 and T2 before T3 are verification ordering. D16's siteApps de-duplication does not block standalone public-module verification.
- D23 excludes iocStatsAdmin from the global iocsh for the linStat memory-record collision; D24 closes serial physical verification at baud correctness; D25 defers the D15 promotion to Backlog M10, completing M6 on the interim EPICS-env home with T1/T2/T3 verified on the two OS targets (D21).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: owner, 2026-09-15; implementation direction and verification plan with D17-D20
Implementation Authorization: owner, 2026-09-16; implement and verify one service at a time, starting with caPutLog
Superseded Plan Artifacts: the original "consolidate existing per-service fragments" premise (only autosave ships one; D12), the six-service default set (narrowed by D13), and the 2026-09-14 outline expanded here with optional serial setup, explicit linStat defaults, autosave macro compatibility, and T3 installed-path verification

1. Specify each fragment's required parameters, defaults, overrides, module DB/library dependencies, initialization point, and observable test expectations. Use the paths and revisions in Reference Inputs below; read executable statements when comments disagree with them. Apply the IOC-owned serial configuration file interface fixed by D20, and specify the linStat comparison windows and tolerances before running its assertions.
2. Prepare the example IOC, its build/DB/startup files, and verification fixtures in EPICS-env. Link the real module libraries and DBDs; provide a writable test PV, autosave-tagged records, and the databases selected for linStat and reccaster. Prepare a test log server, recceiver, writable autosave storage, and a serial endpoint. Confirm basic IOC startup and PV access before service assertions.
3. Author and hold the service fragments in EPICS-env, completing implementation and T1 for one fragment before the next. Keep caPutLog initialization and autosave runtime work behind `afterIocRunning` (D14). Preserve the D19 macro interface; implement linStat defaults and optional database selection from D18. Apply serial options only to ports supplied by the IOC (D17).
4. Compose the validated fragments into one global iocsh and connect it to the example IOC through `IOCSH_TOP`. The IOC supplies identity, paths, endpoints, and optional device configuration; fragments own their service setup; the IOC owns `iocInit`. Run T2 with the same expectations as T1, including configurations without serial ports and without optional linStat databases.
5. Collect the validated fragments and global startup into `commonIocsh`, promote them to its public repository, pin and install the module through the EPICS-env module configuration, and run T3 using the transfer contents and fresh-VM procedure below. The example IOC and verification fixture sources remain maintained in EPICS-env; their runtime files are exported for T3, without exporting the checkout. Repository publication is a separate execution action governed by the normal Git workflow.
6. Run the required checks for every row in OS Coverage And Equipment below, using the same fixture revision and expectations with each OS's own binaries. Record versions, inputs, observations, and evidence in Verification Results. Complete M6 only when the standalone, integrated, and installed paths have passed on both OS targets (Debian 13 and Rocky Linux 8.10, D21); preserve Pending for checks that could not run.

###### Reference Inputs

Paths in the table are relative to the named repository, not the operator's current directory. The siteApps reference is the repository checked out at `siteApps-src/` under `alsu-site-modules`; its files are design inputs only and are not required on a runtime test VM. The executable startup at the recorded revision defines the retained site defaults. If that revision is unavailable, obtain the recorded source before completing parameter specification; do not substitute another revision silently.

| Input | Repository and fixed revision | Repository-relative path |
| --- | --- | --- |
| caPutLog site defaults | siteApps, `37594135824a110c93ee49ed45a7ba82d3cb5815` | `siteApp/iocsh/caPutLog.iocsh` |
| reccaster site defaults | siteApps, `37594135824a110c93ee49ed45a7ba82d3cb5815` | `siteApp/iocsh/reccaster.iocsh` |
| autosave effective macros and defaults | siteApps, `37594135824a110c93ee49ed45a7ba82d3cb5815` | `siteApp/iocsh/autosave.iocsh` |
| Serial helper defaults | siteApps, `37594135824a110c93ee49ed45a7ba82d3cb5815` | `siteApp/iocsh/setSerialParams.iocsh` |
| linStat database selection and example startup | linStat, tag `1.2.1`, commit `b4729e43c8ee9791975abbc7e06b870f46fb9661` | `README.md`; `iocBoot/iocdemo/st.cmd` |
| Module version selection | EPICS-env, `83f036e5ff4c004768ed4482d3b8d059a6f341a3` | `configure/RELEASE` |
| OS coverage source | EPICS-env, `83f036e5ff4c004768ed4482d3b8d059a6f341a3` | `.github/workflows/debian12.yml`, `debian13.yml`, `ubuntu22.yml`, `ubuntu24.yml`, `rocky8.yml`, `rocky9.yml`, `rocky10.yml`, all under `.github/workflows/` |

The recorded module selection is caPutLog `dafb0b2`, recsync `9834b94`, autosave `R6-0`, asyn `R4-46`, and linStat `1.2.1`. Use the corresponding module checkout for behavior details and record the resolved commit and applied patches in each test run. A later version change requires an explicit update of the reference and expectations. For autosave, enumerate all effective defaults from the recorded executable statements during parameter specification; do not infer additional behavior from comment-only options.

##### Implementation Direction

| Component | Responsibility |
| --- | --- |
| Example IOC | Define IOC identity and runtime paths, create requested device ports, load application records, invoke the global startup once before `iocInit`, and call `iocInit` |
| Global iocsh | Pass parameters to the common-service fragments and load the supplied IOC-owned serial configuration file once before `iocInit`; skip serial setup when the path is omitted |
| IOC-owned serial configuration | Call the common serial helper once per existing port, with explicit per-port parameters; travel with the IOC runtime files |
| Service fragments | Load service databases, apply defaults and overrides, and register service-specific post-init commands |
| commonIocsh | Install the validated global startup and fragments under `modules/commonIocsh/iocsh/` |

Autosave restore registration must precede `iocInit`; all application records must be loaded before request generation. After initialization, generate request files from the real database info fields before starting the corresponding monitor sets. Verify this sequence and macro expansion through the real fragment and `afterIocRunning` path; do not assume that registration alone proves successful execution.

| Fragment | Default behavior and parameter contract |
| --- | --- |
| caPutLog | Require the log destination; preserve `LOG_INET_PORT=7004` and `OPTION=0` from the reference startup; verify an explicit override separately |
| reccaster | Load `reccaster.db` for the configured IOC prefix; preserve `TIMEOUT=5.0` and `MAXHOLDOFF=5.0` |
| linStat | Load host and IOC process statistics by default; select NIC and filesystem databases only for configured interfaces and mount paths |
| autosave | Configure storage and restore passes before initialization; generate requests and start saving afterward; retain `SETTINGS_PERIOD=5`, `VALUES_PASS0_PERIOD=5`, and `VALUES_PASS1_PERIOD=10`, along with the other effective reference defaults |
| Serial helper | Require an existing port only when enabled; preserve baud 9600, 8 data bits, 1 stop bit, and parity none; apply each explicitly configured port's settings independently |

Serial startup order is IOC port creation, global iocsh invocation, optional IOC-owned configuration-file loading, per-port helper calls, then `iocInit`. The IOC passes a path resolved against its deployed runtime configuration; helper calls use `IOCSH_TOP` to reach commonIocsh. An omitted path performs no serial configuration. A supplied file must be readable, and every configured port must exist; failures must be visible and cannot satisfy the serial startup assertions. This path configures existing ports only and introduces no siteApps dependency.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | per-fragment | Start a fresh example IOC process with one real fragment; run the service assertions below for defaults, overrides, and relevant failure cases | Both OS targets (Debian 13 and Rocky Linux 8.10, D21); real module libraries and databases; test log server, recceiver, autosave storage, and serial endpoint | Every fragment produces its specified observable effect, including post-init work and parameter overrides |
| T2 | global iocsh aggregation | Start the example IOC through one global invocation; repeat T1 assertions, then restart; test serial absent/present and optional linStat databases absent/present | Same binaries, fixtures, and expected values as T1 for that OS | All configured services meet the same expectations without duplicate initialization, macro cross-talk, or ordering errors; omitted optional configuration is not required |
| T3 | installed path | Transfer the runtime files listed below into a fresh VM with no source checkout or shared source mounts; repeat standalone and integrated checks | Installed release environment on every OS in the coverage table; physical serial devices and test endpoints as specified below | `IOCSH_TOP` resolves installed fragments; isolation preflight and all T1/T2 assertions pass without development-only dependencies |

###### OS Coverage And Equipment

The two targets below are fixed by D21, narrowed from the seven per-OS CI workflows in Reference Inputs. Those workflows identify the OS set; their existing container builds are not evidence that the new IOC tests or physical serial tests have run. Use an OS-matched x86-64 VM for each target and record the actual point release, kernel, architecture, and installed package versions. T3 uses a fresh VM with the same OS release and runtime packages as that target's T1/T2 environment.

| OS target | Workflow | Required software cases | Required physical serial cases |
| --- | --- | --- | --- |
| Debian 13 | `.github/workflows/debian13.yml` | All T1, T2, T3 software assertions | T1, T2, T3 serial configuration and communication |
| Rocky Linux 8.10 | `.github/workflows/rocky8.yml` | All T1, T2, T3 software assertions | T1, T2, T3 serial configuration and communication |

- For caPutLog and reccaster, provide a dedicated test log server and recceiver reachable from each VM, with captured receiver output and versions. The same external servers may serve sequential OS runs, but use distinct IOC prefixes and output locations to prevent one run's records or logs from satisfying another run's assertions.
- For linStat, use the VM's own host/process observations, a configured loopback interface for the optional NIC case, and a dedicated local test filesystem for the optional filesystem case. Provide VM-local writable storage for autosave, and retain it only for the restart cases within that run.
- For physical serial testing, attach two independently configurable physical serial ports to the IOC VM by device passthrough. Connect each to an independent serial peer that supports the tested baud, bits, stop, and parity settings. Use different settings and payloads on the two paths to detect configuration cross-talk; record adapter/peer models, kernel drivers, wiring, device mappings, and settings. Run both default and override cases. Device/peer selection and connectivity must be confirmed before marking the environment ready.
- The hardware bench may be reused sequentially across both OS targets and their fresh T3 VMs. No result on one OS substitutes for another. Unsupported device passthrough, unavailable peers, or missing test services leave the affected cases Pending; they do not reduce the required matrix.
- Record each service/case separately for every OS and T label. A T1/T2/T3 summary becomes Pass only when every required case for both OS targets has passed. PTY observations may supplement the physical cases but cannot close them.

###### T3 Transfer Contents And Isolation

T3 verifies the runtime installation. The maintained example and test sources stay in EPICS-env, but the following exact classes of runtime files are exported from the same build and fixture revision used for that OS's T1/T2 run. Export existing files; do not regenerate substitute databases, request files, or test expectations for T3.

| Transfer content | Required files or contents |
| --- | --- |
| Installed EPICS environment | Installed Base and module runtime tree, including shared libraries, DBD/DB files, required support files, client tools, and installed `commonIocsh/iocsh/` files |
| Example IOC runtime | OS-specific built executable, generated DBD, installed example databases, standalone/global startup files, and the IOC-owned serial configuration files and any runtime files they load; no application source or build checkout |
| Verification runtime | The same verification scripts, static input fixtures, expected-record/value data, timeout/tolerance definitions, and endpoint configuration used for T1/T2 |
| Provenance and file inventory | Relative paths, SHA-256 hashes of regular files, symlink targets, source/fixture revisions, build/OS identity, original source roots, and runtime package requirements |

1. Create the transfer inventory in the build environment and record all source roots, including EPICS-env, module checkouts, siteApps, and build workspaces. Exclude `.git`, source checkouts, private site startup files, and generated autosave `.req`/`.sav` output from previous runs. The input database info fields travel with the example database; T3 must exercise request generation and saving itself.
2. Provision a fresh VM for the target OS. Do not clone the build VM, mount a developer home or build directory, enable shared folders, or provide SSHFS/NFS/SMB access to source trees. Install the recorded OS runtime packages and transfer only the inventoried files. Network connectivity is for the dedicated test services, not remote source filesystems.
3. Verify transferred file hashes and symlink targets. Resolve symlinks before startup and reject dangling links or targets outside the transferred runtime trees and recorded OS runtime files. Confirm that every recorded original source root is absent from the VM, and capture the VM mount list and resolved runtime paths. Changing the working directory alone does not satisfy this check.
4. Start from a clean process environment, supplying only required OS variables and explicit test configuration. Configure `IOCSH_TOP`, database paths, executable/library paths, and startup working directories against the transferred installation. Do not source developer shell startup or build-environment setup files. Confirm the IOC loads the transferred executable, libraries, databases, and iocsh files.
5. Attach the physical serial devices and connect to the dedicated log server and recceiver. Run the unchanged T1/T2 assertions, including serial absent/present, optional linStat databases absent/present, defaults, overrides, failure cases, and autosave restart. Begin autosave cases with empty runtime storage, then retain only that case's generated files for its restart.
6. Retain the transfer inventory, hash/symlink checks, source-root absence checks, mount list, explicit environment, resolved runtime paths, service observations, and generated request/save output with the OS-specific results. Failure of the isolation preflight prevents a T3 Pass even if service assertions otherwise succeed.

###### T1 Service Assertions

| Service | Real path and fixture | Observable pass condition |
| --- | --- | --- |
| caPutLog | CA put to the shipped example test PV through the real IOC and caPutLog to a test log server | The receiver records the expected PV and value change at the configured destination; defaults and explicit logging options behave as specified |
| reccaster | The real fragment and reccaster publish the example IOC's records to a test recceiver | The receiver contains the expected record names and selected metadata; configured timeout and holdoff values are confirmed separately |
| linStat | The real host/process databases and explicitly selected NIC/filesystem databases read the test host | Required PVs exist and update; measurements agree with OS observations within predefined windows and tolerances; optional records are absent unless configured |
| autosave | The shipped example database info fields feed the real fragment's request generation, monitor sets, save files, and IOC boot-time restore | Generated request membership, saved values, and restored values match independent expectations; fixtures distinguish the configured restore passes and retained period macros |
| Serial helper | The real helper applies settings through the real asyn serial driver to existing test ports | Driver/OS settings match defaults and overrides; a physical serial peer confirms communication with the requested configuration; multiple configured ports retain their own settings |

###### Failure Cases And Evidence

- Exercise relevant missing required parameters, invalid paths, and nonexistent configured ports through the actual startup. The verification must report failure when a required effect is missing, even if the IOC process remains alive.
- For D20, run global startup with the serial file path omitted, with a valid file configuring one port, and with a valid file configuring two ports differently. Verify no serial helper invocation when omitted and the expected independent port settings when present. Also supply a missing/unreadable file and a file naming a nonexistent port: these negative cases pass only when the expected error is observed and successful serial setup is not reported. Repeat these cases using the transferred IOC-owned configuration files in T3.
- Test an autosave storage path that cannot be written and confirm that saving is not reported as successful. First boot without a save file and restart with a generated save file have separate expectations.
- Check startup output for unresolved macros, missing files, duplicate records, and failed post-init commands, and confirm service effects independently of log messages.
- Execute the shipped fragments, IOC, database fixtures, request-generation path, and module libraries. Do not substitute internal functions or generate a replacement request file that bypasses autosave generation. Use dedicated external test endpoints and record their scope.
- A PTY may support a limited software-path check, but it cannot establish physical baud/parity correctness. Keep any hardware assertion not yet run Pending until exercised with a suitable serial endpoint (see Serial Physical Verification for what has run).
- Wait for observable readiness and completion conditions with explicit timeouts. Define timing tolerances before the run; do not change expectations to fit observations.
- Record the EPICS-env and commonIocsh revisions, module versions, OS, input parameters, expected and actual values, IOC output, receiver output, and generated request/save files for each case. Retain failure evidence and report incomplete runs as failures or Pending, never Pass.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-18 (both OS); 2026-09-16 (local caPutLog subset) | Fresh epics-dev VMs (Debian 13, Rocky Linux 8.10, D21); EPICS-env release-1.4.0 (622c464) built from source and installed to `/opt/epics/1.4.0/<os>/7.0.10`; installed `commonIocsh` via `IOCSH_TOP`; `tc32sim` 61645ae and the built example IOC | Pass (software) | All seven services' per-service software assertions pass on both OS via the installed fragments; serial physical baud correctness is separately verified on real hardware (see Serial Physical Verification). See Installed-Path Software Verification below. |
| T2 | 2026-09-18 (both OS) | Debian 13 (local working-tree fragments, 1.3.0 distribution) and Rocky Linux 8.10 (VM, installed 1.4.0); one IOC boots the co-loadable services together | Pass (software) | The aggregate boot passes on both OS: all service records present, `iocInit` completes, no macro cross-talk, no duplicate-record collision, iocLog and caPutLog and autosave coexist, restart restores autosave, and optional NIC/FS/serial omit. iocStatsAdmin is excluded (D23). Serial physical baud correctness is separately verified on real hardware (see Serial Physical Verification). See Integrated Verification below. |
| T3 | 2026-09-21 (both OS) | Fresh epics-dev VMs (Debian 13, Rocky Linux 8.10, D21); after export, all EPICS-env and test-IOC source roots removed; assertions run against installed `commonIocsh` via `IOCSH_TOP` with no rebuild | Pass | Isolation preflight passed (recorded source roots absent, no runtime artifact references them, manifest hashes verified) and the full verification suite passed on both OS with no source tree present. See Isolated-Path Verification below. |

###### Local caPutLog Verification

Implemented files: `commonIocsh/iocsh/caPutLog.iocsh` and `examples/commonIocsh/` (EPICS application build, test database, IOC-owned TRAPWRITE policy, startup, and `verify_caputlog.py`). The fragment accepts required `LOG_INET`, default `LOG_INET_PORT=7004`, and default `OPTION=0`; it registers initialization with `afterIocRunning` before `iocInit`. The example links `base.dbd`, `caPutLog.dbd`, and the real module libraries.

Observed on 2026-09-16: the example built with `CHECK_RELEASE=YES`; the final verifier exited 0 after six cases using the real example IOC, installed test database, Base `caput`, and Base `iocLogServer`. Active cases checked initialization after `iocRun: All initialization complete`, actual received old/new values, and logging of repeated values. No internal function or protocol path was substituted.

| Case | Observed result | Verdict |
| --- | --- | --- |
| Default parameters | Port 7004; changed values 0 -> 17 -> 29 produced two log messages; a repeated put of 17 produced no additional message during the 12-second observation window | Pass |
| Explicit port, OPTION=1 | The selected receiver got three messages, including the repeated value | Pass |
| Explicit port, OPTION=2 | The selected receiver got three messages, including the repeated value | Pass |
| OPTION=-1 | Disabled diagnostic; the test PV accepted a put, with no matching log during the observation window | Pass |
| OPTION=9 | Invalid-option diagnostic and logger not initialized; no matching put log | Pass |
| LOG_INET omitted | Undefined-macro diagnostic and logger not initialized; no matching put log | Pass |

Evidence: `work/m6-caputlog-20260916-run2/summary.json`, `provenance.json`, and each case's `inputs.json`, `ioc.log`, `server.log`, `clients.log`, and `received.log`. Provenance records source/fixture/binary hashes, the linked libraries, OS, and kernel. Re-run the shipped verifier with the built example's Base path and a new output directory, as described in `examples/commonIocsh/README.md`.

Build prerequisite: the inspected Debian 13 distribution's caPutLog `configure/RELEASE` names an obsolete Base 3.15.2 path and fails the normal dependency consistency check. This local run therefore built unmodified caPutLog commit `dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34` under `work/m6-caputlog-support/`, with `configure/RELEASE.local` selecting the distribution's Base 7.0.10. This is a development verification of the fragment, not T3 validation of the distributed caPutLog package. Resolve the installed package's build metadata before attempting that installed-path build; no distribution files were changed here.

###### Installed-Path Software Verification (2026-09-18)

Both epics-dev VMs (Debian 13 and Rocky Linux 8.10, D21) built EPICS-env release-1.4.0 (commit 622c464) from source and installed it to `/opt/epics/1.4.0/<os>/7.0.10`. The installed `modules/commonIocsh/iocsh` holds the twelve fragments, content identical to source, mode 644. With `IOCSH_TOP` pointing at the installed `commonIocsh`, `tc32sim` (61645ae) and the built example IOC ran the fragment verification suite under `examples/commonIocsh/tests/`.

Result: seven services, both OS, all pass - linStat (5), reccaster (2), iocStatsAdmin (4), autosave (2: pass1 and settings), iocLog (1), serial (4, socat PTY software path), caPutLog (3, OPTION 0). The runnable procedure is recorded in `docs/procedures/commonIocsh-verification-procedure.md` (Installed-Path Verification).

Scope and remaining work: this establishes the installed-path software behavior (installed fragments resolve through `IOCSH_TOP`) and the per-service software assertions on both OS. It does not close T3: the VMs carried the build's source tree, from which the test scripts and example-IOC source were run, so the strict no-source-checkout isolation preflight was not established. (The integrated T2 aggregate and serial physical baud correctness were verified separately - see Integrated Verification and Serial Physical Verification.)

###### Integrated Verification (2026-09-18)

One IOC boots the co-loadable services together (iocLog before `iocInit`; caPutLog and autosave through `afterIocRunning`; reccaster, linStat host/proc/NIC/FS, serial). The aggregate passes on both OS - Debian 13 (local working-tree fragments, 1.3.0 distribution) and Rocky Linux 8.10 (VM, installed EPICS-env release-1.4.0): all service records present, `iocInit` completes, record names resolve, no duplicate-record collision, iocLog and caPutLog and autosave coexist, a restart restores the autosave set, and a minimal boot omits optional NIC/FS/serial. The check `examples/commonIocsh/tests/verify_integrated.sh` reports `OVERALL: PASS` (13 checks).

This run surfaced a real collision: linStat and iocStats both define `$(IOC):MEM_USED`, `$(IOC):MEM_FREE`, and `$(IOC):MEM_MAX`, so co-loading them errors on duplicate records. iocStatsAdmin is excluded from the global iocsh (D23), and the check now detects such collisions.

###### Serial Physical Verification (2026-09-19)

Physical baud correctness - which a socat PTY cannot establish - was verified on real hardware, run on the HOME host. There a prebuilt `tc32sim` (asyn-linked) was run against the EPICS 1.3.0 debian-13/7.0.10 installed libraries and bound an asyn serial port to an FTDI FT2232H UART (NANDLAND Go Board, USB 0403:6010, channel B, `/dev/ttyUSB1`), then loaded the shipped `setSerialParams.iocsh`; the log shows the fragment's `asynSetOption` for baud/bits/stop/parity applied on the real port.

At 115200 8N1, a raw paced round trip (3 ms between bytes) of a 31-byte string matched exactly (31/31). In separate runs at 9600/19200/38400/57600 (only the baud varied, framing held 8N1), a shorter burst returned mismatched bytes. Together these show the physical baud rate governs framing, which the PTY path cannot show. Parity was applied by the fragment (none) and the matched case passed, but a parity-mismatch case (for example 8E1) was not exercised; parity is therefore applied-and-matched only, not proven by a mismatch.

The application-level `asynOctet` clean round trip was not achieved (positive 115200: read error at ninp=10; negative 9600: error at ninp=20): this board's echo bitstream is half-duplex and drops bytes on an ungapped burst (a board limitation, not the fragment). It is not pursued further (D24) - the software path and physical baud correctness are sufficient.

###### Isolated-Path Verification (2026-09-21)

Strict T3 ran on a fresh VM per OS (Debian 13, Rocky Linux 8.10). After building the example IOC and the `tc32sim` all-module test IOC, `t3_run.sh` assembled a runtime-only bundle (the example and test IOC runtime plus the verification suite), then removed every EPICS-env and test-IOC source root. The isolation preflight confirmed the recorded source roots absent, no runtime artifact referencing them, and matching manifest hashes.

With no source tree present and no rebuild (SKIP_REBUILD=1), the full suite ran against the installed `commonIocsh` through `IOCSH_TOP`: all eight checks passed on both OS (OVERALL: PASS), confirming the installed fragments resolve and work with no development checkout. Tooling: `examples/commonIocsh/tests/t3_run.sh` and the `SKIP_REBUILD` mode in `common.sh`.

##### Closure Evidence

- caPutLog standalone implementation and local verification are recorded above; the 2026-09-18 installed-path run passed the seven services' software assertions on both OS targets (T1 software Pass), the integrated aggregate passed on both OS (T2 software Pass, iocStatsAdmin excluded per D23; see Integrated Verification), and serial physical baud correctness was verified on real hardware (parity applied and matched only; see Serial Physical Verification), and the installed-path no-source isolation passed on both OS (T3 Pass; see Isolated-Path Verification). A parity-mismatch case and the application-level serial octet echo have no further benefit and are not pursued (D24). M6 completes on the interim EPICS-env home per D25; the D15 promotion of commonIocsh to its public module (public repository and RELEASE pin) is deferred and tracked as Backlog M10.

##### GitHub Projection

Title: Define a global iocsh for standard site services
Labels: enhancement
GitHub Milestone: 1.4.0
Observed State: closed
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-21

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
Observed State: closed
Observed Labels: enhancement
Observed Milestone: 1.4.0
Last Compared: 2026-09-21

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
Observed State: closed
Observed Labels: bug
Observed Milestone: 1.4.0
Last Compared: 2026-09-21

#### M12 - measComp TC-32 Fix Carry

Origin: 1.4.0 / M12
Identity History: none
GitHub Issue: #77, https://github.com/jeonghanlee/EPICS-env/issues/77
Status: In progress

##### Summary

The measComp TC-32 driver takes its thermocouple channel count from `ulAIGetInfo(AI_TC)`, which for a USB TC-32 reports the count including the EXP-32 expansion channels; a base unit without the expansion then sees double the real count. This milestone carries the fix as an EPICS-env patch on the pinned measComp (`c38974e`) until an upstream release adopts it.

##### Scope

- Carry the `measCompApp/src/drvMultiFunction.cpp` fix (for `USB_TC32`, halve the count when `ulDevGetConfig(DEV_CFG_HAS_EXP)` reports no expansion) as `patch/measComp-tc32-chan-count.p0.patch`.
- Wire `patch.measComp.tc32.make/apply/revert` into `configure/RULES_PATCH` and the `patch:` / `patch.revert:` aggregates in `configure/RULES_SRC`, keeping the revert list the exact reverse of apply.

Out of scope: the upstream measComp UI and docs commits between the pin and the fork tip (not the driver fix); production hardware verification, which is owner-run per the upstream-fix verification procedure.

##### Completion Criteria

- The patch applies and reverts cleanly in the `make patch` / `make patch.revert` round-trip.
- The OS-matrix build applies the patch and passes.
- A TC-32 without the EXP-32 expansion reports its base channel count, verified on the production environment per the upstream-fix verification procedure.

##### Dependencies And Decisions

- Source: `jeonghanlee/measComp` branch `tc32-exp-chan-count`, the drvMultiFunction.cpp change over the pin `c38974e`.
- Carried, not bumped: the measComp pin stays `c38974e`; the fix rides as a patch, retired when an upstream measComp release includes it.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: accepted 2026-09-21
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Generate `patch/measComp-tc32-chan-count.p0.patch` from the fork fix (drvMultiFunction.cpp only, p0 no-prefix).
2. Add the `patch.measComp.tc32.*` rules and wire apply/revert into the aggregates.
3. Commit, push, and re-run the OS-matrix CI to confirm the build applies the patch.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Patch round-trip | Apply then revert the patch on the pinned measComp source | Repository checkout | Applies and reverts cleanly; source returns to the pinned state |
| T2 | Build | Build measComp with the patch applied across the OS matrix | OS-matrix CI | Build passes with the patch applied |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-21 | measComp source at `c38974e` | Pass | `patch -p0` applies then `patch -R -p0` reverts to a clean tree; the apply and revert aggregate lists verified exact-reverse |
| T2 | Not run | OS-matrix CI | Pending | pending the CI re-run on the final candidate |

##### Closure Evidence

- None yet; the patch and wiring are prepared and round-trip verified, pending the commit and the OS-matrix build-verify.

##### GitHub Projection

Title: measComp TC-32 doubles the thermocouple channel count without EXP-32 expansion
Labels: bug
GitHub Milestone: 1.4.0
Observed State: open
Observed Labels: bug
Observed Milestone: 1.4.0
Last Compared: 2026-09-21

#### M11 - Release EPICS-env 1.4.0

Origin: 1.4.0 / M11
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

The final release milestone cuts EPICS-env 1.4.0 after its development dependencies and candidate verification are complete. The version is already set to 1.4.0, and the final candidate still requires the M3 gz check and Release Verification 1; this milestone merges the release branch to master, tags and publishes the release, closes the GitHub milestone, and closes out the register.

##### Scope

- Merge `release-1.4.0` into `master` with a no-fast-forward merge and tag the merge commit `1.4.0` (no `v` prefix).
- Publish the GitHub release `1.4.0` from a curated notes body and close GitHub milestone 1.4.0 (number 6).
- Close out the register on master and open the next development cycle separately.

Out of scope: the deferred Backlog work (M5, M8, M10); the pyDevSup contributor PR #70, closed as superseded after the release.

##### Completion Criteria

- `master` carries the `--no-ff` merge of `release-1.4.0`, tagged `1.4.0` at the merge commit.
- The GitHub release `1.4.0` is published as Latest and GitHub milestone 6 is closed.
- The register records the executed release sequence and the next entry point.

##### Dependencies And Decisions

- Depends on M1, M2, M4, M6, M7, and M9 (all Complete), M3 (the MCoreUtils pin, pending gz re-verification), and M12 (the measComp TC-32 carry, in progress).
- The version field `ENV_RELEASE_VERS` was set to 1.4.0 ahead of the release (commit 6b9f165); the release does not re-bump it.
- This repository ships no `CHANGELOG.md`; the release notes body is authored directly.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: accepted 2026-09-21
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Author the release notes body at `work/release-notes-1.4.0.md`.
2. Merge `release-1.4.0` to `master` (`--no-ff`) and tag the merge commit `1.4.0`.
3. Push `master` and the `1.4.0` tag; publish the GitHub release from the notes body.
4. Close GitHub milestone 6; close out the register on master.
5. Close PR #70 as superseded, and open the next development cycle.

##### Integrated Verification

| Source | Trigger | Shared surface | Re-run result |
| --- | --- | --- | --- |
| M1-M4, M6, M7, M9 / per-milestone T1-T3 | the origin/master merge, measComp TC-32 patch, and MCoreUtils pin (build-affecting) | build and install tree | Release Verification 1 |
| M3 / T1 | MCoreUtils pin to a86e5ed replaces the local patch | gz build and installed libmcoreutils.so | M3 / T1 re-run on the new pin, separately from Release Verification 1 |

The candidate has advanced past the earlier CI tip: it now includes the origin/master merge, the measComp TC-32 patch (M12), and the MCoreUtils pin to upstream `a86e5ed` replacing the local patch (M3), all build-affecting. CI on `30ce308` predates the MCoreUtils pin. The OS-matrix CI must therefore re-run on the final candidate, recorded in Release Verification 1. The separate M3 / T1 gz re-run must also pass before release; an ordinary CI build does not establish the absence of `.debug_info`.

##### Production Environment Tests

| System | Version | Arch | Deployment path | Timing | Method | Expected | Label | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| OS matrix (7 targets) | 1.4.0 | linux-x86_64 | clean per-OS build tree | pre-release | per-OS CI build from a clean checkout | build passes on every target | Release Verification 1 | CI run on the build-affecting tip `77d2903` |
| production-equivalent host | 1.4.0 | linux-x86_64 | documented build/install of the `1.4.0` tag | post-release | build the released tag on a clean host | build and install succeed | Release Verification 6 | recorded after release |

##### Version Changes

| File | Field | Before | Release value | Pre-change method | Post-change method |
| --- | --- | --- | --- | --- | --- |
| `configure/CONFIG_SITE` | `ENV_RELEASE_VERS` | prior 1.3.x line | 1.4.0 (applied in 6b9f165) | already applied before this cycle | `grep ENV_RELEASE_VERS configure/CONFIG_SITE` reads 1.4.0 (Release Verification 2) |

##### Release Execution

| # | Target object or path | git-workflow authority | Expected result | Observed identifier |
| --- | --- | --- | --- | --- |
| 1 | `master` no-ff merge of `release-1.4.0` | Release scope | merge commit on master | after execution |
| 2 | annotated tag `1.4.0` at the merge commit | Release scope | tag `1.4.0` | after execution |
| 3 | push `master` and `1.4.0` | Push scope | origin updated | after execution |
| 4 | GitHub release `1.4.0` | Release scope | release published, Latest | after execution |
| 5 | GitHub milestone 6 closed | Release scope | milestone closed | after execution |
| 6 | register close-out commit on master | Commit/add scope | register truthful on master | after execution |
| 7 | next development cycle opened (new dev branch and register restart) | Commit/add scope (branch create plus commit) | next cycle started | after execution |
| 8 | release branch two releases back deleted, local and origin, if present | user-run (branch delete plus push delete) | old branch removed | after execution |
| 9 | PR #70 closed as superseded | user-run (`gh pr close`) | PR closed | after execution |

Plan acceptance never authorizes an execution row; each runs only under its named authority.

Preflight before the release merge: confirm the release branch contains master with `git rev-list --count release-1.4.0..origin/master` returning 0 (check against origin/master, not a possibly-stale local master), and fast-forward local master to origin/master first.

##### Release Verification Plan

| Label | Check | Timing |
| --- | --- | --- |
| Release Verification 1 | OS-matrix CI green on the build-affecting candidate | pre-release |
| Release Verification 2 | `ENV_RELEASE_VERS` reads 1.4.0 | post-change |
| Release Verification 3 | tag `1.4.0` peels to the master merge commit | post-release |
| Release Verification 4 | GitHub release `1.4.0` published and Latest | post-release |
| Release Verification 5 | GitHub milestone 6 closed | post-release |
| Release Verification 6 | documented install of the `1.4.0` tag on a clean host | post-release |

##### Release Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| Release Verification 1 | Not run on the final candidate | OS-matrix CI | Pending | the earlier tip 77d2903 was green; CI on 30ce308 includes the master merge and measComp patch but predates the MCoreUtils pin to a86e5ed, so the final candidate requires a fresh run |
| Release Verification 2 | 2026-09-21 | repository checkout | Pass | `grep ENV_RELEASE_VERS configure/CONFIG_SITE` reads 1.4.0 |
| Release Verification 3 | Not run | git | Pending | none |
| Release Verification 4 | Not run | GitHub | Pending | none |
| Release Verification 5 | Not run | GitHub | Pending | none |
| Release Verification 6 | Not run | clean production-equivalent host | Pending | none |

##### Closure Evidence

- None yet; populated as the release sequence executes and each Release Verification result is observed.

##### GitHub Projection

Title: Release EPICS-env 1.4.0
Labels: none
GitHub Milestone: 1.4.0
Observed State: none
Observed Labels: none
Observed Milestone: none
Last Compared: never

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M5 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m5---epicspath-normalizerelpath) |
| Build | M8 | Teach the module generator the correct per-module source-base URLs | Milestone | Not started | No | | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m8---generator-src-url-overrides) |
| IOC shell | M10 | Promote commonIocsh to its public module repository | Milestone | Not started | No | D15, D25 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m10---commoniocsh-promotion) |

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
GitHub Issue: #75, https://github.com/jeonghanlee/EPICS-env/issues/75
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
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-21

#### M10 - commonIocsh Promotion

Origin: 1.4.0 / M10
Identity History: none
GitHub Issue: #76, https://github.com/jeonghanlee/EPICS-env/issues/76
Status: Not started

##### Summary

The `commonIocsh` fragments and the global iocsh are developed and held in EPICS-env during M6 (D15 interim home). Their durable home is a dedicated public module named `commonIocsh` with its own repository, pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP` (D15). M6 verification is complete on the interim home (T1/T2/T3 on the two OS targets, D21); the promotion itself is deferred to this item per D25.

##### Scope

- Create the public `commonIocsh` repository from the interim in-tree fragments, preserving the `iocsh/` layout.
- Pin `commonIocsh` in EPICS-env's `configure/RELEASE` like every other module and install it under `modules/commonIocsh/`.
- Remove the interim in-tree copy from EPICS-env once the pinned module builds and installs.

Out of scope: any change to the fragment behavior verified under M6; the `siteApps` de-duplication (D16), which is the site owner's.

##### Completion Criteria

- The `commonIocsh` public repository exists and carries the verified fragments.
- EPICS-env pins `commonIocsh` in `configure/RELEASE` and installs it under `modules/commonIocsh/iocsh/`, resolved through `IOCSH_TOP`.
- The interim in-tree fragments are removed, and the installed-path checks (T1/T2/T3) still pass on the two OS targets against the pinned module.

##### Dependencies And Decisions

- D15 sets the durable home: a dedicated public `commonIocsh` module, pinned and reached through `IOCSH_TOP`.
- D25 defers the promotion from M6 to this Backlog item; M6 completes on the interim EPICS-env home.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Create the public `commonIocsh` repository from the interim fragments, preserving the `iocsh/` layout.
2. Pin it in `configure/RELEASE` and build and install it under `modules/commonIocsh/`.
3. Remove the interim in-tree copy from EPICS-env.
4. Re-run the installed-path checks (T1/T2/T3) against the pinned module on the two OS targets.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Pinned-module install | Pin and install `commonIocsh`, remove the interim copy, and run the installed-path suite against the pinned module | Target-OS VMs (Debian 13, Rocky Linux 8.10, D21) | The suite passes against the pinned module with no interim in-tree copy present |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Target-OS VMs | Pending | none |

##### Closure Evidence

- None; deferred to the Backlog per D25.

##### GitHub Projection

Title: Promote commonIocsh to its public module repository
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-21

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-09-09 | `8339edfc0b74fc4953702ac2ec996fc4cf9402dd` (`docs/milestone-1.3.1.md`) |
