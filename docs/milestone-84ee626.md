# Work Register

Release line: master
Milestone index: 84ee626
Canonical path: `docs/milestone-84ee626.md`
Canonical branch or ref: `master`
Git upstream: `origin/master`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone Backlog, number 3

Next session entry point: EPICS-env 1.4.0 is released and closed (RELEASED 2026-09-24; closure commit `84ee626`). M4 (CI workflow triggers and OS set, #78), worked on `master` by D10, is Complete on 2026-09-26 and #78 is closed. M6 (documentation rewrite from the current code, mdBook as its main home) is assigned on `master` by D14 and In progress; its plan, revised under D16, was accepted and authorized on 2026-09-26. Steps 1 and 2 are done: the code inventory is in `docs/design/m6-code-inventory.md` and the accepted book structure is in the M6 Implementation Plan. Step 3 is done: the book is committed in 1916c08, corrected against T2 in 9cf7108, and published; T1, T2, and T3 pass. Next, step 4 (the documents outside the book). D17 adds M7, M8, and M9 for the code defects the inventory found; under D18 the book describes the current `IOCSH_TOP` convention and M7 updates it later. The Backlog holds the other surviving work. When the first release work is assigned, choose the next release version under D9 (1.4.1 for fixes only, 1.5.0 for module-set or feature changes), create `release-X.Y.Z` from `master`, reset this register into `docs/milestone-X.Y.Z.md`, and set `ENV_RELEASE_VERS` to X.Y.Z in its own commit. References of the form `1.4.0 M<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CI | M4 | Align the CI workflow triggers and OS set with the shipped targets | Milestone | Complete | - | | Every OS workflow runs when its own file changes and ignores the same sibling set; the CI OS set matches the shipped gz OS set or the difference is a recorded decision; [detail](#m4---ci-trigger-and-os-set-consistency) |
| Docs | M6 | Rewrite the documentation from the current code with mdBook as its main home | Milestone | In progress | - | D14, D16, D18 | The mdBook book under `docs/` is written anew from the current code, builds, and deploys from `master`; every retained document outside it agrees with it; [detail](#m6---documentation-rewrite-from-the-current-code) |
| Code | M7 | Unify `IOCSH_TOP` as the installed commonIocsh iocsh directory | Milestone | Not started | Yes | D17 | Every fragment, test, and example resolves `$(IOCSH_TOP)/<fragment>.iocsh`, and the commonIocsh suites pass; [detail](#m7---iocsh_top-unification) |
| Code | M8 | Remove the unused site-template files | Milestone | Not started | Yes | D17 | The unused ChannelFinder and systemd templates are gone from `site-template/` and nothing references them; [detail](#m8---unused-site-template-removal) |
| Code | M9 | Fix the build-system and script defects found by the code inventory | Milestone | Not started | Yes | D17, D19 | Each defect listed in the detail is fixed or recorded as a Keep, and every OS workflow passes; [detail](#m9---build-system-and-script-defects) |

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
| D19 | On Ubuntu 26, `make conf.<module>` rewrites the module `CONFIG_SITE.local` and drops the `-std=gnu17` line that only `conf.modules.c17` appends. M9 moves the append into the configuration of each of the ten modules, still only when `MODS_C17_BRIDGE` is set (the `conf.<module>` rule of the nine `custom` modules, `iocStats_CONF_SITE_LINES` for the `auto` module iocStats), and removes `conf.modules.c17`. Until then the book tells Ubuntu 26 readers to run `make conf` (make-targets reference) or to append the flag by hand (fix verification procedure), and M9 removes both notes. | 2026-09-27 |

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
Status: In progress

##### Summary

The repository documentation reached its present form by revising legacy documents across many releases. Rewrite it from scratch on `master`, deriving every statement from the current code, with the mdBook book (`docs/book.toml`, `docs/src/`, deployed by `.github/workflows/docs.yml`) as the main home.

##### Scope

- Write the mdBook book anew from the current code: the top-level `Makefile`, `configure/`, `configure_user/`, `tools/`, `scripts/`, `patch/`, `site-template/`, `commonIocsh/`, `examples/`, `.github/workflows/`, and the installed tree they produce.
- Carry content from the existing documents into the new structure only where the structure needs it, and only after checking it against the current code (D16). The existing documents do not set the structure.
- Derive the book's chapter structure from the code, not from the current `docs/src/SUMMARY.md`.
- Decide, for every document outside the book (`README.md`, `docs/procedures/`, `docs/design/`, `docs/archive/`), whether it is replaced by a pointer to the book, rewritten to agree with it, or kept unchanged, and apply that decision.

Out of scope: any code change; `docs/milestone-84ee626.md` and `docs/CLOSED_DOORS.md`; the module source-URL change of Backlog M2 (#75) and the book update it brings (D15).

##### Completion Criteria

- Every statement in the new book matches the current code, and every command the book shows runs as shown on a repository checkout.
- `mdbook build docs` succeeds, and Deploy Docs publishes the new book from `master`.
- Every document outside the book either points to the book or agrees with it, per the recorded decision for that document.

##### Dependencies And Decisions

- D14 sets the direction and places the work on `master`; D16 refines it with the full code source set and the rule for carrying existing content.
- D15 orders this work before Backlog M2 (#75); M2 then updates the book where the module source-URL mechanism changes.
- D18: the book describes the current `IOCSH_TOP` convention; M7 updates the book later, so M6 does not wait for M7.
- Work ordering: chapter writing (Implementation Plan step 3) follows the technical-writing skill that dev-env authors and owns; steps 1 and 2 do not depend on it.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-26; the D16 revision
Implementation Authorization: 2026-09-26; the D16 revision. Git and GitHub mutations require their own authorization.
Superseded Plan Artifacts: the plan accepted and authorized on 2026-09-26 before D16; never committed, and D16 records what changed

1. Inventory the code surfaces the book must describe: make targets, configuration files and their variables, the module set and its dependencies, the install layout, the audit gates, the `commonIocsh` fragments and their example IOC, the user and site templates, and the CI workflows. Record the result in `docs/design/m6-code-inventory.md`.
2. Propose the chapter structure and the decision for every document outside the book; obtain owner acceptance.
3. Write each chapter from the code under the dev-env technical-writing skill, carrying in existing-document content only where the chapter needs it and the code confirms it (D16), and replace the existing `docs/src/` pages.
4. Apply the decisions for the documents outside the book.
5. Run T1-T3.

Step 2 result, accepted 2026-09-26:

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
  - `docs/procedures/` module-bump, upstream-fix-carry, upstream-fix-verification, and commonIocsh-verification procedures: rewritten as book procedure pages, then removed.
  - `docs/procedures/measComp-tc32-fix-20260912-215519.md`: moved to `docs/archive/`.
  - `tools/README.md`, `scripts/README.md`, `patch/README.md`, `examples/commonIocsh/README.md`, `examples/commonIocsh/tests/README.md`: reduced to a pointer to the matching book page.
  - `docs/README.md`: rewritten as a guide to the `docs/` directory.
  - `docs/archive/` and `docs/design/makeRPath-perl-port/`: kept unchanged.
  - `docs/design/m6-code-inventory.md`: removed when M6 completes.
  - `ChangeLog.md`, `.github/ISSUE_TEMPLATE/`: kept unchanged.

Step 3 result: the 25 pages of the accepted structure replace the earlier `docs/src/` pages in 1916c08. The second-person pass converged on 2026-09-28 with no finding above the severity floor.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | Run `mdbook build docs` | Repository checkout with the mdBook version of the Deploy Docs container image `jeonghanlee/mdbook` (`docker run --rm jeonghanlee/mdbook mdbook --version`) | The build succeeds and `docs/src/` is unchanged by it |
| T2 | Code fidelity | For each page, check every statement against the code it describes and run every command the page shows | Repository checkout | Every statement matches the code; every shown command runs as shown |
| T3 | Publish | Push the rewrite to `master` and read the Deploy Docs run and the published site | GitHub Actions on `master`; GitHub Pages | Deploy Docs succeeds and the site serves the new book |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-09-28T03:04:57Z | Deploy Docs `build` job in the `jeonghanlee/mdbook` container on 1916c08 | Pass | Run 36372234041: `mdbook build docs` succeeded and the `docs/src` change check passed; recheck with `gh run view 36372234041` |
| T2 | 2026-09-28 | A clone of `master` at 1916c08 built on a Debian 13 host by replaying the tutorial, and copies of it | Pass, except one statement not checkable on this host | Every page command ran as shown; the statement mismatches it found are corrected in 9cf7108, whose load-fragment build step was rerun. The IOC checks used soft IOCs, a local `iocLogServer`, and `socat` ptys instead of site hardware. `update-release.bash update`, the writing `prep-vendors.bash` commands, `build_epics.bash`, `install_apps.bash`, and `make user.conf` were checked by reading the code. Not checked: installed-tree.md, that GCC 8.5 on Rocky Linux 8 writes `RPATH` without `--enable-new-dtags`; recheck by building on Rocky Linux 8 without the option and reading `readelf -d` |
| T3 | 2026-09-28T03:04:57Z | GitHub Actions on `master` at 1916c08; GitHub Pages | Pass | Run 36372234041 built and deployed; https://jeonghanlee.github.io/EPICS-env/ serves the new introduction, tutorial, make-targets, and glossary pages (HTTP 200), and the removed `architecture.html` returns 404 |

##### Closure Evidence

- None.

#### M7 - IOCSH_TOP Unification

Origin: 84ee626 / M7
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

`IOCSH_TOP` names two different directories. The linStat fragment and the commonIocsh test suite treat it as the `commonIocsh` top and append `/iocsh/` (`commonIocsh/iocsh/linStat.iocsh:16-19`, `examples/commonIocsh/tests/verify_*.sh`), while the example IOC and its caPutLog tests treat it as the `iocsh` directory itself (`examples/commonIocsh/iocBoot/caPutLog.cmd:5`, `examples/commonIocsh/tests/verify_caputlog.sh:77`, `examples/commonIocsh/verify_caputlog.py`). `configure/RULES_INSTALL:10-11` names the installed `modules/commonIocsh/iocsh` directory as the location an IOC reaches through `IOCSH_TOP`. D17 makes that the only meaning.

##### Scope

- `commonIocsh/iocsh/linStat.iocsh`: load the linStat sub-fragments as `$(IOCSH_TOP)/<fragment>.iocsh`.
- `examples/commonIocsh/tests/`: set `IOCSH_TOP` to the `iocsh` directory in `common.sh`, drop the `/iocsh/` path component from every `iocshLoad` in the `verify_*.sh` scripts and the serial configuration lines they write, and pass `IOCSH_TOP_DIR` unchanged in `verify_caputlog.sh`.
- The mdBook book: every page that describes `IOCSH_TOP` or loads a fragment through it (D18).

Out of scope: other fragment and test defects (M9).

##### Completion Criteria

- `git grep -n 'IOCSH_TOP)/iocsh/'` prints nothing outside `docs/`, and the book describes `IOCSH_TOP` as the installed `commonIocsh/iocsh` directory.
- `examples/commonIocsh/tests/run_all.sh` reports OVERALL PASS and `examples/commonIocsh/verify_caputlog.py` exits 0, both against an installed tree.

##### Dependencies And Decisions

- D17 sets the meaning; D18 adds the book update and removes the order before M6.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Change `linStat.iocsh` lines 16-19 to `$(IOCSH_TOP)/<fragment>.iocsh`.
2. Change `common.sh` so `IOCSH_TOP_DIR` is the `iocsh` directory, and remove the `/iocsh/` component from every test that loads a fragment.
3. Update the mdBook book pages that describe `IOCSH_TOP` (D18).
4. Run T1-T3.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | Run `git grep -n 'IOCSH_TOP)/iocsh/' -- ':!docs'` | Repository checkout | No output |
| T2 | Fragment suite | Install the changed fragments with `make install`, then run `examples/commonIocsh/tests/run_all.sh` with `DIST_TOP=<tree>` and `COMMONIOCSH=<tree>/modules/commonIocsh`, where `<tree>` is the installed `INSTALL_LOCATION_EPICS`; the suite reads fragments from `COMMONIOCSH`, not from `DIST_TOP` | Host with the installed tree and the tc32sim IOC the suite uses | OVERALL PASS |
| T3 | Example IOC | Write `examples/commonIocsh/configure/RELEASE.local` with `EPICS_BASE=<tree>/base` and `CAPUTLOG=<tree>/modules/caPutLog`, build the example IOC with `make -C examples/commonIocsh`, then run `examples/commonIocsh/verify_caputlog.py --base <tree>/base --iocsh-top <tree>/modules/commonIocsh/iocsh --output <new_directory>` | Same host | Exit 0, all six cases pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |
| T2 | Not run | Host with the installed tree and tc32sim | Pending | none |
| T3 | Not run | Host with the installed tree and tc32sim | Pending | none |

##### Closure Evidence

- None.

#### M8 - Unused Site-Template Removal

Origin: 84ee626 / M8
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

`site-template/` tracks four files that no rule, script, or workflow renders or installs: `application.properties`, `application.properties.in`, `cf.service.in`, and `systemd.service.in`. The two `application.properties` files carry `server.ssl.key-store-password=password` and third-party LDAP URLs. The only generated content in the directory is `site-template/.versions`, written and installed by `src_version` (`configure/RULES_INSTALL:29-32`).

##### Scope

- Remove the unused files from `site-template/` per the decision below, keeping the directory and the `src_version` behavior.

Out of scope: rewriting git history to purge earlier revisions of these files; that is a force-push and stays owner-run.

##### Completion Criteria

- The removed files are absent and no file outside `docs/` names them.
- `make install` still writes and installs `.versions`, shown by a passing OS workflow run.

##### Dependencies And Decisions

- D17 places the work on `master`.
- Open decision: remove only the two `application.properties` files, or all four unused templates.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Record the owner decision on which files to remove.
2. Remove those files.
3. Run T1 and T2.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | `git grep -n` for each removed file name outside `docs/` | Repository checkout | No output |
| T2 | Install | Push to `master` and read the OS workflow runs | GitHub Actions on `master` | Every OS workflow that runs passes, including `make install` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |
| T2 | Not run | GitHub Actions on `master` | Pending | none |

##### Closure Evidence

- None.

#### M9 - Build-System And Script Defects

Origin: 84ee626 / M9
Identity History: none
GitHub Issue: #80, https://github.com/jeonghanlee/EPICS-env/issues/80
Status: Not started

##### Summary

The M6 code inventory and the chapter writing under M6 step 3 found defects in the build system, scripts, fragments, and tests that are outside the documentation work. D17 assigns them here.

##### Scope

- Declared module dependencies that disagree with what `conf.<module>` writes: `motorMotorSim_DEPS` lists autosave and iocStats but `conf.motorMotorSim` writes only MOTOR and ASYN; `QPC_DEPS` lists asyn but `conf.QPC` writes no `RELEASE.local`; `motor_DEPS` omits autosave.
- CI coverage: the Rocky 10, Ubuntu 24.04, and Ubuntu 26.04 workflows never run `check.module-deps`; Rocky 10 builds the vendor libraries with `conf.rocky8`.
- Make-time side effects: every make run, including `print-%`, runs `mkdir -p $(INSTALL_LOCATION)` (`configure/CONFIG_SRC:46`) and can regenerate `MODULESGEN.mk`.
- Scripts: `scripts/selectEpicsEnv.bash` builds a path that does not match the install layout; `scripts/build_modules_libera.bash` requests `build.sequencer-2-2`; `tools/prep-vendors.bash` tests the unassigned `EPICS_MODS_PATH` and `SRC_VER`, writes a site NTP host, and overwrites `configure/CONFIG_SITE.local`; `tools/prep-vendors.bash` also exits 1 for `help` and applies `conf.rocky8` to every Red Hat-family host; `tools/pvs_gets.bash` prints an invalid `printf "%\n"` format and exits 0 when `caget` or `pvget` is missing; `tools/update-release.bash` exits 1 for `help` and usage errors, the code `check` uses for an incomplete survey; `tools/gen_dep_graph.bash` loops forever when `-o` or `-f` has no argument and exits 1 for `-h`; `tools/pv_snapshot.bash` exits 1 without a message when `-l`, `-o`, `-w`, or `-t` is the last argument, because `shift 2` fails, while its usage text documents exit 2 for usage errors (`tools/pv_snapshot.bash:84-86,152`); `scripts/setEpicsEnv.bash` reads `$1` both as an architecture override and as the `disable` switch.
- Environment scripts: `scripts/setEpicsEnv.bash` aborts under `set -u` (unguarded `$1`, `EPICS_BASE`, `LD_LIBRARY_PATH`), and its `drop_from_path` removes the drop path as an unanchored substring, corrupting `PATH` entries that contain it (`scripts/setEpicsEnv.bash:48-51`). `scripts/resetEpicsEnv.bash` leaves `EPICS_PATH` exported, aborts under `set -u` at `EPICS_EXTENSIONS`, shares the `drop_from_path` bug, names itself `setEpicsEnv.bash`, and is not installed with `setEpicsEnv.bash` (`configure/RULES_BASE:103`).
- C17 bridge (D19): on Ubuntu 26, `make conf.<module>` drops `-std=gnu17` from the module `CONFIG_SITE.local` (`configure/RULES_MODS_CONFIG:33-38`); each of the ten modules appends the line itself when `MODS_C17_BRIDGE` is set, the nine `custom` modules in their `conf.<module>` rules and the `auto` module iocStats through `iocStats_CONF_SITE_LINES`, and `conf.modules.c17` is removed.
- Verification gate: `tools/check_deps.bash:98` globs `modules/*/bin/linux-x86_64`, which matches each versioned module directory and its unversioned link, so `check.deps` scans and counts every module executable twice; it exits 0 when `INSTALL_LOCATION_EPICS` is empty or missing, passing after scanning zero files.
- Clean and uninstall: `uninstall.std` and `distclean.std` fail because `std-src/Makefile` always recurses into `iocs/stdTestIOC`, whose `EPICS_BASE` resolves to an upstream path, so `uninstall.modules` and `clean.modules` stop at std. `README.md:103-108` documents a per-module `make clean.<module>` target that has no rule; the per-module target is `distclean.<module>`.
- Patch carry: after a partial `make patch`, `make patch.revert` stops at the first patch that was never applied, because `patch -R` exits 1 there (`configure/RULES_FUNC:39,67`). `configure/RULES_PATCH:81-86,101-105` justifies the `feed-core-libonly` and `QPC-dataonly` patches as preventing strict `check.module-deps` failures, but the strict audit passes for both modules with the patches reverted.
- Module configuration: `configure/MODULESGEN.mk` depends only on `configure/RELEASE` and `configure/CONFIG_SITE` (`configure/CONFIG_MODS:7`), so a pin in `configure/RELEASE.local` leaves `INSTALL_LOCATION_<MODULE>` at the pinned-over version until the file is removed. `MODS_GEN_STALE_HINT` (`configure/CONFIG_MODS_DEPS:112-117`) tells the user to remove `MODULESGEN.mk` even when the cause is a missing `<module>_CONF_TYPE`. `MODS_ZERO_CUSTOM_VARS` (`configure/RULES_MODS_CONFIG:46`), the base-only list, holds `conf.QPC`, whose `QPC_DEPS` lists asyn, and `conf.sscan`, which writes a `SNCSEQ` dependency. `configure/CONFIG_BASE:23` sets `LINKER_ORIGIN_ROOT`, which no rule reads.
- Installed tree: installed `modules/<module>/configure/RELEASE` files are upstream copies that name foreign `EPICS_BASE` paths, so a downstream IOC fails `checkRelease` unless it sets `CHECK_RELEASE=NO`. Installed text files (pkg-config files, caRepeater service scripts, `base/configure/CONFIG_SITE.local`, module `configure/RELEASE.local`, `libuldaq.la`) embed the absolute install path, so a moved tree leaves them pointing at the old location.
- Common iocsh fragments: `commonIocsh/iocsh/iocLog.iocsh:13` sets `iocLogDisable` with `epicsEnvSet`, but `iocLogInit` reads only the C variable, so `LOGDISABLE=1` does not disable IOC logging. `autosave.iocsh:24-25` uses the iocsh `system` command, which needs Base `system.dbd`, and its header does not state that. `iocStatsAdmin.iocsh` fails to load `iocAdminSoft.db` when `IOC` exceeds 21 characters, because `$(IOC):ALLOW_POSIX_THREAD_PRIORITY_SCHEDULING` exceeds 60 characters, and its comment blames the DESC fields. With the same `IOC`, `iocAdminSoft.db` shares 75 record names with `linStatHost.db` (8) and `linStatProc.db` (67), and loading them together fails on type-mismatched duplicates.
- Tests: `examples/commonIocsh/tests/common.sh` defaults to absolute paths under one user's home. `examples/commonIocsh/tests/verify_serial.sh:57-61` sets `BITS=7` and `PARITY=odd` on socat ptys, which force CS8 without parity, and checks only the echoed baud command, so bits and parity are never verified.
- Hygiene: `.PHONY` names with no rule, unused variables and rules, stale comments, inconsistent clean-target names, inactive patch files, the stale top-level `RELEASE.local` and `CONFIG_SITE.local`.

Out of scope: the `IOCSH_TOP` meaning (M7) and the unused `site-template` files (M8).

##### Completion Criteria

- Each Scope item is fixed, or recorded in `docs/CLOSED_DOORS.md` as a Keep with its premise.
- Every OS workflow passes on `master` after the changes.
- A single `make conf.<module>` on Ubuntu 26 keeps `-std=gnu17` in that module's `CONFIG_SITE.local`, and the book carries neither Ubuntu 26 note (D19).

##### Dependencies And Decisions

- D17 places the work on `master`.
- D19 sets the C17 bridge fix and its book update.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Group the Scope items into independent changes and obtain owner direction on each item's fate (fix or Keep).
2. Implement each group as its own commit.
3. Extend the Test Plan with a check per group, then run it.
4. Remove the Ubuntu 26 notes from `docs/src/reference/make-targets.md` and step 2 of `docs/src/procedures/verify-fix-against-installed-tree.md` when the C17 bridge fix lands (D19).

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Integration | Push the changes to `master` and read the OS workflow runs | GitHub Actions on `master` | Every OS workflow passes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | GitHub Actions on `master` | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Fix build, script, and fragment defects
Labels: bug
GitHub Milestone: Backlog
Observed State: open (2026-09-28T02:43:30Z, `gh issue view 80`)
Observed Labels: bug
Observed Milestone: Backlog

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m1---epicspath-normalizerelpath) |
| Build | M2 | Teach the module generator the correct per-module source-base URLs | Milestone | Not started | No | M6, D15 | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m2---generator-src-url-overrides) |
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
