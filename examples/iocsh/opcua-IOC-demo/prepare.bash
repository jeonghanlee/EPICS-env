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
# installed opcua module are found. With --source, an existing unmodified
# checkout at the recorded revision is used instead of a new clone.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly APPLICATION_URL="https://github.com/jeonghanlee/opcua-IOC-demo"
readonly APPLICATION_REVISION="674c5735623703ad83f9c3fded479affa88871fa"
readonly CHECKOUT_TOOL="../checkout_application.bash"
readonly DB_SOURCE="opcua-IOC-demoApp/Db"
readonly SUBSTITUTIONS="UaDemoServer-server Demo.WorkOrder"
readonly DATA_FILES="Demo.Dynamic.Arrays.db Demo.Dynamic.Scalar.db Demo.Static.Arrays.db Demo.Static.Scalar.db Demo.Dynamic.ArraysE7.db Demo.Dynamic.ScalarE7.db Demo.Static.ArraysE7.db Demo.Static.ScalarE7.db"
readonly MODULE_DB="opcua/db"

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit 1
}

function main {
    local fixture_dir="${BASH_SOURCE[0]%/*}"
    local run_dir=""
    local msi_path=""
    local module_db=""
    local name=""
    local file=""

    local argument=""

    [[ "${BASH_SOURCE[0]}" == */* ]] || fixture_dir="."
    for argument in "$@"; do
        if [[ "${argument}" == "-h" || "${argument}" == "--help" ]]; then
            printf 'Usage: %s [--source DIR] RUN_DIR\n' "${SCRIPT_NAME}"
            return 0
        fi
    done
    if ! msi_path=$(command -v msi); then
        die "Cannot find required command: msi; source the selected tree's setEpicsEnv.bash first"
    fi
    [[ -x "${msi_path}" ]] || die "Required command is not executable: ${msi_path}"
    [[ -n "${EPICS_MODULES:-}" ]] || die "Source setEpicsEnv.bash first: EPICS_MODULES is not set"
    module_db=$(readlink -e -- "${EPICS_MODULES}/${MODULE_DB}") || die "Cannot resolve the installed opcua templates: ${EPICS_MODULES}/${MODULE_DB}"
    run_dir=$(bash "${fixture_dir}/${CHECKOUT_TOOL}" --url "${APPLICATION_URL}" --revision "${APPLICATION_REVISION}" "$@")

    install -d "${run_dir}/db"
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
