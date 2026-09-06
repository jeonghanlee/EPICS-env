# Work Register

Release line: 1.3.1
Canonical path: `docs/milestone-1.3.1.md`
Canonical branch or ref: `release-1.3.0`
Git upstream: `origin/release-1.3.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.3.1, number 5

Next session entry point: after the 1.3.0 release, review and order the M29
implementation plan.

## Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Documentation | M29 | Rewrite the documentation set against the shipped 1.3.0 environment | Milestone | Not started | No | 1.3.0 / M7, D1 | Every retained page is verified against the released 1.3.0 environment or retired by owner decision; [detail](#m29---documentation-rewrite) |
| Documentation | M32 | Make the mdBook build and link check reproducible outside CI | Milestone | Not started | No | 1.3.0 / M7, D4 | A contributor can install the pinned mdBook and lychee and reproduce the CI documentation checks from a written procedure, and the pinned versions have one authority; [detail](#m32---reproducible-mdbook-toolchain) |

## Backlog

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |

No unassigned 1.3.1 work at present. The alliocs consumer items (Makefile entry point, exit-status propagation) relocated to 1.3.0 Carry-forward on 2026-09-05; see that register's Assignment History.

## Decisions

| ID | Decision | Source |
| --- | --- | --- |
| D1 | Transfer M29 and GitHub #56 from 1.3.0 to the 1.3.1 release line. | Owner direction in conversation, 2026-07-28 |
| D2 | Transfer M23 and GitHub #51 from 1.3.0 to the 1.3.1 release line. | Owner direction in conversation, 2026-07-28 |
| D3 | Carry the 2026-08-07 document-review inventory into M29 as one body of evidence for its inventory step, not as separate work rows. | Owner direction in conversation, 2026-08-07 |
| D4 | Track the mdBook build and link-check toolchain as its own work item, separate from the M29 content rewrite. | Owner direction in conversation, 2026-08-08 |
| D5 | Return M23 and GitHub #51 to the 1.3.0 release line so the measComp/uldaq consumer-link fix ships in 1.3.0; M23 precedes the M7 release gate. This reverses D2. | Owner direction in conversation, 2026-08-17 |

## Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| M23 CI vendor relocation | 1.3.0, `docs/milestone-1.3.0.md`, `release-1.3.0` | 1.3.1, `docs/milestone-1.3.1.md`, `release-1.3.0` | `e9fb5c1` | `e9fb5c1` |
| M23 CI vendor relocation | 1.3.1, `docs/milestone-1.3.1.md`, `release-1.3.0` | 1.3.0, `docs/milestone-1.3.0.md`, `release-1.3.0` | this synchronization commit | this synchronization commit |
| M29 Documentation rewrite | 1.3.0, `docs/milestone-1.3.0.md`, `release-1.3.0` | 1.3.1, `docs/milestone-1.3.1.md`, `release-1.3.0` | this synchronization commit | this synchronization commit |

## Milestone Details

### M29 - Documentation Rewrite

Origin: M29, `docs/milestone.md`, commit `3ad6a1d`
Identity History: M29 transferred unchanged from the 1.3.0 release line to
the 1.3.1 release line on 2026-07-28.
GitHub Issue: #56, https://github.com/jeonghanlee/EPICS-env/issues/56
Status: Not started

#### Summary

Rewrite the user documentation against the released 1.3.0 environment.
M27 established the mdBook structure and completed a bounded modernization
pass, but the retained guidance still describes earlier environments.

#### Scope

- Verify the documented EPICS Base 7.0.10 behavior with all fifteen carried
  Base fixes.
- Verify the nine updated module versions, with motor retained at `285f44d`.
- Verify pvxs 1.5.2 with its twelve carried fixes.
- Document feed-core in place of the retired site-layer feed module.
- Verify the strict `check_deps` gate and module dependency audit.
- Verify the 1.3.0 installation path and current `setEpicsEnv.bash` behavior.
- Rewrite or retire each archived platform note by owner decision.
- Resolve the Markdown lint configuration and remove the obsolete
  `release-1.3.0` documentation deployment trigger.

Out of scope: cycle records, build-system changes, and product code changes.

#### Completion Criteria

- Every retained page is checked against a real released 1.3.0 installation.
- Every obsolete page is retired through a recorded owner decision.
- No stale 1.2.x version or installation path remains in the book sources.
- `mdbook build docs` exits 0 and the offline link check reports zero errors.
- The Archived Notes section is empty or removed.
- The accepted Markdown lint configuration is applied and its workflow passes.

#### Dependencies And Decisions

- 1.3.0 / M7 must publish the released object and production installation.
- D1 assigns this work to the 1.3.1 release line.
- D3 supplies the source-tree half of the inventory step; see Inventory
  Evidence below.

#### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Start the inventory from the collected list under Inventory Evidence, then
   extend it with what only a released installation can show: installed paths,
   runtime behaviour, and any page the source-tree pass did not cover.
2. Verify retained instructions against a real released 1.3.0 installation.
3. Present obsolete archived notes for owner rewrite-or-retire decisions.
4. Rewrite the retained pages and apply the accepted lint and deployment
   workflow changes.
5. Build the book, run the offline link check and Markdown lint, then verify
   the published site.

#### Inventory Evidence

Collected 2026-08-07 on `release-1.3.0` at `13abeda`, by reading every document
in the repository and comparing it against the source tree.

##### What was covered

Twenty-one documents, all read: the eighteen user-facing files plus
`.github/ISSUE_TEMPLATE/bug_report.md`,
`.github/ISSUE_TEMPLATE/feature_request.md`, and `docker/scripts/README.md`.
The first inventory listed eighteen and missed the last three; the count above
is the corrected one.

Eight comparison axes were closed: module set, versions and pins, paths, make
targets, tools and scripts, workflows, cross-references, and issue citations.

##### What this evidence cannot tell you

It compares documents against the **source tree**, never against an installed
release. Every claim about runtime behaviour or an installed path is still open
and belongs to step 2.

Files not read, counted rather than estimated:

- `configure/`, 26 files: one read in full (`RULES_PATCH`); nine read only at
  specific definitions or lines (`CONFIG_MODS`, `CONFIG_MODS_DEPS`,
  `CONFIG_SITE`, `RELEASE`, `RULES_BASE`, `RULES_FUNC`, `RULES_MODS_CONFIG`,
  `RULES_SRC`, `RULES_VARS`); sixteen never opened.
- The bodies of the seven `scripts/` and seven `tools/` files, beyond the
  argument parsing of the four documented tools.
- The contents of all 35 patch files.
- `Makefile`, `configure_user/` (2 files), `site-template/` (4), and
  `docker/Dockerfile`.

The four archive notes were opened only far enough to confirm that nothing
presents them as current guidance. Their internal staleness is untouched by
this pass and remains inside this milestone's scope.

##### Re-check these against the tree before starting

This inventory predates the 1.3.0 release. Three corrections were planned on the
1.3.0 line and will already be in place by the time this milestone runs, so the
files below will not match the state recorded here:

| File | Why it will differ |
| --- | --- |
| `README.md` | The Base Commands entry for `make patch.base` is corrected on the 1.3.0 line, and the release bump changes the `source` example path at line 62 |
| `docs/src/module-management/new-module-example.md` | The 1.3.0 correction rewrites the `MODS_ZERO_VARS` / `MODS_ONE_VARS` instruction at lines 40-46, which overlaps the entry below at line 46 |
| `docs/src/module-management/remove-a-module.md` | The 1.3.0 correction rewrites the `MODS_ZERO_VARS` instruction at line 40; the entry below concerns lines 12, 26, and 34 and is expected to survive |
| `configure/CONFIG_SITE` | `ENV_RELEASE_VERS` moves from 1.2.2 to 1.3.0 at the release gate |

Nothing else in this inventory is scheduled for change before this milestone
starts.

##### Group 1 - resolved by rewriting the page

Ten entries; the first (the classification table) was brought current in 1.3.0,
so nine remain. Each of those is a superseded value, an obsolete example, or a
missing addition. Rewriting the page against the released environment removes
them; none needs a separate decision.

| File | What is stale |
| --- | --- |
| `docs/src/module-management/module-management.md` | RESOLVED in 1.3.0: the classification table was brought current -- `feed-core`, `QPC`, `rgamv2` added to `custom` (now auto 9 / custom 22). Retained here so the 1.3.1 page rewrite need not re-address the table |
| `docs/src/module-management/add-a-module.md:17-18` | The snmp example pins `tags/v1.0.0.2j` / `1.0.0.2j`; `configure/RELEASE:151-152` carries `tags/v1.1.0.4ja` / `1.1.0.4ja` |
| `docs/src/module-management/change-repository-url.md:16-17,28,30` | measComp pinned at `2e779c4` against the current `c38974e`; the diff context shows `SRC_GITURL_SNCSEQ` and `SRC_GITURL_OPCUA` as active, but `configure/CONFIG_MODS:40,43` has both commented out |
| `docs/src/module-management/use-different-module-version.md` | The whole worked example is from the `rocky-8.5 / 7.0.6.1` era with `asyn-4.41`, `seq-2.2.8`, `measComp-tc32`. The procedure holds; every value shown is superseded |
| `docs/src/module-management/new-module-example.md:46,82-87` | The `MODS_ONE_VARS` line omits `conf.measComp`, `conf.motor`, `conf.motorMotorSim`; sample output is from `debian/10/e881cb1`, and one line shows a `scaler` path inside a pmac example |
| `tools/README.md` | Three of seven tools undocumented: `audit_module_deps.bash`, `check_env.bash`, `gen_dep_graph.bash`. The prep-vendors section omits `epics-build`, `check-deps`, `all`, `help`, `OS`. The `check_deps.bash` example still uses `1.1.2/debian-12/7.0.7` with counts 156/62 |
| `docs/src/module-management/module-dependency-audit.md:25-32,292-345,360-363` | A completed implementation described in proposal form — "Proposed Commands", Phase 4A through 4D as future work — although `check.module-deps` has gated `make github.check` since 1.2.1 |
| `docs/README.md` | The layout list claims to cover everything at the `docs/` level but omits `book.toml` |
| `docs/base-carry-1.3.0.md:100` | The naming rule uses a three-N placeholder while the shipped files and the general procedure use four (`pr0817`) |
| `docs/testplan_1.3.0.md:5-8` | Declares itself a living document whose discovered cases land under Added During Cycle; the last entry is M20 (2026-07-18) while the register has since carried M21 through M28 |

##### Group 2 - needs a decision before it can be written

Six entries. Rewriting alone does not settle these; each carries a question that
only the owner can answer, and the question is stated so it can be answered
without re-reading the file.

| File | What is stale | The question |
| --- | --- | --- |
| `scripts/README.md` | The whole file describes `scripts/caget_pvs.bash`, which `9e449d8` moved to `tools/` and `6f6a434` removed. Its successor is `tools/pvs_gets.bash`. The eight scripts that do exist are undocumented, including `setEpicsEnv.bash`, which the top-level README tells every user to source | Document the eight scripts, or retire the file and let `tools/README.md` stand alone? |
| `KnownIssues.md:3-9` | `pyDevSup` listed as a current problem although `configure/RELEASE:177-179` retired it; the `pcas` entry still says a decision is due "during 2024" | Drop the pyDevSup entry or keep it marked retired? And what is the current pcas position, given the 1.3.0 bump review left it on HOLD? |
| `docs/src/module-management/remove-a-module.md:12,26,34` | The guide says to remove the declaration lines; the repository kept them commented out in `configure/RELEASE:177-179`, `configure/CONFIG_MODS:47`, and `configure/CONFIG_MODS_DEPS:25` | Which is the intended practice for retiring a module — delete the lines, or comment them out? The guide and the repository disagree, and only one can be documented |
| `docker/scripts/README.md` | Links an external repository and shows `docker ps` / `docker login`; does not describe `docker_builder.bash` or `docker_env_default.conf`, the two files beside it | Is the docker path still supported? If yes it needs real content; if not, the note and its neighbours retire together |
| `ChangeLog.md:20,26` | Releases 1.1.1, 1.1.2, and 1.2.0 have no entry although their tags exist; line 26 is an empty bullet; `v1.1.0` carries a `v` prefix the later entries drop | Reconstruct the three missing entries from their tags, or state that the ChangeLog begins at 1.2.1? |
| `docs/module-bumps-1.3.0.md:76-77` | Raises "Candidate backlog item: teach the generator the per-module SRC_URL overrides" for the MODULESGEN.mk default-URL observation; no Backlog row exists for it | Open it as a Backlog row, or record it as a closed door? |

##### Group 3 - belongs to the parked makeRPath item

Two entries. These follow the 1.3.0 register's makeRPath carry-forward rows, not
this milestone's schedule. They are recorded here only so the evidence stays in
one place.

| File | What is stale |
| --- | --- |
| `docs/makeRPath-perl-port/issue-makeRPath-pl.md` | Reads as a ready-to-file upstream issue closing with "If the approach looks right I'll open it as a PR", while the 1.3.0 register records that it "proposes the approach #25 rejects". Searching it for `#25`, `EPICS::Path`, `superseded`, `outdated` returns nothing |
| `docs/makeRPath-perl-port/test-plan-makeRPath.md:93,104-107` | Runs from `work/compare_makeRPath.sh` and `work/makeRPath.pl`; the tracked copies are under `docs/makeRPath-perl-port/` and `.gitignore:37` excludes `/work/`. Works only in a tree that still holds untracked copies |

##### Checked and found correct

Listed so this milestone does not pay to re-derive them. A document reaches this
table when a claim it makes was resolved against the code and matched; it
reaches the tables above when a claim did not match.

| Document | Claim checked | How |
| --- | --- | --- |
| `docs/module-bumps-1.3.0.md` | All seventeen bump decisions | Compared each against `configure/RELEASE`: nine adopted pins and eight holds match, including the reverted motor at `285f44d` |
| `docs/base-carry-1.3.0.md` | The fifteen adopted base PRs | Each has a matching `patch/7.0.10-pr*.p0.patch`, and there are exactly fifteen |
| `docs/pvxs-carry-1.3.0.md` | The twelve-entry apply list | Matches the twelve `patch/1.5.2-*.p0.patch` files by sequence number, sha, and slug |
| `docs/upstream-fix-carry-procedure.md` | Naming patterns (350-351), wiring rules (358-359), the `/work/` gitignore claim (11) | Match the shipped patch names, `configure/RULES_FUNC:28,56`, and `.gitignore:37` |
| `tools/README.md` | Documented options of the four covered tools | `pvs_gets.bash` accepts every documented flag; `check_deps.bash` accepts `-v`, `--verbose`, `--report-only`; `update-release.bash` accepts `-v`, `--verbose`, `check`, `update`, `help`; `prep-vendors.bash`'s `all` runs the three steps its help states |
| `docs/testplan_1.3.0.md:47`, `module-dependency-audit.md:335-339` | Which workflows run the dependency gate | `debian12`, `debian13`, `rocky8`, `rocky9` run `make github.check`; `rocky10`, `ubuntu22`, `ubuntu24` run explicit target lists without `check.module-deps` |
| All user-facing documents | Issue citations #18, #20, #21, #22, #24, #25, #36, #44, #45, #46, #50, #52, #53 | Every number resolves and each state matches how the citing document describes it |
| `ChangeLog.md` 1.2.1 | The bundled-libevent path was removed from `setEpicsEnv.bash` and `resetEpicsEnv.bash` | Neither script mentions libevent |
| `docs/ALS-U-EPICS-Environment.md` and its PDF | The export matches its source | Both last changed by the same commit `8226fcc` |
| `docs/src/SUMMARY.md` | Chapter links | Every link resolves to an existing file |
| `docs/src/archive.md` | Archive links and the companion script | All four resolve on `origin/master`; `scripts/build_base_libera.bash` exists |
| `docs/src/module-management/add-a-module.md:64` | `make symlink.snmp` | Real target; the plural `symlinks.snmp` does not exist |
| `docs/src/module-management/module-dependency-audit.md:79-83` | The `print-%` versus `PRINT.%` distinction | Matches `configure/RULES_VARS:39,43`, as corrected by issue #36 |

#### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Documentation and production consistency | Compare every retained version, path, module reference, and command with the real released 1.3.0 installation; build the book; run the offline link check and accepted Markdown lint workflow; inspect the published site | Released 1.3.0 installation, repository book sources, and GitHub Pages | Retained guidance matches the released environment; no stale 1.2.x book reference remains; the book, links, lint, and publication checks pass |

#### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Released 1.3.0 installation, repository book sources, and GitHub Pages | Pending | none |

#### Closure Evidence

- None. Assignment transfer was accepted on 2026-07-28; implementation has
  not started.

#### GitHub Projection

Title: Rewrite the documentation set against the shipped 1.3.0 environment
Labels: documentation
GitHub Milestone: 1.3.1
Observed State: open
Observed Labels: documentation
Observed Milestone: 1.3.1
Last Compared: 2026-07-31 13:37:59 -0700; remote issue updated
2026-07-31T20:37:51Z

### M32 - Reproducible mdBook Toolchain

Origin: 1.3.1 / M32
Identity History: none
GitHub Issue: #59, https://github.com/jeonghanlee/EPICS-env/issues/59
Status: Not started

#### Summary

The documentation site is built and link-checked only inside
`.github/workflows/docs.yml`, which pins `MDBOOK_VERSION: v0.5.4` and
`LYCHEE_VERSION: lychee-v0.24.2` as workflow environment variables and installs
both from release tarballs. Nothing outside that file states which versions the
project uses or how to run the same two checks locally, so a contributor editing
a page cannot reproduce what CI will run.

Observed 2026-08-08 while editing three book pages for 1.3.0 / M30: the host had
mdBook v0.4.48 rather than the pinned v0.5.4, and no lychee at all. The build
passed and the three added cross-references resolved in the rendered output, but
the link check that M27 verification ran over 337 links could not be repeated.

#### Scope

- Give the pinned mdBook and lychee versions one authority that both CI and a
  local run read, instead of two workflow-only variables.
- Write the local procedure: install the pinned versions, build the book, run
  the offline link check with the same arguments CI uses.
- State where that procedure lives so a page editor finds it before submitting.

Out of scope: the content rewrite in M29, the Markdown lint configuration M29
already carries, changing the deploy workflow's triggers, and any change to
`book.toml` beyond what a version authority requires.

#### Completion Criteria

- The pinned mdBook and lychee versions appear in exactly one place, and the
  documentation workflow reads them from there.
- A written procedure reproduces both CI checks locally, and running it on a
  clean checkout produces the same verdicts CI reports.
- The procedure is reachable from the documentation the page editor already
  reads.

#### Dependencies And Decisions

- 1.3.0 / M7 publishes the released object first; this work does not gate the
  release.
- D4 separates this from the M29 content rewrite.

#### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Choose the version authority and repoint `.github/workflows/docs.yml` at it.
2. Write the local build and link-check procedure.
3. Run the procedure on a clean checkout and compare its verdicts with a CI run
   of the same commit.

#### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Reproducibility | Follow the written procedure on a clean checkout, then compare the local build result and link-check output against the CI run of the same commit. | Clean checkout and the documentation workflow | Both report the same verdict, and the local run uses the pinned versions. |
| T2 | Single authority | Change the pinned version in its one place and confirm the workflow and the procedure both follow. | Repository checkout | No second copy of the version needs editing. |

#### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Clean checkout and the documentation workflow | Pending | none |
| T2 | Not run | Repository checkout | Pending | none |

#### Closure Evidence

- None; recorded 2026-08-08 from the M30 editing session and not yet started.

#### GitHub Projection

Title: Make the mdBook build and link check reproducible outside CI
Labels: documentation
GitHub Milestone: 1.3.1
Observed State: open
Observed Labels: documentation
Observed Milestone: 1.3.1
Last Compared: 2026-08-08; created and observed in the same action
