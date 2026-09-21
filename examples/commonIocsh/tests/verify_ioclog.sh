#!/usr/bin/env bash
# Verify iocLog: with iocLogInit before iocInit, the boot errlog reaches the
# iocLogServer file. Base feature; no service module required.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh disable=SC1091
source "${SCRIPT_DIR}/common.sh"

readonly LOG_PORT=7011
WORK="$(mktemp -d)"
readonly WORK
readonly LOGFILE="${WORK}/received.log"
server_pid=""
trap 'if [[ -n "${server_pid}" ]]; then kill "${server_pid}" 2>/dev/null || true; fi; rm -rf "${WORK}"' EXIT

# Busy-wait (no sleep) until the log server is listening, bounded.
function wait_listening {
    for _ in $(seq 1 200); do
        if ss -ltn 2>/dev/null | grep -q ":${LOG_PORT} "; then
            return 0
        fi
    done
    return 1
}

function main {
    local startup

    log_info "iocLog: rebuilding (Base feature, no module macro)"
    write_release_local
    rebuild_ioc

    EPICS_IOC_LOG_FILE_NAME="${LOGFILE}" EPICS_IOC_LOG_PORT="${LOG_PORT}" \
        "${EPICS_BASE_DIR}/bin/${ARCH}/iocLogServer" >"${WORK}/server.out" 2>&1 &
    server_pid=$!

    if ! wait_listening; then
        log_fail "iocLogServer did not start listening on ${LOG_PORT}"
        summary
        return
    fi

    startup="$(cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
epicsEnvSet("IOC","ioctestlab-tc32sim")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
iocshLoad("\$(IOCSH_TOP)/iocsh/iocLog.iocsh","IOC=\$(IOC),LOG_INET=127.0.0.1,LOG_INET_PORT=${LOG_PORT}")
iocInit
epicsThreadSleep 5
CMD
)"
    run_ioc "${startup}" "${WORK}/ioc.log"
    kill -HUP "${server_pid}" 2>/dev/null || true

    if grep -q "proc=ioctestlab-tc32sim.*iocRun: All initialization complete" "${LOGFILE}" 2>/dev/null; then
        log_pass "iocLog boot errlog received at server (proc=ioctestlab-tc32sim)"
    else
        log_fail "iocLog boot errlog not found in server file"
        log_info "  connect line: $(grep -c 'connected to log server' "${WORK}/ioc.log" 2>/dev/null || echo 0)"
        log_info "  server file size: $(wc -c < "${LOGFILE}" 2>/dev/null || echo NA)"
    fi

    summary
}

main "$@"
