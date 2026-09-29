# Work Register

Release line: master
Milestone index: 84ee626
Canonical path: `docs/milestone-84ee626.md`
Canonical branch or ref: `master`
Git upstream: `origin/master`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone Backlog, number 3

Next session entry point: EPICS-env 1.4.0 is released and closed (RELEASED 2026-09-24; closure commit `84ee626`). M4 (CI workflow triggers and OS set, #78), worked on `master` by D10, is Complete on 2026-09-26 and #78 is closed. M6 (documentation rewrite from the current code, mdBook as its main home), worked on `master` by D14, is Complete on 2026-09-28: the book is published from `master`, the agent procedures and READMEs agree with it, and T1-T4 pass. D17 adds M7, M8, and M9 for the code defects the documentation work found. M8 (unused site-template removal, #82) is Complete on 2026-09-28 and #82 is closed. M7 (`IOCSH_TOP` unification under D22, #81) is Complete on 2026-09-28 and #81 is closed. D23 splits the remaining inventory defects into M9 (C17 bridge, D19) and M10-M19. M9 (C17 bridge, #80) is Complete on 2026-09-28: implementation commit `64ba7d3` is on `origin/master`, T1-T6 pass, all eight CI workflows succeeded (Rocky 8 on attempt 2), and #80 is closed. M10 (module configuration consistency, #83) is Complete on 2026-09-29: implementation commit `6bbb6a5` is on `origin/master`, T1-T4 pass, all six OS workflows plus Linter and documentation deployment succeeded, and #83 is closed. The remaining inventory groups are #84-#92, linked to M11-M19. M11's expanded Implementation Plan and Test Plan (#84) are accepted on 2026-09-29, including the T2 package preparation and identical-environment comparison conditions. D25 adds `conf.rocky10` in both vendor repositories with `conf.rocky8` compatibility, then switches the Rocky 10 consumer after both vendor changes land. The accepted plan also adds the missing audit to three OS workflows and updates the matching documentation. Implementation of the accepted M11 plan is authorized on 2026-09-29. Both tested vendor changes are published on their default master branches: uldaq-env `988b1523a759855b5e98c23e3cde050ab8d1b26e` and open62541-env `00e5e60eb24a64d94578b608538d4288c90a0dbf`. The EPICS-env consumer change is published as `921cd5f843df1ffc4167324fd762be33a6bb4164`. D26 documentation guard repair is published as `840ad37dd8bb279db7688efcf0c866c0f14e259c`. T1-T6 pass: the actual Rocky 10 run consumes both tested vendor commits; all three changed OS workflows pass the strict dependency audit, build, installation, and final checks; the corrected documentation guard, Pages deployment, and Linter succeed. M11 is Complete on 2026-09-29: verification evidence is published in `2b27ed5d790569121930003dee5823c0f4e52ef7`, the #84 body matches the implementation and verification results, and #84 is closed as completed at 2026-09-29T18:49:21Z. Next, commit this closure record, then review the M12 plan against the current code. M10 completion context: the upstream motorSimTest.src startup failure occurs on both compared revisions and remains outside the implemented dependency change. All five remaining directions were selected on 2026-09-28: keep the motor prerequisites, QPC configuration, and conditional diagnostic hint (CLOSED_DOORS K5-K7); move QPC and sscan to the other-module configuration group; remove only the unused top-level linker-root assignment. M10's four plan reviews are incorporated: M10 / T1 checks effective configuration and the selected changes, M10 / T2 covers six local/parent override changes, M10 / T4 sets each installation root in the checkout's configure/CONFIG_SITE.local and verifies the exact installed base path before module verification, and the cache invalidation change has an implementation step. M10's documentation scope includes the module add-or-bump procedure and QPC's inherited ASYN exception. M10's plan acceptance and implementation authorization are recorded on 2026-09-28; M11 is Complete; M12-M19 remain Ready and each opens with a plan review that re-verifies its items against the current code. Work them in ID order: M10 before M12, because both change the `MODULESGEN.mk` regeneration rule, and M19 last, because its hygiene items overlap the files of M10 and M15. Backlog M2 (#75) is Ready now that M6 is Complete, and updates the book where the module source-URL mechanism changes (D15). The Backlog holds the other surviving work. When the first release work is assigned, choose the next release version under D9 (1.4.1 for fixes only, 1.5.0 for module-set or feature changes), create `release-X.Y.Z` from `master`, reset this register into `docs/milestone-X.Y.Z.md`, and set `ENV_RELEASE_VERS` to X.Y.Z in its own commit. References of the form `1.4.0 M<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

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
| Code | M12 | Remove the side effects of read-only make targets | Milestone | Not started | Yes | D17, D23 | `make print-%` and other read-only targets create no directory and regenerate no file; [detail](#m12---make-time-side-effects) |
| Code | M13 | Fix the argument handling and exit codes of the `tools/` scripts | Milestone | Not started | Yes | D17, D23 | Each listed `tools/` defect is fixed or kept, and each script's exit codes match its usage text; [detail](#m13---tools-script-defects) |
| Code | M14 | Fix the environment scripts under `scripts/` | Milestone | Not started | Yes | D17, D23 | `setEpicsEnv.bash` and `resetEpicsEnv.bash` work under `set -u` and keep unrelated `PATH` entries, and the listed `scripts/` defects are fixed or kept; [detail](#m14---environment-script-defects) |
| Code | M15 | Make the clean, uninstall, and patch-revert targets complete | Milestone | Not started | Yes | D17, D23 | `uninstall.modules`, `clean.modules`, and `make patch.revert` after a partial `make patch` complete, and the patch justifications match the audit; [detail](#m15---clean-uninstall-and-patch-revert) |
| Code | M16 | Decide how installed files name foreign and absolute paths | Milestone | Not started | Yes | D17, D23 | Each listed installed file is fixed or recorded as a Keep, so a downstream IOC and a moved tree behave as the book states; [detail](#m16---installed-tree-portability) |
| Code | M17 | Fix the iocLog, autosave, and iocStatsAdmin fragment defects | Milestone | Not started | Yes | D17, D23 | `LOGDISABLE=1` disables IOC logging, the autosave header states its `system.dbd` need, and the iocStatsAdmin limits and linStat collisions are fixed or kept; [detail](#m17---common-iocsh-fragment-defects) |
| Code | M18 | Make the fragment tests safe and check what they claim | Milestone | Not started | Yes | D17, D23 | `t3_run.sh` deletes no source checkout, `common.sh` has no user-specific default, and `verify_serial.sh` checks bits and parity or states that it does not; [detail](#m18---fragment-test-defects) |
| Code | M19 | Remove unused build-system names, variables, and stale files | Milestone | Not started | Yes | D17, D23 | Each listed hygiene item is fixed or kept, and every OS workflow passes; [detail](#m19---build-system-hygiene) |

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

### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| M4 (CI workflow triggers and OS set, #78) | Backlog, `docs/milestone-84ee626.md`, `master` | Milestone, `docs/milestone-84ee626.md`, `master` | this synchronization commit | this synchronization commit |

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
Status: Not started

##### Summary

Every make run creates the install location and can regenerate `MODULESGEN.mk`, including runs that only print a variable. The M6 code inventory found these defects.

##### Scope

- Make-time side effects: every make run, including `print-%`, runs `mkdir -p $(INSTALL_LOCATION)` (`configure/CONFIG_SRC:46`) and can regenerate `MODULESGEN.mk`.

Out of scope: the defects of M9, M10, M11, M13, M14, M15, M16, M17, M18, M19.

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
| T1 | Side effects | In a fresh clone whose `INSTALL_LOCATION` does not exist, run `make print-INSTALL_LOCATION` and compare `git status` and the file system before and after | Repository checkout | No directory is created and no file changes |
| T2 | Integration | Push the change to `master` and read the OS workflow runs | GitHub Actions on `master` | Every OS workflow passes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |
| T2 | Not run | GitHub Actions on `master` | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Remove side effects from read-only make targets
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:19.540708+00:00, `gh issue view 85 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:19.540708+00:00 (remote updatedAt 2026-09-28T23:00:18Z)

#### M13 - Tools Script Defects

Origin: 84ee626 / M13
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #86, https://github.com/jeonghanlee/EPICS-env/issues/86
Status: Not started

##### Summary

The `tools/` scripts mishandle arguments, missing programs, and exit codes, and the `check.deps` gate scans modules twice. The M6 code inventory found these defects.

##### Scope

- Scripts: `tools/prep-vendors.bash` tests the unassigned `EPICS_MODS_PATH` and `SRC_VER`, writes a site NTP host, and overwrites `configure/CONFIG_SITE.local`; `tools/prep-vendors.bash` also exits 1 for `help` and applies `conf.rocky8` to every Red Hat-family host; `tools/pvs_gets.bash` prints an invalid `printf "%\n"` format and exits 0 when `caget` or `pvget` is missing; `tools/update-release.bash` exits 1 for `help` and usage errors, the code `check` uses for an incomplete survey; `tools/gen_dep_graph.bash` loops forever when `-o` or `-f` has no argument and exits 1 for `-h`; `tools/pv_snapshot.bash` exits 1 without a message when `-l`, `-o`, `-w`, or `-t` is the last argument, because `shift 2` fails, while its usage text documents exit 2 for usage errors (`tools/pv_snapshot.bash:84-86,152`).
- Verification gate: `tools/check_deps.bash:98` globs `modules/*/bin/linux-x86_64`, which matches each versioned module directory and its unversioned link, so `check.deps` scans and counts every module executable twice; it exits 0 when `INSTALL_LOCATION_EPICS` is empty or missing, passing after scanning zero files.

Out of scope: the defects of M9, M10, M11, M12, M14, M15, M16, M17, M18, M19.

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
| T1 | Script | Run each listed invocation of each script (help, missing option argument, missing program, empty install location) and record its output and exit code | Repository checkout and an installed tree | Each exit code and message matches the script usage text; `check.deps` counts each executable once and fails on an empty install location |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout and an installed tree | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Fix tools script argument handling and dependency checks
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:22.615124+00:00, `gh issue view 86 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:22.615124+00:00 (remote updatedAt 2026-09-28T23:00:21Z)

#### M14 - Environment Script Defects

Origin: 84ee626 / M14
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #87, https://github.com/jeonghanlee/EPICS-env/issues/87
Status: Not started

##### Summary

The environment scripts abort under `set -u`, corrupt `PATH`, and name paths or targets that do not exist. The M6 code inventory found these defects.

##### Scope

- Scripts: `scripts/selectEpicsEnv.bash` builds a path that does not match the install layout; `scripts/build_modules_libera.bash` requests `build.sequencer-2-2`; `scripts/setEpicsEnv.bash` reads `$1` both as an architecture override and as the `disable` switch.
- Environment scripts: `scripts/setEpicsEnv.bash` aborts under `set -u` (unguarded `$1`, `EPICS_BASE`, `LD_LIBRARY_PATH`), and its `drop_from_path` removes the drop path as an unanchored substring, corrupting `PATH` entries that contain it (`scripts/setEpicsEnv.bash:48-51`). `scripts/resetEpicsEnv.bash` leaves `EPICS_PATH` exported, aborts under `set -u` at `EPICS_EXTENSIONS`, shares the `drop_from_path` bug, names itself `setEpicsEnv.bash`, and is not installed with `setEpicsEnv.bash` (`configure/RULES_BASE:103`).

Out of scope: the defects of M9, M10, M11, M12, M13, M15, M16, M17, M18, M19.

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
| T1 | Environment | Source `setEpicsEnv.bash`, then `resetEpicsEnv.bash`, in a `set -u` shell whose `PATH` holds an entry that contains the drop path as a substring | An installed tree | Both scripts complete, the unrelated entry survives, and no EPICS variable remains after the reset |
| T2 | Script | Run `selectEpicsEnv.bash` and `build_modules_libera.bash` against an installed tree and the current make targets | Repository checkout and an installed tree | Each resolves an existing path or target |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | An installed tree | Pending | none |
| T2 | Not run | Repository checkout and an installed tree | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Fix environment script paths and shell variable handling
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:25.658292+00:00, `gh issue view 87 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:25.658292+00:00 (remote updatedAt 2026-09-28T23:00:24Z)

#### M15 - Clean, Uninstall, And Patch Revert

Origin: 84ee626 / M15
Identity History: Split from M9 on 2026-09-28 (D23)
GitHub Issue: #88, https://github.com/jeonghanlee/EPICS-env/issues/88
Status: Not started

##### Summary

The std module stops the clean and uninstall targets, and `make patch.revert` stops at a patch that was never applied. The M6 code inventory found these defects.

##### Scope

- Clean and uninstall: `uninstall.std` and `distclean.std` fail because `std-src/Makefile` always recurses into `iocs/stdTestIOC`, whose `EPICS_BASE` resolves to an upstream path, so `uninstall.modules` and `clean.modules` stop at std.
- Patch carry: after a partial `make patch`, `make patch.revert` stops at the first patch that was never applied, because `patch -R` exits 1 there (`configure/RULES_FUNC:39,67`). `configure/RULES_PATCH:81-86,101-105` justifies the `feed-core-libonly` and `QPC-dataonly` patches as preventing strict `check.module-deps` failures, but the strict audit passes for both modules with the patches reverted.

Out of scope: the defects of M9, M10, M11, M12, M13, M14, M16, M17, M18, M19.

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
| T1 | Clean | Run `make uninstall.std`, `make distclean.std`, `make clean.modules`, and `make uninstall.modules` on a built tree | Host with a built tree | Each exits 0 |
| T2 | Patch | Apply part of the patch set, then run `make patch.revert` | Repository checkout | The revert completes and the sources match the pins |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Host with a built tree | Pending | none |
| T2 | Not run | Repository checkout | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Make clean, uninstall, and partial patch revert complete
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T23:00:28.684248+00:00, `gh issue view 88 --repo jeonghanlee/EPICS-env`)
Observed Labels: bug
Observed Milestone: Backlog
Observed Assignee: jeonghanlee
Last Compared: 2026-09-28T23:00:28.684248+00:00 (remote updatedAt 2026-09-28T23:00:27Z)

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

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m1---epicspath-normalizerelpath) |
| Build | M2 | Teach the module generator the correct per-module source-base URLs | Milestone | Not started | Yes | M6, D15 | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m2---generator-src-url-overrides) |
| IOC shell | M3 | Promote commonIocsh to its public module repository | Milestone | Not started | No | D2, D7 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m3---commoniocsh-promotion) |
| IOC shell | M5 | Ship a global iocsh startup file for the common services | Milestone | Not started | No | D8 | `commonIocsh/iocsh/` ships one global startup file that loads the common-service fragments with optional serial configuration, and an example IOC boots with only that file; [detail](#m5---global-iocsh-startup-file) |

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

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-09-25 | `84ee62697e4da0fff141cf5e97af77357d8ce58a` (`docs/milestone-1.4.0.md`) |
