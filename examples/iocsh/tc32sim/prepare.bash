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
# With --source, an existing unmodified checkout at the recorded revision is
# used instead of a new clone.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly APPLICATION_URL="https://github.com/jeonghanlee/tc32sim"
readonly APPLICATION_REVISION="61645aeb78f9e7239a20397c918e2e74508cb9da"
readonly CHECKOUT_TOOL="../checkout_application.bash"
readonly DB_SOURCE="tc32simApp/Db"
readonly SUBSTITUTIONS="TC32-sim.substitutions"
readonly DATABASE="TC32-sim.db"
readonly DATA_FILES="tc32.proto tcmd_group.json"
readonly ACF_FILE="tc32sim.acf"

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit 1
}

function main {
    local fixture_dir="${BASH_SOURCE[0]%/*}"
    local run_dir=""
    local msi_path=""
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
    run_dir=$(bash "${fixture_dir}/${CHECKOUT_TOOL}" --url "${APPLICATION_URL}" --revision "${APPLICATION_REVISION}" "$@")

    # The installed autosave fragment passes its storage path to a shell
    # command unquoted, so the path must hold no whitespace.
    [[ "${run_dir}" != *[[:space:]]* ]] || die "Run directory path must not contain whitespace: ${run_dir}"
    install -d "${run_dir}/db" "${run_dir}/autosave"
    msi -I "${run_dir}/src/${DB_SOURCE}" -S "${run_dir}/src/${DB_SOURCE}/${SUBSTITUTIONS}" -o "${run_dir}/db/${DATABASE}"
    [[ -s "${run_dir}/db/${DATABASE}" ]] || die "msi produced no database: ${run_dir}/db/${DATABASE}"
    for file in ${DATA_FILES}; do
        install -m 644 "${run_dir}/src/${DB_SOURCE}/${file}" "${run_dir}/db/${file}"
    done
    install -m 644 "${fixture_dir}/${ACF_FILE}" "${run_dir}/${ACF_FILE}"
    printf 'TC32SIM_RUN=%s\n' "${run_dir}"
}

main "$@"
