# Work Register

Release line: 1.5.0
Milestone index: 1.5.0
Canonical path: `docs/milestone-1.5.0.md`
Canonical branch or ref: `release-1.5.0`
Git upstream: `origin/release-1.5.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.5.0, number 7

Next session entry point: The makeRPath work (M1) moved to the Backlog on 2026-10-11 (D29, D30); the cycle starts with M9 (pvxs). Review each module plan (M9 to M18) and the release plan (M19) under the plan procedure, recording acceptance and implementation authority separately; implementation then starts with M9. The M9 plan was reviewed on 2026-10-11 and 2026-10-12 in third-person and second-person passes with the findings applied (D31, D32) and was accepted on 2026-10-12; its implementation was authorized the same day; the baseline guests of D32 are built, the candidate e19efe7 landed on origin, T1 to T5 passed on 2026-10-12, #102 is closed, and M9 is Complete; M15 lost its upstream test-suite items under D31. The bodies of #102 and #108 were projected from the register on 2026-10-12 and observed updated the same day. D32 is the build environment rule of every incremental module check: the two epics-dev guests of the 1.4.0 form, never a container. The GitHub projection of D28 is executed and observed on 2026-10-11: issues #102 to #110 project M9 to M17, #97 (reopened) projects M18, #100 projects M19, #99 (M20) and #101 (M21) sit in the Backlog milestone, and #98 is closed as superseded; #25 (M1) sits in the Backlog milestone and #100 names the makeRPath work as upstream work outside the release, both observed on 2026-10-11. The Layer 2 and Layer 3 sessions were told on 2026-10-11 that the selection is settled; G1 and G2 stay Open until their owners open the lines. Milestone tally: 14 rows, Complete 4 (M9, M10, M11, M22), Not started 7, Blocked 1 (M19 on G1 and G2), external gates Open 2; Ready now: M12, M14, M15, M17, M18. The M10 plan was reviewed on 2026-10-12 (four installed consumers, not five; observables for the relink; the guest scripts as the method), accepted and authorized the same day; its candidate f809b08 landed, T1 to T6 passed on 2026-10-12 and are recorded, #103 is closed, and M10 is Complete; its closure commit is 809e447, landed on `origin/release-1.5.0` on 2026-10-12. The M11 plan was reviewed on 2026-10-12 in third-person and second-person passes with the findings applied (the installed-tree census: six calc-linked objects in asyn, mca, measComp, and StreamDevice, pmac by metadata only; eight engine fixes, not seven; the guest scripts and the loader suite as the method; the installed-tree page examples change with the pin), was accepted on 2026-10-12, and its implementation was authorized the same day; the candidate 980e12b landed on `origin/release-1.5.0` with the plan record 7f308e9, T1 to T6 passed on 2026-10-12 and 2026-10-13 and are recorded, #104 is closed, and M11 is Complete; its closure commit is recorded by the next register commit. The calc update added two rules to `docs/procedures/module-bump-procedure.md`, 51f8a01 (a make dry run is not a read-only probe of a built tree) and 35d3ebb (dependents of a bumped module rebuild from clean), and the next module plan review is M12 (busy). M22 completed through that run: the three scripts carried M10 unchanged. The M9 closure commit is 1223168, landed on `origin/release-1.5.0` on 2026-10-12. Backlog: 12 rows (M1 to M8, M20, M21, M23, M24), all Deferred. D33 of 2026-10-12 adds M22, the module check runbook and scripts that run after M9 and before M10, and Backlog M23, the loader suite's record-count fix. D34 of 2026-10-12 has each step end by reinforcing the procedures it changed and collects the other lessons in Backlog M24. `ENV_RELEASE_VERS` is 1.5.0 in `configure/CONFIG_SITE` since 8a603bb, the first commit of this line. The module survey of 2026-10-11 is recorded in D11 to D24 and in the module details. References of the form `84ee626 M<n>`, `84ee626 D<n>`, or `84ee626 M<n> / T<k>` point to `docs/milestone-84ee626.md` at `4d521e7`; references of the form `1.4.0 M<n>` or `1.4.0 D<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Modules | M9 | Update pvxs to 1.5.3 and retire its carry set | Milestone | Complete | No | D12, D26, D31, D32 | `configure/RELEASE` pins `tags/1.5.3`, no `patch/1.5.2-*` file remains and `patch/README.md` agrees, pvxs rebuilds and installs on both incremental platforms, the patch round trip and the loader suite pass; [detail](#m9---pvxs-update) |
| Modules | M10 | Update sscan to ce9660c | Milestone | Complete | No | D14, D26, D31, D32, D33 | sscan rebuilds from the new pin, its four installed consumers relink with their metadata and RUNPATH naming the new pin, the patch round trip and the loader suite pass, and the installed-tree checks pass; [detail](#m10---sscan-update) |
| Modules | M11 | Update calc to R3-8 | Milestone | Complete | No | M10, D13, D26, D31, D32, D33 | calc rebuilds from the new pin as `calc-3.8.0`, its five dependents rebuild with their metadata and the six calc-linked objects naming the new pin, the patch round trip and the loader suite pass, and the installed-tree checks pass; [detail](#m11---calc-update) |
| Modules | M12 | Update busy to a4a272d | Milestone | Not started | Yes | D17, D26, D32 | busy builds with its cfg-based build system, installs `cfg/BUSY_DEPS`, its dependents relink, the Ubuntu 26 C17 bridge question is answered by real builds, and the installed-tree checks pass; [detail](#m12---busy-update) |
| Modules | M13 | Update scaler to baa8e1c | Milestone | Not started | No | M12, D18, D26, D32 | scaler builds with its cfg-based build system, installs `cfg/SCALER_DEPS`, mca and measComp relink, and the installed-tree checks pass; [detail](#m13---scaler-update) |
| Modules | M14 | Update std to 27b6967 | Milestone | Not started | Yes | D15, D26, D32 | std rebuilds from the new pin, mca and measComp reconfigure against it, a throttle record processes in a started IOC, and the installed-tree checks pass; [detail](#m14---std-update) |
| Modules | M15 | Update lua to 01aa7a1 | Milestone | Not started | Yes | D16, D26, D31, D32 | lua builds from the new pin on every CI OS, the Ubuntu 26 C17 bridge question is answered by real builds, and the installed-tree checks pass; [detail](#m15---lua-update) |
| Modules | M16 | Update motor to 4b22ac9 | Milestone | Not started | No | M12, M15, D19, D26, D32 | motor rebuilds from the new pin, motorMotorSim and pmac relink, a simulated motor moves in a started IOC, and the installed-tree checks pass; [detail](#m16---motor-update) |
| Modules | M17 | Update caPutLog to R4.2 | Milestone | Not started | Yes | D20, D26, D32 | caPutLog rebuilds from the release tag, the commonIocsh caPutLog checks and the pyDevSup relink pass, and the installed-tree checks pass; [detail](#m17---caputlog-update) |
| Modules | M18 | Update pyDevSup to 2.1.0 | Milestone | Not started | Yes | D21, D26, D32 | pyDevSup rebuilds from the release tag, a Python device-support record processes in a started IOC, and the installed-tree checks pass; [detail](#m18---pydevsup-update) |
| Procedure | M22 | Keep the module check runbook and scripts | Milestone | Complete | No | M9, D32, D33 | The three scripts under `tools/module-check/` and the Stage 6 section exist, pass their static checks, and carry the sscan update's checks on both guests with no edit beyond arguments; [detail](#m22---module-check-runbook) |
| Release | G1 | Layer 2 (EPICS-env-support) release line and tag for 1.5.0 | External gate | Open | No | | The Layer 2 owner opens a 1.5.0 line and tags it after the Layer 1 module selection is settled; [detail](#g1---layer-2-release-line) |
| Release | G2 | Layer 3 (site modules) release line and tag for 1.5.0 | External gate | Open | No | | The Layer 3 owner opens a 1.5.0 line and tags it after the Layer 1 module selection is settled; [detail](#g2---layer-3-release-line) |
| Release | M19 | Verify and publish EPICS-env 1.5.0 | Milestone | Blocked | No | M9, M10, M11, M12, M13, M14, M15, M16, M17, M18, G1, G2, D25, D26 | Every Release Verification row is Pass, the release objects exist with recorded identities, GitHub milestone 7 is closed, and the next line's canonical path is recorded; [detail](#m19---release-epics-env-150) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Open the 1.5.0 release line on `release-1.5.0` from master `4d521e7` for a module-set update, the case the 1.4.0 closure reserved for 1.5.0. This register is the reset of the master register `docs/milestone-84ee626.md`; the module survey and the IN/HOLD selection for 1.5.0 run on this line, and an earlier 1.5.0 register that is not on this line is not a source of this document. | 2026-10-10 |
| D2 | Assign the makeRPath work (#25) to the Milestone: remove the `makeRPath` Python dependency through additive `EPICS::Path` primitives, delivered as a local patch on the pinned EPICS base. Its earlier ordering dependency, the installed-tree relocation work (84ee626 M16), is Complete. | 2026-10-02 |
| D3 | The durable home for the commonIocsh fragments and the global iocsh is a dedicated public module named `commonIocsh`, its own repository pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP`; per-module patching is not used. Interim: the fragments are developed and held in EPICS-env until the promotion. | 2026-09-12 |
| D4 | Defer the D3 promotion of commonIocsh to its public module (public repository and RELEASE pin). The 1.4.0 fragment work (1.4.0 M6) completed on the interim EPICS-env home with its verification satisfied on Debian 13 and Rocky Linux 8.10; the promotion is Backlog M2. | 2026-09-21 |
| D5 | The 1.4.0 fragment work (1.4.0 M6) ships the commonIocsh fragment set without a single global iocsh file. The common services are verified loading together in one IOC by the integrated suite, and the example IOC exercises only the caPutLog fragment. A shipped global startup file is Backlog M3. | 2026-09-24 |
| D6 | Exclude the Libera cross-build, the actual generated-profile repetition, and the Libera output comparison from the completion of the environment-script work (84ee626 M14); retain them as Deferred Backlog M4. The Libera reference is its own document, `docs/libera-cross-build.md`, and both Libera scripts keep their paths. | 2026-09-30 |
| D7 | Exclude actual macOS patch-revert verification from the completion of the clean, uninstall, and patch-revert work (84ee626 M15) and retain it as Deferred Backlog M5. Preserve the runtime code and platform conditions; Linux results do not verify macOS execution. Resume requires a new execution decision. | 2026-10-01 |
| D8 | The loader work (84ee626 M23) completes with the Eclipse Milo startup variant as the data-path evidence for opcua-IOC-demo. The databases of the original startup name 69 nodes under `ns=2;s=Demo.Static`, `Demo.Dynamic`, and `Demo.WorkOrder` that only the Unified Automation example server `uaservercpp` provides; that server needs a registered download, the Milo server names its nodes differently, and the test server of the opcua module provides its own test nodes only. A server written to imitate those nodes would be a stand-in and is not used. The data path of the original startup is Deferred Backlog M6 until that server is available. | 2026-10-04 |
| D9 | The segmentation fault of the combined load of the linStat and iocStatsAdmin fragments is a defect of EPICS base R7.0.10, carried as the site patch `patch/7.0.10-site02-dbstatic-device-menu.p0.patch` (84ee626 M30). Cause, observed 2026-10-05 on Debian 13: when a database loads a record whose name exists with another record type and sets a field that the existing type lacks, `dbRecordField` in `modules/database/src/ioc/dbStatic/dbLexRoutines.c` suggests a field name by walking the fields of the existing type, and for the device type field of a record type without device support it reads `ftPvt`, which is NULL, at line 1345. Two small database files reproduce it in `softIocPVX` without linStat. The report of this patch and of `7.0.10-site01-dbyacc-eof.p0.patch` to the upstream EPICS base repository is Deferred Backlog M7. | 2026-10-05 |
| D10 | Defer the reconciliation of the release-procedure records, the documents in this repository and the owner's release, milestone, git, and environment-pipeline procedures, until after the 1.5.0 release; the 1.5.0 cycle runs on the 1.4.0 precedent as executed. Track the reconciliation as Backlog M8. | 2026-10-10 |
| D11 | Keep the 1.5.0 module survey's decision record in this Decisions table and in the module details below; no separate `docs/module-bumps-1.5.0.md` is created. The survey ran on 2026-10-11 (`tools/update-release.bash check` exit 0, 33 of 33 lookups, 13 updates), the census was taken at each module's pinned revision with two search tools agreeing, and Layer 2 and Layer 3 were read from ADCore ee039d2 and the sibling site-module checkout. | 2026-10-11 |
| D12 | pvxs: IN, `tags/1.5.2` (8e00eaecdee5ce8a474704e70d820e6f92693fa1) to `tags/1.5.3` (25ca43df4db909c0b1a445fb705fc81582617625). All twelve carried 1.5.2 commits are ancestors of 1.5.3, so the carry files retire with the bump and `patch/README.md` is rewritten; the public API change is additive (`TypeCode::valid()` export, new `pvxs/json.h`) and `SHRLIB_VERSION` stays 1.5. EPICS base stays at 7.0.10 with its carry set unchanged. | 2026-10-11 |
| D13 | calc: IN, 4217e83a9b9067017f4dc74da6b70e3669972f16 to R3-8 (712a40453e8693fda3b90a6e9da5fdb1c708ee38): eight engine fixes, seven bounds and overflow guards and the vararg argument-count skip of the UNTIL scan, with no header or Makefile change. The four later Db-only commits at head (59d1fe5) are not taken. | 2026-10-11 |
| D14 | sscan: IN, e13699e3062145d516cfdd555aae25bb49a8c53b to head ce9660cfc05071834391225beadf7f93b776d216 (no tag after the pin): delays no longer rounded to the thread quantum except on vxWorks, npts computed with round(), K&R declarations removed from the internal writeXDR.h. | 2026-10-11 |
| D15 | std: IN, 5f2e44214963b84ea3a400f7b7c3a9f510126ddd to head 27b696702c4ebc8c698c98e3bbb10a34f1a2c821 (no tag after the pin): throttleRecord.c locks the record in its delayed callback and writes the link-status flag for the correct link. | 2026-10-11 |
| D16 | lua: IN, 17475b50ae95c801bad9573bb2b031ffb04ac75c to head 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d (no tag after the pin; upstream names it Release 4-0): bundled Lua 5.5.1, device support in C++, extended luascript record, unified run and state APIs with deprecated aliases, luaaa and the C++11 requirement removed. No module in the three layers links lua or includes its headers. Conditions: the upstream `luaApp/test` suite runs on the built source, and the Ubuntu 26 build is checked with and without the C17 bridge. | 2026-10-11 |
| D17 | busy: IN, 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb to head a4a272d94d1f4351e7d9553e6dc35782eb96ce75 (no tag after the pin): busyRecord uses TYPED_DSET and TYPED_RSET, the dbd adds the typed dset declaration, and the build moves to the cfg-based mechanism with the test IOC opt-in. Conditions: the cfg-based build and the absence of the installed testBusyAsyn IOC are checked, and the Ubuntu 26 C17 bridge is re-examined by real builds. | 2026-10-11 |
| D18 | scaler: IN, beb5521af49616682e4e442c3e33a06add1bd713 to head baa8e1c5e5a9a5deceef8cc39207a0da446092a6 (no tag after the pin), to keep busy and scaler on the same cfg-based build convention; no record or device-support code changes and the C17 bridge stays. | 2026-10-11 |
| D19 | motor: IN, 285f44d66cf7d07a86047719de757bd1f5d92a95 to 4b22ac950de98c2dca324c2ef8ef221e124f6651, which is R7-4 plus the motorRecord.cc version-number correction the tag misses. Head 47893ed is excluded: it removes NUM_MOTOR_DRIVER_PARAMS, which pmac 2-7-9 uses in two files and pmac upstream still uses, with no newer pmac tag. | 2026-10-11 |
| D20 | caPutLog: IN, dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 to R4.2 (6f9eb3f6c75e49201d114f8e194d53cef493a522); the difference is documentation only, so the move re-pins identical code to a release tag. | 2026-10-11 |
| D21 | pyDevSup: IN, 4527ed055a472d4688846a2cb64ac593fec1ecbb to 2.1.0 (b5cef38a6d9f74f9c59f967185ba6d1940637c03); the difference is CHANGELOG.md only. Head (80cdb15) is not taken. | 2026-10-11 |
| D22 | measComp: HOLD at c38974e85c59429b8ba48ed320681ba0296fb924; the two later commits change autoconvert .ui files and docs only. | 2026-10-11 |
| D23 | pcas: HOLD at e075fd450ab9a66bbc044eaa4c2035d3d26d9651; the two later commits change the CI workflow only. | 2026-10-11 |
| D24 | recsync: HOLD at 9834b94edc63eece42712b8355a4703d4286dd8f. From 1.10.0 the recsync repository carries only a stub client Makefile that exits 1; the client lives in ChannelFinder/reccaster (1.9.7 = bebf91f54faf93a59eb4538d3594a687a8823963, no shared history with the pin). The repository switch is module source work outside a version bump, tracked by GitHub issue #101 in the Backlog milestone and not part of 1.5.0. | 2026-10-11 |
| D25 | Cycle order: M1 first because the makeRPath base patch changes the rpath of every built object and is verified by all later builds; then the independent pvxs (M9); then the asyn stack bottom-up, sscan (M10), calc (M11), busy (M12), scaler (M13), std (M14), lua (M15), motor (M16); then the identical-code re-pins caPutLog (M17) and pyDevSup (M18); then the final release milestone (M19). Each module's Stage 6 reconfigures and rebuilds its dependents before the next module starts. | 2026-10-11 |
| D26 | Verification cadence: each module update runs its incremental real-path checks on Debian 13 and Rocky Linux 8.10; the six OS workflows, the public gz product on six OS, and the internal product with Layer 3 and the alliocs consumer check run on the final combined tree under M19's Integrated Verification and Production Environment Tests. | 2026-10-11 |
| D27 | Keep the Milo-based OPC UA example-server work (#99) out of 1.5.0 as Deferred Backlog work M20: it is example and documentation work, not a module-set change, and it is examined together with the original-startup data path kept as M6. | 2026-10-11 |
| D28 | Project the ten module updates as one GitHub issue per work unit in milestone 1.5.0: nine new issues, and #97 reopened for the pyDevSup update; close the shared #98 as superseded by them; rewrite #100 for the final release work; move #25 to milestone 1.5.0 and #99 to the Backlog milestone; link #101 to Backlog M21. | 2026-10-11 |
| D29 | Move the makeRPath work (M1) to the Backlog and pursue it as an upstream epics-base submission instead of a local base patch, superseding the delivery form of D2. The EPICS-env build already runs `makeRPath.py` under `python3` (`configure/RULES_BASE` writes `PYTHON = python3` into the base `CONFIG_SITE.local`) and requires `python3` to read its own configuration, so a local patch removes no prerequisite; the value of the work is the Base path toolkit and `src/tools` consistency, and upstream carries no change to `makeRPath.py`, `EPICS/Path.pm`, `CONFIG_BASE`, or `src/tools/Makefile` since R7.0.10. Design notes for the upstream work: remove `makeRPath.py` and repoint `MAKERPATH` and the install entry; `Normalize` collapses POSIX `//a` to `/a` and rejects an empty string; verification is the edge catalog with the 37-case parity driver and a RUNPATH comparison between a Python-built and a Perl-built tree; no separate soak wiring is kept. The result enters this repository when a Base release that carries it is pinned. | 2026-10-11 |
| D30 | Revise the cycle order of D25 after D29: pvxs (M9) first, then the asyn stack bottom-up (M10 to M16), then caPutLog (M17) and pyDevSup (M18), then the final release milestone (M19); M1 no longer precedes the cycle. | 2026-10-11 |
| D31 | No module update of this line runs the module's own upstream test suite; the real-path checks of a module update are its builds, the installed-tree checks, and a started IOC or the loader suite. The test-suite condition of D16 is superseded; its C17 bridge condition stays. | 2026-10-11 |
| D32 | Build environment of the incremental platforms (D26). Each platform is an OS-matched x86-64 virtual machine, the form of the 1.4.0 checks (1.4.0 D21 and M6): the `debian13-epics-dev` and `rocky8-epics-dev` guests that `cloud-provision` provisions (`make epics-env.provision`), built from source by the `epics_build` role of `ansible-provision` through cloud-provision's `bin/run_epics_env_build.bash -e epics_env_tag=<commit>`, run once per operator playbook `playbooks/operators/common.yml`, `python.yml`, and `epics_build.yml` so that the `epics_support` operator of the `epics_dev` species does not add Layer 2 to the tree; the commit is the `release-1.5.0` state before the first module change and is on `origin`, because the role clones the public remote; the role's default tag is `release-1.3.0` and its checkout accepts a commit hash, so the extra var is required and pins the baseline. A reused guest is reset first with the provisioner's `make <os>.clean`, because the role skips the build when a tree already exists under `/opt/epics`. The role clones the repository into the guest and writes `INSTALL_LOCATION=/opt/epics`, its `path_epics_install`, which is the production install root and belongs to `ansible-provision`; this register sets no root of its own for a guest. The role builds uldaq and open62541 under the generated tree's `vendor/`, writes `configure/RELEASE.local` from `make print-INSTALL_LOCATION_EPICS`, and runs `make init`, `make patch`, `make conf`, `make build`, `make install`, `make symlinks`, and `make check.env`; the tree is `/opt/epics/1.5.0/<os_id>-<os_version>/7.0.10`, generated by the tracked configuration, and no path is written by hand. That build is the baseline; each module check brings the candidate into the guest's checkout, as the fetched candidate commit or as the working-tree patch with its SHA-256 recorded, both forms the 1.4.0 record used, and rebuilds only its module and its dependents into the same tree. A container build, including the CI workflows that M19 runs under D26, is not evidence for an incremental platform. The results record each guest's OS point release, kernel, and compiler version. | 2026-10-11 |
| D33 | Keep the module check runbook and its scripts as Milestone work M22, done after the pvxs update closes and before the sscan update starts, so that M10 to M18 and the next release run the checks through tracked scripts; keep the loader suite's record-count fix as Backlog work M23 until the release work refreshes the suite counts. | 2026-10-12 |
| D34 | Each module update or procedure step ends by writing its procedure lessons into the procedure it changed, as `docs/procedures/documentation-upkeep-procedure.md` sets out; on 2026-10-12 the installed-tree census rule, the exact-ref count rule, and the carry retirement rule entered `docs/procedures/module-bump-procedure.md` and `docs/procedures/upstream-fix-carry-procedure.md`. Lessons about the sessions' own working method, and the release-procedure decisions to reconcile after the release, collect in Backlog M24 for the skills repository and for M8. | 2026-10-12 |

### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| M1 (EPICS::Path Normalize/RelPath for makeRPath, #25; D29, 2026-10-11) | Milestone, `docs/milestone-1.5.0.md`, `release-1.5.0` | Backlog, `docs/milestone-1.5.0.md`, `release-1.5.0` | this synchronization commit | this synchronization commit |

### Milestone Details

#### M9 - pvxs Update

Origin: 1.5.0 / M9
Identity History: none
GitHub Issue: #102, https://github.com/jeonghanlee/EPICS-env/issues/102
Status: Complete

##### Summary

pvxs moves from `tags/1.5.2` (8e00eaecdee5ce8a474704e70d820e6f92693fa1, 2026-06-23) to `tags/1.5.3` (25ca43df4db909c0b1a445fb705fc81582617625, 2026-09-25): 71 commits, 72 files. The twelve carried 1.5.2 fixes (086501a, 090bf5f, 7490286, 0b3fcca, 084336b, 9a6b4cc, 39cc6fa, c969383, c17812a, eab3275, d5ecc88, cc7bc72) are ancestors of 1.5.3. The public API change is additive: `TypeCode::valid()` gains its export and `pvxs/json.h` is new and installed; `SHRLIB_VERSION` stays 1.5. The release also fixes the ioc proc mapping of non-PP fields, timestamp masking for monitor subscriptions, display precision, the client channel-cache GC and retry, and contains exceptions thrown by server callbacks. The top-level build gains a `setup2` directory, which `conf.pvxs` does not touch.

##### Scope

- Set `SRC_TAG_PVXS` to `tags/1.5.3` and `SRC_VER_PVXS` to `1.5.3` in `configure/RELEASE`.
- Remove the twelve `patch/1.5.2-*.p0.patch` files; the apply and revert functions glob `patch/$(SRC_VER_PVXS)-*.p0.patch` and run zero times at 1.5.3 (observed 2026-10-11 with `SRC_VER_PVXS=1.5.3` on the make command line: both legs exited 0 with no iteration and `pvxs-src` unchanged). Rewrite `patch/README.md` where it names the 1.5.2 set: the kinds table row, the Record note, and the `pvxs 1.5.2 carry (12)` section; the dormant-history line names only `pvxs-1.3.1` and stays. The rewritten README keeps no 1.5.2 text; the retirement record is `docs/archive/pvxs-carry-1.3.0.md` and the Version Changes of the release detail. Reword the comment above the pvxs functions in `configure/RULES_FUNC` to the generic `$(SRC_VER_PVXS)-*` pattern and drop its example of patches 02 and 04 in `tools/put.cpp`; the function bodies do not change.
- Update the book where it names the 1.5.2 pin or carry: `docs/src/reference/module-pins.md`, `docs/src/concepts/upstream-patch-carry.md`, the sample loader output in `docs/src/procedures/set-up-shell.md`, and `docs/src/procedures/carry-upstream-fix.md`, whose worked example moves to the base direct-commit carry `7.0.10-01-b2d2758-putnotify-type-check` (commit b2d2758, one file, regenerated byte-for-byte by `git diff --no-prefix b2d2758^ b2d2758` on 2026-10-11), which stays on the tree; its apply step is rewritten for a one-file unit that sorts first among the base carries.
- Update the two loader test scripts that name the pvxs version, `examples/iocsh/tests/verify_elf_inspection.bash` and `examples/iocsh/tests/verify_failure_diagnostics.bash`, from 1.5.2 to 1.5.3; the suite README states that a pin change adjusts the scripts.
- Rebuild and install pvxs, which regenerates its loader metadata at install. No Layer 1 module relinks: the only build file that names pvxs is linStat's `exampleApp/src/Makefile`, and `conf.linStat` writes `LINSTAT_BUILD_EXAMPLE = NO`, so that example is neither built nor installed, and the installed `liblinStat` links EPICS base only. The loader resolves the native pvxs through the `modules/pvxs` link, so `make symlink.pvxs` is the step that makes pvxs 1.5.3 the `softIocPVX` that the loader runs for every module; `tools/iocsh_elf.bash` refuses an object whose ELF resolves `libpvxs` from another version directory, which T3 exercises through the updated test scripts.

Out of scope: the EPICS base pin and its carry set; pvxs commits beyond the 1.5.3 tag; the pvxs unit tests (D31); the Layer 2 and Layer 3 consumers, which rebuild on their own lines (G1, G2).

##### Completion Criteria

- `make print-SRC_TAG_PVXS` prints `tags/1.5.3`; no `patch/1.5.2-*` file remains; `patch/README.md`, the `configure/RULES_FUNC` comment, the four book pages, and the two loader test scripts agree with the tree (T5).
- pvxs 1.5.3 builds, installs, and symlinks on Debian 13 and Rocky Linux 8.10; `make check.deps` and `make check.env` exit 0.
- `make patch` applies no pvxs file and the `make patch` / `make patch.revert` round trip leaves every source tree pristine.
- The loader verification suite passes against the installed tree.

##### Dependencies And Decisions

- D12, Decision Date: 2026-10-11, selects 1.5.3 and retires the carry set.
- D26 sets the incremental platforms; the six OS workflows and the two products run under M19.
- D31, Decision Date: 2026-10-11: the pvxs unit tests are not run.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms; step 1 executes it.
- Environment, observed 2026-10-12: the two guests were provisioned with cloud-provision 05cf573 and built by the `epics_build` operator of ansible-provision 54f28ce from commit 0c157cf; the sentinel is present on both and the build unit is inactive; the trees are `/opt/epics/1.5.0/debian-13/7.0.10` (Debian 13 trixie, kernel 6.12.74 cloud, GCC 14.2.0) and `/opt/epics/1.5.0/rocky-8.10/7.0.10` (Rocky Linux 8.10, kernel 4.18.0-553, GCC 8.5.0), each with 65 module entries, no Layer 2, `modules/pvxs` linked to `pvxs-1.5.2`, and six vendor libraries; the checkout under `/opt/epics-env-src/EPICS-env` and the tree are root-owned, so the module steps run as root, as the baseline did. The loader suite's tools that the base guests lacked (gawk, expect, strace, podman, ShellCheck) were installed from the distribution packages on 2026-10-12.
- Census: Layer 1 installs no object that links pvxs (linStat's `exampleApp` links `pvxsIoc pvxs`, but `conf.linStat` sets `LINSTAT_BUILD_EXAMPLE = NO`); the runtime consumers are `softIocPVX` of pvxs itself through `tools/iocsh.bash`, the `--pvxs` scan of `tools/iocsh_metadata.bash`, and the loader fixtures and tests under `examples/iocsh/`; Layer 2 ADCore ee039d2 builds NDPluginPvxs and ntndArrayConverterPvxs under `WITH_PVXS=YES` (G1); Layer 3 eventGeneratorSup links pvxs and bpmSup and feed declare it (G2).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-12
Implementation Authorization: 2026-10-12
Superseded Plan Artifacts: none

1. Prepare the environment of D32: provision the `debian13-epics-dev` and `rocky8-epics-dev` guests with `cloud-provision` (`make epics-env.provision`; a reused guest is reset first with `make <os>.clean`), then build the baseline with cloud-provision's `bin/run_epics_env_build.bash -e epics_env_tag=<commit>` once per operator playbook `playbooks/operators/common.yml`, `python.yml`, and `epics_build.yml`, not the `epics_dev` species, whose `epics_support` operator would add Layer 2 to the tree; the commit is the `release-1.5.0` state before this change as pushed to `origin`; confirm in each guest that `make print-INSTALL_LOCATION_EPICS` prints `/opt/epics/1.5.0/<os_id>-<os_version>/7.0.10` and that the role's `make check.env` exited 0; record the OS point release, kernel, and compiler version with T1's evidence. Then, in each guest's checkout under `/opt/epics-env-src/EPICS-env`, fetch and check out the candidate commit, or apply the working-tree patch and record its SHA-256 with T1's evidence.
2. Edit the two pin lines in `configure/RELEASE`.
3. Remove the twelve carry files; rewrite `patch/README.md`; reword the `configure/RULES_FUNC` comment; update the four book pages and the two loader test scripts.
4. Run `make reconf.modules`, `make print-INSTALL_LOCATION_PVXS`, remove `pvxs-src`, then `make PVXS`, `make conf.pvxs`, `make check.module-deps MODULE=pvxs`, `make build.pvxs`, and `make symlink.pvxs`; the install inside `build.pvxs` regenerates the loader metadata of pvxs.
5. Run T1 to T5 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 4 from a tree whose `pvxs-src` was removed first | The Debian 13 and Rocky Linux 8.10 guests of D32 | Every target exits 0; `modules/pvxs-1.5.3` is installed and symlinked; `readelf -d modules/pvxs-1.5.3/lib/<arch>/libpvxs.so` shows SONAME `libpvxs.so.1.5` |
| T2 | Patch round trip | On a fresh checkout at the candidate, its commit or the baseline commit with the recorded patch applied: `make init`, `make patch`, `make patch.revert`, then `git -C <name>-src status --short` in every source tree | The Debian 13 guest, in a fresh clone beside the baseline checkout | No `Patching pvxs-src` line appears; the status command prints nothing in every tree |
| T3 | Consumers | Start the minimal example IOC `examples/iocsh/st.cmd`, which loads linStat, through the installed `iocsh.bash`, then run the loader verification suite under `examples/iocsh/tests`, with the two scripts updated in step 3, as `docs/src/procedures/run-loader-verification-suite.md` describes | The two guests of D32, installed tree | The IOC reaches `iocRun` with zero registration failures; every suite check passes |
| T4 | Installed tree | `make check.deps` and `make check.env` on the installed tree | The two guests of D32 | Both exit 0 |
| T5 | Text agreement | `grep -rn '1\.5\.2'` over `patch/README.md`, `configure/RULES_FUNC`, the four book pages, and the two loader test scripts | Checkout at the candidate, its commit or the baseline commit with the recorded patch applied | The command prints nothing |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-12T10:32Z to 10:35Z | The Debian 13 and Rocky Linux 8.10 guests of D32 at candidate a0fecd9 (Debian 13 trixie, kernel 6.12.74 cloud, GCC 14.2.0; Rocky Linux 8.10, kernel 4.18.0-553, GCC 8.5.0) | Pass | Every target of step 4 exited 0 on both guests: `reconf.modules`, `print-INSTALL_LOCATION_PVXS` (`modules/pvxs-1.5.3`), removal of `pvxs-src`, `PVXS` at 25ca43d, `conf.pvxs`, `check.module-deps MODULE=pvxs` with no finding, `build.pvxs`, `symlink.pvxs`. `modules/pvxs-1.5.3` holds `softIocPVX`, the cfg files `CONFIG_PVXS_MODULE`, `CONFIG_PVXS_VERSION`, `RULES_PVXS_MODULE`, `TOOLCHAIN_PVXS.linux-x86_64`, and `iocsh.conf` with `version=1.5.3`; `modules/pvxs` links to `pvxs-1.5.3`; `readelf -d` of `libpvxs.so` shows SONAME `libpvxs.so.1.5`; the tree has 66 module entries, `pvxs-1.5.2` staying beside the new directory |
| T2 | 2026-10-12T10:33Z to 10:34Z | The Debian 13 guest, fresh clone beside the baseline checkout, at candidate a0fecd9 | Pass | `make init` exited 0 with 33 source trees; `make patch` exited 0 with 27 `Patching` lines and none for `pvxs-src`; `make patch.revert` exited 0; `git status --short` printed nothing in all 33 trees |
| T3 | 2026-10-12T10:38Z to 10:49Z | The two guests of D32, installed tree at candidate a0fecd9, with gawk, expect, strace, podman, and ShellCheck added for the suite | Pass | On both guests the minimal example `examples/iocsh/st.cmd` reached `iocRun: All initialization complete` through the installed `iocsh.bash` with no registration failure, and `run_all.bash` exited 0 with every script at exit 0 and `fail=0`; the passing counts in the suite README's order are 12, 15, 18, 7, 24, 10, 13, 25, 11, 37, 31, 6, 30, 33 on both, `verify_docs_and_tools` at 6 because neither guest has Docker; `verify_readme_update_command` printed 32 on both; `observe_truncated_library` printed statuses 135, 0, 0 on Debian 13 and 0, 0, 0 on Rocky Linux 8.10; `verify_minimal_example` listed 317 records on Rocky Linux 8.10 and 322 lines on Debian 13, where the record set is the same 317 (identical names apart from the NIC name) and five linStat hwmon error lines, from a cloud guest without `/sys/class/hwmon`, begin with a record name and are counted; those five lines are also its suspicious-lines output |
| T4 | 2026-10-12T10:37Z | The two guests of D32, installed tree at candidate a0fecd9 | Pass | `make check.deps` exited 0 and `make check.env` exited 0 with `findings: 0` on both guests |
| T5 | 2026-10-12T10:38Z | Checkout at candidate a0fecd9 in both guests, and the local checkout on 2026-10-12 | Pass | The sweep printed nothing on every checkout |

##### Closure Evidence

- Candidate commits e19efe7 (the pvxs update) and a0fecd9 (the baseline record) landed on `origin/release-1.5.0`: after the push on 2026-10-12, `git rev-parse HEAD '@{upstream}'` and `git ls-remote --heads origin refs/heads/release-1.5.0` all read a0fecd9ad89687a2467cc4009aae5f53e16d4c3a.
- #102 observed closed on 2026-10-12T17:45:32Z after its body was rewritten from this detail with the four acceptance items checked and the close comment posted; the six OS workflows stay with the release work.
- The results commit 1223168 (T1 to T5 and this evidence) landed on `origin/release-1.5.0` on 2026-10-12.

##### GitHub Projection

Title: Update pvxs to 1.5.3
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: closed
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-12; body synced from this detail at closure; remote updated 2026-10-12T17:45:32Z; closed 2026-10-12T17:45:32Z

#### M10 - sscan Update

Origin: 1.5.0 / M10
Identity History: none
GitHub Issue: #103, https://github.com/jeonghanlee/EPICS-env/issues/103
Status: Complete

##### Summary

sscan moves from e13699e3062145d516cfdd555aae25bb49a8c53b (2026-06-05) to head ce9660cfc05071834391225beadf7f93b776d216 (2026-09-28); no tag follows the pin (R2-12 precedes it). Six commits change sscanRecord.c and the internal writeXDR.h: positioner, readback, and detector delays are no longer rounded to the thread quantum except on vxWorks, the number of points is computed with round() to fix an off-by-one, and K&R declarations leave writeXDR.h, which is not installed. No Makefile changes.

##### Scope

- Set `SRC_TAG_SSCAN` and `SRC_VER_SSCAN` to `ce9660c` in `configure/RELEASE`, and update the sscan row of `docs/src/reference/module-pins.md`.
- Rebuild and install sscan with `tools/module-check/guest-update.bash sscan SSCAN <commit>` in each guest; then reconfigure and rebuild the four installed consumers that link `libsscan`, calc, asyn, mca, and measComp in that order, with `make conf.<dependent>` and `make build.<dependent>`. StreamDevice links sscan only under `SSCAN` or `SYNAPPS`, which `conf.StreamDevice` does not set, so it is not a consumer in this build.

Out of scope: sscan commits after ce9660c; StreamDevice; the sscan test applications (D31); the Layer 3 consumers eventGeneratorSup and qpc (G2).

##### Completion Criteria

- `make print-SRC_TAG_SSCAN` prints `ce9660c` and the pins page agrees (T6).
- sscan builds, installs, and symlinks on both guests (T1); the four consumers rebuild, their loader metadata records `dep=sscan ce9660c`, and their six sscan-linked objects carry a RUNPATH that names `sscan-ce9660c` (T2); the two objects of the suite's second asyn are rebuilt by the suite itself (T4).
- The patch round trip on a fresh clone applies no sscan patch and leaves every tree pristine (T3).
- The loader suite passes on both guests (T4); `make check.deps` and `make check.env` exit 0 (T5).

##### Dependencies And Decisions

- D14, Decision Date: 2026-10-11.
- D26 sets the incremental platforms; D32, Decision Date: 2026-10-11, sets their build environment; D31 keeps the sscan test applications out.
- D33 and M22: this update is the first use of the three guest scripts; its T1, T3, and T4 are M22's T2.
- Census, from the baseline guests on 2026-10-12: the installed objects whose ELF `NEEDED` names `libsscan` are `libcalc.so`, asyn's `libtestEpicsSupport.so` and `testEpics`, mca's `libmcaRontec.so` and `mcaRontecApp`, and `measCompApp`, and the loader metadata of calc, asyn, mca, and measComp records `dep=sscan e13699e`; StreamDevice links sscan only under `SSCAN` or `SYNAPPS`, which `conf.StreamDevice` does not set, and its installed objects and metadata name no sscan. Layer 3: eventGeneratorSup and qpc (G2). calc declares `build.sscan`, so M11 follows this work.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-12
Implementation Authorization: 2026-10-12
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE` and the sscan row of `docs/src/reference/module-pins.md`; commit the candidate and push it, since the guests fetch it from origin.
2. In each guest, fetch and check out the candidate, then run `tools/module-check/guest-update.bash sscan SSCAN <commit>` as root.
3. In each guest, run `make conf.calc` and `make build.calc`, then the same pair for asyn, mca, and measComp, as root in the checkout.
4. On the Debian 13 guest, run `tools/module-check/guest-roundtrip.bash <commit> sscan`.
5. In each guest, run `tools/module-check/guest-suite.bash`, then `make check.deps` and `make check.env`.
6. Read the T2 and T6 observables and record T1 to T6.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash sscan SSCAN <commit>` from a checkout whose `sscan-src` the script removes first | The two guests of D32 | The script exits 0; `modules/sscan-ce9660c` is installed and `modules/sscan` links to it; its `cfg/iocsh.conf` reads `version=ce9660c`; the SONAME line of `libsscan.so` is recorded |
| T2 | Consumers relink | `make conf.<dependent>` and `make build.<dependent>` for calc, asyn, mca, and measComp; then `grep '^dep=sscan' modules/<dependent>/cfg/iocsh.conf` for the four and `readelf -d` of their six sscan-linked objects (`libcalc.so`, asyn's `libtestEpicsSupport.so` and `testEpics`, mca's `libmcaRontec.so` and `mcaRontecApp`, `measCompApp`), listed with the installed-tree census command of Stage 3 of `docs/procedures/module-bump-procedure.md` | The two guests of D32 | Every build exits 0; the four metadata files read `dep=sscan ce9660c`; every RUNPATH of the six objects names `sscan-ce9660c` and none names `sscan-e13699e`; the same two objects of the suite's second asyn, `asyn-66bafcd`, are rebuilt by T4 |
| T3 | Patch round trip | `guest-roundtrip.bash <commit> sscan` | The Debian 13 guest, fresh clone beside the baseline checkout | `make init` exits 0 with 33 trees; `make patch` exits 0 with 27 `Patching` lines and none for `sscan-src`; `make patch.revert` exits 0; the status line count of every tree is 0 |
| T4 | Consumers in IOCs | `guest-suite.bash` | The two guests of D32, installed tree | The minimal example IOC reaches `iocRun`; `run_all.bash` exits 0 with every script at exit 0 and `fail=0`, the counts of the suite README (6 for `verify_docs_and_tools` without Docker), 317 records on Rocky Linux 8.10 and 322 lines on Debian 13 by the five hwmon lines of M23 |
| T5 | Installed tree | `make check.deps` and `make check.env` in the checkout | The two guests of D32 | Both exit 0 |
| T6 | Text agreement | `grep -rn 'e13699e'` over `docs/src/reference/module-pins.md` | Checkout at the candidate | The command prints nothing |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-12T20:02Z | The two guests of D32 at candidate f809b08, through `tools/module-check/guest-update.bash sscan SSCAN f809b08` | Pass | On both guests the script exited 0 in about 17 s: sscan cloned at ce9660c, `check.module-deps` with no finding, `modules/sscan-ce9660c` installed with `CONFIG_MODULE`, `SSCAN_DEPS`, `build-record`, and `iocsh.conf` reading `version=ce9660c`, `modules/sscan` linked to it; the SONAME of `libsscan.so` and `libscanProgress.so` is the bare file name; the tree holds 69 module entries with `sscan-e13699e` staying beside the new directory |
| T2 | 2026-10-12T20:02Z to 20:04Z | The two guests of D32 at candidate f809b08, as root in the checkout | Pass | `make conf.<dependent>` and `make build.<dependent>` exited 0 for calc, asyn, mca, and measComp on both guests; the four `cfg/iocsh.conf` files read `dep=sscan ce9660c`; the RUNPATH of `libcalc.so`, asyn's `libtestEpicsSupport.so` and `testEpics`, mca's `libmcaRontec.so` and `mcaRontecApp`, and `measCompApp` names `sscan-ce9660c` and none names `sscan-e13699e`, on both guests |
| T3 | 2026-10-12T20:02Z to 20:03Z | The Debian 13 guest, fresh clone beside the baseline checkout, through `guest-roundtrip.bash f809b08 sscan` | Pass | `make init` exited 0 with 33 source trees; `make patch` exited 0 with 27 `Patching` lines and none for `sscan-src`; `make patch.revert` exited 0; the status line count of all 33 trees is 0 |
| T4 | 2026-10-12T20:04Z to 20:19Z | The two guests of D32, installed tree at candidate f809b08, through `guest-suite.bash` | Pass | On both guests the minimal example IOC reached `iocRun` and `run_all.bash` exited 0 with every script at exit 0 and `fail=0`; the passing counts are 12, 15, 18, 7, 24, 10, 13, 25, 11, 37, 31, 6, 30, 33 in the README's order, 6 for `verify_docs_and_tools` without Docker; `verify_readme_update_command` printed 32 on both; `observe_truncated_library` printed statuses 135, 0, 0 on Debian 13 and 0, 0, 0 on Rocky Linux 8.10; `verify_minimal_example` listed 317 records on Rocky Linux 8.10 and 322 lines on Debian 13, the five hwmon lines of M23 included |
| T5 | 2026-10-12T20:19Z | The two guests of D32, installed tree at candidate f809b08 | Pass | `make check.deps` exited 0 and `make check.env` exited 0 with `findings: 0` on both guests |
| T6 | 2026-10-12 | Checkout at candidate f809b08, locally and in both guests | Pass | `grep -rn 'e13699e'` over `docs/src/reference/module-pins.md` printed nothing on every checkout |

##### Closure Evidence

- Candidate commits e19f76b (the sscan update) and f809b08 (the plan record) landed on `origin/release-1.5.0`: after the push on 2026-10-12, `git rev-parse HEAD '@{upstream}'` and `git ls-remote --heads origin refs/heads/release-1.5.0` all read f809b08f770570a18bd3b4f50afb8ba4beff2bdf.
- #103 observed closed on 2026-10-12T20:26:11Z after its body was rewritten from this detail with the four acceptance items checked and the close comment posted; the six OS workflows stay with the release work.
- The results commit 809e447 (T1 to T6 and this evidence) landed on `origin/release-1.5.0` on 2026-10-12.

##### GitHub Projection

Title: Update sscan to ce9660c
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: closed
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-12; body synced from this detail at closure; remote updated 2026-10-12T20:26:11Z; closed 2026-10-12T20:26:11Z

#### M11 - calc Update

Origin: 1.5.0 / M11
Identity History: none
GitHub Issue: #104, https://github.com/jeonghanlee/EPICS-env/issues/104
Status: Complete

##### Summary

calc moves from 4217e83a9b9067017f4dc74da6b70e3669972f16 (2026-09-09) to R3-8 (712a40453e8693fda3b90a6e9da5fdb1c708ee38, 2026-09-17): twelve commits with eight engine fixes in aCalcPerform.c, calcUtil.c, and sCalcPerform.c (MODULO guard against INT_MIN % -1, lrc() out-of-bounds read on an empty operand, INC() stack-overflow guard, shift count clamp, LITERAL_STRING copy bound, SUBRANGE upper bound, nderiv window check, and the one-byte argument count of the vararg operators MIN, MAX, FINITE, ISNAN, and in aCalc FITQ and FITMQ, skipped in the UNTIL scan, which is the tag commit itself) plus their tests. No header or Makefile changes. The four later Db-only commits at head are not taken (D13).

##### Scope

- Set `SRC_TAG_CALC` to `tags/R3-8` and `SRC_VER_CALC` to `3.8.0` in `configure/RELEASE`, so that calc installs as `modules/calc-3.8.0` with `version=3.8.0`, the naming of the other tag pins; update the calc row of `docs/src/reference/module-pins.md` and the two examples of `docs/src/concepts/installed-tree.md` that name the old pin: the commit-pin directory example becomes `mca-687d563`, a commit pin that no milestone of this cycle moves, and the `dep=calc` line of the StreamDevice metadata example becomes `dep=calc 3.8.0`.
- Rebuild and install calc with `tools/module-check/guest-update.bash calc CALC <commit>` in each guest; then reconfigure and rebuild the five modules whose `_DEPS` list `build.calc`, asyn, StreamDevice, mca, measComp, and pmac in that order, with `make conf.<dependent>` and `make build.<dependent>`.

Out of scope: calc head 59d1fe5 and its database changes; running the calc tests `acalcTest` and `scalcTest` (D31); the Layer 3 consumer qpc (G2).

##### Completion Criteria

- `make print-SRC_TAG_CALC` prints `tags/R3-8` (T1), and the pins page and the installed-tree page agree (T6).
- calc builds, installs as `modules/calc-3.8.0`, and symlinks on both guests (T1); the five dependents rebuild, their loader metadata records `dep=calc 3.8.0`, and the six calc-linked objects carry a RUNPATH that names `calc-3.8.0` (T2); the two objects of the suite's second asyn are rebuilt by the suite itself (T4).
- The patch round trip on a fresh clone applies no calc patch and leaves every tree pristine (T3).
- The loader suite passes on both guests, its dependency-graph IOC loading `libcalc.so` from `calc-3.8.0` and registering the scalcout record type (T4); `make check.deps` and `make check.env` exit 0 (T5).

##### Dependencies And Decisions

- M10 precedes this work: `calc_DEPS` requires `build.sscan`; M10 is Complete, and calc was rebuilt against sscan ce9660c in M10 / T2.
- D13, Decision Date: 2026-10-11.
- D26 sets the incremental platforms; D32, Decision Date: 2026-10-11, sets their build environment; D31 keeps the calc tests out.
- D33 and M22: the three guest scripts carry T1, T3, and T4.
- Census, from the baseline guests on 2026-10-12 after the sscan update: the installed objects whose ELF `NEEDED` names `libcalc` are asyn's `testEpics` and `libtestEpicsSupport.so`, mca's `libmcaRontec.so` and `mcaRontecApp`, `measCompApp`, and StreamDevice's `streamApp`; `libasyn.so` and `libstream.so` do not link calc. The loader metadata of asyn, StreamDevice, mca, measComp, and pmac records `dep=calc 4217e83`; pmac installs no object that links calc, so its dependency is metadata only. All five list `build.calc` in `configure/CONFIG_MODS_DEPS` and rebuild. The suite's second asyn, `asyn-66bafcd`, holds the same two linked objects. Layer 3: qpc (G2).
- Plan review, 2026-10-12: the consumer-in-IOC check is the loader suite, whose dependency-graph IOC loads `libcalc.so` and registers scalcout, not a composed testEpics IOC; the two examples of the installed-tree page change with the pin.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-12
Implementation Authorization: 2026-10-12
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`, the calc row of `docs/src/reference/module-pins.md`, and the two examples of `docs/src/concepts/installed-tree.md` (`mca-687d563` for the commit-pin directory, `dep=calc 3.8.0` in the StreamDevice metadata); commit the candidate and push it, since the guests fetch it from origin.
2. In each guest, fetch and check out the candidate, then run `tools/module-check/guest-update.bash calc CALC <commit>` as root.
3. In each guest, run `make conf.asyn` and `make build.asyn`, then the same pair for StreamDevice, mca, measComp, and pmac, as root in the checkout.
4. On the Debian 13 guest, run `tools/module-check/guest-roundtrip.bash <commit> calc`.
5. In each guest, run `tools/module-check/guest-suite.bash`, then `make check.deps` and `make check.env`.
6. Read the T2 observables in the guests, the calc `dlload` line of `verify_dependency_graph.log` for T4, and the T6 sweep, and record T1 to T6.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash calc CALC <commit>` from a checkout whose `calc-src` the script removes first | The two guests of D32 | The script exits 0 and its `pin:` line reads `tags/R3-8`; `modules/calc-3.8.0` is installed and `modules/calc` links to it; its `cfg/iocsh.conf` reads `version=3.8.0`; the SONAME line of `libcalc.so` is recorded |
| T2 | Consumers relink | `make conf.<dependent>` and `make build.<dependent>` for asyn, StreamDevice, mca, measComp, and pmac; then `grep '^dep=calc' modules/<dependent>/cfg/iocsh.conf` for the five and `readelf -d` of the six calc-linked objects (asyn's `testEpics` and `libtestEpicsSupport.so`, mca's `libmcaRontec.so` and `mcaRontecApp`, `measCompApp`, StreamDevice's `streamApp`), listed with the installed-tree census command of Stage 3 of `docs/procedures/module-bump-procedure.md` | The two guests of D32 | Every build exits 0; the five metadata files read `dep=calc 3.8.0`; every RUNPATH of the six objects names `calc-3.8.0` and none names `calc-4217e83`; the same two objects of the suite's second asyn, `asyn-66bafcd`, are rebuilt by T4 |
| T3 | Patch round trip | `guest-roundtrip.bash <commit> calc` | The Debian 13 guest, fresh clone beside the baseline checkout | `make init` exits 0 with 33 trees; `make patch` exits 0 with 27 `Patching` lines and none for `calc-src`; `make patch.revert` exits 0; the status line count of every tree is 0 |
| T4 | Consumers in IOCs | `guest-suite.bash`, then the calc `dlload` line of `verify_dependency_graph.log` in its log directory, `/var/tmp/iocsh-tests` by default | The two guests of D32, installed tree | The minimal example IOC reaches `iocRun`; `run_all.bash` exits 0 with every script at exit 0 and `fail=0`, the counts of the suite README (6 for `verify_docs_and_tools` without Docker), 317 records on Rocky Linux 8.10 and 322 lines on Debian 13 by the five hwmon lines of M23; the generated startup of the dependency-graph IOC loads `libcalc.so` from `calc-3.8.0` and the IOC registers scalcout; `verify_multiple_versions.log` shows `make build.asyn: status 0` for `asyn-66bafcd` |
| T5 | Installed tree | `make check.deps` and `make check.env` in the checkout | The two guests of D32 | Both exit 0 |
| T6 | Text agreement | `grep -rn '4217e83'` over `docs/src/reference/module-pins.md` and `docs/src/concepts/installed-tree.md` | Checkout at the candidate | The command prints nothing |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-12T23:10Z | The two guests of D32 at candidate 7f308e9, through `tools/module-check/guest-update.bash calc CALC 7f308e9` | Pass | On both guests the script exited 0 in about 20 s: its `pin:` line read `tags/R3-8`, calc cloned at 712a404, `check.module-deps` with no finding, `modules/calc-3.8.0` installed with `CONFIG_MODULE`, `CALC_DEPS`, `build-record`, and `iocsh.conf` reading `version=3.8.0`, `modules/calc` linked to it; the SONAME of `libcalc.so` is the bare file name; the tree holds 70 module entries with `calc-4217e83` staying beside the new directory |
| T2 | 2026-10-12T23:11Z to 23:13Z | The two guests of D32 at candidate 7f308e9, as root in the checkout | Pass | `make conf.<dependent>` and `make build.<dependent>` exited 0 for asyn, StreamDevice, mca, measComp, and pmac on both guests; the five `cfg/iocsh.conf` files read `dep=calc 3.8.0`; the RUNPATH of asyn's `testEpics` and `libtestEpicsSupport.so`, mca's `libmcaRontec.so` and `mcaRontecApp`, `measCompApp`, and StreamDevice's `streamApp` names `calc-3.8.0` and none names `calc-4217e83`, on both guests; the census lists the same six objects, the two of `asyn-66bafcd`, and the two `libcalc.so`; the five were reconfigured and rebuilt once more on 2026-10-13T00:20Z to 00:22Z before the suite rerun of T4, with the same observables |
| T3 | 2026-10-12T23:10Z to 23:12Z | The Debian 13 guest, fresh clone beside the baseline checkout, through `guest-roundtrip.bash 7f308e9 calc` | Pass | `make init` exited 0 with 33 source trees; `make patch` exited 0 with 27 `Patching` lines and none for `calc-src`; `make patch.revert` exited 0; the status line count of all 33 trees is 0 |
| T4 | 2026-10-12T23:13Z to 23:28Z, rerun 2026-10-13T00:21Z to 00:37Z | The two guests of D32, installed tree at candidate 7f308e9, through `guest-suite.bash` | Pass on the rerun | First run, both guests: `run_all.bash` rc 1 with 64 `FAIL` lines. The first script's repeated `make install` reinstalled Base's `epicsString.h` and `calcRecord.h`, whose sources the previous suite run's `make patch.revert` and `make patch` had left newer than the installed copies; five asyn objects recompiled, `libasyn.so` relinked, and `iocsh_metadata.bash` refused asyn's metadata because the library no longer matched the build record that T2 had written from the library it had not relinked; every later IOC check failed on the missing asyn metadata, which the suite's own restore step put back. After `make conf.<dependent>` and `make build.<dependent>` ran once more for the five, writing fresh build records, the rerun passed on both guests: the minimal example IOC reached `iocRun`, `run_all.bash` exited 0 with every script at exit 0 and `fail=0`, the counts 12, 15, 18, 7, 24, 10, 13, 25, 11, 37, 31, 6, 30, 33 in the README's order; `verify_readme_update_command` printed 32; `observe_truncated_library` printed 135, 0, 0 on Debian 13 and 0, 0, 0 on Rocky Linux 8.10; `verify_minimal_example` listed 317 records on Rocky Linux 8.10 and 322 lines on Debian 13; the generated startup of the dependency-graph IOC loaded `calc-3.8.0/lib/linux-x86_64/libcalc.so` and `verify_multiple_versions.log` shows `make build.asyn: status 0` for `asyn-66bafcd` |
| T5 | 2026-10-13T00:37Z | The two guests of D32, installed tree at candidate 7f308e9, after the suite rerun | Pass | `make check.deps` exited 0 and `make check.env` exited 0 with `findings: 0` on both guests, as they had after the first suite run (2026-10-12T23:28Z on Debian 13, 23:38Z on Rocky Linux 8.10) |
| T6 | 2026-10-12 | Checkout at candidate 7f308e9, locally and in both guests | Pass | `grep -rn '4217e83'` over `docs/src/reference/module-pins.md` and `docs/src/concepts/installed-tree.md` printed nothing on every checkout |

##### Closure Evidence

- Candidate commits 980e12b (the calc update) and 7f308e9 (the plan record) landed on `origin/release-1.5.0`: after the push on 2026-10-12, `git rev-parse HEAD '@{upstream}'` and `git ls-remote --heads origin refs/heads/release-1.5.0` all read 7f308e984e4f08058f353b3eeca8fa77bbcff0e5.
- The first suite run failed on both guests and the rerun passed (T4); the cause and its two procedure rules landed in 51f8a01 and 35d3ebb on `origin/release-1.5.0` on 2026-10-13.
- #104 observed closed on 2026-10-13T00:51:32Z after its body was rewritten from this detail with the five acceptance items checked and the close comment posted; the six OS workflows stay with the release work.
- The commit that records T1 to T6 and this evidence lands next; the following register commit records its hash and landing.

##### GitHub Projection

Title: Update calc to R3-8
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: closed
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-13; body synced from this detail at closure; remote updated 2026-10-13T00:51:32Z; closed 2026-10-13T00:51:32Z

#### M12 - busy Update

Origin: 1.5.0 / M12
Identity History: none
GitHub Issue: #105, https://github.com/jeonghanlee/EPICS-env/issues/105
Status: Not started

##### Summary

busy moves from 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb (2025-05-15) to head a4a272d94d1f4351e7d9553e6dc35782eb96ce75 (2026-09-21); no tag follows the pin. busyRecord.c uses TYPED_DSET and TYPED_RSET, busyRecord.dbd adds the typed `busydset` declaration, and devBusyAsyn, devBusySoft, and devBusySoftRaw are updated. The build moves to the cfg-based mechanism: `configure/CONFIG_SITE` sets `MODULE = BUSY` and `BUILD_IOCS = NO`, `configure/Makefile` expands `CONFIG_MODULE@`, and `busyApp/src/Makefile` installs `BUSY_DEPS`; the testBusyAsyn IOC moves to the opt-in `iocs/` directory, so the IOC that was built and installed when ASYN and AUTOSAVE were set (`conf.busy` sets both) is no longer installed. Nothing in this repository references it.

##### Scope

- Set `SRC_TAG_BUSY` and `SRC_VER_BUSY` to `a4a272d` in `configure/RELEASE`.
- Rebuild and install busy; reconfigure and rebuild mca, measComp, and pmac; reconfigure motor, which declares `build.busy`.
- Answer the Ubuntu 26 C17 bridge question for busy with real builds with and without `-std=gnu17`; if both pass, remove busy's conditional append from `conf.busy` in `configure/RULES_MODS_CONFIG` and update the rationale comment in `configure/CONFIG_MODS_DEPS` and the book.

Out of scope: the Layer 3 consumers eventGeneratorSup and feed (G2).

##### Completion Criteria

- `make print-SRC_TAG_BUSY` prints `a4a272d`.
- busy builds, installs `cfg/CONFIG_MODULE` and `cfg/BUSY_DEPS` under its install directory, and installs no testBusyAsyn program; its dependents relink; `make check.deps` and `make check.env` exit 0.
- The C17 bridge decision for busy is recorded with the two real build results.

##### Dependencies And Decisions

- D17, Decision Date: 2026-10-11.
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: Layer 1 mca, measComp, pmac (link), motor (declaration only); Layer 3 eventGeneratorSup, feed.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_BUSY`, remove `busy-src`, then `make BUSY`, `make conf.busy`, `make check.module-deps MODULE=busy`, `make build.busy`, `make symlink.busy`.
3. Reconfigure and rebuild mca, measComp, pmac, and motor in dependency order.
4. On Ubuntu 26, build busy with and without the bridge flag and record both results; apply the configuration change only when both pass.
5. Run T1 to T4 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `busy-src` was removed first; list the installed `cfg/` and `bin/` of the busy directory | Debian 13 and Rocky Linux 8.10 | Every target exits 0; `cfg/CONFIG_MODULE` and `cfg/BUSY_DEPS` are installed; no testBusyAsyn program is installed |
| T2 | Consumers | Reconfigure and rebuild mca, measComp, pmac, and motor; start the tc32sim loader fixture (measComp links busy) through the installed loader | Debian 13 and Rocky Linux 8.10 | Every dependent relinks against the new busy; the fixture IOC reaches `iocRun` with zero registration failures |
| T3 | C17 bridge | `make conf.busy` and `make build.busy` with the bridge flag, then with the conditional append removed | Ubuntu 26.04 workflow or guest | Both builds pass, or the failing build is recorded and the bridge stays |
| T4 | Installed tree | `make check.deps` and `make check.env` | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Ubuntu 26.04 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update busy to a4a272d
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T09:39:48Z

#### M13 - scaler Update

Origin: 1.5.0 / M13
Identity History: none
GitHub Issue: #106, https://github.com/jeonghanlee/EPICS-env/issues/106
Status: Not started

##### Summary

scaler moves from beb5521af49616682e4e442c3e33a06add1bd713 (2025-05-15) to head baa8e1c5e5a9a5deceef8cc39207a0da446092a6 (2026-06-07); no tag follows the pin. The change is the same cfg-based build mechanism as busy (`SCALER_DEPS`, `CONFIG_MODULE@`, `BUILD_IOCS`), the scalerApp test IOC moving to the opt-in `iocs/` directory, and documentation; scalerRecord.c and the device support are unchanged, so the Ubuntu 26 C17 bridge stays. The test IOC was built only when CALC was set, which `conf.scaler` does not do, so the installed tree loses nothing.

##### Scope

- Set `SRC_TAG_SCALER` and `SRC_VER_SCALER` to `baa8e1c` in `configure/RELEASE`.
- Rebuild and install scaler; reconfigure and rebuild mca and measComp.

Out of scope: the Layer 3 consumer eventGeneratorSup (G2); the C17 bridge, which stays.

##### Completion Criteria

- `make print-SRC_TAG_SCALER` prints `baa8e1c`.
- scaler builds and installs `cfg/CONFIG_MODULE` and `cfg/SCALER_DEPS` under its install directory; mca and measComp relink; `make check.deps` and `make check.env` exit 0.

##### Dependencies And Decisions

- M12 precedes this work as an ordering choice of D18, not a build dependency.
- D18, Decision Date: 2026-10-11.
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: Layer 1 mca (SIS), measComp; Layer 3 eventGeneratorSup.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_SCALER`, remove `scaler-src`, then `make SCALER`, `make conf.scaler`, `make check.module-deps MODULE=scaler`, `make build.scaler`, `make symlink.scaler`.
3. Reconfigure and rebuild mca and measComp.
4. Run T1 to T3 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `scaler-src` was removed first; list the installed `cfg/` of the scaler directory | Debian 13 and Rocky Linux 8.10 | Every target exits 0; `cfg/CONFIG_MODULE` and `cfg/SCALER_DEPS` are installed |
| T2 | Consumers | Reconfigure and rebuild mca and measComp; start the tc32sim loader fixture through the installed loader | Debian 13 and Rocky Linux 8.10 | Both dependents relink against the new scaler; the fixture IOC reaches `iocRun` with zero registration failures |
| T3 | Installed tree | `make check.deps` and `make check.env` | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update scaler to baa8e1c
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T09:39:55Z

#### M14 - std Update

Origin: 1.5.0 / M14
Identity History: none
GitHub Issue: #107, https://github.com/jeonghanlee/EPICS-env/issues/107
Status: Not started

##### Summary

std moves from 5f2e44214963b84ea3a400f7b7c3a9f510126ddd (2026-07-20) to head 27b696702c4ebc8c698c98e3bbb10a34f1a2c821 (2026-09-17); no tag follows the pin. Four commits change throttleRecord.c only: the delayed callback locks the record before `valuePut`, and the link-status flag is written for the correct link.

##### Scope

- Set `SRC_TAG_STD` and `SRC_VER_STD` to `27b6967` in `configure/RELEASE`.
- Rebuild and install std; reconfigure mca and measComp, whose generated `RELEASE.local` names the std install directory, and rebuild them.

Out of scope: the Layer 3 consumer feed, which links std (G2).

##### Completion Criteria

- `make print-SRC_TAG_STD` prints `27b6967`.
- std builds, installs, and symlinks; mca and measComp reconfigure and rebuild; `make check.deps` and `make check.env` exit 0.
- A throttle record processes in an IOC started from the installed tree.

##### Dependencies And Decisions

- D15, Decision Date: 2026-10-11.
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: no Layer 1 module links std; mca and measComp declare `build.std`; Layer 3 feed links std.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_STD`, remove `std-src`, then `make STD`, `make conf.std`, `make check.module-deps MODULE=std`, `make build.std`, `make symlink.std`.
3. Reconfigure and rebuild mca and measComp.
4. Run T1 to T3 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `std-src` was removed first | Debian 13 and Rocky Linux 8.10 | Every target exits 0; `modules/std-27b6967` is installed and symlinked |
| T2 | Record | Start an IOC through the installed loader with the std module loaded and a database holding one throttle record; write the input and read the output | Debian 13 and Rocky Linux 8.10 | The IOC reaches `iocRun` with zero registration failures; the throttle record processes and its link status reads OK |
| T3 | Installed tree | `make check.deps` and `make check.env` after mca and measComp rebuild | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update std to 27b6967
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T09:40:02Z

#### M15 - lua Update

Origin: 1.5.0 / M15
Identity History: none
GitHub Issue: #108, https://github.com/jeonghanlee/EPICS-env/issues/108
Status: Not started

##### Summary

lua moves from 17475b50ae95c801bad9573bb2b031ffb04ac75c (2025-05-20) to head 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d (2026-10-06); no tag follows the pin, and upstream's release notes name the state Release 4-0. The bundled Lua moves from 5.4.6 to 5.5.1 (`global` becomes a reserved word), LPeg 1.1.0 is embedded, device support is rewritten in C++ with per-state locking, the luascript record gains POPT, PCAL, IVOA, and IVOV and wider string fields, the run and state APIs are unified with the old names kept as deprecated aliases, `epics.sleep`, `pv:getName()`, and `pv.pv_name` are removed, the port driver callbacks take the self reference first, and the luaaa binding, its header, and the C++11 requirement are removed. The build moves to the cfg-based mechanism; the testLuaIoc and testLuaShell programs move to the opt-in `iocs/` directory; `re.lua`, `bytestream.lua`, and `seq.lua` are installed under `lib/<arch>/`, which `check.deps` and the loader metadata ignore because they select `*.so*`. No module in the three layers links lua or includes its headers.

##### Scope

- Set `SRC_TAG_LUA` and `SRC_VER_LUA` to `01aa7a1` in `configure/RELEASE`.
- Rebuild and install lua; reconfigure motor, which declares `build.lua`.
- Answer the Ubuntu 26 C17 bridge question for lua with real builds with and without `-std=gnu17`; if both pass, remove lua's conditional append from `conf.lua` in `configure/RULES_MODS_CONFIG` and update the rationale comment in `configure/CONFIG_MODS_DEPS` and the book.

Out of scope: lua commits after 01aa7a1; any site IOC script that uses lua, which this repository does not ship.

##### Completion Criteria

- `make print-SRC_TAG_LUA` prints `01aa7a1`.
- lua builds, installs `cfg/CONFIG_MODULE` and `cfg/LUA_DEPS`, and installs no testLuaIoc or testLuaShell program; `make check.deps` and `make check.env` exit 0.
- The C17 bridge decision for lua is recorded with the two real build results.
- The loader starts an IOC with lua loaded and `luaRunString` runs a chunk.

##### Dependencies And Decisions

- D16, Decision Date: 2026-10-11; its C17 bridge condition stays, and its test-suite condition is superseded by D31 (Decision Date: 2026-10-11).
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: none in Layer 1 (motor declares `LUA` for the motorScriptMotor submodule, which this build does not populate); none in Layer 2 or Layer 3.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_LUA`, remove `lua-src`, then `make LUA`, `make conf.lua`, `make check.module-deps MODULE=lua`, `make build.lua`, `make symlink.lua`; reconfigure motor.
3. On Ubuntu 26, build lua with and without the bridge flag and record both results; apply the configuration change only when both pass.
4. Run T1 to T4 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `lua-src` was removed first; list the installed `cfg/`, `bin/`, and `lib/<arch>/` of the lua directory | Debian 13 and Rocky Linux 8.10 | Every target exits 0; the cfg files and the three `.lua` files are installed; no testLuaIoc or testLuaShell program is installed |
| T2 | Loader | Start an IOC through the installed loader with lua loaded; run `luaRunString` with a chunk that reads a local PV through `epics.get` | Debian 13 and Rocky Linux 8.10 | The IOC reaches `iocRun` with zero registration failures; the chunk returns the PV value |
| T3 | C17 bridge | `make conf.lua` and `make build.lua` with the bridge flag, then with the conditional append removed | Ubuntu 26.04 workflow or guest | Both builds pass, or the failing build is recorded and the bridge stays |
| T4 | Installed tree | `make check.deps` and `make check.env` | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Ubuntu 26.04 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update lua to 01aa7a1
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-12; body projected from this detail; remote updated 2026-10-12T08:34:40Z

#### M16 - motor Update

Origin: 1.5.0 / M16
Identity History: none
GitHub Issue: #109, https://github.com/jeonghanlee/EPICS-env/issues/109
Status: Not started

##### Summary

motor moves from 285f44d66cf7d07a86047719de757bd1f5d92a95 (2025-12-12) to 4b22ac950de98c2dca324c2ef8ef221e124f6651 (2026-03-09), the commit after the R7-4 tag that corrects the version number in motorRecord.cc. The range adds the motorActVelocity parameter string and index to `asynMotorController.h` between existing members, which is safe in a full-source rebuild where motorMotorSim and pmac compile against the same header, fixes the motor_task loop that prevented IOC shutdown, fixes the RVEL readback, removes the deprecated register keyword, and adds STD to `modules/Makefile` for driver submodules this build does not populate. Head 47893ed removes NUM_MOTOR_DRIVER_PARAMS, which pmac 2-7-9 uses, and is excluded (D19).

##### Scope

- Set `SRC_TAG_MOTOR` and `SRC_VER_MOTOR` to `4b22ac9` in `configure/RELEASE`.
- Rebuild and install motor; reconfigure and rebuild motorMotorSim and pmac.

Out of scope: motor head 47893ed; pmac and motorMotorSim pins, which the survey reports as current.

##### Completion Criteria

- `make print-SRC_TAG_MOTOR` prints `4b22ac9`.
- motor, motorMotorSim, and pmac build, install, and symlink; `make check.deps` and `make check.env` exit 0.
- A simulated motor moves in an IOC started from the installed tree.

##### Dependencies And Decisions

- M12 and M15 precede this work: `motor_DEPS` requires `build.busy` and `build.lua`.
- D19, Decision Date: 2026-10-11.
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: Layer 1 motorMotorSim, pmac; none in Layer 2 or Layer 3.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_MOTOR`, remove `motor-src`, then `make MOTOR`, `make conf.motor`, `make check.module-deps MODULE=motor`, `make build.motor`, `make symlink.motor`.
3. Reconfigure and rebuild motorMotorSim and pmac.
4. Run T1 to T3 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `motor-src` was removed first | Debian 13 and Rocky Linux 8.10 | Every target exits 0; `modules/motor-4b22ac9` is installed and symlinked |
| T2 | Consumers | Reconfigure and rebuild motorMotorSim and pmac; start an IOC through the installed loader with motor and motorMotorSim loaded and one simulated axis; move it and read RBV | Debian 13 and Rocky Linux 8.10 | Both dependents relink; the IOC reaches `iocRun` with zero registration failures; the axis reaches the commanded position |
| T3 | Installed tree | `make check.deps` and `make check.env` | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update motor to 4b22ac9
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T09:40:16Z

#### M17 - caPutLog Update

Origin: 1.5.0 / M17
Identity History: none
GitHub Issue: #110, https://github.com/jeonghanlee/EPICS-env/issues/110
Status: Not started

##### Summary

caPutLog moves from dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 (2025-12-11) to R4.2 (6f9eb3f6c75e49201d114f8e194d53cef493a522, 2026-02-27). The three commits change `docs/index.rst` and `docs/releasenotes.rst` only, so the built code is identical to the pin and the move re-pins it to a release tag.

##### Scope

- Set `SRC_TAG_CAPUTLOG` to `tags/R4.2` and `SRC_VER_CAPUTLOG` to `4.2.0` in `configure/RELEASE`, after confirming the install directory naming the tree expects for a tag pin.
- Rebuild and install caPutLog; rebuild pyDevSup, whose pyIocApp links caPutLog.

Out of scope: the Layer 3 consumer eventGeneratorSup (G2).

##### Completion Criteria

- `make print-SRC_TAG_CAPUTLOG` prints `tags/R4.2`.
- caPutLog builds, installs, and symlinks; pyDevSup relinks; the commonIocsh caPutLog checks pass; `make check.deps` and `make check.env` exit 0.

##### Dependencies And Decisions

- D20, Decision Date: 2026-10-11.
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: Layer 1 `examples/commonIocsh` (caPutLog fragment and example IOC), pyDevSup pyIocApp; Layer 3 eventGeneratorSup.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_CAPUTLOG`, remove `caPutLog-src`, then `make CAPUTLOG`, `make conf.caPutLog`, `make check.module-deps MODULE=caPutLog`, `make build.caPutLog`, `make symlink.caPutLog`; rebuild pyDevSup.
3. Run T1 to T3 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `caPutLog-src` was removed first | Debian 13 and Rocky Linux 8.10 | Every target exits 0; the caPutLog 4.2.0 directory is installed and symlinked |
| T2 | Consumers | Run the commonIocsh caPutLog checks of `docs/procedures/commonIocsh-verification-procedure.md` against the rebuilt install; rebuild pyDevSup | Debian 13 and Rocky Linux 8.10 | The caPutLog assertions pass; pyDevSup relinks |
| T3 | Installed tree | `make check.deps` and `make check.env` | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update caPutLog to R4.2
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T09:40:23Z

#### M18 - pyDevSup Update

Origin: 1.5.0 / M18
Identity History: none
GitHub Issue: #97, https://github.com/jeonghanlee/EPICS-env/issues/97
Status: Not started

##### Summary

pyDevSup moves from 4527ed055a472d4688846a2cb64ac593fec1ecbb (2026-08-18) to 2.1.0 (b5cef38a6d9f74f9c59f967185ba6d1940637c03, 2026-10-05). The two commits add CHANGELOG.md only, so the built code is identical to the pin and the move re-pins it to a release tag. Head 80cdb15 (Python 3 fixes to the example IOCs, `archApp/bplstorage.db`) is not taken.

##### Scope

- Set `SRC_TAG_PYDEVSUP` to `tags/2.1.0` and `SRC_VER_PYDEVSUP` to `2.1.0` in `configure/RELEASE`.
- Rebuild and install pyDevSup.

Out of scope: pyDevSup head; the caPutLog it links, which M17 owns.

##### Completion Criteria

- `make print-SRC_TAG_PYDEVSUP` prints `tags/2.1.0`.
- pyDevSup builds, installs, and symlinks; a Python device-support record processes in a started IOC; `make check.deps` and `make check.env` exit 0.

##### Dependencies And Decisions

- D21, Decision Date: 2026-10-11.
- D26 sets the incremental platforms.
- D32, Decision Date: 2026-10-11, sets the build environment of the incremental platforms.
- Census: nothing in the three layers consumes pyDevSup; `conf.pyDevSup` keeps its optional caPutLog linkage as configured today.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Edit the two pin lines in `configure/RELEASE`.
2. Run `make reconf.modules`, `make print-INSTALL_LOCATION_PYDEVSUP`, remove `pyDevSup-src`, then `make PYDEVSUP`, `make conf.pyDevSup`, `make check.module-deps MODULE=pyDevSup`, `make build.pyDevSup`, `make symlink.pyDevSup`.
3. Run T1 to T3 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped targets of step 2 from a tree whose `pyDevSup-src` was removed first | Debian 13 and Rocky Linux 8.10 | Every target exits 0; `modules/pyDevSup-2.1.0` is installed and symlinked |
| T2 | Record | Start an IOC through the installed loader with pyDevSup loaded and one record using its Python device support; process it | Debian 13 and Rocky Linux 8.10 | The IOC reaches `iocRun` with zero registration failures; the record processes and the Python callback runs |
| T3 | Installed tree | `make check.deps` and `make check.env` | Debian 13 and Rocky Linux 8.10 | Both exit 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Update pyDevSup to 2.1.0
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T09:40:36Z

#### M22 - Module Check Runbook

Origin: 1.5.0 / M22
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The pvxs update ran its checks through commands composed in the session: the guest update sequence, the fresh-clone patch round trip, the loader suite invocation with its package list and environment variables, and the evidence commands. They survive only in session logs under `work/`, which the repository does not track. This work keeps them as tracked scripts and a procedure section, so that M10 to M18 and the next release run the same path without composing it again.

##### Scope

- Add `tools/module-check/guest-update.bash <module> <KEY> <commit>`, run as root in the guest checkout: fetch and check out the commit, `make reconf.modules`, print the module's install location, remove `<module>-src`, then `make <KEY>`, `make conf.<module>`, `make check.module-deps MODULE=<module>`, `make build.<module>`, and `make symlink.<module>`; afterwards print the SONAME of the installed shared library when the module has one and the `version=` line of its `cfg/iocsh.conf`.
- Add `tools/module-check/guest-roundtrip.bash <commit>`: clone the repository beside the baseline checkout at the commit, run `make init`, `make patch`, and `make patch.revert`, and print the `Patching` line count, the `Patching <module>-src` line count for a named module, and the `git status --short` line count of every source tree.
- Add `tools/module-check/guest-suite.bash`: check the suite's tools, start the minimal example IOC through the installed loader and report whether it reached `iocRun`, run `examples/iocsh/tests/run_all.bash` with `IOCSH_TEST_TREE`, `IOCSH_TEST_REPO`, and `IOCSH_TEST_OUT`, and print the per-script lines, the three count-less outputs, and the `FAIL` count.
- Add the Stage 6 section "On the epics-dev guests" to `docs/procedures/module-bump-procedure.md`: the resource request shape of D32, the packages the suite needs beyond the base guest, the three scripts and their arguments, the `make check.deps` and `make check.env` run, and which output goes into which Verification Results row of a module detail.

Out of scope: changes to the loader suite itself (M23); provisioning automation, which belongs to cloud-provision; the register schema.

##### Completion Criteria

- The three scripts pass `bash -n` and ShellCheck, print a usage line and exit non-zero on missing arguments, and print the values that the T1 to T5 rows of a module detail record.
- The sscan update (M10) runs its build, round trip, suite, and installed-tree checks through the scripts on both guests with no edit beyond the arguments.
- The procedure section names the scripts, the packages, and the register rows.

##### Dependencies And Decisions

- M9 supplies the commands and the observed outputs the scripts reproduce; this is work ordering, since M9's run is the source text.
- D32 fixes the environment the scripts assume.
- D33, Decision Date: 2026-10-12, places this work after M9 and before M10.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-12
Implementation Authorization: 2026-10-12
Superseded Plan Artifacts: none

1. Write the three scripts from the M9 session commands and the step 4, T2, and T3 logs, with arguments in place of the pvxs values.
2. Add the Stage 6 section to `docs/procedures/module-bump-procedure.md`.
3. Run T1 and record it; T2 is observed during M10 and recorded here.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | `bash -n` and `shellcheck` on the three scripts; each script invoked without arguments | Local checkout | The checks exit 0; each script prints a usage line and exits non-zero |
| T2 | Real use | The sscan update's build, round trip, suite, and installed-tree checks run through the scripts, as M10's T1 to T4 record | The two guests of D32 | M10's rows record Pass with the scripts' output and no script edit beyond arguments |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-12 | Local checkout, Debian 13, ShellCheck 0.10.0 | Pass | `bash -n` and `shellcheck` exited 0 on the three scripts; `guest-update.bash` and `guest-roundtrip.bash` without arguments and `guest-suite.bash` with three arguments each printed their usage line and exited 2; `guest-suite.bash` rejected a relative log directory with its usage line and a directory inside the checkout with a message, both at exit 2, before its tool check |
| T2 | 2026-10-12T20:02Z to 20:19Z | The two guests of D32, the sscan update (M10) at candidate f809b08 | Pass | `guest-update.bash sscan SSCAN f809b08` carried M10 / T1 on both guests, `guest-roundtrip.bash f809b08 sscan` carried M10 / T3 on the Debian 13 guest, and `guest-suite.bash` carried M10 / T4 on both guests, each exiting 0 and printing the values those rows record, with no edit to the scripts beyond the arguments |

##### Closure Evidence

- The scripts and the procedure section landed on `origin/release-1.5.0` in 88d3abe and their static checks in 4800137: after the push on 2026-10-12, `git rev-parse HEAD '@{upstream}'` and `git ls-remote --heads origin refs/heads/release-1.5.0` all read 48001375883fb3ad810bde88843872f8afef29bb.
- No issue is linked; the completion criteria are met by T1 and by T2 observed through the sscan update on 2026-10-12.

#### G1 - Layer 2 Release Line

Origin: 1.5.0 / G1
GitHub Issue: none
Status: Open

##### Summary

The internal and public products build Layer 2 (EPICS-env-support) on top of the Layer 1 tree, and the release selector of a run is the Layer 2 tag or release branch for 1.5.0, derived from this release line. That line is opened and tagged by the Layer 2 owner in that repository after the Layer 1 module selection is settled; the Layer 1 agent asks for it by message and never writes to that repository. Affected work: M19.

##### Completion Criteria

- The EPICS-env-support repository has a 1.5.0 release line and a `1.5.0` tag, both observed with `git ls-remote` against the repository URL.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| Not run | Pending | The Layer 2 session reported on 2026-10-11 that no 1.5.0 line exists and that it opens one on its owner's decision after the survey |

##### Closure Evidence

- None.

#### G2 - Layer 3 Release Line

Origin: 1.5.0 / G2
GitHub Issue: none
Status: Open

##### Summary

The internal product builds Layer 3 (the site module repository) on top of Layers 1 and 2, and the Layer 3 release selector for a run is derived from this release line. That line is opened and tagged by the Layer 3 owner in that repository after the Layer 1 module selection is settled; the Layer 1 agent asks for it by message and never writes to that repository. Affected work: M19.

##### Completion Criteria

- The site module repository has a 1.5.0 release line and a `1.5.0` tag, both observed with `git ls-remote` against the repository URL.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| Not run | Pending | The Layer 3 session reported on 2026-10-11 that no 1.5.0 line exists and that it opens one on its owner's decision after the survey |

##### Closure Evidence

- None.

#### M19 - Release EPICS-env 1.5.0

Origin: 1.5.0 / M19
Identity History: none
GitHub Issue: #100, https://github.com/jeonghanlee/EPICS-env/issues/100
Status: Blocked

##### Summary

Release EPICS-env 1.5.0 from `release-1.5.0`: re-run the checks that later module changes invalidate against the final combined tree, run the production environment tests, confirm the version fields, execute the release actions in the recorded order with separate authority each, verify the released objects, and close the cycle. The version field was set at branch open (8a603bb), so release readiness checks that commit and adds no version commit.

##### Scope

- Integrated re-runs of the module checks on the final combined tree, as the Integrated Verification table maps them.
- The production environment tests of the two products: the six OS workflows, the public gz build on six OS, and the internal build with Layer 3 and the alliocs consumer check on three OS, through the environment pipeline procedure.
- The `ChangeLog.md` 1.5.0 entry, the README and book paths naming 1.5.0, the release-note draft, and the readiness-evidence commit that is the release candidate.
- The release execution rows and their checkpoint commits, the released-tag installation, the tracker reconciliation, and the next-line record.

Out of scope: the ship runs into the two distribution repositories, which follow the pipeline's distribution procedure after the tag exists and are not part of this milestone's completion; the content of the module updates, which M9 to M18 own.

##### Completion Criteria

- Every non-final Milestone row is Complete or has an owner-approved assignment transfer, and G1 and G2 are Complete.
- Every Release Verification row is Pass with reachable real-path evidence.
- The merge commit, annotated tag, GitHub release, and milestone closure exist with their identifiers recorded, and the next release line's canonical path or the master generation register is recorded.

##### Dependencies And Decisions

- M9 to M18 precede this work; G1 and G2 gate it; resume as Not started when both gates are Complete.
- D25 as revised by D30 fixes the cycle order and D26 the verification cadence.
- The release follows the executed 1.4.0 sequence (`docs/milestone-1.4.0.md` M11 at `84ee626`) under the owner's release, milestone, git, and environment-pipeline procedures; D10 defers the reconciliation of those procedures to after this release.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. After the last module update, record the combined-tree comparison from each module's tested commit to the candidate tip and run the Integrated Verification re-runs (Release Verification 1 to 6).
2. Confirm the version field against 8a603bb (Release Verification 7); update the README and book paths that name the release and add the `ChangeLog.md` 1.5.0 entry in the format of the 1.4.0 entry, dated to the day of the merge and tag (Release Verification 12), as separately authorized commits.
3. Run the production environment tests of both products on the candidate (Release Verification 2, 3) and the released-tag installation after the tag exists (Release Verification 10).
4. Make the readiness-evidence commit, the release candidate; after it, any commit on the branch voids the candidate.
5. Execute the Release Execution rows in order, each after its own preview, preflight, and authority, with a checkpoint commit after each release-object or remote-state mutation.
6. Run the post-release Release Verification rows (8 to 11), prepare the closure record, reconcile the GitHub milestone and linked issues, and make the closure commit on master.

###### Checkpoint And Object Identity Rule

Before each release mutation, resolve its exact target and show the exact command with the applicable authority. After each release-object or remote-state mutation, observe the result, record it in this document, run the repository checks, and make a separately authorized checkpoint commit before any dependent action. Before the merge, checkpoint commits advance `release-1.5.0`; after the merge, they advance `master`. Every tag operation names the captured merge SHA, never the current HEAD. Before each push, capture the reviewed local tip; afterwards require the observed remote tip to equal it.

##### Integrated Verification

| Source Check | Re-run Trigger | Shared Surface | Release Verification Label | Expected Result | Result Evidence |
| --- | --- | --- | --- | --- | --- |
| M10 / T1, M11 / T1, M12 / T1, M13 / T1, M14 / T1, M15 / T1, M16 / T1, M17 / T1, M18 / T1, M9 / T1 | Any later module update changes the combined source and the installed library set | The whole module build, install, and dependency resolution | Release Verification 1 | All six OS workflows and the Linter succeed at the candidate | pending |
| M9 / T2 | Any change to `patch/` or to a pinned source after the pvxs carry removal | The shipped patch and reverse-patch aggregates | Release Verification 4 | Round trip clean on a fresh checkout at the candidate | pending |
| M9 / T3, M15 / T3, M16 / T2, M18 / T2 | The installed library set and loader metadata differ from the recorded module environment | The installed loader, its metadata, and the module libraries it loads | Release Verification 5 | The loader verification suite passes on the final combined tree | pending |
| M17 / T2 | The installed caPutLog, base, or fragment set differ from the recorded environment | The commonIocsh fragments and their consumer IOC | Release Verification 6 | The commonIocsh fragment suite passes on the final combined tree | pending |
| M10 / T2, M11 / T2, M12 / T2, M13 / T2, M14 / T2 | Later asyn-stack updates relink the dependents again | asyn, StreamDevice, mca, measComp, pmac, motorMotorSim and the fixture IOCs | Release Verification 2 | Gates 1 to 7, `check_deps`, and the alliocs consumer check pass on the internal product | pending |

##### Production Environment Tests

| Release Verification Label | Timing | System | Version | Architecture | Deployment Path | Method | Expected Result | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Release Verification 1 | post-change | Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04, Ubuntu 26.04 (CI) | 1.5.0 | linux-x86_64 | Each workflow's configured install tree | The six OS workflows and the Linter at the candidate commit | All succeed | run URLs, pending |
| Release Verification 2 | post-change | Debian 12, Debian 13, Rocky Linux 8.10 (internal product) | 1.5.0 | linux-x86_64 | `/opt/epics/1.5.0/<os>/7.0.10/` on fresh guests | Pipeline Stage 1 with Layers 1 to 3 at the derived selectors, Gates 1 to 7, `check_deps`, alliocs | Every gate passes; every consumer builds | pending |
| Release Verification 3 | post-change | Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04, Ubuntu 26.04 (public gz product) | 1.5.0 | linux-x86_64 | Fresh gz install tree per OS | `make build.gz`, install, `make check.deps`, `make check.env` through the pipeline | `check.deps` and `check.env` exit 0 on every OS | pending |
| Release Verification 10 | post-release | Debian 13, fresh production-equivalent host | 1.5.0 | linux-x86_64 | `$HOME/epics/1.5.0/debian-13/7.0.10` | The released `README.md` Prerequisites and Getting Started path from the `1.5.0` tag, then `make check.env`, `make check.deps`, and a started `softIoc`, after the storage preflight | Build, install, and checks succeed and the IOC starts | pending |

##### Version Changes

| Field | File | Before | Planned After | Pre-check | Pre-check Label | Post-check | Post-check Label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `ENV_RELEASE_VERS` | `configure/CONFIG_SITE` | 1.4.0 (origin/master 4d521e7) | 1.5.0, applied at branch open in 8a603bb | Inspect `8a603bb^` and the one-line diff of `8a603bb` | Release Verification 7 | Read the candidate `configure/CONFIG_SITE` and the installed path of Release Verification 2 and 10 | Release Verification 8 |

##### Release Execution

| Step | Action | Authorization | Expected Result | Evidence |
| --- | --- | --- | --- | --- |
| 1 | Readiness-evidence commit on `release-1.5.0` (the release candidate) | Commit/add scope | Full candidate SHA recorded | pending |
| 2 | Push `release-1.5.0` | Push scope | Remote tip equals the reviewed local tip and contains the candidate | pending |
| 3 | Local `master` fast-forward to `origin/master` | Explicit Sync scope | `master` current; `git rev-list --count release-1.5.0..master` prints 0 | pending |
| 4 | `--no-ff` merge of the recorded candidate SHA into `master`, subject `Merge release-1.5.0: EPICS Environment 1.5.0` | Release scope, previewed | Merge SHA observed and checkpointed | pending |
| 5 | Annotated tag `1.5.0` naming the merge SHA, message `EPICS Environment 1.5.0` | Release scope, previewed | Tag object and peeled commit observed and checkpointed | pending |
| 6 | Push `master` | Push scope | Remote tip equals the reviewed local tip and contains the merge | pending |
| 7 | Push `refs/tags/1.5.0` | Tag push scope | Remote tag object and peeled commit match | pending |
| 8 | GitHub release `1.5.0` from `work/release-notes-1.5.0.md` | Release scope, previewed | Published, not prerelease, Latest; ID, URL, and time recorded | pending |
| 9 | GitHub milestone 7 close | Release scope, previewed | Closed with zero open items | pending |
| 10 | Delete `release-1.3.0` locally and on origin when fully merged | User-run | Deletion or observed absence recorded | pending |
| 11 | Checkpoint and closure commits on `master` | Commit/add scope | Each recorded identifier committed before the next dependent action | pending |
| 12 | Final `master` push | Push scope | Remote tip equals the closure commit | pending |
| 13 | Next-line action: reset this register into the master generation `docs/milestone-<hash>.md` or open the next line, by owner decision | Document authority and separate Commit/add scope | The next canonical path exists and this register's entry point names it | pending |

Plan acceptance does not authorize any execution row. Immediately before each delegated action, re-show its exact command and complete the matching preflight.

##### Release Verification Plan

| Label | Layer | Timing | Method | Environment | Expected Result | Evidence Target |
| --- | --- | --- | --- | --- | --- | --- |
| Release Verification 1 | CI | post-change | The six OS workflows and the Linter at the candidate commit | GitHub Actions | All succeed | Run URLs |
| Release Verification 2 | Internal product | post-change | Pipeline Stage 1, Layers 1 to 3, Gates 1 to 7, `check_deps`, alliocs | Debian 12, Debian 13, Rocky Linux 8.10 guests | Every gate and consumer passes | `work/release-1.5.0-verification/` evidence tree |
| Release Verification 3 | Public product | post-change | gz build, install, `check.deps`, `check.env` | Six OS guests | Exit 0 on every OS | Same evidence tree |
| Release Verification 4 | Patch set | post-change | `make init`, `make patch`, `make patch.revert`, tree comparison on a fresh checkout | Debian 13 | Every source tree pristine after the revert | Same evidence tree |
| Release Verification 5 | Loader | post-change | The loader verification suite on the combined tree | Debian 13 and Rocky Linux 8.10 | Every check passes | Same evidence tree |
| Release Verification 6 | Fragments | post-change | The commonIocsh fragment suite on the combined tree | Debian 13 and Rocky Linux 8.10 | Every assertion passes | Same evidence tree |
| Release Verification 7 | Version | pre-change | Inspect `8a603bb^` and the diff of `8a603bb` | Repository | Before 1.4.0, after 1.5.0, one line changed | Commit identity |
| Release Verification 8 | Version | post-change | Read the candidate `configure/CONFIG_SITE` and the installed paths of Release Verification 2 and 10 | Repository and installed trees | Every path names 1.5.0 | Observed paths |
| Release Verification 9 | Release objects | post-release | Resolve the remote tag to its peeled commit and read the GitHub release flags | GitHub | Tag peels to the recorded merge; release published, not prerelease, Latest | Identifiers |
| Release Verification 10 | Installation | post-release | The released-tag installation method | Fresh Debian 13 host | Build, install, checks, and IOC start succeed | Evidence tree and run id |
| Release Verification 11 | Tracker | post-release | Read GitHub milestone 7 and every linked issue | GitHub | Milestone closed with zero open items; every linked issue matches its projection | Observed metadata |
| Release Verification 12 | Documentation | post-change | Read `ChangeLog.md`, `README.md`, and the book pages that name the release against the candidate | Repository | The 1.5.0 entry is dated to the tag day and every named path reads 1.5.0 | Commit identity |

##### Release Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| Release Verification 1 | Not run | GitHub Actions | Pending | none |
| Release Verification 2 | Not run | Internal product guests | Pending | none |
| Release Verification 3 | Not run | Public product guests | Pending | none |
| Release Verification 4 | Not run | Debian 13 | Pending | none |
| Release Verification 5 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| Release Verification 6 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| Release Verification 7 | Not run | Repository | Pending | none |
| Release Verification 8 | Not run | Repository and installed trees | Pending | none |
| Release Verification 9 | Not run | GitHub | Pending | none |
| Release Verification 10 | Not run | Fresh Debian 13 host | Pending | none |
| Release Verification 11 | Not run | GitHub | Pending | none |
| Release Verification 12 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Verify and publish EPICS-env 1.5.0
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T17:56:33Z


## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath upstream | Milestone | Deferred | No | D2, D29 | EPICS base ships `Normalize` and `RelPath` in `EPICS::Path` and a Perl `makeRPath` that consumes them, and this repository adopts that release at a pin bump; [detail](#m1---epicspath-normalizerelpath) |
| IOC shell | M2 | Promote commonIocsh to its public module repository | Milestone | Deferred | No | D3, D4 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m2---commoniocsh-promotion) |
| IOC shell | M3 | Ship a global iocsh startup file for the common services | Milestone | Deferred | No | D5 | `commonIocsh/iocsh/` ships one global startup file that loads the common-service fragments with optional serial configuration, and an example IOC boots with only that file; [detail](#m3---global-iocsh-startup-file) |
| Libera | M4 | Verify the Libera cross-build and generated profile | Milestone | Deferred | No | D6 | Real nine-module cross-build, generated-profile repetition, and documentation comparison pass; [detail](#m4---libera-cross-build-and-generated-profile) |
| macOS | M5 | Verify patch revert on actual macOS | Milestone | Deferred | No | D7 | Real macOS patch-revert cases pass with the Darwin mca path active, recorded patch executable, and preserved failure-boundary inventories; [detail](#m5---macos-patch-revert-verification) |
| Runtime | M6 | Verify the original opcua-IOC-demo startup against the Unified Automation example server | Milestone | Deferred | No | D8 | With `uaservercpp` running, the original `examples/iocsh/opcua-IOC-demo/st.cmd` reads its `Demo` records without alarm on Debian 13 and Rocky Linux 8.10; [detail](#m6---original-opcua-startup-data-path) |
| Upstream | M7 | Report the two Base site patches to the upstream EPICS base repository | Milestone | Deferred | No | D9 | One upstream issue or pull request each for the parser crash at end of input and the field-name suggestion crash, filed by the owner, with the site patches kept until an upstream release contains the fixes; [detail](#m7---upstream-report-of-the-base-site-patches) |
| Procedures | M8 | Reconcile the release-procedure records after the 1.5.0 release | Milestone | Deferred | No | D10 | Each listed discrepancy between this repository's documents and the owner's release, milestone, git, and environment-pipeline procedures is resolved or recorded as a closed door, and the documents agree with the 1.5.0 release as executed; [detail](#m8---release-procedure-reconciliation) |
| opcua | M20 | Make Eclipse Milo the default server of the OPC UA loader example | Milestone | Deferred | No | D27 | The documented default example prepares and connects with a reproducible Milo server image on Debian 13 and Rocky Linux 8.10, IOC and server restart cases have observed results, and the fixture README, book pages, and shipped suite agree; [detail](#m20---milo-opc-ua-example-server) |
| Modules | M21 | Migrate IOC record publishing from the recsync client to the reccaster repository | Milestone | Deferred | No | D24 | `configure/RELEASE` names the reccaster repository, the `recsync-src/client` special case is gone, the module builds and installs as `reccaster`, and the commonIocsh reccaster fragment publishes records to a running recceiver; [detail](#m21---reccaster-migration) |
| Loader | M23 | Count only records in the loader suite's minimal example | Milestone | Deferred | No | D33 | `verify_minimal_example.bash` reports the record count on a guest without hwmon and the suite README names the hwmon lines; [detail](#m23---loader-suite-record-count) |
| Procedure | M24 | Collect the lessons of the 1.5.0 cycle for the skills repository and the procedure reconciliation | Milestone | Deferred | No | D34 | Every listed lesson has landed in its destination or been handed to its owning session with the reply recorded; [detail](#m24---lessons-of-the-150-cycle) |

### Backlog Details

#### M1 - EPICS::Path Normalize/RelPath

Origin: 1.5.0 / M1
Identity History: none
GitHub Issue: #25, https://github.com/jeonghanlee/EPICS-env/issues/25
Status: Deferred

##### Summary

`makeRPath` computes relocatable `$ORIGIN`-relative rpath entries. Removing its bare-`python` dependency (the fragility behind #18) requires re-implementing in Perl the lexical path algebra Python's `os.path` provides as primitives; the earlier straight port (upstream PR #589) regressed at exactly this point and was reverted. The proper fix builds the missing primitive once in the shared module and has `makeRPath` consume it.

##### Scope

Additive extension of `src/tools/EPICS/Path.pm`, leaving `AbsPath` untouched: `Normalize($path)` (lexical, no-stat normalization of `.`, `..`, `//`, trailing slash) and `RelPath($target, $base)` (Normalize both, then relativize). The missing operation is lexical `..` collapse without `stat`: `File::Spec->abs2rel` does not normalize embedded `..`, `canonpath` does not collapse `..`, and `Cwd::abs_path` / `EPICS::Path::AbsPath` collapse `..` only by touching the filesystem, unusable for a not-yet-existing `--final` path. Full edge catalog: `docs/makeRPath-perl-port/relpath-design-analysis.md` at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the file is not on `master`.

Delivery (D29): an upstream epics-base submission that adds the primitives and `src/tools/makeRPath.pl`, removes `src/tools/makeRPath.py`, and repoints `MAKERPATH` in `configure/CONFIG_BASE` and the script entry in `src/tools/Makefile`; this repository adopts the result when a Base release that carries it is pinned. The local-patch delivery of D2 is superseded.

Out of scope: a straight port that hand-rolls the algebra inside the leaf tool.

##### Completion Criteria

- `makeRPath` consumes the shared `Normalize`/`RelPath` primitives.
- `AbsPath` is unchanged.
- The reverted straight-port regression does not recur on the edge catalog.

##### Dependencies And Decisions

- D2, Decision Date: 2026-10-02, assigned this work to the Milestone as a local patch on the pinned EPICS base; D29, Decision Date: 2026-10-11, moves it to the Backlog and supersedes that delivery with an upstream submission. A new dated decision assigns it again.
- The EPICS-env build runs `makeRPath.py` under `python3` through `configure/RULES_BASE` and requires `python3` for its own configuration (`configure/CONFIG_MODS`), so no prerequisite of this repository depends on this work.
- Existing artifacts: the corrected port, the 37-case parity driver, the test plan, and the upstream issue body under `docs/design/makeRPath-perl-port/`; the edge catalog and the API proposal at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the reverted upstream baseline and an unrun soak wiring on the same branch, which D29 does not keep.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Carry the edge catalog and the API proposal from the feature branch into `docs/design/makeRPath-perl-port/` with the two specification decisions of D29 recorded.
2. In a fork of epics-base at the pinned tag, add `Normalize` and `RelPath` to `src/tools/EPICS/Path.pm` with POD and a test under `src/tools/test/`, add `src/tools/makeRPath.pl` built on the corrected port, remove `src/tools/makeRPath.py`, and repoint `MAKERPATH` and the install entry.
3. Run T1 and T2 on the fork; open the upstream issue from the prepared body, then the pull request.
4. When a Base release carries the change, adopt it through the module bump procedure; until then nothing in this repository changes.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Path algebra | Run the 37-case parity driver `docs/design/makeRPath-perl-port/compare_makeRPath.sh` and the edge catalog cases against the fork's `makeRPath.pl` | Fork checkout with the pinned `makeRPath.py` as the reference | Every parity case matches the Python output byte for byte; every catalog case matches its specified result with no `stat` |
| T2 | Build | Build and install EPICS base from the fork and from the pinned tag into two roots on the same host; compare the `readelf -d` RUNPATH entries of every installed ELF object | Debian 13 and Rocky Linux 8.10 | The two RUNPATH sets are identical and `make check.deps` exits 0 on both trees |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Fork checkout | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Build EPICS::Path Normalize/RelPath primitives for makeRPath
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-11; remote updated 2026-10-11T17:56:27Z

#### M2 - commonIocsh Promotion

Origin: 1.5.0 / M2
Identity History: none
GitHub Issue: #76, https://github.com/jeonghanlee/EPICS-env/issues/76
Status: Deferred

##### Summary

The `commonIocsh` fragments and the global iocsh are developed and held in EPICS-env since the 1.4.0 fragment work (1.4.0 M6; D3 interim home). Their durable home is a dedicated public module named `commonIocsh` with its own repository, pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP` (D3). The 1.4.0 verification is complete on the interim home (T1/T2/T3 on Debian 13 and Rocky Linux 8.10); the promotion itself is deferred to this item per D4.

##### Scope

- Create the public `commonIocsh` repository from the interim in-tree fragments, preserving the `iocsh/` layout.
- Pin `commonIocsh` in EPICS-env's `configure/RELEASE` like every other module and install it under `modules/commonIocsh/`.
- Remove the interim in-tree copy from EPICS-env once the pinned module builds and installs.

Out of scope: any change to the fragment behavior verified under 1.4.0 M6; the `siteApps` de-duplication (84ee626 D3), which is the site owner's.

##### Completion Criteria

- The `commonIocsh` public repository exists and carries the verified fragments.
- EPICS-env pins `commonIocsh` in `configure/RELEASE` and installs it under `modules/commonIocsh/iocsh/`, resolved through `IOCSH_TOP`.
- The interim in-tree fragments are removed, and the installed-path checks (T1/T2/T3 of 1.4.0 M6) still pass on the two OS targets against the pinned module.

##### Dependencies And Decisions

- D3 sets the durable home: a dedicated public `commonIocsh` module, pinned and reached through `IOCSH_TOP`.
- D4 defers the promotion from the 1.4.0 fragment work to this Backlog item.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Create the public `commonIocsh` repository from the interim fragments, preserving the `iocsh/` layout.
2. Pin it in `configure/RELEASE` and build and install it under `modules/commonIocsh/`.
3. Remove the interim in-tree copy from EPICS-env.
4. Re-run the installed-path checks against the pinned module on the two OS targets.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Pinned-module install | Pin and install `commonIocsh`, remove the interim copy, and run the installed-path suite against the pinned module | Target-OS VMs (Debian 13, Rocky Linux 8.10) | The suite passes against the pinned module with no interim in-tree copy present |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Target-OS VMs | Pending | none |

##### Closure Evidence

- None; deferred to the Backlog per D4.

##### GitHub Projection

Title: Promote commonIocsh to its public module repository
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-21

#### M3 - Global iocsh Startup File

Origin: 1.5.0 / M3
Identity History: none
GitHub Issue: #79, https://github.com/jeonghanlee/EPICS-env/issues/79
Status: Deferred

##### Summary

The 1.4.0 fragment work (1.4.0 M6) shipped the `commonIocsh` fragment set and verified the services loading together in one IOC, but no single global iocsh file ships, and the example IOC exercises only the caPutLog fragment (`examples/commonIocsh/README.md`). D5 deferred the global startup file here.

##### Scope

- Add one global startup file under `commonIocsh/iocsh/` that loads the common-service fragments, with the optional IOC-owned serial configuration file of the 1.4.0 design (84ee626 D4 and D5).
- Make the example IOC boot with only that file for the common services.

Out of scope: changes to the individual fragments verified under 1.4.0 M6, and the D3 promotion tracked as M2.

##### Completion Criteria

- The global startup file loads the common services in one call and applies serial settings only when serial configuration is supplied.
- The example IOC passes the integrated checks using only the global startup file for the common services, on Debian 13 and Rocky Linux 8.10.

##### Dependencies And Decisions

- D5 defers the global startup file from the 1.4.0 fragment work to this item.

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

#### M4 - Libera Cross-Build And Generated Profile

Origin: 1.5.0 / M4
Identity History: none
GitHub Issue: none; #87 is the historical source of the Libera requirements and remains linked to the environment-script work (84ee626 M14)
Status: Deferred

##### Summary

The Libera module script uses the current sequencer targets in published commit `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. Its actual cross-build, generated-profile repetition, and documentation comparison require a real compiler, sysroot, and installed host/ARM base. These checks were separated from the native environment-script work on 2026-09-30 (D6), with the original acceptance, implementation, and verification evidence of that work retained, and the original #87 Libera requirements retained here on 2026-10-01.

##### Scope

- Preserve the published `scripts/build_modules_libera.bash` identifier correction from `sequencer-2-2` to `sequencer`, with `seq` as the installed link name.
- Retain the original #87 requirement to verify the obsolete target correction through actual `build_modules_libera.bash` execution against the real installed tree and current make targets; T1 owns that execution.
- Verify the real nine-module cross-build, installed profile, and repeated setup/reset using that profile.
- Maintain `docs/libera-cross-build.md` as the separate functional reference and verification requirements, linked from `scripts/README.md`.

Out of scope: relocation of either Libera script; changes to `build_base_libera.bash`, compiler or sysroot, module pins, configuration rules, or target-board `/opt` mapping; the completion of the native environment-script work; target-board runtime verification.

##### Completion Criteria

1. The real module script completes all nine build/install/symlink sequences, including current sequencer targets, and `modules/seq` resolves to the installed sequencer directory.
2. The actual installed profile has mode 0444 and nine target-board library paths independently derived from real make locations and the existing `/opt` mapping.
3. Repeated installed setup with the generated profile preserves directory order and retains each profile directory and the base library once. Unrelated library fields retain their bytes, duplicates, order, and empty fields. Reset removes the base library entry and retains the profile entries.
4. The dedicated reference agrees with actual prompts, module order, targets, links, profile bytes, and installation mode. All three actual checks pass; target queries, native products, or an invented profile do not count.

##### Dependencies And Decisions

- D6, Decision Date: 2026-09-30, excludes the Libera checks from the completion of the environment-script work and retains them as Deferred Backlog work. The selected extraction separates the document and preserves both script paths. Resume requires a new execution decision; no cross-build pass or Keep is inferred.
- Decision Date: 2026-10-01; retain only #87's Libera items here. Keep #87 as the native setup/reset issue linked to 84ee626 M14; its closure does not complete, retire, or authorize execution of any M4 check.
- Actual verification requires the real `arm-xilinx-linux-gnueabi` compiler and target sysroot selected by the shipped site file, and installed base products for both `linux-x86_64` and `linux-arm`.
- The configured compiler was absent when inspected on 2026-09-30. This is an unavailable preparation input, not a verification pass.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-30; retains the Libera requirements of the accepted combined environment-script plan (84ee626 M14); D6 authorizes their extraction without changing the requirements
Implementation Authorization: 2026-09-30; the original combined implementation authority covered the identifier correction; actual Libera execution is subsequently deferred by D6
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

The following premise observations come from the accepted combined environment-script plan (84ee626 M14) at baseline `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`. Their original T labels refer to that combined plan: original 84ee626 M14 / T7 maps to M4 / T1, its T3 profile case maps to M4 / T2, and its T8 Libera comparison maps to M4 / T3.

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
| T1 | Not run; deferred on 2026-09-30 | Real Libera compiler/sysroot unavailable | Pending: current sequencer targets and native seq mapping were inspected; no actual Libera script or cross-build pass is claimed | `work/m14-implementation-20260930/verification-summary.json`, `target-query.stdout`, and D6 |
| T2 | Not run; deferred on 2026-09-30 | Actual cross-build installation and generated profile unavailable | Pending: native path cases do not verify actual generated-profile repetition | `work/m14-implementation-20260930/shell-final/summary.json` records the unexecuted profile case; D6 |
| T3 | Not run; deferred on 2026-09-30 | Actual Libera outputs unavailable | Pending: source/reference extraction and local link checks do not verify runtime assertions | `work/m14-implementation-20260930/verification-summary.json` and D6 |

##### Closure Evidence

- The identifier correction, dedicated reference, README link, and D6 scope separation are published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` on `origin/master`, with publication confirmed at 2026-10-01T06:44:52.634205+00:00. This is source and document publication evidence; it does not complete or retire the deferred cross-build work.
- All three actual Libera checks remain Pending. Native CI success does not verify cross-build or generated-profile execution.

#### M5 - macOS Patch-Revert Verification

Origin: 1.5.0 / M5
Identity History: none
GitHub Issue: none; #88 remains linked to the clean, uninstall, and patch-revert work (84ee626 M15) and is the source of the patch-revert scope
Status: Deferred

##### Summary

The clean, uninstall, and patch-revert work (84ee626 M15) verified patch revert on actual Rocky Linux 10.2. Its Linux mca target is inactive; no real macOS execution is recorded. This separate work, split from that work's T2 on 2026-10-01 (D7), retains native macOS patch-revert verification, including the active Darwin mca target, without delaying that completion or changing its runtime code.

##### Scope

- Verify the shipped individual and aggregate revert targets on actual macOS with real pinned sources and patch files, preserving the Darwin condition.
- Exercise the active `patch.mca.apply` and `patch.mca.revert` paths with confirmed unapplied, applied, repeated, conflicting, and missing-input states.
- Verify whole-patch classification, reverse order, stack prefixes, independent source edits, existing backups, and errors through the shared revert helper.
- Record actual command resolution, versions, source pins, statuses, outputs, and source inventories, including ignored rejection and backup files.

Out of scope: the completed Linux checks of 84ee626 M15; std cleanup or general macOS build qualification; changes to module pins, patch contents, apply recipes, or platform conditions; Libera M4; other milestone work.

##### Completion Criteria

1. Actual macOS execution activates the Darwin mca path without replacing `uname`, make, the revert helper, or the patch executable with a substitute.
2. Confirmed unapplied, applied, supported partial sets of whole patches, and repeated revert return 0; actual patch order and source inventories agree, preserving unrelated edits and existing backups.
3. Conflicting, partially applied individual patches, missing required inputs, and unresolved states fail with the source and patch identified. Sources and inventories match the actual failing-patch boundary; earlier completed reversals remain, later reversals do not run, and no new `.rej` or `.orig` files appear on classification failure.
4. Evidence names the real macOS version, architecture, make, Bash, patch executable and version, source pins, commands, timestamps, and outputs. Linux results or a forced Darwin variable do not satisfy these checks.

##### Dependencies And Decisions

- D7, Decision Date: 2026-10-01, retains this scope as Deferred Backlog and excludes it from the completion of 84ee626 M15. A new execution decision is required to resume; no macOS verification pass or Keep is inferred.
- Preparation must inspect the commands actually selected by the macOS environment, including whether the selected patch supports the shipped GNU patch options. Missing preparation inputs are not successful checks.
- The Linux ptrace observer used by 84ee626 M15 is not a macOS observation procedure. Review and validate a native method that captures the real failing-patch boundary before executing failure-preservation cases.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On a new execution decision, review this draft and prepare an isolated real macOS checkout, HOME, and writable test roots; preserve the owner's checkout, installation, and previous evidence.
2. Inspect the actual platform, architecture, make, Bash, patch executable, option support, pins, and target activation. Validate the native boundary observation procedure before any failure case; do not substitute an internal program or reconstruct expected source files.
3. Run the shipped individual and aggregate patch paths on independently restored pinned source trees, compare real inventories, and retain exact commands and observations under ignored `work/`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Platform and successful revert | Inspect real command resolution and platform, then execute individual mca and aggregate apply/revert with none/all applied, stack prefixes, independent source shifts, and repetition | Actual macOS; isolated real pinned source checkouts; shipped make, helper, and patch files; recorded patch executable | Darwin mca path is active; successful cases return 0 in the expected reverse order; repeated revert changes nothing; unrelated edits and existing backups survive |
| T2 | Failure preservation | Use controlled edits to real patch-owned files and required-input absence; capture the real first failing boundary with a validated native observation procedure, then let the shipped invocation finish | Same actual macOS environment; independent writable cases; unchanged internal programs and original protected trees outside the writable roots | Actual target fails with source/patch diagnostics; failing-boundary inventory equals final inventory; preceding reversals remain, later reversals do not run, and no new rejection or backup files appear |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-10-01 | Actual macOS execution not performed | Pending: the Linux inactive mca result of 84ee626 M15 does not verify the active Darwin path or native helper execution | D7; 84ee626 M15 / T2 records only the executed Linux scope |
| T2 | Not run; deferred on 2026-10-01 | Native macOS boundary observation not prepared or executed | Pending: no macOS failure-preservation result is claimed | D7; native observation procedure requires review before execution |

##### Closure Evidence

- None. The scope separation records Deferred work only; the publication of 84ee626 M15 or #88 closure does not complete, retire, or authorize execution of M5.

#### M6 - Original opcua Startup Data Path

Origin: 1.5.0 / M6
Identity History: none
GitHub Issue: none in this repository; #93 remains linked to the loader work (84ee626 M23) and states this check as pending. jeonghanlee/opcua-IOC-demo#1 proposes replacing the Unified Automation server in the application with an open-source server
Status: Deferred

##### Summary

The loader work (84ee626 M23) verifies the opcua-IOC-demo data path with the Eclipse Milo startup variant. The original startup of the application reads nodes that only the Unified Automation example server `uaservercpp` provides, and no such server was available. This work, split from that work's T13 on 2026-10-04 (D8), keeps that check without delaying the loader work.

##### Scope

- Run the original `examples/iocsh/opcua-IOC-demo/st.cmd` through the installed `iocsh.bash` against a running `uaservercpp` at its default address `opc.tcp://127.0.0.1:48020`.
- Read the records of the eight `Demo` databases and of `Demo.WorkOrder` through CA, and judge them by the criteria of the fixture `README.md`: no alarm, the `Demo.Dynamic` records advancing their timestamps within the 200 millisecond subscription plus 2 seconds, and a read answering within 5 seconds.

Out of scope: the loader behavior and the Milo variant, which the loader work verifies; a server written to imitate the `Demo` nodes.

##### Completion Criteria

1. The session of the original startup connects to a real `uaservercpp` on Debian 13 and Rocky Linux 8.10.
2. The records meet the fixture criteria, and the evidence names the server version and the bundle it came from.

##### Dependencies And Decisions

- D8, Decision Date: 2026-10-04, keeps this scope as Deferred Backlog and excludes it from the completion of the loader work. A new execution decision is required to resume, when the server bundle is available.
- The server comes from a Unified Automation software bundle, which needs a registered download.
- jeonghanlee/opcua-IOC-demo#1, opened on 2026-10-04, proposes that the application use an open62541-based server or the Eclipse Milo demo server. When the application changes that way, its original startup no longer needs `uaservercpp`; the fixture then follows the new application revision and this work is re-examined.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On a new execution decision, obtain the bundle and start `uaservercpp` on each target.
2. Run the fixture with its original startup and record the results against the fixture criteria.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Data path | Start `uaservercpp`, prepare the fixture run directory, start the original startup through the installed wrapper, and read the `Demo` records twice through CA | Candidate installations on Debian 13 and Rocky Linux 8.10; a real `uaservercpp` | The session connects; the records read without alarm; the `Demo.Dynamic` records change value and timestamp between the reads |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-10-04 | No `uaservercpp` available | Pending: the original startup reaches `iocInit` and its records read `INVALID` with `COMM` without the server, recorded under 84ee626 M23 / T13 | D8 |

##### Closure Evidence

- None. The separation records Deferred work only; the completion of the loader work or #93 closure does not complete or authorize M6.

#### M7 - Upstream Report Of The Base Site Patches

Origin: 1.5.0 / M7
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

The Base site patches `patch/7.0.10-site01-dbyacc-eof.p0.patch` and `patch/7.0.10-site02-dbstatic-device-menu.p0.patch` correct two segmentation faults of the EPICS base database loader that exist in R7.0.10 and in the 7.0 branch observed on 2026-10-05. Report both to the upstream EPICS base repository so that a later release carries them and the site patches can be dropped at a pin bump.

##### Scope

- One upstream issue or pull request for the parser crash at end of input and one for the field-name suggestion crash, each with its reproduction files, the observed fault location, and the patch.
- The owner files them; this repository records the upstream references when they exist.

Out of scope: any change to the carried patches, which the two site-patch works (84ee626 M25 and M30) own.

##### Completion Criteria

1. Each defect has an upstream reference, or the owner records that it is not reported, with the reason.

##### Dependencies And Decisions

- D9, Decision Date: 2026-10-05, defers the report until the owner chooses to file it.
- The carry rules admit only fixes merged upstream, so the site patches stay until an upstream release above the pin contains the fixes.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Prepare the two upstream texts from the reproduction files of the two site-patch works when the owner asks for them.
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

#### M8 - Release Procedure Reconciliation

Origin: 1.5.0 / M8
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

The documents that describe how this repository is released disagree in places, between this repository and the owner's procedures and among those procedures. The 1.5.0 cycle follows the 1.4.0 precedent as executed (D10); after the 1.5.0 release, bring the records into agreement with what was executed.

##### Scope

The discrepancies found on 2026-10-10 while opening this line:

- The time of the version change: the owner's git release procedure describes a release-eve bump from a `-dev` version, its own notes and the environment-pipeline procedure set `ENV_RELEASE_VERS` at branch-open without `-dev`, and the release-cycle procedure describes a version commit during readiness. This repository sets the value at branch-open; the procedures should say so in one place.
- The changelog: `ChangeLog.md` uses `### <version> <date> <author>` headings and the release merge uses the subject `Merge release-X.Y.Z: EPICS Environment X.Y.Z`; the git release procedure describes a `CHANGELOG.md` with a moniker heading and release notes derived from it, and the release-cycle procedure has no changelog step.
- Issue closure in a release line: direct closure on the release branch and `Closes` footers at the master merge both occur in the 1.3.0 to 1.4.0 history; the git procedure describes only the footer route, and its milestone procedure presumes a status document this repository does not have. The GitHub milestone of this line also received the issues closed by master work before the line opened.
- The route map: an earlier 1.5.0 attempt, not on this line, tracked `docs/procedures/epics-env-release-route.md` and cited an environment-pipeline reference that does not exist; decide whether a route map belongs in this repository and, if so, write it against the executed 1.5.0 route.
- The register reset: the 1.4.0 reset deleted the prior canonical file, as the milestone procedure requires; the earlier attempt kept it under a snapshot banner and added a register for a future line, which the procedure does not allow.
- Stale statements: the environment-pipeline procedure names a role default of `release-1.3.0` and predates the installed-module loader and the Base site patches; the git milestone procedure gates on a `docs/STATUS.md`.
- Procedure copies: the owner's procedures differ between working hosts; synchronize the copies before the next cycle opens.

Out of scope: changes to the 1.5.0 procedure while the cycle runs; the content of the procedures beyond their agreement with the executed route; the work content of the earlier 1.5.0 attempt.

##### Completion Criteria

1. Each listed discrepancy is resolved in its owning document or recorded in `docs/CLOSED_DOORS.md` as kept, with the reason.
2. `docs/README.md`, `ChangeLog.md`, and the procedures under `docs/procedures/` agree with the 1.5.0 release as executed.
3. The owner's procedures name one place for the version change and one for the changelog, and the route map question is decided.

##### Dependencies And Decisions

- D10, Decision Date: 2026-10-10, defers this work until after the 1.5.0 release.
- The 1.5.0 release record in this document is the input; the work starts after the cycle closes.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. After the 1.5.0 closure, compare each listed discrepancy against the executed 1.5.0 route recorded in this document.
2. Correct the documents in this repository; propose the corrections of the owner's procedures in their own repository.
3. Record kept shapes in `docs/CLOSED_DOORS.md`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Documents | Read each listed document against the executed 1.5.0 route and the corrected text | Repository checkout and the owner's procedure files | No listed discrepancy remains, or each is a recorded closed door |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |

##### Closure Evidence

- None; deferred by D10.


#### M20 - Milo OPC UA Example Server

Origin: 1.5.0 / M20
Identity History: none
GitHub Issue: #99, https://github.com/jeonghanlee/EPICS-env/issues/99
Status: Deferred

##### Summary

Make Eclipse Milo the primary server of the OPC UA loader example, so the documented example needs no Unified Automation server installation. The Milo variant reads real server values today, but the fixture README and test record a second IOC session failing with `INVALID` and `COMM` unless the server is restarted. The application boundary is coordinated with jeonghanlee/opcua-IOC-demo#1; this work owns the EPICS-env fixture, book pages, and shipped verification script.

##### Scope

- Make the default startup and preparation use real Milo nodes and a reproducible server image identity.
- Align the fixture README, the book pages, the shipped verification script, and the expected test results with the default example.
- Exercise IOC restart without server restart and server stop and start, then document and verify the accepted recovery behavior.
- Preserve unrelated containers and installations during verification.

Out of scope: an imitation of Unified Automation nodes, acquisition of its proprietary server, an implicit opcua or open62541 module upgrade, and the original-startup data path kept as M6.

##### Completion Criteria

- The documented default example prepares and connects without proprietary server files on Debian 13 and Rocky Linux 8.10.
- Server identity, device support, subscription updates, values, timestamps, alarms, and bounded reads are checked through the real installed module and IOC.
- IOC and server restart cases have observed results; any remaining limitation is explicitly accepted and documented.
- Startup path compatibility, preparation, documentation, and the shipped suite agree, and no unexecuted Unified Automation check is represented as a Milo result.

##### Dependencies And Decisions

- D27, Decision Date: 2026-10-11, keeps this work out of 1.5.0 as Deferred Backlog work; a new dated decision assigns it.
- M6 keeps the original-startup data path against the Unified Automation server; the two are examined together when either resumes.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On assignment, select the reproducible Milo server image identity and record it in the fixture README.
2. Switch the default startup and preparation to the Milo nodes; update the book pages and the shipped verification script.
3. Run the fixture through the installed loader on both platforms, including the restart cases, and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Fixture | Prepare and start the opcua-IOC-demo fixture through the installed loader against the selected Milo server image; read the records; restart the IOC without restarting the server; stop and start the server | Debian 13 and Rocky Linux 8.10, installed tree | The session connects, the records read without alarm, and each restart case has an observed result |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None; deferred by D27.

##### GitHub Projection

Title: Use Milo as the default OPC UA loader example server
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-11; remote updated 2026-10-11T09:40:55Z

#### M21 - reccaster Migration

Origin: 1.5.0 / M21
Identity History: none
GitHub Issue: #101, https://github.com/jeonghanlee/EPICS-env/issues/101
Status: Deferred

##### Summary

The recsync repository stopped carrying the IOC client: from 1.10.0 its `client/` directory holds only a Makefile that announces the move and exits 1, while releases through 1.9.6 still carry it. The client now lives in ChannelFinder/reccaster, whose newest tag 1.9.7 is bebf91f54faf93a59eb4538d3594a687a8823963 (2026-08-19) with no shared history with the pinned recsync commit 9834b94edc63eece42712b8355a4703d4286dd8f. Moving forward means switching the module source to the reccaster repository, which is module source work rather than a version bump.

##### Scope

- Point the module at the reccaster repository in `configure/RELEASE` (`SRC_BASE`, `SRC_NAME`, pin) and remove the `recsync-src/client` path special case in `configure/CONFIG_MODS`.
- Keep the installed names `reccaster` and `reccaster.dbd`, which the commonIocsh reccaster fragment and the loader metadata use.
- Update the module pins page and the add-or-bump procedure of the book.

Out of scope: the recceiver server side; any change to the commonIocsh fragment beyond what the new source requires.

##### Completion Criteria

- `configure/RELEASE` names the reccaster repository and a release tag of it; `make init` fetches it without the client path special case.
- The module builds, installs, and symlinks as `reccaster` on Debian 13 and Rocky Linux 8.10; `make check.deps` and `make check.env` exit 0.
- The commonIocsh reccaster fragment publishes an IOC's records to a running recceiver, observed through the recceiver's output.

##### Dependencies And Decisions

- D24, Decision Date: 2026-10-11, holds recsync at the pin for 1.5.0 and names this migration as separate work; a new dated decision assigns it to a release line.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On assignment, compare the pinned client tree with the selected reccaster tag file by file and record the behavioral differences.
2. Edit `configure/RELEASE` and `configure/CONFIG_MODS`; run `make init`, the configuration target, `make check.module-deps MODULE=recsync` or its renamed form, build, install, and symlink.
3. Run the commonIocsh reccaster fragment check against a running recceiver and record the result.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped init, configure, audit, build, install, and symlink targets from a tree without the old source | Debian 13 and Rocky Linux 8.10 | Every target exits 0; the module installs as `reccaster` with `reccaster.dbd` |
| T2 | Fragment | The commonIocsh reccaster fragment check of `docs/procedures/commonIocsh-verification-procedure.md` with a running recceiver | Debian 13 and Rocky Linux 8.10, installed tree | The recceiver records the IOC's channels |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None; deferred by D24.

##### GitHub Projection

Title: Migrate IOC record publishing to reccaster for 1.6.0
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-11; remote updated 2026-10-08T00:00:30Z
#### M23 - Loader Suite Record Count

Origin: 1.5.0 / M23
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

`examples/iocsh/tests/verify_minimal_example.bash` reports `records listed` as the count of output lines that begin with `EPICSENV:`. On the Debian 13 epics-dev guest, a cloud guest without `/sys/class/hwmon`, linStat prints five error lines that begin with a record name, so the count read 322 for the same 317 records that the Rocky Linux 8.10 guest listed, and the suspicious-lines section held those five lines (M9 / T3, 2026-10-12). The suite README expects 317 and no suspicious line.

##### Scope

- Count only the record list, so that an error line beginning with a record name is not counted as a record.
- State in the suite README that a guest without `/sys/class/hwmon` prints the five linStat hwmon lines, and keep the expected count at 317 for the current pins.

Out of scope: linStat's behaviour on a host without hwmon; the hwmon records themselves.

##### Completion Criteria

- On the Debian 13 guest the count line reads 317 and the README names the hwmon lines as an environment output.

##### Dependencies And Decisions

- D33, Decision Date: 2026-10-12: deferred until the release work refreshes the suite counts.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Change the count expression of `verify_minimal_example.bash` to the record list.
2. Add the hwmon note to `examples/iocsh/tests/README.md`.
3. Run T1 and record it.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Real path | `run_all.bash verify_minimal_example` after the change | The Debian 13 guest of D32 | The log reads `records listed: 317` and the README names the hwmon lines |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | The Debian 13 guest of D32 | Pending | none |

##### Closure Evidence

- None; deferred by D33.

#### M24 - Lessons of the 1.5.0 Cycle

Origin: 1.5.0 / M24
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

Lessons that a module update or a review pass produced and that no procedure of this repository can hold: how the sessions work, and the release-procedure decisions that D10 defers to the reconciliation after the release (M8). Procedure lessons go into the procedures at the step that produced them (D34) and are not listed here. The list grows during the cycle; each item names its destination.

##### Scope

For the skills repository (agent-review, milestone-tracking, agent-collaboration, git-workflow references), observed in the pvxs update:

- A full-read pass from a seat not yet taken finds what angle passes miss: the second-person pass from the implementer's seat found that the installed linStat links no pvxs, after four third-person passes verified the link at source level; the procedure owner's seat found the contradiction between Stage 6 step 3 and the guest section.
- A fact that replaces an owner's decision is surfaced as a decision change, not written in silently: the install root rule of the local host was replaced by the role's `/opt/epics` without saying so until the owner-seat pass.
- The entry point holds the state; review history goes to commit messages, not to the register.
- The register's structural checks (heading nesting, detail links, table widths, D and M references, consecutive T labels, plan gate fields, the release detail's own subsections) ran from a scratchpad script; they belong to the milestone-tracking skill as a tracked asset.
- The test VM request protocol worked across three sessions on one host; the provider needed its owner's approval for a host change (an inactive libvirt network) and for running the requester's build commands on the guests.
- An issue closes in three steps: the body synced with checked acceptance items and results, the close comment, the close; the register records the observed times afterwards.

For the procedure reconciliation after the release (M8): the test-scope decisions of this cycle, D31 (no upstream test suites), the full fresh-checkout round trip kept as a module check, and `patch/README.md` keeping no history text, become rules of the release procedure or are reversed there.

Out of scope: procedure lessons, which D34 routes into the procedures at each step; the loader suite's record count (M23).

##### Completion Criteria

- Each skills item is handed to the session that owns the skills repository with its reply recorded here, or applied there with the commit named.
- Each reconciliation item is settled in M8 with the decision recorded.

##### Dependencies And Decisions

- D34, Decision Date: 2026-10-12.
- D10 defers the procedure reconciliation to M8 after the release.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Keep appending items with their destination during the cycle.
2. At the cycle's close, send the skills items to the skills repository's session as one request and record the reply.
3. Hand the reconciliation items to M8.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Hand-off | The skills request sent and answered; each M8 item named in M8's detail | This register and the skills repository's session | Every item has a destination record |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | This register and the skills repository's session | Pending | none |

##### Closure Evidence

- None; deferred by D34.

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-10-10 | `4d521e7a0f05163d39541c0357e966397433b027` (`docs/milestone-84ee626.md`) |
