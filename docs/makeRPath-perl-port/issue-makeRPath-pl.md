# makeRPath: Perl port from PR #589 regressed `$ORIGIN` rpath generation — analysis, fix, and tests

## Summary

PR #589 ("Remove Python build dependency when `LINKER_USE_RPATH=ORIGIN`", commit `f4c474e`) converted `src/tools/makeRPath.py` to `makeRPath.pl`, and was later reverted in full by `a3d8531` ("Revert PR #589"). The revert commit does not record a reason.

On inspection the Perl port carried three behavioral regressions against the Python original. The most significant one ties the emitted `$ORIGIN` rpath to the *current working directory*, which works against the goal of `LINKER_USE_RPATH=ORIGIN` (a relocatable build tree) and may well have led to the revert.

The Python-to-Perl direction is a natural fit for `src/tools`. `makeRPath` is the only Python script among the Perl build tools there, so porting it both restores consistency with the rest of the directory and removes the Python dependency from the normal (non-doc) build path — the stated goal of PR #589. The unversioned `python` command is fragile (depending on the distribution it may be absent or resolve to Python 2); this can be steered with `PYTHON` in CONFIG_SITE, but narrowing the build's interpreter dependencies toward Perl alone is the more sustainable path. The port adds no new Perl dependency: it uses only core modules and the defined-or operator `//`, which is within EPICS's stated minimum (Perl 5.10.1) and already used in `src/tools` by `makeTestfile.pl` (which likewise declares `use 5.10.1` for it). The blocker in #589 was the regression, not the language choice.

So this issue includes a **corrected port and a comparison test driver inline for review**, not just a bug report. If the approach looks right I'll open it as a PR.

## Reproduction

Given a relocatable tree:

```
build/lib
build/module/lib
other/lib        # outside the root
```

and the call

```
makeRPath -F build/lib -R build build/lib build/module/lib other/lib
```

**Python (`makeRPath.py`, current):**

```
-Wl,-rpath-link,/.../build/lib -Wl,-rpath,$ORIGIN/. \
-Wl,-rpath-link,/.../build/module/lib -Wl,-rpath,$ORIGIN/../module/lib \
-Wl,-rpath,/.../other/lib
```

**Perl (`makeRPath.pl` from PR #589):**

```
-Wl,-rpath-link,/.../build/lib \
-Wl,-rpath,$ORIGIN/../../../../<cwd-path>/lib \
-Wl,-rpath-link,/.../build/module/lib \
-Wl,-rpath,$ORIGIN/../../../../<cwd-path>/module/lib
```

The Perl `$ORIGIN` paths embed the working directory the build ran from, and the trailing rpath for the out-of-tree `other/lib` is missing entirely.

## Regressions

### A. `$ORIGIN` path computed against the wrong base (cwd leak)

`makeRPath.py` computes the target relative to the *final* location, with both expressed relative to the enclosing root:

```python
# rrel = target relative to root, frel = final relative to root
path = os.path.relpath(rrel, frel)
```

The Perl port used the absolute `$final` as the base instead of the root-relative `$frel`:

```perl
my $rel_path = File::Spec->abs2rel($rrel, $final);
```

Because `$rrel` is a *relative* string, `abs2rel` resolves it against the current working directory, so the result encodes the cwd. The resulting rpath is not relocatable.

### B. Missing `-rpath` for paths outside every root

In Python the final `-rpath` entry is appended unconditionally, once per input path, *outside* the root-matching loop:

```python
for path in args.path:
    path = os.path.abspath(path)
    for root in roots:
        ...
        break
    output['-Wl,-rpath,' + os.path.join(args.origin, path)] = True
```

The Perl port emitted the `-rpath` entry only *inside* the per-root loop, so an input path under no root (e.g. a system library directory) produced no `-rpath` at all.

### C. `Cwd::abs_path` rejects a not-yet-existing `--final`

The Perl port used `Cwd::abs_path`, which requires the path to exist on disk. The `--final` install location frequently does not exist at link time, so this can return `undef`. The Python `os.path.abspath` is purely lexical.

## The fix

The corrected port mirrors the Python semantics:

- **A** — compute the `$ORIGIN`-relative path with `abs2rel($rrel, $frel)`, both sides root-relative so the cwd cancels:

  ```perl
  $rel = File::Spec->abs2rel($rrel, $frel);
  ```

- **B** — emit the `-rpath` entry once per input, outside the root loop, via a `join_origin` helper that mirrors `os.path.join` (an absolute argument replaces `$ORIGIN`; an empty base or a trailing slash is handled like Python):

  ```perl
  sub join_origin {
      my ($base, $path) = @_;
      return $path if File::Spec->file_name_is_absolute($path);
      return $path if $base eq '';
      return $base =~ m{/$} ? "$base$path" : "$base/$path";
  }
  ```

- **C** — make paths absolute lexically with `File::Spec->rel2abs` (no `stat`), plus a small `normpath` helper reproducing `os.path.normpath` so `..` collapses identically.

<details>
<summary>Full corrected <code>makeRPath.pl</code></summary>

```perl
#!/usr/bin/env perl
#*************************************************************************
# SPDX-License-Identifier: EPICS
# EPICS BASE is distributed subject to a Software License Agreement found
# in file LICENSE that is included with this distribution.
#*************************************************************************

use strict;
use warnings;
use 5.10.1;   # for the defined-or operator //

use Getopt::Long;
use File::Spec;
use Pod::Usage;

# Example:
#   target to be installed as: /build/bin/blah
#   post-install will copy as: /install/bin/blah
#
# Need to link against:
#   /install/lib/libA.so
#   /build/lib/libB.so
#   /other/lib/libC.so
#
# Want final result to be:
#   -rpath $ORIGIN/../lib -rpath /other/lib \
#   -rpath-link /build/lib -rpath-link /install/lib

warn "[" . join(' ', $0, @ARGV) . "]\n"
    if ($ENV{EPICS_DEBUG_RPATH} // '') eq 'YES';

# Defaults for command-line arguments
my $final  = File::Spec->curdir();
my $root   = '';
my $origin = '$ORIGIN';
my $help   = 0;

GetOptions(
    'final|F=s'  => \$final,
    'root|R=s'   => \$root,
    'origin|O=s' => \$origin,
    'help|h'     => \$help,
) or pod2usage(
    -exitval   => 2,
    -verbose   => 1,
    -noperldoc => 1,
);

pod2usage(
    -exitval   => 0,
    -verbose   => 2,
    -noperldoc => 1,
) if $help;

# Lexically normalize an absolute path the way Python's os.path.normpath()
# does: collapse '.', resolve '..' against the preceding component, and drop
# '..' that would climb above the root. Purely textual, no filesystem access.
sub normpath {
    my ($p) = @_;
    return '.' if $p eq '';
    my $abs = ($p =~ m{^/});
    my @out;
    foreach my $c (split m{/+}, $p) {
        next if $c eq '' || $c eq '.';
        if ($c eq '..') {
            if (@out && $out[-1] ne '..') {
                pop @out;
            } elsif (!$abs) {
                push @out, $c;
            }
        } else {
            push @out, $c;
        }
    }
    my $r = join('/', @out);
    $r = '/' . $r if $abs;
    return $r eq '' ? '.' : $r;
}

# Normalize to absolute form lexically (rel2abs, not Cwd::abs_path) so that
# a --final install location which does not exist yet is still accepted.
my $fdir  = normpath(File::Spec->rel2abs($final));
my @roots = map { normpath(File::Spec->rel2abs($_)) }
            grep { length } split(/:/, $root);

# Find the root which contains the final location, and remember the final
# location relative to that enclosing root ($frel).
my $froot;
my $frel;
foreach my $r (@roots) {
    my $rel = File::Spec->abs2rel($fdir, $r);
    if ($rel !~ m{^\.\.}) {
        # final dir is under this root
        $froot = $r;
        $frel  = $rel;
        last;
    }
}

if (!defined $froot) {
    warn "makeRPath: Final location $fdir\n" .
         "Not under any of: @roots\n";
    @roots = ();   # Skip $ORIGIN handling below
}

# Join $origin with a relative path the way os.path.join() does:
#   - an absolute second argument replaces the origin entirely
#     (used for paths outside any root);
#   - an empty base returns the path unchanged (no spurious leading slash);
#   - a base already ending in '/' is not given a second separator.
sub join_origin {
    my ($base, $path) = @_;
    return $path if File::Spec->file_name_is_absolute($path);
    return $path if $base eq '';
    return $base =~ m{/$} ? "$base$path" : "$base/$path";
}

my (@output, %seen);
sub emit {
    my ($opt) = @_;
    push @output, $opt unless $seen{$opt}++;
}

foreach my $path (@ARGV) {
    $path = normpath(File::Spec->rel2abs($path));
    my $rel = $path;   # default: outside every root, keep the absolute path

    foreach my $r (@roots) {
        my $rrel = File::Spec->abs2rel($path, $r);
        next if $rrel =~ m{^\.\.};   # path not under this root

        # Some older binutils don't handle $ORIGIN correctly when locating
        # dependencies of libraries, so also provide the absolute path for
        # internal use by 'ld' only.
        emit("-Wl,-rpath-link,$path");

        # frel is the final location relative to the enclosing root,
        # rrel is the target location relative to the same root, so the
        # target relative to the final location is abs2rel($rrel, $frel).
        $rel = File::Spec->abs2rel($rrel, $frel);
        last;
    }

    emit("-Wl,-rpath," . join_origin($origin, $rel));
}

print join(' ', @output), "\n";

__END__

=head1 NAME

makeRPath.pl - Compute and output -rpath entries for given paths

=head1 SYNOPSIS

makeRPath.pl [options] [path ...]

=head1 OPTIONS

    -h, --help      Display detailed help and exit
    -F, --final     Final install location for ELF file
    -R, --root      Root(s) of relocatable tree, separated by ':'
    -O, --origin    Origin path (default: '$ORIGIN')

=head1 DESCRIPTION

Computes and outputs -rpath entries for each of the given paths.
Paths under C<--root> will be computed as relative to C<--final>.

=head1 EXAMPLE

A library to be placed in C</build/lib> and linked against libraries in
C</build/lib>, C</build/module/lib>, and C</other/lib> would pass

  makeRPath.pl -F /build/lib -R /build /build/lib /build/module/lib /other/lib

which generates

  -Wl,-rpath,$ORIGIN/. -Wl,-rpath,$ORIGIN/../module/lib -Wl,-rpath,/other/lib

=cut
```

</details>

## Regression test

A driver runs both implementations on identical arguments and compares their stdout and exit status. stdout is captured to temp files and compared with `cmp`, so even a stray trailing newline would be caught. It covers 37 cases — the doc example, multiple roots, a `--final` outside every root, relative inputs with `..`, the `root`/`root2` prefix trap, nested-root ordering, symlink (lexical) paths, `--opt=value`, dash-leading paths after `--`, de-duplication, and the `-O` origin edge cases (empty / trailing-slash / absolute / relative).

With the corrected port every case matches the Python reference: `cases=37 pass=37 fail=0`. The doc-example `-rpath` entries match the POD `EXAMPLE` block (`$ORIGIN/.`, `$ORIGIN/../module/lib`, `/.../other/lib`); the full output also carries the `-rpath-link` entries, which the POD example omits for brevity.

<details>
<summary>Comparison driver <code>compare_makeRPath.sh</code></summary>

```bash
#!/usr/bin/env bash
# Compares makeRPath.py (the reference) against makeRPath.pl (the port), driving
# every case in test-plan-makeRPath.md. A case PASSes only when both
# implementations exit 0 (the normal rpath invocation) AND produce identical
# stdout. stdout is captured to temp files and compared with cmp, so even a stray
# trailing newline is caught.
set -u

# Paths are resolved relative to this script so the driver works from any
# checkout; override with MAKERPATH_PY / MAKERPATH_PL for other layouts (e.g.
# when both scripts sit in src/tools/ inside an upstream PR).
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PY=${MAKERPATH_PY:-$HERE/../epics-base-src/src/tools/makeRPath.py}
PL=${MAKERPATH_PL:-$HERE/makeRPath.pl}
# Make paths absolute against the invocation cwd before any per-case 'cd' into a
# temp dir, so relative MAKERPATH_* overrides still resolve. (HERE-based
# defaults are already absolute.)
case $PY in /*) ;; *) PY=$(pwd)/$PY ;; esac
case $PL in /*) ;; *) PL=$(pwd)/$PL ;; esac

T=$(mktemp -d)
mkdir -p \
    "$T/build/lib" "$T/build/module/lib" "$T/build/a" \
    "$T/other/lib" "$T/inst/lib" \
    "$T/root/lib" "$T/root2/lib" \
    "$T/usr/bin/linux-x86_64" "$T/usr/lib/linux-x86_64" \
    "$T/sp ace/lib"
ln -s "$T/build" "$T/link"

pass=0; fail=0
function run {
    local name=$1 dir=$2; shift 2
    local rcpy rcpl outpy outpl errpy errpl ok=1
    outpy=$(mktemp); outpl=$(mktemp); errpy=$(mktemp); errpl=$(mktemp)
    ( cd "$dir" && python3 "$PY" "$@" ) >"$outpy" 2>"$errpy"; rcpy=$?
    ( cd "$dir" && perl    "$PL" "$@" ) >"$outpl" 2>"$errpl"; rcpl=$?
    printf '== %s ==\n' "$name"
    printf '  PY: %s\n' "$(cat "$outpy")"
    printf '  PL: %s\n' "$(cat "$outpl")"
    if [ "$rcpy" -ne 0 ] || [ "$rcpl" -ne 0 ]; then
        printf '  exit: py=%d pl=%d (expected 0/0)\n' "$rcpy" "$rcpl"; ok=0
    fi
    cmp -s "$outpy" "$outpl" || ok=0
    if [ "$ok" -eq 1 ]; then
        printf '  -> PASS\n'; pass=$((pass + 1))
    else
        printf '  -> FAIL\n'; fail=$((fail + 1))
        cmp "$outpy" "$outpl"
        [ -s "$errpy" ] && printf '  py stderr: %s\n' "$(cat "$errpy")"
        [ -s "$errpl" ] && printf '  pl stderr: %s\n' "$(cat "$errpl")"
    fi
    rm -f "$outpy" "$outpl" "$errpy" "$errpl"
}

# 1  no-args: empty stdout when no paths given
run "01 no-args"                       "$T" -F "$T/build/lib" -R "$T/build"
# 2  doc-example: in-root lib, in-root module lib, out-of-root lib
run "02 doc-example"                   "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/build/lib" "$T/build/module/lib" "$T/other/lib"
# 3  multi-root: final & paths under different roots
run "03 multi-root"                    "$T" -F "$T/inst/lib" -R "$T/inst:$T/build" \
    "$T/inst/lib" "$T/build/module/lib" "$T/other/lib"
# 4  empty-root-components: ':'-split blanks ignored
run "04 empty-root-components"         "$T" -F "$T/build/lib" -R ":$T/build::" \
    "$T/build/lib" "$T/build/module/lib"
# 5  final-outside: no $ORIGIN rewrite
run "05 final-outside"                 "$T" -F "$T/other/lib" -R "$T/build" \
    "$T/build/lib" "$T/other/lib"
# 6  nonexistent-final: lexical absolute, no stat
run "06 nonexistent-final"             "$T" -F "$T/nope/lib" -R "$T/build" \
    "$T/build/lib"
# 7  relative-basic: cwd-relative inputs
run "07 relative-basic"                "$T" -F build/lib -R build \
    build/lib build/module/lib other/lib
# 8  relative-dotdot: '..' normalization
run "08 relative-dotdot"               "$T/build" -F lib -R . \
    lib ../other/lib
# 9  duplicate: same path repeated
run "09 duplicate"                     "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/build/lib" "$T/build/lib"
# 10 custom-origin
run "10 custom-origin"                 "$T" -O @loader_path -F "$T/build/lib" -R "$T/build" \
    "$T/build/module/lib"
# 11 absolute-origin: os.path.join with absolute origin
run "11 absolute-origin"               "$T" -O /abs/origin -F "$T/build/lib" -R "$T/build" \
    "$T/build/module/lib"
# 12 space-path
run "12 space-path"                    "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/sp ace/lib"
# 13 repeated-roots
run "13 repeated-roots"                "$T" -F "$T/build/lib" -R "$T/build:$T/build" \
    "$T/build/module/lib"
# 14 no-root-with-path: every path absolute
run "14 no-root-with-path"             "$T" -F "$T/build/lib" \
    "$T/build/lib" "$T/other/lib"
# 15 equals-form
run "15 equals-form"                   "$T" "--final=$T/build/lib" "--root=$T/build" "--origin=\$ORIGIN" \
    "$T/build/module/lib" "$T/other/lib"
# 16 root-prefix-trap: /root vs /root2 sibling
run "16 root-prefix-trap"              "$T" -F "$T/root/lib" -R "$T/root" \
    "$T/root/lib" "$T/root2/lib"
# 17 nested-final: EPICS-style nested arch dirs
run "17 nested-final"                  "$T" -F "$T/usr/bin/linux-x86_64" -R "$T/usr" \
    "$T/usr/lib/linux-x86_64"
# 18 same-path-different-spelling: dedup after normalize
run "18 same-path-different-spelling"  "$T/build" -F lib -R "$T/build" \
    lib ./lib a/../lib
# 19 root-order-overlap-parent-first
run "19 root-order-overlap-parent-first" "$T" -F "$T/usr/bin/linux-x86_64" -R "$T/usr:$T/usr/lib" \
    "$T/usr/lib/linux-x86_64"
# 20 root-order-overlap-child-first
run "20 root-order-overlap-child-first"  "$T" -F "$T/usr/bin/linux-x86_64" -R "$T/usr/lib:$T/usr" \
    "$T/usr/lib/linux-x86_64"
# 21 trailing-slash on final/root/path
run "21 trailing-slash"                "$T" -F "$T/build/lib/" -R "$T/build/" \
    "$T/build/module/lib/"
# 22 relative-root-different-cwd: cwd under root
run "22 relative-root-different-cwd"   "$T/build" -F lib -R . \
    lib module/lib
# 23 empty-origin: os.path.join('', rel)
run "23 empty-origin"                  "$T" -O '' -F "$T/build/lib" -R "$T/build" \
    "$T/build/module/lib"
# 24 origin-with-trailing-slash
# shellcheck disable=SC2016  # literal $ORIGIN must not be shell-expanded
run "24 origin-with-trailing-slash"    "$T" -O '$ORIGIN/' -F "$T/build/lib" -R "$T/build" \
    "$T/build/module/lib"
# 25 symlink-path-lexical: symlink not resolved
run "25 symlink-path-lexical"          "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/link/module/lib"
# 26 multiple-outside-paths
run "26 multiple-outside-paths"        "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/other/lib" "$T/inst/lib"
# 27 mixed-inside-outside-duplicates
run "27 mixed-inside-outside-duplicates" "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/build/lib" "$T/other/lib" "$T/build/lib" "$T/other/lib"
# 28 path-name-starts-with-dash: after '--'
run "28 path-name-starts-with-dash"    "$T" -F "$T/build/lib" -R "$T/build" -- -name
# 29 root-is-filesystem-root
run "29 root-is-filesystem-root"       "$T" -F "$T/build/lib" -R / \
    "$T/build/lib" "$T/other/lib"
# 30 relative-origin-parent
run "30 relative-origin-parent"        "$T" -O ../origin -F "$T/build/lib" -R "$T/build" \
    "$T/build/module/lib"
# 31 final-equals-root: $frel is '.'
run "31 final-equals-root"             "$T" -F "$T/build" -R "$T/build" \
    "$T/build/lib"
# 32 path-equals-final: yields $ORIGIN/.
run "32 path-equals-final"             "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/build/lib"
# 33 path-equals-root: abs2rel is '.'
run "33 path-equals-root"              "$T" -F "$T/build/lib" -R "$T/build" \
    "$T/build"
# 34 empty-string-path: abspath('') == cwd
run "34 empty-string-path"             "$T" -F "$T/build/lib" -R "$T/build" \
    ""
# 35 final-ancestor-of-root: final not enclosed
run "35 final-ancestor-of-root"        "$T" -F "$T" -R "$T/build" \
    "$T/build/lib"
# 36 multiple-roots-none-match
run "36 multiple-roots-none-match"     "$T" -F "$T/other/lib" -R "$T/inst:$T/build" \
    "$T/other/lib"
# 37 origin-double-trailing-slash
# shellcheck disable=SC2016  # literal $ORIGIN must not be shell-expanded
run "37 origin-double-trailing-slash"  "$T" -O '$ORIGIN//' -F "$T/build/lib" -R "$T/build" \
    "$T/build/module/lib"

rm -rf "$T"
printf '\n'
printf 'cases=%d pass=%d fail=%d\n' "$((pass + fail))" "$pass" "$fail"
if [ "$fail" -eq 0 ]; then printf '%s\n' "ALL CASES PASS"; else printf '%s\n' "SOME CASES FAIL"; exit 1; fi
```

</details>

## Notes

The corrected port and driver are included inline so the approach can be reviewed here before any merge. If it looks right, I'll open it as a PR — which also enables line-level review and CI. Two points worth a maintainer's call:

- The `-O` origin edge cases (empty / trailing-slash) never arise from the build call site (always `-O '$ORIGIN'`), but `os.path.join` semantics are matched for completeness; let me know if you'd rather treat those as out of scope.
- stderr/help text follows the Perl `Pod::Usage` convention rather than matching argparse exactly; only the stdout rpath output is compared closely.
