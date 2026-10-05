#!/usr/bin/env bash
# Failure diagnostics of the shipped wrapper in the show mode and in a
# real start. Syntax and graph cases use the candidate tree with its two
# installed versions of linStat and asyn; file and metadata faults are
# injected into a copy of the tree.
# Single-quoted arguments carry sed commands and literal dollar signs on purpose.
# shellcheck disable=SC2016
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/failure_diagnostics"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
FC=$(iocsh_test_copy_tree "${IOCSH_TEST_OUT}/copies/fault"); printf 'fault copy %s\n' "${FC}"
N=0
# run_case LABEL EXPECTED_REGEX WRAPPER_ARGS...  runs both modes and checks
# a nonzero status, the expected message, and that no IOC was launched.
function run_case {
    local label="$1" expect="$2"; shift 2
    N=$((N + 1))
    iocsh.bash -n "$@" > "${D}/c${N}.show.out" 2> "${D}/c${N}.show.err"; local ss=$?
    iocsh.bash "$@" < /dev/null > "${D}/c${N}.run.out" 2>&1; local sr=$?
    printf '%2d %-34s show=%s run=%s | %s\n' "${N}" "${label}" "${ss}" "${sr}" "$(grep -v '^$' "${D}/c${N}.show.err" | head -n 4 | tr '\n' '~' | cut -c1-330)"
    iocsh_test_check "${label}" bash -c "[[ ${ss} -ne 0 && ${sr} -ne 0 ]] && grep -q -E -- \"\$1\" '${D}/c${N}.show.err' && grep -q -E -- \"\$1\" '${D}/c${N}.run.out' && ! grep -q 'softIocPVX.dbd\|Starting iocInit' '${D}/c${N}.run.out' && [[ ! -s '${D}/c${N}.show.out' ]]" _ "${expect}"
}
function st { local f="${D}/s${N}-$1.cmd"; shift; printf '%s\n' "$@" 'iocInit()' > "${f}"; printf '%s' "${f}"; }

iocsh_test_section "syntax and argument cases, candidate tree"
iocsh_test_env
run_case "directive without a name"        'sm1-x.cmd:2: Malformed module directive'      "$(N=m1; st x '# c' 'module')"
run_case "three arguments"                 'sm2-x.cmd:1: Malformed module directive'      "$(N=m2; st x 'module linStat 1.2.1 extra')"
run_case "quotes on one argument only"     'sm3-x.cmd:1: Malformed module directive.*quotes on both' "$(N=m3; st x 'mod "linStat" 1.2.1')"
run_case "parenthesized without quotes"    'sm4-x.cmd:1: Malformed module directive'      "$(N='m4'; st x 'm(linStat)')"
run_case "invalid character in the name"   'sm5-x.cmd:1: Malformed module directive'      "$(N=m5; st x 'module lin$tat')"
OKST="$(N=ok; st x 'module linStat')"
run_case "two startup files"               'Specify at most one IOC startup file'      "${OKST}" "${OKST}"
run_case "unknown option"                  'Unknown option: -x'                        -x "${OKST}"
run_case "unreadable startup file"         'Cannot read startup file: /nonexistent/st.cmd' /nonexistent/st.cmd
run_case "unknown module"                  'Module nosuch has no installed default link: .*\(sg1-x.cmd:1\)' "$(N=g1; st x 'module nosuch')"
run_case "version that is not installed"   'Module linStat 9.9.9 is not installed under .*\(sg2-x.cmd:1\)' "$(N=g2; st x 'module linStat 9.9.9')"
run_case "direct version conflict"         'Module version conflict: linStat'          "$(N=g3; st x 'module linStat 1.1.1' 'module linStat')"
run_case "transitive version conflict"     'Requested: 4.46.0 at StreamDevice 2.8.26 \(sg4-x.cmd:2\)' "$(N=g4; st x 'module asyn 66bafcd' 'module StreamDevice')"
run_case "transitive conflict, other order" 'Requested: 66bafcd at sg5-x.cmd:2' "$(N=g5; st x 'module StreamDevice' 'module asyn 66bafcd')"
cat "${D}"/c11.show.err "${D}"/c12.show.err "${D}"/c13.show.err

iocsh_test_section "file and metadata faults, copy of the tree"
iocsh_test_env "${FC}"
M="${EPICS_MODULES}"; A="${EPICS_HOST_ARCH}"
LS="$(N=f; st x 'module linStat')"; SD="$(N=fs; st x 'module StreamDevice')"; PV="$(N=fp; st x 'module pvxs 9.9.9')"
# fault_conf MODULE-VERSION SED_EXPRESSION LABEL REGEX STARTUP [keep-digest]
# edits the metadata of the copy and, unless keep-digest is given, records
# the digest of the edited file, so the check under test is the one behind
# the digest comparison. With keep-digest the edit is a one-file change.
function fault_conf {
    local conf="${M}/$1/cfg/iocsh.conf"
    cp -p "${conf}" "${D}/conf.saved"; cp -p "${conf}.sha256" "${D}/digest.saved"
    chmod u+w "${conf}" "${conf}.sha256"; sed -i "$2" "${conf}"
    [[ "${6:-}" == "keep-digest" ]] || sha256sum < "${conf}" | cut -d' ' -f1 > "${conf}.sha256"
    run_case "$3" "$4" "$5"
    cp -p "${D}/conf.saved" "${conf}"; cp -p "${D}/digest.saved" "${conf}.sha256"
}
mv "${M}/linStat-1.2.1/cfg/iocsh.conf" "${D}/conf.moved"
run_case "missing metadata" 'Module linStat 1.2.1 has no loader metadata: .*Install it with' "${LS}"
mv "${D}/conf.moved" "${M}/linStat-1.2.1/cfg/iocsh.conf"
mv "${M}/linStat-1.2.1/lib/${A}/liblinStat.so" "${D}/lib.moved"
run_case "missing library file" 'linStat' "${LS}"
mv "${D}/lib.moved" "${M}/linStat-1.2.1/lib/${A}/liblinStat.so"
mv "${M}/linStat-1.2.1/dbd/linStat.dbd" "${D}/dbd.moved"
run_case "missing DBD file" 'DBD of linStat 1.2.1 is missing' "${LS}"
mv "${D}/dbd.moved" "${M}/linStat-1.2.1/dbd/linStat.dbd"
fault_conf linStat-1.2.1 '$a dep=asyn 4.46.0' "one-file edit: added dependency" 'Metadata of linStat 1.2.1 was changed after its generation: .*iocsh.conf does not match .*iocsh.conf.sha256. Regenerate it with make install' "${LS}" keep-digest
fault_conf linStat-1.2.1 's/^macro=.*/macro=OTHER/' "one-file edit: macro" 'Metadata of linStat 1.2.1 was changed after its generation' "${LS}" keep-digest
fault_conf asyn-4.46.0 '$a dep=StreamDevice 2.8.26' "one-file edit: cycle in a dependency" 'Metadata of asyn 4.46.0 was changed after its generation' "${SD}" keep-digest
mv "${M}/linStat-1.2.1/cfg/iocsh.conf.sha256" "${D}/digest.moved"
run_case "missing digest" 'Module linStat 1.2.1 has no metadata digest: .*iocsh.conf.sha256. Regenerate the metadata with make install' "${LS}"
mv "${D}/digest.moved" "${M}/linStat-1.2.1/cfg/iocsh.conf.sha256"
fault_conf linStat-1.2.1 's/^format=1$/format=2/' "format mismatch" 'Unsupported metadata format in .*: 2 \(this wrapper reads format 1\)' "${LS}"
fault_conf linStat-1.2.1 's/^arch=.*/arch=linux-aarch64/' "architecture mismatch" 'Module linStat 1.2.1 is built for linux-aarch64, not linux-x86_64' "${LS}"
fault_conf linStat-1.2.1 's/^base=.*/base=7.0.9/' "Base version mismatch" 'Module linStat 1.2.1 is built against Base 7.0.9, not the selected Base 7.0.10' "${LS}"
fault_conf linStat-1.2.1 's/^name=.*/name=other/' "metadata names another module" 'names module other, not linStat' "${LS}"
fault_conf linStat-1.2.1 's/^version=.*/version=0.0.1/' "metadata records another version" 'records version 0.0.1, not 1.2.1' "${LS}"
fault_conf linStat-1.2.1 '$a this line has no separator' "line without a separator" 'Malformed metadata line in .*linStat-1.2.1/cfg/iocsh.conf' "${LS}"
fault_conf linStat-1.2.1 '$a color=blue' "unknown key" 'Unknown metadata key in .*: color' "${LS}"
fault_conf linStat-1.2.1 's|^lib=.*|lib=../../asyn/lib/x.so|' "entry outside the module" 'entry outside the module' "${LS}"
fault_conf linStat-1.2.1 '/^dbd=/p' "repeated entry" 'repeats the entry dbd=' "${LS}"
fault_conf linStat-1.2.1 '/^macro=/d' "missing macro" 'has no valid macro name' "${LS}"
fault_conf linStat-1.2.1 '$a dep=asyn' "malformed dependency" 'Malformed dependency in ' "${LS}"
fault_conf asyn-4.46.0 '$a dep=StreamDevice 2.8.26' "dependency cycle" 'Dependency cycle at StreamDevice \(asyn 4.46.0 \(StreamDevice 2.8.26 \(sfs-x.cmd:1\)\)\)' "${SD}"
fault_conf StreamDevice-2.8.26 's/^dep=asyn .*/dep=asyn 9.9.9/' "recorded dependency that is not installed" 'Module asyn 9.9.9 is not installed under .*\(StreamDevice 2.8.26 \(sfs-x.cmd:1\)\)' "${SD}"
run_case "pvxs version that is not installed" 'Module pvxs 9.9.9 is not installed' "${PV}"
cp -a "${M}/pvxs-1.5.2" "${M}/pvxs-9.9.9"; chmod u+w "${M}/pvxs-9.9.9/cfg/iocsh.conf" "${M}/pvxs-9.9.9/cfg/iocsh.conf.sha256"; sed -i 's/^version=.*/version=9.9.9/' "${M}/pvxs-9.9.9/cfg/iocsh.conf"; sha256sum < "${M}/pvxs-9.9.9/cfg/iocsh.conf" | cut -d' ' -f1 > "${M}/pvxs-9.9.9/cfg/iocsh.conf.sha256"
run_case "pvxs version other than the native one" 'Module pvxs 9.9.9 is requested at sfp-x.cmd:1, but the native softIocPVX already provides pvxs 1.5.2' "${PV}"
rm -rf "${M}/pvxs-9.9.9"
cat "${D}/c19.show.err"

iocsh_test_section "the copy starts again after the faults were removed"
iocsh.bash -n "${SD}" > /dev/null 2> "${D}/clean.err"; printf 'show status %s\n' $?
iocsh_test_check "the restored copy resolves StreamDevice and linStat" bash -c "iocsh.bash -n '${SD}' > /dev/null 2>&1 && iocsh.bash -n '${LS}' > /dev/null 2>&1"
iocsh_test_section "no eval in the shipped tools"
grep -n -w 'eval' "${IOCSH_TEST_TREE}/base/bin/${A}/iocsh.bash" "${IOCSH_TEST_TREE}/base/bin/${A}/iocsh_elf.bash" || printf 'no eval\n'
iocsh_test_check "wrapper and ELF tool contain no eval" bash -c "! grep -q -w eval '${IOCSH_TEST_TREE}/base/bin/${A}/iocsh.bash' '${IOCSH_TEST_TREE}/base/bin/${A}/iocsh_elf.bash'"
iocsh_test_summary
