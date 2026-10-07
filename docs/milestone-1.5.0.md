# Work Register

Release line: 1.5.0
Milestone index: 1.5.0
Canonical path: `docs/milestone-1.5.0.md`
Canonical branch or ref: `release-1.5.0`
Git upstream: `origin/release-1.5.0`
Remote tracker: `jeonghanlee/EPICS-env`; [1.5.0](https://github.com/jeonghanlee/EPICS-env/milestone/7), number 7, open; observed 2026-10-06T22:12:25Z through `gh api repos/jeonghanlee/EPICS-env/milestones/7`; remote updated_at 2026-10-06T22:10:21Z. Five open issues (#96-#100) are published and all 20 closed Backlog issues are assigned to this milestone.

Next session entry point: Continue M1 source-consumer coverage by obtaining pin-matched Layer 1 sources, then present the complete findings for candidate IN/HOLD decisions. The branch-opening version correction is committed at bc184267f8f796973d033d5b95022f52e1eb9609; its corrected plan and query evidence are recorded here. The 33-module upstream survey, candidate comparison, site-source census, and pinned ADCore assessment are recorded below. The original ADCore checkout remains at its old pin with local configuration changes; use the selected source for eventual rebuild verification. Source-initialization improvements are deferred until after 1.5.0 under D8; M2-M5 remain draft and the survey does not authorize pin edits, patch removal, builds, or release actions.

This is the initial release-line plan. D9 authorizes only the branch-opening version correction; the remaining implementation and release actions require their recorded authority. Its baseline is `4d521e7a0f05163d39541c0357e966397433b027`; the published 1.4.0 tag resolves to `5326c981912566810f763cbe12aba6509bbdb7c4`. Completed changes since 1.4.0 include the installed-module loader, build and environment corrections, two Base site patches, loader fixtures and tests, documentation, and CI changes. They belong in the release comparison and final verification, not new implementation milestones.

This document is the current work register on `release-1.5.0`. The retained `docs/milestone-84ee626.md` is a historical snapshot of master at the baseline commit, not an active plan on this branch. Completed work and its evidence remain there. Seven unfinished work items and the initialization plan gate are retained below in Backlog; the former OPC UA server work continues as M4 with the owner-selected Milo scope. This is a release-branch consolidation, not a modification of the live master branch or a claim that new plans are accepted.

## Milestone

### Release Procedure

This sequence summarizes the work details below. Those details own the plans, authorization, checks, and evidence for each step.

1. **Prepare the release.** Establish `release-1.5.0` and set `ENV_RELEASE_VERS=1.5.0` in `configure/CONFIG_SITE` when the branch opens, before development or integration installs. Use the plain number without `-dev`, because it is an install-path component; review the change for a separate version-only commit under git-workflow. Establish the canonical plan, GitHub milestone, and issues; commit the plan before issue publication. See D9, [Decisions](#decisions), and the GitHub Projection fields in M1-M5.
2. **Survey every module.** Check effective pins and upstream changes, resolve candidate release objects, and compare the release baseline with 1.4.0. Follow [Module Version Bump](procedures/module-bump-procedure.md), stages 1-2; record findings in [M1](#m1---module-survey).
3. **Assess the selected updates.** Inspect actual consumers across all three source layers, compare pyDevSup and pvxs interfaces and build settings, and examine all twelve pvxs carry patches. Follow the module-bump procedure, stages 3-4, and the [Bump obligation](procedures/upstream-fix-carry-procedure.md#bump-obligation); record evidence in [M1](#m1---module-survey).
4. **Decide IN or HOLD.** Present the complete candidate and consumer findings for the owner's decision. Record each decision and the approved verification scope in [M1](#m1---module-survey) before any pin edit.
5. **Implement and verify each change.** Execute the accepted and authorized plans for [pyDevSup (M2)](#m2---pydevsup-update), [pvxs and its carry set (M3)](#m3---pvxs-update-and-patch-reconciliation), and the [Milo example (M4)](#m4---milo-example). Verify patch application and reversion, rebuild actual consumers, and exercise real IOC behavior; record each detail's local test results.
6. **Verify the combined candidate.** Complete M1-M4 and run the integrated code checks and CI in [M5](#m5---final-release), then the install checks on the same combined tree, which already uses the 1.5.0 install path. Build on Debian 12/13, Rocky Linux 8/10, and Ubuntu 24.04/26.04; run the complete loader, fragment, Python support, and Milo data/restart checks on Debian 13 and Rocky Linux 8.10. Preserve the observed evidence in a separately authorized commit.
7. **Prepare the final release candidate.** Write ChangeLog and release notes from the complete source comparison. Confirm the existing 1.5.0 value and installed path, complete documentation and readiness checks, and record the exact verified candidate. Follow M5's Version Changes and Release Verification 1-5; do not defer the branch-opening version correction to this step or change `ENV_RELEASE_VERS` again at release-eve.
8. **Publish the release.** Preview and authorize the exact actions in M5's Release Execution: publish the candidate branch, merge into `master`, create the annotated `1.5.0` tag at the selected release object, push the branch and tag, and publish the GitHub release. Read back each object identity and remote result.
9. **Verify the published version.** Follow M5's Release Verification 6-7. Confirm the remote tag and release target, complete storage preflight, install from the actual released tag in clean Debian 13 and Rocky Linux 8.10 environments, and verify real IOC data paths.
10. **Close the release cycle.** Follow M5's Release Verification 8. Reconcile linked issues and milestone state, recheck the twenty closed Backlog assignments, record retained future work and the next release decision, and commit the completed closure evidence.

Current step: **3 - source-consumer assessment in M1**. Version-only commit bc184267f8f796973d033d5b95022f52e1eb9609 carries the branch-opening 1.5.0 value; the corrected plan and query evidence are recorded in this documentation commit. M2 and M3 both depend on M1; neither has an established dependency on the other. M4 may proceed independently under its own accepted plan and authorization. M5 requires M1-M4 to be complete. M12 and G1 remain in Backlog under D8 and do not block 1.5.0.

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Survey | M1 | Establish module candidates and the release comparison | Milestone | In progress | No | D1, D2 | Complete upstream survey, consumer census, and candidate decisions; [detail](#m1---module-survey) |
| Modules | M2 | Update pyDevSup to 2.1.0 | Milestone | Not started | No | M1 | Exact new source and consumers build and run; [detail](#m2---pydevsup-update) |
| Modules | M3 | Update pvxs and reconcile its carry patches | Milestone | Not started | No | M1 | Every existing carry has a disposition and the updated module and consumers pass; [detail](#m3---pvxs-update-and-patch-reconciliation) |
| OPC UA | M4 | Make Eclipse Milo the primary OPC UA example server | Milestone | Not started | Yes | D3 | Default example, tests, and documentation use the real Milo server; [detail](#m4---milo-example) |
| Release | M5 | Verify and publish EPICS-env 1.5.0 | Milestone | Not started | No | M1, M2, M3, M4 | Combined candidate and actual released objects pass all required checks; [detail](#m5---final-release) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Prepare 1.5.0 on release-1.5.0; preserve the published 1.4.0 objects. | 2026-10-06 |
| D2 | Survey every module, but select only pyDevSup and pvxs for the initial update scope. Keep makeRPath Perl conversion outside 1.5.0. Other updates require a separate scope decision. | 2026-10-06 |
| D3 | Replace the Unified Automation server verification direction with an Eclipse Milo based example, including startup, tests, and documentation. | 2026-10-06 |
| D4 | Move all 20 currently closed Backlog issues to GitHub milestone 1.5.0, preserving their closed state, bodies, labels, and assignees. This is tracker reassignment, not a claim that every fix first ships in 1.5.0. | 2026-10-06 |
| D5 | Add source-version checks and explicit initialization choices to EPICS-env for 1.5.0. Request the same behavior from the support and site repositories through their own owners; do not edit those repositories here. | 2026-10-06 |
| D6 | Keeping the current source displays the required overrides for operator application before configuration and build proceed. Do not write local override files automatically. | 2026-10-06 |
| D7 | With no terminal input and no explicit choice, a source mismatch selects the configured version automatically only when the source is clean. Local changes require an error and stop. | 2026-10-06 |
| D8 | Defer source-initialization improvements until after 1.5.0; retain M12 and G1 in Backlog and preserve D6-D7. EPICS-env implementation and verification precede example delivery to support and site owners. No future release version is assigned. | 2026-10-06 |
| D9 | Correct the branch-opening rule and the stale current value: apply plain ENV_RELEASE_VERS=1.5.0 before development or integration installs, and retain that value through release-eve. This authorizes the configuration and release-plan correction only; commits, pushes, module updates, builds, and release actions retain their separate authority. | 2026-10-06 |

### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| Milo Example | Historical master register M26 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M4, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| EPICS::Path Normalize/RelPath | Historical master register M1 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M6, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| commonIocsh Promotion | Historical master register M3 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M7, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| Global iocsh Startup File | Historical master register M5 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M8, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| Libera Cross-Build And Generated Profile | Historical master register M20 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M9, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| macOS Patch-Revert Verification | Historical master register M21 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M10, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| Upstream Report Of The Base Site Patches | Historical master register M31 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M11, release-1.5.0 | this synchronization commit | this synchronization commit on release-1.5.0; master is unchanged |
| Source Version Checks | docs/milestone-1.5.0.md, Milestone M12 | docs/milestone-1.5.0.md, Backlog M12 | this synchronization commit | this synchronization commit on release-1.5.0; D8 |
| Initialization Plan Acceptance | docs/milestone-1.5.0.md, Milestone G1 | docs/milestone-1.5.0.md, Backlog G1 | this synchronization commit | this synchronization commit on release-1.5.0; D8 |

### Milestone Details

#### M1 - Module Survey

Origin: 1.5.0 / M1
Identity History: none
GitHub Issue: #96, https://github.com/jeonghanlee/EPICS-env/issues/96
Status: In progress

##### Summary

Establish what changed since 1.4.0 and what the two selected upstream updates actually require. A survey result is not authority to update every available module.

##### Scope

Survey all configured modules using `docs/procedures/module-bump-procedure.md`, stages 1-5. Inspect local pin overrides, upstream releases, exact object identities, source changes, build options, and consumers of pyDevSup and pvxs across EPICS-env, EPICS-env-support, and available site module sources. Keep durable candidate and consumer evidence in this detail; scratch logs may live under `work/`. The canonical detail replaces a separate active module-bump planning document.

Out of scope: pin edits, builds, other module upgrades, and makeRPath conversion.

##### Completion Criteria

- Every configured remote has a recorded survey result and observation time; unreachable and indeterminate entries remain explicit.
- Confirm pyDevSup 2.1.0 and select the exact pvxs release from authoritative upstream objects. Do not infer a version from the word "latest".
- Compare pyDevSup `4527ed0` and pvxs `1.5.2` with their candidates, including local fixes and build configuration changes.
- List actual link, header, DBD, and runtime consumers from source. Unavailable layers are explicitly not surveyed, not declared compatible.
- Present each selected candidate's IN/HOLD decision and any required external verification. Reconcile missing mandatory consumer access before declaring readiness.
- Record the 1.4.0-to-candidate module, patch, feature, platform, and user-interface changes.

##### Dependencies And Decisions

D1 and D2. M1 precedes M2 and M3 because their exact source and test scope depend on the census. The proposed working order is M1, M2, M3, M4, M5; M2 and M3 have no established dependency on each other, and M4 can be prepared independently. This order is a proposal, not an invented build dependency.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-06; proceed with the module-bump procedure and the M1 survey scope.
Implementation Authorization: 2026-10-06; execute the survey and source assessment. Candidate decisions and pin edits remain separate.
Superseded Plan Artifacts: none

1. Check the consolidated row/detail pairs and live linked tracker facts before committing the release plan; preserve deferred work and prior evidence.
2. Run `tools/update-release.bash check`, retain its output and exit status, and separately verify release-tag candidates for commit-pinned modules.
3. Read the effective old pins and exact candidate sources. Build the dependent census with both traversal methods required by the module-bump procedure.
4. Inspect public interfaces, build settings, Python requirements, and carried modifications. Record full consumer findings and obtain candidate decisions before pin edits.
5. Update the draft test scope from the observed census and record the final release comparison against 1.4.0.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Survey | Execute the shipped update checker and inspect effective overrides and upstream tag objects | Release checkout and upstream remotes | Every configured module accounted for; exact targets identified |
| T2 | Source | Run both source traversal methods; inspect actual conditional link paths and old-to-new changes | All available consumer source layers | Evidence-backed census and explicit coverage gaps |
| T3 | Scope | Compare 1.4.0 with the release baseline and reconcile candidate decisions | Git objects and canonical details | Complete change categories; no implicit additional upgrades |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-06 | Release checkout and 33 public upstreams | Pass: shipped checker exit 0, 33/33 lookups, 13 updates; 19 commit-pin release inventories checked; selected release identities confirmed | Upstream Survey and Candidate Source Comparison below |
| T2 | Initial census 2026-10-06; latest source assessment 2026-10-07T00:56:39Z | Available Layer 2 sources, separate pinned ADCore source, both configured site source trees, and repository fixtures | Partial: initial census 19 lines, site census 17 lines, and pinned ADCore census 124 lines each agree between methods; pin-matched Layer 1 sources remain unavailable | Consumer Coverage below |
| T3 | 2026-10-06 | 1.4.0 to e8302b7 | Partial: release comparison recorded; candidate decisions await complete consumer coverage | Release Comparison below |

##### Upstream Survey

Observation Date: 2026-10-06. `tools/update-release.bash check` completed with exit 0: 33 attempted, 33 completed, 13 updates. The table records the checker result, not an upgrade decision. Tag pins are compared with release tags; commit pins with branch heads. The supplemental official-release inventory below covers all 19 commit pins. Only the two selected candidates receive immutable source comparison in this scope; a latest published release is not automatically newer than an existing commit pin.

The effective pyDevSup tag/version are `4527ed0` / `4527ed0`; pvxs is `tags/1.5.2` / `1.5.2`, confirmed with the four `make print-SRC_TAG_*` / `print-SRC_VER_*` queries. The sibling local override sets only an EPICS Base path; no checkout-local `configure/RELEASE.local` exists. No module pin override was found.

| Module key | Current pin | Survey target | Result |
| --- | --- | --- | --- |
| BASE | tags/R7.0.10 | tags/R7.0.10 | Current at surveyed ref |
| RETOOLS | 5ada1e1 | 5ada1e1 | Current at surveyed ref |
| RECSYNC | 9834b94 | 6494fca | Update available |
| SNCSEQ | tags/R2-2-9 | tags/R2-2-9 | Current at surveyed ref |
| ETHERIP | tags/ether_ip-3-10 | tags/ether_ip-3-10 | Current at surveyed ref |
| IOCSTATS | tags/4.0.1 | tags/4.0.1 | Current at surveyed ref |
| MCOREUTILS | a86e5ed | a86e5ed | Current at surveyed ref |
| CAPUTLOG | dafb0b2 | 6f9eb3f | Update available |
| AUTOSAVE | tags/R6-0 | tags/R6-0 | Current at surveyed ref |
| CALC | 4217e83 | 59d1fe5 | Update available |
| SSCAN | e13699e | ce9660c | Update available |
| ASYN | tags/R4-46 | tags/R4-46 | Current at surveyed ref |
| LUA | 17475b5 | ada11c0 | Update available |
| MODBUS | tags/R3-4 | tags/R3-4 | Current at surveyed ref |
| STD | 5f2e442 | 27b6967 | Update available |
| BUSY | 2dfe92d | a4a272d | Update available |
| SCALER | beb5521 | baa8e1c | Update available |
| MCA | 687d563 | 687d563 | Current at surveyed ref |
| MEASCOMP | c38974e | 9c8e01e | Update available |
| STREAM | tags/2.8.26 | tags/2.8.26 | Current at surveyed ref |
| SNMP | tags/v1.1.0.4ja | tags/v1.1.0.4ja | Current at surveyed ref |
| OPCUA | tags/v0.11.2 | tags/v0.11.2 | Current at surveyed ref |
| MOTOR | 285f44d | 47893ed | Update available |
| MOTORSIM | tags/R1-3 | tags/R1-3 | Current at surveyed ref |
| PYDEVSUP | 4527ed0 | b5cef38 | Update available |
| PCAS | e075fd4 | bdf2b0a | Update available |
| PVXS | tags/1.5.2 | tags/1.5.3 | Update available |
| PMAC | 2-7-9 | 2-7-9 | Current at surveyed ref |
| PSCDRV | 276daca | 276daca | Current at surveyed ref |
| LINSTAT | tags/1.2.1 | tags/1.2.1 | Current at surveyed ref |
| FEEDCORE | 0472d88 | 0472d88 | Current at surveyed ref |
| QPC | 913fad4 | 913fad4 | Current at surveyed ref |
| RGAMV2 | 27fc633 | 27fc633 | Current at surveyed ref |

##### Commit-Pin Release Inventory

Observed 2026-10-06 through each public upstream's `releases/latest` endpoint. A 404 was followed by a `tags?per_page=5` read. Tag samples are not ordered release decisions; no published release is distinct from no tags. No outside-scope candidate is selected by this inventory.

| Module key | Latest published release / tag observation |
| --- | --- |
| RETOOLS | R1-4-1 |
| RECSYNC | 1.10.0 |
| MCOREUTILS | 1.2.3 |
| CAPUTLOG | R4.2 |
| CALC | R3-8 |
| SSCAN | R2-12 |
| LUA | R3-1 |
| STD | R3-6-4 |
| BUSY | R1-7-4 |
| SCALER | 4.1 |
| MCA | No published release; first five tags are historical synApps tags; no release candidate selected |
| MEASCOMP | No published release; sample includes R4-3, R4-2, R4-1 and historical synApps tags |
| MOTOR | R7-4 |
| PYDEVSUP | 2.1.0; exact source resolved below |
| PCAS | v4.13.3 |
| PSCDRV | No published release; tag atf-20250728 |
| FEEDCORE | No published release or tags |
| QPC | No published release or tags |
| RGAMV2 | No published release or tags |

##### Candidate Source Comparison

| Module | Old source commit | Candidate tag and commit | Observed change |
| --- | --- | --- | --- |
| pyDevSup | 4527ed055a472d4688846a2cb64ac593fec1ecbb | 2.1.0, b5cef38a6d9f74f9c59f967185ba6d1940637c03 | Only `CHANGELOG.md` added: 167 lines. No executable source, header, build configuration, Python requirement, or existing fix differs from the current pin. |
| pvxs | 8e00eaecdee5ce8a474704e70d820e6f92693fa1 | 1.5.3, 25ca43df4db909c0b1a445fb705fc81582617625 | 72 files changed, 2439 insertions and 342 deletions; includes the twelve carried commits and further functional changes. |

Source identities were resolved with `git rev-parse '<tag>^{commit}'` in separate upstream clones. Comparisons used explicit old and release refs, not the clone's default branch HEAD. Official releases: https://github.com/epics-modules/pyDevSup/releases/tag/2.1.0 (published 2026-10-05T23:42:00Z) and https://github.com/epics-base/pvxs/releases/tag/1.5.3 (published 2026-09-29T00:08:23Z).

pyDevSup's unchanged documentation requires Python >= 3.6 and NumPy. A pin-only source change is supported by the diff, but installed paths, rebuilt identity, Python IOC startup, and record processing still need the M2 checks.

pvxs public-header changes are confined to `src/pvxs/data.h`, `src/pvxs/source.h`, and new `src/pvxs/json.h`. Existing public signatures show no removal in the inspected diff; `TypeCode::valid()` gains its export annotation and JSON adds a new interface. This static finding is not an ABI or runtime pass. Additional verification obligations are:

- CLI options must precede positional arguments; `tools/cliutil.cpp` stops option parsing after the first positional argument. `pvxput` adds JSON parsing. Check existing scripts plus actual read/write/monitor commands.
- `ChannelControl::onClose()` alone no longer claims a channel (`src/serverchan.cpp`); a GET/RPC/MONITOR handler is required. Recheck custom sources and callback lifetimes.
- `ConnectOp::connect()` no longer synchronizes with the worker thread; shared-PV subscription tracking changes. Exercise server startup, subscriptions, cancellation, and shutdown.
- IOC changes include monitor timestamp masking, non-PP `+type:"proc"` handling, display precision, and publishing the actual server TCP port. Exercise loader and IOC data paths on the combined tree.
- Build setup adds `setup2` to enforce configuration-install order. CLI tools require Base >= 3.15, which the pinned 7.0.10 satisfies. Python packaging now requires >= 3.8; distinguish that packaging route from the native EPICS Make build.

##### Existing pvxs Carry Assessment

For each actual patch file, `git patch-id --stable` matched the originating upstream commit diff; `git merge-base --is-ancestor <commit> 1.5.3` returned 0. All twelve original changes are in the candidate's history. This establishes provenance and inclusion, not that later changes preserve every behavior; patch retirement remains an M3 change after the candidate decision and final-source examination.

| Patch file | Upstream commit | Ancestor of 1.5.3 | Stable patch ID | Disposition |
| --- | --- | --- | --- | --- |
| `1.5.2-01-086501a-pvxmonitor-conn-ts.p0.patch` | 086501a | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-02-090bf5f-cli-flush.p0.patch` | 090bf5f | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-03-7490286-pvalink-seq-point.p0.patch` | 7490286 | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-04-0b3fcca-cli-dtor-order.p0.patch` | 0b3fcca | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-05-084336b-client-retry-slowdown.p0.patch` | 084336b | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-06-9a6b4cc-oncreate-log-deescalate.p0.patch` | 9a6b4cc | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-07-39cc6fa-infoop-early-dtor.p0.patch` | 39cc6fa | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-08-c969383-clientmon-cb-guard.p0.patch` | c969383 | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-09-c17812a-clientget-cb-guard.p0.patch` | c17812a | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-10-eab3275-clientdiscover-cb-guard.p0.patch` | eab3275 | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-11-d5ecc88-clientintrospect-cb-guard.p0.patch` | d5ecc88 | Yes | Match | Candidate for retirement; final source and runtime checks remain |
| `1.5.2-12-cc7bc72-synccancel-diag.p0.patch` | cc7bc72 | Yes | Match | Candidate for retirement; final source and runtime checks remain |

##### Consumer Coverage

The initial census on 2026-10-06 searched source, headers, Makefiles (including `commonDriverMakefile`), database/DBD files, IOC startup fragments, and Python files using both ignore-disabled ripgrep and `find` plus `grep`. On the then-available source roots both returned the same 19 lines. This agreement checks traversal only; source coverage and pin identity still require the checks below.

Source inventory rechecked at 2026-10-07T00:31:38Z by reading each environment's `configure/RELEASE`, checking its module source directories, and resolving source HEAD and the configured pin with `git rev-parse`, followed by `git status --porcelain`. The current release checkout has 0/33 configured source directories, EPICS-env-support has 4/4, and the site module environment has 2/2. Both site sources match their configured tags and have clean working trees. Their source-consumer census is recorded below.

Site source census observed at 2026-10-07T00:48:11Z. Source HEADs still matched the two configured tags and both working trees were clean before and after inspection. Ignore-disabled, hidden-file-inclusive `rg --files` and `find -type f` returned the same 249 regular files outside `.git`; no symbolic links were present. Case-insensitive `rg -n --no-ignore --hidden --no-heading` and `find` plus `grep -IHniE` searched all non-binary file types with `pvxs|pydevsup|devsup|softiocpy|softiocpvx|p4p|python|qsrv` and returned the same 17 matching lines. Inspection classified four as commented PVXS configuration, three as an unrelated C++ device-support variable, and ten as unrelated Python script, documentation, or regular-expression references. The relevant Makefiles, environment configuration rules, and Python imports showed no direct pyDevSup or pvxs link, header, DBD, or startup consumer. One site module installs database and IOC startup fragments; the other's libraries link EPICS Base and a bundled regular-expression library. This is a source finding; installed loader behavior and IOC runtime have not been verified.

| Layer / surface | Observed consumers | Coverage and remaining check |
| --- | --- | --- |
| EPICS-env module sources | No build-order dependency names pyDevSup or pvxs in `configure/CONFIG_MODS_DEPS` | Original module source trees are absent. A build-order declaration is not a complete source census; obtain sources before declaring coverage. |
| EPICS-env installed loader | `tools/iocsh.bash` launches `softIocPVX`; metadata scans `pvxsIoc.dbd`; `configure/CONFIG_MODS_IOCSH` names `pvxs` and `pvxsIoc` | Full loader/metadata/ELF and fixture suites remain required. pyDevSup has no loader library/DBD entry; test its own Python IOC path. |
| EPICS-env-support | At configured ADCore pin `ee039d2`: `NDPluginPvxs` uses server, SharedPV, NTNDArray, and IOC singleton interfaces; `ntndArrayConverterPvxs` uses `pvxs/data.h` and links pvxs | `conf.ADCore` enables `WITH_PVXS = YES`. Both common driver and library Makefiles link `pvxs`, `pvxsIoc`, and `ntndArrayConverterPvxs`; driver DBDs include PVXS support. The pinned source census is complete in a separate clean checkout. Rebuild and exercise the selected source; the original checkout remains at its old pin. |
| EPICS-env-support transitive consumers | ADSimDetector, ADGenICam, ADVimba depend on ADCore; ADVimba also depends on ADGenICam | All four source trees are present. These three consumers match their configured pins; all four trees have existing local modifications. No pyDevSup use was found in the initial searched file classes. Consumer relink/startup remains unexecuted. |
| Site module layer | Both configured source trees match their pins; no direct pyDevSup or pvxs consumer found | Source census complete for these two trees: identical 249-file inventories and 17 inspected matching lines. Shared installed-loader behavior and IOC runtime remain unverified; this finding does not complete M1 coverage. |

Layer 2 environment source recorded for the initial census: commit 2fcf46ca5756b58b19453ac9bde31352c05cdfbb. The original ADCore checkout remains at commit 72593ed7ed6407c58ae387c3e58cfa8a33217b54 with a pre-existing local `configure/CONFIG_SITE` modification. The initial ADCore findings describe that checkout. Its HEAD, working-tree status, and configuration file hash were unchanged by the assessment below; existing sibling sources and pins were preserved.

Pinned ADCore assessment observed at 2026-10-07T00:56:39Z against Layer 2 environment commit 06c8da480bc0287bd181b574d6391b43ded23a28. Its configured `ee039d2` resolves to official upstream commit ee039d24c9e89e70b31fd383b4817a40db5d6395, confirmed through `repos/areaDetector/ADCore/commits/ee039d2` and a separate clone of `areaDetector/ADCore`. Configuration commit 7fe14ee changed the previous pin `72593ed` to `ee039d2`. `configure/RULES_MODS` skips both clone and checkout when the source directory already exists, so `init` does not align an existing source with a changed pin. The observed old HEAD is consistent with that skip rule; a particular initialization run or build using the new source has not been verified.

The separate assessment checkout resolved HEAD to the full configured source commit and had a clean working tree. Ignore-disabled, hidden-file-inclusive, case-insensitive `rg` and `find` plus `grep -IHniE` searched all non-binary file types outside `.git` with `pvxs|pydevsup|devsup|softiocpy|softiocpvx|p4p` and returned the same 124 matching lines. No pyDevSup or Python IOC reference matched. Reading the conditional Makefiles and source confirmed the plugin and converter as direct pvxs consumers; the existing `adcore-libxml.p0.patch` touches only `NDFileHDF5LayoutXML.cpp` and does not remove either consumer from the build.

The original source commit is an ancestor of the configured pin. Their comparison covers 76 files, 4131 insertions, and 1722 deletions. Relevant changes include explicit `pvxsIoc` and `pvxs` entries added to `ADApp/commonLibraryMakefile`, Linux-specific C++11 flags for `NDPluginPvxs`, and removal of the converter's `pv/pvIntrospect.h` include with numeric type-code mapping and a range check. These findings update the source and link assessment, not an API/ABI or runtime pass. The selected ADCore source, converter, plugin, and three transitive consumers still require coherent rebuild, relink, and IOC data checks during the module verification scope. Building the unchanged original checkout would not verify the configured pin.

##### Release Comparison

`git diff 1.4.0..e8302b7` covers 150 changed files. `configure/RELEASE` has twelve added per-module source-base assignments but no module tag/version changes. Existing release content includes the installed-module loader and its metadata/ELF tools; configuration, dependency, clean/uninstall/revert and environment corrections; two Base site patches; common IOC fragment corrections; loader fixtures and verification scripts; rewritten operator documentation; and a six-Linux-target CI set (Debian 12/13, Rocky 8/10, Ubuntu 24.04/26.04). Historical milestone records and release-planning documents are documentation changes, not additional runtime features.

No candidate IN/HOLD decision has been recorded. The other eleven changed upstreams are outside the selected update scope. Missing source coverage and candidate decisions remain M1 work; no build or runtime check has run during this survey.

##### Closure Evidence

None. The earlier baseline comparison does not complete the candidate survey.

##### GitHub Projection

Title: Survey module changes for EPICS-env 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-06T22:10:07Z
Last Compared: 2026-10-06T22:12:25Z; metadata read through `gh api 'repos/jeonghanlee/EPICS-env/issues?milestone=7&state=all&per_page=100'`; published title, body, state, labels, assignee, and milestone were verified against the prepared draft after creation.
Prepared Body: `work/issue-150-survey.md`
Publication: Complete. Created after canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77; issue creation does not establish plan acceptance or implementation completion.


#### M2 - pyDevSup Update

Origin: 1.5.0 / M2
Identity History: none
GitHub Issue: #97, https://github.com/jeonghanlee/EPICS-env/issues/97
Status: Not started

##### Summary

Move the pyDevSup pin from `4527ed0` to release 2.1.0 after verifying that the candidate includes the required existing changes.

##### Scope

Update `SRC_TAG_PYDEVSUP` and `SRC_VER_PYDEVSUP` in `configure/RELEASE`, affected current documentation, and only configuration changes justified by the source assessment. Rebuild actual consumers found by M1.

Out of scope: assuming that a version-only edit proves runtime compatibility; unrelated Python or module upgrades.

##### Completion Criteria

- The checkout and installed identity match the approved upstream object, not a stale source directory.
- Existing required fixes are present or explicitly carried under the repository procedure.
- The module, its census consumers, and representative Python device-support IOC pass real build, link, startup, and record-processing checks on all six supported OS targets.

##### Dependencies And Decisions

M1 supplies the approved source and consumer census. Any unexpected dependency upgrade returns for a scope decision.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Apply the approved pin and documentation changes after the M1 IN decision and implementation authority.
2. Follow the shipped module-bump procedure with an isolated candidate source and install tree; verify source HEAD before building. Do not delete an existing source or evidence tree implicitly.
3. Run dependency audits, rebuild consumers, and exercise actual Python device support using upstream or existing shipped fixtures selected from the census.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Inspect effective pins, source HEAD, installed paths, and required fixes | Candidate checkout and installation | Exact approved 2.1.0 source and matching installed identity |
| T2 | Build | Real configuration, dependency audit, build, install, consumer relink, check.deps and check.env | Six supported Linux OS targets | All required builds and installed-tree checks pass |
| T3 | Runtime | Start a real Python device-support IOC and exercise its records and required consumer paths | Six supported Linux OS targets | Python imports, device support, and observable record behavior pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Candidate tree | Pending | none |
| T2 | Not run | Six Linux OS targets | Pending | none |
| T3 | Not run | Six Linux OS targets | Pending | none |

##### Closure Evidence

None.

##### GitHub Projection

Title: Update pyDevSup to 2.1.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-06T22:10:10Z
Last Compared: 2026-10-06T22:12:25Z; metadata read through `gh api 'repos/jeonghanlee/EPICS-env/issues?milestone=7&state=all&per_page=100'`; published title, body, state, labels, assignee, and milestone were verified against the prepared draft after creation.
Prepared Body: `work/issue-150-pydevsup.md`
Publication: Complete. Created after canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77; issue creation does not establish plan acceptance or implementation completion.


#### M3 - pvxs Update And Patch Reconciliation

Origin: 1.5.0 / M3
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98
Status: Not started

##### Summary

Update pvxs from 1.5.2 to the exact release selected in M1 and account for all twelve current carry patches.

##### Scope

Inspect `patch/1.5.2-*.p0.patch`, `patch/README.md`, the historical carry evidence in `docs/archive/pvxs-carry-1.3.0.md`, and the patch selection rules. Update pins, required surviving patches, active patch documentation, and affected loader test expectations. Apply the Bump obligation in `docs/procedures/upstream-fix-carry-procedure.md` before patch changes.

Out of scope: blindly renaming patches to a new version prefix, assuming a clean apply proves necessity, or changing Base patches as part of this bump.

##### Completion Criteria

- All twelve carries have source-backed dispositions: included upstream, still required, or superseded with a stated reason and owner decision.
- No required fix disappears merely because the version-prefixed patch glob no longer matches.
- The actual patch and reverse-patch path works for the selected carry set, and active README rows and test expectations match it.
- pvxs and census consumers build and start on all six OS targets; real CA/PVA and loader checks exercise the selected installed libraries.

##### Dependencies And Decisions

M1 supplies the exact candidate and consumer census. The loader invokes pvxs softIocPVX, so this change invalidates earlier loader runtime results for the final candidate.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Build a twelve-row carry assessment with original fix, candidate source evidence, proposed disposition, and verification method; obtain decisions on unresolved alternatives before deletion or modification.
2. Change the pin and approved carry set together with `patch/README.md` and affected tests. Retain historical evidence in Git.
3. Exercise real shipped patch apply/revert and build/install rules in an isolated candidate; verify dependency and ELF metadata against actual artifacts.
4. Rebuild consumers and run pvxs upstream tests, representative IOC and CLI read/write/monitor paths, and the installed-module loader suite.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Carry | Compare each of twelve fixes with candidate source and execute shipped patch apply/revert | Candidate source and repository rules | Every fix accounted for; applicable carry set applies and reverts correctly |
| T2 | Build | Full real build/install, upstream tests, census consumer relink/startup, check.deps and check.env | Six supported Linux OS targets | Correct source and installed library identities; no failed required checks |
| T3 | Runtime | Real pvxs client/server operations and examples/iocsh/tests/run_all.bash against installed candidate | Debian 13 and Rocky Linux 8.10 | Loader, CLI, application data paths, and failure diagnostics match the accepted contract |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Candidate source | Pending | none |
| T2 | Not run | Six Linux OS targets | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

None.

##### GitHub Projection

Title: Update pvxs and reconcile its carry patches
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-06T22:10:14Z
Last Compared: 2026-10-06T22:12:25Z; metadata read through `gh api 'repos/jeonghanlee/EPICS-env/issues?milestone=7&state=all&per_page=100'`; published title, body, state, labels, assignee, and milestone were verified against the prepared draft after creation.
Prepared Body: `work/issue-150-pvxs.md`
Publication: Complete. Created after canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77; issue creation does not establish plan acceptance or implementation completion.


#### M4 - Milo Example

Origin: 84ee626 / M26
Identity History: Historical M26 continues as 1.5.0 M4 on 2026-10-06 with the owner-selected Milo scope; original unexecuted Unified Automation checks remain historical and are not passes
GitHub Issue: #99, https://github.com/jeonghanlee/EPICS-env/issues/99; related application work: jeonghanlee/opcua-IOC-demo#1 (open, observed 2026-10-06)
Status: Not started

##### Summary

Make the existing Eclipse Milo integration the primary OPC UA example and remove the Unified Automation server requirement from the release's example verification.

##### Scope

Adapt `examples/iocsh/opcua-IOC-demo/` startup and preparation, `examples/iocsh/tests/verify_fixture_opcua.bash`, the suite expectations, and the related README and book pages. Use a real open-source Milo server with an exact reproducible image identity and documented node mappings.

Out of scope: implementing a server that imitates Unified Automation nodes, acquiring its proprietary example server, or silently expanding into an opcua/open62541 version upgrade.

##### Completion Criteria

- The documented default startup connects to Milo and uses real supported nodes; preparation needs no proprietary server files.
- Tests check server identity, device support, subscription updates, values, timestamps, alarms, and bounded reads through the installed opcua module and native IOC.
- Measure IOC restart without server restart and server stop/start. The existing README and test expect INVALID/COMM on the second session; do not silently treat that as successful normal operation. If it persists, present the observed cause and a bounded correction or explicit accepted restart limitation before closure.
- Startup paths, example commands, suite counts, and documentation agree. Decide whether to retain a compatibility entry for `st-milo.cmd` before removing or changing its interface.
- Preserve the historical M26 evidence and the superseded server requirement without claiming its unexecuted original-server checks passed.

##### Dependencies And Decisions

D3. Development can proceed independently of M2/M3; acceptance against the final combined tree belongs to M5. The source work is `docs/milestone-84ee626.md` M26 at baseline `4d521e7a0f05163d39541c0357e966397433b027`; its release-branch continuation is recorded below; no original-server test is claimed as passed.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: docs/milestone-84ee626.md M26 at 4d521e7a0f05163d39541c0357e966397433b027

1. Inspect the existing Milo variant and select a reproducible server artifact; retain source and license provenance. Reproduce the documented restart behavior before selecting its treatment.
2. Make Milo the default example, align preparation with the real nodes and templates, and settle the compatibility-path choice.
3. Revise the real fixture tests, cleanup ownership, expected results, README, and book together. Use run-owned container identities and preserve unrelated running containers.
4. Run the documented procedure and suite on both runtime targets, including the restart cases, then record the accepted outcome and source-assignment transition.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Preparation | Execute shipped prepare.bash and default startup with the pinned real Milo server | Debian 13 and Rocky Linux 8.10 | Reproducible preparation and connected IOC without proprietary server dependency |
| T2 | Data | Read server identity and real dynamic records twice; observe subscriptions, values, timestamps, alarms, and read duration | Both runtime targets | Correct server, NO_ALARM and advancing values/timestamps; reads within documented bounds |
| T3 | Recovery | Restart IOC without restarting server, then stop/start server and observe alarm/recovery | Both runtime targets | Accepted recovery behavior or explicitly approved measured limitation; no assumed success |
| T4 | Documentation | Execute published example commands and the revised shipped fixture suite | Both runtime targets and documented mdBook image | Examples, expected counts, test outcomes, and book agree |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Both runtime targets | Pending | none |
| T2 | Not run | Both runtime targets | Pending | none |
| T3 | Not run | Both runtime targets | Pending | none |
| T4 | Not run | Runtime targets and book build | Pending | none |

##### Closure Evidence

None. Earlier Milo observations establish planning context only.

##### GitHub Projection

Title: Use Milo as the default OPC UA loader example server
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-06T22:10:17Z
Last Compared: 2026-10-06T22:12:25Z; metadata read through `gh api 'repos/jeonghanlee/EPICS-env/issues?milestone=7&state=all&per_page=100'`; published title, body, state, labels, assignee, and milestone were verified against the prepared draft after creation.
Prepared Body: `work/issue-150-milo.md`
Publication: Complete. Created after canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77; issue creation does not establish plan acceptance or implementation completion.


#### M5 - Final Release

Origin: 1.5.0 / M5
Identity History: none
GitHub Issue: #100, https://github.com/jeonghanlee/EPICS-env/issues/100
Status: Not started

##### Summary

Verify the combined 1.5.0 candidate, publish separately authorized release objects, and verify the actual published version before closure.

##### Scope

Release comparison, branch-opening version checks, integrated re-runs, six-OS builds, two-target full runtime suites, final version and install-path consistency, documentation, publication, clean installation from the released object, and final tracker and cycle reconciliation.

Out of scope: source-initialization improvements deferred under D8, makeRPath conversion, unselected module updates, rewriting 1.4.0 objects, or treating CI builds alone as IOC runtime evidence.

##### Completion Criteria

- M1-M4 are complete with reachable evidence; any required external verification has a completed explicit gate.
- Every final check below has an observed Pass; missing environments or access remain Pending and cannot be counted as success.
- Release actions name exact immutable targets and their own authorization; the released tag is not moved to include later closure evidence.
- The canonical records, optional tracker projections, release notes, and next entry point agree.
- All 20 issues in the closed-Backlog inventory below are assigned to milestone 1.5.0 and remain closed; original completion evidence and first-release history remain unchanged.

##### Dependencies And Decisions

M1-M4 and D1-D4; D8 excludes initialization improvements from this release and D9 governs the branch-opening version correction. Local T results require the applicable re-run when a later change invalidates the behavior they checked. The release number affects install-path assertions; a number-only correction does not itself invalidate code checks.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: 727b966e6030ebbb9dea52faa7eb09cc4b518fd4, docs/milestone-1.5.0.md / M5, release-eve version timing; D9 corrects that timing only.

1. Confirm the branch already carries `ENV_RELEASE_VERS=1.5.0` and the separately authorized version-only commit. Accept the remaining cycle and work plans, verify the register consolidation and settle remaining choices, and commit the complete plan through git-workflow before any tracker mutation.
2. Complete M1-M4 and update integrated re-run requirements for actual changed surfaces.
3. Run and record integrated code verification and CI against the combined candidate, then install verification on that same tree and its existing 1.5.0 path. Preserve the results in a separately authorized evidence commit. Reuse CI evidence only when the pipeline's unchanged-code conditions hold; any required code change invalidates affected evidence. Final readiness carries no new `ENV_RELEASE_VERS` mutation.
4. Prepare release notes from the complete 1.4.0-to-candidate comparison and preview exact release commands. Publishing requires separate authority.
5. Verify released objects and clean installations using release-cycle storage preflight before fresh verification clones. Record exact filesystem, destination, clone mode, refspecs, storage bounds, and free-space reserve.
6. Reconcile source records and tracker state, record the next-line decision, and commit final closure evidence without altering the release tag.

##### Closed Backlog Issue Reassignment

Decision: D4. Move #63, #69, #75, #78, #80, #81, #82, #83, #84, #85, #86, #87, #88, #89, #90, #91, #92, #93, #94, #95 from GitHub milestone Backlog (number 3) to 1.5.0 (number 7). This is the full set of 20 closed issues returned by the paginated REST query on 2026-10-06T20:49:56Z; pull requests are excluded. The same query was re-run before execution and confirmed the 20-issue batch. Target milestone 7 was verified open at the same observation time.

After canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77, all 20 issues were reassigned through `gh issue edit --milestone 1.5.0`. Readback confirmed every issue remained closed in milestone 7. Before/after comparisons matched titles, bodies, states, closure reasons, closure times, labels, assignees, and comment counts for all 20 issues; no unrelated issue metadata changed. The open Backlog issues #25, #76, and #79 are excluded. A newly discovered issue is outside this observed batch until the inventory is reconciled.

Prepared commands: `work/issues-150-move-closed.txt`. Execution result: Complete on 2026-10-06. All 20 assignments were re-observed at 2026-10-06T22:12:25Z through `gh api 'repos/jeonghanlee/EPICS-env/issues?milestone=7&state=all&per_page=100'`. Post-move verification found zero closed issues remaining in Backlog. Check the assignments again in Release Verification 8. Reassignment does not establish that an issue's implementation first appears in 1.5.0; derive release notes from the actual source comparison.

##### Integrated Verification

| Source Check | Re-run Trigger | Shared Surface | Release Verification Label | Expected Result | Result Evidence |
| --- | --- | --- | --- | --- | --- |
| M2 / T2, M2 / T3 | Later pins or build settings; install-path assertions require the current release path | Installed libraries and consumers | Release Verification 3 | Builds and real Python IOC behavior pass on final tree | Pending |
| M3 / T1, M3 / T2 | Carry or pvxs module-version changes | Patch selection and pvxs artifacts | Release Verification 3 | Correct carry set and installed identities | Pending |
| M3 / T3 | pvxs, metadata, or fixture changes | softIocPVX and loader | Release Verification 4 | Entire loader suite passes with final pins | Pending |
| M4 / T1, M4 / T2, M4 / T3, M4 / T4 | Server, pvxs, fixture, or documentation changes | Milo example and installed IOC | Release Verification 4 | Real data path and accepted recovery behavior pass | Pending |

##### Production Environment Tests

| Release Verification Label | Timing | System | Version | Architecture | Deployment Path | Method | Expected Result | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Release Verification 4 | post-change | Debian; Rocky Linux | 13; 8.10 | x86_64 | Separate 1.5.0 candidate paths, resolve before execution | Full loader and fragment suites plus Milo recovery checks | Final-version runtime behavior passes | Pending |
| Release Verification 7 | post-release | Debian; Rocky Linux | 13; 8.10 | x86_64 | New clean verification paths, resolve during storage preflight | Published quick-start/build/install from actual release tag, then IOC data checks | Released objects reproduce documented behavior | Pending |

No production host deployment is implied. These are clean production-equivalent test environments; record concrete paths and availability before plan acceptance and execution.

##### Version Changes

| Field | File | Before | Planned After | Pre-check | Pre-check Label | Post-check | Post-check Label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ENV_RELEASE_VERS | configure/CONFIG_SITE | 1.4.0 | 1.5.0 | Read the configured value and run the shipped make queries for the effective value and derived install roots before the branch-opening correction | Release Verification 1 | Read the configured value and repeat the same queries after correction; require the plain 1.5.0 value and path | Release Verification 2 |

`ENV_RELEASE_VERS` is an install-path component and must use the plain release number from branch opening. D9 corrects this branch's stale 1.4.0 value to 1.5.0 before development or integration installs. Apply and check this value at branch opening, then preserve it through release-eve; the generic final version-bump sequence does not defer this field. The branch-opening correction is carried by version-only commit bc184267f8f796973d033d5b95022f52e1eb9609. Release Verification 1-2 record only the actual source and make-query observations; actual installed-path and generated-version checks remain in Release Verification 3 and 7. All remaining M1-M5 plan acceptance and implementation authority remain as recorded.

##### Release Execution

| Step | Action | Authorization | Expected Result | Evidence |
| --- | --- | --- | --- | --- |
| 1 | Commit and push the reviewed release candidate on release-1.5.0 | Separate git-workflow commit and push authority | Exact candidate reachable on origin | Pending |
| 2 | Merge the accepted candidate into master | Previewed user-run action or exact Release scope | Recorded merge identity with required checks | Pending |
| 3 | Create annotated 1.5.0 tag at the explicitly selected release object | Previewed user-run action or exact Release scope | Immutable recorded tag and target identities | Pending |
| 4 | Push master and the exact tag | Applicable separate push/tag authority or previewed Release scope | Remote refs match accepted objects | Pending |
| 5 | Create GitHub release 1.5.0 with reviewed notes | Previewed user-run action or exact Release scope | Release names the verified tag | Pending |
| 6 | Reconcile linked issues and remote milestone; recheck the completed 20-issue Backlog reassignment | Applicable Issue scope | All 20 remain closed and belong to 1.5.0; other fields preserved | Backlog reassignment complete, observed 2026-10-06T22:12:25Z; final release reconciliation Pending |
| 7 | Record next-line disposition and cycle closure | Accepted next-line decision and separate commit authority | One clear next entry; published tag unchanged | Pending |

Exact commands and object IDs are prepared only after the final candidate and live tracker facts are known. Plan acceptance does not authorize these actions.

##### Release Verification Plan

| Label | Layer | Timing | Method | Environment | Expected Result | Evidence Target |
| --- | --- | --- | --- | --- | --- | --- |
| Release Verification 1 | Version | pre-change | Read configure/CONFIG_SITE and run shipped make queries for ENV_RELEASE_VERS, INSTALL_LOCATION_VER, and INSTALL_LOCATION_EPICS before the branch-opening correction | Release-branch working checkout | Exact prior value and derived paths recorded before correction | Source identity, observed time, query command and outputs |
| Release Verification 2 | Version | post-change | Read configure/CONFIG_SITE and repeat the same shipped make queries after the branch-opening correction | Release-branch working checkout | Plain 1.5.0 value and derived install paths; no -dev suffix | Source file, observed time, query command and outputs; recorded version-only commit |
| Release Verification 3 | Build | post-change | Recheck completed work evidence and version inventory; run real six-OS workflow paths, dependency audits, patch round trip, upstream checks and representative bumped-module consumer IOC startup; verify actual 1.5.0 installed roots and generated version evidence | Debian 12/13, Rocky 8/10, Ubuntu 24.04/26.04 | All required checks pass against the final candidate on the existing 1.5.0 install path | Per-OS logs, source IDs, installed-path and version outputs, workflow URLs where applicable |
| Release Verification 4 | Runtime | post-change | Full shipped loader and fragment suites, Python support checks, Milo data and restart cases | Debian 13 and Rocky Linux 8.10 | Accepted behavior on actual installed final libraries | Candidate identity, server digest, real IOC and client logs |
| Release Verification 5 | Docs | post-change | Build mdBook; execute changed user procedures; verify release comparison, active patch rows, shell lint and links | Final source and documented book image | Documentation and checks agree with final behavior | Book/lint logs and reviewed release notes |
| Release Verification 6 | Objects | post-release | Read remote tag object, peeled commit, GitHub release target and version contents | Canonical remote and released objects | Exact authorized identities, unchanged 1.4.0 objects | Observed time, immutable IDs and release URL |
| Release Verification 7 | Installation | post-release | Storage preflight, fresh tag-based install using documented path, verify actual 1.5.0 installed root and generated version evidence, then actual IOC data checks | Clean Debian 13 and Rocky Linux 8.10 environments | Published version installs and operates as documented | Filesystem measurements, tag IDs, installed-path and version outputs, install/runtime logs |
| Release Verification 8 | Closure | post-release | Re-read applicable tracker facts, including all 20 closed issue assignments to milestone 7; verify retained backlog, next-line decision and closure file | Repository and canonical remote | Complete evidence and consistent next entry | Read-back observations and closure commit |

##### Release Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| Release Verification 1 | 2026-10-07T03:13:42Z | Debian 13, release-1.5.0 working checkout at 727b966e6030ebbb9dea52faa7eb09cc4b518fd4 | Pass | configure/CONFIG_SITE and `make -s --no-print-directory print-ENV_RELEASE_VERS print-INSTALL_LOCATION_VER print-INSTALL_LOCATION_EPICS` from repository root, exit 0: effective value 1.4.0, version root `${INSTALL_LOCATION}/1.4.0`, EPICS root `${INSTALL_LOCATION}/1.4.0/debian-13/7.0.10`; this records the stale before-state only |
| Release Verification 2 | 2026-10-07T03:14:27Z | Debian 13, release-1.5.0 corrected working tree at observation | Pass | configure/CONFIG_SITE and the same shipped make query, exit 0: effective value 1.5.0, version root `${INSTALL_LOCATION}/1.5.0`, EPICS root `${INSTALL_LOCATION}/1.5.0/debian-13/7.0.10`; source/query checks only, no install or IOC run. Version-only commit bc184267f8f796973d033d5b95022f52e1eb9609 preserves the checked configuration |
| Release Verification 3 | Not run | Six Linux OS targets | Pending | none |
| Release Verification 4 | Not run | Two runtime targets | Pending | none |
| Release Verification 5 | Not run | Final source and book image | Pending | none |
| Release Verification 6 | Not run | Released objects | Pending | none |
| Release Verification 7 | Not run | Clean released installations | Pending | none |
| Release Verification 8 | Not run | Repository and remote tracker | Pending | none |

##### Closure Evidence

None. D9 authorizes only the branch-opening configuration and release-plan correction. Release Verification 1-2 record its source and make-query checks; all combined-candidate and released-object checks remain Pending. The remaining plans remain draft.

##### GitHub Projection

Title: Verify and publish EPICS-env 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-06T22:10:21Z
Last Compared: 2026-10-06T22:12:25Z; metadata read through `gh api 'repos/jeonghanlee/EPICS-env/issues?milestone=7&state=all&per_page=100'`; published title, body, state, labels, assignee, and milestone were verified against the prepared draft after creation.
Prepared Body: `work/issue-150-release.md`
Publication: Complete. Created after canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77; issue creation does not establish plan acceptance or implementation completion.


## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M6 | EPICS::Path Normalize/RelPath | Milestone | Deferred | No | | Retained scope and pending checks; [detail](#m6---epicspath-normalizerelpath) |
| IOC shell | M7 | commonIocsh Promotion | Milestone | Deferred | No | | Retained scope and pending checks; [detail](#m7---commoniocsh-promotion) |
| IOC shell | M8 | Global iocsh Startup File | Milestone | Deferred | No | | Retained scope and pending checks; [detail](#m8---global-iocsh-startup-file) |
| Libera | M9 | Libera Cross-Build And Generated Profile | Milestone | Deferred | No | | Retained scope and pending checks; [detail](#m9---libera-cross-build-and-generated-profile) |
| macOS | M10 | macOS Patch-Revert Verification | Milestone | Deferred | No | | Retained scope and pending checks; [detail](#m10---macos-patch-revert-verification) |
| Upstream | M11 | Upstream Report Of The Base Site Patches | Milestone | Deferred | No | | Retained scope and pending checks; [detail](#m11---upstream-report-of-the-base-site-patches) |
| Initialization | M12 | Check source versions and handle initialization choices | Milestone | Deferred | No | D8 | After 1.5.0; retained policies and pending checks; [detail](#m12---source-version-checks) |
| Initialization | G1 | Accept the initialization plan | External gate | Open | No | | Selected policies and the complete plan are accepted and implementation is separately authorized; [detail](#g1---initialization-plan-acceptance) |

Backlog is excluded from 1.5.0 completion. Historical decision links refer to the retained baseline snapshot, not the new release decision IDs. Existing observed tracker metadata remains dated historical evidence until re-read.

### Backlog Details

#### M6 - EPICS::Path Normalize/RelPath

Origin: 84ee626 / M1
Identity History: Continued from historical master M1 as release-local M6 on 2026-10-06. none
GitHub Issue: #25, https://github.com/jeonghanlee/EPICS-env/issues/25
Status: Deferred

##### Summary

`makeRPath` computes relocatable `$ORIGIN`-relative rpath entries. Removing its bare-`python` dependency (the fragility behind #18) requires re-implementing in Perl the lexical path algebra Python's `os.path` provides as primitives; the earlier straight port (upstream PR #589) regressed at exactly this point and was reverted. The proper fix builds the missing primitive once in the shared module and has `makeRPath` consume it.

##### Scope

Additive extension of `src/tools/EPICS/Path.pm`, leaving `AbsPath` untouched: `Normalize($path)` (lexical, no-stat normalization of `.`, `..`, `//`, trailing slash) and `RelPath($target, $base)` (Normalize both, then relativize). The missing operation is lexical `..` collapse without `stat`: `File::Spec->abs2rel` does not normalize embedded `..`, `canonpath` does not collapse `..`, and `Cwd::abs_path` / `EPICS::Path::AbsPath` collapse `..` only by touching the filesystem, unusable for a not-yet-existing `--final` path. Full edge catalog: `docs/makeRPath-perl-port/relpath-design-analysis.md` at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the file is not on `master`.

Delivery ([historical D52](milestone-84ee626.md#decisions)): one local patch on the pinned EPICS base adds the primitives and `src/tools/makeRPath.pl`, removes `src/tools/makeRPath.py`, and repoints `MAKERPATH` in `configure/CONFIG_BASE` and the script entry in `src/tools/Makefile`. The patch has its own apply and revert rule and a row in `patch/README.md`.

Out of scope: a straight port that hand-rolls the algebra inside the leaf tool.

##### Completion Criteria

- `makeRPath` consumes the shared `Normalize`/`RelPath` primitives.
- `AbsPath` is unchanged.
- The reverted straight-port regression does not recur on the edge catalog.

##### Dependencies And Decisions

- Decision Date: 2026-10-06; exclude this work from 1.5.0 and retain it in Backlog. Resume requires a new owner decision. The earlier completed relocation work does not block this deferred item.

- [historical D52](milestone-84ee626.md#decisions), Decision Date: 2026-10-02, assigns this work to the Milestone on `master` and selects delivery as a local patch on the pinned EPICS base.
- historical master M16 is a work-ordering dependency: this work starts after historical master M16 completes. It is not a behavioral constraint.

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
| T1 | Path algebra | Run the edge catalog in `docs/makeRPath-perl-port/relpath-design-analysis.md` (commit `e6a0ee8`) against the new primitives | Repository checkout | Every case matches the expected lexical result with no `stat` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Build EPICS::Path Normalize/RelPath primitives for makeRPath
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-09; GitHub milestone Backlog

#### M7 - commonIocsh Promotion

Origin: 84ee626 / M3
Identity History: Continued from historical master M3 as release-local M7 on 2026-10-06. none
GitHub Issue: #76, https://github.com/jeonghanlee/EPICS-env/issues/76
Status: Deferred

##### Summary

The `commonIocsh` fragments and the global iocsh are developed and held in EPICS-env during 1.4.0 M6 ([historical D2](milestone-84ee626.md#decisions) interim home). Their durable home is a dedicated public module named `commonIocsh` with its own repository, pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP` ([historical D2](milestone-84ee626.md#decisions)). 1.4.0 M6 verification is complete on the interim home (T1/T2/T3 on the two OS targets, [historical D6](milestone-84ee626.md#decisions)); the promotion itself is deferred to this item per [historical D7](milestone-84ee626.md#decisions).

##### Scope

- Create the public `commonIocsh` repository from the interim in-tree fragments, preserving the `iocsh/` layout.
- Pin `commonIocsh` in EPICS-env's `configure/RELEASE` like every other module and install it under `modules/commonIocsh/`.
- Remove the interim in-tree copy from EPICS-env once the pinned module builds and installs.

Out of scope: any change to the fragment behavior verified under 1.4.0 M6; the `siteApps` de-duplication ([historical D3](milestone-84ee626.md#decisions)), which is the site owner's.

##### Completion Criteria

- The `commonIocsh` public repository exists and carries the verified fragments.
- EPICS-env pins `commonIocsh` in `configure/RELEASE` and installs it under `modules/commonIocsh/iocsh/`, resolved through `IOCSH_TOP`.
- The interim in-tree fragments are removed, and the installed-path checks (T1/T2/T3) still pass on the two OS targets against the pinned module.

##### Dependencies And Decisions

- Decision Date: 2026-10-05; retain Deferred status under [historical D97](milestone-84ee626.md#decisions); resume only when requested.

- [historical D2](milestone-84ee626.md#decisions) sets the durable home: a dedicated public `commonIocsh` module, pinned and reached through `IOCSH_TOP`.
- [historical D7](milestone-84ee626.md#decisions) defers the promotion from 1.4.0 M6 to this Backlog item; 1.4.0 M6 completes on the interim EPICS-env home.

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
| T1 | Pinned-module install | Pin and install `commonIocsh`, remove the interim copy, and run the installed-path suite against the pinned module | Target-OS VMs (Debian 13, Rocky Linux 8.10, [historical D6](milestone-84ee626.md#decisions)) | The suite passes against the pinned module with no interim in-tree copy present |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Target-OS VMs | Pending | none |

##### Closure Evidence

- None; deferred to the Backlog per [historical D7](milestone-84ee626.md#decisions).

##### GitHub Projection

Title: Promote commonIocsh to its public module repository
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-21

#### M8 - Global iocsh Startup File

Origin: 84ee626 / M5
Identity History: Continued from historical master M5 as release-local M8 on 2026-10-06. none
GitHub Issue: #79, https://github.com/jeonghanlee/EPICS-env/issues/79
Status: Deferred

##### Summary

1.4.0 M6 shipped the `commonIocsh` fragment set and verified the services loading together in one IOC, but no single global iocsh file ships, and the example IOC exercises only the caPutLog fragment (`examples/commonIocsh/README.md`). [historical D8](milestone-84ee626.md#decisions) (2026-09-24) deferred the global startup file here.

##### Scope

- Add one global startup file under `commonIocsh/iocsh/` that loads the common-service fragments, with the optional IOC-owned serial configuration of [historical D4](milestone-84ee626.md#decisions) and [historical D5](milestone-84ee626.md#decisions).
- Make the example IOC boot with only that file for the common services.

Out of scope: changes to the individual fragments verified under 1.4.0 M6, and the [historical D2](milestone-84ee626.md#decisions) promotion tracked as M7.

##### Completion Criteria

- The global startup file loads the common services in one call and applies serial settings only when serial configuration is supplied.
- The example IOC passes the integrated checks using only the global startup file for the common services, on Debian 13 and Rocky Linux 8.10 ([historical D6](milestone-84ee626.md#decisions)).

##### Dependencies And Decisions

- Decision Date: 2026-10-05; retain Deferred status under [historical D97](milestone-84ee626.md#decisions); resume only when requested.

- [historical D8](milestone-84ee626.md#decisions) defers the global startup file from 1.4.0 M6 to this item.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Compose the global startup file from the fragment order that `examples/commonIocsh/tests/verify_integrated.sh` already verifies.
2. Point the example IOC at it and rerun the integrated, installed-path, and isolated-path checks.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Global startup | Boot the example IOC with only the global startup file; run the integrated assertions with serial absent and present | Debian 13 and Rocky Linux 8.10 VMs | Every service's assertions pass with no duplicate records |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 VMs | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Ship a global iocsh startup file for the common services
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-25

#### M9 - Libera Cross-Build And Generated Profile

Origin: 84ee626 / M20
Identity History: Continued from historical master M20 as release-local M9 on 2026-10-06. Libera scope split from historical master M14 to Backlog on 2026-09-30 ([historical D42](milestone-84ee626.md#decisions)); original acceptance, implementation, and verification evidence retained; original #87 Libera requirements retained here on 2026-10-01
GitHub Issue: none; #87 is the historical source of the Libera requirements and remains linked to native historical master M14
Status: Deferred

##### Summary

The Libera module script uses the current sequencer targets in published commit `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. Its actual cross-build, generated-profile repetition, and documentation comparison require a real compiler, sysroot, and installed host/ARM base. These checks are separate from native environment-script completion.

##### Scope

- Preserve the published `scripts/build_modules_libera.bash` identifier correction from `sequencer-2-2` to `sequencer`, with `seq` as the installed link name.
- Retain the original #87 requirement to verify the obsolete target correction through actual `build_modules_libera.bash` execution against the real installed tree and current make targets; T1 owns that execution.
- Verify the real nine-module cross-build, installed profile, and repeated setup/reset using that profile.
- Maintain `docs/libera-cross-build.md` as the separate functional reference and verification requirements, linked from `scripts/README.md`.

Out of scope: relocation of either Libera script; changes to `build_base_libera.bash`, compiler or sysroot, module pins, configuration rules, or target-board `/opt` mapping; native historical master M14 completion; target-board runtime verification.

##### Completion Criteria

1. The real module script completes all nine build/install/symlink sequences, including current sequencer targets, and `modules/seq` resolves to the installed sequencer directory.
2. The actual installed profile has mode 0444 and nine target-board library paths independently derived from real make locations and the existing `/opt` mapping.
3. Repeated installed setup with the generated profile preserves directory order and retains each profile directory and the base library once. Unrelated library fields retain their bytes, duplicates, order, and empty fields. Reset removes the base library entry and retains the profile entries.
4. The dedicated reference agrees with actual prompts, module order, targets, links, profile bytes, and installation mode. All three actual checks pass; target queries, native products, or an invented profile do not count.

##### Dependencies And Decisions

- [historical D42](milestone-84ee626.md#decisions), Decision Date: 2026-09-30, excludes Libera checks from historical master M14 completion and retains them as Deferred Backlog work. The selected extraction separates the document and preserves both script paths. Resume requires a new execution decision; no cross-build pass or Keep is inferred.
- Decision Date: 2026-10-01; retain only #87's Libera items here. Keep #87 as the native setup/reset issue linked to historical master M14; its closure does not complete, retire, or authorize execution of any M9 check.
- Actual verification requires the real `arm-xilinx-linux-gnueabi` compiler and target sysroot selected by the shipped site file, and installed base products for both `linux-x86_64` and `linux-arm`.
- The configured compiler was absent when inspected on 2026-09-30. This is an unavailable preparation input, not a verification pass.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-30; retains the Libera requirements of the accepted combined historical master M14 plan; [historical D42](milestone-84ee626.md#decisions) authorizes their extraction without changing the requirements
Implementation Authorization: 2026-09-30; original combined historical master M14 implementation authority covered the identifier correction; actual Libera execution is subsequently deferred by [historical D42](milestone-84ee626.md#decisions)
Superseded Plan Artifacts: `work/m14-implementation-20260930/before-libera-extraction.md` retains the original combined plan and observations

1. Preserve the implemented identifier correction, other module order, prompt, configuration calls, `seq` mapping, and library-profile policy. Preserve existing setup profile loading and reset cleanup scope. No further code change follows from extraction.
2. Upon a new execution decision, prepare the real isolated compiler/sysroot/base environment according to the dedicated reference's cross-base requirements. Use shipped init, patch, conf, build, and install targets and the unchanged cross site file; inspect effective architecture, GNU target/directory, and installed host/ARM ELF products before the module run.
3. Execute the actual module script, then use its actual installed profile for repeated setup/reset. Compare the dedicated document with the observed outputs and retain statuses, versions, pins, hashes, argv, stdout, stderr, modes, and timestamps under ignored `work/`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Cross-build | Inspect generated targets, then run the actual `build_modules_libera.bash` through configuration, every build/install/symlink call, and final profile install; use a real PTY and wait for the prompt before confirmation | Isolated checkout, HOME, and install root; real compiler/sysroot; real host and ARM base; pinned module sources | Script and all nested operations return 0; nine module sequences run; current sequencer targets and seq link match; host/ARM ELF products and profile bytes/mode match independently checked real make locations |
| T2 | Generated profile | Source T1's actual installed setup twice in fresh Bash children with nounset on and off; compare each library field independently; source actual installed reset | Actual T1 installation and profile; unrelated fields include duplicates, spaces, literal special characters, and leading/middle/trailing empty fields | Each of the nine profile directories occurs once in generated order; base library occurs once; unrelated fields retain exact bytes and structure; reset removes only the known base library entry and retains profile entries |
| T3 | Documentation | Read the dedicated reference and README link against the actual T1/T2 prompts, targets, links, generated profile, and modes | Same real cross-build installation and candidate docs | Document matches the observed execution; no native or host result is described as target-board runtime verification |

No internal span can be replaced by a stub, fake make, invented base tree, or manually written profile. Only the outer environment, filesystem availability, and download transport can be controlled. A timeout, incomplete run, or missing input is not a pass. Never run Libera initialization against the owner's working checkout or installation.

##### Plan Review Evidence

The following premise observations come from the accepted combined historical master M14 plan at baseline `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`. Their original T labels refer to that combined plan: original historical master M14 / T7 maps to M9 / T1, its T3 profile case maps to M9 / T2, and its T8 Libera comparison maps to M9 / T3.

| Class | Scope Clause | Observed Evidence | Original Plan Consequence |
| --- | --- | --- | --- |
| Confirmed finding | Sequencer target/link identity | The real make query returned build.sequencer and symlink.sequencer, with no build.sequencer-2-2; CONFIG_VARS and RULES_FUNC map its installed name to seq | Change the build identifier while retaining seq; require the real T7 script run |
| Hypothesis / preparation requirement | Libera integration feasibility | The configured cross compiler is absent on this host; a complete current Libera build has not run | Check a real compiler/sysroot/base environment before T7; do not infer cross-build success from native target inspection |
| Confirmed finding | Cross-base preparation | `configure/CONFIG_BASE` defaults both cross architecture variables to empty; `conf.base.site` writes the selected target architecture but does not copy the Libera OS site file. The existing `build_base_libera.bash` separately sets the architectures and copies that file | T7 preparation names the isolated local settings, unchanged file copy, effective configuration checks, and actual host/ARM base products |
| Hypothesis / required coverage | Libera profile repetition | Setup passes the profile's entire colon-separated library list to `set_variable`; the Libera script generates that list from make locations. No candidate profile repetition has run, so a duplicate regression after changing field comparison is unverified | T3 uses T7's real installed profile and setup, and independently checks each directory's count and order after both source calls |

The original case matrix and preparation details are preserved in `work/m14-implementation-20260930/before-libera-extraction.md`. Their functional requirements are extracted into `docs/libera-cross-build.md`. Premise inputs and observations remain in `work/m14-plan-20260930/baseline.json`.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-09-30 | Real Libera compiler/sysroot unavailable | Pending: current sequencer targets and native seq mapping were inspected; no actual Libera script or cross-build pass is claimed | `work/m14-implementation-20260930/verification-summary.json`, `target-query.stdout`, and [historical D42](milestone-84ee626.md#decisions) |
| T2 | Not run; deferred on 2026-09-30 | Actual cross-build installation and generated profile unavailable | Pending: native path cases do not verify actual generated-profile repetition | `work/m14-implementation-20260930/shell-final/summary.json` records the unexecuted profile case; [historical D42](milestone-84ee626.md#decisions) |
| T3 | Not run; deferred on 2026-09-30 | Actual Libera outputs unavailable | Pending: source/reference extraction and local link checks do not verify runtime assertions | `work/m14-implementation-20260930/verification-summary.json` and [historical D42](milestone-84ee626.md#decisions) |

##### Closure Evidence

- The identifier correction, dedicated reference, README link, and [historical D42](milestone-84ee626.md#decisions) scope separation are published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` on `origin/master`, with publication confirmed at 2026-10-01T06:44:52.634205+00:00. This is source and document publication evidence; it does not complete or retire the deferred cross-build work.
- All three actual Libera checks remain Pending. Native CI success does not verify cross-build or generated-profile execution.

#### M10 - macOS Patch-Revert Verification

Origin: 84ee626 / M21
Identity History: Continued from historical master M21 as release-local M10 on 2026-10-06. Unexecuted macOS verification subset separated from historical master M15 / T2 to Backlog on 2026-10-01 ([historical D49](milestone-84ee626.md#decisions))
GitHub Issue: none; #88 remains linked to historical master M15 and is the source of the patch-revert scope
Status: Deferred

##### Summary

historical master M15 verifies patch revert on actual Rocky Linux 10.2. Its Linux mca target
is inactive; no real macOS execution is recorded. This separate work retains
native macOS patch-revert verification, including the active Darwin mca
target, without delaying historical master M15 completion or changing its runtime code.

##### Scope

- Verify the shipped individual and aggregate revert targets on actual macOS
  with real pinned sources and patch files, preserving the Darwin condition.
- Exercise the active `patch.mca.apply` and `patch.mca.revert` paths with
  confirmed unapplied, applied, repeated, conflicting, and missing-input states.
- Verify whole-patch classification, reverse order, stack prefixes, independent
  source edits, existing backups, and errors through the shared revert helper.
- Record actual command resolution, versions, source pins, statuses, outputs,
  and source inventories, including ignored rejection and backup files.

Out of scope: historical master M15's completed Linux checks; std cleanup or general macOS build
qualification; changes to module pins, patch contents, apply recipes, or
platform conditions; Libera M9; other milestone work.

##### Completion Criteria

1. Actual macOS execution activates the Darwin mca path without replacing
   `uname`, make, the revert helper, or the patch executable with a substitute.
2. Confirmed unapplied, applied, supported partial sets of whole patches,
   and repeated revert return 0; actual patch order and source inventories
   agree, preserving unrelated edits and existing backups.
3. Conflicting, partially applied individual patches, missing required inputs,
   and unresolved states fail with the source and patch identified. Sources
   and inventories match the actual failing-patch boundary; earlier completed
   reversals remain, later reversals do not run, and no new `.rej` or `.orig`
   files appear on classification failure.
4. Evidence names the real macOS version, architecture, make, Bash, patch
   executable and version, source pins, commands, timestamps, and outputs.
   Linux results or a forced Darwin variable do not satisfy these checks.

##### Dependencies And Decisions

- [historical D49](milestone-84ee626.md#decisions), Decision Date: 2026-10-01, retains this scope as Deferred Backlog and
  excludes it from historical master M15 completion. A new execution decision is required to
  resume; no macOS verification pass or Keep is inferred.
- Preparation must inspect the commands actually selected by the macOS
  environment, including whether the selected patch supports the shipped
  GNU patch options. Missing preparation inputs are not successful checks.
- The Linux ptrace observer used by historical master M15 is not a macOS observation procedure.
  Review and validate a native method that captures the real failing-patch
  boundary before executing failure-preservation cases.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On a new execution decision, review this draft and prepare an isolated
   real macOS checkout, HOME, and writable test roots; preserve the owner's
   checkout, installation, and previous evidence.
2. Inspect the actual platform, architecture, make, Bash, patch executable,
   option support, pins, and target activation. Validate the native boundary
   observation procedure before any failure case; do not substitute an
   internal program or reconstruct expected source files.
3. Run the shipped individual and aggregate patch paths on independently
   restored pinned source trees, compare real inventories, and retain exact
   commands and observations under ignored `work/`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Platform and successful revert | Inspect real command resolution and platform, then execute individual mca and aggregate apply/revert with none/all applied, stack prefixes, independent source shifts, and repetition | Actual macOS; isolated real pinned source checkouts; shipped make, helper, and patch files; recorded patch executable | Darwin mca path is active; successful cases return 0 in the expected reverse order; repeated revert changes nothing; unrelated edits and existing backups survive |
| T2 | Failure preservation | Use controlled edits to real patch-owned files and required-input absence; capture the real first failing boundary with a validated native observation procedure, then let the shipped invocation finish | Same actual macOS environment; independent writable cases; unchanged internal programs and original protected trees outside the writable roots | Actual target fails with source/patch diagnostics; failing-boundary inventory equals final inventory; preceding reversals remain, later reversals do not run, and no new rejection or backup files appear |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-10-01 | Actual macOS execution not performed | Pending: historical master M15's Linux inactive mca result does not verify the active Darwin path or native helper execution | [historical D49](milestone-84ee626.md#decisions); historical master M15 / T2 records only the executed Linux scope |
| T2 | Not run; deferred on 2026-10-01 | Native macOS boundary observation not prepared or executed | Pending: no macOS failure-preservation result is claimed | [historical D49](milestone-84ee626.md#decisions); native observation procedure requires review before execution |

##### Closure Evidence

- None. The scope separation records Deferred work only; historical master M15 publication or
  #88 closure does not complete, retire, or authorize execution of M10.

#### M11 - Upstream Report Of The Base Site Patches

Origin: 84ee626 / M31
Identity History: Continued from historical master M31 as release-local M11 on 2026-10-06. Opened on 2026-10-05 by [historical D103](milestone-84ee626.md#decisions) as Deferred work
GitHub Issue: none
Status: Deferred

##### Summary

The Base site patches `patch/7.0.10-site01-dbyacc-eof.p0.patch` and `patch/7.0.10-site02-dbstatic-device-menu.p0.patch` correct two segmentation faults of the EPICS base database loader that exist in R7.0.10 and in the 7.0 branch observed on 2026-10-05. Report both to the upstream EPICS base repository so that a later release carries them and the site patches can be dropped at a pin bump.

##### Scope

- One upstream issue or pull request for the parser crash at end of input and one for the field-name suggestion crash, each with its reproduction files, the observed fault location, and the patch.
- The owner files them; this repository records the upstream references when they exist.

Out of scope: any change to the carried patches, which historical master M25 and historical master M30 own.

##### Completion Criteria

1. Each defect has an upstream reference, or the owner records that it is not reported, with the reason.

##### Dependencies And Decisions

- [historical D103](milestone-84ee626.md#decisions), Decision Date: 2026-10-05, defers the report until the owner chooses to file it.
- The carry rules admit only fixes merged upstream, so the site patches stay until an upstream release above the pin contains the fixes.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Prepare the two upstream texts from the reproduction files of historical master M25 and historical master M30 when the owner asks for them.
2. The owner files them and this register records the references.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Upstream state | Read the two upstream references | GitHub | Each is open, merged, or closed with a reason recorded here |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | None | Pending | Deferred |

##### Closure Evidence

- None; the work is Deferred.

#### M12 - Source Version Checks

Origin: 1.5.0 / M12
Identity History: none
GitHub Issue: none
Status: Deferred
Deferral Decision: D8, 2026-10-06; excluded from 1.5.0 and not assigned to a later version.

##### Summary

Make initialization compare existing Git source identity with the configured pin instead of treating directory existence as sufficient. A mismatch must offer the configured source or the existing source while preserving local work and truthful build and installation versions.

##### Scope

EPICS-env Base and module initialization through `configure/RULES_BASE`, `configure/RULES_MODS`, and their actual `make init`, `init.base`, and `init.modules` entry points. Include full commit resolution, interactive choices, explicit unattended operation, local-change protection, effective pin/version consistency before configuration and build, regression coverage, and the affected build procedure documentation.

Out of scope: direct changes to EPICS-env-support or site repositories, module version upgrades, removal of local source changes, automatic patch migration, and unrelated build-system cleanup.

##### Completion Criteria

- An existing source is skipped only after the configured ref and current HEAD resolve to the same commit, including equivalent tag and commit spellings.
- A mismatch reports both source identities and offers using the configured source or keeping the current source.
- Keeping the current source makes effective source pins, generated configuration, installation paths, and source metadata agree with that source before subsequent configuration or build.
- Choosing the configured source acquires the exact selected commit without overwriting staged, unstaged, untracked, or submodule changes.
- Invalid source directories, unresolved refs, failed acquisition, and declined choices cannot be reported as successful matching initialization.
- Unattended invocation supports explicit choices and defaults to the configured source on a clean mismatch; local changes cause an error and stop. It never waits indefinitely for interactive input. Parallel invocation cannot mix prompts or lose retained-version settings.
- Regression checks run the shipped Makefile recipes and implementation with real Git repositories; the mismatch regression fails against the previous directory-only behavior.
- The documented build path and the future assigned release checks include the accepted initialization behavior.

##### Dependencies And Decisions

D8 supersedes the 1.5.0 assignment in D5 and defers execution until after that release. D6 and D7 remain the selected behavior. G1 is retained as the acceptance prerequisite for future implementation, but it does not block any current release work. Reassignment requires a dated decision, renewed plan acceptance, and separate implementation authority; restore G1 as an execution dependency while it remains Open, with resume as Not started. EPICS-env must implement and verify a working example before asking support and site owners to adopt it.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Inspect local override precedence, generated module configuration, source metadata, and the supported serial and parallel entry points. Complete review and acceptance of the plan under G1, preserving D6 and D7.
2. Replace the directory-only branches in `configure/RULES_BASE` and `configure/RULES_MODS` with commit comparison and explicit mismatch handling. Apply D7 when terminal input and an explicit choice are both absent: select the configured source for a clean mismatch and stop on local changes. Preserve Base submodule initialization and the existing fresh-clone path; propagate acquisition and validation failures.
3. Implement D6: display the exact source-tag and version overrides for operator application, and prevent configuration or build under mismatched identities until they are applied. Do not modify local override files automatically. Verify the generated cache reflects the effective retained values after the operator applies the overrides.
4. Add regression coverage for missing, matching, mismatched, dirty, invalid, and unattended cases using real shipped recipes and Git source fixtures. Compare the mismatch regression with the preceding implementation instead of recreating its logic in a test substitute.
5. Update `docs/src/procedures/build-and-install.md` and relevant command/reference documentation. Report the accepted behavior and landed identifier to support and site owners; they remain the single writers of their repositories.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Source identity | Run the shipped Base and module initialization recipes against absent sources and existing repositories with matching tag or commit refs | Isolated checkout and real filesystem Git remotes | Exact clone identity; equal commits skip without a prompt |
| T2 | Version choice | Run real mismatch choices, then inspect effective pins, generated configuration, source identity, and installation metadata through shipped paths | Isolated checkout with two real source commits | Selected source and every version-bearing output agree; old directory-only behavior fails the regression |
| T3 | Local work | Exercise mismatch handling with staged, unstaged, untracked, and submodule changes; compare source content and index before and after | Real Git working trees | Local work is preserved and no forced reset, clean, or implicit patch migration occurs |
| T4 | Invocation and errors | Run the shipped entry points with explicit choices, unattended clean/dirty mismatches without a choice, serial/parallel make, invalid sources, missing refs, and acquisition failure | Terminal and nonterminal processes; real Git remotes | Clean unattended mismatches select the configured source; local changes stop; no hanging or mixed prompts |
| T5 | Installation | Execute the documented initialization/configuration/build path using the accepted choices and inspect actual installed source metadata | Selected release test environments | Installed source and version identities agree with the selected or retained source |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated checkout and real Git remotes | Pending | none |
| T2 | Not run | Real source commits and shipped configuration paths | Pending | none |
| T3 | Not run | Real Git working trees | Pending | none |
| T4 | Not run | Terminal and nonterminal initialization | Pending | none |
| T5 | Not run | Actual release installations | Pending | none |

##### Closure Evidence

None. The directory-only branches were read in `configure/RULES_BASE:12` and `configure/RULES_MODS:38` at 727b966e6030ebbb9dea52faa7eb09cc4b518fd4. The observed older ADCore checkout is recorded in M1; no initialization regression or changed implementation has run yet.

##### GitHub Projection

Title: Check source versions during init
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: Backlog, number 3, https://github.com/jeonghanlee/EPICS-env/milestone/3
Observed State: none
Observed Labels: none
Observed Assignee: none
Observed Milestone: none
Last Compared: never; no linked issue exists yet
Prepared Body: `work/issue-init-source-version.md`
Publication: Not created. The 1.5.0 publication direction is superseded by D8. Backlog milestone 3 was observed open at 2026-10-07T03:04:05Z through `gh api repos/jeonghanlee/EPICS-env/milestones/3`; remote updated_at was 2026-10-06T22:08:08Z. No GitHub mutation was performed.

#### G1 - Initialization Plan Acceptance

Origin: 1.5.0 / G1
GitHub Issue: none
Status: Open

##### Summary

The repository owner selected operator-applied overrides in D6 and the unattended default in D7. Review and accept the complete M12 plan and record separate implementation authorization. This gate affects deferred M12 only and has no 1.5.0 release dependency.

##### Completion Criteria

- The keep path follows D6: display operator-applied source-tag and version overrides before configuration and build proceed; no automatic override-file write.
- The unattended default follows D7: select the configured source automatically for a clean mismatch when no terminal input or explicit choice is available; stop on local changes.
- Record the accepted M12 plan and separate implementation authorization before code changes.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| 2026-10-06 | Partial | D6 and D7 record both selected policies; acceptance and separate implementation authorization of the complete plan remain unrecorded |

##### Closure Evidence

None.
