# Work Register

Release line: master
Milestone index: d8dcbe1
Canonical path: `docs/milestone-d8dcbe1.md`
Canonical branch or ref: master
Git upstream: origin/master
Remote tracker: jeonghanlee/EPICS-env; no new release milestone assigned

Next session entry point: reconcile the existing TC32 reconnection issue #120 with this register before selecting work. The 11 Deferred Backlog items below all have dedicated issues; activation requires a new dated decision. M2 is retired and is not a candidate for implementation.

This document carries unfinished work after release 1.5.0. Completed release results remain in the prior state named in History. No next release number or implementation assignment is established by this reset.

## Milestone

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |

No assigned work remains from release 1.5.0. Release tally: 0 assigned items. The work register reset and its dependent links are published on master.

## Backlog

Backlog retains 13 rows: 11 Deferred items and two Complete items, excluded from the release tally. M7 is delivered; M2 is retired by decision D4, not implemented. None is Ready. Both closed items retain their evidence in this generation; activation of any unfinished item requires a new dated decision.

GitHub reconciliation observed on 2026-11-05 at 03:53 UTC: all 11 unfinished items have open dedicated issues. The seven newly linked issues #133 through #139 have milestone Backlog and assignee jeonghanlee; their bodies, titles, labels, and state match the prepared scope. M2 has a closed issue whose body now records cancellation under D4. M6 has its own issue #135, separate from the completed loader scope of #93. Recheck the inventory with `gh issue list -R jeonghanlee/EPICS-env --state all --limit 200 --json number,title,state,url`; the linked details carry the individual observations.

Remaining reconciliation: [#120](https://github.com/jeonghanlee/EPICS-env/issues/120), Restore TC32 reconnection with ULDAQ and measComp patches, is already open in Backlog but has no work row in this register. It is separate from the 11 items above and has not been duplicated or assigned by this issue-registration update.

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
