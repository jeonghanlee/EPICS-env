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
PY=${MAKERPATH_PY:-$HERE/../../epics-base-src/src/tools/makeRPath.py}
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
