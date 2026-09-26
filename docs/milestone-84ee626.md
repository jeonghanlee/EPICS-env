# Work Register

Release line: master
Milestone index: 84ee626
Canonical path: `docs/milestone-84ee626.md`
Canonical branch or ref: `master`
Git upstream: `origin/master`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone Backlog, number 3

Next session entry point: EPICS-env 1.4.0 is released and closed (RELEASED 2026-09-24; closure commit `84ee626`). M4 (CI workflow triggers and OS set, #78), worked on `master` by D10, is Complete on 2026-09-26 and #78 is closed. The Milestone section holds no open work; the Backlog holds the other surviving work. When the first release work is assigned, choose the next release version under D9 (1.4.1 for fixes only, 1.5.0 for module-set or feature changes), create `release-X.Y.Z` from `master`, reset this register into `docs/milestone-X.Y.Z.md`, and set `ENV_RELEASE_VERS` to X.Y.Z in its own commit. References of the form `1.4.0 M<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CI | M4 | Align the CI workflow triggers and OS set with the shipped targets | Milestone | Complete | - | | Every OS workflow runs when its own file changes and ignores the same sibling set; the CI OS set matches the shipped gz OS set or the difference is a recorded decision; [detail](#m4---ci-trigger-and-os-set-consistency) |

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

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M1 | Build EPICS::Path Normalize/RelPath primitives for makeRPath | Milestone | Not started | No | | `makeRPath` consumes a shared lexical no-stat path primitive instead of a bare-`python` dependency, and the straight-port regression does not recur; [detail](#m1---epicspath-normalizerelpath) |
| Build | M2 | Teach the module generator the correct per-module source-base URLs | Milestone | Not started | No | | The generated `MODULESGEN.mk` carries the correct base URL for all twelve non-`epics-modules` modules with no post-include override, effective values unchanged; [detail](#m2---generator-src-url-overrides) |
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

Out of scope: changing any effective URL (all twelve are already correct); the `INSTALL_LOCATION_*` and `SRC_PATH_*` generator output and the `seq` and `recsync-src/client` special cases; and `configure/RELEASE` edits unless the chosen approach is Option A.

##### Completion Criteria

- The current effective values are captured as a baseline (`make print-SRC_GITURL_<M>` for the twelve modules on the unmodified tree).
- The generated `configure/MODULESGEN.mk` carries the correct base URL for all twelve modules, with no `SRC_GITURL_*` re-definition left in `configure/CONFIG_MODS`.
- The post-change effective `make print-SRC_GITURL_*` equals the captured baseline for every module — not merely equal to the regenerated file, which is circular once the override is gone.
- A clone of the twelve modules resolves and the build is unchanged.
- The procedure for declaring a new non-`epics-modules` module's base is documented where the chosen approach places it.

##### Dependencies And Decisions

- Parked to the Backlog per D1; the design decision below is deferred until it is revisited.
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
Last Compared: 2026-09-21

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
