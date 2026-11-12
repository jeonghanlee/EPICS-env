#!/usr/bin/env bash
# Verify caPutLog (OPTION 0): value-change puts are logged, an unchanged put is
# not. Orchestrates an isolated log server, an IOC started by the installed
# iocsh.bash loader (started and stopped by ioc-runner in local mode through
# iocsh-launch.sh), and CA puts. caPutLog squashes bursts and flushes after a
# delay, so real-time waits are required. No IOC is built.
#   IOC_RUNNER : ioc-runner executable (default: ioc-runner found in PATH)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh disable=SC1091
source "${SCRIPT_DIR}/common.sh"

EXAMPLE_TOP_DIR="$(dirname "${SCRIPT_DIR}")"
readonly EXAMPLE_TOP_DIR
readonly IOCSH_BIN="${EPICS_BASE_DIR}/bin/${ARCH}/iocsh.bash"
readonly CAPUT="${EPICS_BASE_DIR}/bin/${ARCH}/caput"
readonly LOGSRV="${EPICS_BASE_DIR}/bin/${ARCH}/iocLogServer"
readonly PREFIX="M6TEST:"
readonly PV="${PREFIX}Value"
readonly SETTLE=12
WORK="$(mktemp -d)"
readonly WORK
readonly RECV="${WORK}/received.log"
server_pid=""
ioc_name=""
ioc_log=""
runner=""

function cleanup {
    if [[ -n "${ioc_name}" ]]; then ioc_teardown "${WORK}/ioc.log"; fi
    if [[ -n "${server_pid}" ]]; then kill "${server_pid}" 2>/dev/null || true; fi
    if [[ "${KEEP_WORKSPACE:-0}" != "1" ]]; then common_iocsh_trash "${WORK}"; fi
}
trap cleanup EXIT

function free_port {
    perl -MIO::Socket::INET -e 'my $s = IO::Socket::INET->new(LocalAddr => "127.0.0.1", LocalPort => 0, Proto => "tcp", Listen => 1) or die "free port: $!\n"; print $s->sockport, "\n"'
}

# Run ioc-runner in local mode with the given arguments, output to the workspace.
function run_runner {
    "${runner}" --local "$@" >>"${WORK}/ioc-runner.out" 2>&1
}

# Install the IOC configuration of this run under a name only this run uses, then start the IOC.
# The configuration carries the launcher and the exported environment of the run.
# ioc-runner returns once the IOC reports initialization or after its own limit.
function ioc_start {
    local conf="${WORK}/${ioc_name}.conf" key value user group view
    user="$(id -un)"
    group="$(id -gn)"
    {
        printf 'IOC_USER="%s"\nIOC_GROUP="%s"\nIOC_CHDIR="%s"\nIOC_PORT=""\n' "${user}" "${group}" "${WORK}"
        printf 'IOC_CMD="%s"\n' "${SCRIPT_DIR}/iocsh-launch.sh"
        for key in DIST_TOP EXAMPLE_TOP IOCSH_TOP TEST_PREFIX CAPUTLOG_MACROS EPICS_CA_AUTO_ADDR_LIST EPICS_CA_ADDR_LIST \
            EPICS_CA_SERVER_PORT EPICS_CAS_INTF_ADDR_LIST EPICS_CAS_BEACON_ADDR_LIST EPICS_CAS_AUTO_BEACON_ADDR_LIST \
            EPICS_IOC_LOG_INET EPICS_IOC_LOG_PORT; do
            value="${!key}"
            printf '%s="%s"\n' "${key}" "${value}"
        done
    } >"${conf}"
    run_runner -f install "${conf}" || { log_fail "ioc-runner install failed"; return 1; }
    view="$("${runner}" --local view "${ioc_name}" 2>&1)" || true
    ioc_log="$(printf '%s\n' "${view}" | sed -n 's/.*--logfile=\([^ ]*\).*/\1/p' | head -n 1)"
    ioc_log="${ioc_log//%i/${ioc_name}}"
    [[ -n "${ioc_log}" ]] || { log_fail "ioc-runner view names no log file"; return 1; }
    run_runner start "${ioc_name}" || { log_fail "ioc-runner start failed"; return 1; }
    return 0
}

# Stop and remove the IOC, keeping its log at the given path first. It never fails.
function ioc_teardown {
    local keep="$1"
    run_runner stop "${ioc_name}" || true
    if [[ -n "${ioc_log}" && -f "${ioc_log}" ]]; then cp -- "${ioc_log}" "${keep}" || true; fi
    run_runner remove "${ioc_name}" || true
    ioc_name=""
    ioc_log=""
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
    local ca_port log_port baseline after i attempt

    if [[ ! -x "${IOCSH_BIN}" || ! -f "${DIST_TOP}/setEpicsEnv.bash" ]]; then
        log_fail "IOC shell not found: ${IOCSH_BIN} (set DIST_TOP to an installed tree)"
        summary
        return
    fi
    runner="${IOC_RUNNER:-$(command -v ioc-runner || true)}"
    if [[ -z "${runner}" || ! -x "${runner}" ]] || ! command -v procServ >/dev/null 2>&1; then
        log_fail "ioc-runner and procServ are required to start the IOC (set IOC_RUNNER or add ioc-runner to PATH)"
        summary
        return
    fi
    log_info "caPutLog: orchestrating IOC shell on isolated CA port"

    ca_port="${CAPUTLOG_CA_PORT:-$(free_port)}"
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

    # The CA port was free when it was chosen, but another process can take it before the IOC
    # binds it; the IOC then reports it and cannot start. Start again on a new port, keeping
    # the log of the failed start, and fail on any other cause at once.
    export DIST_TOP EXAMPLE_TOP="${EXAMPLE_TOP_DIR}" IOCSH_TOP="${IOCSH_TOP_DIR}" TEST_PREFIX="${PREFIX}"
    export CAPUTLOG_MACROS="LOG_INET=127.0.0.1,LOG_INET_PORT=${log_port},OPTION=0"
    export EPICS_IOC_LOG_INET="127.0.0.1" EPICS_IOC_LOG_PORT="${log_port}"
    for attempt in 1 2 3; do
        ioc_name="caputlog-$(od -An -N6 -tx1 /dev/urandom | tr -d ' \n')-sh"
        ioc_start || { summary; return; }
        if wait_file "${ioc_log}" "caPutLog: successfully initialized"; then
            break
        fi
        if [[ ${attempt} -lt 3 ]] && grep -q "CAS: No TCP server started" "${ioc_log}"; then
            ioc_teardown "${WORK}/ioc.log.attempt${attempt}"
            ca_port="$(free_port)"
            export EPICS_CA_SERVER_PORT="${ca_port}"
            continue
        fi
        log_fail "caPutLog did not initialize"
        summary
        return
    done

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
