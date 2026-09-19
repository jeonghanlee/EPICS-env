#!/usr/bin/env bash
# Verify the integrated (global-iocsh) path: load every common service in one
# IOC boot and confirm they coexist without duplicate initialization, macro
# cross-talk, or ordering errors. iocLog initializes before iocInit while
# autosave and caPutLog both register through afterIocRunning; a restart must
# still restore autosave, and omitted optional services must not be required.
#
# Prerequisites (via the common.sh environment contract): a built distribution
# (DIST_TOP), a tc32sim checkout (TC32SIM), the commonIocsh fragments
# (COMMONIOCSH), ARCH, and host tools socat, ss, and the Base iocLogServer.
# tc32sim must link the service modules (LINSTAT, RECCASTER, AUTOSAVE,
# devIocStats, CAPUTLOG); this script enables them in RELEASE.local and rebuilds.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "${SCRIPT_DIR}/common.sh"

readonly LOG_PORT=7013
AS1="$(mktemp -d)"
WORK="$(mktemp -d)"
readonly AS1 WORK
readonly RECS_A="${WORK}/records-a.out"
readonly RECS_C="${WORK}/records-c.out"
readonly LOGFILE="${WORK}/received.log"
readonly SERIAL_CFG="${WORK}/serial-config.iocsh"
readonly ACF="${WORK}/test.acf"
readonly TTY_A="${WORK}/ttyA"
readonly TTY_B="${WORK}/ttyB"
readonly SAV_PASS1="${AS1}/ioctestlab-tc32sim/save/values_pass1.sav"
server_pid=""
socat_pid=""

function cleanup {
    if [[ -n "${server_pid}" ]]; then
        kill "${server_pid}" 2>/dev/null || true
    fi
    if [[ -n "${socat_pid}" ]]; then
        kill "${socat_pid}" 2>/dev/null || true
    fi
    if [[ "${KEEP_WORKSPACE:-0}" == "1" ]]; then
        printf "KEEP_WORKSPACE=1: retaining %s and %s\n" "${AS1}" "${WORK}"
        return
    fi
    rm -rf "${AS1}" "${WORK}"
}
trap cleanup EXIT

# Busy-wait (no sleep) until the log server is listening, bounded.
function wait_listening {
    for _ in $(seq 1 200); do
        if ss -ltn 2>/dev/null | grep -q ":${LOG_PORT} "; then
            return 0
        fi
    done
    return 1
}

# Busy-wait until a path exists, bounded.
function wait_file {
    local path="$1"
    for _ in $(seq 1 200); do
        if [[ -e "${path}" ]]; then
            return 0
        fi
        wait_seconds 1
    done
    return 1
}

# Emit an aggregate startup with the co-loadable services; the argument is the
# tail run after iocInit, so the initial-save and restart-read boots share one
# body. iocStatsAdmin is excluded: its iocAdminSoft.db MEM_* records collide with
# linStat's under the same $(IOC): prefix, so the two are not co-loaded.
function startup_body {
    local tail="$1"
    cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
epicsEnvSet("IOC","ioctestlab-tc32sim")
epicsEnvSet("AS_TOP","${AS1}")
epicsEnvSet("DB_TOP","\$(TOP)/db")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
iocshLoad("\$(IOCSH_TOP)/iocsh/iocLog.iocsh","IOC=\$(IOC),LOG_INET=127.0.0.1,LOG_INET_PORT=${LOG_PORT}")
cd "\${TOP}/iocBoot/ioctestlab-tc32sim"
epicsEnvSet("PORT1","TCP001")
epicsEnvSet("P1","TC32:001:")
epicsEnvSet("TCPPORT1","9400")
iocshLoad("\$(IOCSH_LOCAL_TOP=\$(TOP)/iocsh)/tc32sim.iocsh","PORT=\$(PORT1),P=\$(P1),TCP_PORT=\$(TCPPORT1),DATABASE_TOP=\$(DB_TOP),PVX=")
drvAsynSerialPortConfigure("S1","${TTY_A}",0,0,0)
iocshLoad("\$(IOCSH_TOP)/iocsh/serial.iocsh","SERIAL_ENABLE=,SERIAL_CONFIG=${SERIAL_CFG}")
iocshLoad("\$(IOCSH_TOP)/iocsh/caPutLog.iocsh","LOG_INET=127.0.0.1,LOG_INET_PORT=${LOG_PORT}")
iocshLoad("\$(IOCSH_TOP)/iocsh/autosave.iocsh","IOC=\$(IOC),AS_TOP=\$(AS_TOP)")
iocshLoad("\$(IOCSH_TOP)/iocsh/reccaster.iocsh","IOC=\$(IOC)")
iocshLoad("\$(IOCSH_TOP)/iocsh/linStat.iocsh","IOC=\$(IOC),NICENABLE=,NIC=lo,FSENABLE=,FSID=ROOT,DIR=/")
asSetFilename("${ACF}")
iocInit
${tail}
CMD
}

# Initial boot: prove caPutLog is configured, then save the pass1 value set.
function startup_full {
    startup_body "epicsThreadSleep 3
caPutLogShow 2
manual_save(\"values_pass1.req\")
epicsThreadSleep 1
dbl > ${RECS_A}"
}

# Restart boot: no re-save; reboot restore of the saved set runs during iocInit.
function startup_restart {
    startup_body "epicsThreadSleep 2"
}

# Startup that boots only the default services (no NIC, no FS, no serial):
# optional configuration omitted must not be required.
function startup_minimal {
    cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
epicsEnvSet("IOC","ioctestlab-tc32sim")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
iocshLoad("\$(IOCSH_TOP)/iocsh/reccaster.iocsh","IOC=\$(IOC)")
iocshLoad("\$(IOCSH_TOP)/iocsh/linStat.iocsh","IOC=\$(IOC)")
iocInit
epicsThreadSleep 1
dbl > ${RECS_C}
CMD
}

function check_record {
    local recs="$1" pat="$2" label="$3"
    if grep -q "ioctestlab-tc32sim:${pat}" "${recs}" 2>/dev/null; then
        log_pass "aggregate ${label} records present (:${pat}*)"
    else
        log_fail "aggregate ${label} records missing (:${pat}*)"
    fi
}

function main {
    log_info "integrated: enabling all service modules and rebuilding"
    # shellcheck disable=SC2016
    write_release_local \
        'LINSTAT = $(MODULES)/linStat' \
        'RECCASTER = $(MODULES)/recsync' \
        'AUTOSAVE = $(MODULES)/autosave' \
        'devIocStats = $(MODULES)/iocStats' \
        'CAPUTLOG = $(MODULES)/caPutLog'
    rebuild_ioc

    # shellcheck disable=SC2016
    printf 'iocshLoad("$(IOCSH_TOP)/iocsh/setSerialParams.iocsh","PORT=S1,BAUD=19200,BITS=7,STOP=2,PARITY=odd")\n' \
        > "${SERIAL_CFG}"

    # caPutLog requires an access security policy with TRAPWRITE, which the IOC
    # owns; supply a minimal one so caPutLogInit succeeds in the aggregate boot.
    printf '%s\n' \
        'ASG(DEFAULT) {' \
        '    RULE(1, READ)' \
        '    RULE(1, WRITE, TRAPWRITE)' \
        '}' > "${ACF}"

    EPICS_IOC_LOG_FILE_NAME="${LOGFILE}" EPICS_IOC_LOG_PORT="${LOG_PORT}" \
        "${EPICS_BASE_DIR}/bin/${ARCH}/iocLogServer" >"${WORK}/server.out" 2>&1 &
    server_pid=$!
    if ! wait_listening; then
        log_fail "iocLogServer did not start listening on ${LOG_PORT}"
        summary
        return
    fi

    socat "pty,raw,echo=0,link=${TTY_A}" "pty,raw,echo=0,link=${TTY_B}" >"${WORK}/socat.out" 2>&1 &
    socat_pid=$!
    if ! wait_file "${TTY_A}"; then
        log_fail "socat PTY ${TTY_A} did not appear"
        summary
        return
    fi

    # Case A: all services in one boot.
    log_info "Case A: aggregate boot of all services"
    run_ioc "$(startup_full)" "${WORK}/ioc-a.log"
    kill -HUP "${server_pid}" 2>/dev/null || true

    check_record "${RECS_A}" "SYS_" "linStat host"
    check_record "${RECS_A}" "IOC_" "linStat proc"
    check_record "${RECS_A}" "NET:lo" "linStat nic"
    check_record "${RECS_A}" "ROOT:" "linStat fs"
    check_record "${RECS_A}" "State-Sts" "reccaster"

    if grep -q "iocRun: All initialization complete" "${WORK}/ioc-a.log" 2>/dev/null; then
        log_pass "aggregate iocInit completed with all services loaded"
    else
        log_fail "aggregate iocInit did not complete"
    fi

    # shellcheck disable=SC2016
    if grep -q '\$(' "${RECS_A}" 2>/dev/null; then
        log_fail "aggregate has unresolved macros in record names (cross-talk)"
    else
        log_pass "aggregate record names fully resolved (no macro cross-talk)"
    fi

    if grep -qiE "already exists|duplicate record" "${WORK}/ioc-a.log" 2>/dev/null; then
        log_fail "aggregate has duplicate record definitions across services"
    else
        log_pass "aggregate loaded with no duplicate record collisions across services"
    fi

    if grep -q "proc=ioctestlab-tc32sim" "${LOGFILE}" 2>/dev/null; then
        log_pass "iocLog boot errlog reached server alongside other services"
    else
        log_fail "iocLog boot errlog not received in aggregate boot"
    fi

    # caPutLog prints a clear success line; use it as the positive confirmation.
    # A negative "no error" check false-passes on a missing command and can
    # false-fail on output interleaved with an unrelated error line.
    if grep -q "caPutLog: successfully initialized" "${WORK}/ioc-a.log" 2>/dev/null; then
        log_pass "caPutLog initialized in aggregate (coexists with autosave afterIocRunning)"
    else
        log_fail "caPutLog did not report successful initialization in the aggregate boot"
    fi

    if [[ -s "${SAV_PASS1}" ]]; then
        log_pass "autosave afterIocRunning fired in aggregate (values_pass1.sav written)"
    else
        log_fail "autosave did not write values_pass1.sav in aggregate"
    fi

    # Case B: restart against the prior save; the restored value proves restore.
    log_info "Case B: restart with autosave restore"
    run_ioc "$(startup_restart)" "${WORK}/ioc-b.log"
    if grep -q "iocRun: All initialization complete" "${WORK}/ioc-b.log" 2>/dev/null \
        && grep -qE "values_pass1.sav: [0-9]+ of [0-9]+ PV" "${WORK}/ioc-b.log" 2>/dev/null \
        && ! grep -qE "Can't open file '.*values_pass1.sav'" "${WORK}/ioc-b.log" 2>/dev/null; then
        log_pass "restart restored autosave values_pass1 set and reloaded all services"
    else
        log_fail "restart did not restore autosave values_pass1 or failed to reload"
    fi

    # Case C: minimal boot, optional NIC/FS/serial omitted.
    log_info "Case C: minimal boot with optional services omitted"
    run_ioc "$(startup_minimal)" "${WORK}/ioc-c.log"
    if grep -q "iocRun: All initialization complete" "${WORK}/ioc-c.log" 2>/dev/null \
        && grep -q "ioctestlab-tc32sim:SYS_" "${RECS_C}" 2>/dev/null \
        && ! grep -q "ioctestlab-tc32sim:NET:lo" "${RECS_C}" 2>/dev/null \
        && ! grep -q "ioctestlab-tc32sim:ROOT:" "${RECS_C}" 2>/dev/null; then
        log_pass "minimal boot completed with optional NIC/FS/serial omitted"
    else
        log_fail "minimal boot failed or created optional records unexpectedly"
    fi

    summary
}

main "$@"
