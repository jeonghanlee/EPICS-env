# Work Register

Release line: 1.5.0
Milestone index: 1.5.0
Canonical path: `docs/milestone-1.5.0.md`
Canonical branch or ref: `release-1.5.0`
Git upstream: none until the branch is pushed; then `origin/release-1.5.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.5.0, number 7

Next session entry point: Run the 1.5.0 module survey under `docs/procedures/module-bump-procedure.md` with `tools/update-release.bash check`, present the candidate table and the census for the owner's IN/HOLD decisions, and add each selected module update to this Milestone as its own work unit; then order the cycle, add the final release milestone, and make the planning commit (release-cycle phases 1-6). M1 is Ready and takes the place the accepted order gives it. GitHub milestone 7 holds 22 closed issues from the master work between 1.4.0 and this line and three open issues (#98, #99, #100) projected from an earlier 1.5.0 register that is not on this line; their disposition is decided in the planning step. `ENV_RELEASE_VERS` is 1.5.0 in `configure/CONFIG_SITE` from the first commit of this line. References of the form `84ee626 M<n>`, `84ee626 D<n>`, or `84ee626 M<n> / T<k>` point to `docs/milestone-84ee626.md` at `4d521e7`; references of the form `1.4.0 M<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | Yes | D2 | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m1---epicspath-normalizerelpath) |

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

### Milestone Details

#### M1 - EPICS::Path Normalize/RelPath

Origin: 1.5.0 / M1
Identity History: none
GitHub Issue: #25, https://github.com/jeonghanlee/EPICS-env/issues/25
Status: Not started

##### Summary

`makeRPath` computes relocatable `$ORIGIN`-relative rpath entries. Removing its bare-`python` dependency (the fragility behind #18) requires re-implementing in Perl the lexical path algebra Python's `os.path` provides as primitives; the earlier straight port (upstream PR #589) regressed at exactly this point and was reverted. The proper fix builds the missing primitive once in the shared module and has `makeRPath` consume it.

##### Scope

Additive extension of `src/tools/EPICS/Path.pm`, leaving `AbsPath` untouched: `Normalize($path)` (lexical, no-stat normalization of `.`, `..`, `//`, trailing slash) and `RelPath($target, $base)` (Normalize both, then relativize). The missing operation is lexical `..` collapse without `stat`: `File::Spec->abs2rel` does not normalize embedded `..`, `canonpath` does not collapse `..`, and `Cwd::abs_path` / `EPICS::Path::AbsPath` collapse `..` only by touching the filesystem, unusable for a not-yet-existing `--final` path. Full edge catalog: `docs/makeRPath-perl-port/relpath-design-analysis.md` at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the file is not on `master`.

Delivery (D2): one local patch on the pinned EPICS base adds the primitives and `src/tools/makeRPath.pl`, removes `src/tools/makeRPath.py`, and repoints `MAKERPATH` in `configure/CONFIG_BASE` and the script entry in `src/tools/Makefile`. The patch has its own apply and revert rule and a row in `patch/README.md`.

Out of scope: a straight port that hand-rolls the algebra inside the leaf tool.

##### Completion Criteria

- `makeRPath` consumes the shared `Normalize`/`RelPath` primitives.
- `AbsPath` is unchanged.
- The reverted straight-port regression does not recur on the edge catalog.

##### Dependencies And Decisions

- D2, Decision Date: 2026-10-02, assigns this work to the Milestone and selects delivery as a local patch on the pinned EPICS base. Its earlier ordering dependency, the relocation work recorded as 84ee626 M16, is Complete; no ordering dependency remains.

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
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-09; GitHub milestone Backlog

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| IOC shell | M2 | Promote commonIocsh to its public module repository | Milestone | Deferred | No | D3, D4 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m2---commoniocsh-promotion) |
| IOC shell | M3 | Ship a global iocsh startup file for the common services | Milestone | Deferred | No | D5 | `commonIocsh/iocsh/` ships one global startup file that loads the common-service fragments with optional serial configuration, and an example IOC boots with only that file; [detail](#m3---global-iocsh-startup-file) |
| Libera | M4 | Verify the Libera cross-build and generated profile | Milestone | Deferred | No | D6 | Real nine-module cross-build, generated-profile repetition, and documentation comparison pass; [detail](#m4---libera-cross-build-and-generated-profile) |
| macOS | M5 | Verify patch revert on actual macOS | Milestone | Deferred | No | D7 | Real macOS patch-revert cases pass with the Darwin mca path active, recorded patch executable, and preserved failure-boundary inventories; [detail](#m5---macos-patch-revert-verification) |
| Runtime | M6 | Verify the original opcua-IOC-demo startup against the Unified Automation example server | Milestone | Deferred | No | D8 | With `uaservercpp` running, the original `examples/iocsh/opcua-IOC-demo/st.cmd` reads its `Demo` records without alarm on Debian 13 and Rocky Linux 8.10; [detail](#m6---original-opcua-startup-data-path) |
| Upstream | M7 | Report the two Base site patches to the upstream EPICS base repository | Milestone | Deferred | No | D9 | One upstream issue or pull request each for the parser crash at end of input and the field-name suggestion crash, filed by the owner, with the site patches kept until an upstream release contains the fixes; [detail](#m7---upstream-report-of-the-base-site-patches) |
| Procedures | M8 | Reconcile the release-procedure records after the 1.5.0 release | Milestone | Deferred | No | D10 | Each listed discrepancy between this repository's documents and the owner's release, milestone, git, and environment-pipeline procedures is resolved or recorded as a closed door, and the documents agree with the 1.5.0 release as executed; [detail](#m8---release-procedure-reconciliation) |

### Backlog Details

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

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-10-10 | `4d521e7a0f05163d39541c0357e966397433b027` (`docs/milestone-84ee626.md`) |
