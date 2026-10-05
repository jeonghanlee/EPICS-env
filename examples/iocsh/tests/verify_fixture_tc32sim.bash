#!/usr/bin/env bash
# tc32sim fixture: startup, data path, monitoring and retools,
# autosave restoration, and CA put logging, following
# examples/iocsh/tc32sim/README.md with its default ports.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
F="${IOCSH_TEST_REPO}/examples/iocsh/tc32sim"
RUN="${IOCSH_TEST_OUT}/fixture_tc32sim-$(date -u +%H%M%S)"
D="${IOCSH_TEST_OUT}/fixture_tc32sim"; rm -rf "${D}"; mkdir -p "${D}"
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'run dir %s\n' "${RUN}"

iocsh_test_section "prepare"
bash "${F}/prepare.bash" "${RUN}"; printf 'prepare status %s\n' $?
git -C "${RUN}/src" rev-parse HEAD
export TC32SIM_RUN="${RUN}"

iocsh_test_section "simulator and log receiver"
setsid bash "${RUN}/src/simulator/tc32_emulator.bash" --port 9400 > "${D}/emu.out" 2>&1 &
EMU=$!
EPICS_IOC_LOG_FILE_NAME="${RUN}/ioclog.txt" iocLogServer > "${D}/logserver.out" 2>&1 &
LOGPID=$!
for _ in $(seq 1 40); do grep -q 'Emulator running' "${D}/emu.out" && break; iocsh_test_sleep 0.25; done
tail -n 2 "${D}/emu.out"
function cleanup { kill -TERM -- "-${EMU}" 2>/dev/null; kill -TERM "${LOGPID}" 2>/dev/null; }
trap cleanup EXIT

iocsh_test_section "first start"
cd "${RUN}" || exit 2
iocsh.bash -n "${F}/st.cmd" > "${D}/show" 2> "${D}/show.err"; printf 'show status %s\n' $?; cat "${D}/show.err"
grep -E '^# [A-Za-z]' "${D}/show" | grep -v 'iocsh.bash\|elf:'
iocsh_test_ioc_start tc "${D}/ioc-1.log" -v "${F}/st.cmd"; s=$?
pid="${IOCSH_TEST_IOC_PID[tc]}"
iocsh_test_check "startup: iocInit completed" iocsh_test_eq "${s}" 0
printf 'exe %s\n' "$(readlink "/proc/${pid}/exe")"
iocsh_test_maps "${pid}" | grep -F '/modules/' > "${D}/maps"; sed "s|${EPICS_MODULES}/||" "${D}/maps"
grep '^dlload' "${D}/show" | sed 's/^dlload("\(.*\)")$/\1/' | xargs -r readlink -e | LC_ALL=C sort > "${D}/expected.libs"
grep -v '/pvxs-' "${D}/maps" | LC_ALL=C sort > "${D}/mapped.libs"
iocsh_test_check "startup: mapped module libraries equal the resolved metadata entries" diff "${D}/expected.libs" "${D}/mapped.libs"
sleep 10

iocsh_test_section "startup: record inventory"
names=(); for i in $(seq 0 31); do names+=("TC32:001:Ti${i}"); done
rt=$(for n in "${names[@]}"; do caget -t "${n}.RTYP" "${n}.DTYP" "${n}.SCAN" | tr '\n' '|'; echo; done | sort | uniq -c)
printf '%s\n' "${rt}"
iocsh_test_check "startup: 32 ai records with DTYP stream and SCAN I/O Intr" iocsh_test_eq "${rt}" "     32 ai|stream|I/O Intr|"

iocsh_test_section "data path: values, two reads 2 s apart"
caget -a "${names[@]}" > "${D}/read1"; s1=$?; sleep 2; caget -a "${names[@]}" > "${D}/read2"; s2=$?
head -n 3 "${D}/read1"; head -n 3 "${D}/read2"
iocsh_test_check "data path: both reads answered" test "${s1}" -eq 0 -a "${s2}" -eq 0
iocsh_test_check "data path: 32 values between 10 and 90" iocsh_test_eq "$(awk '$4 >= 10.0 && $4 <= 90.0' "${D}/read2" | wc -l)" 32
printf 'channels whose timestamp advanced within 2 s: %s of 32\n' "$(paste "${D}/read1" "${D}/read2" | awk -F'\t' '{split($1,a," "); split($2,b," "); if ((a[2]" "a[3]) < (b[2]" "b[3])) n++} END {print n+0}')"
timeout 30 camonitor "${names[@]}" > "${D}/camon-all" 2>&1
awk '{split($3,t,":"); s=t[1]*3600+t[2]*60+t[3]; n[$1]++; if ($1 in last) {g=s-last[$1]; if (g>max[$1]) max[$1]=g}; last[$1]=s}
     END {for (k in n) printf "%-16s updates %4d  largest gap %6.2f s\n", k, n[k], max[k]}' "${D}/camon-all" | sort -V > "${D}/gaps"
printf 'over 30 s: channels with at least 2 updates %s of 32, largest gap %s s, Ti0 largest gap %s s\n' "$(awk '$3 >= 2' "${D}/gaps" | wc -l)" "$(awk '{print $6}' "${D}/gaps" | sort -n | tail -n1)" "$(awk '$1=="TC32:001:Ti0"{print $6}' "${D}/gaps")"
iocsh_test_check "data path: README criterion: every channel updates at least twice in 30 s" iocsh_test_eq "$(awk '$3 >= 2' "${D}/gaps" | wc -l)" 32
printf 'alarm states in the second read:\n'; awk '{print $5 "-" $6}' "${D}/read2" | sort | uniq -c
iocsh_test_check "data path: no INVALID alarm" bash -c "! grep -q INVALID '${D}/read2'"
( time -p caget TC32:001:Ti0 ) 2>&1 | grep -E 'TC32|real'

iocsh_test_section "data path: PVA group and monitor"
pvget TC32:001:group > "${D}/group" 2>&1; printf 'pvget status %s\n' $?; head -n 12 "${D}/group"
iocsh_test_check "monitor: group holds tc32.model_number and ch00.temp" bash -c "grep -q 'model_number' '${D}/group' && grep -q 'ch00' '${D}/group' && grep -q 'temp' '${D}/group'"
timeout 4 camonitor TC32:001:Ti0 > "${D}/camon" 2>&1; printf 'camonitor updates in 4 s: %s\n' "$(wc -l < "${D}/camon")"
timeout 4 pvxmonitor TC32:001:Ti0 > "${D}/pvmon" 2>&1; printf 'pvxmonitor value lines in 4 s: %s\n' "$(grep -c 'value' "${D}/pvmon")"
iocsh_test_check "monitor: CA monitor delivers changing values" test "$(awk '{print $4}' "${D}/camon" | sort -u | wc -l)" -ge 2
iocsh_test_check "monitor: PVA monitor delivers updates" test "$(grep -c 'value' "${D}/pvmon")" -ge 2

iocsh_test_section "monitor: linStat, two reads 11 s apart"
LS=(ioctestlab-tc32sim:MEM_FREE ioctestlab-tc32sim:PROCESS_ID ioctestlab-tc32sim:NET:lo:MTU ioctestlab-tc32sim:ROOT:SIZE)
caget -a "${LS[@]}" | tee "${D}/ls1"; sleep 11; caget -a "${LS[@]}" | tee "${D}/ls2"
iocsh_test_check "monitor: four linStat PVs readable" iocsh_test_eq "$(wc -l < "${D}/ls2")" 4
iocsh_test_check "monitor: MEM_FREE timestamp advanced" test "$(awk 'NR==1{print $2" "$3}' "${D}/ls1")" \< "$(awk 'NR==1{print $2" "$3}' "${D}/ls2")"
iocsh_test_check "monitor: PROCESS_ID equals the IOC pid" iocsh_test_eq "$(caget -t -f0 ioctestlab-tc32sim:PROCESS_ID)" "${pid}"

iocsh_test_section "autosave and caPutLog: CA puts"
caget TC32:001:Ti0.HIGH TC32:001:Ti0Scale
caput TC32:001:Ti0.HIGH 47; caput TC32:001:Ti0Scale 2
SAVE="${RUN}/autosave/ioctestlab-tc32sim/save"
for i in $(seq 1 15); do
    grep -q 'Ti0.HIGH 47' "${SAVE}/settings.sav" 2>/dev/null && grep -q 'Ti0Scale.VAL 2' "${SAVE}/values_pass1.sav" 2>/dev/null && grep -q 'Ti0Scale' "${RUN}/ioclog.txt" 2>/dev/null && break
    sleep 1
done
printf 'waited %s s\n' "${i}"
find "${SAVE}" -mindepth 1 -maxdepth 1 -printf '%M %s %f\n' | sort -k3 | head -n 12
grep -h -E 'Ti0\.HIGH|Ti0Scale' "${SAVE}/settings.sav" "${SAVE}/values_pass1.sav"
iocsh_test_check "autosave: settings.sav holds TC32:001:Ti0.HIGH 47" grep -q '^TC32:001:Ti0.HIGH 47$' "${SAVE}/settings.sav"
iocsh_test_check "autosave: values_pass1.sav holds TC32:001:Ti0Scale.VAL 2" grep -q '^TC32:001:Ti0Scale.VAL 2$' "${SAVE}/values_pass1.sav"
caget ioctestlab-tc32sim-as:SR_status ioctestlab-tc32sim-as:SR_0_Name ioctestlab-tc32sim-as:SR_0_Status ioctestlab-tc32sim-as:SR_0_StatusStr | tee "${D}/sr"
caget ioctestlab-tc32sim-as:SR_2_Name ioctestlab-tc32sim-as:SR_2_Status ioctestlab-tc32sim-as:SR_2_StatusStr ioctestlab-tc32sim-as:SR_2_Time | tee -a "${D}/sr"
iocsh_test_check "autosave: autosave status records report Ok for the settings and pass1 sets" iocsh_test_eq "$(grep -c '_Status  *Ok' "${D}/sr")" 2
printf 'ioclog.txt:\n'; cat "${RUN}/ioclog.txt"
iocsh_test_check "caPutLog: log names Ti0.HIGH with new=47" bash -c "grep 'TC32:001:Ti0.HIGH' '${RUN}/ioclog.txt' | grep -q 'new=47'"
iocsh_test_check "caPutLog: log names Ti0Scale with new= and old=" bash -c "grep 'TC32:001:Ti0Scale' '${RUN}/ioclog.txt' | grep 'new=' | grep -q 'old='"

iocsh_test_section "stop and restart with the same run directory"
iocsh_test_ioc_stop tc
iocsh_test_plain "${D}/ioc-1.log" > "${D}/ioc-1.plain"
iocsh_test_check "monitor: reGrep printed TC32:001:Ti0 after iocInit" bash -c "sed -n '/^reGrep/,/^dbl/p' '${D}/ioc-1.plain' | grep -q '^TC32:001:Ti0\$'"
sed -n '/^reGrep/,/^dbl/p' "${D}/ioc-1.plain"
iocsh_test_check "startup: dlload lines are unique" iocsh_test_eq "$(grep -c '^dlload' "${D}/ioc-1.plain")" "$(grep '^dlload' "${D}/ioc-1.plain" | sort -u | wc -l)"
iocsh_test_check "startup: one registration call by the wrapper" iocsh_test_eq "$(grep -c '^registerAllRecordDeviceDrivers' "${D}/ioc-1.plain")" 1
printf 'suspicious lines of the first start:\n'; iocsh_test_suspicious "${D}/ioc-1.log" | head -n 20
printf 'record list file: %s lines\n' "$(wc -l < "${RUN}/testlab-tc32sim")"
iocsh_test_ioc_start tc "${D}/ioc-2.log" "${F}/st.cmd"; s=$?
iocsh_test_check "autosave: second iocInit completed" iocsh_test_eq "${s}" 0
sleep 3
caget TC32:001:Ti0.HIGH TC32:001:Ti0Scale
iocsh_test_check "autosave: Ti0.HIGH restored to 47" iocsh_test_eq "$(caget -t TC32:001:Ti0.HIGH)" 47
iocsh_test_check "autosave: Ti0Scale restored to Kelvin" iocsh_test_eq "$(caget -t TC32:001:Ti0Scale)" Kelvin
iocsh_test_ioc_stop tc
grep -i -E 'restore|\.sav' "${D}/ioc-2.log" | head -n 8
printf 'suspicious lines of the second start:\n'; iocsh_test_suspicious "${D}/ioc-2.log" | head -n 20
iocsh_test_summary
