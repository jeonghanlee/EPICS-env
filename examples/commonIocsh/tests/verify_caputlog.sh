#!/usr/bin/env bash
# Verify caPutLog (OPTION 0): value-change puts are logged, an unchanged put is
# not. Orchestrates an isolated log server, the example IOC (via caputlog-ioc.sh),
# and CA puts. caPutLog squashes bursts and flushes after a delay, so real-time
# waits are required. The example IOC must be built (examples/commonIocsh).

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh disable=SC1091
source "${SCRIPT_DIR}/common.sh"

EXAMPLE_TOP_DIR="$(dirname "${SCRIPT_DIR}")"
readonly EXAMPLE_TOP_DIR
readonly EX_IOC_BIN="${EXAMPLE_TOP_DIR}/bin/${ARCH}/commonIocshExample"
readonly CAPUT="${EPICS_BASE_DIR}/bin/${ARCH}/caput"
readonly LOGSRV="${EPICS_BASE_DIR}/bin/${ARCH}/iocLogServer"
readonly PREFIX="M6TEST:"
readonly PV="${PREFIX}Value"
readonly SETTLE=12
WORK="$(mktemp -d)"
readonly WORK
readonly RECV="${WORK}/received.log"
server_pid=""
ioc_pid=""

function cleanup {
    if [[ -n "${ioc_pid}" ]]; then kill "${ioc_pid}" 2>/dev/null || true; fi
    if [[ -n "${server_pid}" ]]; then kill "${server_pid}" 2>/dev/null || true; fi
    if [[ "${KEEP_WORKSPACE:-0}" != "1" ]]; then rm -rf "${WORK}"; fi
}
trap cleanup EXIT

function free_port {
    python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1]); s.close()'
}

# Poll a file for a pattern in real time (1 s steps, up to 30 s).
function wait_file {
    local file="$1" pattern="$2" i
    for i in $(seq 1 30); do
        if grep -q "${pattern}" "${file}" 2>/dev/null; then return 0; fi
        wait_seconds 1
        : "${i}"
    done
    return 1
}

function main {
    local ca_port log_port baseline after i

    if [[ ! -x "${EX_IOC_BIN}" ]]; then
        log_fail "example IOC not built: ${EX_IOC_BIN} (run: make -C ${EXAMPLE_TOP_DIR})"
        summary
        return
    fi
    log_info "caPutLog: orchestrating example IOC on isolated CA port"

    ca_port="$(free_port)"
    log_port="$(free_port)"

    unset EPICS_CA_ADDR_LIST EPICS_CAS_INTF_ADDR_LIST EPICS_CAS_BEACON_ADDR_LIST 2>/dev/null || true
    export EPICS_CA_AUTO_ADDR_LIST=NO
    export EPICS_CA_ADDR_LIST=127.0.0.1
    export EPICS_CA_SERVER_PORT="${ca_port}"
    export EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
    export EPICS_CAS_BEACON_ADDR_LIST=127.0.0.1
    export EPICS_CAS_AUTO_BEACON_ADDR_LIST=NO

    EPICS_IOC_LOG_FILE_NAME="${RECV}" EPICS_IOC_LOG_PORT="${log_port}" "${LOGSRV}" >"${WORK}/server.out" 2>&1 &
    server_pid=$!
    for i in $(seq 1 200); do
        if ss -ltn 2>/dev/null | grep -q ":${log_port} "; then break; fi
        : "${i}"
    done

    # Keep the IOC alive for the whole run by holding its stdin open.
    EX_IOC="${EX_IOC_BIN}" EXAMPLE_TOP="${EXAMPLE_TOP_DIR}" IOCSH_TOP="${IOCSH_TOP_DIR}/iocsh" \
        LOG_PORT="${log_port}" TEST_PREFIX="${PREFIX}" \
        bash "${SCRIPT_DIR}/caputlog-ioc.sh" >"${WORK}/ioc.log" 2>&1 < <(sleep 60) &
    ioc_pid=$!

    if ! wait_file "${WORK}/ioc.log" "caPutLog: successfully initialized"; then
        log_fail "caPutLog did not initialize"
        summary
        return
    fi

    "${CAPUT}" -w 10 "${PV}" 17 >/dev/null 2>&1 || true
    wait_seconds "${SETTLE}"
    kill -HUP "${server_pid}" 2>/dev/null || true
    if wait_file "${RECV}" "new=17.*old=0"; then
        log_pass "caPutLog logged value change 0 -> 17 (new=17 old=0)"
    else
        log_fail "caPutLog did not log first change"
    fi

    baseline="$(grep -c "${PV}" "${RECV}" 2>/dev/null || true)"
    "${CAPUT}" -w 5 "${PV}" 17 >/dev/null 2>&1 || true
    "${CAPUT}" -w 5 "${PV}" 29 >/dev/null 2>&1 || true
    wait_seconds "${SETTLE}"
    kill -HUP "${server_pid}" 2>/dev/null || true
    if wait_file "${RECV}" "new=29.*old=17"; then
        log_pass "caPutLog logged value change 17 -> 29 (new=29 old=17)"
    else
        log_fail "caPutLog did not log second change"
    fi

    after="$(grep -c "${PV}" "${RECV}" 2>/dev/null || true)"
    if [[ "$((after - baseline))" -eq 1 ]]; then
        log_pass "caPutLog OPTION 0 suppressed the unchanged put (only the 29 change logged)"
    else
        log_fail "caPutLog OPTION 0 count unexpected (baseline=${baseline} after=${after})"
    fi

    summary
}

main "$@"
