#!/usr/bin/env bash
# A copied candidate tree under a path with spaces, with the original
# tree and the build checkout renamed away and the installed .local files
# unreadable; the startup runs under strace.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/relocated_tree"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
cp "${IOCSH_TEST_REPO}/examples/iocsh/st.cmd" "${D}/st.cmd"
COPY=$(iocsh_test_copy_tree "${IOCSH_TEST_OUT}/copies/with space")
printf 'copy [%s]\n' "${COPY}"
find "${COPY}" -name '*.local*' -type f > "${D}/local-files"; printf '.local files in the copy: %s\n' "$(wc -l < "${D}/local-files")"
xargs -d '\n' -r chmod 000 < "${D}/local-files"

ORIG_TREE="${IOCSH_TEST_TREE}"; ORIG_REPO="${IOCSH_TEST_REPO}"
function restore {
    [[ ! -d "${ORIG_TREE}.off" ]] || mv "${ORIG_TREE}.off" "${ORIG_TREE}"
    [[ ! -d "${ORIG_REPO}.off" ]] || mv "${ORIG_REPO}.off" "${ORIG_REPO}"
    xargs -d '\n' -r chmod 644 < "${D}/local-files" 2>/dev/null
}
trap restore EXIT
mv "${ORIG_TREE}" "${ORIG_TREE}.off"; mv "${ORIG_REPO}" "${ORIG_REPO}.off"
printf 'original tree present: %s, build checkout present: %s\n' "$([[ -e "${ORIG_TREE}" ]] && echo yes || echo no)" "$([[ -e "${ORIG_REPO}" ]] && echo yes || echo no)"

iocsh_test_section "start from the copy under strace"
export IOCSH_TEST_TREE="${COPY}"
iocsh_test_env "${COPY}"
printf 'EPICS_BASE [%s]\nwrapper [%s]\n' "${EPICS_BASE}" "$(command -v iocsh.bash)"
export NIC; NIC=$(ip route show default | awk '{print $5; exit}')
FIFO="${D}/in"; mkfifo "${FIFO}"
strace -f -qq -o "${D}/trace" -e trace=%file,execve iocsh.bash "${D}/st.cmd" < "${FIFO}" > "${D}/ioc.log" 2>&1 &
SPID=$!
exec {FD}> "${FIFO}"
for _ in $(seq 1 240); do grep -q -- "${IOCSH_TEST_READY_TEXT}" "${D}/ioc.log" && break; kill -0 "${SPID}" 2>/dev/null || break; iocsh_test_sleep 0.25; done
iocsh_test_check "iocInit completed from the copy" grep -q -- "${IOCSH_TEST_READY_TEXT}" "${D}/ioc.log"
IOCPID=$(pgrep -f -n "${COPY}/modules/pvxs-[^/]*/bin/[^/]*/softIocPVX")
printf 'IOC pid %s exe [%s]\n' "${IOCPID}" "$(readlink "/proc/${IOCPID}/exe")"
iocsh_test_maps "${IOCPID}" > "${D}/maps"
printf 'mapped libraries under the copy: %s, under the original tree path: %s\n' "$(grep -c -F "${COPY}/" "${D}/maps")" "$(grep -c -F "${ORIG_TREE}/" "${D}/maps")"
iocsh_test_check "module and Base libraries are mapped from the copy only" bash -c "grep -q -F '${COPY}/modules/linStat' '${D}/maps' && ! grep -q -F '${ORIG_TREE}/' '${D}/maps'"
sleep 12
PVS=(EPICSENV:MEM_MAX EPICSENV:MEM_FREE EPICSENV:PROCESS_ID "EPICSENV:NET:${NIC}:NAME" "EPICSENV:NET:${NIC}:MTU" EPICSENV:ROOT:PATH EPICSENV:ROOT:SIZE)
caget -a "${PVS[@]}"; SEVR=(); for pv in "${PVS[@]}"; do SEVR+=("${pv}.SEVR"); done
iocsh_test_check "seven representative PVs read NO_ALARM" iocsh_test_eq "$(caget -t "${SEVR[@]}" | grep -c NO_ALARM)" 7
printf 'epicsEnvShow LINSTAT\nepicsEnvShow IOCSH_TOP\nexit\n' >&"${FD}"; exec {FD}>&-
wait "${SPID}"; printf 'traced run exit status %s\n' $?
iocsh_test_plain "${D}/ioc.log" | grep -E '^(LINSTAT|IOCSH_TOP)='
iocsh_test_check "LINSTAT and IOCSH_TOP point into the copy" iocsh_test_eq "$(iocsh_test_plain "${D}/ioc.log" | grep -E '^(LINSTAT|IOCSH_TOP)=' | grep -c -F "=${COPY}/modules/")" 2
restore; trap - EXIT

iocsh_test_section "trace analysis"
printf 'trace lines: %s\n' "$(wc -l < "${D}/trace")"
grep 'execve(' "${D}/trace" | grep -v ' = -1 ' | sed 's/.*execve("\([^"]*\)".*/\1/' | sort | uniq -c | sort -rn > "${D}/execs"; cat "${D}/execs"
iocsh_test_check "no make was executed" bash -c "! grep -q -E '/(g?make)\$' '${D}/execs'"
grep -F "${ORIG_TREE}/" "${D}/trace" > "${D}/orig-tree-refs"; grep -F "${ORIG_REPO}/" "${D}/trace" > "${D}/orig-repo-refs"
printf 'trace lines naming the original tree: %s (successful %s); the build checkout: %s (successful %s)\n' "$(wc -l < "${D}/orig-tree-refs")" "$(grep -c -v ' = -1 ' "${D}/orig-tree-refs")" "$(wc -l < "${D}/orig-repo-refs")" "$(grep -c -v ' = -1 ' "${D}/orig-repo-refs")"
head -n 5 "${D}/orig-tree-refs" | cut -c1-220
iocsh_test_check "no file of the original tree or the build checkout was reached" bash -c "! grep -v ' = -1 ' '${D}/orig-tree-refs' '${D}/orig-repo-refs' | grep -q ."
grep -E '\.local[^a-zA-Z/]' "${D}/trace" | grep -v '/\.local/' > "${D}/local-refs"; printf 'trace lines naming a .local file: %s\n' "$(wc -l < "${D}/local-refs")"; head -n 5 "${D}/local-refs" | cut -c1-200
iocsh_test_check "no .local file was read" bash -c "! grep -v ' = -1 ' '${D}/local-refs' | grep -q ."
printf 'successful file paths outside the copy, by top directory:\n'
grep -v ' = -1 ' "${D}/trace" | grep -o '"/[^"]*"' | tr -d '"' | grep -v -F "${COPY}" | awk -F/ '{print "/"$2}' | sort | uniq -c | sort -rn
printf 'successful paths outside the copy and outside system directories:\n'
grep -v ' = -1 ' "${D}/trace" | grep -o '"/[^"]*"' | tr -d '"' | grep -v -F "${COPY}" | grep -v -E '^/(usr|lib|lib64|etc|proc|dev|sys|bin|sbin|tmp|run|var)(/|$)|^/$' | sort -u | head -n 30
iocsh_test_summary
