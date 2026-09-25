#!/usr/bin/env bash
# Run every commonIocsh verification script in order and report an overall result.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly -a SCRIPTS=(
    verify_linstat.sh
    verify_reccaster.sh
    verify_iocstatsadmin.sh
    verify_autosave.sh
    verify_ioclog.sh
    verify_serial.sh
    verify_caputlog.sh
    verify_integrated.sh
)

function main {
    local script overall=0 status

    for script in "${SCRIPTS[@]}"; do
        printf "%s\n" "==== ${script} ===="
        if bash "${SCRIPT_DIR}/${script}"; then
            status="PASS"
        else
            status="FAIL"
            overall=1
        fi
        printf "RESULT %s: %s\n\n" "${script}" "${status}"
    done

    printf "%s\n" "--------------------"
    if [[ "${overall}" -eq 0 ]]; then
        printf "%s\n" "OVERALL: PASS"
    else
        printf "%s\n" "OVERALL: FAIL"
    fi
    return "${overall}"
}

main "$@"
