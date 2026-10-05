# Work Register

Release line: master
Milestone index: 84ee626
Canonical path: `docs/milestone-84ee626.md`
Canonical branch or ref: `master`
Git upstream: `origin/master`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone Backlog, number 3

Next session entry point: M23 ran on `iocsh-module-loader`, which is now merged into `master`, under the plan in `docs/milestone-84ee626.md`, accepted and authorized on 2026-10-02 with amendments through D79 on 2026-10-03 and D80 through D83 on 2026-10-04. D80 through D83 are implemented in the tools, the tc32sim fixture, and the book. Implementation Plan steps 1 through 6 are implemented: the metadata contract and entry mapping, the build and install wiring, the wrapper `tools/iocsh.bash`, the ELF validation in `tools/iocsh_elf.bash` with the link settings of D73 and D74, the minimal example `examples/iocsh/st.cmd`, and the three application fixtures under `examples/iocsh/` with their expected results in each `README.md`. All six OS workflows and the Linter succeed at `effde53dfe0ad30c1a9a7e48b960e21ee48a30f7` and at `ec795cbdc6de1c2d39534cb9c115bd004b87c04c`, the merge of `master` through `fbc01a5`. The branch now includes `master` through `ce22dcd`, which removed the relocation mechanism of M16 again (M22, D54): outside this register and `docs/CLOSED_DOORS.md` the tree equals `effde53dfe0ad30c1a9a7e48b960e21ee48a30f7`, so module builds and installs no longer run under a metadata writer and `install.iocsh` is part of the full install. Because `master` uses M22, D54, and K11, this work was renumbered from M22 to M23, its decisions from D54-D78 to D55-D79 after the earlier change from D50-D74, and its closed-door record from K11 to K12. All six OS workflows and the Linter also succeed at `66ee33a52a50dbb38db43e720dbe7b0cd2f3c96e`, the merged state, and at `841f939786eb4f81f3dffc9f8d8ed3f89581aedf`, which carries the D80 through D83 implementation. Issue #93 matches the plan through D83 and carries the verification results as of 2026-10-04 17:24:00 UTC; it stays open. Step 7 has its mdBook pages updated: the four pages of the plan, the `install` target lists of `reference/make-targets.md` and `concepts/build-pipeline.md`, and the loader declarations in `procedures/add-or-bump-module.md`; the book builds with the documented image. On 2026-10-04, T1 through T16 ran on both targets against candidates built from `ec795cbdc6de1c2d39534cb9c115bd004b87c04c`, a state that still carried the relocation writer; those runs are not recorded as results. A second run on 2026-10-04, on candidates built on both targets from the tree that implements D80 through D83, passed every check of T1 through T16, with the opcua-IOC-demo data path of the original startup not run; those results are recorded in Verification Results against `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`. Three observations from the runs that lie outside the loader checks are Backlog M24: one is closed as K13, one became the work M25, a Base site patch under D84, and one is corrected by the truncation check of D87; M24 is complete, and all six OS workflows and the Linter succeed at `fd4dcf1ff28c10e6948ef9f9ee908b035e9ea0bf`, which carries that check. M25 has its patch, its record, and the revert correction of D85 in place and verified on both targets; its issue is #94, and all six OS workflows and the Linter succeed with the patch at `4ee9282d72a83fee5f4de2c7017fdb7ea4edf316`, so its four criteria were met for the patch as `7.0.10.base.p0.patch`. D88 then moved the patch into the carry set of EPICS base as `7.0.10-site01-dbyacc-eof.p0.patch` and removed the earlier patch family with its three targets; for that state M25 / T2 and T4 pass on 2026-10-05. Commit `4ee9282d72a83fee5f4de2c7017fdb7ea4edf316` also corrects the recovery steps that the refusal message and the book give after a refused metadata generation; those corrections were checked on Debian 13 by a measComp recovery run and by the fixture commands, and the full T1 through T16 run was not repeated on that commit. Under D86 the Milo variant of D78 is the opcua-IOC-demo data-path evidence, and the data path of the original startup is Backlog M26, Deferred until the Unified Automation example server is available. A coherence review of the whole branch on 2026-10-04 led to corrections published in `50ca0c8`, `9d6632d`, and `796083ca8a563eda23bea35256c3d10f50b226c2`: the truncation message of metadata generation, the link rule for an empty module directory (D89), the refusal message, book and register corrections, and the closed-door records K14 through K16. T1 through T16 are recorded against `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`; on 2026-10-05 every script ran again without a failed check on candidates built from `796083ca8a563eda23bea35256c3d10f50b226c2` on Debian 13 and Rocky Linux 8.10, and all six OS workflows and the Linter succeed at that commit. The branch is on `master`: `35a845118042a11e0f8bdf2f9748c9136bac05d9` merges `master` through `df04cf1` and all six OS workflows, the Linter, and the documentation deployment succeed at it, observed 2026-10-05T02:35Z. Issues #93 and #94 carry the corrected bodies and are closed as completed, observed 2026-10-05T02:59Z, so M23 and M25 are Complete. The loader work is Complete on `master`: M23, M25, M27, M28, and M29; M26 stays Deferred. M2 is Complete as of 2026-10-05. The next work in the order of D98 is M17, M18, M19, and then M1 under D52; M3 and M5 are Deferred under D97. M29, the installed opcua configuration, is Complete as of 2026-10-05.

Existing work context: The expanded M16 (#89) relocation plan under D50 was accepted on 2026-10-02 (America/Los_Angeles) in its Python-based form, including installed dependency normalization, explicit refresh after a move, real downstream/metadata/service tests, recovery behavior, and all accepted review findings. M16 implementation and local native verification are recorded on 2026-10-02: T1-T5 pass; T6 local checks and independent Debian consumers pass, while exact published-commit CI remains Pending. D51 (2026-10-02) replaces the Python utility with a Perl implementation, so those results belong to the superseded Python implementation. The D51 plan revision was accepted and its implementation authorized on 2026-10-03. The Perl implementation, its documentation, and this record are committed on `master`; the implementation commit precedes this record. T1-T5 pass on Rocky Linux 8.10 and Debian 13 (T1-T4 2026-10-03, T5 2026-10-04 UTC); the local portion of T6 and the reader review of the changed documentation pass. Both commits are on `origin/master`, and T6 passes with all eight workflows on the pushed commit, so T1-T6 pass. #89's body matches the published implementation and results, and #89 was closed as completed at 2026-10-04T06:14:49Z. M16 is Complete on 2026-10-03 (America/Los_Angeles). The untracked `tools/relocate_installed_tree.py` was removed after closure (owner decision 2026-10-03). D54 (2026-10-04) retires that mechanism: the environment is cloned whole and nothing reads the installed text metadata (K11), so M22 reverted `965a9a2` on `master` as `c1d38fdb2f5354636fb211c78dccd9dcae073f26`; T1-T3 pass, both commits are on `origin/master`, and M22 is Complete on 2026-10-04. The #89 lead paragraph and retirement comment record the removal (2026-10-04T08:46:00Z). D52 (2026-10-02) assigns M1 (#25, `EPICS::Path` primitives for `makeRPath`) to the Milestone as a local base patch, worked after M16 completes. M15's closure record is published in `1219c9223dd4380852f30104e9abcb2d553a455a` on `origin/master`. M14 (#87) is Complete on 2026-10-01. Its native implementation is published in `5a610a89c922220c55eecb6820056bc1e9cdea1f`; the separate Libera correction/reference and shared verification record are published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` on `origin/master`. Native T1-T7 pass, the shell matrix passes 130 cases, and all six OS workflows, Linter, and documentation deployment succeed. #87's body now matches the native scope and all seven acceptance criteria are checked; it was closed as completed at 2026-10-01T07:09:47Z and read back at 2026-10-01T07:10:05.214Z. D41 and K9 preserve selector code and direct-source selection. D42 retains Libera cross-build, actual generated-profile repetition, and output comparison in Deferred Backlog M20, with all three checks Pending; the original #87 Libera items belong only to M20. M15 (#88) is Complete on 2026-10-01 (America/Los_Angeles). The native implementation and verification record are published in `6e58d422ec33233edd21d2c529923971ec2445a3` on `origin/master`; T1-T3 pass and all eight push workflows succeed. The issue body matches the implementation and actual results, all six acceptance criteria are checked, and #88 was closed as completed at 2026-10-02T01:44:37Z; closure was read back at 2026-10-02T02:27:24Z. D47 preserves the exact motor-generated-file exception, K10 retains both patch contents and apply behavior, and D48's function-location checks are verified. D49 retains actual macOS patch-revert verification as Deferred Backlog M21 with both checks Pending; M15 closure completes no M21 check. EPICS-env 1.4.0 is released and closed (RELEASED 2026-09-24; closure commit `84ee626`). M4 (CI workflow triggers and OS set, #78), worked on `master` by D10, is Complete on 2026-09-26 and #78 is closed. M6 (documentation rewrite from the current code, mdBook as its main home), worked on `master` by D14, is Complete on 2026-09-28: the book is published from `master`, the agent procedures and READMEs agree with it, and T1-T4 pass. D17 adds M7, M8, and M9 for the code defects the documentation work found. M8 (unused site-template removal, #82) is Complete on 2026-09-28 and #82 is closed. M7 (`IOCSH_TOP` unification under D22, #81) is Complete on 2026-09-28 and #81 is closed. D23 splits the remaining inventory defects into M9 (C17 bridge, D19) and M10-M19. M9 (C17 bridge, #80) is Complete on 2026-09-28: implementation commit `64ba7d3` is on `origin/master`, T1-T6 pass, all eight CI workflows succeeded (Rocky 8 on attempt 2), and #80 is closed. M10 (module configuration consistency, #83) is Complete on 2026-09-29: implementation commit `6bbb6a5` is on `origin/master`, T1-T4 pass, all six OS workflows plus Linter and documentation deployment succeeded, and #83 is closed. The remaining inventory groups are #84-#92, linked to M11-M19. M11's expanded Implementation Plan and Test Plan (#84) are accepted on 2026-09-29, including the T2 package preparation and identical-environment comparison conditions. D25 adds `conf.rocky10` in both vendor repositories with `conf.rocky8` compatibility, then switches the Rocky 10 consumer after both vendor changes land. The accepted plan also adds the missing audit to three OS workflows and updates the matching documentation. Implementation of the accepted M11 plan is authorized on 2026-09-29. Both tested vendor changes are published on their default master branches: uldaq-env `988b1523a759855b5e98c23e3cde050ab8d1b26e` and open62541-env `00e5e60eb24a64d94578b608538d4288c90a0dbf`. The EPICS-env consumer change is published as `921cd5f843df1ffc4167324fd762be33a6bb4164`. D26 documentation guard repair is published as `840ad37dd8bb279db7688efcf0c866c0f14e259c`. T1-T6 pass: the actual Rocky 10 run consumes both tested vendor commits; all three changed OS workflows pass the strict dependency audit, build, installation, and final checks; the corrected documentation guard, Pages deployment, and Linter succeed. M11 is Complete on 2026-09-29: verification evidence is published in `2b27ed5d790569121930003dee5823c0f4e52ef7`, the #84 body matches the implementation and verification results, and #84 is closed as completed at 2026-09-29T18:49:21Z. M11's closure record is published as `5a130908464f2a4a90108223fcf4a087d70d61f8`. M12 plan acceptance and implementation authorization are recorded on 2026-09-29. The accepted query/action separation is published as `c1de48c21aa6ecc2e9a1be224833dcbee71b820f`; T1-T6 pass. All six candidate OS workflows, Linter, and documentation deployment succeed. The tutorial paragraph correction is accepted, authorized, and verified on 2026-09-29. The verification record is published as `c351ac9243d5e5424baa1a61f0f1455e57887f` on `origin/master`. M12 is Complete on 2026-09-29: issue #85 was closed as completed at 2026-09-30T00:07:25Z after its body and completion comment were synchronized. M10 completion context: the upstream motorSimTest.src startup failure occurs on both compared revisions and remains outside the implemented dependency change. All five remaining directions were selected on 2026-09-28: keep the motor prerequisites, QPC configuration, and conditional diagnostic hint (CLOSED_DOORS K5-K7); move QPC and sscan to the other-module configuration group; remove only the unused top-level linker-root assignment. M10's four plan reviews are incorporated: M10 / T1 checks effective configuration and the selected changes, M10 / T2 covers six local/parent override changes, M10 / T4 sets each installation root in the checkout's configure/CONFIG_SITE.local and verifies the exact installed base path before module verification, and the cache invalidation change has an implementation step. M10's documentation scope includes the module add-or-bump procedure and QPC's inherited ASYN exception. M10's plan acceptance and implementation authorization are recorded on 2026-09-28; M11-M13 are Complete; M13's full accepted implementation and T1-T5 evidence are published, and #86 is closed as completed. M14 is Complete with its native implementation, T1-T7 verification, and all eight CI workflows published; #87 is reconciled and closed as completed on 2026-10-01. M20 independently retains the deferred Libera checks. M15 is Complete; M16's Python-based plan was accepted and authorized on 2026-10-02, and its D51 revision on 2026-10-03. M17-M19 remain Ready and each opens with a plan review that checks its items against the current code. Continue with M1 under D52, which is now Ready, then M17 and M18 in ID order, then M19 because its hygiene items overlap the files of M10 and M15. Backlog M2 (#75) is Ready now that M6 is Complete, and updates the book where the module source-URL mechanism changes (D15). The Backlog holds the other surviving work. When the first release work is assigned, choose the next release version under D9 (1.4.1 for fixes only, 1.5.0 for module-set or feature changes), create `release-X.Y.Z` from `master`, reset this register into `docs/milestone-X.Y.Z.md`, and set `ENV_RELEASE_VERS` to X.Y.Z in its own commit. References of the form `1.4.0 M<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

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
| Code | M16 | Make installed build and service files usable after relocation | Milestone | Complete | No | D17, D23, D50, D51, D53 | Fresh and relocated downstream IOC builds pass with CHECK_RELEASE=YES; managed metadata, pkg-config consumers, and service launch paths resolve the selected root, with repetition and recovery verified; [detail](#m16---installed-tree-portability) |
| Code | M17 | Fix the iocLog, autosave, and iocStatsAdmin fragment defects | Milestone | Not started | Yes | D17, D23 | `LOGDISABLE=1` disables IOC logging, the autosave header states its `system.dbd` need, and the iocStatsAdmin limits and linStat collisions are fixed or kept; [detail](#m17---common-iocsh-fragment-defects) |
| Code | M18 | Make the fragment tests safe and check what they claim | Milestone | Not started | Yes | D17, D23 | `t3_run.sh` deletes no source checkout, `common.sh` has no user-specific default, and `verify_serial.sh` checks bits and parity or states that it does not; [detail](#m18---fragment-test-defects) |
| Code | M19 | Remove unused build-system names, variables, and stale files | Milestone | Not started | Yes | D17, D23 | Each listed hygiene item is fixed or kept, and every OS workflow passes; [detail](#m19---build-system-hygiene) |
| Code | M22 | Remove the installed-tree relocation mechanism | Milestone | Complete | No | D54 | `tools/relocate_installed_tree.pl`, the make writer wrapping in `configure/RULES_*`, and the relocation documentation are gone from `master`; the installed tree, book, and CI match the pre-M16 behavior; [detail](#m22---relocation-mechanism-removal) |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | Yes | M16, D52 | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m1---epicspath-normalizerelpath) |
| Runtime | M23 | Load installed EPICS modules with iocsh.bash and softIocPVX | Milestone | Complete | No | D55, D56, D57, D58, D59, D60, D61, D62, D63, D64, D65, D66, D67, D68, D69, D70, D71, D72, D73, D74, D75, D76, D77, D78, D79, D80, D81, D82, D83, D86, D89 | Installed metadata drives all three directive aliases, exact/default versions, dependency and ELF validation, and real IOC startup without runtime .local reads; all three public candidate IOCs are covered and T1-T16 pass; [detail](#m23---installed-module-loader-for-softiocpvx) |
| Code | M25 | Carry a Base site patch for the database parser crash at end of input | Milestone | Complete | No | D84, D85, D88 | `patch/7.0.10-site01-dbyacc-eof.p0.patch` is applied by `make patch` and reverted by `make patch.revert`, whose function-location check skips declarations; a database definition file that ends inside an open construct gives a syntax error without a segmentation fault on Debian 13 and Rocky Linux 8.10; the six OS workflows and the Linter succeed; [detail](#m25---base-site-patch-for-the-parser-crash-at-end-of-input) |
| Docs | M27 | Add the loader pages to the book | Milestone | Complete | No | M23, M25, M28, D90, D92, D93 | The book has a concept page and a procedure page for the loader in its table of contents, with entry points from the introduction, the tutorial, and the glossary; the reference keeps forms, messages, option behavior, and exit statuses only, with a list of every moved statement; every command and message on the pages matches executed output; the suite's documentation check passes on the new text; the book builds with the documented image; [detail](#m27---loader-pages-in-the-book) |
| Tests | M28 | Add the loader verification suite to the repository | Milestone | Complete | No | M23, M25, D91, D92, D94 | The suite under `examples/iocsh/tests/` and its procedure page are in the repository, with a list of the refusal cases and the script that provokes each; it passes ShellCheck with and without `-x` and the Linter, holds no host address, workstation path, earlier work number, or earlier test number, and gives the expected number of passing checks per script on Debian 13 and Rocky Linux 8.10; [detail](#m28---loader-verification-suite) |
| opcua | M29 | Keep the installed opcua configuration unchanged by a repeated installation | Milestone | Complete | Yes | M23, D95 | A repeated `make install` leaves `modules/opcua-0.11.2/cfg/CONFIG_OPCUA` unchanged on Debian 13 and Rocky Linux 8.10, and the verification suite runs twice on one tree with the same counts, or an owner decision keeps the behavior with its cause recorded; [detail](#m29---installed-opcua-configuration-and-repeated-installation) |

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
| D50 | Expand M16 relocation support to downstream IOC builds, pkg-config, and the listed installed build/service metadata. Include explicit path-refresh and repetition verification; drafting the plan does not authorize implementation. | 2026-10-01 |
| D51 | M16 implements the installed-tree metadata utility in Perl instead of Python: source `tools/relocate_installed_tree.pl`, installed copy `relocateEpicsEnv.pl`, invoked as `perl <tree>/relocateEpicsEnv.pl`. The options, exit statuses, inventory and operation-record structure, and required behavior are unchanged. The code stays within the Perl 5.26 language level and the Perl modules installed on a prepared Rocky Linux 8.10 system. SHA-256 uses `Digest::SHA`, with the coreutils `sha256sum` command as the fallback where it is not installed. On Rocky Linux the prepared systems carry `perl-Digest-SHA`, `perl-JSON-PP`, `perl-Pod-Checker`, and `perl-Test-Simple` through pkg_automation `60de819` for containers and ansible-provision `4dfb290` (branch `m14-middleware-reconcile`) for VMs. Results observed on the Python implementation do not verify the Perl implementation; native verification runs again on Rocky Linux 8.10 and Debian 13. Rocky Linux 8.10 replaces Rocky Linux 10.2 in the local native checks of the M16 Test Plan, including the baseline installation and the systemd VM; the six OS CI workflows observed in T6 are unchanged. | 2026-10-02 |
| D52 | Assign Backlog M1 (#25) to the Milestone on `master`: remove the `makeRPath` Python dependency through additive `EPICS::Path` primitives, delivered as a local patch on the pinned EPICS base. Work it after M16 completes. | 2026-10-02 |
| D53 | Tools that only a verification step needs stay in that test image and are not added to the pkg_automation, ansible-provision, or cloud-provision package lists. EPICS-env fixes its install and library locations itself, so the production package set stays minimal; a package goes to the provisioning lists only when the shipped build, install, or a shipped tool at run time needs it. Example: `libtool-bin` on Debian 13, added only for the M16 T3 libtool link through `libuldaq.la`. | 2026-10-03 |
| D54 | Retire the installed-tree relocation mechanism that M16 delivered (D50, D51) and keep installed text metadata as upstream installs it (K11). The environment is cloned and moved whole; `$ORIGIN` runpaths, the location-derived `setEpicsEnv.bash`, and relative module links already make it position independent, and nothing in the environment reads the installed module `RELEASE*` files (`CHECK_RELEASE = NO` everywhere EPICS-env builds), the pkg-config or libtool files, or the base site file; service and init files are operator-installed outside the tree. The refresh utility, inventory, backups, and make writer protection are removed from `master` as M22; #89 is recorded as not a defect in this environment. D53 stands. | 2026-10-04 |
| D55 | Add an installed iocsh.bash wrapper for the existing softIocPVX; derive runtime module metadata during installation from the fixed distribution structure and effective build dependencies. Startup reads installed metadata and artifacts only, without e3-require, runtime Make, the source checkout, or .local configuration. | 2026-10-02 |
| D56 | An omitted module version follows its unversioned selection symlink; an explicit version selects the exact installed directory; dependencies retain the versions recorded for the selected module. Validate and resolve the required graph once per invocation, then use canonical paths throughout; reject conflicting versions within one IOC. | 2026-10-02 |
| D57 | Give m, mod, and module identical startup-file syntax: a literal name with an optional exact version, using unquoted or quoted arguments or the parenthesized form. Report invalid syntax and module/version conflicts with source locations and dependency context before IOC startup. | 2026-10-02 |
| D58 | Include DT_NEEDED and RUNPATH search with ORIGIN expansion in installed-module validation, comparing ELF module ownership and versions with metadata. Retain DBD-only dependencies and verify actual native library selection separately from static ELF search. | 2026-10-02 |
| D59 | Exclude IOC applications whose source repository is hosted on GitLab. Include all three public candidates, tc32sim, EPICS-IOC-Demo, and opcua-IOC-demo, in M23. Verify each through the installed wrapper and softIocPVX without compiling an IOC executable or custom support; record startup and communication/data-update results separately. An unavailable device or external PV leaves its check Pending rather than establishing a pass. | 2026-10-02 |
| D60 | Develop the installed loader on iocsh-module-loader. Use tc32sim with StreamDevice, linStat, retools, autosave, and caPutLog as the first integration example; verify simulator data, monitoring, retools execution, autosave restart restoration, and CA put log reception separately. Prepare complete IOC examples later as separate application fixtures. | 2026-10-02 |
| D61 | Install iocsh.bash into the selected tree's base executable directory, `base/bin/<EPICS_HOST_ARCH>/`, which `setEpicsEnv.bash` already publishes and `resetEpicsEnv.bash` already removes. Add no distribution-top `bin` directory; the EPICS build specification reserves that name against the parent of an installation directory. | 2026-10-02 |
| D62 | Runtime metadata records each module's build-declared dependencies as they are. A declared dependency that the selected artifacts do not reference by ELF or DBD still loads in dependency order; loading it is expected behavior, not a defect, and entry mappings do not prune dependencies. | 2026-10-02 |
| D63 | Keep a minimal tracked loader example at `examples/iocsh/st.cmd`, replacing the untracked repository-root prototype; complete IOC applications remain separate fixtures under D60. | 2026-10-02 |
| D64 | Module entry mapping uses a default rule, `lib<name>.so` with `<name>.dbd`, plus explicit exceptions for every module whose installed names differ or whose library or DBD list is empty. Metadata generation fails the installation of a module whose default-rule files are absent and that has no exception, and rejects a candidate DBD that defines a Base menu or record type with a body, since that is an expanded application DBD; such a module needs an exception naming its support DBD. Empty-body declarations such as `recordtype(ai) {}` are not expanded DBDs. | 2026-10-02 |
| D65 | The wrapper keeps replacing itself with the native executable through `exec`. The line-preserving generated startup copy is written to a disposable temporary file that is opened and unlinked at once and passed as `/dev/fd/N`, so nothing remains on disk after `exec` and no cleanup runs after the IOC exits. | 2026-10-02 |
| D66 | ELF validation also rejects, at installation, a selected library that leaves symbols undefined after its `DT_NEEDED` closure, Base, and its dependency modules are considered, because `dlload` of such a library fails in `softIocPVX`. The treatment of a module that this check rejects is decided when the check reports it. | 2026-10-02 |
| D67 | The wrapper has a show mode, `-n` or `--show`, that prints the generated startup and exits without starting the IOC, so directive selection and diagnostics can be compared without an IOC process. | 2026-10-02 |
| D68 | Metadata generation also rejects a selected DBD whose record, device, driver, registrar, function, variable, or link entries are exported by no selected, dependency, Base, or PVXS library, using the symbol names `registerAllRecordDeviceDrivers` resolves. Under D64, a support DBD may include a Base or PVXS file that carries menus only, as a record DBD includes `menuYesNo.dbd`; an include that carries record types or support entries still marks an application DBD. | 2026-10-02 |
| D69 | The minimal example check reads a named representative set of linStat PVs for `NO_ALARM` and an advancing timestamp, not every linStat record: `<IOC>:MEM_MAX`, `<IOC>:MEM_FREE`, `<IOC>:PROCESS_ID`, `<IOC>:NET:<NIC>:NAME`, `<IOC>:NET:<NIC>:MTU`, `<IOC>:<FSID>:PATH`, and `<IOC>:<FSID>:SIZE`. The check confirms that the loader loaded and registered the support; it does not judge the alarm configuration of the linStat databases. | 2026-10-03 |
| D70 | The undefined-symbol check of D66 counts function and data symbols alike. Observed 2026-10-03 on the local Debian 13 tree: `dlload` fails only for an undefined data symbol, as in `libdevSnmp.so`; a library whose undefined symbols are all functions, as `libmeasComp.so` with 42 uldaq functions, loads and the process ends at the first call into them, so D66's stated reason holds for data symbols and the check rejects both cases. | 2026-10-03 |
| D71 | A module that the D66 check rejects is declared unloadable in `configure/CONFIG_MODS_IOCSH` with a short reason. Its metadata is still generated and carries the reason, the wrapper refuses the module with that reason before IOC launch, and generation fails when a declared module no longer leaves a symbol undefined. snmp and measComp are declared: their libraries name neither net-snmp nor uldaq in `NEEDED`. Linking those libraries in the module build is separate work. | 2026-10-03 |
| D72 | The ELF resolver is one tool, `tools/iocsh_elf.bash`, installed beside the wrapper in the Base executable directory. Metadata generation runs it for the D66 check and the wrapper runs it before IOC launch, so both use one reading of `NEEDED`, `RPATH`, `RUNPATH`, and `$ORIGIN`. | 2026-10-03 |
| D73 | The generated Base site configuration adds `-Wl,--no-as-needed` to `USR_LDFLAGS`, so every shared library named on a link line is recorded in `NEEDED` whatever its position, for Base, every module, and applications built against the installed Base. The cause is removed at the linker rather than by reordering a module's link line, which would need a source patch that must follow upstream. Observed 2026-10-03: the snmp link line names net-snmp before its objects; the Rocky 8 and Rocky 10 builds record it and the library resolves, while the Debian and Ubuntu builds drop it. The snmp unloadable declaration of D71 is removed; measComp stays declared because its link line does not name uldaq at all. | 2026-10-03 |
| D74 | The generated measComp site configuration adds `measComp_LIBS_Linux += uldaq`, so `libmeasComp.so` records `libuldaq` in `NEEDED` with the vendor runpath and loads on its own; the upstream Makefile names uldaq for the IOC executable only, and no source patch is added. The measComp unloadable declaration of D71 is removed. The declaration mechanism of D71 stays, with no module declared. | 2026-10-03 |
| D75 | The unloadable declaration of D71 is removed from the make rules, the metadata generator, and the wrapper. After D73 and D74 no module is declared, so no shipped configuration can exercise the declaration. A library that the D66 check rejects fails its module build until the missing library is named on the library's link line. | 2026-10-03 |
| D76 | Each application fixture is a directory `examples/iocsh/<ioc>/` in this repository that holds the adapted startup, a preparation script, and the settings of the test environment. The application itself is checked out at the revision the fixture records and is used unchanged; a database that the application build expands from substitution files is expanded with the installed `msi` at preparation. | 2026-10-03 |
| D77 | The asyn entry mapping lists `asyn.dbd`, `drvAsynIPPort.dbd`, and `drvAsynSerialPort.dbd`. `asyn.dbd` alone registers no port configuration command, so `drvAsynIPPortConfigure` in the tc32sim fragment was not registered when the fixture first ran on 2026-10-03. | 2026-10-03 |
| D78 | The opcua-IOC-demo data path is checked against the open-source Eclipse Milo demo server through a startup variant, `examples/iocsh/opcua-IOC-demo/st-milo.cmd`, that loads the application's server database and its generic `ai.template` with node identifiers of that server; the server is started anew before each IOC start, because only the first session after a server start connects with the installed open62541 client. The original startup for the Unified Automation demo server stays in the fixture, and its data path stays Pending until that server is available. | 2026-10-03 |
| D79 | The caPutLog entry mapping is the default rule, `libcaPutLog.so` with `caPutLog.dbd` alone. `caPutLog.dbd` and `caPutJsonLog.dbd` are alternatives: with both loaded the module skips the JSON registration and warns to use only one, as every loader start showed on 2026-10-03. The installed fragment calls `caPutLogInit`, which `caPutLog.dbd` registers. This replaces the earlier listing of both files under D64. | 2026-10-03 |
| D80 | The loader guards against metadata that was changed after its generation. Metadata generation records the SHA-256 digest of `cfg/iocsh.conf` beside it, and the wrapper compares that digest for every selected module before IOC launch; a mismatch names the module and the regenerating make target. The wrapper tests for a dependency cycle before it accepts an already selected module, so a cycle among matching versions is refused; observed 2026-10-04, such a cycle in an edited `iocsh.conf` started the IOC. The digest covers the file content only and holds no path, so a tree that is copied, moved, or published through Git keeps passing. It detects an edit of that one file, not an edit that also replaces the digest, and artifact digests stay an installation check. Modules that other repositories build against this environment carry no loader metadata; the same generation can apply to them in their own builds and is not part of this work. | 2026-10-04 |
| D81 | Metadata generation removes the existing `cfg/iocsh.conf` and its digest before it runs its checks, and so does the build record step, so a module whose generation is refused carries no loader metadata: the wrapper refuses it and its unversioned link is not published until a later generation succeeds. Observed 2026-10-04: a measComp build without the uldaq link line failed the undefined-symbol check after the EPICS build had installed the new library, and the metadata of the earlier build stayed, so the wrapper still accepted the module. The refused library itself stays installed, because the EPICS build installs as it builds. Every refusal also states that the module is installed without loader metadata and names the make targets to run after the correction; the undefined-symbol message names the site configuration line of this repository, `<library>_LIBS_Linux += <name>` in the module's `conf` rule, and the command that lists every finding. | 2026-10-04 |
| D82 | The tc32sim fixture judges the update of its temperature records with one `camonitor` run of 30 seconds in which each of the 32 channels updates at least twice, in place of two `caget -a` reads 2 seconds apart. Observed 2026-10-04 on Debian 13 and Rocky Linux 8.10: `TC32:001:Ti0` updates about once per second with gaps up to 2.2 seconds, and the other channels about every 3 seconds with gaps up to 16 seconds, because the simulator sends all 32 values in one burst and the `I/O Intr` records share that input; every channel updated at least twice within 30 seconds. The earlier criterion failed on both hosts for a reason outside the loader. | 2026-10-04 |
| D83 | With `--environment`, the wrapper discards the standard output of the sourced `setEpicsEnv.bash`, so the show mode prints the generated startup only; observed 2026-10-04, that output began with a blank line and, when another tree was selected, with the `EPICS_BASE is defined as` notice. The native IOC shell names a startup file by its last path component, so an error in the caller's file reads `ERROR 4 line <n>`; the line number is the caller's and the wrapper prints the descriptor mapping first. The unlinked descriptor of D65 stays, and the book explains the name `4` in place of a startup copy that keeps the original file name on disk. | 2026-10-04 |
| D84 | Carry a site patch for EPICS base 7.0.10, `patch/7.0.10.base.p0.patch`: when the database parser reports an error after its last input file is closed, `yyerror` prints ` at end of input` and returns without reading `pinputFileNow`, `yytext`, or the line buffer. Observed 2026-10-04: a database definition file that ends inside an open construct ended `softIoc` and `softIocPVX` with a segmentation fault on Debian 13 and Rocky Linux 8.10; the read was added upstream by commit `f9e53dded658b21bbf93155766fe34085ec47099`, first released in R7.0.9, and the upstream `7.0` branch held it on that date. The fix is not upstream, so it is a site patch and not part of the upstream carry; its report to upstream proceeds outside this repository. | 2026-10-04 |
| D85 | The function-location check of `tools/revert_patch.bash` does not count a line that ends with a semicolon as an occurrence of the function named in the hunk header: such a line is a declaration, and a patch cannot change lines inside it. Observed 2026-10-04: with the forward declaration of `yyerror` counted, the revert of the Base site patch stopped as unclassifiable although its reverse dry-run succeeded. A function that is defined twice still leaves the state unresolved. | 2026-10-04 |
| D86 | The loader work completes with the Eclipse Milo startup variant as the data-path evidence for opcua-IOC-demo. The databases of the original startup name 69 nodes under `ns=2;s=Demo.Static`, `Demo.Dynamic`, and `Demo.WorkOrder` that only the Unified Automation example server `uaservercpp` provides; that server needs a registered download, the Milo server names its nodes differently, and the test server of the opcua module provides its own test nodes only. A server written to imitate those nodes would be a stand-in and is not used. The data path of the original startup is separated into Backlog M26, Deferred until that server is available, and is excluded from the completion of the loader work. | 2026-10-04 |
| D87 | The ELF tool reports a library whose file is shorter than the end of its last loadable segment, in both of its modes, so the wrapper refuses such a library before IOC launch and metadata generation refuses it at installation. Observed 2026-10-04 with `liblinStat.so` cut behind its dynamic section: glibc 2.41 on Debian 13 maps the file and the IOC ends with a bus error, while glibc 2.28 on Rocky Linux 8.10 answers `ELF load command past end of file`. The tool reads the program headers in the `readelf` call it already makes and adds one `stat` per object. A file cut behind its loadable segments still loads on both targets and is not reported; the artifact digests of the installation check cover it. | 2026-10-04 |
| D88 | The Base site patch joins the carry set of EPICS base: it is named `<base_version>-site<NN>-<slug>.p0.patch`, so `patch.base.pr.apply` applies it after the upstream fixes and `patch.base.pr.revert` reverts it first, and a site patch that must precede the pull request patches is named `<base_version>-<NN>-site-<slug>.p0.patch`. `patch/7.0.10.base.p0.patch` becomes `patch/7.0.10-site01-dbyacc-eof.p0.patch`. The earlier form `<version>.base.p0.patch` is obsolete: `patch.base.apply`, `patch.base.revert`, `patch.base.make`, and their three functions in `configure/RULES_FUNC` are removed, and `patch.base`, which `scripts/build_base_libera.bash` calls, stays as an empty target so the Libera build applies no Base patch, as before the site patch existed. Observed 2026-10-04 in a patched build root: `make -n patch.base.make` writes the difference of the whole Base source, 31 files and 1470 lines with the carry set, over the 19-line site patch. This replaces the patch family and the apply order that D84 chose; the fix itself and D85 stand. | 2026-10-04 |
| D89 | `symlink.<module>` treats an empty module directory, which `uninstall.<module>` leaves, as not installed: it prints a notice and creates no link, and `make symlinks` continues with the other modules. A module directory that holds files without valid loader metadata still stops the target. Observed 2026-10-04 on Debian 13: after `make uninstall.linStat`, `make symlink.linStat` removed the link and stopped with `Missing or empty metadata file`, which also stopped `make symlinks`. | 2026-10-04 |
| D90 | The book gets a procedure page for running an IOC from installed modules, with entry points from the introduction, the tutorial, and the glossary. It is its own work, M27, and starts on `master` after M23 and M25 are Complete. Observed 2026-10-05 in a read of the book: seven pages describe the loader, but no table of contents entry names it, the way to run an IOC without compiling one is an optional step of the shell setup page, the introduction, the tutorial, and the glossary do not mention it, and the procedures of the fixtures are outside the book. | 2026-10-05 |
| D91 | The scripts that verified the loader join the repository as a suite under `examples/iocsh/tests/`, with a procedure page in the book, as its own work, M28 (D92). Observed 2026-10-05: all of T1 through T16 of the loader work ran from untracked local scripts, the CI workflows never run the loader, and `examples/commonIocsh/tests/` with its book procedure is the precedent for a suite of this kind. The suite carries a neutral name prefix in place of the earlier work number, takes every path and host from environment variables, passes ShellCheck, and leaves out the host-specific wrappers and the one-time measurement script. | 2026-10-05 |
| D92 | The loader book pages and the loader verification suite are two works: M27 for the pages and M28 for the suite, and M28 comes first. The suite puts the scripts that provoke each refusal into the repository and lists each refusal case in its `README.md`, so M27 writes its table of refusals from that list and provokes each refusal from the repository, and M27 then checks the suite again against the new book text. Observed 2026-10-05: the works share `docs/src/SUMMARY.md` and one more file, because `t11.bash` of the suite compares text of `docs/src/procedures/set-up-shell.md` with executed output, anchored on the sentences `For the minimal example of the repository the output is as follows` and `Each tool resolves inside`; M27 keeps those two sentences unchanged or adapts the anchors of `verify_docs_and_tools.bash` in the same work. Both works run on the workstation that holds the local scripts in `work/m22-tests/`. This replaces the placement of the suite inside M27 that D91 chose; D91 stands for the suite itself. | 2026-10-05 |
| D93 | The book pages follow these choices. A concept page, `concepts/installed-module-loader.md`, explains how the loader works. The explanatory sentences of the `iocsh.bash`, `iocsh_elf.bash`, and `iocsh_metadata.bash` items of `reference/tools-and-scripts.md` move into it, while the reference keeps the directive forms, the exact messages, the option behavior of `-n` and `-e`, the exit statuses, the repair commands, and the tool rows; a bullet that holds a message keeps the message and gives its cause sentence to the concept page. The procedure page lists each refusal with its meaning and the action it needs and quotes only the first words of the message, so the exact text stays in the reference. The `README.md` files of the example fixtures stay under `examples/iocsh/` as the one place of their run steps and expected results, and the procedure page links them by absolute GitHub URL of `master`, because the book builds only from `docs/src` and a relative link would break on the site. The tutorial gets one closing sentence that points to the procedure, not a new step. Observed 2026-10-05: lines 62 to 159 of the reference mix explanation with exact messages, no page of the book links a repository file today, and the fixture steps carry measured results that would drift if kept in two places. | 2026-10-05 |
| D94 | The suite follows these choices. A neutral runner inside the suite takes the installed tree, the EPICS-env checkout, and the output directory from the variables `IOCSH_TEST_TREE`, `IOCSH_TEST_REPO`, and `IOCSH_TEST_OUT`, runs the scripts in the fixed order of the local driver, and takes the place of both the driver and the host wrappers; the prefix of functions and variables is `iocsh_test`, and the demo server container is named `iocsh-milo`. The scripts are named after `examples/commonIocsh/tests/`: `common.bash`, `run_all.bash`, `verify_<topic>.bash`, and `observe_truncated_library.bash`; the table of the earlier and the new names is in M28. Only the wrappers that connect to a host stay out. The procedure page gives the build steps of a candidate installation, taken from the OS workflows with an install location of its own. The `README.md` of the suite lists, for each refusal case of the failure-diagnostics and ELF scripts, the script and the check that provokes it, for M27. The expected number of passing checks per script is also copied into it, with the exception that `t11.bash` gives 6 on Rocky Linux 8.10, so that no register is needed to read it. Each script sources the shared functions under the directive `# shellcheck source=common.bash disable=SC1091`, the form of `examples/commonIocsh/tests/`, so it passes with and without `-x`, because a `source=` directive alone leaves the finding `SC1091` without `-x`; a finding on a literal string or on an `eval` that cannot be rewritten without changing the check gets a line-scoped `# shellcheck disable=` with its reason. Check descriptions that carry the T numbers of the loader work use the topic name instead. The suite applies to the pins of the tree it was recorded on, and a pin bump adjusts it. Observed 2026-10-05: 22 ShellCheck findings in 9 files, every script uses the variables `M22_TREE`, `M22_REPO`, and `M22_OUT`, and the local driver cannot run without the host wrappers. | 2026-10-05 |
| D95 | The installed `modules/opcua-0.11.2/cfg/CONFIG_OPCUA` that changes its content when it is installed again is its own work, M29, in the Milestone section. Observed 2026-10-05 on Debian 13: the fresh build holds the line `OPEN62541 = $(_OPEN62541_CONFIG_OPCUA)/../../../vendor`, which is relative to the installed file; the repeated installation of a first run of the verification suite kept it, a later installation rewrote it as `OPEN62541 = <installed_tree>/modules/opcua-0.11.2/cfg//../../../vendor`, and a plain `make install.opcua` on a candidate that had run the suite once reproduced the rewrite. The cause is not isolated: the patch round trip of the suite, which updates the source files, comes before the rewrite but has not been shown to cause it. The suite README and its page say meanwhile to run it once per candidate installation. | 2026-10-05 |
| D96 | The installed `cfg/CONFIG_OPCUA` of opcua stays the literal `OPEN62541 = $(_OPEN62541_CONFIG_OPCUA)/../../../vendor` in every installation, so that a moved installed tree still links. Cause, observed 2026-10-05 on Debian 13: `conf.opcua` writes `-include $(INSTALL_LOCATION)/cfg/CONFIG_OPCUA` into the opcua `CONFIG_SITE.local`, and the opcua build resolves `OPEN62541` through that installed file; the first build generates the file before the include has anything to read and passes the literal to `expandVars.pl`, a later installation after the patch round trip has made `CONFIG_OPCUA@` newer passes the resolved absolute path. Removing the include fails with `ld: cannot find -lopen62541`, so it stays. `conf.opcua` also writes `CONFIG_OPCUA_EXPANDFLAGS = -D OPEN62541=$(OPEN62541_PATH)`, which the expansion adds after the default `-D OPEN62541=` and which wins, so every installation writes the same text. | 2026-10-05 |
| D97 | Set Backlog M3 and M5 to Deferred. The owner decided on 2026-10-05 that neither the promotion of commonIocsh to its public module (M3, D2, D7) nor the global iocsh startup file (M5, D8) is worked now; the decisions D2, D7, and D8 stay as recorded, and each work waits until the owner asks for it. | 2026-10-05 |
| D98 | Work the remaining Backlog in this order: M2, M17, M18, M19, then M1. M3 and M5 are Deferred under D97, and M20, M21, and M26 stay Deferred. Each work starts only after its plan is accepted and its implementation is authorized. | 2026-10-05 |
| D99 | M2 takes Option A: the base of each module that does not live in `epics-modules` is declared as `SRC_BASE_<module>=$(SRC_URL_<owner>)`, with a recursive assignment so that a `SRC_URL_<owner>` set in `RELEASE.local` still reaches it, in the module block of `configure/RELEASE`, and the generator writes `$(or $(strip $(SRC_BASE_<module>)),$(SRC_URL_EPICSMODULES))/<name>` for every module. The twelve `SRC_GITURL_*` re-definitions of `configure/CONFIG_MODS` are removed after the generator emits them. `SRC_BASE_*` enters the inputs that invalidate the generated cache, so a changed base regenerates `configure/MODULESGEN.mk`. Every effective `SRC_GITURL_*` stays equal to the value captured before the change. | 2026-10-05 |

### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| M4 (CI workflow triggers and OS set, #78) | Backlog, `docs/milestone-84ee626.md`, `master` | Milestone, `docs/milestone-84ee626.md`, `master` | this synchronization commit | this synchronization commit |
| M14 Libera subset -> M20 (D42, 2026-09-30) | Milestone, `docs/milestone-84ee626.md`, `master` | Backlog, `docs/milestone-84ee626.md`, `master` | `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` | `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` |
| M15 macOS verification subset -> M21 (D49, 2026-10-01) | Milestone, `docs/milestone-84ee626.md`, `master` | Backlog, `docs/milestone-84ee626.md`, `master` | `6e58d422ec33233edd21d2c529923971ec2445a3` | `6e58d422ec33233edd21d2c529923971ec2445a3` |
| M1 (EPICS::Path Normalize/RelPath for makeRPath, #25; D52, 2026-10-02) | Backlog, `docs/milestone-84ee626.md`, `master` | Milestone, `docs/milestone-84ee626.md`, `master` | this synchronization commit | this synchronization commit |

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
Status: Complete

##### Summary

Make the installed native Linux tree usable for downstream IOC builds and the listed build/service metadata after relocation. D50 expands the existing loader and shell relocation boundary. The implementation normalizes installed metadata after installation and supplies an explicit installed-tree refresh operation after a move; sourcing the environment remains a shell-only operation.

##### Scope

- Installed dependency configuration: every selected module's installed `configure/RELEASE` and included `RELEASE*` files must resolve the effective installed EPICS base and module dependencies. Preserve pinned versioned module locations, declaration order, and legitimate external dependencies. A downstream IOC must use the real `checkRelease` with checking enabled.
- Installed metadata: base `configure/CONFIG_SITE.local`; installed module `configure/RELEASE.local` files containing managed paths; base `lib/pkgconfig/epics-base.pc` and architecture-specific variants; `S99caRepeater`, `S99logServer`, and `caRepeater.service` under the host bin directory; vendor `libuldaq.la` and `pkgconfig/open62541.pc` when those vendors are installed inside the tree.
- Installation integration and a shipped refresh operation: prepare the installed metadata after successful installation, then update the same managed fields to the new root after a move. The operation must work from the installed tree without the original checkout or installation. Perl and the Perl modules installed on a prepared Rocky Linux 8.10 system are the runtime prerequisites of the utility, with `sha256sum` as the SHA-256 fallback where `Digest::SHA` is not installed (D51). Source: `tools/relocate_installed_tree.pl`; installed copy: `relocateEpicsEnv.pl`; installed inventory: `.epics-env-paths.json`. The public interface is defined in the Implementation Plan.
- Documentation: explain the preparation and refresh steps, the same-OS/architecture boundary, retained external dependencies, and the separate reload/reinstallation needed for service files already copied outside the tree. Keep the source configuration, module pins, loader policy, and direct-source environment selection intact.

Out of scope: the defects of M9-M15 and M17-M19; Libera and macOS execution retained in M20/M21; portability between operating systems or architectures; rebuilding the installed base or modules after a move; binary rewriting; updating arbitrary consumer IOC files; automatic changes to `/etc`, running host services, or external vendor repositories. A system service already registered outside the tree requires its own operator action; that does not become an automatic refresh side effect.

##### Completion Criteria

- A fresh native install has consistent installed dependency declarations. An independently generated downstream IOC builds with `CHECK_RELEASE=YES`, without substituting the consistency checker or installing a special consumer-side bypass.
- After relocating the complete tree and running its refresh operation, the same downstream build, pkg-config consumers, and listed service launch paths use the new root. The original checkout and old installation root are unavailable during these checks.
- Each in-scope metadata file has an explicit disposition and observed functional check. A text search alone does not verify an IOC build, a pkg-config consumer, or service execution. External paths retain their meanings and are reported separately from managed tree paths.
- Repeating refresh at the same root changes no file content, mode, or symlink target. Moving from root A to B and then C updates managed paths each time. Unrelated settings, comments, includes, user content, existing backups, and other installed environments are preserved.
- The utility validates its input and all intended changes before replacing files. Missing required metadata, ambiguous managed assignments, unsupported input, a target symlink outside the tree, or inability to make and verify backups returns nonzero with the affected file named. Preflight failure changes no managed file. A failure after replacement starts restores the changed files from verified backups or reports the exact incomplete recovery; it never reports success after a partial update.
- Only inventory-listed managed fields may be changed. A successful update retains verified backups of changed files, preserves their modes, and updates the recorded current root only after all replacements succeed. No-op runs create no additional backups. The operation never follows module aliases twice or writes through a path escaping the selected tree.
- Replacement recovery survives process termination. Before the first replacement, persist the previous inventory, source/target roots, managed file locators, verified backup locators, original modes, and expected before/after hashes in a tree-local operation record. A new invocation must detect an unfinished operation before treating the inventory as current. Check reports it without writing; apply restores the verified previous metadata and inventory, reports recovery separately, and exits nonzero without starting a new update in that invocation. Missing, altered, or unsafe recovery inputs leave the record intact and identify the files requiring operator action. Another termination during recovery remains recoverable on the next invocation.
- Installation finalization waits for base, module, and commonIocsh installation to finish, including parallel make. A failed install must not produce a falsely finalized tree. Partial targets remain usable under their existing contract, and an incomplete tree fails an explicit full-tree refresh with a diagnostic.
- Before any full or partial installation overwrites a managed installed file, persist an incomplete-install state, including when the destination already has a completed inventory. Publish a newly completed inventory only after all required install prerequisites and metadata preparation succeed. Check and apply reject an incomplete-install state until a successful full installation finalizes it; metadata rollback alone cannot establish that partially installed binaries and modules are complete.
- Before upstream installation can overwrite existing metadata, verify and retain snapshots of the installed settings, comments, includes, file modes, and previous inventory. Reconcile new configured managed fields with the preserved unmanaged content before finalization. Ambiguous reconciliation stops with named files and retained snapshots; it must not silently discard user content. Installation failure restores and verifies the preserved metadata while retaining incomplete-install state, because metadata restoration does not establish binary/module completeness. A retry reuses the original verified snapshots rather than replacing them with partially installed contents.
- Every repository entry point that writes installed metadata performs the same state preflight, including `install`, `install.base`, `install.modules`, generated `install.<module>` targets, `build`, `build.base`, `build.modules`, and generated `build.<module>` targets. Upstream default builds install output, so build entry points require protection before upstream make starts. Unfinished replacement/recovery state takes precedence over starting or retrying installation: refuse the writer invocation before copying files or changing the operation record, inventory, or backups. Finish the documented recovery through the installed utility first. Existing incomplete-install state permits a full-install retry using its preserved snapshots, but does not permit refresh to report success.
- Repeat-refresh and reinstall checks have different expected results. Same-root refresh preserves contents, modes, symlink targets, and inventory and creates no new backups. Reinstallation may copy source-derived configuration, regenerate the inventory, and update `.versions` and its normal installation backup; these expected installation changes are recorded separately and do not weaken the refresh no-op requirement.
- The shipped `check.deps`, real loader and shell checks, and existing native CI workflows remain successful. This milestone does not expand the shell scripts' write behavior, relax release consistency checks, or change patch, dependency-audit, or binary-linker policy.
- The book describes exactly what the shipped operation verifies and changes, including copied system service files and unavailable external dependencies. Required native tests and publication checks are recorded before issue closure; unexecuted checks remain Pending.

##### Dependencies And Decisions

- D17 assigns the work to `master`; D23 gives it independent identity and #89. These are work-order decisions, not runtime dependencies on other inventory fixes.
- D50, Decision Date: 2026-10-01, selects the expanded relocation scope: downstream IOC builds, pkg-config, and listed installed build/service metadata must be usable at the new location, with path-refresh and repetition verification. The selection authorizes drafting this plan; plan acceptance and implementation authorization remain separate.
- D51, Decision Date: 2026-10-02, replaces the Python utility with a Perl implementation with the same options, exit statuses, and required behavior, limited to the Perl 5.26 language level and the Perl modules installed on a prepared Rocky Linux 8.10 system, with `sha256sum` as the SHA-256 fallback where `Digest::SHA` is not installed. A prepared system follows only the package preparation portion of the `Install required packages` step in `.github/workflows/rocky8.yml`. Observed 2026-10-02 in a Rocky Linux 8.10 image built from `rockylinux/rockylinux:8` with the package preparation commands of that step and pkg_automation `60de819`: Perl 5.26.3, `JSON::PP` 2.97001, `Digest::SHA` 6.02, `Test::More` 1.302135, `Pod::Checker` 1.73. It revises the accepted plan, so plan acceptance and implementation authorization are recorded again for the revision.
- Status stays In progress under D51: the Python implementation and its verification were authorized and ran, and the work continues with the revision. The revision was accepted and its implementation authorized on 2026-10-03; the Perl utility is implemented under it.
- Working-tree disposition under D51: `tools/relocate_installed_tree.py` stays in place until the Perl implementation passes its verification, and its removal is a separate owner decision. The uncommitted make-rule and `docs/src` changes are kept and adapted to the Perl utility. The commit message `work/commit-msg-installed-tree.txt` and the staging script `work/stage-installed-tree.bash`, prepared for the Python implementation, are not used.
- D53, Decision Date: 2026-10-03, keeps verification-only tools in the test images; the Debian 13 test image adds `libtool-bin` for T3 only.
- The EPICS build specification's `RELEASE file` and `Modifying configure/RELEASE* files` sections require fully resolved dependency paths and describe the consistency check. The current pinned `convertRelease.pl` and `EPICS/Release.pm` are the executable authority for parsing and comparison. GNU make-only expressions cannot be assumed to work in the Perl parser; verify proposed generated declarations through both real consumers.
- Baseline evidence is a complete Rocky Linux 8.10 installation built from repository commit `1219c9223dd4380852f30104e9abcb2d553a455a`, the state before the path correction, through the shipped configuration, build, and installation commands. The retained Rocky Linux 10.2 installation under `work/m14-implementation-20260930/` is not the baseline of the D51 revision. Record the baseline source and vendor commits, configuration, image digest, architecture, and actual root before baseline runs. Construct separate candidate fixtures from the current authorized implementation after acceptance; do not mutate the baseline.
- Services need a disposable Linux VM with systemd for the service-manager part of T4. Container-only syntax or direct binary checks do not satisfy that part. Preparing the verification environment is planned work; no service changes on the owner's host are authorized by this plan. The earlier Rocky Linux 10 VM is not reused; a disposable Rocky Linux 8.10 VM with systemd is prepared for the D51 revision. Use a Rocky Linux 8.10 VM created by cloud-provision under its owner's authorization; it is ready when systemd runs and the refreshed `caRepeater.service` can be installed through the normal operator procedure.

##### Premise Classification

Observed on 2026-10-01 from repository commit `1219c9223dd4380852f30104e9abcb2d553a455a` and the retained native installation. This is planning evidence, not candidate verification.

| Class | Target | Evidence And Next Check |
| --- | --- | --- |
| Confirmed finding | Installed module dependency metadata | The retained installation has 31 versioned module `configure/RELEASE` files. Actual installed asyn, autosave, StreamDevice, busy, and MCoreUtils files contain upstream EPICS base defaults; asyn's local override supplies module paths but no EPICS_BASE. Pinned `convertRelease.pl:checkRelease` reads each support module with its own TOP and compares its expanded dependencies. T1 must execute the real downstream build to establish which declarations currently fail; no baseline build failure is inferred from this inspection |
| Confirmed finding | Absolute metadata paths | The actual base site file, both base pkg-config files, three service/init files, uldaq libtool file, and open62541 pkg-config file name the original install root. Of 16 versioned module RELEASE.local files, 15 contain original tree paths; iocStats has only MAKE_TEST_IOC_APP=NO. T2-T4 verify functional consequences and the correction |
| Confirmed constraint | Installation copies configuration | `configure/RULES_BASE:install.base` and generated module install targets invoke upstream installation. Pinned base CONFIG_COMMON selects RELEASE* and RULES_BUILD for config installation; RULES_BUILD copies those files. The actual pinned installEpics.pl, executed with a copied installed CONFIG_SITE.local fixture and a destination containing an added operator comment, returned 0 but removed the destination comment when the source was newer. Upstream default make also installs output through RULES_DIRS/RULES_BUILD; build.base and generated module build targets invoke that path. Existing metadata must be preserved before these writers start; installed-output checks remain necessary |
| Hypothesis | Complete downstream dependency mapping | Not every module's dependency declarations and RELEASE include variants have been exercised as installed consumers. Step 1 inventories every selected module and compares the real parser output with effective build configuration; unsupported or conflicting declarations must be resolved before a transform is accepted |
| Hypothesis | Moved consumers and service execution | No moved-tree IOC, pkg-config compile/link, libtool consumer, or actual service-manager run has executed for M16. T2-T4 isolate the original root and execute those real paths; syntax or substring checks alone do not establish success |
| Owner decision | Relocation boundary | D50 selects expanded support instead of retaining the existing text-file exclusions. The explicit refresh utility, inventory, and CLI below are proposed implementation details of this draft, pending plan review and acceptance |

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-03 (America/Los_Angeles); the D51 revision of the expanded plan, after one third-person and two second-person reviews with all findings applied
Implementation Authorization: 2026-10-03 (America/Los_Angeles); implement the accepted D51 revision
Superseded Plan Artifacts: the Python-based expanded plan, accepted and authorized on 2026-10-02 (America/Los_Angeles) with all accepted review findings. Its text was never committed and is not retained separately; the D51 revision edited it in place, changing only the implementation language, the installed file names and invocation, the runtime prerequisites, and the Rocky Linux version and source of the baseline and test environments, as listed in D51 and Dependencies And Decisions

Accepted Plan Findings: On 2026-10-01, the first third-person plan review's four findings were accepted: persistent interruption/retry recovery, failed-reinstall completion-state handling, actual library use in pkg-config verification, and separate reinstall/refresh repetition expectations. The second third-person plan review's two findings were also accepted: preserve user metadata before upstream writers run, and reject installation/build writers while replacement recovery is unfinished. On 2026-10-02, the first second-person plan review's finding was accepted: identify the retained baseline installation and its source, image, command, and root evidence directly in this detail. These findings were incorporated in the superseded Python-based plan and carry over to the D51 revision, accepted and authorized on 2026-10-03. The baseline-identification finding is satisfied again only after the Rocky Linux 8.10 baseline is built and its source, image, command, and root evidence are recorded here.

1. Establish the complete inventory and baseline. Inspect the actual selected module set and install locations from `configure/CONFIG_MODS`, `configure/RULES_MODS`, `configure/RULES_FUNC`, and installed configuration. Resolve every included RELEASE variant using the pinned EPICS parser and compare it with the effective source/build configuration. Record declared dependencies, versioned destinations, optional vendor metadata, original root, architecture, external paths, and file modes without assuming the documentation's earlier counts are permanent. Run the baseline portions of T1-T4 in disposable fixtures. Keep inspection findings separate from executed baseline outcomes.
2. Define a small installed inventory that records only managed file paths, field types, selected module dependencies, current root, and format version. Define a separate tree-local persistent operation record for incomplete installation or replacement/recovery state; its file locators must be relative to the selected tree so recovery does not depend on an unavailable old root. Derive dependency declarations from the actual configured build, not guessed module names or a recursive string replacement. Validate that all managed relative file locators stay inside the tree and that the resolved dependency declarations are accepted by both GNU make and EPICS::Release. Retain public external dependency values without rebasing them. Unknown or unsupported declarations stop with a diagnostic. The inventory supports fresh installs; importing older installations without that inventory is outside this first implementation.
3. Implement one metadata preparation/refresh utility under `tools/` and install its runnable copy plus inventory at the tree root through `configure/RULES_INSTALL`. Normalize only installed EPICS-env-managed dependency declarations and the listed metadata fields. Retain upstream source files and source-side build configuration. Refresh determines the selected new root from the installed utility's location or one explicitly supplied tree path, validates the entire update, and leaves ordinary shell sourcing read-only. The installed interface is `perl <tree>/relocateEpicsEnv.pl --check` or `--apply`, with optional `--tree <absolute_tree>`; absent --tree, use the installed file's own resolved location. Require exactly one operation, with --help returning 0. Check returns 0 when current, 1 when managed updates are needed, and 2 on invalid input, unfinished recovery, incomplete installation, or an inspection error, without writing. Apply returns 0 only after a complete update or verified no-op, 2 on preflight error or incomplete installation, and 3 on replacement failure or an invocation handling unfinished recovery, including a successful rollback. The latter reports the rollback outcome and requires a separate apply invocation for a new update. The install-only inventory creation path requires explicit configured dependency inputs; it is not inferred from old installed defaults.
4. Finalize installation after every installation prerequisite succeeds. Adjust only the necessary installed-output integration in `configure/RULES_INSTALL`, `configure/RULES_BASE`, generated module rules in `configure/RULES_FUNC`, and their aggregation in `configure/RULES_MODS_BUILD`. Guard full and partial install entry points and build/base/module entry points before invoking upstream make, because upstream default builds install output. The shared preflight rejects unfinished replacement/recovery without modifying installed metadata, the operation record, inventory, or backups; it must not convert that state into an installation record. On a previously finalized tree, verify and persist original metadata/modes/inventory snapshots and incomplete-install state before any writer can overwrite them. Reuse the original verified snapshots on retries from incomplete-install state; never replace them with partial output. Preserve the standalone targets' existing partial-install behavior while keeping the previous completed inventory ineligible for refresh. After upstream installation, reconcile newly configured managed fields with the original unmanaged settings, comments, and includes; unsupported or ambiguous reconciliation stops with retained snapshots. On installation failure, restore and verify the preserved metadata, keep incomplete-install state and snapshots, and identify any restoration failure. Successful metadata restoration alone never marks binary/module installation complete. Complete `make install` finalization must not race under parallel make; clear incomplete-install state only after every required prerequisite, preservation check, and metadata preparation succeeds. Reinstallation regenerates metadata from the newly built configuration and runs the same validation rather than retaining a stale old-root inventory. Track source-derived managed metadata and `.versions` changes separately from refresh no-op checks. Close fresh-install consistency, writer-path protection, failed-reinstall detection, and target-order behavior with T1 and T5.
5. Implement file-specific handling for base and module dependency/site files, base/vendor pkg-config files, libuldaq.la, and the three installed service/init files. Preserve non-path options, user settings, comments, includes, and legitimate external paths; installation preparation uses the pre-writer snapshots from step 4 so upstream copying cannot erase the preservation inputs. Treat the iocStats local file without managed paths as unchanged. Store and verify backups before replacing changed files; use same-directory replacement and mode preservation. Persist all recovery inputs before the first replacement and retain them until every replacement and the new inventory are verified. On a new invocation, inspect this record before normal path inspection: check reports unfinished recovery; apply verifies backups and before/after hashes, restores the previous metadata/modes/inventory, and returns 3 without beginning a new update. Keep a record usable after another interruption during rollback; unknown file contents or invalid backups stop recovery with an exact diagnostic rather than overwriting them. Do not rewrite a file with an ambiguous field, change binaries, modify another installed tree, or contact a running system service. Close moved-root functionality with T2-T4 and failure/repetition behavior with T5.
6. Update `docs/src/concepts/installed-tree.md`, the build/install and install-location procedures, `docs/src/reference/make-targets.md`, and `docs/src/reference/tools-and-scripts.md`. Add a focused book procedure for the actual move-and-refresh operation and include it in SUMMARY.md. State required Perl and consumer tools, supported OS/architecture, original-root isolation in verification, backup/recovery behavior, and the need to reinstall/reload system service copies separately. Update the existing installed-fix verification procedure only where its installed-path assumptions actually change. Do not claim that arbitrary consumer files or external system registration move automatically.
7. Run T1-T6 against the real shipped code and fixtures, then record actual results, exact tested source hashes, environment identities, command statuses, inventories, and required publication checks here. A missing environment leaves the affected check Pending. Review the final changed documentation from the reader's seat before commit preparation. Project the accepted scope and later observed results to #89 only under separate issue authority; implementation, publication, and closure follow their own authorization.

##### Test Plan

Local tests run on pinned native Rocky Linux 8.10 and independently built Debian 13 installations. The earlier Rocky Linux 10.2 runs belong to the superseded Python implementation. Keep separate baseline/candidate trees and their real vendor libraries; exact published-commit CI remains Pending. Do not change the owner's installation or earlier evidence. The candidate is generated through the shipped configuration, build, installation, and refresh paths; hand-built installed metadata or substituted internal functions are not fixtures. Retain failing fixtures and exact command/status records. T6 requires an independently generated Debian 13 relocated consumer check in addition to the existing CI runs. An unavailable fixture leaves that check Pending; no macOS or Libera result is inferred.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Fresh installation and downstream IOC | Run actual shipped build/install and finalization on an independently configured candidate. Generate an example IOC with installed makeBaseApp.pl, configure a real module dependency chain, and build with CHECK_RELEASE=YES. Execute the real consistency checker for each inventory-selected installed dependency declaration and include variant. Observe the baseline on equivalent original-root paths | Pinned Rocky Linux 8.10; source/configuration and vendor pins recorded; original install and evidence read-only | Candidate install and downstream build return 0 with checking enabled; installed base/module declarations match the selected versioned dependencies; any baseline failure is captured from execution. Original source configuration is unchanged by installed metadata preparation |
| T2 | Relocated IOC, loader, and shell | Move a complete candidate tree from A to B, make the old root and original checkout unavailable, invoke the installed refresh utility, and regenerate/rebuild the same real IOC. Run the built IOC through iocInit and exit. Source the installed setup twice. Provide exact shipped checker scripts as separate read-only verification inputs and run check_env.bash --epics <B> --strict --require-run and check_deps.bash <B> directly | Same native OS/architecture; disposable container with relocated tree, consumer workspace, and read-only shipped checker scripts; original checkout and root A unavailable; real make/Perl/compiler/loader | IOC checkRelease, build, link, and startup succeed using B. Shell paths select B without duplicate managed entries; check.deps succeeds with original loader policy. No dependency on A, the source checkout, or a consumer-side check bypass |
| T3 | Build metadata consumers | At A and then B, query both EPICS base pkg-config variants and installed open62541.pc with real pkg-config. Compile/link/run an EPICS consumer that calls ca_context_create, ca_context_destroy, and epicsThreadGetIdSelf. Obtain compilation/linker flags from each pkg-config variant and EPICS library names from EPICS_BASE_HOST_LIBS in the architecture-specific provider, converting its ca/Com values to library arguments; record the complete inputs rather than assuming --libs supplies library names. Run vendor consumers that call exported APIs declared by the actual installed headers, including a real libtool link through libuldaq.la. Record runtime-loaded library paths and canonical destinations using the real loader, not only textual flags. Keep external system libraries available and record baseline moved-root results separately | Same native fixture; original root unavailable after move; actual vendor libraries, pkg-config, libtool, compiler; API-calling consumer sources and exact link commands retained | Both base variants compile/link/run the API-calling consumer and load the selected ca/Com libraries from B. The open62541 and libtool consumers likewise call their real library APIs and load the tree-local libraries from B. An empty program or a link that never uses the target library does not satisfy this check. External dependency paths are preserved. Missing optional tree-local vendor metadata is classified explicitly, while missing required selected metadata fails |
| T4 | Installed services | After refresh at B, verify syntax and execute the shipped S99caRepeater and S99logServer start paths in an isolated namespace; observe the actual executable path and readiness, then terminate only captured child processes. In a disposable systemd VM, install the refreshed caRepeater.service through the normal operator procedure, reload, start, inspect ExecStart/MainPID and readiness, then stop it | Disposable Rocky Linux 8.10 namespace and systemd VM; free CA/log ports and isolated log output; original root absent; no owner-host service writes | Both init paths and the service manager execute real binaries from B and become ready; stop succeeds. File syntax checks and direct binary startup do not substitute for the service-manager test. Existing service copies outside the tree remain unchanged until the explicit operator procedure runs |
| T5 | Repetition, preservation, and failure | Run installation preparation/reinstallation twice, separately from two same-root refresh invocations; relocate A->B->C and compare contents/modes/symlink targets, inventories, and backup counts. Add operator comments, unmanaged options, and supported includes to actual installed metadata, make source configuration newer through the real configuration path, and verify preservation after successful reinstall and after a writer fails following a real installed-file copy. Retain original snapshots across the failed install and full-install retry; cover ambiguous reconciliation and restoration failure. Record expected source-config copies of managed fields, inventory regeneration, and .versions/timestamp/installation-backup changes separately. Exercise full install, install.base, install.modules, generated install.<module>, build, build.base, build.modules, and generated build.<module> writer entry points; cover build-path failure after installed output has changed and before finalization. Invoke both check and apply before repairing incomplete state through a successful full install. Cover partial targets, existing backups, another installed tree, versioned aliases, optional absent vendors, missing inventory/required files, ambiguous fields, read-only files, escaping symlinks, and real replacement/backup failures. Kill the actual refresh process with SIGKILL after at least one replacement and before completion, observe persisted state and mixed contents, and attempt the real install/build writer entry points while recovery is unfinished. Compare metadata, operation record, inventory, and backups before/after each rejected writer. Run check, then restart apply for rollback; also interrupt rollback and verify the next invocation can finish it. Test missing/altered recovery inputs and a separate clean retry after rollback. Exercise serial and parallel install prerequisite ordering | Independently restored disposable real installations; failures only at outer filesystem/process boundaries; no substituted internal refresh/install functions; captured original snapshots, inventories, operation records, statuses, and loaded real paths | Same-root refresh changes nothing and creates no additional backups. Reinstall changes only the expected managed fields and normal installation records while preserving original user settings, comments, and supported includes. Successful and failed writer paths preserve verified original snapshots; failed installation restores preserved metadata or reports exact incomplete restoration, without claiming binary/module completeness. A full-install retry reuses original snapshots and completes reconciliation; ambiguous reconciliation cannot finalize. All install/build writers reject unfinished replacement/recovery before upstream writes, return nonzero, and leave metadata, operation record, inventory, and backups unchanged. Installation backups and .versions are not judged by the refresh no-op assertion. Each move uses its current root. Failed reinstall and partial-install state cause check/apply to return 2 despite a prior completed inventory; only successful full installation clears that state. Unfinished replacement causes read-only check to return 2; apply restores verified prior contents/modes/inventory and returns 3, including after interrupted rollback. Invalid recovery inputs remain recorded with exact diagnostics. A later separate clean apply succeeds and then repeats unchanged. Managed changes retain verified backups; unrelated files and the original tree remain untouched. Preflight errors change no managed metadata or completed inventory; incomplete installs never report successful finalization |
| T6 | Documentation and native regression | Read every changed procedure against the shipped CLI and executed outcomes; build the actual mdBook. Run syntax/lint checks for the changed utility and shipped install checks. Observe existing six OS workflows, Linter Run, and Deploy Docs on the exact published implementation commit; run the T2 downstream build/startup and T3 pkg-config consumers against an independently generated Debian 13 native relocated fixture | Current repository, actual mdBook tooling, published implementation commit and native CI | Documentation matches observed behavior and all required checks succeed. Source pins, module dependency audit, patch behavior, loader policy, and shell selection remain intact. Unexecuted relocation or service checks remain Pending regardless of successful CI |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Builds 2026-10-03T08:46:02Z-09:40:32Z; consumers 17:40:55Z-17:42:44Z | Rocky Linux 8.10 and Debian 13 containers; pinned sources and vendors; baseline Rocky Linux 8.10 built from `1219c9223dd4` | Pass | Candidate patch, configuration, dependency audit, build, install with finalization, aliases, and checks return 0 on both systems. All 32 selected modules pass the installed parser and the real checkRelease; an IOC generated with makeBaseApp.pl builds with CHECK_RELEASE=YES and completes iocInit. Baseline: 30 of 31 checkRelease runs and the downstream build fail (status 2). The 173 source `configure/RELEASE*` and `CONFIG_SITE*` files are identical between the baseline and candidate checkouts |
| T2 | 2026-10-03T17:41:24Z (Rocky Linux 8.10), 17:43:11Z (Debian 13) | Candidate copied to /relocated/tree-b; root A and the source checkout absent | Pass | Installed `relocateEpicsEnv.pl`: check 1, apply 0, check 0, and two repeated applies 0 with the full tree snapshot unchanged. Setup twice without duplicate entries; `check_env.bash --strict --require-run` and `check_deps.bash` return 0. The rebuilt IOC completes iocInit with ca, Com, dbCore, dbRecStd, pvAccess, and pvData loaded from B. The baseline copied the same way fails 35 consumer commands |
| T3 | Same runs as T1 and T2 | Same containers; real compiler, pkg-config, libtool, and vendor libraries | Pass | 82 consumer commands per system and root return 0 at A and at B: both base pkg-config variants compile, link, and run the CA consumer with ca and Com loaded from the selected root; the open62541 consumer and the libtool link through `libuldaq.la` run with the tree-local libraries. The Debian 13 test image adds `libtool-bin` for this check only (D53) |
| T4 | Namespace 2026-10-03T17:43:24Z; systemd start 2026-10-03 11:17:56 PDT | Rocky Linux 8.10 container namespace; disposable Rocky Linux 8.10 VM from the cloud provisioning service, with systemd and SELinux Enforcing, run under its owner's authorization | Pass | S99caRepeater and S99logServer run the binaries under B, own UDP 15065 and TCP 16500, and the captured processes stop. On the VM the installed utility refreshes the unpacked tree to /opt/m16/tree-b (check 1, apply 0, check 0); after `restorecon` and the operator unit installation, systemd runs `/opt/m16/tree-b/base/bin/linux-x86_64/caRepeater` as MainPID 2413 owning UDP 5065; stop gives MainPID 0 and inactive, and the installed unit is removed |
| T5 | 2026-10-04T02:13:20Z-03:54:59Z | Rocky Linux 8.10 and Debian 13 containers; disposable copies of the complete candidates (checkout and installed tree at their build paths) and of the T2/T3 tree at B; a separate build per system against vendors installed outside the tree | Pass | Transactions 52/52 per system: SIGKILL of the actual refresh after a replacement leaves the operation record; check returns 2; all eight install/build writer entry points reject it with metadata, record, inventory, and backups unchanged; apply restores and returns 3, also after a killed rollback; separate clean retry, repeated no-op, and A->B->C each use the current root; seven invalid inputs and missing or altered recovery inputs stop with exact diagnostics. Writers 112/112 per system: ordinary backups and absolute and relative operator includes survive serial and parallel full installs; reinstall preserves comments, options, includes, and modes; a failed `install.base`, a failed `build.base`, a removed include after the observed upstream copy, and a read-only configure directory during restoration each keep the original snapshots and leave check/apply at 2 until a full install; ambiguous reconciliation cannot finalize; seven partial targets leave incomplete state until a full install. Settings, CRLF, unmanaged local file, alias, backup-directory failure, and real replacement failure (restored, 3) plus ten invalid-structure invocations: 49/49 per system. External vendors only: 11/11, 52 managed files, 94 external vendor files unchanged |
| T6 | Local 2026-10-04T04:31:26Z-04:32:43Z; CI 2026-10-04T05:38:02Z-06:00:31Z | Rocky Linux 8.10 and Debian 13 target images; `jeonghanlee/mdbook:0.5.4` (`2b53e59ebf0e`) with the repository mounted read-only; GitHub Actions on `master` at `a39e8b44de29056d789dd87b1a05104655495e40`, whose implementation files are those of `965a9a2cffbbde360b18c7221aaacae468fa9dca` | Pass | The documented move procedure and tools-reference commands run on a copy of each T2/T3 tree: move, check 1, apply 0, setup selects the new base, check 0, repeated apply leaves the full snapshot unchanged, `--check --tree` 0, `--help` 0, no operation 2; 10/10 per system, and 10/10 on Rocky Linux 8.10 with the `perl-Digest-SHA` package removed so the `sha256sum` fallback runs. `perl -wc` and `podchecker` pass on Perl 5.26.3 and 5.40.1; all 13 loaded modules are present on both prepared targets; `--help` lists exactly the four public options the parser accepts. The book builds with `docs/src` unchanged; no rendered page or source document names the Python utility. `git diff --check` and the untracked files are clean. Shipped `check.env` and `check.deps`, patches, and the dependency audit return 0 in both candidate builds; the Debian 13 candidate is an independently generated native fixture whose relocated consumers pass under T2/T3. All six OS workflows succeed (Debian 12 37180430147, Debian 13 37180431530, Rocky 8 37180430140, Rocky 10 37180430127, Ubuntu 24.04 37180430114, Ubuntu 26.04 37180430102); each log records `Installed metadata finalized for /github/home/epics/1.4.0/<os>/7.0.10.` and the EPICS Environment Check step succeeds. Linter Run 37180430128 and Deploy Docs 37180430108 succeed. Recheck: `gh run view <id> --log` |

The Python implementation's results of 2026-10-02 (T1-T5 Pass, T6 local portion Pass with published CI Pending, on Rocky Linux 10.2 and Debian 13) are superseded by D51; their result records remain under `work/m16-implementation-20261002/` and in Tested Sources And Evidence below. Its four build trees (`debian-native`, `rocky-final-native`, `qualified-writers-native`, `optional-vendors-native`) were removed on 2026-10-03 to free disk space for the Perl T5 fixtures; their `*-results` records are retained.

###### Perl Implementation Evidence

All paths below are relative to `work/m16-perl-20261003/`.

- Tested sources: repository commit `1219c9223dd4380852f30104e9abcb2d553a455a` with the working-tree overlay `tools/relocate_installed_tree.pl` (`d41a892ffef0f8e6`), `configure/RULES_FUNC` (`b346497d993e1adc`), `configure/RULES_BASE` (`1e3602105ae54fe8`), `configure/RULES_INSTALL` (`bdc019c9b733e3df`), `configure/RULES_SRC` (`da71ffb0ecb2f0f2`), and `configure/RULES_MODS_BUILD` (`a250b8435a9ebc19`), SHA-256 prefixes. The installed `relocateEpicsEnv.pl` of both candidates is identical to the source. Module and vendor pins are the 39 source/submodule bundles and four vendor commits of the Python evidence.
- Images: `m16-local/rocky8-perl:20261002` (`aeb1f3d10fb4`) from `rockylinux/rockylinux:8` with the `rocky8.yml` package step and pkg_automation `60de819`; `m16-local/debian13-perl:20261003` (`c14dd5a2f49c`) from `debian:trixie-slim` with the `debian13.yml` package step and `60de819`; `m16-local/debian13-perl-verify:20261003` (`fcd71753c6f0`) adds `libtool-bin` for T3 only.
- Records: `native/<fixture>/evidence/steps.tsv` and `logs/` for each build; `verification/results/<run>/` for T1-T4; `verification/results/rocky8-t4-systemd-vm/` holds the VM output and its provenance.
- The real installation path exposed two port defects, fixed before these results: an inherited install lock was lost one writer level down because adopting the descriptor with `open(..., '<&=')` marked it close-on-exec again, and `sort bsd_glob(...)` parsed `bsd_glob` as the sort comparator so an absent module `configure/RELEASE*` pattern was treated as a file. In both failures the writer restored the original metadata and returned 2.
- Against the Python utility on a retained Debian 13 tree at the same path, nine check, apply, and invalid-state steps return the same statuses with identical stdout, and the 55 managed files and the inventory match after apply.
- T5 records: `t5/<system>/` (transactions), `t5/<system>-writers/results/` (backups, includes, reinstall, writer failures), `t5/<system>-extra/relocated/extra-results/` (settings, filesystem failures, invalid structures), and `t5/<system>-optional/evidence/` (external-vendor build steps and results), each with `commands.json` or `steps.tsv`, statuses, stdout, stderr, and the image identity. Drivers: `t5_transactions.py`, `t5_writers.py`, `t5_extra.py`, `t5_optional.py`, run by the matching `run-*.bash`. For disk space, `t5/` is a symbolic link to the same directory on a separate data disk.
- T6 local records are on the same separate local data disk, in `t6/`: `<system>-doc-commands/` and `rocky8-no-digest-sha/` (driver `t6_doc_commands.py`, run by `run-doc-commands.bash`), and `mdbook/` (build log and rendered book). The `make exist LEVEL=1` listing in `build-and-install.md` is the observed Debian 13 output; Rocky Linux 8.10's `tree` 1.7.0 prints the same entries with "4 directories" because it does not count the top directory, and the procedure states this. The reader review of the changed documentation (2026-10-04) corrected that listing's label, added the meaning of the external dependency lines to both procedures, and added the `tree` count note; the following reader pass found nothing further, and the book rebuilds.
- The restoration-failure fixture of the Python test made the configure directory read-only after the upstream copy and relied on a later upstream install into that directory to fail the writer. On Rocky Linux 8.10, `CONFIG_SITE.local` is the last file installed there, so the writer succeeded and left the expected partial-install state instead. The Perl fixture also obstructs one installed header, so the real base build fails after the configure copy regardless of install order; the injection stays at the filesystem boundary.


###### Tested Sources And Evidence

All paths below are relative to `work/m16-implementation-20261002/`. `verification-summary.json` holds exact command statuses/times, final source hashes, all 39 pinned source/submodule commits, image identities, actual loaded library paths, and version-qualified earlier evidence. Raw failing fixtures and logs are retained; incomplete copies, inherited loader environments, failed fault injection, and harness failures do not count as passing verification.

| Production input | Final SHA-256 |
| --- | --- |
| tools/relocate_installed_tree.py | 6d4b8ce97e0ff3925f420bc5b5016cfea94d3c4b5c1e6659febd174b34ca62e4 |
| configure/RULES_FUNC | 22ba6bec7f713d22797b568ea3be6fa8e5214083d4ace8f5d867102d3b12a336 |
| configure/RULES_INSTALL | bdc019c9b733e3dfddd644b85f894e1af1a89a3b500874dff2efb52185227eff |
| configure/RULES_BASE | 1e3602105ae54fe845fb17b42614b046337ead4852cd8eb45186e1621e6c6f54 |
| configure/RULES_SRC | da71ffb0ecb2f0f2c83ba4cb9d4b9530259b1f3a47d37af3cb24f63ef32bb08e |
| configure/RULES_MODS_BUILD | a250b8435a9ebc19857be6f0002adc8bc7c26a31761a0a470cf60479074eb66a |

- Final utility identity is verified against the actual installed copies in Rocky, Debian, and optional-vendor installations. Final evidence is `rocky-final-install-results`, `debian-final-install-results`, `rocky-final-move-v2-results`, `debian-final-move-v2-results`, `final-transaction-results`, `qualified-writer-repair-final-results`, `qualified-writer-final-results`, `optional-final-results`, and `final-static-results.json`.
- The independent fresh Rocky pipeline uses utility SHA-256 `90b798b82f80acc4a2c38f565084b19ad4b387e4255b2bafdffa94eef0e4d9fb`, with the same five final make-rule hashes. Its commands and source hashes are in `rocky-final-native-results`; final real installation and moved consumers qualify the final utility. Debian source/build evidence is in `debian-native-results`, `debian-resume2.status`, and their retained build logs; final real installation and moved consumers qualify the final utility separately.
- Earlier original-root API/IOC qualification uses utility SHA-256 `598575446cb654d20680c3bb5c72d7c6763b18c63da710c3e6ada76fb6191a04`: `rocky-qualified-a2-consumers` and `debian-13-qualified-a-consumers`. `qualified-doc-command-results` executes the actual move, default shell source, check/apply, explicit --tree, and --help at that version. The invalid inventory/operation JSON tests and actual build-path failure use utility SHA-256 `a8f1592ce4366ba771a8245416385f5dddf448b28d10fcf45d6b107fce18dd50`, in `invalid-state-qualified-results` and `qualified-writer-failure-results`; all ten invalid-state assertions pass, and failed build remains incomplete until full retry. The final missing-include test executes the corrected final code through the actual writer.
- `native-fresh/pins.json` records the 39 source/submodule commits. EPICS base is `bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77`; vendor repositories are uldaq-env `988b1523a759855b5e98c23e3cde050ab8d1b26e` and open62541-env `00e5e60eb24a64d94578b608538d4288c90a0dbf`, with actual library sources uldaq `c7b94531185ff098af166da2be1f3a4a648cfa96` and open62541 `3eed1a6d5c5b207c531b2d35ed88aa0a4a4541e5`. Debian builds these genuine vendor sources independently.
- Native images: Rocky `sha256:a53abde34d5aeede81d01df6fe5954be5fc62eea8846777a9f59b1038c11aff9`; Debian `sha256:3145f98f5e72ffd89b99a7fe4d86a31a0c32650c879ca7a2c0b0c703fa84dba5`. Book image: `sha256:2b53e59ebf0edf2913e0636ff2e31351f0f0c4c7593fb51d1f22b4b629173015`. Consumer containers have a native network interface for actual PVAccess startup and clean inherited EPICS/loader settings. Original A paths and source checkout are absent from moved consumer mounts; only exact shipped checker scripts are separate read-only inputs.
- Normal installed inventories select 32 versioned modules and 54 managed files. The absolute/shared-include preservation fixture adds one operator file, producing 55 managed files: 47 RELEASE/include files, one base site file, three pkg-config files, three shell/libtool files, and one systemd file. Actual parser and checkRelease run for every selected module; IOC and four API consumers verify use of these declarations. `iocStats`' unmanaged local setting is preserved. The external-vendor fixture has 52 managed files, reports both absent optional tree-local vendor files, and preserves all 415 genuine external vendor files unchanged.
- Baseline runs use read-only retained M14 installation evidence. `baseline-a2` records actual original-root parser/consumer results and downstream build status 2. `baseline-move-complete-results` uses the complete 31-module baseline with A unavailable: real consistency/IOC build status 2 and base/open62541 compilation status 1. Actual baseline uldaq libtool linking and API execution return 0; no libtool failure is inferred from its old textual libdir. The earlier incomplete baseline copy is excluded.
- `reinstall-results` retains actual successful partial install/build writers and incomplete-state/full-retry results; `relocated/extra-results` retains non-path options, external settings, CRLF, backups, modes, and real replacement/backup failure observations. `init-results/results.json` and `systemd-final-results.log` retain actual service process/socket/start/stop outcomes. `mdbook-final.log` records the actual successful read-only-source book build, with output under `book-final`; `doc-tree-results` retains actual listing outputs.

##### Closure Evidence

- Complete on 2026-10-03 (America/Los_Angeles): the accepted Perl deliverable, required verification, publication, and linked-issue closure are satisfied.
- The sixteen-file implementation is published in `965a9a2cffbbde360b18c7221aaacae468fa9dca` and its verification record in `a39e8b44de29056d789dd87b1a05104655495e40` on `origin/master`. At 2026-10-04T06:15:09Z, `git ls-remote --exit-code --heads origin refs/heads/master` resolved `a39e8b44de29056d789dd87b1a05104655495e40`, and `origin/master` contains both commits.
- T1-T5 pass on native Rocky Linux 8.10 and Debian 13; T6 passes locally and with all six OS workflows, Linter Run, and Deploy Docs on the pushed commit, as observed above.
- #89's body was rewritten to match the published implementation and real verification results, with both acceptance criteria checked. The completion comment is https://github.com/jeonghanlee/EPICS-env/issues/89#issuecomment-5977226520.
- #89 was closed as completed at 2026-10-04T06:14:49Z. At 2026-10-04T06:14:50Z, `gh issue view 89 --repo jeonghanlee/EPICS-env` reported `state=CLOSED`, `stateReason=COMPLETED`, two checked and no unchecked boxes, and a body equal to the prepared text.
- The Python implementation and its local verification of 2026-10-02 are superseded by D51 and were never committed. Under the owner decision of 2026-10-03, the untracked `tools/relocate_installed_tree.py` was removed after this closure; its SHA-256 before removal began with `6d4b8ce97e0ff392`, matching the final Python utility in Tested Sources And Evidence.
- D54 (2026-10-04) retires the delivered mechanism: a peer's finding that a full install over a tree from another EPICS-env commit stops at reconciliation (`GENVERSIONDEFAULT` differs by `git describe`) led to re-examining the premise, and K11 records that nothing in this cloned environment reads the installed text metadata. The removal is M22; this closure record is unchanged as history.

##### GitHub Projection

Title: Resolve foreign and absolute paths in installed files
Labels: bug
GitHub Milestone: Backlog
Observed State: closed as completed (2026-10-04T06:14:50Z, `gh issue view 89 --repo jeonghanlee/EPICS-env`; closed_at 2026-10-04T06:14:49Z)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-10-04T06:14:50Z (remote updatedAt 2026-10-04T06:14:49Z)
Projection Difference: none. The live body matches the published Perl implementation, the native Rocky Linux 8.10 and Debian 13 verification, and the successful CI results. Both acceptance criteria are checked. After D54, the lead paragraph records the removal in `c1d38fd` and the retirement comment of 2026-10-04 explains it; the rest of the body remains the record of the withdrawn correction.

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

#### M22 - Relocation Mechanism Removal

Origin: 84ee626 / M22
Identity History: Opened on 2026-10-04 by D54 to undo the M16 delivery
GitHub Issue: #89 (closed; the retirement comment is prepared under separate issue authority)
Status: Complete

##### Summary

Remove the installed-tree metadata normalization and refresh mechanism that M16 published in `965a9a2cffbbde360b18c7221aaacae468fa9dca`. K11 records why the installed text metadata needs no rewriting in this environment.

##### Scope

- Revert the sixteen files of `965a9a2cffbbde360b18c7221aaacae468fa9dca` on `master`: `tools/relocate_installed_tree.pl`; the `METADATA_WRITE` wrapping and `metadata.*.raw` targets in `configure/RULES_BASE`, `RULES_FUNC`, `RULES_INSTALL`, `RULES_MODS_BUILD`, and `RULES_SRC`; `docs/src/procedures/move-installed-tree.md` and its `SUMMARY.md` entry; and the relocation passages in the other eight documents.
- Keep the M16 verification record and decisions as history; record the retirement in M16 Closure Evidence, K11, and #89.

Out of scope: changing how upstream installs any file; the `iocsh-module-loader` branch, which merges onto the reverted `master` and resolves its own conflicts; M1.

##### Completion Criteria

- `master` carries no reference to `relocateEpicsEnv.pl`, `relocate_installed_tree`, or `METADATA_WRITE` outside the milestone register and the archive.
- A native install from the reverted `master` produces the pre-M16 tree (no `relocateEpicsEnv.pl`, `.epics-env-paths.json`, or `.epics-env-backups`) and passes the shipped checks; the book builds.
- All six OS workflows, Linter Run, and Deploy Docs succeed on the pushed commit.

##### Dependencies And Decisions

- D54, Decision Date: 2026-10-04.
- K11 in `docs/CLOSED_DOORS.md` records the Keep verdict for the installed text metadata.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-04, owner direction in session
Implementation Authorization: 2026-10-04, owner direction in session
Superseded Plan Artifacts: none

1. Revert `965a9a2cffbbde360b18c7221aaacae468fa9dca` on `master` as one commit.
2. Record D54, K11, M22, and the M16 retirement note; prepare the #89 comment for separate issue authority.
3. Run T1-T3 and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Source | `grep` the repository for the removed names; compare the sixteen reverted files with `965a9a2^`; build the book | Repository checkout; `jeonghanlee/mdbook:0.5.4` | No reference outside the register and archive; the files are byte-identical to their pre-M16 state; the book builds |
| T2 | Native install | Build and install from the reverted `master` with pinned sources; run `check.env` and `check.deps` | Rocky Linux 8.10 container | The tree top holds only the pre-M16 entries and both checks return 0 |
| T3 | CI | Observe the workflows on the pushed revert commit | GitHub Actions on `master` | All six OS workflows, Linter Run, and Deploy Docs succeed |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-04T07:53:49Z (tree), commit at 08:04Z | Repository checkout at `c1d38fdb2f5354636fb211c78dccd9dcae073f26`; `jeonghanlee/mdbook:0.5.4` (`2b53e59ebf0e`) with the repository mounted read-only | Pass | No reference to `relocateEpicsEnv`, `relocate_installed_tree`, `METADATA_WRITE`, or `epics-env-paths` outside this register, `docs/CLOSED_DOORS.md`, and `docs/archive/`; all sixteen files are byte-identical to `965a9a2^`, the two added files are deleted; the book builds without the move page or any `relocateEpicsEnv` text |
| T2 | Build 2026-10-03T08:46:02Z-08:57:51Z; identity checked 2026-10-04T08:05:09Z | Rocky Linux 8.10 container `m16-local/rocky8-perl:20261002`, pinned sources and vendors | Pass | `git diff --stat 1219c92 c1d38fd -- . ':!docs/milestone-84ee626.md'` is empty, so the reverted code is the code the Rocky Linux 8.10 baseline was built from; that build's `install` and `checks` steps returned 0, and the installed tree top holds only `base`, `modules`, `vendor`, `setEpicsEnv.bash`, `resetEpicsEnv.bash`, and `.versions`. Evidence: `work/m16-perl-20261003/native/rocky8-baseline/evidence/steps.tsv` |
| T3 | 2026-10-04T08:07:40Z-08:30:09Z | GitHub Actions on `master` at `ce22dcdd2c36d322fefe339bc64408029d64c274`, whose code is that of `c1d38fdb2f5354636fb211c78dccd9dcae073f26` | Pass | All six OS workflows succeed (Debian 12 37187883784, Debian 13 37187883849, Rocky 8 37187883793, Rocky 10 37187883826, Ubuntu 24.04 37187883808, Ubuntu 26.04 37187883789); no OS log mentions `Installed metadata finalized` or `relocateEpicsEnv`. Linter Run 37187883798 and Deploy Docs 37187883866 succeed. Recheck: `gh run view <id> --log` |

##### Closure Evidence

- Complete on 2026-10-04 (America/Los_Angeles): the revert, its verification, and publication are satisfied, and the linked #89 is closed.
- The revert is published as `c1d38fdb2f5354636fb211c78dccd9dcae073f26` and this record as `ce22dcdd2c36d322fefe339bc64408029d64c274` on `origin/master`; `git ls-remote --exit-code --heads origin refs/heads/master` resolved `ce22dcd` after the push, and the local tree was clean.
- T1-T3 pass as recorded above.
- #89 remains closed as completed (2026-10-04T06:14:49Z). Its lead paragraph now records the publication in `965a9a2` and the removal in `c1d38fd`, and the retirement comment is https://github.com/jeonghanlee/EPICS-env/issues/89#issuecomment-5978229430 (posted 2026-10-04T08:46:00Z; read back at 08:46:01Z with `state=CLOSED`, `stateReason=COMPLETED`, body equal to the prepared text).

##### GitHub Projection

Title: none; the retirement is recorded on the closed #89
Observed State: closed as completed (2026-10-04T08:46:01Z, `gh issue view 89 --repo jeonghanlee/EPICS-env`; updatedAt 2026-10-04T08:46:00Z)
Last Compared: 2026-10-04T08:46:01Z
Projection Difference: none. The #89 lead paragraph and the retirement comment describe the removal; the rest of the body remains the record of the withdrawn correction.

#### M1 - EPICS::Path Normalize/RelPath

Origin: 84ee626 / M1
Identity History: none
GitHub Issue: #25, https://github.com/jeonghanlee/EPICS-env/issues/25
Status: Not started

##### Summary

`makeRPath` computes relocatable `$ORIGIN`-relative rpath entries. Removing its bare-`python` dependency (the fragility behind #18) requires re-implementing in Perl the lexical path algebra Python's `os.path` provides as primitives; the earlier straight port (upstream PR #589) regressed at exactly this point and was reverted. The proper fix builds the missing primitive once in the shared module and has `makeRPath` consume it.

##### Scope

Additive extension of `src/tools/EPICS/Path.pm`, leaving `AbsPath` untouched: `Normalize($path)` (lexical, no-stat normalization of `.`, `..`, `//`, trailing slash) and `RelPath($target, $base)` (Normalize both, then relativize). The missing operation is lexical `..` collapse without `stat`: `File::Spec->abs2rel` does not normalize embedded `..`, `canonpath` does not collapse `..`, and `Cwd::abs_path` / `EPICS::Path::AbsPath` collapse `..` only by touching the filesystem, unusable for a not-yet-existing `--final` path. Full edge catalog: `docs/makeRPath-perl-port/relpath-design-analysis.md` at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the file is not on `master`.

Delivery (D52): one local patch on the pinned EPICS base adds the primitives and `src/tools/makeRPath.pl`, removes `src/tools/makeRPath.py`, and repoints `MAKERPATH` in `configure/CONFIG_BASE` and the script entry in `src/tools/Makefile`. The patch has its own apply and revert rule and a row in `patch/README.md`.

Out of scope: a straight port that hand-rolls the algebra inside the leaf tool.

##### Completion Criteria

- `makeRPath` consumes the shared `Normalize`/`RelPath` primitives.
- `AbsPath` is unchanged.
- The reverted straight-port regression does not recur on the edge catalog.

##### Dependencies And Decisions

- D52, Decision Date: 2026-10-02, assigns this work to the Milestone on `master` and selects delivery as a local patch on the pinned EPICS base.
- M16 is a work-ordering dependency: this work starts after M16 completes. It is not a behavioral constraint.

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

#### M23 - Installed Module Loader For softIocPVX

Origin: 84ee626 / M22
Identity History: M22 until 2026-10-04; renumbered to M23 at the merge of `master`, which assigned M22 to the relocation mechanism removal
GitHub Issue: #93
Status: Complete

##### Summary

Run an IOC with the installed `softIocPVX` and an IOC-owned `st.cmd` that names modules, without compiling an IOC executable or installing e3-require. The installed `iocsh.bash` resolves the requested versions and their dependencies, validates the selected files, loads support, and runs the remaining startup commands.

The distribution already defines module names, versioned directories, dependency rules, and unversioned selection symlinks. Generate runtime metadata during installation so startup does not need the build checkout, Make, or any `.local` file.

##### Scope

- Generate version-specific metadata at installation from effective module names, version pins, declared dependencies, and installed artifacts. Proposed location: `modules/<name>-<version>/cfg/iocsh.conf`. Record a format version, module name/version, Base/architecture compatibility, distribution-relative artifact paths, exact dependency versions, explicit ordered library/DBD entries, and the environment macros needed by installed DB and iocsh files.
- Keep metadata with its module version. Do not embed absolute build/install roots or execute the metadata as shell code. Empty library or DBD lists support library-only and data-only modules. Derive entries by the default rule `lib<name>.so` with `<name>.dbd` (D64), and declare an explicit exception for every module whose installed names differ or whose list is empty; the installed inventory includes asyn with `asyn.dbd`, `drvAsynIPPort.dbd`, and `drvAsynSerialPort.dbd` (D77), StreamDevice as `libstream` with `stream.dbd`, iocStats as `libdevIocStats` with `devIocStats.dbd`, autosave as `libautosave` with `asSupport.dbd`, caPutLog by the default rule with `caPutLog.dbd` alone, since `caPutJsonLog.dbd` is its alternative and not a companion (D79), calc with `calcSupport.dbd`, sscan with `sscanSupport.dbd`, mca with `mcaSupport.dbd`, feed-core as `libfeed` with `feed.dbd`, recsync as `libreccaster` with `reccaster.dbd`, snmp as `libdevSnmp` with `devSnmp.dbd`, std, modbus, busy, and scaler with `<name>Support.dbd`, sequencer/seq as library-only (`libseq`, `libpv`) whose installed DBDs are examples, pcas as library-only (`libcas`, `libgdd`), and QPC as data-only with no library or DBD. A module whose default-rule files are absent and that has no exception fails metadata generation at installation. A candidate DBD that defines a Base menu or record type with a body is an expanded application DBD and is rejected at metadata generation, the Base names being those of the DBD native `softIocPVX` loads (`softIocPVX.dbd` with `base/dbd/base.dbd` and its includes); in the installed inventory `sscan.dbd`, `std.dbd`, `mca.dbd`, `snmp.dbd`, and `pmac.dbd` are such files, and the real `softIocPVX` loads them without error and can register support outside the selected graph, as `std.dbd` does with 68 asyn device entries resolved through the `libasyn.so` that `libstd.so` names in `NEEDED`, so only the install-time check prevents it. A record DBD may include a Base or PVXS file that carries menus only, and generation rejects a selected DBD with an entry that no selected, dependency, Base, or PVXS library exports (D68); `pmacInclude.dbd`, the pscdrv `pscSig.dbd`, and the rgamv2 `rgaInclude.dbd` are such files and stay out of the mapping. Do not load every installed example library or DBD.
- Record the effective module version and exact dependencies used by each successful build, including DBD/data-only dependencies, and tie that record to the generated artifacts. During module and distribution installation, generate runtime metadata from this build record and the installed artifact inventory; compare it with the effective installation configuration and reject stale or unproven combinations. Configuration queries alone cannot establish an artifact's build identity. The successful-build record is `modules/<name>-<version>/cfg/build-record`, beside the runtime metadata. It carries the source commit actually built, which must equal the commit of the pinned tag, and the build rejects a release file in the source checkout that names an undeclared dependency version or a module outside the selected tree. Validate artifacts and metadata before publishing the unversioned symlink; repeated installation must preserve other versions' metadata. Record build-declared dependencies as they are (D62): a declared dependency that the selected artifacts do not reference by ELF or DBD, such as asyn's calc, sscan, and sequencer, still loads in dependency order, and loading it is expected rather than a defect.
- Install `iocsh.bash` into the selected distribution at `base/bin/<EPICS_HOST_ARCH>/iocsh.bash` (D61). Sourcing that tree's `setEpicsEnv.bash` already places that directory on the executable search path, and `resetEpicsEnv.bash` already removes it; add no new search-path entry and no distribution-top `bin` directory. Setup repetition, switching trees, reset, and repeated base installation must leave the wrapper reachable only through the selected tree.
- Accept `m`, `mod`, and `module` as equivalent wrapper directives in the supplied startup file. Each accepts a literal module name and an optional exact version, in the six forms below. These are startup-file directives consumed before native IOC execution, not commands registered in the interactive IOC shell. The wrapper's show mode, `-n` or `--show`, prints the generated startup and exits without starting the IOC (D67).
- Resolve an omitted version through the unversioned module symlink. Resolve an explicit version through its exact versioned directory. Follow each selected module's recorded dependency versions rather than the dependencies' current default symlinks. Version strings are opaque; do not sort directory names or implement version ranges.
- Validate the needed directories, links, metadata, dependency graph, files, architecture, and Base compatibility during startup preparation. Cache resolved canonical paths and reuse them for libraries, DBDs, DBs, iocsh files, and module macros such as `LINSTAT`. Reject missing inputs, invalid metadata, cycles, and competing versions of one module before launching the IOC.
- Inspect selected ELF files using `readelf`: follow `DT_NEEDED`, search applicable `RUNPATH` entries with `$ORIGIN` relative to each actual library, and compare installed-module ownership and versions with metadata. Classify each resolved dependency as installed-module, distribution-vendor (`vendor/lib`, as `libopcua.so` resolves `libopen62541.so.1`), or system. Include native `softIocPVX` and its Base/PVXS dependencies. Preserve dependencies that exist only at the DBD or data-file level. Reject a selected library that leaves symbols undefined after its `DT_NEEDED` closure, Base, and its dependency modules are considered (D66); observed 2026-10-02 on the local Debian 13 tree, `libdevSnmp.so` names no net-snmp library in `NEEDED` and `dlload` fails with `undefined symbol: usmAESPrivProtocol` (recheck with `ldd -r <tree>/modules/snmp-<version>/lib/<arch>/libdevSnmp.so`). The check counts function and data symbols alike (D70), a rejected library fails its module build until the missing library is named on its link line (D75), the generated Base site configuration links with `--no-as-needed` so a named library is never dropped by its position (D73), the measComp site configuration names uldaq for the support library (D74), and the resolver is the installed `iocsh_elf.bash` that both metadata generation and the wrapper run (D72).
- Treat ELF inspection as validation, not proof of the native loader's actual selection. Account for `RPATH`, environment search paths, preloaded libraries, and system dependencies where relevant; reject detectable conflicting module candidates rather than silently selecting a different installed version. Verify actual loaded paths separately in the real IOC.
- Load each required support library and DBD once in dependency order. Supply Base and required module DBD include directories; issue one wrapper-generated `registerAllRecordDeviceDrivers(pdbbase)` after support loading and before the startup's DB loads and `iocInit`. Reuse support already supplied by native `softIocPVX` and reject incompatible requests for its already-loaded Base/PVXS versions. A library, DBD, or support-registration failure must stop before application DB loading and `iocInit`. One call suffices: in EPICS Base R7.0.10, `registerAllRecordDeviceDrivers.cpp` skips record types, device supports, and drivers already present in the registry and runs registrars and functions through `runRegistrarOnce`, so support that native `softIocPVX` already registered is not registered again; T8 confirms this by observation.
- Preserve the order of ordinary startup commands, the caller's working directory, terminal input, signals, and native process exit status. Wrapper syntax and dependency diagnostics identify the original startup filename and line. Native errors preserve the original message and exit status; run a generated copy of the startup file in which each wrapper directive line is replaced by a comment line, so native line numbers equal the original and only the filename differs, and report that filename mapping without assuming that `IOCSH_STARTUP_SCRIPT` changes native parser diagnostics. Write the copy to a disposable temporary file, open it, unlink it at once, and pass the open descriptor as `/dev/fd/N` to the native executable, as the prototype already does with its generated preamble (D65); nothing remains after `exec` and no cleanup runs after the IOC exits. Wrapper diagnostics name the original file and the `/dev/fd/N` path. The IOC startup owns identity, port configuration, DB loading, common iocsh calls, and `iocInit`.
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

- D55 fixes the installed-distribution boundary and install-time metadata; D56 fixes version selection and one-time resolution; D57 fixes directive aliases and diagnostics; D58 includes ELF search validation and actual loader verification.
- D59 excludes GitLab-hosted IOC sources, retains all three public candidates, and requires separate startup and communication/data-update results for each. The candidate matrix describes scope, not verified runtime compatibility.
- No dependency on M3 or M5: the installed commonIocsh fragments already exist; promotion to a separate module repository and a global startup file are separate deliverables.
- M16 concerns installed build-configuration portability; this wrapper's runtime path must not consume those configuration files. Do not use M16 completion as a substitute for the relocation check here.
- Preserve the existing environment selector under D41 and CLOSED_DOORS K9. This work integrates with direct sourcing of the selected tree's setup script.
- D60 makes `tc32sim` the first integration example and requires functional checks for linStat, retools, autosave, and caPutLog. Work is assigned to `iocsh-module-loader`; complete IOC examples remain separate application fixtures.
- D61 places the wrapper in the base executable directory, D62 records declared dependencies without pruning, and D63 keeps the minimal example at `examples/iocsh/st.cmd`; all three were decided at the first plan review on 2026-10-02. D64 fixes the default entry rule with explicit exceptions and was decided at the second plan review on the same date. D65 keeps `exec` and passes the generated startup copy as an unlinked descriptor; it was decided at the second-person review on the same date. D66 adds the undefined-symbol check to ELF validation and was decided at the first implementation review on the same date. D67 records the wrapper's show mode, and D68 records the DBD entry-symbol check with the Base menu include allowance; both were recorded at the third implementation review on the same date. D69 names the representative linStat PVs that the minimal example check reads and was decided on 2026-10-03. D70 makes the undefined-symbol check count functions and data alike, D71 declares a rejected module unloadable with a recorded reason, and D72 places the ELF resolver in one installed tool; all three were decided on 2026-10-03 when the check first ran over the installed inventory. D73 records every named library in `NEEDED` through the generated Base site configuration and removes the snmp declaration; it was decided on 2026-10-03 after the Rocky workflows showed the snmp library resolving there. D74 names uldaq for the measComp support library through the generated site configuration and removes the measComp declaration; it was decided on the same date. D75 removes the declaration mechanism itself, since no module uses it; it was decided on the same date after the workflows passed with D73 and D74. D76 places each application fixture under `examples/iocsh/<ioc>/` with the application checked out at a recorded revision, and D77 adds the asyn port driver DBDs to the entry mapping; both were decided on 2026-10-03 during the first fixture run. D78 checks the opcua-IOC-demo data path against the Eclipse Milo demo server and was decided on the same date after that server was tried. D79 loads `caPutLog.dbd` alone and was decided on the same date at the second review of the fixtures.
- D80 adds a digest of the generated metadata that the wrapper compares at startup and moves the cycle test ahead of the selected-version shortcut; decided on 2026-10-04 after the cycle case of T6 started an IOC.
- D81 removes earlier metadata before the generation checks and extends the refusal messages with the resulting state and the next commands; decided on 2026-10-04 after the rejected measComp build of T7 left the earlier metadata in place.
- D82 replaces the 2-second timestamp criterion of the tc32sim fixture with a 30-second monitor criterion; decided on 2026-10-04 from the update intervals measured on both targets.
- D83 keeps the show mode output free of setup script output and documents the descriptor name in native errors; decided on 2026-10-04 from the T9 observations.
- D86 accepts the Milo variant as the opcua-IOC-demo data-path evidence for completion and separates the data path of the original startup into Backlog M26; decided on 2026-10-04.
- D89 lets `symlink.<module>` pass an empty module directory with a notice and no link; decided on 2026-10-04 after `make uninstall.linStat` stopped `make symlinks`. Checked on Debian 13 on 2026-10-04: after `make uninstall.linStat`, `make symlink.linStat` and `make symlinks` end with status 0, print the notice, and create no `linStat` link; a directory with one stray file and no metadata still stops with status 2; `make build.linStat` and `make symlink.linStat` restore the module and its link. On 2026-10-05 the same steps passed on Debian 13 and Rocky Linux 8.10 as part of `review.bash`.
- No release version or change to the ordering of existing work is assigned by this plan.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-02; the D61-D65 revision, after four third-person reviews and one second-person review, and the D66, D67, and D68 amendments; 2026-10-03 for the D69 through D79 amendments; 2026-10-04 for the D80 through D83 amendments
Implementation Authorization: 2026-10-02; the D61-D65 revision, and the D66, D67, and D68 amendments; 2026-10-03 for the D69 through D79 amendments; 2026-10-04 for the D80 through D83 amendments. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: none

1. Define the metadata contract and explicit module entry mappings alongside the effective module definitions in `configure/`. Check `CONFIG_VARS`, `CONFIG_MODS`, and `CONFIG_MODS_DEPS` for canonical names, special mappings such as sequencer/seq, selected versions, and dependency edges; record declared dependencies without pruning (D62). Apply the default entry rule and enumerate every exception from the installed inventory of all configured modules as listed in Scope (D64), and include the hyphenated name `feed-core` in name parsing. Define the successful-build record and artifact identity used by the installer; retain DBD/data dependency versions even when ELF has no corresponding edge. Cover native Base/PVXS, DBD-only dependencies, and empty artifact lists. Close with T1 and T3.
2. Add successful-build record generation, runtime metadata generation, and installation sequencing through `configure/RULES_MODS_BUILD`, `configure/RULES_FUNC`, and `configure/RULES_INSTALL`. Require a matching build record before installation metadata generation. Write complete validated metadata, with the digest of D80 beside it, before alias publication, removing earlier metadata before the checks and reporting the resulting state on a refusal (D81); handle both individual module installation and distribution installation without parse-time filesystem writes. Install the wrapper into `base/bin/<EPICS_HOST_ARCH>/` through `configure/RULES_INSTALL` after base installation (D61), deriving the architecture name from the installed `base/lib/perl/EpicsHostArch.pl` as `scripts/setEpicsEnv.bash` does, because `configure/` defines no `EPICS_HOST_ARCH`; verify that `scripts/setEpicsEnv.bash` and `scripts/resetEpicsEnv.bash` already publish and remove that directory without a new entry. Close with T1 and T9.
3. Replace the prototype's `# modules:`/`RELEASE.local` resolution in `tools/iocsh.bash` with literal directive parsing, installed metadata discovery, exact/default version selection, the metadata digest comparison and the cycle test ahead of the selected-version shortcut (D80), recursive graph validation, and cached canonical paths. Preserve original source locations for wrapper diagnostics and emit actionable conflict chains; run a line-preserving generated copy whose directive lines become comments, passed as an unlinked `/dev/fd/N` descriptor (D65), and verify the filename-only mapping with a real failing startup. Provide the show mode (D67). Close with T2-T6.
4. Add recursive ELF dependency inspection for the selected native executable and libraries. Expand `$ORIGIN`, inspect applicable search paths, classify installed-module, distribution-vendor, and system dependencies, and compare module ownership/version with metadata. Reject a selected library with undefined symbols at installation (D66, D70, D75), and keep the resolver in `tools/iocsh_elf.bash`, installed beside the wrapper (D72). Keep DBD/data dependencies independent of ELF. Close with T7 and the real loaded-path checks of T8.
5. Generate the native startup sequence: dependency-ordered library/DBD loading, resolved module macros, one wrapper support-registration call, then the ordinary startup commands. Move the prototype startup to `examples/iocsh/st.cmd` (D63) and update it to use module directives and the installed linStat fragment, enabling one NIC and one filesystem through the fragment macros (`NICENABLE=""` with `NIC`, `FSENABLE=""` with `FSID` and `DIR`) and taking the interface name from the environment because it is host-specific. Retain existing environment-selection and native execution behavior where compatible with the contract. Close with T8-T10.
6. Prepare an actual application fixture for every IOC in the candidate matrix from the repository recorded there, identifying its source revision and original startup variant. Adapt only module declarations, installation paths, and test-environment settings; reuse the application's real DBs, templates, protocol files, and iocsh fragments. Start with the real `tc32sim` TCP simulator and add linStat, retools, autosave, and caPutLog through installed support. Prepare disposable local save directories, access security with `TRAPWRITE`, and Base's `iocLogServer` as the local log receiver. Resolve required common iocsh prerequisites from the selected installation before execution. Define each IOC's PV names, record/DTYP expectations, readback or source comparison, update interval, timeout, and expected alarm conditions before running it. Document unavailable prerequisites rather than substituting an empty IOC or replacement driver. Keep complete example applications separately from loader implementation files. Close with T12-T16.
7. Add integration coverage through the actual shipped path and update the mdBook pages `docs/src/procedures/set-up-shell.md`, `docs/src/concepts/installed-tree.md`, `docs/src/concepts/module-set.md`, and `docs/src/reference/tools-and-scripts.md`. Document metadata, examples, version selection, missing-version/conflict messages, the startup-only directive boundary, and the full candidate matrix. Run T1-T16 and record actual observations before marking any criterion complete.

##### Test Plan

Use real candidate installations on Debian 13 and Rocky Linux 8.10 for native runtime coverage. Installation/lint checks also exercise the repository's supported Linux build workflows when changes are published. These are proposed verification targets, not existing results. Prerequisite: a candidate installation produced by this branch on each target. Observed 2026-10-02: the local `~/EPICS-env-distribution/1.3.0/debian-13/7.0.10` tree predates commonIocsh installation and carries no `iocsh.conf` (recheck with `ls <tree>/modules/commonIocsh <tree>/modules/*/cfg/iocsh.conf`), and no Rocky Linux 8.10 tree is identified; both remain Pending prerequisites until prepared. Observed 2026-10-03 on the local Debian 13 host with linStat 1.2.1 and the tracked example: all 315 linStat records are readable and 31 are in alarm for reasons outside the loader, namely `<FSID>:AVAIL` at `LOLO` because the database limits are in bytes while the value arrives in megabytes, records that read unset environment variables, scan helper records before their first period, and host-dependent interrupt and interface counters; with the loopback interface the link speed and duplex records are also `INVALID`. Observed 2026-10-03 on the same host, as a development check that is not a T7 result: the D66 check over the installed inventory of 30 configured modules reports snmp with 27 undefined symbols and measComp with 42, and rgamv2 passes once its asyn dependency is considered; with the two modules declared unloadable, metadata generation passes for all 30, the static inspection of all 28 loadable modules together reports no finding in under one second, and the tracked example starts through the installed wrapper with the selected libraries mapped.

The full candidate matrix contains 3 IOC applications without application-specific compiled support. The primary modules below identify coverage, not complete dependency lists; obtain exact dependencies from the installed metadata and real application inputs. All candidates participate in T12 and T13 on both runtime targets. Record startup and data-path results separately for each IOC and target; equipment or external-PV availability can leave a check Pending, but cannot remove an IOC from the matrix or turn an unexecuted check into a pass. Use real test devices or sources when available; an explicitly identified simulator at the external boundary establishes simulated coverage only.

| IOC | Source | Primary modules | Application coverage |
| --- | --- | --- | --- |
| `tc32sim` | <https://github.com/jeonghanlee/tc32sim> | `StreamDevice`, `asyn`, `pvxs`, `linStat`, `retools`, `autosave`, `caPutLog` | First integration example: actual TCP simulator, temperature records, PVA groups, monitoring, restart restoration, and CA put logging |
| `EPICS-IOC-Demo` | <https://github.com/jeonghanlee/EPICS-IOC-Demo> | `StreamDevice`, `asyn` | Actual training-device startup and DBs |
| `opcua-IOC-demo` | <https://github.com/jeonghanlee/opcua-IOC-demo> | `opcua` | Sessions, subscriptions, and application records |

Candidate selection excludes IOC applications whose source repository is hosted on GitLab. The retained applications are `tc32sim`, `EPICS-IOC-Demo`, and `opcua-IOC-demo`, whose source repositories recorded above are on GitHub; step 6 records the exact revision each fixture uses. IOCs with application-specific C/C++ or sequencer support remain outside this no-IOC-compilation matrix. Preserve all three selected candidates even when later execution exposes a missing dependency.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Installation and metadata | Run the actual module build and individual-module/distribution installation paths, repeat installation, repeat base installation into the existing tree, change pins without rebuilding, and inspect generated metadata and alias publication order; run shipped read-only Make queries and compare filesystem inventories | Disposable real build/install roots; candidate configure rules | Successful-build records and installed artifacts agree with effective identities, versions, exact dependencies, entry lists, architecture, and relative paths agree with installed artifacts; aliases expose complete metadata; stale build identities fail; a module whose default-rule files are absent without an exception fails metadata generation, and a candidate DBD that defines a Base menu or record type with a body is rejected (D64); a DBD with an entry that no selected, dependency, Base, or PVXS library exports is rejected, and a record DBD that includes a Base menu file is accepted (D68); a source checkout that is not at the pinned tag fails the build record; other versions survive; the wrapper is present after repeated base installation; queries create no files |
| T2 | Directive syntax | Run the installed wrapper with all six forms for each of `m`, `mod`, and `module`, default and a genuinely installed exact version, comparing the generated startups through the show mode (D67) and loading the default and the exact selection in the real IOC; include comments, whitespace, duplicate declarations, a hyphenated module name such as `feed-core`, and ordinary commands containing the same words | Real generated metadata and libraries on both runtime targets | All 18 forms produce the same intended selection; ordinary commands retain their order and text; each support entry loads once |
| T3 | Dependency graph and entry mapping | Start through real StreamDevice, linStat, and representative library-only/data-only modules; inspect ordered support loads, installed DB/DBD includes, and macros | Real installed modules, including explicit entry-name exceptions and generated metadata | Dependencies precede consumers; calc remains available for StreamDevice DBD support even when absent from its ELF `NEEDED` list; declared dependencies load even when the consumer's ELF and DBD do not reference them (D62); test/example artifacts are not loaded; data-only entries require no invented library |
| T4 | Multiple versions | Build and install two real versions of linStat, which has no module dependencies, using the actual rules; select each explicitly and through the default symlink, and exercise a recorded dependency version that differs from the default alias with StreamDevice against asyn. Use linStat 1.1.1 beside the pinned 1.2.1, because the library of 1.2.0 is byte-identical to that of 1.2.1, and asyn at upstream commit `66bafcde239ddc902000e9ec380872c8b621fdf9` beside the pinned R4-46, because R4-45 does not build with the asyn site configuration of this repository: it predates the `DRV_VXI11` switch and needs `rpc/rpc.h` (observed 2026-10-04 on Debian 13) | Two real versioned installations of the same module with generated metadata; both runtime targets | Explicit selection is exact, default follows the alias, and dependencies use recorded versions; an unavailable example version fails; renaming one binary is not multi-version coverage |
| T5 | Resolved paths | Resolve a startup, change default symlinks at the filesystem boundary before native execution, and observe library mappings, DBD/DB paths, and exported module macros; also test a broken selected link | Disposable real installed trees; observation-only tracing or process suspension | The current startup uses cached canonical paths consistently; a subsequent invocation sees the changed default; invalid links fail during preparation |
| T6 | Failure diagnostics | Invoke the shipped wrapper, in the show mode and in a real start, on malformed declarations, extra arguments, missing names/versions/files/metadata, format and architecture mismatches, cycles, direct/transitive version conflicts, native Base/PVXS version conflicts, malformed metadata, a cycle among matching versions, and metadata changed after its generation (D80); inject filesystem faults only into copies of real generated packages | Real wrapper and generated metadata; controlled filesystem boundary changes | Nonzero exit before IOC launch for graph/syntax failures; message identifies the module, relevant versions, file/line or dependency chains, and a corrective action; no eval or silent fallback |
| T7 | ELF search validation | Inspect actual native executable and libraries through the shipped resolver; vary `RUNPATH`-resolved module availability and environment search candidates, including a wrong installed version; inspect real DBD-only dependencies | Real ELF binaries and generated metadata; disposable installed trees on both runtime targets | `ORIGIN` is based on each real object; metadata/ELF mismatches are explained; detectable conflicting candidates fail; vendor and system libraries are distinguished from installed modules; a selected library with undefined symbols is rejected at installation (D66); static inspection is never reported as proof of native binding |
| T8 | IOC and data path | Execute the tracked `examples/iocsh/st.cmd` with the installed wrapper, installed commonIocsh linStat fragment, real DBs, libraries, and DBDs; inspect actual process library maps and read the representative linStat PVs of D69 after one scan period and again after the next, with `NIC` naming a physical interface; exercise actual support-load failure using filesystem faults in disposable copies | Both runtime targets; actual `softIocPVX` and real CA/PVA clients; dedicated CA and PVA server ports when the host runs other EPICS servers, because linStat rescans through a CA link to its own PV | `iocInit` completes; the representative PVs are readable with `NO_ALARM`, and `MEM_FREE` advances its timestamp between the two reads; selected versions match actual mappings; support entries and wrapper-generated registration appear once; no missing DSET or unknown record/device support; an injected support-load failure prevents application DB loading and `iocInit` |
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
| T1 | 2026-10-04T09:29:21Z (Debian 13), 2026-10-04T09:49:09Z (Rocky Linux 8.10); pin and rejection parts with T4 and T7 | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; the build copy as build root | Pass. The 32 installed modules agree with the effective pins: build record, metadata, digest, source commit at the pinned tag, declared dependencies, relative entries, and alias. Fourteen read-only queries leave the inventories of the build root and the install root unchanged. `make install.linStat`, a repeated `make install`, and a repeated `make install.base` succeed and leave shared libraries, DBD files, metadata, and the Base executables unchanged; the wrapper and the ELF tool equal the sources afterwards. A changed tag without a rebuild, a source checkout that is not at the pinned tag, default-rule files without a declaration, the expanded `streamApp.dbd`, the unprovided entries of `pmacInclude.dbd`, and a measComp library built without its uldaq link line each fail the build or installation and leave the module without loader metadata, with the state and the target to run in the message (D81). `symlink.linStat` does not publish an installation without metadata, and the earlier versions stay installed. On Rocky Linux 8.10 the repeated installation rewrites the static archive `libopcua.a` (M24). All six OS workflows and the Linter succeed at `841f939786eb4f81f3dffc9f8d8ed3f89581aedf`, which carries that tree, by 2026-10-04T10:30:15Z: Debian 12 37194149764, Debian 13 37194149699, Rocky 8 37194149666, Rocky 10 37194149713, Ubuntu 24.04 37194149759, Ubuntu 26.04 37194149762, Linter 37194149712. | `work/m22-tests/t01a.bash`, `t04.bash`, `t07.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T2 | 2026-10-04T09:30:43Z (Debian 13), 2026-10-04T09:50:08Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files | Pass. All 18 forms give the same generated startup for linStat 1.2.1. A file with comments, leading whitespace, a trailing comment, repeated declarations, `feed-core`, and ordinary commands that contain the directive words loads each library once and keeps the ordinary commands in order and text in the real IOC. The default and the exact form each reach `iocInit` with only `linStat-1.2.1` mapped; T4 covers an exact version that differs from the default link. | `work/m22-tests/t02.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T3 | 2026-10-04T09:30:53Z (Debian 13), 2026-10-04T09:50:14Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files | Pass. With StreamDevice, linStat, seq, pcas, QPC, and pyDevSup, the generated startup loads seq, sscan, and calc before asyn and asyn before StreamDevice; `libstream.so` names no calc library in `NEEDED` and calc is loaded. Of 46 recorded dependency pairs, 29 have no ELF reference from the consumer and load as declared (D62). QPC and pyDevSup get a macro and no library or DBD; seq and pcas get libraries and no DBD. The mapped module libraries equal the metadata entries and no asyn test library is mapped. All 32 installed modules in one IOC reach `iocInit` with 35 selected libraries mapped. | `work/m22-tests/t03.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T4 | 2026-10-04T09:33:57Z (Debian 13), 2026-10-04T09:53:14Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; linStat 1.1.1 and asyn `66bafcd` built beside the pinned versions through the documented bump steps | Pass. `module linStat 1.1.1`, `module linStat 1.2.1`, and the default each map exactly the selected library, with different library content in the two versions; after `symlink.linStat` the default follows the link to 1.1.1 and the exact 1.2.1 still loads. `module linStat 9.9.9` is refused, and two versions in one file are refused with both locations. With the asyn link at `66bafcd`, `module StreamDevice` maps `asyn-4.46.0` only, `module asyn` maps `asyn-66bafcd` only, and both in one file are refused with the dependency chain. Pins, source trees, and links were restored and a full `make install` succeeded afterwards. | `work/m22-tests/t04.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T5 | 2026-10-04T09:36:39Z (Debian 13), 2026-10-04T09:55:49Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files with linStat 1.1.1 installed; `strace` delaying only the wrapper process's own `execve` by 6 seconds | Pass. The linStat link changed from 1.2.1 to 1.1.1 after the wrapper printed its descriptor mapping and while the process was still the shell. The started IOC maps only `linStat-1.2.1`, `LINSTAT` names 1.2.1, and every `dlload`, `dbLoadDatabase`, and `dbLoadRecords` path names 1.2.1 with none through the unversioned link. The next show mode and real start select 1.1.1. A dangling and an absent default link are refused in both modes before launch with the startup location; an exact version still resolves with the dangling link. | `work/m22-tests/t05.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T6 | 2026-10-04T09:36:49Z (Debian 13), 2026-10-04T09:55:58Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; faults injected into a copy of the tree | Pass. 35 cases, each in the show mode and in a real start, end with a nonzero status, the expected message, and no IOC launch: five malformed directives, two startup files, an unknown option, an unreadable file, an unknown module, an absent version, a direct and two transitive conflicts with their chains, missing metadata, library, and DBD, three one-file edits and a missing digest refused by the digest (D80), format, architecture, Base, name, and version mismatches, six malformed metadata forms, a dependency cycle among matching versions (D80), an absent recorded dependency, and an absent and a non-native pvxs version. The copy resolves again after the faults are removed, and the wrapper and the ELF tool contain no `eval`. | `work/m22-tests/t06.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T7 | 2026-10-04T09:36:52Z (Debian 13), 2026-10-04T09:56:02Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; a copy of the tree for faults | Pass. With opcua, measComp, snmp, and StreamDevice the report names `libopen62541` and `libuldaq` as vendor files of the tree, `libnetsnmp` as a system file, and `libasyn.so` under the selected `asyn-4.46.0`, and calls itself a static inspection; every tree file of the report is mapped in the real IOC and every other mapped tree file is a library the startup loads. In a copy every reported tree file lies in the copy. An asyn of another version first on `LD_LIBRARY_PATH` changes neither the static result nor the native mapping, because the startup loads the selected library by path first; a pvxs directory of another version on `LD_LIBRARY_PATH` is refused before launch with the corrective text. A dependency missing from the metadata and a removed vendor library are explained and refused; a one-file edit of a recorded dependency version is refused by the digest, and the same edit with the digest replaced passes, as D80 states. A measComp library without its uldaq link line is rejected at installation with 43 findings, which the printed command lists in full. | `work/m22-tests/t07.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T8 | 2026-10-04T09:30:58Z (Debian 13, interface `enp86s0`), 2026-10-04T09:50:19Z (Rocky Linux 8.10, interface `eth0`); fault part with T7 | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; dedicated loopback CA and PVA ports | Pass. `examples/iocsh/st.cmd` reaches `iocInit` with 317 records. The seven representative PVs of D69 read `NO_ALARM` 12 seconds after `iocInit` and again 11 seconds later, with `MEM_FREE` advancing its timestamp by 10 seconds; `pvxget` reads the same record. The process maps `linStat-1.2.1` and the Base and pvxs libraries of the tree, the verbose log shows one `dlload`, one wrapper registration, and no suspicious line. In a copy, a damaged `linStat.dbd` and a truncated `liblinStat.so` each end the IOC before the application database and `iocInit`; the damaged DBD ended `softIocPVX` with a segmentation fault on both targets and the end on the truncated library differs by target (M24). With the Base site patch of D84 applied and Base rebuilt in the same candidates, observed 2026-10-04T17:53:54Z on both targets, the damaged DBD gives `ERROR: syntax error`, ` at end of input`, and status 2 through `on error break`, still before the application database and `iocInit`. With the truncation check of D87, observed 2026-10-04T21:28:54Z on both targets, the wrapper refuses the truncated library before launch with status 1, so neither target reaches the native loader with it. | `work/m22-tests/t08.bash`, `t07.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T9 | 2026-10-04T09:39:26Z (Debian 13), 2026-10-04T09:50:43Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files and a copy of it as second tree; fresh shells with nounset on and off; `expect` for the terminal | Pass. Repeated setup keeps one Base entry, switching trees leaves no entry of the first tree, and reset removes the wrapper path while the shell survives, in both nounset modes. Inherited selection resolves in the sourced tree, `--environment` selects the named tree alone or over an inherited one and prints the generated startup only (D83), and no selection is refused. On a terminal the wrapper's PID runs `softIocPVX` in the caller's directory as the foreground process group, a typed command reaches the IOC shell, `exit` ends with status 0, and SIGTERM, SIGINT, and Ctrl-C end the IOC by that signal. A `-S` run keeps running after the startup file and ends with 143 on SIGTERM. An unknown command on line 5 gives `ERROR 4 line 5` after the descriptor mapping, with the same status 2 as the native executable on the same file, and later lines do not run. | `work/m22-tests/t09.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T10 | 2026-10-04T09:31:32Z (Debian 13), 2026-10-04T09:50:53Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files, copied to a path with a space; the original tree and the build root renamed away; the 17 installed `.local` files of the copy unreadable; `strace` on file and exec calls | Pass. The minimal example reaches `iocInit` from the copy, maps the module and Base libraries from the copy only, and reads the seven representative PVs with `NO_ALARM`; `LINSTAT` and `IOCSH_TOP` point into the copy. The traces of 3491 and 3816 lines show no `make`, no path of the original tree or the build root, and no `.local` file; successful paths outside the copy are system directories, the startup file, and directories of the caller's `LD_LIBRARY_PATH`. | `work/m22-tests/t10.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T11 | 2026-10-04T09:39:11Z (Debian 13), 2026-10-04T09:57:41Z (Rocky Linux 8.10) | Working tree equal to `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f` on the Debian 13 host with ShellCheck 0.10.0 and the `jeonghanlee/mdbook` image (mdbook v0.5.4); the build copy on Rocky Linux 8.10; the candidate installations; GitHub Actions | Pass. `bash -n` and ShellCheck report nothing for the three tools, the checkout helper, and the three `prepare.bash` scripts on both targets. The book builds from a copy of `docs` and leaves `docs/src` unchanged (Debian 13 only; the Rocky Linux 8.10 host has no container image for it). The five tools resolve where `set-up-shell.md` says, the show-mode output of the minimal example equals the documented output, the help names the four options and the three keywords, and the documented start shows the mapping line, `iocInit`, and the prompt and leaves with 0 on `exit`. All six OS workflows and the Linter succeed at `841f939786eb4f81f3dffc9f8d8ed3f89581aedf`, which carries that tree, by 2026-10-04T10:30:15Z: Debian 12 37194149764, Debian 13 37194149699, Rocky 8 37194149666, Rocky 10 37194149713, Ubuntu 24.04 37194149759, Ubuntu 26.04 37194149762, Linter 37194149712. After the later corrections to the refusal message and the book, the same workflows succeed at `4ee9282d72a83fee5f4de2c7017fdb7ea4edf316` by 2026-10-04T21:03:24Z: Debian 12 37232916850, Debian 13 37232916844, Rocky 8 37232916827, Rocky 10 37232916939, Ubuntu 24.04 37232916833, Ubuntu 26.04 37232916826, Linter 37232916823. With the truncation check, the same workflows succeed at `fd4dcf1ff28c10e6948ef9f9ee908b035e9ea0bf` by 2026-10-04T22:52:07Z: Debian 12 37240107521, Debian 13 37240107514, Rocky 8 37240107524, Rocky 10 37240107522, Ubuntu 24.04 37240107515, Ubuntu 26.04 37240107520, Linter 37240107516. | `work/m22-tests/t11.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T12 | 2026-10-04T09:31:49Z through 09:33:30Z (Debian 13), 2026-10-04T09:51:07Z through 09:52:47Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; each application checked out at the revision its fixture records | Pass on both targets for each IOC. tc32sim: `iocInit` completes; the mapped module libraries equal the entries of StreamDevice, linStat, retools, autosave, caPutLog, and their recorded asyn, calc, sscan, and seq; 32 `ai` records with `DTYP` `stream` and `SCAN` `I/O Intr`; each library loaded once and one wrapper registration; 577 records listed. EPICS-IOC-Demo: `iocInit` completes with and without the simulator; `stringout` with `stream` and `stringin` with `Soft Channel`; mapped libraries equal the entries. opcua-IOC-demo: `iocInit` completes for `st.cmd` and for `st-milo.cmd`; `libopcua` and the vendor `libopen62541` are mapped from the tree; 87 records with `DTYP` `OPCUA`. | `work/m22-tests/fx-tc32sim.bash`, `fx-demo.bash`, `fx-opcua.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T13 | Same runs as T12 | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; the tc32sim and EPICS-IOC-Demo simulators of the applications; the Eclipse Milo demo server image of D78 under `docker` on Debian 13 and `podman` on Rocky Linux 8.10 | tc32sim, simulated device: Pass on both targets; 32 values between 10 and 90 without `INVALID`, and each channel updates at least twice in 30 seconds (D82; largest single gap 16.8 seconds on Debian 13 and 11.3 seconds on Rocky Linux 8.10). EPICS-IOC-Demo, echo simulator: Pass on both targets; the readback holds the written text within 2 seconds with a new timestamp and no alarm, and without the simulator the write fails with `INVALID` and `COMM` while the readback stays `UDF`. opcua-IOC-demo: the original startup without its server reads `INVALID` and `COMM`, and its data path is separated into Backlog M26 under D86 and is not part of this result; the Milo variant passes on both targets, with the session connected as Anonymous, product name and state read, and three values without alarm whose values and timestamps change between two reads; a second session without a server restart leaves the records `INVALID` with `COMM`, as the fixture documents. | `work/m22-tests/fx-tc32sim.bash`, `fx-demo.bash`, `fx-opcua.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T14 | 2026-10-04T09:31:49Z (Debian 13), 2026-10-04T09:51:07Z (Rocky Linux 8.10) | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; the tc32sim TCP simulator | Pass on both targets, simulated device coverage. `pvget TC32:001:group` returns the structure with `tc32.model_number` and `ch00.temp`; CA and PVA monitors of `TC32:001:Ti0` deliver changing values; the four linStat PVs are readable, `MEM_FREE` advances its timestamp over 11 seconds, and `PROCESS_ID` equals the IOC PID; `reGrep("^TC32:001:Ti0$")` prints `TC32:001:Ti0` after `iocInit`; each of the five selected modules is loaded once. | `work/m22-tests/fx-tc32sim.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T15 | Same runs as T14 | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; a new run directory with the installed autosave fragment | Pass on both targets. After two CA puts, `settings.sav` holds `TC32:001:Ti0.HIGH 47` and `values_pass1.sav` holds `TC32:001:Ti0Scale.VAL 2` within 9 seconds, written by autosave, and the status records of both sets read `Ok`. After `exit` and a second start with the same directory, `caget` returns `47` and `Kelvin`. | `work/m22-tests/fx-tc32sim.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T16 | Same runs as T14 | Debian 13 host and a disposable Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from a copy of the tree of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`, identical to it in all 223 tracked files; Base `iocLogServer` on port 7004 and the fixture access security with `TRAPWRITE` | Pass on both targets. Each of the two CA puts gives one line in the receiver's file that names the PV with `new=` and `old=` values: `TC32:001:Ti0.HIGH new=47 old=45` and `TC32:001:Ti0Scale new=2 old=0`. | `work/m22-tests/fx-tc32sim.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |

Prototype observations and static candidate inspection do not verify this metadata, syntax, version-selection, RUNPATH design, or candidate IOC execution. The startup and data-path results of all three candidates are recorded above for each IOC and target; the opcua-IOC-demo data path of the original startup is separated into Backlog M26 under D86. A substitute parser, hand-authored replacement metadata, mocked internal loader, or copied binary renamed as a second version cannot establish acceptance.

Repeat on the final tree, 2026-10-05T01:17:10Z through 01:29:35Z: the rows above describe the run against `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f`. The tools, the link rule, and the Base patch family changed after it, so every script of that run ran again in the same order on new candidate installations, built in full through the workflow steps from an export of `796083ca8a563eda23bea35256c3d10f50b226c2` with its 224 tracked files, on the Debian 13 host and on the Rocky Linux 8.10 VM. No check failed, and each script gave the number of passing checks it gave in the recorded run on that target:

| Labels | Script | Passing checks, Debian 13 | Passing checks, Rocky Linux 8.10 |
| --- | --- | --- | --- |
| T1 | `t01a.bash` | 12 | 12 |
| T2 | `t02.bash` | 15 | 15 |
| T3 | `t03.bash` | 18 | 18 |
| T4, pin parts of T1 | `t04.bash` | 25 | 25 |
| T5 | `t05.bash` | 11 | 11 |
| T6 | `t06.bash` | 37 | 37 |
| T7, fault parts of T1 and T8 | `t07.bash` | 31 | 31 |
| T9 | `t09.bash` | 30 | 30 |
| T10 | `t10.bash` | 7 | 7 |
| T11 | `t11.bash` | 8 | 6 |
| T12 through T16 | `fx-tc32sim.bash` | 24 | 24 |
| T12, T13 | `fx-demo.bash` | 10 | 10 |
| T12, T13 | `fx-opcua.bash` | 13 | 13 |

`t08.bash` for T8 counts no checks; on both targets its log again lists 317 records, reads the representative PVs twice, and reports no suspicious line, and it differs from the recorded log only in paths, process numbers, time stamps, and memory values. `t11.bash` has two checks fewer on Rocky Linux 8.10 in both runs, because Docker is absent on the Rocky Linux 8.10 host and the book is not built there; ShellCheck is present on both hosts. The update command of the tc32sim README prints `32` on both targets; that command had not run on Rocky Linux 8.10 before. The opcua-IOC-demo data path of the original startup was again not run (D86). The corrections of the branch review have their own script, `review.bash`, which passes 33 checks on each target through the shipped make rules: the link rule on an uninstalled module (D89), metadata generation with a truncated library of a dependency, and the patch round trip with the site patch in the carry set (D88). T11's workflow part: all six OS workflows and the Linter succeed at `796083ca8a563eda23bea35256c3d10f50b226c2` by 2026-10-05T01:20:51Z: Debian 12 37249407104, Debian 13 37249407112, Rocky 8 37249407098, Rocky 10 37249407134, Ubuntu 24.04 37249407120, Ubuntu 26.04 37249407139, Linter 37249407113; recheck with `gh run view <id> --repo jeonghanlee/EPICS-env`. Scripts and logs: `work/m22-tests/` with `out-debian13-rerun` and `out-rocky8-rerun`, local and untracked.

##### Closure Evidence

- Verification: T1 through T16 are recorded against `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f` on Debian 13 and Rocky Linux 8.10, and were repeated without a failed check on candidates built from `796083ca8a563eda23bea35256c3d10f50b226c2` on 2026-10-05. T13 is judged with the Milo variant for opcua-IOC-demo under D86, Decision Date 2026-10-04; the data path of the original startup is Backlog M26 and is excluded from this completion.
- Landing on the work branch: observed 2026-10-04T21:15Z after `git fetch`, `origin/iocsh-module-loader` equals the local head and carries the loader, its guards, the fixtures, and the book; all six OS workflows and the Linter succeed at `4ee9282d72a83fee5f4de2c7017fdb7ea4edf316` and at `fd4dcf1ff28c10e6948ef9f9ee908b035e9ea0bf`, which carries the truncation check of `81abb4f`.
- Landing on `master`: observed 2026-10-05T02:35Z after `git fetch`, `origin/master` and `origin/iocsh-module-loader` equal the local head `35a845118042a11e0f8bdf2f9748c9136bac05d9`, which merges `master` through `df04cf1e439c7c501743c9d75ff9924d39b1c8c9` and carries the branch as a fast-forward of `master`; all six OS workflows, the Linter, and the documentation deployment succeed at that commit: Debian 12 37254298213, Debian 13 37254298198, Rocky 8 37254298239, Rocky 10 37254298188, Ubuntu 24.04 37254298211, Ubuntu 26.04 37254298197, Linter 37254298210, Deploy Docs 37254298186; recheck with `gh run view <id> --repo jeonghanlee/EPICS-env`.
- Issue #93 was observed closed as completed at 2026-10-05T02:59:44Z (`gh api repos/jeonghanlee/EPICS-env/issues/93`, `state_reason` completed; closing comment https://github.com/jeonghanlee/EPICS-env/issues/93#issuecomment-5987333275).
- Complete on 2026-10-05: the deliverable, T1 through T16, the repository changes on `master`, and the closure of #93 are all observed. The data path of the original opcua startup is Backlog M26 and is not part of this completion.

##### GitHub Projection

Title: Load installed EPICS modules with iocsh.bash and softIocPVX
Labels: enhancement
GitHub Milestone: Backlog
Assignee: jeonghanlee
Observed State: CLOSED (completed, 2026-10-05T02:59:44Z)
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-05 03:00 UTC via `gh issue view 93 --repo jeonghanlee/EPICS-env`; GitHub updated at 2026-10-05T02:59:44Z with the closing comment; title, body, labels, milestone, and assignee match the plan projection with the amendments through D89 and the repeat run of 2026-10-05, and the body carries the sixteen acceptance items checked with their results.

#### M25 - Base Site Patch For The Parser Crash At End Of Input

Origin: 84ee626 / M25
Identity History: Opened on 2026-10-04 by D84 from the second observation of M24
GitHub Issue: #94, https://github.com/jeonghanlee/EPICS-env/issues/94
Status: Complete

##### Summary

EPICS base R7.0.10 ends `softIoc` and `softIocPVX` with a segmentation fault when a database definition or database file ends inside an open construct. Carry the correction as the site patch of the pinned Base until an upstream release contains one.

##### Scope

- Add the site patch, `patch/7.0.10-site01-dbyacc-eof.p0.patch` under D88 and `patch/7.0.10.base.p0.patch` before it, which changes `yyerror` in `modules/database/src/ioc/dbStatic/dbYacc.y`: when no input file is open, print ` at end of input` and return without reading `pinputFileNow`, `yytext`, or the line buffer.
- Record the case, the reproduction, and the tested versions in `patch/README.md`, and state the site patch in `docs/src/concepts/upstream-patch-carry.md`.
- Make `make patch.base.revert` revert this patch. `tools/revert_patch.bash` counted the forward declaration `static int yyerror(char *str);` on line 11 of `dbYacc.y` as a second definition of the function named in the hunk header and stopped with `Cannot classify revert state`; the check skips a declaration, a line that ends with a semicolon (D85).

Out of scope: the report and correction in the upstream EPICS base repository, which proceed outside this repository; the `Parser stack dirty` warning that follows the syntax error; any other change to the upstream carry set.

##### Completion Criteria

1. `make patch` applies the site patch with the carry set of EPICS base, after the upstream fixes (D88), and `make patch.revert` followed by `make patch` returns the Base source to the same state.
2. With Base built from the patched source, a file that ends after `recordtype(x) {`, after `field(`, or inside `device(...` gives `ERROR: syntax error` and ` at end of input` from `softIoc` and `softIocPVX` without a fault, and a syntax error before the end of a file is reported as before.
3. A startup with `on error break` ends with status 2 before `iocInit` on such a file.
4. All six OS workflows and the Linter succeed on the pushed commit.

##### Dependencies And Decisions

- D84 and D85, Decision Date: 2026-10-04.
- The upstream carry rules admit only fixes that are merged upstream; this fix is not, so it uses the site patch family `<base_version>.base.p0.patch` that `patch.base.apply` already handles.
- D85 makes the function-location check of `tools/revert_patch.bash` skip a declaration of the function; chosen on 2026-10-04 during implementation, as the owner directed.
- D88, Decision Date: 2026-10-04, moves the patch into the carry set under the name `7.0.10-site01-dbyacc-eof.p0.patch` and removes the `<version>.base.p0.patch` family with its three targets; the two bullets above describe the state before it.
- A pin bump of EPICS base drops the file from the applied set, as for every version-anchored patch; the fix is then re-examined against the new pin.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-04, owner direction in session, with the correction of step 3 left to the implementation
Implementation Authorization: 2026-10-04, owner direction in session. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: none

1. Write the correction against the pinned Base source and generate `patch/7.0.10.base.p0.patch` with `git diff --no-prefix`. Done on 2026-10-04.
2. Record the case, reproduction, and tested versions in `patch/README.md` and update the book page. Done on 2026-10-04.
3. Make `make patch.base.revert` revert the patch: in `matches_function_location` of `tools/revert_patch.bash`, do not count a line that ends with a semicolon as an occurrence of the function (D85); state it in the two book pages that describe the check. Done on 2026-10-04, closed by T2.
4. Publish and read the workflows for T4. Done on 2026-10-04.
5. Under D88, rename the patch to `patch/7.0.10-site01-dbyacc-eof.p0.patch`, remove `patch.base.apply`, `patch.base.revert`, `patch.base.make`, and their functions, take both targets out of the `patch` and `patch.revert` lists, and update `patch/README.md` and the three book pages that name the family. Done on 2026-10-04 in `50ca0c8`; T2 and T4 were repeated on 2026-10-05.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Parser behavior | Load DBD files that end after `recordtype(x) {`, after `field(`, and inside `device(...`, and one with a syntax error on its first line, through `softIoc` and `softIocPVX`, without and with the patch; repeat one with `on error break` | Installed Base and pvxs of a candidate installation on Debian 13 and Rocky Linux 8.10, Base rebuilt through `make build.base` and `make install.base` | Without the patch the three truncated files end with status 139; with it they give ` at end of input` without a fault; the first-line error is reported the same way in both; the `on error break` startup ends with status 2 before `iocInit` |
| T2 | Patch targets | Run `make patch.base.pr.revert` and `make patch.base.pr.apply`, then `make patch.revert` and `make patch`; before D88 the first pair was `make patch.base.apply` and `make patch.base.revert` | Build root with the pinned Base source and the carry set, both targets | Each target succeeds and the Base source returns to the same state |
| T3 | Loader fault check | Run the damaged-DBD part of M23 / T8 through the installed wrapper | The same candidates with the patched Base | The IOC ends with status 2 before the application database and `iocInit` |
| T4 | CI | Read the workflows on the pushed commit | GitHub Actions | All six OS workflows and the Linter succeed |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-04, about 17:51Z | Candidate installations of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f` on Debian 13 (GCC 14.2.0) and Rocky Linux 8.10 (GCC 8.5.0); Base R7.0.10 with the carry set, without and with the site patch | Pass. Without the patch the three truncated files end both executables with status 139 after `ERROR: syntax error`, with the fault in `yyerror` at `dbStatic/dbYacc.y:381` under `gdb` on Rocky Linux 8.10. With the patch they give `ERROR: syntax error` and ` at end of input` and no fault on both targets; the first-line error prints the file, line, and text as before; the `on error break` startup ends with status 2 and no `iocInit` | `patch/README.md`, section on the site patch |
| T2 | 2026-10-04, about 18:05Z | Build roots of the candidates on Debian 13 (GNU patch 2.8) and Rocky Linux 8.10 (GNU patch 2.7.6) | Pass with the D85 correction. Before it, `make patch.base.revert` stopped with `Cannot classify revert state` (reverse=1 forward=1), because the check found the declaration on line 11 and the definition on line 370. With it, `make patch.base.revert` and `make patch.base.apply` succeed, `make patch.revert` reverts all 38 applied patches, `make patch` applies them again, and the differences of the seven patched source trees against their pins are identical before and after on both targets. After D88, on 2026-10-04 on Debian 13 only: `make patch` applies 19 EPICS base patches with `7.0.10-site01-dbyacc-eof.p0.patch` last, `make patch.revert` and `make patch.base.pr.revert` leave only the two files that `make conf` writes as changed in `epics-base-src`, and after each `make patch` or `make patch.base.pr.apply` the differences of `epics-base-src` and `pvxs-src` against their pins equal those before the change. On 2026-10-05, at 01:27Z on Rocky Linux 8.10 and 01:29Z on Debian 13, on candidates built from `796083ca8a563eda23bea35256c3d10f50b226c2` on Debian 13 and Rocky Linux 8.10: the same round trip passes over every patched source tree, `make patch.base` applies nothing, and `patch.base.apply`, `patch.base.revert`, and `patch.base.make` have no rule | `tools/revert_patch.bash`, function `matches_function_location` |
| T3 | 2026-10-04T17:53:54Z | The same candidates with the patched Base | Pass on both targets: status 2 after ` at end of input`, with no application database and no `iocInit`; the other 28 checks of the script pass | `work/m22-tests/t07.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T4 | 2026-10-04T21:03:24Z | GitHub Actions on `iocsh-module-loader` at `4ee9282d72a83fee5f4de2c7017fdb7ea4edf316`; the same seven workflows also at `e2f1a123bc6c25a5c7a65194977f5463848d4218`, the first pushed state with the patch | Pass. All six OS workflows and the Linter succeed at both commits; the Rocky 8 and Debian 13 logs show `Patching epics-base-src with the file` for `patch/7.0.10.base.p0.patch` and `patching file modules/database/src/ioc/dbStatic/dbYacc.y` before the build | Debian 12 37232916850, Debian 13 37232916844, Rocky 8 37232916827, Rocky 10 37232916939, Ubuntu 24.04 37232916833, Ubuntu 26.04 37232916826, Linter 37232916823; recheck with `gh run view <id> --repo jeonghanlee/EPICS-env` |

##### Closure Evidence

- The four completion criteria were met as of 2026-10-04T21:03:24Z with the patch as `7.0.10.base.p0.patch`: T1 through T4 pass. D88 renames the patch and changes its targets; for that state T2 passes on both targets on 2026-10-05, T3 passes again as part of `t07.bash` in the repeat run of M23, where the damaged DBD ends the IOC with status 2 on both targets with Base built from the renamed patch, and T4 passes: all six OS workflows and the Linter succeed at `796083ca8a563eda23bea35256c3d10f50b226c2` (run numbers in the repeat paragraph of M23). T1 was not repeated; the patch content is unchanged, as the rename at 100% similarity in `50ca0c8` shows. The branch reached `master` at `35a845118042a11e0f8bdf2f9748c9136bac05d9`, observed 2026-10-05T02:35Z, and all six OS workflows, the Linter, and the documentation deployment succeed there (run numbers in M23 Closure Evidence). Issue #94 was observed closed as completed at 2026-10-05T02:59:47Z (`state_reason` completed; closing comment https://github.com/jeonghanlee/EPICS-env/issues/94#issuecomment-5987333558). Complete on 2026-10-05.

##### GitHub Projection

Title: Database parser ends with a segmentation fault when a file ends inside an open construct
Labels: bug
GitHub Milestone: Backlog
Assignee: jeonghanlee
Observed State: CLOSED (completed, 2026-10-05T02:59:47Z)
Observed Labels: bug
Observed Milestone: Backlog
Last Compared: 2026-10-05 03:00 UTC via `gh issue view 94 --repo jeonghanlee/EPICS-env`; GitHub updated at 2026-10-05T02:59:47Z with the closing comment; title, body, labels, milestone, and assignee match the projection of this detail after D88, with all four acceptance items checked.

#### M27 - Loader Pages In The Book

Origin: 84ee626 / M27
Identity History: Opened on 2026-10-05 by D90 from a read of how the book covers the loader; the verification suite moved to M28 on 2026-10-05 by D92, which also puts M28 first; revised after reviews on 2026-10-05
GitHub Issue: none
Status: Complete

##### Summary

The loader is described on seven pages of the book, but no page explains how it works and none is about running an IOC from installed modules. Add a concept page and a procedure page and the entry points that lead to them, so a reader who wants to run an IOC without compiling it finds the way from the introduction, the tutorial, and the glossary.

##### Scope

- A concept page, `docs/src/concepts/installed-module-loader.md` (D93), listed in `docs/src/SUMMARY.md` under Concepts after `Installed tree and relocation`: what the wrapper does, how it decides a version and the dependencies, the startup it generates and how line numbers stay true, the checks it runs before the IOC starts, and its limits. It links to the installed tree page for `cfg/` and to the module set page for the entries instead of repeating them.
- The explanatory sentences of the `iocsh.bash`, `iocsh_elf.bash`, and `iocsh_metadata.bash` items of `docs/src/reference/tools-and-scripts.md` (the table rows at lines 36 to 38 stay; the bullets of `Behavior details of the tools` from `iocsh.bash takes the tree` to the `iocsh_metadata.bash record` bullet, lines 62 to 159) move into the concept page. The reference keeps the directive forms, the exact messages, the option behavior of `-n` and `-e`, the exit statuses, and the repair commands; a bullet that holds a message keeps the message and gives its cause sentence to the concept page (D93). The work writes a list of every moved statement, from its reference line to its concept-page line.
- A procedure page, `docs/src/procedures/run-ioc-from-installed-modules.md`, listed under Procedures after `Set up a shell with the environment`: writing a startup file with the directives, selecting a version, the show mode, reading a native error, running the example fixtures, and one table of the refusals of the loader with their meaning and the action each needs, quoting only the first words of each message (D93). The messages come from `tools/iocsh.bash`, `tools/iocsh_elf.bash`, and `tools/iocsh_metadata.bash`; the table covers each refusal that the reference names and each of the 35 cases of the failure-diagnostics check recorded in M23. The fixtures are linked by the absolute URL `https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/<fixture>/README.md`. Step 5 of `procedures/set-up-shell.md` points to the page.
- Entry points: the introduction names what the installed tree gives for running an IOC, the tutorial ends with one sentence that points to the procedure, and the glossary defines loader, directive, loader metadata, build record, and site patch.
- The two sentences of `procedures/set-up-shell.md` that `verify_docs_and_tools.bash` of the suite anchors on, `For the minimal example of the repository the output is as follows` and `Each tool resolves inside`, stay unchanged; if the work must move or reword them, it adapts the anchors of that script in the same work (D92).

Out of scope: the verification suite (M28); the behavior of the loader; the title of `concepts/installed-tree.md`, which still says relocation; the `ChangeLog.md` entry, which belongs to the release; moving the fixture `README.md` files into the book.

##### Completion Criteria

1. Both pages exist, are in the table of contents at the places named above, and the book builds with the documented image (`jeonghanlee/mdbook`, as in `docs/README.md`) without error.
2. Each fixture URL on the procedure page names a file that exists on `master`.
3. The introduction, the tutorial, and the glossary lead to the pages or define their terms.
4. Every statement moved out of the reference appears on the concept page, none remains in the reference, and the list of moved statements is recorded in Verification Results.
5. Every command and message on the pages matches output executed on an installed tree, and a second-person reading of the changed pages finds no step that needs the session's context.
6. `verify_docs_and_tools.bash` of the suite passes on the new book text, and the `README.md` of the suite, its procedure page, and the new pages agree with one another.

##### Dependencies And Decisions

- D90, Decision Date: 2026-10-05, assigns the book pages and their place after M23 and M25.
- D92 and D93, Decision Date: 2026-10-05, set the split from M28, the order M27 then M28, and the choices of the page content.
- M23 and M25 are Complete as of 2026-10-05, so the pages describe the loader as merged and closed.
- M28 is Complete first (D92). The fault recipes that provoke each refusal are then in the repository as `examples/iocsh/tests/verify_failure_diagnostics.bash` and `verify_elf_inspection.bash`, and the `README.md` of the suite lists each refusal case with the script and check that provokes it; this work writes its table of refusals from that list.
- A candidate installation on Debian 13 is built as in `procedures/build-and-install.md` with an install location of its own.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-05, owner acceptance of the plan after two third-person and three second-person reviews
Implementation Authorization: 2026-10-05, owner authorization of the current plan. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: none

1. Accept this plan and authorize its implementation.
2. Write the concept page from the explanatory sentences of the reference, move those sentences out of the reference by the rule of the scope, and write the list of moved statements.
3. Write the procedure page, including the table of refusals, taking the messages from the three tools and the cases from the list in the `README.md` of the suite.
4. Add the entry points, the glossary terms, the pointer in step 5 of the shell setup page, and the two pages in `docs/src/SUMMARY.md`.
5. Build a candidate installation, run each command of the procedure, and provoke each listed refusal on a copy of the installed tree with the scripts of the suite; compare each message with its output.
6. Run `verify_docs_and_tools.bash` on the new book text, adapt its anchors if the work changed those two sentences, and check that the suite `README.md` and its procedure page agree with the new pages.
7. Read the changed pages from the seat of a reader who has only the book.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Book build and links | Build the book with the documented image and check that each fixture URL names a file on `master` with `gh api repos/jeonghanlee/EPICS-env/contents/<path>` | Checkout of `master`; GitHub | No build error, and every URL names an existing file |
| T2 | Commands and messages | Run every command of the procedure and provoke each listed refusal on a copy of an installed tree | Candidate installation on Debian 13 | Each command and message matches the page |
| T3 | Reader pass | Read the changed pages first line to last as a reader who has only the book | The built book | No step needs the session's context |
| T4 | Reference after the move | Compare the reference before and after for every moved statement and record the list | The two versions of `tools-and-scripts.md` | Each moved statement appears on the concept page and none remains in the reference |
| T5 | Suite after the pages | Run `verify_docs_and_tools.bash`, then `run_all.bash`, on the candidate installation | Candidate installation on Debian 13; checkout with the new pages | No failed check, and the counts of the suite `README.md` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-05 | Checkout of `master` with the new pages; the book built with `jeonghanlee/mdbook`; GitHub | Pass. The book builds without error. All 63 relative links and anchors of the changed pages resolve, and the four GitHub URLs of fixture and suite `README.md` files name files that exist on `master` | `mdbook build docs`; a link checker over the nine changed pages; `gh api repos/jeonghanlee/EPICS-env/contents/<path>?ref=master` |
| T2 | 2026-10-05, full suite at 16:33:30Z | Candidate installation on Debian 13 built from the working tree with the new pages | Pass. The 42 message starts of the two refusal tables were compared with the messages of the three tools: 41 occur literally, and `Cannot resolve the pvxs module link` is written with the variable `${NATIVE_MODULE}`, whose value is `pvxs`. The 34 starts of the first comparison also occur in the logs of the suite run, which provokes the 35 refusal cases and the ELF and generator refusals; the actions name targets that exist in `configure/` | `tools/iocsh.bash`, `tools/iocsh_elf.bash`, `tools/iocsh_metadata.bash`; `examples/iocsh/tests/verify_failure_diagnostics.bash` and `verify_elf_inspection.bash`; logs in `work/m27-run/out-debian13` and `work/m28-run/out-m27`, local and untracked |
| T3 | 2026-10-05 | The built book; a sub-agent in the seat of an IOC engineer who knows the book only | Pass with the review state noted. The pages were read first line to last once; the reader found no finding that blocked and 8 recommended findings and 6 informational ones about messages, steps, and duplication, all reflected; the corrected text was checked against the tool sources and the suite and was not read a second time by another reader | The reader report; `docs/src/concepts/installed-module-loader.md`; `docs/src/procedures/run-ioc-from-installed-modules.md` |
| T4 | 2026-10-05 | The two versions of `docs/src/reference/tools-and-scripts.md`, before and after | Pass. 16 statements moved: that each dependency loads in its recorded version (Selecting versions and dependencies); the replacement of directive lines in the copy, the line numbers of messages, the content of the generated startup, a startup without a directive, and the name of the startup file in the IOC shell (The generated startup); that directives are not IOC shell commands (Directives); the causes that stop the start, the inspection and its stop cases, the truncated file and the bus error, the search order, and that the inspection is static (Checks before the IOC starts); and the requirements of `record`, `generate`, and `check` and the removal of earlier metadata (How the metadata is made). Each was in the old reference, none is in the new one, and each is on the concept page | A string comparison of the old and new reference against the concept page |
| T5 | 2026-10-05, 16:33:30Z | Fresh candidate installation on Debian 13 built from the working tree with the new pages | Pass. `run_all.bash` ends with status 0, every script exits 0 with no `FAIL` line, the counts equal the table of the suite `README.md` (12, 15, 18, 7, 24, 10, 13, 25, 11, 37, 31, 8, 30, 33), and the checks of `verify_docs_and_tools.bash` hold on the new book text without a change of its anchors. A second run on a tree that already ran the suite fails two checks of `verify_install_metadata.bash`, because a repeated installation rewrites `modules/opcua-0.11.2/cfg/CONFIG_OPCUA` with an absolute path where the fresh build holds `$(_OPEN62541_CONFIG_OPCUA)`; the suite README and its page say to run it once per candidate installation | `examples/iocsh/tests/run_all.bash`; logs in `work/m27-run/out-debian13` and `work/m28-run/out-m27`, local and untracked |

##### Closure Evidence

- Verification: T1 through T5 are recorded above. T3 rests on one independent reading whose findings were reflected and checked against the tool sources, and not on a second reading of the corrected text.
- Landing on `master`: observed 2026-10-05T16:39Z after `git fetch`, `origin/master` equals the local head `ace595adddfa39c96775d3b987ea2716d6103ad5`, which follows the commit `e6b7cb6` that carries the pages; the documentation deployment and the Linter succeed at it: Deploy Docs 37342169311, Linter 37342169537; recheck with `gh run view <id> --repo jeonghanlee/EPICS-env`. The operating system workflows do not run for a push that changes only `docs/**`, `.md` files, and `examples/iocsh/tests/README.md`.
- Complete on 2026-10-05: the deliverable, T1 through T5, and the repository changes on `master` are observed; no issue is linked.

#### M28 - Loader Verification Suite

Origin: 84ee626 / M28
Identity History: Split from M27 on 2026-10-05 by D92, which also puts M28 first; revised after reviews on 2026-10-05
GitHub Issue: none
Status: Complete

##### Summary

The scripts that ran T1 through T16 of the loader work are untracked local files, and the CI workflows never run the loader. Move them into the repository as a suite with its own procedure page, so the checks can be run again on the same pins, and adjusted with a pin bump (D91, D94).

##### Scope

- The scripts exist only in `work/m22-tests/` of the checkout on the workstation that ran the work; the directory is gitignored by `/work/` and no other copy exists. The work runs on that workstation, and its first step copies the scripts into the repository; nothing else of this plan can be done without them.
- The suite goes to `examples/iocsh/tests/` with these names (D94); the order of the first column is the order of `run_all.bash`, taken from the local driver `run-seq.bash`:

| Earlier name | New name | Checks |
| --- | --- | --- |
| `lib.bash` | `common.bash` | Shared functions; every script sources it under `# shellcheck source=common.bash disable=SC1091` |
| `run-seq.bash`, `run-debian.bash`, `run-rocky.bash` | `run_all.bash` | Takes `IOCSH_TEST_TREE`, `IOCSH_TEST_REPO`, `IOCSH_TEST_OUT`, runs the scripts below in this order, writes one log per script, prints its exit status |
| `t01a.bash` | `verify_install_metadata.bash` | Installation and metadata, repeated installation inventory |
| `t02.bash` | `verify_directives.bash` | The 18 directive forms |
| `t03.bash` | `verify_dependency_graph.bash` | Dependency order and entry mapping |
| `t08.bash` | `verify_minimal_example.bash` | The minimal example and its PVs; counts no checks, lists 317 records |
| `t10.bash` | `verify_relocated_tree.bash` | A copied tree under a path with a space, no runtime dependency on the checkout |
| `fx-tc32sim.bash` | `verify_fixture_tc32sim.bash` | The tc32sim fixture |
| `fx-demo.bash` | `verify_fixture_ioc_demo.bash` | The EPICS-IOC-Demo fixture |
| `fx-opcua.bash` | `verify_fixture_opcua.bash` | The opcua fixture against the Milo server |
| `t04.bash` | `verify_multiple_versions.bash` | Second versions of linStat and asyn, the pin parts of the installation checks |
| `t05.bash` | `verify_resolved_paths.bash` | Paths stay after a default link changes; needs the versions that the previous script installs, so these two keep their order |
| `t06.bash` | `verify_failure_diagnostics.bash` | The 35 refusal cases |
| `t07.bash` | `verify_elf_inspection.bash` | ELF checks, injected faults, the damaged DBD |
| `t11.bash` | `verify_docs_and_tools.bash` | Syntax and ShellCheck of the tools, the book build, the documented examples; compares text of `procedures/set-up-shell.md` through the two anchor sentences of D92 |
| `t09.bash` | `verify_shell_lifecycle.bash` | Environment switching, signals, PTY, native errors |
| `readme-updates.bash` | `verify_readme_update_command.bash` | The update command of the tc32sim README prints `32`; counts no checks |
| `trunc.bash` | `observe_truncated_library.bash` | Three cuts of a library; counts no checks |
| `review.bash` | `verify_make_rules.bash` | The link rule on an uninstalled module, a truncated dependency library, the patch round trip |

- Check descriptions that carry the T numbers of the loader work use the topic name instead, so they do not collide with the labels of this plan. The prefix `M22` and `m22` is replaced everywhere, including the container name, which becomes `iocsh-milo`.
- The shell findings are corrected: 22 findings in 9 files with `shellcheck -x -e SC1091`, among them 7 on literal strings in the failure-diagnostics script and 3 on the values an `eval` generates in the truncated-library script; a finding that cannot be rewritten without changing the check gets a line-scoped `# shellcheck disable=` with its reason. Every script also passes without `-x`, through the directive `# shellcheck source=common.bash disable=SC1091` at its `source` line, which is how `examples/commonIocsh/tests/` does it.
- A procedure page, `docs/src/procedures/run-loader-verification-suite.md`, listed under Procedures after `Run the fragment verification suite`, in the shape of that page: prerequisites, the steps, the order, the three variables, what each script checks, and the expected counts. Its prerequisites are derived from the scripts and the fixtures by searching them, and cover the tools (`bash`, `expect`, `strace`, `docker` or `podman`, `perl`, `gawk`, `readelf`, `ldd`, `ss`, `ip`, `git`, `patch`, `setsid`, `mkfifo`, `truncate`, `sha256sum`, the EPICS client tools of the installed tree, `caget`, `caput`, `pvget`, `pvxget`, and `camonitor`, which the environment script puts on `PATH`, and for `verify_docs_and_tools.bash` ShellCheck and the `jeonghanlee/mdbook` image on a Debian host), the ports (the loopback ports 55064, 55065, 55075, 55076, 9400, 4840, the default port 9399 of the EPICS-IOC-Demo simulator, and 7004, which is the default of the caPutLog fragment in the tc32sim fixture and not set by a script), the image `docker.io/digitalpetri/opc-ua-demo-server`, and network access for the application checkouts. It gives the build steps of a candidate installation, taken from the OS workflows with an install location of its own, for Debian 13 and for any Rocky Linux 8.10 host.
- The expected counts go into `examples/iocsh/tests/README.md` as a table with one row per script, copied from the repeat run of M23 on 2026-10-05: `verify_install_metadata` 12, `verify_directives` 15, `verify_dependency_graph` 18, `verify_relocated_tree` 7, `verify_fixture_tc32sim` 24, `verify_fixture_ioc_demo` 10, `verify_fixture_opcua` 13, `verify_multiple_versions` 25, `verify_resolved_paths` 11, `verify_failure_diagnostics` 37, `verify_elf_inspection` 31, `verify_shell_lifecycle` 30, `verify_make_rules` 33, and `verify_docs_and_tools` 8 on Debian 13 and 6 on Rocky Linux 8.10, where Docker is absent and the book is not built; a host without ShellCheck gives one check fewer and a host without Docker two fewer. For the scripts that count none: the minimal example lists 317 records and no suspicious line, the update command prints `32`, and the truncated-library observation gives status 135 for the cut inside the last loadable segment and 0 for the other two on Debian 13 with glibc 2.41, and 0 for all three on Rocky Linux 8.10 with glibc 2.28.
- Stay out: the wrappers that connect to a host, which are `rr.bash`, `run-rocky.bash`, `run-debian.bash`, `rocky-build-final.bash`, `rocky-build-rerun.bash`, and `debian-build.bash`, and the one-time measurement `fx-tc32sim-gap.bash`.
- The `README.md` of the suite also lists the refusal cases: for each of the 35 cases of the failure-diagnostics script and each fault of the ELF script, the script and the check that provokes it, so that M27 writes its table of refusals from the list and provokes each refusal from the repository (D92).
- `verify_docs_and_tools.bash` compares text of `procedures/set-up-shell.md` through two anchor sentences; M27 adapts them if it edits those sentences (D92).

Out of scope: any change to what the scripts check; the local logs and candidate trees of the earlier runs; the loader pages of M27; running the suite in CI; making the scripts independent of the pins they were recorded on, which a pin bump handles.

##### Completion Criteria

1. The suite is in the repository under the names above, passes ShellCheck with and without `-x` and the Linter, and a search for `192.168.`, `vmadmin`, `/data/`, `/home/`, `m22` or `M22` in any case, the pattern `\bT[0-9]+\b`, and the earlier file names (`lib.bash`, `run-seq`, `t01a`, `t02` through `t11`, `fx-`) finds nothing in the suite and its page; the loopback address `127.0.0.1` is the only allowed hit of the address patterns. The PV prefix `jeonglee:myoffice:` in `verify_fixture_ioc_demo.bash` belongs to the EPICS-IOC-Demo application and is exempt; the patterns do not search for it.
2. On candidate installations built from `master` on Debian 13 and Rocky Linux 8.10, each script gives the counts of the table in the suite `README.md`, and the three scripts that count none give the observations listed there.
3. The procedure page is in the table of contents at the place named above, the book builds with the documented image, and every command on it matches executed output.
4. The `README.md` of the suite lists every refusal case with the script and the check that provokes it.

##### Dependencies And Decisions

- D91, D92, and D94, Decision Date: 2026-10-05, add the suite, set it apart from M27, and fix the runner, the names, the counts, and the shell corrections.
- M23 and M25 are Complete as of 2026-10-05; the suite checks the loader as merged. The recorded counts are in the Verification Results of M23, in the table of the repeat run and the paragraph after it, which also holds the 33 of `verify_make_rules`, the 317 records, and the `32`; the statuses of the truncated-library cuts are in the T3 row of M24.
- M28 comes first (D92): M27 uses its list of refusal cases and checks the suite again against the new pages; `verify_docs_and_tools.bash` compares text of `procedures/set-up-shell.md`, which M27 edits, and M27 adapts its anchors then.
- The Linter runs super-linter with `VALIDATE_BASH` on pushes that do not only change `docs/**` or `ChangeLog.md`; its ShellCheck options could not be read, so the scripts pass with and without `-x`.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-05, owner acceptance of the plan after two third-person and two second-person reviews
Implementation Authorization: 2026-10-05, owner authorization of the current plan. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: none

1. Accept this plan and authorize its implementation.
2. On the workstation that holds `work/m22-tests/`, copy the scripts into `examples/iocsh/tests/` under the new names, and write `run_all.bash` from `run-seq.bash` with the three variables. If that directory is absent, stop.
3. Replace the prefix and the T numbers of the check descriptions, take the paths from the variables, and correct the ShellCheck findings.
4. Write the `README.md` of the suite with the counts table, the observations, and the list of refusal cases, and the procedure page, and list the page in `docs/src/SUMMARY.md`.
5. Build candidate installations on both targets from the working tree that holds the suite, run `run_all.bash`, and compare the counts and the observations with the table. When no Rocky Linux 8.10 host is available, its part of T1 stays Pending, M28 stays In progress, and the host is requested.
6. Search the suite and the page for the patterns of criterion 1, and read the page from the seat of a reader who has only the book.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Suite on both targets | Run `run_all.bash` on candidate installations built from the working tree that holds the suite | Debian 13 and Rocky Linux 8.10 | No failed check; each script gives the counts and observations of the table |
| T2 | Lint | Run `shellcheck` with and without `-x` over the suite and read the Linter workflow on the pushed commit | Checkout of `master`; GitHub Actions | No finding, and the Linter succeeds |
| T3 | Identifiers and earlier names | Search the suite and the page for `192.168.`, `vmadmin`, `/data/`, `/home/`, `m22` in any case, `\bT[0-9]+\b`, and the earlier file names | Checkout of `master` | No match |
| T4 | Procedure page | Build the book, run each command of the page, and read the page as a reader who has only the book | Candidate installation on Debian 13; the built book | Each command matches; no step needs the session's context |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-05T07:22Z through 07:33:24Z (Debian 13), about 07:37Z through 07:46:30Z (Rocky Linux 8.10) | Debian 13 host and the Rocky Linux 8.10 VM; on each, a candidate installation built in full through the workflow steps from an export of the working tree that holds the suite, 245 files, with an install location of its own | Pass. `run_all.bash` ends with status 0 on both targets and every script exits 0 with no `FAIL` line. The counts equal the table of the suite `README.md`: 12, 15, 18, 7, 24, 10, 13, 25, 11, 37, 31, 8 (6 on Rocky Linux 8.10), 30, and 33. The minimal example lists 317 records with no suspicious line, the update command prints `32`, and the truncated-library observation gives 135, 0, 0 on Debian 13 and 0, 0, 0 on Rocky Linux 8.10 | `examples/iocsh/tests/run_all.bash`; logs in `work/m28-run/out-debian13` and `work/m28-run/rocky-logs`, local and untracked |
| T2 | 2026-10-05, ShellCheck locally and the Linter workflow on the pushed commit | Working tree with the suite, ShellCheck 0.10.0; GitHub Actions on `master` at `1c8705ea4c3ab807ca2d5173b78c12042cf5d971` | Pass. ShellCheck reports nothing over the 19 scripts with `-x` and without it, and the Linter workflow succeeds | `shellcheck -x` and `shellcheck` over `examples/iocsh/tests/*.bash`; Linter run 37329668358 and two earlier runs of the same commit; recheck with `gh run view <id> --repo jeonghanlee/EPICS-env` |
| T3 | 2026-10-05 | Working tree with the suite | Pass. A search of `examples/iocsh/tests` and `docs/src/procedures/run-loader-verification-suite.md` for `192.168.`, `vmadmin`, `/data/`, `/home/`, `m22` in any case, `\bT[0-9]+\b`, and the earlier file names finds nothing; the only address is `127.0.0.1` in `common.bash` and `verify_fixture_opcua.bash` | `grep -rn -I` over the two paths |
| T4 | 2026-10-05 | Candidate installation on Debian 13; the book built with the documented image | Pass, with the review state noted. The book builds without error. The documented commands ran: the run with a missing variable ends with status 2 and `missing IOCSH_TEST_TREE`, and a named run of `verify_directives` and a missing script gives 15 passing checks, `no such script`, and status 1. Two second-person passes over the page and the `README.md`, the second from the seat of a Rocky Linux 8.10 maintainer, returned 4 findings that blocked and 20 others, all reflected, among them the scripts that need the second versions, `socat`, the limits of `<log_dir>`, and `conf.rocky8` for the vendor builds on Rocky Linux; each corrected statement was checked against the scripts or the workflow, and the last corrections were not reviewed a third time | `mdbook build docs` with `jeonghanlee/mdbook`; `examples/iocsh/tests/run_all.bash`; `docs/src/procedures/run-loader-verification-suite.md` |

##### Closure Evidence

- Verification: T1 through T4 are recorded above. T1 ran on candidate installations built from the working tree that holds the suite, which equals the committed suite; T4 rests on two second-person reviews whose last corrections were checked against the scripts and not reviewed a third time.
- Landing on `master`: observed 2026-10-05T15:34Z after `git fetch`, `origin/master` equals the local head `1c8705ea4c3ab807ca2d5173b78c12042cf5d971`, which follows the commit `ec52ed531a01789ad61037caf403a7881087091e` that carries the suite; all six OS workflows, the Linter, and the documentation deployment succeed at it: Debian 12 37329668567, Debian 13 37329668979, Rocky 8 37329668934, Rocky 10 37329668782, Ubuntu 24.04 37329668651, Ubuntu 26.04 37329668688, Linter 37329668358, Deploy Docs 37329668399. The runs were started two or three times for the commit, and one documentation run was cancelled by a newer one; every other run succeeded.
- Complete on 2026-10-05: the deliverable, T1 through T4, and the repository changes on `master` are observed; no issue is linked.

#### M29 - Installed Opcua Configuration And Repeated Installation

Origin: 84ee626 / M29
Identity History: Opened on 2026-10-05 by D95 from a second run of the loader verification suite on one tree
GitHub Issue: none
Status: Complete

##### Summary

The installed `cfg/CONFIG_OPCUA` of the opcua module is relative to its own location after a fresh build and holds an absolute path after a later installation. The loader verification suite shows it: a second run on the same tree fails two checks of `verify_install_metadata.bash`, which compare the content of the installed files before and after a repeated installation. Find the cause and make a repeated installation leave the file unchanged, or record why the behavior stays.

##### Scope

- Reproduce the change on a fresh Debian 13 candidate installation built through the workflow steps: read the line `OPEN62541 = ...` of `modules/opcua-0.11.2/cfg/CONFIG_OPCUA` after the build, after `make install.opcua`, and after the patch round trip of `verify_make_rules.bash`, and record which step changes it.
- Isolate the cause in the opcua build and in the carried patch `patch/opcua-CONFIG_OPCUA.p0.patch`, which makes the installed file derive its path from its own location. Two leads, not conclusions. First, `tools/prep-vendors.bash` writes `OPEN62541_PATH=$$(_OPEN62541_CONFIG_OPCUA)/../../../vendor` into `configure/RELEASE.local`, and `conf.opcua` in `configure/RULES_MODS_CONFIG` copies it with `echo "OPEN62541 = $(OPEN62541_PATH)"` into `configure/CONFIG_SITE.local`; the value passes through make and through the shell in double quotes, and a build and a later installation may not expand it the same way. Second, the patch round trip changes the source `devOpcuaSup/open62541/CONFIG_OPCUA@`, so the next installation may generate the file again; this has not been shown.
- Correct it in the rules of this repository or in the carried patch so that every installation writes the same file, and update the text of the suite `README.md` and its procedure page that tells the reader to run the suite once per candidate installation.

Out of scope: the relocation of other installed text files, which `docs/CLOSED_DOORS.md` K11 keeps; the static archive that changes on reinstallation, K13; the data path of the original opcua startup, M26.

##### Completion Criteria

1. The step that changes the file is named, with the evidence of a run on a fresh candidate installation.
2. After the correction, `make install` and `make install.opcua` repeated on fresh candidate installations on Debian 13 and Rocky Linux 8.10 leave `cfg/CONFIG_OPCUA` byte for byte unchanged, and the loader still starts the opcua fixture.
3. `run_all.bash` run twice on one candidate installation gives the counts of the suite `README.md` both times, and the note about one run per candidate is removed.
4. All six operating system workflows and the Linter succeed on the pushed commit. Alternatively the owner decides, after the cause is known, to keep the behavior; then the cause and the decision are recorded in `docs/CLOSED_DOORS.md` and criteria 2 and 3 are not required.

##### Dependencies And Decisions

- D95, Decision Date: 2026-10-05, opens the work and states what was observed and what is not known.
- M23 and M28 are Complete as of 2026-10-05; the suite is the real path that shows the change.
- The correction touches the opcua build configuration, so the six operating system workflows are the final check.

##### Implementation Plan

Plan Status: implemented
Plan Acceptance: 2026-10-05, owner
Implementation Authorization: 2026-10-05, owner, for steps 2 and 3; step 4 reports the chosen correction to the owner before it is implemented
Superseded Plan Artifacts: none

1. Accept this plan and authorize its implementation.
2. Build a fresh candidate installation on Debian 13 and read the line `OPEN62541 = ...` and the SHA-256 digest of `cfg/CONFIG_OPCUA` after the build, after `make install.opcua`, after the patch round trip of `verify_make_rules.bash`, and after `make install.opcua` again. This step changes no tracked file.
3. At the first step that changes the file, compare `configure/CONFIG_SITE.local` and `configure/RELEASE.local` of the opcua source with the values before it, and name the cause.
4. Choose the correction by cause and report it to the owner before implementing it: the value written by `conf.opcua` if the lead of `OPEN62541_PATH` holds, the state of the carried patch before and after the round trip if the second lead holds, or a K record in `docs/CLOSED_DOORS.md` if the owner keeps the behavior.
5. Implement it, repeat `make install` and `make install.opcua` on fresh candidates on Debian 13 and Rocky Linux 8.10, and run the suite twice on one tree. The Rocky Linux host needs a restart request to the session that provides it.
6. Remove the note about one run per candidate from the suite `README.md` and page, push, and read the workflows on the pushed commit.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Reproduction | Read the line `OPEN62541 = ...` of the installed `CONFIG_OPCUA` after the build, after `make install.opcua`, and after the patch round trip of the suite | Fresh candidate installation on Debian 13 | The step that rewrites the file is named |
| T2 | Repeated installation | Run `make install` and `make install.opcua` twice and compare the SHA-256 digest of `cfg/CONFIG_OPCUA` | Fresh candidate installations on Debian 13 and Rocky Linux 8.10 | The digest does not change, and the opcua fixture reaches `iocInit` through the loader |
| T3 | Suite twice | Run `run_all.bash` twice on one candidate installation | Fresh candidate installation on Debian 13 | Both runs give the counts of the suite `README.md` |
| T4 | CI | Read the workflows on the pushed commit | GitHub Actions | All six operating system workflows and the Linter succeed |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-05T17:30Z | Debian 13, fresh candidate built from `bca6d7e` | Pass | The line and digest of `cfg/CONFIG_OPCUA` stay literal and `7a6cc0af` after the build, after `make install.opcua`, after `make patch.revert`, and after `make patch`; the following `make install.opcua` writes the absolute path and the digest `fc935e09`. The `-D OPEN62541=` value of `expandVars.pl` differs between the build and that installation; see D96 |
| T2 | 2026-10-05T18:20Z and 2026-10-05T19:50Z | Debian 13 and Rocky Linux 8.10, fresh candidates with the change | Pass | Digest `7a6cc0af` after the build, after `make install.opcua` twice, and after `make install` twice on both targets; on Rocky Linux 8.10 one run of the suite follows with every count equal to the suite `README.md` (6 for `verify_docs_and_tools`, without Docker), the opcua fixture at 13 and the digest unchanged; a candidate without the change and without the include fails to link with `cannot find -lopen62541` |
| T3 | 2026-10-05T18:45Z | Debian 13, same candidate | Pass | `run_all.bash` ran twice on one tree, both runs exit 0, every count equals the suite `README.md`, and the digest is `7a6cc0af` after both |
| T4 | 2026-10-05T21:59Z | GitHub Actions at `649d29872a3d11717ea19862ed0b0304565fbb4e` | Pass | Debian 12, Debian 13, Ubuntu 24.04, Ubuntu 26.04, Rocky Linux 8, Rocky Linux 10, the Linter, and Deploy Docs succeed; five jobs first ended without a start because GitHub gave them no hosted runner, and succeeded when they were run again |

##### Closure Evidence

- Completed 2026-10-05. The correction is `649d29872a3d11717ea19862ed0b0304565fbb4e`: `conf.opcua` writes `CONFIG_OPCUA_EXPANDFLAGS`, so every installation writes the literal `OPEN62541` line, as D96 records. T1 through T4 pass on Debian 13, Rocky Linux 8.10, and the operating system workflows; the suite README and its procedure page no longer limit the suite to one run per tree.

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Build | M2 | Teach the module generator the correct per-module source-base URLs | Milestone | Complete | Yes | M6, D15, D99 | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m2---generator-src-url-overrides) |
| IOC shell | M3 | Promote commonIocsh to its public module repository | Milestone | Deferred | No | D2, D7 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m3---commoniocsh-promotion) |
| IOC shell | M5 | Ship a global iocsh startup file for the common services | Milestone | Deferred | No | D8 | `commonIocsh/iocsh/` ships one global startup file that loads the common-service fragments with optional serial configuration, and an example IOC boots with only that file; [detail](#m5---global-iocsh-startup-file) |
| Libera | M20 | Verify the Libera cross-build and generated profile | Milestone | Deferred | No | D42 | Real nine-module cross-build, generated-profile repetition, and documentation comparison pass; excluded from M14 completion; [detail](#m20---libera-cross-build-and-generated-profile) |
| macOS | M21 | Verify patch revert on actual macOS | Milestone | Deferred | No | D49 | Real macOS patch-revert cases pass with the Darwin mca path active, recorded patch executable, and preserved failure-boundary inventories; excluded from M15 completion; [detail](#m21---macos-patch-revert-verification) |
| Runtime | M24 | Examine three observations from the loader verification | Milestone | Complete | No | D84, D87 | Each observation, the static archive that changes on reinstallation, the IOC crash on a damaged DBD, and the host-dependent end on a truncated library, has a recorded cause and either a work item or a closed-door record; [detail](#m24---loader-verification-observations) |
| Runtime | M26 | Verify the original opcua-IOC-demo startup against the Unified Automation example server | Milestone | Deferred | No | D86 | With `uaservercpp` running, the original `examples/iocsh/opcua-IOC-demo/st.cmd` reads its `Demo` records without alarm on Debian 13 and Rocky Linux 8.10; excluded from M23 completion; [detail](#m26---original-opcua-startup-data-path) |

### Backlog Details

#### M2 - Generator SRC URL Overrides

Origin: 84ee626 / M2
Identity History: none
GitHub Issue: #75, https://github.com/jeonghanlee/EPICS-env/issues/75
Status: Complete

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

- Parked to the Backlog per D1; D98 puts it first in the order of the remaining work.
- D15: starts after M6 is Complete, and updates the book M6 wrote.
- D99 decides the design as Option A: the base of each module is declared in its block of `configure/RELEASE` and the generator falls back to `SRC_URL_EPICSMODULES`. Option B, a module-to-base table inside the generator, is not taken because it separates a module from its base and moves the special cases into the shell-echo loop.

##### Implementation Plan

Plan Status: implemented
Plan Acceptance: 2026-10-05, owner
Implementation Authorization: 2026-10-05, owner
Superseded Plan Artifacts: none

1. Design decided as Option A under D99.
2. Capture the baseline `make print-SRC_GITURL_*` for the twelve modules on the current tree.
3. Add `SRC_BASE_<module>` to the twelve module blocks of `configure/RELEASE` as the existing `## SRC_URL_*` comments name them, make the generator in `configure/CONFIG_MODS` use it with the `SRC_URL_EPICSMODULES` fallback, and add `SRC_BASE_*` to `MODS_GEN_INPUTS` so a changed base regenerates the cache.
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
| T1 | 2026-10-05T23:13Z | Repository checkout on Debian 13 | Pass | The `SRC_GITURL_*` values of all 32 modules, read with `make print-SRC_GITURL_<module>` before and after the change, are identical; the generated `configure/MODULESGEN.mk` carries the same 32 values; changing one `SRC_BASE_*` line regenerates the file; the clone commands of `make -n init` are identical before and after, and the twelve addresses answer `git ls-remote`; a `SRC_URL_MD` set in `RELEASE.local` reaches `pscdrv` and `linStat` as before the change; `mdbook build docs` succeeds. all six operating system workflows, the Linter, and the documentation deployment succeed on the pushed commit `d71599fbb7330db99b46b00b2835b57dba24cc27`, observed 2026-10-05T23:42Z (4:42 PM PDT) |

##### Closure Evidence

- Completed 2026-10-05 at `d71599fbb7330db99b46b00b2835b57dba24cc27` under D99: `configure/RELEASE` carries `SRC_BASE_<module>` for the twelve modules hosted outside `epics-modules`, the generator uses it with the `SRC_URL_EPICSMODULES` fallback, `SRC_BASE_*` is an input of the generated cache, and the `SRC_GITURL_*` re-definitions of `configure/CONFIG_MODS` with their commented-out predecessors are removed. The book describes the mechanism. GitHub issue #75 is still open.

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
Status: Deferred

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
Status: Deferred

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

#### M24 - Loader Verification Observations

Origin: 84ee626 / M24
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The loader verification runs of 2026-10-04 on Debian 13 and Rocky Linux 8.10 showed three behaviors outside the loader's own checks. None of them failed a loader criterion. Each needs its cause examined before deciding whether it is work or a closed door.

##### Scope

- A repeated `make install` on Rocky Linux 8.10 changes the content of `modules/opcua-0.11.2/lib/linux-x86_64/libopcua.a`; shared libraries, DBD files, and loader metadata keep their digests, and the Debian 13 tree shows no changed archive.
- `softIocPVX` ends with a segmentation fault, status 139, after `ERROR: syntax error` when `dbLoadDatabase` reads a DBD file with an unterminated record type; observed on both targets with a deliberately damaged copy of `linStat.dbd`.
- A selected library truncated just behind its dynamic section passes the static ELF inspection of the wrapper. The IOC then ends with a bus error, status 135, on Debian 13 and with a `dlload` error and status 2 on Rocky Linux 8.10.

Out of scope: the loader behavior that M23 verifies; in each damaged-file case the application database is not loaded and `iocInit` does not run, as M23 / T7 and M23 / T8 require.

##### Completion Criteria

1. The cause of the changed static archive is identified from the opcua build rules and the archiver of each target, with the decision whether reinstallation must leave archives unchanged.
2. The DBD crash is reproduced with the installed `softIocPVX` and with Base `softIoc`, and it is recorded whether Base, PVXS, or neither is the place for a correction.
3. The decision whether the wrapper should detect a truncated library before IOC launch is recorded with its cost at startup.
4. Each observation ends as a work item with its own plan or as a `docs/CLOSED_DOORS.md` record.

##### Dependencies And Decisions

- No dependency on M23 completion: the observations concern the opcua build, the native DBD parser, and the scope of the static inspection.
- The static archive observation ended as a Keep on 2026-10-04, recorded as K13 in `docs/CLOSED_DOORS.md`.
- D84 carries a Base site patch for the DBD crash, decided on 2026-10-04; that work continues as M25.
- D87 adds the truncation check to the ELF tool for the third observation, decided on 2026-10-04.
- No release version or ordering is assigned.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Reproduce each observation on a candidate installation of the current branch on both targets.
2. Examine the cause of each and present the choice between work and a closed-door record to the owner.
3. Record the outcomes and split accepted work into its own rows.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Reinstallation | Run `make install` twice and compare the digests of every installed static archive, shared library, and DBD file | Candidate installations on Debian 13 and Rocky Linux 8.10 | The changed files and the build step that rewrites them are identified |
| T2 | Damaged DBD | Load a DBD with an unterminated record type through the installed `softIocPVX` and through Base `softIoc` | Both targets; real installed executables | The end status and message of each executable are recorded |
| T3 | Truncated library | Start the minimal example with a selected library cut behind its dynamic section, in a copy of the tree | Both targets; a copy of a candidate installation | The layer that refuses the library and the end status are recorded for each target |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-10-04 | Candidate installations of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f` on Debian 13 and Rocky Linux 8.10 | Cause identified: opcua regenerates its version header on every `make` and rebuilds its library, and `ar` 2.30 on Rocky Linux 8.10 writes member timestamps where `ar` 2.44 on Debian 13 writes zeros. A second `make install.opcua` on Rocky Linux 8.10 changed the digest of `libopcua.a` and kept that of `libopcua.so.0.11`. The full digest comparison of every static archive after two installations was run on 2026-10-04 with M23 / T1: one changed archive on Rocky Linux 8.10, none on Debian 13 | K13 in `docs/CLOSED_DOORS.md` |
| T2 | 2026-10-04, patched run at 2026-10-04T17:53:54Z | Candidate installations of `10d220259ccb542c8ec4cf0dfe1b678eb05c3c3f` on Debian 13 (GCC 14.2.0) and Rocky Linux 8.10 (GCC 8.5.0); installed `softIocPVX` and Base `softIoc`; then the same candidates with `patch/7.0.10.base.p0.patch` applied through `make patch.base.apply` and Base rebuilt and reinstalled | Cause identified and corrected. Without the patch, a DBD that ends after `recordtype(x) {`, after `field(`, or inside `device(...` ends both executables with status 139 after `ERROR: syntax error`; `gdb` on Rocky Linux 8.10 places the fault in `yyerror` at `dbStatic/dbYacc.y:381`, reading `pinputFileNow->line_num` after the last input file is closed; a syntax error before the end of a file is reported normally. With the patch, the same files give `ERROR: syntax error` and ` at end of input` without a fault on both targets, and a startup with `on error break` ends with status 2 before `iocInit`. `make patch.base.revert` does not revert the patch: `tools/revert_patch.bash` counts the forward declaration of `yyerror` as a second definition and reports that it cannot classify the state; D85 corrects that check, as M25 / T2 records | `patch/7.0.10.base.p0.patch`; `patch/README.md`, section on the site patch; `work/m22-tests/t07.bash` with logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |
| T3 | 2026-10-04T21:28:54Z | Candidate installations on Debian 13 (glibc 2.41) and Rocky Linux 8.10 (glibc 2.28) with the D87 tools installed through `make install.iocsh`; a copy of each tree for the cut library | Cause identified and corrected. A library cut inside its last loadable segment ends the IOC with a bus error, status 135, on Debian 13, and with `ELF load command past end of file` and a break on Rocky Linux 8.10; a library cut behind its loadable segments loads and the IOC runs on both. Before D87 the static inspection passed all of these. With D87 the wrapper refuses the first case in the show mode and in a real start with status 1 and `is truncated: its size is ... bytes, but its last loadable segment ends at ...` before any IOC launch on both targets, the `undefined` mode prints `truncated <file>`, and the second case still starts the IOC | `work/m22-tests/t07.bash` and `work/m22-tests/trunc.bash`; logs under `work/m22-tests/out-debian13` and `work/m22-tests/out-rocky8`, local and untracked |

##### Closure Evidence

- The static archive observation is closed by K13, Decision Date 2026-10-04. The DBD observation became the work M25 under D84. The truncated-library observation is corrected under D87. Every observation has its outcome.
- Landing: observed 2026-10-04T23:09Z after `git fetch`, `origin/iocsh-module-loader` equals the local head `fd4dcf1ff28c10e6948ef9f9ee908b035e9ea0bf` and carries the truncation check in `81abb4f`; all six OS workflows and the Linter succeed at that head by 2026-10-04T22:52:07Z: Debian 12 37240107521, Debian 13 37240107514, Rocky 8 37240107524, Rocky 10 37240107522, Ubuntu 24.04 37240107515, Ubuntu 26.04 37240107520, Linter 37240107516.
- No issue is linked to this work. Complete on 2026-10-04.

#### M26 - Original opcua Startup Data Path

Origin: 84ee626 / M26
Identity History: Unexecuted data-path check separated from M23 / T13 to Backlog on 2026-10-04 (D86)
GitHub Issue: none in this repository; #93 remains linked to M23 and states this check as pending. jeonghanlee/opcua-IOC-demo#1 proposes replacing the Unified Automation server in the application with an open-source server
Status: Deferred

##### Summary

M23 verifies the opcua-IOC-demo data path with the Eclipse Milo startup variant. The original startup of the application reads nodes that only the Unified Automation example server `uaservercpp` provides, and no such server was available. This work keeps that check without delaying M23.

##### Scope

- Run the original `examples/iocsh/opcua-IOC-demo/st.cmd` through the installed `iocsh.bash` against a running `uaservercpp` at its default address `opc.tcp://127.0.0.1:48020`.
- Read the records of the eight `Demo` databases and of `Demo.WorkOrder` through CA, and judge them by the criteria of the fixture `README.md`: no alarm, the `Demo.Dynamic` records advancing their timestamps within the 200 millisecond subscription plus 2 seconds, and a read answering within 5 seconds.

Out of scope: the loader behavior and the Milo variant, which M23 verifies; a server written to imitate the `Demo` nodes.

##### Completion Criteria

1. The session of the original startup connects to a real `uaservercpp` on Debian 13 and Rocky Linux 8.10.
2. The records meet the fixture criteria, and the evidence names the server version and the bundle it came from.

##### Dependencies And Decisions

- D86, Decision Date: 2026-10-04, keeps this scope as Deferred Backlog and excludes it from M23 completion. A new execution decision is required to resume, when the server bundle is available.
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
| T1 | Not run; deferred on 2026-10-04 | No `uaservercpp` available | Pending: the original startup reaches `iocInit` and its records read `INVALID` with `COMM` without the server, recorded under M23 / T13 | D86 |

##### Closure Evidence

- None. The separation records Deferred work only; M23 completion or #93 closure does not complete or authorize M26.

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-09-25 | `84ee62697e4da0fff141cf5e97af77357d8ce58a` (`docs/milestone-1.4.0.md`) |
