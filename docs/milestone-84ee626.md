# Work Register

Release line: master
Milestone index: 84ee626
Canonical path: `docs/milestone-84ee626.md`
Canonical branch or ref: `iocsh-module-loader`
Git upstream: none
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone Backlog, number 3

Next session entry point: M22's plan is accepted on 2026-10-02 (the D56-D60 revision with the D61, D62, and D63 amendments) in `docs/milestone-84ee626.md` on `iocsh-module-loader`, and implementation is authorized on the same date. Issue #93 is reconciled with the plan including the D61 through D73 amendments as of 2026-10-04 02:32:06 UTC. Implementation Plan steps 1 through 3 are on the branch: `configure/CONFIG_MODS_IOCSH`, `tools/iocsh_metadata.bash`, the build, install, and alias rule wiring, and the rewritten wrapper `tools/iocsh.bash`; All six OS workflows and the Linter succeed at `862841b31435421ff4a260aeee8082b3a6eb9ba3`, which is a partial observation recorded under T1; T1 through T6 still wait for a candidate installation produced by the branch. Step 4, the ELF validation in `tools/iocsh_elf.bash` with the undefined-symbol check, the `--no-as-needed` link setting, and the uldaq link setting for the measComp library (D65 through D70), and the step 5 example `examples/iocsh/st.cmd` are implemented; T7 through T10 wait for the same candidate installation. At `a6f022eacbee3598f1d7d3fe9bcfbd9e33085b06`, with D68 and D69, all six OS workflows and the Linter succeed; the earlier Rocky failures at `41ff83759a52d8ab44fcf364e6656ee1fdac8c44` came from the snmp declaration that D68 removed. The declaration mechanism is removed (D70). Step 6 has all three fixtures under `examples/iocsh/` (D71): `tc32sim` at `61645aeb78f9e7239a20397c918e2e74508cb9da`, `EPICS-IOC-Demo` at `e4198269aaa9d8c367446fd1d5afe8c371b4c039`, and `opcua-IOC-demo` at `674c5735623703ad83f9c3fded479affa88871fa`, each with its expected results in its `README.md`; the asyn mapping gained its port driver DBDs (D72). Development runs on a Debian 13 candidate installation built from `8e8414625a5448a010434650c3b817c8372f3c47`, with the asyn metadata regenerated for D72, showed for tc32sim the simulator values, linStat, the PVA group, retools, autosave restoration after a restart, and caPutLog reception, for EPICS-IOC-Demo the echo path through its simulator, and for opcua-IOC-demo a completed `iocInit` with the original startup, whose records stay in `COMM` alarm without the Unified Automation server, and with the Milo variant (D73) a connected session, the server status records, and three changing values; none of these is a T12 through T16 result. Continue with step 7: rebuild the candidate installations from the branch head on Debian 13 and Rocky Linux 8.10, update the mdBook pages, and run T1 through T16; the opcua-IOC-demo data path of the original startup stays Pending until the Unified Automation demo server is available.

Existing work context: Publish the M15 closure record, then review M16 (#89)'s draft plan against the current installed-tree paths. M16 remains Not started and Ready; implementation requires separate authorization. M14 (#87) is Complete on 2026-10-01. Its native implementation is published in `5a610a89c922220c55eecb6820056bc1e9cdea1f`; the separate Libera correction/reference and shared verification record are published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` on `origin/master`. Native T1-T7 pass, the shell matrix passes 130 cases, and all six OS workflows, Linter, and documentation deployment succeed. #87's body now matches the native scope and all seven acceptance criteria are checked; it was closed as completed at 2026-10-01T07:09:47Z and read back at 2026-10-01T07:10:05.214Z. D41 and K9 preserve selector code and direct-source selection. D42 retains Libera cross-build, actual generated-profile repetition, and output comparison in Deferred Backlog M20, with all three checks Pending; the original #87 Libera items belong only to M20. M15 (#88) is Complete on 2026-10-01 (America/Los_Angeles). The native implementation and verification record are published in `6e58d422ec33233edd21d2c529923971ec2445a3` on `origin/master`; T1-T3 pass and all eight push workflows succeed. The issue body matches the implementation and actual results, all six acceptance criteria are checked, and #88 was closed as completed at 2026-10-02T01:44:37Z; closure was read back at 2026-10-02T02:27:24Z. D47 preserves the exact motor-generated-file exception, K10 retains both patch contents and apply behavior, and D48's function-location checks are verified. D49 retains actual macOS patch-revert verification as Deferred Backlog M21 with both checks Pending; M15 closure completes no M21 check. EPICS-env 1.4.0 is released and closed (RELEASED 2026-09-24; closure commit `84ee626`). M4 (CI workflow triggers and OS set, #78), worked on `master` by D10, is Complete on 2026-09-26 and #78 is closed. M6 (documentation rewrite from the current code, mdBook as its main home), worked on `master` by D14, is Complete on 2026-09-28: the book is published from `master`, the agent procedures and READMEs agree with it, and T1-T4 pass. D17 adds M7, M8, and M9 for the code defects the documentation work found. M8 (unused site-template removal, #82) is Complete on 2026-09-28 and #82 is closed. M7 (`IOCSH_TOP` unification under D22, #81) is Complete on 2026-09-28 and #81 is closed. D23 splits the remaining inventory defects into M9 (C17 bridge, D19) and M10-M19. M9 (C17 bridge, #80) is Complete on 2026-09-28: implementation commit `64ba7d3` is on `origin/master`, T1-T6 pass, all eight CI workflows succeeded (Rocky 8 on attempt 2), and #80 is closed. M10 (module configuration consistency, #83) is Complete on 2026-09-29: implementation commit `6bbb6a5` is on `origin/master`, T1-T4 pass, all six OS workflows plus Linter and documentation deployment succeeded, and #83 is closed. The remaining inventory groups are #84-#92, linked to M11-M19. M11's expanded Implementation Plan and Test Plan (#84) are accepted on 2026-09-29, including the T2 package preparation and identical-environment comparison conditions. D25 adds `conf.rocky10` in both vendor repositories with `conf.rocky8` compatibility, then switches the Rocky 10 consumer after both vendor changes land. The accepted plan also adds the missing audit to three OS workflows and updates the matching documentation. Implementation of the accepted M11 plan is authorized on 2026-09-29. Both tested vendor changes are published on their default master branches: uldaq-env `988b1523a759855b5e98c23e3cde050ab8d1b26e` and open62541-env `00e5e60eb24a64d94578b608538d4288c90a0dbf`. The EPICS-env consumer change is published as `921cd5f843df1ffc4167324fd762be33a6bb4164`. D26 documentation guard repair is published as `840ad37dd8bb279db7688efcf0c866c0f14e259c`. T1-T6 pass: the actual Rocky 10 run consumes both tested vendor commits; all three changed OS workflows pass the strict dependency audit, build, installation, and final checks; the corrected documentation guard, Pages deployment, and Linter succeed. M11 is Complete on 2026-09-29: verification evidence is published in `2b27ed5d790569121930003dee5823c0f4e52ef7`, the #84 body matches the implementation and verification results, and #84 is closed as completed at 2026-09-29T18:49:21Z. M11's closure record is published as `5a130908464f2a4a90108223fcf4a087d70d61f8`. M12 plan acceptance and implementation authorization are recorded on 2026-09-29. The accepted query/action separation is published as `c1de48c21aa6ecc2e9a1be224833dcbee71b820f`; T1-T6 pass. All six candidate OS workflows, Linter, and documentation deployment succeed. The tutorial paragraph correction is accepted, authorized, and verified on 2026-09-29. The verification record is published as `c351ac9243d5e5424baa1a61f0f1455e57887f` on `origin/master`. M12 is Complete on 2026-09-29: issue #85 was closed as completed at 2026-09-30T00:07:25Z after its body and completion comment were synchronized. M10 completion context: the upstream motorSimTest.src startup failure occurs on both compared revisions and remains outside the implemented dependency change. All five remaining directions were selected on 2026-09-28: keep the motor prerequisites, QPC configuration, and conditional diagnostic hint (CLOSED_DOORS K5-K7); move QPC and sscan to the other-module configuration group; remove only the unused top-level linker-root assignment. M10's four plan reviews are incorporated: M10 / T1 checks effective configuration and the selected changes, M10 / T2 covers six local/parent override changes, M10 / T4 sets each installation root in the checkout's configure/CONFIG_SITE.local and verifies the exact installed base path before module verification, and the cache invalidation change has an implementation step. M10's documentation scope includes the module add-or-bump procedure and QPC's inherited ASYN exception. M10's plan acceptance and implementation authorization are recorded on 2026-09-28; M11-M13 are Complete; M13's full accepted implementation and T1-T5 evidence are published, and #86 is closed as completed. M14 is Complete with its native implementation, T1-T7 verification, and all eight CI workflows published; #87 is reconciled and closed as completed on 2026-10-01. M20 independently retains the deferred Libera checks. M15 is Complete; M16-M19 remain Ready and each opens with a plan review that checks its items against the current code. Continue with M16 through M18 in ID order, then M19 because its hygiene items overlap the files of M10 and M15. Backlog M2 (#75) is Ready now that M6 is Complete, and updates the book where the module source-URL mechanism changes (D15). The Backlog holds the other surviving work. When the first release work is assigned, choose the next release version under D9 (1.4.1 for fixes only, 1.5.0 for module-set or feature changes), create `release-X.Y.Z` from `master`, reset this register into `docs/milestone-X.Y.Z.md`, and set `ENV_RELEASE_VERS` to X.Y.Z in its own commit. References of the form `1.4.0 M<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CI | M4 | Align the CI workflow triggers and OS set with the shipped targets | Milestone | Complete | - | | Every OS workflow runs when its own file changes and ignores the same sibling set; the CI OS set matches the shipped gz OS set or the difference is a recorded decision; [detail](#m4---ci-trigger-and-os-set-consistency) |
| Docs | M6 | Rewrite the documentation from the current code with mdBook as its main home | Milestone | Complete | - | D14, D16, D18, D20, D21 | The mdBook book under `docs/` is written anew from the current code, builds, and deploys from `master`; every retained document outside it agrees with it; [detail](#m6---documentation-rewrite-from-the-current-code) |
| Code | M7 | Unify `IOCSH_TOP` as the installed commonIocsh module directory | Milestone | Complete | - | D17, D22 | Every fragment, test, and example resolves `$(IOCSH_TOP)/iocsh/<fragment>.iocsh`, and the commonIocsh suites pass; [detail](#m7---iocsh_top-unification) |
| Code | M8 | Remove the unused site-template files | Milestone | Complete | - | D17 | The unused ChannelFinder and systemd templates are gone from `site-template/` and nothing references them; [detail](#m8---unused-site-template-removal) |
| Code | M9 | Keep `-std=gnu17` in each C17 module configuration on Ubuntu 26 | Milestone | Complete | - | D17, D19, D23 | A single `make conf.<module>` on Ubuntu 26 keeps `-std=gnu17`; the book and agent procedure describe automatic configuration and retain the conditional C17 check and append for older release checkouts without the fix, including `1.4.0`; [detail](#m9---c17-bridge-per-module) |
| Code | M10 | Make the module configuration agree with the declared dependencies | Milestone | Complete | - | D17, D23 | Declared prerequisites cover the effective build inputs; local and parent pin overrides update `MODULESGEN.mk`; QPC and sscan use the other-module configuration group; the unused linker-root assignment is removed and K5-K7 are preserved; [detail](#m10---module-configuration-consistency) |
| Code | M11 | Run the same checks in every OS workflow | Milestone | Complete | - | D11, D17, D23, D25 | Every OS workflow runs `check.module-deps` before the build; both vendors provide compatible `conf.rocky10` targets that Rocky 10 consumes after publication, and the documentation agrees; [detail](#m11---ci-workflow-coverage) |
| Code | M12 | Remove the side effects of read-only make targets | Milestone | Complete | - | D17, D23 | The implementation and verification record are published, T1-T6 pass, and #85 is closed as completed; [detail](#m12---make-time-side-effects) |
| Code | M13 | Fix the `tools/` script defects and dependency checks | Milestone | Complete | No | D17, D23, D25, D28 | Each listed `tools/` defect is fixed or kept, `check.deps` scans a real installed tree once and rejects an empty or missing tree, and the reference docs match the resulting behavior; [detail](#m13---tools-script-defects) |
| Code | M14 | Fix the environment scripts under `scripts/` | Milestone | Complete | No | D17, D23, D39, D40, D41, D42 | Native implementation and T1-T7 verification are published, all eight CI workflows pass, direct-source selection and selector Keep are preserved, and #87 is reconciled and closed as completed on 2026-10-01; [detail](#m14---environment-script-defects) |
| Code | M15 | Make the clean, uninstall, and patch-revert targets complete | Milestone | Complete | No | D17, D23, D43, D44, D45, D46, D47, D48, D49 | `uninstall.modules`, `clean.modules`, and `make patch.revert` after a partial `make patch` complete, and the patch justifications match the audit; [detail](#m15---clean-uninstall-and-patch-revert) |
| Code | M16 | Decide how installed files name foreign and absolute paths | Milestone | Not started | Yes | D17, D23 | Each listed installed file is fixed or recorded as a Keep, so a downstream IOC and a moved tree behave as the book states; [detail](#m16---installed-tree-portability) |
| Code | M17 | Fix the iocLog, autosave, and iocStatsAdmin fragment defects | Milestone | Not started | Yes | D17, D23 | `LOGDISABLE=1` disables IOC logging, the autosave header states its `system.dbd` need, and the iocStatsAdmin limits and linStat collisions are fixed or kept; [detail](#m17---common-iocsh-fragment-defects) |
| Code | M18 | Make the fragment tests safe and check what they claim | Milestone | Not started | Yes | D17, D23 | `t3_run.sh` deletes no source checkout, `common.sh` has no user-specific default, and `verify_serial.sh` checks bits and parity or states that it does not; [detail](#m18---fragment-test-defects) |
| Code | M19 | Remove unused build-system names, variables, and stale files | Milestone | Not started | Yes | D17, D23 | Each listed hygiene item is fixed or kept, and every OS workflow passes; [detail](#m19---build-system-hygiene) |
| Runtime | M22 | Load installed EPICS modules with iocsh.bash and softIocPVX | Milestone | In progress | No | D50, D51, D52, D53, D54, D55, D56, D57, D58, D59, D60, D61, D62, D63, D64, D65, D66, D67, D68, D69, D70, D71, D72, D73 | Installed metadata drives all three directive aliases, exact/default versions, dependency and ELF validation, and real IOC startup without runtime .local reads; all three public candidate IOCs are covered and T1-T16 pass; [detail](#m22---installed-module-loader-for-softiocpvx) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Park M2 (module generator source-base URLs) to the Backlog and revisit only if release time permits; its design decision (Option A vs B) is deferred. | 2026-09-10 |
| D2 | The durable home for the 1.4.0 M6 fragments and the global iocsh is a dedicated public module named `commonIocsh`, its own repo pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP`; per-module patching is not used. Interim: until testing completes the fragments are developed and held in EPICS-env, then promoted to the `commonIocsh` repo. | 2026-09-12 |
| D3 | Resolve the `commonIocsh`/`siteApps` overlap by layering, not duplication: `siteApps` drops its duplicate generic fragments and consumes `commonIocsh`, keeping only its site-specific profiles and databases. This de-duplication is the site owner's (coordinated with the alsu-site-modules session), not done in EPICS-env. | 2026-09-12 |
| D4 | 1.4.0 M6 invokes the serial parameter helper optionally through the global iocsh, using ports already created by the IOC. An IOC without serial devices supplies no serial configuration. Specify the representation of multiple ports before implementing the serial integration. | 2026-09-15 |
| D5 | Resolve D4's multiple-port representation by passing one optional IOC-owned serial configuration file path to the global iocsh. The file calls the common serial helper once per existing port, with that port's parameters. Omitting the path skips serial setup; a supplied unreadable path is an error. | 2026-09-15 |
| D6 | Narrow 1.4.0 M6's IOC verification matrix (T1/T2/T3) from the seven per-OS CI targets to two: Debian 13 and Rocky Linux 8.10. The per-fragment assertions, the T1/T2/T3 structure, and the serial cases are unchanged; only the OS breadth is reduced. | 2026-09-17 |
| D7 | Defer the D2 promotion of commonIocsh to its public module (public repository and RELEASE pin). 1.4.0 M6 completes on the interim EPICS-env home, its verification (T1/T2/T3) satisfied on the two OS targets (D6); the promotion is tracked as Backlog M3. | 2026-09-21 |
| D8 | 1.4.0 M6 ships the commonIocsh fragment set without a single global iocsh file. The common services are verified loading together in one IOC by the integrated suite (T2), and the example IOC exercises only the caPutLog fragment. A shipped global startup file is deferred to Backlog M5. | 2026-09-24 |
| D9 | The next release line is not opened at the 1.4.0 closure. Its version depends on its first assigned work (1.4.1 for fixes only, 1.5.0 for module-set or feature changes); its canonical document is created then, by reset from the current master register, following 1.4.0 M11's Next Cycle Handoff. | 2026-09-25 |
| D10 | Work M4 (CI workflow triggers and OS set) directly on `master`, not on a release branch; assigning it does not open the next release line under D9. | 2026-09-25 |
| D11 | M4 directions: the CI OS set equals the shipped OS set (Debian 12/13, Ubuntu 24.04/26.04, Rocky Linux 8.10/10.2); stale Actions rules are removed, including the super-linter v4.8.1 image, replaced by v8.7.0 with its configuration; a documentation-only commit runs no OS build workflow; a change to one OS workflow file runs only that OS, while a change to a shared build input runs every OS. | 2026-09-25 |
| D12 | The upgraded linter validates Bash only. Markdown validation stays off: the v4.8.1 `VALIDATE_MD` name was never a valid variable, so no Markdown was ever linted, and a v8.7.0 run on `d5ec42d` reports 322 Markdown findings across 23 files. The five shellcheck 0.11.0 findings are resolved by reasoned suppressions in the scripts. | 2026-09-25 |
| D13 | Run the M4 trigger checks (T1, T2, T3) on a temporary branch created at `master` and deleted after the runs are read, not on `master`. The OS workflow push triggers carry no branch filter, so the same `paths-ignore` rule applies, and no test commit enters `master`. | 2026-09-25 |
| D14 | Rewrite the whole documentation on `master` from the current code, without using the existing documents as a source, with the mdBook book as its main home. Like D10, working it on `master` does not open the next release line under D9. | 2026-09-26 |
| D15 | Order the documentation work before the module source-URL work: M6 completes first, then Backlog M2 (#75) runs and updates the mdBook book where that mechanism changes. | 2026-09-26 |
| D16 | Refine D14: the book is newly written with a new structure derived from the current code, and the code sources include `commonIocsh/`, `examples/`, `configure_user/`, and `site-template/`. Content from the existing documents is carried into the new structure only where that structure needs it and only after it is checked against the current code. | 2026-09-26 |
| D17 | Fix the code defects found by the M6 code inventory as milestones on `master`: M7 unifies `IOCSH_TOP` as the installed `commonIocsh/iocsh` directory, the meaning the book uses and the one `configure/RULES_INSTALL` and the example IOC already use; M8 removes the unused `site-template` files; M9 fixes the remaining build-system and script defects. M7 completes before M6, because the book describes the unified meaning. Like D10, this work does not open the next release line under D9. | 2026-09-26 |
| D18 | Revise the D17 order: the book describes the `IOCSH_TOP` convention the current code uses, and M7 updates the book when it unifies the code on the installed `commonIocsh/iocsh` directory. M6 no longer waits for M7. | 2026-09-27 |
| D19 | On Ubuntu 26, `make conf.<module>` rewrites the module `CONFIG_SITE.local` and drops the `-std=gnu17` line that only `conf.modules.c17` appends. M9 moves the append into the configuration of each of the ten modules, still only when `MODS_C17_BRIDGE` is set (the `conf.<module>` rule of the nine `custom` modules, `iocStats_CONF_SITE_LINES` for the `auto` module iocStats), and removes `conf.modules.c17`. Until then the book tells Ubuntu 26 readers to run `make conf` (make-targets reference) or to append the flag by hand (fix verification procedure of the book and of `docs/procedures/`), and M9 removes those notes. | 2026-09-27 |
| D20 | Revise the M6 step 2 decision for `docs/procedures/`: the module-bump, upstream-fix-carry, upstream-fix-verification, and commonIocsh-verification procedures are written for AI agents to follow, with roles, judgment stages, and record rules that the book pages do not carry. They stay in `docs/procedures/` as live agent procedures, are checked against the current code and the book, and `docs/README.md` names them as agent procedures. `measComp-tc32-fix-20260912-215519.md` also stays in `docs/procedures/` as an execution example of the upstream-fix-verification procedure, with a note that it was run before `tools/verify_fix_build.bash` and `tools/pv_snapshot.bash` existed. | 2026-09-28 |
| D21 | Keep `patch/README.md` as the patch-set summary table instead of reducing it to a pointer: `docs/procedures/upstream-fix-carry-procedure.md` adds a row there with every carried patch and counts its rows against the patch files. M6 checks the table against `patch/` and leaves its form unchanged. | 2026-09-28 |
| D22 | Revise the `IOCSH_TOP` meaning of D17: `IOCSH_TOP` names the installed `modules/commonIocsh` module directory, and an IOC loads a fragment as `$(IOCSH_TOP)/iocsh/<fragment>.iocsh`. This is the meaning `linStat.iocsh`, the fragment test suite, and the book (after D18) use; only the example IOC and its caPutLog checks take the `iocsh` directory itself, so M7 changes those. It keeps the startup scripts that already use `$(IOCSH_TOP)/iocsh/` working, and matches the module-top form a `commonIocsh` release macro takes once the fragments move to their own module (D2). | 2026-09-28 |
| D23 | Split the M6 code-inventory defects of M9 into one milestone per independent group, each fixed and verified on its own and tracked by its own issue: M9 keeps the C17 bridge (D19) and #80; M10 through M19 take module configuration, CI coverage, make-time side effects, `tools/` scripts, environment scripts, clean and patch revert, installed-tree portability, fragments, fragment tests, and hygiene. | 2026-09-28 |
| D24 | Keep Rocky 10's two vendor calls to `conf.rocky8`: both vendor repositories provide it as the Red Hat configuration and neither provides `conf.rocky10` (K8). M11 adds the missing dependency audit to Rocky 10 and Ubuntu 24.04/26.04 and updates the matching book descriptions; no vendor repository change is required. | 2026-09-29 |
| D25 | Expand M11 to add `conf.rocky10` in both `uldaq-env` and `open62541-env`, preserving the existing `conf.rocky8` interface and configuration behavior. Publish and verify both vendor changes before switching the Rocky 10 consumer. This supersedes D24's restriction on vendor changes and target selection; the missing-audit work remains in scope. | 2026-09-29 |
| D26 | Extend M11 to repair the documentation CI source-change guard: trust only the checkout path and fail on Git errors as well as changed docs/src files. Verify the shipped workflow commands in the actual mdBook container before a corrected deployment. | 2026-09-29 |
| D27 | Fix both M12 query side effects: installation-directory creation and generated module-cache writes. Preserve current query values and normal build behavior; draft the concrete plan before separate acceptance and implementation authorization. | 2026-09-29 |
| D28 | When `tools/prep-vendors.bash` replaces an existing `configure/CONFIG_SITE.local` or `configure/RELEASE.local` in EPICS-env or a vendor checkout, a non-interactive run backs up the existing file before replacing it; an interactive run asks first and backs up and replaces only after confirmation. Preserve earlier backups; name each new backup with a UTC date and time, adding a numeric suffix on collision. Backup failure, confirmation refusal, or EOF preserves the original and stops the whole invocation with status 1 before subsequent build steps. | 2026-09-30 |
| D29 | M13 removes the site-specific `EPICS_TS_NTP_INET=tic.lbl.gov` assignment from `tools/prep-vendors.bash` and uses the repository default `time.google.com` from `configure/CONFIG_BASE`. | 2026-09-29 |
| D30 | M13 removes the `EPICS_MODS_PATH` directory check and conditional `make clean.modules` call from `tools/prep-vendors.bash`; the preceding `make distclean` already runs `distclean.modules`. | 2026-09-29 |
| D31 | M13 removes the unused `SRC_VER` argument from the `all` command in `tools/prep-vendors.bash` and updates its usage and completion message; the argument currently has no effect on setup. | 2026-09-29 |
| D32 | M13 fixes `tools/pvs_gets.bash` so a missing `caget` or `pvget` produces a valid diagnostic and exits promptly with status 2 in both single and watch modes. | 2026-09-30 |
| D33 | M13 makes `tools/update-release.bash help` exit 0 and usage errors exit 2, while preserving `check`'s documented survey statuses. | 2026-09-29 |
| D34 | M13 makes `tools/gen_dep_graph.bash -h` exit 0 and makes `-f` or `-o` without an argument fail promptly with a diagnostic and status 2. | 2026-09-29 |
| D35 | M13 makes `tools/prep-vendors.bash help` exit 0. | 2026-09-29 |
| D36 | M13 makes `tools/pv_snapshot.bash` report a missing value for `-l`, `-o`, `-w`, or `-t` as a usage error with status 2, matching its documented contract. | 2026-09-29 |
| D37 | M13 makes `tools/check_deps.bash` fail with a diagnostic and corrective guidance when the installed-tree path is empty or does not exist. The message identifies the invalid input and directs the user to set `INSTALL_LOCATION_EPICS` or pass a valid `<installed_tree>`. | 2026-09-29 |
| D38 | M13 deduplicates `tools/check_deps.bash` executable scan paths so each canonical installed executable is analyzed once, including versioned directories also reachable through unversioned links. | 2026-09-29 |
| D39 | M14 separates `setEpicsEnv.bash` arguments as `[<fallback_arch>] [disable]`. Preserve automatic architecture detection priority; use the supplied architecture only as a fallback, and use `disable` only to suppress the summary. | 2026-09-30 |
| D40 | M14 reset unsets only the managed `EPICS_PATH`, `EPICS_BASE`, `EPICS_MODULES`, and `EPICS_HOST_ARCH` variables and retains the existing legacy `EPICS_EXTENSIONS` cleanup. Preserve independently configured CA settings and other unmanaged EPICS variables. | 2026-09-30 |
| D41 | M14 keeps `scripts/selectEpicsEnv.bash` unchanged (K9) and preserves selecting an environment by directly sourcing the installed `setEpicsEnv.bash`, whose own location determines the tree. Do not introduce a new selector argument form or change its legacy path construction. | 2026-09-30 |
| D42 | Exclude Libera cross-build, actual generated-profile repetition, and Libera output comparison from M14 completion; retain them as Deferred Backlog M20. Extract the Libera reference into its own document and keep both scripts at their existing paths. | 2026-09-30 |
| D43 | M15 fixes std configuration through `conf.std`: supply the actual installed base to the child IOC, retaining the existing uninstall/realuninstall recursion and the upstream Makefiles. Do not add a patch that skips child IOC cleanup when `BUILD_IOCS=NO`. | 2026-10-01 |
| D44 | M15 makes `patch.revert` skip only patches confirmed not applied and reverse applied patches in reverse application order. Conflict, partial application, or an indeterminate state stops the target with an error. | 2026-10-01 |
| D45 | M15 updates only `EPICS_BASE` in the std child IOC's existing `configure/RELEASE.local`, preserving all other settings. Repeated `conf.std` and installation-root changes must keep the effective base current without duplicating managed assignments. | 2026-10-01 |
| D46 | M15 retains the contents and apply behavior of `feed-core-libonly` and `QPC-dataonly`. Verify the actual strict dependency audit with and without each patch under identical configuration, then align code comments and book text with the patches' actual functions and observed audit results. | 2026-10-01 |
| D47 | M15 preserves upstream motor cleanup: motor-src/modules/RELEASE.<host_arch>.local is generated by the pinned motor modules Makefile and removed by realclean. Exclude only this generated file from local-setting preservation checks; preserve tracked sources and every other local setting. | 2026-10-01 |
| D48 | M15 verifies the named function location when repeated source code makes patch direction ambiguous. Validate actual changed lines for supported single-file, single-hunk static C function patches, including one-direction matches; retain errors for unresolved, conflicting, or partial states. | 2026-10-01 |
| D49 | Exclude actual macOS patch-revert verification from M15 completion and retain it as separate Deferred Backlog M21. Preserve the runtime code and platform conditions; Linux results do not verify macOS execution. Resume requires a new execution decision. | 2026-10-01 |
| D50 | Add an installed iocsh.bash wrapper for the existing softIocPVX; derive runtime module metadata during installation from the fixed distribution structure and effective build dependencies. Startup reads installed metadata and artifacts only, without e3-require, runtime Make, the source checkout, or .local configuration. | 2026-10-02 |
| D51 | An omitted module version follows its unversioned selection symlink; an explicit version selects the exact installed directory; dependencies retain the versions recorded for the selected module. Validate and resolve the required graph once per invocation, then use canonical paths throughout; reject conflicting versions within one IOC. | 2026-10-02 |
| D52 | Give m, mod, and module identical startup-file syntax: a literal name with an optional exact version, using unquoted or quoted arguments or the parenthesized form. Report invalid syntax and module/version conflicts with source locations and dependency context before IOC startup. | 2026-10-02 |
| D53 | Include DT_NEEDED and RUNPATH search with ORIGIN expansion in installed-module validation, comparing ELF module ownership and versions with metadata. Retain DBD-only dependencies and verify actual native library selection separately from static ELF search. | 2026-10-02 |
| D54 | Exclude IOC applications whose source repository is hosted on GitLab. Include all three public candidates, tc32sim, EPICS-IOC-Demo, and opcua-IOC-demo, in M22. Verify each through the installed wrapper and softIocPVX without compiling an IOC executable or custom support; record startup and communication/data-update results separately. An unavailable device or external PV leaves its check Pending rather than establishing a pass. | 2026-10-02 |
| D55 | Develop the installed loader on iocsh-module-loader. Use tc32sim with StreamDevice, linStat, retools, autosave, and caPutLog as the first integration example; verify simulator data, monitoring, retools execution, autosave restart restoration, and CA put log reception separately. Prepare complete IOC examples later as separate application fixtures. | 2026-10-02 |
| D56 | Install iocsh.bash into the selected tree's base executable directory, `base/bin/<EPICS_HOST_ARCH>/`, which `setEpicsEnv.bash` already publishes and `resetEpicsEnv.bash` already removes. Add no distribution-top `bin` directory; the EPICS build specification reserves that name against the parent of an installation directory. | 2026-10-02 |
| D57 | Runtime metadata records each module's build-declared dependencies as they are. A declared dependency that the selected artifacts do not reference by ELF or DBD still loads in dependency order; loading it is expected behavior, not a defect, and entry mappings do not prune dependencies. | 2026-10-02 |
| D58 | Keep a minimal tracked loader example at `examples/iocsh/st.cmd`, replacing the untracked repository-root prototype; complete IOC applications remain separate fixtures under D55. | 2026-10-02 |
| D59 | Module entry mapping uses a default rule, `lib<name>.so` with `<name>.dbd`, plus explicit exceptions for every module whose installed names differ or whose library or DBD list is empty. Metadata generation fails the installation of a module whose default-rule files are absent and that has no exception, and rejects a candidate DBD that defines a Base menu or record type with a body, since that is an expanded application DBD; such a module needs an exception naming its support DBD. Empty-body declarations such as `recordtype(ai) {}` are not expanded DBDs. | 2026-10-02 |
| D60 | The wrapper keeps replacing itself with the native executable through `exec`. The line-preserving generated startup copy is written to a disposable temporary file that is opened and unlinked at once and passed as `/dev/fd/N`, so nothing remains on disk after `exec` and no cleanup runs after the IOC exits. | 2026-10-02 |
| D61 | ELF validation also rejects, at installation, a selected library that leaves symbols undefined after its `DT_NEEDED` closure, Base, and its dependency modules are considered, because `dlload` of such a library fails in `softIocPVX`. The treatment of a module that this check rejects is decided when the check reports it. | 2026-10-02 |
| D62 | The wrapper has a show mode, `-n` or `--show`, that prints the generated startup and exits without starting the IOC, so directive selection and diagnostics can be compared without an IOC process. | 2026-10-02 |
| D63 | Metadata generation also rejects a selected DBD whose record, device, driver, registrar, function, variable, or link entries are exported by no selected, dependency, Base, or PVXS library, using the symbol names `registerAllRecordDeviceDrivers` resolves. Under D59, a support DBD may include a Base or PVXS file that carries menus only, as a record DBD includes `menuYesNo.dbd`; an include that carries record types or support entries still marks an application DBD. | 2026-10-02 |
| D64 | The minimal example check reads a named representative set of linStat PVs for `NO_ALARM` and an advancing timestamp, not every linStat record: `<IOC>:MEM_MAX`, `<IOC>:MEM_FREE`, `<IOC>:PROCESS_ID`, `<IOC>:NET:<NIC>:NAME`, `<IOC>:NET:<NIC>:MTU`, `<IOC>:<FSID>:PATH`, and `<IOC>:<FSID>:SIZE`. The check confirms that the loader loaded and registered the support; it does not judge the alarm configuration of the linStat databases. | 2026-10-03 |
| D65 | The undefined-symbol check of D61 counts function and data symbols alike. Observed 2026-10-03 on the local Debian 13 tree: `dlload` fails only for an undefined data symbol, as in `libdevSnmp.so`; a library whose undefined symbols are all functions, as `libmeasComp.so` with 42 uldaq functions, loads and the process ends at the first call into them, so D61's stated reason holds for data symbols and the check rejects both cases. | 2026-10-03 |
| D66 | A module that the D61 check rejects is declared unloadable in `configure/CONFIG_MODS_IOCSH` with a short reason. Its metadata is still generated and carries the reason, the wrapper refuses the module with that reason before IOC launch, and generation fails when a declared module no longer leaves a symbol undefined. snmp and measComp are declared: their libraries name neither net-snmp nor uldaq in `NEEDED`. Linking those libraries in the module build is separate work. | 2026-10-03 |
| D67 | The ELF resolver is one tool, `tools/iocsh_elf.bash`, installed beside the wrapper in the Base executable directory. Metadata generation runs it for the D61 check and the wrapper runs it before IOC launch, so both use one reading of `NEEDED`, `RPATH`, `RUNPATH`, and `$ORIGIN`. | 2026-10-03 |
| D68 | The generated Base site configuration adds `-Wl,--no-as-needed` to `USR_LDFLAGS`, so every shared library named on a link line is recorded in `NEEDED` whatever its position, for Base, every module, and applications built against the installed Base. The cause is removed at the linker rather than by reordering a module's link line, which would need a source patch that must follow upstream. Observed 2026-10-03: the snmp link line names net-snmp before its objects; the Rocky 8 and Rocky 10 builds record it and the library resolves, while the Debian and Ubuntu builds drop it. The snmp unloadable declaration of D66 is removed; measComp stays declared because its link line does not name uldaq at all. | 2026-10-03 |
| D69 | The generated measComp site configuration adds `measComp_LIBS_Linux += uldaq`, so `libmeasComp.so` records `libuldaq` in `NEEDED` with the vendor runpath and loads on its own; the upstream Makefile names uldaq for the IOC executable only, and no source patch is added. The measComp unloadable declaration of D66 is removed. The declaration mechanism of D66 stays, with no module declared. | 2026-10-03 |
| D70 | The unloadable declaration of D66 is removed from the make rules, the metadata generator, and the wrapper. After D68 and D69 no module is declared, so no shipped configuration can exercise the declaration. A library that the D61 check rejects fails its module build until the missing library is named on the library's link line. | 2026-10-03 |
| D71 | Each application fixture is a directory `examples/iocsh/<ioc>/` in this repository that holds the adapted startup, a preparation script, and the settings of the test environment. The application itself is checked out at the revision the fixture records and is used unchanged; a database that the application build expands from substitution files is expanded with the installed `msi` at preparation. | 2026-10-03 |
| D72 | The asyn entry mapping lists `asyn.dbd`, `drvAsynIPPort.dbd`, and `drvAsynSerialPort.dbd`. `asyn.dbd` alone registers no port configuration command, so `drvAsynIPPortConfigure` in the tc32sim fragment was not registered when the fixture first ran on 2026-10-03. | 2026-10-03 |
| D73 | The opcua-IOC-demo data path is checked against the open-source Eclipse Milo demo server through a startup variant, `examples/iocsh/opcua-IOC-demo/st-milo.cmd`, that loads the application's server database and its generic `ai.template` with node identifiers of that server; the server is started anew before each IOC start, because only the first session after a server start connects with the installed open62541 client. The original startup for the Unified Automation demo server stays in the fixture, and its data path stays Pending until that server is available. | 2026-10-03 |
### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| M4 (CI workflow triggers and OS set, #78) | Backlog, `docs/milestone-84ee626.md`, `master` | Milestone, `docs/milestone-84ee626.md`, `master` | this synchronization commit | this synchronization commit |
| M14 Libera subset -> M20 (D42, 2026-09-30) | Milestone, `docs/milestone-84ee626.md`, `master` | Backlog, `docs/milestone-84ee626.md`, `master` | `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` | `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` |
| M15 macOS verification subset -> M21 (D49, 2026-10-01) | Milestone, `docs/milestone-84ee626.md`, `master` | Backlog, `docs/milestone-84ee626.md`, `master` | `6e58d422ec33233edd21d2c529923971ec2445a3` | `6e58d422ec33233edd21d2c529923971ec2445a3` |

### Milestone Details

#### M4 - CI Trigger And OS Set Consistency

Origin: 84ee626 / M4
Identity History: none
GitHub Issue: #78, https://github.com/jeonghanlee/EPICS-env/issues/78
Status: Complete

##### Summary

A conceptual-integrity sweep of `release-1.4.0` on 2026-09-24 found two CI inconsistencies that already exist on `master`. First, the `paths-ignore` lists of the seven OS workflows differ: `.github/workflows/rocky8.yml` ignores `.github/workflows/rocky*.yml`, which matches its own file, so a push that changes only `rocky8.yml` does not run Rocky 8; each workflow ignores a different set of sibling workflow files; and only `ubuntu22.yml` lacks `site-template/**`. Second, the CI OS set (Debian 12/13, Rocky 8/9/10, Ubuntu 22.04/24.04) differs from the shipped gz OS set (Debian 12/13, Ubuntu 24.04/26.04, Rocky 8.10/10.2): Ubuntu 26.04 ships without CI, and Rocky 9 and Ubuntu 22.04 have CI but are not shipped.

##### Scope

- Give the six OS workflows one trigger rule. Each ignores documentation and other non-build paths (`**.md`, `docs/**`, `site-template/**`, `LICENSE`; the build writes only its generated `site-template/.versions`), the non-OS workflows (`linter.yml`, `docs.yml`), and every other OS workflow file by its exact name; none ignores its own file. Shared build inputs (`configure/`, `Makefile`, `patch/`, `scripts/`, `tools/`, and the rest) are not ignored, so a change there runs every OS.
- Match the CI OS set to the shipped set (D11): add `ubuntu26.yml` (Ubuntu 26.04), remove `rocky9.yml` and `ubuntu22.yml`.
- Remove stale rules: the `release-1.4.0` branch in the `docs.yml` push trigger, and the `rockylinux:8` container in `rocky8.yml`, which provides Rocky Linux 8.9, replaced by `rockylinux/rockylinux:8`, which provides the shipped 8.10.
- Update the `README.md` CI badges and Supported Platforms line to the same OS set.
- Replace the `linter.yml` image `docker://github/super-linter:v4.8.1` with `super-linter/super-linter@v8.7.0` and its required configuration: full-history checkout (`fetch-depth: 0`), `GITHUB_TOKEN`, job permissions, and `VALIDATE_BASH` only (D12). The five shellcheck findings of a local v8.7.0 run are resolved by reasoned suppressions in the scripts.
- Move every `actions/checkout@v5` to the current major, `actions/checkout@v7`.

Out of scope: the build steps inside the workflows and the external `pkg_automation` prerequisite script.

##### Completion Criteria

- A push that changes only one OS workflow file runs that workflow and no other OS workflow.
- A push that changes only documentation or other non-build paths runs no OS workflow.
- A push that changes a shared build input runs all six OS workflows.
- The OS workflow containers are Debian 12, Debian 13, Ubuntu 24.04, Ubuntu 26.04, Rocky Linux 8.10, and Rocky Linux 10.2, and `README.md` lists the same set.
- No workflow names a removed workflow or the `release-1.4.0` branch.
- `linter.yml` runs `super-linter/super-linter@v8.7.0` with Bash validation and passes on `master`; every workflow uses `actions/checkout@v7`.

##### Dependencies And Decisions

- D10 assigns this work to `master`; D11 sets its directions; D13 places the trigger checks on a temporary branch.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-26; the D13 revision
Implementation Authorization: 2026-09-26; the D13 revision. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: the plan accepted and authorized on 2026-09-25 and revised for D12, at `32d818a`

1. Rewrite the `on.push.paths-ignore` block of the five kept OS workflows from the single rule in Scope, listing the other OS workflow files by exact name.
2. Add `ubuntu26.yml` from `ubuntu24.yml` with container `ubuntu:26.04` and the same rule; remove `rocky9.yml` and `ubuntu22.yml`.
3. Change the `rocky8.yml` container to `rockylinux/rockylinux:8`; drop `release-1.4.0` from the `docs.yml` push branches.
4. Update the `README.md` badges and Supported Platforms line.
5. Fix the five shellcheck 0.11.0 findings: add SC2329 to the existing SC2317 suppressions in `tools/check_deps.bash` and `tools/verify_fix_build.bash`, and suppress SC2119 with its reason at the two argument-less `write_release_local` calls in `examples/commonIocsh/tests/`. Rewrite `linter.yml` for v8.7.0 with `VALIDATE_BASH` only, and rerun v8.7.0 locally until it passes.
6. Change every `actions/checkout@v5` to `actions/checkout@v7`.
7. Check the rule statically: for each OS workflow, confirm the ignore list covers the other five OS workflow files and the non-build paths and does not match its own file; then run T4 and T5.
8. Run T1, T2, and T3 under D13: create the temporary branch `ci-trigger-test` at `master`, push it once unchanged so that each test push is compared with the branch head it extends rather than with a base GitHub chooses for a new branch, then push the T2, T1, and T3 commits in that order, each as its own push, and read the runs each starts. A run started by the unchanged push is not counted; cancelling any run is the owner's action. Delete the branch after the last runs are read.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Trigger, own file | Push one commit that renames one step in `ubuntu26.yml` and changes no other file; list the runs the push starts after two minutes | GitHub Actions on the D13 temporary branch | Of the OS workflows, only Ubuntu 26.04 starts; its completion is not required |
| T2 | Trigger, non-build paths | Push one commit that changes one line in each of `README.md`, `docs/README.md`, one file under `site-template/`, `LICENSE`, `linter.yml`, and `docs.yml`; list the runs the push starts after two minutes | GitHub Actions on the D13 temporary branch | No OS workflow starts; Deploy Docs does not start; Linter Run starts because `README.md` is outside its ignore list |
| T3 | Trigger, shared input | Push one commit that adds one comment line to `configure/CONFIG_SITE` and changes no workflow file; read the runs to completion | GitHub Actions on the D13 temporary branch | All six OS workflows start and pass |
| T4 | OS set | Run each container image named in the OS workflows and read its `/etc/os-release`; compare with the `README.md` list | Local Docker with the workflow images, and the repository | Debian 12, Debian 13, Ubuntu 24.04, Ubuntu 26.04, Rocky Linux 8.10, Rocky Linux 10.2 in both |
| T5 | Linter | Push the implementation and read the `linter.yml` run | GitHub Actions on `master` | super-linter v8.7.0 runs Bash validation and passes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-26T18:54:56Z (UTC) | GitHub Actions on `ci-trigger-test`, a push whose only change renames one step in `ubuntu26.yml` | Pass | Runs started within two minutes: Ubuntu 26.04 (run 36264216835, success) and Linter Run (run 36264216783, success); no other OS workflow started. Recheck: `gh run list --branch ci-trigger-test --json name,headSha,createdAt,conclusion`. |
| T2 | 2026-09-26T18:52:06Z (UTC) | GitHub Actions on `ci-trigger-test`, a push whose only changes are one line each in `README.md`, `docs/README.md`, `site-template/application.properties.in`, `LICENSE`, `linter.yml`, and `docs.yml` | Pass | The only run started within two minutes was Linter Run (run 36264053350, success); no OS workflow and no Deploy Docs started. The unchanged first push of the branch started no run. Recheck: `gh run list --branch ci-trigger-test --json name,headSha,createdAt,conclusion`. |
| T3 | 2026-09-26T19:28:37Z (UTC) | GitHub Actions on `ci-trigger-test`, a push whose only change adds one comment line to `configure/CONFIG_SITE` | Pass | All six OS workflows started and succeeded: Debian 12 (run 36264944942), Debian 13 (36264944915), Ubuntu 24.04 (36264944899), Ubuntu 26.04 (36264944900), Rocky 8 (36264944919), Rocky 10 (36264944918); Linter Run (36264944929) also succeeded. Recheck: `gh run list --branch ci-trigger-test --json name,headSha,createdAt,conclusion`. |
| T4 | 2026-09-25T19:17Z (UTC) | Local Docker, each image pulled fresh as named in the working-tree OS workflows; `README.md` of the same tree | Pass | `/etc/os-release`: `debian:bookworm-slim` Debian 12 (12.15), `debian:trixie-slim` Debian 13 (13.7), `rockylinux/rockylinux:8` Rocky Linux 8.10, `rockylinux/rockylinux:10` Rocky Linux 10.2, `ubuntu:24.04` Ubuntu 24.04.5 LTS, `ubuntu:26.04` Ubuntu 26.04.1 LTS; `README.md` lists the same six. Recheck: `docker run --rm <image> cat /etc/os-release` for each workflow container. |
| T5 | 2026-09-25T19:35:42Z (UTC) | GitHub Actions on `master` at `32d818a` | Pass | Linter Run (run 36180429646, success) ran `ghcr.io/super-linter/super-linter:v8.7.0` with `VALIDATE_BASH: true`, shellcheck 0.11.0, and logged "Successfully linted BASH". Recheck: `gh run view 36180429646 --log`. |

##### Closure Evidence

- Static workflow check, 2026-09-26T20:22Z (UTC), `.github/workflows/` on `master` at `6f84150`: no workflow names `rocky9`, `ubuntu22`, `release-1.4.0`, or an `actions/checkout` major below v7, and each of the eight workflows uses `actions/checkout@v7`. Recheck: `grep -rn "rocky9\|ubuntu22\|release-1.4.0\|checkout@v[0-6]" .github/workflows/` prints nothing, and `grep -c "actions/checkout@v7" .github/workflows/*.yml` prints 1 for each file.
- Landing, 2026-09-26T20:24:26Z (UTC): after `git fetch`, `origin/master` equals `64610e8`, which carries the implementation (`9e5850b` through `0bee8f9`), the D13 plan revision (`e45cfa8`), and the Verification Results (`64610e8`). Recheck: `git merge-base --is-ancestor 64610e8 origin/master && echo landed` prints `landed`.
- Temporary branch: `ci-trigger-test` deleted from `origin` and locally on 2026-09-26 after the T1-T3 runs were read (Implementation Plan step 8); no test commit is on `master`. Recheck: `git ls-remote --heads origin ci-trigger-test` prints nothing.
- Linked issue: #78 observed closed (completed) at 2026-09-26T20:32:18Z (UTC), its body with every acceptance criterion checked. Recheck: `gh issue view 78 --json state,stateReason,closedAt`.
- Complete on 2026-09-26.

##### GitHub Projection

Title: Align the CI workflow triggers and OS set with the shipped targets
Labels: bug
GitHub Milestone: Backlog
Observed State: closed (completed, 2026-09-26T20:32:18Z)
Observed Labels: bug
Observed Milestone: Backlog
Last Compared: 2026-09-26

#### M6 - Documentation Rewrite From The Current Code

Origin: 84ee626 / M6
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The repository documentation reached its present form by revising legacy documents across many releases. Rewrite it from scratch on `master`, deriving every statement from the current code, with the mdBook book (`docs/book.toml`, `docs/src/`, deployed by `.github/workflows/docs.yml`) as the main home.

##### Scope

- Write the mdBook book anew from the current code: the top-level `Makefile`, `configure/`, `configure_user/`, `tools/`, `scripts/`, `patch/`, `site-template/`, `commonIocsh/`, `examples/`, `.github/workflows/`, and the installed tree they produce.
- Carry content from the existing documents into the new structure only where the structure needs it, and only after checking it against the current code (D16). The existing documents do not set the structure.
- Derive the book's chapter structure from the code, not from the current `docs/src/SUMMARY.md`.
- Decide, for every document outside the book (`README.md`, `docs/README.md`, `docs/procedures/`, `docs/design/`, `docs/archive/`, and the READMEs of `tools/`, `scripts/`, `patch/`, `examples/commonIocsh/`, and `examples/commonIocsh/tests/`), whether it is replaced by a pointer to the book, rewritten to agree with it, or kept unchanged, and apply that decision.

Out of scope: any code change; `docs/milestone-84ee626.md` and `docs/CLOSED_DOORS.md`; the module source-URL change of Backlog M2 (#75) and the book update it brings (D15).

##### Completion Criteria

- Every statement in the new book matches the current code, and every command the book shows runs as shown on a repository checkout.
- `mdbook build docs` succeeds, and Deploy Docs publishes the new book from `master`.
- Every document outside the book either points to the book or agrees with it, per the recorded decision for that document.

##### Dependencies And Decisions

- D14 sets the direction and places the work on `master`; D16 refines it with the full code source set and the rule for carrying existing content.
- D15 orders this work before Backlog M2 (#75); M2 then updates the book where the module source-URL mechanism changes.
- D18: the book describes the current `IOCSH_TOP` convention; M7 updates the book later, so M6 does not wait for M7.
- D20 keeps the four agent procedures and the measComp execution example in `docs/procedures/` as live documents instead of removing or archiving them.
- D21 keeps `patch/README.md` as the patch-set summary table.
- Work ordering: chapter writing (Implementation Plan step 3) follows the technical-writing skill that dev-env authors and owns; steps 1 and 2 do not depend on it.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-28; the D20 revision, and the D21 revision
Implementation Authorization: 2026-09-28; the D20 revision, and the D21 revision. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: the plan accepted and authorized on 2026-09-26 before D16, never committed; the D16 revision accepted and authorized on 2026-09-26, at `ddcacc1`, whose step 2 result D20 revises

1. Inventory the code surfaces the book must describe: make targets, configuration files and their variables, the module set and its dependencies, the install layout, the audit gates, the `commonIocsh` fragments and their example IOC, the user and site templates, and the CI workflows. Record the result in `docs/design/m6-code-inventory.md`.
2. Propose the chapter structure and the decision for every document outside the book; obtain owner acceptance.
3. Write each chapter from the code under the dev-env technical-writing skill, carrying in existing-document content only where the chapter needs it and the code confirms it (D16), and replace the existing `docs/src/` pages.
4. Apply the decisions for the documents outside the book.
5. Run T1-T4.

Step 2 result, accepted 2026-09-26 and revised by D20 and D21 on 2026-09-28:

- Book structure, in reading order:
  - Introduction: what EPICS-env provides, the supported operating systems, how to read the book; out of scope: the Libera cross build (`scripts/build_*_libera.bash`, `conf.modules.libera`, `configure/os/`).
  - Tutorial: Build and use your first EPICS environment.
  - Concepts: Build pipeline stages; Module set and dependencies; Installed tree and relocation; Build and install verification gates; Upstream patch carry; Common iocsh fragments.
  - Procedures: Choose the install location and release; Build and install the environment; Set up a shell with the environment; Add or bump a module; Carry an upstream fix as a patch; Verify a fix against an installed tree; Run the verification gates; Load common iocsh fragments in an IOC; Run the fragment verification suite; Uninstall and clean.
  - Reference: Make targets by purpose; Configuration variables and override files; Module pins and dependencies; Common iocsh fragment macros; Tools and scripts reference; Supported platforms and CI.
  - Glossary of EPICS-env terms.
  - Every heading follows the technical-writing rule of 3 to 11 words.
- Documents outside the book:
  - `README.md`: rewritten as an overview with the CI badges and a link to the book.
  - `docs/procedures/` module-bump, upstream-fix-carry, upstream-fix-verification, and commonIocsh-verification procedures: kept as live agent procedures (D20); each is checked against the current code and the book, and every mismatch is corrected.
  - `docs/procedures/measComp-tc32-fix-20260912-215519.md`: kept as an execution example of the upstream-fix-verification procedure, with a note that it was run before `tools/verify_fix_build.bash` and `tools/pv_snapshot.bash` existed (D20).
  - `patch/README.md`: kept as the patch-set summary table and checked against `patch/` (D21).
  - `tools/README.md`, `scripts/README.md`, `examples/commonIocsh/README.md`, `examples/commonIocsh/tests/README.md`: reduced to a pointer to the matching book page and, where one exists, to the matching agent procedure in `docs/procedures/`.
  - `docs/README.md`: rewritten as a guide to the `docs/` directory that names the `docs/procedures/` documents as agent procedures.
  - `docs/archive/` and `docs/design/makeRPath-perl-port/`: kept unchanged.
  - `docs/design/m6-code-inventory.md`: removed when M6 completes.
  - `ChangeLog.md`, `.github/ISSUE_TEMPLATE/`: kept unchanged.

Step 4 result: every decision of the step 2 result is applied: `README.md` and `docs/README.md` rewritten; the four agent procedures and the measComp example corrected against the code and the book, with old register IDs replaced by their content and the site module repository named by its role; `patch/README.md` kept and checked; the other four READMEs reduced to pointers. `docs/CLOSED_DOORS.md` gets only its line citation of the carry procedure updated, by owner direction on 2026-09-28.

Step 3 result: the 25 pages of the accepted structure replace the earlier `docs/src/` pages in 1916c08. The second-person pass converged on 2026-09-28 with no finding above the severity floor.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | Run `mdbook build docs` | Repository checkout with the mdBook version of the Deploy Docs container image `jeonghanlee/mdbook` (`docker run --rm jeonghanlee/mdbook mdbook --version`) | The build succeeds and `docs/src/` is unchanged by it |
| T2 | Code fidelity | For each page, check every statement against the code it describes and run every command the page shows | Repository checkout | Every statement matches the code; every shown command runs as shown |
| T3 | Publish | Push the rewrite to `master` and read the Deploy Docs run and the published site | GitHub Actions on `master`; GitHub Pages | Deploy Docs succeeds and the site serves the new book |
| T4 | Outside documents | For each document outside the book, check that its recorded step 2 decision is applied; for each retained document (the agent procedures, the measComp example, `README.md`, `docs/README.md`, and the pointer READMEs), check every statement and link against the current code and the book, and run every command it shows | Repository checkout | Every decision is applied; every statement and link matches; every shown command runs as shown, or the document marks it as a past record |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-28T03:04:57Z | Deploy Docs `build` job in the `jeonghanlee/mdbook` container on 1916c08 | Pass | Run 36372234041: `mdbook build docs` succeeded and the `docs/src` change check passed; recheck with `gh run view 36372234041` |
| T2 | 2026-09-28 | A clone of `master` at 1916c08 built on a Debian 13 host by replaying the tutorial, and copies of it | Pass | Every page command ran as shown; the statement mismatches it found are corrected in 9cf7108, whose load-fragment build step was rerun. The IOC checks used soft IOCs, a local `iocLogServer`, and `socat` ptys instead of site hardware. `update-release.bash update`, the writing `prep-vendors.bash` commands, `build_epics.bash`, `install_apps.bash`, and `make user.conf` were checked by reading the code. The one statement not checkable on this host, that GCC 8.5 on Rocky Linux 8 writes `RPATH` without `--enable-new-dtags`, is removed from installed-tree.md in 1445a4e; the remaining text states only the linker option, where the configuration passes it, and that `check.deps` fails on `RPATH` |
| T3 | 2026-09-28T03:04:57Z | GitHub Actions on `master` at 1916c08; GitHub Pages | Pass | Run 36372234041 built and deployed; https://jeonghanlee.github.io/EPICS-env/ serves the new introduction, tutorial, make-targets, and glossary pages (HTTP 200), and the removed `architecture.html` returns 404 |
| T4 | 2026-09-28 | The working tree after step 4, the Debian 13 build of T2, and copies of it | Pass | Every step 2 decision is applied, except the inventory removal due at M6 closure. The READMEs' 51 links resolve, the `docs/README.md` docker commands build and serve the book, and the `patch/README.md` summary agrees with `patch/`. The procedure commands ran as shown, including `update-release.bash check`, the census searches, the carry fetch, diff, and round trip, `verify_fix_build.bash` and `pv_snapshot.bash` on a soft-IOC stand-in, and `run_all.sh` with tc32sim (`OVERALL: PASS`); the scoring harness ran with stub `agent()` and `parallel()` only. The mismatches found were corrected before this result. Not run: `t3_run.sh` (it deletes source roots with `sudo rm -rf`), Layer 3 of the bump census (private repository), steps needing a production host, CI matrix, or owner authority, and the Ubuntu 26 flag step (no Ubuntu 26 host) |

##### Closure Evidence

- Book: 1916c08 (rewrite), 9cf7108 (T2 corrections), and 1445a4e (unchecked statement removed) on `master`; Deploy Docs runs 36372234041, 36375349441, and 36379385628 succeeded, and the site serves the new book (T3).
- Documents outside the book: c3f691d (agent procedures and `docs/CLOSED_DOORS.md` citation) and 86a2f09 (READMEs) on `master`; T4 passes.
- `docs/design/m6-code-inventory.md` removed in cada2b1.
- Landing: `git fetch` on 2026-09-28T08:27:51Z showed `origin/master` at cada2b1, which contains every commit above; recheck with `git merge-base --is-ancestor <commit> origin/master`.
- No linked GitHub issue.

#### M7 - IOCSH_TOP Unification

Origin: 84ee626 / M7
Identity History: none
GitHub Issue: #81, https://github.com/jeonghanlee/EPICS-env/issues/81
Status: Complete

##### Summary

`IOCSH_TOP` names two different directories. The linStat fragment, the commonIocsh test suite, and the book treat it as the `commonIocsh` module directory and append `/iocsh/` (`commonIocsh/iocsh/linStat.iocsh:16-19`, `examples/commonIocsh/tests/verify_*.sh`), while the example IOC and its caPutLog checks treat it as the `iocsh` directory itself (`examples/commonIocsh/iocBoot/caPutLog.cmd:5`, `examples/commonIocsh/tests/verify_caputlog.sh:77`, `examples/commonIocsh/tests/caputlog-ioc.sh:6`, `examples/commonIocsh/verify_caputlog.py`). D22 makes the module directory the only meaning.

##### Scope

- `examples/commonIocsh/iocBoot/caPutLog.cmd`: load `$(IOCSH_TOP)/iocsh/caPutLog.iocsh`.
- `examples/commonIocsh/tests/verify_caputlog.sh`: pass `IOCSH_TOP_DIR` unchanged; `examples/commonIocsh/tests/caputlog-ioc.sh`: describe `IOCSH_TOP` as the `commonIocsh` module directory.
- `examples/commonIocsh/verify_caputlog.py`: `--iocsh-top` names the `commonIocsh` module directory, its default is `commonIocsh` of the clone that holds the script, and the script reads `<iocsh-top>/iocsh/caPutLog.iocsh`.
- `configure/RULES_INSTALL`: the install comment names `$(INSTALL_LOCATION_MODS)/commonIocsh` as the directory `IOCSH_TOP` names, and drops `per D15`, a decision number of the 1.4.0 register that names a different decision here, keeping its content (the fragments are held in the EPICS-env tree until they move to the public `commonIocsh` repository).
- The mdBook book (D18): remove the example-IOC exception from `concepts/common-iocsh-fragments.md`, `procedures/run-fragment-verification-suite.md`, and `glossary.md`, and in the suite procedure pass `--iocsh-top modules/commonIocsh` and state the `verify_caputlog.py` default as `commonIocsh` of the clone. Outside the book: remove the same exception from `docs/procedures/commonIocsh-verification-procedure.md`, and change the concept-page link text of `examples/commonIocsh/README.md`, which names an `IOCSH_TOP` form of this IOC.

Out of scope: other fragment and test defects (M9).

##### Completion Criteria

- Every `$(IOCSH_TOP)/` path outside `docs/` continues with `iocsh/`, no test passes an `iocsh` subdirectory as `IOCSH_TOP`, and the book describes `IOCSH_TOP` as the installed `modules/commonIocsh` directory with no exception.
- `examples/commonIocsh/verify_caputlog.py` exits 0 and `examples/commonIocsh/tests/run_all.sh` reports `OVERALL: PASS`, both against an installed tree.
- The book builds and Deploy Docs publishes the changed pages from `master`.

##### Dependencies And Decisions

- D17 places the work on `master`; D22 sets the meaning and replaces the `iocsh`-directory meaning of D17; D18 adds the book update.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-28
Implementation Authorization: 2026-09-28. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: the draft that unified `IOCSH_TOP` as the `iocsh` directory under D17, replaced on 2026-09-28 by D22 before acceptance

1. Change `caPutLog.cmd` to load `$(IOCSH_TOP)/iocsh/caPutLog.iocsh`.
2. Change `verify_caputlog.sh` to pass `IOCSH_TOP_DIR` unchanged, and the `IOCSH_TOP` comment of `caputlog-ioc.sh`.
3. Change `verify_caputlog.py` so `--iocsh-top` and its default name the `commonIocsh` module directory and the script reads `<iocsh-top>/iocsh/caPutLog.iocsh`.
4. Change the install comment of `configure/RULES_INSTALL`: name the module directory and drop `per D15`.
5. Update the book pages (the exception in three pages, and the `--iocsh-top` argument and default in the suite procedure), `docs/procedures/commonIocsh-verification-procedure.md`, and the concept-page link text of `examples/commonIocsh/README.md`.
6. Rewrite the body of #81 from this detail, so the issue states the module-directory meaning.
7. Run T1-T4.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | Run `git grep -nE '\$\(IOCSH_TOP\)/' -- ':!docs' \| grep -v 'IOCSH_TOP)/iocsh/'`, `git grep -n 'IOCSH_TOP_DIR}/iocsh' -- ':!docs'`, and `git grep -n 'commonIocsh/iocsh' -- examples/commonIocsh/verify_caputlog.py`; read every book and `docs/procedures/` passage that `git grep -n IOCSH_TOP -- docs/src docs/procedures` lists | Repository checkout | The three searches print nothing; every listed passage states the module-directory meaning with no exception |
| T2 | Example IOC | Write `examples/commonIocsh/configure/RELEASE.local` with `EPICS_BASE=<tree>/base` and `CAPUTLOG=<tree>/modules/caPutLog`, build the example IOC with `make -C examples/commonIocsh CHECK_RELEASE=NO`, then run `examples/commonIocsh/verify_caputlog.py --base <tree>/base --iocsh-top <tree>/modules/commonIocsh --output <new_directory>`, where `<tree>` is an installed tree whose `modules/commonIocsh/iocsh` holds the current fragments; M7 changes no installed file, so the tree needs no rebuild | Host with the installed tree | Exit 0, all six cases pass |
| T3 | Fragment suite | From the top of the clone whose example IOC T2 built, run `examples/commonIocsh/tests/run_all.sh` with `DIST_TOP=<tree>`, `TC32SIM=<tc32sim_dir>`, and `COMMONIOCSH=<tree>/modules/commonIocsh`; the suite reads fragments from `COMMONIOCSH`, not from `DIST_TOP` | Same host, with a built tc32sim checkout, `socat`, `ss`, and free TCP ports 7011 and 7013 | `OVERALL: PASS` |
| T4 | Publish | Run `mdbook build docs`, push to `master`, and read the Deploy Docs run and the changed pages on the published site | Repository checkout with the `jeonghanlee/mdbook` container, as `docs/README.md` runs it; GitHub Actions on `master`; GitHub Pages | The build succeeds, Deploy Docs succeeds, and the published pages state the module-directory meaning |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-28T16:57:38Z | Working tree with the M7 changes | Pass | The three searches printed nothing; every passage `git grep -n IOCSH_TOP -- docs/src docs/procedures` lists states the module-directory meaning with no exception; the review of the change found one more passage, `run-fragment-verification-suite.md` step 4, which named `--iocsh-top` as the directory of `caPutLog.iocsh` without `IOCSH_TOP` in the line, and it now names `iocsh/caPutLog.iocsh` below `--iocsh-top` |
| T2 | 2026-09-28T16:58:18Z | Debian 13 host; a clone of 232c4d1 with the M7 changes; the 1.4.0 Debian 13 tree built in M6 T2, whose `modules/commonIocsh/iocsh` equals `commonIocsh/iocsh` (`diff -r`) | Pass | `make -C examples/commonIocsh CHECK_RELEASE=NO` exited 0; `verify_caputlog.py --iocsh-top <tree>/modules/commonIocsh` exited 0 with all six cases Pass, and its `summary.json` names `<tree>/modules/commonIocsh/iocsh/caPutLog.iocsh` as the fragment |
| T3 | 2026-09-28T17:00:41Z | Same host, clone, and tree; built tc32sim checkout; ports 7011 and 7013 free | Pass | `run_all.sh` with `COMMONIOCSH=<tree>/modules/commonIocsh` printed `OVERALL: PASS`; all eight scripts Pass, including `verify_caputlog.sh`, which passes `IOCSH_TOP_DIR` unchanged |
| T4 | 2026-09-28T17:20:18Z | Container build on the T2 clone; GitHub Actions on `master` at 9d88563, which carries b4266b5; GitHub Pages | Pass | `mdbook build docs` in the `jeonghanlee/mdbook` container succeeded; Deploy Docs run 36456054055 succeeded; the published suite procedure shows `--iocsh-top modules/commonIocsh` and `iocsh/caPutLog.iocsh` below `--iocsh-top`, and the published glossary and concept page carry no example-IOC exception; recheck with `gh run view 36456054055` |

##### Closure Evidence

- b4266b5 (example IOC, its checks, install comment, book, agent procedure, and example README) and 9d88563 (plan acceptance and local checks) on `master`; T1-T4 pass.
- The push also ran every OS workflow, all passing on 9d88563: Debian 13 36456054351, Debian 12 36456054078, Rocky 10 36456054335, Rocky 8 36456054064, Ubuntu 24.04 36456054109, Ubuntu 26.04 36456054239; Linter Run 36456054144 also passed.
- Landing: `git fetch` on 2026-09-28T17:35:15Z showed `origin/master` at 9d88563, which contains b4266b5; recheck with `git merge-base --is-ancestor <commit> origin/master`.
- #81 closed as completed with its body rewritten to the module-directory meaning and a closing comment (2026-09-28T17:48:09Z, `gh issue view 81`).

##### GitHub Projection

Title: Unify the IOCSH_TOP meaning
Labels: bug
GitHub Milestone: Backlog
Observed State: closed (completed, 2026-09-28T17:48:09Z, `gh issue view 81`)
Observed Labels: bug
Observed Milestone: Backlog
Last Compared: 2026-09-28T17:53:08Z (remote updatedAt 2026-09-28T17:48:09Z)

#### M8 - Unused Site-Template Removal

Origin: 84ee626 / M8
Identity History: none
GitHub Issue: #82, https://github.com/jeonghanlee/EPICS-env/issues/82
Status: Complete

##### Summary

`site-template/` tracks four files that no rule, script, or workflow renders or installs: `application.properties`, `application.properties.in`, `cf.service.in`, and `systemd.service.in`. The two `application.properties` files carry `server.ssl.key-store-password=password` and third-party LDAP URLs. The only generated content in the directory is `site-template/.versions`, written and installed by `src_version` (`configure/RULES_INSTALL:29-32`).

##### Scope

- Remove all four unused files from `site-template/` (`application.properties`, `application.properties.in`, `cf.service.in`, `systemd.service.in`), keeping the directory and the `src_version` behavior.

- Keep `src_version` working when `site-template/` holds no tracked file: the four files are the only tracked content of the directory and `.versions` is gitignored, so a fresh clone has no `site-template/` and `src_version` cannot write `site-template/.versions`. `src_version` creates the directory first (`mkdir -p $(SITE_TEMPLATE_PATH)`).

Out of scope: rewriting git history to purge earlier revisions of these files; that is a force-push and stays owner-run.

##### Completion Criteria

- The removed files are absent and no file outside `docs/` names them.
- In a fresh clone of the changed commit, `make src_version` writes `site-template/.versions` and installs it at the top of the installed tree.
- Every OS workflow passes on the push, including `make install`.

##### Dependencies And Decisions

- D17 places the work on `master`.
- Owner decision 2026-09-28: remove all four unused templates, not only the two `application.properties` files. No file outside `docs/` names any of them (`git grep`, 2026-09-28).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-28
Implementation Authorization: 2026-09-28. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: the draft that removed the files only, revised on 2026-09-28 before acceptance

1. Confirm by execution that `src_version` fails in a fresh clone once the four files are gone.
2. Add `mkdir -p $(SITE_TEMPLATE_PATH)` as the first command of `src_version` in `configure/RULES_INSTALL`.
3. Remove the four files.
4. Run T1-T3.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | `git grep -n` for each removed file name outside `docs/` | Repository checkout | No output |
| T2 | Fresh clone | Clone the changed commit into a scratch directory, point `INSTALL_LOCATION` at a scratch tree, and run `make src_version` | Local host, scratch directory | `site-template/.versions` is written and installed at the top of the tree |
| T3 | Install | Push to `master` and read the OS workflow runs; the `configure/` change is outside the path filters, so all six run | GitHub Actions on `master` | Every OS workflow passes, including `make install` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-28 | Working tree with the four files removed | Pass | `git grep -n "application.properties\|cf.service.in\|systemd.service.in" -- ':!docs'` printed nothing (exit 1) |
| T2 | 2026-09-28 | Local host; fresh clone of a scratch commit carrying both changes | Pass | Without the `mkdir -p` line, `make src_version` in a fresh clone stopped at `RULES_INSTALL:30` with `site-template/.versions: No such file or directory`; with it, the clone had no `site-template/`, and `make src_version` exited 0, wrote `site-template/.versions`, and installed it at the top of the scratch tree |
| T3 | 2026-09-28T09:36:29Z | GitHub Actions on `master` at d9b803d, which carries 58bba42 | Pass | The six OS workflow runs passed, including `make install`: Debian 13 36402131960, Debian 12 36402131875, Rocky 10 36402131782, Rocky 8 36402131832, Ubuntu 24.04 36402131779, Ubuntu 26.04 36402131967; Linter Run 36402132179 also passed; recheck with `gh run list --commit d9b803d6c9a95207cb859f95d565c3c0eec1a24f` |

##### Closure Evidence

- 58bba42 (the four files removed, `mkdir -p` added to `src_version`) and d9b803d (plan and local checks) on `master`; T1-T3 pass.
- Landing: `git fetch` on 2026-09-28T15:08:58Z showed `origin/master` at d9b803d, which contains 58bba42; recheck with `git merge-base --is-ancestor <commit> origin/master`.
- #82 closed as completed with a closing comment (2026-09-28T15:46:14Z, `gh issue view 82`).

##### GitHub Projection

Title: Remove unused site-template files
Labels: enhancement
GitHub Milestone: Backlog
Observed State: closed (completed, 2026-09-28T15:46:14Z, `gh issue view 82`)
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-28T16:01:13Z (remote updatedAt 2026-09-28T15:46:14Z)

#### M9 - C17 Bridge Per Module

Origin: 84ee626 / M9
Identity History: Split on 2026-09-28 (D23): M9 keeps the C17 bridge; the other inventory defects moved to M10-M19
GitHub Issue: #80, https://github.com/jeonghanlee/EPICS-env/issues/80
Status: Complete

##### Summary

Before `64ba7d3`, `make conf.<module>` on Ubuntu 26 dropped the `-std=gnu17` line that only `conf.modules.c17` appended (D19). Each affected module now retains that flag in its own configuration.

##### Scope

- C17 bridge (D19): each of the ten modules writes `USR_CFLAGS += -std=gnu17` in its own configuration on Ubuntu 26. The nine `custom` targets are `conf.sncseq`, `conf.sscan`, `conf.calc`, `conf.busy`, `conf.StreamDevice`, `conf.lua`, `conf.std`, `conf.scaler`, and `conf.mca`; the `auto` target is `conf.iocStats`, through `iocStats_CONF_SITE_LINES`.
- Define the Ubuntu 26 condition and `MODS_C17_BRIDGE` in `configure/CONFIG_MODS_DEPS` before the iocStats configuration variables. This file is read after OS detection in `configure/CONFIG_SRC` and before `configure/RULES_MODS_CONF_AUTO` generates the iocStats rule. Keep the existing include order and automatic rule builder.
- Remove `conf.modules.c17`, its prerequisites in both `conf.modules` and `conf.gz.modules`, and its unused `MODS_C17_SRC_PATHS` list from `configure/RULES_MODS_CONFIG`.
- Update the C17 descriptions in `docs/src/reference/make-targets.md`, `docs/src/concepts/build-pipeline.md`, `docs/src/procedures/verify-fix-against-installed-tree.md`, `docs/procedures/upstream-fix-verification-procedure.md`, and `docs/procedures/module-bump-procedure.md`.

Out of scope: the defects of M10, M11, M12, M13, M14, M15, M16, M17, M18, M19.

##### Completion Criteria

- On Ubuntu 26, each of the ten individual configuration targets writes exactly one `USR_CFLAGS += -std=gnu17` line to its module's `CONFIG_SITE.local`, including on a second invocation. OS detection selects the flag without command-line or environment overrides of `OS_NAME`, `OS_VERSION`, or `MODS_C17_BRIDGE`.
- `conf.modules` and `conf.gz.modules` each write the same C17 line for all ten modules; the gz configuration also retains its existing compression flags in the repository-top `CONFIG_SITE.local`.
- On Ubuntu 24.04, the individual targets and both aggregate targets add no `-std=gnu17` flag to the generated module or repository-top site files.
- The five documents in Scope describe the per-module configuration. Current checkouts need no manual flag append or full configuration to recover the flag, and live references to `conf.modules.c17` or `MODS_C17_SRC_PATHS` are gone. The fix-verification procedures also support a checkout of the installed release: on Ubuntu 26, they check for exactly one C17 line and append it only when absent, as required by release `1.4.0`.
- All required checks in the Test Plan pass, including every OS workflow for the implementation commit.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.
- D19 sets the C17 bridge fix and its book update.
- Accepted correction, 2026-09-28: the D19 workaround removal applies to checkouts with the per-module fix. Keep a conditional C17 check and append for an installed release's checkout without the fix, including `1.4.0`.
- The configuration order is a behavioral constraint: `RULES_MODS_CONF_AUTO` expands `iocStats_CONF_SITE_LINES` while generating the rule, so the C17 value must already be defined at that point.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-28; the plan with all three plan-review findings and the accepted release-checkout compatibility correction incorporated.
Implementation Authorization: 2026-09-28; implement the current plan, apply the accepted compatibility correction, and run the local checks and review again. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: M9 draft at `688cd89`.

1. Prepare the real source trees described in Test Preparation. Run the T1 assertions against the unmodified baseline and record the missing flag after each individual configuration target; this is the regression evidence to compare with the candidate.
2. Move the C17 rationale comments, `MODS_C17_BRIDGE` definition, and existing Ubuntu 26 condition from `configure/RULES_MODS_CONFIG` to `configure/CONFIG_MODS_DEPS`, before the iocStats configuration variables. Define `iocStats_CONF_SITE_LINES` there to append the C17 line only when the bridge is enabled. T1 verifies the generated iocStats rule through the top-level make path; T3 verifies the condition is inactive elsewhere.
3. Add the conditional C17 append after each of the nine custom targets writes its `CONFIG_SITE.local` in `configure/RULES_MODS_CONFIG`. Remove the old aggregate target, its `.PHONY` entry, its two prerequisite references, and `MODS_C17_SRC_PATHS`. T1 checks every target and repeat invocation; T4 checks both aggregate paths.
4. Update all five documents in Scope. In `make-targets.md`, update the aggregate row and remove the obsolete target row and workaround. In `build-pipeline.md`, replace the obsolete append and ordering descriptions with the per-module behavior. In both fix-verification procedures, retain the checkout of the installed release and document a C17 check with an append only when absent on Ubuntu 26; checkouts with the per-module fix need no append. In `module-bump-procedure.md`, describe checking and retiring a module's own C17 setting after a real build with and without it, using the custom target or `iocStats_CONF_SITE_LINES` as appropriate. T5 and T6 check these changes.
5. Run T1 and T3-T6 against the candidate and record the observed results, including the baseline-to-candidate comparison for T1.
6. After separately authorized commit and push operations, read T2 to completion for the implementation commit and record each OS workflow result.

##### Test Plan

Test Preparation:

- Use separate scratch checkouts for the unmodified baseline `688cd899ed2bd1f4d60d17ef87b26469bfa3b569` and the candidate. Record each checkout's commit and candidate diff, the container image or host OS, and the module pins used.
- For T1, T3, and T4, use the checkout's top-level `Makefile` and actual module sources obtained by `make init` at the pins in `configure/RELEASE`; apply the shipped patches with `make patch`. Set `INSTALL_LOCATION` to a scratch directory and provide any configuration prerequisites named by the shipped workflow. Run inside the stated OS and let `configure/CONFIG_SRC` read its `/etc/os-release`; leave `OS_NAME`, `OS_VERSION`, and `MODS_C17_BRIDGE` unset in the environment and make command line.
- Inspect the ten source directories `sequencer-src`, `iocStats-src`, `sscan-src`, `calc-src`, `busy-src`, `StreamDevice-src`, `lua-src`, `std-src`, `scaler-src`, and `mca-src`. Use the matching individual targets listed in Scope; sequencer uses `conf.sncseq`.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Individual C17 configuration | Run `make conf.modules`, then run each of the ten individual targets twice in separate make invocations; inspect its `configure/CONFIG_SITE.local` after each invocation. Apply the same assertions to the baseline and candidate | Ubuntu 26.04 host or container; real pinned source trees | The baseline fails the flag assertion after each individual target. The candidate writes exactly one `USR_CFLAGS += -std=gnu17` line after every invocation, including iocStats |
| T2 | Integration | Push the change to `master` and read the OS workflow runs | GitHub Actions on `master` | Every OS workflow passes |
| T3 | OS condition | Run the ten individual targets twice, then `make conf.modules` and `make conf.gz.modules`; inspect the generated site files after each step | Ubuntu 24.04 host or container; real pinned source trees | No generated module or repository-top `CONFIG_SITE.local` contains `-std=gnu17` |
| T4 | Aggregate configuration | Run `make conf.modules` and inspect all ten module site files; run `make conf.gz.modules` and inspect them again, together with the repository-top site file | Ubuntu 26.04 host or container; real pinned source trees | Both commands succeed and each module has exactly one C17 line after each command. The gz path also writes `-g0 -gz=zlib` for `USR_CFLAGS`, `USR_CXXFLAGS`, and `USR_LDFLAGS` at the repository top |
| T5 | Documentation consistency | Read all five changed documents against the candidate code; search `configure/`, `docs/src/`, and `docs/procedures/` for the retired target and list names; check the current and release-checkout instructions; run `mdbook build docs` | Candidate checkout with mdBook | The book builds; the five documents agree with the per-module behavior; no live reference to `conf.modules.c17` or `MODS_C17_SRC_PATHS` remains; manual append is conditional on the C17 line being absent on Ubuntu 26 |
| T6 | Release-checkout compatibility | Execute the documented check and conditional append after individual configuration on the real baseline and candidate; repeat configuration and check again. Confirm the baseline's configuration rules match tag `1.4.0` | Ubuntu 26.04 container; the real pinned sources from T1 | Baseline: the check prints 0 and exits 1, then prints 1 after the documented append. Candidate: the check prints 1 without an append. Both remain at one line when the instructions are followed again |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-28T18:51:20Z (UTC) | Ubuntu 26.04.1 LTS container; real pinned sources after `make init` and `make patch` | Pass | Baseline `688cd89`: all ten initial files had the flag, then all 20 individual invocations lost it. Candidate: all 20 individual invocations kept exactly one flag, including iocStats. See `baseline26-results/summary.json` and `candidate26-results/summary.json` under the local evidence directory below; every make command exited 0 |
| T2 | 2026-09-28T22:33:35Z (UTC) | GitHub Actions on `master` at `64ba7d3244f9cd4c9035743008a5375b0362bc4c` | Pass | All six OS workflows succeeded: Debian 12 36481348926, Debian 13 36481348945, Ubuntu 24.04 36481348616, Ubuntu 26.04 36481348736, Rocky 10 36481348645, and Rocky 8 36481348841 (attempt 2). Rocky 8 passed package installation, EPICS installation, and the environment check after the package-list update jeonghanlee/pkg_automation@472ef7654e4541ba6322e301ac78bea5691e3845. Linter Run 36481348700 and Deploy Docs 36481348672 also succeeded. Recheck with `gh run list --repo jeonghanlee/EPICS-env --commit 64ba7d3244f9cd4c9035743008a5375b0362bc4c` |
| T3 | 2026-09-28T18:51:24Z (UTC) | Ubuntu 24.04.5 LTS container; the same module pins as T1 | Pass | All 20 individual invocations and both aggregates added no C17 flag; the generated module and repository-top site files were checked. `candidate24-results/summary.json`: 109 assertions, zero failures or execution errors |
| T4 | 2026-09-28T18:51:20Z (UTC) | Ubuntu 26.04.1 LTS container; real pinned sources | Pass | Both aggregates succeeded; all ten module files kept exactly one C17 flag after each. The gz root site file retained all three compression flags. `candidate26-results/summary.json`: 55 assertions across T1/T4, zero failures or execution errors |
| T5 | 2026-09-28T19:08:39Z (UTC) | Current working tree; `jeonghanlee/mdbook:0.5.4` image | Pass | Fresh `mdbook build docs --dest-dir /output/book` exited 0 with the repository mounted read-only; `review2/mdbook-build.log` and rendered HTML contain the corrected release-checkout instructions. All five documents agree with the configuration code; the retired target and list names have no live references in the searched paths. Second third-person review and the following reader review found no further defect |
| T6 | 2026-09-28T19:07:16Z (UTC) | Ubuntu 26.04.1 LTS container; real baseline and candidate pinned sources | Pass | Commands extracted from the two corrected documents passed all 44 cases: ten modules in the agent procedure and StreamDevice in the book, each configured twice in each checkout. The baseline required 22 conditional appends; the candidate required none. Every final check printed 1. `review2/compatibility-results.json` records command output, exit codes, document hashes, and site-file snapshots; the baseline's three module-configuration files match tag `1.4.0` byte for byte |

Initial evidence directory: `work/m9-c17-20260928-1143/`. The initial candidate is `688cd89` plus `candidate.patch` (SHA-256 `285968ca9398cf81b3f898a37bc4c787667856a95ce3edaa7a4fa72c772e235c`). `provenance.json` records image IDs, script hashes, matching module pins, and byte-for-byte agreement with the working tree at that observation time. The compatibility correction changes documentation only; the two implementation files retain their tested contents. The baseline and candidate aggregate files contain the same lines for all ten modules; line order was normalized for that comparison. Each preparation directory contains the actual `make init` and `make patch` logs and source commit list; each result directory contains per-command logs and site-file snapshots.

Compatibility-correction evidence is under `review2/` in the same directory. `review2/provenance.json` identifies the corrected documents, unchanged implementation, baseline-to-release comparison, and rendered book. T6 verifies configuration instructions only; compilation and installation are covered by the completed T2 OS workflows.

##### Closure Evidence

- Implementation and documentation: `64ba7d3244f9cd4c9035743008a5375b0362bc4c`; T1-T6 pass.
- Landing observed 2026-09-28T22:33:35Z: after `git fetch origin`, both HEAD and `origin/master` were `64ba7d3244f9cd4c9035743008a5375b0362bc4c`; `git merge-base --is-ancestor 64ba7d3244f9cd4c9035743008a5375b0362bc4c origin/master` exited 0.
- #80 was narrowed to the verified C17 change and closed as completed at 2026-09-28T23:02:48Z; its body retains the older-release C17 procedure and links the remaining inventory to #83-#92. Closure and the body were read back at 2026-09-28T23:02:49.854069+00:00 with `gh issue view 80 --repo jeonghanlee/EPICS-env`.
- M10-M19 remain independent open work in #83-#92. Each issue body, bug label, Backlog milestone, and jeonghanlee assignment matched its approved draft after creation.

##### GitHub Projection

Title: Keep -std=gnu17 in each C17 module configuration on Ubuntu 26
Labels: bug
GitHub Milestone: Backlog
Observed State: closed (completed at 2026-09-28T23:02:48Z; observed 2026-09-28T23:02:49.854069+00:00, `gh issue view 80 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Last Compared: 2026-09-28T23:02:49.854069+00:00 (remote updatedAt 2026-09-28T23:02:48Z); title, body, and closed state match the C17 scope

#### M10 - Module Configuration Consistency

Origin: 84ee626 / M10
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #83, https://github.com/jeonghanlee/EPICS-env/issues/83
Status: Complete

##### Summary

The module configuration work fixes stale generated paths after pin overrides, removes two direct motorMotorSim build prerequisites, moves QPC and sscan into the configuration group for modules with other dependencies, and removes an unused linker-root assignment. The existing motor prerequisites, QPC configuration, and conditional diagnostic hint are accepted Keeps.

##### Scope

- motorMotorSim: remove `build.autosave` and `build.iocStats` from its direct build prerequisites, retaining `null.base build.motor build.asyn` and the current configuration and feature set.
- Accepted dependency Keeps: retain `motor_DEPS`, including the existing `motor -> busy -> autosave` ordering, and retain `QPC_DEPS` and the inherited ASYN path in `conf.QPC`. The premises and evidence are recorded in `docs/CLOSED_DOORS.md` K5 and K6.
- Generated module paths: `configure/MODULESGEN.mk` depends only on `configure/RELEASE` and `configure/CONFIG_SITE` (`configure/CONFIG_MODS:7`). After the cache exists, creating, editing, or removing a version-pin override in either `configure/RELEASE.local` or `../RELEASE.local` changes the loaded pin but leaves the cached installation path stale.
- Configuration grouping: move `conf.QPC` and `conf.sscan` from `MODS_ZERO_CUSTOM_VARS` to `MODS_ONE_VARS` in `configure/RULES_MODS_CONFIG`, preserving their configuration recipes and aggregate output.
- Linker variable: remove only the unused top-level `LINKER_ORIGIN_ROOT` assignment from `configure/CONFIG_BASE`. Preserve the full installation-tree root supplied directly by `DO_MAKE` in `configure/CONFIG_SRC`.
- Accepted diagnostic Keep: retain `MODS_GEN_STALE_HINT` and the distinct missing/invalid declaration errors in `configure/CONFIG_MODS_DEPS`; the hint is conditional on a changed module set (`docs/CLOSED_DOORS.md` K7).

Out of scope: the defects of M9, M11, M12, M13, M14, M15, M16, M17, M18, M19.

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.
- T1 accounts for effective configuration, conditional inputs, and direct or transitive build ordering. T2 fails on the defective baseline and passes on the candidate for all six override changes, without manual cache removal.
- motorMotorSim builds with the selected direct prerequisites and produces the same IOC support as the baseline under the existing configuration. autosave and iocStats remain in the overall module set; the selected change removes only their direct prerequisite entries from `motorMotorSim_DEPS`.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.
- Decision Date: 2026-09-28. Remove the direct `build.autosave` and `build.iocStats` prerequisites from `motorMotorSim_DEPS`. These entries control build ordering. Retain the existing `conf.motorMotorSim` output and optional-feature settings; enabling the example IOC's autosave or iocStats support is outside this decision.
- Decision Date: 2026-09-28. Keep the existing motor prerequisites, QPC configuration and prerequisites, and conditional stale-cache hint (K5-K7). Move QPC and sscan to `MODS_ONE_VARS`. Remove only the unused `LINKER_ORIGIN_ROOT` assignment in `configure/CONFIG_BASE`; retain the recursive build command's full installation-tree root. All five remaining directions are resolved.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-28; accepted revised plan frozen at `work/m10-implementation-20260928/accepted-plan.md`, SHA-256 `d99955cff0d9ed41e4bbb5d4991c256fe22acdc69bcb6247ab367e55d382a778`
Implementation Authorization: 2026-09-28; explicit authorization to implement the accepted plan
Superseded Plan Artifacts: none

1. Prepare the baseline and candidate checkouts required by T1, T2, and T4. For T1 and T4, set each checkout's installation root in its own `configure/CONFIG_SITE.local` before running make, as specified in T4 steps 1-2. Preserve the accepted Keeps in `docs/CLOSED_DOORS.md` K5-K7: the motor and QPC prerequisites, existing `conf.QPC` recipe and inherited ASYN path, and conditional diagnostic hint. T1 checks these boundaries alongside the selected changes below.
2. In `configure/CONFIG_MODS`, extend the existing cache invalidation rule to compare the effective module pin values loaded through the supported override hooks with the values used to generate `MODULESGEN.mk`. Store those generation inputs with the cache and regenerate when they differ or the cache is absent. This comparison must detect override removal as well as creation and editing; adding only currently existing override files as prerequisites is insufficient. Preserve the existing `RELEASE` and `CONFIG_SITE` invalidation and the module-only, file-origin filters. The comparison must settle after the regenerated file is read, and an unchanged invocation must not rewrite the cache. T2 verifies these conditions. Read-only make side effects remain M12 work, and source-URL policy remains Backlog M2 work.
3. In `configure/CONFIG_MODS_DEPS`, remove `build.autosave` and `build.iocStats` from `motorMotorSim_DEPS`, retaining `null.base build.motor build.asyn`. Use the existing `conf.motorMotorSim` output and optional-feature settings. Update motorMotorSim's declared-dependency row in `docs/src/reference/module-pins.md`. T4 verifies the direct prerequisites and preserves the baseline IOC support through the real configuration and build paths.
4. Update `docs/src/concepts/module-set.md`, the override guidance in `docs/src/reference/configuration-variables.md`, and step 7 of `docs/src/procedures/add-or-bump-module.md` to describe the verified cache behavior. The procedure must explain automatic regeneration after a local pin change instead of requiring manual regeneration for that change; retain the explicit `reconf.modules` target's documented purpose. In `module-set.md`, describe QPC's inherited, unversioned ASYN path as an exception to generated versioned dependency paths and distinguish its installed IOC fragment's runtime ASYN macro. Keep the procedure's base-only versus other-module grouping description aligned with step 5. Check that the linker description continues to name the full installation-tree root. T1 and T2 supply the observed behavior for these descriptions, and the documentation check must cover all three files.
5. In `configure/RULES_MODS_CONFIG`, move `conf.QPC` and `conf.sscan` from `MODS_ZERO_CUSTOM_VARS` to `MODS_ONE_VARS`. Leave their recipes, the Libera-specific group, and build prerequisites unchanged. T1 verifies membership exactly once in the new group, absence from the old group, and unchanged aggregate configuration output after normalizing installation roots.
6. In `configure/CONFIG_BASE`, remove only `LINKER_ORIGIN_ROOT:=$(INSTALL_LOCATION_BASE)`. Keep `configure/CONFIG_SRC`'s `DO_MAKE` assignment unchanged. T1 compares the effective recursive command against the baseline, with and without a top-level linker-root override, and requires `LINKER_ORIGIN_ROOT` to remain `INSTALL_LOCATION_EPICS`; T3 exercises the build workflows.
7. Run T1-T4 using the real shipped paths. Record exact revisions, source pins, commands, observation times, and outputs. Keep baseline defect evidence separate from candidate acceptance results; a successful configuration or make database query is not a successful build or IOC startup.

###### Selected Directions

Decision Date: 2026-09-28

| Item | Selected direction and affected files | Verification |
| --- | --- | --- |
| motor / direct autosave prerequisite | Keep `motor_DEPS` in `configure/CONFIG_MODS_DEPS`; add no direct autosave entry (K5) | T1 checks that AUTOSAVE remains undefined under the current configuration and that `motor -> busy -> autosave` ordering remains; T4 builds the motor prerequisite |
| QPC / ASYN path | Keep `QPC_DEPS`, `conf.QPC`, and the inherited ASYN path (K6); document the exception in `module-set.md` | T1 checks the resolved path and active data-installation targets; T3 builds QPC through the shipped workflow |
| Configuration grouping | Move `conf.QPC` and `conf.sscan` to `MODS_ONE_VARS` in `configure/RULES_MODS_CONFIG` | T1 checks group membership, aggregate configuration output, unchanged build ordering apart from the selected motorMotorSim change, and matching documentation |
| Missing/invalid declaration diagnostics | Keep the conditional hint and distinct errors in `configure/CONFIG_MODS_DEPS` (K7) | T1 invokes the real top-level path with empty and invalid declarations; both must exit 2 with the corresponding error and conditional hint |
| Linker variable | Remove only the unused assignment in `configure/CONFIG_BASE`; retain `configure/CONFIG_SRC`'s direct root argument | T1 requires the recursive command to keep `INSTALL_LOCATION_EPICS` as its linker root; T3 exercises the build workflows |

All five directions are selected. Plan acceptance and implementation authorization are recorded above.

##### Plan Review

Review Date: 2026-09-28
Review Basis: review 1 at `64ba7d3244f9cd4c9035743008a5375b0362bc4c`; reviews 2-4 at `73b71d8bc8cf3c924feeacfc8942180f89c55c55`, with the draft-plan revisions identified by their frozen evidence below
Review Count: 4 (third-person self-reviews)
Review Verdict: acceptable after the review-4 installation-path clarification; that clarification is incorporated in this draft alongside the earlier corrections and selected directions. Plan acceptance and implementation authorization were granted on 2026-09-28.

The findings below distinguish observed behavior from a defect assumption. The motorMotorSim direction and all five remaining directions were selected on 2026-09-28 and are reflected in Scope and Implementation Plan. The decision checks below support those choices and do not count as another plan review or candidate acceptance.

- Confirmed finding, Scope / module configuration: in a fresh checkout at the review-1 basis, the actual top-level make path prints `SRC_VER_MOTOR=m10-probe` after a `configure/RELEASE.local` override, while `INSTALL_LOCATION_MOTOR` still ends in `motor-285f44d`. The generated file's SHA-256 is unchanged. Its prerequisite list omits the supported override inputs (`configure/CONFIG_MODS:7`; override hooks in `configure/RELEASE:230-231`). Implementation step 2 and T2 now cover creating, editing, and removing an override at both hooks.
- Confirmed finding, Test Plan / T1: a comparison limited to `RELEASE.local` misses the actual configuration contract. `conf.motorMotorSim` writes `configure/RELEASE` directly; QPC's original `configure/RELEASE` defines ASYN and includes the parent configuration. Review 2 reproduced these outputs with real pinned sources. Revised T1 inspects the effective configuration, required build inputs, optional features, and build ordering.
- Confirmed finding, Test Plan / T2: review 2 showed that placing an override before the first cache generation gives the correct path on the defective baseline, so the original test can pass without detecting the defect. After cache creation, all six local/parent creation, editing, and removal cases retain stale paths. Revised T2 requires the baseline to fail those assertions and the candidate to pass them.
- Confirmed finding, Test Plan / T4: the actual generated prerequisite graph for `build.motorMotorSim` contains an empty `null.base` target and no reachable `build.base` target (`configure/RULES_BASE:105-115`). Revised T4 explicitly prepares, builds, and installs base in each isolated installation root before configuring and building the modules.
- Confirmed finding, Implementation Plan / documentation: review 3 found that `docs/src/procedures/add-or-bump-module.md:164-166` requires manual cache regeneration for a local pin change, but implementation step 4 omitted that procedure. Step 4 now includes its update and requires the documentation check to cover all three cache-related documents.
- Confirmed finding, Test Plan / T4 preparation shared by T1: review 4 found that the installation-root instruction did not specify how to set the value. With `INSTALL_LOCATION` passed on the top-level make command line, the value reaches recursive make and overrides the generated base setting: the real base core build installed directly under that root, and `install.base` exited 2 because the intended installation-tree directory was absent. Setting the value in the checkout's `configure/CONFIG_SITE.local` instead produced the intended base directory, and both build and install exited 0. Revised T4 steps 1-2 require that file setting throughout the procedure and check the configuration and libraries at the exact `INSTALL_LOCATION_BASE` path; T1 uses the same setup.
- Selected direction, Scope / motorMotorSim (2026-09-28): remove its direct autosave and iocStats build prerequisites while retaining the current configuration and feature set. The real target writes MOTOR, ASYN, and EPICS_BASE. The support library and IOC in `motorMotorSim-src/motorSimApp/src/Makefile` link motor, asyn, and EPICS base. The separate example under `iocs/` is included only with `BUILD_IOCS=YES`; its two extra services are conditional on `AUTOSAVE` and `DEVIOCSTATS` (`motorMotorSim-src/Makefile`; `motorMotorSim-src/iocs/motorSimIOC/motorSimApp/src/Makefile`). T4 must verify the selected build-order change against the current baseline; source inspection alone is not build verification.
- Selected Keep, Scope / motor (K5): the real configured motor RELEASE has no AUTOSAVE value, and `motor-src/modules/Makefile` forwards it only when defined. The generated prerequisites already include `motor -> busy -> autosave`. Retain the current declaration without a new direct autosave entry.
- Selected Keep, Scope / QPC (K6): the real configured RELEASE resolves ASYN to `$(EPICS_BASE)/../modules/asyn`. The active `digitelQpcApp` tree installs data and IOC fragments and declares no library or executable; `qpcApp` is outside the top-level DIRS. `gamma-pctrl.iocsh` uses the consuming IOC's ASYN macro. Retain `conf.QPC` and `QPC_DEPS`, and describe the inherited path accurately in the book.
- Selected change, Scope / configuration grouping: move `conf.sscan` and `conf.QPC` from `MODS_ZERO_CUSTOM_VARS` to `MODS_ONE_VARS`. Their effective SNCSEQ and ASYN settings belong with the documented other-module group. These lists group configuration targets and do not establish the build dependency graph; preserve recipes and aggregate output.
- Selected Keep, Scope / diagnostics (K7): real top-level invocations with empty and invalid `motor_CONF_TYPE` values both exit 2 and produce distinct missing/invalid errors with the same conditional stale-cache hint. Retain that wording. These checks do not establish that removing the cache repairs an arbitrary missing or invalid declaration.
- Selected change, Scope / linker variable: remove only the unused assignment at `configure/CONFIG_BASE:23`. Changing its top-level value in a real print-target invocation leaves `DO_MAKE`'s linker argument unchanged: `configure/CONFIG_SRC:61` supplies `INSTALL_LOCATION_EPICS` directly. Preserve that full installation-tree root.

Evidence: review 1 is recorded in `work/m10-premise-20260928/results.json`. Review 2 is recorded in `work/m10-plan-review2-20260928/setup.json` and `observations.json`, including commands, outputs, real source pins, generated configuration, the generated prerequisite graph, six stale override cases, and observation times. Its frozen plan is `plan-reviewed.md` with SHA-256 `651351f21e0f1bdc871b483e3132d832978a9d02e22e7286b31047c073156e46`. Review 3 is recorded in `work/m10-plan-review3-20260928/observations.json`; its `plan-reviewed.md` has SHA-256 `4a4c9cf7d9c90f493b598dded85b814be54567d9b04aaf04479e770c0ab54018`. It independently detected stale paths in all six baseline override cases, ran `conf.base`, and read the generated base build/install rules through make's database output. These checks ran the shipped make paths and actual source configuration without mocked internal functions. None of the three reviews ran a complete module build or IOC startup, and none supplies candidate acceptance results.

Decision evidence: `work/m10-decisions-20260928/observations.json` records the shipped configuration targets, EPICS base's real RELEASE parser, prerequisite queries, missing/invalid declaration invocations, and linker command expansion at `73b71d8bc8cf3c924feeacfc8942180f89c55c55`, observed at `2026-09-29T02:02:19.394620+00:00`. Source pins are motor `285f44d66cf7d07a86047719de757bd1f5d92a95`, QPC `913fad41df170063d910d0b4fdb083de696fac36`, and sscan `e13699e3062145d516cfdd555aae25bb49a8c53b`. These are configuration and source-inspection results, with no module compilation or IOC startup.

Review-4 evidence: `work/m10-plan-review4-20260928/` contains the frozen `milestone-84ee626.md` with SHA-256 `8d28aa71cf7d68770a318df34564aff446ece93fc82973103adcb81ece448303`. Its `observations.json` records six fresh baseline override cases, real module configuration and RELEASE parsing, prerequisite queries, diagnostics, and linker command expansion. `installation-probe.json` records the two installation-root methods at `2026-09-29T03:41:40.254006+00:00`, with the build and install logs beside it. Both methods ran the shipped `build.base` and `install.base` targets on base core pin `bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77` with the shipped base patches. Optional base submodules were not populated. These observations verify the installation-path premise; they are not full T4 or motorSim IOC acceptance results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Configuration | Run the effective-configuration procedure below for every module and each selected configuration decision | Debian 13; real pinned sources with shipped patches; base and required dependencies built through shipped targets | Every enabled build input is accounted for by the effective configuration and direct or transitive ordering; any extra declared prerequisite has an accepted reason. The configuration, diagnostics, linker command, and documentation match the selected decisions |
| T2 | Regeneration | Run the six-case override procedure below against the defective baseline and candidate without manually removing `MODULESGEN.mk` | Separate repository checkouts and writable installation roots; real top-level make path | The baseline fails all six path-update assertions and the candidate passes all six. Removal restores the default pin and path; unchanged repeat queries preserve cache content and modification time and terminate normally |
| T3 | Integration | Push the change to `master` and read the OS workflow runs | GitHub Actions on `master` | Every OS workflow passes |
| T4 | motorMotorSim dependency and feature preservation | Follow the isolated-build procedure below, including explicit base preparation. Read the generated direct prerequisites, compare module configuration and installed `motorSim.dbd`, and start each built motorSim IOC to compare registered support. Check the full module list and declared-dependency documentation | Debian 13; separate writable installation roots; identical real EPICS base and module pins with shipped patches; default optional-feature settings | The baseline has the two extra direct prerequisites; the candidate has only `null.base build.motor build.asyn`. Both builds and IOC startups succeed with matching configuration and registered support after normalizing installation roots. autosave and iocStats remain in the full module set, and the documentation names the candidate's direct prerequisites |

###### T1 Effective Configuration

1. Obtain the real pinned sources, apply the shipped patches, and prepare base using T4 steps 1-2, including the checkout's `configure/CONFIG_SITE.local` installation-root setting and exact installed-base path checks. Keep that file setting for every T1 invocation; do not pass `INSTALL_LOCATION` on the make command line. Then run `conf.release.modules` and each module's actual configuration target, including existing name mappings such as `conf.sncseq`.
2. Build the required module dependencies through the shipped targets. For each actual module build directory, inspect the configuration resolved by its own make path: `RELEASE`, parent and local includes, applicable architecture-specific files, and `CONFIG_SITE` settings. Record the resolved dependency paths and feature conditions. A missing `RELEASE.local` is not itself a failure.
3. Compare the enabled consumers in the real module Makefiles with the generated build prerequisites, distinguishing direct requirements, transitive prerequisites, conditional features, and data-only consumers. Include motorMotorSim's default IOC and the separately gated `iocs/` example; preserve the existing optional-feature settings. Do not require textual equality between a dependency list and one configuration file.
4. For motor, record the undefined AUTOSAVE setting under the existing configuration and the `motor -> busy -> autosave` prerequisite chain. For QPC, record the inherited `$(EPICS_BASE)/../modules/asyn` value, the active data-installation targets, and the IOC fragment's runtime ASYN use. Compare `motor_DEPS`, `QPC_DEPS`, and their configuration output against the baseline; require the K5 and K6 boundaries to remain intact.
5. Query the actual configuration groups: `conf.QPC` and `conf.sscan` must each occur once in `MODS_ONE_VARS` and be absent from `MODS_ZERO_CUSTOM_VARS`. Run `conf.modules` on baseline and candidate using identical pins and settings, and compare all generated module configuration after normalizing installation roots. Require the Libera-specific group and build prerequisites to remain unchanged apart from the selected motorMotorSim direct-prerequisite change. Check the group description in `add-or-bump-module.md` and the QPC exception in `module-set.md`.
6. In isolated checkouts, invoke the top-level `print-MOD_NAMES` target with `motor_CONF_TYPE=` and with `motor_CONF_TYPE=invalid`. Require exit 2, the corresponding missing or invalid declaration error, and the existing conditional hint in each case. Record commands and output; this verifies the diagnostics, not recovery from every declaration error.
7. Query `DO_MAKE` through the real top-level print target on baseline and candidate, both with the default linker-root setting and with a distinct command-line `LINKER_ORIGIN_ROOT` value. Require the expanded recursive command to remain unchanged after normalizing installation roots and to pass `LINKER_ORIGIN_ROOT=INSTALL_LOCATION_EPICS` in all cases. Check the matching linker description in `configuration-variables.md`.

###### T2 Override Changes

Use a defective baseline at `73b71d8bc8cf3c924feeacfc8942180f89c55c55` and record the candidate revision or exact diff. Use the same assertions on both. Run each case independently for `configure/RELEASE.local` and `../RELEASE.local`, with the other hook absent and every input confined to the disposable checkout and its parent. Query both `SRC_VER_MOTOR` and `INSTALL_LOCATION_MOTOR` through the shipped top-level print targets.

1. Creation: with no override, query once to generate the cache and record the default pin and path. Create the override with a different `SRC_VER_MOTOR`, query again, and require both the pin and path to change.
2. Editing: create an initial override before the first query and confirm its generated path. Change the pin in that existing file, query again, and require the path to follow the new pin. The initial successful query alone does not count as regression coverage.
3. Removal: generate the cache with an override active, then move that override outside the included path. Query again and require the pin and path to return to their defaults without removing the cache.
4. After each candidate transition, repeat the query without changing any input. Require identical values and cache content and modification time, with a bounded timeout to detect a make restart loop. Retain commands, outputs, cache hashes, and timestamps for the six cases. Review 2 supplies baseline observations only; the final regression must run on both versions.

###### T4 Isolated Build And IOC Comparison

1. Prepare baseline `73b71d8bc8cf3c924feeacfc8942180f89c55c55` and the recorded candidate in separate checkouts with separate writable installation roots. Before the first make invocation, write `INSTALL_LOCATION:=<absolute-install-root>` in each checkout's `configure/CONFIG_SITE.local`, using that checkout's root. Keep this file setting throughout T4 and its shared T1 setup; do not pass `INSTALL_LOCATION` on the make command line, where it would also override the recursive base and module settings. Record all actual source commits and submodule pins. Use identical host prerequisites and default optional-feature settings.
2. From each checkout's top directory, run separate, sequential invocations of the shipped targets: `init`, `patch`, `conf.base`, `build.base`, and `install.base`, using the file setting from step 1. Require every invocation to succeed. Query `INSTALL_LOCATION_BASE` through the shipped top-level print target and verify `configure/CONFIG` and the base libraries under that exact directory (`lib/linux-x86_64/libCom.so` for this Debian 13 environment). Files installed directly under the outer installation root do not satisfy this check. Stop before module configuration if the expected base files are absent; source presence and `null.base` do not satisfy this prerequisite.
3. Run `conf.modules` after base installation; this includes the shared parent configuration and module configuration targets. Capture the effective motor and motorMotorSim configuration and the real generated prerequisite graph. Confirm that the candidate's direct motorMotorSim prerequisites are exactly `null.base build.motor build.asyn`.
4. Run `build.motorMotorSim` with its generated prerequisites. Require successful compilation and installation in both roots, then compare the installed `motorSim.dbd` and relevant generated configuration after normalizing only the two installation roots.
5. Start each build's motorSim IOC with the same startup actions using that build's installed DBD and generated registrar. Require successful initialization, capture registered support and startup diagnostics, and compare the support sets. A successful make database query or binary launch alone is insufficient.
6. Confirm that both autosave and iocStats remain in the complete module list, and that `docs/src/reference/module-pins.md` describes the candidate's direct prerequisites. This check removes two direct build-order entries without removing modules or enabling optional services.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-29T04:20:15.986403+00:00 | Debian 13; real pinned sources, installed base and required dependencies | Pass | 32 module configurations; 148 configuration files match after installation-root normalization; actual Makefile inspection, declared dependency audit, Keeps, grouping, diagnostics, linker, and path-origin checks pass; `work/m10-implementation-20260928/verification-summary.json` |
| T2 | 2026-09-29T04:17:30Z | Six independent cases per revision; real top-level make | Pass | Baseline fails all six path-update assertions; candidate passes all six and preserves cache hashes and modification times on unchanged repeats; `work/m10-implementation-20260928/overrides.json` |
| T3 | 2026-09-29T08:18:00Z | GitHub Actions on `master`, commit `6bbb6a5` | Pass | Debian 12/13, Rocky 8/10, and Ubuntu 24.04/26.04 all pass, including EPICS installation and environment checks; workflow links below |
| T4 | 2026-09-29T04:17:30Z | Debian 13; separate baseline and candidate installations with identical source pins and default features | Pass | Both base and motorMotorSim builds and installations pass; the installed IOCs initialize eight motors from the shipped asyn fixture with identical sets of 363 registered names; installed DBD and normalized generated registrar match; `work/m10-implementation-20260928/ioc-asyn.json` |

Implementation evidence: baseline `73b71d8bc8cf3c924feeacfc8942180f89c55c55`; the candidate is the same revision plus `work/m10-implementation-20260928/candidate-final.patch`, SHA-256 `fe4ae10a2098e53079b966031b09e61c5f9e45922d3133eb379c110e53009fc3`. The five changed configure files are hashed in `verification-summary.json`. The accepted plan remains frozen in `accepted-plan.md`; the implementation does not change its scope or test criteria.

- T1: each checkout ran the shipped `init`, `patch`, `conf.base`, `build.base`, `install.base`, `conf.modules`, `build.motorMotorSim`, `build.mca`, and `build.QPC` targets. The exact installed base configuration and `libCom.so` exist at `INSTALL_LOCATION_BASE`. `baseline/configuration-final.json` and `candidate/configuration-final.json` record all source commits, submodule states, RELEASE parsing, and active Makefile values. The rgamv2 database directory was also checked with the `EPICS_HOST_ARCH` value normally exported by its parent make; both follow-up invocations pass in `configuration-followup.json`. Both dependency audits exit 0. The candidate's only remaining declared-unobserved dependency is QPC's accepted ASYN declaration (K6). The actual generated build graph differs only in the two selected motorMotorSim prerequisites. `invariants.json` covers legacy cache migration, tracked-input invalidation, unchanged repeats, configuration groups, diagnostics, linker command, and explicit regeneration. `linker-comparison.json` records default and explicit linker-root queries on both revisions. K5-K7 remain unchanged.
- T2: `overrides.py` runs the same path assertions against both revisions, with independent creation, editing, and removal cases for both supported hooks. Every query uses a 20-second timeout. No case removes the cache to repair an override transition.
- T4: EPICS base and its submodules were populated by the shipped `init` target. The default motorSim executable loads its own installed DBD and generated registrar, then executes the unmodified upstream `motorSim.cmd` and `motorSim.substitutions` fixtures under `iocs/motorSimIOC/iocBoot/iocMotorSim`. The fixture loads the installed motor database. The test does not enable `BUILD_IOCS`, AUTOSAVE, or DEVIOCSTATS. Both IOCs exit 0 after successful `iocInit`, with eight motor records and matching registered support. `ioc-asyn.py`, the generated startup command files, and the stdout/stderr logs preserve the procedure. The DBD SHA-256 is `b7d2b8f2e8f20a832789b251c5b052de83027e74921a85dc7636191bcea8e838` in both installations.
- Additional observation outside the selected dependency change: the separate upstream `motorSimTest.src` fixture exits with SIGSEGV during `iocInit` on both baseline and candidate (`ioc.json`). Its cause has not been diagnosed. T4's passing result applies to the shipped asyn fixture above; it does not establish that every upstream startup example works.
- Documentation: the four changed book pages build with the repository's mdBook image. The rendered output is under `work/m10-implementation-20260928/book/`. The override procedure keeps explicit regeneration optional, and the QPC and linker descriptions match the observed configuration. `git diff --check` passes.

###### CI Runs

Observed at 2026-09-29T08:18:00Z using `gh run list` filtered by the full implementation commit and `gh run view <run-id>` for each run in `jeonghanlee/EPICS-env`. Every run is a completed, successful `push` run on `master` at `6bbb6a5e45a49aad093d0c233113f40235ed2b4a`. Both the `EPICS installation` and `EPICS Environment Check` steps succeeded in every OS workflow.

| Workflow | Run | Result |
| --- | --- | --- |
| Debian 12 | [36537862518](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862518) | Pass |
| Debian 13 | [36537862513](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862513) | Pass |
| Rocky 8 | [36537862588](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862588) | Pass |
| Rocky 10 | [36537862601](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862601) | Pass |
| Ubuntu 24.04 | [36537862586](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862586) | Pass |
| Ubuntu 26.04 | [36537862580](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862580) | Pass |
| Linter Run | [36537862531](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862531) | Pass |
| Deploy Docs | [36537862537](https://github.com/jeonghanlee/EPICS-env/actions/runs/36537862537) | Pass |

##### Closure Evidence

- Implementation commit: `6bbb6a5e45a49aad093d0c233113f40235ed2b4a`, committed and pushed on 2026-09-29. The commit contains the five configure changes, four book pages, and the decision and milestone records.
- Landing observed at 2026-09-29T08:18:10Z: after fetching `origin`, both `HEAD` and `origin/master` resolve to `6bbb6a5e45a49aad093d0c233113f40235ed2b4a`. The implementation commit is an ancestor of the fetched upstream, and the comparison of all 11 committed paths returns no differences. Recheck with `git fetch origin`, `git rev-parse HEAD origin/master`, and a path-limited `git diff <implementation-commit> origin/master -- <committed-paths>`.
- Verification: T1-T4 pass. The six OS workflows, Linter Run, and Deploy Docs all succeeded for the implementation commit; the workflow table records their durable URLs.
- Linked issue: #83 closed as completed at 2026-09-29T08:26:56Z; observed at 2026-09-29T08:31:49Z through `gh issue view 83 --repo jeonghanlee/EPICS-env`. The published body matches the accepted scope and completed verification, and the [closure comment](https://github.com/jeonghanlee/EPICS-env/issues/83#issuecomment-5886516866) records the result.
- Complete on 2026-09-29: the implementation is on `origin/master`, T1-T4 pass, and the linked issue is closed. This record preserves those observed results.


##### GitHub Projection

Title: Make module configuration agree with declared dependencies
Labels: bug
GitHub Milestone: Backlog
Observed State: closed (completed at 2026-09-29T08:26:56Z; observed 2026-09-29T08:31:49Z, `gh issue view 83 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-29T08:31:49Z (remote updatedAt 2026-09-29T08:26:56Z); title, label, milestone, and assignee match. The published body records the selected changes, retained behavior, all five completed acceptance criteria, and the eight successful CI runs. The closure comment matches the prepared result, and the observed issue state is closed.

#### M11 - CI Workflow Coverage

Origin: 84ee626 / M11
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #84, https://github.com/jeonghanlee/EPICS-env/issues/84
Status: Complete

##### Summary

Rocky 10, Ubuntu 24.04, and Ubuntu 26.04 omit the pre-build module dependency audit. Debian 12, Debian 13, and Rocky 8 already run it through `github.check`. D25 expands this work to add `conf.rocky10` in both vendor repositories and use it from the Rocky 10 workflow, while retaining the existing `conf.rocky8` interface and configuration behavior.

##### Scope

- In `jeonghanlee/uldaq-env` and `jeonghanlee/open62541-env`, add `conf.rocky10` in `configure/RULES_INSTALL` and document it in each `README.md`. The new target delegates to the existing `conf.rocky8` recipe; both target names remain callable.
- In `.github/workflows/rocky10.yml`, switch both vendor configuration calls to `conf.rocky10` after the vendor changes land. Print each vendor checkout's commit immediately after its clone so the run identifies the consumed source.
- Add `make check.module-deps` to the `EPICS installation` step in `.github/workflows/rocky10.yml`, `.github/workflows/ubuntu24.yml`, and `.github/workflows/ubuntu26.yml`.
- Update the CI coverage and vendor invocation descriptions in `docs/src/introduction.md`, `docs/src/concepts/verification-gates.md`, `docs/src/reference/supported-platforms-and-ci.md`, and `docs/src/reference/tools-and-scripts.md`.
- Keep the vendor configuration behavior covered by K8 in `docs/CLOSED_DOORS.md`; D25 supersedes the earlier restriction on adding a target or changing Rocky 10's calls.

- Repair the source-change guard in `.github/workflows/docs.yml` under D26 and update its description in `docs/src/reference/supported-platforms-and-ci.md`.

Out of scope: removal of `conf.rocky8`; changes to compiler/linker settings, installation layout, source pins, containers, package setup, workflow triggers, or the dependency-audit implementation; vendor CI repairs or redesign; the defects of M9, M10, and M12-M19.

##### Completion Criteria

- Both vendor repositories provide a working `conf.rocky10` entry point that reuses the existing configuration recipe. `conf.rocky8` remains supported, with real configuration/build/install evidence for the compatibility checks below.
- Both vendor changes are available from the default branches that EPICS-env clones before the dependent workflow changes are published. The Rocky 10 run records and uses commits containing the new target.
- All six EPICS-env OS workflows reach `check.module-deps` after patching and configuration and before compilation. The existing `github.check` callers remain intact, and audit failures remain fatal.
- The three changed EPICS-env workflows pass the actual audit, build, install, `check.env`, and `check.deps`. Rocky 10 builds and installs both vendors through `conf.rocky10`.
- The two vendor READMEs and four book pages describe the selected target names and audit coverage. T1-T6 pass; historical CI results are not reported as validation of the new vendor revisions.

- The documentation CI guard trusts the checkout and fails both on Git errors and on source changes after the build.

##### Dependencies And Decisions

- D17 places the EPICS-env work on `master`; D23 assigns this independent defect group to M11.
- Behavioral ordering: the audit reads patched module sources and generated module configuration, so it runs after `patch` and `conf` and before `build`.
- D11 preserves the current EPICS-env push filters. The three affected workflow files trigger their three OS runs; the unchanged OS workflows have no manual trigger.
- D25 (Decision Date: 2026-09-29) supersedes D24's vendor-scope restriction. It selects `conf.rocky10` in both vendor repositories, with the existing behavior and `conf.rocky8` compatibility preserved.
- Delivery ordering within M11: both vendor changes must be verified and published first; the EPICS-env switch depends on their published commits. The vendor changes are independent of each other.
- Before editing a vendor repository, identify its maintained checkout and owning writer. If another session owns it, that writer makes and reports the change. Record each vendor's baseline, candidate, validation, and published commit here; publication in one repository does not imply publication in another.

- D26 (Decision Date: 2026-09-29) includes the source-change guard repair authorized after the Deploy Docs 36603576766 log showed a Git ownership failure hidden by command substitution.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-29; expanded D25 plan and T1-T5, including the T2 environment conditions; D26 extends the accepted scope with the documentation guard repair and T6
Implementation Authorization: 2026-09-29; implement the accepted expanded D25 plan, including the T2 environment conditions; the D26 documentation guard repair is explicitly authorized on 2026-09-29
Superseded Plan Artifacts: D24-limited draft in this canonical detail (2026-09-29); no accepted implementation plan

Planning bases: EPICS-env `ebb8544fd81701f594b2e3a651a676c9463dea10`, `uldaq-env` `afd6f49e65c7cd64a215f20458e43a843dea4f61`, and `open62541-env` `f297d97f9a860ee1f63eba29b4f8919cdb32953a`. The first plan review confirmed the missing audits and the vendor target semantics. The expanded D25 plan, with the T2 environment correction, is accepted on 2026-09-29; implementation is authorized on 2026-09-29.

1. Resolve the two vendor checkouts and their writers, then recheck all three repository bases before implementation. In each vendor's `configure/RULES_INSTALL`, add `conf.rocky10` as a prerequisite-only alias of `conf.rocky8`, preserving the existing Linux condition where present. Declare both action targets phony and keep the actual configuration recipe in one place.
2. Document the new target and retained old target in both vendor READMEs. Keep the existing flags, source pins, prefix override, library directory, and ordinary `conf` target unchanged. Prepare and freeze the package environment for each OS as specified in T2, then run the real vendor comparisons from that same prepared image and record the exact candidate commits.
3. Publish the verified vendor changes under the separate repository-specific commit and push authorizations. Confirm both commits are reachable from the default branches EPICS-env clones. Do not publish the EPICS-env switch while either target is available only in an unpublished checkout.
4. In Rocky 10, print each cloned vendor's commit and change its configuration invocation to `conf.rocky10`. Retain the clone source, clone depth, installation prefix, and other make goals.
5. Insert one `make check.module-deps` immediately before `make build` in each of the three affected EPICS-env workflows. This follows `make conf` and the existing `make vars` in Ubuntu. Preserve failure propagation without error suppression or a replacement for the shipped audit.
6. Update the four Scope book pages with the audit coverage, build sequences, and Rocky 10 vendor target. The independent `tools/prep-vendors.bash` entry continues using its existing target; its description must still match its own code.
7. Run T1-T5 and record the actual source commits, execution environments, observation times, and results. Recheck the vendor commits consumed by the Rocky 10 CI run. Any unexpected vendor revision or out-of-scope failure needs investigation before acceptance, without silently broadening the changes.

8. In the documentation guard, register only `GITHUB_WORKSPACE` as `safe.directory`, assign the `git status` output before testing it, and retain the Actions fail-on-error shell. Run T6 with the actual workflow step, then require a corrected Deploy Docs run under T5.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | Parse all six shipped EPICS-env workflow YAML files; inspect installation ordering and the real `github.check` prerequisites; inspect both vendor aliases, phony declarations, and complete diffs; run `git diff --check` in each checkout | Three candidate repositories | Six audit paths follow `conf` and precede `build`; only the three missing calls are added; Rocky 10 uses the new vendor names; both names reach one unchanged recipe per vendor; shared build inputs, triggers, and existing checks retain their intended behavior |
| T2 | Vendor integration | Prepare the package environments using the T2 procedure below. For each vendor, run the shipped `init`, configuration target, `build`, and `install` in separate baseline and candidate trees: baseline `conf.rocky8`, candidate `conf.rocky8`, and candidate `conf.rocky10` on Rocky 10; also run candidate `conf.rocky8` on Rocky 8. Compare effective flags, prefixes, installed libraries, and dynamic tags from the real results | One prepared image per OS, based on `rockylinux/rockylinux:10` and `rockylinux/rockylinux:8.10`; identical package/compiler environments within each OS; the vendor source pins and isolated installation prefixes from the shipped configuration | Every path completes and the environment identity checks below pass. On Rocky 10 the old and new names preserve effective compiler/linker settings, shared-library installation, relative library paths, and RUNPATH behavior; Rocky 8 retains the working old interface. Normalize only the deliberately separate installation/source roots and incidental timestamps |
| T3 | Published dependency | Confirm each tested vendor commit is reachable from the default branch used by the consumer; read the vendor SHAs printed by the actual Rocky 10 run and compare their trees with the tested candidates | GitHub vendor branches and the candidate EPICS-env Rocky 10 run | Both new targets were published before consumption. The consumed commits match the tested candidates, or any later change has been inspected and relevant verification repeated; a local-only target or an unexamined vendor revision does not pass |
| T4 | Integration | After authorized publication, read the actual module-audit output and subsequent build/install/check steps in all three changed EPICS-env OS logs at the full implementation commit | GitHub Actions on `master`: Rocky 10, Ubuntu 24.04, Ubuntu 26.04 | Each configures its real pinned modules, runs the strict audit before compilation, and passes installation, `check.env`, and `check.deps`; Rocky 10 actually builds both vendors through `conf.rocky10`. The candidate Linter Run also succeeds |
| T5 | Documentation | Read both vendor READMEs against their Makefiles and the four book pages against the workflows; build with the repository's mdBook image and inspect the changed rendered passages | Candidate source trees; `jeonghanlee/mdbook`; Deploy Docs after the authorized push | The two target names and compatibility are documented accurately, the book's coverage and sequences match the code, the book builds without changing `docs/src`, and deployment succeeds |
| T6 | Documentation guard integration | Execute the exact shipped guard run block with sh -e in the mdBook image against a real clone: clean docs after a real build, changed docs, and an actual Git error. Execute the old guard on the ownership-error case to confirm the regression | jeonghanlee/mdbook with a host-owned checkout and isolated container Git configuration | Clean docs pass; changed docs and Git errors fail. The old guard reproduces false success. Parse YAML, check the shell block, and retain image identity and outputs |

T1 is source inspection. T2 and T4 must run the shipped targets and real pinned vendor/module sources; no internal stub, no-op build, or hand-built fixture replaces configuration, compilation, installation, or the audit. Record the actual container image identity, source revisions, and configured prefixes for T2. Do not point either build at an existing production installation.

T2 environment preparation and comparison:

1. Resolve each base image once and record its digest and architecture. In an isolated container for each OS, execute the package preparation commands from the corresponding EPICS-env workflow's `Install required packages` step, stopping before `VENDOR_PATH` and vendor setup. Use `.github/workflows/rocky10.yml` for Rocky 10 and `.github/workflows/rocky8.yml` for Rocky 8, including the latter's additional package and pip commands. Record the EPICS-env revision, exact setup commands, and consumed `pkg_automation` commit. This reuses the existing package setup without changing the shipped workflows.
2. Save each prepared environment as a local image before any vendor build and record its immutable image ID, installed RPM package names/versions/architectures, installed pip packages where applicable, and compiler, linker, CMake, Autoconf, Automake, and Libtool versions. Start every case for that OS in a fresh container from that exact prepared image ID, with the same architecture and build environment variables. Do not rerun package installation or updates between cases, or reuse generated source, build, or installed-library trees.
3. Before each build, confirm that its package inventory and tool versions match the recorded prepared environment. On Rocky 10, all three cases for each vendor must use the same image ID and resolve the shipped source pins, including submodules where applicable, to the same source commits. Record each wrapper revision and isolated source/install root separately. A mismatch invalidates the comparison; prepare one common environment and repeat all affected cases before accepting T2. Rocky 8 is a separate compatibility environment and is not required to match Rocky 10's packages or compiler.

Before accepting T4, check that its logs contain the configured module inventory and audit results, not only a green job status. The three unchanged EPICS-env workflows retain their existing audit calls; T1 checks those paths and T2 supplies new vendor compatibility evidence. The six successful OS runs at `6bbb6a5` remain historical baseline evidence only: their old vendor revisions do not verify the newly published targets.

A push containing only the three affected EPICS-env workflows and the planned documentation triggers those three OS workflows, Linter Run, and Deploy Docs under D11. This plan does not claim six new EPICS-env GitHub Actions runs. Vendor validation and EPICS-env validation must keep their separate source commits and outcomes. The D26 follow-up changes only the documentation workflow and documentation, triggering Deploy Docs and Linter Run while retaining the three OS validation runs at 921cd5f843df1ffc4167324fd762be33a6bb4164.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-29T15:42:53.091988+00:00 | EPICS-env and the two local vendor candidates | Pass | Six real workflow YAML files parsed; audit ordering and unchanged triggers checked; both vendor recipes preserved with phony aliases; real make dry-runs expand both names identically; actionlint 1.7.12 and three repository diff checks pass |
| T2 | 2026-09-29T15:54:31.722946+00:00 | Fixed Rocky 10 and Rocky 8 package images; real pinned vendor sources | Pass | Eight shipped init/configure/build/install paths pass. Each vendor's three Rocky 10 cases match package/tool environment, source and submodule commits, effective flags and prefixes, installed files/symlinks, and full dynamic tags. Both Rocky 8 legacy-target builds pass. All installed shared libraries use RUNPATH with $ORIGIN/. and no RPATH; exact candidate file hashes and results are in work/m11-implementation-20260929/t2-results.json |
| T3 | 2026-09-29T18:35:46Z | Published vendor branches and Rocky 10 run 36603576627 at 921cd5f843df1ffc4167324fd762be33a6bb4164 | Pass | The actual clone logs record uldaq-env 988b1523a759855b5e98c23e3cde050ab8d1b26e and open62541-env 00e5e60eb24a64d94578b608538d4288c90a0dbf, matching the published and locally tested trees. Both real conf.rocky10 build/install paths complete |
| T4 | 2026-09-29T18:35:46Z | Rocky 10 36603576627, Ubuntu 24.04 36603576682, Ubuntu 26.04 36603576770 at 921cd5f843df1ffc4167324fd762be33a6bb4164 | Pass | All three actual logs contain strict dependency audits of 32 configured modules before compilation, followed by successful build, install, check.env, and check.deps. The shared declared-unobserved: asyn finding is non-fatal under the current strict policy. Environment findings and RPATH/ABSPATH/LOSTORG error counts are zero. Linter Run 36603576615 succeeds |
| T5 | 2026-09-29T18:35:46Z | Vendor READMEs, local rendered book, Deploy Docs 36611624563 at 840ad37dd8bb279db7688efcf0c866c0f14e259c | Pass | README/source and rendered documentation checks pass locally. The corrected remote mdBook 0.5.4 build, Git source-change guard under sh -e, artifact upload, and Pages deployment all succeed. Linter Run 36611624427 also succeeds |
| T6 | 2026-09-29T18:35:46Z | Local mdBook image sha256:2b53e59ebf0edf2913e0636ff2e31351f0f0c4c7593fb51d1f22b4b629173015 and remote Deploy Docs 36611624563 at 840ad37dd8bb279db7688efcf0c866c0f14e259c | Pass | Exact local shipped guard: clean docs after real build exit 0, changed docs exit 1, Git error exit 128; old guard ownership-error case falsely exits 0. YAML, shell syntax, ShellCheck, actionlint, and changed book build pass. The remote guard executes all three shipped commands under sh -e without a Git ownership error and deployment succeeds. Exact local workflow hash and outputs remain in work/m11-docs-guard-20260929/results.json |

Local implementation evidence: `work/m11-implementation-20260929/` contains the two independent vendor checkouts, candidate file hashes, actionlint output, mdBook output, rendered book, package preparation logs, and the T2 driver. Both vendor checkouts were created for this work after checking the available sessions and the usual checkout paths; no existing vendor writer was identified. Their baseline commits are the Planning bases above. Published vendor commit IDs and default-branch observations are recorded below.

T2 execution identity:

- rocky10: base `sha256:0b5329d806d053ad65ab6b21fc3e49f1025e970cd826547a01a93b3ce9012796` (amd64); prepared image `sha256:bff3174e228da6d5fdfb89db0b10db775e2b8271743d6b187a1e494448a5976d`. The setup logs record pkg_automation `472ef7654e4541ba6322e301ac78bea5691e3845`.
- rocky8: base `sha256:fcc573d8a467898553374348812a0c93d900161b7b97cf71c76476db5e41c7b3` (amd64); prepared image `sha256:d11a335bd99a97ceec0ea5d9b32f16199babd50f24c514df7b783787cb11263e`. The setup logs record pkg_automation `472ef7654e4541ba6322e301ac78bea5691e3845`.
- uldaq-env: wrapper baseline `afd6f49e65c7cd64a215f20458e43a843dea4f61` plus tested candidate diff SHA-256 `0905cd7d6b346eb81ed3d4b9ec54d1b5aeed1148fff5f03272179222e2b63deb`; library source `c7b94531185ff098af166da2be1f3a4a648cfa96`. Candidate file hashes, source/submodule identities, package/tool inventories, actual build logs, installed trees, and dynamic tags are retained with the T2 results.
- open62541-env: wrapper baseline `f297d97f9a860ee1f63eba29b4f8919cdb32953a` plus tested candidate diff SHA-256 `711a2c0763d47cb02283d0b9b5dc039326b815f3b4b648d4d88c0d7afa473c05`; library source `3eed1a6d5c5b207c531b2d35ed88aa0a4a4541e5`. Candidate file hashes, source/submodule identities, package/tool inventories, actual build logs, installed trees, and dynamic tags are retained with the T2 results.

Published vendor observation (2026-09-29T17:07:12.313912+00:00): `git ls-remote --symref https://github.com/jeonghanlee/uldaq-env HEAD refs/heads/master` and the corresponding command for `https://github.com/jeonghanlee/open62541-env` resolve HEAD to refs/heads/master and the commits recorded in T3. The committed patches match the T2 candidate diff hashes above, and all tracked files match the tested Rocky 10 candidate trees. No new vendor CI result is claimed.

##### Closure Evidence

- T1-T6 pass through the shipped code and actual local or remote execution paths. The vendor commits are published and consumed by Rocky 10; EPICS-env 921cd5f843df1ffc4167324fd762be33a6bb4164 supplies the OS workflow changes, and 840ad37dd8bb279db7688efcf0c866c0f14e259c supplies the corrected documentation guard.
- Landing observation (2026-09-29T18:35:46Z): git ls-remote origin refs/heads/master resolves to 840ad37dd8bb279db7688efcf0c866c0f14e259c, matching local HEAD and origin/master.
- CI evidence: [Rocky 10](https://github.com/jeonghanlee/EPICS-env/actions/runs/36603576627), [Ubuntu 24.04](https://github.com/jeonghanlee/EPICS-env/actions/runs/36603576682), [Ubuntu 26.04](https://github.com/jeonghanlee/EPICS-env/actions/runs/36603576770), [Deploy Docs](https://github.com/jeonghanlee/EPICS-env/actions/runs/36611624563), and [Linter](https://github.com/jeonghanlee/EPICS-env/actions/runs/36611624427) all succeed at their recorded commits.
- Verification record landing observation (2026-09-29T18:53:23Z): `git ls-remote origin refs/heads/master` resolves to `2b27ed5d790569121930003dee5823c0f4e52ef7`, matching local HEAD and origin/master. This published commit records the completed T1-T6 results.
- Issue closure observation (2026-09-29T18:53:23Z): `gh issue view 84 --repo jeonghanlee/EPICS-env --json state,stateReason,closedAt,updatedAt` reports CLOSED, COMPLETED, and closedAt 2026-09-29T18:49:21Z. The reconciled body records the shipped changes, verification results, and satisfied acceptance criteria; the completion comment is published.
- Completion Date: 2026-09-29. The accepted deliverables, required verification, vendor publication and consumption, implementation landing, verification record landing, and linked issue closure are satisfied.

##### GitHub Projection

Title: Run the same dependency checks in every OS workflow
Labels: bug
GitHub Milestone: Backlog
Observed State: closed, completed (2026-09-29T18:53:23Z, `gh issue view 84 --repo jeonghanlee/EPICS-env`)
Observed Closed At: 2026-09-29T18:49:21Z
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-29T18:53:23Z (remote updatedAt 2026-09-29T18:49:21Z)
Projection Follow-up: none; the issue body and completion comment match the published implementation and verification results, and #84 is closed as completed.


#### M12 - Make-Time Side Effects

Origin: 84ee626 / M12
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #85, https://github.com/jeonghanlee/EPICS-env/issues/85
Status: Complete

##### Summary

Make evaluates the installation-directory creation probe in `configure/CONFIG_SRC` before running any target. The included `configure/MODULESGEN.mk` is also generated when absent and regenerated when tracked configuration or effective module pins change. These writes occur during variable queries, including `make -n print-INSTALL_LOCATION`.

Premise verification at `5a130908464f2a4a90108223fcf4a087d70d61f8` on 2026-09-29 used independent fresh local clones and the shipped Makefiles. Both `make print-INSTALL_LOCATION` and `make -n print-INSTALL_LOCATION` exited 0 while creating the previously absent install directory and `configure/MODULESGEN.mk`. A real `configure/RELEASE.local` override from asyn 4.46.0 to 4.46.1 made `make print-INSTALL_LOCATION_ASYN` rewrite the existing cache and print the updated path; the next unchanged invocation preserved its bytes and modification time. These observations establish the defects and the existing value behavior; they do not verify a candidate fix.

##### Scope

- In `Makefile` and `configure/RULES_SRC`, establish the shipped default goal before CONFIG evaluation while preserving effective `.DEFAULT_GOAL` overrides.
- Stop installation-directory creation by query-only invocations in `configure/CONFIG_SRC`.
- Stop generation and regeneration of `configure/MODULESGEN.mk` by query-only invocations in `configure/CONFIG_MODS`, while deriving current module variables from the effective configuration in memory.
- Classify the shipped query targets before these CONFIG files are evaluated: `print-%`, `PRINT.%`, `vars`, `env`, `default`, `ls.%`, `tree.%`, `cat.%`, `exist`, `exist.modules`, `show.genmk`, `conf.show`, and the actually declared `conf.*.show` targets, including aggregates and dynamically generated auto-module targets. When the explicit goal list is empty, classify the effective `.DEFAULT_GOAL`, including command-line overrides; the unchanged shipped default is `vars`. Every explicit goal must be a recognized query target for the invocation to take the query-only path. Unknown or mixed query/action goal lists retain the normal action path; do not classify an undeclared name merely because its suffix is .show.
- In `configure/RULES_MODS`, display current generated configuration on stdout for show.genmk when MODULESGEN.mk is absent; retain existing-file display when present and preserve other generated-file output.
- Preserve the current generated module values, module-only lists, command-line precedence, file-origin filters, repository overrides, and the M10 cache invalidation behavior for action invocations.
- Update the book descriptions of variable queries, install-location permissions, generated module variables, and cache regeneration where this behavior changes. Include the directory-creation paragraph in docs/src/tutorial/first-environment.md under the accepted 2026-09-29 scope extension.

Out of scope: universal suppression of all effects of `make -n` on action targets; changes to build/install recipes, source pins, compiler flags, dependency audit policy, workflow triggers, source-URL policy, user-supplied local-file side effects, or the defects assigned to M13-M19.

##### Completion Criteria

- Each recognized query-only invocation creates no installation directory and creates, rewrites, or removes no repository file, whether `MODULESGEN.mk` is absent, current, or stale. Byte content, file set, and modification times remain unchanged. The same applies with `-n` on those query goals.
- Variable queries return values derived from the current effective configuration even when the persistent cache is absent or stale. Local and parent overrides, their removal, command-line overrides, and the existing special module mappings retain their semantics. File-display targets retain their file-content meaning under the show.genmk rule below.
- Query-time inspection preserves the meaning of the existing creation probe without performing a write: an existing directory whose type can be resolved through its parent path yields `SUDO_INFO=0` even when the final directory has mode 000 and cannot itself be read, written, or searched. For an absent directory, inspect the nearest existing ancestor and traversal/create permissions. An existing non-directory yields failure. Parent components that prevent resolving the final path or creating missing components also yield failure. Do not require search permission on the final existing directory merely to recognize that it already exists. Normal action invocations retain the actual `mkdir -p` probe and `SUDO`/`SUDOBASH` selection. Non-writing inspection does not promise to predict quota, read-only mount, or concurrent filesystem failures; actual action results remain authoritative. The book must not equate a 0 result for an existing directory with permission to install into it.
- show.genmk succeeds without creating files when MODULESGEN.mk is absent and displays current effective configuration. With a present cache, it displays that file unchanged. conf show targets retain their existing file/error behavior; fixtures for their successful paths must contain the actual files they read.
- A bare invocation with the unchanged shipped default is a query, and the explicit `default` alias remains a query because it depends only on `vars`. An overridden `.DEFAULT_GOAL` is classified by its actual target: a query override takes the query path and an action/unknown override takes the normal action path. Mixed query/action invocations retain action behavior. Action invocations regenerate the persistent cache under the M10 conditions and preserve it when unchanged.
- T1-T6 pass through the actual shipped Makefiles and relevant real build/install paths, and the documentation agrees with the code.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 assigns this independent defect group to M12.
- D27 (Decision Date: 2026-09-29) selects fixing both confirmed side effects while preserving query values and normal build behavior. It authorizes drafting this plan; plan acceptance and implementation authorization remain separate.
- M10 is Complete and its cache invalidation is a regression constraint, not unfinished prerequisite work.
- The query classification must be available before `CONFIG_SRC` and `CONFIG_MODS` are evaluated. Query-derived module values must be available before the existing module validation and dynamic target generation run.
- Accepted review corrections (2026-09-29): classify the actual effective default goal and preserve its overrides; include the default alias and declared show targets; preserve legacy SUDO_INFO values and distinguish final-directory mode 000 from an unsearchable parent path.
- show.genmk output decision (Decision Date: 2026-09-29): when MODULESGEN.mk is absent, display the current derived module configuration on stdout without creating a file. When the cache exists, retain its existing file-display meaning, including stale contents; variable queries independently use current effective values. Preserve display of other existing configure/*.mk files.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-29, owner approval after four plan reviews; tutorial paragraph extension accepted on 2026-09-29
Implementation Authorization: 2026-09-29, owner instruction "Approve and implement"; tutorial paragraph extension accepted and authorized on 2026-09-29
Superseded Plan Artifacts: initial M12 inventory outline in this canonical detail, 2026-09-29

Planning base: `5a130908464f2a4a90108223fcf4a087d70d61f8`. The two defects are reproduced above. The following design is accepted and implementation is authorized.

1. Move the current `.DEFAULT_GOAL := vars` declaration from `configure/RULES_SRC` to `Makefile` before the CONFIG include, retaining ordinary Make assignment precedence and command-line overrides. In `configure/CONFIG`, establish one classification before including the side-effecting CONFIG files. When MAKECMDGOALS is empty, classify the effective `.DEFAULT_GOAL` instead of substituting vars unconditionally; explicit goals take precedence over the default. Include the explicit `default` alias. Inventory the declared query targets and their prerequisite chains, including `show.genmk`, `conf.show`, module-show aggregates, custom-module show targets, and auto-module show targets. Derive known dynamic names from effective module declarations without generating the cache. Recognize only actual query targets; unknown and mixed query/action invocations retain the action path. T1 and T4 cover bare make, make default, query/action `.DEFAULT_GOAL` overrides, explicit goals overriding the default selection, multiple queries, and unknown/mixed goals.
2. In `configure/CONFIG_SRC`, preserve the existing probe meaning on the query path without creating directories. First determine whether the path resolves to an existing directory through searchable parent components; that existing directory is success even with mode 000. Do not use the final directory write or search bit as a success requirement. Reject an existing non-directory and distinguish it from failure to resolve a path through an unsearchable parent. For an absent path, inspect traversal and creation permissions at the nearest existing ancestor under the executing user identity, including symlink resolution. Preserve the normal action probe and `SUDO`/`SUDOBASH` selection. T3 compares actual baseline values and action probe results in matched filesystem fixtures, including separate fixtures for a mode-000 final existing directory and a mode-000 parent that prevents reaching the final path; document the limits of predicting actual creation without writing.
3. In `configure/CONFIG_MODS`, derive the query-path module variables in memory from the effective configuration instead of including the persistent generated file. Share the derivation with the persistent generator so repository URLs, source paths, install paths, sequencing, variable flavor/origin, and special mappings cannot drift between paths. Apply the existing repository overrides and module validation in their current order. In `configure/RULES_MODS`, make show.genmk render the same effective generated configuration to stdout when MODULESGEN.mk is absent, retaining its current display format and other existing configure/*.mk output. If the cache exists, display its actual contents without regenerating it, even when stale. T2 compares real outputs and origins and separately checks current variable values versus displayed persistent file contents.
4. Keep the persistent cache include/remake path for action invocations, including M10's effective-pin comparison, tracked prerequisites, restart behavior, and unchanged-cache preservation. Do not weaken the module-only or file-origin filters to support the query path. T4 covers all six local/parent override transitions and real mixed-goal behavior.
5. Update `docs/src/concepts/module-set.md`, `docs/src/procedures/choose-install-location.md`, `docs/src/reference/configuration-variables.md`, and the query entries in `docs/src/reference/make-targets.md`. Inspect the existing cache-regeneration descriptions in `docs/src/procedures/add-or-bump-module.md` and `docs/src/procedures/uninstall-and-clean.md` and adjust affected statements to distinguish queries from actions. Also correct the directory-creation paragraph in `docs/src/tutorial/first-environment.md` under the accepted 2026-09-29 scope extension. Retain the shipped command names. T6 covers the source/code comparison and rendered passages.
6. Run T1-T4 locally against the exact candidate Makefiles and preserve baseline/candidate revisions and observations. After separately authorized publication of the shared CONFIG changes, read all six actual OS workflow logs for T5 and the documentation build/deployment for T6. Record results without substituting stubs for generation, configuration, compilation, or installation.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Query side effects | Inventory the actual declared query targets and prerequisite chains; run all Scope query targets, bare make with the unchanged default, make default, and a query `.DEFAULT_GOAL=print-SRC_VER_ASYN` override in independent real clones with absent, current, and stale cache states. Supply real readable fixtures for ls/tree/cat and all conf show prerequisites. Include mixed query-only lists and -n query invocations. Compare file sets, bytes, and mtime in the checkout and isolated install root | Baseline and exact candidate clones; real query tools and source/configuration fixtures | Baseline reproduces the two defects. Candidate queries make no writes and preserve valid query output; file-display errors retain their documented behavior and are checked separately. Git status alone is insufficient because the cache is ignored |
| T2 | Query values | Compare generated module triples, origins, effective module lists, special mappings, and variable outputs against real normal generation; exercise both RELEASE.local hook transitions and command-line overrides. For show.genmk, compare absent-cache stdout with real normal generation and existing-cache output with the actual files, including stale caches and other generated files | Independent real baseline/action and candidate/query clones with matching settings | Variable queries return current values with matching origins and no cache writes. Absent-cache show.genmk succeeds with current generated settings on stdout; present-cache display matches actual contents, including stale settings. Normalize only isolated roots and incidental generation timestamps for baseline/candidate comparisons |
| T3 | Installation permissions | Execute queries as a real unprivileged identity for writable and non-writable existing directories, a mode-000 final existing directory with searchable parents, a distinct mode-000 parent blocking access to the final path, absent nested writable paths, protected ancestors, existing non-directory components, and symlink paths. Compare SUDO_INFO, SUDO, and SUDOBASH with real shipped baseline probes and matched action clones | Local isolated directories and a container where needed; no production paths; real filesystem permissions | Existing directories resolvable through their parents yield 0 even with final mode 000; unsearchable parents, non-directory components, and protected absent paths fail. Query inspection makes no writes, and values match the legacy probe for these cases. Actual action selection remains unchanged; no claim predicts quota, mount, race, or install success |
| T4 | Action compatibility | Run real shipped action targets and both query/action goal orders in isolated source trees. Verify bare make with the unchanged default and make default take the query path under T1. Run a real action `.DEFAULT_GOAL=conf.base.site` override in prepared pinned base sources and a query override, including explicit query goals with an action default and explicit action goals with a query default; use -n only as an additional classification check, not as action execution evidence. Exercise all six local/parent override transitions and tracked configuration changes; inspect persistent cache bytes and mtime for changed and unchanged actions, and inspect the classification of unknown goals | Exact candidate checkout and real pinned source trees; isolated install roots | Actions preserve current module values, command-line precedence, module-only/file-origin filters, and special mappings, and settle after regeneration. Unchanged actions preserve the cache; mixed and unknown goals cannot select the query-only path |
| T5 | OS integration | After separately authorized publication, read real configuration, strict audit, compilation, installation, check.env, and check.deps steps for all six OS workflows at the candidate commit; inspect Linter Run too | GitHub Actions on master: Debian 12/13, Rocky 8/10, Ubuntu 24.04/26.04 | All six workflows run for shared CONFIG changes and pass their real shipped paths; no historical run is counted for the candidate |
| T6 | Documentation | Compare every changed book statement to the executed query/action behavior, build with the repository mdBook image, inspect changed rendered passages, and read the corrected documentation build/deployment after authorized publication | Exact candidate source and rendered book; actual Deploy Docs workflow | Query behavior, permission assessment, cache regeneration, and unchanged command names agree with the code; docs/src stays unchanged after build and deployment succeeds |

T1-T4 operate on the real shipped Makefiles. No internal generator, permission probe, configuration, or build function is mocked. Before/after snapshots include ignored generated files and paths outside the checkout used as isolated install roots. A failing target is not evidence that the query succeeded without writes. Record every actual goal, exit status, source revision, filesystem comparison, and observation time. Filesystem fixtures set up outer-boundary conditions; they do not reproduce the implementation under test.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-29T19:42:49Z; installed-tree checks 19:45:14Z | Debian 13, GNU Make, real configured source fixtures and isolated install roots | Pass (local) | 330 successful query invocations cover 55 goal selections in absent/current/stale cache states, normally and with -n. Four additional exist/exist.modules executions inspect actual installed base/module files. Full file-set, byte, and mtime snapshots remain unchanged. Missing conf input and unreadable other generated input fail without creating the cache or install root. Real baseline print and -n print reproduce both writes |
| T2 | 2026-09-29T19:42:25Z | Independent baseline/action and candidate/query clones | Pass (local) | All 32 generated module triples, origin and flavor reports, derived lists, repository overrides, seq/recsync mappings, and command-line precedence match actual baseline generation. Both RELEASE.local hooks cover creation, edit, and removal. Absent-cache show.genmk matches real normal generation, including another generated file; present/stale output matches actual file contents |
| T3 | 2026-09-29T19:42:22Z | Real uid 1000, isolated permission and symlink fixtures | Pass (local) | 33 actual invocations compare baseline, candidate query, and candidate action for 11 cases. SUDO_INFO, SUDO, and SUDOBASH match. Final mode-000 directories yield 0; blocked parents and non-directory components yield 1. Query fixtures and absent caches remain unchanged |
| T4 | 2026-09-29T19:42:25Z; base actions 19:45:14Z | Candidate Makefiles and real pinned EPICS base R7.0.10 source | Pass (local) | Six override transitions regenerate the action cache and unchanged actions preserve bytes/mtime. Both tracked prerequisites invalidate it. Both mixed-goal orders, explicit-goal precedence, and actual conf.base.site default overrides run. Unknown names and empty pattern stems use the action path. Real conf.base/build.base/install.base succeed for base commit bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77; installed CONFIG, libCom.so, and caget exist |
| T5 | 2026-09-29T22:31:36.342846+00:00 | GitHub Actions on master at c1de48c21aa6ecc2e9a1be224833dcbee71b820f | Pass | All six OS workflows and Linter succeed. Each OS installation and environment-check step succeeds; actual logs contain reports for all 32 modules and execution of check.env and check.deps. Workflow runs are listed below; no prior revision is counted |
| T6 | 2026-09-29T19:55:10.922433+00:00; remote 2026-09-29T22:31:36.342846+00:00 | Exact seven-page candidate book, actual mdBook image, rendered HTML, and Deploy Docs at c1de48c21aa6ecc2e9a1be224833dcbee71b820f | Pass | The book builds with mdBook image sha256:2b53e59ebf0edf2913e0636ff2e31351f0f0c4c7593fb51d1f22b4b629173015, with source mounted read-only. All seven changed rendered passages match executed query/action behavior. The tutorial query and -n query run on the actual candidate without filesystem changes. Full docs/src byte and mtime snapshots remain unchanged after the book build. Remote Build the book, Guard against build side effects, and Deploy to GitHub Pages steps succeed in run 36633239757 |

Local evidence: `work/m12-implementation-20260929/`. The query, value/action, and permission drivers recorded 336, 79, and 33 actual commands respectively, including fixture preparation and expected failures. The configuration manifest SHA256 is `7b778679685881d3b81d9db68e16b252f4074a440ad9d139062eed8d49a6a5ec`; it identifies the tested candidate files over planning base `5a130908464f2a4a90108223fcf4a087d70d61f8`. Test fixtures copy actual upstream configuration trees after the shipped conf target runs; they do not reconstruct internal Make logic. The installed-tree query fixture includes the freshly built base and actual asyn installation files; copying the latter is not counted as a candidate module build.

Final query/value/action reruns on 2026-09-29 at 20:08:44Z and 20:08:19Z pass through the corrected Makefiles; evidence is in `work/m12-implementation-20260929/queries-commit-review/` and `values-commit-review/`. The final configuration manifest `candidate-commit-review-sha256.json` has SHA256 `916438eecedf9a8e0fb88ac6e6781d3fda0185fcdc48a77a171e2037d9071839`. Only the absent-cache show.genmk recipe differs from the earlier configuration manifest. Shell glob expansion preserves spaces, shell metacharacters, and newlines in other generated-file names. Three real cases (no other generated files, space-containing names before/after MODULESGEN.mk, and special-character names) match actual cache display order and contents, with unchanged file sets, bytes, and mtime for normal and -n queries. Evidence: `work/m12-show-fixed-0pzq_j1m/`.

Remote evidence observed at 2026-09-29T22:31:36.342846+00:00 with `gh run list --repo jeonghanlee/EPICS-env --commit c1de48c21aa6ecc2e9a1be224833dcbee71b820f`, individual `gh run view <run_id> --json jobs`, and OS `gh run view <run_id> --log`. Every listed run is completed with conclusion success at the implementation commit.

| Workflow | Run | Run Updated At | Result |
| --- | --- | --- | --- |
| Debian 12 | [36633239646](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239646) | 2026-09-29T21:45:44Z | Pass |
| Debian 13 | [36633239724](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239724) | 2026-09-29T21:43:36Z | Pass |
| Rocky 8 | [36633239666](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239666) | 2026-09-29T21:43:30Z | Pass |
| Rocky 10 | [36633239623](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239623) | 2026-09-29T21:47:56Z | Pass |
| Ubuntu 24.04 | [36633239658](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239658) | 2026-09-29T21:42:29Z | Pass |
| Ubuntu 26.04 | [36633239619](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239619) | 2026-09-29T21:46:24Z | Pass |
| Linter Run | [36633239685](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239685) | 2026-09-29T21:28:02Z | Pass |
| Deploy Docs | [36633239757](https://github.com/jeonghanlee/EPICS-env/actions/runs/36633239757) | 2026-09-29T21:26:53Z | Pass |

##### Closure Evidence

- Implementation commit `c1de48c21aa6ecc2e9a1be224833dcbee71b820f` is published on origin/master on 2026-09-29.
- T1-T6 pass: local query/value/permission/action checks, all six candidate OS runs, Linter, the book build guard, and GitHub Pages deployment succeed.
- Verification record commit `c351ac9243d5e5424baa1a61f0f1455e57887f` is published on `origin/master`.
- GitHub issue #85 is closed as completed at 2026-09-30T00:07:25Z; its body and completion comment match the published implementation and verification results.
- The directory-creation paragraph in docs/src/tutorial/first-environment.md is included by owner acceptance and implementation authorization on 2026-09-29. The correction, actual query and -n execution, book build, rendered HTML, and source-preservation checks pass locally. Evidence: work/m12-implementation-20260929/tutorial-correction/.

##### GitHub Projection

Title: Remove side effects from read-only make targets
Labels: bug
GitHub Milestone: Backlog
Observed State: closed, completed (2026-09-30T00:07:25Z, `gh issue view 85 --repo jeonghanlee/EPICS-env`)
Observed Closed At: 2026-09-30T00:07:25Z
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-30T00:07:25Z (remote updatedAt 2026-09-30T00:07:25Z)
Projection Follow-up: none; the issue body and completion comment match the published implementation and verification results, and #85 is closed as completed.

#### M13 - Tools Script Defects

Origin: 84ee626 / M13
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #86, https://github.com/jeonghanlee/EPICS-env/issues/86
Status: Complete

##### Summary

The `tools/` scripts mishandle arguments, missing programs, and exit codes, and the `check.deps` gate scans modules twice. The M6 code inventory found these defects.

##### Scope

- `tools/prep-vendors.bash` references unset `EPICS_MODS_PATH` and `SRC_VER` values. M13 removes the `EPICS_MODS_PATH` check and duplicate cleanup call because `make distclean` already cleans module sources (D30), removes the unused `SRC_VER` argument from `all` (D31), removes the site-specific NTP host `tic.lbl.gov` in favor of the `time.google.com` default (D29), and applies D28 to existing local configuration files. Its `help` command currently exits 1; M13 makes it exit 0 (D35). Its Red Hat-family branch uses `conf.rocky8` on Rocky 10 even though D25 directs the Rocky 10 consumer to `conf.rocky10` while preserving `conf.rocky8` compatibility.
- `tools/pvs_gets.bash` prints an invalid `printf "%\n"` format and exits 0 when `caget` or `pvget` is missing in single mode; its watch mode continues after the helper exits inside command substitution. D32 requires a valid diagnostic and prompt status 2 in both modes.
- `tools/update-release.bash` exits 1 for `help` and usage errors, the same code `check` uses for an incomplete survey. M13 changes `help` to status 0 and usage errors to status 2 while preserving `check` statuses (D33).
- `tools/gen_dep_graph.bash` loops forever when `-o` or `-f` has no argument and exits 1 for `-h`. M13 makes help successful and missing option arguments prompt usage errors (D34).
- `tools/pv_snapshot.bash` exits 1 without a message when `-l`, `-o`, `-w`, or `-t` is the last argument, because `shift 2` fails, while its usage text documents exit 2 for usage errors (`tools/pv_snapshot.bash:84-86,152`). M13 reports these missing values as usage errors with status 2 (D36).
- Verification gate: `tools/check_deps.bash:98` globs `modules/*/bin/linux-x86_64`, which matches versioned module directories and unversioned links. On a real EPICS-env 1.3.0 Debian 13 installed tree, the shipped script reported 150 executable paths for 88 canonical files (62 duplicates, each reported twice) and exited 0. M13 deduplicates canonical paths so each executable is analyzed once (D38); T4 verifies complete coverage against a populated tree built from the current checkout. `check.deps` must also fail with a diagnostic and corrective guidance when `INSTALL_LOCATION_EPICS` is empty or the named tree is missing instead of passing after scanning zero files (D37).
- Documentation: update `docs/src/reference/tools-and-scripts.md` and the verification-gate pages to state the selected exit codes, missing-tree behavior, `prep-vendors.bash` file handling, and OS-specific vendor target.

Out of scope: the defects of M9, M10, M11, M12, M14, M15, M16, M17, M18, M19.

##### Completion Criteria

- Each code Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.
- `prep-vendors.bash` uses `conf.rocky10` on Rocky 10 and retains the `conf.rocky8` compatibility behavior; existing local configuration files follow D28.
- `prep-vendors.bash` no longer sets the site-specific NTP host and the generated configuration uses `configure/CONFIG_BASE`'s `time.google.com` default.
- `prep-vendors.bash` no longer tests unset `EPICS_MODS_PATH` or repeats module cleanup already performed by `make distclean`.
- `prep-vendors.bash all` has no unused version argument, and its usage and completion output do not show an empty version.
- `prep-vendors.bash help` exits 0.
- `pvs_gets.bash` reports a missing `caget` or `pvget` with a valid diagnostic and exits promptly with status 2 in single and watch modes.
- `update-release.bash help` exits 0, usage errors exit 2, and `check` retains its documented survey statuses.
- `gen_dep_graph.bash -h` exits 0; `-f` and `-o` without arguments exit promptly with a diagnostic and status 2.
- `pv_snapshot.bash` reports a missing value for `-l`, `-o`, `-w`, or `-t` and exits 2.
- `check.deps` analyzes each canonical executable once on a populated installed tree and fails on empty and missing installation paths with a diagnostic identifying the bad input and guidance to set `INSTALL_LOCATION_EPICS` or pass a valid `<installed_tree>`.
- The tools reference and verification-gate documentation agree with the resulting behavior, and the mdBook build succeeds.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.
- D25 selects `conf.rocky10` for Rocky 10 and preserves `conf.rocky8` compatibility in both vendor repositories.
- D28 defines backup and confirmation behavior at every local configuration replacement site. Backups use `<file>.bak.<UTC date and time>` with a numeric suffix on collision; earlier backups remain unchanged. Backup failure, confirmation refusal, or EOF leaves the original unchanged and aborts the invocation with status 1 before subsequent build steps.
- D29 removes the site-specific NTP assignment and retains the repository default, `EPICS_TS_NTP_INET=time.google.com`.
- D30 removes the `EPICS_MODS_PATH` condition and duplicate module cleanup call.
- D31 removes the unused `SRC_VER` argument from `all` and updates its usage and completion message.
- D32 makes missing `caget` and `pvget` errors explicit, prompt, and status 2 in single and watch modes.
- D33 separates `update-release.bash` help and usage statuses from its survey results.
- D34 defines successful help and prompt usage errors for `gen_dep_graph.bash`.
- D35 makes `prep-vendors.bash help` exit successfully.
- D36 makes missing `pv_snapshot.bash` option values follow the documented usage-error status 2.
- D37 requires a useful error and recovery instruction for empty or missing installed-tree paths.
- D38 removes duplicate executable scans through versioned and unversioned paths.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-30: full Implementation Plan and Test Plan, including the incorporated full-plan review findings
Implementation Authorization: 2026-09-30: full Implementation Plan and Test Plan
Superseded Plan Artifacts: none

The full Implementation Plan and Test Plan are accepted and authorized on 2026-09-30, including the incorporated full-plan review findings and the selected D28/D32 behavior. The existing step 4/T4 evidence remains separate from the required final whole-candidate verification.

1. Re-verify each Scope item against the current code and confirm its Fix direction against D25 and D28-D38; record any Keep in `docs/CLOSED_DOORS.md`. Before code changes, update the tools reference with the selected interfaces, diagnostic conditions, and exact statuses from the Test Plan. D28 uses status 1 for backup failure, refusal, and EOF; D32 uses status 2 for a missing client. Resolve any newly discovered contract choice before implementation rather than during step 3.
2. Update `tools/prep-vendors.bash` for D25's Rocky 10 target, D28's existing-file behavior, D29's NTP default, D30's removal of the `EPICS_MODS_PATH` condition and duplicate cleanup call, D31's removal of the unused `SRC_VER` argument, and D35's successful help status. Apply one configuration replacement procedure to `_prep_env`, `_prep_vendor` for both vendors, `epics_env`, and `epics_build`: ask before backup in interactive mode; preserve every earlier backup; finish and verify the backup before replacement; propagate backup failure, refusal, or EOF to the top-level invocation so no subsequent build step runs. Verify through T1 and T2.
3. Correct the argument, help, missing-program, and exit-status handling in `tools/pvs_gets.bash`, `tools/update-release.bash`, `tools/gen_dep_graph.bash`, and `tools/pv_snapshot.bash` under D32-D36. Validate the selected client in the main execution path before single or watch execution, so a helper exit inside command substitution cannot leave the parent loop running. Preserve `update-release.bash check` statuses 0, 1, and 2. Verify negative and normal argument paths through T1 and all survey outcomes through T3; update the tools reference to match.
4. Correct `tools/check_deps.bash` to deduplicate canonical executable paths under D38 and reject an empty or missing installed tree with D37's diagnostic and corrective guidance; update the verification-gate pages to match.
5. Prepare the verification environments and installed tree in the order below, then run T1-T5 against the final candidate. Record argv, environment, source and vendor commits, stdout, stderr, status, and observation time for each check. Retain the existing step 4/T4 evidence and distinguish it from the final whole-candidate verification.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | CLI contracts | Run the shipped scripts for every negative and positive case listed below; record stdout, stderr, and status | Disposable checkout; clients and IOC from the final candidate's T4 installed tree for positive snapshot cases; client-free PATH for missing-client cases; `timeout` for bounded negative cases | Exact statuses and diagnostics match the T1 cases; graph generation and snapshot capture/compare still work with valid option values |
| T2 | `prep-vendors.bash` configuration and OS selection | Run shipped `init`, `prep-vendors`, `epics-env`, `epics-build vars`, and `all`; exercise the configuration replacement sites and fixture protocol below | Separate temporary checkout and HOME per case; Rocky Linux 10 and 8.10 containers prepared from the images and package steps below; actual pinned vendor Git mirrors; real make targets | D28 preserves originals and prior backups on failure or refusal, propagates status 1, and stops subsequent build steps; successful replacement preserves an exact backup. Rocky 10 uses `conf.rocky10`, Rocky 8.10 uses `conf.rocky8`; D29-D31 hold through the real build paths |
| T3 | `update-release.bash` survey statuses | Run shipped `check` against the real `configure/RELEASE` for all three transport-response cases listed below; control only outbound `curl` and `git ls-remote` boundaries | Disposable checkout; actual script and RELEASE; deterministic HTTP and Git transport responses | Complete survey returns 0, incomplete survey returns 1, and reachable but indeterminate survey returns 2; the RELEASE bytes and mtime are unchanged in every case |
| T4 | `check.deps` installed-tree scan | Build a complete installed tree with the shipped make targets under a temporary installation root. Run the real `check_deps.bash --verbose`, canonicalize its reported executable paths, and compare that set with the unique executable paths in the actual tree. For the empty-variable case, set `GNUMAKEFLAGS='INSTALL_LOCATION_EPICS='`, verify `make print-INSTALL_LOCATION_EPICS` is empty, then run the real script. Also run it with an explicit missing tree path | Disposable repository checkout; complete installed tree built from that checkout; `readelf` on `PATH` | Every canonical executable appears once and the reported set matches the real tree; both the verified empty location and missing tree fail with a diagnostic that identifies the invalid input and tells the user to set `INSTALL_LOCATION_EPICS` or pass a valid `<installed_tree>`, instead of reporting zero files as a clean scan |
| T5 | Documentation | Build the book and inspect the rendered tools and verification-gate pages against the updated scripts and observed output | Repository checkout; repository mdBook build environment | The book builds without changing `docs/src`; documented interfaces, exit statuses, file handling, OS targets, and missing-tree behavior match the verified code |

###### Verification Setup And Execution Order

- Prepare T2 containers from `rockylinux/rockylinux:10` and `rockylinux/rockylinux:8`, matching `.github/workflows/rocky10.yml` and `.github/workflows/rocky8.yml`. Record the resolved image digest and `/etc/os-release`; require Rocky Linux 10 and 8.10 respectively before running OS-selection cases.
- Follow only the package preparation portion of each workflow's `Install required packages` step. Rocky 10 installs `git`, `make`, `sudo`, `bash`, `wget`, and `unzip`, then clones `pkg_automation` and runs `pkg_automation.bash -y`. Rocky 8 first runs `dnf update -y`, installs those packages plus `tree`, runs the same package automation, then installs `python3-pip` and `libusbx-devel` and uses `pip3` to install `numpy` and `nose`. Record the consumed `pkg_automation` commit and package preparation status; stop on failure. Do not run the workflow's vendor configuration or build commands as test setup: T2 must exercise the shipped `prep-vendors.bash` with the pinned mirrors below.
- Before testing, verify `python3`, Git, and make are available for the real configuration and build paths. Also prepare real Graphviz `dot` for T1, `timeout` for bounded cases, `script(1)` for T2 terminal cases, and `bc`, `clear`, and `sleep` for the watch path. The missing-client PATH must retain the scripts' required system utilities while excluding both `caget` and `pvget`.
- Prepare T4's complete installed tree from the final candidate in a disposable checkout with a temporary installation root before T1's positive snapshot cases. Build the required vendor libraries at the specified T2 pins and use the shipped EPICS-env targets `init`, `patch`, `conf`, `check.module-deps`, `build`, `install`, and `symlinks`, followed by `check.env`. Resolve `<installed_tree>` with the real `make print-INSTALL_LOCATION_EPICS` in that checkout and verify that it is inside the selected temporary installation root. Record the source and vendor commits, resolved installation path, and EPICS base version.
- Require executable `softIoc`, `caget`, and `caput` under `<installed_tree>/base/bin/linux-x86_64` and the installed `<installed_tree>/base/dbd/softIoc.dbd`. Use those explicit paths for IOC setup and client operations; put that bin directory first on PATH for the shipped snapshot capture. Do not substitute an unrelated host installation. A missing binary, DBD file, or failed tree build stops the positive cases with preparation diagnostics.
- T labels identify checks rather than chronological order. T1's negative cases and T3 can run before the tree is built; T1's positive snapshot cases require the prepared T4 tree. T2 keeps its separate checkouts, HOME directories, and installation roots, and T4's scan and T5's documentation checks still require their own recorded results.

###### T1 Execution Cases

- Run `prep-vendors.bash help`, `update-release.bash help`, and `gen_dep_graph.bash -h`; each returns 0. Run an unknown `prep-vendors.bash` command and `epics-build` without a target; each returns 1 with usage. Run `update-release.bash` without a command and with an unknown command; each returns 2 with usage. T3 owns the separate survey statuses.
- Run `gen_dep_graph.bash -f` and `-o` as the last argument under a two-second timeout; each returns 2 before the timeout with a diagnostic identifying the option. Also cover their `--file` and `--output` aliases. Generate a graph with valid `-f` and `-o` using the shipped `configure/CONFIG_MODS_DEPS` and real `dot`; require status 0 and a nonempty SVG containing the expected module names.
- Run `pv_snapshot.bash capture` with each of `-l`, `-o`, and `-w` last, and `compare -t` last; each returns 2 with a diagnostic identifying the missing value.
- For positive snapshot cases, start the designated tree's real `softIoc` as a controlled child process. Pass `-D <installed_tree>/base/dbd/softIoc.dbd` first, then `-S`, `-m P=<unique-prefix>`, and `-d` with the final candidate's shipped `examples/commonIocsh/fixtureDb/caPutLog.db`. Record the child PID and stdout/stderr log paths. Use a unique prefix ending in `:` and loopback-only CA discovery, with a separate test server port recorded in the environment, so the selected `<unique-prefix>Value` PV belongs to this IOC.
- Wait for readiness by polling that PV with the designated tree's real `caget -w 1`, bounded by a ten-second startup deadline and a check that the child remains running. Begin capture only after a successful read. If the child exits or the deadline expires, fail the case with the IOC and client diagnostics; do not treat disconnected snapshots as successful preparation.
- Capture before and after an unchanged value with valid `-l`, `-o`, and `-w`, then compare the captured files with valid `-t`; require capture status 0 with zero disconnected PVs and compare status 0 with `SAME`. Change the value with the designated tree's real `caput`, require status 0, capture again, and compare with tolerance 0; require status 1 with `DIFF`. Use only files emitted by the actual capture path as compare fixtures.
- On success, failure, or interruption, terminate and wait for only the IOC child started by this case. Bound the wait and escalate termination only for that recorded child if needed. Preserve IOC logs, readiness reads, snapshots, and command results as evidence; do not terminate unrelated IOCs or delete their files.
- Run `pvs_gets.bash -l /dev/null` with and without `-7`, each in single mode and with `-w 1`. First verify `caget` and `pvget` are unavailable on the selected PATH and that the watch utilities remain available. All four invocations must return 2 within two seconds, print a valid missing-client diagnostic naming the selected program, and produce no invalid printf-format error. Timeout status 124 is a failure. Do not replace the helper or loop with a test function.

###### T2 Fixture And File Handling

- Use real vendor commits already verified for D25: `uldaq-env` at `988b1523a759855b5e98c23e3cde050ab8d1b26e` and `open62541-env` at `00e5e60eb24a64d94578b608538d4288c90a0dbf`. Create isolated bare mirrors containing those commits, with each mirror's default branch fixed to its specified commit. Use a temporary Git configuration to map only the two vendor SSH and HTTPS clone URLs to those mirrors through Git URL rewriting. Run the real `git clone` via the shipped `init` and `all`, and verify both resulting HEAD values after cloning. This controls the outer Git transport only; keep all script functions and make recipes intact. Preseeding the working directory is insufficient because `init` clears it.
- Exercise EPICS-env `configure/CONFIG_SITE.local` through `init`, each vendor's `configure/CONFIG_SITE.local` through `prep-vendors`, and EPICS-env `configure/RELEASE.local` through both `epics-env` and `epics-build vars`. Use valid existing configurations under the isolated installation root, record their bytes before each case, and run `all` to cover the composed path. Keep each case separate so `init` does not erase another case's prepared vendor files.
- For non-interactive replacement and interactive confirmation, require a byte-identical backup before replacement. Use `<file>.bak.<YYYYMMDDTHHMMSSZ>` in the same directory, adding `.1`, `.2`, and later suffixes on collision. Preserve earlier backup bytes; control only the outer clock to repeat the timestamp and verify collision handling. A new configuration file needs no backup or confirmation.
- Run interactive cases through `script(1)` so the shipped script reads stdin from a terminal; wait for the actual prompt before sending confirmation or refusal through the input pipe. For EOF, send the terminal's EOF character at the empty prompt; closing the outer pipe alone is not proof that the terminal read received EOF. Bound each prompt case with a timeout. Refusal and EOF return 1, preserve the original, create no backup, and run no subsequent build step. Verify the absence of subsequent build output and changes to the real build artifacts. Induce backup creation failure with real filesystem permissions as an unprivileged user; require status 1, a diagnostic, unchanged original and previous backups, and no subsequent build step.
- In both OS environments, record the real make target and generated configuration: Rocky 10 calls `conf.rocky10`, Rocky 8.10 calls `conf.rocky8`. Verify both RELEASE-writing paths omit the site-specific NTP assignment and that effective `EPICS_TS_NTP_INET` is `time.google.com`. The environment build uses `make distclean` without the removed condition or second module cleanup. Run `all` without a version argument; require status 0 and no empty version in its completion output, with generated files only within the disposable checkout, HOME, or installation root.

###### T3 Survey Cases

Use the real RELEASE entries and module URL resolution in every case. Supply deterministic responses only at the outer `curl` and `git ls-remote` transport boundaries; never replace parsing, version selection, or survey functions.

- Complete: every module lookup resolves and tag-pinned modules have a valid release tag. Require status 0 and a complete survey summary; available updates do not change that status.
- Incomplete: make a transport unreachable while other lookups remain valid. Require status 1 and a diagnostic that the survey is incomplete and not authoritative.
- Indeterminate: make every transport reachable, but return no release tag for one tag-pinned module while all other entries resolve. Require status 2 and an indeterminate summary, without an incomplete-survey diagnostic.
- For every case, compare RELEASE bytes and mtime before and after. T1 independently verifies help status 0 and usage status 2, so those cases cannot substitute for these survey checks.

##### Verification Results

The final candidate uses EPICS-env `64e164fc64642f0f718df5f55577c9cee7a343f0` plus the local implementation. `work/m13-implementation-20260930/candidate-environment.json` records SHA-256 values for all six scripts, `configure/RULES_DEPS_CHECK`, and the shipped IOC database. Those bytes match the CLI checkout and both Rocky build checkouts. The same file records the 36 consumed repository commits per Rocky environment and EPICS base version `7.0.10`.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-30T10:33:45.039832+00:00 through 2026-09-30T11:19:04.943799+00:00 | Disposable checkout for CLI cases; final candidate's installed clients and softIoc on Rocky 10.2 for positive PV cases | Pass. Help, usage, and every required missing-value case return the selected statuses. Both missing clients fail promptly in single and watch modes. Real Graphviz generation succeeds. Three connected captures succeed; the actual unchanged and changed snapshots compare as SAME/status 0 and DIFF/status 1. Available caget succeeds in single mode and supplies two value reads in watch mode before controlled termination. | `work/m13-implementation-20260930/cli-survey-results.json` and `containers/rocky10-run3/installed-verification-run3/results.json` beneath the same evidence root; command output, graph, snapshots, IOC log, readiness reads, and watch log are retained. |
| T2 | 2026-09-30T10:49:17.799590+00:00 through 2026-09-30T11:09:53.131032+00:00 | Rocky Linux 8.10 and 10.2; separate checkout, HOME, and installation root for each configuration case; real pinned vendor Git mirrors | Pass: 47 checks on each OS. All five replacement sites preserve originals and earlier backups on refusal, EOF, and actual permission-induced backup failure, return 1, and stop before later builds. Real all and confirmed vendor builds succeed, including exact backups, collision suffixes, both vendor pins, conf.rocky8/conf.rocky10 selection, default time.google.com, and removal of duplicate cleanup and unused version output. | `work/m13-implementation-20260930/containers/rocky8-run5/results.json` and `containers/rocky10-run3/results.json`; all.log, terminal transcripts, configuration files, backups, environment.log, and setup.log are retained. `replacement-regression.json` compares actual baseline and candidate RELEASE replacement: only the candidate preserves the original backup and omits the site NTP assignment. |
| T3 | 2026-09-30T10:33:49.591306+00:00 through 2026-09-30T10:33:53.186002+00:00 | Real script and configure/RELEASE in the disposable checkout; only outward HTTP and Git transport responses controlled | Pass. Complete, incomplete, and reachable-but-indeterminate surveys return 0, 1, and 2 with the selected summaries. RELEASE bytes and mtime remain unchanged in all three cases. | `work/m13-implementation-20260930/cli-survey-results.json`, transport fixtures, and the survey-complete, survey-incomplete, and survey-indeterminate stdout/stderr files. |
| T4 | 2026-09-30T11:19:04.968362+00:00 through 2026-09-30T11:19:14.353727+00:00 | Final candidate on Rocky 10.2; complete installed tree at /case/full/install/1.4.0/rocky-10.2/7.0.10 | Pass. All 85 canonical BIN files appear exactly once and all 69 SO files match the actual scan inventory. Empty make location, empty positional input, missing tree, non-directory input, failed make lookup, and report-only invalid input exit 2 with corrective guidance. Real check.deps and audit.deps both succeed. | `work/m13-implementation-20260930/containers/rocky10-run3/installed-verification-run3/results.json`. The real clone/patch/build/install sequence is recorded in T2 all.log; installed-verification-run2 records conf, check.module-deps, build, install, symlinks, and check.env, all status 0. Run3 uses that same prepared checkout and installed tree. |
| T5 | 2026-09-30T10:58:08.683558+00:00 | Repository mdBook 0.5.4 image; read-only source mount and isolated book output | Pass. The book builds; all six rendered exit-status cells match the source reference. Rendered interfaces, configuration backup rules, OS targets, NTP default, canonical scan behavior, and input guidance match T1-T4 observations. docs/src bytes and mtime remain unchanged. | `work/m13-implementation-20260930/docs-results.json`, docs-source-before.json, and book-output/book; static-results.json records bash -n, ShellCheck's warning gate, and diff checks, all status 0. |

###### Environment And Execution Evidence

- `work/m13-implementation-20260930/images.json` records resolved image IDs and registry digests. Rocky 8's base digest is `sha256:e8a49c5403b687db05d4d67333fa45808fbe74f36e683cec7abb1f7d0f2338c6`; Rocky 10's is `sha256:827d37bc128288ccf160ee318bb3cb92d591164cb217e92f8bc61e3982ae1834`. Actual OS values are 8.10 and 10.2.
- Prepared package image IDs are `sha256:d11a335bd99a97ceec0ea5d9b32f16199babd50f24c514df7b783787cb11263e` for Rocky 8 and `sha256:bff3174e228da6d5fdfb89db0b10db775e2b8271743d6b187a1e494448a5976d` for Rocky 10. Their image histories contain the selected workflow package steps only. Both consumed `pkg_automation` commit `472ef7654e4541ba6322e301ac78bea5691e3845`; actual successful package output is preserved in `work/m11-implementation-20260929/rocky8-package-setup.log` and `rocky10-package-setup.log`. Each T2 setup.log records its successful installation of the additional test utilities.
- Vendor HEAD values match D25's pins. The full installed-tree verification uses package image `sha256:a53abde34d5aeede81d01df6fe5954be5fc62eea8846777a9f59b1038c11aff9`, preserving the tested Rocky 10 package environment. It uses the same real build tree prepared by T2, then the actual pre-build audit and final build/install targets recorded above.
- The approved caPutLog.db fixture resolves to its actual tracked location, `examples/commonIocsh/fixtureDb/caPutLog.db`; the earlier `db/` path in the plan was incorrect. The real softIoc loads that shipped file with its installed DBD, uses a unique prefix and loopback CA port, and becomes ready only after a successful actual caget. The IOC and watch child processes are terminated and waited for; their logs and statuses are retained. Failed preparation attempts remain separate from the successful final results.

###### Earlier Checker-Only Evidence

- At `2026-09-30T07:35:49.036492+00:00`, the Debian 13 VM checker-only candidate passed D37/D38. The real baseline reported 144 BIN occurrences for 85 canonical files and accepted empty/missing paths; the candidate reported 85 unique BIN paths and 69 SO paths matching that installed tree and rejected invalid inputs with guidance. `work/m13-t4-candidate-20260930/results.json` and its raw output retain that evidence. Checker SHA-256: `bd4bc57cf56264a66ceaf4a2367d50f47ff92279d9042a1e006818c650fe02f3`.
- At `2026-09-30T08:42:39.530493+00:00`, the earlier checker-only documentation build passed with unchanged source bytes and mtime. `work/m13-docs-correction-r53ezxhf/results.json` retains the commands, rendered output, and matching checker hash. This earlier result covered three checker pages; final T5 above covers the full tools change.

Implementation and all required T1-T5 verification are complete. The tested scripts, matching documentation, and verification evidence are published in `d16dd4b718397b909be9b293ec2cbd945ae4f3ce` on `origin/master`. Issue #86's body matches the implementation and satisfied completion criteria, and #86 is closed as completed.

##### Closure Evidence

- Implementation, matching documentation, and T1-T5 verification evidence are published in `d16dd4b718397b909be9b293ec2cbd945ae4f3ce`.
- Repository landing observed at `2026-09-30T16:43:30.182327+00:00`: after `git fetch`, HEAD and `origin/master` resolve to that commit, and all 11 changed file blobs match between the implementation commit and the fetched upstream. The working tree was clean at comparison.
- Issue #86 was closed as completed at `2026-09-30T16:36:56Z` after its body and completion comment were synchronized. At `2026-09-30T16:44:18.293361+00:00`, `gh api repos/jeonghanlee/EPICS-env/issues/86` confirms `state=closed`, `state_reason=completed`, and a body identical to the prepared implementation and verification record. The posted completion comment was also read back and matched.
- Completion Date: 2026-09-30. All completion criteria are satisfied; no technical or linked-issue condition remains open.

##### GitHub Projection

Title: Fix tools script argument handling and dependency checks
Labels: bug
GitHub Milestone: Backlog
Observed State: closed as completed (2026-09-30T16:44:18.293361+00:00, `gh api repos/jeonghanlee/EPICS-env/issues/86`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-30T16:44:18.293361+00:00 (remote updatedAt 2026-09-30T16:36:56Z)

Projection Follow-up: none; the issue body and completion comment match the published implementation and verification results, and #86 is closed as completed.

#### M14 - Environment Script Defects

Origin: 84ee626 / M14
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #87, https://github.com/jeonghanlee/EPICS-env/issues/87
Status: Complete

##### Summary

The environment scripts abort under `set -u`, corrupt unrelated path entries, and name an obsolete installation layout. Setup and reset must operate on the actual installed tree, preserve independently configured CA settings, and keep architecture selection separate from output control.

##### Scope

- `scripts/setEpicsEnv.bash`: guard optional arguments and unset variables; separate the fallback architecture from `disable`; remove only complete matching colon-delimited path entries; handle repeated setup and switching trees without damaging unrelated entries.
- `scripts/resetEpicsEnv.bash`: apply the same path and nounset rules; unset the variables selected by D40 even when `EPICS_BASE` is absent; correct its Shell header.
- Examined Keep: `scripts/selectEpicsEnv.bash` remains unchanged under D41 and `docs/CLOSED_DOORS.md` K9. Preserve direct sourcing of each installed `setEpicsEnv.bash` to select that tree; no selector interface or path-construction change is part of implementation.
- `configure/RULES_BASE`: install `resetEpicsEnv.bash` alongside `setEpicsEnv.bash` through the real `install.base` target.
- Matching usage and installation documentation: `docs/src/procedures/set-up-shell.md`, `docs/src/reference/tools-and-scripts.md`, `docs/src/reference/make-targets.md`, `docs/src/concepts/installed-tree.md`, `docs/src/concepts/build-pipeline.md`, `docs/src/procedures/build-and-install.md`, and `docs/src/tutorial/first-environment.md`. Link `scripts/README.md` to the separate Libera reference, `docs/libera-cross-build.md`, outside the book.

Out of scope: M9-M13 and M15-M20; Libera cross-build and generated-profile verification; changes to `build_epics.bash`, `install_apps.bash`, or `build_base_libera.bash`; Libera's target-board `/opt` library mapping; module pins or configuration rules; shell startup files in the user's home; general script style cleanup and a new test framework. Preparation may use existing shipped configuration and targets in an isolated checkout without modifying those rules.

##### Completion Criteria

1. Setup and reset complete in Bash with `set -u`, including missing arguments, unset or empty optional variables, partially populated environments, and a repeated reset. Sourced scripts return to the caller without changing its working directory, shell options, or positional arguments.
2. Path removal matches complete colon-delimited fields. Unrelated fields retain their bytes, order, duplicates, and leading, middle, or trailing empty fields. Repeated setup creates no duplicate managed entry; switching tree A to tree B removes the known managed entries of A before adding B.
3. D39 is implemented: no arguments and `disable` alone retain automatic detection; `<fallback_arch>` and `<fallback_arch> disable` use the fallback only when discovery is unavailable. `disable` never becomes `EPICS_HOST_ARCH`. Invalid usage or unavailable architecture returns a nonzero status and a diagnostic without partially replacing the managed environment. A real discovery command that fails without a supplied fallback returns status 1 and preserves the previous managed variables and both path values.
4. Reset removes known base, pvxs, pmac, and legacy extension executable entries and the base library entry, then unsets the D40 variables. Independent CA settings survive setup, switching, and reset. Missing variable components must not be assembled into invented paths for removal.
5. D41 is preserved: `selectEpicsEnv.bash` remains byte-identical to the baseline, and directly sourcing setup at either real installed-tree location selects that tree. The known legacy-selector layout mismatch is recorded as Keep K9, not reported as fixed or verified compatible with the current installation layout.
6. Actual `install.base` and aggregate `install` install byte-identical candidate setup and reset scripts at the top of the tree with mode 0644 and the existing `INSTALL_DATA -b` replacement policy.
7. Usage, reset behavior, installation listings, and file counts agree with the candidate's observed native behavior. Every required T1-T7 check passes, or an explicit owner-approved Keep changes the corresponding criterion and is recorded in `docs/CLOSED_DOORS.md` with its premise and evidence.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 assigns these defects to M14. These are scope and work-order decisions, not dependencies on later inventory milestones.
- D39 selects architecture fallback priority and separate summary control; D40 selects the managed-variable reset scope. Both decisions are dated 2026-09-30.
- D41 keeps the existing selector code unchanged. The proposed direct-tree and additional-release selector interfaces are withdrawn. Environment selection continues through direct sourcing of the chosen installed setup script; its own location remains the source of the environment paths. Keep K9 records the existing selector limitation.
- Native verification requires one real candidate installation with base, pvxs, and pmac tools and module links. These are test preparation requirements; missing preparation cannot count as a successful test.
- D42 separates Libera implementation and verification into Deferred Backlog M20 on 2026-09-30. Original M14 / T7 becomes M20 / T1; the original T3 generated-profile case becomes M20 / T2; the original T8 Libera output comparison becomes M20 / T3. The native documentation check becomes M14 / T7. Pending Libera checks remain Pending in M20 and are excluded from M14 completion. No Keep or cross-build pass is created.
- Decision Date: 2026-10-01; project only the native setup/reset scope and selector Keep to #87. Retain its original Libera target and actual-script verification requirements in M20; the issue itself remains linked to M14.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-30; the complete M14 plan incorporating all three findings from its second review; native scope separation accepted by the subsequent D42 extraction direction
Implementation Authorization: 2026-09-30; implement the accepted plan; subsequent D42 authorizes document extraction and preserves the script locations without further Libera execution
Superseded Plan Artifacts: `work/m14-implementation-20260930/before-libera-extraction.md` retains the accepted combined plan and all observations before D42

The native plan retains its acceptance and implementation authority from 2026-09-30. D42 narrows its completion scope and separates the deferred Libera requirements without changing source code. The selector decision is resolved by D41. Git and GitHub mutations require their own authorization.

1. Freeze the candidate file list, baseline commit, and required test cases before implementation. Preserve the D41 selector bytes and direct-source behavior. Keep the confirmed premise observations below separate from candidate Verification Results.
2. In `setEpicsEnv.bash` and `resetEpicsEnv.bash`, replace substring-based path removal with complete-field comparison. Guard missing values before expansion and remove a managed path only when its identifying components are available. Preserve unrelated fields and maintain the current order of pmac, pvxs, and base additions. Preserve the existing profile-loading and reset cleanup scope; actual generated-profile verification belongs to M20. Close the native path cases with T2 and T3.
3. In `setEpicsEnv.bash`, parse the D39 argument forms before changing the environment. Resolve the script location and candidate architecture before removing the previous environment. Retain the existing discovery order, including fallback when Perl is unavailable. Check the actual discovery command's status and architecture result before environment cleanup; a failed discovery without a supplied fallback returns 1 and leaves the previous environment intact. Return status 2 for invalid usage and status 1 when no architecture can be determined; successful setup returns 0. Preserve existing Libera profile loading. Close with T2 and T4.
4. In `resetEpicsEnv.bash`, make path cleanup conditional on available components but make D40 variable unsetting independent of the `EPICS_BASE` condition. Preserve unmanaged EPICS variables and correct the Shell header. In `configure/RULES_BASE`, add reset to the same `INSTALL_DATA -b` install operation as setup. Close with T2, T3, and T6.
5. Leave `selectEpicsEnv.bash` unchanged and preserve the location-derived paths of `setEpicsEnv.bash`. Document direct sourcing as the way to select among installed trees, and retain an accurate description of the existing selector's arguments and legacy path. Close with T5 and T7; do not add a compatibility link or another selector entry point.
6. Update the seven named book pages for the setup/reset interfaces, preserved direct-source selection and CA settings, installed reset script, and resulting directory listings and file counts. Extract the Libera description and verification requirements into `docs/libera-cross-build.md` and link it from `scripts/README.md`. Preserve both Libera script locations and bytes. Close with T7 and a second-person read of the changed procedures against actual outputs.
7. Run T1-T7 on the native candidate using the preparation and evidence rules below. Record each actual outcome with its candidate source identity and evidence. Request a scope decision for any unrelated defect that prevents a required path from running; do not work around it inside the path or expand the code changes silently.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | Run `bash -n` on the setup, reset, and unchanged selector scripts; run `shellcheck -s bash -S warning` as the gate and plain `shellcheck -s bash` as the full diagnostic inventory; run `git diff --check` and inspect changed paths | Candidate checkout; record Bash and ShellCheck versions | Syntax, warning/error gate, and whitespace check return 0; diagnostics are read without truncation; no source change escapes the scoped files |
| T2 | Shell lifecycle | Source the actual installed setup/reset scripts in fresh `bash --noprofile --norc` children with nounset both enabled and disabled; use the fresh, empty, partial, legacy, and repeated-reset cases below | Isolated HOME and controlled environment; real candidate installed tree | Successful calls return 0 and reach the caller's sentinel; no unbound variable; caller context survives; D40 variables are unset and independent CA values survive |
| T3 | Path lifecycle | Source A twice, switch A to B, and reset B; exercise complete managed matches and unrelated substring, whitespace, regex-character, duplicate, and empty fields in PATH and LD_LIBRARY_PATH | Two copies of the real candidate native tree; fresh child shell per case | All and only complete known managed fields are removed; expected managed prefix appears once; unrelated fields retain exact bytes and order |
| T4 | Architecture and output | Run the four D39 forms through the installed setup script; compare detection with the real installed EpicsHostArch output; control discovery availability through outer PATH/filesystem changes and exercise an actual probe failure through the outer Perl environment | Candidate native installation; real host tools and unchanged upstream architecture scripts | Detection precedes a conflicting fallback; fallback works when discovery is unavailable; summary suppression does not change architecture or path values; invalid usage returns 2; unavailable architecture or a real probe failure without a fallback returns 1 with a diagnostic and no environment replacement |
| T5 | Selection compatibility | Compare selector bytes with the frozen baseline; directly source the installed setup script from tree A and then tree B while running from another directory | Candidate checkout and copies of the real candidate installation; isolated Bash children | Selector bytes are unchanged; direct sourcing selects the real location of each script and the corresponding base/modules/tool paths without an extra location or release argument |
| T6 | Install integration | Run the real candidate base configuration/build and `install.base`, then the aggregate build/install/symlinks path; repeat installation over known previous script bytes; source installed files and run actual `make check.env` | Disposable checkout and writable install root on one supported Linux OS with all required vendor/module build inputs | Both installed scripts match candidate bytes and mode 0644; backups match replaced bytes; installed setup/reset work; softIoc, caget, pvget, and pvxget resolve inside the tree; the real environment gate returns 0 |
| T7 | Documentation | Build the book from candidate docs with the shipped mdBook configuration; read the seven changed book pages against the actual T2-T6 interfaces; check the separate reference and README links against shipped source and install outputs | Candidate documentation; local mdBook or the shipped documentation image; isolated build output directory | Build returns 0; sources remain unchanged by rendering; reset examples, architecture behavior, direct-source selection and existing selector limitation, top-level listings/counts agree with observed native results |

###### Case Matrix

- T2: no arguments; all managed variables absent; each optional variable absent or empty; `EPICS_BASE` set while modules, architecture, extensions, or library path are individually missing; only `EPICS_PATH`/modules/architecture set without base; a complete previous environment; nonempty legacy `EPICS_EXTENSIONS`; and reset before setup and twice after setup. Use `EPICS_CA_ADDR_LIST` and `EPICS_CA_AUTO_ADDR_LIST` as independent settings and compare them byte for byte after each call. Record the distinction between unset and empty values. Snapshot working directory, `set +o`, `shopt -p`, and caller arguments before and after each source. Catch expected nonzero returns at the call site so `errexit` in the caller does not hide return behavior; also run successful cases under `set -eu`.
- T3: place complete managed fields first, middle, last, and more than once; place unrelated fields containing the managed string as a prefix or interior substring; include spaces, `.`, `[`, `]`, `*`, and `;` as literal field data; include unrelated duplicates and leading, adjacent, and trailing empty fields. Use independent expected field lists in the harness and run the shipped scripts; do not call a replacement `drop_from_path`. Test initial PATH and LD_LIBRARY_PATH both unset and empty. After switching, no known A base/pvxs/pmac field remains; after reset, no known B field remains. Preserve the existing Libera profile policy; do not claim reset removes every library a profile may add.
- T4: valid forms are no arguments, `disable`, `<fallback_arch>`, and `<fallback_arch> disable`. Invalid forms include `disable <arch>`, duplicate `disable`, and extra arguments. Test native detection with a deliberately different fallback, discovery absent with a valid fallback, and discovery absent with no fallback or with `disable` alone. For each available upstream discovery location, retain its real shipped bytes and remove only higher-priority files in a disposable tree copy. A restricted PATH must expose the real required utilities while excluding Perl; never replace the architecture scripts or internal discovery functions. Additionally, keep the actual Perl executable and upstream probe present, and set `PERL5OPT=-M__M14_Missing_Module__` only in the test child's outer environment so the real probe fails. With no arguments and with `disable` alone, require status 1, a diagnostic, and the caller's sentinel; compare the old managed variables and both paths byte for byte, including unset versus empty state. Execute this case against baseline and candidate: the baseline's observed status 0 and environment replacement must be rejected. Capture managed variables and both paths before all failing calls and compare them afterwards.
- T5: compare `selectEpicsEnv.bash` byte for byte with its file at baseline `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`. Use actual installed tree A and a filesystem copy B, including a directory name with spaces. From an unrelated working directory, source A's setup script and then B's setup script without a location or release argument. Check EPICS_PATH, EPICS_BASE, EPICS_MODULES, EPICS_HOST_ARCH, and actual tool resolution against each selected tree. This verifies existing direct-source selection; it does not claim the unchanged legacy selector resolves make's current layout.
- T6: obtain the destination from the real candidate make configuration. Compare SHA-256 and mode of source and installed scripts. Before repeating `install.base`, place known previous bytes at both script destinations in the disposable root; verify the resulting backups independently and verify the current files against the candidate again. Inspect the aggregate `install` result separately. Test setup through its real installed location and a filesystem symlink to that script. Manual script copying is not evidence that installation works.

##### Verification Preparation And Evidence

1. Freeze the baseline at `e1e2df3f266fed6f658a0beca7da7af1f06e81dc` and record the candidate commit or base commit plus a complete diff and SHA-256 values for changed files. Record OS, Bash, ShellCheck, make, mdBook, compiler versions, source pins, vendor commits, environment inputs, and installation paths for each run. Save argv, stdout, stderr, status, and UTC observation time under ignored `work/`; summarize durable outcomes here.
2. Use isolated checkouts, install roots, and HOME directories. Preserve test evidence and existing directories; cleanup is a separate authorized action.
3. Prepare one supported native OS, preferably Rocky Linux 10.2 using the available package environment. Run the candidate's actual init, patch, conf, dependency check, build, install, and symlinks targets with real pinned sources and vendors. Reusing a package environment or download mirror is permitted; old installed scripts and an earlier milestone's pass do not verify the new candidate. Create A/B and restricted-discovery test copies only from this real completed installation.
4. Run T1 before candidate execution. Prepare and verify the native install in T6 before the native installed-script checks T2-T5. Run the documentation check against the observed native outputs. Execute the original nounset and substring regression inputs and T4's discovery-command failure against the frozen baseline and candidate; the assertions must reject the observed baseline failure or corruption and accept the candidate's real outcome. A new case without an executed baseline comparison must not be described as a demonstrated regression against the old defect.
5. Replace no internal span with a mock, stub, fake make, invented base tree, or helper copied into the harness. Only outer environment, filesystem availability, and download transport may be controlled. The harness invokes real scripts and targets and independently checks their outputs. Keep native, cross-build, and target-board runtime claims distinct.
6. All T1-T7 results must refer to the same final candidate source bytes. Re-run affected checks after corrections; a change to installed-script or install-rule bytes requires refreshing the actual installation before dependent checks. A timeout, incomplete run, or unavailable prerequisite is not a pass. Plan acceptance, implementation authorization, GitHub reconciliation, commit, and push remain separate actions; this plan request performs none of the latter mutations.

##### Plan Review Evidence

The review paragraphs and premise table below describe the original combined plan. Their original T7 cross-build and T8 documentation labels predate D42; the mapping above identifies the current checks. Libera-specific premise rows are retained in M20.

Review baseline: `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`, reviewed on 2026-09-30. This is the first review of the M14 plan. The review boundary is the scoped scripts, installation rule, matching usage documentation, and their real execution paths. The original plan lacked case-level expectations, installation preparation, caller-context checks, a managed-variable definition, and an actual Libera execution requirement. The revised draft specifies them; D41 resolves the selector decision by retaining its existing code and direct-source selection.

The second review of the complete M14 plan on 2026-09-30 identified three required additions: real discovery-command failure in T4, concrete cross-base configuration before T7, and repeated setup with T7's actual generated profile in T3. All three plan findings were accepted for incorporation on 2026-09-30. This direction revises the draft; it does not grant plan acceptance or code implementation authorization.

| Class | Scope Clause | Observed Evidence | Plan Consequence |
| --- | --- | --- | --- |
| Confirmed finding | Setup/reset nounset | Real child Bash source calls on 2026-09-30 at 17:29:41 UTC returned 127 at setup lines 106, 115, and 254 and reset lines 115 and 155; no caller sentinel was reached | T2 covers each missing value with the installed candidate |
| Confirmed finding | Exact path removal and reset variables | At 17:29:41 UTC, real reset changed a substring entry into `-extra` and retained EPICS_PATH; without base it also retained EPICS_MODULES and EPICS_HOST_ARCH | T3 requires exact fields; T2 checks reset independently of base and preserves D40 CA settings |
| Confirmed finding | Selector layout | `configure/CONFIG_SRC` defines `<install_location>/<release>/<os_id>-<os_version>/<base_version>`; real make query at 17:28:20 UTC returned that layout, while the selector builds `<epics_top>/epics/<os_id>/<os_version>/<base_version>` | Keep the selector unchanged under D41/K9; exercise direct installed-script selection in T5 and document the limitation |
| Confirmed finding | Reset installation/header and documentation | RULES_BASE installs only setup; reset's Shell header names setup; the shell procedure and script reference explicitly describe reset as uninstalled and EPICS_PATH as retained | T6 verifies real installation and T8 replaces the corresponding descriptions and listings |
| Owner decision | Argument roles and reset ownership | D39 and D40 select separate fallback/summary arguments and managed-variable reset on 2026-09-30 | Reflect those choices in T2-T4 and usage docs |
| Owner decision | Selector code and direct selection | D41 selects existing code preservation on 2026-09-30; setup already derives the tree from its own source location | Withdraw the proposed selector interfaces, preserve its bytes, and retain direct-source selection in T5 |
| Confirmed finding | Discovery-command failure | At 2026-09-30T22:46:21 UTC, the real installed setup in `work/m10-implementation-20260928/candidate/install/1.4.0/debian-13/7.0.10` matched the baseline source SHA-256. In a separate Bash child with `PERL5OPT=-M__M14_Missing_Module__`, its unchanged real Perl probe failed, but setup returned 0, left architecture empty, replaced the old base variable, and removed the old base PATH and library entries | T4 repeats this real failure on baseline and candidate; candidate must return 1 and preserve the old environment |

The premise run's full inputs, statuses, timestamps, source hashes, and make output are retained locally in `work/m14-plan-20260930/baseline.json`. These observations confirm current defects; they are not candidate acceptance results. The baseline warning/error ShellCheck gate also returned 0 with ShellCheck 0.10.0 on the four scoped scripts during this review; this does not satisfy candidate T1.

##### Verification Results

The verified candidate is baseline `e1e2df3f266fed6f658a0beca7da7af1f06e81dc` plus the scoped changes, now published as native implementation `5a610a89c922220c55eecb6820056bc1e9cdea1f` and Libera/reference/record `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. The fetched `origin/master` tree at 2026-10-01T06:44:52.634205+00:00 contains both commits and matches the reviewed source and document SHA-256 values. `work/m14-implementation-20260930/verification-summary.json` records the pre-extraction scoped SHA-256 map, consumed repository commits, resolved image observations, and original check labels. D42 changes documentation and work ownership only; it preserves the runtime source and seven book pages. Original Libera checks remain Pending in M20. No internal script, upstream architecture probe, make target, or installed base was replaced by a substitute.

`work/m14-implementation-20260930/libera-extraction-check.json` records the extraction's local-link and row/detail checks, consecutive current test labels, preserved runtime/book/archive identities, whitespace result, and final document hashes. These checks verify the document separation; they do not execute or satisfy any M20 runtime check.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-01T04:01:14.466637+00:00 | Candidate source; Bash 5.2.37 and ShellCheck 0.10.0 | Pass: syntax, warning/error gate, full inventory, and whitespace check return 0; selector bytes and approved file scope are preserved | `work/m14-implementation-20260930/static.json`, `candidate.diff`, and `verification-summary.json` |
| T2 | 2026-10-01T04:15:45.425463+00:00 through 2026-10-01T04:15:49.717903+00:00 | Rocky Linux 10.2; actual installed candidate; isolated Bash 5.2.26 children with nounset enabled and disabled | Pass: fresh, empty, partial, legacy, reset-before-setup, repeated-reset, and positional-argument cases return to the caller; CA values and caller context are preserved | `work/m14-implementation-20260930/shell-final/results.json` and `summary.json`; each child script, state, stdout, and stderr are retained |
| T3 | 2026-10-01T04:15:46.507396+00:00 through 2026-10-01T04:15:49.729198+00:00 | Rocky Linux 10.2; actual installed candidate; isolated Bash 5.2.26 children with nounset enabled and disabled | Pass within the D42 native scope: exact-field, substring, literal-character, duplicate, empty/unset, repeated setup, A-to-B switch, and reset checks pass; the actual generated-profile case is separately Pending in M20 / T2 | `work/m14-implementation-20260930/shell-final/results.json` and `summary.json`; each child script, state, stdout, and stderr are retained |
| T4 | 2026-10-01T04:15:46.770908+00:00 through 2026-10-01T04:15:50.769158+00:00 | Rocky Linux 10.2; actual installed candidate; isolated Bash 5.2.26 children with nounset enabled and disabled | Pass: all four valid forms, invalid status 2, unavailable status 1, real discovery priority, fallback without Perl, summary suppression, and actual Perl probe failure with preserved old state are observed | `work/m14-implementation-20260930/shell-final/results.json` and `summary.json`; each child script, state, stdout, and stderr are retained |
| T5 | 2026-10-01T04:15:47.476389+00:00 through 2026-10-01T04:15:49.980230+00:00 | Rocky Linux 10.2; actual installed candidate; isolated Bash 5.2.26 children with nounset enabled and disabled | Pass: selector SHA-256 matches the baseline; direct sourcing from another directory selects both actual tree locations, including spaces and literal special characters; all four tools resolve in the selected tree | `work/m14-implementation-20260930/shell-final/results.json` and `summary.json`; each child script, state, stdout, and stderr are retained |
| T6 | 2026-10-01T04:09:56.121905+00:00 through 2026-10-01T04:14:53.946654+00:00 | Rocky Linux 10.2; separate checkout, HOME, and install root; real pinned source and vendor repositories | Pass: actual init/patch preparation and completed pinned submodules precede the final conf, dependency audit, base build/install, aggregate build/install, symlinks, and check.env. Both scripts match candidate bytes and mode 0644; actual replacement backups match previous bytes; symlink sourcing and four tool paths pass | `work/m14-implementation-20260930/native/commands.json`, `complete/commands.json`, `complete/summary.json`, and `shell-final/results.json`; interrupted preparation and final successful logs are retained separately |
| T7 | 2026-10-01T04:05:18.658970712Z through 2026-10-01T04:17:43.876033+00:00 | mdBook 0.5.4 with read-only candidate docs; actual Rocky 10.2 installation and tutorial IOC | Pass within the D42 native scope: book build returns 0 with unchanged source bytes; all seven output pages exist; native setup/reset, tools, gates, first top-level file listing/counts, and real CA/PVA reads and write pass; Libera output comparison is separately Pending in M20 / T3 | `work/m14-implementation-20260930/container-observations.txt`, `verification-summary.json`, `native/complete/first-top-files-list.stdout`, `doc-commands/commands.json`, and `doc-commands/ioc.terminal` |

The final shell matrix passes 130 cases. Separate unchanged baseline executions reproduce setup/reset nounset aborts, substring corruption, and status 0 with environment replacement after a real probe failure. Candidate executions with the corresponding inputs reject those outcomes. This comparison does not claim an actual Libera integration result.

The first top-level file listing uses actual native build products. Earlier top-level scripts, backups, and the version file are retained outside the isolated destination before the actual aggregate install creates its files. Its real `LC_ALL=C make exist LEVEL=1` output reports four directories and three files. Replacement-policy checks then overwrite only the isolated script destinations with known previous bytes and run the actual `install.base` again.

Implementation document review 1, second-person self-review, on 2026-09-30: all seven changed book pages and scripts README were read in full from the operator's seat. The charter covers their approved setup/reset interface, direct selection, installation outputs, and Libera prerequisites. Native procedures and reference rows agree with the executed outputs; no unresolved native reader finding remains. The original Libera compiler/base review and unexecuted runtime/profile assertions are retained in M20 after D42. At that review, all seven native checks passed and no commit, push, or issue closure had been recorded. The publication and CI observations below update that state.

###### Published Candidate CI

Observed at 2026-10-01T06:44:52.634205+00:00 using `gh run list` for the exact commit `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. All eight runs have `headSha` equal to that commit, `status=completed`, and `conclusion=success`. This confirms the shipped native CI workflows, Linter, and documentation deployment; the actual Libera cross-build and profile checks remain Pending in M20.

| Workflow | Result | Run Updated At | Evidence |
| --- | --- | --- | --- |
| Debian 12 | Success | 2026-10-01T06:34:30Z | [Run 36823512804](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512804) |
| Debian 13 | Success | 2026-10-01T06:27:18Z | [Run 36823512758](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512758) |
| Rocky 8 | Success | 2026-10-01T06:34:15Z | [Run 36823512772](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512772) |
| Rocky 10 | Success | 2026-10-01T06:36:06Z | [Run 36823512757](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512757) |
| Ubuntu 24.04 | Success | 2026-10-01T06:32:40Z | [Run 36823512810](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512810) |
| Ubuntu 26.04 | Success | 2026-10-01T06:33:37Z | [Run 36823512752](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512752) |
| Linter Run | Success | 2026-10-01T06:14:22Z | [Run 36823512760](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512760) |
| Deploy Docs | Success | 2026-10-01T06:12:40Z | [Run 36823512754](https://github.com/jeonghanlee/EPICS-env/actions/runs/36823512754) |

The raw CI and issue observations and the publication comparison are retained in `work/m14-implementation-20260930/publication-ci.json`.

##### Closure Evidence

- Native implementation and its seven book pages and Keep record are published in `5a610a89c922220c55eecb6820056bc1e9cdea1f` (11 files). The Libera identifier correction, dedicated reference, scripts README, and shared record are separately published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` (4 files).
- At 2026-10-01T06:44:52.634205+00:00, after `git fetch origin` returned 0, local HEAD and `origin/master` both resolved to `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. Both commits are ancestors of the fetched upstream; its reviewed source and document bytes match the recorded candidate hashes. The worktree was clean at this observation.
- Native T1-T7 pass, the final shell matrix passes 130 cases, and all eight push workflows on `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` succeed as recorded above.
- #87's body is reconciled to the native scope, managed-variable reset, selector Keep, published implementation, and observed verification, with all seven acceptance criteria checked. Its original Libera requirements remain in M20 and are excluded from native completion. The completion comment is https://github.com/jeonghanlee/EPICS-env/issues/87#issuecomment-5926494173.
- #87 was closed as completed at 2026-10-01T07:09:47Z. At 2026-10-01T07:10:05.214Z, `gh issue view 87 --repo jeonghanlee/EPICS-env` reported `state=CLOSED` and `stateReason=COMPLETED`; its body and completion comment matched the prepared native text. The raw observation is retained in `work/m14-implementation-20260930/issue-closure.json`.
- Complete on 2026-10-01: the native deliverable and required verification have upstream landing evidence, all eight CI workflows succeed, and the linked issue is reconciled and observed closed. No closure exception or Libera verification pass is inferred.
- Actual Libera execution remains deferred in M20; native publication and CI success satisfy no M20 runtime check.


##### GitHub Projection

Title: Fix environment script paths and shell variable handling
Labels: bug
GitHub Milestone: Backlog
Observed State: closed as completed (2026-10-01T07:10:05.214Z, `gh issue view 87 --repo jeonghanlee/EPICS-env`; closedAt 2026-10-01T07:09:47Z)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-10-01T07:10:05.214Z (remote updatedAt 2026-10-01T07:09:47Z)
Projection Difference: none. The live body matches the native scope, managed-variable reset, selector Keep, published implementation, and observed verification. The seven native acceptance criteria are checked; Libera requirements remain in M20 and do not occur in the live body.

#### M15 - Clean, Uninstall, And Patch Revert

Origin: 84ee626 / M15
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #88, https://github.com/jeonghanlee/EPICS-env/issues/88
Status: Complete

##### Summary

`conf.std` supplies the installed base to its child IOC while preserving upstream cleanup recursion and unrelated local settings. Revert targets classify whole patches, skip confirmed unapplied patches, and stop on conflicts or unresolved states. T1-T3 verify the actual cleanup, safe revert, and retained-patch audit behavior; the implementation and verification record are published, all eight CI workflows succeed, and #88 is reconciled and closed.

##### Scope

- Clean and uninstall: `std-src/Makefile` recurses into `iocs` for uninstall and realuninstall independently of `BUILD_IOCS`. The child `iocs/stdTestIOC` does not read the EPICS-env root `RELEASE.local` through the parent's relative include, so a direct make query resolves the unavailable upstream base path. Correct its configuration through `configure/RULES_MODS_CONFIG` under D43 and preserve upstream recursion. Reproduce the actual `uninstall.std`, `distclean.std`, `uninstall.modules`, and `clean.modules` outcomes before reporting the inventory's outer failure as a current executed result.
- Patch revert: the inventory reports failure after a partial `make patch`. Current `configure/RULES_FUNC` and `configure/RULES_PATCH` invoke reverse patch commands without first distinguishing applied and unapplied states. Under D44, skip only confirmed unapplied patches, reverse applied patches in the existing reverse order, and stop on conflict, partial application, or an indeterminate state. Reproduce the baseline failure through the shipped make targets before recording it as a current executed result.
- Patch justification: `configure/RULES_PATCH` describes `feed-core-libonly` and `QPC-dataonly` as necessary for strict `check.module-deps`. The current book reports that the audit passes with both patches reverted. Under D46, retain both patch contents and apply behavior, re-run the actual audit under identical configuration with and without each patch, and align comments and book text with the observed results and actual patch functions.

Out of scope: the defects of M9, M10, M11, M12, M13, M14, M16, M17, M18, M19; actual macOS patch-revert verification, retained in Deferred Backlog M21 under D49.

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.
- D49 limits completion verification to the recorded native Linux scope; actual macOS patch-revert execution remains Pending in M21 and is not a condition of M15 completion.
- `make patch.revert` returns 0 for confirmed unapplied, fully applied, and supported partially applied sets of whole patches; applied patches are reversed in reverse application order. Repeating a successful revert returns 0 without changing sources.
- A conflicting, partially applied individual patch, or indeterminate state returns nonzero with the source and patch identified. Safe skipping must not conceal these errors or discard unrelated changes.
- `conf.std` supplies the actual installed base to the child IOC while preserving existing local content other than `EPICS_BASE` assignments. Repeated configuration adds no duplicate managed assignments; changing the installation root updates the effective base.
- Both retained patch files and their apply behavior are unchanged. Their comments and book descriptions match the actual source changes and the recorded strict audit results for all four applied/unapplied combinations.
- Cleanup preserves tracked sources and user local settings. Under D47, only motor-src/modules/RELEASE.<host_arch>.local, generated and removed by the upstream motor modules Makefile, is excluded from this preservation assertion.
- Cleanup runs only after the pinned native environment and every effective cleanup path are checked. All removal paths resolve inside the disposable checkout or install root, and the test uses no sudo. Original installations and earlier evidence remain outside writable mounts.
- A target that legitimately selects no patches returns 0, including an empty optional legacy/version glob or a platform-inactive target. A missing required named patch, source tree, or file needed by a selected patch is an error.
- Conflict and partial-application failures leave sources and inventories unchanged from the state immediately before processing the failing patch, and later reversals do not run. Earlier completed reversals remain in effect and are recorded as completed, including their changes to files also targeted by the failing or later patches. Failure does not create new `.rej` or `.orig` files.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.
- D43, Decision Date: 2026-10-01, selects the `conf.std` configuration correction and retains the upstream Makefiles and recursive cleanup. This selects a plan direction; plan acceptance and implementation authorization remain separate.
- D44, Decision Date: 2026-10-01, selects skipping confirmed unapplied patches, reversing applied patches in reverse application order, and stopping on conflict, partial application, or an indeterminate state.
- D45, Decision Date: 2026-10-01, selects updating only `EPICS_BASE` in an existing child `configure/RELEASE.local` and preserving its other settings. Create the local base assignment when the file is absent; retain unrelated content when it exists.
- D46, Decision Date: 2026-10-01, retains both feed-core and QPC patch contents and apply behavior. Correct their explanations after comparing actual strict audit results under identical configuration; this does not authorize removing either patch or changing audit policy.
- D47, Decision Date: 2026-10-01, retains the pinned motor modules Makefile and its realclean behavior. Its generated modules/RELEASE.<host_arch>.local is the sole exception to local-setting preservation; every other local setting and tracked source remains protected.
- D48, Decision Date: 2026-10-01, selects verifying function location for repeated-code matches, including base PR0919. Supported single-file, single-hunk static C function patches must match changed lines inside the uniquely identified function; unresolved states remain errors.
- D49, Decision Date: 2026-10-01, separates actual macOS patch-revert verification from M15 into Deferred Backlog M21. Preserve the code, patch contents, and Darwin condition. M15 publication and closure do not complete or authorize M21 execution.
- Real cleanup verification requires a complete pinned native build and installation in a separate writable checkout and install root. Recreate the starting built state independently for each destructive target; no run may alter the owner's checkout, installation, or earlier verification evidence.
- T1 uses Rocky 10.2 in image `sha256:a53abde34d5aeede81d01df6fe5954be5fc62eea8846777a9f59b1038c11aff9`, matching the existing complete native fixture. Keep consistent absolute paths inside the container; validate copied generated settings and rebuild real products if their paths do not match the disposable tree. Before every destructive target, inspect the effective module and child installation paths, `MODS_INSTALL_LOCATIONS`, and sudo settings; stop before cleanup if any removal path escapes the disposable roots or resolves through a symlink into a protected tree.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-01, current plan after the ninth third-person and tenth second-person reviews; accepted to proceed. D48 function-location verification accepted on 2026-10-01. D49 separates macOS verification into M21 without changing the implementation.
Implementation Authorization: 2026-10-01, proceed with the reviewed M15 implementation and T1-T3 verification; D47 explicitly clarifies the generated-file exclusion during execution; D48 function-location implementation and remaining real verification authorized on 2026-10-01. D49 authorizes the macOS scope separation; actual M21 execution remains deferred.
Superseded Plan Artifacts: none

1. Re-verify each Scope item against the current code. For std, implement the selected D43 direction in `conf.std`: supply the actual installed base in the child IOC's `configure/RELEASE.local` while retaining upstream Makefiles and uninstall/realuninstall recursion. Under D45, create the base assignment when absent and update only `EPICS_BASE` assignments in an existing file; preserve unrelated settings, comments, and includes. Repeated configuration must not duplicate managed assignments, and a changed installation root must resolve the selected base consistently. Close this item with T1.
2. Update the active revert paths in `configure/RULES_FUNC` and `configure/RULES_PATCH` under D44, keeping the reverse order in `configure/RULES_SRC` and the platform conditions. Preserve successful no-op behavior when an optional glob selects no patches or a platform condition disables a target; distinguish this from missing inputs to a selected patch. Classify each whole patch without modifying sources or prompting before reversing it. Under D48, constrain supported repeated-code matches to the named function, and retain errors when location evidence cannot resolve the state. Skip only confirmed unapplied patches; conflicting, partially applied, required-input-missing, and indeterminate cases fail. Verify that classification failures make no changes from the state immediately before the failing patch is processed, stop later reversals in the default invocation, and create no new `.rej` or `.orig` files. Retain and record earlier completed reversals, including changes to shared target files, and preserve unrelated tracked changes, untracked files, and local configuration. Close this item with T2.
3. Retain `patch/feed-core-libonly.p0.patch`, `patch/QPC-dataonly.p0.patch`, and their apply behavior under D46. Compare the shipped strict audit with both applied, each applied alone, and neither applied, keeping all other source and configuration inputs identical. Update the explanatory comments in `configure/RULES_PATCH` and the relevant text in `docs/src/concepts/upstream-patch-carry.md` to match actual patch functions and observed audit results. Record the accepted Keep premise and evidence in `docs/CLOSED_DOORS.md`; close this item with T3.
4. Run the Test Plan and record actual baseline and candidate outcomes separately. For T1, perform and record the environment, path, and privilege checks before each destructive target; a failed preparation check prevents cleanup and is not a cleanup pass. For T2, follow the T2 Observation Procedure below to capture source contents and complete inventories, including ignored files, at the real failing-patch boundary. Complete its preparation checks before using the observer on writable candidate fixtures. Record preceding completed reversals and compare the final state with the captured reference; earlier successful changes remain allowed, and the failing and later steps add no changes or new rejection/backup files. Preparation observations are not T2 candidate passes.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Configuration and clean | Query the real std module and child IOC configuration after actual `make conf.std`, covering absent and existing child local files, repetition, and an installation-root change; compare existing non-EPICS_BASE content. Before every cleanup, confirm the image/OS, effective base and module paths, child installation paths, aggregate removal list, and absence of sudo. Resolve paths and symlinks to prove every removal target is inside the disposable roots. Run `make uninstall.std`, `make distclean.std`, `make clean.modules`, and `make uninstall.modules` on independently restored real builds; compare baseline and candidate | Pinned Rocky 10.2 image specified above; isolated checkout, HOME, and writable install root at consistent container paths; actual pinned std and EPICS base; original installations and prior evidence outside writable mounts | Preparation checks pass before any cleanup starts. Child IOC resolves the actual installed base; settings, comments, and includes outside EPICS_BASE assignments are unchanged. Repetition adds no duplicate assignments, and root switching updates the effective base. All four candidate cleanup targets return 0 and remove their intended products. Tracked sources, user local settings, the installed base, and unrelated installations survive; only the motor-generated modules/RELEASE.<host_arch>.local may be removed under D47; individual std cleanup preserves other modules. Actual outer baseline results are recorded; a preparation failure or dry-run is not a cleanup pass |
| T2 | Patch | Exercise shipped aggregate and individual revert targets with none/all applied, prefixes within base/pvxs stacks, mixed module families, and repetition. Test successful empty optional globs and platform-inactive targets separately from missing required inputs to selected patches. Use controlled edits to real patch target files for conflict and partial-hunk cases; place a failure between reversible patches, including patches that share target files. Follow the T2 Observation Procedure to capture the actual boundary and compare final contents and inventories, including ignored `.rej` and `.orig` files. Cover failure within a multi-patch target and within the aggregate, recording completed reversals before that boundary. Required-input failures that occur before GNU patch starts are exercised as the first selected failing target with command-start capture | Independent disposable pinned checkouts; real make rules, patch executable, and shipped patch files with no internal replacements; actual platform conditions retained; default make invocation for failure-stop checks | Safe cases and legitimate no-selection targets return 0. Applied patches reverse in reverse application order and restore patch-owned changes while preserving unrelated changes; repetition changes nothing. Conflict, partial application, required-input absence, or an indeterminate state returns nonzero with source and patch identified. The failing step and all later steps add no changes relative to the observed state immediately before the failing patch. Earlier completed reversals remain in effect and are recorded, even when they changed files also targeted by the failing or later patches. No new `.rej` or `.orig` files appear on classification failure. Baseline partial-set failure is observed through the real make path; untested platform-specific paths remain explicitly unverified |
| T3 | Patch justification and documentation | Run actual `make check.module-deps` in four source states: both retained patches applied, feed-core only, QPC only, and neither. Set states through shipped individual patch targets; record status and findings, compare source changes with the retained patch files, and review revised comments, book text, and Keep evidence against those observations | Isolated complete pinned source checkouts; identical module selection, platform, generated configuration, and other patch states across all cases; actual shipped strict audit | The normal patched configuration passes. Every combination has a recorded actual outcome; comments and book text describe those outcomes accurately without treating unexecuted cases as passing. The retained patch files and apply behavior remain unchanged, and the Keep records the actual functions and evidence. Unexpected outcomes require correcting the explanation rather than silently changing audit policy |

###### T2 Observation Procedure

1. Use Python 3 and Linux `ptrace` through `work/m15-plan-20261001/observe-patch.py`; it follows the real make process and its fork/vfork/clone/exec descendants. Use the pinned Rocky 10.2 image from Dependencies And Decisions, the host evidence directory owner's UID:GID, `--cap-drop ALL --cap-add SYS_PTRACE`, the default seccomp profile, `--network none`, and a read-only container root. No sudo, additional packages, `--privileged`, or source-code substitution is needed. Grant write access only to each disposable candidate fixture and its separate evidence directory; earlier fixtures and installations remain read-only or outside the mounts.

2. From the repository root, run the following read-only preparation commands. The launcher uses the actual existing fixture `work/m14-implementation-20260930/native`, creates uniquely named retained containers and evidence directories, and records the exact Docker argv. The first command must return 0 with one matching GNU patch exec stop, a recorded boundary inventory, and identical initial/final source inventories. It deliberately kills make before patch processing; its recorded make status is -9, not a successful revert. The second command must return 0 with command-start capture, actual `patch.base.revert` status 0 for the empty optional glob, and identical initial/final inventories.

```bash
python3 work/m15-plan-20261001/run-observer-preflight.py
python3 work/m15-plan-20261001/run-observer-preflight.py --command-start
```

3. For conflict and partial-hunk cases, invoke `observe-patch.py` with `--cwd <actual_checkout>`, one `--root <actual_source_tree>` for every affected source tree, `--patch <absolute_shipped_patch>`, `--output <new_evidence_directory>`, and `-- make <shipped_revert_target>`. Omit `--abort-before-patch` for the real candidate run. The observer stops at `PTRACE_EVENT_EXEC` of the actual GNU patch process, identifies the selected patch through its stdin path or input argument, and records the source inventory before that process starts processing the patch. Use the first matching event for the candidate's first GNU patch classification command. Resume the unchanged process and allow the shipped make target to reach its actual result. Make's existing serial execution and exclusive fixture ownership prevent another source writer from changing the captured state.

4. Keep failure cases that occur before GNU patch exec, including a missing required named patch, as the first selected failing target. Use `--capture-command-start` instead of `--patch`, then compare `initial.json` with `final.json` and require the shipped target's actual nonzero status and source/patch diagnostic. When the source tree itself is missing, inventory its existing parent so absence is recorded. This mode does not require the missing file to exist. Failures after earlier successful reversals within a stack or aggregate use the patch-exec mode in step 3; do not assume a per-file make target exists.

5. Store evidence outside every inventoried source tree. Each case records `initial.json`, `boundary-NNN.json` for matching exec events, `final.json`, `trace.json`, `stdout.txt`, and `stderr.txt`. Inventories include ignored and untracked entries, file type and mode, regular-file size and SHA256, and symlink targets without following directory symlinks. `trace.json` identifies the command, patch, PID, executable, argv, cwd, event time, matching inventory, actual command status, and controlled-abort state. Require the failing patch's first boundary inventory to equal the final inventory, preserve preceding reversals, and verify later steps did not run. A tracing permission error, missing required boundary, incomplete inventory, or preparation abort is not a candidate pass. Inspect stderr and record completeness as well as exit status: argument errors and uncaught filesystem/tracing exceptions can exit 2 or 1. The observer explicitly returns 125 when a required boundary is absent, an abort check fails, or the command has no nonnegative exit status; otherwise a completed non-abort run returns the real command's status. Keep the launch argv, image, observer SHA256, and case records with the T2 evidence.

##### Plan Review Evidence

First plan review, baseline `18243e725e93b3f05c68012a5aac8360c64975f8`, on 2026-10-01. This is a standalone self-review of the std cleanup, partial patch revert, and patch-justification scope. D43 selects the std direction, D44 selects patch-revert behavior, D45 selects preservation of existing child local settings, and D46 retains both patches while correcting their explanations against actual audit evidence. The identified owner choices are resolved; acceptance of the complete revised plan and implementation authorization remain separate. No candidate implementation or T1-T3 pass is recorded.

| Class | Scope Clause | Observed Evidence | Plan Consequence |
| --- | --- | --- | --- |
| Confirmed finding | std child configuration | On the actual Rocky 10.2 installation at 2026-10-01T07:31:24.304375+00:00, direct `make -np uninstall` in the pinned std child IOC returns 2 because its base configure include is unavailable. The child reads the parent module RELEASE with its own TOP and misses the EPICS-env root override | D43 corrects child configuration through `conf.std`; T1 verifies the effective base and actual outer cleanup targets |
| Hypothesis requiring actual execution | Inventory's outer std failure | Read-only `make -n uninstall` and `make -n distclean` in the std module return 0 at 2026-10-01T07:29:51.119612+00:00 and 2026-10-01T07:29:51.557847+00:00. Direct IOC parsing and parent dry-run differ; neither executes cleanup | Run each baseline and candidate outer target on independently restored real build products; do not infer success or failure of actual cleanup from these diagnostics |
| Owner decision resolved | std correction boundary | D43 selects child base configuration through `conf.std`, preserving the existing upstream Makefiles and cleanup recursion | Keep the correction in the configuration rule and test it through shipped make paths |
| Owner decision resolved | Partial patch revert | D44 permits skipping only confirmed unapplied patches and requires errors for conflict, partial application, or an indeterminate state | T2 separates safe skipping from invalid states and checks reverse order, repetition, and preservation of unrelated changes |
| Owner decision resolved | Existing std child local settings | D45 selects updating only EPICS_BASE while preserving the remaining local content | T1 covers absent and existing local files, checks preserved content, and verifies repetition and installation-root changes through real `conf.std` |
| Owner decision resolved | Patch justification | D46 retains both patch contents and apply behavior and selects verification followed by explanation corrections | T3 executes all four applied/unapplied combinations through the shipped audit before comments, book text, and Keep evidence claim an outcome |

The read-only diagnostic argv, stdout/stderr, status, time, image identity, and decision are retained in `work/m15-plan-20261001/std-premise.json`. The source fixture is the actual pinned native installation; these observations do not satisfy T1 or replace a real clean/uninstall run.

###### Second Review

Second review of the M15 plan on 2026-10-01, as a standalone third-person self-review of the revised draft and D43-D46 against baseline `18243e725e93b3f05c68012a5aac8360c64975f8`. All three findings were accepted for plan correction on 2026-10-01. This acceptance covers the findings; the complete plan remains draft, with no implementation authorization.

| Accepted Finding | Scope Clause | Evidence | Reflected Requirement |
| --- | --- | --- | --- |
| Execution environment and cleanup paths | T1 preparation | Real `print-OS_NAME`, `print-OS_VERSION`, installation-path, and `print-SUDOBASH` queries on the same native fixture resolve Debian 13 and a sudo wrapper on the host, but Rocky 10.2 and `bash -c` in the pinned image. The read-only container finished at 2026-10-01T08:20:16.768437424Z; host values were re-observed at 2026-10-01T08:27:38.904418+00:00 | Pin the native image, retain consistent container paths, and verify effective removal paths and privilege settings before every cleanup |
| Legitimate empty selection versus missing required inputs | T2 classification | The current 7.0.10 legacy glob selects no file; actual `make patch.base.revert INSTALL_LOCATION=/tmp` returned 0 during the second review. `configure/RULES_FUNC` makes the legacy and version-aware sets optional | Preserve no-op success for legitimate empty selection and inactive platform targets; fail missing required inputs to selected patches |
| File state after failure | T2 failure verification | The reviewed T2 required status and diagnostics but did not explicitly assert the failing and later patch states or absence of new rejection/backup files | Compare contents and inventories including ignored files, leave the failing and later patches unchanged, and record earlier completed reversals |

The actual diagnostic results are retained in `work/m15-plan-20261001/second-review.json`. The container used a read-only native mount and did not run destructive cleanup. These premise observations do not satisfy T1-T3 or establish a candidate patch-revert pass.

###### Second-Person Review

The fifth review of the M15 plan on 2026-10-01 took the seat of an implementation engineer working without the authoring conversation. The reviewed draft had SHA256 `2c141b82abeb06fd6230da9de907004199411fcf70f2cc55621c6f659277cb78` at baseline `18243e725e93b3f05c68012a5aac8360c64975f8`. The T2 comparison finding was accepted for plan correction on 2026-10-01.

The shipped pvxs patches `1.5.2-02-090bf5f-cli-flush.p0.patch` and `1.5.2-04-0b3fcca-cli-dtor-order.p0.patch` both target `tools/call.cpp`, `tools/get.cpp`, `tools/info.cpp`, `tools/list.cpp`, `tools/monitor.cpp`, and `tools/put.cpp`. A whole-invocation comparison must allow changes from earlier completed reversals. Completion Criteria, Implementation Plan items 2 and 4, and T2 now compare failure against the state immediately before processing the failing patch. For failures within a stack or aggregate, capture that reference at the failing patch boundary in the actual shipped execution using observation-only process control. Base and pvxs have one target per stack, so separate per-file make targets cannot be assumed. Keep make rules, revert logic, and the patch executable unchanged by observation; do not reconstruct an expected source tree by hand. This refines the second review's file-preservation requirement.

This acceptance covers the comparison correction only. Plan acceptance, implementation authorization, and T1-T3 execution remain pending.

###### Eighth Review Correction And Observation Preparation

The eighth review on 2026-10-01 found that the failure-state requirement did not name an observation tool, command, stop point, privilege configuration, or evidence files. The correction was accepted on 2026-10-01. The T2 Observation Procedure now names each item and distinguishes preparation from candidate verification.

On the actual pinned Rocky 10.2 image, the prepared launcher returned 0 at `2026-10-01T16:18:53.800116629Z` after following the shipped `make patch.feed-core.revert` to a GNU patch exec stop at `2026-10-01T16:18:53.738437+00:00`. It recorded the selected patch's stdin and source inventory, deliberately killed make before patch processing, and observed identical initial/final inventories. The command-start preparation returned 0 at `2026-10-01T16:19:10.293212061Z` after the real empty legacy `patch.base.revert` returned 0 with unchanged inventories. Both containers used UID:GID `1000:1000`, only `SYS_PTRACE` after dropping all capabilities, no network, a read-only root, and a read-only native fixture mount.

An earlier resume diagnostic at `2026-10-01T16:15:57.382129982Z` recorded the actual make status 2 when GNU patch could not create a temporary file on the read-only source mount; inventories remained unchanged. This confirms status recording for that diagnostic, not a conflict/partial-application result. The first preparation attempt stopped at an evidence-directory permission error before the target ran; it is not a successful observation.

Raw launch argv and observer SHA256 are in `work/m15-plan-20261001/exec-20261001-161853-363753-launch.json` and `work/m15-plan-20261001/start-20261001-161909-955487-launch.json`. Their case directories contain the inventories, trace, and stdout/stderr. `work/m15-plan-20261001/observer-preparation.json` retains inspected container/image/mount facts and links the resume diagnostic. These observations establish preparation on the existing environment only. Required-input failure cases, writable candidate capture, and T1-T3 remain unexecuted; the plan remains draft without implementation authorization.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-01T18:09:00.601336+00:00 | Rocky 10.2 pinned image; four independent real native build/install copies, UID:GID 1000:1000, no sudo | Pass: all four actual candidate cleanup targets return 0; absent/existing/repeated/root-switched std child configuration resolves the installed base. Tracked sources, protected local settings, installed base, and unrelated individual-target module installations are preserved. Only the motor-generated local file is excluded under D47. Each actual baseline cleanup target returns 2 | `work/m15-implementation-20261001/t1-v2-{baseline,candidate}-<target>/`; clean.modules final candidate: `t1-v5-candidate-clean.modules/`. Each case retains raw commands, preparation, and results |
| T2 | 2026-10-01T21:44:18.532769+00:00 | Rocky 10.2 pinned image; real pinned source clones, make, GNU patch, and observation-only ptrace | Pass: 21 final matrix cases plus three extended/review cases at helper SHA256 `fd411404e9c1a168e0b67977b5a0f2ccf5e84a2e98e2d5857a3968ba98bc5cca`. Baseline none/partial targets return 2; candidate none/all/repeat, stack prefixes, mixed families, and optional/inactive selections succeed. Conflict, partial-hunk, missing, malformed, shared-file, aggregate, repeated-code, and duplicate-function failures stop with diagnostics and unchanged failing-boundary inventories. Earlier reversals remain and later steps do not run. Real post-apply 40-line and 400-line shifts preserve independent comments and existing backups through revert and repetition; the 400-line case also exercises the helper without prerequisites. Observed reversal order matches all 18 base and 12 pvxs patch files. Linux platform-inactive behavior is verified; actual macOS verification remains Pending in Deferred Backlog M21 under D49 and is excluded from M15 completion | `work/m15-final-20261001/{matrix-v1,extended-v1,review-v1}/{launch.json,summary.json}` and each case's real commands, inventories, and traces. Earlier failed probes remain under `work/m15-implementation-20261001/` |
| T3 | 2026-10-01T18:08:45.090726+00:00 | Rocky 10.2 pinned image; independent actual pinned source checkouts, identical other patches and generated configuration | Pass: strict audit returns 0 in all four retained-patch combinations. Non-failing declared-unobserved findings remain: 26 with both patches or QPC only, and 25 with feed-core only or neither. Retained patch contents, apply recipes, source pins, and audit policy remain unchanged; explanatory comments and book text match the four results, and K10 records the Keep | `work/m15-implementation-20261001/t3-cases/launch.json` and `four-combinations/{pins.json,commands.jsonl,audits.json,result.json}`; `docs/CLOSED_DOORS.md` K10 |

##### Implementation Review Observations

The first review of the M15 implementation is a completed third-person
self-review on 2026-10-01. Its charter covers D43-D48, T1-T3, the ten changed
files, affected make paths, book passages, and Keep evidence. Its verdict is
Pass for the accepted native implementation; actual macOS execution remains
Pending in Deferred Backlog M21 under D49.

| Finding Or Check | Scope Clause | Observed Evidence | Outcome |
| --- | --- | --- | --- |
| Post-apply source shift and repeat failure | D44, D48 / T2 | The earlier 40-line shift restored code once but failed while preparing PR0919 context on repetition. Private hunk search positions now follow the uniquely named function while retaining real hunk matching | Resolved at the final helper hash; actual 40-line and 400-line cases revert and repeat successfully, preserving independent comments and existing backups |
| Duplicate function and failing-patch preservation | D44, D48 / T2 | A controlled duplicate of the real putUInt64String function fails through the shipped base revert. Independent comparisons of all ten actual failure traces confirm that their first failing boundary, or command-start inventory, equals the final inventory | Pass; four cases retain earlier completed reversals, and later reversals do not run |
| Audit success does not mean no findings | D46 / T3 | Real outputs retain 26 declared-unobserved findings with both patches or QPC only, and 25 with feed-core only or neither; strict status is 0 in every state | Corrected the verification row; patch contents, apply behavior, and audit policy are unchanged |
| Source configuration and cleanup preservation | D43, D45, D47 / T1 | All four real candidate cleanup targets return 0 after absent/existing/repeated/root-switched std configuration; baseline targets return 2 | Pass; only the upstream motor-generated host RELEASE file is excluded |
| Retained inputs and reversal order | D44, D46 / T2-T3 | Direct byte comparisons against `18243e725e93b3f05c68012a5aac8360c64975f8` preserve all tracked patch files, source pins, aggregate order, three apply macros, and eight fixed apply recipes. Real aggregate output reverses all 18 base and 12 pvxs patches in descending file order | Pass; final runtime inputs match all three final launch records |

The second review of the M15 implementation is a completed second-person
self-review on 2026-10-01, taking the seat of an operator without the
authoring conversation. Every changed passage in the four book pages,
K10, the canonical verification rows, and the entry point was read against
the actual execution records and final rendered book. Its verdict is Pass;
no unresolved in-scope finding remains.

The reader checks cover D43/D45's child base configuration before cleanup,
D47's exact generated-file exception, D44/D48's whole-patch skip and failure
conditions, preserved earlier reversals and backups, and D46's four audit
outcomes. The entry point distinguishes completed local verification from
pending commit, publication, and linked-issue closure. No unexecuted macOS
path is claimed as verified. D49 subsequently separates those unexecuted
checks into Deferred Backlog M21 without changing the reviewed runtime code
or book; M15 completion does not satisfy any M21 check.

A separate initial probe shifted the source before shipped apply. GNU patch
then applied PR0919 to the similar putUlongString body. This apply behavior
is outside the revert charter and is not added to the current implementation
or closure criteria. Raw observations are retained in `review-cases/` under
`work/m15-implementation-20261001/`; no apply recipe or patch was changed.

The final actual mdBook build succeeds at 2026-10-01T21:55:52.666162+00:00
using the pinned locally available CI image, with all docs/src and book.toml
bytes unchanged during execution. All four affected HTML pages exist.
Raw argv, image, status, source hashes, and output are in
`work/m15-final-20261001/docs-build-final.json`.

Final local checks on 2026-10-01 also return 0: `bash -n tools/revert_patch.bash`,
`shellcheck -S warning tools/revert_patch.bash`,
`shellcheck tools/revert_patch.bash`, and `git diff --check`.
Both ShellCheck invocations produce no findings at the final helper hash.

Automatic approval review rejected the latest full matrix launcher because
free disk space was about 5.1 GB and accumulated fixtures could exhaust it.
The real shared-object fixture consumes about 297 MB, so 21 retained cases
would require about 6 GB before logs. No rejected launcher ran. The owner
subsequently authorized moving only the implementation evidence directory
to the USB filesystem and retaining its original path as a symbolic link.
That verified move resolved the capacity condition. The separately approved
final matrix recorded 93,573,562,368 free bytes against a 10,737,418,240-byte
preflight minimum and completed successfully. Its exact writable case mounts
and read-only seed/candidate mounts are recorded in
`work/m15-final-20261001/matrix-v1/launch.json`; prior evidence is preserved.

##### Publication Verification

Observed at 2026-10-02T02:27:24Z through the GitHub Actions runs API for commit `6e58d422ec33233edd21d2c529923971ec2445a3`. Every listed run reports `status=completed` and `conclusion=success`; the timestamps below are the remote `updated_at` values.

| Workflow | Result | Remote Updated At | Run |
| --- | --- | --- | --- |
| Deploy Docs | success | 2026-10-01T23:59:57Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668244 |
| Linter Run | success | 2026-10-02T00:01:12Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668248 |
| Ubuntu 24.04 | success | 2026-10-02T00:13:48Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668277 |
| Debian 13 | success | 2026-10-02T00:15:52Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668264 |
| Debian 12 | success | 2026-10-02T00:15:28Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668263 |
| Rocky 8 | success | 2026-10-02T00:17:20Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668242 |
| Ubuntu 26.04 | success | 2026-10-02T00:20:38Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668306 |
| Rocky 10 | success | 2026-10-02T00:21:36Z | https://github.com/jeonghanlee/EPICS-env/actions/runs/36943668249 |

##### Closure Evidence

- Complete on 2026-10-01 (America/Los_Angeles): the accepted native deliverable, required verification, publication, and linked-issue closure are satisfied.
- The ten-file native implementation and verification record are published in `6e58d422ec33233edd21d2c529923971ec2445a3` on `origin/master`. At 2026-10-02T02:27:24Z, `git ls-remote --exit-code --heads origin refs/heads/master` resolved that commit; the local worktree was clean before this record update.
- Native T1 passes all four actual cleanup targets and std configuration cases; T2 passes 24 real cases, including baseline observations and candidate success/failure paths; T3 strict audit returns 0 in all four retained-patch combinations. The recorded non-failing audit findings, unchanged patch/apply inputs, and exact motor-generated-file exception remain part of the evidence.
- All six OS workflows, Linter Run, and Deploy Docs succeed for the implementation commit, as observed above.
- #88's body matches the published implementation, real verification outcomes, and macOS scope exclusion, with all six acceptance criteria checked. The completion comment is https://github.com/jeonghanlee/EPICS-env/issues/88#issuecomment-5944032128.
- #88 was closed as completed at 2026-10-02T01:44:37Z. At 2026-10-02T02:27:24Z, `gh api repos/jeonghanlee/EPICS-env/issues/88` reported `state=closed`, `state_reason=completed`, and `updated_at=2026-10-02T01:44:37Z`; the body matched the prepared native text.
- D49 preserves actual macOS patch-revert verification in Deferred Backlog M21. This closure does not complete, retire, or authorize any M21 check.

##### GitHub Projection

Title: Make clean, uninstall, and partial patch revert complete
Labels: bug
GitHub Milestone: Backlog
Observed State: closed as completed (2026-10-02T02:27:24Z, `gh api repos/jeonghanlee/EPICS-env/issues/88`; closed_at 2026-10-02T01:44:37Z)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-10-02T02:27:24Z (remote updated_at 2026-10-02T01:44:37Z)
Projection Difference: none. The live body matches the native scope, published correction, actual cleanup and patch/audit verification, and successful CI results. All six acceptance criteria are checked; actual macOS verification remains a separate scope in M21.

#### M16 - Installed Tree Portability

Origin: 84ee626 / M16
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #89, https://github.com/jeonghanlee/EPICS-env/issues/89
Status: Not started

##### Summary

Installed files name upstream `EPICS_BASE` paths and the absolute install path. The M6 code inventory found these defects.

##### Scope

- Installed tree: installed `modules/<module>/configure/RELEASE` files are upstream copies that name foreign `EPICS_BASE` paths, so a downstream IOC fails `checkRelease` unless it sets `CHECK_RELEASE=NO`. Installed text files (pkg-config files, caRepeater service scripts, `base/configure/CONFIG_SITE.local`, module `configure/RELEASE.local`, `libuldaq.la`) embed the absolute install path, so a moved tree leaves them pointing at the old location.

Out of scope: the defects of M9, M10, M11, M12, M13, M14, M15, M17, M18, M19.

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Re-verify each Scope item against the current code and obtain owner direction on its fate (fix or Keep).
2. Implement the fixes and record each Keep in `docs/CLOSED_DOORS.md`.
3. Run the Test Plan.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Downstream | Build an IOC against the installed tree without `CHECK_RELEASE=NO`, and read each listed text file after moving the tree | Host with an installed tree | The result matches the recorded fix or Keep for each file |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Host with an installed tree | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Resolve foreign and absolute paths in installed files
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:32.382476+00:00, `gh issue view 89 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:32.382476+00:00 (remote updatedAt 2026-09-28T23:00:31Z)

#### M17 - Common Iocsh Fragment Defects

Origin: 84ee626 / M17
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #90, https://github.com/jeonghanlee/EPICS-env/issues/90
Status: Not started

##### Summary

Three fragments do not behave as their macros and comments state. The M6 code inventory found these defects.

##### Scope

- Common iocsh fragments: `commonIocsh/iocsh/iocLog.iocsh:13` sets `iocLogDisable` with `epicsEnvSet`, but `iocLogInit` reads only the C variable, so `LOGDISABLE=1` does not disable IOC logging. `autosave.iocsh:24-25` uses the iocsh `system` command, which needs Base `system.dbd`, and its header does not state that. `iocStatsAdmin.iocsh` fails to load `iocAdminSoft.db` when `IOC` exceeds 21 characters, because `$(IOC):ALLOW_POSIX_THREAD_PRIORITY_SCHEDULING` exceeds 60 characters, and its comment blames the DESC fields. With the same `IOC`, `iocAdminSoft.db` shares 75 record names with `linStatHost.db` (8) and `linStatProc.db` (67), and loading them together fails on type-mismatched duplicates.

Out of scope: the defects of M9, M10, M11, M12, M13, M14, M15, M16, M18, M19.

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Re-verify each Scope item against the current code and obtain owner direction on its fate (fix or Keep).
2. Implement the fixes and record each Keep in `docs/CLOSED_DOORS.md`.
3. Run the Test Plan.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Fragment | Boot a test IOC with each changed fragment: iocLog with `LOGDISABLE=1`, and iocStatsAdmin with a 22-character `IOC` alone and with linStat | Host with an installed tree and the fragment test IOC | Logging is disabled; each case matches the recorded fix or Keep |
| T2 | Fragment suite | Run `examples/commonIocsh/tests/run_all.sh` against the installed tree | Same host | `OVERALL: PASS` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Host with an installed tree and the fragment test IOC | Pending | none |
| T2 | Not run | Same host | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Fix logging and database constraints in common iocsh fragments
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:35.967687+00:00, `gh issue view 90 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:35.967687+00:00 (remote updatedAt 2026-09-28T23:00:35Z)

#### M18 - Fragment Test Defects

Origin: 84ee626 / M18
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #91, https://github.com/jeonghanlee/EPICS-env/issues/91
Status: Not started

##### Summary

The fragment tests can delete a working checkout, default to one user's paths, and do not check the serial settings they set. The M6 code inventory found these defects.

##### Scope

- Tests: `examples/commonIocsh/tests/t3_run.sh` removes the source roots `SRC_EPICS` and `TC32SIM_SRC` with `sudo rm -rf` (line 73), so an override that names a working checkout deletes that checkout. `examples/commonIocsh/tests/common.sh` defaults to absolute paths under one user's home. `examples/commonIocsh/tests/verify_serial.sh:57-61` sets `BITS=7` and `PARITY=odd` on socat ptys, which force CS8 without parity, and checks only the echoed baud command, so bits and parity are never verified.

Out of scope: the defects of M9, M10, M11, M12, M13, M14, M15, M16, M17, M19.

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Re-verify each Scope item against the current code and obtain owner direction on its fate (fix or Keep).
2. Implement the fixes and record each Keep in `docs/CLOSED_DOORS.md`.
3. Run the Test Plan.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Safety | Run `t3_run.sh` with source overrides that name a scratch copy of a checkout | Scratch directory | The named checkout remains |
| T2 | Fragment suite | Run `examples/commonIocsh/tests/run_all.sh` against an installed tree | Host with the installed tree and tc32sim | `OVERALL: PASS` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Scratch directory | Pending | none |
| T2 | Not run | Host with the installed tree and tc32sim | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Protect source checkouts and verify fragment test claims
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:38.858714+00:00, `gh issue view 91 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:38.858714+00:00 (remote updatedAt 2026-09-28T23:00:37Z)

#### M19 - Build-System Hygiene

Origin: 84ee626 / M19
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #92, https://github.com/jeonghanlee/EPICS-env/issues/92
Status: Not started

##### Summary

The build system carries names, variables, comments, and files that no rule uses. The M6 code inventory found these defects.

##### Scope

- Hygiene: `.PHONY` names with no rule, unused variables and rules, stale comments, inconsistent clean-target names, inactive patch files, the stale top-level `RELEASE.local` and `CONFIG_SITE.local`.

Out of scope: the defects of M9, M10, M11, M12, M13, M14, M15, M16, M17, M18.

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.

##### Dependencies And Decisions

- D17 places the work on `master`; D23 splits the inventory defects into M9-M19, each with its own issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Re-verify each Scope item against the current code and obtain owner direction on its fate (fix or Keep).
2. Implement the fixes and record each Keep in `docs/CLOSED_DOORS.md`.
3. Run the Test Plan.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Integration | Push the change to `master` and read the OS workflow runs | GitHub Actions on `master` | Every OS workflow passes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | GitHub Actions on `master` | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Reconcile unused build names, variables, and stale files
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:41.274628+00:00, `gh issue view 92 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:41.274628+00:00 (remote updatedAt 2026-09-28T23:00:40Z)

#### M22 - Installed Module Loader For softIocPVX

Origin: 84ee626 / M22
Identity History: none
GitHub Issue: #93
Status: In progress

##### Summary

Run an IOC with the installed `softIocPVX` and an IOC-owned `st.cmd` that names modules, without compiling an IOC executable or installing e3-require. The installed `iocsh.bash` resolves the requested versions and their dependencies, validates the selected files, loads support, and runs the remaining startup commands.

The distribution already defines module names, versioned directories, dependency rules, and unversioned selection symlinks. Generate runtime metadata during installation so startup does not need the build checkout, Make, or any `.local` file.

##### Scope

- Generate version-specific metadata at installation from effective module names, version pins, declared dependencies, and installed artifacts. Proposed location: `modules/<name>-<version>/cfg/iocsh.conf`. Record a format version, module name/version, Base/architecture compatibility, distribution-relative artifact paths, exact dependency versions, explicit ordered library/DBD entries, and the environment macros needed by installed DB and iocsh files.
- Keep metadata with its module version. Do not embed absolute build/install roots or execute the metadata as shell code. Empty library or DBD lists support library-only and data-only modules. Derive entries by the default rule `lib<name>.so` with `<name>.dbd` (D59), and declare an explicit exception for every module whose installed names differ or whose list is empty; the installed inventory includes asyn with `asyn.dbd`, `drvAsynIPPort.dbd`, and `drvAsynSerialPort.dbd` (D72), StreamDevice as `libstream` with `stream.dbd`, iocStats as `libdevIocStats` with `devIocStats.dbd`, autosave as `libautosave` with `asSupport.dbd`, caPutLog with both `caPutLog.dbd` and `caPutJsonLog.dbd` because `libcaPutLog.so` defines both registrars, calc with `calcSupport.dbd`, sscan with `sscanSupport.dbd`, mca with `mcaSupport.dbd`, feed-core as `libfeed` with `feed.dbd`, recsync as `libreccaster` with `reccaster.dbd`, snmp as `libdevSnmp` with `devSnmp.dbd`, std, modbus, busy, and scaler with `<name>Support.dbd`, sequencer/seq as library-only (`libseq`, `libpv`) whose installed DBDs are examples, pcas as library-only (`libcas`, `libgdd`), and QPC as data-only with no library or DBD. A module whose default-rule files are absent and that has no exception fails metadata generation at installation. A candidate DBD that defines a Base menu or record type with a body is an expanded application DBD and is rejected at metadata generation, the Base names being those of the DBD native `softIocPVX` loads (`softIocPVX.dbd` with `base/dbd/base.dbd` and its includes); in the installed inventory `sscan.dbd`, `std.dbd`, `mca.dbd`, `snmp.dbd`, and `pmac.dbd` are such files, and the real `softIocPVX` loads them without error and can register support outside the selected graph, as `std.dbd` does with 68 asyn device entries resolved through the `libasyn.so` that `libstd.so` names in `NEEDED`, so only the install-time check prevents it. A record DBD may include a Base or PVXS file that carries menus only, and generation rejects a selected DBD with an entry that no selected, dependency, Base, or PVXS library exports (D63); `pmacInclude.dbd`, the pscdrv `pscSig.dbd`, and the rgamv2 `rgaInclude.dbd` are such files and stay out of the mapping. Do not load every installed example library or DBD.
- Record the effective module version and exact dependencies used by each successful build, including DBD/data-only dependencies, and tie that record to the generated artifacts. During module and distribution installation, generate runtime metadata from this build record and the installed artifact inventory; compare it with the effective installation configuration and reject stale or unproven combinations. Configuration queries alone cannot establish an artifact's build identity. The successful-build record is `modules/<name>-<version>/cfg/build-record`, beside the runtime metadata. It carries the source commit actually built, which must equal the commit of the pinned tag, and the build rejects a release file in the source checkout that names an undeclared dependency version or a module outside the selected tree. Validate artifacts and metadata before publishing the unversioned symlink; repeated installation must preserve other versions' metadata. Record build-declared dependencies as they are (D57): a declared dependency that the selected artifacts do not reference by ELF or DBD, such as asyn's calc, sscan, and sequencer, still loads in dependency order, and loading it is expected rather than a defect.
- Install `iocsh.bash` into the selected distribution at `base/bin/<EPICS_HOST_ARCH>/iocsh.bash` (D56). Sourcing that tree's `setEpicsEnv.bash` already places that directory on the executable search path, and `resetEpicsEnv.bash` already removes it; add no new search-path entry and no distribution-top `bin` directory. Setup repetition, switching trees, reset, and repeated base installation must leave the wrapper reachable only through the selected tree.
- Accept `m`, `mod`, and `module` as equivalent wrapper directives in the supplied startup file. Each accepts a literal module name and an optional exact version, in the six forms below. These are startup-file directives consumed before native IOC execution, not commands registered in the interactive IOC shell. The wrapper's show mode, `-n` or `--show`, prints the generated startup and exits without starting the IOC (D62).
- Resolve an omitted version through the unversioned module symlink. Resolve an explicit version through its exact versioned directory. Follow each selected module's recorded dependency versions rather than the dependencies' current default symlinks. Version strings are opaque; do not sort directory names or implement version ranges.
- Validate the needed directories, links, metadata, dependency graph, files, architecture, and Base compatibility during startup preparation. Cache resolved canonical paths and reuse them for libraries, DBDs, DBs, iocsh files, and module macros such as `LINSTAT`. Reject missing inputs, invalid metadata, cycles, and competing versions of one module before launching the IOC.
- Inspect selected ELF files using `readelf`: follow `DT_NEEDED`, search applicable `RUNPATH` entries with `$ORIGIN` relative to each actual library, and compare installed-module ownership and versions with metadata. Classify each resolved dependency as installed-module, distribution-vendor (`vendor/lib`, as `libopcua.so` resolves `libopen62541.so.1`), or system. Include native `softIocPVX` and its Base/PVXS dependencies. Preserve dependencies that exist only at the DBD or data-file level. Reject a selected library that leaves symbols undefined after its `DT_NEEDED` closure, Base, and its dependency modules are considered (D61); observed 2026-10-02 on the local Debian 13 tree, `libdevSnmp.so` names no net-snmp library in `NEEDED` and `dlload` fails with `undefined symbol: usmAESPrivProtocol` (recheck with `ldd -r <tree>/modules/snmp-<version>/lib/<arch>/libdevSnmp.so`). The check counts function and data symbols alike (D65), a rejected library fails its module build until the missing library is named on its link line (D70), the generated Base site configuration links with `--no-as-needed` so a named library is never dropped by its position (D68), the measComp site configuration names uldaq for the support library (D69), and the resolver is the installed `iocsh_elf.bash` that both metadata generation and the wrapper run (D67).
- Treat ELF inspection as validation, not proof of the native loader's actual selection. Account for `RPATH`, environment search paths, preloaded libraries, and system dependencies where relevant; reject detectable conflicting module candidates rather than silently selecting a different installed version. Verify actual loaded paths separately in the real IOC.
- Load each required support library and DBD once in dependency order. Supply Base and required module DBD include directories; issue one wrapper-generated `registerAllRecordDeviceDrivers(pdbbase)` after support loading and before the startup's DB loads and `iocInit`. Reuse support already supplied by native `softIocPVX` and reject incompatible requests for its already-loaded Base/PVXS versions. A library, DBD, or support-registration failure must stop before application DB loading and `iocInit`. One call suffices: in EPICS Base R7.0.10, `registerAllRecordDeviceDrivers.cpp` skips record types, device supports, and drivers already present in the registry and runs registrars and functions through `runRegistrarOnce`, so support that native `softIocPVX` already registered is not registered again; T8 confirms this by observation.
- Preserve the order of ordinary startup commands, the caller's working directory, terminal input, signals, and native process exit status. Wrapper syntax and dependency diagnostics identify the original startup filename and line. Native errors preserve the original message and exit status; run a generated copy of the startup file in which each wrapper directive line is replaced by a comment line, so native line numbers equal the original and only the filename differs, and report that filename mapping without assuming that `IOCSH_STARTUP_SCRIPT` changes native parser diagnostics. Write the copy to a disposable temporary file, open it, unlink it at once, and pass the open descriptor as `/dev/fd/N` to the native executable, as the prototype already does with its generated preamble (D60); nothing remains after `exec` and no cleanup runs after the IOC exits. Wrapper diagnostics name the original file and the `/dev/fd/N` path. The IOC startup owns identity, port configuration, DB loading, common iocsh calls, and `iocInit`.
- Use `tc32sim` as the first integration example with StreamDevice, linStat, retools, autosave, and caPutLog. Resolve dependencies such as asyn and calc automatically from installed metadata. Reuse the real TCP simulator, protocol, DBs, and PVA group definition; use installed commonIocsh fragments for linStat, autosave, and caPutLog. Keep IOC-owned access security, local save storage, and log receiver configuration in the application startup. Use resolved module macros rather than mutable default symlinks. Keep complete IOC examples separate from the loader implementation; prepare and store them later as separate application fixtures.
- Include all three IOCs in the candidate matrix below; exclude IOC applications whose source repository is hosted on GitLab. Adapt their real startup files to installed module declarations and paths while retaining their application DBs, templates, protocol files, and iocsh fragments. Verify every candidate separately through `iocsh.bash` and `softIocPVX`, without compiling an IOC executable or custom support. Keep startup results separate from communication and data-update results.

Out of scope: e3-require integration; runtime downloads or builds; a general package/version-range solver; arbitrary external installation layouts; native interactive `m`/`mod`/`module` commands; directives generated at runtime or inside later `iocshLoad` calls; a global common-service startup file; operational equipment changes; acceptance claims beyond the listed IOCs and tested modules/platforms. Existing build-time `.local` handling remains outside this change.

Directive contract, shown with `module`; replacing that name with `mod` or `m` preserves every form:

```text
module linStat
module "linStat"
module("linStat")
module linStat 1.2.0
module "linStat" "1.2.0"
module("linStat", "1.2.0")
```

The explicit version is illustrative and succeeds only when that exact version is installed. A missing closing parenthesis, extra argument, invalid name, or malformed quoting is an error. Parse literals without `eval`. Recognize directives only as complete startup statements, leaving comments, quoted text in other commands, and ordinary IOC commands intact.

Conflict diagnostic contract:

```text
Module version conflict: linStat
Requested: 1.2.0 at st.cmd:4
Selected:  1.2.1 at st.cmd:2
Use one version of linStat in this IOC.
```

For a transitive conflict, include the dependency chains as well as the source locations; do not continue with a partially selected graph.

##### Completion Criteria

- A freshly installed distribution contains the wrapper and valid per-version metadata generated by the real installation rules; sourcing its setup script makes the wrapper usable without the source checkout or runtime Make.
- All 18 combinations of directive name and syntax work through the shipped wrapper; malformed declarations fail with filename/line diagnostics before native startup.
- Default and exact version selection, transitive dependencies, repeated declarations, library-only/data-only modules, and explicit entry-name exceptions follow installed metadata. Different versions of the same module never coexist in one IOC.
- Validation resolves the selected graph once, reports missing or conflicting inputs clearly, and uses canonical module paths throughout startup even if default symlinks subsequently change.
- RUNPATH/NEEDED inspection detects inconsistent installed-module candidates while retaining DBD-only dependencies; observed native library mappings agree with the selected module versions.
- The real example IOC registers required support, completes `iocInit`, and supplies healthy linStat host/process PVs and the enabled NIC/filesystem PVs. Support loads and wrapper-generated registration are not duplicated.
- The real `tc32sim` integration supplies changing simulator values over CA/PVA with all selected support registered. Defined linStat PVs update, the selected retools command executes with its expected result, autosave persists selected settings and restores them across an actual IOC restart, and a real CA put produces the expected caPutLog entry at a local receiver. Loading libraries alone satisfies none of these functional checks.
- Each of the 3 candidate IOCs has its own startup and data-path evidence through the installed wrapper, with the application revision, adapted startup, installed versions, actual loaded library paths, and measured PV criteria identified. All candidates remain required; one representative IOC does not establish a result for another. Missing prerequisites or unavailable devices/external PVs remain Pending and cannot count as passed checks.
- The installed wrapper survives tree relocation, environment switching/reset, startup filenames containing spaces, interactive input, signals, and native error exits within the tested scope.
- Documentation describes the installed interface and limitations. Required checks run through actual installation, metadata generation, wrapper, installed fragments, libraries, DBDs, databases, and native IOC; all results identify what actually ran.

##### Dependencies And Decisions

- D50 fixes the installed-distribution boundary and install-time metadata; D51 fixes version selection and one-time resolution; D52 fixes directive aliases and diagnostics; D53 includes ELF search validation and actual loader verification.
- D54 excludes GitLab-hosted IOC sources, retains all three public candidates, and requires separate startup and communication/data-update results for each. The candidate matrix describes scope, not verified runtime compatibility.
- No dependency on M3 or M5: the installed commonIocsh fragments already exist; promotion to a separate module repository and a global startup file are separate deliverables.
- M16 concerns installed build-configuration portability; this wrapper's runtime path must not consume those configuration files. Do not use M16 completion as a substitute for the relocation check here.
- Preserve the existing environment selector under D41 and CLOSED_DOORS K9. This work integrates with direct sourcing of the selected tree's setup script.
- D55 makes `tc32sim` the first integration example and requires functional checks for linStat, retools, autosave, and caPutLog. Work is assigned to `iocsh-module-loader`; complete IOC examples remain separate application fixtures.
- D56 places the wrapper in the base executable directory, D57 records declared dependencies without pruning, and D58 keeps the minimal example at `examples/iocsh/st.cmd`; all three were decided at the first plan review on 2026-10-02. D59 fixes the default entry rule with explicit exceptions and was decided at the second plan review on the same date. D60 keeps `exec` and passes the generated startup copy as an unlinked descriptor; it was decided at the second-person review on the same date. D61 adds the undefined-symbol check to ELF validation and was decided at the first implementation review on the same date. D62 records the wrapper's show mode, and D63 records the DBD entry-symbol check with the Base menu include allowance; both were recorded at the third implementation review on the same date. D64 names the representative linStat PVs that the minimal example check reads and was decided on 2026-10-03. D65 makes the undefined-symbol check count functions and data alike, D66 declares a rejected module unloadable with a recorded reason, and D67 places the ELF resolver in one installed tool; all three were decided on 2026-10-03 when the check first ran over the installed inventory. D68 records every named library in `NEEDED` through the generated Base site configuration and removes the snmp declaration; it was decided on 2026-10-03 after the Rocky workflows showed the snmp library resolving there. D69 names uldaq for the measComp support library through the generated site configuration and removes the measComp declaration; it was decided on the same date. D70 removes the declaration mechanism itself, since no module uses it; it was decided on the same date after the workflows passed with D68 and D69. D71 places each application fixture under `examples/iocsh/<ioc>/` with the application checked out at a recorded revision, and D72 adds the asyn port driver DBDs to the entry mapping; both were decided on 2026-10-03 during the first fixture run. D73 checks the opcua-IOC-demo data path against the Eclipse Milo demo server and was decided on the same date after that server was tried.
- No release version or change to the ordering of existing work is assigned by this plan.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-02; the D56-D60 revision, after four third-person reviews and one second-person review, and the D61, D62, and D63 amendments; 2026-10-03 for the D64 through D73 amendments
Implementation Authorization: 2026-10-02; the D56-D60 revision, and the D61, D62, and D63 amendments; 2026-10-03 for the D64 through D73 amendments. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: none

1. Define the metadata contract and explicit module entry mappings alongside the effective module definitions in `configure/`. Check `CONFIG_VARS`, `CONFIG_MODS`, and `CONFIG_MODS_DEPS` for canonical names, special mappings such as sequencer/seq, selected versions, and dependency edges; record declared dependencies without pruning (D57). Apply the default entry rule and enumerate every exception from the installed inventory of all configured modules as listed in Scope (D59), and include the hyphenated name `feed-core` in name parsing. Define the successful-build record and artifact identity used by the installer; retain DBD/data dependency versions even when ELF has no corresponding edge. Cover native Base/PVXS, DBD-only dependencies, and empty artifact lists. Close with T1 and T3.
2. Add successful-build record generation, runtime metadata generation, and installation sequencing through `configure/RULES_MODS_BUILD`, `configure/RULES_FUNC`, and `configure/RULES_INSTALL`. Require a matching build record before installation metadata generation. Write complete validated metadata before alias publication; handle both individual module installation and distribution installation without parse-time filesystem writes. Install the wrapper into `base/bin/<EPICS_HOST_ARCH>/` through `configure/RULES_INSTALL` after base installation (D56), deriving the architecture name from the installed `base/lib/perl/EpicsHostArch.pl` as `scripts/setEpicsEnv.bash` does, because `configure/` defines no `EPICS_HOST_ARCH`; verify that `scripts/setEpicsEnv.bash` and `scripts/resetEpicsEnv.bash` already publish and remove that directory without a new entry. Close with T1 and T9.
3. Replace the prototype's `# modules:`/`RELEASE.local` resolution in `tools/iocsh.bash` with literal directive parsing, installed metadata discovery, exact/default version selection, recursive graph validation, and cached canonical paths. Preserve original source locations for wrapper diagnostics and emit actionable conflict chains; run a line-preserving generated copy whose directive lines become comments, passed as an unlinked `/dev/fd/N` descriptor (D60), and verify the filename-only mapping with a real failing startup. Provide the show mode (D62). Close with T2-T6.
4. Add recursive ELF dependency inspection for the selected native executable and libraries. Expand `$ORIGIN`, inspect applicable search paths, classify installed-module, distribution-vendor, and system dependencies, and compare module ownership/version with metadata. Reject a selected library with undefined symbols at installation (D61, D65, D70), and keep the resolver in `tools/iocsh_elf.bash`, installed beside the wrapper (D67). Keep DBD/data dependencies independent of ELF. Close with T7 and the real loaded-path checks of T8.
5. Generate the native startup sequence: dependency-ordered library/DBD loading, resolved module macros, one wrapper support-registration call, then the ordinary startup commands. Move the prototype startup to `examples/iocsh/st.cmd` (D58) and update it to use module directives and the installed linStat fragment, enabling one NIC and one filesystem through the fragment macros (`NICENABLE=""` with `NIC`, `FSENABLE=""` with `FSID` and `DIR`) and taking the interface name from the environment because it is host-specific. Retain existing environment-selection and native execution behavior where compatible with the contract. Close with T8-T10.
6. Prepare an actual application fixture for every IOC in the candidate matrix from the repository recorded there, identifying its source revision and original startup variant. Adapt only module declarations, installation paths, and test-environment settings; reuse the application's real DBs, templates, protocol files, and iocsh fragments. Start with the real `tc32sim` TCP simulator and add linStat, retools, autosave, and caPutLog through installed support. Prepare disposable local save directories, access security with `TRAPWRITE`, and Base's `iocLogServer` as the local log receiver. Resolve required common iocsh prerequisites from the selected installation before execution. Define each IOC's PV names, record/DTYP expectations, readback or source comparison, update interval, timeout, and expected alarm conditions before running it. Document unavailable prerequisites rather than substituting an empty IOC or replacement driver. Keep complete example applications separately from loader implementation files. Close with T12-T16.
7. Add integration coverage through the actual shipped path and update the mdBook pages `docs/src/procedures/set-up-shell.md`, `docs/src/concepts/installed-tree.md`, `docs/src/concepts/module-set.md`, and `docs/src/reference/tools-and-scripts.md`. Document metadata, examples, version selection, missing-version/conflict messages, the startup-only directive boundary, and the full candidate matrix. Run T1-T16 and record actual observations before marking any criterion complete.

##### Test Plan

Use real candidate installations on Debian 13 and Rocky Linux 8.10 for native runtime coverage. Installation/lint checks also exercise the repository's supported Linux build workflows when changes are published. These are proposed verification targets, not existing results. Prerequisite: a candidate installation produced by this branch on each target. Observed 2026-10-02: the local `~/EPICS-env-distribution/1.3.0/debian-13/7.0.10` tree predates commonIocsh installation and carries no `iocsh.conf` (recheck with `ls <tree>/modules/commonIocsh <tree>/modules/*/cfg/iocsh.conf`), and no Rocky Linux 8.10 tree is identified; both remain Pending prerequisites until prepared. Observed 2026-10-03 on the local Debian 13 host with linStat 1.2.1 and the tracked example: all 315 linStat records are readable and 31 are in alarm for reasons outside the loader, namely `<FSID>:AVAIL` at `LOLO` because the database limits are in bytes while the value arrives in megabytes, records that read unset environment variables, scan helper records before their first period, and host-dependent interrupt and interface counters; with the loopback interface the link speed and duplex records are also `INVALID`. Observed 2026-10-03 on the same host, as a development check that is not a T7 result: the D61 check over the installed inventory of 30 configured modules reports snmp with 27 undefined symbols and measComp with 42, and rgamv2 passes once its asyn dependency is considered; with the two modules declared unloadable, metadata generation passes for all 30, the static inspection of all 28 loadable modules together reports no finding in under one second, and the tracked example starts through the installed wrapper with the selected libraries mapped.

The full candidate matrix contains 3 IOC applications without application-specific compiled support. The primary modules below identify coverage, not complete dependency lists; obtain exact dependencies from the installed metadata and real application inputs. All candidates participate in T12 and T13 on both runtime targets. Record startup and data-path results separately for each IOC and target; equipment or external-PV availability can leave a check Pending, but cannot remove an IOC from the matrix or turn an unexecuted check into a pass. Use real test devices or sources when available; an explicitly identified simulator at the external boundary establishes simulated coverage only.

| IOC | Source | Primary modules | Application coverage |
| --- | --- | --- | --- |
| `tc32sim` | <https://github.com/jeonghanlee/tc32sim> | `StreamDevice`, `asyn`, `pvxs`, `linStat`, `retools`, `autosave`, `caPutLog` | First integration example: actual TCP simulator, temperature records, PVA groups, monitoring, restart restoration, and CA put logging |
| `EPICS-IOC-Demo` | <https://github.com/jeonghanlee/EPICS-IOC-Demo> | `StreamDevice`, `asyn` | Actual training-device startup and DBs |
| `opcua-IOC-demo` | <https://github.com/jeonghanlee/opcua-IOC-demo> | `opcua` | Sessions, subscriptions, and application records |

Candidate selection excludes IOC applications whose source repository is hosted on GitLab. The retained applications are `tc32sim`, `EPICS-IOC-Demo`, and `opcua-IOC-demo`, whose source repositories recorded above are on GitHub; step 6 records the exact revision each fixture uses. IOCs with application-specific C/C++ or sequencer support remain outside this no-IOC-compilation matrix. Preserve all three selected candidates even when later execution exposes a missing dependency.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Installation and metadata | Run the actual module build and individual-module/distribution installation paths, repeat installation, repeat base installation into the existing tree, change pins without rebuilding, and inspect generated metadata and alias publication order; run shipped read-only Make queries and compare filesystem inventories | Disposable real build/install roots; candidate configure rules | Successful-build records and installed artifacts agree with effective identities, versions, exact dependencies, entry lists, architecture, and relative paths agree with installed artifacts; aliases expose complete metadata; stale build identities fail; a module whose default-rule files are absent without an exception fails metadata generation, and a candidate DBD that defines a Base menu or record type with a body is rejected (D59); a DBD with an entry that no selected, dependency, Base, or PVXS library exports is rejected, and a record DBD that includes a Base menu file is accepted (D63); a source checkout that is not at the pinned tag fails the build record; other versions survive; the wrapper is present after repeated base installation; queries create no files |
| T2 | Directive syntax | Run the installed wrapper with all six forms for each of `m`, `mod`, and `module`, default and a genuinely installed exact version, comparing the generated startups through the show mode (D62) and loading the default and the exact selection in the real IOC; include comments, whitespace, duplicate declarations, a hyphenated module name such as `feed-core`, and ordinary commands containing the same words | Real generated metadata and libraries on both runtime targets | All 18 forms produce the same intended selection; ordinary commands retain their order and text; each support entry loads once |
| T3 | Dependency graph and entry mapping | Start through real StreamDevice, linStat, and representative library-only/data-only modules; inspect ordered support loads, installed DB/DBD includes, and macros | Real installed modules, including explicit entry-name exceptions and generated metadata | Dependencies precede consumers; calc remains available for StreamDevice DBD support even when absent from its ELF `NEEDED` list; declared dependencies load even when the consumer's ELF and DBD do not reference them (D57); test/example artifacts are not loaded; data-only entries require no invented library |
| T4 | Multiple versions | Build and install two real versions of linStat, which has no module dependencies, using the actual rules; select each explicitly and through the default symlink, and exercise a recorded dependency version that differs from the default alias with StreamDevice against asyn | Two real versioned installations of the same module with generated metadata; both runtime targets | Explicit selection is exact, default follows the alias, and dependencies use recorded versions; an unavailable example version fails; renaming one binary is not multi-version coverage |
| T5 | Resolved paths | Resolve a startup, change default symlinks at the filesystem boundary before native execution, and observe library mappings, DBD/DB paths, and exported module macros; also test a broken selected link | Disposable real installed trees; observation-only tracing or process suspension | The current startup uses cached canonical paths consistently; a subsequent invocation sees the changed default; invalid links fail during preparation |
| T6 | Failure diagnostics | Invoke the shipped wrapper, in the show mode and in a real start, on malformed declarations, extra arguments, missing names/versions/files/metadata, format and architecture mismatches, cycles, direct/transitive version conflicts, native Base/PVXS version conflicts, and malformed metadata; inject filesystem faults only into copies of real generated packages | Real wrapper and generated metadata; controlled filesystem boundary changes | Nonzero exit before IOC launch for graph/syntax failures; message identifies the module, relevant versions, file/line or dependency chains, and a corrective action; no eval or silent fallback |
| T7 | ELF search validation | Inspect actual native executable and libraries through the shipped resolver; vary `RUNPATH`-resolved module availability and environment search candidates, including a wrong installed version; inspect real DBD-only dependencies | Real ELF binaries and generated metadata; disposable installed trees on both runtime targets | `ORIGIN` is based on each real object; metadata/ELF mismatches are explained; detectable conflicting candidates fail; vendor and system libraries are distinguished from installed modules; a selected library with undefined symbols is rejected at installation (D61); static inspection is never reported as proof of native binding |
| T8 | IOC and data path | Execute the tracked `examples/iocsh/st.cmd` with the installed wrapper, installed commonIocsh linStat fragment, real DBs, libraries, and DBDs; inspect actual process library maps and read the representative linStat PVs of D64 after one scan period and again after the next, with `NIC` naming a physical interface; exercise actual support-load failure using filesystem faults in disposable copies | Both runtime targets; actual `softIocPVX` and real CA/PVA clients; dedicated CA and PVA server ports when the host runs other EPICS servers, because linStat rescans through a CA link to its own PV | `iocInit` completes; the representative PVs are readable with `NO_ALARM`, and `MEM_FREE` advances its timestamp between the two reads; selected versions match actual mappings; support entries and wrapper-generated registration appear once; no missing DSET or unknown record/device support; an injected support-load failure prevents application DB loading and `iocInit` |
| T9 | Environment and process lifecycle | Source actual setup repeatedly, switch between two installed trees, reset, and invoke the wrapper with inherited and explicit selection; use a PTY for stdin, send signals, trigger an actual native startup error, and inspect PID/cwd/status; end non-interactive runs by signal, because `softIocPVX -S` keeps running after the startup file ends, including after an `exit` command (observed 2026-10-02 on the local Debian 13 tree) | Fresh Bash children with nounset on/off; real installed scripts and IOC | Correct executable/tree is selected; the base executable path carrying the wrapper is removed after reset; caller shell survives setup/reset; IOC owns terminal input and receives signals; native messages, exit status, and working directory are preserved; a real native startup error reports the original line number through the line-preserving generated copy and its recorded filename mapping |
| T10 | Relocation and runtime independence | Move/copy a real installed candidate tree to a path with spaces; make its original tree and build checkout unavailable; deny access to installed `.local` files at the filesystem boundary; run actual startup while tracing file/exec access | Disposable relocated installation on both runtime targets | Startup succeeds solely from relocated artifacts and metadata; no runtime Make, checkout, or `.local` reads; macros and actual library/DB paths remain inside the selected tree except legitimate system dependencies |
| T11 | Documentation and integration | Run Bash syntax/ShellCheck checks, build the mdBook without changing sources, execute documented wrapper examples, and read supported Linux install/lint workflow results after publication | Candidate source and actual installed trees; repository CI | Interface, installation paths, grammar, and diagnostics match the implementation; changed paths pass their normal checks; no claim extends to untested equipment, modules, or platforms |
| T12 | All candidate IOC startups | Run each of the 3 actual application fixtures through the installed wrapper and native executable; inspect support loads, DB/template/protocol and nested iocsh resolution, record/DTYP inventory, process library maps, and `iocInit` | Both runtime targets; real installed modules and application files; no custom IOC executable or substitute internal driver | Every IOC has its own result; required files and support resolve, selected library versions match actual mappings, expected records exist, and `iocInit` completes without missing DSET or unknown commands/record types; an unavailable prerequisite remains Pending |
| T13 | All candidate IOC data paths | Read each fixture's predefined PVs through real CA/PVA clients; compare device readbacks or external-source values, timestamps/updates, alarm conditions, and timeouts with the fixture criteria; identify simulator use separately | Both runtime targets; real IOC records and drivers; available test devices or external PV sources | Every IOC has separate data-path evidence; required values and updates meet the recorded criteria, and offline alarms are distinguished from loader failures; missing equipment or source PVs remain Pending, and neither `iocInit` alone nor an offline run establishes successful communication |
| T14 | tc32sim monitoring and retools | Start the actual TCP simulator and adapted tc32sim startup with all five selected modules through the installed wrapper; observe changing CA/PVA values and defined linStat host/process/NIC/filesystem PVs; execute retools `reGrep` against a fixture record name with its predefined expected output (the installed retools tree carries no documentation; its library exports `reGrep`, `reAddAlias`, `reAddInfo`, `reGetField`, `rePutField`, and `reTest`) | Both runtime targets; real simulator, protocol, application DBs, commonIocsh fragments, and native support | The simulator-to-record-to-CA/PVA path runs with the selected modules loaded once; linStat readings meet the fixture update/alarm criteria; the retools command resolves and returns the expected result; the evidence describes simulated device coverage |
| T15 | autosave restart restoration | Use the actual autosave fragment and request generation with selected autosave-tagged fields in the tc32sim fixture; change those settings through CA, observe their save-file contents, stop the IOC, and restart through the installed wrapper using the same disposable save directory | Both runtime targets; real autosave library, DB annotations, request/save files, and native IOC lifecycle | Selected settings are saved and restored to the expected values after restart; status records and file contents agree; a file created by the test in place of autosave output does not satisfy the check |
| T16 | caPutLog reception | Load IOC-owned access security with TRAPWRITE before iocInit and initialize caPutLog through its actual installed fragment after access security is active; change a fixture PV through a real CA client and inspect Base's `iocLogServer` from `base/bin/<EPICS_HOST_ARCH>` listening on the fragment's `LOG_INET_PORT` (default 7004) as the local receiver | Both runtime targets; real CA client, caPutLog library/fragment, access security, and local receiver | The received log entry identifies the selected PV and changed value under the configured logging mode; successful IOC startup, an internal dbpf call, or a PVA-only write does not establish CA put logging |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; partial CI observation at 2026-10-03T07:15:16Z (UTC) | GitHub Actions on `iocsh-module-loader` at `862841b31435421ff4a260aeee8082b3a6eb9ba3` | Pending: on six OS workflows the real build and install rules ran the build record, metadata generation, source-pin comparison, alias check, and wrapper installation without a tool error, and the post-install gates passed; the generated files were not inspected, and repeated installation, a pin change without rebuilding, a second installed version, and the read-only query comparison have not run | Debian 12 37104451152, Debian 13 37104451131, Rocky 8 37104451149, Rocky 10 37104451128, Ubuntu 24.04 37104451116, Ubuntu 26.04 37104451151, Linter 37104451132; the Debian 13 and Rocky 8 logs show 32 module source trees built and no `iocsh_metadata.bash` error line |
| T2 | Not run | Real candidate wrapper | Pending | none |
| T3 | Not run | Real installed module graph | Pending | none |
| T4 | Not run | Two real installed module versions | Pending | none |
| T5 | Not run | Real installation with controlled symlink changes | Pending | none |
| T6 | Not run | Real wrapper with filesystem fault cases | Pending | none |
| T7 | Not run | Real ELF binaries and resolver | Pending | none |
| T8 | Not run | Actual `softIocPVX` and linStat PVs | Pending | none |
| T9 | Not run | Actual setup/reset and native process | Pending | none |
| T10 | Not run | Relocated candidate installation | Pending | none |
| T11 | Not run | Documentation, lint, and supported Linux workflows | Pending | none |
| T12 | Not run | All three application fixtures through installed wrapper and softIocPVX | Pending | none |
| T13 | Not run | All three application data paths and their required devices or PV sources | Pending | none |
| T14 | Not run | Actual tc32sim simulator, monitoring, and retools | Pending | none |
| T15 | Not run | Actual autosave save and restart restoration | Pending | none |
| T16 | Not run | Actual CA put and local caPutLog receiver | Pending | none |

Prototype observations and static candidate inspection do not verify this metadata, syntax, version-selection, RUNPATH design, or candidate IOC execution. All three candidate startup and data-path results are currently Not run. Record each IOC/target result separately before rolling up T12 or T13. A substitute parser, hand-authored replacement metadata, mocked internal loader, or copied binary renamed as a second version cannot establish acceptance.

##### Closure Evidence

- None.

##### GitHub Projection

Title: Load installed EPICS modules with iocsh.bash and softIocPVX
Labels: enhancement
GitHub Milestone: Backlog
Assignee: jeonghanlee
Observed State: OPEN
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-04 02:32:06 UTC via `gh issue view 93 --repo jeonghanlee/EPICS-env`; GitHub updated at 2026-10-04T02:32:06Z; title, body, labels, milestone, and assignee match the accepted plan projection with the D61 through D73 amendments.

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m1---epicspath-normalizerelpath) |
| Build | M2 | Teach the module generator the correct per-module source-base URLs | Milestone | Not started | Yes | M6, D15 | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m2---generator-src-url-overrides) |
| IOC shell | M3 | Promote commonIocsh to its public module repository | Milestone | Not started | No | D2, D7 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m3---commoniocsh-promotion) |
| IOC shell | M5 | Ship a global iocsh startup file for the common services | Milestone | Not started | No | D8 | `commonIocsh/iocsh/` ships one global startup file that loads the common-service fragments with optional serial configuration, and an example IOC boots with only that file; [detail](#m5---global-iocsh-startup-file) |
| Libera | M20 | Verify the Libera cross-build and generated profile | Milestone | Deferred | No | D42 | Real nine-module cross-build, generated-profile repetition, and documentation comparison pass; excluded from M14 completion; [detail](#m20---libera-cross-build-and-generated-profile) |
| macOS | M21 | Verify patch revert on actual macOS | Milestone | Deferred | No | D49 | Real macOS patch-revert cases pass with the Darwin mca path active, recorded patch executable, and preserved failure-boundary inventories; excluded from M15 completion; [detail](#m21---macos-patch-revert-verification) |

### Backlog Details

#### M1 - EPICS::Path Normalize/RelPath

Origin: 84ee626 / M1
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

#### M2 - Generator SRC URL Overrides

Origin: 84ee626 / M2
Identity History: none
GitHub Issue: #75, https://github.com/jeonghanlee/EPICS-env/issues/75
Status: Not started

##### Summary

The `MODULESGEN.mk` generator rule in `configure/CONFIG_MODS` writes `$(SRC_URL_EPICSMODULES)/<name>` uniformly for every module. Twelve modules live outside `epics-modules` — RECSYNC, RETOOLS, STREAM, SNMP, MOTORSIM, PVXS, PMAC, PSCDRV, LINSTAT, FEEDCORE, QPC, RGAMV2 — so `configure/CONFIG_MODS` re-defines their `SRC_GITURL_*` after the include; the effective make values are correct and builds are unaffected. The generated `configure/MODULESGEN.mk` is git-untracked (gitignored), so the twelve stale lines mislead only a maintainer who opens their own generated copy, not a reader of the committed tree. The improvement is to have the generator emit the correct base URL per module so the generated file no longer carries stale values.

##### Scope

- Teach the generator to select the correct source base per module instead of always using `SRC_URL_EPICSMODULES`, covering all twelve non-`epics-modules` modules above. The base is not derivable from the module name (RECSYNC uses `SRC_URL_CHANNELFINDER`; `SRC_URL_MD` is shared by PSCDRV and LINSTAT; `SRC_URL_JEONGHANLEE` by SNMP, QPC, and RGAMV2), so the special-case map must be carried explicitly. The chosen approach (Option A or B below) fixes which files change.
- After the generator emits correct URLs, remove the now-redundant `SRC_GITURL_*` re-definitions from `configure/CONFIG_MODS` (lines 36-54). This step must follow the generator change, never precede it.
- State where a maintainer declares the base for a new non-`epics-modules` module after this change.
- Update the mdBook book written by M6 wherever it describes the module source-URL mechanism, so it agrees with the changed code.

Out of scope: changing any effective URL (all twelve are already correct); the `INSTALL_LOCATION_*` and `SRC_PATH_*` generator output and the `seq` and `recsync-src/client` special cases; and `configure/RELEASE` edits unless the chosen approach is Option A.

##### Completion Criteria

- The current effective values are captured as a baseline (`make print-SRC_GITURL_<M>` for the twelve modules on the unmodified tree).
- The generated `configure/MODULESGEN.mk` carries the correct base URL for all twelve modules, with no `SRC_GITURL_*` re-definition left in `configure/CONFIG_MODS`.
- The post-change effective `make print-SRC_GITURL_*` equals the captured baseline for every module — not merely equal to the regenerated file, which is circular once the override is gone.
- A clone of the twelve modules resolves and the build is unchanged.
- The procedure for declaring a new non-`epics-modules` module's base is documented where the chosen approach places it.
- The mdBook book describes the changed source-URL mechanism and no longer describes the removed `SRC_GITURL_*` re-definitions.

##### Dependencies And Decisions

- Parked to the Backlog per D1; the design decision below is deferred until it is revisited.
- D15: starts after M6 is Complete, and updates the book M6 wrote.
- Open design decision. Option A: declare per-module base variables in `configure/RELEASE` and add a one-line generator fallback; keeps the generator uniform and co-locates each base with its module, but edits `configure/RELEASE` and either duplicates a shared base or adds an indirection layer. Option B: carry a module-to-base table inside the `configure/CONFIG_MODS` generator rule; leaves `configure/RELEASE` untouched and confines the change to one file, but moves the special-case knowledge into the shell-echo loop and reduces readability. Either way the twelve non-mechanical lines move rather than disappear.

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
6. Update the mdBook book written by M6 wherever it describes the module source-URL mechanism, and rebuild it with `mdbook build docs`.

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
Last Compared: 2026-09-26

#### M3 - commonIocsh Promotion

Origin: 84ee626 / M3
Identity History: none
GitHub Issue: #76, https://github.com/jeonghanlee/EPICS-env/issues/76
Status: Not started

##### Summary

The `commonIocsh` fragments and the global iocsh are developed and held in EPICS-env during 1.4.0 M6 (D2 interim home). Their durable home is a dedicated public module named `commonIocsh` with its own repository, pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP` (D2). 1.4.0 M6 verification is complete on the interim home (T1/T2/T3 on the two OS targets, D6); the promotion itself is deferred to this item per D7.

##### Scope

- Create the public `commonIocsh` repository from the interim in-tree fragments, preserving the `iocsh/` layout.
- Pin `commonIocsh` in EPICS-env's `configure/RELEASE` like every other module and install it under `modules/commonIocsh/`.
- Remove the interim in-tree copy from EPICS-env once the pinned module builds and installs.

Out of scope: any change to the fragment behavior verified under 1.4.0 M6; the `siteApps` de-duplication (D3), which is the site owner's.

##### Completion Criteria

- The `commonIocsh` public repository exists and carries the verified fragments.
- EPICS-env pins `commonIocsh` in `configure/RELEASE` and installs it under `modules/commonIocsh/iocsh/`, resolved through `IOCSH_TOP`.
- The interim in-tree fragments are removed, and the installed-path checks (T1/T2/T3) still pass on the two OS targets against the pinned module.

##### Dependencies And Decisions

- D2 sets the durable home: a dedicated public `commonIocsh` module, pinned and reached through `IOCSH_TOP`.
- D7 defers the promotion from 1.4.0 M6 to this Backlog item; 1.4.0 M6 completes on the interim EPICS-env home.

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
| T1 | Pinned-module install | Pin and install `commonIocsh`, remove the interim copy, and run the installed-path suite against the pinned module | Target-OS VMs (Debian 13, Rocky Linux 8.10, D6) | The suite passes against the pinned module with no interim in-tree copy present |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Target-OS VMs | Pending | none |

##### Closure Evidence

- None; deferred to the Backlog per D7.

##### GitHub Projection

Title: Promote commonIocsh to its public module repository
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-21

#### M5 - Global iocsh Startup File

Origin: 84ee626 / M5
Identity History: none
GitHub Issue: #79, https://github.com/jeonghanlee/EPICS-env/issues/79
Status: Not started

##### Summary

1.4.0 M6 shipped the `commonIocsh` fragment set and verified the services loading together in one IOC, but no single global iocsh file ships, and the example IOC exercises only the caPutLog fragment (`examples/commonIocsh/README.md`). D8 (2026-09-24) deferred the global startup file here.

##### Scope

- Add one global startup file under `commonIocsh/iocsh/` that loads the common-service fragments, with the optional IOC-owned serial configuration of D4 and D5.
- Make the example IOC boot with only that file for the common services.

Out of scope: changes to the individual fragments verified under 1.4.0 M6, and the D2 promotion tracked as M3.

##### Completion Criteria

- The global startup file loads the common services in one call and applies serial settings only when serial configuration is supplied.
- The example IOC passes the integrated checks using only the global startup file for the common services, on Debian 13 and Rocky Linux 8.10 (D6).

##### Dependencies And Decisions

- D8 defers the global startup file from 1.4.0 M6 to this item.

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

#### M20 - Libera Cross-Build And Generated Profile

Origin: 84ee626 / M20
Identity History: Libera scope split from M14 to Backlog on 2026-09-30 (D42); original acceptance, implementation, and verification evidence retained; original #87 Libera requirements retained here on 2026-10-01
GitHub Issue: none; #87 is the historical source of the Libera requirements and remains linked to native M14
Status: Deferred

##### Summary

The Libera module script uses the current sequencer targets in published commit `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. Its actual cross-build, generated-profile repetition, and documentation comparison require a real compiler, sysroot, and installed host/ARM base. These checks are separate from native environment-script completion.

##### Scope

- Preserve the published `scripts/build_modules_libera.bash` identifier correction from `sequencer-2-2` to `sequencer`, with `seq` as the installed link name.
- Retain the original #87 requirement to verify the obsolete target correction through actual `build_modules_libera.bash` execution against the real installed tree and current make targets; T1 owns that execution.
- Verify the real nine-module cross-build, installed profile, and repeated setup/reset using that profile.
- Maintain `docs/libera-cross-build.md` as the separate functional reference and verification requirements, linked from `scripts/README.md`.

Out of scope: relocation of either Libera script; changes to `build_base_libera.bash`, compiler or sysroot, module pins, configuration rules, or target-board `/opt` mapping; native M14 completion; target-board runtime verification.

##### Completion Criteria

1. The real module script completes all nine build/install/symlink sequences, including current sequencer targets, and `modules/seq` resolves to the installed sequencer directory.
2. The actual installed profile has mode 0444 and nine target-board library paths independently derived from real make locations and the existing `/opt` mapping.
3. Repeated installed setup with the generated profile preserves directory order and retains each profile directory and the base library once. Unrelated library fields retain their bytes, duplicates, order, and empty fields. Reset removes the base library entry and retains the profile entries.
4. The dedicated reference agrees with actual prompts, module order, targets, links, profile bytes, and installation mode. All three actual checks pass; target queries, native products, or an invented profile do not count.

##### Dependencies And Decisions

- D42, Decision Date: 2026-09-30, excludes Libera checks from M14 completion and retains them as Deferred Backlog work. The selected extraction separates the document and preserves both script paths. Resume requires a new execution decision; no cross-build pass or Keep is inferred.
- Decision Date: 2026-10-01; retain only #87's Libera items here. Keep #87 as the native setup/reset issue linked to M14; its closure does not complete, retire, or authorize execution of any M20 check.
- Actual verification requires the real `arm-xilinx-linux-gnueabi` compiler and target sysroot selected by the shipped site file, and installed base products for both `linux-x86_64` and `linux-arm`.
- The configured compiler was absent when inspected on 2026-09-30. This is an unavailable preparation input, not a verification pass.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-30; retains the Libera requirements of the accepted combined M14 plan; D42 authorizes their extraction without changing the requirements
Implementation Authorization: 2026-09-30; original combined M14 implementation authority covered the identifier correction; actual Libera execution is subsequently deferred by D42
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

The following premise observations come from the accepted combined M14 plan at baseline `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`. Their original T labels refer to that combined plan: original M14 / T7 maps to M20 / T1, its T3 profile case maps to M20 / T2, and its T8 Libera comparison maps to M20 / T3.

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
| T1 | Not run; deferred on 2026-09-30 | Real Libera compiler/sysroot unavailable | Pending: current sequencer targets and native seq mapping were inspected; no actual Libera script or cross-build pass is claimed | `work/m14-implementation-20260930/verification-summary.json`, `target-query.stdout`, and D42 |
| T2 | Not run; deferred on 2026-09-30 | Actual cross-build installation and generated profile unavailable | Pending: native path cases do not verify actual generated-profile repetition | `work/m14-implementation-20260930/shell-final/summary.json` records the unexecuted profile case; D42 |
| T3 | Not run; deferred on 2026-09-30 | Actual Libera outputs unavailable | Pending: source/reference extraction and local link checks do not verify runtime assertions | `work/m14-implementation-20260930/verification-summary.json` and D42 |

##### Closure Evidence

- The identifier correction, dedicated reference, README link, and D42 scope separation are published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` on `origin/master`, with publication confirmed at 2026-10-01T06:44:52.634205+00:00. This is source and document publication evidence; it does not complete or retire the deferred cross-build work.
- All three actual Libera checks remain Pending. Native CI success does not verify cross-build or generated-profile execution.

#### M21 - macOS Patch-Revert Verification

Origin: 84ee626 / M21
Identity History: Unexecuted macOS verification subset separated from M15 / T2 to Backlog on 2026-10-01 (D49)
GitHub Issue: none; #88 remains linked to M15 and is the source of the patch-revert scope
Status: Deferred

##### Summary

M15 verifies patch revert on actual Rocky Linux 10.2. Its Linux mca target
is inactive; no real macOS execution is recorded. This separate work retains
native macOS patch-revert verification, including the active Darwin mca
target, without delaying M15 completion or changing its runtime code.

##### Scope

- Verify the shipped individual and aggregate revert targets on actual macOS
  with real pinned sources and patch files, preserving the Darwin condition.
- Exercise the active `patch.mca.apply` and `patch.mca.revert` paths with
  confirmed unapplied, applied, repeated, conflicting, and missing-input states.
- Verify whole-patch classification, reverse order, stack prefixes, independent
  source edits, existing backups, and errors through the shared revert helper.
- Record actual command resolution, versions, source pins, statuses, outputs,
  and source inventories, including ignored rejection and backup files.

Out of scope: M15's completed Linux checks; std cleanup or general macOS build
qualification; changes to module pins, patch contents, apply recipes, or
platform conditions; Libera M20; other milestone work.

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

- D49, Decision Date: 2026-10-01, retains this scope as Deferred Backlog and
  excludes it from M15 completion. A new execution decision is required to
  resume; no macOS verification pass or Keep is inferred.
- Preparation must inspect the commands actually selected by the macOS
  environment, including whether the selected patch supports the shipped
  GNU patch options. Missing preparation inputs are not successful checks.
- The Linux ptrace observer used by M15 is not a macOS observation procedure.
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
| T1 | Not run; deferred on 2026-10-01 | Actual macOS execution not performed | Pending: M15's Linux inactive mca result does not verify the active Darwin path or native helper execution | D49; M15 / T2 records only the executed Linux scope |
| T2 | Not run; deferred on 2026-10-01 | Native macOS boundary observation not prepared or executed | Pending: no macOS failure-preservation result is claimed | D49; native observation procedure requires review before execution |

##### Closure Evidence

- None. The scope separation records Deferred work only; M15 publication or
  #88 closure does not complete, retire, or authorize execution of M21.

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-09-25 | `84ee62697e4da0fff141cf5e97af77357d8ce58a` (`docs/milestone-1.4.0.md`) |
