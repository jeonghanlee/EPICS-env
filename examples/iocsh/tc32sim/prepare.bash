#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Prepare the run directory of the tc32sim loader fixture. The application
# is checked out at the recorded revision, its database is expanded from the
# application's own substitution and template files with the installed msi,
# as the application build does, and the protocol and group definition are
# placed beside it. Nothing of the application is compiled.
#
#   prepare.bash [--source DIR] RUN_DIR
#
# Source the selected tree's setEpicsEnv.bash first so that msi is found.
# With --source, an existing checkout at the recorded revision is used
# instead of a new clone.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly APPLICATION_URL="https://github.com/jeonghanlee/tc32sim"
readonly APPLICATION_REVISION="61645aeb78f9e7239a20397c918e2e74508cb9da"
readonly DB_SOURCE="tc32simApp/Db"
readonly SUBSTITUTIONS="TC32-sim.substitutions"
readonly DATABASE="TC32-sim.db"
readonly DATA_FILES="tc32.proto tcmd_group.json"
readonly ACF_FILE="tc32sim.acf"

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
    local source_dir=""
    local run_dir=""
    local fixture_dir=""
    local head=""
    local file=""
    local -a positionals=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --source)
                [[ $# -ge 2 && -n "$2" ]] || die "Missing directory for --source"
                source_dir="$2"
                shift
                ;;
            -h|--help)
                printf 'Usage: %s [--source DIR] RUN_DIR\n' "${SCRIPT_NAME}"
                return 0
                ;;
            --) shift; positionals+=("$@"); break ;;
            -*) die "Unknown option: $1" ;;
            *) positionals+=("$1") ;;
        esac
        shift
    done
    [[ ${#positionals[@]} -eq 1 ]] || die "Specify one run directory"
    run_dir="${positionals[0]}"
    require_command git
    require_command msi
    require_command install
    require_command readlink

    fixture_dir="${BASH_SOURCE[0]%/*}"
    [[ "${BASH_SOURCE[0]}" == */* ]] || fixture_dir="."
    fixture_dir=$(readlink -e -- "${fixture_dir}") || die "Cannot resolve the fixture directory"
    install -d "${run_dir}" "${run_dir}/db" "${run_dir}/autosave"
    run_dir=$(readlink -e -- "${run_dir}") || die "Cannot resolve the run directory"

    if [[ -n "${source_dir}" ]]; then
        source_dir=$(readlink -e -- "${source_dir}") || die "Cannot resolve the application checkout: ${source_dir}"
        rm -f "${run_dir}/src"
        ln -s "${source_dir}" "${run_dir}/src"
    elif [[ ! -d "${run_dir}/src" ]]; then
        git clone --quiet "${APPLICATION_URL}" "${run_dir}/src"
        git -C "${run_dir}/src" checkout --quiet "${APPLICATION_REVISION}"
    fi
    head=$(git -C "${run_dir}/src" rev-parse HEAD) || die "Not a git checkout: ${run_dir}/src"
    [[ "${head}" == "${APPLICATION_REVISION}" ]] || die "Application checkout is at ${head}, not the recorded revision ${APPLICATION_REVISION}"

    msi -I "${run_dir}/src/${DB_SOURCE}" -S "${run_dir}/src/${DB_SOURCE}/${SUBSTITUTIONS}" -o "${run_dir}/db/${DATABASE}"
    [[ -s "${run_dir}/db/${DATABASE}" ]] || die "msi produced no database: ${run_dir}/db/${DATABASE}"
    for file in ${DATA_FILES}; do
        install -m 644 "${run_dir}/src/${DB_SOURCE}/${file}" "${run_dir}/db/${file}"
    done
    install -m 644 "${fixture_dir}/${ACF_FILE}" "${run_dir}/${ACF_FILE}"
    printf 'TC32SIM_RUN=%s\n' "${run_dir}"
}

main "$@"
