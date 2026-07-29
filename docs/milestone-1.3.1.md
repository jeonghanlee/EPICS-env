# Work Register

Release line: 1.3.1
Canonical path: `docs/milestone-1.3.1.md`
Canonical branch or ref: `release-1.3.0`
Git upstream: `origin/release-1.3.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.3.1, number 5

Next session entry point: after the 1.3.0 release, review and accept the M29
implementation plan.

## Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Documentation | M29 | Rewrite the documentation set against the shipped 1.3.0 environment | Milestone | Not started | No | 1.3.0 / M7, D1 | Every retained page is verified against the released 1.3.0 environment or retired by owner decision; [detail](#m29---documentation-rewrite) |

## Decisions

| ID | Decision | Source |
| --- | --- | --- |
| D1 | Transfer M29 and GitHub #56 from 1.3.0 to the 1.3.1 release line. | Owner direction in conversation, 2026-07-28 |

## Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
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

#### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Inventory every book page, archived note, version, installation path,
   module version, and executable command.
2. Verify retained instructions against a real released 1.3.0 installation.
3. Present obsolete archived notes for owner rewrite-or-retire decisions.
4. Rewrite the retained pages and apply the accepted lint and deployment
   workflow changes.
5. Build the book, run the offline link check and Markdown lint, then verify
   the published site.

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
Last Compared: 2026-07-28 23:30:16 -0700; remote issue updated
2026-07-29T06:29:30Z
