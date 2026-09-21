#!/usr/bin/env bash
# Verify the reccaster fragment: status records are created with the default
# timeout/holdoff. Full recceiver delivery needs an external service (skipped).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh disable=SC1091
source "${SCRIPT_DIR}/common.sh"

WORK="$(mktemp -d)"
readonly WORK
readonly RECS="${WORK}/records.out"
trap 'rm -rf "${WORK}"' EXIT

function main {
    local startup rec

    log_info "reccaster: enabling module and rebuilding"
    # shellcheck disable=SC2016
    write_release_local 'RECCASTER = $(MODULES)/recsync'
    rebuild_ioc

    startup="$(cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
epicsEnvSet("IOC","ioctestlab-tc32sim")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
iocshLoad("\$(IOCSH_TOP)/iocsh/reccaster.iocsh","IOC=\$(IOC)")
iocInit
dbl > ${RECS}
CMD
)"
    run_ioc "${startup}" "${WORK}/ioc.log"

    for rec in "State-Sts" "Msg-I"; do
        if grep -q "ioctestlab-tc32sim:${rec}" "${RECS}" 2>/dev/null; then
            log_pass "reccaster record present (ioctestlab-tc32sim:${rec})"
        else
            log_fail "reccaster record missing (ioctestlab-tc32sim:${rec})"
        fi
    done

    summary
}

main "$@"
