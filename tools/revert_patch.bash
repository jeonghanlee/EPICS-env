#!/usr/bin/env bash

# Classify a whole patch before reversing it; preserve confirmed unapplied
# sources and fail on conflicting, partial, or indeterminate input states.
set -euo pipefail
export LC_ALL=C

declare -a patch_options=(--batch --forward --ignore-whitespace --no-backup-if-mismatch -p0)
declare -a prerequisite_patches=()
declare source_path patch_file patch_command forward_output reverse_output
declare scratch='' prerequisite_mode=0
declare forward_status=0 reverse_status=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-backup-if-mismatch) shift ;;
        --prerequisites) prerequisite_mode=1; shift ;;
        --) shift; break ;;
        *) break ;;
    esac
done
if [[ $# -lt 2 || ( $prerequisite_mode -eq 0 && $# -ne 2 ) ]]; then
    printf 'Usage: %s [--no-backup-if-mismatch] [--prerequisites] <source> <patch> [ordered-patches...]\n' "${0##*/}" >&2
    exit 2
fi
source_path="$1"
patch_file="$2"
shift 2
if [[ $prerequisite_mode -eq 1 ]]; then
    for prerequisite in "$@"; do
        [[ "$prerequisite" != "$patch_file" ]] || break
        prerequisite_patches+=("$prerequisite")
    done
fi
if [[ ! -d "$source_path" || ! -s "$patch_file" ]]; then
    printf 'Missing required revert input: source=%s patch=%s\n' "$source_path" "$patch_file" >&2
    exit 2
fi

function cleanup {
    local status=$?
    if [[ -n "$scratch" ]]; then
        if [[ $status -eq 0 ]]; then
            rm -rf "$scratch"
        else
            printf 'Revert classification workspace retained: %s\n' "$scratch" >&2
        fi
    fi
}
trap cleanup EXIT

# Ambiguous GNU matches are accepted only inside a uniquely named static C function.
# Restrict this proof to one file and one hunk; other ambiguous shapes fail.
# A line that ends with a semicolon is a declaration of the function, not its
# definition, so it does not count as an occurrence.
function matches_function_location {
    local root="$1" selected="$2" direction="$3" output="$4"
    local mode="${5:-check}"
    awk -v root="$root" -v direction="$direction" -v output="$output" -v mode="$mode" '
        { patch_lines[NR]=$0 }
        /^--- / { files++; path=substr($0, 5); sub("\t.*", "", path) }
        /^@@ / {
            hunks++
            split($0, fields, " ")
            range=direction == "reverse" ? fields[3] : fields[2]
            sub(/^[+-]/, "", range)
            split(range, bounds, ",")
            position=bounds[1]+0
            context=$0
            sub(/^@@[^@]*@@[[:space:]]*/, "", context)
            in_hunk=1
            next
        }
        in_hunk && /^[ +-]/ {
            marker=substr($0, 1, 1)
            if (marker == "+" || marker == "-") {
                if (!changed) first_changed=line_index
                last_changed=line_index
                changed=1
            }
            if (marker == " " || marker == (direction == "reverse" ? "+" : "-")) line_index++
        }
        END {
            if (files != 1 || hunks != 1 || context !~ /^static[[:space:]].*\(/ ||
                path == "" || path ~ /^\// || path ~ /(^|\/)\.\.(\/|$)/) exit 2
            count=split(output, messages, "\n")
            for (i=1; i<=count; i++) {
                if (messages[i] ~ /^Hunk #1 succeeded at /) {
                    split(messages[i], words, " ")
                    position=words[5]+0
                }
            }
            gsub(/[[:space:]]/, "", context)
            while ((read_status=getline line < (root "/" path)) > 0) {
                line_number++
                compact=line
                gsub(/[[:space:]]/, "", compact)
                if (index(compact, context) == 1 && compact !~ /;$/) {
                    occurrences++
                    start=line_number
                }
                if (start && !finish && line ~ /^}/) finish=line_number
            }
            close(root "/" path)
            if (read_status < 0 || occurrences != 1 || !finish || !changed) exit 1
            if (mode == "hint") {
                position=int((start + finish) / 2)
                for (i=1; i<=NR; i++) {
                    line=patch_lines[i]
                    if (line ~ /^@@ /) {
                        sub(/^@@ -[0-9]+/, "@@ -" position, line)
                        sub(/ \+[0-9]+/, " +" position, line)
                    }
                    print line
                }
                exit 0
            }
            if (position + first_changed <= start ||
                position + last_changed >= finish) exit 1
        }
    ' "$selected"
}

function direction_matches_location {
    local status=0
    matches_function_location "$@" || status=$?
    [[ $status -eq 0 || $status -eq 2 ]]
}

# Change only the search hint in a private patch, retaining the shipped hunk.
# GNU patch must still match its contents and the changed lines must stay in the function.
function locate_private_patch {
    local selected="$1" status=0
    matches_function_location "$scratch/source" "$selected" forward '' hint > "$scratch/location.patch" || status=$?
    case "$status" in
        0) printf '%s\n' "$scratch/location.patch" ;;
        2) printf '%s\n' "$selected" ;;
        *) return 1 ;;
    esac
}

# Classify each private prerequisite with the same whole-patch and location checks.
# Reverse preparation defers only 1/1 mismatches; forward preparation resolves all.
function prepare_private_prerequisite {
    local prerequisite="$1" direction="$2" selected
    local forward reverse
    local forward_code=0 reverse_code=0
    [[ -s "$prerequisite" ]] || return 1
    selected=$(locate_private_patch "$prerequisite") || return 1
    forward=$("$patch_command" "${patch_options[@]}" --dry-run -d "$scratch/source" < "$selected" 2>&1) || forward_code=$?
    reverse=$("$patch_command" "${patch_options[@]}" --dry-run -R -d "$scratch/source" < "$selected" 2>&1) || reverse_code=$?
    if [[ $forward_code -eq 0 ]] && ! direction_matches_location "$scratch/source" "$selected" forward "$forward"; then forward_code=1; fi
    if [[ $reverse_code -eq 0 ]] && ! direction_matches_location "$scratch/source" "$selected" reverse "$reverse"; then reverse_code=1; fi
    if [[ $forward_code -eq 0 && $reverse_code -eq 1 ]]; then
        if [[ "$direction" == forward ]]; then
            "$patch_command" "${patch_options[@]}" -d "$scratch/source" < "$selected" >/dev/null 2>&1 || return 1
        fi
    elif [[ $reverse_code -eq 0 && $forward_code -eq 1 ]]; then
        if [[ "$direction" == reverse ]]; then
            "$patch_command" "${patch_options[@]}" -R -d "$scratch/source" < "$selected" >/dev/null 2>&1 || return 1
        fi
    elif [[ "$direction" == reverse && $forward_code -eq 1 && $reverse_code -eq 1 ]]; then
        return 0
    else
        printf 'Cannot prepare prerequisite: %s (direction=%s)\nReverse dry-run:\n%s\nForward dry-run:\n%s\n' \
            "$prerequisite" "$direction" "$reverse" "$forward" >&2
        return 1
    fi
    return 0
}

# Copy real patch-owned files, undo confirmed prerequisites in reverse order,
# then prepare every prerequisite in forward order without changing real sources.
function confirm_unapplied_with_prerequisites {
    local path parent prerequisite selected index
    local forward reverse
    local forward_code reverse_code
    scratch=$(mktemp -d) || return 1
    mkdir "$scratch/source" || return 1
    while IFS= read -r path; do
        [[ "$path" != /dev/null ]] || continue
        if [[ -z "$path" || "$path" == /* || "$path" == .. || "$path" == ../* || "$path" == */../* || "$path" == */.. ]]; then
            return 1
        fi
        parent=.
        [[ "$path" != */* ]] || parent="${path%/*}"
        mkdir -p "$scratch/source/$parent" || return 1
        if [[ -f "$source_path/$path" ]]; then
            cp -pL "$source_path/$path" "$scratch/source/$path" || return 1
            chmod u+w "$scratch/source/$path" || return 1
        fi
    done < <(awk '/^--- / || /^\+\+\+ / { path=substr($0, 5); sub("\t.*", "", path); print path }' \
        "${prerequisite_patches[@]}" "$patch_file")
    for ((index = ${#prerequisite_patches[@]} - 1; index >= 0; index -= 1)); do
        prepare_private_prerequisite "${prerequisite_patches[index]}" reverse || return 1
    done
    for prerequisite in "${prerequisite_patches[@]}"; do
        prepare_private_prerequisite "$prerequisite" forward || return 1
    done
    selected=$(locate_private_patch "$patch_file") || return 1
    forward_code=0
    reverse_code=0
    forward=$("$patch_command" "${patch_options[@]}" --dry-run -d "$scratch/source" < "$selected" 2>&1) || forward_code=$?
    reverse=$("$patch_command" "${patch_options[@]}" --dry-run -R -d "$scratch/source" < "$selected" 2>&1) || reverse_code=$?
    if [[ $forward_code -eq 0 ]] && ! direction_matches_location "$scratch/source" "$selected" forward "$forward"; then forward_code=1; fi
    if [[ $reverse_code -eq 0 ]] && ! direction_matches_location "$scratch/source" "$selected" reverse "$reverse"; then reverse_code=1; fi
    if [[ $forward_code -eq 0 && $reverse_code -eq 1 ]]; then
        return 0
    fi
    printf 'Prerequisite view does not confirm an unapplied patch: %s\nReverse dry-run:\n%s\nForward dry-run:\n%s\n' \
        "$patch_file" "$reverse" "$forward" >&2
    return 1
}
if ! patch_command=$(command -v patch) || [[ ! -x "$patch_command" ]]; then
    printf 'Required patch executable unavailable: source=%s patch=%s\n' "$source_path" "$patch_file" >&2
    exit 2
fi

reverse_output=$("$patch_command" "${patch_options[@]}" --dry-run -R -d "$source_path" < "$patch_file" 2>&1) || reverse_status=$?
forward_output=$("$patch_command" "${patch_options[@]}" --dry-run -d "$source_path" < "$patch_file" 2>&1) || forward_status=$?

if [[ $forward_status -eq 0 ]] && ! direction_matches_location "$source_path" "$patch_file" forward "$forward_output"; then forward_status=1; fi
if [[ $reverse_status -eq 0 ]] && ! direction_matches_location "$source_path" "$patch_file" reverse "$reverse_output"; then reverse_status=1; fi

if [[ $reverse_status -eq 0 && $forward_status -eq 1 ]]; then
    printf 'Reverting applied patch: source=%s patch=%s\n' "$source_path" "$patch_file"
    "$patch_command" "${patch_options[@]}" -R -d "$source_path" < "$patch_file"
elif [[ $forward_status -eq 0 && $reverse_status -eq 1 ]]; then
    printf 'Skipping unapplied patch: source=%s patch=%s\n' "$source_path" "$patch_file"
elif [[ $forward_status -eq 1 && $reverse_status -eq 1 ]] && confirm_unapplied_with_prerequisites; then
    printf 'Skipping unapplied patch: source=%s patch=%s\n' "$source_path" "$patch_file"
else
    printf 'Cannot classify revert state: source=%s patch=%s (reverse=%d forward=%d)\n' \
        "$source_path" "$patch_file" "$reverse_status" "$forward_status" >&2
    printf 'Reverse dry-run:\n%s\nForward dry-run:\n%s\n' "$reverse_output" "$forward_output" >&2
    exit 2
fi
