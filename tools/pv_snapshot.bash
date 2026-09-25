#!/usr/bin/env bash
#
# pv_snapshot.bash - capture EPICS PV values into a snapshot file and compare
# two snapshots, for the before/after check around a test IOC run.
#
#   capture  reads every PV of a list with caget and writes one
#            "<pv><TAB><value>" line per listed PV, in list order, after a
#            "#" header line holding the capture time. A PV that does not
#            connect is written with the value __DISCONNECTED__; an array
#            value keeps its element count and elements, tab separated.
#   compare  reports each PV of the first snapshot against the second as
#            SAME, WITHIN (numeric difference not above the tolerance),
#            DIFF, MISSING (absent from the second), or DISCONN (not
#            connected in either), then a summary with the largest numeric
#            difference. Exit status 1 when any PV is DIFF, MISSING, or
#            DISCONN; 0 otherwise.

set -euo pipefail

readonly PROG="${0##*/}"
readonly DISCONNECTED="__DISCONNECTED__"
readonly DEFAULT_TIMEOUT="2.0"
readonly DEFAULT_TOLERANCE="0"
# PVs per caget call; a call with an unconnected PV prints no value at all,
# so only a failed batch is read again one PV at a time, with up to
# PARALLEL_READS reads running at once.
readonly BATCH_SIZE=100
readonly PARALLEL_READS=20

function die {
    printf "%s: error: %s\n" "$PROG" "$1" >&2
    exit 2
}

function usage {
    cat <<EOF
Usage:
  $PROG capture -l PVLIST -o SNAPSHOT [-w SECONDS]
  $PROG compare [-t TOLERANCE] BEFORE AFTER

capture:
  -l PVLIST    file with one PV name per line; blank lines and # comments ignored
  -o SNAPSHOT  output file
  -w SECONDS   Channel Access timeout                     [$DEFAULT_TIMEOUT]

compare:
  -t TOLERANCE largest numeric difference reported as WITHIN [$DEFAULT_TOLERANCE]

Exit status: 0 no difference beyond the tolerance, 1 difference found,
2 usage or runtime error.
EOF
}

function need_cmd {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1 || die "required command not found: $cmd"
    [[ -x "$(command -v "$cmd")" ]] || die "not executable: $cmd"
}

# Prints the PV names of a list file, one per line, without comments,
# whitespace, or carriage returns.
function read_pv_list {
    local file="$1"
    local line
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        line="${line%%#*}"
        line="${line//[[:space:]]/}"
        if [[ -n "$line" ]]; then
            printf "%s\n" "$line"
        fi
    done < "$file"
    return 0
}

function cmd_capture {
    local list="" out="" timeout="$DEFAULT_TIMEOUT"
    local raw name value pv i k tmpdir disconnected=0
    local -a pvs=() batch=()
    local -A seen=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -l) list="${2:-}"; shift 2 ;;
            -o) out="${2:-}"; shift 2 ;;
            -w) timeout="${2:-}"; shift 2 ;;
            -h|--help) usage; exit 0 ;;
            *) die "capture: unexpected argument: $1" ;;
        esac
    done
    [[ -n "$list" && -n "$out" ]] || { usage >&2; die "capture needs -l and -o"; }
    [[ -s "$list" ]] || die "PV list missing or empty: $list"
    need_cmd caget

    mapfile -t pvs < <(read_pv_list "$list")
    [[ ${#pvs[@]} -gt 0 ]] || die "no PV names in $list"

    tmpdir="$(mktemp -d)"
    # shellcheck disable=SC2064  # expand tmpdir now; it is local to this function
    trap "rm -rf '${tmpdir}'" EXIT
    raw=""
    for ((i = 0; i < ${#pvs[@]}; i += BATCH_SIZE)); do
        batch=("${pvs[@]:i:BATCH_SIZE}")
        if value="$(caget -w "$timeout" -F $'\t' "${batch[@]}" 2>/dev/null)"; then
            raw+="${value}"$'\n'
            continue
        fi
        # Each read writes its own file, so long array values cannot interleave.
        rm -f "${tmpdir}"/*
        for ((k = 0; k < ${#batch[@]}; k++)); do
            caget -w "$timeout" -F $'\t' "${batch[k]}" > "${tmpdir}/${k}" 2>/dev/null &
            if (( (k + 1) % PARALLEL_READS == 0 )); then
                wait || true
            fi
        done
        wait || true
        for ((k = 0; k < ${#batch[@]}; k++)); do
            if [[ -s "${tmpdir}/${k}" ]]; then
                raw+="$(< "${tmpdir}/${k}")"$'\n'
            fi
        done
    done
    while IFS=$'\t' read -r name value; do
        if [[ -n "$name" ]]; then
            seen["$name"]="$value"
        fi
    done <<< "$raw"

    {
        printf "# captured %s by %s from %s\n" "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$PROG" "$list"
        for pv in "${pvs[@]}"; do
            if [[ -n "${seen[$pv]+set}" ]]; then
                printf "%s\t%s\n" "$pv" "${seen[$pv]}"
            else
                printf "%s\t%s\n" "$pv" "$DISCONNECTED"
                disconnected=$((disconnected + 1))
            fi
        done
    } > "$out"
    [[ -s "$out" ]] || die "snapshot not written: $out"

    printf "%s: %d PVs captured to %s, %d not connected\n" \
        "$PROG" "${#pvs[@]}" "$out" "$disconnected"
    return 0
}

function cmd_compare {
    local tolerance="$DEFAULT_TOLERANCE"
    local before after

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t) tolerance="${2:-}"; shift 2 ;;
            -h|--help) usage; exit 0 ;;
            -*) die "compare: unknown option: $1" ;;
            *) break ;;
        esac
    done
    [[ $# -eq 2 ]] || { usage >&2; die "compare needs BEFORE and AFTER"; }
    before="$1"
    after="$2"
    [[ -s "$before" ]] || die "snapshot missing or empty: $before"
    [[ -s "$after" ]] || die "snapshot missing or empty: $after"
    [[ "$tolerance" =~ ^[0-9]+([.][0-9]+)?([eE][-+]?[0-9]+)?$ ]] \
        || die "tolerance must be a non-negative number: $tolerance"
    need_cmd awk

    awk -F '\t' -v tol="$tolerance" -v disc="$DISCONNECTED" '
        function isnum(v) { return v ~ /^[-+]?([0-9]+[.]?[0-9]*|[.][0-9]+)([eE][-+]?[0-9]+)?$/ }
        function absv(v)  { return v < 0 ? -v : v }
        function val(line) { sub(/^[^\t]*\t/, "", line); return line }
        /^#/ { next }
        FNR == NR { order[++n] = $1; bval[$1] = val($0); next }
        { aval[$1] = val($0) }
        END {
            maxd = -1
            for (i = 1; i <= n; i++) {
                pv = order[i]; b = bval[pv]; delta = ""
                if (!(pv in aval)) {
                    st = "MISSING"; a = ""
                } else {
                    a = aval[pv]
                    if (b == disc || a == disc) {
                        st = "DISCONN"
                    } else if (a == b) {
                        st = "SAME"
                    } else if (isnum(a) && isnum(b)) {
                        d = absv(a - b); delta = d
                        st = (d <= tol + 0) ? "WITHIN" : "DIFF"
                        if (d > maxd) { maxd = d; maxpv = pv }
                    } else {
                        st = "DIFF"
                    }
                }
                count[st]++
                printf "%s\t%s\t%s\t%s\t%s\n", st, pv, b, a, delta
            }
            printf "# PVs %d: SAME %d, WITHIN %d, DIFF %d, MISSING %d, DISCONN %d; tolerance %s\n",
                n, count["SAME"], count["WITHIN"], count["DIFF"], count["MISSING"], count["DISCONN"], tol
            if (maxd >= 0) printf "# largest numeric difference %s on %s\n", maxd, maxpv
            exit (count["DIFF"] + count["MISSING"] + count["DISCONN"] > 0) ? 1 : 0
        }
    ' "$before" "$after"
}

[[ $# -gt 0 ]] || { usage >&2; exit 2; }
case "$1" in
    capture) shift; cmd_capture "$@" ;;
    compare) shift; cmd_compare "$@" ;;
    -h|--help) usage ;;
    *) usage >&2; die "unknown command: $1" ;;
esac
