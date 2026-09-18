#!/usr/bin/env bash
# Verify serial software-path via socat PTYs: params applied on one port, omit
# skips, unreadable config errors, and multiple ports get independent settings.
# Physical baud/parity correctness is out of scope.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

WORK="$(mktemp -d)"
readonly WORK
readonly TTYA1="${WORK}/ttyA1"
readonly TTYB1="${WORK}/ttyB1"
readonly TTYA2="${WORK}/ttyA2"
readonly TTYB2="${WORK}/ttyB2"
readonly CFG1="${WORK}/serial-config-1.iocsh"
readonly CFG2="${WORK}/serial-config-2.iocsh"
socat_pid1=""
socat_pid2=""

function cleanup {
    if [[ -n "${socat_pid1}" ]]; then kill "${socat_pid1}" 2>/dev/null || true; fi
    if [[ -n "${socat_pid2}" ]]; then kill "${socat_pid2}" 2>/dev/null || true; fi
    rm -rf "${WORK}"
}
trap cleanup EXIT

function startup {
    # args: <serial.iocsh macros> [second-port-config-line]
    local macros="$1"
    local second="${2:-}"
    cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
drvAsynSerialPortConfigure("S1","${TTYA1}",0,0,0)
${second}
iocshLoad("\$(IOCSH_TOP)/iocsh/serial.iocsh","${macros}")
iocInit
epicsThreadSleep 1
CMD
}

function main {
    log_info "serial: rebuilding and starting virtual PTYs"
    write_release_local
    rebuild_ioc
    socat pty,raw,echo=0,link="${TTYA1}" pty,raw,echo=0,link="${TTYB1}" 2>/dev/null &
    socat_pid1=$!
    socat pty,raw,echo=0,link="${TTYA2}" pty,raw,echo=0,link="${TTYB2}" 2>/dev/null &
    socat_pid2=$!

    printf '%s\n' 'iocshLoad("$(IOCSH_TOP)/iocsh/setSerialParams.iocsh","PORT=S1,BAUD=19200,BITS=7,STOP=2,PARITY=odd")' > "${CFG1}"
    {
        printf '%s\n' 'iocshLoad("$(IOCSH_TOP)/iocsh/setSerialParams.iocsh","PORT=S1,BAUD=19200,BITS=7,STOP=2,PARITY=odd")'
        printf '%s\n' 'iocshLoad("$(IOCSH_TOP)/iocsh/setSerialParams.iocsh","PORT=S2,BAUD=115200,BITS=8,STOP=1,PARITY=even")'
    } > "${CFG2}"

    # applied (one port)
    run_ioc "$(startup "SERIAL_ENABLE=,SERIAL_CONFIG=${CFG1}")" "${WORK}/applied.log"
    if grep -q 'asynSetOption("S1", -1, "baud",   "19200")' "${WORK}/applied.log" 2>/dev/null; then
        log_pass "serial params applied via config (baud 19200 on S1)"
    else
        log_fail "serial params not applied"
    fi

    # omit (SERIAL_ENABLE unset -> skipped)
    run_ioc "$(startup "IOC=x")" "${WORK}/omit.log"
    if ! grep -q 'asynSetOption' "${WORK}/omit.log" 2>/dev/null; then
        log_pass "serial skipped when SERIAL_ENABLE unset"
    else
        log_fail "serial ran despite omit"
    fi

    # unreadable config -> iocshLoad error
    run_ioc "$(startup "SERIAL_ENABLE=,SERIAL_CONFIG=/no/such/serial.iocsh")" "${WORK}/unread.log"
    if grep -qi "Can't open /no/such/serial.iocsh" "${WORK}/unread.log" 2>/dev/null; then
        log_pass "serial unreadable config reports error"
    else
        log_fail "serial unreadable config did not error"
    fi

    # multiple ports -> independent settings, no cross-talk
    run_ioc "$(startup "SERIAL_ENABLE=,SERIAL_CONFIG=${CFG2}" 'drvAsynSerialPortConfigure("S2","'"${TTYA2}"'",0,0,0)')" "${WORK}/multi.log"
    if grep -q 'asynSetOption("S1", -1, "baud",   "19200")' "${WORK}/multi.log" 2>/dev/null \
       && grep -q 'asynSetOption("S2", -1, "baud",   "115200")' "${WORK}/multi.log" 2>/dev/null; then
        log_pass "serial multiple ports get independent settings (S1 19200, S2 115200)"
    else
        log_fail "serial multiple-port settings not independent"
    fi

    summary
}

main "$@"
