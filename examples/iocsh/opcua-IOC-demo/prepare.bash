#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Prepare the run directory of the opcua-IOC-demo loader fixture. The
# application is checked out at the recorded revision, its two substitution
# files are expanded with the installed msi against the application
# templates and the templates of the installed opcua module, as the
# application build does, and its plain database files are placed beside
# them. Nothing of the application is compiled.
#
#   prepare.bash [--source DIR] RUN_DIR
#
# Source the selected tree's setEpicsEnv.bash first so that msi and the
# installed opcua module are found.
# With --source, an existing checkout at the recorded revision is used
# instead of a new clone.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly APPLICATION_URL="https://github.com/jeonghanlee/opcua-IOC-demo"
readonly APPLICATION_REVISION="674c5735623703ad83f9c3fded479affa88871fa"
readonly DB_SOURCE="opcua-IOC-demoApp/Db"
readonly SUBSTITUTIONS="UaDemoServer-server Demo.WorkOrder"
readonly DATA_FILES="Demo.Dynamic.Arrays.db Demo.Dynamic.Scalar.db Demo.Static.Arrays.db Demo.Static.Scalar.db Demo.Dynamic.ArraysE7.db Demo.Dynamic.ScalarE7.db Demo.Static.ArraysE7.db Demo.Static.ScalarE7.db"
readonly MODULE_DB="opcua/db"

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
    local module_db=""
    local name=""
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

    [[ -n "${EPICS_MODULES:-}" ]] || die "Source setEpicsEnv.bash first: EPICS_MODULES is not set"
    module_db=$(readlink -e -- "${EPICS_MODULES}/${MODULE_DB}") || die "Cannot resolve the installed opcua templates: ${EPICS_MODULES}/${MODULE_DB}"
    install -d "${run_dir}" "${run_dir}/db"
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

    for name in ${SUBSTITUTIONS}; do
        msi -I "${run_dir}/src/${DB_SOURCE}" -I "${module_db}" -S "${run_dir}/src/${DB_SOURCE}/${name}.substitutions" -o "${run_dir}/db/${name}.db"
        [[ -s "${run_dir}/db/${name}.db" ]] || die "msi produced no database: ${run_dir}/db/${name}.db"
    done
    for file in ${DATA_FILES}; do
        install -m 644 "${run_dir}/src/${DB_SOURCE}/${file}" "${run_dir}/db/${file}"
    done
    printf 'OPCUA_IOC_DEMO_RUN=%s\n' "${run_dir}"
}

main "$@"
