# Work Register

Release line: master
Milestone index: d8dcbe1
Canonical path: `docs/milestone-d8dcbe1.md`
Canonical branch or ref: master
Git upstream: origin/master
Remote tracker: jeonghanlee/EPICS-env; no new release milestone assigned

Next session entry point: decide G1 (release number) and G2 (EPICS Base version) in this register, then open the release branch as `docs/procedures/release-procedure.md` step 1 sets out; M14, M15 and M16 resume as Not started after both gates close. The 11 Deferred Backlog items all have dedicated issues; activation requires a new dated decision. M2 is retired and is not a candidate for implementation.

This document carries unfinished work after release 1.5.0. Completed release results remain in the prior state named in History. No next release number or implementation assignment is established by this reset.

## Milestone

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| G1 | Release number of the next release | External gate | Open | No | | The maintainer records a dated decision that names the number; [detail](#g1---release-number-of-the-next-release) |
| G2 | EPICS Base version of the next release | External gate | Open | No | | The maintainer records a dated decision that names the Base pin; [detail](#g2---epics-base-version-of-the-next-release) |
| M14 | Update modbus to R3-5 | Milestone | Blocked | No | D5, G1, G2 | The module cycle passes on both test machines; [detail](#m14---update-modbus-to-r3-5) |
| M15 | Carry the uldaq-env timeout and alarm patches | Milestone | Blocked | No | D5, G1, G2 | Both patches are built and loaded through the vendor preparation; [detail](#m15---carry-the-uldaq-env-timeout-and-alarm-patches) |
| M16 | Move measComp to the jeonghanlee fork | Milestone | Blocked | No | D5, G1, G2 | The measComp cycle and the TC32 reconnection checks pass; [detail](#m16---move-meascomp-to-the-jeonghanlee-fork) |

Release tally: 3 assigned items (M14, M15, M16) and 2 open gates (G1, G2). All three items are Blocked by G1 and G2 and resume as Not started when both close. No GitHub milestone exists for this release yet.

### Milestone Details

#### G1 - Release number of the next release

Origin: d8dcbe1 / G1
GitHub Issue: none
Status: Open

##### Summary

The maintainer names the number of the next release by a dated decision: the patch number rises for a release of fixes only, and the minor number for a change of the module set or a feature (`docs/procedures/release-procedure.md`, step 1). The release carries a feature (the alarm configuration write of M15) and module source changes (M14, M16), so the minor number is the candidate. It gates M14, M15 and M16, because the release branch, the GitHub milestone and the release tracking issue open with that number.

##### Completion Criteria

- A Decisions row names the release number and its date.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| Not run | Pending | A dated Decisions row |

##### Closure Evidence

- none

#### G2 - EPICS Base version of the next release

Origin: d8dcbe1 / G2
GitHub Issue: none
Status: Open

##### Summary

The release pin of EPICS Base is `tags/R7.0.10`. On 2026-11-11 the tag `R7.0.11` exists (released 2026-10-27, 185 commits after `R7.0.10`), no tag `R7.0.12` exists, and the `7.0` branch holds seven commits after `R7.0.11`. The maintainer decides among moving to `R7.0.11`, waiting for a tag of the branch, and keeping `R7.0.10`. A move re-examines the downstream patches of EPICS base and pvxs together (`docs/procedures/upstream-fix-carry-procedure.md`, Bump obligation) and adds work rows for the Base and pvxs cycles. The choice gates M14, M15 and M16, because every module cycle runs on a tree built from the Base pin of the candidate.

##### Completion Criteria

- A Decisions row names the Base pin and its date; when it moves, the work rows of the Base and pvxs cycles exist.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| Not run | Pending | A dated Decisions row |

##### Closure Evidence

- none

#### M14 - Update modbus to R3-5

Origin: d8dcbe1 / M14
Identity History: none
GitHub Issue: #141 (https://github.com/jeonghanlee/EPICS-env/issues/141)
Status: Blocked

##### Summary

The pin of modbus is `tags/R3-4` (version 3.4.0, `4a1276b`). The tag `R3-5` (`47d9c40`), the head of the upstream `master` on 2026-11-11, is 17 commits ahead. They add a `ResetStatistics` record, an optional `PINI`, `DESC` fields with empty defaults in the templates, and output of the expected and actual values of a CRC error, print the debug address in decimal, fix `std::min` on Windows, and update the asyn and base entries of the module's `configure/RELEASE`. modbus carries no downstream patch. The module `motor` names `build.modbus` in its `_DEPS` line and is rebuilt with it.

##### Scope

Judge the compatibility of R3-5 with the asyn and Base of the release, decide IN or HOLD, move the pin and its version value, and run the module cycle.

Out of scope: other module updates and a change of the asyn pin.

##### Completion Criteria

- The module cycle of modbus passes on the Debian 13 and Rocky Linux 8.10 test machines: the clean rebuild of modbus and of motor, the patch round trip on a fresh clone, the module scripts of the loader verification suite with the site modules counted, `make check.deps`, `make check.env`, and the reverse-dependency search.

##### Dependencies And Decisions

D5, G1 and G2 apply. Resume as Not started when G1 and G2 are Complete.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Verify the repository-side claims: the pin, the version value, the dependents, and the library stems.
2. Judge the 17 commits against the asyn and Base of the release and record IN or HOLD.
3. Edit the pin and version value in `configure/RELEASE` and run the cycle with `tools/module-check/cycle.bash`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Module cycle | `tools/module-check/cycle.bash modbus MODBUS <candidate> <site checkout>` | Debian 13 and Rocky Linux 8.10 test machines | every row passes with `rc=0`, the dependent `motor` rebuilds, and no installed library outside the dependents needs a library of modbus |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |

##### Closure Evidence

- none

##### GitHub Projection

Title: Update modbus to R3-5
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-11-12 00:34 UTC, #141 created

#### M15 - Carry the uldaq-env timeout and alarm patches

Origin: d8dcbe1 / M15
Identity History: none
GitHub Issue: #142 (https://github.com/jeonghanlee/EPICS-env/issues/142); the related issues are jeonghanlee/uldaq-env#3 and jeonghanlee/uldaq-env#4
Status: Blocked

##### Summary

The vendor library ULDAQ stays at 1.2.2 (`a5094ec`, the tag `1.2.2` of `jeonghanlee/uldaq-env`, observed 2026-11-11). The distribution is to carry two more patches beside `patch/1.2.2-tcp-receive.p0.patch`, which exists today. The first adds device configuration items for the network connection timeout and the command timeout, set with `ulDevSetConfig()` and read with `ulDevGetConfig()`, with the default of 3000 ms (jeonghanlee/uldaq-env#3). Measured in measComp, a silent second TC32 stalls a healthy one for 6.1 to 6.3 seconds and then 3.1 seconds in every 5.5 seconds, and its request count over 20 seconds falls from 481 to 512 to 240 to 243. The second adds an alarm configuration write and read for the network TC32 and E-TC (jeonghanlee/uldaq-env#4). The upstream version string stays 1.2.0 in ULDAQ 1.2.2, so the build is identified by its source commit, patch state and library hash.

##### Scope

The patches are to be written and accepted in the `uldaq-env` repository under its two issues. This item carries their integration into the EPICS-env vendor preparation, the build and installation documents, and the checks of the installed tree.

Out of scope: the lock on the device registry `DaqDeviceManager::mCreatedDevicesMap`, the broadcast discovery wait, USB devices, TCP keepalive tuning, and changes to the protocol.

##### Completion Criteria

- The two patches exist in `uldaq-env` and meet the acceptance criteria of their issues.
- The vendor preparation of EPICS-env applies them before the build and installs the patched library, and the installed IOC loads it.
- The measComp build of M16 links the patched library.

##### Dependencies And Decisions

D5, G1 and G2 apply. Resume as Not started when G1 and G2 are Complete.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Develop and review the two patches in `uldaq-env`.
2. Integrate the patch stage into the vendor preparation of EPICS-env and update the build and installation documents.
3. Rebuild the vendor library on the test machines and run the checks below.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Vendor build | apply, revert and build the patched ULDAQ through the vendor preparation | Debian 13 and Rocky Linux 8.10 test machines | the patches apply and revert cleanly, and the library builds and installs |
| T2 | Timeouts | connect to an address that drops packets and command a device that stops answering, with configured timeouts | a network TC32 or its simulated endpoint | each call returns within 100 ms of the configured value, and the default stays 3000 ms |
| T3 | Alarm configuration | set an alarm configuration and read it back | a network TC32 and an E-TC | the configuration read equals the configuration written |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |
| T2 | Not run | a network TC32 or its simulated endpoint | Pending | none |
| T3 | Not run | a network TC32 and an E-TC | Pending | none |

##### Closure Evidence

- none

##### GitHub Projection

Title: Carry the uldaq-env timeout and alarm patches
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-11-12 00:34 UTC, #142 created

#### M16 - Move measComp to the jeonghanlee fork

Origin: d8dcbe1 / M16
Identity History: none
GitHub Issue: #120 (https://github.com/jeonghanlee/EPICS-env/issues/120)
Status: Blocked

##### Summary

TC32 reconnection (#120) is carried by moving the measComp pin from `c38974e` of `epics-modules/measComp` to the branch `site` of `jeonghanlee/measComp` (`1612c38`, observed 2026-11-11), which is 70 commits ahead and holds the reconnection work, its tests and documents. The clone URL changes with `SRC_BASE_MEASCOMP=$(SRC_URL_JEONGHANLEE)`, the way `SRC_BASE_SNMP` does. This replaces the method of #120, which keeps the old pin with three patches. Of the two current patches, `patch/measComp-CONFIG_MEASCOMP.p0.patch` applies to the fork (checked with `git apply --check` on 2026-11-11), and `patch/measComp-tc32-chan-count.p0.patch` neither applies nor reverses on it, so the plan decides whether each patch is kept, regenerated or dropped. The reconnect patch held outside the repository is not applied.

##### Scope

Move the pin and the URL, decide the fate of the two patches against the fork, rebuild measComp and its consumers, and verify TC32 reconnection on the integrated build.

Out of scope: real-hardware endurance beyond the checks listed here, EXP-32, USB, Windows and other models.

##### Completion Criteria

- The module cycle of measComp passes on both test machines at the fork pin with the patches the plan keeps.
- The real-driver transport regression of #120 passes on the integrated build, with its negative controls.
- On a real TC32 without EXP-32: offline IOC startup, repeated power cycles and network loss do not restart the IOC or replace valid samples, the input records carry INVALID alarms during the loss, and valid updates resume after recovery.

##### Dependencies And Decisions

D5, G1 and G2 apply. M15 supplies the configurable timeouts that remove the remaining three-second stall; M16 does not wait for it. Resume as Not started when G1 and G2 are Complete.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Compare the fork with the two patches and with the held reconnect patch, and record each patch as kept, regenerated or dropped.
2. Set the pin, the version value and `SRC_BASE_MEASCOMP`, and run the module cycle with `tools/module-check/cycle.bash`.
3. Run the transport regression and the hardware checks on the integrated build.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Module cycle | `tools/module-check/cycle.bash measComp MEASCOMP <candidate> <site checkout>` | Debian 13 and Rocky Linux 8.10 test machines | every row passes with `rc=0` |
| T2 | Transport regression | the real-driver reconnection fixture of the fork with its negative controls | Debian 13 test machine, the TC32 endpoint simulated | all positive assertions pass and each negative control fails as expected |
| T3 | Hardware | offline start, power cycles and network loss on a TC32 | a real TC32 without EXP-32 | no IOC restart, no invalid replacement samples, INVALID alarms during loss, valid updates after recovery |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |
| T2 | Not run | Debian 13 test machine | Pending | none |
| T3 | Not run | a real TC32 | Pending | none |

##### Closure Evidence

- none

##### GitHub Projection

Title: Restore TC32 reconnection with ULDAQ and measComp patches
Labels: bug
GitHub Milestone: Backlog
Observed State: open
Observed Labels: bug
Observed Milestone: Backlog
Last Compared: 2026-11-12 00:34 UTC, after the body of #120 was rewritten to the fork method

## Backlog

Backlog retains 13 rows: 11 Deferred items and two Complete items, excluded from the release tally. M7 is delivered; M2 is retired by decision D4, not implemented. None is Ready. Both closed items retain their evidence in this generation; activation of any unfinished item requires a new dated decision.

GitHub reconciliation observed on 2026-11-05 at 03:53 UTC: all 11 unfinished items have open dedicated issues. The seven newly linked issues #133 through #139 have milestone Backlog and assignee jeonghanlee; their bodies, titles, labels, and state match the prepared scope. M2 has a closed issue whose body now records cancellation under D4. M6 has its own issue #135, separate from the completed loader scope of #93. Recheck the inventory with `gh issue list -R jeonghanlee/EPICS-env --state all --limit 200 --json number,title,state,url`; the linked details carry the individual observations.

Reconciliation of [#120](https://github.com/jeonghanlee/EPICS-env/issues/120), Restore TC32 reconnection with ULDAQ and measComp patches: it is open in the GitHub milestone Backlog and is carried by M16 in the Milestone section; its body was rewritten to the fork method at 2026-11-12 00:26 UTC and its GitHub milestone is still Backlog.

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| M1 | EPICS Path primitives and Perl makeRPath | Carry-forward | Deferred | No | D1 | [Completion criteria](#m1---epics-path-primitives-and-perl-makerpath) |
| M2 | Publish commonIocsh as a module | Carry-forward | Complete | No | D4 | Retired, not implemented; [closure evidence](#m2---publish-commoniocsh-as-a-module) |
| M3 | Global IOC startup for common services | Carry-forward | Deferred | No | D1 | [Completion criteria](#m3---global-ioc-startup-for-common-services) |
| M4 | Libera cross-build and generated profile | Carry-forward | Deferred | No | D1 | [Completion criteria](#m4---libera-cross-build-and-generated-profile) |
| M5 | Patch revert on macOS | Carry-forward | Deferred | No | D1 | [Completion criteria](#m5---patch-revert-on-macos) |
| M6 | Original OPC UA demo startup data | Carry-forward | Deferred | No | D1 | [Completion criteria](#m6---original-opc-ua-demo-startup-data) |
| M7 | Report Base site fixes upstream | Carry-forward | Complete | No | D3 | [Closure evidence](#m7---report-base-site-fixes-upstream) |
| M8 | Milo as the OPC UA example default | Carry-forward | Deferred | No | D1 | [Completion criteria](#m8---milo-as-the-opc-ua-example-default) |
| M9 | Migrate recsync to reccaster | Carry-forward | Deferred | No | D1, D2 | [Completion criteria](#m9---migrate-recsync-to-reccaster) |
| M10 | Minimal-example record counting | Carry-forward | Deferred | No | D1 | [Completion criteria](#m10---minimal-example-record-counting) |
| M11 | Lua database loading without macros | Carry-forward | Deferred | No | D1 | [Completion criteria](#m11---lua-database-loading-without-macros) |
| M12 | Shared-library version identification | Carry-forward | Deferred | No | D1 | [Completion criteria](#m12---shared-library-version-identification) |
| M13 | Load pyDevSup through the IOC loader | Carry-forward | Deferred | No | D1 | [Completion criteria](#m13---load-pydevsup-through-the-ioc-loader) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Retain the 13 carried items as Deferred during the master reset. D3 corrects M7 using its prior completion evidence. A new dated decision is required to activate any unfinished item; the reset does not authorize implementation or a new release line. | 2026-11-04 |
| D2 | Keep recsync at 9834b94edc63eece42712b8355a4703d4286dd8f until the separately scoped client migration. From 1.10.0 the recsync repository contains a stub client Makefile that exits 1; the client moved to ChannelFinder/reccaster, whose 1.9.7 commit bebf91f54faf93a59eb4538d3594a687a8823963 has no shared history with the pin. The repository switch is module source work tracked by #101. | 2026-10-11 |
| D3 | Correct M7 to Complete from the two upstream reports and commit 0038fa68e3e2b507d3935738d46050bb86ce9896. Retain the other 12 items as Deferred; the closed state of #76 alone does not establish M2 completion or retirement. This reconciliation authorizes no implementation or GitHub mutation. | 2026-11-04 |
| D4 | Do not split commonIocsh into a separate public module. Retire M2 without implementation; #76 was deliberately closed for this reason. Waive its repository creation, module pinning, installation, and verification requirements. This supersedes the M2 deferral in D1 and D3; the other 11 unfinished items remain Deferred. | 2026-11-04 |
| D5 | Activate three items for the next release without a release number: M14, modbus from `tags/R3-4` to `tags/R3-5`; M15, the uldaq-env patches for the network timeouts and for the TC32 and E-TC alarm configuration write, with ULDAQ staying at 1.2.2; and M16, measComp from the branch `site` of `jeonghanlee/measComp`, which carries #120 by this method and replaces its plan of keeping the pin `c38974e` with three patches. The release number (G1) and the EPICS Base version (G2) are not decided and stay Open gates. This activation authorizes no implementation, GitHub issue, milestone, or commit. | 2026-11-11 |

### Backlog Details

#### M1 - EPICS Path primitives and Perl makeRPath

Origin: d8dcbe1 / M1
Identity History: none
GitHub Issue: #25 (https://github.com/jeonghanlee/EPICS-env/issues/25)
Status: Deferred

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 25 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

A local base patch removes no prerequisite, because the build already runs `makeRPath.py` under `python3` and needs `python3` to read its configuration; the value is the Base path toolkit

##### Scope

Remove the `makeRPath` Python dependency through additive `EPICS::Path` primitives (`Normalize`, `RelPath`) and a Perl `makeRPath`, pursued as an upstream epics-base submission.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The upstream submission defines the additive path primitives and Perl makeRPath behavior, with real build-path verification.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M2 - Publish commonIocsh as a module

Origin: d8dcbe1 / M2
Identity History: none
GitHub Issue: #76 (https://github.com/jeonghanlee/EPICS-env/issues/76)
Status: Complete

GitHub state observed: CLOSED on 2026-11-05 at 03:53 UTC. The body records cancellation under D4, with label wontfix and assignee jeonghanlee. Recheck with `gh issue view 76 -R jeonghanlee/EPICS-env --json state,body,labels,assignees`. The earlier deferral comment is historical.

##### Summary

The separate-module proposal is retired. Keep the commonIocsh fragments in this repository; no promotion is planned.

##### Scope

Retired proposal: promote the commonIocsh fragments to a dedicated public module repository, pinned like every other module.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- Original delivery criterion, waived by D4: the commonIocsh fragments have a public module repository and an integrated, pinned source declaration with verified installation.

Closure is by retirement, not delivery.

##### Dependencies And Decisions

D4 retires this proposal on 2026-11-04 and supersedes its prior deferral. Reopening requires a new dated decision.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

No implementation is planned; the proposal is retired under D4.

##### Test Plan

D4 waives verification of the proposed repository, pin, installation, and installed paths because the split will not be implemented.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No implementation or acceptance test is claimed. Closure rests on the dated retirement decision below.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

Retirement Decision Date: 2026-11-04. D4 confirms that #76 was deliberately closed and that the separate-module work will not be done. Repository creation, module pinning, installation, and installed-path verification are waived. Status Complete records retirement only, not delivery.

#### M3 - Global IOC startup for common services

Origin: d8dcbe1 / M3
Identity History: none
GitHub Issue: #79 (https://github.com/jeonghanlee/EPICS-env/issues/79)
Status: Deferred

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 79 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

The fragment set ships without one; the common services are verified loading together by the integrated suite

##### Scope

Ship a global iocsh startup file for the common services.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- A global startup file loads the intended common services and passes their integrated verification.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M4 - Libera cross-build and generated profile

Origin: d8dcbe1 / M4
Identity History: none
GitHub Issue: #133 (https://github.com/jeonghanlee/EPICS-env/issues/133)
Status: Deferred

##### Summary

Needs the real nine-module cross-build; the Libera reference is `docs/libera-cross-build.md`

##### Scope

Verify the Libera cross-build and the generated profile.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The actual nine-module cross-build and generated profile pass the checks in docs/libera-cross-build.md.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

The required inputs and verification requirements are in [Libera cross-build reference](libera-cross-build.md).

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M5 - Patch revert on macOS

Origin: d8dcbe1 / M5
Identity History: none
GitHub Issue: #134 (https://github.com/jeonghanlee/EPICS-env/issues/134)
Status: Deferred

##### Summary

Linux results do not verify macOS execution; the Darwin mca path stays in the code

##### Scope

Verify the patch revert on actual macOS.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- Actual macOS patch apply/revert execution verifies the Darwin mca path and clean restored sources.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M6 - Original OPC UA demo startup data

Origin: d8dcbe1 / M6
Identity History: none
GitHub Issue: #135 (https://github.com/jeonghanlee/EPICS-env/issues/135)
Status: Deferred

Related issue: [#93](https://github.com/jeonghanlee/EPICS-env/issues/93), observed CLOSED on 2026-11-05 at 03:05 UTC. Its acceptance text and closure comment explicitly leave the original Unified Automation startup data path outside the completed loader scope. It is not a dedicated issue for this item. Recheck with `gh issue view 93 -R jeonghanlee/EPICS-env --json state,body,comments`.

##### Summary

The 69 nodes of its databases come from the Unified Automation example server, which needs a registered download; a server written to imitate those nodes would be a stand-in

##### Scope

Read the original `opcua-IOC-demo` startup data path.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The original demo startup data path is documented from the real Unified Automation server and its 69 database nodes.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M7 - Report Base site fixes upstream

Origin: d8dcbe1 / M7
Identity History: none
GitHub Issue: #113 (https://github.com/jeonghanlee/EPICS-env/issues/113)
Status: Complete

##### Summary

Both Base site fixes have upstream reports: [epics-base#1033](https://github.com/epics-base/epics-base/issues/1033) for `yyerror()` and [epics-base#1034](https://github.com/epics-base/epics-base/issues/1034) for `dbRecordField()`. Commit `0038fa68e3e2b507d3935738d46050bb86ce9896`, included in master, records both reports in `patch/README.md`.

##### Scope

Report the two EPICS base site patches (`7.0.10-site01-dbyacc-eof`, `7.0.10-site02-dbstatic-device-menu`) upstream.

Out of scope: upstream acceptance, removing the carried patches, and changes to published release tags. Reporting is complete even while the upstream issues remain open.

##### Completion Criteria

- An upstream issue or pull request exists for each of the two named Base site fixes.

##### Dependencies And Decisions

D3 corrects the stale Deferred status on 2026-11-04 using existing delivery evidence. No implementation is activated by this correction.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

No new implementation plan is proposed. The reports and documentation commit predate this status correction; their original acceptance criteria and closure evidence remain in #113.

##### Test Plan

Reconciliation checks establish report publication and the local documentation references. They do not rerun the crash reproductions or claim upstream acceptance.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | External record | Read issues 1033 and 1034 with `gh issue view` in epics-base/epics-base | GitHub | Each named fault has its own published report |
| T2 | Repository | Inspect commit 0038fa68e3e2b507d3935738d46050bb86ce9896 and the two Upstream rows in patch/README.md; check commit ancestry against HEAD | Local master | Both issue numbers are recorded and the commit is included in master |
| T3 | External record | Read #113 body, state, and closure comment with `gh issue view` | GitHub | The tracking issue is closed with evidence for each reporting criterion |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-05 03:05 UTC | GitHub | Pass | #1033 and #1034 exist with the matching fault titles; both were OPEN at observation |
| T2 | 2026-11-05 03:05 UTC | Local master | Pass | Commit 0038fa68e3e2b507d3935738d46050bb86ce9896 contains both references and is an ancestor of HEAD; both references remain in patch/README.md |
| T3 | 2026-11-05 03:05 UTC | GitHub | Pass | #113 is CLOSED; its 2026-11-02 closure comment identifies the reports and documentation commit |

##### Closure Evidence

The two published upstream reports and commit `0038fa68e3e2b507d3935738d46050bb86ce9896` satisfy the reporting scope. [The closure comment](https://github.com/jeonghanlee/EPICS-env/issues/113#issuecomment-6581732670) records completion of the final criterion. Recheck with `gh issue view 113 -R jeonghanlee/EPICS-env --json state,body,comments`. Both site patches remain carried until an upstream release contains the fixes; that later removal is outside this completed item.

#### M8 - Milo as the OPC UA example default

Origin: d8dcbe1 / M8
Identity History: none
GitHub Issue: #99 (https://github.com/jeonghanlee/EPICS-env/issues/99)
Status: Deferred

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 99 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

Example and documentation work, not a module-set change

##### Scope

Make Eclipse Milo the default server of the OPC UA loader example.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The OPC UA loader example uses Eclipse Milo by default, with matching instructions and real example verification.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M9 - Migrate recsync to reccaster

Origin: d8dcbe1 / M9
Identity History: none
GitHub Issue: #101 (https://github.com/jeonghanlee/EPICS-env/issues/101)
Status: Deferred

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 101 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

Module source work outside a version bump (D2)

##### Scope

Migrate IOC record publishing from the recsync client to the reccaster repository.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The selected reccaster source replaces the recsync client with verified build, installation, and IOC publishing.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 and D2 apply. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M10 - Minimal-example record counting

Origin: d8dcbe1 / M10
Identity History: none
GitHub Issue: #136 (https://github.com/jeonghanlee/EPICS-env/issues/136)
Status: Deferred

##### Summary

A guest without `/sys/class/hwmon` adds linStat error lines to the count

##### Scope

Count only records in the loader suite's minimal example.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The minimal-example count includes records only, including on a machine without /sys/class/hwmon.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M11 - Lua database loading without macros

Origin: d8dcbe1 / M11
Identity History: none
GitHub Issue: #137 (https://github.com/jeonghanlee/EPICS-env/issues/137)
Status: Deferred

##### Summary

The defect sits in lua's database hook at the pin that 1.4.0 shipped and at `01aa7a1` alike; reporting it upstream or carrying a patch is decided when the work is assigned

##### Scope

Stop `dbLoadRecords` from crashing an IOC that loads lua when called without its macros argument.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The real IOC survives dbLoadRecords without macros while lua is loaded; the selected upstream fix or carry has verification evidence.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M12 - Shared-library version identification

Origin: d8dcbe1 / M12
Identity History: none
GitHub Issue: #138 (https://github.com/jeonghanlee/EPICS-env/issues/138)
Status: Deferred

##### Summary

The modules set no versioned `SONAME` (47 of the 54 distinct values in the Debian 13 tree are bare); the work decides the RUNPATH naming rule, the `SONAME` and ABI name rule, and how `check.deps` and `check.env` report a link

##### Scope

Decide how the installed shared libraries identify their version.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The agreed RUNPATH, SONAME/ABI, and dependency-reporting rules are documented and verified against real installed libraries.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M13 - Load pyDevSup through the IOC loader

Origin: d8dcbe1 / M13
Identity History: none
GitHub Issue: #139 (https://github.com/jeonghanlee/EPICS-env/issues/139)
Status: Deferred

##### Summary

An exploratory run loaded its library and database definition into the plain `softIoc` and processed a record; relocation, the library name that carries the Python version, and the loader rules are not examined

##### Scope

Load pyDevSup into a plain IOC through the loader.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The real loader starts pyDevSup in a plain IOC and verifies relocation, Python-version library naming, and loader selection.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

## History

| Reset Date | Prior State Commit |
| --- | --- |
| 2026-11-04 | d8dcbe12147842c34b8ec1f3f8187c18c6decc86 |
