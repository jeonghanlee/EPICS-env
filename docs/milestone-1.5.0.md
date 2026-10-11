# Work Register

Release line: 1.5.0
Milestone index: 1.5.0
Canonical path: `docs/milestone-1.5.0.md`
Canonical branch or ref: `release-1.5.0`
Git upstream: `origin/release-1.5.0`
Remote tracker: `jeonghanlee/EPICS-env`; [1.5.0](https://github.com/jeonghanlee/EPICS-env/milestone/7), number 7, open; observed by 2026-10-08T18:38:33Z through `gh api repos/jeonghanlee/EPICS-env/milestones/7`; remote updated_at 2026-10-08T18:37:58Z. Three open issues (#98-#100) and 22 closed issues (#96, consolidated #97, and all 20 closed Backlog issues) are assigned to this milestone.

Next session entry point: Continue M15 under D33-D37. Under D37, only Rocky 8 remains as an incremental guest for the original mca/measComp software checks; the Ubuntu 24, Rocky 10 and Ubuntu 26 software checks run once on the final combined tree under M5. Debian 13 and Debian 12 original mca/measComp software consumer paths and setup-failure cleanup pass. Debian 12 evidence retrieval and actual shutdown/preservation are verified by 2026-10-09T09:26:53Z. The next retained guest is Rocky 8. Its restart request is delivered; the request-status record at 2026-10-09T16:08:33Z confirms no READY response and an independently observed shut off state. Await the provisioning owner's separate restart authorization and verified READY before software checks. Run only one guest at a time. Debian 13, the fresh Debian 12 guest, and Rocky 8 have observed core scan/MDA checks, seven additional current-pin consumer builds, original asyn testEpics data paths, and original std trend scans. Debian 12 evidence was copied to the host and hash-verified; its finished notice was processed and actual shutdown with disk preservation was confirmed. Rocky 8's final audit and evidence retrieval passed; the provider processed its finished notice and actual shutdown with disk/definition/seed preservation was confirmed at 2026-10-09T01:15:31Z. Ubuntu 24 now has a verified private handoff dated 2026-10-09T02:13:08Z; requester key-only SSH, sudo, fresh workspace absence, OS/resources and cloud-init completion were independently checked at 2026-10-09T02:18:52Z. Actual prerequisites and the same frozen candidate transport passed; all 32 core build stages completed at 2026-10-09T02:27:48Z. The original decoder, scan/MDA and current-pin consumer checks pass, with final audit at 2026-10-09T02:44:08Z and host evidence retrieval verified at 2026-10-09T02:44:58Z. Requester read-only lifecycle checks at 2026-10-09T03:57:55Z and network checks at 2026-10-09T03:58:16Z confirm Ubuntu 24's expected UUID, shut off state, persistent definition, disk/creation-record/seed and live/persistent reservation preservation. The provider's actual completed shutdown response was read. Its NVRAM path remains in the definition; physical file existence is not independently verified. Rocky 10's real core/consumer subset now passes: 32 core stages, 55 consumer/vendor stages, original decoder, eight independent runtime cases and final identity/lifecycle audit by 2026-10-09T04:36:42Z. Host retrieval verifies all 374 manifest files at 2026-10-09T04:37:15Z. The provider completed the matching finished notice. Requester read-only lifecycle and live/persistent network checks at 2026-10-09T04:39:59Z confirm Rocky 10 shut off with persistent definition, disk/creation-record/seed and reservations preserved. The NVRAM path remains configured; physical file existence is not independently verified. Ubuntu 26 has a completed READY response and private handoff dated 2026-10-09T04:45:01Z. Requester read-only host/guest checks at 2026-10-09T04:47:26Z-04:47:28Z confirm Ubuntu 26.04 LTS, key-only SSH/sudo, two CPUs, configured 4 GiB memory, 20 GiB disk, expected UUID/reservations and an absent workspace. cloud-init is done/errors=[] with the disclosed recoverable password warning and exit 2 retained. Actual prerequisites and frozen candidate transport pass. All 32 core stages complete at 2026-10-09T04:56:27Z; the original decoder completes at 2026-10-09T04:56:42Z with 22 original files unchanged. The point/delay case passes at 2026-10-09T04:56:53Z with NPTS/CPT=4, three 0.001-second delays and observed cleanup. The MDA case completes at 2026-10-09T05:04:45Z using the unchanged original request: a real 364-byte file decodes to rank 1, four requested/completed points and detector values 0 1 2 3; saveData advances scanNumber 0 -> 1 with no retries or abandoned writes. The independent setup-failure case observes cleanup. All 55 consumer/vendor stages pass by 2026-10-09T05:10:05Z; consumer runtime completes by 2026-10-09T05:10:19Z. The final identity/lifecycle audit passes by 2026-10-09T05:10:31Z, and all 374 evidence files pass host size/hash checks at 2026-10-09T05:10:47Z. A separate fresh selected-scan build without its C17 append exits 0 at 2026-10-09T05:11:52Z; all 50 coherent current-pin consumer comparison stages exit 0 by 2026-10-09T05:20:14Z. Comparison audit and host retrieval verify 118 evidence files at 2026-10-09T05:20:45Z. The provider completed the matching finished notice. Independent requester checks at 2026-10-09T05:22:47Z confirm the expected UUID, shut off state, persistent definition, disk/creation-record/seed and live/persistent reservations preserved. The configured NVRAM path remains; actual physical file existence is not independently verified. D35 accepts and authorizes removal of sscan's C17 append; the changed configuration target is verified below. The subsequent actual Ubuntu 26 post-C17 runtime verification passes by 2026-10-09T07:47:30Z: changed configuration matches the real no-C17 build, eight original-fixture cases and a fresh initialized-map scan recheck pass, and all 1,106 evidence files are retrieved and hash-verified at 2026-10-09T07:47:32Z. Requester checks at 2026-10-09T07:50:35Z confirm the restarted guest is shut off with its persistent definition, disk/creation-record/seed and live/persistent reservations preserved; physical NVRAM file existence remains unverified. Continue from the Rocky 8 request status in Debian 12 Software Consumer Verification below with D36's software-only equipment boundary; remaining configured consumer software/transitive/layer paths run incrementally on Debian 13 and Rocky Linux 8.10 and, under D37, once on the final combined tree under M5. Until the provisioning owner's Rocky 8 authorization arrives, no guest action and no other module implementation is authorized; the remaining incremental software checks that need no guest may continue natively on Debian 13 under D33's workspace bound and D36's continuation authority, and the owner chooses which Ready item (M2, M3 or M13) to authorize next. One guest runs at a time and capacity is rechecked before every creation. D36 excludes actual mca/measComp equipment acceptance; their original software startup on Rocky 8 (incremental) and, under D37, on Ubuntu 24, Rocky 10 and Ubuntu 26 (final combined tree), and other configured transitive/layer consumers remain Pending, so M15 is In progress. Preserve `work/sscan-bump-20261008` and its failed and successful evidence within the 8 GiB source/install workspace bound. Shared issue #98 tracks all ten updates under D32; do not create separate module issues. Other module pins and the twelve pvxs carries remain unchanged. The dependency order remains selected Base and unchanged sequencer, M15 sscan, M14 calc, unchanged asyn rebuild, then M16 lua/M17 std/M18 busy/M19 scaler; M20 follows Lua and busy. M2 pyDevSup, M3 pvxs, and M13 caPutLog have only Base prerequisites. Other implementation, commit/push, and GitHub/release actions need their separate authority. Milo and final release plans remain draft; Open G2 keeps M20/M5 Blocked. M1 is Complete; D8/D18 exclusions and the Release Runbooks remain in force.

This is the initial release-line plan. D9 authorizes only the branch-opening version correction; the remaining implementation and release actions require their recorded authority. Its baseline is `4d521e7a0f05163d39541c0357e966397433b027`; the published 1.4.0 tag resolves to `5326c981912566810f763cbe12aba6509bbdb7c4`. Completed changes since 1.4.0 include the installed-module loader, build and environment corrections, two Base site patches, loader fixtures and tests, documentation, and CI changes. They belong in the release comparison and final verification, not new implementation milestones.

This document is the current work register on `release-1.5.0`. The retained `docs/milestone-84ee626.md` is a historical snapshot of master at the baseline commit, not an active plan on this branch. Completed work and its evidence remain there. Seven unfinished work items and the initialization plan gate are retained below in Backlog; the former OPC UA server work continues as M4 with the owner-selected Milo scope. This is a release-branch consolidation, not a modification of the live master branch.

## Milestone

### Release Runbooks

Follow the installed `epics-env-pipeline/SKILL.md` runbook for EPICS environment installation, verification, and ship runs on per-OS guests, `release-cycle/SKILL.md` for release-cycle management, and `git-workflow/SKILL.md` for Git and GitHub release operations. Use `milestone-tracking/SKILL.md` for this document's register schema, plan review, and status, `agent-collaboration/SKILL.md` for requests to the Layer 2, Layer 3, and guest provisioner sessions, and `agent-review/SKILL.md` for review passes. The tracked map `docs/procedures/epics-env-release-route.md` lists the release steps, and the pipeline skill's `references/release-route.md` maps each of its phrases to the skill and reference that owns it. Resolve these paths from the runtime's skill catalog and read each operation's routed references before execution. Keep the procedure in those runbooks; this milestone document records the 1.5.0 scope, decisions, work status, plans, and observed verification evidence.

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Survey | M1 | Establish module candidates and the release comparison | Milestone | Complete | No | D1, D2, D10, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28 | Assessment, ten IN/three HOLD choices, comparison, verification scope, and Keep records landed at 503f6ca; selected Base code and focused verification landed at ed5f810; issue #96 body reconciled and completed closure observed 2026-10-08; [detail](#m1---module-survey) |
| Modules | M2 | Update pyDevSup to 2.1.0 | Milestone | Not started | Yes | M1, D17, D37, D38 | Exact selected 2.1.0 source is installed; module and consumers build and run; [detail](#m2---pydevsup-update) |
| Modules | M3 | Update pvxs and reconcile its carry patches | Milestone | Not started | Yes | M1, D16, D37, D38 | Selected 1.5.3 and removal of twelve included carries are implemented; updated module and consumers pass; [detail](#m3---pvxs-update-and-patch-reconciliation) |
| Modules | M13 | Update caPutLog to 4.2.0 | Milestone | Not started | Yes | M1, D19, D29, D37, D38 | Exact R4.2 identity and real put logging pass with configured consumers; [detail](#m13---caputlog-update) |
| Modules | M14 | Update calc to 3.8.0 | Milestone | Not started | No | M1, M15, D20, D29, D37, D38 | R3-8 tests, affected records, and coherent calc consumers pass; [detail](#m14---calc-update) |
| Modules | M15 | Update sscan to ce9660c | Milestone | In progress | No | M1, D21, D29, D33, D34, D35, D36, D37, D38 | Selected scan counts, short delays, saved data, and consumers pass; [detail](#m15---sscan-update) |
| Modules | M16 | Update lua to 01aa7a1 | Milestone | Not started | No | M1, M14, D22, D29, D37, D38 | Lua 5.5.1, eight upstream tests, used scripts, and enabled consumers pass; [detail](#m16---lua-update) |
| Modules | M17 | Update std to 27b6967 | Milestone | Not started | No | M1, M14, D23, D29, D37, D38 | Real throttle concurrency/link-state checks and configured consumers pass; [detail](#m17---std-update) |
| Modules | M18 | Update busy to a4a272d | Milestone | Not started | No | M1, M14, D24, D29, D37, D38 | Typed busy support, real completion callbacks, relocated example, and consumers pass; [detail](#m18---busy-update) |
| Modules | M19 | Update scaler to baa8e1c | Milestone | Not started | No | M1, M14, D25, D29, D37, D38 | Soft scaler, cfg, original example invocation, uninstall, and consumers pass; [detail](#m19---scaler-update) |
| Verification | G2 | Identify required motor/pmac drivers, devices, and verification access | External gate | Open | No | | Actual required velocity/model-1/pmac verification inputs and access are recorded and available; [detail](#g2---motor-and-pmac-verification-access) |
| Modules | M20 | Update motor to 4b22ac9 | Milestone | Blocked | No | M1, M16, M18, G2, D27, D29, D37, D38 | Coherent motor/consumer builds, real motion, velocity/shutdown, and required hardware checks pass; [detail](#m20---motor-update) |
| OPC UA | M4 | Make Eclipse Milo the primary OPC UA example server | Milestone | Not started | Yes | D3 | Default example, tests, and documentation use the real Milo server; [detail](#m4---milo-example) |
| Release | M5 | Verify and publish EPICS-env 1.5.0 | Milestone | Blocked | No | M1, M2, M3, M4, M13, M14, M15, M16, M17, M18, M19, M20, G2, D37, D38 | Combined candidate and actual released objects pass all required checks; [detail](#m5---final-release) |

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
| D16 | Select pvxs 1.5.2 -> published 1.5.3, verdict IN, at 25ca43df4db909c0b1a445fb705fc81582617625. Remove all twelve existing 1.5.2 carry files in M3 because their fixes remain in the final 1.5.3 source. Exclude the post-release a9f8b7b32f4145e97ff694ac22f5f8422a176e64 -> d23de00df491fc22fbebf243bb7dfefd1f27d4f8 chain because address-processing findings remain; this removes rule-passing d23 and does not add rule-missing a9. The selected new carry list is empty. This records the version and carry decision; M3 plan acceptance, implementation authority, and release qualification remain separate. | 2026-10-07 |
| D17 | Select pyDevSup 4527ed055a472d4688846a2cb64ac593fec1ecbb -> published 2.1.0 at b5cef38a6d9f74f9c59f967185ba6d1940637c03, verdict IN. The actual comparison adds only CHANGELOG.md, 167 lines; all executable source, headers, build files, and requirements remain unchanged. Verify installed identity, softIocPy, and Python record behavior in M2. This records the version decision; M2 plan acceptance, implementation authority, and release qualification remain separate. | 2026-10-07 |
| D18 | Keep recsync at 9834b94edc63eece42712b8355a4703d4286dd8f for 1.5.0, verdict HOLD for the newer recsync candidates. Assign migration to the standalone ChannelFinder/reccaster repository to 1.6.0 and prepare one issue. Recsync 1.10.0 and the compared branch head lack the IOC client source; the migration requires acquisition and client-path integration changes. Its implementation scope belongs to docs/milestone-1.6.0.md; exact future version selection, implementation, and GitHub execution retain separate authority. | 2026-10-07 |
| D19 | Select caPutLog dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 -> R4.2 at 6f9eb3f6c75e49201d114f8e194d53cef493a522, verdict IN. The actual comparison changes only docs/index.rst and docs/releasenotes.rst, with 26 insertions and four deletions; executable source, public headers, and build files remain unchanged. Verify installed identity and real CA/PVA put logging through the existing loader, commonIocsh, tc32sim, and site consumers. This records the version selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D20 | Select calc 4217e83a9b9067017f4dc74da6b70e3669972f16 -> R3-8 at 712a40453e8693fda3b90a6e9da5fdb1c708ee38, verdict IN. The selected release contains the aCalc/sCalc calculation and bounds fixes plus upstream test changes: five files, 107 insertions, and 13 deletions. Exclude the later sixteen database changes from this selection. Public headers and build files are unchanged. Verify the real upstream tests, affected records, and census consumers. This records the version selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D21 | Select sscan e13699e3062145d516cfdd555aae25bb49a8c53b -> ce9660cfc05071834391225beadf7f93b776d216, verdict IN. Two files change with 17 insertions and 11 deletions: remove delay quantization outside vxWorks, round scan-point calculations, and type the XDR callback declaration for C23. The short-delay fix requires Base 7.0.10 or later, matching the current Base pin. Verify real scans, delays, saveData/XDR output, consumer rebuilds, and the C17 setting through actual builds. This records the source selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D22 | Select lua 17475b50ae95c801bad9573bb2b031ffb04ac75c -> 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d, verdict IN. Include the untagged branch candidate with bundled Lua 5.5.1 and the EPICS support redesign in 1.5.0. Require dedicated script compatibility, record/device support, shell, asyn, state/concurrency, installed-loader, and conditional motorScriptMotor verification. This records the source selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D23 | Select std 5f2e44214963b84ea3a400f7b7c3a9f510126ddd -> 27b696702c4ebc8c698c98e3bbb10a34f1a2c821, verdict IN. Include the throttle callback record-lock and per-link status fixes in 1.5.0: one source file, nine insertions, and three deletions; public headers, DBD, and build settings are unchanged. Verify real delayed output, concurrent value updates, independent OUT/SINP link changes and reconnects, installed-loader registration, and configured consumers. This records the source selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D24 | Select busy 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb -> a4a272d94d1f4351e7d9553e6dc35782eb96ce75, verdict IN. Include the untagged branch candidate with typed device-support tables, installed CONFIG_MODULE/BUSY_DEPS, and the relocated opt-in example IOC. Verify generated headers/DBD, Soft/Raw Soft/asyn processing, completion callbacks, configured consumers, and installed metadata. Reassess the C17 setting through real builds. This records the source selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D25 | Select scaler beb5521af49616682e4e442c3e33a06add1bd713 -> baa8e1c5e5a9a5deceef8cc39207a0da446092a6, verdict IN. Include the untagged branch candidate with installed CONFIG_MODULE/SCALER_DEPS and the relocated opt-in example IOC. Record/driver source, public headers, DBD, and databases are unchanged. Verify installed identity/cfg, the real soft scaler and enabled consumers, the new example paths and invocation, and the C17 setting through actual builds. This records the source selection; the implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D26 | Keep measComp at c38974e85c59429b8ba48ed320681ba0296fb924 for 1.5.0, verdict HOLD for branch candidate 9c8e01e025258668208383b370061a2b1ba9d7e8. Its two commits change generated caQtDM screens and the documentation dependency only; driver, header, DBD, database, build, and startup paths are unchanged. Retain the CONFIG_MEASCOMP and TC-32 channel-count carries. No new update work row, pin edit, or candidate build/runtime verification is authorized by this choice. | 2026-10-07 |
| D27 | Select motor 285f44d66cf7d07a86047719de757bd1f5d92a95 -> 4b22ac950de98c2dca324c2ef8ef221e124f6651, verdict IN. Use the upstream R7-4 source with its subsequent version-reporting correction: the tag-to-selected diff changes only one documentation line and VERSION 7.3 to 7.4. Retain NUM_MOTOR_DRIVER_PARAMS required by the pinned pmac. Exclude the later 47893ed branch changes, including position compare, homing fallback, and macro removal. Verify installed identity/version, coherent motorMotorSim/pmac rebuilds, actual motor records, velocity feedback, and applicable driver shutdown. No local motor patch is selected. The implementation plan, pin edit authority, builds, and runtime verification remain separate. | 2026-10-07 |
| D28 | Keep pcas at e075fd450ab9a66bbc044eaa4c2035d3d26d9651 for 1.5.0, verdict HOLD for branch candidate bdf2b0ab4229e0bb69dbe9107dbb40c332db4f33. The two later commits change only the upstream GitHub Actions workflow: one file, 38 insertions, and 35 deletions. All other source paths are identical, and there is no runtime fix to adopt. No pcas-specific carry exists. Preserve the current pin and its integrated Base, library-only loader, and real server-example verification. No new update work row, future-release assignment, issue, or candidate build is authorized by this choice. | 2026-10-07 |
| D29 | Assign caPutLog, calc, sscan, lua, std, busy, scaler, and motor to eight separate 1.5.0 work units and manage one issue per module. Prepare their implementation/test plans and refine M2-M3. Preserve existing IDs, source selections, HOLD outcomes, Backlog assignments, and separate plan acceptance, implementation, Git/GitHub, and release authority. | 2026-10-08 |
| D30 | Accept the reviewed implementation and test plans for M2, M3, and M13-M20, including exact selected pins, real fixtures, configured consumer checks, and final-tree re-run obligations. Preserve the Open G2 condition and Blocked M20/M5 status. Implementation authority is not granted by this acceptance; M4 and M5 remain draft. | 2026-10-08 |
| D31 | Manage M2-M3 and M13-M20 directly in this canonical milestone document. Supersede D29's requirement for eight module issues and cancel the planned pyDevSup/pvxs issue-body updates. Preserve published issue identities and dated observations. D30's accepted technical plans, implementation authority, verification requirements, dependency order, and the Open G2 condition are unchanged. | 2026-10-08 |
| D32 | Consolidate M2-M3 and M13-M20 under existing GitHub issue #98. Expand its body to all ten selected module updates, prerequisites, configured consumers, and real verification requirements. Close standalone #97 as not planned after transferring its pyDevSup scope to #98; this does not complete pyDevSup work. Supersede D31's cancellation of the #98 body update while retaining the cancellation of eight new module issues. Preserve work identities, accepted technical plans, verification results, and separate implementation authority. | 2026-10-08 |
| D33 | Authorize the accepted M15 sscan implementation and verification plan as the first module update in the recorded dependency order. Use a new work/sscan-bump-20261008 source/install workspace, bounded to 8 GiB, preserving existing sources, installations, and evidence. Change only the selected sscan pin and justified integration/documentation values. Remaining platform and consumer checks stay Pending until their real paths run. No commit, push, GitHub mutation, or release action is authorized by this decision. | 2026-10-08 |
| D34 | Accept and authorize the VM resource extension for the accepted M15 verification plan: five fresh per-OS guests, each 2 vCPU, 4 GiB RAM, and 20 GiB disk, through the provisioning owner. Run one guest at a time in the order Debian 12, Rocky 8, Ubuntu 24, Rocky 10, Ubuntu 26. Recheck capacity before every creation; finish each OS's checks and report completion for shutdown before requesting the next. Preserve guest disks and verification evidence; retain D33's 8 GiB source/install workspace bound and preserve existing guests. This does not authorize cleanup, other module selections, commit/push, GitHub mutation, or release actions. D37 supersedes this guest order for the Ubuntu 24.04, Rocky Linux 10 and Ubuntu 26.04 software cases only. | 2026-10-08 |
| D35 | Remove only sscan's Ubuntu 26 C17 append after the actual selected-source and current-consumer builds pass with and without it. Update the rationale and book module list, and verify the changed shipped configuration target in a separate workspace. Preserve other modules' compiler settings, existing sources, installations and evidence. Affected final-tree build/runtime checks remain required; this does not authorize another module update, commit/push, GitHub mutation, or release action. | 2026-10-09 |
| D36 | Exclude actual mca/measComp equipment acceptance from M15 because no verification devices are available. Accept and authorize continuation of the remaining software checks: the real installed support, original software fixtures, IOC startup, coherent dependencies and configured consumers. This does not claim equipment behavior was verified, waive other required software/platform/layer checks, change other module plans or G2, or authorize commit/push, GitHub mutations or release actions. | 2026-10-09 |
| D37 | Accept a revised per-OS verification cadence for the module updates, replacing the per-module six-platform runtime verification in the accepted plans of M2, M3 and M13-M20. Each implemented module update runs its incremental runtime verification on Debian 13 and Rocky Linux 8.10 only. The six-platform runtime verification of the module and consumer checks that M5's Integrated Verification map assigns to Release Verification 3 (Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04) runs once on the final combined tree under M5 Release Verification 3, together with the six-OS workflow builds that cover compiler and toolchain differences. For M15, the remaining original mca/measComp software cases on Ubuntu 24.04, Rocky Linux 10 and Ubuntu 26.04 move to that final-tree run, as do the Debian 12 Layer 3 checks of M15 / T4, which join the final-tree internal Layers 1-3; the Debian 13 and Debian 12 results already recorded and the pending Rocky 8 case are unchanged. This supersedes D34's guest order for those three platforms only; D34's per-guest resource bounds, one-guest-at-a-time rule and evidence preservation remain and also apply to the guests of that final-tree run. Recorded results keep their original scope and are not final qualification. A module work unit may close on its incremental platforms and landing evidence; the transferred platform runs are recorded obligations of M5 Release Verification 3 and are not a condition of that closure. The Ubuntu 26.04-only compiler comparison labels (T5 of M14 and M16-M19) likewise run in that final-tree run, which already lists the C17 comparisons, and are recorded obligations rather than closure conditions. Labels that the map assigns to Release Verification 4, including M3 / T4, M4 and the G2 device checks of M20 / T5, are not moved by this decision and keep their own completion conditions; D36 and G2 are unchanged. Plan content and implementation authority of M2, M3 and M13-M20 are otherwise unchanged. This does not authorize a guest restart, which stays with the provisioning owner, nor commit/push, GitHub mutation, or release actions. | 2026-10-09 |
| D38 | Defer the closure of shared issue #98 for module work units. #98 is shared by ten module updates, so the Complete status of a module work unit does not require #98 to be observed closed; this is the owner exception, and each affected Closure Evidence points here. The exception takes effect when M5 is accepted and the 1.5.0 release cycle is opened, and the master push of Release Execution step 4 carries the `Closes #98` footer on the commit recorded in M5 at release preparation. This does not close, edit or comment on #98, and does not authorize commit/push, GitHub mutation or a release action. | 2026-10-10 |

### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| Milo Example | Historical master register M26 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M4, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| EPICS::Path Normalize/RelPath | Historical master register M1 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M6, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| commonIocsh Promotion | Historical master register M3 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M7, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| Global iocsh Startup File | Historical master register M5 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M8, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| Libera Cross-Build And Generated Profile | Historical master register M20 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M9, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| macOS Patch-Revert Verification | Historical master register M21 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M10, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| Upstream Report Of The Base Site Patches | Historical master register M31 at 4d521e7a0f05163d39541c0357e966397433b027 | docs/milestone-1.5.0.md M11, release-1.5.0 | af91a9290129a6964168b363eb1944639dc0fc77 | af91a9290129a6964168b363eb1944639dc0fc77 on release-1.5.0; master is unchanged |
| Source Version Checks | docs/milestone-1.5.0.md, Milestone M12 | docs/milestone-1.5.0.md, Backlog M12 | 56f7e8c022f334d136449dfcda35c156674f9920 | 56f7e8c022f334d136449dfcda35c156674f9920 on release-1.5.0; D8 |
| Initialization Plan Acceptance | docs/milestone-1.5.0.md, Milestone G1 | docs/milestone-1.5.0.md, Backlog G1 | 56f7e8c022f334d136449dfcda35c156674f9920 | 56f7e8c022f334d136449dfcda35c156674f9920 on release-1.5.0; D8 |

### Milestone Details

#### M1 - Module Survey

Origin: 1.5.0 / M1
Identity History: none
GitHub Issue: #96, https://github.com/jeonghanlee/EPICS-env/issues/96
Status: Complete

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

D1, D2, D10, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, and D28. M1 precedes M2 and M3 because their exact source and test scope depend on the census. D29 assigns the eight additional selected updates to M13-M20; D30 accepts their plans and M2-M3 on 2026-10-08. Implementation authority remains separate. D13 reopened D12's Base selection; D14 records the new complete #900 chain after the fresh assessment, and D15 authorizes that chain's implementation under M1. The selected Base implementation, focused verification, and second code review are complete locally on 2026-10-07. #976 and e699b75b are outside the selected 23-patch set; no additional adoption or rejection decision is recorded. D16 resolves the pvxs version and carry decisions: 1.5.3, removal of twelve included carries, and no a9 -> d23 chain. D17 selects pyDevSup 2.1.0. D18 keeps recsync unchanged for 1.5.0; D19 selects caPutLog R4.2; D20 selects calc R3-8; D21 selects sscan ce9660c; D22 selects lua 01aa7a1 with dedicated compatibility verification; D23 selects std 27b6967; D24 selects busy a4a272d with typed device-support and example-build verification; D25 selects scaler baa8e1c with cfg, example IOC, and consumer verification. D26 keeps measComp c38974e and its two existing carries unchanged for 1.5.0. D27 selects motor 4b22ac9 with its upstream version correction, coherent motorMotorSim/pmac rebuild, and real IOC verification. D28 keeps pcas e075fd4 unchanged for 1.5.0. All thirteen module decisions are resolved, with ten IN and three HOLD. The release comparison and verification-scope consolidation under T3 are landed with the selections and Keep records at 503f6cae62ac77111078a9e9c5faa974740165b6; issue #96's body is reconciled and its completed closure was observed by 2026-10-08T15:10:34Z, completing M1. M3 still excludes Base implementation. Current implementation ordering follows the Next session entry point and each work unit's dependencies, including M13-M20. M2, M3, M13, and M4 have no established ordering dependency on one another; independent row order does not impose a build dependency.

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
| T3 | Scope | Compare 1.4.0 with the current committed candidate, separate uncommitted documentation and selected future updates, and consolidate census-based verification obligations | Actual Git objects, effective Make pins, shipped files, canonical decisions, and release runbooks | Complete module/patch/feature/platform/interface categories and all thirteen dispositions; no implicit upgrade or build/runtime qualification |
| T4 | Patch prerequisites | Run the shipped patch/revert targets, standalone and leave-one-out checks, and focused native core builds; compare the new original-diff chain with the current stack | Isolated tracked environment snapshot and exact pinned source archives | Explicit prerequisite graph, complete application observations, byte/file restoration results, and separate build evidence and limits |
| T5 | Selected Base wiring | Run shipped make patch/patch.revert and Base-specific targets, including revert on an unapplied tree; compare ordered patch logs, whole-source names and SHA256 values | Isolated current environment snapshot and all exact pinned patched-source archives | All 23 selected Base patches run in the Stage 6 order; full real round trip restores source bytes and names without .orig/.rej; existing non-Base carries remain unchanged |
| T6 | Selected Base native behavior | Run shipped conf.base/build.base with all six exact Base gitlinks; run epicsAtomicTest, epicsLoadTest, taskwdTest, aslibtest, and actual libCom cantProceed YES/NO child-process probes | Private Debian 13 native install and selected Base sources | Configure/build and real fixtures pass; abort/suspend observations match the configured policy; no platform-matrix or release qualification inferred |
| T7 | Partial-stack reversal | Apply each Base prefix from zero through 23 patches, then run the shipped revert target; exercise real conflict, missing/malformed input, ambiguous dry-run, space-containing path, existing backup, and full Linux round-trip cases | Actual current helper and Make targets; exact pinned source archives; Debian 13.7, GNU Make 4.4.1, GNU patch 2.8 | Every valid prefix restores exactly; errors stop without changing source at classification entry; preceding reversals and existing backups are preserved; all 42 Linux patches reverse in their actual inverse order |
| T8 | Independent code review | Review the frozen helper with one independent agent and one rebuttal exchange; execute Base and pvxs cases independently and check local-edit preservation through the public Make targets | Frozen helper SHA256 below; exact R7.0.10 and pvxs 1.5.2 archives; real GNU patch without internal mocks | No must-fix or minor finding; normal restoration and error-preservation behavior confirmed; unexecuted failure branches remain explicit |
| T9 | pvxs final source and prerequisites | Recheck release and branch objects, all twelve original carry diffs and final-source functions; run actual GNU patch and the shipped revert helper on complete 1.5.3 archives for the two post-release commits | Environment ed5f810; actual upstream Git objects; Debian 13.7 and GNU patch 2.8 | Every carry accounted for; exact prerequisite and source findings recorded; prefixes zero, one, and two restore; no candidate build or runtime qualification inferred |
| T10 | Lua source and consumers | Recheck the effective Lua pin, exact branch/tag objects, actual public headers, DBD/build changes, and paired source traversals; inspect the exact optional motorScriptMotor source | Thirty-nine available source roots; Lua Git objects; motor-pinned motorScriptMotor commit through the upstream API | Exact candidate and active/conditional consumers established; script/API changes and required real-path checks recorded without a build or runtime pass |
| T11 | std source and consumers | Inspect exact old/new objects and complete throttle diff, effective pins, upstream tags, actual build/DBD/patch paths, and paired source traversals including record types and startup files | Thirty-nine available source roots; actual std and Base Git objects; public upstream APIs | Exact branch candidate and active/build-order consumers identified; delayed-output and independent link-state verification obligations recorded without a runtime pass |
| T12 | busy source and consumers | Inspect exact old/new objects, typed device-support and generated-header changes, effective pins, tag ancestry, cfg/example build paths, carry rules, and two paired source censuses | Thirty-nine available source roots; actual busy and Base Git objects; public upstream APIs | Exact candidate and active/conditional consumers established; completion, cfg, example IOC, and C17 verification obligations recorded without a candidate build or runtime pass |
| T13 | scaler source and consumers | Inspect exact old/new objects, effective pins, upstream tags and ancestry, library/header/DBD/database identity, cfg/example/uninstall changes, and paired source traversals | Thirty-nine available source roots; actual scaler and selected calc Git objects; public upstream APIs | Exact candidate and configured/conditional consumers established; cfg, example invocation, soft-scaler, consumer, and C17 verification obligations recorded without a build or runtime pass |
| T14 | measComp source, screens, and consumers | Inspect exact old/new objects, effective pins, upstream tags and ancestry, existing carries, changed XML screens and referenced files, and primary/supplemental paired source traversals | Thirty-nine available source roots; actual measComp Git objects; public upstream APIs | Exact candidate, unchanged IOC/carry inputs, and active-consumer census established; screen changes distinguished from IOC changes without a candidate build or runtime pass |
| T15 | motor source and consumers | Inspect exact old, released, selected, and latest branch objects; effective pins; complete source/header/build/gitlink changes; existing carries; version reporting; and primary/supplemental paired source traversals | Thirty-nine available source roots; actual motor, motorMotorSim, and pmac Git objects; public upstream APIs | Selected source distinguished from the release tag and incompatible later branch; consumer and real-path verification scope established without a candidate build or runtime pass |
| T16 | pcas source and consumers | Inspect exact old/new objects, effective pins, upstream tags and ancestry, the complete workflow diff, identity of all other source paths, existing carries, public exports, and primary/supplemental paired traversals | Thirty-nine available source roots; actual pcas Git objects; public upstream APIs | CI-only candidate and unchanged runtime/build surface established; direct consumers and retained-pin verification scope recorded without a build or runtime pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Initial survey 2026-10-06; rechecked by 2026-10-07T06:58:42Z | Release checkout and 33 public upstreams | Pass: real checker exit 0, 33/33 lookups, 13 updates; Lua advanced to 01aa7a1; effective candidate pins rechecked with Make | Upstream Survey and Expanded Candidate Assessment below |
| T2 | Initial census 2026-10-06; expanded assessment 2026-10-07T06:58:42Z | 33 pin-matched Layer 1 sources, six Base component submodules, pinned ADCore, three other support sources, and two site sources | Pass for the recorded static census: both searches agree on 46,065 lines across 39 roots; conditional and runtime consumers classified; no build, ABI, or runtime pass claimed | Expanded Candidate Assessment and Consumer Assessment below; earlier observations retained in Consumer Coverage |
| T3 | Rechecked by 2026-10-08T05:04:27Z; earlier partial observation retained below | 1.4.0 at 5326c981912566810f763cbe12aba6509bbdb7c4 to committed ed5f810fa5ac32d47108bc8b7468d0cf907f42d8; actual selected upstream objects and current effective Make queries | Pass for source comparison and scope consolidation: 155 changed files, 21,204 insertions, 3,683 deletions; all 66 tracked tag/version assignments unchanged; effective 1.5.0 value and thirteen old pins confirmed; all thirteen dispositions and required real-path checks accounted for | Release Comparison and Consolidated Selected Verification Scope below; uncommitted documentation is separate; no module-update build, installed-path, or runtime pass |
| T4 | Earlier cross-check 2026-10-07T08:02:41Z through 2026-10-07T08:14:19Z; fresh Base assessment verified by 2026-10-07T16:12:44Z | Debian 13.7, GNU Make 4.4.1, GCC 14.2.0; exact R7.0.10 archive, six pinned Base components, and environment 56f7e8c022f334d136449dfcda35c156674f9920 | Fresh complete-unit prerequisites established; shipped Base baseline restores exactly; explicit 25-step assessment applies and builds with exit 0. Private reverse restores all 1,832 original files but leaves two .orig files. Four shipped fixtures and focused real runtime paths executed. Five independent scores complete | Base Carry Restart Before Selection below; earlier all-module observations retained in Existing Patch Dependency Cross-check. Selected production wiring is verified separately in T5-T6; other platforms, external consumer builds, and release qualification remain unverified |
| T5 | 2026-10-07T17:44:14Z | Current uncommitted implementation over environment 56f7e8c022f334d136449dfcda35c156674f9920; eight exact pinned source archives; GNU Make 4.4.1 and GNU patch 2.8 on Debian 13.7 | Pass: 23 ordered Base dry-runs and real applications; exact inverse reversal; all 42 Linux patches observed with 187 patching-file lines; all eight source file sets and SHA256 values restored, 3,915 regular files; no .orig/.rej | Base Carry Implementation below; unapplied revert and empty version-matched set also preserve sources; 21 carry rows and two site units match the actual list |
| T6 | Native build 2026-10-07T17:52:51Z; runtime checks 2026-10-07T17:54:07Z | Selected 23-patch Base and six exact gitlinks; private CONFIG_SITE.local install; Debian 13.7 x86_64, GCC 14.2.0, GNU Make 4.4.1 | Pass: shipped conf.base/build.base exit 0; four real upstream fixtures pass all 126 checks; actual libCom cantProceed YES aborts by SIGABRT, NO suspends through a four-second observation | Base Carry Implementation below; other platforms, downstream consumer builds, full released-fix regressions, supervisor recovery, and release qualification are not established |
| T7 | 2026-10-07; execution evidence recorded by 2026-10-07T19:34:14Z | Current uncommitted implementation over 56f7e8c022f334d136449dfcda35c156674f9920; actual helper and Make targets; eight exact pinned archives | Pass: all 24 Base prefixes restore; real incomplete/conflict/missing/malformed/ambiguous cases stop and preserve source; 15 preceding reversals retained on a later error; all 42 Linux patches apply/revert and restore eight complete trees, 3,915 regular files | Base Revert Correction And Review below; names, bytes, modes, and symlinks compared with fresh archive extraction; Bash syntax and both ShellCheck checks exit 0 |
| T8 | 2026-10-07; author executions recorded by 2026-10-07T19:45:28Z, independent executions by 2026-10-07T19:49:53Z | Same frozen helper; actual public Make paths and exact Base/pvxs archives | Accept: second code review, one independent agent, one rebuttal exchange; no must-fix, minor finding, or residual disagreement. Nine independently executed Base states restore; all thirteen pvxs prefix states restore; independent full pvxs round trip and error-preservation cases pass | Base Revert Correction And Review below; local edits preserved at Base prefixes 2 and 17; actual private apply/reverse failure and private mktemp failure were not executed |
| T9 | Completed 2026-10-07T21:49:53Z | Environment ed5f810fa5ac32d47108bc8b7468d0cf907f42d8; actual pvxs 1.5.3 archive; Debian 13.7, GNU patch 2.8; unchanged shipped helper | Pass for source and prerequisite assessment: all twelve fixes retained; 73 post-pin commits split into 71 through the release and two afterward; a9 alone dry-run 0, d23 alone 1, d23 after a9 0; both real applications return 0; all three prefix states restore the complete 295-file inventory without new .orig/.rej | pvxs Final Source And Post-release Dependency Assessment below; raw results SHA256 6c22314bf1e00d5259421e8b1b9afa114130771be49f26b781beeaf14e61dd33; no 1.5.3 build, full Make round trip, ABI, or runtime pass claimed |
| T10 | Source assessment completed by 2026-10-08T01:25:36Z | Actual old and candidate Lua objects; paired traversals across 39 source roots; exact motorScriptMotor commit 0c63c3f24e1f5572549e4c00ccc4fa20e84cd573 through GitHub | Source assessment complete: 232 files, 37,600 insertions, 20,205 deletions; both searches agree per root; removed script APIs and retained shell aliases confirmed; optional direct motorScriptMotor linkage identified | Lua Selection And Compatibility Scope below; no candidate build, upstream test execution, or IOC/runtime compatibility pass |
| T11 | Source assessment completed by 2026-10-08T01:31:58Z | Actual std 5f2e442 and 27b6967 objects; effective Make pins; upstream branch/tag/PR APIs; two paired searches across 39 source roots; actual Base dbLock.h | Source assessment complete: one file, nine insertions, three deletions; main and supplemental traversal results agree per root; no external std header/library use found; calc example runtime use and mca/measComp build-order dependencies classified | std Selection And Verification Scope below; no candidate build, IOC startup, concurrency regression, or runtime compatibility pass |
| T12 | Source assessment completed by 2026-10-08T02:13:39Z | Actual busy 2dfe92d and a4a272d objects; effective Make pins; upstream branch/tag/PR APIs; primary and supplemental paired traversals across 39 source roots; actual Base devSup.h | Source assessment complete: 39 files, 806 insertions, 152 deletions; both censuses agree per root; typed support, optional IOC relocation, and configured consumers classified; no external custom busy device support or testBusyAsyn use found | busy Selection And Verification Scope below; no candidate build, IOC startup, completion regression, consumer compatibility, or C17-option comparison pass |
| T13 | Source assessment completed by 2026-10-08T03:00:12Z | Actual scaler beb5521 and baa8e1c objects; effective Make pins; upstream branch/tag/release APIs; paired traversals across 39 roots; selected calc R3-8 cfg declarations | Source assessment complete: 33 files, 708 insertions, 411 deletions; record/driver/header/DBD/database paths unchanged; traversal results agree per root; measComp and conditional mca SIS consumers classified; example run mode changes from 100755 to 100644 | scaler Selection And Verification Scope below; no candidate build, example execution, soft-scaler operation, consumer compatibility, uninstall, or C17-option comparison pass |
| T14 | Source assessment completed by 2026-10-08T04:20:56Z | Actual measComp c38974e and 9c8e01e objects; effective Make pins; upstream master/tag APIs; changed screen XML; paired traversals across 39 roots | Source assessment complete: two commits, 14 files, 10,758 insertions, 6,308 deletions; driver/header/DBD/database/build/startup paths unchanged; both traversal pairs agree per root; no active external consumer found; all 37 literal screen references exist in the candidate source | measComp HOLD Decision And Source Assessment below; no new candidate patch application/reversal, build, GUI execution, IOC startup, or hardware pass |
| T15 | Source assessment completed by 2026-10-08T04:39:16Z | Actual motor 285f44d, R7-4, 4b22ac9, and 47893ed objects; clean motorMotorSim R1-3 and pinned pmac sources; effective Make pins; upstream APIs; paired traversals across 39 roots | Source assessment complete: selected source changes 29 files, 290 insertions, 61 deletions; only docs/RELEASE.md and motorRecord.cc differ from R7-4; required pmac macro retained; header member addition requires coherent rebuild; primary and supplemental traversals agree per root | motor Selection And Verification Scope below; no candidate build, link, installed VERS observation, IOC startup, velocity/shutdown regression, or hardware pass |
| T16 | Source assessment completed by 2026-10-08T04:54:08Z | Actual pcas e075fd4 and bdf2b0a objects; effective Make pins; upstream master/tag APIs; actual public header/library Makefiles; paired traversals across 39 roots | Source assessment complete: two commits, one workflow file, 38 insertions, 35 deletions; all non-workflow paths identical; primary and supplemental traversal results agree per root; no external cas/gdd header or library consumer found; latest tag precedes current pin | pcas HOLD Decision And Source Assessment below; no build, upstream CI execution, installed-loader, real server/client, or runtime pass |

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

For each actual patch file, `git patch-id --stable` matched the originating upstream commit diff; `git merge-base --is-ancestor <commit> 1.5.3` returned 0. T9 rechecked this provenance and separately inspected the actual final-source functions below. All twelve original fixes remain in 1.5.3; later callback changes retain the protections rather than reproducing every original hunk verbatim. D16 selects removal of all twelve files in M3. Actual removal, build, and runtime verification remain pending.

| Patch file | Upstream commit | Ancestor of 1.5.3 | Stable patch ID | Selected Disposition Under D16 |
| --- | --- | --- | --- | --- |
| `1.5.2-01-086501a-pvxmonitor-conn-ts.p0.patch` | 086501a | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-02-090bf5f-cli-flush.p0.patch` | 090bf5f | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-03-7490286-pvalink-seq-point.p0.patch` | 7490286 | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-04-0b3fcca-cli-dtor-order.p0.patch` | 0b3fcca | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-05-084336b-client-retry-slowdown.p0.patch` | 084336b | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-06-9a6b4cc-oncreate-log-deescalate.p0.patch` | 9a6b4cc | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-07-39cc6fa-infoop-early-dtor.p0.patch` | 39cc6fa | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-08-c969383-clientmon-cb-guard.p0.patch` | c969383 | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-09-c17812a-clientget-cb-guard.p0.patch` | c17812a | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-10-eab3275-clientdiscover-cb-guard.p0.patch` | eab3275 | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-11-d5ecc88-clientintrospect-cb-guard.p0.patch` | d5ecc88 | Yes | Match | Remove in M3: included upstream; runtime pending |
| `1.5.2-12-cc7bc72-synccancel-diag.p0.patch` | cc7bc72 | Yes | Match | Remove in M3: included upstream; runtime pending |

###### pvxs Final Source And Post-release Dependency Assessment

Observed through actual GitHub release/commit metadata and Git objects by 2026-10-07T21:49:53Z. The published release remains 1.5.3, published 2026-09-29T00:08:23Z, at 25ca43df4db909c0b1a445fb705fc81582617625. The effective existing pin remains 1.5.2 at 8e00eaecdee5ce8a474704e70d820e6f92693fa1. Upstream pvxs master remains d23de00df491fc22fbebf243bb7dfefd1f27d4f8 and Base 7.0 remains e699b75ba3f18a632feb4bd544dbe4149685ef68. Enumerating the complete pvxs range gives 73 post-pin commits: 71 through 1.5.3 and exactly two afterward, a9f8b7b32f4145e97ff694ac22f5f8422a176e64 then d23de00df491fc22fbebf243bb7dfefd1f27d4f8. No new surviving post-release candidate appeared. Released 1.5.3 is a module-bump candidate; the two later commits are a separate carry decision.

All source locators in this table refer to immutable release object 25ca43df4db909c0b1a445fb705fc81582617625. Original diffs, functions, callback ownership, and operation ordering were examined as well as ancestry and stable patch IDs. Runtime checks listed here are obligations for the selected implementation, not observed passes.

| Original Fix | Final-source Evidence In 1.5.3 | Runtime Check Still Required |
| --- | --- | --- |
| 086501a | tools/monitor.cpp:173,181 emits conn.time for disconnect/connect | Actual monitor disconnect and reconnect output |
| 090bf5f | tools/call.cpp:126,134; get.cpp:103,118; info.cpp:82,95,97; list.cpp:176; monitor.cpp:114,164; put.cpp:118,145 retain stderr diagnostics and result flushes | Actual six-tool redirected stdout/stderr behavior |
| 7490286 | ioc/pvalink_channel.cpp:422,428 completes trac.scan before update_seq at 433 and update_evt.signal at 434 under the lock | Actual pvalink update/processing wait sequence |
| 0b3fcca | Callback state precedes Context in tools/call.cpp:120,123; get.cpp:98,100; info.cpp:77,79; list.cpp:115,118; monitor.cpp:109,111; put.cpp:112,115 | Actual CLI completion, interruption, and destruction |
| 084336b | src/clientconn.cpp:377-384 queues denied CREATE retries in laterBucket with wrap handling | Actual denied CREATE retry timing |
| 9a6b4cc | src/serverchan.cpp:329 logs an onCreate exception at error level | Actual throwing onCreate callback and server continuation |
| 39cc6fa | src/clientintrospect.cpp:40 guards the destructor by onWorker; line 231 assigns onWorker only after worker dispatch | Actual operation destruction before worker creation |
| c969383 | src/clientmon.cpp:114,121 brackets event execution; 284-285 rejects active callback replacement; 297,299 preserves active callbacks during cancellation; 640,651 brackets onInit | Actual monitor callbacks replacing/canceling their operation |
| c17812a | src/clientget.cpp:162,175 brackets done; 186,188,190 guards cancellation; 231,238 guards reExec; 293,305 brackets builder; 540,544,546 brackets onInit | Actual builder, completion, and initialization callback cancellation |
| eab3275 | src/clientdiscover.cpp:55 guards cancellation; 137,143 brackets notify execution | Actual discovery cancellation within notification |
| d5ecc88 | src/clientintrospect.cpp:49 guards cancellation; 171,177 brackets done execution | Actual introspection cancellation within completion |
| cc7bc72 | ioc/pvalink_channel.cpp:270 retains syncCancel(false); src/clientdiscover.cpp:96,98; clientget.cpp:618,620; clientintrospect.cpp:210,212; clientmon.cpp:834,836 retain worker diagnostics; src/evhelper.cpp:363,365 and evhelper.h:201 retain inLoop | Actual synchronous-cancellation diagnostics and pvalink destruction |

The carry funnel after the release contains two enumerated commits, zero doc/CI/test-only removals, zero applicability deferrals, and two scored candidates retained from the unchanged earlier five-candidate assessment. The complete five-candidate table and all raw vectors remain under Earlier Five-reviewer Carry Scores. T9 checked its frozen input SHA256 7fbc6b84055e1baf862ef9d3a52499987cc30ea14abb896f177354731c6e6593, validated all 200 raw axis values, and recomputed the 40 per-axis medians and five totals outside the model. No new scoring run or narrower candidate set is represented by this extract.

| Retained Candidate | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule Conditions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| PVXS-a9 | 0 | 0 | 2 | 1 | 3 | 1 | 3 | 4 | 14 | none |
| PVXS-d23 | 5 | 3 | 6 | 0 | 6 | 4 | 3 | 4 | 31 | bug>=5 |

Prerequisite: a9 -> d23. a9's original diff changes address parsing in src/config.cpp and its actual test/testconfig.cpp fixture. d23 explicitly follows a9 and restores failure when a nonempty address list produces no valid endpoints. Both touch these same two files. Real GNU patch 2.8 with batch, forward, ignore-whitespace, no-backup-if-mismatch, and p0 options dry-ran a9 alone at 1.5.3 with exit 0, d23 alone with exit 1, and d23 after actual a9 application with exit 0. Both real applications exited 0 and produced exactly the two upstream d23 file objects. The added std::exception_ptr/current_exception/rethrow_exception API and std::map use already have project counterparts at 1.5.3; this source inspection is not a compiler or test result. Selecting d23 necessarily selects the complete a9 -> d23 chain, including a9's rule miss.

The full Git archive of actual 1.5.3 was independently extracted for prefix states zero, one, and two. The unchanged shipped tools/revert_patch.bash, SHA256 3c0c24bbedd3e65c7f4225ae0303e8def66a8859514c0aa1096bccb2c1a6e04e, reversed d23 then a9 with the actual prerequisite list and --no-backup-if-mismatch. All six helper calls exited 0; every state restored the complete original 295-regular-file inventory, including names, bytes, modes, and symlinks, with no new .orig/.rej files. These diagnostic diffs were derived directly from upstream objects without manual source or hunk changes. This exercises real GNU patch and the shipped helper, not a candidate Make wiring/build path.

Remaining source findings in the chain, with locators at d23de00df491fc22fbebf243bb7dfefd1f27d4f8:

- src/config.cpp:275-292,407-409,474-482: a9 alone can turn an all-invalid explicit server interface list into an empty list and then wildcard binding. d23 restores the all-invalid exception, but a valid-plus-invalid interface list still accepts the valid subset where 1.5.3 imports rejected invalid entries.
- src/config.cpp:411-412,514 and src/server.cpp:467-470: ignored-address import now only tokenizes and deduplicates strings; address parsing is deferred to server construction instead of the strict 1.5.3 import. This is a validation-timing change, not evidence that invalid ignored addresses are accepted.
- src/config.cpp:569-575 and src/client.cpp:621-630: nameServers is tokenized without the new parseAddresses validation; the client logs a failed address parse but continues to append that entry. d23 does not address this path.
- src/config.cpp:623-637 and src/client.cpp:601-618: client address deduplication precedes default UDP-port normalization. Omitted-port and explicit-default-port forms can produce duplicate effective destinations; 1.5.3 normalized imported addresses before deduplication.
- src/config.cpp:623-637: an all-invalid explicit client destination list now throws before automatic interface addresses can be added. This changes configuration behavior and requires an explicit runtime test.

Recommendation for the owner: select published 1.5.3 without the post-release chain and retire the twelve redundant 1.5.2 carry files in the authorized M3 implementation. Alternatively, selection of the original a9 -> d23 chain must account for the remaining findings and its wider runtime test scope. No IN/HOLD verdict, carry adoption or rejection, new production patch, patch deletion, or pin edit is recorded by T9. The consumer obligations remain ADCore NDPluginPvxs/ntndArrayConverterPvxs, its ADSimDetector/ADGenICam/ADVimba consumers, and installed-loader softIocPVX; the previously observed disabled linStat example and site census are not new executions. Full shipped Make apply/revert, 1.5.3 module and consumer builds, upstream testconfig execution, installed IOC/network checks, and platform qualification remain unexecuted.

Decision Date: 2026-10-07. D16 records pvxs 1.5.2 -> 1.5.3, verdict IN, exact target 25ca43df4db909c0b1a445fb705fc81582617625. The released source contains all twelve retained fixes, so all twelve carry files are selected for removal in M3. The post-release a9 -> d23 chain is excluded because the remaining address-processing findings outweigh adding that chain to this release. Owner additions: zero; rule-passing candidates removed: one, d23; a9's rule miss is not overridden. The ordered new pvxs carry list is empty, with zero selected new patches. This decision follows T9's completed assessment; actual pins and patch files remain unchanged and M3's plan is still draft.

Raw content-free execution driver: work/pvxs-final-source-review-20261007.py. Actual archives, original diffs, complete numbered source, command logs, and results remain in work/pvxs-final-source-20261007-nj9nv157/; results.json SHA256 is 6c22314bf1e00d5259421e8b1b9afa114130771be49f26b781beeaf14e61dd33. This canonical section retains the immutable objects, methods, results, findings, and verification limits independently of the ignored scratch files.

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

No candidate IN/HOLD decision was recorded at the 2026-10-07T06:58:42Z assessment. D16-D28 subsequently resolve all thirteen choices, with ten IN and three HOLD, as consolidated below. The earlier comparisons above are historical observations, not the current candidate totals.

###### Current Committed Candidate Compared With 1.4.0

Observed by 2026-10-08T05:04:27Z. The published 1.4.0 commit is 5326c981912566810f763cbe12aba6509bbdb7c4; current release HEAD is ed5f810fa5ac32d47108bc8b7468d0cf907f42d8. Actual `git diff --name-status`, `--numstat`, and `--shortstat 1.4.0..HEAD` report 155 changed files, 21,204 insertions, and 3,683 deletions. This count includes documentation, fixtures, and patch text; it is not a count of changed module source files. Every path in the diff is accounted for below.

| Path Group | Changed Files | Insertions | Deletions |
| --- | ---: | ---: | ---: |
| .github | 9 | 88 | 90 |
| commonIocsh | 6 | 24 | 6 |
| configure | 20 | 445 | 296 |
| docs | 44 | 11,266 | 1,990 |
| examples | 43 | 2,904 | 140 |
| patch | 10 | 3,682 | 117 |
| Repository root | 3 | 37 | 95 |
| scripts | 4 | 273 | 333 |
| site-template | 4 | 0 | 210 |
| tools | 12 | 2,485 | 406 |
| Total | 155 | 21,204 | 3,683 |

Actual comparison of all 66 SRC_TAG_/SRC_VER_ assignments in the two committed configure/RELEASE objects finds no difference. Base remains R7.0.10, asyn remains R4-46, and every surveyed module still has its original pin. The twelve added SRC_BASE_ assignments make repository ownership explicit beside the module triples; they do not change source tag/version selection. The shipped Make queries reconfirm the thirteen effective old pins, Base/asyn pins, ENV_RELEASE_VERS=1.5.0, and the derived 1.5.0/debian-13/7.0.10 root. A derived path is not evidence of an installation.

| Change Category | Already In The Committed Candidate | Source And Interface Evidence |
| --- | --- | --- |
| Installed-module loader | Run an IOC through softIocPVX with module directives, exact versions, recorded dependencies, environment macros, and show mode | New tools/iocsh.bash, iocsh_metadata.bash, and iocsh_elf.bash; configure/CONFIG_MODS_IOCSH and RULES_FUNC/RULES_INSTALL; installed-module-loader concept and procedure |
| Loader identity and ELF checks | Build records bind metadata to source and artifacts; refused generation removes stale metadata; symlink publication checks artifacts; startup refuses inconsistent versions, missing dependencies, and truncated libraries | Actual build/install/symlink recipes, metadata/digest files, ELF inspection, and failure-diagnostic fixtures; these checks are distinct from dynamic binding/runtime verification |
| Configuration and linking | Query-only Make goals derive variables without writing a cache; action goals refresh effective module settings; configuration types are separate; source-base declarations are centralized; individual C17 settings survive reconfiguration | CONFIG_GOALS, CONFIG_MODS, CONFIG_MODS_TYPES, RELEASE, and RULES_MODS_CONFIG; std example local configuration preservation, sscan/QPC configuration grouping, corrected motorMotorSim prerequisites; no-as-needed, measComp uldaq linkage, and stable installed OPC UA cfg |
| Base and patch operations | Five new R7.0.10 patch files: complete #753, cf85a1a5, #900, and two site fixes; #934 uses its original upstream representation; #949 remains; composed 23-patch order reverses exactly | CONFIG_BASE, RULES_FUNC/RULES_PATCH, tools/revert_patch.bash, and patch/README.md; parser EOF and redefined-record/device-menu site fixes; three unused older Base patch files and their obsolete generic rules removed |
| Environment and command behavior | Setup/reset preserves unrelated literal and empty path fields, supports repeated setup and tree switching, and validates architecture before changing the environment; reset is installed alongside setup | scripts/setEpicsEnv.bash and resetEpicsEnv.bash; vendor preparation confirms and backs up existing local configuration; check_deps rejects invalid trees and deduplicates executable paths; helper commands validate missing inputs and distinguish help from usage errors |
| Common IOC fragments and examples | iocLogDisable uses the real C-variable setter; stats fragments document prefix limits and duplicate-record conflicts; autosave documents system.dbd; caPutLog example paths, serial readback, and test source ownership are corrected | Six changed commonIocsh fragments; existing fragment suite; new minimal linStat startup, tc32sim, EPICS-IOC-Demo, and opcua-IOC-demo loader fixtures, shared application checkout, and 17-script loader runner |
| Platforms and CI | Six Linux workflows: Debian 12/13, Rocky 8/10, Ubuntu 24.04/26.04; Rocky 9 removed and Ubuntu 22.04 replaced; every OS runs the module dependency audit before compilation | .github/workflows and supported-platforms-and-ci reference; checkout v7, super-linter v8.7.0, aligned push filters, Rocky vendor configuration/source reporting; docs deploys from master and fails on Git inspection errors |
| Documentation and removed templates | Operator book reorganized into tutorials, concepts, procedures, and references; READMEs point to it; dedicated Libera reference and current/historical milestone evidence retained | docs, root README/.gitignore, and script/tool READMEs; four unused site-template files removed; scripts/build_modules_libera.bash uses current sequencer target names, without a target-board verification claim |

At this observation, uncommitted changes are confined to docs/CLOSED_DOORS.md and this document, plus the untracked docs/milestone-1.6.0.md. They contain selections, Keep evidence, and future migration tracking, not shipped module updates, and are excluded from the committed 155-file count. No configure, tool, script, patch, example, or workflow path differs from HEAD. The twelve patch/1.5.2-*.p0.patch files are still present; their removal is selected future M3 work.

###### Selected Updates Still To Implement

The following dispositions are the final M1 source selections, not installed versions. Their full target identities and dated decisions remain in D16-D28. Fresh shortstat comparisons of the ten IN pairs use the actual old/selected Git objects; these module-repository counts are separate from the EPICS-env diff above.

| Module | Current Pin | Selected Target | Verdict | Old-To-Selected Files |
| --- | --- | --- | --- | ---: |
| pyDevSup | 4527ed0 | 2.1.0 / b5cef38 | IN | 1 |
| pvxs | 1.5.2 / 8e00eae | 1.5.3 / 25ca43d | IN | 72 |
| caPutLog | dafb0b2 | R4.2 / 6f9eb3f | IN | 2 |
| calc | 4217e83 | R3-8 / 712a404 | IN | 5 |
| sscan | e13699e | ce9660c | IN | 2 |
| lua | 17475b5 | 01aa7a1 | IN | 232 |
| std | 5f2e442 | 27b6967 | IN | 1 |
| busy | 2dfe92d | a4a272d | IN | 39 |
| scaler | beb5521 | baa8e1c | IN | 33 |
| motor | 285f44d | 4b22ac9, after R7-4 | IN | 29 |
| recsync | 9834b94 | Unchanged | HOLD | 0 |
| measComp | c38974e | Unchanged; both carries retained | HOLD | 0 |
| pcas | e075fd4 | Unchanged | HOLD | 0 |

The selected behavior changes are the pvxs release fixes, calc calculation/bounds fixes, sscan timing/point/XDR fixes, Lua 5.5.1 and EPICS API/record redesign, std callback/link-state fixes, busy typed support and completion paths, scaler installed cfg/example organization, and motor velocity/shutdown support with upstream VERS correction. pyDevSup and caPutLog changes are documentation-only but still change installed identity. Busy, scaler, and Lua example-build options and moved paths require explicit verification configuration; they are not automatically enabled by selection. No local motor patch is selected. pvxs will remove twelve redundant carries and add none; all other retained module carries must still apply/revert against the selected combination under the Bump obligation.

M4's planned Milo default is separate from the existing st-milo.cmd variant: the current st.cmd and README still require the Unified Automation server for their original path. Its exact server artifact, real node mapping, compatibility entry, and measured restart treatment remain M4 work. No opcua/open62541 upgrade is selected. D8 excludes source-version initialization improvements from 1.5.0; D18 keeps recsync and assigns reccaster migration to 1.6.0. The rejected later calc database changes, motor 47893ed changes, and pvxs a9 -> d23 chain remain outside the selected update scope.

###### Consolidated Selected Verification Scope

This section preserves M1's source assessment and consumer obligations. D29 subsequently assigns caPutLog, calc, sscan, lua, std, busy, scaler, and motor to M13-M20; D31 cancels eight individual issue preparations; D32 uses existing #98 for all ten selected updates while preserving module tracking in this canonical document. Their implementation/test plans and refined M2-M3 plans below are accepted separately under D30; source selection alone does not authorize implementation. M5 now maps their checks to final-tree re-runs; G2 records the missing required motor/pmac verification inputs and access. These planning changes do not alter M1's recorded source results or qualify any module.

| Module / Selection | Required Real Shipped Path | Consumer And Evidence Coverage |
| --- | --- | --- |
| pyDevSup IN | Exact source/install identity, real softIocPy imports, Python device-support records, processing and upstream fixtures | M2 / T1-T3; no active external consumer in current source configuration; recheck disabled feedApp/logging examples if enabled |
| pvxs IN | Empty selected carry set through shipped Make apply/revert; upstream tests, real CLI read/write/monitor, CA/PVA IOC and loader; retain checks for every retired fix | M3 / T1-T3; twelve-row final-source runtime table; ADCore converter/plugin and all three detector consumers rebuild/relink and exercise actual data |
| caPutLog IN | Installed identity/metadata, actual CA/PVA put logging with iocLogServer through shipped fragments and tc32sim | D19 and Consumer Assessment; loader/commonIocsh/site logging consumers; optional Python and pva2pva examples only when configured |
| calc IN | Exact R3-8, real upstream aCalc/sCalc tests and affected record processing; no later DB defaults | D20 and Consumer Assessment; asyn, StreamDevice, mca, measComp and runtime templates in std/sscan/QPC/pmac; optional scaler/ADCore paths when enabled |
| sscan IN | Real scan counts, short delays, saveData and XDR output; loader support registration | D21 and Consumer Assessment; calc, asyn test IOC, mca and measComp; std trend database; conditional StreamDevice/ADCore paths only when enabled |
| lua IN | Eight original luaApp/test programs; existing-script migration, record/device support, shell aliases/new commands, CA/database/asyn, state/concurrency, cfg/loader, enabled iocLuaExample | T10 and Lua Selection And Compatibility Scope; optional motorScriptMotor needs its own exact source census, coherent rebuild and real script/reload checks; no active external consumer currently |
| std IN | Real throttle.db delayed/latest/concurrent output and independent OUT/SINP changes/reconnects; inspect private link-state flags as well as exposed fields | T11 and std Selection And Verification Scope; configured mca/measComp rebuild, calc pvHistory example when enabled, installed-loader registration |
| busy IN | Actual generated header/typed device supports; Soft/Raw Soft/asyn record processing, HIGH reset, completion and forward links; real relocated testBusyAsynApp driver/database | T12 and busy Selection And Verification Scope; mca/measComp links, motor/pmac and other runtime databases, enabled ADCore/detector paths; verify normal BUILD_IOCS=NO and isolated YES separately |
| scaler IN | Installed cfg/header/DBD, actual drvScalerSoft and shipped databases; count/reset/presets/completion; relocated scalerTestApp with selected CALC; isolated uninstall/realuninstall | T13 and scaler Selection And Verification Scope; mca/measComp and enabled hardware paths, autosave test DB and used MDA tool; resolve the mode-100644 run invocation in the accepted plan |
| motor IN | Coherent motor/motorMotorSim/pmac compilation and linking; installed VERS=7.4, actual motion/readback/completion/stop/jog/home/limits; driver-backed RVEL and model-1 shutdown | T15 and motor Selection And Verification Scope; std motor DB/request paths and optional busy example; enable and survey any additional driver before claiming its behavior |
| recsync HOLD | Retained reccaster library/DBD and database through actual loader, commonIocsh, and site startup; rebuild against final Base | D18 and Consumer Assessment; optional ADCore RECCASTER path only when enabled; no repository/client migration in 1.5.0 |
| measComp HOLD | Both retained carries, real selected-dependency configuration/build, loader/vendor cfg, IOC and applicable device behavior | T14 and measComp HOLD Decision And Source Assessment; calc/sscan/std/busy/scaler changes reach this unchanged module; actual TC-32 and expansion configuration required for device results |
| pcas HOLD | Retained cas/gdd libraries against Base, library-only loader metadata, and actual excas/caDirServ server-client paths | T16 and pcas HOLD Decision And Source Assessment; no external direct consumers found; an ordinary Base CA IOC does not exercise pcas |

Apply the module-bump procedure's Stage 6 to every IN module and its actual census/dependency consumers on all six Linux OS targets. Confirm exact source HEAD and effective overrides before configuration: an existing source directory skips acquisition and may still contain the old pin. Use separately authorized isolated sources/installations and preserve existing local work; this assessment authorizes no source deletion. Reconfigure and relink consumers with the same selected headers/libraries and regenerate build/loader metadata. In particular, asyn is unchanged at R4-46 but consumes calc and sscan; motorMotorSim/pmac consume the new motor, and measComp consumes multiple IN modules. A HOLD or unchanged pin is not an exemption from verification of changed dependencies.

Base remains R7.0.10 with the landed 23-patch set. T5-T8 establish focused Debian 13 results, not release qualification. The final combined tree still needs real aggregate apply/revert, retained-fix regressions, downstream module/consumer builds, Base CA/PVA checks, and all six OS workflow paths. Run check.module-deps against configured module sources before building; run check.deps and check.env against the installed tree after installation. Reassess each affected conditional C17 append through real with/without-option builds on the relevant toolchain; do not remove it from header inspection or a build on a different compiler.

The final tree also invalidates prior loader and fragment runtime evidence where pvxs, module metadata, or dependencies change. Re-run examples/iocsh/tests/run_all.bash and the commonIocsh suite on their documented Debian 13 and Rocky Linux 8.10 environments, using actual installed final libraries, application fixtures, simulators, and the accepted real Milo server. Cover metadata generation/refusal, dependency and version conflicts, ELF/truncation diagnostics, relocated-tree operation, shell lifecycle, installed examples, logging, serial behavior, and M4's measured recovery contract. Update pin-dependent fixture expectations in the relevant implementation; preserve real internal paths and substitute only outer boundaries where the specification permits it.

For installation and release qualification, follow epics-env-pipeline and its verification/combinations references. All required gates, exact layer ref resolution, inventory, symlinks/artifacts, real runtime, binary-link checks, and active internal IOC-consumer builds remain future executions. The public product covers Layers 1-2 on six Linux targets; the internal product covers Layers 1-3 on Debian 12/13 and Rocky 8. Other layer/OS combinations are portability coverage. Do not carry historical inventory counts or old CI/runtime passes into 1.5.0 without matching the final source/artifact identity and the runbook's reuse conditions. The release-cycle runbook owns acceptance and release-wide test ordering.

No candidate-update build, installed-tree test, script migration result, GUI execution, real server recovery, or hardware result is claimed by M1 / T3. Optional uninitialized motor drivers and required motion/shutdown hardware, TC-32/expansion, pmac, enabled VME/device paths, and final VM/consumer access must be identified before accepting their implementation/release plans. Missing mandatory external verification requires an explicit gate under milestone-tracking; it cannot become a source-only compatibility pass or an implicit waiver. Existing known source coverage is the 33 pin-matched Layer 1 roots, four support roots, and two site roots recorded under T2 and T9-T16, with their configuration and source-identity limits preserved.

Repeat the Git comparison and verification mapping after the selected implementations land and before release notes/final readiness. This is the completed M1 assessment of the current candidate plus selected future changes, not a claim that the final combined 1.5.0 source tree already exists.

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
| measComp | c38974e | 9c8e01e025258668208383b370061a2b1ba9d7e8 | 14 | D26 holds the current pin for 1.5.0. Two commits change 13 generated caQtDM screens and docs/requirements.txt; the IOC source/build/startup paths and both carry inputs are unchanged. T14 and the dedicated assessment below record screen functionality, references, and the fresh consumer census. Retain both existing carries and verify the current measComp against selected dependency updates during integrated verification. |
| motor | 285f44d | 47893ed11b0027b90a94622847ebc5332ba6b99a | 44 | Adds actual velocity and position-compare support, changes homing fallback and driver gitlinks, and removes NUM_MOTOR_DRIVER_PARAMS. Pinned pmac uses that macro in pmacController.cpp:137 and pmacCSController.cpp:151. The latest branch candidate requires a consumer change. D27 selects 4b22ac9, the R7-4 source with the upstream version-reporting correction, retaining the required macro; T15 and the dedicated scope below record the exact comparison and consumer obligations. |
| pcas | e075fd4 | bdf2b0ab4229e0bb69dbe9107dbb40c332db4f33 | 1 | D28 holds e075fd4 for 1.5.0. Two commits change only the upstream workflow, with 38 insertions and 35 deletions; all other source paths are identical. T16 and the dedicated assessment below record the fresh census, tag ancestry, and retained-pin verification scope. |

Published-tag alternatives were checked independently of the branch-head comparison:

| Module | Published tag and resolved commit | Difference relevant to selection |
| --- | --- | --- |
| recsync | 1.10.0, e749f9e5a32af21099cc76a51789a40dc8d6ec89 | Already lacks the client source. Selecting the release tag does not avoid the repository migration. |
| calc | R3-8, 712a40453e8693fda3b90a6e9da5fdb1c708ee38 | Five changed files from the old pin; includes the calculation fixes and tests, before the later DESC and userTransforms10 default changes. |
| motor | R7-4, 68605b9512c8da65e83933474d17cadb453ec13b | Twenty-eight changed files; adds motorActVelocity and other fixes while retaining NUM_MOTOR_DRIVER_PARAMS. The tag still defines VERSION as 7.3 in motorRecord.cc; upstream 4b22ac950de98c2dca324c2ef8ef221e124f6651 corrects that reporting value to 7.4. Account for this before selecting a tag-only update. A coherent motorMotorSim/pmac rebuild remains required. |

The observed latest tags for sscan (R2-12), lua (R3-1), std (R3-6-4), busy (R1-7-4), scaler (4.1), measComp (R4-3), and pcas (v4.13.3) are ancestors of their existing pins. Moving to those tags would move backward. caPutLog R4.2, pyDevSup 2.1.0, and pvxs 1.5.3 resolve to the compared candidate commits.

Recommendations for the owner decision: pyDevSup 2.1.0, pvxs 1.5.3, caPutLog R4.2, calc R3-8, sscan ce9660c, std 27b6967, busy a4a272d, scaler baa8e1c, and motor R7-4 can proceed to explicitly scoped real verification after selection. Hold recsync pending a repository-migration decision and Lua pending a dedicated migration/test scope. measComp's screen-only update and pcas's CI-only update can remain at their current pins unless those changes are wanted in 1.5.0. These are recommendations only: no IN/HOLD verdict, new implementation milestone, or pin edit is authorized by this table.

Decision Date: 2026-10-07. D18 records recsync 9834b94edc63eece42712b8355a4703d4286dd8f -> unchanged, verdict HOLD for the compared newer recsync branch and 1.10.0 release. Migration to the separate reccaster repository is assigned to 1.6.0, with its complete work detail in `docs/milestone-1.6.0.md`. The comparison with standalone reccaster 1.9.7 finds identical headers, DB/DBD, and library Makefiles, with small C/C++ style changes and changed parent override paths; it does not remove EPICS-env's acquisition and `client/` integration obligation. No recsync pin or source path was changed and no migration build/runtime check ran. `docs/CLOSED_DOORS.md` retains the examined-state Keep decision. The tracking issue is published as #101, https://github.com/jeonghanlee/EPICS-env/issues/101, in the existing GitHub Backlog milestone, number 3. It retains 1.6.0 as the planned release; no remote milestone was created. Readback at 2026-10-08T00:00:55Z confirms the open issue's title, full body, enhancement label, jeonghanlee assignee, and Backlog assignment; remote updatedAt is 2026-10-08T00:00:30Z.

Decision Date: 2026-10-07. D19 records caPutLog dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 -> R4.2 at 6f9eb3f6c75e49201d114f8e194d53cef493a522, verdict IN. The full source comparison and subsequent `git diff --numstat dafb0b2..R4.2` inspection confirm only docs/index.rst (eight insertions, four deletions) and docs/releasenotes.rst (18 insertions). The GitHub tag-ref API resolves R4.2 directly to the selected commit. Installed-loader entries, commonIocsh, tc32sim, and the site logging fragment remain the real verification consumers. pyDevSup's optional linkage stays disabled in the current recipe; its logging example and Base pva2pva's putlog startup are optional consumers, not newly enabled by this decision. No pin edit, new implementation work row, build, or runtime pass is recorded by this selection. The caPutLog implementation plan must be assigned and separately accepted before execution. After D19, nine candidate choices remained: calc, sscan, lua, std, busy, scaler, measComp, motor, and pcas.

Decision Date: 2026-10-07. D20 records calc 4217e83a9b9067017f4dc74da6b70e3669972f16 -> R3-8 at 712a40453e8693fda3b90a6e9da5fdb1c708ee38, verdict IN. The selected release contains the modulo-overflow, runtime-stack, string/array-bounds, derivative-window, and variable-argument traversal fixes. Rechecked at 2026-10-08T00:39:54Z through the GitHub tag-ref API and `git diff 4217e83..R3-8`: the tag resolves directly to the selected commit, and five files change with 107 insertions and 13 deletions. Three implementation files and two upstream test files change; public headers, build files, and databases are unchanged. The sixteen later database changes between R3-8 and branch candidate 59d1fe51c2d4e8c8eec2ad9d067831c93d69f5cb are outside this selection. The real upstream tests and affected aCalc/sCalc records require execution; calc's link, header, DBD, and runtime consumers remain as listed below, including asyn, StreamDevice, mca, measComp, std, sscan, QPC, pmac, and conditional scaler/ADCore paths. No pin edit, new implementation work row, build, or runtime pass is recorded by this selection. The calc implementation plan must be assigned and separately accepted before execution. After D20, eight candidate choices remained: sscan, lua, std, busy, scaler, measComp, motor, and pcas.

Decision Date: 2026-10-07. D21 records sscan e13699e3062145d516cfdd555aae25bb49a8c53b -> ce9660cfc05071834391225beadf7f93b776d216, verdict IN. Rechecked at 2026-10-08T01:00:54Z through the GitHub branch-head API, effective Make pin queries, and `git diff e13699e..ce9660c`: the branch candidate still resolves to the selected commit, while both effective source pins remain e13699e. The full comparison changes sscanApp/src/sscanRecord.c by 16 insertions and ten deletions and sscanApp/src/writeXDR.h by one insertion and one deletion. PR #38 removes delay quantization outside vxWorks and requires Base 7.0.10 or later for very short delays; the current Base pin is R7.0.10. PR #42 rounds the floating-point scan-point calculation before integer assignment. PR #41 changes xdrproc_t from an unspecified argument list to FILE* and char* arguments for C23. No external use of the changed callback type was found in the surveyed sources; build files and DBD definitions are unchanged. R2-12 is already an ancestor of the old pin, so selecting that tag would move backward. No direct sscan patch exists. The existing C17 setting remains subject to real with/without-option builds rather than a static removal decision. Fresh ignore-disabled ripgrep and find/grep traversals agreed across all 39 source roots; active and conditional consumers are listed below. Verify actual scan point counts, short delays, saveData/XDR files, installed-loader registration, and module/consumer build and IOC startup paths. No pin edit, new implementation work row, build, or runtime pass is recorded by this selection. The sscan implementation plan must be assigned and separately accepted before execution. After D21, seven candidate choices remained: lua, std, busy, scaler, measComp, motor, and pcas.

###### Lua Selection And Compatibility Scope

Decision Date: 2026-10-07. D22 records lua 17475b50ae95c801bad9573bb2b031ffb04ac75c -> 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d, verdict IN. The selected object is an untagged master commit, not a published R4 release. The upstream branch-head and tag-list APIs were rechecked during T10; R3-1 at 631771e61676a6f03a668c51f272f37e2579e94b already precedes the current pin. Effective Make pin queries still return 17475b5. The full source comparison has 232 changed files, 37,600 insertions, and 20,205 deletions. Include this candidate in 1.5.0 despite the earlier HOLD recommendation, with the dedicated compatibility obligations below. After D22, six candidate decisions remained: std, busy, scaler, measComp, motor, and pcas.

Actual luaApp/src/core/lua.h identifies bundled Lua 5.4.6 in the current pin and 5.5.1 in the selected candidate. Public header and Makefile diffs remove luaaa.hpp and the lua_asynPortDriver/lua_asynOctetClient wrapper classes, convert ten device-support files from C to C++, and add per-state locking/reference APIs and luaPortDriver stateMutex. Existing shell entry names remain deprecated aliases; this does not establish unchanged behavior. Actual lepicslib.cpp removes epics.sleep and the PV object's getName method/pv_name property; losilib.cpp provides osi.sleep, and the new PV object exposes name. Existing scripts using those removed APIs require migration. The luascript DBD adds processing/output/alarm fields and enlarges string fields; all related code and generated headers must use the same new definitions.

The selected root Makefile builds example IOCs only with BUILD_IOCS=YES; CONFIG_SITE defaults to NO. The old testLuaIoc/testLuaShell production entries are removed, while luaApp/test is built independently of that example option. The current conf.lua recipe sets ASYN, INSTALL_LOCATION, CHECK_RELEASE, and the conditional C17 flag; it does not enable BUILD_IOCS. There is no Lua-specific carried patch in the current patch rules. Compare real builds with and without the C17 setting before considering its removal.

Fresh ignore-disabled, hidden-file-inclusive ripgrep and find/grep traversals agreed across all 39 available source roots, including Lua scripts and startup files. No active external Lua header/library/DBD/script consumer was found in that initialized configuration. Motor declares build.lua, but its optional driver submodules are uninitialized and modules/Makefile includes only checked-out submodules with a Makefile. The exact motor gitlink for motorScriptMotor is 0c63c3f24e1f5572549e4c00ccc4fa20e84cd573; its actual upstream scriptMotorApp/src/Makefile links lua, ScriptMotorDriver.h includes luaEpics.h, and its driver/scripts call Lua, epics, and asyn APIs. This is a conditional direct consumer, not a clean compatibility verdict. PSC driver Wireshark scripts use Wireshark's Lua interpreter, not this EPICS library. No direct Lua use was found in the four support and two site source roots.

Required real-path verification before completion:

- Build the exact selected module and all enabled consumers coherently. Verify installed identity, cfg dependency files, library/DBD registration, and the installed-module loader. Recheck optional motorScriptMotor selection and its actual source census before any consumer build.
- Execute all eight shipped luaApp/test programs with their original fixtures: luaScriptTest, luaDtypTest, luaPortDriverTest, luaShellTest, luaEpicsTest, luaEventTest, luaConcurrencyTest, and bytestreamTest. Record actual results rather than assuming that their presence verifies behavior.
- Run representative existing scripts and the selected iocLuaExample startup paths. Check removed API migration, old shell aliases and new run/load commands, script paths, scalar/string/array records, CA/database/asyn access, and concurrent state use. Explicitly enable the example build in the verification configuration and verify the resulting executable/DBD names.
- If motorScriptMotor is enabled, rebuild/relink it against the selected Lua headers/library and execute its real script, parameter, reload, and IOC startup paths. Do not count the current uninitialized submodule as having passed.
- Account for Lua 5.5 language/C API changes and incompatible precompiled chunks. Recompile actual consumers and regenerate precompiled scripts where applicable; the official compatibility list is https://www.lua.org/manual/5.5/manual.html#8. Verify every required platform and consumer through the module-bump procedure's Stage 6.

These are verification obligations, not observed passes or an accepted implementation plan. The Lua implementation plan must be assigned and separately accepted before pin edits or builds; source selection does not authorize those actions.

###### std Selection And Verification Scope

Decision Date: 2026-10-07. D23 records std 5f2e44214963b84ea3a400f7b7c3a9f510126ddd -> 27b696702c4ebc8c698c98e3bbb10a34f1a2c821, verdict IN. T11 rechecked the upstream master API against the exact local candidate object; effective source tag/version queries remain 5f2e442. The latest module release tag R3-6-4 at 1b416dbb74fb54060395347433c30361bd276424 already precedes the existing pin, so the selected target is an untagged branch commit. After D23, five candidate decisions remained: busy, scaler, measComp, motor, and pcas.

The complete diff changes only stdApp/src/throttleRecord.c: nine insertions and three deletions. Original commit 06c6f4a0aeb01fad14e72175276495489bdffc89, merged through PR #27, wraps delayFuncCallback's valuePut call in dbScanLock/dbScanUnlock. The actual Base dbLock.h documents this lock for record modification and requires the matching unlock. Original commit 4822763c88059fe2a55c78b1ce2321a6c509301d, merged through PR #29, selects the correct outLinkStat or sinpLinkStat pointer in special() and resets caLink/caLinkNc independently for each checkLink iteration. These are source-observed fixes; no local execution has reproduced the old race or verified the new behavior. Public headers, DBD definitions, build options, installed cfg definitions, and databases are unchanged. No std-specific patch is present in the current carry rules.

Fresh ignore-disabled, hidden-file-inclusive ripgrep and find/grep searches agreed across all 39 source roots. The primary expression covers std library lists in every position, public record headers/DBD, STD paths, and throttle support. A supplemental paired search covers epid/timestamp record declarations and the remaining command/device-support names. Neither search found an active external std header/library consumer. mca and measComp declare build.std but have no corresponding direct link/header use in the surveyed sources. calc's iocBoot/iocCalc/calc.iocsh loads $(STD)/stdApp/Db/pvHistory.db; this is an example runtime consumer, not a new std library dependency. No direct std use was found in the four support and two site source roots. Base's epId variable and pvxs's transmission-throttle comment/pvxcall tool are unrelated matches. The installed loader registers stdSupport.dbd.

Required real-path verification before completion:

- Build and install the exact selected std source, verify library/DBD/cfg identity and installed-loader registration, and reconfigure/rebuild the declared mca and measComp dependents through the actual environment targets. Recheck the actual enabled consumer configuration.
- Load the shipped stdApp/Db/throttle.db into a real IOC. Exercise immediate output after the configured delay, multiple value changes within the delay, delivery of the latest value, and concurrent processing/callback execution. Observe actual OUT writes, SENT/WAIT state, and forward-link behavior; source inspection alone does not verify the locking regression.
- Exercise independent OUT and SINP changes, CA disconnect/reconnect, and local/constant link combinations. Validate the affected per-link private status flags as well as exposed link-validity fields; exposed fields alone do not prove the private-flag assignment fix.
- Verify the calc example's std database load when that example is enabled. Run the required platform build/startup and installed check.deps/check.env paths. Compare real builds with and without the conditional C17 option before deciding whether it can be removed.

The std implementation plan must be assigned and separately accepted before pin edits or builds. The IN decision records the selected source and verification obligations, not implementation authority or an observed runtime pass.

###### busy Selection And Verification Scope

Decision Date: 2026-10-07. D24 records busy 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb -> a4a272d94d1f4351e7d9553e6dc35782eb96ce75, verdict IN. The master API resolves to this exact candidate, committed 2026-09-21T16:35:17Z; effective Make source tag/version queries remain 2dfe92d. The latest module tag R1-7-4 at 569a6b6fb1288c067ac2b22a998aa7de5375ddc4 precedes the existing pin, confirmed by the actual ancestry check. The selected target is therefore an untagged branch commit. After D24, four candidate decisions remained: scaler, measComp, motor, and pcas.

The complete comparison changes 39 files with 806 insertions and 152 deletions, including documentation expansion and example relocation. PR epics-modules/busy#17 moves busydset into busyRecord.dbd, embeds the Base dset as common, and changes the record/device support to typed function declarations. The actual Base devSup.h defines typed_dset and selects it through USE_TYPED_DSET. Existing record field types and defaults are unchanged; DOL's prompt text changes. The three device support names remain Soft Channel, Raw Soft Channel, and asynInt32. No busy-specific carry exists in the current patch rules.

The candidate installs cfg/CONFIG_MODULE and cfg/BUSY_DEPS with BUSY_IOC_DBDS=busySupport.dbd and BUSY_IOC_LIBS=busy. BUILD_IOCS defaults to NO. The old source builds testBusyAsyn when both ASYN and AUTOSAVE are set, as the current conf.busy recipe does. The candidate instead places the example under iocs/testBusyAsynIOC and builds testBusyAsynApp only with BUILD_IOCS=YES. Its test driver and registrar move out of libbusy into the example application. The example's new paths and executable name must be used for runtime verification; library installation alone does not exercise this driver.

Fresh ignore-disabled, hidden-file-inclusive ripgrep and find/grep traversals agreed across all 39 source roots. The primary expression covers busy library-list entries in every position, busySupport, busyRecord, busydset, devBusy, busy record declarations, and BUSY paths. A supplemental paired search covers testBusyAsyn, asynBusyInt32, devBusySoftRaw, and devBusySoft; its only matches are in busy itself. No external custom busy device support or test driver use was found in the initialized roots. mca's Rontec library/IOC and measComp's HAVE_ULDAQ-enabled Linux IOC have active link evidence. mca's Canberra/Amptek and VME SIS paths are conditional or platform-specific under the current recipe. Motor and pmac consume busy records; pmac also includes busySupport.dbd, while its example IOC links are disabled by BUILD_IOCS=NO. feed-core's carried library-only patch removes its bundled IOC link, but its installed busy-record templates remain consumers. calc, std, and autosave have runtime databases; sequencer has a parallel-processing example. ADCore supplies busy-record templates and conditional BUSY library/DBD entries; detector IOC paths using its commonDriverMakefile require the same runtime support when enabled. No direct use was found in the two available site roots. Optional uninitialized motor driver submodules remain outside this source census.

Required real-path verification before completion:

- Build and install the exact candidate against the selected Base/asyn/autosave stack. Verify the generated busyRecord.h, all three registered device supports, libbusy, busySupport.dbd, cfg/CONFIG_MODULE, cfg/BUSY_DEPS, and installed-loader registration.
- Run the shipped busyRecord and testBusyAsyn databases in a real IOC. Exercise Soft Channel and Raw Soft Channel output, VAL transitions, HIGH delayed reset, put-completion callbacks, forward-link behavior, and asyn synchronous/asynchronous processing with single, repeated, and separately triggered callbacks. Use the actual shipped test driver, not a substitute.
- Build the relocated example with BUILD_IOCS=YES in an isolated verification configuration and start testBusyAsynApp through its actual startup path. Verify the normal BUILD_IOCS=NO library installation separately.
- Reconfigure/rebuild the declared mca, measComp, motor, and pmac dependents, relink enabled consumers, and load the affected installed databases. Cover ADCore and enabled detector IOC paths; recheck configuration and optional submodule selection before execution.
- Complete the required platform build/startup and installed check.deps/check.env paths. Compare real builds with and without the conditional C17 option before deciding whether to remove it.

The busy implementation plan must be assigned and separately accepted before pin edits or builds. The IN decision records source selection and verification obligations, not implementation authority or an observed runtime pass.

###### scaler Selection And Verification Scope

Decision Date: 2026-10-07. D25 records scaler beb5521af49616682e4e442c3e33a06add1bd713 -> baa8e1c5e5a9a5deceef8cc39207a0da446092a6, verdict IN. The upstream master API resolves to the selected candidate, committed 2026-06-07T21:14:49Z; effective Make source tag/version queries remain beb5521. The latest published release 4.1, published 2023-06-07T19:58:18Z, resolves to eddb4394381d98342e7c55b51bdcc6af30c3443c and precedes the old pin, confirmed by the actual ancestry check. The selected target is an untagged branch commit. After D25, three candidate decisions remained: measComp, motor, and pcas.

The full comparison changes 33 files with 708 insertions and 411 deletions. Record and driver implementation, public headers, DBD definitions, shipped databases, and softScaler.iocsh are unchanged. The moved example main changes comments only. The changes add installed cfg/CONFIG_MODULE and cfg/SCALER_DEPS, declaring SCALER_IOC_DBDS=scalerSupport.dbd and SCALER_IOC_LIBS=scaler, and reorganize documentation and the example IOC. No scaler-specific carry exists in the current patch rules. The existing C17 setting remains subject to actual build comparison.

BUILD_IOCS defaults to NO. The old example scalerApp was conditional on CALC, which the current conf.scaler recipe does not set and the upstream RELEASE leaves commented out. The new example is iocs/scalerTestIOC with executable scalerTestApp; enabling it requires BUILD_IOCS=YES and a valid CALC path. Its Makefile consumes CALC_IOC_DBDS/CALC_IOC_LIBS, which exist in the selected calc R3-8 source. Startup now loads $(SCALER)/iocsh/softScaler.iocsh. The relocated run script changes from mode 100755 to 100644, so direct ./run invocation loses execution permission; the accepted implementation/test plan must specify the actual invocation without silently editing upstream source. The top-level uninstall and realuninstall targets now recurse into iocs, including when normal IOC builds are disabled.

Fresh case-insensitive, ignore-disabled, hidden-file-inclusive ripgrep and find/grep searches agreed per root across all 39 sources. The expression covers the whole scaler name, scalerSupport, scalerRecord, devScaler, and SCALER_ tokens over Makefiles, source/header, database/DBD, startup, request, dependency, Python, and shell files. measComp's USBCTR driver includes devScalerAsyn.h, its HAVE_ULDAQ-enabled Linux IOC links scaler and includes scalerSupport.dbd, and its startup loads scaler.db with Asyn Scaler device support. mca's SIS drivers include the same header and list scaler in library/IOC links; those builds are vxWorks/RTEMS-specific, with the Linux VME selections commented out in the surveyed source. mca also supplies scaler startup, request files, and acquisition-control database links. Autosave's SR_test.db contains a scaler record. sscan's MDA Python tool maps scaler S1-S64 fields to NM1-NM64 descriptions; its generic RECORD_SCALER_DATA log message is not an additional scaler-library dependency. Base and pcas matches are scalar-data comments or messages, not module consumers. No direct use was found in the four support or two site source roots. Declared rebuild dependencies remain mca and measComp; actual enabled paths must be checked again before execution.

Required real-path verification before completion:

- Build and install the exact selected source against the selected Base/asyn stack. Verify libscaler, generated scalerRecord.h, scalerSupport.dbd, cfg/CONFIG_MODULE, cfg/SCALER_DEPS, installed source identity, and loader registration.
- Execute the shipped softScaler.iocsh, scaler.db, and scalerSoftCtrl.db with the actual drvScalerSoft in a real IOC. Exercise count start/stop, reset, presets, channel values, and completion behavior through the shipped records and driver.
- Enable and build the relocated scalerTestApp with the selected calc path in an isolated verification configuration. Verify its DBD, startup paths, and chosen invocation of the shipped example. Check the normal BUILD_IOCS=NO install and the changed uninstall/realuninstall paths in an isolated installation.
- Reconfigure/rebuild mca and measComp, relink enabled consumers, and load their actual scaler databases/request files. Cover enabled VME SIS paths and the autosave test database; check MDA scaler-description handling when that tool is used. Hardware behavior requires the corresponding actual device and is not established by soft-scaler execution.
- Complete required platform build/startup and installed check.deps/check.env paths. Compare real builds with and without the conditional C17 option before deciding whether to remove it.

The scaler implementation plan must be assigned and separately accepted before pin edits or builds. This source selection does not establish an observed build, IOC, or hardware pass.

###### measComp HOLD Decision And Source Assessment

Decision Date: 2026-10-07. D26 keeps measComp c38974e85c59429b8ba48ed320681ba0296fb924 unchanged for 1.5.0, verdict HOLD for 9c8e01e025258668208383b370061a2b1ba9d7e8. T14 rechecked the upstream master and tag APIs against the actual source objects; both effective Make source tag/version queries still return c38974e. The compared master commit is dated 2026-07-13T17:30:10Z. Latest module tag R4-3 at bad545061ef24acc718f40676e982b7eb3d69ff3 is an ancestor of the current pin, so selecting that tag would move backward. After D26, two candidate decisions remained: motor and pcas.

The complete old-to-candidate comparison contains two commits, 14 files, 10,758 insertions, and 6,308 deletions. Only 13 generated caQtDM screens under measCompApp/op/ui/autoconvert and docs/requirements.txt change. Driver implementation, public headers, DBD, databases, configure files, root Makefile, and iocBoot are unchanged. The documentation dependency moves from mistune<0.8.5 to mistune==3.3.0; no IOC dependency or build setting changes.

The screen changes are functional rather than formatting only. They add the USB-ERB24 screen and its top-level menu entry, change embedded/related-display references from .adl to .ui, move USB3104's inline analogue output controls into measCompAnalogOutSync8.ui, expose existing SyncMaster/SyncEnable/SyncWrite and WaveGen PulseDelay records, and remove the counter include from USBTEMP_module.ui. XML parsing of the real changed files succeeds. Comparison of the USB3104 inline channel properties with the new output screen finds all old channel properties retained, plus the three sync channels. All 37 unique literal referenced screen filenames exist in the full candidate source. These observations do not establish GUI loading, macro inheritance, PV connection, or device behavior.

The tracked CONFIG_MEASCOMP and TC-32 channel-count patch files and their shipped Make rules are retained unchanged. The candidate leaves both patch input paths byte-identical to the old pin and contains neither carried addition. T14 did not apply or reverse those patches on the candidate; the earlier current-pin round-trip evidence remains under Existing Patch Dependency Cross-check. Holding the update does not waive the current carries' release verification.

Fresh case-insensitive, ignore-disabled, hidden-file-inclusive ripgrep and find/grep traversals agree per root across 33 environment, four support, and two site sources. The primary expression covers measComp, driver/header names, discovery, and CONFIG_MEASCOMP; the supplemental pair covers the actual MultiFunctionConfig, USBCTRConfig, USBCTR_SNLRegistrar, and measCompShowDevices command/registrar names. No active external library/header/DBD/startup consumer is found. One site source contains only commented configuration/discovery commands. No other module declares build.measComp.

measComp itself declares Base, asyn, calc, sscan, busy, scaler, sequencer, autosave, std, and mca prerequisites. Its unchanged pin still requires real configuration/build, installed-loader/vendor cfg, and IOC verification against the selected dependency combination, including the selected calc, sscan, busy, scaler, and std updates. Actual TC-32 behavior requires the corresponding hardware and expansion configuration. No candidate screen update, new implementation work row, pin edit, patch removal, or new build/runtime pass follows from this HOLD. The examined-state Keep record is in docs/CLOSED_DOORS.md.

###### motor Selection And Verification Scope

Decision Date: 2026-10-07. D27 selects motor 285f44d66cf7d07a86047719de757bd1f5d92a95 -> 4b22ac950de98c2dca324c2ef8ef221e124f6651, verdict IN. This is an exact upstream commit after the published R7-4 tag at 68605b9512c8da65e83933474d17cadb453ec13b, not the latest branch head. The upstream release API reports R7-4 published 2026-03-09T20:21:09Z; the selected commit is dated 2026-03-09T20:34:37Z. Effective Make source tag/version queries still return 285f44d. After D27, the remaining candidate decision was pcas.

T15 compares all four real source objects. Old-to-R7-4 changes 28 files, 289 insertions, and 60 deletions. Old-to-selected changes 29 files, 290 insertions, and 61 deletions. Only two upstream commits lie between the release tag and selected source: a906acae881e617cec92a4dce070b5d81273b3dd adds a colon in docs/RELEASE.md, and 4b22ac950de98c2dca324c2ef8ef221e124f6651 changes VERSION from 7.3 to 7.4 in motorRecord.cc. The actual initialization assigns VERSION to the motor record VERS field. This is a source finding; no installed record's VERS has been observed. Use the complete selected upstream source without a local version patch.

The selected source adds the motorActVelocity parameter and updates the asyn axis status/callback path for velocity feedback, removes the deprecated register keyword from motordrvCom.cc, and adds a shutdown hook/wakeup/exit condition for model-1 motor_task instances. The asynMotorController class gains a protected member within its existing layout. Its existing signatures and NUM_MOTOR_DRIVER_PARAMS remain; motor, motorMotorSim, and pmac must compile and link against the same headers/libraries. Runtime RVEL improvement requires a driver that supplies the actual velocity parameter; simulator movement alone cannot establish that behavior for every driver. Core Makefiles, configure files, motorRecord.dbd, and shipped databases are unchanged from the old pin. modules/Makefile adds conditional STD forwarding; the current conf.motor does not supply STD.

The unselected latest branch 47893ed11b0027b90a94622847ebc5332ba6b99a changes 44 files, 23,748 insertions, and 140 deletions from the old pin. It adds position-compare support and screens, changes the HVEL=0 fallback from VBAS to VELO, and removes NUM_MOTOR_DRIVER_PARAMS. The pinned pmac at 02c4f7247c760634e73b4e5175e3380844c3a77a uses that macro in its two controller constructors. Those source references remain incompatible with the latest branch; no failed compilation was executed. This later branch and its broader behavior changes are outside D27's selection.

Fresh case-insensitive, ignore-disabled, hidden-file-inclusive ripgrep and find/grep searches agree per root across all 39 available sources. The primary expression covers motor library/header/DBD/record paths and MOTOR_ tokens; the supplemental pair covers the remaining exported motor headers, controller commands, new velocity names, and the parameter-count macro. motorMotorSim and pmac directly include asynMotorController/asynMotorAxis and link motor; motorMotorSim also includes motor_interface.h, and both IOC/library paths name the relevant DBD support. std supplies soft motor databases and motor save-request files. busy's Python documentation example controls motor PVs and is an optional runtime example rather than a library dependency. Base/calc/sscan/asyn/mca/opcua matches are comments, generic motion, or unrelated device names; StreamDevice's legacy steppermotorRecord entry is not this module's motor record. No direct motor use is found in the four support or two site roots.

Sixteen motor driver gitlinks change from the old pin. The current clone rule checks out motor without initializing these submodules, and modules/Makefile includes only children with a checked-out Makefile. All optional driver submodules in the assessment checkout remain uninitialized and outside the current active census. The selected motorMotorSim gitlink equals 39a66815a386b9fc8b948e369ac325df3848436e, matching the separately pinned R1-3 source. Enabling another driver requires a new source census and its actual build/runtime checks. The shipped motor patch list is empty; no new carry is needed for the selected version correction.

Required real-path verification before completion:

- Acquire/configure/build/install the exact selected motor source against the selected Base/asyn and configured prerequisites. Verify motorSupport.dbd, devSoftMotor.dbd, libmotor/libsoftMotor, generated motorRecord.h, installed source identity, loader registration, and VERS=7.4 in an actual loaded motor record.
- Reconfigure/rebuild/relink motorMotorSim R1-3 and the pinned pmac against the selected motor headers and libraries. Exercise the shipped simulator databases and IOC fragments, with paths appropriate to the separately installed motorMotorSim tree. Verify movement, readback, completion, stop, jog/home, limits, and startup registration. No old binary/new-header mixture is acceptable.
- Exercise velocity feedback with a real enabled upstream driver that supplies motorActVelocity; observe RVEL updates and callbacks. Test model-1 shutdown with a real enabled model-1 driver that starts motor_task. Record either path as unverified when the required driver/device is unavailable; a different simulator or idle IOC does not cover it.
- Load affected std motor databases/request paths and any explicitly enabled busy motor example. Complete the required platform build/startup and installed check.deps/check.env paths; pmac device and trajectory behavior require the corresponding real hardware.

The motor implementation plan must be assigned and separately accepted before pin edits or builds. D27 records source selection and verification obligations only; no new implementation work row, local source modification, patch addition, build, IOC, or hardware pass is recorded.

###### pcas HOLD Decision And Source Assessment

Decision Date: 2026-10-07. D28 retains pcas e075fd450ab9a66bbc044eaa4c2035d3d26d9651 for 1.5.0, verdict HOLD for bdf2b0ab4229e0bb69dbe9107dbb40c332db4f33. The master API resolves to this compared candidate, dated 2026-07-20T13:58:16Z. Both effective Make source tag/version queries still return e075fd4. Latest module tag v4.13.3 at 6ba32b5c3b39d05dc16d8ea8b95b5a991bdb59b0 is an ancestor of the retained pin; selecting it would move backward. All thirteen candidate choices are now resolved: ten IN and three HOLD.

The complete comparison contains two commits, 0c28eb6b5 and bdf2b0ab4, and changes only .github/workflows/ci-scripts-build.yml, with 38 insertions and 35 deletions. The actual diff changes Ubuntu runners and job names, Actions checkout/artifact versions, CI package and warning options, and CI container setup. A full Git diff excluding this one file returns zero: every other source path, including libraries, headers, Makefiles, configure files, examples, templates, version configuration, and submodule gitlinks, is identical. These upstream workflow changes do not enter EPICS-env's module build path. No workflow execution or compiler/runtime result is inferred from the source comparison.

Fresh case-insensitive, ignore-disabled, hidden-file-inclusive ripgrep and find/grep traversals agree per root across 33 environment, four support, and two site sources. The broad primary expression covers pcas, cas/gdd public names, generic-data types, and library names. The supplemental pair uses actual exported header include names and cas/gdd library-list entries in every position, including mixed-case LIBs and plain/append assignments. The only direct header/library matches are inside pcas itself. Broad matches elsewhere are Base CA server/client and atomic names, CA event-test names, unrelated upper-case/case-fold functions, or background-array variable names. No external cas/gdd header or library consumer is found, and no other module declares build.pcas.

The shipped loader lists cas and gdd as pcas libraries and supplies no pcas DBD. pcas depends on Base; its cas library links ca, gdd, and Com, and gdd links Com. The module builds its own server examples, excas and caDirServ. No pcas-specific patch is present. Holding the candidate preserves the existing code but does not waive coherent builds against the selected Base or installed-library/loader and actual server verification during integrated release checks. A normal IOC using Base's CA server does not exercise the pcas server examples.

No new pcas update work row, pin edit, carry, future-release assignment, or issue is created. No build, upstream CI execution, installed-loader check, server/client exchange, or runtime verification ran during T16. The examined-state Keep record is in docs/CLOSED_DOORS.md. The current 1.4.0 comparison and consolidated scope are now recorded under T3; M1 closure still requires the remaining evidence to land and its linked issue to be reconciled.

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
| sscan | calc's SSCAN-enabled library, asyn's testEpicsSupport/testEpics IOC, mca's configured applications and Rontec library, and measComp's HAVE_ULDAQ-enabled Linux IOC have source link evidence. stdApp/Db/trend.db instantiates an sscan record. StreamDevice's application links sscan only when SSCAN or SYNAPPS is configured alongside CALC; the default recipe supplies CALC but neither SSCAN nor SYNAPPS. ADCore's SSCAN entry is optional. QPC's application link is removed by the data-only patch. No direct sscan consumer was found in the two surveyed site source roots. Transitive rebuilds follow calc/asyn and their configured dependents. |
| lua | No active external Lua header/library/script consumer found in the initialized roots. Motor declares build.lua; its optional motorScriptMotor is uninitialized and therefore excluded by the modules/Makefile wildcard. The exact motor-pinned driver source links lua and includes luaEpics.h, so enabling it adds a direct consumer requiring rebuild, script/reload, and IOC checks. Verify Lua's own shipped tests, records, shell, scripts, asyn/state behavior, installed cfg, and loader registration; D22 selects the candidate with the dedicated scope above. |
| std | Paired primary and supplemental searches found no active external std-library/header consumer across 39 roots. mca/measComp declare build-order dependencies; calc's calc.iocsh loads the std pvHistory database as an example runtime consumer. No direct use was found in the four support/two site roots. D23 selects 27b6967; verify real throttle delayed/concurrent output, independent OUT/SINP status and reconnect behavior, loader registration, and configured consumer paths as specified above. |
| busy | mca and measComp have active link evidence. Motor/pmac, feed-core, calc, std, autosave, and ADCore consume runtime records/templates; pmac also includes busySupport.dbd, and sequencer has an optional example. ADCore's library entry is conditional. feed-core's bundled IOC link is removed by its patch. D24 selects a4a272d; T12 and the dedicated scope above retain the typed support, relocated example, installed cfg, completion callback, and consumer verification obligations. |
| scaler | measComp's USBCTR driver includes devScalerAsyn.h and its enabled Linux IOC links scaler. mca SIS header/library/IOC paths are platform-specific; its databases, startup, and requests also use scaler. Autosave has a scaler test database; sscan's MDA tool maps scaler channel descriptions. No direct use was found in four support/two site roots. D25 selects baa8e1c; T13 and the dedicated scope above retain installed cfg, relocated-example invocation, real soft-scaler, configured-consumer, and C17 verification obligations. |
| measComp | D26 retains c38974e for 1.5.0. T14 primary and supplemental paired traversals find no active external library/header/DBD/startup consumer across 39 roots; site configuration/discovery comments are inactive. Its own selected-dependency build, driver/IOC, loader, installed vendor cfg, and both existing carries still require integrated verification. No candidate GUI or runtime pass is claimed. |
| motor | motorMotorSim and pmac directly include/link motor; std supplies motor databases and save-request files, and busy has an optional Python motor example. T15 primary and supplemental traversals agree across 39 roots; no direct support/site consumer is found. D27 selects 4b22ac9, retaining the pmac macro and correcting the source VERS value. Rebuild all direct consumers together and execute the dedicated version, motion, velocity, and applicable shutdown checks above. Optional uninitialized motor drivers require a fresh census if enabled. |
| pcas | D28 retains e075fd4. T16 primary and supplemental paired traversals agree across 39 roots and find no external cas/gdd header or library consumer. The loader records cas/gdd as library-only metadata with no DBD. Verify the current pin against selected Base, installed loader/libraries, and the shipped excas/caDirServ examples during integrated release verification; no candidate build or runtime pass is claimed. |

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

Verification limits: other platforms, CI/VM qualification, strict installed-tree dependency verification, downstream consumer builds, all released-fix runtime regressions, RTEMS, thread-resource or allocation exhaustion, NDEBUG builds of all libCom, supervisor recovery, and release qualification remain unverified by T5-T6. No per-fix runtime proof is inferred for the unexercised #753 paths or cf85a1a5 diagnostic identity. The selected Base work and focused review are complete locally; D16-D17 subsequently select pvxs and pyDevSup, while eleven other module decisions and the release comparison remain pending. M1 remains In progress and M2-M5 retain their recorded state.

###### Base Revert Correction And Review

Completion recorded: 2026-10-07. The fresh Base assessment, selected original #900 dependency chain, production wiring, native focused checks, and corrected partial-stack reversal are complete within the authorized local scope. The selected 23-patch list, upstream patch bytes, and module pins are unchanged by the revert correction. The reviewed tools/revert_patch.bash SHA256 is 3c0c24bbedd3e65c7f4225ae0303e8def66a8859514c0aa1096bccb2c1a6e04e. No commit, push, landing, or release qualification is established by this completion record.

Landing observed separately by 2026-10-07T21:52:17Z: the selected Base work and corrected helper are committed at ed5f810fa5ac32d47108bc8b7468d0cf907f42d8, which carries all thirteen authored paths. The local HEAD and origin's advertised refs/heads/release-1.5.0 both resolved to that exact commit through git rev-parse and git ls-remote. This establishes publication of the implementation on the release branch, not release qualification or publication of EPICS-env 1.5.0.

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

Selected Base carry work is committed and landed on release-1.5.0 at ed5f810fa5ac32d47108bc8b7468d0cf907f42d8, observed by 2026-10-07T21:52:17Z, with assessment, implementation, focused verification, and second code review recorded under T4-T8. T9 records the pvxs final-source and post-release prerequisite assessment; D16 selects 1.5.3, removal of all twelve included carry files, and no a9 -> d23 chain. D17 selects pyDevSup 2.1.0; D18 keeps recsync unchanged for 1.5.0; D19 selects caPutLog R4.2; D20 selects calc R3-8; D21 selects sscan ce9660c; D22 selects lua 01aa7a1 with dedicated compatibility verification; D23 selects std 27b6967; D24 selects busy a4a272d with typed device-support and example-build verification; D25 selects scaler baa8e1c with cfg, example IOC, and consumer verification. D26 keeps measComp c38974e and its two existing carries unchanged for 1.5.0. D27 selects motor 4b22ac9 with its upstream version correction, coherent motorMotorSim/pmac rebuild, and real IOC verification. D28 keeps pcas e075fd4 unchanged for 1.5.0. All thirteen candidate decisions are resolved, with ten IN and three HOLD. T3 completes the source comparison and selected verification-scope deliverable; these records are landed at 503f6cae62ac77111078a9e9c5faa974740165b6. M1 is Complete on 2026-10-08: the scoped deliverables and recorded required checks have landing evidence, and issue #96's reconciled body and completed closure were observed. No pin change, candidate-update implementation, or release qualification is established by these assessment, selection, and landing records.

Landing readback observed by 2026-10-08T09:03:56Z: local HEAD, origin/release-1.5.0, and the actual remote branch returned by git ls-remote resolve to 503f6cae62ac77111078a9e9c5faa974740165b6. Its three changed files are docs/milestone-1.5.0.md, docs/CLOSED_DOORS.md, and docs/milestone-1.6.0.md, with 510 insertions and 43 deletions. The committed document bytes match the prepared files. This publishes the assessment, selections, verification scope, Keep records, and future reccaster tracking; it adds no module, patch, workflow, or runtime code beyond ed5f810. The T3 comparison totals remain the recorded ed5f810 observation, not new totals for 503f6ca.

Issue #96 was observed closed with `state_reason` completed through `gh api repos/jeonghanlee/EPICS-env/issues/96` by 2026-10-08T15:10:34Z; its `closed_at` and `updated_at` are 2026-10-08T15:10:14Z. The actual body matches the prepared expanded assessment, all seven acceptance criteria are checked with results, and no unchecked criterion remains. The [completion comment](https://github.com/jeonghanlee/EPICS-env/issues/96#issuecomment-6062896546), created at 2026-10-08T15:09:38Z, also matches the prepared outcome. Title, enhancement label, jeonghanlee assignee, and milestone 1.5.0 remain correct. No deferred-close exception is needed. At the issue-close observation above, M2-M3 were Not started / Ready Yes because M1 was Complete, and their plans remained draft with no acceptance or implementation authority. D29 assigns the additional eight plans to M13-M20; D30 subsequently accepts M2-M3 and M13-M20 on 2026-10-08. Implementation authority remains separate. Candidate-update builds belong to the separately accepted implementation and final release checks, not the completed M1 scope.

##### GitHub Projection

Title: Survey module changes for EPICS-env 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: closed; `state_reason` completed; `closed_at` 2026-10-08T15:10:14Z
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T15:10:14Z
Last Compared: by 2026-10-08T15:10:34Z through `gh api repos/jeonghanlee/EPICS-env/issues/96`; title, closed/completed state, enhancement label, jeonghanlee assignee, and milestone 1.5.0 match. The body matches the prepared expanded source assessment, selected Base results, and closure evidence, with all seven acceptance criteria checked. The completion comment read through `gh api repos/jeonghanlee/EPICS-env/issues/comments/6062896546` matches its prepared file.
Prepared Body: original creation draft `work/issue-150-survey.md`; replacement `work/issue-150-survey-body.md`; close comment `work/issue-150-survey-close.md`.
Publication: Original issue created after canonical planning commit af91a9290129a6964168b363eb1944639dc0fc77. Expanded body, completion comment, and completed closure applied under separate Issue authority on 2026-10-08 and read back successfully. Issue closure confirms the linked external state; completion also depends on the recorded deliverables, checks, and landing evidence above.


#### M2 - pyDevSup Update

Origin: 1.5.0 / M2
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32. Previous standalone issue: #97, https://github.com/jeonghanlee/EPICS-env/issues/97; observed closed as not_planned at 2026-10-08T18:37:58Z after scope transfer, not implementation completion.
Status: Not started

##### Summary

Move the pyDevSup pin from 4527ed055a472d4688846a2cb64ac593fec1ecbb to D17's selected release 2.1.0 at b5cef38a6d9f74f9c59f967185ba6d1940637c03. The source assessment confirms every existing code change remains; installation and runtime verification are pending.

##### Scope

Update `SRC_TAG_PYDEVSUP` and `SRC_VER_PYDEVSUP` in `configure/RELEASE`, affected current documentation, and only configuration changes justified by the source assessment. Rebuild actual consumers found by M1.

Out of scope: assuming that a version-only edit proves runtime compatibility; unrelated Python or module upgrades.

##### Completion Criteria

- The checkout and installed identity match the approved upstream object, not a stale source directory.
- Existing required fixes are present or explicitly carried under the repository procedure.
- The module, its census consumers, and representative Python device-support IOC pass real build, link, startup, and record-processing checks on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.

##### Dependencies And Decisions

M1 is Complete and D17 selects exact pyDevSup 2.1.0. There is no build-order dependency on pvxs or caPutLog in the current enabled recipe. Optional caPutLog linkage is not enabled by this plan. D30 accepts this detailed plan; implementation authority remains separate, and an unexpected dependency upgrade returns for a scope decision. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan.
Implementation Authorization: none
Superseded Plan Artifacts: 503f6cae62ac77111078a9e9c5faa974740165b6, docs/milestone-1.5.0.md / M2, prior unaccepted three-step draft; no observed result is superseded.

1. Recheck effective pins and both override locations, then propose `SRC_TAG_PYDEVSUP=tags/2.1.0` / `SRC_VER_PYDEVSUP=2.1.0`, resolving b5cef38a6d9f74f9c59f967185ba6d1940637c03. M1 established that the executable source and requirements are unchanged; installation is still a real new-version check.
2. After plan acceptance and implementation authority, use an approved new isolated candidate/source/install path and follow module-bump Stage 6 and book steps 7-15. Preserve original checkouts and evidence; confirm the acquired HEAD rather than accepting an existing directory.
3. Run actual conf.pyDevSup, check.module-deps MODULE=pyDevSup, build.pyDevSup, symlink.pyDevSup, check.deps, and check.env. Inspect the produced Python-versioned softIocPy executable, installed Python/library paths, NumPy and devsup imports, and generated identity.
4. Start that actual installed executable with the selected source's original testApp/cntrec.db and testApp/cntmod.py, following documentation/gettingstarted.rst with the real interpreter/library paths. Monitor test:count and observe successive processing increments through real Python Device support; keep the original fixture bytes. Do not use legacy test.cmd's Python-2 print statement as the Python-3 startup recipe.
5. Recheck and execute any configured census consumer; optional feedApp/logging is tested only after explicit configuration/census. Record source/artifact/runtime evidence on the D37 incremental platforms, then schedule affected M5 re-runs after later pins or metadata changes. Git/GitHub actions remain separately authorized.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Compare effective 2.1.0 pins, full source HEAD, produced executable/library/Python paths, installed directory, and unchanged required fixes | Isolated candidate source and installation | Exact b5cef38 source and actual 2.1.0 installation; no stale source directory |
| T2 | Build | Real conf.pyDevSup, strict dependency audit, build/install/symlink, configured consumer relink, check.deps and check.env | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Actual Python/NumPy dependencies, artifacts, metadata and installed-tree checks pass |
| T3 | Runtime | Actual produced softIocPy executable with original testApp/cntrec.db and cntmod.py; real CA monitor of test:count and devsup/NumPy imports | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Real Python Device processing increments the counter through the installed implementation |
| T4 | Consumers | Recheck paired census and actual configured optional paths; run every enabled consumer and preserve source identities | Applicable Layer 1/2 six-OS and internal Layer 3 targets; Layer 3 incrementally on Debian 13 and Rocky Linux 8, the six-OS runs and Debian 12 Layer 3 in the final tree under Release Verification 3 | Every enabled consumer passes; disabled examples are identified and never counted as executed |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; six Linux OS targets at the M5 final-tree run | Pending | none |
| T3 | Not run | D37 incremental platforms; six Linux OS targets at the M5 final-tree run | Pending | none |
| T4 | Not run | Applicable consumer targets | Pending | none |

##### Closure Evidence

None. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.
Previous Issue Closure: #97 title and metadata were preserved; its body matches `work/issue-97-body.md` and its closed/not_planned state was observed by 2026-10-08T18:38:33Z through `gh api repos/jeonghanlee/EPICS-env/issues/97`. The original five pyDevSup acceptance requirements continue in #98.


#### M3 - pvxs Update And Patch Reconciliation

Origin: 1.5.0 / M3
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Update pvxs from 1.5.2 to D16's selected published 1.5.3 at 25ca43df4db909c0b1a445fb705fc81582617625 and remove all twelve carry files whose fixes remain in that release. Add no a9 -> d23 post-release carry.

##### Scope

Use M1 / T9's final-source assessment and D16's selected dispositions for `patch/1.5.2-*.p0.patch`. Update the pvxs tag/version pins to 1.5.3, remove those twelve files, and update `patch/README.md`, affected loader test expectations and the active documents that name pvxs 1.5.2 or its carry set together: `docs/src/reference/module-pins.md`, `docs/src/concepts/upstream-patch-carry.md`, `docs/src/procedures/carry-upstream-fix.md`, `docs/procedures/upstream-fix-carry-procedure.md`, and the pvxs comment in `configure/RULES_FUNC`. The worked example of `carry-upstream-fix.md` regenerates `1.5.2-12-cc7bc72-synccancel-diag.p0.patch`; it needs an example that still exists after the removal. Preserve historical evidence in `docs/archive/pvxs-carry-1.3.0.md` and Git. Apply the Bump obligation in `docs/procedures/upstream-fix-carry-procedure.md`; the selected new carry set is empty.

Out of scope: blindly renaming patches to a new version prefix, assuming a clean apply proves necessity, or changing Base patches as part of this bump.

##### Completion Criteria

- All twelve carries have source-backed dispositions: included upstream, still required, or superseded with a stated reason and owner decision.
- No required fix disappears merely because the version-prefixed patch glob no longer matches.
- The actual patch and reverse-patch path works for the selected carry set, and active README rows, test expectations and the documents named in Scope match it.
- pvxs and census consumers build and start on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms are covered by the M5 final-tree run, a recorded obligation and not a condition of this closure; real CA/PVA and loader checks exercise the selected installed libraries.

##### Dependencies And Decisions

M1 is Complete and D16 selects exact pvxs 1.5.3 with all twelve existing carries removed and no new carry. There is no dependency on the pyDevSup update. ADCore's actual pvxs plugin/converter and detector consumers, the installed loader, and all twelve retained runtime protections remain required checks. D30 accepts this detailed plan; implementation authority remains separate. Changing softIocPVX, native identity, or consumer metadata invalidates earlier final-candidate loader/runtime results. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan. Scope amended 2026-10-10 at the owner's direction to add the documents that name pvxs 1.5.2; plan content is otherwise unchanged.
Implementation Authorization: none
Superseded Plan Artifacts: 503f6cae62ac77111078a9e9c5faa974740165b6, docs/milestone-1.5.0.md / M3, prior unaccepted three-check draft; no observed result is superseded.

1. Reconfirm D16's 25ca43df4db909c0b1a445fb705fc81582617625 and every M1 / T9 final-source fix/disposition. Proposed pins are `SRC_TAG_PVXS=tags/1.5.3` / `SRC_VER_PVXS=1.5.3`; remove the twelve `patch/1.5.2-*.p0.patch` files and add no a9 -> d23 carry.
2. After acceptance and implementation authority, change pins, active patch README rows, pin-dependent loader expectations and the documents named in Scope together. In particular, `verify_failure_diagnostics.bash` and `verify_elf_inspection.bash` currently name pvxs-1.5.2 and native 1.5.2; preserve their real failure/ELF assertions when updating to the selected installation. Keep the intentional inactive pvxs-1.3.1 rule/file and archive history.
3. Use an approved new isolated candidate source/install workspace. Run actual empty-set `patch.pvxs.commit.apply` / `patch.pvxs.commit.revert` and the full retained aggregate patch round trip, comparing complete source names/bytes and backup/reject residues. Rebuild through conf.pvxs, strict dependency audit, build.pvxs, symlink.pvxs, check.deps and check.env; verify actual libpvxs/libpvxsIoc/softIocPVX identity and metadata.
4. Execute the selected upstream TESTS with original TESTFILES through the actual produced programs, including testconfig, testinfo, testget, testmon, testput, testpvalink, testqsingle, and testqgroup where selected Base enables them. testdiscover is built but excluded from upstream default TESTS; explicitly include its real invocation when checking discovery cancellation.
5. Map all twelve M1 / T9 runtime obligations to observed upstream cases or real additional client/server/IOC runs: connection timestamps, six-tool redirected output/flush/destruction, pvalink update ordering, denied-CREATE retry timing, throwing onCreate continuation, early operation destruction, monitor/get/discovery/introspection callback cancellation, and synchronous-cancellation diagnostics. Execute actual JSON put, options-before-positionals, subscriptions/cancellation/shutdown, and changed IOC processing/precision/port behavior. A source/ancestry match or nominal read does not close these checks.
6. Rebuild/relink configured ADCore NDPluginPvxs/ntndArrayConverterPvxs and ADSimDetector/ADGenICam/ADVimba through their owners' accepted sources/configuration, then exercise their real data and IOC paths. Do not modify sibling pins or discard their existing local changes here.
7. Execute the complete ordered examples/iocsh/tests/run_all.bash against installed candidate libraries on Debian 13 and Rocky Linux 8.10, with actual application fixtures and required real servers. Map later module/example changes to M5 re-runs; required missing environments, devices, or fixture behavior remain Pending.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Carry | Reconfirm the twelve final-source dispositions; run actual empty pvxs Make apply/revert and complete retained aggregate round trip with full inventory comparison | Isolated exact pinned source trees and actual repository rules | Twelve fixes remain in 1.5.3, no new pvxs carry applies, other carries restore without .orig/.rej |
| T2 | Build | Real configure/audit/build/install/symlink, original upstream TESTS/TESTFILES, configured ADCore/detector coherent relink/startup, check.deps/check.env | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04; Layer 3 only on its internal targets, incrementally on Debian 13 and Rocky Linux 8 and on Debian 12 in the final tree under Release Verification 3 | Selected sources, libraries, consumers, cfg and installed checks pass without source/configuration identity substitutions |
| T3 | Runtime | Actual CLI/server/IOC operations and explicit twelve-fix case mapping, including non-default discovery tests, callbacks, pvalink, JSON/option parsing, and actual data paths | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Every retired-fix protection and selected behavior has an actual recorded result; an unexercised case stays Pending |
| T4 | Loader | Entire ordered examples/iocsh/tests/run_all.bash with updated native-version expectations and actual installed libraries/application fixtures/required servers | Debian 13 and Rocky Linux 8.10 | Full loader, metadata, ELF, relocation, lifecycle, examples and failure diagnostics pass; no internal mock path |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated exact sources | Pending | none |
| T2 | Not run | D37 incremental platforms and applicable consumer targets; six Linux OS targets at the M5 final-tree run | Pending | none |
| T3 | Not run | D37 incremental platforms; six Linux OS targets at the M5 final-tree run | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

None. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M13 - caPutLog Update

Origin: 1.5.0 / M13
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Implement D19's selected caPutLog update from dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 to 6f9eb3f6c75e49201d114f8e194d53cef493a522, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T2, M1 / T3 and Consumer Assessment.

##### Scope

Update `SRC_TAG_CAPUTLOG` and `SRC_VER_CAPUTLOG` in `configure/RELEASE` to proposed values `tags/R4.2` / `4.2.0`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Only documentation differs from the old source. No Python logging linkage is enabled by this plan.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, D19, D29. The configured caPutLog_DEPS is null.base; pyDevSup logging linkage remains optional and disabled. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D19's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source 6f9eb3f6c75e49201d114f8e194d53cef493a522; planned install version 4.2.0; no stale source or consumer build record |
| T2 | Build | Run shipped conf.caPutLog, check.module-deps MODULE=caPutLog, build.caPutLog, symlink.caPutLog, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Execute the selected source's test/caPutJsonLogTest.cpp with test/caPutJsonLogTest.db and test/asg.cfg; run real CA and PVA puts through caPutLog and iocLogServer. Exercise commonIocsh/iocsh/caPutLog.iocsh, examples/commonIocsh/tests/verify_caputlog.sh, and the real tc32sim logging fixture. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | The upstream JSON test passes and real changed values and required access/client context reach the actual logger; IOC startup and the installed loader resolve the selected module. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: Installed-loader metadata, commonIocsh, tc32sim, and the configured site logging fragment; optional pyDevSup logging and Base pva2pva only if explicitly enabled. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M14 - calc Update

Origin: 1.5.0 / M14
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Implement D20's selected calc update from 4217e83a9b9067017f4dc74da6b70e3669972f16 to 712a40453e8693fda3b90a6e9da5fdb1c708ee38, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T2, M1 / T3 and D20's exact five-file comparison.

##### Scope

Update `SRC_TAG_CALC` and `SRC_VER_CALC` in `configure/RELEASE` to proposed values `tags/R3-8` / `3.8.0`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. M15 precedes this build because calc_DEPS names build.sscan. Leave the sixteen post-R3-8 database changes out. After this installation, rebuild unchanged asyn R4-46 before its downstream modules.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, M15, D20, D29. calc_DEPS requires build.sscan, so M15 precedes this implementation. The installed calc/sscan changes require an unchanged asyn R4-46 rebuild before downstream work. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D20's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source 712a40453e8693fda3b90a6e9da5fdb1c708ee38; planned install version 3.8.0; no stale source or consumer build record |
| T2 | Build | Run shipped conf.calc, check.module-deps MODULE=calc, build.calc, symlink.calc, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Execute the unchanged selected tests/acalcTest.cpp and tests/scalcTest.cpp through their built acalcTest/scalcTest programs and original fixtures; exercise real aCalcout/sCalcout record processing for the selected modulo, stack, bounds, derivative-window, and argument-traversal fixes. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Original upstream checks pass and actual array/string calculation records produce the expected values without the selected defects. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: Reconfigure/relink asyn, StreamDevice, mca, measComp, and pmac; load configured std/sscan/QPC runtime templates. The selected scaler example and ADCore CALC path are conditional consumers. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |
| T5 | Compiler | Compare actual selected-module and consumer builds with and without the existing -std=gnu17 append; keep its current value until results and an explicit retain/remove decision | Affected Ubuntu 26.04 compiler configuration | Observed compiler behavior determines the proposed C17 disposition; a source/header review or different compiler cannot justify removal |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |
| T5 | Not run | Affected Ubuntu 26.04 compiler configuration | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M15 - sscan Update

Origin: 1.5.0 / M15
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: In progress

##### Summary

Implement D21's selected sscan update from e13699e3062145d516cfdd555aae25bb49a8c53b to ce9660cfc05071834391225beadf7f93b776d216, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T2, M1 / T3 and D21's exact two-file comparison.

##### Scope

Update `SRC_TAG_SSCAN` and `SRC_VER_SSCAN` in `configure/RELEASE` to proposed values `ce9660c` / `ce9660c`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Build the unchanged sequencer prerequisite first. No new sscan carry is selected. D35 removes only the sscan C17 append after T5's actual build comparison; the nine other module settings remain. Rebuild current-pin consumers now; later selected calc/asyn consumers invalidate those results and require M5 re-runs.

Out of scope: actual mca/measComp equipment acceptance under D36, other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer software build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every required software check below has an actual observed result with real code and original fixtures; missing required software/platform/layer checks remain Pending and do not close the work, except the Ubuntu 24.04, Rocky Linux 10 and Ubuntu 26.04 software cases that D37 transfers to M5 Release Verification 3, and the Debian 12 Layer 3 checks of T4, which move to the final-tree internal Layers 1-3 of that label. Actual mca/measComp equipment acceptance is excluded by D36 and is not reported as verified.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree. Under D37 the remaining original software checks on Ubuntu 24.04, Rocky Linux 10 and Ubuntu 26.04 run in that final-tree execution, not as separate per-module guest sessions; they are recorded obligations of M5 Release Verification 3 and not a condition of M15 closure. Shared issue #98 closure follows D38.

##### Dependencies And Decisions

M1, D21, D29, D33, D34, D35, D36. sscan_DEPS requires the unchanged sequencer. Its incremental consumer checks can use currently implemented pins; selected later calc/asyn changes require final re-runs. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. D33 authorizes the current implementation and verification plan; D34 accepts and authorizes its sequential VM resource extension. D35 accepts and authorizes the compiler disposition already required by T5: remove only the sscan append and verify actual configuration generation. D36 accepts the revised software-only completion boundary and authorizes continuation; actual mca/measComp equipment acceptance is excluded. Publication authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D36 (2026-10-09) accepts the narrowed equipment exclusion while preserving the remaining software/platform/layer obligations. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan.
Implementation Authorization: 2026-10-08; D33 authorizes this accepted sscan plan and its isolated source/install verification workspace; D34 accepts and authorizes the sequential VM resource extension. D35 (2026-10-09) accepts and authorizes sscan's C17 removal and its bounded configuration/documentation verification. D36 (2026-10-09) authorizes continuation of the remaining software verification within the revised completion boundary. Commit, push, GitHub publication, and release actions remain separately authorized.
Superseded Plan Artifacts: D36 supersedes only the prior M15 equipment-acceptance requirement; earlier dated observations retain their original scope. D37 supersedes only D34's guest order for the Ubuntu 24.04, Rocky Linux 10 and Ubuntu 26.04 software cases, which move to the final-tree run.

1. Recheck D21's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source ce9660cfc05071834391225beadf7f93b776d216; planned install version ce9660c; no stale source or consumer build record |
| T2 | Build | Run shipped conf.sscan, check.module-deps MODULE=sscan, build.sscan, symlink.sscan, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Start the installed sscan support and load the original sscanApp/Db scan and saveData databases. Run scans with non-integral point calculations and short non-vxWorks delays; inspect actual completed point counts, saved MDA/XDR files, and readback through the shipped tools. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Counts follow the selected rounding fix, short-delay operation completes on Base 7.0.10, and real saveData/XDR output is valid; no mock scan engine or reconstructed file is counted. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: calc, asyn testEpicsSupport/testEpics, original mca software support/database, actual measComp support registration, std trend database, and configured transitive dependents; StreamDevice/ADCore SSCAN paths only when enabled. Recheck enabled conditionals through paired source traversals before execution. Under D36, exercise real software paths without requiring a physical mca/measComp device; do not count a software channel as equipment acceptance | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer software startup/data paths pass for the recorded snapshot; unavailable required software checks remain Pending; actual mca/measComp equipment acceptance is excluded by D36; later selected changes map to M5 |
| T5 | Compiler | Compare actual selected-module and consumer builds with and without the existing -std=gnu17 append; keep its current value until results and an explicit retain/remove decision | Affected Ubuntu 26.04 compiler configuration | Observed compiler behavior determines the proposed C17 disposition; a source/header review or different compiler cannot justify removal |

##### Software Verification Scope

D36's Decision Date is 2026-10-09. No mca/measComp verification devices are available. Actual equipment acceptance is outside this M15 completion boundary; no equipment result is inferred from a soft channel, registration, build or prior core scan. Remaining software startup/data paths, configured consumers, incremental platform coverage and landing evidence remain required for M15 closure; the final combined-tree checks, including the transferred platform runs, are recorded obligations of M5 Release Verification 3 and not conditions of that closure. Earlier dated results retain the scope recorded when they were observed. D37's Decision Date is 2026-10-09. Rocky 8 remains the one further incremental guest for the original mca/measComp software cases; Ubuntu 24.04, Rocky Linux 10 and Ubuntu 26.04 run them once on the final combined tree under M5, so those three remain Pending as M5 obligations until that run and do not hold M15 closure. The original mca/measComp software cases belong to T4's Layers 1-2; its Layer 3 runs incrementally on Debian 13 and Rocky Linux 8, with Debian 12 in the final-tree internal Layers 1-3 of Release Verification 3. The Debian 13 and Debian 12 results below were observed before D37 as incremental snapshots and are not final qualification.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Initial identity 2026-10-08T19:35:08Z; consumer identity and lifecycle recheck 2026-10-08T20:35:09Z | Isolated Debian 13.7 source and installed subset over environment 3d0bda4d4c46ce64b1e7cbd9f28e99d0a5b9ecc9 with the uncommitted sscan pin update | Pass for native snapshot: effective pin, full source HEAD, installed directory/library/DBD/cfg, real loader selection, and original DB/request bytes agree; only the two sscan assignments differ among 66 tag/version assignments | Native Verification Snapshot and Native Consumer Verification below; `identity-audit.json` and `consumer-identity-audit.json` under `work/sscan-bump-20261008` |
| T2 | Native Base/seq/sscan build by 2026-10-08T19:06:39Z; additional consumer and vendor gates by 2026-10-08T20:28:02Z | Debian 13.7 x86_64, GCC 14.2.0, GNU Make 4.4.1; isolated core and current-pin consumer subset | Partial: native configure/audit/build/install/symlink and installed gates pass; final subset checks 64 executables and 42 shared libraries with zero defects. Subsequent Debian 12 and Rocky 8 observations are recorded separately below; Ubuntu 24/26 and Rocky 10 remain Pending | `native-result.json`, `runtime-prepare.json`, `loader-prepare.json`, seven consumer build records and raw logs described below |
| T3 | Point/delay case 2026-10-08T19:25:47Z; MDA case 2026-10-08T19:33:22Z | Debian 13.7 loopback; installed loader, original standardScans.db/saveData.db/saveData.req, original mdautils 1.4.2 C tools | Partial: actual NPTS/CPT=4, all three 0.001-second delay values retained, scan idle after completion, and real MDA decode pass. Subsequent Debian 12 and Rocky 8 observations are recorded separately below; Ubuntu 24/26 and Rocky 10 remain Pending. Missing scaler/MCA channels are outside this core fixture's observed coverage | `runtime-point-delay-host/result.json` and `runtime-mda-host/result.json`; first 120-second startup timeout retained in `runtime-mda/result.json`; raw IOC/client logs and actual 364-byte file retained |
| T4 | Census 2026-10-08T19:00:47Z; wider search 2026-10-08T19:28:38Z; asyn runtime by 2026-10-08T20:07:24Z; std runtime by 2026-10-08T20:20:01Z; additional native builds by 2026-10-08T20:28:02Z | 39 actual source roots across Layers 1-3; Debian 13 current-pin calc/asyn/std/autosave/busy/scaler/mca/measComp rebuilt against selected sscan | Partial: paired census, native consumer builds/metadata, original asyn testEpics echo/integer paths, and original std trend scan pass for their recorded fixtures. Required mca/measComp device startup, other configured transitive/layer consumers, and full OS coverage Pending | Native Consumer Verification below, seven real build records, original IOC/client logs and `consumer-identity-audit.json`; conditional ADCore/StreamDevice links and removed QPC application link remain classified in the earlier snapshot |
| T1 | 2026-10-08T23:45:33Z | Fresh Debian 12 x86_64 guest; the same frozen environment basis and selected sscan pin | Pass for this incremental snapshot: thirteen source HEADs, eleven installed metadata files, actual sscan library, original fixtures, and loader selection agree; only the two sscan pin assignments change | Debian 12 Verification Snapshot below; `debian12-guest/evidence/guest-identity-audit.json` under the same work directory |
| T2 | Core build by 2026-10-08T23:27:55Z; current-pin consumers and final gates by 2026-10-08T23:44:00Z | Debian 12 x86_64, GCC 12.2.0, GNU Make 4.3; fresh source/install subset | Partial: actual core and seven additional consumer configure/audit/build/install/symlink paths pass; final subset checks 64 executables and 42 shared libraries with zero defects; installed environment findings=0. Subsequent Rocky 8 observations are recorded separately below; Ubuntu 24/26 and Rocky 10 remain Pending | `core-recheck-build-result.json`, `consumers-build-result.json`, `loader-install-result.json`, and original stage logs in `debian12-guest/evidence` |
| T3 | Point/delay case 2026-10-08T23:29:40Z; MDA case 2026-10-08T23:38:03Z | Debian 12 loopback; shipped installed loader, original scan/saveData fixtures, and original mdautils 1.4.2 C tools | Partial: NPTS/CPT=4, DDLY/PDLY/RDLY=0.001, idle completion, actual saveData file and original decoder pass; missing equipment channels are unverified; subsequent Rocky 8 observations are recorded separately below and three other OS targets remain Pending | `runtime-point-delay-debian12/result.json`, `runtime-mda-debian12/result.json`, original IOC/client output, and the actual 364-byte MDA file in `debian12-guest/evidence` |
| T4 | Builds by 2026-10-08T23:44:00Z; asyn/std runtime by 2026-10-08T23:44:53Z; identity/lifecycle audit by 2026-10-08T23:45:33Z | Debian 12 current-pin calc/asyn/std/autosave/busy/scaler/mca/measComp built against selected sscan | Partial: coherent consumer builds, metadata, original asyn testEpics echo/integer paths, and original std trend scan pass. Required mca/measComp device startup, other configured transitive/layer consumers, and remaining OS coverage stay Pending | `consumers-build-result.json`, `consumer-runtime-result.json`, five consumer runtime records, actual process maps, and `guest-identity-audit.json` in `debian12-guest/evidence` |
| T1 | 2026-10-09T01:05:27Z | Fresh Rocky Linux 8.10 x86_64 guest; frozen environment basis and selected sscan update | Pass for this snapshot: effective pins, thirteen source HEADs, eleven metadata digests, actual library, byte-identical loaders and original fixtures agree | Rocky 8 Verification Snapshot; `rocky8-guest/evidence/guest-identity-audit.json` |
| T2 | Core by 2026-10-09T00:49:52Z; consumers/final gates by 2026-10-09T01:03:46Z | Rocky Linux 8.10, GCC 8.5.0, GNU Make 4.2.1; isolated current-pin subset | Partial: 32 core and 55 consumer/vendor stages exit 0; 64 executables and 42 shared libraries with zero defects; environment findings=0. Three other OS targets/full configured coverage stay Pending | `core-build-result.json`, `consumers-build-result.json` and original logs in `rocky8-guest/evidence` |
| T3 | Point/delay by 2026-10-09T00:50:29Z; MDA by 2026-10-09T00:58:23Z | Rocky Linux 8.10 loopback; installed shipped loader, original scan/saveData fixtures and mdautils C decoder | Partial: four-point calculation/completion, 0.001-second delays, actual MDA/XDR output and original decoder pass; unavailable equipment and remaining OS checks stay Pending | `runtime-point-delay-rocky8/result.json`, `runtime-mda-rocky8/result.json` and actual data/client/IOC evidence |
| T4 | Builds by 2026-10-09T01:03:46Z; runtime by 2026-10-09T01:04:46Z; audit by 2026-10-09T01:05:27Z | Rocky Linux 8.10; current-pin configured consumers against selected sscan | Partial: coherent builds/metadata, original asyn echo/integer and std trend paths, independent setup failures and real cleanup pass. Required equipment and other transitive/layer/OS paths stay Pending | `consumers-runtime-result.json`, five consumer records, actual maps and identity audit in `rocky8-guest/evidence` |
| T1 | 2026-10-09T02:44:08Z | Fresh Ubuntu 24.04.4 x86_64 guest; frozen candidate and selected sscan update | Pass for this snapshot: both effective pins, thirteen source HEADs, eleven metadata digests, actual library, shipped loaders and original fixtures agree | Ubuntu 24 Verification Snapshot; `ubuntu24-guest/evidence/guest-identity-audit.json` |
| T2 | Core by 2026-10-09T02:27:48Z; consumers/final gates by 2026-10-09T02:43:04Z | Ubuntu 24.04.4, GCC 13.3.0, GNU Make 4.3; isolated current-pin subset | Partial: 32 core and 55 consumer/vendor stages exit 0; 64 executables and 42 shared libraries with zero defects; environment findings=0. Two other OS targets and full configured coverage remain Pending | `core-build-result.json`, `consumers-build-result.json` and original logs in `ubuntu24-guest/evidence` |
| T3 | Point/delay by 2026-10-09T02:28:42Z; MDA by 2026-10-09T02:36:35Z | Ubuntu 24 loopback; installed loader, original scan/saveData fixtures and mdautils C decoder | Partial: four points, 0.001-second delays, actual 364-byte MDA/XDR output and original decoder pass; missing equipment and remaining OS checks stay Pending | `runtime-point-delay-ubuntu24/result.json`, `runtime-mda-ubuntu24/result.json` and actual IOC/client/data evidence |
| T4 | Builds by 2026-10-09T02:43:04Z; runtime by 2026-10-09T02:43:33Z; audit by 2026-10-09T02:44:08Z | Ubuntu 24; current-pin configured consumers against selected sscan | Partial: coherent builds/metadata, original asyn echo/integer and std trend paths, setup-failure cleanup pass. Required equipment and other transitive/layer/OS checks stay Pending | `consumers-runtime-result.json`, five consumer records, actual process maps and identity audit in `ubuntu24-guest/evidence` |
| T1 | 2026-10-09T04:36:42Z | Fresh Rocky Linux 10.2 x86_64 guest; same frozen candidate and selected sscan update | Pass for this snapshot: both effective pins, thirteen source HEADs, eleven installed metadata digests, library, loaders and original fixtures agree | Rocky 10 Verification Snapshot; rocky10-guest/evidence/guest-identity-audit.json |
| T2 | Core by 2026-10-09T04:20:50Z; consumers/final gates by 2026-10-09T04:35:57Z | Rocky Linux 10.2, GCC 14.3.1, GNU Make 4.4.1; current-pin isolated subset | Partial: all 32 core and 55 consumer/vendor stages exit 0; 64 executables/42 shared libraries have zero defects; environment findings=0. Ubuntu 26 and full configured coverage remain Pending | core-build-result.json, consumers-build-result.json and actual logs in rocky10-guest/evidence |
| T3 | Point/delay by 2026-10-09T04:21:39Z; MDA by 2026-10-09T04:29:34Z | Rocky Linux 10.2 loopback; installed loader, original scan/saveData fixtures and original mdautils decoder | Partial: four points, three 0.001-second delays, actual 364-byte MDA output with four decoded detector values and observed cleanup pass. Required equipment and Ubuntu 26 remain Pending | core-runtime-result.json and actual runtime-point-delay-rocky10/runtime-mda-rocky10 result, client, IOC and data files; Rocky 10 Verification Snapshot below |
| T4 | Builds by 2026-10-09T04:35:57Z; runtime by 2026-10-09T04:36:21Z; audit by 2026-10-09T04:36:42Z | Rocky Linux 10.2; current-pin consumers built against selected sscan | Partial: coherent consumer builds/metadata, original asyn integer/echo and std trend data paths, setup-failure cleanup and sixteen absent PIDs pass. Required equipment and other transitive/layer/OS paths remain Pending | consumers-runtime-result.json, five actual consumer case records, library maps and guest-identity-audit.json in rocky10-guest/evidence |
| T1 | 2026-10-09T05:10:30Z | Fresh Ubuntu 26.04 LTS x86_64 guest; frozen candidate and selected sscan update | Pass for this snapshot: both effective pins, thirteen source HEADs, eleven metadata digests, actual selected library, original fixtures and byte-identical installed loaders agree | Ubuntu 26 Verification Snapshot; ubuntu26-guest/evidence/guest-identity-audit.json |
| T2 | Core by 2026-10-09T04:56:27Z; consumers/final gates by 2026-10-09T05:10:05Z | Ubuntu 26.04, GCC 15.2.0, GNU Make 4.4.1; isolated current-pin baseline subset | Partial: all 32 core and 55 consumer/vendor stages exit 0; installed gates inspect 64 executables and 42 shared libraries with zero defects; environment findings=0. Full configured coverage remains Pending | core-build-result.json, consumers-build-result.json and actual logs in ubuntu26-guest/evidence |
| T3 | Point/delay by 2026-10-09T04:56:53Z; MDA by 2026-10-09T05:04:45Z | Ubuntu 26 loopback; shipped installed loader, original scan/saveData fixtures and original mdautils decoder | Partial: four-point calculation and completion, three 0.001-second delays, actual 364-byte MDA/XDR output and original decoder pass. Unavailable equipment remains unqualified | core-runtime-result.json, runtime-point-delay-ubuntu26/result.json and runtime-mda-ubuntu26/result.json; original IOC/client/data evidence |
| T4 | Builds by 2026-10-09T05:10:05Z; runtime by 2026-10-09T05:10:19Z; audit by 2026-10-09T05:10:31Z | Ubuntu 26; current-pin consumers against selected sscan | Partial: coherent builds/metadata, original asyn echo/integer and std trend paths, setup-failure cleanup and sixteen absent PIDs pass. Required equipment and other configured transitive/layer paths remain Pending | consumers-runtime-result.json, five consumer records, actual maps and guest-identity-audit.json in ubuntu26-guest/evidence |
| T5 | Selected build by 2026-10-09T05:11:53Z; consumers by 2026-10-09T05:20:14Z; comparison audit/retrieval by 2026-10-09T05:20:45Z; changed configuration verified 2026-10-09T07:03:59Z | Actual Ubuntu 26.04/GCC 15.2.0 build comparison; separate Debian 13.7 configuration run with OS_NAME=ubuntu and OS_VERSION=26.04 | Pass for compiler comparison and configuration: selected sscan and current-pin consumer builds pass with and without the append; D35 selects removal. Real changed conf.sscan removes the prior flag and repeats byte-identically; sequencer retains one flag and sscan paths agree. No post-removal runtime or final-tree qualification is inferred | Ubuntu 26 C17 Build Comparison and C17 Configuration Removal below; ubuntu26-guest/c17-evidence/c17-comparison-audit.json, actual logs and retrieval result; c17-removal/configuration-result.json |

| T1 | 2026-10-09T07:47:30Z | Actual Ubuntu 26.04; retained no-C17 comparison sources/modules with unchanged shared Base and vendor | Pass for this runtime snapshot: eleven source HEADs and metadata digests, selected library, original fixtures, and retained evidence agree; changed shipped configuration matches the actual compiled inputs | Ubuntu 26 Post-C17 Runtime Verification below; post-c17-runtime/evidence/runtime-audit.json and runtime-verification.json under ubuntu26-guest |
| T3 | Point/delay by 2026-10-09T07:36:29Z; MDA by 2026-10-09T07:44:31Z; fresh initialized-map scan recheck by 2026-10-09T07:47:12Z | Ubuntu 26 loopback; actual no-C17 selected sscan, shipped loader, original databases/request and original decoder | Partial: four points, three 0.001-second delays, real MDA/XDR save and decode pass; actual process maps and cleanup verified. Equipment and final combined-tree checks remain Pending | runtime-point-delay, runtime-mda, runtime-point-delay-complete-maps, library-map-recheck.json and runtime-audit.json in post-c17-runtime/evidence |
| T4 | asyn/std data paths by 2026-10-09T07:36:33Z; setup-failure cleanup by 2026-10-09T07:36:38Z; audit 2026-10-09T07:47:30Z | Ubuntu 26; unchanged original current-pin asyn testEpics and std trend fixtures using actual no-C17 sscan | Partial: echo/integer/trend paths, coherent real library maps, fresh-process isolation and owned-resource cleanup pass. Other configured device/transitive/layer and final-tree checks remain Pending | Actual asyn-runtime and std-runtime records/maps, original fixtures and runtime-audit.json in post-c17-runtime/evidence |
| T5 | 2026-10-09T07:36:25Z | Actual Ubuntu 26.04; current changed shipped targets over a verified 250-file working-checkout snapshot and authentic selected sources | Pass for actual configuration equivalence: eight recorded commands exit 0, generated sscan/sequencer files exactly match the no-C17 build inputs and repeat identically; sscan has no explicit dialect, sequencer retains one C17 flag | post-c17-runtime/evidence/runtime-verification.json, current-manifest.json and actual configuration logs; no additional compilation or installed-environment gate is claimed |
| T4 | Functional cases by 2026-10-09T08:19:50Z; setup-failure cleanup by 2026-10-09T08:20:23Z; artifact audit 2026-10-09T08:23:29Z | Debian 13.7 loopback; retained coherent installed libraries, actual shipped loader, original mca Soft Channel/simple_mca.db and standardScans.db | Partial software scope: independent mca and measComp consumer startup, actual measComp command registration, healthy original software readback and four-point scan pass; setup-failure cleanup passes. Five other OS targets and remaining configured software/layer paths still need their checks; equipment acceptance is excluded by D36 | Native Software Consumer Verification below; software-consumers-debian13/native-software-audit.json, three real case records, initialized maps and raw client/IOC logs |
| T4 | Functional cases by 2026-10-09T09:22:39Z; setup-failure cleanup 2026-10-09T09:22:24Z; audit 2026-10-09T09:24:14Z; host retrieval 2026-10-09T09:24:51Z | Actual Debian 12 loopback; retained coherent source-built installation, shipped loader and original mca/sscan fixtures | Partial software scope: independent mca/measComp startup, real measComp registration, healthy original software readback, four-point scans and setup-failure cleanup pass. Four other OS targets and remaining configured software/layer paths stay Pending; actual equipment acceptance is excluded by D36 | Debian 12 Software Consumer Verification below; debian12-guest/software-consumers/evidence/software-audit.json, original case logs/maps, evidence-retrieval-result.json and lifecycle-result.json |

##### Native Verification Snapshot

Observed by 2026-10-08T19:35:08Z. The checkout carries only the selected sscan pin change and its active documentation update. Verification uses fresh sources in `work/sscan-bump-20261008/native-environment` and the isolated install tree `work/sscan-bump-20261008/native-install/1.5.0/debian-13/7.0.10`. `configure/CONFIG_SITE.local` selects that install root; the successful Make path does not pass `INSTALL_LOCATION` on the command line. The recorded subset contains Base, seq, sscan, current calc, and current pvxs; it is not a complete release tree.

| Source | Full HEAD | Installed identity |
| --- | --- | --- |
| EPICS Base | bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77 | base 7.0.10, with the selected 23 Base patches and six pinned component objects |
| sequencer | e5e361509df1c0d3c667872243d8f7a9894514b4 | seq-2.2.9 |
| sscan | ce9660cfc05071834391225beadf7f93b776d216 | sscan-ce9660c |
| calc | 4217e83a9b9067017f4dc74da6b70e3669972f16 | calc-4217e83; records dep=sscan ce9660c |
| pvxs | 8e00eaecdee5ce8a474704e70d820e6f92693fa1 | pvxs-1.5.2, with its twelve existing commit carries |

Build evidence: actual acquisition, `conf.release.modules`, `conf.sncseq`, `conf.sscan`, strict `check.module-deps MODULE=sscan`, `build.sequencer`, `build.sscan`, `install.sscan`, `symlink.sequencer`, `symlink.sscan`, `check.deps`, and `check.env` exited 0. Current calc and pvxs were acquired, configured, audited, built, installed, and linked through the shipped targets before runtime startup. The final subset gate inspected 43 executables and 22 shared libraries: zero RPATH, absolute dependency paths, or lost $ORIGIN; installed environment findings=0. Installed sscan metadata records format=1, version=ce9660c, base=7.0.10, arch=linux-x86_64, and dep=seq 2.2.9. The real installed `iocsh.bash` and `iocsh_elf.bash` bytes match the shipped tools.

Fixture evidence: the original committed `sscanApp/Db/standardScans.db`, `sscanApp/Db/saveData.db`, and `docs/saveData.req` bytes match the actual installed/runtime copies. The startup loads the two original databases through the installed loader. The MDA case uses an unchanged copy of the original request file; its relative `data` filesystem setting fits saveData's string-length limit. The decoder is built from the module's original `sscanApp/src/mdautils-src.tar.gz`, SHA256 a83045e861e0883fc0300fe58c12e0bd206e9c07421950e5859c0fe5cd8fdf17. All fourteen archived C/header/build/reference source files checked against that archive remain byte-identical; system libtirpc supplies the actual XDR library.

Behavior evidence: separate fresh IOCs run the point/delay and MDA cases through the installed `softIocPVX` loader. With P1SP=0, P1EP=0.3, and P1SI=0.1, the actual record reports NPTS=4; DDLY, PDLY, and RDLY retain 0.001 seconds. Completed scans report CPT=4, EXSC=0, BUSY=0. In the MDA case D01PV reads the original scan1.CPT field, so no equipment motion or detector qualification is inferred. Real `mda-info` and `mda-dump` exit 0 and report rank=1, requested/completed points=4, detector values 0 1 2 3, and three connected extra PVs. The file `runtime-mda-host/data/rel1500000.mda` is 364 bytes, SHA256 d80959ee9407874a8dbb3e31ab39d701b8f725a9bc6e513ae4ce8c5ef9e3ebc6. saveData reports Active, scanNumber 0 -> 1, totalRetries=0, abandonedWrites=0. Its 47 unavailable scaler/MCA request entries produce preserved connection messages; those channels and equipment remain unverified. These are selected-source observations, without a former-source failure comparison.

Consumer evidence: the first 39-root census pairs forced ripgrep and find/grep for link lines, includes, and record declarations, with all 117 pairs agreeing. A separate wider `*Makefile*`/`*.mk` pair again agrees across all 39 roots and includes ADCore's `ADApp/commonDriverMakefile` SSCAN conditional. Current calc has two real link lines after shipped configuration; asyn has two, mca seven, measComp one, and StreamDevice/ADCore one conditional each. The existing QPC data-only patch removes its application link; std has an original runtime scan record. Recover each optional consumer's effective configuration before its actual build/startup; this static observation does not complete T4. Later M14 calc, M3 pvxs, and shared asyn/configuration changes require the affected M5 re-runs.

Diagnostic failure evidence: the generated IOC build exits 2 at CHECK_RELEASE against the modules' original installed RELEASE paths (`runtime-prepare.json` and `logs/runtime-build-ioc.log`). The first MDA startup attempt reaches its 120-second limit while the original request waits for unavailable channels (`runtime-mda/result.json`); that result remains Fail. The subsequent fresh host case uses the same original request with a 900-second bound and passes. Earlier source/install setup failures and the interrupted build remain in `native-build.json` and raw logs; they are not included in the successful native subset result.

Lifecycle evidence: all required client commands in the successful host cases exit 0. Actual wait results confirm each owned IOC and repeater terminated, and loopback probes confirm their four private ports were released. An independent setup-failure case starts both real processes, injects a setup error, then observes their termination and port release (`runtime-setup-failure-host/result.json`). Evidence is preserved on both failure and success. The workspace contains 2,797,393,353 regular-file bytes at the identity audit, below D33's 8 GiB bound. The existing Ubuntu 26 C17 append remains; T5 has no compiler comparison yet.

##### Native Consumer Verification

Observed by 2026-10-08T20:35:09Z in the same isolated Debian 13.7 workspace. These are unchanged current-pin consumer builds for M15, not implementation of the later selected calc/std/busy/scaler updates. All 64 other tag/version assignments remain unchanged, and current pvxs 1.5.2 retains its twelve carries.

| Consumer | Full source HEAD | Installed version | Build evidence |
| --- | --- | --- | --- |
| asyn | 76f6164757d54b0b7dae22a911fe78fd20a95525 | 4.46.0 | `asyn-consumer-host-build.json` |
| std | 5f2e44214963b84ea3a400f7b7c3a9f510126ddd | 5f2e442 | `std-consumer-host-build.json` |
| autosave | 03b94f803be4e1844699a9c56562c96406242591 | 6.0.0 | `autosave-consumer-host-build.json` |
| busy | 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb | 2dfe92d | `busy-consumer-host-build.json` |
| scaler | beb5521af49616682e4e442c3e33a06add1bd713 | beb5521 | `scaler-consumer-host-build.json` |
| mca | 687d563206d59de9097e28e95e32ad09ebcc2522 | 687d563 | `mca-consumer-host-build.json` |
| measComp | c38974e85c59429b8ba48ed320681ba0296fb924 | c38974e | `meascomp-consumer-host-recheck-build.json` |

Every listed consumer was acquired from an absent source path, checked against its current-pin census identity, configured, audited, built, installed, and linked through the shipped Make targets. All recorded required stages exit 0. asyn, mca, and measComp metadata explicitly record dep=sscan ce9660c. Installed metadata digests agree with the actual cfg files. The final subset gates at 2026-10-08T20:28:02Z inspect 64 executables and 42 shared libraries, including the vendor library, with zero RPATH, absolute dependency paths, or lost $ORIGIN; check.env reports findings=0. This subset is not the complete Layer 1-3 release tree.

measComp retains the two original configuration/TC-32 patches through `patch.measComp.apply` and `patch.measComp.tc32.apply`. Its actual vendor is uldaq 1.2.1 at c7b94531185ff098af166da2be1f3a4a648cfa96, built through `uldaq-env` 988b1523a759855b5e98c23e3cde050ab8d1b26e and its original init/conf/build/install targets. The native-only `configure/RELEASE.local` sets VENDOR_ULDAQ_PATH to this workspace's installed vendor directory. This resolves the initially absent /usr/local provider without changing a release pin or a global installation. Native mca keeps the shipped Linux configuration with USB/libnet support disabled; its Darwin-only carry is inactive here.

asyn runtime uses the actual installed testEpics executable and the byte-identical original `iocBoot/ioctestEpics/st.cmd`, driver sources, and devInt32/devDigital/devOctet databases. Its relative db/dbd paths resolve through filesystem links to the installed artifacts; the startup and databases are not rewritten. Separate fresh echo and integer cases pass at 2026-10-08T20:06:48Z and 2026-10-08T20:07:07Z. The real echo path returns both the original test string and the supplied `rel150 sscan consumer`; the actual integer driver reports matching output/input values 123 and -17 with SEVR=0 and UDF=0. The running process maps confirm the installed testEpicsSupport, selected sscan, and current calc libraries. An independent post-initialization setup-failure case confirms owned-process and private-port cleanup by 2026-10-08T20:07:24Z. Evidence: `asyn-runtime-echo-host`, `asyn-runtime-int32-host`, and `asyn-runtime-setup-failure-host` result JSON, original IOC logs, process maps, and raw client output.

std runtime loads the byte-identical original `stdApp/Db/trend.db` through the shipped installed loader with current std/calc and selected sscan. At 2026-10-08T20:17:51Z the real trend record reports RTYP=sscan, MPTS=1000, and an initially idle scan. Its original time calculation maps trend_time1=2 to trend_realtime1=1; the original time readback remains R1PV=time. P1SP=0, P1EP=0.3, and P1SI=0.1 yield NPTS=4 and completed CPT=4, EXSC=0, BUSY=0. An independent setup-failure case confirms cleanup by 2026-10-08T20:20:01Z. Evidence: `std-runtime-trend-host-recheck` and `std-runtime-setup-failure-host`. These fixture results do not qualify the serial devices in the optional stdTestIOC demonstration.

Failed observations remain preserved: the initial sandbox asyn acquisition exits 2 on SSH configuration access (`asyn-consumer-build.json`); the first std runtime checker misclassifies the echoed `on error break` command (`std-runtime-trend-host/result.json`); and the first vendor guard misreads the two-line `uldaq-env` version query (`meascomp-consumer-host-build.json`). Corrected real-path re-executions are separate records, and none of those initial failures is reported as Pass.

`consumer-identity-audit.json` rechecks the actual seven consumer source HEADs and installed metadata digests, all five successful/expected-failure consumer runtime records, required client exit codes, owned-process termination and private-port release. The selected sscan library SHA256 remains c5d6d78f2e066760463be60928fc6ab381c5c08fb3c9c4e70539d6aa0e09bb26. Before writing that audit the workspace contains 3,117,201,327 regular-file bytes, within D33's 8 GiB bound. No VM was provisioned at this snapshot; the subsequent D34 decision authorizes the VM resource extension. mca/measComp device startup, other configured transitive consumers, Layer 2-3 checks, five remaining OS targets, and the actual Ubuntu 26 C17 comparison remain Pending. Later selected-pin/configuration changes still require M5's final re-runs.

##### Sequential VM Verification

D34 authorizes fresh guests in the order Debian 12, Rocky 8, Ubuntu 24, Rocky 10, Ubuntu 26. Provisioning belongs to its owning session. The first Debian 12 guest has a verified private handoff and the actual incremental build/runtime observations below, and is now shut off with its disk preserved. Rocky 8 was created after that shutdown, completed its recorded incremental build/runtime subset and verified host evidence retrieval, and is now shut off with its disk/definition/seed preserved. Ubuntu 24 has a verified private handoff dated 2026-10-09T02:13:08Z. Requester checks at 2026-10-09T02:18:52Z independently confirm key-only SSH, sudo, Ubuntu 24.04.4, two CPUs, configured 4 GiB memory, 20 GiB disk, cloud-init done/errors=[] and an absent verification workspace. The guest's actual date is normal; the cloud-init last_update epoch display is preserved in private baseline evidence. Actual prerequisite installation and frozen candidate transport pass. All 32 core stages complete at 2026-10-09T02:27:48Z, and the original decoder build completes at 2026-10-09T02:28:09Z with all 22 archived files unchanged. The independent setup-failure and point/delay cases pass by 2026-10-09T02:28:42Z; the tracked MDA case is running against the unchanged original request. The subsequent MDA case completes at 2026-10-09T02:36:35Z; all 55 consumer/vendor stages pass by 2026-10-09T02:43:04Z, and consumer runtime completes by 2026-10-09T02:43:33Z. Final audit and host retrieval are verified below. The provider completed the finished-notice shutdown. Requester read-only domuuid/domstate/dominfo/dumpxml checks at 2026-10-09T03:57:55Z confirm the expected UUID, shut off state, persistent definition and disk/creation-record/seed preservation; actual live/persistent network checks at 2026-10-09T03:58:16Z confirm the expected reservation pair. The NVRAM path remains in the definition; its physical file is not independently verified. Rocky 10's private READY handoff and independently checked baseline are verified with its disclosed recoverable password warning retained. Its recorded core/consumer/runtime subset and final audit pass by 2026-10-09T04:36:42Z; host evidence retrieval passes by 2026-10-09T04:37:15Z. The provider completed the finished notice, and requester read-only checks at 2026-10-09T04:39:59Z confirm the expected UUID, shut off state, persistent definition, disk/creation-record/seed and live/persistent reservations preserved. The configured NVRAM path is retained; its physical file is not independently verified. The Ubuntu 26 provider turn completed with a private READY handoff dated 2026-10-09T04:45:01Z. Independent requester checks at 2026-10-09T04:47:26Z-04:47:28Z confirm the actual Ubuntu 26.04 LTS guest, requested resources, key-only SSH/sudo, fresh workspace absence and expected UUID/reservation/lease. cloud-init status is done/errors=[] with degraded done and exit 2 from the preserved password-not-supplied warning. Actual prerequisites and frozen candidate transport pass. All 32 core stages complete at 2026-10-09T04:56:27Z; the original decoder completes at 2026-10-09T04:56:42Z with 22 original files unchanged. The point/delay case passes at 2026-10-09T04:56:53Z with NPTS/CPT=4, three 0.001-second delays and observed cleanup. The MDA case completes at 2026-10-09T05:04:45Z using the unchanged original request: a real 364-byte file decodes to rank 1, four requested/completed points and detector values 0 1 2 3; saveData advances scanNumber 0 -> 1 with no retries or abandoned writes. The independent setup-failure case observes cleanup. All 55 consumer/vendor stages pass by 2026-10-09T05:10:05Z; consumer runtime completes by 2026-10-09T05:10:19Z. The final identity/lifecycle audit passes by 2026-10-09T05:10:31Z, and all 374 evidence files pass host size/hash checks at 2026-10-09T05:10:47Z. A separate fresh selected-scan build without its C17 append exits 0 at 2026-10-09T05:11:52Z; all 50 coherent current-pin consumer comparison stages exit 0 by 2026-10-09T05:20:14Z. Comparison audit and host retrieval verify 118 evidence files at 2026-10-09T05:20:45Z. The provider completed the matching finished notice. Independent requester checks at 2026-10-09T05:22:47Z confirm the expected UUID, shut off state, persistent definition, disk/creation-record/seed and live/persistent reservations preserved. The configured NVRAM path remains; actual physical file existence is not independently verified. D35 accepts and authorizes removal of sscan's C17 append; the changed configuration target is verified below. Private baseline and source-only helper preparation records are under work/sscan-bump-20261008/ubuntu26-guest. The Ubuntu 26 baseline subset is verified below; compiler build comparison and resource closure are verified, with D35's sscan-only removal and configuration verification recorded below. Requester builds use the current uncommitted candidate files and original fixtures, not an unchanged remote branch mistaken for the selected sscan update. Preserve the failed and successful evidence and each guest disk; send a finished notice and confirm shutdown before requesting the next OS.

Candidate transport preparation is observed at 2026-10-08T22:29:22Z. `work/sscan-bump-20261008/debian12-transport/candidate.tar.gz` contains 274 frozen files: current tracked environment files, the unchanged current vendor wrapper, and original runtime drivers. Actual archive membership, file bytes, symlink targets, and modes agree with `candidate-manifest.json`; `transport-result.json` records the checks. The environment basis remains 3d0bda4d4c46ce64b1e7cbd9f28e99d0a5b9ecc9, with only the two selected sscan assignments changed among 66 source tag/version assignments. Archive SHA256 is 4e42c449ef6ba954008d636a7a1e2f74186af2f9ede91b39fe17882ef892ba05; size is 838,944 bytes. The host workspace contains 3,118,107,643 regular-file bytes after the archive, within 8 GiB. No module sources, compiled binaries, credentials, or prior runtime results substitute the fresh guest paths.

The first request was pending provider approval at 2026-10-08T22:29:44Z. Its subsequently verified private handoff is dated 2026-10-08T23:06:33Z. Direct key-only SSH, sudo, OS/resources, and cloud-init status were checked before requester installation. After evidence retrieval, the requester sent the finished notice; delivery and processing were observed through the confirmed provider app server. At 2026-10-08T23:52:57Z, the provider acknowledged the finished notice and its current turn reported `waitingOnApproval`, checked through `thread/read`.

At 2026-10-09T00:23:00Z, the provider's matching completed response and private `sscan-debian12-20261008-shutdown.log` were read. Requester read-only libvirt `domuuid`, `domstate`, `dominfo`, and `dumpxml --inactive` checks confirm the expected UUID, `shut off`, persistent definition, and preserved disk, creation-record, and seed. The provider also reports the live/persistent reservation preserved. The NVRAM path remains in the inactive definition; actual NVRAM file existence is unverified because the provider's read failed on permissions and its sudo check was denied by execution policy. No NVRAM file-preservation claim is made from the definition alone. These lifecycle observations are separate from the already preserved runtime evidence.

The next scoped request, `EPICS-M15-rocky8-20261008`, was accepted by the provider's queue after the actual Debian 12 shutdown check. It asks for one fresh Rocky Linux 8.10 `rocky8-epics-dev` guest with 2 vCPU, 4 GiB RAM, and 20 GiB disk, a new capacity check before creation, verified private access files, and disk/evidence preservation after use. The requester installs prerequisites and the frozen current candidate and runs the real checks. At 2026-10-09T00:24:48Z, `thread/read` confirms the matching request is being processed and the provider reports `waitingOnApproval`. That observation established processing only. The subsequent private handoff is dated 2026-10-09T00:32:00Z; actual key-only SSH, sudo, Rocky Linux 8.10, two CPUs, configured 4 GiB memory and 20 GiB disk, cloud-init completion without errors, and private access files were verified before requester installation. Exact access and VM identifiers remain in private records.

##### Ubuntu 26 Verification Snapshot

Final baseline audit observed at 2026-10-09T05:10:30Z and completed at 2026-10-09T05:10:31Z; host evidence retrieval verified at 2026-10-09T05:10:47Z. Actual Ubuntu 26.04 LTS, requested resources, private access and fresh workspace absence were independently checked before installation. Private baseline evidence preserves cloud-init degraded done/exit 2 from the password-not-supplied warning with empty error lists; the guest clock is correct. Prerequisites and all 274 frozen candidate byte/mode checks pass. Toolchain: GCC/G++ 15.2.0 (Ubuntu 15.2.0-16ubuntu1), GNU Make 4.4.1, GNU patch 2.8 and Python 3.14.4.

The shipped Make paths complete 32 core and 55 consumer/vendor stages, every exit 0, under 1.5.0/ubuntu-26.04/7.0.10. Base has seven verified pinned gitlinks and 23 actual patch applications; current pvxs 1.5.2 retains twelve actual carries. All thirteen source HEADs match the recorded current-pin identities. The seven additional consumers are asyn, std, autosave, busy, scaler, mca and measComp; their later selected updates are not implemented here. Actual uldaq 1.2.1 uses the unchanged wrapper's normal conf target; measComp retains both carries and a guest-local vendor path. Linux mca keeps USB/libnet disabled. Final installed gates inspect 64 executables and 42 shared libraries with zero RPATH/absolute-path/lost-$ORIGIN defects; environment findings=0.

The audit verifies both effective sscan assignments, eleven installed metadata digests and dependency versions, original database/request bytes and byte-identical installed loaders. Installed libsscan.so SHA256 is f89dbc009360ae11f8058b3de92e88f6b8b8e2257e89e3e5a602a7ed0286217d. Original mdautils builds with all 22 archived files unchanged. Fresh scan cases observe NPTS/CPT=4, DDLY/PDLY/RDLY=0.001 and EXSC/BUSY=0. The unchanged original saveData request produces a real 364-byte MDA file, SHA256 8845ca79af31ae281c4f084d4a288ac13dd50bd23788978b9bacbf103a2f9f2c. Original mda-info/mda-dump report rank 1, four requested/completed points, detector values 0 1 2 3 and three extra PVs. saveData stays Active, scanNumber advances 0 -> 1, retries=0 and abandonedWrites=0. Missing scaler/MCA equipment channels remain unqualified.

Original asyn testEpics startup, drivers and databases return both echo strings and matching integer output/input values 123 and -17 with SEVR/UDF=0. Actual maps include testEpicsSupport, selected sscan and current calc. Original std trend.db observes RTYP=sscan, MPTS=1000, time 2 -> realtime 1, R1PV=time and a completed four-point idle scan. Each case uses its real entrypoint and fresh IOC/repeater processes, in a different order from Rocky 10. Five successful cases and three independent setup failures observe process termination and private-port release; the final audit independently checks all sixteen recorded PIDs absent. All 56 client commands exit 0.

Private baseline evidence is under work/sscan-bump-20261008/ubuntu26-guest/evidence. The 340,426-byte ubuntu26-evidence.tar.gz has SHA256 ba925811dfaf9351623d48fd6b586e8c42f451366d586f5aa16e855feea448f1. All 374 manifest files pass host size/hash checks; the manifest is member 375. Actual logs, drivers, original fixtures, maps, metadata and real data are preserved. Guest workspace after archiving is 2,083,291,051 bytes; host workspace after retrieval is 3,144,977,519 bytes, both within 8 GiB. This immutable baseline archive precedes the separately recorded compiler comparison and does not establish its result.

The baseline subset, separate C17 build comparison and resource closure are verified. The confirmed provider completed the finished notice and its actual private shutdown log was read. Independent requester domuuid/domstate/dominfo/dumpxml and live/persistent network checks at 2026-10-09T05:22:47Z confirm the expected UUID, shut off state, persistent definition, disk/creation-record/seed and reservations preserved. NVRAM remains configured; physical file existence is not independently verified. Private raw outputs, provider response/log and lifecycle-result-20261009T052247.json are preserved under the guest work directory. Both host evidence archives retain their recorded SHA256 after shutdown. All five requested guests are now shut off with their recorded evidence retained. D35 accepts and authorizes removal of sscan's C17 append; the changed configuration target is verified below. Required equipment, other configured transitive/layer consumers, final combined-tree reruns, landing and shared issue closure remain Pending. M15 stays In progress.

##### Ubuntu 26 C17 Build Comparison

Selected sscan without its conditional append builds from a separately acquired source at 2026-10-09T05:11:52Z; all 50 consumer comparison stages complete with exit 0 at 2026-10-09T05:20:14Z. The baseline already records real builds with the existing append. The comparison uses the same frozen environment and exact source identities in a separate compiler-no-c17 source/output tree, with the unchanged actual baseline Base and uldaq prerequisites explicitly selected. Only conf.sscan receives MODS_C17_BRIDGE=; all other modules retain their configured compiler settings. No upstream tracked sscan source is modified.

The actual gcc default reports __STDC_VERSION__=202311L. Seven real sscan compile commands have no explicit -std option. The selected library installs successfully, followed by fresh current-pin calc, pvxs, asyn, std, autosave, busy, scaler, mca and measComp builds. All eleven comparison source HEADs and eleven installed metadata files agree with the frozen identities. Original logs contain actual links to the comparison sscan for calc, asyn, mca and measComp. The comparison libsscan.so SHA256 is 1915f3b8beeaaa085de53787a1800923cdaab096a64ea5ddec8607f801cc8276.

The audit at 2026-10-09T05:20:29Z rechecks unchanged baseline sscan configuration, library and metadata plus Base libCom. The baseline evidence archive still has its recorded SHA256. These observations establish the selected-module and current-consumer compiler/build comparison only: no no-C17 runtime, relocation or installed-environment gate Pass is claimed for the separate tree with external prerequisites. Original warnings remain in the real logs.

Host retrieval verifies all 118 comparison evidence files at 2026-10-09T05:20:45Z. The separate 128,296-byte ubuntu26-c17-evidence.tar.gz has SHA256 4db6f268e37837b33bf587e75ce1dc42d53efd6bf56dc59d47c7f39e4edae855 and 119 members including its manifest. Actual compile/link logs, generated source configuration, installed metadata, source identities, comparison helpers and audit are preserved under work/sscan-bump-20261008/ubuntu26-guest/c17-evidence. Guest workspace after archiving is 2,705,473,593 bytes; host workspace after retrieval is 3,147,417,426 bytes, both below 8 GiB.

Both compiler build variants pass for this incremental snapshot. D35 selects removal of only the release sscan append; the implementation and separate actual configuration check are recorded below. This configuration removal invalidates affected snapshot qualification and requires the mapped final-tree checks under M5. The matching finished notice is completed; actual shutdown and the independently verified preservation limits are recorded in the Ubuntu 26 baseline snapshot above.

##### C17 Configuration Removal

D35's Decision Date is 2026-10-09. The release configuration removes only the conditional C17 append from conf.sscan in configure/RULES_MODS_CONFIG and the corresponding sscan rationale line in configure/CONFIG_MODS_DEPS. The book's source-configuration list and module count now name nine modules. Other compiler settings and all other source pins remain unchanged.

Observed at 2026-10-09T07:03:59Z in a new work/sscan-bump-20261008/c17-removal workspace on actual Debian 13.7. This check runs the real shipped Make targets with OS_NAME=ubuntu and OS_VERSION=26.04; it is configuration generation, not an Ubuntu 26 compilation or runtime result. Separate authentic local clones resolve selected sscan ce9660cfc05071834391225beadf7f93b776d216 and unchanged sequencer e5e361509df1c0d3c667872243d8f7a9894514b4. The original committed configuration first generates one real C17 append for each module. The current changed rules then run conf.release.modules, conf.sncseq and conf.sscan twice: the prior sscan flag disappears, sequencer retains exactly one flag, and generated files are byte-identical on repetition. The sscan installation path and SNCSEQ dependency match the effective Make variables, and the tracked sscan source is unchanged.

All fifteen recorded commands exit 0 and all fifteen assertions pass. The rules used match the actual working checkout: RULES_MODS_CONFIG SHA256 9c5d4a3afc81d0ccc5fb770f739b340050206dfc91f1860bf0d78a4f319443a2; CONFIG_MODS_DEPS SHA256 1facd911ac1b413ed86e4955f5bf9ae62dcacfc3ee06b8dbb39ac525a69bc7d7. Evidence: c17-removal/configuration-result.json, original and changed generated configuration, and actual command logs under the same private work root. Regular-file workspace size is 3,188,102,228 bytes, within D33's 8 GiB bound. Existing verification workspaces and archives are preserved. At this configuration-only snapshot, post-removal runtime, other required coverage and final combined-tree verification remain Pending; T5 completion does not close M15. The subsequent actual Ubuntu 26 runtime observations are recorded below.

##### Ubuntu 26 Post-C17 Runtime Verification

Observed on actual Ubuntu 26.04 LTS after a separately authorized restart of the retained prepared guest. The accepted M15 verification plan continues with fresh runtime cases; the unchanged compiled no-C17 module tree, Base, vendor and original decoder remain the actual providers. A separate runtime directory links those real artifacts and uses byte-identical regular copies of the shipped setup/reset scripts, so the loader selects the comparison modules and shared baseline Base. This is targeted runtime verification, not a new compilation, relocation test, complete installed-environment gate or release qualification.

At 2026-10-09T07:36:25Z, eight actual acquisition/configuration commands exit 0 against a verified snapshot of all 250 tracked working-checkout files. Separate authentic sequencer and selected sscan clones resolve their recorded exact HEADs. The real reconf.modules, conf.release.modules, conf.sncseq and conf.sscan targets run without a MODS_C17_BRIDGE override; two configure passes produce byte-identical sscan CONFIG_SITE.local/RELEASE.local and sequencer CONFIG_SITE.local/RULES_BUILD files, exactly matching the actual comparison build inputs. sscan has no explicit -std option, sequencer retains one -std=gnu17 append, and selected sscan's tracked source is unchanged. The snapshot archive SHA256 is 908644a4a17f80fe7febff18d6e95ed118c0b0533b4b24620be181eb4643630e; its configuration-rule hashes match C17 Configuration Removal above.

Eight independent original-fixture cases finish at 2026-10-09T07:44:31Z in a different order from the baseline: asyn integer, point/delay, std trend, asyn echo, std setup failure, asyn setup failure, core setup failure and MDA. The original drivers are byte-identical to the retained copies; every case creates its own IOC/repeater and private ports. Five functional cases pass, three deliberate setup failures are observed as expected, and all 56 client commands exit 0. Actual cleanup, independent PID-absence checks and port probes confirm the sixteen owned processes terminated and their ports were released.

The original scan records report NPTS/CPT=4 from 0 to 0.3 in 0.1 steps, retain DDLY/PDLY/RDLY=0.001 and complete with EXSC/BUSY=0. The unchanged original request produces a real 364-byte MDA file with SHA256 89ba94b00a5ba333f0e4b4b002f9a63328c2a84697076b8bc80e60a0a215c21d. Actual mda-info/mda-dump runs, including the audit's separate decoder invocation, report rank 1, four requested/completed points, detector values 0 1 2 3 and three extra PVs. saveData remains Active, scanNumber advances 0 -> 1, retries=0 and abandonedWrites=0. The twelve original runtime fixture files match committed upstream bytes; all 22 archived original decoder source files remain unchanged. Missing scaler/MCA channels in the original request remain outside equipment qualification.

Original asyn testEpics returns integer values 123 and -17 and both echo strings with SEVR/UDF=0. Original std trend.db reports RTYP=sscan, MPTS=1000, time 2 -> realtime 1, R1PV=time and a four-point idle completion. The actual initialized asyn/std maps verify their comparison libraries and unchanged Base; MDA maps verify the real selected sscan, current calc/pvxs and Base. A separate fresh original point/delay case at 2026-10-09T07:47:12Z verifies all four libraries after its actual readiness marker, completes the real scan and observes cleanup of its two additional processes. The selected no-C17 libsscan.so retains SHA256 1915f3b8beeaaa085de53787a1800923cdaab096a64ea5ddec8607f801cc8276. The initial early-map audit remains Fail in post-c17-runtime/evidence-retrieval-result.json with its raw error; the separate corrected audit and fresh map recheck are the passing evidence. No earlier failure is relabeled Pass.

The final actual audit completes at 2026-10-09T07:47:30Z. Eleven comparison source HEADs and eleven installed metadata digests agree with the compiled snapshot, and retained configuration/library/source identities and all 492 earlier evidence files remain unchanged. Host retrieval at 2026-10-09T07:47:32Z verifies all 1,106 manifest files and 1,107 archive members. The 22,476,149-byte runtime-evidence.tar.gz has SHA256 5e7a37dc4757de3a3fbf9d36c39b4d98bf87405583f0af7041cad44d335ab41d. Private evidence is under work/sscan-bump-20261008/ubuntu26-guest/post-c17-runtime, including evidence/runtime-verification.json, evidence/runtime-audit.json, original fixtures, actual configuration/client/IOC logs, process maps, real MDA output, evidence-retrieval-recheck-result.json and the preserved initial failure. Guest workspace after archive creation is 2,770,395,364 regular-file bytes; host workspace at retrieval is 3,254,000,566 bytes, both below 8 GiB.

The finished notice is processed and the provider's actual successful shutdown log is read. Independent requester domuuid/domstate/dominfo/dumpxml and live/persistent network checks at 2026-10-09T07:50:35Z confirm the expected UUID, shut off state, persistent definition, disk/creation-record/seed and reservations preserved. The configured NVRAM path remains; physical file existence is not independently verified. Both earlier archives and the new runtime archive retain their recorded SHA256 after shutdown. Private lifecycle-result.json, lifecycle-raw.json and provider-shutdown.log preserve these observations. Required equipment, other configured transitive/layer paths, final combined-tree reruns, landing and shared issue closure remain Pending; M15 remains In progress.

##### Rocky 10 Verification Snapshot

Final audit completes at 2026-10-09T04:36:42Z; host retrieval verifies the evidence at 2026-10-09T04:37:15Z. The fresh guest is Rocky Linux 10.2, two CPUs, configured 4 GiB memory and 20 GiB disk. Actual key-only SSH/sudo and workspace absence were checked at 2026-10-09T04:09:34Z; UUID/configuration/reservation/lease at 2026-10-09T04:10:40Z. cloud-init is done with empty fatal error lists and a recoverable password-not-specified warning, returning exit 2. This warning and its last_update epoch display remain in private baseline evidence.

Prerequisites pass with the existing Rocky 10 package names and CRB/EPEL setup. Toolchain: GCC/G++ 14.3.1, GNU Make 4.4.1, GNU patch 2.7.6 and Python 3.12.14. The frozen candidate and all 274 recorded files pass byte/mode checks. Actual configure/build/install/link and audit paths complete 32 core stages by 2026-10-09T04:20:50Z and 55 consumer/vendor stages by 2026-10-09T04:35:57Z, every exit 0. The isolated install path is 1.5.0/rocky-10.2/7.0.10. Base has seven verified pinned gitlinks and 23 actual patch applications; current pvxs 1.5.2 has twelve actual carry applications. The seven additional consumers retain their current pins. Actual uldaq 1.2.1 uses the shipped conf.rocky10 target; measComp retains both existing carries. Final installed gates inspect 64 executables and 42 shared libraries, with zero RPATH/absolute-path/lost-$ORIGIN defects and environment findings=0.

The final audit checks both effective sscan assignments, all thirteen actual source HEADs, eleven metadata digests, selected-scan dependencies, byte-identical installed loaders and original fixture bytes. Installed libsscan.so SHA256 is b2c9ce092f7e9bc910d95add41447275f6633c95a8786c127fc0e295e65525f4. The original decoder build completes at 2026-10-09T04:21:14Z with all 22 archived files unchanged.

Separate real scan cases observe NPTS/CPT=4, DDLY/PDLY/RDLY=0.001 and EXSC/BUSY=0. The original scan/saveData databases and unchanged request produce an actual 364-byte file at 2026-10-09T04:29:34Z, SHA256 c3c53b4c648e61ba7824924d8f1c5a2b276aa761a05762fcb05f3d102de5d212. Original mda-info/mda-dump report rank 1, four requested/completed points, detector data 0 1 2 3 and three extra PVs. saveData stays Active, scanNumber advances 0 -> 1, retries=0 and abandonedWrites=0. Unavailable scaler/MCA channels in the original request remain unqualified.

Original asyn testEpics startup/databases/drivers return integer values 123 and -17 and both the original echo string and rel150 sscan consumer with SEVR/UDF=0. Actual maps confirm testEpicsSupport, selected sscan and current calc. Original std trend.db reports RTYP=sscan, MPTS=1000, time 2 -> realtime 1, R1PV=time and a completed four-point idle scan. Consumer runtime finishes at 2026-10-09T04:36:21Z. Three setup-failure cases plus five successful cases confirm real IOC/repeater termination and private-port release; the final audit independently checks all sixteen recorded PIDs absent. All 56 client commands exit 0. Every case uses its own real entrypoint and fresh processes, in a different order from Ubuntu 24.

Private evidence is under work/sscan-bump-20261008/rocky10-guest/evidence. The 346,025-byte rocky10-evidence.tar.gz has SHA256 196eee958d8523b817b7ecae4de82389003d88ee5b18c9d20aa421e8773e7d5a. All 374 manifest files pass size/hash checks after retrieval; the manifest is member 375. The archive preserves actual logs, original fixtures, driver source, process maps, metadata and real MDA data. Guest workspace after archiving is 2,081,931,436 bytes; host workspace after retrieval is 3,139,899,162 bytes, both below 8 GiB.

The incremental subset is verified and its evidence retrieved. The provider completed the matching finished notice. Requester read-only domuuid/domstate/dominfo/dumpxml and live/persistent network XML checks at 2026-10-09T04:39:59Z confirm the expected UUID, shut off state, persistent definition, disk/creation-record/seed and reservation preservation. The NVRAM path remains in the definition; actual physical file existence is not independently verified. Private raw outputs, the provider response/log and lifecycle-result-20261009T043959.json are preserved under the guest work directory. The evidence archive still matches its recorded SHA256. Resource closure is verified before the Ubuntu 26 request. Required equipment, other configured transitive/layer paths, Ubuntu 26 and its C17 comparison, final combined-tree reruns, landing and shared issue closure remain Pending. M15 remains In progress.

##### Ubuntu 24 Verification Snapshot

Final audit observed at 2026-10-09T02:44:08Z; host evidence retrieval verified at 2026-10-09T02:44:58Z. Fresh source paths and configure/CONFIG_SITE.local select the isolated `1.5.0/ubuntu-24.04/7.0.10` installation. Actual prerequisite installation passed. Toolchain: GCC/G++ 13.3.0, GNU Make 4.3, GNU patch 2.7.6 and Python 3.12.3. Private VM/access identifiers remain in the handoff and non-public records.

The same frozen candidate archive and all 274 recorded files pass byte/mode checks before building. The real Make paths complete 32 core, 55 consumer/vendor and one original decoder stage with every exit 0. Source HEADs match all thirteen manifest identities, including selected sscan ce9660c, unchanged sequencer and current calc/pvxs. Base retains seven pinned gitlinks and 23 selected patches; pvxs 1.5.2 retains its twelve carries. Additional current-pin consumers are asyn, std, autosave, busy, scaler, mca and measComp. measComp retains both carries and uses actual uldaq 1.2.1 through the unchanged vendor wrapper's `conf` target with the guest-local vendor path override. This does not implement their later selected updates. Actual final installed gates inspect 64 executables and 42 shared libraries with zero RPATH, absolute paths or lost $ORIGIN; check.env reports findings=0.

The final audit verifies both sscan assignments, thirteen actual source HEADs, eleven installed metadata digests, selected-scan dependency versions, original fixture bytes and the two byte-identical installed loader scripts. Installed libsscan.so SHA256 is 25195cfce904fb762348a0331a4dc89d0d566bd5aec8c3cb33237faff14a6f0d. Separate fresh scan cases observe NPTS/CPT=4, DDLY/PDLY/RDLY=0.001 and EXSC/BUSY=0. Original scan/saveData databases and the unchanged original request produce a real 364-byte file, SHA256 e30b2b92124861eaefaa6f6c43efa64f677a7e73b734324642195713496e9186. Original mdautils 1.4.2 tools report rank=1, four requested/completed points, detector values 0 1 2 3 and three extra PVs. All 22 archived files remain unchanged. saveData reports Active, scanNumber 0 -> 1, totalRetries=0 and abandonedWrites=0. Missing scaler/MCA channels are not qualified.

The original asyn testEpics executable/startup/databases/drivers return the original echo string and `rel150 sscan consumer`, and integer values 123 and -17 with SEVR/UDF=0. Actual maps show testEpicsSupport, selected sscan and current calc. Original std trend.db reports RTYP=sscan, MPTS=1000, time 2 -> realtime 1, R1PV=time and a four-point completed idle scan. Three setup-failure cases and five successful cases observe real IOC/repeater termination and private-port release; the final audit independently checks all recorded PIDs are absent. All 56 recorded client commands exit 0. Each case runs independently through its real entrypoint, in a different order from Rocky 8.

Evidence is under `work/sscan-bump-20261008/ubuntu24-guest/evidence`. The 340,330-byte `ubuntu24-evidence.tar.gz` has SHA256 6c8773edf9b34689025280dd9e91011acf9b19ad3689d148265d7d6ae44dd989. All 374 manifest files match size/hash after retrieval; the manifest is member 375. Actual logs, process maps, drivers, metadata, original fixtures and MDA output are retained. Guest workspace after archive preparation is 2,079,897,464 bytes; host workspace after retrieval is 3,134,725,921 bytes, both below 8 GiB.

After verified retrieval, the confirmed provider completed its shutdown response. Independent read-only domuuid/domstate/dominfo/dumpxml observations at 2026-10-09T03:57:55Z confirm the expected UUID, shut off, persistent definition and disk/creation-record/seed preservation. Read-only network XML observations at 2026-10-09T03:58:16Z confirm the expected live/persistent DHCP reservation pair. The NVRAM path remains in the inactive definition; actual physical file existence is not independently verified. Private lifecycle raw outputs and the separate result are preserved under the same guest work directory in lifecycle-raw-20261009T035755.json, lifecycle-network-20261009T035816.json and lifecycle-result-20261009T035816.json. The evidence archive still has its recorded SHA256. Resource closure is verified before the Rocky 10 request. Required equipment and other configured transitive/layer paths, the two remaining OS targets, Ubuntu 26 C17 comparison, final combined-tree reruns and landing stay Pending. M15 remains In progress.

##### Rocky 8 Verification Snapshot

Final source/metadata/lifecycle audit observed at 2026-10-09T01:05:27Z; evidence retrieval verified at 2026-10-09T01:07:05Z. Fresh sources and configure/CONFIG_SITE.local select the isolated `1.5.0/rocky-8.10/7.0.10` install. Actual prerequisites use the configured PowerTools repository and Python 3.9 selection. Toolchain: GCC/G++ 8.5.0, GNU Make 4.2.1, GNU patch 2.7.6, Python 3.9.25. Exact access and VM identifiers remain in non-public records.

The frozen candidate and all 274 file bytes match the Debian 12 transport. The initial extraction check failed because the system Python tar filter cleared group-write modes. A separate recheck restores only recorded modes inside the private workspace and verifies all bytes/modes before the real build. The original `rocky8-guest/transport-result.json` remains Fail evidence alongside raw stderr; the recheck does not relabel that failure.

All 32 core stages and 55 additional consumer/vendor stages exit 0 through the shipped Make paths. The thirteen source HEADs match the native/current-pin identities above. Base retains its seven pinned gitlinks and 23 selected patches; sequencer remains unchanged, sscan is ce9660c, current calc is 4217e83 and current pvxs 1.5.2 retains twelve carries. Additional consumers are asyn, std, autosave, busy, scaler, mca and measComp. These are M15 consumer checks, not their later selected updates. measComp retains its two carries and uses actual uldaq 1.2.1 through the original vendor wrapper's `conf.rocky8` target; only the guest-local vendor path override is added. Final gates inspect 64 executables and 42 shared libraries with zero RPATH, absolute dependency paths or lost $ORIGIN; environment findings=0.

The audit verifies both effective sscan assignments, thirteen actual source HEADs, eleven installed metadata files/digests, required selected-scan dependency versions, original DB/request bytes and byte-identical installed loader scripts. Installed selected sscan library SHA256 is 8fcce8e7fd81fc788ffd3194bd7d33d74f35d1a080a26aa4c1672cf178de2175.

The original standardScans.db, saveData.db and saveData.req run through the installed loader in separate fresh cases. Observed NPTS/CPT=4, DDLY/PDLY/RDLY=0.001 and EXSC/BUSY=0. The MDA case completes at 2026-10-09T00:58:23Z and writes a real 364-byte file, SHA256 f504e980cfc350b2a543250a3f81d1d14b04045fb99ac520cea55b3371176bac. Original mdautils 1.4.2 C tools report rank=1, four requested/completed points, detector values 0 1 2 3 and three extra PVs. saveData remains Active, scanNumber 0 -> 1, totalRetries=0 and abandonedWrites=0. The actual decoder build exits 0 and checks all 22 archived files unchanged. Missing equipment channels are not qualified by this core fixture.

The original asyn testEpics executable/startup/drivers/databases run separate echo and integer cases: the original string and `rel150 sscan consumer` return with SEVR/UDF=0; integer output/input match 123 and -17 with SEVR/UDF=0. Actual maps confirm testEpicsSupport, selected sscan and current calc. Original std trend.db reports RTYP=sscan, MPTS=1000, time 2 -> realtime 1, R1PV=time and a four-point completed idle scan. Three setup-failure cases plus five successful cases confirm actual IOC/repeater termination and private-port release. The final audit independently confirms recorded PIDs are absent. Cases use their real entrypoints in a different order from Debian 12.

Evidence is under `work/sscan-bump-20261008/rocky8-guest/evidence`. The 342,744-byte `rocky8-evidence.tar.gz` has SHA256 4e90b69e7281ae55eab31bf9eca4b2cd2c9ae5646bd81d0abd12c74e11776cb4. All 375 manifest files match their size/hash after retrieval; the manifest is the 376th member. Actual original fixtures, MDA output, IOC/client logs, process maps, metadata, drivers and build/runtime records are retained. Recorded guest workspace size during archive preparation is 2,662,445,227 bytes; host workspace size after retrieval is 3,129,685,179 bytes, both within 8 GiB.

After use and verified retrieval, the finished notice was processed by the confirmed provisioning session. Its actual shutdown log was read, and requester read-only domuuid/domstate/dominfo/dumpxml checks at 2026-10-09T01:15:31Z confirm the exact requested UUID, shut off, persistent definition, and preserved disk, creation-record and seed. The inactive definition has no NVRAM entry. Requester read-only network XML checks at 2026-10-09T01:23:42Z also confirm the expected live/persistent DHCP reservation pair. The private lifecycle evidence retains its Fail and corrected observation records separately, alongside original libvirt outputs. Resource closure is verified before the next OS request. Required equipment and other configured transitive/layer paths, three further VM targets, Ubuntu 26 C17 comparison, final combined-tree re-runs and landing evidence stay Pending. M15 remains In progress.

##### Debian 12 Verification Snapshot

Observed by 2026-10-08T23:45:33Z; evidence retrieval verified at 2026-10-08T23:47:09Z. The guest used fresh source paths and an isolated `1.5.0/debian-12/7.0.10` installation selected by `configure/CONFIG_SITE.local`. Actual prerequisites were installed before the builds. Toolchain: GCC/G++ 12.2.0, GNU Make 4.3, GNU patch 2.7.6, Python 3.11.2. Private access and VM identities remain in the provider's non-public handoff.

The thirteen actual source HEADs match the native snapshot's Base, sequencer, selected sscan, current calc/pvxs, seven additional consumers, and uldaq identities above. Base retains all 23 selected patches; all seven pinned gitlinks, including `.ci` and the six components, were checked. Current pvxs 1.5.2 retains its twelve carries. Every required recorded core and consumer stage exits 0 through the shipped Make paths. `install.iocsh` installs the two byte-checked shipped loader scripts before successful IOC cases. The seven additional consumers are asyn, std, autosave, busy, scaler, mca, and measComp; this is M15 consumer verification, not implementation of their later selected updates. measComp retains its two carries and uses actual uldaq 1.2.1 built through the frozen vendor wrapper; only the guest-local vendor path override is added. Linux mca keeps USB/libnet support disabled. Final installed gates inspect 64 executables and 42 shared libraries, with zero RPATH, absolute dependency paths, or lost $ORIGIN; `check.env` reports findings=0.

All original scan/saveData databases and request bytes agree with the selected source and installed/runtime copies. The point/delay case observes NPTS/CPT=4, DDLY/PDLY/RDLY=0.001, EXSC=0, and BUSY=0. The independent MDA case writes a real 364-byte file, SHA256 c5830838b669ea5de0c6e0dd810470856801ca9609c2bf784f9f3af522394c8b. Original `mda-info`/`mda-dump` report rank=1, four requested/completed points, detector values 0 1 2 3, and three extra PVs; saveData reports Active, scanNumber 0 -> 1, totalRetries=0, and abandonedWrites=0. The decoder is built from the original archive, whose SHA256 is recorded in the native snapshot; all 22 archived files remain byte-identical. Unavailable equipment channels in the original request are not qualified by this core scan.

The unchanged original asyn testEpics executable, startup, databases, and drivers run independently for integer and echo checks. Integer readbacks match 123 and -17 with SEVR=0/UDF=0; echo returns the original test string and `rel150 sscan consumer`. Actual process maps confirm testEpicsSupport, selected sscan, and current calc. The original std `trend.db` reports RTYP=sscan, MPTS=1000, trend_time1=2 -> trend_realtime1=1, R1PV=time, and a completed four-point idle scan. These results qualify only the recorded fixtures. Three independent setup-failure cases plus the five successful runtime cases confirm actual IOC/repeater termination and private-port release; the final audit independently checks the recorded processes are absent.

Evidence is under `work/sscan-bump-20261008/debian12-guest/evidence`. The 1,139,455-byte `debian12-evidence.tar.gz` has SHA256 ccfc44d514ef7183ce08385353a40d2760e483ae09b4235c9d30ce4fdaa6f7c9. All 301 files named in its manifest match their recorded sizes/hashes after retrieval; the archive includes the manifest as its 302nd member. Original logs, fixtures, actual MDA output, metadata, and result records are retained. Guest workspace size after archive preparation is 2,121,691,146 regular-file bytes; host workspace size after retrieval is 3,124,495,120 bytes, both within the 8 GiB bound.

Retained failures remain separate: `core-build-result.json` records the initial verification driver's wrong Base source path after successful real acquisition; `runtime-setup-failure-debian12/result.json` records the first attempt before loader installation. Corrected real-path re-executions have separate records; neither initial failure is relabeled Pass. At this Debian 12 snapshot, required equipment, other configured transitive/layer paths, four further OS targets, Ubuntu 26 C17 comparison, final re-runs and landing evidence were Pending. Later Rocky 8 observations are recorded above; they do not close outstanding equipment/layer or final-tree checks.

##### Native Software Consumer Verification

D36 narrows only actual equipment acceptance. Observed on Debian 13.7 using the retained installed source-built tree. The actual installed iocsh.bash loads mca 687d563 and measComp c38974e in separate fresh functional cases, with selected sscan ce9660c and recorded coherent dependencies. Original simple_mca.db, devMCA_soft.c, standardScans.db and measCompSupport.dbd match their committed upstream bytes; installed database/DBD copies also agree. No module source, installed binary, metadata or original fixture is rewritten for these cases.

The measComp case completes at 2026-10-09T08:19:09Z; the independent mca case completes at 2026-10-09T08:19:50Z. The original MCA record reports RTYP=mca, DTYP=Soft Channel and NMAX/NUSE=16. Its real READ operation completes with NORD=16, READ=0 and SEVR/UDF=0. Original standardScans.db reads that actual NORD field through D01PV: selected rounding gives NPTS/CPT=4, all three delays retain 0.001 seconds, D01CV=16, and EXSC/BUSY=0. The real measComp registrar exposes MultiFunctionConfig, confirmed through the initialized IOC's help output; no hardware configuration command is invoked.

Actual initialized process maps contain thirteen expected libraries for measComp and twelve for mca, including the selected sscan, coherent consumer libraries, Base and current pvxs. The audit checks ten installed metadata files and eleven module library artifacts against their current digests and original build records. All 32 real client commands exit 0. Each case owns a fresh IOC/repeater and four private ports. A third independent case injects a setup failure only after actual IOC initialization and library checks; its cleanup completes at 2026-10-09T08:20:23Z. Actual waits and in-case port probes confirm all six owned processes terminate and all twelve private port checks pass.

The audit at 2026-10-09T08:23:29Z passes for this Debian 13 software scope. Its SHA256 is 39672f4ffd6fd7eb1eeff2cf19b2fc5c0af373a4ff7a11837563dad548074a02; regular-file workspace size before the audit is 3,255,190,781 bytes, below 8 GiB. Evidence is under work/sscan-bump-20261008/software-consumers-debian13: native-software-audit.json, meascomp-functional, mca-independent and setup-failure-independent retain real results, copied driver bytes, original fixtures' hashes, initialized maps and raw logs. Two earlier checker failures remain Fail with their actual drivers and raw results: loader informational text was misclassified, then numeric DTYP output was compared with a string. Corrected runs have separate records. The local sandbox's getifaddrs warning remains in the actual logs; these loopback checks do not establish broader network or equipment behavior.

The retained Debian 12 guest subsequently receives its separately authorized READY handoff. Actual requester checks and software verification are recorded below; the initial approval-pending response is not runtime evidence. Remaining configured software/layer paths, later combined-tree reruns, landing and shared issue closure remain outstanding; M15 is In progress.

##### Debian 12 Software Consumer Verification

Observed on actual Debian GNU/Linux 12 after the provisioning owner's separate authorization to restart the retained prepared guest. Requester key-only SSH, sudo, cloud-init done/errors=[], two CPUs, and the existing installation are independently checked at 2026-10-09T09:20:52Z. The source and install workspace is unchanged from the earlier Debian 12 snapshot: selected sscan ce9660cfc05071834391225beadf7f93b776d216, current mca 687d563206d59de9097e28e95e32ad09ebcc2522 and measComp c38974e85c59429b8ba48ed320681ba0296fb924. The unchanged verification driver has SHA256 5ff0f55b5c700bd52621f681e0d329aee43be739bf211d74f489693cd5e3ae2c. This is software verification against retained real compiled artifacts, not a rebuild or equipment acceptance.

Three cases run individually through their actual entrypoints in a different order from Debian 13: mca completes at 2026-10-09T09:22:09Z, post-initialization setup-failure cleanup at 2026-10-09T09:22:24Z, and measComp at 2026-10-09T09:22:39Z. Each owns a fresh IOC/repeater and four private ports. Original simple_mca.db, devMCA_soft.c, standardScans.db and measCompSupport.dbd agree with committed upstream bytes and their applicable installed copies. Both functional cases observe RTYP=mca, DTYP=Soft Channel and NMAX/NUSE=16; actual READ completes with NORD=16, READ=0 and SEVR/UDF=0. Original standardScans.db reads that NORD through D01PV and completes NPTS/CPT=4 with DDLY/PDLY/RDLY=0.001, D01CV=16 and EXSC/BUSY=0. The initialized measComp IOC exposes the real MultiFunctionConfig registrar through help; no equipment configuration is invoked.

All 32 real client commands exit 0. Actual initialized process maps contain twelve expected libraries in the mca case and thirteen in the measComp and setup-failure cases. Ten metadata files match the earlier installed identity audit, and eleven declared module libraries match their pre-run hashes. Actual waits, independent PID-absence checks and port probes confirm all six owned processes terminate and all twelve private ports are released. The audit at 2026-10-09T09:24:14Z also confirms all 15,283 existing guest regular files and 36 symlinks are unchanged. The initial audit-only Fail for the seq/sequencer metadata-name mismatch remains separate in audit-initial-failure.json with its original driver; the corrected audit does not relabel it.

Host retrieval at 2026-10-09T09:24:51Z verifies all 95 manifest files and 96 archive members. The 795,752-byte debian12-software-evidence-20261009.tar.gz has SHA256 350ff4cf4503f742ba32c4c9780a5021f7ac108ca94ccf95ed01b8f04cfcaec5; software-audit.json has SHA256 8103317fa55a4a0df31f37a1d3581a131e049669abe779a0c77e35bed393424a. All 321 earlier host evidence files remain byte-identical. Guest workspace after archive creation is 2,125,724,684 regular-file bytes and host workspace at retrieval is 3,259,285,521 bytes, both below 8 GiB. Evidence under work/sscan-bump-20261008/debian12-guest/software-consumers retains original fixture copies, actual drivers/results, initialized maps, raw IOC/client logs, the preservation manifest, corrected audit and initial audit failure.

The finished notice is delivered immediately after verified retrieval and processed by the confirmed provider. Its actual normal shutdown exits 0 at 2026-10-09T09:25:58Z. Requester read-only UUID/state/definition and live/persistent network checks at 2026-10-09T09:26:04Z confirm shut off, persistent definition, disk/creation-record/seed and reservations preserved. A further preservation record at 2026-10-09T09:26:53Z verifies the provider's completed response, all 423 pre-shutdown host evidence hashes and both Debian 12 archives unchanged. The configured NVRAM path remains; physical file existence is not independently verified. Private lifecycle-result.json, lifecycle-raw.json and provider-shutdown.log retain these observations.

M15 remains In progress. Original mca/measComp software verification on Rocky 8 (incremental) and, under D37, on Ubuntu 24, Rocky 10 and Ubuntu 26 (final combined tree), other configured transitive/layer consumers and landing evidence remain outstanding for M15; shared issue #98 closure follows D38; final combined-tree reruns are recorded obligations of M5 Release Verification 3. The next retained guest is Rocky 8. Its software-verification restart request is delivered to the confirmed provider; the request-status record at 2026-10-09T16:08:33Z confirms no READY response, no software test execution and an independently observed shut off state. Separate provider-owner restart authorization and a verified READY handoff remain required. Private request and response evidence is under work/sscan-bump-20261008/rocky8-software-request-20261009.

##### Closure Evidence

D33-D36 authorize the current implementation, sequential VM verification, sscan-only C17 removal and the revised software verification boundary. The sscan pin, active pin reference, C17 configuration and related book explanation are changed; the Debian 13, fresh Debian 12, Rocky 8, Ubuntu 24, Rocky 10 and Ubuntu 26 baseline core/consumer observations above are recorded. All five guest baseline evidence archives have verified host retrieval. D35's compiler disposition is implemented and its actual configuration check passes; the earlier Ubuntu 26 build comparison remains immutable evidence. Actual Ubuntu 26 post-removal original-fixture runtime, configuration equivalence, host evidence retrieval and resource closure now pass within the recorded scope. M15 remains In progress: remaining configured consumer software/layer checks and commit/landing evidence remain outstanding; shared issue #98 closure follows D38; final combined-tree re-runs are recorded obligations of M5 Release Verification 3. D36 excludes actual mca/measComp equipment acceptance without claiming it passed. Their original software consumer paths and setup-failure cleanup now pass on Debian 13 and Debian 12, with Debian 12 host retrieval and resource closure verified above; Rocky 8 remains the one further incremental guest; under D37 the Ubuntu 24, Rocky 10 and Ubuntu 26 software cases run in the final-tree run, and the configured software/layer paths remain required incrementally on Debian 13 and Rocky Linux 8.10. The module update is uncommitted. D32's published #98 scope does not establish any of these results; its recorded external observation is unchanged. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope. D37 (2026-10-09) changes the per-module six-OS criteria that the published #98 body states; reconcile the body under separate Issue authority before the issue is closed.


#### M16 - Lua Update

Origin: 1.5.0 / M16
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Implement D22's selected lua update from 17475b50ae95c801bad9573bb2b031ffb04ac75c to 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T10 and Lua Selection And Compatibility Scope.

##### Scope

Update `SRC_TAG_LUA` and `SRC_VER_LUA` in `configure/RELEASE` to proposed values `01aa7a1` / `01aa7a1`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Rebuild asyn against completed M14/M15 before Lua. Preserve normal BUILD_IOCS=NO; independently enable the original iocs/iocLuaExample fixture for verification. Check epics.sleep -> osi.sleep, getName/pv_name -> name, removed wrapper APIs, generated luascript fields, and precompiled chunks against actual used scripts. Enabling a driver requires a fresh source census; an uninitialized motorScriptMotor does not pass.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, M14, D22, D29. lua_DEPS requires asyn, whose build requires selected calc and sscan. M14 therefore precedes the rebuilt asyn/Lua path; motorScriptMotor is an enabled-source condition rather than a reverse dependency. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan. Verification-example handling amended 2026-10-10 at the owner's direction; plan content is otherwise unchanged.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D22's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d; planned install version 01aa7a1; no stale source or consumer build record |
| T2 | Build | Run shipped conf.lua, check.module-deps MODULE=lua, build.lua, symlink.lua, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Execute luaApp/test's eight original programs and fixtures: luaScriptTest, luaDtypTest, luaPortDriverTest, luaShellTest, luaEpicsTest, luaEventTest, luaConcurrencyTest, and bytestreamTest. Run actual scripts, records, scalar/string/array data, database/CA/asyn access, concurrent state use, old shell aliases, and the new run/load commands. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All eight tests pass through actual Lua/EPICS/asyn paths; deployed scripts use compatible APIs and actual IOC operations remain correct under concurrent use. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: Motor's declared build.lua prerequisite and any explicitly enabled motorScriptMotor at the selected motor gitlink; no active external Lua consumer was found in the initialized census. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |
| T5 | Compiler | Compare actual selected-module and consumer builds with and without the existing -std=gnu17 append; keep its current value until results and an explicit retain/remove decision | Affected Ubuntu 26.04 compiler configuration | Observed compiler behavior determines the proposed C17 disposition; a source/header review or different compiler cannot justify removal |
| T6 | Example | Build the selected iocs/iocLuaExample in a separate BUILD_IOCS=YES configuration and execute its original startup/scripts; separately verify the normal library-only installation. The example's configure/RELEASE sets LUA=$(TOP)/../.., which has no cfg when INSTALL_LOCATION is set elsewhere and then leaves LUA_IOC_LIBS empty; point LUA in the example's configure/RELEASE.local to the installed lua tree. Enable BUILD_IOCS=YES only in this verification configuration; remove the option and the example products afterwards, so the normal build keeps BUILD_IOCS=NO. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Real opt-in IOC startup and original fixture data paths pass independently of the normal installation |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |
| T5 | Not run | Affected Ubuntu 26.04 compiler configuration | Pending | none |
| T6 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M17 - std Update

Origin: 1.5.0 / M17
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Implement D23's selected std update from 5f2e44214963b84ea3a400f7b7c3a9f510126ddd to 27b696702c4ebc8c698c98e3bbb10a34f1a2c821, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T11 and std Selection And Verification Scope.

##### Scope

Update `SRC_TAG_STD` and `SRC_VER_STD` in `configure/RELEASE` to proposed values `27b6967` / `27b6967`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Rebuild unchanged asyn after M14 before this module. Private flag inspection must observe the actual installed record implementation, not a reimplementation of special() or checkLink(). No direct external std library/header consumer was found.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, M14, D23, D29. std_DEPS requires sequencer and asyn. M14 precedes the rebuilt asyn/std path; the calc pvHistory database is an optional runtime consumer, not a reverse build dependency. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan. Verification-example handling amended 2026-10-10 at the owner's direction; plan content is otherwise unchanged.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D23's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source 27b696702c4ebc8c698c98e3bbb10a34f1a2c821; planned install version 27b6967; no stale source or consumer build record |
| T2 | Build | Run shipped conf.std, check.module-deps MODULE=std, build.std, symlink.std, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Load the original stdApp/Db/throttle.db into a real IOC: build the shipped iocs/stdTestIOC (stdTestApp) in an isolated verification configuration. Its configure/RELEASE sets STD=$(TOP)/../.., the same pattern that left the lua example's library list empty, so point STD in the example's configure/RELEASE.local to the installed std tree. Enable BUILD_IOCS=YES only in this verification configuration; remove the option and the example products afterwards, so the normal build keeps BUILD_IOCS=NO. Exercise delayed/latest-value output and concurrent processing/callbacks; change OUT and SINP independently, disconnect/reconnect CA links, and check local/constant links. Inspect actual private per-link status flags in addition to exposed fields. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Delayed output delivers the actual latest value under record locking; OUT/SINP status and flags remain independent after changes and reconnects. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: Declared mca/measComp build dependents, installed stdSupport.dbd registration, and the calc pvHistory example when enabled. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |
| T5 | Compiler | Compare actual selected-module and consumer builds with and without the existing -std=gnu17 append; keep its current value until results and an explicit retain/remove decision | Affected Ubuntu 26.04 compiler configuration | Observed compiler behavior determines the proposed C17 disposition; a source/header review or different compiler cannot justify removal |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |
| T5 | Not run | Affected Ubuntu 26.04 compiler configuration | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M18 - busy Update

Origin: 1.5.0 / M18
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Implement D24's selected busy update from 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb to a4a272d94d1f4351e7d9553e6dc35782eb96ce75, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T12 and busy Selection And Verification Scope.

##### Scope

Update `SRC_TAG_BUSY` and `SRC_VER_BUSY` in `configure/RELEASE` to proposed values `a4a272d` / `a4a272d`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Rebuild asyn after M14 and retain autosave as a prerequisite. Verify generated busyRecord.h, all three device-support registrations, cfg/CONFIG_MODULE and BUSY_DEPS. Keep normal BUILD_IOCS=NO.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, M14, D24, D29. busy_DEPS requires unchanged autosave and rebuilt asyn after M14. Motor's declared build.busy dependency makes this a prerequisite of M20. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan. Verification-example handling amended 2026-10-10 at the owner's direction; plan content is otherwise unchanged.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D24's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source a4a272d94d1f4351e7d9553e6dc35782eb96ce75; planned install version a4a272d; no stale source or consumer build record |
| T2 | Build | Run shipped conf.busy, check.module-deps MODULE=busy, build.busy, symlink.busy, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Use the original busyApp/Db databases and shipped testBusyAsyn driver to exercise Soft Channel, Raw Soft Channel, and asynInt32 support, VAL transitions, HIGH reset, completion callbacks, forward links, and synchronous/asynchronous repeated callbacks. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Actual typed device support and record completion behave correctly, without a replacement driver or mocked internal callback path. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: mca/measComp link paths, motor/pmac and other configured busy-record databases, ADCore/detector templates and enabled library paths; feed-core's removed IOC remains disabled. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |
| T5 | Compiler | Compare actual selected-module and consumer builds with and without the existing -std=gnu17 append; keep its current value until results and an explicit retain/remove decision | Affected Ubuntu 26.04 compiler configuration | Observed compiler behavior determines the proposed C17 disposition; a source/header review or different compiler cannot justify removal |
| T6 | Example | Build iocs/testBusyAsynIOC with BUILD_IOCS=YES in a separate verification configuration, start its actual testBusyAsynApp and original st.cmd, and run the shipped testBusyAsyn databases. The example's configure/RELEASE sets BUSY=$(TOP)/../.., the same pattern that left the lua example's library list empty; point BUSY in the example's configure/RELEASE.local to the installed busy tree. Enable BUILD_IOCS=YES only in this verification configuration; remove the option and the example products afterwards, so the normal build keeps BUILD_IOCS=NO. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Real opt-in IOC startup and original fixture data paths pass independently of the normal installation |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |
| T5 | Not run | Affected Ubuntu 26.04 compiler configuration | Pending | none |
| T6 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M19 - scaler Update

Origin: 1.5.0 / M19
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Not started

##### Summary

Implement D25's selected scaler update from beb5521af49616682e4e442c3e33a06add1bd713 to baa8e1c5e5a9a5deceef8cc39207a0da446092a6, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T13 and scaler Selection And Verification Scope.

##### Scope

Update `SRC_TAG_SCALER` and `SRC_VER_SCALER` in `configure/RELEASE` to proposed values `baa8e1c` / `baa8e1c`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Rebuild asyn after M14 and retain autosave. The example also requires M14's selected CALC cfg declarations. No upstream source or execution permission is changed to handle its relocated run script.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, M14, D25, D29. scaler_DEPS requires unchanged autosave and rebuilt asyn after M14; the isolated opt-in example additionally consumes selected calc cfg declarations. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan. Verification-example handling amended 2026-10-10 at the owner's direction; plan content is otherwise unchanged.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D25's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source baa8e1c5e5a9a5deceef8cc39207a0da446092a6; planned install version baa8e1c; no stale source or consumer build record |
| T2 | Build | Run shipped conf.scaler, check.module-deps MODULE=scaler, build.scaler, symlink.scaler, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Load the original iocsh/softScaler.iocsh and scaler databases into a real IOC using drvScalerSoft. Check actual count/reset/preset/completion behavior; verify installed cfg/CONFIG_MODULE, SCALER_DEPS, library, header, DBD, and real isolated uninstall/realuninstall behavior. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | The real soft-scaler data path and metadata pass; uninstall targets affect only the isolated verification installation and behave correctly with example builds disabled and enabled. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: measComp USBCTR header/library path, configured mca SIS paths and databases, autosave scaler database, and the sscan MDA channel-description tool. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |
| T5 | Compiler | Compare actual selected-module and consumer builds with and without the existing -std=gnu17 append; keep its current value until results and an explicit retain/remove decision | Affected Ubuntu 26.04 compiler configuration | Observed compiler behavior determines the proposed C17 disposition; a source/header review or different compiler cannot justify removal |
| T6 | Example | In an isolated BUILD_IOCS=YES configuration with CALC pointing to selected R3-8, build scalerTestApp. From iocs/scalerTestIOC/iocBoot/iocScalerTest, invoke the unchanged mode-100644 run through sh; verify its actual st.cmd and $(SCALER)/iocsh/softScaler.iocsh path. Check normal BUILD_IOCS=NO separately. The example's configure/RELEASE sets SCALER=$(TOP)/../.., the same pattern that left the lua example's library list empty; point SCALER in the example's configure/RELEASE.local to the installed scaler tree. Enable BUILD_IOCS=YES only in this verification configuration; remove the option and the example products afterwards, so the normal build keeps BUILD_IOCS=NO. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Real opt-in IOC startup and original fixture data paths pass independently of the normal installation |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |
| T5 | Not run | Affected Ubuntu 26.04 compiler configuration | Pending | none |
| T6 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### M20 - motor Update

Origin: 1.5.0 / M20
Identity History: none
GitHub Issue: #98, https://github.com/jeonghanlee/EPICS-env/issues/98; shared module-update issue under D32
Status: Blocked

##### Summary

Implement D27's selected motor update from 285f44d66cf7d07a86047719de757bd1f5d92a95 to 4b22ac950de98c2dca324c2ef8ef221e124f6651, preserving the recorded consumer and verification obligations. Source assessment evidence: M1 / T15 and motor Selection And Verification Scope.

##### Scope

Update `SRC_TAG_MOTOR` and `SRC_VER_MOTOR` in `configure/RELEASE` to proposed values `4b22ac9` / `4b22ac9`, resolving the full selected object above. Update affected active documentation, installed expectations, and only configuration changes justified by actual selected-source builds. Build after selected Lua and busy, with unchanged sequencer/asyn/modbus prerequisites. Exclude 47893ed and add no local version patch. G2 is Open because required actual-velocity/model-1 drivers and motor/pmac hardware verification access are not identified in the current plan. On G2 completion, resume as Not started; plan acceptance and implementation authority still remain separate.

Out of scope: other source selections, enabling unreviewed optional drivers or consumer paths, changing sibling repository pins here, source-initialization changes under D8, and treating static inspection or a build as runtime qualification.

##### Completion Criteria

- Effective source and installed identity match the selected full commit; no existing source-directory skip or pin override substitutes the previous source.
- The real module, its configured prerequisites, artifacts, loader metadata, and required consumer build/startup paths pass on Debian 13 and Rocky Linux 8.10, the D37 incremental platforms; the other platforms run once on the final combined tree under M5 Release Verification 3 and are recorded obligations, not conditions of this closure.
- Every local check below has an actual observed result with real code and original fixtures; missing required device/access checks remain Pending and do not close the work.
- Later shared changes invalidate the affected snapshot results and are re-executed against the final combination under M5; scope, documentation, landing evidence, and linked issue state agree.

##### Dependencies And Decisions

M1, M16, M18, G2, D27, D29. motor_DEPS requires selected Lua and busy plus unchanged sequencer/asyn/modbus, so M16 and M18 precede this implementation. G2 is Open for required actual driver/device scope and access; resume as Not started when G2 completes. Source-backed build constraints come from `configure/CONFIG_MODS_DEPS` and M1's actual consumer census. Rebuild consumers against the installed prerequisite versions; an unchanged pin is not a waiver. Optional runtime examples do not create reverse build dependencies. D29 assigns this separate work; D30 accepts the detailed plan, and D31 keeps implementation and verification tracking in this canonical detail; D32 assigns shared issue #98. Implementation authority remains separate. D37 sets the platform cadence: incremental runtime checks run on Debian 13 and Rocky Linux 8.10, and the six-platform runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 run once on the final combined tree; plan content and implementation authority are otherwise unchanged. The Test Plan Environment column of this detail's T labels names the final-tree scope, and the closure of this detail needs only the incremental platforms; the other platforms, and the Ubuntu 26.04-only compiler comparison labels where this detail has them, are recorded obligations of the final-tree run in Release Verification 3. Labels that the map assigns to Release Verification 4, including any G2 device check, keep their own completion conditions.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-08; D30 accepts the reviewed exact source selection, implementation steps, real-path Test Plan, and final-tree re-run mapping. D37 (2026-10-09) accepts the revised per-OS verification cadence for this plan.
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Recheck D27's immutable source, effective old pins/overrides, actual active consumers, selected prerequisite installations, and the planned tag/version values above before any authorized edit.
2. Use a new isolated candidate source/install workspace with approved paths and storage bounds; preserve existing local sources, installations, and evidence. Follow the shipped module-bump Stage 6 and book steps 7-15 from a source path that cannot trigger the existing-directory acquisition skip. Do not remove an existing source tree implicitly.
3. Apply only the selected pin and justified integration changes; run the actual configure, dependency audit, build/install, symlink, artifact and installed-environment checks. Inspect all retained carries applicable to this source before building; no new local upstream-source patch is selected by this plan.
4. Execute the original module fixtures and actual IOC/data paths listed below, then coherently reconfigure/rebuild/relink the configured consumers. Record exact currently implemented consumer pins; do not require unimplemented future modules to be Complete before this incremental snapshot can be checked.
5. Record all observations and unresolved required checks; map every later selected-pin, configuration, metadata, or fixture change to M5's integrated re-run. Commit/push, issue creation/body edits/closure, and release actions require their separate git-workflow authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Identity | Read effective SRC_TAG/SRC_VER, overrides, source HEAD, actual installed directory, library/DBD/cfg and loader metadata | Isolated candidate source and installation | Exact selected source 4b22ac950de98c2dca324c2ef8ef221e124f6651; planned install version 4b22ac9; no stale source or consumer build record |
| T2 | Build | Run shipped conf.motor, check.module-deps MODULE=motor, build.motor, symlink.motor, then installed check.deps/check.env; use actual configured dependency sources and record their identities | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | All required configure/audit/build/install and installed-path checks pass; actual artifacts and metadata agree |
| T3 | Behavior | Use selected motor and separately pinned motorMotorSim R1-3 with the original simulator IOC/database paths. Observe actual motor-record VERS=7.4, movement/readback/completion, stop, jog/home, and limits. Do not mix old consumers with the new asynMotorController layout. | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Actual installed motor records identify 7.4 and simulator paths pass; NUM_MOTOR_DRIVER_PARAMS remains available to the pinned pmac. |
| T4 | Consumers | Reconfigure, coherently rebuild/relink, and start all configured source-census consumers: Coherent motorMotorSim and pmac rebuild/relink; affected std motor databases/request files and any explicitly enabled busy motor example. Recheck enabled conditionals through paired source traversals before execution | Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Actual consumer startup/data paths pass for the recorded snapshot; unavailable required checks remain Pending; later selected changes map to M5 |
| T5 | Hardware | With G2's accepted actual upstream driver/device inputs, observe motorActVelocity-backed RVEL updates/callbacks, active model-1 motor_task shutdown, and required real pmac device/trajectory behavior | Owner-supplied actual driver/device environments identified by G2 | Every required real behavior has observed evidence; an idle IOC, unrelated simulator, or inaccessible device is not a Pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Isolated candidate source and installation | Pending | none |
| T2 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T3 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 | Pending | none |
| T4 | Not run | D37 incremental platforms; final-tree run on Debian 12/13, Rocky Linux 8/10, Ubuntu 24.04/26.04 for Layers 1-2; Debian 13 and Rocky Linux 8 incrementally and Debian 12 in the final-tree internal Layers 1-3 (Release Verification 3) for Layer 3 | Pending | none |
| T5 | Not run | Owner-supplied actual driver/device environments identified by G2 | Pending | none |

##### Closure Evidence

None for implementation. D30 records plan acceptance only; D31 cancels individual module issues, and D32 assigns shared issue #98. Its body update records scope only. No pin edit, candidate build/runtime result, implementation authority, or landing is established by this detail. Closure of shared issue #98 follows D38.

##### GitHub Projection

Title: Update EPICS modules and verify consumers for 1.5.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: 1.5.0, number 7, https://github.com/jeonghanlee/EPICS-env/milestone/7
Observed State: open; shared module-update issue #98
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: 1.5.0, number 7
Observed Updated At: 2026-10-08T18:37:06Z
Last Compared: by 2026-10-08T18:38:33Z through `gh issue view 98 --repo jeonghanlee/EPICS-env --json number,title,body,state,labels,assignees,milestone,url,updatedAt`; title, complete body, open state, label, assignee, and milestone match the prepared shared scope.
Prepared Body: `work/issue-98-body.md`; shared body for M2-M3 and M13-M20
Publication: Complete under D32 for the shared title/body update; no new module issue was created. Six common and ten module acceptance criteria remain unchecked because module implementation and verification are not complete. This detail owns its module plan and evidence; #98 projects their combined scope.


#### G2 - Motor And pmac Verification Access

Origin: 1.5.0 / G2
GitHub Issue: none
Status: Open

##### Summary

The owner supplies the exact enabled upstream driver/source/configuration and actual device/access inputs needed for M20 / T5: a driver that provides motorActVelocity, an active model-1 driver with motor_task, and the pmac device/trajectory path. M1 / T15 recorded uninitialized optional driver sources and no hardware/runtime evidence for these changes. These inputs and availability have not been established by the current planning work. Responsible party: owner; affected work: M20 and M5.

##### Completion Criteria

- Required public driver commits/gitlinks, enabled configuration, actual device roles, intended verification environments, and the acceptance scope for velocity, shutdown, and pmac are explicitly identified.
- Required driver sources are censused and the actual verification devices/access are available, with a dated access/availability observation or explicit owner-approved scope decision; exact internal endpoints stay in a private operational record.
- The gate closes only the prerequisite condition. M20 / T5 and M5 still require actual behavior results; a gate closure alone is not hardware qualification.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| Not run | Open: required driver/device scope and verification availability not recorded | M1 / T15 and M20 / T5; no device/access pass claimed |

##### Closure Evidence

None. Opened for planning on 2026-10-08 from the already recorded verification obligations; no missing check is waived.



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
Status: Blocked

##### Summary

Verify the combined 1.5.0 candidate, publish separately authorized release objects, and verify the actual published version before closure.

##### Scope

Release comparison, branch-opening version checks, integrated re-runs, six-OS builds, full internal Layers 1-3 installation verification on Debian 12/13 and Rocky Linux 8.10, all seven runbook gates and active alliocs consumers, two-target full runtime suites, final version and install-path consistency, documentation, publication, clean installation from the released object, and final tracker and cycle reconciliation.

Out of scope: source-initialization improvements deferred under D8, makeRPath conversion, unselected module updates, rewriting 1.4.0 objects, or treating CI builds alone as IOC runtime evidence.

##### Completion Criteria

- M1-M4 and all eight additional module work units M13-M20 are complete with reachable evidence; G2 and any other required external verification gate are Complete.
- Every final check below has an observed Pass; missing environments or access remain Pending and cannot be counted as success.
- Before release execution, Release Verification 3 records a Pass for every runbook gate and every active alliocs consumer on each required internal OS; a partial, excluded, or incomplete result is not a Pass.
- Release actions name exact immutable targets and their own authorization; the released tag is not moved to include later closure evidence.
- The canonical records, optional tracker projections, release notes, and next entry point agree.
- All 20 issues in the closed-Backlog inventory below are assigned to milestone 1.5.0 and remain closed; original completion evidence and first-release history remain unchanged.

##### Dependencies And Decisions

M1-M4, M13-M20, G2, D1-D4, D8-D9, and D16-D38. D29 assigns the eight IN module implementations M13-M20, while M2 and M3 cover pyDevSup and pvxs; the three HOLD pins and selected Base still need coherent final-tree verification. G2 is Open for required actual motor/pmac verification inputs and access; resume as Not started when G2 completes. D8 excludes initialization improvements and D9 governs the existing branch-opening version correction. Local T results require real re-runs after later changes to the checked source, artifact, fixture, or consumer configuration. The release number affects install-path assertions; a number-only correction does not itself invalidate code checks. D37 places the six-platform runtime verification of the module and consumer checks that the Integrated Verification map assigns to Release Verification 3 on the final combined tree; per-module incremental results are not release qualification.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: 727b966e6030ebbb9dea52faa7eb09cc4b518fd4, docs/milestone-1.5.0.md / M5, release-eve version timing corrected by D9; 503f6cae62ac77111078a9e9c5faa974740165b6, docs/milestone-1.5.0.md / M5, prior unaccepted five-work plan before D29's additional module assignment.

1. Confirm the branch already carries `ENV_RELEASE_VERS=1.5.0` and the separately authorized version-only commit. Accept the remaining cycle and work plans, verify the register consolidation and settle remaining choices, and commit the complete plan through git-workflow before any tracker mutation.
2. Complete M1-M4 and M13-M20 under their separately accepted and authorized plans; close G2 and verify every required driver/device path. Use the source-backed module ordering in the current entry point; do not treat independent-module row order as a dependency.
3. Run and record integrated code verification and CI against the combined candidate, then full installation verification on that same tree and its existing 1.5.0 path through the Release Runbooks. Release Verification 3 owns the normal Stage 1 internal Layers 1-3 runs on Debian 12/13 and Rocky Linux 8.10, all seven gates including the binary-link check, and the subsequent complete active alliocs consumer check. Resolve each layer's release-line ref freshly at preflight and record the exact accepted refs, source identities, installed roots, per-OS gate outcomes, and complete consumer evidence before release execution. Preserve the results in a separately authorized evidence commit. Reuse CI evidence only when the pipeline's unchanged-code conditions hold; any required code change invalidates affected evidence. Final readiness carries no new `ENV_RELEASE_VERS` mutation.
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
| M2 / T1, M2 / T2, M2 / T3, M2 / T4 | Later pins, interpreter paths, consumer configuration or metadata | Actual installed Python device support and original counter fixture | Release Verification 3 | Exact identity, six-OS Python IOC behavior and every enabled consumer pass on the final tree | Pending |
| M3 / T1, M3 / T2 | Carry or pvxs module-version changes | Patch selection and pvxs artifacts | Release Verification 3 | Correct carry set and installed identities | Pending |
| M3 / T3 | Later pvxs, IOC or consumer changes | All twelve retired-fix runtime protections, real CLI/IOC and ADCore data paths | Release Verification 3 | Explicit real-case mapping and final combination pass; no static substitute | Pending |
| M3 / T4 | pvxs, metadata, fixture, or example changes | softIocPVX and loader | Release Verification 4 | Entire ordered loader suite passes with final pins and real fixtures/servers | Pending |
| M4 / T1, M4 / T2, M4 / T3, M4 / T4 | Server, pvxs, fixture, or documentation changes | Milo example and installed IOC | Release Verification 4 | Real data path and accepted recovery behavior pass | Pending |
| M13 / T1, M13 / T2, M13 / T3, M13 / T4 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | caPutLog implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M14 / T1, M14 / T2, M14 / T3, M14 / T4, M14 / T5 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | calc implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M15 / T1, M15 / T2, M15 / T3, M15 / T4, M15 / T5 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | sscan implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M16 / T1, M16 / T2, M16 / T3, M16 / T4, M16 / T5, M16 / T6 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | lua implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M17 / T1, M17 / T2, M17 / T3, M17 / T4, M17 / T5 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | std implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M18 / T1, M18 / T2, M18 / T3, M18 / T4, M18 / T5, M18 / T6 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | busy implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M19 / T1, M19 / T2, M19 / T3, M19 / T4, M19 / T5, M19 / T6 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | scaler implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M20 / T1, M20 / T2, M20 / T3, M20 / T4 | Later selected pins, dependent relink, installed cfg, compiler option or fixture changes | motor implementation and configured consumer snapshot | Release Verification 3 | All real required module/consumer checks rerun against the final combined identities and configuration | Pending |
| M20 / T5, G2 | Driver/source, device access or final motor/pmac configuration changes | Actual velocity, model-1 shutdown and pmac device/trajectory paths | Release Verification 4 | Required accepted driver/device methods actually run and pass; an idle or unrelated simulator is not sufficient | Pending |

##### Production Environment Tests

| Release Verification Label | Timing | System | Version | Architecture | Deployment Path | Method | Expected Result | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Release Verification 3 | post-change | Debian; Rocky Linux | 12 and 13; 8.10 | x86_64 | Exact 1.5.0 installed roots and setEpicsEnv.bash for each clean internal VM, resolve and accept before execution | Normal Stage 1 Layers 1-3 installation and all seven gates, then every active alliocs consumer, through epics-env-pipeline; on the same platforms and the final combined tree, the module and consumer runtime checks that the Integrated Verification map assigns to Release Verification 3 | Every gate, active consumer and assigned module/consumer runtime check passes on every required internal OS before release execution | Pending; per-OS gate table, source/ref identities, installed roots and complete consumer logs |
| Release Verification 3 | post-change | Rocky Linux; Ubuntu | 10; 24.04 and 26.04 | x86_64 | Exact 1.5.0 installed roots on fresh guests provisioned one at a time through the provisioning owner, resolve and accept before execution | Final-tree module and consumer runtime checks of the T labels that the Integrated Verification map assigns to Release Verification 3 through the real shipped drivers and original fixtures, including M15's original mca/measComp software cases | Every enabled check passes on the final combined tree on each platform | Pending; per-OS result table, driver bytes, raw logs and guest lifecycle records |
| Release Verification 4 | post-change | Debian; Rocky Linux | 13; 8.10 | x86_64 | Separate 1.5.0 candidate paths, resolve before execution | Full loader and fragment suites plus Milo recovery checks | Final-version runtime behavior passes | Pending |
| Release Verification 4 | post-change | Owner-supplied actual motor/pmac devices and driver environments | Exact driver/device/configuration identities supplied under G2 before acceptance | Actual target architectures supplied under G2 | Accepted private operational paths, identified before execution | Real motorActVelocity/RVEL, active model-1 shutdown, and pmac device/trajectory methods from M20 / T5 | Every required accepted device behavior has actual evidence | Pending; G2 Open |
| Release Verification 7 | post-release | Debian; Rocky Linux | 13; 8.10 | x86_64 | New clean verification paths, resolve during storage preflight | Published quick-start/build/install from actual release tag, then IOC data checks | Released objects reproduce documented behavior | Pending |

No production host deployment is implied. These are clean production-equivalent test environments; record concrete paths and availability before plan acceptance and execution.

For Release Verification 3, follow `epics-env-pipeline/SKILL.md`, `epics-env-pipeline/references/verification.md`, and `epics-env-pipeline/references/combinations.md`, resolved from the runtime's skill catalog. These runbooks own the installation procedure, gate methods, and consumer driver. Reconcile the expected inventory with the selected 1.5.0 sources and layer combination before the count check; earlier-version counts are not 1.5.0 evidence. Record all seven gate outcomes, check_deps exit status, the resolved alliocs commit and active consumer set, and complete real command outputs for each internal OS under Release Verification 3. Missing or failed checks keep that result Pending or Fail and prevent release execution. The six-OS code/build checks and the internal three-OS Layers 1-3 installation checks remain distinct; additional non-shipping layer/OS combinations are portability coverage under the runbook.

##### Version Changes

| Field | File | Before | Planned After | Pre-check | Pre-check Label | Post-check | Post-check Label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ENV_RELEASE_VERS | configure/CONFIG_SITE | 1.4.0 | 1.5.0 | Read the configured value and run the shipped make queries for the effective value and derived install roots before the branch-opening correction | Release Verification 1 | Read the configured value and repeat the same queries after correction; require the plain 1.5.0 value and path | Release Verification 2 |

`ENV_RELEASE_VERS` is an install-path component and must use the plain release number from branch opening. D9 corrects this branch's stale 1.4.0 value to 1.5.0 before development or integration installs. Apply and check this value at branch opening, then preserve it through release-eve; the generic final version-bump sequence does not defer this field. The branch-opening correction is carried by version-only commit bc184267f8f796973d033d5b95022f52e1eb9609. Release Verification 1-2 record only the actual source and make-query observations; actual installed-path and generated-version checks remain in Release Verification 3 and 7. All remaining M1-M5 plan acceptance and implementation authority remain as recorded.

##### Release Execution

| Step | Action | Authorization | Expected Result | Evidence |
| --- | --- | --- | --- | --- |
| 1 | Push the readiness-evidence commit (the release candidate) on release-1.5.0 | Separate git-workflow push authority | Exact candidate reachable on origin | Pending |
| 2 | Merge the accepted candidate into master | Previewed user-run action or exact Release scope | Recorded merge identity with required checks | Pending |
| 3 | Create annotated 1.5.0 tag at the explicitly selected release object | Previewed user-run action or exact Release scope | Immutable recorded tag and target identities | Pending |
| 4 | Push master, then push the exact tag | Separate push authority for master, then separate tag-push authority for the tag after master is on origin | Remote refs match accepted objects; the pushed history carries the `Closes #98` footer under D38 on the commit that carries it, recorded here at release preparation | Pending |
| 5 | Create GitHub release 1.5.0 with reviewed notes | Previewed user-run action or exact Release scope | Release names the verified tag | Pending |
| 6 | Reconcile linked issues and remote milestone; recheck the completed 20-issue Backlog reassignment | Applicable Issue scope for issues and their milestone assignment; the milestone close under the previewed Release scope or a user-run action | All 20 remain closed and belong to 1.5.0; other fields preserved | Backlog reassignment complete, observed 2026-10-06T22:12:25Z; final release reconciliation Pending |
| 7 | Record next-line disposition and cycle closure | Accepted next-line decision and separate commit authority | One clear next entry; published tag unchanged | Pending |

Exact commands and object IDs are prepared only after the final candidate and live tracker facts are known. Plan acceptance does not authorize these actions.

##### Release Verification Plan

| Label | Layer | Timing | Method | Environment | Expected Result | Evidence Target |
| --- | --- | --- | --- | --- | --- | --- |
| Release Verification 1 | Version | pre-change | Read configure/CONFIG_SITE and run shipped make queries for ENV_RELEASE_VERS, INSTALL_LOCATION_VER, and INSTALL_LOCATION_EPICS before the branch-opening correction | Release-branch working checkout | Exact prior value and derived paths recorded before correction | Source identity, observed time, query command and outputs |
| Release Verification 2 | Version | post-change | Read configure/CONFIG_SITE and repeat the same shipped make queries after the branch-opening correction | Release-branch working checkout | Plain 1.5.0 value and derived install paths; no -dev suffix | Source file, observed time, query command and outputs; recorded version-only commit |
| Release Verification 3 | Build and Installation | post-change | Recheck completed work evidence and version inventory; run real six-OS workflow paths, dependency audits, patch round trip, original upstream fixtures, all twelve retired pvxs protections, C17 comparisons, opt-in examples and the module checks and the enabled consumer checks of every T label that the Integrated Verification map assigns to Release Verification 3, each label on the platforms of its Test Plan Environment, M15's original mca/measComp software cases, and configured consumer IOC startup; then run the full internal installation checks defined in Production Environment Tests through epics-env-pipeline, including all seven gates, check_deps and every active alliocs consumer; verify actual 1.5.0 installed roots and generated version evidence | Code/build and module/consumer runtime: Debian 12/13, Rocky 8/10, Ubuntu 24.04/26.04 (Rocky Linux 10, Ubuntu 24.04 and Ubuntu 26.04 on fresh guests, one at a time, through the provisioning owner); internal Layers 1-3 installation: Debian 12/13, Rocky Linux 8.10 | All required code/build and module/consumer runtime checks, all seven installation gates and every active alliocs consumer pass against the final candidate on the existing 1.5.0 install path before release execution | Per-OS gate/result table and raw outputs, exact layer refs and source IDs, inventory expectations, alliocs commit/active set and complete logs, installed-path and version outputs, workflow URLs where applicable |
| Release Verification 4 | Runtime | post-change | Full shipped loader and fragment suites, Milo data/restart cases and G2's real motor/pmac driver/device methods from M20 / T5 | Debian 13 and Rocky Linux 8.10 plus G2's accepted actual driver/device environments | Accepted behavior on actual installed final libraries | Candidate identity, server digest, real IOC and client logs |
| Release Verification 5 | Docs | post-change | Build mdBook; execute changed user procedures; verify release comparison, active patch rows, shell lint and links | Final source and documented book image | Documentation and checks agree with final behavior | Book/lint logs and reviewed release notes |
| Release Verification 6 | Objects | post-release | Read remote tag object, peeled commit, GitHub release target and version contents | Canonical remote and released objects | Exact authorized identities, unchanged 1.4.0 objects | Observed time, immutable IDs and release URL |
| Release Verification 7 | Installation | post-release | Storage preflight, fresh tag-based install using documented path, verify actual 1.5.0 installed root and generated version evidence, then actual IOC data checks | Clean Debian 13 and Rocky Linux 8.10 environments | Published version installs and operates as documented | Filesystem measurements, tag IDs, installed-path and version outputs, install/runtime logs |
| Release Verification 8 | Closure | post-release | Re-read applicable tracker facts, including all 20 closed issue assignments to milestone 7; verify retained backlog, next-line decision and closure file | Repository and canonical remote | Complete evidence and consistent next entry | Read-back observations and closure commit |

##### Release Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| Release Verification 1 | 2026-10-07T03:13:42Z | Debian 13, release-1.5.0 working checkout at 727b966e6030ebbb9dea52faa7eb09cc4b518fd4 | Pass | configure/CONFIG_SITE and `make -s --no-print-directory print-ENV_RELEASE_VERS print-INSTALL_LOCATION_VER print-INSTALL_LOCATION_EPICS` from repository root, exit 0: effective value 1.4.0, version root `${INSTALL_LOCATION}/1.4.0`, EPICS root `${INSTALL_LOCATION}/1.4.0/debian-13/7.0.10`; this records the stale before-state only |
| Release Verification 2 | 2026-10-07T03:14:27Z | Debian 13, release-1.5.0 corrected working tree at observation | Pass | configure/CONFIG_SITE and the same shipped make query, exit 0: effective value 1.5.0, version root `${INSTALL_LOCATION}/1.5.0`, EPICS root `${INSTALL_LOCATION}/1.5.0/debian-13/7.0.10`; source/query checks only, no install or IOC run. Version-only commit bc184267f8f796973d033d5b95022f52e1eb9609 preserves the checked configuration |
| Release Verification 3 | Not run | Six Linux code/build and module/consumer runtime targets; internal Layers 1-3 installation, Gates 1-7 and alliocs on Debian 12/13 and Rocky Linux 8.10 | Pending | none |
| Release Verification 4 | Not run | Two runtime targets | Pending | none |
| Release Verification 5 | Not run | Final source and book image | Pending | none |
| Release Verification 6 | Not run | Released objects | Pending | none |
| Release Verification 7 | Not run | Clean released installations | Pending | none |
| Release Verification 8 | Not run | Repository and remote tracker | Pending | none |

##### Closure Evidence

None. D9 authorizes only the branch-opening configuration and release-plan correction. Release Verification 1-2 record its source and make-query checks; all combined-candidate and released-object checks remain Pending. M4 and M5 remain draft; D30 accepts the module plans only and records no implementation authority.

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
Last Compared: by 2026-10-08T15:30:30Z through the milestone-7 REST issue query; title, open state, enhancement label, jeonghanlee assignee, and milestone 1.5.0 match. The live body retains the earlier plan and requires projection of this detailed draft after the planning commit and separate git-workflow authority.
Prepared Body: `work/issue-150-release.md`
Publication: Existing issue remains published and open. This planning update changes no GitHub state; body projection follows the planning commit and separate git-workflow authority.


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
