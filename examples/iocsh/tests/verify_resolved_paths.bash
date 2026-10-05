#!/usr/bin/env bash
# The default link changes between the wrapper's resolution and the
# native start. strace delays the wrapper's own execve of softIocPVX, the
# link is changed in that window, and the running IOC is inspected. Needs
# linStat 1.1.1 and 1.2.1 installed, with the alias at 1.2.1.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
D="${IOCSH_TEST_OUT}/resolved_paths"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
M="${EPICS_MODULES}"; A="${EPICS_HOST_ARCH}"
ST="${IOCSH_TEST_REPO}/examples/iocsh/st.cmd"
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; strace -V | head -n1
printf 'alias before: %s\n' "$(readlink "${M}/linStat")"
function restore { ln -sfn ./linStat-1.2.1 "${M}/linStat"; }
trap restore EXIT
iocsh_test_check "alias starts at 1.2.1 and 1.1.1 is installed" bash -c "[[ \"\$(readlink '${M}/linStat')\" == './linStat-1.2.1' && -s '${M}/linStat-1.1.1/cfg/iocsh.conf' ]]"

iocsh_test_section "change the default link between resolution and native start"
FIFO="${D}/in"; mkfifo "${FIFO}"
strace -o "${D}/trace" -e trace=execve -e inject=execve:delay_enter=6000000 bash "$(command -v iocsh.bash)" -v "${ST}" < "${FIFO}" > "${D}/ioc.log" 2>&1 &
SPID=$!
exec {FD}> "${FIFO}"
for _ in $(seq 1 200); do grep -q 'generated startup runs as /dev/fd/3' "${D}/ioc.log" && break; iocsh_test_sleep 0.1; done
grep -q 'generated startup runs as /dev/fd/3' "${D}/ioc.log" && printf 'wrapper finished its resolution at %s\n' "$(date -u +%H:%M:%S.%N | cut -c1-12)"
IOCPID=$(pgrep -P "${SPID}" | head -n1)
printf 'process %s is still [%s]\n' "${IOCPID}" "$(readlink "/proc/${IOCPID}/exe")"
iocsh_test_check "native executable has not started when the link changes" bash -c "[[ \"\$(readlink /proc/${IOCPID}/exe)\" == */bash ]] && ! grep -q 'softIocPVX.dbd' '${D}/ioc.log'"
ln -sfn ./linStat-1.1.1 "${M}/linStat"
printf 'alias changed to %s at %s\n' "$(readlink "${M}/linStat")" "$(date -u +%H:%M:%S.%N | cut -c1-12)"
for _ in $(seq 1 240); do grep -q -- "${IOCSH_TEST_READY_TEXT}" "${D}/ioc.log" && break; kill -0 "${SPID}" 2>/dev/null || break; iocsh_test_sleep 0.25; done
iocsh_test_check "iocInit completed" grep -q -- "${IOCSH_TEST_READY_TEXT}" "${D}/ioc.log"
printf 'process %s is now [%s]\n' "${IOCPID}" "$(readlink "/proc/${IOCPID}/exe")"
iocsh_test_maps "${IOCPID}" | grep -F '/modules/linStat' | sed "s|${M}/||" | tee "${D}/maps"
printf 'epicsEnvShow LINSTAT\nexit\n' >&"${FD}"; exec {FD}>&-; wait "${SPID}"
iocsh_test_plain "${D}/ioc.log" > "${D}/ioc.plain"
grep -E '^LINSTAT=' "${D}/ioc.plain" | sed "s|${M}/||"
grep -E '^(dlload|dbLoadDatabase|dbLoadRecords)' "${D}/ioc.plain" | grep -o 'linStat-[0-9.]*' | sort | uniq -c
iocsh_test_check "library mapping uses 1.2.1 only" iocsh_test_eq "$(cat "${D}/maps")" "linStat-1.2.1/lib/${A}/liblinStat.so"
iocsh_test_check "LINSTAT macro names 1.2.1" grep -q "^LINSTAT=${M}/linStat-1.2.1\$" "${D}/ioc.plain"
iocsh_test_check "every DBD and DB path names 1.2.1" iocsh_test_eq "$(grep -E '^(dlload|dbLoadDatabase|dbLoadRecords)' "${D}/ioc.plain" | grep -o 'linStat-[0-9.]*' | sort -u)" "linStat-1.2.1"
iocsh_test_check "no path goes through the unversioned link" bash -c "! grep -E '^(dlload|dbLoadDatabase|dbLoadRecords)' '${D}/ioc.plain' | grep -q '/modules/linStat/'"

iocsh_test_section "the next invocation sees the changed default"
iocsh.bash -n "${ST}" | grep -E '^# linStat|^dlload' | sed "s|${M}/||"
iocsh_test_check "show mode selects 1.1.1 now" bash -c "iocsh.bash -n '${ST}' | grep -q '^# linStat 1.1.1'"
iocsh_test_ioc_start nxt "${D}/next.log" "${ST}"; s=$?
iocsh_test_maps "${IOCSH_TEST_IOC_PID[nxt]}" | grep -F '/modules/linStat' | sed "s|${M}/||" > "${D}/next.maps"; iocsh_test_ioc_stop nxt
iocsh_test_check "real IOC maps 1.1.1 now" iocsh_test_eq "${s}:$(cat "${D}/next.maps")" "0:linStat-1.1.1/lib/${A}/liblinStat.so"

iocsh_test_section "broken links fail during preparation"
ln -sfn ./linStat-0.0.0 "${M}/linStat"
iocsh.bash -n "${ST}" > "${D}/broken.show" 2> "${D}/broken.err"; printf 'show status %s: ' $?; cat "${D}/broken.err"
iocsh.bash "${ST}" < /dev/null > "${D}/broken.run" 2>&1; sr=$?; printf 'real start status %s: ' "${sr}"; cat "${D}/broken.run"
iocsh_test_check "a broken default link is refused in both modes before launch" bash -c "grep -q 'Module linStat has a broken default link' '${D}/broken.err' && [[ ${sr} -eq 1 ]] && ! grep -q 'softIocPVX.dbd\|iocInit' '${D}/broken.run'"
printf 'module linStat 1.2.1\niocInit()\n' > "${D}/exact.cmd"
iocsh.bash -n "${D}/exact.cmd" > "${D}/exact.show" 2> "${D}/exact.err"; printf 'exact version with the broken default link: status %s ' $?; cat "${D}/exact.err"; grep '^# linStat' "${D}/exact.show"
rm -f "${M}/linStat"
iocsh.bash -n "${ST}" > /dev/null 2> "${D}/absent.err"; printf 'absent link status %s: ' $?; cat "${D}/absent.err"
iocsh_test_check "an absent default link is refused with the startup location" grep -q 'Module linStat has no installed default link: .* (st.cmd:13)' "${D}/absent.err"
restore; trap - EXIT
printf 'alias restored: %s\n' "$(readlink "${M}/linStat")"
iocsh_test_summary
