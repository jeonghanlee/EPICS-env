#!/usr/bin/env bash
# Minimal example through the installed wrapper, the commonIocsh linStat
# fragment, real CA and PVA clients, and the process library maps.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
NIC_NAME=$(ip route show default | awk '{print $5; exit}')
export NIC="${NIC_NAME}"
ST="${IOCSH_TEST_REPO}/examples/iocsh/st.cmd"
LOG="${IOCSH_TEST_OUT}/minimal_example-ioc.log"
RUN="${IOCSH_TEST_OUT}/minimal_example-run"
mkdir -p "${RUN}"; cd "${RUN}" || exit 2

iocsh_test_section "context"
date -u +'%Y-%m-%dT%H:%M:%SZ'
printf 'tree %s\nrepo %s\nnic %s\n' "${IOCSH_TEST_TREE}" "${IOCSH_TEST_REPO}" "${NIC}"
printf 'wrapper %s\nsoftIocPVX %s\n' "$(command -v iocsh.bash)" "$(readlink -e "${EPICS_MODULES}/pvxs")"

iocsh_test_section "show mode"
iocsh.bash -n "${ST}"; printf 'show status %s\n' $?

iocsh_test_section "start (verbose)"
iocsh_test_ioc_start minimal_example "${LOG}" -v "${ST}"; printf 'start status %s pid %s\n' $? "${IOCSH_TEST_IOC_PID[minimal_example]}"
printf 'exe %s\ncwd %s\n' "$(readlink "/proc/${IOCSH_TEST_IOC_PID[minimal_example]}/exe")" "$(readlink "/proc/${IOCSH_TEST_IOC_PID[minimal_example]}/cwd")"

iocsh_test_section "module libraries mapped"
iocsh_test_maps "${IOCSH_TEST_IOC_PID[minimal_example]}" | grep -F "${IOCSH_TEST_TREE%/*/*/*}" || true

PVS=(EPICSENV:MEM_MAX EPICSENV:MEM_FREE EPICSENV:PROCESS_ID "EPICSENV:NET:${NIC}:NAME" "EPICSENV:NET:${NIC}:MTU" EPICSENV:ROOT:PATH EPICSENV:ROOT:SIZE)
SEVR=(); for pv in "${PVS[@]}"; do SEVR+=("${pv}.SEVR"); done
iocsh_test_section "first read, 12 s after iocInit"
sleep 12
date -u +'%H:%M:%SZ'; caget -a "${PVS[@]}"; printf 'caget status %s\n' $?
caget "${SEVR[@]}"
iocsh_test_section "second read, 11 s later"
sleep 11
date -u +'%H:%M:%SZ'; caget -a "${PVS[@]}"; printf 'caget status %s\n' $?
caget "${SEVR[@]}"
iocsh_test_section "PVA read"
pvxget EPICSENV:MEM_FREE; printf 'pvxget status %s\n' $?
iocsh_test_section "record inventory"
iocsh_test_ioc_cmd minimal_example "dbl" 
iocsh_test_ioc_stop minimal_example
iocsh_test_section "IOC log"
cat "${LOG}"
iocsh_test_section "counts"
PLAIN="${IOCSH_TEST_OUT}/minimal_example-ioc.plain"; iocsh_test_plain "${LOG}" > "${PLAIN}"
printf 'iocInit complete lines: %s\n' "$(grep -c -- "${IOCSH_TEST_READY_TEXT}" "${PLAIN}")"
printf 'registerAllRecordDeviceDrivers lines: %s\n' "$(grep -c 'registerAllRecordDeviceDrivers' "${PLAIN}")"
printf 'dlload lines: %s unique: %s\n' "$(grep -c '^dlload' "${PLAIN}")" "$(grep '^dlload' "${PLAIN}" | sort -u | wc -l)"
printf 'dbLoadDatabase lines: %s unique: %s\n' "$(grep -c '^dbLoadDatabase' "${PLAIN}")" "$(grep '^dbLoadDatabase' "${PLAIN}" | sort -u | wc -l)"
printf 'records listed: %s\n' "$(grep -c '^EPICSENV:' "${PLAIN}")"
iocsh_test_section "suspicious lines"
iocsh_test_suspicious "${LOG}"
