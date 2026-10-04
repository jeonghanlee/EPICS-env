#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Prepare the run directory of the EPICS-IOC-Demo loader fixture: the
# application checked out at the recorded revision. Its database, protocol,
# and fragment are used from the checkout; nothing is compiled or generated.
#
#   prepare.bash [--source DIR] RUN_DIR
#
# With --source, an existing unmodified checkout at the recorded revision is
# used instead of a new clone.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly APPLICATION_URL="https://github.com/jeonghanlee/EPICS-IOC-Demo"
readonly APPLICATION_REVISION="e4198269aaa9d8c367446fd1d5afe8c371b4c039"
readonly CHECKOUT_TOOL="../checkout_application.bash"
readonly REQUIRED_FILES="jeonglee-DemoApp/Db/training.db jeonglee-DemoApp/Db/training.proto jeonglee-DemoApp/iocsh/training_device.iocsh"

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit 1
}

function main {
    local fixture_dir="${BASH_SOURCE[0]%/*}"
    local run_dir=""
    local file=""

    local argument=""

    [[ "${BASH_SOURCE[0]}" == */* ]] || fixture_dir="."
    for argument in "$@"; do
        if [[ "${argument}" == "-h" || "${argument}" == "--help" ]]; then
            printf 'Usage: %s [--source DIR] RUN_DIR\n' "${SCRIPT_NAME}"
            return 0
        fi
    done
    run_dir=$(bash "${fixture_dir}/${CHECKOUT_TOOL}" --url "${APPLICATION_URL}" --revision "${APPLICATION_REVISION}" "$@")

    for file in ${REQUIRED_FILES}; do
        [[ -s "${run_dir}/src/${file}" ]] || die "Application file is missing: ${run_dir}/src/${file}"
    done
    printf 'EPICS_IOC_DEMO_RUN=%s\n' "${run_dir}"
}

main "$@"
