# Work Register

Release line: 1.6.0
Milestone index: 1.6.0
Canonical path: `docs/milestone-1.6.0.md`
Canonical branch or ref: none; the future release branch has not been opened
Git upstream: none
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone Backlog, number 3, https://github.com/jeonghanlee/EPICS-env/milestone/3. Issue #101 is open and assigned to Backlog, observed at 2026-10-08T00:00:55Z through `gh issue view 101 --repo jeonghanlee/EPICS-env` with JSON output; remote updatedAt is 2026-10-08T00:00:30Z.

Next session entry point: Review the M1 migration plan in `docs/milestone-1.6.0.md` before implementation. Tracking issue #101 is published in GitHub Backlog; the planned release remains 1.6.0 and the exact source selection and implementation authority remain separate.

This document records the assigned reccaster migration only. It does not open a release branch, accept an implementation plan, authorize source changes, or define the complete 1.6.0 release cycle.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Modules | M1 | Migrate the IOC client from recsync to reccaster | Milestone | Not started | Yes | D1, D2 | Selected reccaster source builds and installs; loader, database startup, and record publication pass; [detail](#m1---reccaster-migration) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Assign the recsync-to-reccaster IOC client migration to 1.6.0 and prepare one tracking issue. Keep the existing recsync source and pin in 1.5.0. The exact future reccaster release selection, plan acceptance, and implementation authorization remain separate. | 2026-10-07 |
| D2 | Use the existing GitHub Backlog milestone for the tracking issue. Do not create a GitHub 1.6.0 milestone; retain 1.6.0 as the planned release and in the issue title. | 2026-10-07 |

### Milestone Details

#### M1 - Reccaster Migration

Origin: 1.6.0 / M1
Identity History: none
GitHub Issue: #101, https://github.com/jeonghanlee/EPICS-env/issues/101
Status: Not started

##### Summary

Acquire the IOC client from the standalone `ChannelFinder/reccaster` repository instead of the `client/` subtree of `ChannelFinder/recsync`. Preserve the installed reccaster library, DBD, database, and IOC startup behavior while aligning acquisition, configuration, build paths, and source metadata with the separate repository.

##### Scope

EPICS-env source identity and version settings in `configure/RELEASE`, source-path generation in `configure/CONFIG_MODS`, custom configuration targets in `configure/RULES_MODS_CONFIG`, installed source and loader metadata, `commonIocsh/iocsh/reccaster.iocsh`, and the affected module/build documentation. Reassess enabled consumers across the environment, support, and available site module sources before selecting the exact release.

Out of scope: changing the 1.5.0 recsync pin, implementing or replacing the RecCeiver server, direct edits to support or site repositories, unrelated module updates, and opening or publishing the complete 1.6.0 release cycle.

##### Completion Criteria

- Fresh acquisition resolves to the selected published reccaster release and records the exact source commit.
- Configuration and build use the module repository root; no active recipe relies on `recsync-src/client` or writes configuration under a missing `client/` directory.
- Generated install paths and source metadata agree with the selected source and version.
- The installed library `reccaster`, `reccaster.dbd`, and `db/reccaster.db` remain usable by the installed loader and existing startup fragments.
- The module and every enabled consumer build, relink, and start on every supported CI operating system.
- A real IOC publishes its record names and metadata to a real RecCeiver through the RecSync protocol, without substituting the client, loader, or receiver path.
- Documentation describes acquisition, installation, and IOC startup from the standalone repository.

##### Dependencies And Decisions

D1 assigns the work to 1.6.0. D2 places its GitHub issue in the existing Backlog milestone without creating another remote milestone. The 1.5.0 survey's HOLD decision is recorded separately in `docs/milestone-1.5.0.md`; it is not a second implementation work item. There is no selected future source pin or accepted implementation plan yet.

Source comparison observed on 2026-10-07: the old client at `ChannelFinder/recsync` commit 9834b94edc63eece42712b8355a4703d4286dd8f was compared with reccaster release 1.9.7 at bebf91f54faf93a59eb4538d3594a687a8823963. The old `client/` tree was read with `git ls-tree` and `git show`; the released tree and blobs were read through GitHub's Git database API, and each retrieved blob was checked against its Git object identity. After removing the old `client/` prefix, 27 regular files were identical, 11 common files differed, four Docker-related files were absent, and seven metadata/CI/documentation files were added. Gitlinks are excluded from those file counts.

The changed C/C++ files contain variable renaming, separated declarations and assignments, and return-statement formatting. Public headers, `reccaster.db`, `reccaster.dbd`, and library Makefiles are identical. `configure/RELEASE` and `configure/CONFIG_SITE` change parent override paths from two directory levels to one. The existing EPICS-env source-path substitution and `conf.recsync` target still assume `client/`. This source comparison does not establish build or runtime compatibility; repeat release selection and consumer assessment when implementing.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Follow `docs/procedures/module-bump-procedure.md`: confirm the current pins and overrides, compare the proposed published reccaster release, survey actual consumers, and obtain the exact source selection and plan acceptance.
2. Update acquisition settings and remove the `client/` path assumptions from source generation and the custom configuration targets. Keep installed library, DBD, database, and startup contracts consistent with the existing consumers.
3. Regenerate configuration and source metadata, acquire the selected source through the shipped initialization path, and execute the module build and installation path.
4. Rebuild enabled consumers, verify the installed loader and startup fragment, and check actual record publication with a real RecCeiver on supported platforms.
5. Update the affected documentation and record the exact source, implementation commit, and observed verification results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Source and configuration | Run shipped initialization/configuration targets and inspect source HEAD, generated paths, and installed metadata | Isolated checkout with the selected real upstream source | Exact selected source; all paths use the standalone repository root |
| T2 | Build and install | Execute the shipped module and enabled-consumer build/install paths, dependency checks, and environment checks | Every supported CI operating system | Successful coherent builds, links, installation, and source identity |
| T3 | IOC startup | Start an IOC through the installed loader and existing reccaster startup fragment | Actual installed candidate environment | Library, DBD registration, and database load succeed |
| T4 | Record publication | Run a real IOC and real RecCeiver and inspect received record names and metadata | Actual client/server processes using RecSync networking | Published records and metadata match the IOC's loaded database |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Selected real source through shipped initialization/configuration | Pending | none |
| T2 | Not run | Supported CI platforms and actual install | Pending | none |
| T3 | Not run | Installed candidate IOC | Pending | none |
| T4 | Not run | Real IOC and RecCeiver | Pending | none |

##### Closure Evidence

None. Source inspection is recorded above; migration implementation and real build/runtime verification have not run.

##### GitHub Projection

Title: Migrate IOC record publishing to reccaster for 1.6.0
Labels: enhancement
Assignee: jeonghanlee
GitHub Milestone: Backlog, number 3, https://github.com/jeonghanlee/EPICS-env/milestone/3
Observed State: open
Observed Labels: enhancement
Observed Assignee: jeonghanlee
Observed Milestone: Backlog, number 3
Last Compared: 2026-10-08T00:00:55Z through gh issue view 101; remote updatedAt 2026-10-08T00:00:30Z. Title, full body, open state, label, assignee, and milestone match the prepared content.
Prepared Body: `work/issue-reccaster.md`
Publication: Created under delegated Issue scope and read back as #101, https://github.com/jeonghanlee/EPICS-env/issues/101. The full body matches the prepared file apart from trailing newline normalization. No remote milestone was created. Issue publication does not establish migration implementation or verification.

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |

### Backlog Details

None.
