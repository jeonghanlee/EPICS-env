#!/usr/bin/env bash
# Build-id comparison of the shipped wrapper before a start, its exit
# statuses, and its loader option. The record of the candidate tree is
# read first; every fault is injected into a copy of the tree, and the
# module under test is iocStats, which no other module depends on.
# Single-quoted arguments carry sed commands and regular expressions on purpose.
# shellcheck disable=SC2016
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/build_ids"; iocsh_test_trash "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
FC=$(iocsh_test_copy_tree "${IOCSH_TEST_OUT}/copies/buildid") || exit 2; printf 'fault copy %s\n' "${FC}"
iocsh_test_env "${FC}"
M="${EPICS_MODULES}"
MOD=$(readlink -e "${M}/iocStats") || exit 2
OWN="${MOD##*/}"; REC="${MOD}/cfg/build-record"
LIBREL=$(sed -n 's/^lib=//p' "${MOD}/cfg/iocsh.conf" | head -n 1)
ID=$(readelf -n "${MOD}/${LIBREL}" | sed -n 's/.*Build ID: *//p')
printf 'module %s library %s build-id %s\n' "${OWN}" "${LIBREL}" "${ID}"
ST="${D}/st.cmd"; printf '%s\n' 'module iocStats' 'iocInit()' > "${ST}"
N=0

# refused LABEL EXPECTED_REGEX WRAPPER_ARGS...  runs the show mode and a
# real start and checks status 78 in both, the expected message in both,
# no listing on standard output, and that no IOC was launched.
function refused {
    local label="$1" expect="$2"; shift 2
    N=$((N + 1))
    iocsh.bash -n "$@" > "${D}/c${N}.show.out" 2> "${D}/c${N}.show.err"; local ss=$?
    iocsh.bash "$@" < /dev/null > "${D}/c${N}.run.out" 2>&1; local sr=$?
    printf '%2d %-38s show=%s run=%s | %s\n' "${N}" "${label}" "${ss}" "${sr}" "$(head -n 3 "${D}/c${N}.show.err" | tr '\n' '~' | cut -c1-300)"
    iocsh_test_check "${label}" bash -c "[[ ${ss} -eq 78 && ${sr} -eq 78 ]] && grep -q -E -- \"\$1\" '${D}/c${N}.show.err' && grep -q -E -- \"\$1\" '${D}/c${N}.run.out' && ! grep -q 'softIocPVX.dbd\|Starting iocInit' '${D}/c${N}.run.out' && [[ ! -s '${D}/c${N}.show.out' ]]" _ "${expect}"
}

# fault_record SED_EXPRESSION LABEL REGEX [keep-digest]  edits the build
# record of the copy and, unless keep-digest is given, records the digest
# of the edited file, so the check under test is the one behind the digest
# comparison. The record and its digest are restored afterwards.
function fault_record {
    cp -p "${REC}" "${D}/record.saved"; cp -p "${REC}.sha256" "${D}/record-digest.saved"
    chmod u+w "${REC}" "${REC}.sha256"; sed -i "$1" "${REC}"
    [[ "${4:-}" == "keep-digest" ]] || sha256sum < "${REC}" | cut -d' ' -f1 > "${REC}.sha256"
    refused "$2" "$3" "${ST}"
    cp -p "${D}/record.saved" "${REC}"; cp -p "${D}/record-digest.saved" "${REC}.sha256"
}

iocsh_test_section "build record of the candidate tree"
grep -E '^(format|buildid)=' "${REC}"
iocsh_test_check "the record is format 2" grep -q -x 'format=2' "${REC}"
iocsh_test_check "the record matches its digest file" iocsh_test_eq "$(cat "${REC}.sha256" 2>/dev/null)" "$(sha256sum < "${REC}" | cut -d' ' -f1)"
iocsh_test_check "the recorded build-id is the build-id of the installed library" grep -q -x "buildid=${LIBREL} ${ID}" "${REC}"
iocsh_test_check "the loader metadata stays format 1" grep -q -x 'format=1' "${MOD}/cfg/iocsh.conf"

iocsh_test_section "correct start"
iocsh.bash -n "${ST}" > "${D}/ok.show" 2> "${D}/ok.show.err"; s=$?; printf 'show status %s\n' "${s}"
grep "^# elf: module ${OWN} " "${D}/ok.show" | sed "s|${FC}|<copy>|"
iocsh_test_check "the show mode ends with 0 and lists the library with its build-id" bash -c "[[ ${s} -eq 0 ]] && [[ ! -s '${D}/ok.show.err' ]] && grep -q '^# elf: module ${OWN} .*/${LIBREL} buildid ${ID}\$' '${D}/ok.show'"
printf 'exit\n' | iocsh.bash "${ST}" > "${D}/ok.run" 2>&1; s=$?; printf 'start status %s\n' "${s}"
iocsh_test_check "a correct start reaches iocInit, prints no ERROR line, and exits 0" bash -c "[[ ${s} -eq 0 ]] && grep -q '${IOCSH_TEST_READY_TEXT}' '${D}/ok.run' && ! grep -q 'iocsh.bash: ERROR' '${D}/ok.run'"

iocsh_test_section "refused starts"
cp -p "${MOD}/${LIBREL}" "${D}/library.saved"; chmod u+w "${MOD}/${LIBREL}"
# The same library with one bit of its build-id note changed is another build at the recorded path.
perl -0777 -pe 'BEGIN { $id = pack("H*", shift @ARGV) } my $i = index($_, $id); die "no build-id note\n" if $i < 0; substr($_, $i, 1) = chr(ord(substr($_, $i, 1)) ^ 1)' "${ID}" "${D}/library.saved" > "${MOD}/${LIBREL}" || exit 2
OTHER=$(readelf -n "${MOD}/${LIBREL}" | sed -n 's/.*Build ID: *//p'); printf 'library with build-id %s at the recorded path\n' "${OTHER}"
refused "a library of another build" "iocsh.bash: ERROR: ${OWN} ${LIBREL} build-id ${OTHER} recorded ${ID}" "${ST}"
iocsh_test_check "the summary line comes first" bash -c "head -n 1 '${D}/c${N}.show.err' | grep -q -x 'iocsh.bash: ERROR: 1 of [0-9]* module libraries differ from their build record'"
cp -p "${D}/library.saved" "${MOD}/${LIBREL}"
fault_record 's/^\(buildid=[^ ]* \)..../\10000/' "a recorded build-id that differs" "iocsh.bash: ERROR: ${OWN} ${LIBREL} build-id ${ID} recorded 0000"
fault_record '/^buildid=/d' "a library without a build-id line" "iocsh.bash: ERROR: ${OWN} ${LIBREL} has no build-id in cfg/build-record"
fault_record 's/^\(buildid=[^ ]* \)..../\10000/' "a record changed after it was written" 'Build record of iocStats .* was changed after it was written: .*build-record does not match .*build-record.sha256' keep-digest
fault_record '$a color=blue' "an unknown record key" 'Unknown build record key in .*: color'
fault_record 's/^format=2$/format=3/' "an unknown record format" 'Unsupported build record format in .*: 3 \(this wrapper reads formats 1 and 2\)'
fault_record 's/^name=.*/name=other/' "a record that names another module" 'names module other, not iocStats'
fault_record 's/^format=2$/format=1/' "a record edited to format 1 beside its digest" 'Build record of iocStats .* claims format 1 beside a digest file' keep-digest
cp -p "${REC}" "${D}/record.saved"; cp -p "${REC}.sha256" "${D}/record-digest.saved"; chmod u+w "${REC}" "${REC}.sha256"
printf '=/etc/hostname\n' >> "${REC}"; sha256sum < "${REC}" | cut -d' ' -f1 > "${REC}.sha256"
bash "${IOCSH_TEST_REPO}/tools/iocsh_metadata.bash" check --install "${MOD}" --base "${FC}/base" > "${D}/emptykey.out" 2>&1; s=$?; printf 'check of a record line with an empty key: status %s: %s\n' "${s}" "$(head -n 1 "${D}/emptykey.out" | cut -c1-160)"
iocsh_test_check "the metadata tool refuses a record line with an empty key" bash -c "[[ ${s} -ne 0 ]] && grep -q 'Unknown key in .*build-record' '${D}/emptykey.out'"
cp -p "${D}/record.saved" "${REC}"; cp -p "${D}/record-digest.saved" "${REC}.sha256"

# other_key FILE LINE LABEL REGEX  appends a line with a key of the other
# file format to FILE of the copy, records the digest of the edited file,
# and checks that the metadata tool refuses the file for that key. The file
# and its digest are restored afterwards.
function other_key {
    cp -p "$1" "${D}/file.saved"; cp -p "$1.sha256" "${D}/file-digest.saved"; chmod u+w "$1" "$1.sha256"
    printf '%s\n' "$2" >> "$1"; sha256sum < "$1" | cut -d' ' -f1 > "$1.sha256"
    bash "${IOCSH_TEST_REPO}/tools/iocsh_metadata.bash" check --install "${MOD}" --base "${FC}/base" > "${D}/otherkey.out" 2>&1; local s=$?
    printf 'check with %s: status %s: %s\n' "$3" "${s}" "$(head -n 1 "${D}/otherkey.out" | cut -c1-160)"
    iocsh_test_check "the metadata tool refuses $3" bash -c "[[ ${s} -ne 0 ]] && grep -q -- \"\$1\" '${D}/otherkey.out'" _ "$4"
    cp -p "${D}/file.saved" "$1"; cp -p "${D}/file-digest.saved" "$1.sha256"
}
other_key "${REC}" "lib=${LIBREL}" "a loader metadata key in the build record" 'Unknown key in .*build-record: lib'
other_key "${MOD}/cfg/iocsh.conf" "artifact=${LIBREL} 00" "a build record key in the loader metadata" 'Unknown key in .*iocsh.conf: artifact'

mv "${REC}.sha256" "${D}/record-digest.moved"
refused "a record without its digest file" 'Module iocStats .* has no build record digest: .*build-record.sha256' "${ST}"
mv "${D}/record-digest.moved" "${REC}.sha256"
mv "${REC}" "${D}/record.moved"
refused "a module without its build record" 'Module iocStats .* has no build record: .*cfg/build-record' "${ST}"
mv "${D}/record.moved" "${REC}"

iocsh_test_section "record of format 1"
cp -p "${REC}" "${D}/record.saved"; mv "${REC}.sha256" "${D}/record-digest.moved"; chmod u+w "${REC}"
sed -i 's/^format=2$/format=1/' "${REC}"
bash "${IOCSH_TEST_REPO}/tools/iocsh_metadata.bash" check --install "${MOD}" --base "${FC}/base" > "${D}/old-buildid.out" 2>&1; s=$?
printf 'check of a format 1 record with build-id lines: status %s: %s\n' "${s}" "$(head -n 1 "${D}/old-buildid.out" | cut -c1-160)"
iocsh_test_check "the metadata tool refuses a build-id line in a record of format 1" bash -c "[[ ${s} -ne 0 ]] && grep -q 'Unknown key in .*build-record: buildid' '${D}/old-buildid.out'"
sed -i '/^buildid=/d' "${REC}"
iocsh.bash -n "${ST}" > "${D}/old.show" 2> "${D}/old.show.err"; s=$?; printf 'show status %s\n' "${s}"
iocsh_test_check "a record of format 1 is not compared and is marked in the listing" bash -c "[[ ${s} -eq 0 ]] && [[ ! -s '${D}/old.show.err' ]] && grep -q '^# elf: module ${OWN} .*/${LIBREL} buildid ${ID} not recorded\$' '${D}/old.show'"
printf 'exit\n' | iocsh.bash "${ST}" > "${D}/old.run" 2>&1; s=$?
iocsh_test_check "a start with a record of format 1 reaches iocInit without a build-id message" bash -c "[[ ${s} -eq 0 ]] && grep -q '${IOCSH_TEST_READY_TEXT}' '${D}/old.run' && ! grep -q -i 'build-id\|build record' '${D}/old.run'"
cp -p "${D}/record.saved" "${REC}"; mv "${D}/record-digest.moved" "${REC}.sha256"

iocsh_test_section "exit statuses"
iocsh.bash -x "${ST}" > /dev/null 2>&1; s1=$?; iocsh.bash -n -x "${ST}" > /dev/null 2>&1; s2=$?
iocsh.bash -n > /dev/null 2>&1; s3=$?; iocsh.bash "${ST}" "${ST}" > /dev/null 2>&1; s4=$?
printf 'unknown option %s, with show %s, show without a file %s, two startup files %s\n' "${s1}" "${s2}" "${s3}" "${s4}"
iocsh_test_check "a wrong command line ends with 64" iocsh_test_eq "${s1} ${s2} ${s3} ${s4}" "64 64 64 64"
printf '%s\n' 'module nosuch' 'iocInit()' > "${D}/nosuch.cmd"
iocsh.bash -n "${D}/nosuch.cmd" > /dev/null 2>&1; s1=$?; iocsh.bash "${D}/nosuch.cmd" < /dev/null > /dev/null 2>&1; s2=$?
iocsh.bash -n /nonexistent/st.cmd > /dev/null 2>&1; s3=$?
printf 'module that is not installed: show %s start %s; unreadable startup file %s\n' "${s1}" "${s2}" "${s3}"
iocsh_test_check "a refused start ends with 78 in both modes" iocsh_test_eq "${s1} ${s2} ${s3}" "78 78 78"
iocsh.bash -h > /dev/null 2>&1; s=$?
iocsh_test_check "help ends with 0" iocsh_test_eq "${s}" 0

iocsh_test_section "loader option"
printf 'exit\n' | iocsh.bash -l "${ST}" > "${D}/loader.out" 2> "${D}/loader.err"; s=$?
PID=$(sed -n 's/^iocsh.bash: loader lines of the IOC process start with \([0-9]*\):$/\1/p' "${D}/loader.err")
printf 'status %s, announced process %s, its loader lines %s, loader lines of other processes %s\n' "${s}" "${PID:-none}" "$(grep -c -E "^ +${PID:-x}:" "${D}/loader.err")" "$(grep -E '^ +[0-9]+:' "${D}/loader.err" | grep -c -v -E "^ +${PID:-x}:")"
iocsh_test_check "the loader of the announced IOC process reports the library of the module" bash -c "[[ ${s} -eq 0 && -n '${PID}' ]] && grep -E '^ +${PID}:' '${D}/loader.err' | grep -q 'calling init: .*/${OWN}/${LIBREL}\$'"
printf 'exit\n' | iocsh.bash "${ST}" > "${D}/plain.out" 2> "${D}/plain.err"
iocsh_test_check "without the option the loader reports nothing" bash -c "! grep -q -E '^ +[0-9]+:' '${D}/plain.err' && ! grep -q 'loader lines' '${D}/plain.err'"

iocsh_test_section "the copy starts again after the faults were removed"
iocsh_test_check "the restored copy passes the show mode" bash -c "iocsh.bash -n '${ST}' > /dev/null 2>&1"
iocsh_test_summary
