#!/usr/bin/env bash
# opcua-IOC-demo fixture: the opcua-server-sim server, built from source at the
# recorded revisions, and the IOC startup and database of the simulator run
# through the installed iocsh.bash and the installed opcua module, following
# examples/iocsh/opcua-IOC-demo/README.md. The server uses TCP port 4840.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
F="${IOCSH_TEST_REPO}/examples/iocsh/opcua-IOC-demo"
RUN="${IOCSH_TEST_OUT}/fixture_opcua-$(date -u +%H%M%S)"
D="${IOCSH_TEST_OUT}/fixture_opcua"; iocsh_test_trash "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
OPC_PORT=4840
WAIT=30
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'run dir %s\n' "${RUN}"

# wait_eq SECONDS EXPECTED COMMAND...  succeeds when the command prints EXPECTED within SECONDS.
function wait_eq {
    local seconds="$1" expected="$2" i=0
    shift 2
    for ((i = 0; i < seconds * 4; i++)); do
        [[ "$("$@" 2>/dev/null)" == "${expected}" ]] && return 0
        iocsh_test_sleep 0.25
    done
    return 1
}
function cag { caget -t -w 3 "$@"; }
# Starts the server the way the simulator documents it and waits for its listen line.
function server_start {
    setsid bash "${SIM}/scripts/run-model.bash" --di "${DI}" "${SIM}/models/s7-1500-composite" > "${D}/server-$1.log" 2>&1 &
    SERVER=$!
    for ((i = 0; i < WAIT * 4; i++)); do
        grep -q "Creating listen socket.*port ${OPC_PORT}" "${D}/server-$1.log" 2>/dev/null && return 0
        kill -0 "${SERVER}" 2>/dev/null || return 1
        iocsh_test_sleep 0.25
    done
    return 1
}
function server_stop {
    kill -INT "${SERVER}" 2>/dev/null
    for ((i = 0; i < 40; i++)); do kill -0 "${SERVER}" 2>/dev/null || break; iocsh_test_sleep 0.25; done
    kill -0 "${SERVER}" 2>/dev/null && kill -KILL "${SERVER}" 2>/dev/null
    wait "${SERVER}" 2>/dev/null
}
function cleanup { [[ -z "${SERVER:-}" ]] || kill -KILL "${SERVER}" 2>/dev/null; }
trap cleanup EXIT

iocsh_test_section "prepare"
bash "${F}/prepare.bash" "${RUN}" > "${D}/prepare.out" 2>&1; ps=$?
printf 'prepare status %s\n' "${ps}"; tail -n 3 "${D}/prepare.out" | sed "s|${RUN}|<run>|g"
iocsh_test_check "prepare: exits 0" iocsh_test_eq "${ps}" 0
SIM="${RUN}/simulator/src"; ENVSRC="${RUN}/open62541-env/src"; PREFIX="$(readlink -e "${RUN}/open62541-1.5.10")"
DI="${ENVSRC}/open62541-src/deps/ua-nodeset/DI/Opc.Ua.Di.NodeSet2.xml"
iocsh_test_check "prepare: the simulator and open62541-env checkouts print their revisions" \
    iocsh_test_eq "$(grep -E '^(simulator|open62541-env)=' "${D}/prepare.out" | tr '\n' ' ')" \
    "simulator=$(git -C "${SIM}" rev-parse HEAD) open62541-env=$(git -C "${ENVSRC}" rev-parse HEAD) "
iocsh_test_check "prepare: both checkouts have no modified tracked file" bash -c "git -C '${SIM}' diff --quiet HEAD -- && git -C '${ENVSRC}' diff --quiet HEAD --"

iocsh_test_section "server"
iocsh_test_check "server: TCP port ${OPC_PORT} is free before the start" iocsh_test_eq "$(ss -ltn | awk -v p=":${OPC_PORT}\$" '$4 ~ p' | wc -l)" 0
server_start first; s=$?
iocsh_test_check "server: listens on port ${OPC_PORT}" iocsh_test_eq "${s}" 0
tail -n 2 "${D}/server-first.log" | cut -c1-160
iocsh_test_maps "${SERVER}" | grep libopen62541 | sed "s|${RUN}|<run>|" > "${D}/server.maps"; cat "${D}/server.maps"
iocsh_test_check "server: libopen62541 is mapped from the prefix of the run" \
    bash -c "grep -q '^${PREFIX}/lib/libopen62541.so\$' '${D}/server.maps' || grep -q '^<run>/open62541-1.5.10/lib/libopen62541.so\$' '${D}/server.maps'"
iocsh_test_check "server: the prefix of the run holds open62541 1.5.10" \
    iocsh_test_eq "$(sed -n 's/^#define UA_OPEN62541_VER_\(MAJOR\|MINOR\|PATCH\) //p' "${PREFIX}/include/open62541/config.h" | tr '\n' '.')" "1.5.10."

iocsh_test_section "first IOC session"
export SIM_IOC_DIR="${SIM}/ioc" SIM_OPC_PORT="${OPC_PORT}" SIM_SECURE_DIR="${RUN}/secure"
iocsh.bash -n "${SIM}/ioc/st.cmd" > "${D}/show" 2> "${D}/show.err"; printf 'show status %s\n' $?; cat "${D}/show.err"
iocsh_test_ioc_start sim "${D}/ioc-1.log" -v "${SIM}/ioc/st.cmd"; s=$?
pid="${IOCSH_TEST_IOC_PID[sim]}"
iocsh_test_check "startup: iocInit completed" iocsh_test_eq "${s}" 0
iocsh_test_maps "${pid}" | grep -E 'libopcua|libopen62541' > "${D}/ioc.maps"; sed "s|${EPICS_MODULES%/modules}/||" "${D}/ioc.maps"
VENDOR="${EPICS_MODULES%/modules}/vendor"
iocsh_test_check "startup: libopcua is mapped from the opcua module of the selected tree" bash -c "grep -q '/modules/opcua-[^/]*/lib/.*libopcua.so' '${D}/ioc.maps'"
iocsh_test_check "startup: the IOC maps libopen62541 1.3.15 from the vendor directory and not the server library" \
    bash -c "grep -q '^$(readlink -e "${VENDOR}")/lib/libopen62541.so.1.3.15' '${D}/ioc.maps' && ! grep -q '${PREFIX}' '${D}/ioc.maps'"
iocsh_test_check "startup: session OPC1 and session OPC2 connect" \
    bash -c "for i in \$(seq 1 120); do grep -aq 'OPC UA session OPC2: connected' '${D}/ioc-1.log' && break; sleep 0.25; done; grep -aq 'OPC UA session OPC1: connected' '${D}/ioc-1.log' && grep -aq 'OPC UA session OPC2: connected' '${D}/ioc-1.log'"
USER_NAME="$(grep -m 1 '^user[[:blank:]]' "${SIM}/models/s7-1500-composite/simulation.conf" | awk '{print $2}')"
iocsh_test_check "data path: session OPC2 is secured with the user of the simulation file" \
    bash -c "grep -aq \"session OPC2: connected as '${USER_NAME}' (username token) with security level [0-9]* (mode=SignAndEncrypt; policy=Basic256Sha256)\" '${D}/ioc-1.log'"

iocsh_test_section "data path: values of the model"
iocsh_test_check "data path: SIM:Mode shows RUN (8)" wait_eq 15 8 cag SIM:Mode
iocsh_test_check "data path: start values Bool true, Byte 171, Word 52719, Int 42" \
    iocsh_test_eq "$(cag SIM:Static:Bool SIM:Static:Byte SIM:Static:Word SIM:Static:Int | tr '\n' ' ')" "true 171 52719 42 "
iocsh_test_check "data path: structure member SIM:Udt:Int has its start value 42" iocsh_test_eq "$(cag SIM:Udt:Int)" 42
iocsh_test_check "data path: the array record holds 38 elements" iocsh_test_eq "$(cag SIM:Array:Int.NELM)" 38
iocsh_test_check "data path: SIM:Secure:Byte read over the secured session is 171" wait_eq 15 171 cag SIM:Secure:Byte
iocsh_test_check "startup: record uses OPCUA device support on I/O Intr" \
    iocsh_test_eq "$(cag SIM:Static:Int.DTYP SIM:Static:Int.SCAN | tr '\n' '|')" "OPCUA|I/O Intr|"
declare -A seen=()
end=$((SECONDS + 6))
while ((SECONDS < end)); do seen["$(cag SIM:Clock:Byte)"]=1; iocsh_test_sleep 0.2; done
printf 'distinct values of SIM:Clock:Byte in 6 s: %s\n' "${#seen[@]}"
iocsh_test_check "data path: subscription updates SIM:Clock:Byte to at least 3 distinct values in 6 s" test "${#seen[@]}" -ge 3
cag SIM:Static:Int.SEVR SIM:Static:Int.STAT | tr '\n' ' '; printf '\n'
iocsh_test_check "data path: SIM:Static:Int has no alarm" iocsh_test_eq "$(cag SIM:Static:Int.SEVR SIM:Static:Int.STAT | tr '\n' '|')" "NO_ALARM|NO_ALARM|"
iocsh_test_section "data path: server identity, timestamps, bounded read"
CONF="${SIM}/models/s7-1500-composite/server.json5"
EXPECT_URI="$(sed -n 's/^ *applicationUri: *"\(.*\)",.*/\1/p' "${CONF}" | head -n 1)"
EXPECT_NAME="$(awk '/applicationName: *\{/ {on = 1} on && /text:/ {sub(/^[^"]*"/, ""); sub(/".*$/, ""); print; exit}' "${CONF}")"
printf 'configured application name [%s] uri [%s]\n' "${EXPECT_NAME}" "${EXPECT_URI}"
iocsh_test_ioc_cmd sim 'opcuaShowSecurity OPC1'
for ((i = 0; i < 40; i++)); do grep -aq 'Server URI:' "${D}/ioc-1.log" && break; iocsh_test_sleep 0.25; done
iocsh_test_plain "${D}/ioc-1.log" | grep -a -E 'Server (Name|URI):' | head -n 2
function identity_ok {
    local plain
    plain="$(iocsh_test_plain "${D}/ioc-1.log")"
    [[ -n "${EXPECT_URI}" && -n "${EXPECT_NAME}" ]] || return 1
    grep -qF "Server Name: [en-US]\"${EXPECT_NAME}\"" <<< "${plain}" && grep -qF "Server URI:  ${EXPECT_URI}" <<< "${plain}"
}
iocsh_test_check "identity: the module reports the server name and URI that server.json5 configures" identity_ok
t1="$(caget -a SIM:Clock:Byte | awk '{print $2 " " $3}')"; iocsh_test_sleep 1.2; t2="$(caget -a SIM:Clock:Byte | awk '{print $2 " " $3}')"
printf 'timestamps of SIM:Clock:Byte: [%s] then [%s]\n' "${t1}" "${t2}"
iocsh_test_check "data path: the timestamp of SIM:Clock:Byte advances between two reads 1.2 s apart" bash -c "[[ -n '${t1}' && '${t1}' < '${t2}' ]]"
ms0=$(date +%s%N); value="$(cag SIM:Static:Int)"; ms1=$(date +%s%N); elapsed=$(((ms1 - ms0) / 1000000))
printf 'read of SIM:Static:Int gave %s in %s ms\n' "${value}" "${elapsed}"
iocsh_test_check "data path: a Channel Access read of SIM:Static:Int returns 42 within 2 s" bash -c "[[ '${value}' == 42 && ${elapsed} -lt 2000 ]]"
iocsh_test_ioc_stop sim
iocsh_test_plain "${D}/ioc-1.log" > "${D}/ioc-1.plain"
printf 'suspicious lines:\n'; iocsh_test_suspicious "${D}/ioc-1.log" | cut -c1-200 | sort -t: -k2 | uniq -c -f1 | head -n 12

iocsh_test_section "second IOC session without a server restart"
iocsh_test_ioc_start sim "${D}/ioc-2.log" -v "${SIM}/ioc/st.cmd"; s=$?
iocsh_test_check "restart: second iocInit completed" iocsh_test_eq "${s}" 0
iocsh_test_check "restart: the second session reads SIM:Mode 8" wait_eq 15 8 cag SIM:Mode
iocsh_test_check "restart: the second session has no alarm on SIM:Static:Int" \
    wait_eq 15 "NO_ALARM|NO_ALARM|" bash -c "caget -t -w 3 SIM:Static:Int.SEVR SIM:Static:Int.STAT | tr '\n' '|'"

iocsh_test_section "server stop and start with the IOC running"
server_stop
printf 'server stopped, status of the port: %s listeners\n' "$(ss -ltn | awk -v p=":${OPC_PORT}\$" '$4 ~ p' | wc -l)"
t0=$SECONDS
wait_eq 60 "INVALID|COMM|" bash -c "caget -t -w 3 SIM:Static:Int.SEVR SIM:Static:Int.STAT | tr '\n' '|'"; r=$?
printf 'after the server stop: INVALID and COMM reached %s (%s s)\n' "$([[ $r == 0 ]] && echo yes || echo no)" "$((SECONDS - t0))"
iocsh_test_check "server stop: SIM:Static:Int goes INVALID with COMM" iocsh_test_eq "${r}" 0
server_start second; s=$?
iocsh_test_check "server start: the server listens again" iocsh_test_eq "${s}" 0
t0=$SECONDS
iocsh_test_check "server start: SIM:Static:Int returns to no alarm within 60 s without an IOC restart" \
    wait_eq 60 "NO_ALARM|NO_ALARM|" bash -c "caget -t -w 3 SIM:Static:Int.SEVR SIM:Static:Int.STAT | tr '\n' '|'"
printf 'recovery after the server start took %s s\n' "$((SECONDS - t0))"
iocsh_test_check "server start: SIM:Mode and SIM:Static:Int have their values again" \
    wait_eq 30 "8|42|" bash -c "caget -t -w 3 SIM:Mode SIM:Static:Int | tr '\n' '|'"
iocsh_test_ioc_cmd sim 'dbl'
iocsh_test_ioc_stop sim
iocsh_test_plain "${D}/ioc-2.log" > "${D}/ioc-2.plain"
iocsh_test_check "second session: dbl lists the 14 records of the simulator database" \
    iocsh_test_eq "$(awk '/^dbl$/ {on = 1; next} on && /^SIM:/ {n++} on && !/^SIM:/ {exit} END {print n + 0}' "${D}/ioc-2.plain")" 14
printf 'suspicious lines:\n'; iocsh_test_suspicious "${D}/ioc-2.log" | cut -c1-200 | sort -t: -k2 | uniq -c -f1 | head -n 12
server_stop
iocsh_test_summary
