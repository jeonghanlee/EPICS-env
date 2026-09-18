#!/usr/bin/env bash
# Verify the linStat fragments: host/proc load by default, one NIC and one
# filesystem enabled via the aggregate linStat.iocsh; check records appear.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

WORK="$(mktemp -d)"
readonly WORK
readonly RECS="${WORK}/records.out"
trap 'rm -rf "${WORK}"' EXIT

function main {
    local startup group pat label

    log_info "linStat: enabling module and rebuilding"
    # shellcheck disable=SC2016
    write_release_local 'LINSTAT = $(MODULES)/linStat'
    rebuild_ioc

    startup="$(cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
epicsEnvSet("IOC","ioctestlab-tc32sim")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
iocshLoad("\$(IOCSH_TOP)/iocsh/linStat.iocsh","IOC=\$(IOC),NICENABLE=,NIC=lo,FSENABLE=,FSID=ROOT,DIR=/")
iocInit
dbl > ${RECS}
CMD
)"
    run_ioc "${startup}" "${WORK}/ioc.log"

    for group in "SYS_:host" "NET:HOST:host-net" "IOC_:proc" "NET:lo:nic" "ROOT::fs"; do
        pat="${group%:*}"
        label="${group##*:}"
        if grep -q "ioctestlab-tc32sim:${pat}" "${RECS}" 2>/dev/null; then
            log_pass "linStat ${label} records present (ioctestlab-tc32sim:${pat}*)"
        else
            log_fail "linStat ${label} records missing (ioctestlab-tc32sim:${pat}*)"
        fi
    done

    summary
}

main "$@"
