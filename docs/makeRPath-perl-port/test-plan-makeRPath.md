# makeRPath.pl — Test Plan

## Scope

The build contract of `makeRPath` is the **stdout `-rpath` / `-rpath-link`
string** that the build captures via `$(shell ...)`. This plan tests that
contract only. The reference is the upstream `makeRPath.py`: a case PASSes when
`makeRPath.pl` produces identical stdout and the same exit status as the Python
original for the same arguments and working directory.

## Non-goals

- `--help` / usage / error text on **stderr** (Perl `Pod::Usage` convention,
  intentionally not matched to argparse exactly — see issue body), together with
  the `--help` and parse-error **exit codes** that accompany them.
- The `EPICS_DEBUG_RPATH` debug line (stderr, diagnostic only).

Only the **exit status of a normal rpath invocation** (expected 0) is in scope,
since the build captures stdout and depends on a clean exit alongside it.

## Reference behavior (from `makeRPath.py`)

- Each input path produces one `-Wl,-rpath,...` entry, in input order, de-duplicated.
- A path under a `--root` that also encloses `--final` is emitted as
  `$ORIGIN/<target-relative-to-final>` plus a `-Wl,-rpath-link,<abspath>`.
- A path outside every root is emitted as an absolute `-Wl,-rpath,<abspath>`.
- Paths are made absolute **lexically** (`os.path.abspath`, no symlink resolution)
  and normalized (`os.path.normpath`).
- The origin string is combined via `os.path.join(origin, rel)`.

## Cases

Status legend: **P** = passing against the reference. All 37 cases currently pass;
see `compare_makeRPath.sh` for the driver and the run summary `cases=37 pass=37
fail=0`.

| #  | Case | Input shape | Intent / branch exercised | Status |
|----|------|-------------|---------------------------|--------|
| 1  | no-args | (no path args) | empty stdout when no paths given | P |
| 2  | doc-example | `-F build/lib -R build` + in/in/out libs | baseline: in-root lib, in-root module lib, out-of-root lib | P |
| 3  | multi-root | `-R inst:build`, final & paths in different roots | final and target resolve under different roots | P |
| 4  | empty-root-components | `-R :root::` | empty `:`-split root components ignored | P |
| 5  | final-outside | final not under any root | no `$ORIGIN` rewrite; absolute rpath kept | P |
| 6  | nonexistent-final | `--final` path that does not exist | lexical absolute, no `stat` | P |
| 7  | relative-basic | relative `-F`/`-R`/path from cwd | cwd-relative inputs resolved | P |
| 8  | relative-dotdot | paths containing `..` | `..` normalization | P |
| 9  | duplicate | same path repeated | duplicate rpath removed | P |
| 10 | custom-origin | `-O @loader_path` | non-`$ORIGIN` origin string | P |
| 11 | absolute-origin | origin is an absolute path | `os.path.join` with absolute origin | P |
| 12 | space-path | path containing a space | stdout stability with spaces | P |
| 13 | repeated-roots | same root listed twice | output stable with duplicate roots | P |
| 14 | no-root-with-path | no `-R` at all | every path emitted as absolute rpath | P |
| 15 | equals-form | `--final=… --root=… --origin=…` | `=`-joined option form, same stdout | P |
| 16 | root-prefix-trap | `/tmp/root` vs `/tmp/root2` | prefix-only sibling not mistaken as in-root | P |
| 17 | nested-final | `bin/linux-x86_64` final, `lib/linux-x86_64` dep | EPICS-style nested relative path | P |
| 18 | same-path-different-spelling | `lib`, `./lib`, `a/../lib` | same abspath → de-dup | P |
| 19 | root-order-overlap-parent-first | nested roots, parent first | same root chosen as Python | P |
| 20 | root-order-overlap-child-first | nested roots, child first | same root chosen as Python | P |
| 21 | trailing-slash | trailing `/` on final/root/path | trailing slash effect on output | P |
| 22 | relative-root-different-cwd | cwd under root, relative root/path | relative root/path from a sub-cwd | P |
| 23 | empty-origin | `-O ''` | `os.path.join('', rel)` → no leading slash | P |
| 24 | origin-with-trailing-slash | `-O '$ORIGIN/'` | `os.path.join` collapses doubled slash | P |
| 25 | symlink-path-lexical | path through a symlink | lexical abspath, symlink not resolved | P |
| 26 | multiple-outside-paths | several out-of-root paths | order + de-dup of absolute rpaths | P |
| 27 | mixed-inside-outside-duplicates | in/out paths mixed with duplicates | output order and de-dup across both kinds | P |
| 28 | path-name-starts-with-dash | `-- -name` | dash-leading path after `--` reaches stdout | P |
| 29 | root-is-filesystem-root | `-R /` | every absolute path treated as in-root | P |
| 30 | relative-origin-parent | `-O ../origin` | `os.path.join` with relative origin | P |
| 31 | final-equals-root | `--final` == `--root` | `$frel` is `.`; `abs2rel(rrel, '.')` path | P |
| 32 | path-equals-final | a dep dir equal to `--final` | self-reference yields `$ORIGIN/.` (absorbable into #2) | P |
| 33 | path-equals-root | a dep dir equal to its enclosing root | `abs2rel(path, root)` is `.`, in-root boundary | P |
| 34 | empty-string-path | `''` as a path arg | `abspath('')` == cwd, parity with Python | P |
| 35 | final-ancestor-of-root | `--final` is an ancestor of `--root` | final not enclosed → no `$ORIGIN`, all absolute (absorbable into #5) | P |
| 36 | multiple-roots-none-match | several roots, no path under any | roots present but unmatched → all absolute | P |
| 37 | origin-double-trailing-slash | `-O '$ORIGIN//'` | regression companion to #24, pinned after the join fix | P |

## Resolved differences

`join_origin()` originally appended with `"$base/$path"` and did not reproduce
`os.path.join` for two edge origins:

- **#23 empty-origin** — was Python `../lib` vs Perl `/../lib` (spurious leading slash).
- **#24 origin-with-trailing-slash** — was Python `$ORIGIN/../lib` vs Perl `$ORIGIN//../lib`.

Neither occurs from the actual build call site (always `-O '$ORIGIN'`), but `-O`
is a public option and the `Reference behavior` already commits to
`os.path.join(origin, rel)`. `join_origin()` now mirrors `os.path.join`: an empty
base returns `$path` unchanged, and a base ending in `/` is not given a second
separator. #23, #24, and #37 (single- and double-slash forms) all pass.

## How to run

    bash work/compare_makeRPath.sh

The file also carries the executable bit, so `./compare_makeRPath.sh` works from
`work/`. It drives every case through both implementations, capturing stdout to
temp files and comparing them with `cmp` alongside exit status. A case is PASS
only when both exit 0 **and** stdout is identical; the run ends with a
`cases=N pass=N fail=N` summary.

Script paths are resolved relative to the driver, so it runs from any checkout.
For other layouts (e.g. both scripts under `src/tools/` in an upstream PR), set
`MAKERPATH_PY` and `MAKERPATH_PL`. Relative override values are resolved against
the invocation directory, so run from the repo root — e.g. from this checkout:

    MAKERPATH_PY=epics-base-src/src/tools/makeRPath.py \
        MAKERPATH_PL=work/makeRPath.pl bash work/compare_makeRPath.sh
