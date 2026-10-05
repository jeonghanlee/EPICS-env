#!/usr/bin/env bash
# Setup, repeated setup, tree switching, reset, inherited and explicit
# selection, terminal ownership, signals, exit status, working directory,
# and a native startup error.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/shell_lifecycle"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
TREE1="${IOCSH_TEST_TREE}"
TREE2=$(iocsh_test_copy_tree "${IOCSH_TEST_OUT}/copies/tree2")
printf 'second tree %s\n' "${TREE2}"
ARCH=linux-x86_64
ST="${IOCSH_TEST_REPO}/examples/iocsh/st.cmd"
export TREE1 TREE2 ARCH ST

iocsh_test_section "setup, repeated setup, switch, reset in fresh shells"
for mode in '+u' '-u'; do
    iocsh_test_clean_shell -c "
        set ${mode}
        source \"\${TREE1}/setEpicsEnv.bash\" > /dev/null
        source \"\${TREE1}/setEpicsEnv.bash\" > /dev/null
        printf 'A1 %s\n' \"\$(command -v iocsh.bash)\"
        printf 'A2 %s\n' \"\$(command -v softIocPVX)\"
        printf 'A3 base-bin entries %s\n' \"\$(tr ':' '\n' <<< \"\${PATH}\" | grep -c -x \"\${TREE1}/base/bin/\${ARCH}\")\"
        source \"\${TREE2}/setEpicsEnv.bash\" > /dev/null
        printf 'B1 %s\n' \"\$(command -v iocsh.bash)\"
        printf 'B2 %s\n' \"\$(command -v softIocPVX)\"
        printf 'B3 tree1 entries left in PATH %s\n' \"\$(tr ':' '\n' <<< \"\${PATH}\" | grep -c \"^\${TREE1}/\")\"
        printf 'B4 EPICS_BASE %s\n' \"\${EPICS_BASE}\"
        source \"\${TREE2}/resetEpicsEnv.bash\" > /dev/null
        printf 'C1 wrapper after reset [%s]\n' \"\$(command -v iocsh.bash)\"
        printf 'C2 tree entries left in PATH %s\n' \"\$(tr ':' '\n' <<< \"\${PATH}\" | grep -c -e \"^\${TREE1}/\" -e \"^\${TREE2}/\")\"
        printf 'C3 EPICS_BASE [%s]\n' \"\${EPICS_BASE-unset}\"
        printf 'C4 shell alive, nounset mode ${mode}\n'
    " > "${D}/env${mode}.out" 2>&1
    printf 'mode %s exit %s\n' "${mode}" $?; cat "${D}/env${mode}.out"
    iocsh_test_check "set ${mode}: wrapper comes from tree 1 after setup" grep -q -x "A1 ${TREE1}/base/bin/${ARCH}/iocsh.bash" "${D}/env${mode}.out"
    iocsh_test_check "set ${mode}: repeated setup keeps one base entry" grep -q -x 'A3 base-bin entries 1' "${D}/env${mode}.out"
    iocsh_test_check "set ${mode}: wrapper and softIocPVX come from tree 2 after the switch" bash -c "grep -q -x 'B1 ${TREE2}/base/bin/${ARCH}/iocsh.bash' '${D}/env${mode}.out' && grep -q 'B2 ${TREE2}/modules/' '${D}/env${mode}.out' && grep -q -x 'B3 tree1 entries left in PATH 0' '${D}/env${mode}.out'"
    iocsh_test_check "set ${mode}: reset removes the wrapper path and the shell survives" bash -c "grep -q -x 'C1 wrapper after reset \[\]' '${D}/env${mode}.out' && grep -q -x 'C2 tree entries left in PATH 0' '${D}/env${mode}.out' && grep -q 'C4 shell alive' '${D}/env${mode}.out'"
done

iocsh_test_section "inherited and explicit selection"
iocsh_test_clean_shell -c "source \"\${TREE1}/setEpicsEnv.bash\" > /dev/null; iocsh.bash -n \"\${ST}\"" > "${D}/sel-inherit" 2>&1; printf 'inherited status %s\n' $?
iocsh_test_clean_shell -c "\"\${TREE1}/base/bin/\${ARCH}/iocsh.bash\" -e \"\${TREE2}\" -n \"\${ST}\"" > "${D}/sel-explicit" 2>&1; printf 'explicit status %s\n' $?
iocsh_test_clean_shell -c "source \"\${TREE1}/setEpicsEnv.bash\" > /dev/null; iocsh.bash -e \"\${TREE2}\" -n \"\${ST}\"" > "${D}/sel-both" 2>&1; printf 'inherited tree 1 with explicit tree 2 status %s\n' $?
iocsh_test_clean_shell -c "\"\${TREE1}/base/bin/\${ARCH}/iocsh.bash\" -n \"\${ST}\"" > "${D}/sel-none" 2>&1; printf 'no selection status %s\n' $?; cat "${D}/sel-none"
iocsh_test_check "inherited selection resolves in tree 1" bash -c "grep -q '^dlload(\"${TREE1}/modules/linStat' '${D}/sel-inherit' && ! grep -q '${TREE2}/' '${D}/sel-inherit'"
iocsh_test_check "explicit selection resolves in tree 2" bash -c "grep -q '^dlload(\"${TREE2}/modules/linStat' '${D}/sel-explicit' && ! grep -q '${TREE1}/' '${D}/sel-explicit'"
iocsh_test_check "explicit selection overrides the inherited tree" bash -c "grep -q '^dlload(\"${TREE2}/modules/linStat' '${D}/sel-both' && ! grep -q '^dlload(\"${TREE1}/' '${D}/sel-both'"
iocsh_test_check "explicit selection prints the generated startup only" bash -c "head -n1 '${D}/sel-both' | grep -q '^# iocsh.bash: generated startup for ' && ! grep -q '${TREE1}/' '${D}/sel-both' && ! grep -q 'EPICS_BASE is defined' '${D}/sel-both'"
iocsh_test_check "no selection is refused" grep -q 'Source setEpicsEnv.bash first, or select a tree with --environment' "${D}/sel-none"

iocsh_test_section "terminal, PID, working directory, exit status"
iocsh_test_env
mkdir -p "${D}/cwd"; cd "${D}/cwd" || exit 2
cat > "${D}/pty.exp" <<'EXP'
set timeout 40
set st [lindex $argv 0]
spawn -noecho iocsh.bash $st
set pid [exp_pid]
expect "7.0.10 > "
puts "\nPTY exe [file readlink /proc/$pid/exe]"
puts "PTY cwd [file readlink /proc/$pid/cwd]"
puts "PTY fd0 [file readlink /proc/$pid/fd/0]"
puts "PTY ps [exec ps -o pid=,pgid=,tpgid=,tty= -p $pid]"
send "epicsEnvShow LINSTAT\r"
expect -re {LINSTAT=[^\r\n]+}
expect "7.0.10 > "
send "exit\r"
expect eof
set w [wait]
puts "\nPTY wait $w"
puts "PTY spawned pid $pid"
EXP
expect "${D}/pty.exp" "${ST}" > "${D}/pty.out" 2>&1; printf 'expect status %s\n' $?
grep -a '^PTY\|LINSTAT=' "${D}/pty.out" | tr -d '\r'
iocsh_test_check "the spawned wrapper PID runs softIocPVX" grep -a -q "^PTY exe ${TREE1}/modules/pvxs-.*/softIocPVX" "${D}/pty.out"
iocsh_test_check "working directory is the caller's" grep -a -q "^PTY cwd ${D}/cwd" "${D}/pty.out"
iocsh_test_check "standard input is the terminal" grep -a -q '^PTY fd0 /dev/pts/' "${D}/pty.out"
iocsh_test_check "IOC is the terminal foreground process group" bash -c "grep -a '^PTY ps' '${D}/pty.out' | awk '{exit !(\$4 == \$5)}'"
iocsh_test_check "typed command reached the IOC shell" grep -a -q "LINSTAT=${TREE1}/modules/linStat-" "${D}/pty.out"
iocsh_test_check "exit command ends with status 0" bash -c "grep -a '^PTY wait' '${D}/pty.out' | awk '{exit !(\$6 == 0 && NF == 6)}'"

iocsh_test_section "signals on a terminal"
for sig in TERM INT; do
    cat > "${D}/sig.exp" <<'EXP'
set timeout 40
set st [lindex $argv 0]
set sig [lindex $argv 1]
spawn -noecho iocsh.bash $st
set pid [exp_pid]
expect "7.0.10 > "
if {$sig eq "CTRLC"} { send "\003" } else { exec kill -$sig $pid }
expect { eof { puts "\nSIG eof" } timeout { puts "\nSIG still running after 10 s"; exec kill -KILL $pid; expect eof } }
puts "SIG wait [wait]"
EXP
    expect "${D}/sig.exp" "${ST}" "${sig}" > "${D}/sig-${sig}.out" 2>&1
    printf '%s: %s\n' "${sig}" "$(tr -d '\r' < "${D}/sig-${sig}.out" | grep -a 'SIG ' | tr '\n' ' ')"
done
sed -i 's/set timeout 40/set timeout 10/' "${D}/sig.exp"
expect "${D}/sig.exp" "${ST}" CTRLC > "${D}/sig-CTRLC.out" 2>&1
printf 'Ctrl-C typed at the prompt: %s\n' "$(tr -d '\r' < "${D}/sig-CTRLC.out" | grep -a 'SIG ' | tr '\n' ' ')"
iocsh_test_check "SIGTERM reaches the IOC and ends it by that signal" grep -a -q 'SIG wait .* CHILDKILLED SIGTERM' "${D}/sig-TERM.out"
iocsh_test_check "SIGINT reaches the IOC and ends it by that signal" grep -a -q 'SIG wait .* CHILDKILLED SIGINT' "${D}/sig-INT.out"

iocsh_test_section "non-interactive run ended by signal"
iocsh.bash -S "${ST}" > "${D}/nonint.log" 2>&1 &
pid=$!
for _ in $(seq 1 120); do grep -q -- "${IOCSH_TEST_READY_TEXT}" "${D}/nonint.log" && break; iocsh_test_sleep 0.25; done
sleep 2; kill -0 "${pid}" && printf 'still running 2 s after the startup file ended\n'
kill -TERM "${pid}"; wait "${pid}"; s=$?
printf 'status after SIGTERM %s\n' "${s}"
iocsh_test_check "-S run keeps running and ends with 143 on SIGTERM" iocsh_test_eq "${s}" 143

iocsh_test_section "native startup error: wrapper against the native executable"
function run_pair {
    local tag="$1"
    sed 's/^module linStat$/# module linStat/' "${D}/${tag}.cmd" > "${D}/${tag}-native.cmd"
    iocsh.bash "${D}/${tag}.cmd" < /dev/null > "${D}/${tag}-wrapper.out" 2>&1; sw=$?
    softIocPVX -D "${EPICS_MODULES}/pvxs/dbd/softIocPVX.dbd" "${D}/${tag}-native.cmd" < /dev/null > "${D}/${tag}-native.out" 2>&1; sn=$?
    iocsh_test_plain "${D}/${tag}-wrapper.out" > "${D}/${tag}-wrapper.plain"; iocsh_test_plain "${D}/${tag}-native.out" > "${D}/${tag}-native.plain"
    printf '%s: wrapper status %s, native status %s\n' "${tag}" "${sw}" "${sn}"
    printf 'wrapper messages:\n'; grep -n -i -E 'error|line [0-9]|not found|runs as' "${D}/${tag}-wrapper.plain" | cut -c1-220
    printf 'native messages:\n'; grep -n -i -E 'error|line [0-9]|not found' "${D}/${tag}-native.plain" | cut -c1-220
}
printf '%s\n' 'on error break' 'module linStat' 'epicsEnvSet("IOCSH_TEST_E","1")' '# line 4' 'iocshNoSuchCommand 1' 'epicsEnvSet("IOCSH_TEST_AFTER","1")' 'iocInit()' > "${D}/errcmd.cmd"
run_pair errcmd
iocsh_test_check "unknown command: wrapper and native exit status agree" iocsh_test_eq "${sw}" "${sn}"
iocsh_test_check "unknown command: wrapper prints the file mapping" grep -q "errcmd.cmd runs as /dev/fd/4" "${D}/errcmd-wrapper.plain"
# iocsh names a startup file by its last path component, so /dev/fd/4 appears as 4.
iocsh_test_check "unknown command: native error names descriptor 4 and line 5" grep -q "^ERROR 4 line 5: Command 'iocshNoSuchCommand' not registered" "${D}/errcmd-wrapper.plain"
iocsh_test_check "unknown command: native run names its own file and line 5" bash -c "grep 'errcmd-native.cmd' '${D}/errcmd-native.plain' | grep -q 'line 5'"
iocsh_test_check "unknown command: later lines did not run and iocInit did not complete" bash -c "! grep -q 'IOCSH_TEST_AFTER' '${D}/errcmd-wrapper.plain' && ! grep -q -- '${IOCSH_TEST_READY_TEXT}' '${D}/errcmd-wrapper.plain'"
printf '%s\n' 'on error break' 'module linStat' 'epicsEnvSet("IOCSH_TEST_E","1")' '# line 4' 'dbLoadRecords("/nonexistent/iocsh-missing.db","P=x")' 'epicsEnvSet("IOCSH_TEST_AFTER","1")' 'iocInit()' > "${D}/errdb.cmd"
run_pair errdb
iocsh_test_check "missing database: wrapper and native exit status agree" iocsh_test_eq "${sw}" "${sn}"
iocsh_test_check "missing database: wrapper and native print the same database errors" iocsh_test_eq "$(grep "iocsh-missing.db'" "${D}/errdb-wrapper.plain")" "$(grep "iocsh-missing.db'" "${D}/errdb-native.plain")"
iocsh_test_check "missing database: later lines did not run and iocInit did not complete" bash -c "! grep -q 'IOCSH_TEST_AFTER' '${D}/errdb-wrapper.plain' && ! grep -q -- '${IOCSH_TEST_READY_TEXT}' '${D}/errdb-wrapper.plain'"
iocsh_test_summary
