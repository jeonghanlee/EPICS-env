#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Prepare the run directory of the EPICS-IOC-Demo loader fixture: the
# application checked out at the recorded revision. Its database, protocol,
# and fragment are used from the checkout; nothing is compiled or generated.
#
#   prepare.bash [--source DIR] RUN_DIR
#
# With --source, an existing checkout at the recorded revision is used
# instead of a new clone.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly APPLICATION_URL="https://github.com/jeonghanlee/EPICS-IOC-Demo"
readonly APPLICATION_REVISION="e4198269aaa9d8c367446fd1d5afe8c371b4c039"
readonly REQUIRED_FILES="jeonglee-DemoApp/Db/training.db jeonglee-DemoApp/Db/training.proto jeonglee-DemoApp/iocsh/training_device.iocsh"

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
    require_command install
    require_command readlink

    install -d "${run_dir}"
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
    for file in ${REQUIRED_FILES}; do
        [[ -s "${run_dir}/src/${file}" ]] || die "Application file is missing: ${run_dir}/src/${file}"
    done
    printf 'EPICS_IOC_DEMO_RUN=%s\n' "${run_dir}"
}

main "$@"
