#!/usr/bin/env bash
# Sourced by verification tools. Moves test artifacts out of their active
# paths and retains them in unique UTC-stamped directories for manual cleanup.
# Each directory holds entry (the artifact) and source-path (its original path).
# Diagnostics go to stderr so command substitutions keep their data output.

function test_move_to_trash {
    local trash="${1:-}"
    local path=""
    local parent=""
    local name=""
    local bucket=""
    local stamp=""

    if [[ $# -lt 2 || -z ${trash} ]]; then
        printf 'test trash: expected a trash directory and at least one path\n' >&2
        return 1
    fi
    shift
    trash=$(readlink -m -- "${trash}") || return 1
    if [[ ${trash} == / ]]; then
        printf 'test trash: refusing the filesystem root as trash\n' >&2
        return 1
    fi
    for path in "$@"; do
        while [[ ${path} == */ && ${path} != / ]]; do path=${path%/}; done
        name=${path##*/}
        if [[ -z ${name} || ${name} == . || ${name} == .. ]]; then
            printf 'test trash: refusing unsafe path: %s\n' "${path}" >&2
            return 1
        fi
        [[ -e ${path} || -L ${path} ]] || continue
        parent=$(cd -P -- "$(dirname -- "${path}")" && pwd -P) || return 1
        path="${parent%/}/${name}"
        case ${trash}/ in
            "${path}/"*)
                printf 'test trash: destination lies inside source: %s -> %s\n' "${path}" "${trash}" >&2
                return 1
                ;;
        esac
        mkdir -p -- "${trash}" || return 1
        stamp=$(date -u +%Y%m%dT%H%M%SZ) || return 1
        bucket=$(mktemp -d "${trash}/${stamp}.XXXXXX") || return 1
        printf '%s\n' "${path}" > "${bucket}/source-path" || return 1
        if ! mv -T -- "${path}" "${bucket}/entry"; then
            printf 'test trash: move failed; retained source: %s\n' "${path}" >&2
            return 1
        fi
        printf 'test trash: %s -> %s\n' "${path}" "${bucket}/entry" >&2
    done
    return 0
}
