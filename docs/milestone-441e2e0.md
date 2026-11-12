# Work Register

Release line: master
Milestone index: 441e2e0
Canonical path: `docs/milestone-441e2e0.md`
Canonical branch or ref: master
Git upstream: origin/master
Remote tracker: jeonghanlee/EPICS-env; the open issues are in the GitHub milestone Backlog

Next session entry point: take M1 (Port Python utilities to Perl, #140): draft its Implementation Plan in this register and obtain its acceptance before editing any tool.

This document carries unfinished work after release 1.5.0. Completed results remain in the prior state named in History. Work continues on master with no release branch (D2), and the rows are taken in table order.

## Milestone

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| M1 | Port Python utilities to Perl | Milestone | Not started | Yes | D2 | The scoped tools and their callers run without Python and match the existing results; [detail](#m1---port-python-utilities-to-perl) |
| M2 | Minimal-example record counting | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m2---minimal-example-record-counting) |
| M3 | Milo as the OPC UA example default | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m3---milo-as-the-opc-ua-example-default) |
| M4 | Global IOC startup for common services | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m4---global-ioc-startup-for-common-services) |
| M5 | Lua database loading without macros | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m5---lua-database-loading-without-macros) |
| M6 | EPICS Path primitives and Perl makeRPath | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m6---epics-path-primitives-and-perl-makerpath) |
| M7 | Move EPICS Base to R7.0.11 | Milestone | Not started | Yes | D2, D3 | Each Base patch is settled for the new pin and Base builds from it; [detail](#m7---move-epics-base-to-r7011) |
| M8 | Re-examine pvxs with the Base move | Milestone | Not started | No | D3, M7 | The pvxs pin and patches are settled and pvxs builds on the new Base; [detail](#m8---re-examine-pvxs-with-the-base-move) |
| M9 | Update modbus to R3-5 | Milestone | Not started | No | D2, D3, M7, M8 | The module cycle passes on both test machines; [detail](#m9---update-modbus-to-r3-5) |
| M10 | Carry the uldaq-env timeout and alarm patches | Milestone | Not started | No | D2, D3, M7, M8 | Both patches are built and loaded through the vendor preparation; [detail](#m10---carry-the-uldaq-env-timeout-and-alarm-patches) |
| M11 | Move measComp to the jeonghanlee fork | Milestone | Not started | No | D2, D3, M7, M8 | The measComp cycle and the TC32 reconnection checks pass; [detail](#m11---move-meascomp-to-the-jeonghanlee-fork) |
| M12 | Shared-library version identification | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m12---shared-library-version-identification) |
| M13 | Migrate recsync to reccaster | Carry-forward | Not started | Yes | D1, D2 | [Completion criteria](#m13---migrate-recsync-to-reccaster) |
| M14 | Load pyDevSup through the IOC loader | Carry-forward | Deferred | No | D4 | [Completion criteria](#m14---load-pydevsup-through-the-ioc-loader) |
| M15 | Patch revert on macOS | Carry-forward | Deferred | No | D4 | [Completion criteria](#m15---patch-revert-on-macos) |
| M16 | Original OPC UA demo startup data | Carry-forward | Deferred | No | D4 | [Completion criteria](#m16---original-opc-ua-demo-startup-data) |
| M17 | Libera cross-build and generated profile | Carry-forward | Deferred | No | D4 | [Completion criteria](#m17---libera-cross-build-and-generated-profile) |

Tally: 17 items, 13 Not started (M1 through M13) and 4 Deferred (M14 through M17). Ready: M1 through M7, M12 and M13. No gate is open.

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Keep recsync at 9834b94edc63eece42712b8355a4703d4286dd8f until the separately scoped client migration. From 1.10.0 the recsync repository contains a stub client Makefile that exits 1; the client moved to ChannelFinder/reccaster, whose 1.9.7 commit bebf91f54faf93a59eb4538d3594a687a8823963 has no shared history with the pin. The repository switch is module source work tracked by #101. | 2026-11-11 |
| D2 | Continue on master with no release branch and no release. Take the rows in table order, the lightest first and one at a time, and hand the work over when enough of it is complete. The release number and the tie of the Base pin to a publication date, recorded in the prior state, are not carried. | 2026-11-11 |
| D3 | Move EPICS Base from `tags/R7.0.10` to `tags/R7.0.11` as a work item (M7) and examine the pvxs pin and patches together with it (M8). | 2026-11-11 |
| D4 | Defer M14 through M17 and place them after the other rows: they need a pyDevSup exploration that is not yet scoped, a macOS machine, a registered download of the Unified Automation example server, or a real nine-module cross-build. A new dated decision returns one of them to Not started. | 2026-11-11 |

### Milestone Details

#### M1 - Port Python utilities to Perl

Origin: 441e2e0 / M1
Identity History: none
GitHub Issue: #140 (https://github.com/jeonghanlee/EPICS-env/issues/140)
Status: Not started

##### Summary

Replace the repository-maintained Python utilities and the Python helpers embedded in Bash tools with Perl, so that verification needs no separate Python runtime or newer Python version.

##### Scope

Replace `tools/tree-manifest.py`, `tools/verify_tree_manifest.py`, `tools/verify_test_trash.py`, `tools/linstat-carry/verify.py` and `examples/commonIocsh/verify_caputlog.py`, and the embedded Python helpers of `tools/install-distribution.bash` (the site dependency audit JSON) and `examples/commonIocsh/tests/verify_caputlog.sh` (the TCP port selection). Keep the Bash entrypoints. Update callers, documentation, and distribution skill instructions.

Out of scope: the build requirements of upstream modules and the Python-based EPICS support modules; the work does not claim that the whole EPICS build is Python-free.

##### Completion Criteria

- The oldest supported Perl interpreter and the required modules are confirmed on the supported target operating systems.
- Command arguments, exit behavior, output contracts, and recorded data formats are preserved, and existing manifest records remain compatible.
- The real replacement tools and fixtures run and their observable results match the existing Python implementations, with the failure-path coverage and the real IOC verification retained.
- The site-enabled and site-disabled installer paths are verified, including accepted source findings and rejected dependency failures.
- No Python invocation remains in the scoped tools and their callers, and the prerequisites and instructions are updated.

##### Dependencies And Decisions

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is taken.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M2 - Minimal-example record counting

Origin: 441e2e0 / M2
Identity History: none
GitHub Issue: #136 (https://github.com/jeonghanlee/EPICS-env/issues/136)
Status: Not started

##### Summary

A guest without `/sys/class/hwmon` adds linStat error lines to the count

##### Scope

Count only records in the loader suite's minimal example.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The minimal-example count includes records only, including on a machine without /sys/class/hwmon.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M3 - Milo as the OPC UA example default

Origin: 441e2e0 / M3
Identity History: none
GitHub Issue: #99 (https://github.com/jeonghanlee/EPICS-env/issues/99)
Status: Not started

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

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M4 - Global IOC startup for common services

Origin: 441e2e0 / M4
Identity History: none
GitHub Issue: #79 (https://github.com/jeonghanlee/EPICS-env/issues/79)
Status: Not started

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

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M5 - Lua database loading without macros

Origin: 441e2e0 / M5
Identity History: none
GitHub Issue: #137 (https://github.com/jeonghanlee/EPICS-env/issues/137)
Status: Not started

##### Summary

The defect sits in lua's database hook at the pin that 1.4.0 shipped and at `01aa7a1` alike; reporting it upstream or carrying a patch is decided when the work is assigned

##### Scope

Stop `dbLoadRecords` from crashing an IOC that loads lua when called without its macros argument.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The real IOC survives dbLoadRecords without macros while lua is loaded; the selected upstream fix or carry has verification evidence.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M6 - EPICS Path primitives and Perl makeRPath

Origin: 441e2e0 / M6
Identity History: none
GitHub Issue: #25 (https://github.com/jeonghanlee/EPICS-env/issues/25)
Status: Not started

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

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M7 - Move EPICS Base to R7.0.11

Origin: 441e2e0 / M7
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

The pin of EPICS Base is `tags/R7.0.10`. On 2026-11-11 the tag `R7.0.11` exists (released 2026-10-27, 185 commits after `R7.0.10`). Patches are named for the pinned version and the patch rule applies only `patch/<SRC_VER>-*.p0.patch`, so moving the pin drops the set unless each patch is renamed, re-based, or dropped (`docs/procedures/upstream-fix-carry-procedure.md`, Bump obligation).

##### Scope

Move `SRC_TAG_BASE` and `SRC_VER_BASE` in `configure/RELEASE` to `tags/R7.0.11` and `7.0.11`, and settle each of the 21 Base patches named `7.0.10-*` (18 upstream fixes and 3 site patches) under the Bump obligation.

Out of scope: a move to any tag after `R7.0.11`, the pvxs pin (M8), and module updates.

##### Completion Criteria

- Each downstream Base patch is renamed, re-based, or dropped for `tags/R7.0.11` under the Bump obligation.
- EPICS Base builds from the new pin.

##### Dependencies And Decisions

D2 and D3 apply.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is taken.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M8 - Re-examine pvxs with the Base move

Origin: 441e2e0 / M8
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

pvxs is pinned at `tags/1.5.3` with two patches, `1.5.3-01-7176098-single-put-marked-value` and `1.5.3-02-96345dd-tcp-listener-backlog`. EPICS Base and pvxs move together under the Bump obligation of `docs/procedures/upstream-fix-carry-procedure.md`.

##### Scope

Examine the pvxs pin and its two patches together with the Base move of M7, and settle each patch.

Out of scope: module updates and a pvxs version change that M7 does not require.

##### Completion Criteria

- The pvxs pin and each of its patches are settled under the Bump obligation.
- pvxs builds on the Base of the new pin.

##### Dependencies And Decisions

D3 applies. It waits for M7.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is taken.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M9 - Update modbus to R3-5

Origin: 441e2e0 / M9
Identity History: none
GitHub Issue: #141 (https://github.com/jeonghanlee/EPICS-env/issues/141)
Status: Not started

##### Summary

The pin of modbus is `tags/R3-4` (version 3.4.0, `4a1276b`). The tag `R3-5` (`47d9c40`), the head of the upstream `master` on 2026-11-11, is 17 commits ahead. They add a `ResetStatistics` record, an optional `PINI`, `DESC` fields with empty defaults in the templates, and output of the expected and actual values of a CRC error, print the debug address in decimal, fix `std::min` on Windows, and update the asyn and base entries of the module's `configure/RELEASE`. modbus carries no downstream patch. The module `motor` names `build.modbus` in its `_DEPS` line and is rebuilt with it.

##### Scope

Judge the compatibility of R3-5 with the asyn and the Base pin of M7, decide IN or HOLD, move the pin and its version value, and run the module cycle.

Out of scope: other module updates and a change of the asyn pin.

##### Completion Criteria

- The module cycle of modbus passes on the Debian 13 and Rocky Linux 8.10 test machines: the clean rebuild of modbus and of motor, the patch round trip on a fresh clone, the module scripts of the loader verification suite with the site modules counted, `make check.deps`, `make check.env`, and the reverse-dependency search.

##### Dependencies And Decisions

D2 and D3 apply. The cycle runs on the tree of the Base pin, so it waits for M7 and M8.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Verify the repository-side claims: the pin, the version value, the dependents, and the library stems.
2. Judge the 17 commits against the asyn and the Base pin of M7 and record IN or HOLD.
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

#### M10 - Carry the uldaq-env timeout and alarm patches

Origin: 441e2e0 / M10
Identity History: none
GitHub Issue: #142 (https://github.com/jeonghanlee/EPICS-env/issues/142); the related issues are jeonghanlee/uldaq-env#3 and jeonghanlee/uldaq-env#4
Status: Not started

##### Summary

The vendor library ULDAQ stays at 1.2.2 (`a5094ec`, the tag `1.2.2` of `jeonghanlee/uldaq-env`, observed 2026-11-11). The distribution is to carry two more patches beside `patch/1.2.2-tcp-receive.p0.patch`, which exists today. The first adds device configuration items for the network connection timeout and the command timeout, set with `ulDevSetConfig()` and read with `ulDevGetConfig()`, with the default of 3000 ms (jeonghanlee/uldaq-env#3). Measured in measComp, a silent second TC32 stalls a healthy one for 6.1 to 6.3 seconds and then 3.1 seconds in every 5.5 seconds, and its request count over 20 seconds falls from 481 to 512 to 240 to 243. The second adds an alarm configuration write and read for the network TC32 and E-TC (jeonghanlee/uldaq-env#4). The upstream version string stays 1.2.0 in ULDAQ 1.2.2, so the build is identified by its source commit, patch state and library hash.

##### Scope

The patches are to be written and accepted in the `uldaq-env` repository under its two issues. This item carries their integration into the EPICS-env vendor preparation, the build and installation documents, and the checks of the installed tree.

Out of scope: the lock on the device registry `DaqDeviceManager::mCreatedDevicesMap`, the broadcast discovery wait, USB devices, TCP keepalive tuning, and changes to the protocol.

##### Completion Criteria

- The two patches exist in `uldaq-env` and meet the acceptance criteria of their issues.
- The vendor preparation of EPICS-env applies them before the build and installs the patched library, and the installed IOC loads it.
- The measComp build of M11 links the patched library.

##### Dependencies And Decisions

D2 and D3 apply. The cycle runs on the tree of the Base pin, so it waits for M7 and M8.

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

#### M11 - Move measComp to the jeonghanlee fork

Origin: 441e2e0 / M11
Identity History: none
GitHub Issue: #120 (https://github.com/jeonghanlee/EPICS-env/issues/120)
Status: Not started

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

D2 and D3 apply. M10 supplies the configurable timeouts that remove the remaining three-second stall; M11 does not wait for it. The cycle runs on the tree of the Base pin, so it waits for M7 and M8.

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

#### M12 - Shared-library version identification

Origin: 441e2e0 / M12
Identity History: none
GitHub Issue: #138 (https://github.com/jeonghanlee/EPICS-env/issues/138)
Status: Not started

##### Summary

The modules set no versioned `SONAME` (47 of the 54 distinct values in the Debian 13 tree are bare); the work decides the RUNPATH naming rule, the `SONAME` and ABI name rule, and how `check.deps` and `check.env` report a link

##### Scope

Decide how the installed shared libraries identify their version.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The agreed RUNPATH, SONAME/ABI, and dependency-reporting rules are documented and verified against real installed libraries.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M13 - Migrate recsync to reccaster

Origin: 441e2e0 / M13
Identity History: none
GitHub Issue: #101 (https://github.com/jeonghanlee/EPICS-env/issues/101)
Status: Not started

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 101 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

Module source work outside a version bump (D1)

##### Scope

Migrate IOC record publishing from the recsync client to the reccaster repository.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The selected reccaster source replaces the recsync client with verified build, installation, and IOC publishing.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 and D2 apply.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M14 - Load pyDevSup through the IOC loader

Origin: 441e2e0 / M14
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

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

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

#### M15 - Patch revert on macOS

Origin: 441e2e0 / M15
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

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

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

#### M16 - Original OPC UA demo startup data

Origin: 441e2e0 / M16
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

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

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

#### M17 - Libera cross-build and generated profile

Origin: 441e2e0 / M17
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

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

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

## Backlog

No work is unassigned.

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |

### Backlog Details

None.

## History

| Reset Date | Prior State Commit |
| --- | --- |
| 2026-11-11 | 441e2e08467b3af7668a605c1447f5d07d23bce9 |
