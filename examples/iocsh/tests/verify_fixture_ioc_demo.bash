#!/usr/bin/env bash
# EPICS-IOC-Demo fixture: startup and data path, following
# examples/iocsh/EPICS-IOC-Demo/README.md with its default port.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
F="${IOCSH_TEST_REPO}/examples/iocsh/EPICS-IOC-Demo"
RUN="${IOCSH_TEST_OUT}/fixture_ioc_demo-$(date -u +%H%M%S)"
D="${IOCSH_TEST_OUT}/fixture_ioc_demo"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'run dir %s\n' "${RUN}"

iocsh_test_section "prepare"
bash "${F}/prepare.bash" "${RUN}"; printf 'prepare status %s\n' $?
git -C "${RUN}/src" rev-parse HEAD
export EPICS_IOC_DEMO_RUN="${RUN}"

iocsh_test_section "simulator"
setsid bash "${RUN}/src/simulator/tcpserver.bash" 9399 > "${D}/emu.out" 2>&1 &
EMU=$!
function cleanup { kill -TERM -- "-${EMU}" 2>/dev/null; }
trap cleanup EXIT
for _ in $(seq 1 20); do ss -ltn | grep -q ':9399 ' && break; iocsh_test_sleep 0.25; done
cat "${D}/emu.out"; ss -ltn | grep ':9399 '

iocsh_test_section "start with the simulator"
iocsh.bash -n "${F}/st.cmd" > "${D}/show" 2> "${D}/show.err"; printf 'show status %s\n' $?; cat "${D}/show.err"
grep -E '^# [A-Za-z]' "${D}/show" | grep -v 'iocsh.bash\|elf:'
iocsh_test_ioc_start demo "${D}/ioc-1.log" -v "${F}/st.cmd"; s=$?
pid="${IOCSH_TEST_IOC_PID[demo]}"
iocsh_test_check "startup: iocInit completed" iocsh_test_eq "${s}" 0
iocsh_test_maps "${pid}" | grep -F '/modules/' > "${D}/maps"; sed "s|${EPICS_MODULES}/||" "${D}/maps"
grep '^dlload' "${D}/show" | sed 's/^dlload("\(.*\)")$/\1/' | xargs -r readlink -e | LC_ALL=C sort > "${D}/expected.libs"
grep -v '/pvxs-' "${D}/maps" | LC_ALL=C sort > "${D}/mapped.libs"
iocsh_test_check "startup: mapped module libraries equal the resolved metadata entries" diff "${D}/expected.libs" "${D}/mapped.libs"
sleep 2
caget jeonglee:myoffice:Cmd.RTYP jeonglee:myoffice:Cmd.DTYP jeonglee:myoffice:Cmd-RB.RTYP jeonglee:myoffice:Cmd-RB.DTYP | tee "${D}/types"
iocsh_test_check "startup: record and device types" iocsh_test_eq "$(awk '{print $2, $3}' "${D}/types" | tr '\n' '|')" "stringout |stream |stringin |Soft Channel|"
caget -a jeonglee:myoffice:Cmd-RB | tee "${D}/rb-initial"
caput jeonglee:myoffice:Cmd "first text"; printf 'caput status %s\n' $?
sleep 2
caget -a jeonglee:myoffice:Cmd-RB | tee "${D}/rb0"
TEXT="hello loader $(date -u +%H%M%S)"
caput jeonglee:myoffice:Cmd "${TEXT}"; printf 'caput status %s\n' $?
sleep 2
caget -a jeonglee:myoffice:Cmd-RB | tee "${D}/rb1"
caget jeonglee:myoffice:Cmd-RB.SEVR jeonglee:myoffice:Cmd.SEVR
iocsh_test_check "data path: readback holds the written text within 2 s" iocsh_test_eq "$(caget -t jeonglee:myoffice:Cmd-RB)" "${TEXT}"
iocsh_test_check "data path: readback timestamp is newer than after the first write" test "$(awk '{print $2" "$3}' "${D}/rb0")" \< "$(awk '{print $2" "$3}' "${D}/rb1")"
iocsh_test_check "data path: readback has no alarm" iocsh_test_eq "$(caget -t jeonglee:myoffice:Cmd-RB.SEVR)" NO_ALARM
pvxget jeonglee:myoffice:Cmd-RB | grep -E 'value|severity'
iocsh_test_ioc_cmd demo 'dbl'
iocsh_test_ioc_stop demo
iocsh_test_plain "${D}/ioc-1.log" > "${D}/ioc-1.plain"
printf 'records: %s\n' "$(sed -n '/> dbl/,/> exit/p' "${D}/ioc-1.plain" | grep -c '^jeonglee')"
iocsh_test_check "startup: dlload lines are unique" iocsh_test_eq "$(grep -c '^dlload' "${D}/ioc-1.plain")" "$(grep '^dlload' "${D}/ioc-1.plain" | sort -u | wc -l)"
printf 'suspicious lines:\n'; iocsh_test_suspicious "${D}/ioc-1.log" | head -n 20

iocsh_test_section "offline: simulator stopped, IOC started anew"
cleanup; sleep 1; ss -ltn | grep ':9399 ' || printf 'port 9399 closed\n'
iocsh_test_ioc_start demo "${D}/ioc-2.log" "${F}/st.cmd"; s=$?
iocsh_test_check "startup: iocInit completed without the simulator" iocsh_test_eq "${s}" 0
sleep 2
caput jeonglee:myoffice:Cmd "offline text" > "${D}/offput" 2>&1; printf 'caput status %s\n' $?; cat "${D}/offput"
sleep 2
caget jeonglee:myoffice:Cmd.SEVR jeonglee:myoffice:Cmd.STAT jeonglee:myoffice:Cmd-RB.SEVR jeonglee:myoffice:Cmd-RB.STAT | tee "${D}/offstate"
iocsh_test_check "data path: offline caput reports a failed write" grep -q 'Channel write request failed' "${D}/offput"
iocsh_test_check "data path: offline Cmd is INVALID with COMM, Cmd-RB stays UDF" iocsh_test_eq "$(awk '{print $2}' "${D}/offstate" | tr '\n' '|')" "INVALID|COMM|INVALID|UDF|"
iocsh_test_ioc_stop demo
printf 'suspicious lines:\n'; iocsh_test_suspicious "${D}/ioc-2.log" | head -n 20
iocsh_test_summary
