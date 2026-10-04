#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Place an application checkout at a recorded revision under a fixture run
# directory, as <RUN_DIR>/src, and print the canonical run directory. The
# fixture preparation scripts share this step.
#
#   checkout_application.bash --url URL --revision COMMIT [--source DIR] RUN_DIR
#
# Without --source the application is cloned into <RUN_DIR>/src unless a
# checkout is already there. With --source, <RUN_DIR>/src becomes a link to
# that existing checkout. In both cases the checkout must sit at the
# recorded revision and its tracked files must be unmodified, so the
# fixture runs the application's own files.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly CHECKOUT_NAME="src"

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit 1
}

function require_command {
    local name="$1"
    local path=""

    if ! path=$(command -v "${name}"); then
        die "Cannot find required command: ${name}"
    fi
    [[ -x "${path}" ]] || die "Required command is not executable: ${path}"
}

function main {
    local url=""
    local revision=""
    local source_dir=""
    local run_dir=""
    local checkout=""
    local head=""
    local resolved=""
    local -a positionals=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --url) [[ $# -ge 2 && -n "$2" ]] || die "Missing value for $1"; url="$2"; shift ;;
            --revision) [[ $# -ge 2 && -n "$2" ]] || die "Missing value for $1"; revision="$2"; shift ;;
            --source) [[ $# -ge 2 && -n "$2" ]] || die "Missing directory for $1"; source_dir="$2"; shift ;;
            -h|--help)
                printf 'Usage: %s --url URL --revision COMMIT [--source DIR] RUN_DIR\n' "${SCRIPT_NAME}"
                return 0
                ;;
            --) shift; positionals+=("$@"); break ;;
            -*) die "Unknown option: $1" ;;
            *) positionals+=("$1") ;;
        esac
        shift
    done
    [[ -n "${url}" && -n "${revision}" ]] || die "Specify --url and --revision"
    [[ ${#positionals[@]} -eq 1 ]] || die "Specify one run directory"
    require_command git
    require_command install
    require_command readlink

    if [[ -n "${source_dir}" ]]; then
        resolved=$(readlink -e -- "${source_dir}") || die "Cannot resolve the application checkout: ${source_dir}"
        source_dir="${resolved}"
    fi
    install -d "${positionals[0]}"
    run_dir=$(readlink -e -- "${positionals[0]}") || die "Cannot resolve the run directory: ${positionals[0]}"
    checkout="${run_dir}/${CHECKOUT_NAME}"

    if [[ -n "${source_dir}" ]]; then
        if [[ -e "${checkout}" && ! -L "${checkout}" ]]; then
            die "${checkout} already holds a checkout; use a new run directory for --source, or remove it first"
        fi
        rm -f "${checkout}"
        ln -s "${source_dir}" "${checkout}"
    elif [[ ! -e "${checkout}" ]]; then
        git clone --quiet "${url}" "${checkout}"
        git -C "${checkout}" checkout --quiet "${revision}"
    fi
    head=$(git -C "${checkout}" rev-parse HEAD) || die "Not a git checkout: ${checkout}"
    [[ "${head}" == "${revision}" ]] || die "Application checkout is at ${head}, not the recorded revision ${revision}"
    if ! git -C "${checkout}" diff --quiet HEAD --; then
        die "Application checkout has modified tracked files: ${checkout}; the fixture uses the application files unchanged"
    fi
    printf '%s\n' "${run_dir}"
}

main "$@"
