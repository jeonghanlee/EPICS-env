# Work Register

Release line: 1.5.0
Milestone index: 1.5.0
Canonical path: `docs/milestone-1.5.0.md`
Canonical branch or ref: `release-1.5.0`
Git upstream: `origin/release-1.5.0`
Remote tracker: `jeonghanlee/EPICS-env`; [1.5.0](https://github.com/jeonghanlee/EPICS-env/milestone/7), number 7, open; observed 2026-10-06T22:12:25Z through `gh api repos/jeonghanlee/EPICS-env/milestones/7`; remote updated_at 2026-10-06T22:10:21Z. Five open issues (#96-#100) are published and all 20 closed Backlog issues are assigned to this milestone.

Next session entry point: Continue M1 with the pvxs release and carry review, then obtain the thirteen-module IN/HOLD decisions, including calc and motor tag-versus-branch choices. The fresh Base assessment, D14's selected chain implementation under D15, corrected partial-stack reversal, and second code review are complete locally; focused real-path results are recorded in M1 / T4-T8 and Base Carry Implementation below. These changes remain uncommitted and have no landing evidence; module pins are unchanged. pvxs d23de00d depends on a9f8b7b3, which misses the rule and introduces unresolved source findings; distinguish that later chain from released pvxs 1.5.3. Source-initialization improvements remain deferred under D8. M2-M5 remain draft; release-wide builds and publication retain their separate authority.

This is the initial release-line plan. D9 authorizes only the branch-opening version correction; the remaining implementation and release actions require their recorded authority. Its baseline is `4d521e7a0f05163d39541c0357e966397433b027`; the published 1.4.0 tag resolves to `5326c981912566810f763cbe12aba6509bbdb7c4`. Completed changes since 1.4.0 include the installed-module loader, build and environment corrections, two Base site patches, loader fixtures and tests, documentation, and CI changes. They belong in the release comparison and final verification, not new implementation milestones.

This document is the current work register on `release-1.5.0`. The retained `docs/milestone-84ee626.md` is a historical snapshot of master at the baseline commit, not an active plan on this branch. Completed work and its evidence remain there. Seven unfinished work items and the initialization plan gate are retained below in Backlog; the former OPC UA server work continues as M4 with the owner-selected Milo scope. This is a release-branch consolidation, not a modification of the live master branch or a claim that new plans are accepted.

## Milestone

### Release Runbooks

Follow the installed `epics-env-pipeline/SKILL.md` runbook for EPICS environment release preparation, installation, and verification, `release-cycle/SKILL.md` for release-cycle management, and `git-workflow/SKILL.md` for Git and GitHub release operations. Resolve these paths from the runtime's skill catalog and read each operation's routed references before execution. Keep the procedure in those runbooks; this milestone document records the 1.5.0 scope, decisions, work status, plans, and observed verification evidence.

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Survey | M1 | Establish module candidates and the release comparison | Milestone | In progress | No | D1, D2, D10, D12, D13, D14, D15 | Selected Base carry implementation and focused review complete; finish remaining module/carry decisions and release comparison; [detail](#m1---module-survey) |
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
| D10 | Assess all thirteen available update candidates together, including pyDevSup and pvxs, using the module-bump procedure. Expand M1 source comparison and consumer coverage beyond D2's initial two candidates. This accepts and authorizes the expanded survey; each candidate's IN/HOLD decision and implementation remain separate. | 2026-10-06 |
| D11 | Run this five-reviewer carry assessment in two batches of three and two. This excepts simultaneous execution only: all five reviewers use the same frozen candidates and rubric, see no other reviewer's scores or findings, and retain independent raw results before per-axis median calculation. No carry adoption or implementation is authorized by this execution choice. | 2026-10-07 |
| D12 | Add Base commit 6d85a363 and PR #900 as original upstream diffs, preserving R7.0.10 and avoiding manual source or hunk adjustments. Cross-check the existing active patches for prerequisites and interactions before production wiring. The additional cf85a1a5 carry, #934 replacement, and backup-policy change identified by that check remain proposals pending a scope decision. | 2026-10-07 |
| D13 | Reopen the new Base patch selection before implementation and restart the carry procedure from enumeration. Preserve the released carry baseline and the original-upstream-diff constraint. Re-derive the new candidate set and its complete dependency chains from source, score the complete fresh set with five independent assessors under D11, and present the full table for the owner decision. The earlier D12 selection and prior panel scores are historical evidence, not the current selection. | 2026-10-07 |
| D14 | Select complete original PR #900 after the fresh assessment; it meets bug>=5 and safety>=5. Include complete four-commit PR #753 and cf85a1a5 despite their rule misses because the original #900 chain and coexistence with the released fixes require them. Replace the existing #934 representation with its original upstream diff and retain #949 afterward, preserving R7.0.10 and all other released fixes without manual source or hunk adjustments. Production patch generation, wiring, and backup-policy implementation remain separate work. No decision on #976 or e699b75b is recorded by this selection. | 2026-10-07 |
| D15 | Accept and authorize implementation of D14's selected Base chain and its focused verification. Use --no-backup-if-mismatch for Base application, matching the existing pvxs policy. Preserve the released filenames and pins, emit the required #753 and cf85a1a5 prerequisites before the remaining carries, and reverse the actual apply list. Git/GitHub publication and release qualification remain separately governed. | 2026-10-07 |

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

Establish what changed since 1.4.0 and what all thirteen available upstream updates actually require. A survey result is not authority to update every available module.

##### Scope

Survey all configured modules using `docs/procedures/module-bump-procedure.md`, stages 1-5. Under D10, assess recsync, caPutLog, calc, sscan, lua, std, busy, scaler, measComp, motor, pyDevSup, pcas, and pvxs together. Inspect local pin overrides, upstream releases, exact object identities, source changes, build options, carried patches, and consumers across EPICS-env, EPICS-env-support, and available site module sources. Distinguish a published tag from later branch commits. Keep durable candidate and consumer evidence in this detail; scratch logs may live under `work/`. The canonical detail replaces a separate active module-bump planning document.

D12 authorized checking the existing active patch set and its interactions. D13 reopened its new Base selection and authorized the completed fresh carry assessment. D14 records the selected complete #753, cf85a1a5, and #900 chain, the original #934 representation, and retained #949. Complete chains and existing-patch interactions were established before the fresh scoring panel and this decision. D15 extends M1 with implementation of this selected Base carry chain, its explicit ordering, residue-free backup policy, and focused real-path verification. This selected Base work is complete locally on 2026-10-07, including the revert correction and second code review recorded under T7-T8. Focused native builds do not qualify the release or change module pins.

Out of scope: pin edits, release-wide builds, implementation of any other candidate update before its IN decision and authority, and makeRPath conversion.

##### Completion Criteria

- Every configured remote has a recorded survey result and observation time; unreachable and indeterminate entries remain explicit.
- Confirm pyDevSup 2.1.0 and select the exact pvxs release from authoritative upstream objects. Do not infer a version from the word "latest".
- Compare all thirteen candidates with their effective current pins, including local fixes and build configuration changes; retain pyDevSup `4527ed0` and pvxs `1.5.2` in the same assessment.
- List actual link, header, DBD, and runtime consumers from source. Unavailable layers are explicitly not surveyed, not declared compatible.
- Present each selected candidate's IN/HOLD decision and any required external verification. Reconcile missing mandatory consumer access before declaring readiness.
- Record the 1.4.0-to-candidate module, patch, feature, platform, and user-interface changes.
- Wire the selected original Base chain, preserve all other patch bytes and module pins, and record the focused T5-T8 results and limits without declaring release qualification.

##### Dependencies And Decisions

D1, D2, D10, D12, D13, D14, and D15. M1 precedes M2 and M3 because their exact source and test scope depend on the census. Additional selected updates require their own implementation scope after the candidate decisions. D13 reopened D12's Base selection; D14 records the new complete #900 chain after the fresh assessment, and D15 authorizes that chain's implementation under M1. The selected Base implementation, focused verification, and second code review are complete locally on 2026-10-07. #976 and e699b75b are outside the selected 23-patch set; no additional adoption or rejection decision is recorded. The remaining module and pvxs carry decisions remain pending, with pvxs review as the next entry point. M3 still excludes Base implementation. The proposed working order is M1, M2, M3, M4, M5; M2 and M3 have no established dependency on each other, and M4 can be prepared independently. This order is a proposal, not an invented build dependency.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-06; proceed with the module-bump procedure, expanded by D10 to assess all thirteen candidates together. D15, Decision Date 2026-10-07, accepts the focused selected-Base implementation extension below.
Implementation Authorization: 2026-10-06; execute the expanded survey and source assessment under D10. D13, Decision Date 2026-10-07, authorizes the fresh Base assessment and focused prerequisite verification. D14 selects the complete #900 chain; D15, Decision Date 2026-10-07, authorizes production patch generation, wiring, the chosen backup policy, and focused verification for that chain. Remaining candidate decisions, pin edits, release-wide verification, and publication retain separate authority.
Superseded Plan Artifacts: the two-candidate source-assessment scope at 56f7e8c022f334d136449dfcda35c156674f9920, accepted and authorized on 2026-10-06; D10 expands that scope without changing its decision and implementation boundaries.

1. Check the consolidated row/detail pairs and live linked tracker facts before committing the release plan; preserve deferred work and prior evidence.
2. Run `tools/update-release.bash check`, retain its output and exit status, and separately verify release-tag candidates for commit-pinned modules.
3. Read the effective old pins and exact candidate sources for all thirteen updates. Compare newer published tags separately from branch-head candidates. Build the dependent census with both traversal methods required by the module-bump procedure.
4. Inspect public interfaces, build settings, Python requirements, and carried modifications. Record full consumer findings and obtain candidate decisions before pin edits.
5. Update the draft test scope from the observed census and record the final release comparison against 1.4.0.
6. Implement the Stage 6 Base list below: generate three complete original upstream diffs and replace #934 with RAW934; update configure/CONFIG_BASE, configure/RULES_FUNC, and patch/README.md together. Keep the carry overview, carry procedure, and target reference consistent with the actual Base rules. Run the actual shipped apply/revert targets on exact pinned archives, then configure/build the selected Base and execute focused upstream fixtures and failure-policy checks. Preserve all other patch bytes and module pins.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Survey | Execute the shipped update checker and inspect effective overrides and upstream tag objects | Release checkout and upstream remotes | Every configured module accounted for; exact targets identified |
| T2 | Source | Run both source traversal methods; inspect actual conditional link paths and old-to-new changes | All available consumer source layers | Evidence-backed census and explicit coverage gaps |
| T3 | Scope | Compare 1.4.0 with the release baseline and reconcile candidate decisions | Git objects and canonical details | Complete change categories; no implicit additional upgrades |
| T4 | Patch prerequisites | Run the shipped patch/revert targets, standalone and leave-one-out checks, and focused native core builds; compare the new original-diff chain with the current stack | Isolated tracked environment snapshot and exact pinned source archives | Explicit prerequisite graph, complete application observations, byte/file restoration results, and separate build evidence and limits |
| T5 | Selected Base wiring | Run shipped make patch/patch.revert and Base-specific targets, including revert on an unapplied tree; compare ordered patch logs, whole-source names and SHA256 values | Isolated current environment snapshot and all exact pinned patched-source archives | All 23 selected Base patches run in the Stage 6 order; full real round trip restores source bytes and names without .orig/.rej; existing non-Base carries remain unchanged |
| T6 | Selected Base native behavior | Run shipped conf.base/build.base with all six exact Base gitlinks; run epicsAtomicTest, epicsLoadTest, taskwdTest, aslibtest, and actual libCom cantProceed YES/NO child-process probes | Private Debian 13 native install and selected Base sources | Configure/build and real fixtures pass; abort/suspend observations match the configured policy; no platform-matrix or release qualification inferred |
| T7 | Partial-stack reversal | Apply each Base prefix from zero through 23 patches, then run the shipped revert target; exercise real conflict, missing/malformed input, ambiguous dry-run, space-containing path, existing backup, and full Linux round-trip cases | Actual current helper and Make targets; exact pinned source archives; Debian 13.7, GNU Make 4.4.1, GNU patch 2.8 | Every valid prefix restores exactly; errors stop without changing source at classification entry; preceding reversals and existing backups are preserved; all 42 Linux patches reverse in their actual inverse order |
| T8 | Independent code review | Review the frozen helper with one independent agent and one rebuttal exchange; execute Base and pvxs cases independently and check local-edit preservation through the public Make targets | Frozen helper SHA256 below; exact R7.0.10 and pvxs 1.5.2 archives; real GNU patch without internal mocks | No must-fix or minor finding; normal restoration and error-preservation behavior confirmed; unexecuted failure branches remain explicit |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Initial survey 2026-10-06; rechecked by 2026-10-07T06:58:42Z | Release checkout and 33 public upstreams | Pass: real checker exit 0, 33/33 lookups, 13 updates; Lua advanced to 01aa7a1; effective candidate pins rechecked with Make | Upstream Survey and Expanded Candidate Assessment below |
| T2 | Initial census 2026-10-06; expanded assessment 2026-10-07T06:58:42Z | 33 pin-matched Layer 1 sources, six Base component submodules, pinned ADCore, three other support sources, and two site sources | Pass for the recorded static census: both searches agree on 46,065 lines across 39 roots; conditional and runtime consumers classified; no build, ABI, or runtime pass claimed | Expanded Candidate Assessment and Consumer Assessment below; earlier observations retained in Consumer Coverage |
| T3 | 2026-10-07T06:58:42Z | 1.4.0 to 56f7e8c022f334d136449dfcda35c156674f9920 | Partial: 151 changed files and unchanged module pins confirmed; all thirteen candidate decisions remain pending | Release Comparison and Expanded Candidate Assessment below |
| T4 | Earlier cross-check 2026-10-07T08:02:41Z through 2026-10-07T08:14:19Z; fresh Base assessment verified by 2026-10-07T16:12:44Z | Debian 13.7, GNU Make 4.4.1, GCC 14.2.0; exact R7.0.10 archive, six pinned Base components, and environment 56f7e8c022f334d136449dfcda35c156674f9920 | Fresh complete-unit prerequisites established; shipped Base baseline restores exactly; explicit 25-step assessment applies and builds with exit 0. Private reverse restores all 1,832 original files but leaves two .orig files. Four shipped fixtures and focused real runtime paths executed. Five independent scores complete | Base Carry Restart Before Selection below; earlier all-module observations retained in Existing Patch Dependency Cross-check. Selected production wiring is verified separately in T5-T6; other platforms, external consumer builds, and release qualification remain unverified |
| T5 | 2026-10-07T17:44:14Z | Current uncommitted implementation over environment 56f7e8c022f334d136449dfcda35c156674f9920; eight exact pinned source archives; GNU Make 4.4.1 and GNU patch 2.8 on Debian 13.7 | Pass: 23 ordered Base dry-runs and real applications; exact inverse reversal; all 42 Linux patches observed with 187 patching-file lines; all eight source file sets and SHA256 values restored, 3,915 regular files; no .orig/.rej | Base Carry Implementation below; unapplied revert and empty version-matched set also preserve sources; 21 carry rows and two site units match the actual list |
| T6 | Native build 2026-10-07T17:52:51Z; runtime checks 2026-10-07T17:54:07Z | Selected 23-patch Base and six exact gitlinks; private CONFIG_SITE.local install; Debian 13.7 x86_64, GCC 14.2.0, GNU Make 4.4.1 | Pass: shipped conf.base/build.base exit 0; four real upstream fixtures pass all 126 checks; actual libCom cantProceed YES aborts by SIGABRT, NO suspends through a four-second observation | Base Carry Implementation below; other platforms, downstream consumer builds, full released-fix regressions, supervisor recovery, and release qualification are not established |
| T7 | 2026-10-07; execution evidence recorded by 2026-10-07T19:34:14Z | Current uncommitted implementation over 56f7e8c022f334d136449dfcda35c156674f9920; actual helper and Make targets; eight exact pinned archives | Pass: all 24 Base prefixes restore; real incomplete/conflict/missing/malformed/ambiguous cases stop and preserve source; 15 preceding reversals retained on a later error; all 42 Linux patches apply/revert and restore eight complete trees, 3,915 regular files | Base Revert Correction And Review below; names, bytes, modes, and symlinks compared with fresh archive extraction; Bash syntax and both ShellCheck checks exit 0 |
| T8 | 2026-10-07; author executions recorded by 2026-10-07T19:45:28Z, independent executions by 2026-10-07T19:49:53Z | Same frozen helper; actual public Make paths and exact Base/pvxs archives | Accept: second code review, one independent agent, one rebuttal exchange; no must-fix, minor finding, or residual disagreement. Nine independently executed Base states restore; all thirteen pvxs prefix states restore; independent full pvxs round trip and error-preservation cases pass | Base Revert Correction And Review below; local edits preserved at Base prefixes 2 and 17; actual private apply/reverse failure and private mktemp failure were not executed |

##### Upstream Survey

Observation Date: 2026-10-06. `tools/update-release.bash check` completed with exit 0: 33 attempted, 33 completed, 13 updates. The table records that initial checker result, not an upgrade decision. Tag pins are compared with release tags; commit pins with branch heads. The supplemental official-release inventory below covers all 19 commit pins. D10 subsequently expanded immutable source comparison to all thirteen candidates; see Expanded Candidate Assessment for the newer Lua observation. A latest published release is not automatically newer than an existing commit pin.

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

Observed 2026-10-06 through each public upstream's `releases/latest` endpoint. A 404 was followed by a `tags?per_page=5` read. Tag samples are not ordered release decisions; no published release is distinct from no tags. This inventory does not select a candidate for implementation.

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
| EPICS-env module sources | No build-order dependency names pyDevSup or pvxs in `configure/CONFIG_MODS_DEPS` | Sources were absent at the initial observation. The subsequent 33-source assessment and conditional-use classification are recorded in Consumer Assessment below. |
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

Rechecked at 2026-10-07T06:58:42Z: `git diff 1.4.0..56f7e8c022f334d136449dfcda35c156674f9920` covers 151 files, 17,159 insertions, and 3,648 deletions. Module tag/version pins remain unchanged; `ENV_RELEASE_VERS` now reads 1.5.0. At that survey observation, uncommitted work changed this milestone document only.

No candidate IN/HOLD decision has been recorded. D10 brings the other eleven changed upstreams into the same assessment. The candidate choices below remain M1 work; no build or runtime check has run during this survey.

##### Expanded Candidate Assessment

Observed by 2026-10-07T06:58:42Z. The repeated shipped checker completed all 33 remote lookups with exit 0 and again found thirteen updates. Lua advanced from the earlier `ada11c0` observation to `01aa7a1`; the comparison below uses the latter. The checker first failed all lookups in the restricted execution environment; that incomplete result was superseded by the successful real checker run. No checker update command was run.

Effective old tags and versions were read with `make -s --no-print-directory print-SRC_TAG_<KEY> print-SRC_VER_<KEY>`. Candidate commits were resolved with `git rev-parse '<ref>^{commit}'` and compared with `git diff <old>..<candidate>`, including the changed public headers, record definitions, build files, and local carry targets. All thirteen old commits are ancestors of their compared candidates. These are source findings, not build or compatibility passes.

| Module | Effective old pin | Compared candidate commit | Changed files | Source finding and verification obligation |
| --- | --- | --- | --- | --- |
| pyDevSup | 4527ed0 | b5cef38a6d9f74f9c59f967185ba6d1940637c03 (2.1.0) | 1 | Adds CHANGELOG.md only. Verify the new installed identity and real Python IOC/record path under M2. |
| pvxs | tags/1.5.2 | 25ca43df4db909c0b1a445fb705fc81582617625 (1.5.3) | 72 | Existing twelve carries are in the release history. Retain the detailed final-source, CLI, callback, IOC, ADCore, and patch-retirement checks recorded above and in M3. |
| recsync | 9834b94 | 6494fca8166ae3a2ae432ce91ee7eb2e4f06d4c3 | 138 | client/README.md states that RecCaster moved to ChannelFinder/reccaster. The candidate removes client/configure and client/castApp, which conf.recsync and the loader still require. Release 1.10.0 has the same missing client. A source-repository migration is required before either can replace the current pin. |
| caPutLog | dafb0b2 | 6f9eb3f6c75e49201d114f8e194d53cef493a522 (R4.2) | 2 | Documentation and release notes only. No library or build change. Verify installed identity and the existing real put-logging fixture. |
| calc | 4217e83 | 59d1fe51c2d4e8c8eec2ad9d067831c93d69f5cb | 21 | aCalc/sCalc fix modulo overflow, stack bounds, empty LRC input, string/array bounds, derivative-window bounds, and variable-argument traversal. Later DB changes standardize DESC and make userTransforms10 start disabled. Public headers and build files are unchanged. Run the real upstream tests, affected records, and consumer rebuilds. |
| sscan | e13699e | ce9660cfc05071834391225beadf7f93b776d216 | 2 | sscanRecord.c removes delay quantization outside vxWorks and rounds scan-point calculations; writeXDR.h types the callback prototype. Verify scan counts, short delays, saveData/XDR output, and consumers. This does not establish that the existing C17 bridge can be removed. |
| lua | 17475b5 | 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d | 232 | Bundled Lua moves to 5.5.1; luaaa is removed; device support becomes C++; state, shell, record, and asyn interfaces change. New cfg dependency files and BUILD_IOCS=NO alter installed examples. Existing entry names retained as deprecated aliases do not prove script compatibility. Require a dedicated Lua script/record/asyn and loader verification plan. |
| std | 5f2e442 | 27b696702c4ebc8c698c98e3bbb10a34f1a2c821 | 1 | throttleRecord.c locks the record around delayed valuePut and fixes per-link status handling. No public-header or build change. Verify delayed output and independent OUT/SINP disconnect/reconnect behavior. |
| busy | 2dfe92d | a4a272d94d1f4351e7d9553e6dc35782eb96ce75 | 39 | Typed DSET/DRVET declarations change busyRecord/device support. CONFIG_MODULE and BUSY_DEPS are installed; test IOC moves to iocs/ and becomes opt-in through BUILD_IOCS=NO. Verify generated headers/DBD, soft/asyn completion, consumer records, and installed metadata. Reassess the C17 bridge with actual builds only. |
| scaler | beb5521 | baa8e1c5e5a9a5deceef8cc39207a0da446092a6 | 33 | Support implementation and headers are unchanged; CONFIG_MODULE and SCALER_DEPS are added, and the test IOC moves to an opt-in iocs/ build. Verify installed cfg/metadata, consumer linkage, and scaler operation. |
| measComp | c38974e | 9c8e01e025258668208383b370061a2b1ba9d7e8 | 14 | Changes are generated UI screens and a documentation dependency. Driver source and build files touched by the CONFIG_MEASCOMP and TC-32 carries are unchanged; neither carry is included by this update. Retain both obligations and verify them through the real carry/build procedure if selected. |
| motor | 285f44d | 47893ed11b0027b90a94622847ebc5332ba6b99a | 44 | Adds actual velocity and position-compare support, changes homing fallback and driver gitlinks, and removes NUM_MOTOR_DRIVER_PARAMS. Pinned pmac uses that macro in pmacController.cpp:137 and pmacCSController.cpp:151. The branch candidate requires a consumer change; the published R7-4 alternative below retains the macro. |
| pcas | e075fd4 | bdf2b0ab4229e0bb69dbe9107dbb40c332db4f33 | 1 | Changes only the upstream GitHub Actions workflow. No installed source, interface, or build change; an update provides no runtime fix relative to the current pin. |

Published-tag alternatives were checked independently of the branch-head comparison:

| Module | Published tag and resolved commit | Difference relevant to selection |
| --- | --- | --- |
| recsync | 1.10.0, e749f9e5a32af21099cc76a51789a40dc8d6ec89 | Already lacks the client source. Selecting the release tag does not avoid the repository migration. |
| calc | R3-8, 712a40453e8693fda3b90a6e9da5fdb1c708ee38 | Five changed files from the old pin; includes the calculation fixes and tests, before the later DESC and userTransforms10 default changes. |
| motor | R7-4, 68605b9512c8da65e83933474d17cadb453ec13b | Twenty-eight changed files; adds motorActVelocity and other fixes while retaining NUM_MOTOR_DRIVER_PARAMS. The tag still defines VERSION as 7.3 in motorRecord.cc; upstream 4b22ac950de98c2dca324c2ef8ef221e124f6651 corrects that reporting value to 7.4. Account for this before selecting a tag-only update. A coherent motorMotorSim/pmac rebuild remains required. |

The observed latest tags for sscan (R2-12), lua (R3-1), std (R3-6-4), busy (R1-7-4), scaler (4.1), measComp (R4-3), and pcas (v4.13.3) are ancestors of their existing pins. Moving to those tags would move backward. caPutLog R4.2, pyDevSup 2.1.0, and pvxs 1.5.3 resolve to the compared candidate commits.

Recommendations for the owner decision: pyDevSup 2.1.0, pvxs 1.5.3, caPutLog R4.2, calc R3-8, sscan ce9660c, std 27b6967, busy a4a272d, scaler baa8e1c, and motor R7-4 can proceed to explicitly scoped real verification after selection. Hold recsync pending a repository-migration decision and Lua pending a dedicated migration/test scope. measComp's screen-only update and pcas's CI-only update can remain at their current pins unless those changes are wanted in 1.5.0. These are recommendations only: no IN/HOLD verdict, new implementation milestone, or pin edit is authorized by this table.

##### Consumer Assessment

At 2026-10-07T06:58:42Z, all 33 separate Layer 1 assessment checkouts matched the effective Make pins and had clean working trees. The six Base component submodules were initialized at their recorded gitlinks. Motor's optional driver submodules and pvxs's optional bundled libevent remain uninitialized, matching the current module initialization path; motorMotorSim is surveyed as its separately pinned module. This is source preparation, not evidence that the environment's make init/build/install path ran.

The assessment also covered clean pinned ADCore ee039d24c9e89e70b31fd383b4817a40db5d6395, pin-matched ADSimDetector/ADGenICam/ADVimba with their existing local configuration modifications, and both clean, pin-matched site sources. The original ADCore checkout was not replaced.

Case-insensitive, ignore-disabled, hidden-file-inclusive `rg` and `find` plus `grep -IHniE` returned the same 46,065 matching lines across all 39 roots. Both traversals excluded `.git` and selected `*Makefile*`, `*.mk`, `*.c`, `*.cc`, `*.cpp`, `*.cxx`, `*.h`, `*.hpp`, `*.db`, `*.dbd`, `*.substitutions`, `*.template`, `*.cmd`, `*.iocsh`, `*.lua`, `*.py`, `*.req`, `*.bash`, `*.sh`, and `*_DEPS`. The search covered mixed-case `LIBs`, all library-list positions, and runtime startup files. Agreement verifies traversal, not compatibility. Raw local evidence is `work/survey-150-all-census.json`; reproduce with the module-bump procedure's Stage 3 paired traversals, these file classes, and the following case-insensitive expression:

```text
\bstd\b|\bcas\b|\bgdd\b|\bcalc\b|miscSupport|scanparm|saveData|writeXDR|reccaster|caPutLog|aCalc|sCalc|transformRecord|swait|acalcout|scalcout|sscan|lua|throttle|epid|busy|scaler|measComp|motor|pyDevSup|devsup|softIocPy|pcas|casdef|casChannel|pvxs|softIocPVX|pvx(get|put|monitor)
```

| Candidate | Source-backed consumers and verification surface |
| --- | --- |
| pyDevSup | No active external module consumer found in the surveyed configuration. feedApp/Makefile has conditional pyDevSup linkage, but the carried feed-core-libonly patch removes feedApp from the build. Base devSup.h includes are unrelated. Exercise pyDevSup's own softIocPy and Python records. |
| pvxs | ADCore's NDPluginPvxs and ntndArrayConverterPvxs, plus ADSimDetector/ADGenICam/ADVimba through ADCore. The installed loader runs softIocPVX. linStat's optional example names pvxs, but conf.linStat sets LINSTAT_BUILD_EXAMPLE=NO. |
| recsync | The installed loader maps recsync to reccaster library/DBD; commonIocsh loads reccaster.db. Site startup fragments also load that database. ADCore has conditional RECCASTER linkage, not enabled by the current support recipe. |
| caPutLog | Installed-loader entries, commonIocsh, the tc32sim logging example, and a site logging fragment. pyDevSup's optional caPutLog linkage is disabled in its default RELEASE and is not enabled by conf.pyDevSup; its logging example and Base pva2pva's putlog startup are additional optional consumers. |
| calc | asyn links calc and includes sCalcoutRecord.h when configured CALC is present; StreamDevice uses the same record header and support DBD. mca and measComp application/library link lines also name calc. Runtime DB/template consumers include std, sscan, QPC, mca, and pmac. QPC's application link references are removed by its data-only patch, but its installed template still uses calc records. Scaler's old optional test IOC and ADCore's optional CALC entry are conditional consumers. |
| sscan | calc, asyn's test applications, StreamDevice's application, mca, and measComp have source link evidence. std's trend database uses scanparm; ADCore's SSCAN entry is optional. QPC's application link is removed by the data-only patch. |
| lua | No active external Lua header/library/script consumer found in these roots. motor declares a build-order dependency without a matching active source use in the initialized tree. Verify Lua's own records, shell, scripts, asyn support, and installed-loader registration. |
| std | No external std-library/header use found; mca/measComp declare build-order dependencies. calc's example loads std databases. Verify std's own throttle records and loader independently of those declarations. |
| busy | mca and measComp have active link evidence. Runtime records/templates also occur in motor, feed-core, calc, std, pmac, autosave, and ADCore; sequencer has an optional example. ADCore's direct library entry is conditional. feed-core's application link is removed by its patch, while its installed busy-record templates remain consumers. |
| scaler | mca SIS sources and measComp's USBCTR driver include devScalerAsyn.h; corresponding library/application link lines name scaler. autosave has a scaler test database; mca's VME startup examples are additional platform-specific consumers. |
| measComp | No external module source link found in the surveyed roots. Verify its own driver/IOC tools, loader entries, installed vendor cfg, and both carries. A commented site discovery command is not an active consumer. |
| motor | motorMotorSim and pmac include asynMotorController/asynMotorAxis and link motor. std installs motor-record databases and save-request files. Pinned pmac's two constructor calls require the macro removed by branch head. Optional uninitialized motor driver submodules are outside the current initialized build and would require a new census if enabled. |
| pcas | No external cas/gdd header or link consumer found in the surveyed roots. The installed loader records cas/gdd as library-only metadata. Verify the module's own real server examples if selected. |

Source evidence is interpreted with configure/CONFIG_MODS_DEPS, configure/RULES_MODS_CONFIG, configure/CONFIG_MODS_IOCSH, carried patches, and each source Makefile's conditions. A _DEPS declaration alone is not a direct consumer. Transitive rebuild scope follows the accepted direct consumers and the real build dependency graph. ADCore's required busy-record templates remain relevant even when its optional BUSY library entry is unset. Recheck local overrides and optional example/submodule selection before any build; no installed tree or hardware behavior was verified here.

##### Base Carry Restart Before Selection

Assessment verified by 2026-10-07T16:12:44Z under D13, following `docs/procedures/upstream-fix-carry-procedure.md`, stages 1-5. D13 reopened the previous selection; D14 records the subsequent decision below. At assessment time, the released 18 Base carries and two site patches were unchanged; no new patch, pin, production rule, or patch-summary row had changed. The later D15 implementation is recorded separately below. This is the owner-requested Base-first restart; the earlier pvxs assessment remains separate evidence rather than input to this panel.

Live GitHub repository, branch, and paginated tag APIs were rechecked. The default branch is `7.0`, its tip is e699b75ba3f18a632feb4bd544dbe4149685ef68, committed 2026-10-05T15:49:28-07:00, and no release tag above R7.0.10 exists. The exact pin is bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77. Fresh local enumeration through that tip contains 164 commits; the released snapshot 53b0fc99af3e562b6581732828e20d4a2f4297a0 contains 156. SHA-set reconciliation yields eight new commits, not an author-date filter. Real changed-file lists and diffs were regenerated for all 164 commits. Released dispositions remain in effect; the two older prerequisites below re-enter as complete units required by the new original-diff chain.

The eight new commits are 7d0b9625, 9edb40d2, 849cff86, 3206c817, 013d97b5, 0b25bd50, e6c7dd04, and e699b75b. Commit-to-pulls API results place 9edb40d2, 849cff86, 3206c817, and 013d97b5 in PR #900, and 0b25bd50 plus merge e6c7dd04 in PR #976. The #976 merge introduces no additional source change. The documentation member 013d97b5 stays inside the complete #900 PR; it is not a separate candidate to remove.

| Funnel Item | Count / Outcome |
| --- | --- |
| Enumerated current pin-to-tip commits | 164 |
| Released-snapshot commits retaining their verdicts | 156 |
| New commits / new carry units | 8 / 4 |
| New units removed as exclusively documentation, CI, or test code | 0 |
| New units deferred at applicability | 1: 7d0b9625 |
| New units surviving to scoring | 3: #900, #976, e699b75b |
| Complete older prerequisite units entering this panel | 2: #753, cf85a1a5 |
| Scored candidates / independent assessors / integer axis values | 5 / 5 / 200 |
| Candidates meeting the recommendation rule | 1: #900, through bug and safety |
| New owner additions / removals recorded after restart | 2 rule-missing prerequisites added / 0 rule-pass removals: #753 and cf85a1a5 under D14; #976 and e699b75b undecided |
| Newly selected carry set | 3 new units: complete #753, cf85a1a5, complete #900; replace existing #934 with RAW934 and retain #949; ordered Stage 6 list recorded in Base Carry Implementation under D15 |

The deferred 7d0b9625 adds an assembler search flag for the embedded GDB helper. Its Makefile hunk applies with exit 0, but the helper and assembly machinery introduced by 4b03e97d7b24cbbb9825ea09dc3e8046f73b24d0 are absent at R7.0.10. Applying the flag alone does not provide that feature. This is an applicability deferral, not a low-score removal.

Complete PR #753 comprises 6d85a363, 209e1f95, 2bd148ab, and 12c56ffc. Carrying only 6d85a363 is not carrying the complete unit. The full PR removes pointer casts across CA, database, standard records, libCom, public headers, tests, and several OS implementations. It also changes taskwd list-node arguments and flex allocation arithmetic. It is not exclusively cosmetic or test code.

| Candidate | Complete Unit | Files | Additions / Deletions | Direct Change |
| --- | --- | ---: | ---: | --- |
| BASE753 | PR #753, four commits | 111 | 375 / 375 | Pointer conversions, list nodes, and flex allocation expressions |
| BASEcf85 | Direct commit cf85a1a5; no associated PR | 1 | 1 / 1 | Correct the channel pointer printed by log_header |
| BASE900 | PR #900, four commits | 5 | 33 / 14 | cantProceed abort policy, unconditional Must failure checks, and RTEMS include order |
| BASE976 | PR #976, commit plus merge | 1 | 1 / 1 | Correct iocRub to iocRun in compiled iocPause help |
| BASEe699 | Direct commit e699b75b | 1 | 1 / 1 | Add the standard ERROR prefix and Ignoring text to an ACF diagnostic |

The immutable ranges below define the actual no-prefix upstream diffs. RAW934 is a different representation of an already released fix, not a sixth new candidate. No manual source or hunk adjustment was used.

| Unit | Before | After |
| --- | --- | --- |
| BASE753 | 85347172c619c360392b28dee47e0041541d4d32 | 12c56ffc954e4cde72c43174ebd11ccd0d523c1e |
| BASEcf85 | 07da9aeb32d89dd7265ece6c0297b8c4d7bbd56b | cf85a1a5eb86928323d4c62d4d3c553f362a7d04 |
| BASE900 | 7d0b9625a7df6365ece37309ca8021e650874391 | 013d97b5a61034f8e11a7697adfb290e577a8dcc |
| BASE976 | 013d97b5a61034f8e11a7697adfb290e577a8dcc | e6c7dd045c2f7bb6fea43961d6a7df1328bc03f7 |
| BASEe699 | e6c7dd045c2f7bb6fea43961d6a7df1328bc03f7 | e699b75ba3f18a632feb4bd544dbe4149685ef68 |
| RAW934 | 93b4598dcdb38b8a5501b3a366c44c15d26799f2 | 33f4d15ff340d4af428d2b111e9d84bbaadf5087 |
| Deferred 7d0b9625 | 53b0fc99af3e562b6581732828e20d4a2f4297a0 | 7d0b9625a7df6365ece37309ca8021e650874391 |

All checks used actual exact-pin `git archive` trees, GNU patch, and unchanged production patch files. Prerequisites were established before scoring. Forty baseline checks comprised 20 standalone applications and 20 omit-one stacks; only #949 alone and the stack omitting #934 failed. The existing #934 -> #949 prerequisite is therefore retained. File overlap alone is not classified as a prerequisite.

| Actual Apply Check | Exit | Consequence |
| --- | ---: | --- |
| Complete #753 alone | 0 | Applies to the exact pin |
| #900 alone / #753 then #900 | 1 / 0 | Original #900 requires the complete #753 unit |
| cf85a1a5 alone / #753 then cf85a1a5 | 1 / 0 | Original diagnostic correction requires #753 context |
| #753 then RAW934 / #753 then cf85a1a5 then RAW934 | 1 / 0 | Original #934 also needs the corrected diagnostic context |
| Released baseline then #753 | 1 | #753 cannot simply be appended to the released stack |
| #753 then shipped #934, with or without cf85a1a5 | 1 | The current adapted #934 representation remains incompatible |
| cf85a1a5 before #753 | 1 | Default mixed commit/PR lexical ordering is insufficient |
| #976 alone / e699b75b alone | 0 / 0 | Independent applicable changes; e699b75b leaves an offset backup |
| Complete explicit 25-step assessment stack | 0 at every step | All five candidates coexist in the tested order; two .orig files remain |

Selecting original #900 entails #753 in full. To coexist with the released validation fixes, selecting #753 or #900 additionally entails cf85a1a5 before the original #934 representation, retaining #949 afterward. The #753/cf85a1a5/#900 units together touch 115 distinct files; #900 itself touches five. This full integration cost is included in fit and locality. Adopting cf85a1a5 independently also entails #753 and the same coexistence work. #976 and e699b75b remain independent choices.

#753 overlaps released #904, #913, #915, #918, #920, #932, #934, #935, #949, and site02. It overlaps #900 in cantProceed.c and e699b75b in asLibRoutines.c. The latter overlap does not require #753. #976 overlaps none of the other candidates or baseline patches. The observed complete assessment order was #753, cf85a1a5, all 20 baseline patches in their existing order with RAW934 replacing only #934, then #900, #976, and e699b75b. This is a tested assessment order, not an adopted Stage 6 list. Proper commit-unit filenames sort before PR filenames; wiring must explicitly preserve #753 before cf85a1a5 if selected, rather than disguising the direct commit as a PR or trusting the default sort.

Five fresh-context assessors ran in the D11 batches of three and two with the same frozen input and rubric. They were forbidden to read the prior Base decisions, scores, audit reports, or any other assessor's results. Each read all five real complete diffs, checked them against regenerated upstream bytes, and returned the same input SHA256, `12a5d65ea5e3a70065358f8470f8b292c4816faf23b73c494fe0996f68fbd0fe`. The five raw score/notes files were saved before aggregation; `panel-result.json` preserves the raw set. The code validated all 200 integer values and all memberships, took each axis's third sorted score, checked it independently against `statistics.median`, then computed totals and OR-rule conditions. No historical score was reused.

| Candidate | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule Conditions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| BASE753 | 0 | 1 | 1 | 0 | 2 | 1 | 3 | 1 | 9 | none |
| BASEcf85 | 0 | 0 | 2 | 0 | 3 | 1 | 3 | 2 | 11 | none |
| BASE900 | 0 | 6 | 6 | 0 | 7 | 4 | 3 | 1 | 27 | bug>=5, safety>=5 |
| BASE976 | 0 | 0 | 1 | 0 | 1 | 0 | 10 | 10 | 22 | none |
| BASEe699 | 0 | 0 | 1 | 0 | 4 | 1 | 9 | 10 | 25 | none |

Raw vectors use security, safety, bug, perf, ops, urgency, fit, locality in that order. These preserve all 200 numerical inputs independently of ignored scratch. The maximum per-axis range is two points, on integration fit; no candidate reaches total>=40 or urgency>=5. The rule is advisory and does not select #900 or discard the other four candidates.

| Candidate | A1 | A2 | A3 | A4 | A5 |
| --- | --- | --- | --- | --- | --- |
| BASE753 | 0,1,1,0,1,0,2,1 | 0,1,1,0,1,0,3,1 | 0,1,1,0,2,1,3,1 | 0,1,1,0,2,1,3,2 | 0,1,1,0,2,1,4,1 |
| BASEcf85 | 0,0,2,0,2,0,2,1 | 0,0,3,0,3,1,3,2 | 0,0,2,0,2,1,2,2 | 0,0,2,0,3,1,3,2 | 0,0,3,0,3,1,4,2 |
| BASE900 | 0,6,6,0,7,4,2,1 | 0,6,5,0,6,4,3,2 | 0,6,6,0,7,4,3,1 | 0,6,6,0,7,4,3,2 | 0,6,6,0,7,4,4,1 |
| BASE976 | 0,0,1,0,1,0,10,10 | 0,0,1,0,1,0,10,10 | 0,0,1,0,1,0,10,10 | 0,0,1,0,1,0,10,10 | 0,0,2,0,2,0,10,10 |
| BASEe699 | 0,0,1,0,4,1,9,10 | 0,0,1,0,4,1,9,10 | 0,0,1,0,4,1,9,10 | 0,0,1,0,4,1,9,10 | 0,0,2,0,5,2,9,10 |

All five assessors personally executed GNU patch checks on real pinned archives; none substituted an internal function. They inspected the shared native build without claiming a personal rebuild. Assessor 1 additionally compared all 116 candidate-target files in its independently applied stack with the actual native-build source: every file matched. Assessor 5 executed all 25 reverse steps and restored the contents and names of all 1,832 original archive files; two .orig extras remained. The parent independently rechecked the real reversed tree and assessor 4's log hashes. Assessor 3's immutable report has a separate erratum correcting the phrase "111 additional files": #753 and cf85a1a5 share camessage.c, so their union is 111, not 112. Scores and observed outcomes are unchanged.

The real shipped Base patch apply/revert targets both exited 0 on the current baseline and restored its exact file set and bytes with no .orig/.rej. The complete original assessment stack was built through unchanged shipped conf.base and build.base targets in an archived environment at 56f7e8c022f334d136449dfcda35c156674f9920, with all six component gitlinks at R7.0.10 and a private writable INSTALL_LOCATION. Both targets exited 0 on Debian 13.7, Linux x86_64, GCC 14.2.0, and GNU Make 4.4.1. This fresh build includes the complete four-commit #753 unit; the earlier single-commit build below does not establish that result. No additional compile/link prerequisite was observed in this combination.

| Focused Execution On The Actual Built Stack | Observed Result | Boundary |
| --- | --- | --- |
| Shipped epicsAtomicTest, epicsLoadTest, taskwdTest, and aslibtest fixtures, assessor 4 | Exit 0 each; 50/50, 4/4, 8/8, and 64/64 | Four actual upstream fixtures, not the entire suite or every #753 path |
| Public cantProceed calls, assessors 1, 4, and 5 | YES logs aborting and exits by SIGABRT; NO logs suspending and times out after four seconds | Child processes are terminated after observation; indefinite behavior and IOC restart are not established |
| Actual NDEBUG epicsMutexMustLock caller, assessor 4 | Real OS mutex failure reaches cantProceed; YES exits by SIGABRT, NO times out after four seconds | Driver uses the actual epicsMutexImpl.h and library; destroys the unlocked pthread mutex while retaining the EPICS wrapper; no internal function replacement. Whole libCom is not an NDEBUG build |
| Actual softIoc help iocPause, assessors 4 and 5 | Exit 0; compiled help contains iocRun | Help path only; an earlier -S attempt stopped before help and is not counted as verification |
| Actual asInitMem with unresolved HAG input, assessors 4 and 5 | ERROR/Ignoring diagnostic emitted; status remains 0; assessor 4 observes the unresolved marker in asDumpHag | Actual parser and resolver run; no client authorization or full IOC activation claim |

Candidate findings: no new candidate-internal runtime defect was established by these limited executions. #753 changes public callbackSetUser and pointer-conversion surfaces on unbuilt platforms; external consumers and non-native compilers are not qualified. Its flex allocation expression uses size_t, while the preceding signed multiplication guard remains, so no comprehensive overflow fix is claimed. #900's explicit Must checks address the NDEBUG-sensitive assertions, but epicsThreadMustCreate resource failure and allocation exhaustion were not exercised; mallocMustSucceed/callocMustSucceed retain separate suspension/retry loops. cf85a1a5 affects printed diagnostic identity only. #976 changes help only; e699b75b changes the emitted error text only, with no new access-policy enforcement. Native runtime observations do not remove the whole-chain integration cost.

Owner Decision: D14. Decision Date: 2026-10-07. Select the complete original #900 chain while preserving the released fixes and avoiding manual source or hunk adjustments. The two rule-missing prerequisites receive adoption decisions because the complete-unit apply checks above establish their necessity.

| Unit | Disposition | Basis |
| --- | --- | --- |
| Complete PR #900 | Select | Total 27; bug>=5 and safety>=5; unconditional Must failure handling and configured cantProceed abort policy |
| Complete PR #753, four commits | Select as prerequisite | Total 9; owner decision because original #900 requires the complete unit |
| cf85a1a5 | Select as prerequisite | Total 11; owner decision because coexistence with original #934 requires the corrected diagnostic context after #753 |
| Existing #934 | Replace representation with RAW934 | Preserve the released fix using its original upstream diff; not an additional new fix |
| Existing #949 | Retain after #934 | Preserve the released fix and its verified #934 prerequisite |
| #976 and e699b75b | No decision recorded | Independent choices; this #900 selection does not discard them |

Decision boundary at D14: the three new units and existing-fix dispositions were selected, but the ordered Stage 6 list, mixed filename order, and production apply/revert path were not yet implemented. The default GNU patch assessment left two .orig backups. Backup policy was an implementation proposal, not a selected upstream fix. Production Base patch hashes and source-checkout cleanliness were unchanged at that observation. D15 and the implementation section below record the subsequent implementation and focused results. Other OSes, RTEMS, Windows, downstream module builds, supervisor recovery, all released-fix runtime regressions, and release qualification remain unverified.

Fresh scratch evidence is under `work/base-carry-restart-20261007/`: full enumerations, SHA reconciliation, real diffs, classification, apply logs, shipped-baseline and native-build records, five immutable assessor outputs and private checks, panel-result.json, medians.json, and the arithmetic program. The immutable source ranges, complete funnel, all numerical inputs, material findings, actual methods, observed outcomes, and limits above are durable; the ignored directory is not the sole decision evidence.

##### Base Carry Implementation

Decision Date: 2026-10-07. D15 accepts and authorizes implementation of the D14 selection after its third-person and second-person decision-record reviews. The focused selected-23 review applied and reversed all 23 original units using GNU patch; all 1,832 original archive files were restored, but camessage.c.orig remained. That apply-only review did not run production Make wiring or a build. D15 selects --no-backup-if-mismatch to prevent that backup; it does not change an upstream hunk.

Stage 6 apply-selection list, recorded before production patch generation. Existing carry totals and bases below retain their released values from patch/README.md; only #753, cf85a1a5, and #900 use the fresh panel. #934 is an original-diff representation replacement with its existing score, not a newly scored fix. The two site patches retain their existing scope. Every shared-file pair is included in overlap and must pass in this actual order.

| Order | SHA / PR | Title | Total /80 | Basis | Overlap |
| ---: | --- | --- | ---: | --- | --- |
| 1 | #753 | Remove needless pointer casts, complete four-commit PR | 9 | owner decision: original #900 prerequisite | cf85a1a5, #900, #904, #913, #915, #918, #920, #932, #934, #935, #949, site02 |
| 2 | cf85a1a5 | Correct server-channel diagnostic pointer | 11 | owner decision: original #934 context after #753 | #753, #934, #949 |
| 3 | b2d2758 | dbPutNotifyBlocker type check | 39 | bug, safety; retained | none |
| 4 | #817 | mbbiRecord COSV/LALM and AFTC, released record hunk | 37 | bug, urgency; retained | none |
| 5 | #837 | macLib mismatched delimiters | 39 | bug, urgency; retained | none |
| 6 | #870 | epicsStrPrintEscaped bounds | 38 | bug, safety, urgency; retained | none |
| 7 | #890 | Fail when makeRPath errors | 25 | bug, owner decision; retained | none |
| 8 | #900 | cantProceed policy and unconditional Must checks, complete PR | 27 | bug, safety | #753 |
| 9 | #904 | caRepeaterThread use-after-free | 42 | total, bug, safety; retained | #753 |
| 10 | #913 | histogramRecord bounds | 51 | total, bug, safety, urgency; retained | #753 |
| 11 | #914 | printfRecord wide-string bounds | 46 | total, bug, safety, urgency; retained | none |
| 12 | #915 | Ring-bytes high-water-mark operands | 30 | bug; retained | #753 |
| 13 | #918 | IOC shell on-error-wait parsing | 39 | bug, urgency; retained | #753 |
| 14 | #919 | UInt64-to-string conversion | 37 | bug, urgency; retained | none |
| 15 | #920 | dbStaticLib UINT64 access | 46 | total, bug, safety, urgency; retained | #753 |
| 16 | #922 | dbJLink comparison | 37 | bug, urgency; retained | none |
| 17 | #932 | Database and CA client validation | 46 | total, bug, safety, urgency; retained | #753 |
| 18 | #934 / RAW934 | RSRV validation, original upstream representation | 52 | total, bug, safety, urgency; retained fix | #753, cf85a1a5, #949 |
| 19 | #935 | caget NULL check | 35 | safety; retained | #753 |
| 20 | #948 | dbChannel_put time-string conversion | 37 | bug; retained | none |
| 21 | #949 | RSRV scalar-string PUT | 51 | total, bug, safety, urgency; retained | #753, cf85a1a5, #934 |
| 22 | site01 | dbYacc end-of-file diagnostic | n/a | existing site patch | none |
| 23 | site02 | dbStatic device-menu bounds | n/a | existing site patch | #753 |

#753 must precede the released fixes it overlaps; the general preference to place a broad overlapping patch last cannot override its proven prerequisite role. Emit #753 and cf85a1a5 as an explicit prefix, then sort the remaining version-matched filenames. This preserves every released filename and their relative order, places #900 in its PR-number position, and retains #934 before #949. Revert reverses this composed list, not a separate filename sort. The existing released b2d2758 sequence 01 is not renumbered; the new cf85a1a5 sequence 02 names its Stage 6 position.

Production files: patch/7.0.10-pr0753-remove-pointer-casts.p0.patch, patch/7.0.10-02-cf85a1a-server-channel-pointer.p0.patch, and patch/7.0.10-pr0900-cantproceed-failure-policy.p0.patch; replace patch/7.0.10-pr0934-rsrv-msg-validation.p0.patch from the RAW934 range above. Preserve all other existing patch bytes. The complete original upstream ranges above govern generation; no added header, curated hunk, or manual source edit is permitted. patch/README.md must contain 21 Base carry rows plus the two site patches, matching the 23-file apply list.

Implementation verified locally under T5 and T6 on 2026-10-07; no commit, push, or landing evidence is recorded. The earlier 25-unit assessment is separate from these selected-23 production-path observations. The three new files and RAW934 were regenerated from their immutable upstream ranges and compared byte-for-byte with the production files. All 40 other existing patch files and configure/RELEASE remain byte-identical to HEAD.

| Original Unit | Production File | SHA256 |
| --- | --- | --- |
| Complete #753 | 7.0.10-pr0753-remove-pointer-casts.p0.patch | 8280c23f2eba1d55c2b60451411f1eea26069d842124ca70d1f27f5a91792623 |
| cf85a1a5 | 7.0.10-02-cf85a1a-server-channel-pointer.p0.patch | 830a7c9fe31cc1c4761d64c8af5a59c13c1d7607e4c299211cc8e02fa6a30741 |
| Complete #900 | 7.0.10-pr0900-cantproceed-failure-policy.p0.patch | 2e822b3e8253d16c879d35f0a74deab1beff4fcd4fedbc330f6b014330888d60 |
| Original #934 | 7.0.10-pr0934-rsrv-msg-validation.p0.patch | 1f0108c8f3d1922faa4254b2af02909619166b6f45d2950587d27ba0aebf55c7 |

T5 used a git archive of environment HEAD plus the actual uncommitted implementation files, and exact archives of the eight source commits recorded in Existing Patch Dependency Cross-check. No Makefile, patch executable, or revert helper was substituted. Each of the 23 Base files passed a GNU patch per-hunk dry-run in the Stage 6 state, followed by the real Base apply target. All 15 shared-file pairs match the overlap table. The shipped Base revert target ran the exact inverse and restored all 1,832 original Base files, names, and modes without backup or rejection residue.

The full shipped make patch and make patch.revert then exited 0. Application named all 42 expected Linux patch files exactly once and printed 187 patching-file lines; every patch's file count matched its real diff. Reversal named those files in the exact inverse order. All eight complete source inventories, SHA256 values, and modes matched the baseline afterward, including the untouched Linux mca tree: 3,915 regular files. Reverting an unapplied Base also exited 0 without source changes. Selecting SRC_VER_BASE=7.0.11 for the patch targets produced an empty list and successful unchanged apply/revert; this selector check is not a Base upgrade.

The patch summary contains all 21 Base carries plus the two site units, matching the 23-file list. The user-facing carry overview, procedure, and target reference describe the explicit #753/cf85a1a5 prefix, the remaining filename sort, exact inverse reversal, and Base backup suppression.

T6 used a separate fresh environment and Base archive, all six recorded component gitlinks, and a private INSTALL_LOCATION in the environment's configure/CONFIG_SITE.local. The actual shipped conf.base and build.base targets exited 0; build finished at 2026-10-07T17:52:51Z. The installed libCom.so, libdbCore.so, and softIoc exist under native-install/1.5.0/debian-13/7.0.10/base. An earlier command-line INSTALL_LOCATION invocation compiled with exit 0 but installed at the private root because that assignment reached the sub-make; it is not the final T6 installation result.

| Actual Fixture Or Runtime Path | Observed Result | Scope |
| --- | --- | --- |
| modules/libcom/test/O.linux-x86_64/epicsAtomicTest | Exit 0; 50/50 TAP checks | Actual upstream atomic fixture |
| modules/libcom/test/O.linux-x86_64/epicsLoadTest | Exit 0; 4/4 TAP checks | Actual upstream loading fixture and its built library |
| modules/libcom/test/O.linux-x86_64/taskwdTest | Exit 0; 8/8 TAP checks | Actual upstream task watchdog fixture |
| modules/libcom/test/O.linux-x86_64/aslibtest | Exit 0; 64/64 TAP checks | Actual upstream access-security fixture |
| Installed libCom cantProceed, EPICS_ABORT_ON_ASSERT=YES | Aborting diagnostic; SIGABRT, process return -6 | Direct public API call in a child process; core dumps disabled |
| Installed libCom cantProceed, EPICS_ABORT_ON_ASSERT=NO | Suspending diagnostic; no exit within four seconds | Observation ends by terminating that child; indefinite behavior and IOC restart are not established |

All four fixture logs contain their complete numbered TAP plan, only successful checks, and no bailout. The actual installed libCom SHA256 is 49981ebfc9739c9585a654fbba5fc3e718fb70710ae4360799d8bd9a5bce220d; the final native build log SHA256 is 78ea472d1bb76aeeb9884ddbf5cb0c33490deeba476879c6183d776f71c914b0. All eight original source clones were rechecked clean after verification. Raw logs and content-free execution/check programs are retained under work/base-carry-implementation-20261007-cv4lu_hw/; T5-result.json SHA256 is e58ea86c4fc243c4ec02adcbf4e03a468d466fb8cad4c291914b3b0477c402aa, and native-check/T6-result.json SHA256 is cda607b3e192c33ac0d10e8a0c328e939bb67dd378df41a48f49bbef84b61b65.

Verification limits: other platforms, CI/VM qualification, strict installed-tree dependency verification, downstream consumer builds, all released-fix runtime regressions, RTEMS, thread-resource or allocation exhaustion, NDEBUG builds of all libCom, supervisor recovery, and release qualification remain unverified by T5-T6. No per-fix runtime proof is inferred for the unexercised #753 paths or cf85a1a5 diagnostic identity. The selected Base work and focused review are complete locally; pvxs carry choices and thirteen-module decisions remain pending, so M1 remains In progress and M2-M5 retain their recorded state.

###### Base Revert Correction And Review

Completion recorded: 2026-10-07. The fresh Base assessment, selected original #900 dependency chain, production wiring, native focused checks, and corrected partial-stack reversal are complete within the authorized local scope. The selected 23-patch list, upstream patch bytes, and module pins are unchanged by the revert correction. The reviewed tools/revert_patch.bash SHA256 is 3c0c24bbedd3e65c7f4225ae0303e8def66a8859514c0aa1096bccb2c1a6e04e. No commit, push, landing, or release qualification is established by this completion record.

Private prerequisite preparation runs in reverse order, then forward order. Reverse only uniquely confirmed applied patches, and defer only checked forward/reverse 1/1 mismatches during reverse preparation. Forward preparation must resolve every prerequisite to a checked 0/1 or 1/0 state, and every private mutation must succeed. Confirm absence only when the selected patch checks forward 0/reverse 1. Ambiguity, missing input, or command errors fail classification without changing real source at classification entry; reversals completed before that entry remain in place.

T7 ran the actual shipped helper and Make targets against exact pinned source archives. All Base prefixes k=0 through k=23 reverted successfully in the exact inverse of the applied prefix, with only confirmed unapplied patches skipped and complete source inventories restored. Incomplete #753, real conflicts, missing prerequisites, malformed GNU input with dry-run statuses 2/2, and ambiguous GNU input with statuses 0/0 exited 2 and preserved source at classification entry. A later conflict retained 15 already completed reversals. Failure at the eighth application stopped before later patches; reverting that partial state also refused safely. Space-containing source paths and existing .orig/.rej files were preserved as checked.

The corrected helper also passed the real full Linux make patch/patch.revert round trip: all 42 patch files applied and reversed in their exact inverse order. Eight complete trees matched fresh extraction of the original archives, including file names, bytes, permission modes, and symlinks; the inventories contain 3,915 regular files. Unapplied pvxs reversal preserved all source trees. bash -n, the ShellCheck warning gate, and the full ShellCheck inventory each exited 0 with no diagnostics.

T8 independently exercised nine Base prefixes: 0, 1, 2, 7, 8, 17, 18, 22, and 23. Actual incomplete prerequisites, duplicate function content, missing input, GNU 0/0 ambiguity, and directory input producing GNU 2/2 all stopped without changing source at classification entry. A later directory error retained 15 prior reversals. The independent full twelve-patch pvxs apply/revert restored its source, and repeated unapplied reversal remained unchanged. Separate author executions through the actual repository Make targets restored all thirteen pvxs prefix states and preserved independent local edits at Base prefixes 2 and 17.

Code review 2 verdict: accept after one independent agent and one rebuttal exchange; no must-fix, minor finding, or residual disagreement. The observed cases cover R1 valid partial-stack recovery, R2 refusal of incomplete/conflicting/ambiguous/error input, R3 preservation of source at classification entry and preceding reversals, and R4 unchanged public options, actual inverse order, and pvxs behavior. The accepted private-preparation rule is the one stated above.

Evidence files and their identities:

| Evidence | SHA256 |
| --- | --- |
| work/base-revert-fix-20261007-l_8rop88/results.json | 06c876a0149efb043d2d75100d9a98842141fb9188b5b367dee59a7cf373a3c6 |
| work/revert-code-debate-author-n8zix9hk/results.json | 4270f41af3affa8dd1ed5c0402fda6766a170bdf4ad5d90f864312ac712e0c54 |
| work/revert-independent-20261007-67dBHx/observations.json | ec72dba594bc70cb60954a6caee9c8e7738024d78990bcb5be5a348263e5c371 |

The configuration snapshot, content-free execution drivers, and raw logs remain in those ignored work directories. These local evidence files are not committed deliverables. Actual private apply/reverse command failure and private mktemp failure were not reproduced or executed; their explicit error guards were inspected, but no execution result is claimed for those branches. The GNU 2/2 temporary-file error occurred before private mktemp and establishes only refusal at the initial dry-runs. This limit produced no additional code finding in the completed review. T6 retains its earlier dated native-build result; T7-T8 add helper verification rather than a new native build or release qualification.

##### Earlier Base And pvxs Carry Assessment

The Base selection and scores in this earlier assessment are historical under D13. They are not input to the fresh Base candidate set or panel. The pvxs assessment retains its recorded prospective scope; this Base-only restart does not re-score it.

Observed at 2026-10-07T07:19:32Z under the request to proceed with the carry procedure. This assessment follows `docs/procedures/upstream-fix-carry-procedure.md`; the thirteen module-update recommendations above are not eight-axis carry scores. Base and pvxs were surveyed together. This evidence does not authorize Base patch changes under M3.

Live GitHub repository metadata, default-branch commit objects, and tag listings matched the local assessment objects. Full local `git rev-list --reverse` enumerations were reconciled by SHA against the archived decision-record snapshots, not by author date. Real per-commit diffs and changed-file lists were retained, including first-parent merge diffs.

| Track | Current Pin | Survey Tip | Full Range | Previous Snapshot | New Commits | Route |
| --- | --- | --- | ---: | --- | ---: | --- |
| Base | R7.0.10, bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77 | e699b75ba3f18a632feb4bd544dbe4149685ef68, 2026-10-05 | 164 | 53b0fc99af3e562b6581732828e20d4a2f4297a0, 156 commits | 8 | No newer release tag; carry refresh |
| pvxs | 1.5.2, 8e00eaecdee5ce8a474704e70d820e6f92693fa1 | d23de00df491fc22fbebf243bb7dfefd1f27d4f8, 2026-09-30 | 73 | 788f838dfcaffaf1306355179c179dea1158b9a5, 29 commits | 44 | Published 1.5.3 takes priority over a new 1.5.2 carry |

The pvxs 1.5.3 tag is 25ca43df4db909c0b1a445fb705fc81582617625. Of the 44 new commits since the archived survey, 42 are contained in that release and two follow it. Those two were examined against 1.5.3 as a proposed baseline; the configured pin remains 1.5.2. Existing carry retirement evidence remains in Existing pvxs Carry Assessment above.

Base's eight new commits form four carry units. PR #900 contains 9edb40d2, 849cff86, 3206c817, and the documentation commit 013d97b5. PR #976 contains 0b25bd50 and its merge e6c7dd04; the merge introduces no additional change. Direct commits 7d0b9625 and e699b75b are separate units. PR membership was verified through the GitHub commit-to-pulls API. No prior adopted, deferred, or rejected unit was rescored.

| Track / Unit | Applicability | Apply Check | Dependency / Disposition Before Scoring |
| --- | --- | --- | --- |
| Base 7d0b9625, GDB helper assembler search path | Missing target feature | Exit 0 at R7.0.10 | Defer: embedded GDB helper from 4b03e97d is absent at the pin and is not supplied by the existing carries. Applying a compiler flag alone does not supply that feature. |
| Base PR #900, cantProceed and EPICS_ABORT_ON_ASSERT | Target APIs exist | Exit 1 at R7.0.10; exit 0 after the earlier cantProceed.c cast-only change | Retain for scoring. The verbatim diff depends on the removal of `(void *)` in 6d85a363; a curated rebase is an alternative requiring a later decision. Required cantProceed, envGetBoolConfigParam, and EPICS_ABORT_ON_ASSERT declarations exist at the pin. |
| Base PR #976, iocPause help spelling | Target string exists | Exit 0 at R7.0.10 | Retain for scoring: an executable IOC shell help string changes from iocRub to iocRun; not discarded merely because it is a cosmetic one-word change. |
| Base e699b75b, ACF lookup error logging | Target path exists | Exit 0 at R7.0.10 | Retain for scoring. Changes the emitted diagnostic; ERL_ERROR already exists at the pin. |
| pvxs a9f8b7b3, address parsing | Target path exists at proposed 1.5.3 | Exit 0 at 1.5.3 | Retain for prospective scoring; changes address parsing and normalization, not only function naming. |
| pvxs d23de00d, reject an entirely invalid address list | Target path exists at proposed 1.5.3 | Exit 1 alone; exit 0 after a9f8b7b3 | Retain with its prerequisite. The second commit cannot be treated as an independent clean carry. |

Apply checks used the unmodified upstream diffs and separate Git indexes populated by `git read-tree` from the exact upstream baseline trees, followed by `git apply --check --cached`. Sequential checks applied the prerequisite to the scratch index before checking the tail. The Base context check used only the real upstream 6d85a363 diff for cantProceed.c; it does not establish that the whole prerequisite commit should be adopted. These are apply-only observations. No module build, runtime test, or shipped `make patch` / `make patch.revert` verification ran.

Assessment artifacts are under `work/carry-150-assessment-flyb51xh/`: full enumerations, SHA deltas, changed-file lists, real diffs, `assessment.json`, and `sequence-checks.json`. Scratch indexes leave the assessment source checkouts and repository index unchanged. The immutable ranges and outcomes above are the durable evidence; scratch files are not required to reconstruct them.

The five-reviewer assessment completed under D11 at 2026-10-07T07:31:51Z. Three Base units survived the applicability assessment; two pvxs units were assessed prospectively against 1.5.3. Five fresh-context reviewers ran in batches of three and two, with the same candidate input and instructions forbidding access to other reviewers' results. The frozen input is `work/carry-150-assessment-flyb51xh/panel/input.json`, SHA256 `7fbc6b84055e1baf862ef9d3a52499987cc30ea14abb896f177354731c6e6593`. All five returned this exact input hash and five complete candidate rows. All 200 axis values passed integer/range validation before aggregation. No missing reviewer, candidate, or axis was omitted from the calculation.

##### Earlier Five-reviewer Carry Scores

Each reviewer read all candidate diffs and baseline source, performed private-index apply checks, and recorded findings and unexecuted checks. Raw `reviewer-1.json` through `reviewer-5.json` were saved before aggregation; `panel-result.json` retains all five results and `medians.json` retains the computed table. `panel/aggregate.py` calculated the per-axis medians, totals, and OR-rule conditions. A separate arithmetic check matched every median to the third sorted observation and confirmed every total. Scores are advisory; no candidate was adopted by this assessment.

| Candidate | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule Conditions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| PVXS-d23 | 5 | 3 | 6 | 0 | 6 | 4 | 3 | 4 | 31 | bug>=5 |
| BASE-900 | 0 | 6 | 6 | 0 | 7 | 4 | 4 | 2 | 29 | bug>=5, safety>=5 |
| BASE-e699 | 0 | 0 | 1 | 0 | 3 | 1 | 10 | 9 | 24 | none |
| BASE-976 | 0 | 0 | 1 | 0 | 1 | 0 | 10 | 10 | 22 | none |
| PVXS-a9 | 0 | 0 | 2 | 1 | 3 | 1 | 3 | 4 | 14 | none |

BASE-900 and BASE-976 identify the PR units above. BASE-e699 identifies e699b75ba3f18a632feb4bd544dbe4149685ef68; PVXS-a9 and PVXS-d23 identify a9f8b7b32f4145e97ff694ac22f5f8422a176e64 and d23de00df491fc22fbebf243bb7dfefd1f27d4f8. Totals below 40 can meet the rule through bug, safety, or urgency >=5; neither rule-passing unit reached total>=40.

Raw vectors below use the axis order security, safety, bug, perf, ops, urgency, fit, locality. These preserve the numerical audit independently of the ignored scratch directory.

| Candidate | R1 | R2 | R3 | R4 | R5 |
| --- | --- | --- | --- | --- | --- |
| BASE-900 | 0,6,6,0,7,4,4,2 | 0,6,6,0,7,4,4,2 | 0,5,5,0,7,4,4,2 | 0,6,6,0,7,4,4,2 | 0,6,6,0,7,5,4,2 |
| BASE-976 | 0,0,1,0,1,0,10,10 | 0,0,1,0,2,0,10,10 | 0,0,1,0,1,0,10,10 | 0,0,1,0,2,0,10,10 | 0,0,1,0,1,0,10,10 |
| BASE-e699 | 0,0,1,0,3,1,10,9 | 0,0,1,0,4,1,10,9 | 0,0,1,0,3,1,10,9 | 0,0,1,0,4,1,10,9 | 0,0,1,0,3,1,10,10 |
| PVXS-a9 | 0,0,2,0,2,0,3,4 | 0,0,3,2,3,1,3,4 | 0,0,3,1,3,1,3,3 | 0,1,2,0,3,1,2,4 | 0,0,2,1,2,0,3,3 |
| PVXS-d23 | 5,3,5,0,5,2,3,5 | 6,3,6,0,6,3,4,4 | 6,4,6,0,6,5,3,4 | 5,3,6,0,6,4,3,5 | 5,3,5,0,5,4,3,4 |

Candidate findings and decision constraints:

- BASE-900 changes shared libCom failure behavior: MustCreate/MustLock checks remain active under NDEBUG and cantProceed honors EPICS_ABORT_ON_ASSERT. All five reproduced the verbatim apply failure and the cast-only context diagnostic. No new defect was found in the inspected changed failure paths, but mallocMustSucceed/callocMustSucceed retain separate suspension loops. The panel did not choose a backport or authorize the broad cleanup; D12 subsequently selected the original #900 and full 6d85a363 diffs. Failure-path runtime proof and RTEMS include-order compatibility remain unverified.
- PVXS-a9 removes required=true validation during environment/definition import. At a9f8b7b3, src/config.cpp:401-402 passes server interfaces to split_into; parseAddresses at 275-286 discards invalid tokens; server Config::expand at 470-476 substitutes a wildcard if none remain. All five identified this changed control flow. PVXS-d23 adds the all-invalid guard, but must carry a9 first and does not restore rejection of every invalid member in a mixed list.
- All five identified the remaining name-server interaction: a9f8b7b3 src/config.cpp:567-568 retains invalid tokens, while the unchanged src/client.cpp:621-630 catches a setAddress failure without skipping the entry. SockAddr defaults to AF_UNSPEC and setAddress assigns its receiver only on success. d23 does not validate nameServers. Source inspection confirms the path; no network failure or crash was executed or claimed.
- R1, R4, and R5 also identified default-port alias duplication. Candidate Config::expand deduplicates before the client consumer supplies the default port, so omitted-port and explicit-default-port forms can become duplicate search destinations afterward. The source ordering and port-sensitive comparison were independently checked; no packet-count or performance measurement ran.
- PVXS-d23's added upstream test was read, not run. It checks client addressList with autoAddrList=false; it does not prove server binding behavior, name-server handling, or the other prerequisite interactions. The throw also precedes automatic destination expansion, so the chain changes that failure policy. Its security and urgency assessments are conditional on the entire chain and affected configuration, not evidence of a fault in the configured 1.5.2 deployment.
- BASE-976 and BASE-e699 change help/diagnostic text only within the inspected diffs. They apply cleanly and miss the scoring rule; their low scores do not authorize deleting existing functionality or changing earlier carry decisions.

Panel verification boundary: source inspection and exact upstream apply checks only. No panel reviewer ran a full build, the shipped testconfig binary, IOC startup, network binding, failure injection, or the environment's actual patch/revert path. D12 subsequently selected BASE-900 and its original-diff prerequisite; the other four scored-unit decisions and all thirteen module-update decisions remain pending. A decision on the pvxs chain must account for its prerequisite and remaining source findings, rather than selecting the rule-passing tail alone. The following cross-check records later execution separately from panel evidence.

##### Existing Patch Dependency Cross-check

This cross-check predates D13. Its proposed Base stack used the single 6d85a363 commit, not the complete four-commit PR #753 discovered in the fresh assessment. Its proposed build and round-trip outcomes are historical evidence; Base Carry Restart Before Selection above records the current complete-unit scope and verification boundary.

Observed 2026-10-07, against environment commit 56f7e8c022f334d136449dfcda35c156674f9920. Scope: all 40 active patch files across eight pinned sources, including the Darwin-only mca recipe. The commented pvxs-1.3.1 patch is inactive and excluded. No production patch, source, pin, or apply recipe changed.

The check extracted actual tracked environment and source trees with `git archive`, verified the eight source clones were clean and pin-matched, and executed their real Makefile recipes in isolated directories. It used no replacement make, patch executable, or revert helper. Current source identities are Base bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77, pvxs 8e00eaecdee5ce8a474704e70d820e6f92693fa1, measComp c38974e85c59429b8ba48ed320681ba0296fb924, opcua f9b0c92faabf466e389782b7747d2162456a2b20, feed-core 0472d88f3a42ad8adde5b32d7e348efe43d84199, QPC 913fad41df170063d910d0b4fdb083de696fac36, StreamDevice 668d1d525509604ab4ccd7382022dfb469c99841, and mca 687d563206d59de9097e28e95e32ad09ebcc2522.

| Track | Active files | Standalone apply successes | Required earlier carry |
| --- | ---: | ---: | --- |
| Base R7.0.10 | 20, including two site patches | 19 | #949 requires #934 |
| pvxs 1.5.2 | 12 | 11 | 04-0b3fcca requires 02-090bf5f |
| measComp | 2 | 2 | None found by apply checks |
| opcua | 2 | 2 | None found by apply checks |
| feed-core | 1 | 1 | None found by apply checks |
| QPC | 1 | 1 | None found by apply checks |
| StreamDevice | 1 | 1 | None found by apply checks |
| mca, Darwin recipe only | 1 | 1 | None found by apply checks |

The real Linux `make patch` and `make patch.revert` both exited 0. Application logs named all 39 expected active files with no missing or unexpected patch and 70 `patching file` lines. Whole-source file-set and SHA256 comparisons were identical after reversal for all eight archived trees, including the untouched Linux mca source.

All 40 patches were checked individually against exact pinned files. Only #949 and pvxs 04 failed alone. Removing each of the 20 Base and 12 pvxs patches in turn produced only two failing stacks: omitting #934 rejected #949, and omitting pvxs 02 rejected 04. Each prerequisite/tail pair also applied successfully with no other carry present. Both prerequisites are already included before their tails in the shipped order; no missing apply prerequisite was found in the existing set. These mechanical checks do not prove behavior independence or every build dependency.

There are eleven shared-file pairs: Base #934/#949 share camessage.c; pvxs has ten pairs involving the CLI changes, pvalink changes, and callback/diagnostic changes. Nine of the eleven pairs are overlap without an observed apply prerequisite. The full shipped order succeeded. Baseline declarations were inspected for INVALID_DB_REQ, ANSI_MAGENTA, taskwdRemove, cvtUInt64ToString/cvtUInt64ToHexString, client OperationBase::onWorker, and Connected/Disconnect::time. The measComp TC-32 patch's ulDevGetConfig and DEV_CFG_HAS_EXP declarations were confirmed in actual upstream uldaq v1.2.1 src/uldaq.h, matching the inspected vendor environment pin. This is source/API evidence, not an installed vendor-library or hardware test.

Historical exceptions remain explicit: `docs/archive/base-carry-1.3.0.md` records per-hunk adjustment of #837 and #934 for R7.0.10, and fix-only curation of #817. D12 requests original upstream diffs for the new carries; it does not silently reverse every historical carry decision.

The mca apply and revert recipes were also executed on Linux with the Darwin branch selected. Both exited 0 and restored the original Makefile bytes, but an offset of -1 generated mcaApp/CanberraSrc/Makefile.orig, which remained after revert. This is a failed residue-free restoration check, not a missing patch prerequisite. Linux execution with a forced platform selector does not satisfy deferred M10's requirement for real macOS verification.

D12 selects original upstream commit 6d85a36397de0666f12dca2054c47eb0b3742849, 111 files, and the complete merged PR #900 diff from 7d0b9625a7df6365ece37309ca8021e650874391 to 013d97b5a61034f8e11a7697adfb290e577a8dcc, five files. The broad cleanup shares files with ten existing Base patches; #900 does not share a file with an existing carry. Four actual Make variants established the integration boundary:

| Diagnostic stack | make patch | make patch.revert | Source restoration |
| --- | --- | --- | --- |
| Current stack plus both selected originals | Exit 2 at existing #934, hunk 4 | Not run after failure | Failed stack retained for inspection |
| Both originals with upstream-original #934 substituted | Exit 2 at #934, hunk 4 | Not run after failure | Failed stack retained for inspection |
| Both originals, cf85a1a5, and upstream-original #934 | Exit 0; all 42 Linux patches observed | Exit 0 | Tracked Base bytes restored; camessage.c.orig remained; other seven source trees identical |
| Same original chain with Base apply --no-backup-if-mismatch | Exit 0 | Exit 0 | All eight complete source file sets and SHA256 values identical; no .orig/.rej residue |

The additional original commit cf85a1a5eb86928323d4c62d4d3c553f362a7d04 corrects the log_header pointer. It supplies context required by original #934 after 6d85a363. The #934 original is the PR-unit diff from 93b4598dcdb38b8a5501b3a366c44c15d26799f2 to 33f4d15ff340d4af428d2b111e9d84bbaadf5087, not a wider branch range containing unrelated commits. No source or hunk was manually edited in any diagnostic variant. Filename sorting places the cleanup and pointer fix before the PR patches and #900 before #904. #934 remains before #949.

The backup-policy proposal changes only the Base apply command in configure/RULES_FUNC to pass --no-backup-if-mismatch, matching the existing pvxs policy. The shipped revert helper already suppresses new backups. All Base patch bytes in the proposal matched the preceding original-diff variant exactly; no upstream code adjustment was needed. A further real apply compared all 133 Base patch-target files byte-for-byte with the successfully native-built original chain: every file matched. Its subsequent real revert also exited 0. This policy was tested only in the isolated proposal and is not yet a production change. It does not change the separate Darwin mca apply recipe or remove the observed mca backup.

Native build results used the shipped configuration and build targets, actual pinned Base component gitlinks, and separate writable install roots on Debian 13 with GCC 14.2.0:

| Source combination | Real targets | Finished At, UTC | Result |
| --- | --- | --- | --- |
| Current Base with all 20 carried/site patches and six bundled components | conf.base, build.base | 2026-10-07T08:08:07Z | Exit 0 |
| Proposed Base with both originals, cf85a1a5, original #934, and remaining patches | conf.base, build.base | 2026-10-07T08:08:10Z | Exit 0 |
| Current pvxs 1.5.2 with all twelve carries and current patched Base | PVXS clone, patch.pvxs.commit.apply, conf.pvxs, build.pvxs | 2026-10-07T08:14:19Z | All exits 0, including loader metadata generation |

The pvxs module build requires a real Git checkout for the loader's configured-tag check. An initial archive-source invocation completed compilation but exited 2 at metadata generation because tags/1.5.2 could not resolve. The successful invocation used the real shipped PVXS clone target with a local Git transport, checked out the exact pin, applied the actual twelve patch files, and rebuilt through build.pvxs. No identity check was bypassed. The archive failure remains in the raw results and is not counted as a successful module build.

Installed files were observed for libCom.so, libdbCore.so, softIoc, libpvxs.so, and softIocPVX. The generated pvxs cfg/iocsh.conf, checksum, and build-record exist; the loader configuration records version 1.5.2, Base 7.0.10, linux-x86_64, libpvxs.so, and libpvxsIoc.so. The real checkout HEAD and tags/1.5.2 both resolve to 8e00eaecdee5ce8a474704e70d820e6f92693fa1. This is produced-file and metadata evidence, not IOC runtime proof.

No additional compile/link prerequisite was missing in these Debian 13 core builds. Local-module builds, native macOS, other release OSes, RTEMS, failure-path runtime proof, and full release qualification remain outside this result. The original eight assessment source repositories were rechecked clean; changes are confined to isolated verification environments and this canonical document.

Historical selection state before D13: the two D12 carries had been selected, but production patch generation/wiring was incomplete. D13 reopens that selection for a fresh assessment and owner decision. The cf85a1a5 addition, #934 original replacement, and backup policy needed for residue-free reversal remain examined proposals; none is selected by an apply success. The existing release patch directory and README remain unchanged. Raw observations and candidate patch files are in `work/patch-dependency-audit-08ouqn3g/`; the immutable refs, methods, outcomes, and limits above are historical evidence and do not replace the fresh derivation.

##### Closure Evidence

Selected Base carry work is complete locally on 2026-10-07, with the fresh assessment, selected-chain implementation, focused verification, and second code review recorded under T4-T8. No commit or landing evidence is recorded yet. M1 remains In progress until the remaining pvxs carry and thirteen-module decisions and release comparison are complete; this partial completion does not close the candidate survey.

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
