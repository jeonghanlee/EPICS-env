# makeRPath relative-path computation — design analysis and edge catalog

## Purpose

`makeRPath` emits relocatable `$ORIGIN`-relative rpath entries for the build.
Removing its Python dependency requires re-implementing, in Perl, the lexical
path algebra that Python's `os.path` provides as library primitives. This
document records which primitive is missing, the measured edge behavior that
defines the replacement, and the design direction chosen.

## The primitive gap

The tool needs three operations. One has no existing no-stat implementation.

| Operation | core `File::Spec` | `EPICS::Path` | GNU make | Status |
| --- | --- | --- | --- | --- |
| collapse `.`, `//`, trailing slash | `canonpath` | — | `$(abspath)` | available |
| **collapse `..` lexically, no `stat`** | `canonpath` does not | `AbsPath` stats | — | **missing** |
| relativize (abs2rel) | `abs2rel` (needs pre-normalized input) | — | — (no primitive) | partial |
| origin join | string op | — | string op | trivial |

`File::Spec->abs2rel` does not normalize embedded `..`, and `canonpath` does
not collapse `..` either. `Cwd::abs_path` and `EPICS::Path::AbsPath` do collapse
`..` but only by touching the filesystem (`stat`, symlink resolution), which is
unusable for a not-yet-existing `--final` and breaks lexical predictability.

## Edge catalog (measured)

Reference is Python `os.path` (`relpath` / `normpath` / `join`). Parity with
Python is **not** a requirement; these values define where a Perl
implementation must add normalization, and become the specification in their
own terms.

### A. Relativize — `os.path.relpath` vs `File::Spec->abs2rel`

20 `(target, base)` pairs measured; 17 agree, 3 diverge — all from `abs2rel`
not collapsing `..`, plus the empty-string case.

| target | base | `os.path.relpath` | `File::Spec->abs2rel` |
| --- | --- | --- | --- |
| `/build/x/../lib` | `/build` | `lib` | `x/../lib` |
| `/a/../b` | `/b` | `.` | `../a/../b` |
| `` (empty) | `/build` | error | `../<cwd>` |

Agreeing cases (confirm correct behavior): identical → `.`; ancestor → `..`;
child → `lib`; divergent → `../../b/c`; root vs deep → `../..`; prefix-trap
`/root2/lib` vs `/root` → `../root2/lib`; nested `usr/lib` vs `usr/bin` →
`../../lib/...`; trailing-slash irrelevant; case-sensitive (`/Build` ≠ `/build`).

### B. Normalize — `os.path.normpath` vs `File::Spec->canonpath`

| input | `os.path.normpath` | `File::Spec->canonpath` |
| --- | --- | --- |
| `/build/x/../lib` | `/build/lib` | `/build/x/../lib` |
| `/a/b/../../..` | `/` | `/a/b/../../..` |
| `//a` | `//a` | `/a` |
| `''` | `.` | `''` |
| `a/../../b` | `../b` | `a/../../b` |

`canonpath` collapses `.`, `//`, and trailing slash but never `..`. This is the
gap. The earlier hand-rolled `normpath` in `makeRPath.pl` filled it (collapses
`..`); it differs from Python only on POSIX `//a` (collapses to `/a`).

### C. Origin join — `os.path.join(origin, rel)`

| origin | rel | result |
| --- | --- | --- |
| `$ORIGIN` | `.` | `$ORIGIN/.` |
| `$ORIGIN/` | `../lib` | `$ORIGIN/../lib` |
| `` (empty) | `../lib` | `../lib` |
| `$ORIGIN` | `/abs/path` | `/abs/path` (absolute rel replaces origin) |
| `$ORIGIN` | `` (empty) | `$ORIGIN/` |

### D. Edges not covered by the Python suite's 37 cases

- `..` collapsing to an identical path (`/a/../b` vs `/b`) as a relpath input.
- `..` in the base argument (`/x/y/../z`).
- POSIX leading `//a` / `///a`.
- `/..`, `/../..` above the filesystem root; `a/../../b` above a relative root.
- Empty string as an `abs2rel` argument (Python errors; Perl resolves to cwd).

## Design directions

**A — core `File::Spec`, contained in makeRPath.** Keep a local lexical
normalize plus `File::Spec->abs2rel`; smallest blast radius, no shared-module
change. Does not advance the Base path toolkit.

**B — `EPICS::Path` additive (chosen).** Add the missing primitive to the
shared module so both `makeRPath` and future tools reuse it. Larger review
surface; requires the missing no-stat normalize to live in one place.

Direction B is chosen because the goal is improving Base path tooling, and the
no-stat `..`-collapsing normalize must be built regardless of direction.

### Proposed `EPICS::Path` API (additive; `AbsPath` untouched)

- `Normalize($path)` — lexical, no-stat normalization (`.`, `..`, `//`,
  trailing slash).
- `RelPath($target, $base)` — `Normalize` both arguments, then
  `File::Spec->abs2rel`. Sibling to `AbsPath`.

The membership test ("is this path inside the relocatable tree") is `RelPath`
not starting with `..`. With both paths under the same root, the `$ORIGIN`
relative path is `RelPath(target, final)` directly — the root indirection is
needed only for the membership test.

### Specification decision points

- Embedded `..` — must collapse (non-negotiable).
- POSIX leading `//a` — define (recommended: collapse to `/a`).
- Empty-string argument — define (`croak` vs normalize to `.`).

## Blast radius

`EPICS::Path::AbsPath` has five callers — `expandVars.pl`,
`genVersionHeader.pl`, `convertRelease.pl`, `makeBaseApp.pl`, `fullPathName.pl`
— and `fullPathName.pl` is wired into `configure/CONFIG_BASE`. The additive
primitives must not alter `AbsPath`, so none of these are affected.

## Rejected alternatives

- **GNU make** — `$(abspath)` covers normalization, but there is no
  relative-path primitive; a hand-rolled common-prefix walk breaks on paths
  with spaces and has no order-preserving dedup.
- **Guile (`$(guile ...)`)** — no EPICS target platform ships a Guile-enabled
  `make` by default (Debian splits it into a separate `make-guile`; macOS
  system make is 3.81, predating Guile support; the development host's GNU Make
  4.4.1 reports no `guile` in `.FEATURES`). A heavier prerequisite than Perl,
  which Base already requires.

## Related artifacts

- `makeRPath.pl` — corrected Perl port (baseline this work builds on).
- `compare_makeRPath.sh` — 37-case stdout comparison driver.
- `test-plan-makeRPath.md` — test plan for the stdout contract.
- `issue-makeRPath-pl.md` — upstream issue body (analysis plus full code).

The eventual upstream epics-base submission is tracked separately from the
environment-repo backlog item (issue #25).
