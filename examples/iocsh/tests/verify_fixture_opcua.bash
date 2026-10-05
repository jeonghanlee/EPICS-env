#!/usr/bin/env bash
# opcua-IOC-demo fixture: startup and data path, following
# examples/iocsh/opcua-IOC-demo/README.md. The original startup runs
# without its server; the Milo variant runs against the Eclipse Milo demo
# server in a container.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
F="${IOCSH_TEST_REPO}/examples/iocsh/opcua-IOC-demo"
RUN="${IOCSH_TEST_OUT}/fixture_opcua-$(date -u +%H%M%S)"
D="${IOCSH_TEST_OUT}/fixture_opcua"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
IMAGE="docker.io/digitalpetri/opc-ua-demo-server"
CT=$(command -v docker || command -v podman)
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'run dir %s\ncontainer tool %s\n' "${RUN}" "${CT}"

iocsh_test_section "prepare"
bash "${F}/prepare.bash" "${RUN}"; printf 'prepare status %s\n' $?
git -C "${RUN}/src" rev-parse HEAD
find "${RUN}/db" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort | tr '\n' ' '; printf '\n'
export OPCUA_IOC_DEMO_RUN="${RUN}"

iocsh_test_section "original startup without the Unified Automation server"
iocsh.bash -n "${F}/st.cmd" > "${D}/show" 2> "${D}/show.err"; printf 'show status %s\n' $?; cat "${D}/show.err"
grep -E '^# [A-Za-z]' "${D}/show" | grep -v 'iocsh.bash\|elf:'; grep '^# elf: vendor' "${D}/show"
iocsh_test_ioc_start ua "${D}/ioc-ua.log" -v "${F}/st.cmd"; s=$?
pid="${IOCSH_TEST_IOC_PID[ua]}"
iocsh_test_check "startup st.cmd: iocInit completed" iocsh_test_eq "${s}" 0
iocsh_test_maps "${pid}" | grep -E '/modules/|/vendor/' > "${D}/maps"; sed "s|${EPICS_MODULES%/modules}/||" "${D}/maps"
iocsh_test_check "startup st.cmd: opcua and the vendor open62541 library are mapped from the selected tree" bash -c "grep -q '/modules/opcua-[^/]*/lib/.*libopcua.so' '${D}/maps' && grep -q '${EPICS_MODULES%/modules}/vendor/.*libopen62541' '${D}/maps'"
sleep 3
caget OPC:DSS:bibool.DTYP OPC:DSS:bibool.SEVR OPC:DSS:bibool.STAT | tee "${D}/ua-state"
iocsh_test_check "startup st.cmd: record uses OPCUA device support" iocsh_test_eq "$(caget -t OPC:DSS:bibool.DTYP)" OPCUA
iocsh_test_check "data path st.cmd without server: INVALID and COMM" iocsh_test_eq "$(awk '{print $2}' "${D}/ua-state" | tr '\n' '|')" "OPCUA|INVALID|COMM|"
iocsh_test_ioc_cmd ua 'dbl'
iocsh_test_ioc_stop ua
iocsh_test_plain "${D}/ioc-ua.log" > "${D}/ioc-ua.plain"
printf 'records: %s\n' "$(sed -n '/> dbl/,/> exit/p' "${D}/ioc-ua.plain" | grep -c '^OPC:')"
grep -i -E 'OPC UA|opcua.*version|session OPC1' "${D}/ioc-ua.plain" | grep -v '^opcua\|^#' | sort | uniq -c | head -n 8
printf 'suspicious lines:\n'; iocsh_test_suspicious "${D}/ioc-ua.log" | cut -c1-200 | sort -t: -k2 | uniq -c -f1 | head -n 12

iocsh_test_section "Eclipse Milo demo server"
"${CT}" rm -f iocsh-milo > /dev/null 2>&1
"${CT}" run --rm -d --name iocsh-milo -p 127.0.0.1:4840:4840 "${IMAGE}" > "${D}/ct.id" 2> "${D}/ct.err"; printf 'container start status %s\n' $?; tail -n 2 "${D}/ct.err"
function cleanup { "${CT}" rm -f iocsh-milo > /dev/null 2>&1; }
trap cleanup EXIT
for i in $(seq 1 120); do "${CT}" logs iocsh-milo 2>&1 | grep -q 'started in' && break; sleep 1; done
printf 'server ready after %s s\n' "${i}"
"${CT}" logs iocsh-milo 2>&1 | grep 'started in' | head -n 3
"${CT}" image inspect "${IMAGE}" --format '{{index .RepoDigests 0}}' 2>&1 | head -n 1

iocsh_test_section "Milo variant, first session"
iocsh_test_ioc_start milo "${D}/ioc-milo.log" -v "${F}/st-milo.cmd"; s=$?
iocsh_test_check "startup st-milo.cmd: iocInit completed" iocsh_test_eq "${s}" 0
for i in $(seq 1 20); do grep -q "connected as" "${D}/ioc-milo.log" && break; sleep 1; done
grep -a 'session OPC1' "${D}/ioc-milo.log" | head -n 4
iocsh_test_check "data path Milo: session connected as Anonymous" grep -a -q "OPC UA session OPC1: connected as 'Anonymous'" "${D}/ioc-milo.log"
sleep 3
caget OPC:ProductName OPC:ServerState
caget OPC:MILO:DynamicDouble-RB.DTYP OPC:MILO:DynamicDouble-RB.SCAN
PVS=(OPC:CurrentTime OPC:MILO:DynamicDouble-RB OPC:MILO:DynamicFloat-RB OPC:MILO:DynamicInt32-RB)
caget -a "${PVS[@]}" | tee "${D}/m1"; sleep 2; caget -a "${PVS[@]}" | tee "${D}/m2"
caget OPC:MILO:DynamicDouble-RB.SEVR OPC:MILO:DynamicFloat-RB.SEVR OPC:MILO:DynamicInt32-RB.SEVR | tee "${D}/msevr"
iocsh_test_check "data path Milo: product name and state" iocsh_test_eq "$(caget -t OPC:ProductName)|$(caget -t OPC:ServerState)" "Eclipse Milo OPC UA Demo Server|Running"
iocsh_test_check "data path Milo: DTYP OPCUA and SCAN I/O Intr" iocsh_test_eq "$(caget -t OPC:MILO:DynamicDouble-RB.DTYP)|$(caget -t OPC:MILO:DynamicDouble-RB.SCAN)" "OPCUA|I/O Intr"
iocsh_test_check "data path Milo: three values without alarm" iocsh_test_eq "$(grep -c NO_ALARM "${D}/msevr")" 3
iocsh_test_check "data path Milo: four timestamps advanced between the reads" iocsh_test_eq "$(paste "${D}/m1" "${D}/m2" | awk -F'\t' '{split($1,a," "); split($2,b," "); if ((a[2]" "a[3]) < (b[2]" "b[3])) n++} END {print n+0}')" 4
iocsh_test_check "data path Milo: three values changed between the reads" iocsh_test_eq "$(paste "${D}/m1" "${D}/m2" | awk -F'\t' 'NR>1 {split($1,a," "); split($2,b," "); if (a[4] != b[4]) n++} END {print n+0}')" 3
( time -p caget OPC:MILO:DynamicDouble-RB ) 2>&1 | grep -E 'OPC|real'
iocsh_test_ioc_stop milo
printf 'suspicious lines:\n'; iocsh_test_suspicious "${D}/ioc-milo.log" | cut -c1-200 | head -n 12

iocsh_test_section "Milo variant, second session without a server restart"
iocsh_test_ioc_start milo "${D}/ioc-milo2.log" "${F}/st-milo.cmd"; s=$?
iocsh_test_check "startup second start: iocInit completed" iocsh_test_eq "${s}" 0
sleep 8
caget OPC:MILO:DynamicDouble-RB.SEVR OPC:MILO:DynamicDouble-RB.STAT | tee "${D}/m2state"
iocsh_test_check "documented behavior: second session leaves records INVALID with COMM" iocsh_test_eq "$(awk '{print $2}' "${D}/m2state" | tr '\n' '|')" "INVALID|COMM|"
grep -a -i 'BadNotImplemented\|session OPC1' "${D}/ioc-milo2.log" | sort | uniq -c | head -n 5
iocsh_test_ioc_stop milo
iocsh_test_summary
