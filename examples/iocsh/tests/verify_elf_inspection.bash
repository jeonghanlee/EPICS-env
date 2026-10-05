#!/usr/bin/env bash
# ELF inspection with the fault parts of the minimal-example check and the
# rejection parts of the installation check: the shipped
# ELF resolver through the wrapper, environment candidates of another
# installed version, metadata against ELF, a support-load failure in a copy,
# and the generator's rejections through the shipped make rules.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/elf_inspection"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
S="${IOCSH_TEST_REPO}"; T="${IOCSH_TEST_TREE}"
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
iocsh_test_env
M="${EPICS_MODULES}"; A="${EPICS_HOST_ARCH}"; V="${T}/vendor"
function st { local f="${D}/$1.cmd"; shift; printf '%s\n' "$@" 'iocInit()' > "${f}"; printf '%s' "${f}"; }

iocsh_test_section "classes in the static report against the native mappings"
MIX=$(st mix 'module opcua' 'module measComp' 'module snmp' 'module StreamDevice')
iocsh.bash -n "${MIX}" > "${D}/mix.show" 2> "${D}/mix.err"; printf 'show status %s\n' $?; cat "${D}/mix.err"
head -n 2 "${D}/mix.show" | cut -c1-140
grep '^# elf:' "${D}/mix.show" | awk '{print $3}' | sort | uniq -c | tr '\n' ' '; printf '\n'
grep -E '^# elf: (vendor|module)' "${D}/mix.show" | sed "s|${T}/||" | sort -u
grep -E '^# elf: system .*(netsnmp|usb)' "${D}/mix.show" | head -n 4
iocsh_test_check "open62541 and uldaq are vendor files of the selected tree" bash -c "grep -q '^# elf: vendor - ${V}/lib/libopen62541' '${D}/mix.show' && grep -q '^# elf: vendor - ${V}/lib/libuldaq' '${D}/mix.show'"
iocsh_test_check "net-snmp is a system file" grep -q -E '^# elf: system - /(usr/)?lib.*/libnetsnmp' "${D}/mix.show"
iocsh_test_check "libasyn is owned by the selected asyn version" grep -q "^# elf: module asyn-4.46.0 ${M}/asyn-4.46.0/lib/${A}/libasyn.so" "${D}/mix.show"
iocsh_test_check "the report calls itself a static inspection" grep -q '^# iocsh.bash: static ELF inspection of' "${D}/mix.show"
iocsh_test_ioc_start mix "${D}/mix.log" "${MIX}"; s=$?
iocsh_test_maps "${IOCSH_TEST_IOC_PID[mix]}" > "${D}/mix.maps"; iocsh_test_ioc_stop mix
iocsh_test_check "real IOC with the four modules reaches iocInit" iocsh_test_eq "${s}" 0
grep -E '^# elf: (vendor|module|base)' "${D}/mix.show" | awk '{print $5}' | xargs -r readlink -e | sort -u > "${D}/mix.static"
grep -F "${T}/" "${D}/mix.maps" | sort -u > "${D}/mix.native"
printf 'tree files in the static report %s, mapped natively %s, in the report but not mapped %s, mapped but not in the report %s\n' "$(wc -l < "${D}/mix.static")" "$(wc -l < "${D}/mix.native")" "$(comm -23 "${D}/mix.static" "${D}/mix.native" | wc -l)" "$(comm -13 "${D}/mix.static" "${D}/mix.native" | wc -l)"
comm -3 "${D}/mix.static" "${D}/mix.native" | sed "s|${T}/||" | head -n 8
grep '^dlload' "${D}/mix.show" | sed 's/^dlload("\(.*\)")$/\1/' | xargs -r readlink -e | sort -u > "${D}/mix.loaded"
iocsh_test_check "every tree file of the static report is mapped natively" iocsh_test_eq "$(comm -23 "${D}/mix.static" "${D}/mix.native" | wc -l)" 0
iocsh_test_check "every other mapped tree file is a library the startup loads" iocsh_test_eq "$(comm -13 "${D}/mix.static" "${D}/mix.native" | comm -23 - "${D}/mix.loaded" | wc -l)" 0

iocsh_test_section "environment candidate of another installed version"
SD=$(st sd 'module StreamDevice')
LD_LIBRARY_PATH="${M}/asyn-66bafcd/lib/${A}:${LD_LIBRARY_PATH}" iocsh.bash -n "${SD}" > "${D}/ld.show" 2> "${D}/ld.err"; s1=$?
LD_LIBRARY_PATH="${M}/asyn-66bafcd/lib/${A}:${LD_LIBRARY_PATH}" iocsh.bash "${SD}" < /dev/null > "${D}/ld.run" 2>&1; s2=$?
printf 'asyn 66bafcd first on LD_LIBRARY_PATH with module StreamDevice: show status %s, real start status %s\n' "${s1}" "${s2}"; cut -c1-400 "${D}/ld.err"
grep 'libasyn' "${D}/ld.show" | sed "s|${M}/||"
LD_LIBRARY_PATH="${M}/asyn-66bafcd/lib/${A}:${LD_LIBRARY_PATH}" iocsh_test_ioc_start ld "${D}/ld.log" "${SD}"; s=$?
iocsh_test_maps "${IOCSH_TEST_IOC_PID[ld]}" | grep '/asyn-' | sed "s|${M}/||" | tee "${D}/ld.maps"; iocsh_test_ioc_stop ld
# The startup loads the selected libasyn.so by path first, so the name is
# already loaded when libstream.so needs it; the native loader agrees.
iocsh_test_check "static result and native mapping agree on asyn-4.46.0 despite the environment entry" bash -c "[[ ${s1} -eq 0 && ${s} -eq 0 ]] && grep -q 'module asyn-4.46.0' '${D}/ld.show' && [[ \"\$(cat '${D}/ld.maps')\" == 'asyn-4.46.0/lib/${A}/libasyn.so' ]]"
LD_LIBRARY_PATH="${M}/asyn-4.46.0/lib/${A}:${LD_LIBRARY_PATH}" iocsh.bash -n "${SD}" > /dev/null 2> "${D}/ld-ok.err"; s=$?
iocsh_test_check "the selected version on LD_LIBRARY_PATH is accepted" iocsh_test_eq "${s}:$(wc -c < "${D}/ld-ok.err")" "0:0"

iocsh_test_section "faults in a copy: ORIGIN, metadata against ELF, missing vendor file, support-load failure"
FC=$(iocsh_test_copy_tree "${IOCSH_TEST_OUT}/copies/fault")
iocsh_test_env "${FC}"; FM="${EPICS_MODULES}"
iocsh.bash -n "${MIX}" > "${D}/copy.show" 2> "${D}/copy.err"; printf 'show status in the copy %s\n' $?
iocsh_test_check "every tree file in the copy's report lies in the copy" bash -c "[[ \$(grep -c -E '^# elf: (vendor|module|base)' '${D}/copy.show') -gt 10 ]] && ! grep -E '^# elf: (vendor|module|base)' '${D}/copy.show' | grep -v -q -F ' ${FC}/'"
SDC="${FM}/StreamDevice-2.8.26/cfg/iocsh.conf"
cp -p "${SDC}" "${D}/sd.conf"; cp -p "${SDC}.sha256" "${D}/sd.digest"; chmod u+w "${SDC}" "${SDC}.sha256"
function redigest { sha256sum < "${SDC}" | cut -d' ' -f1 > "${SDC}.sha256"; }
# Both files changed together, so the ELF inspection is the check under test.
sed -i '/^dep=asyn /d' "${SDC}"; redigest
iocsh.bash -n "${SD}" > /dev/null 2> "${D}/mismatch.err"; s=$?; printf 'metadata omits the asyn dependency that the ELF needs: status %s\n' "${s}"; cut -c1-400 "${D}/mismatch.err"
iocsh_test_check "an ELF dependency that the metadata does not record is explained" bash -c "[[ ${s} -eq 1 ]] && grep -q 'asyn-4.46.0, which is not a selected module or a recorded dependency' '${D}/mismatch.err'"
# A one-file edit of the recorded dependency version is refused by the digest.
cp -p "${D}/sd.digest" "${SDC}.sha256"; sed 's/^dep=asyn .*/dep=asyn 66bafcd/' "${D}/sd.conf" > "${SDC}"
iocsh.bash -n "${SD}" > "${D}/mismatch2.show" 2> "${D}/mismatch2.err"; s=$?; printf 'metadata edited to asyn 66bafcd, digest unchanged: status %s\n' "${s}"; cut -c1-300 "${D}/mismatch2.err"
iocsh_test_check "an edited dependency version is refused by the metadata digest" bash -c "[[ ${s} -eq 1 ]] && grep -q 'Metadata of StreamDevice 2.8.26 was changed after its generation' '${D}/mismatch2.err'"
redigest
iocsh.bash -n "${SD}" > "${D}/mismatch3.show" 2> "${D}/mismatch3.err"; printf 'same edit with the digest replaced as well (outside the guard): status %s; ' $?; grep -c 'asyn-66bafcd' "${D}/mismatch3.show" | sed 's/$/ lines name asyn-66bafcd/'
cp -p "${D}/sd.conf" "${SDC}"; cp -p "${D}/sd.digest" "${SDC}.sha256"
cp -a "${FM}/pvxs-1.5.2" "${FM}/pvxs-9.9.9"
LD_LIBRARY_PATH="${FM}/pvxs-9.9.9/lib/${A}:${LD_LIBRARY_PATH}" iocsh.bash -n "${SD}" > /dev/null 2> "${D}/pvxs.err"; s=$?; printf 'copied pvxs directory first on LD_LIBRARY_PATH: status %s\n' "${s}"; head -n 2 "${D}/pvxs.err" | cut -c1-400
LD_LIBRARY_PATH="${FM}/pvxs-9.9.9/lib/${A}:${LD_LIBRARY_PATH}" iocsh.bash "${SD}" < /dev/null > "${D}/pvxs.run" 2>&1; s2=$?
rm -rf "${FM}/pvxs-9.9.9"
iocsh_test_check "an environment candidate in another version directory is refused before launch" bash -c "[[ ${s} -eq 1 && ${s2} -eq 1 ]] && grep -q 'pvxs-9.9.9, but the selected pvxs is pvxs-1.5.2' '${D}/pvxs.err' && grep -q 'Remove the other version from LD_LIBRARY_PATH' '${D}/pvxs.err' && ! grep -q 'softIocPVX.dbd' '${D}/pvxs.run'"
mkdir "${D}/vendor.moved"; mv "${FC}"/vendor/lib/libopen62541.so* "${D}/vendor.moved/"
iocsh.bash -n "$(st op 'module opcua')" > "${D}/novendor.show" 2> "${D}/novendor.err"; s=$?; printf 'vendor library removed: status %s\n' "${s}"; cut -c1-300 "${D}/novendor.err"; grep 'open62541' "${D}/novendor.show" | head -n 2
mv "${D}"/vendor.moved/* "${FC}/vendor/lib/"
iocsh_test_check "a NEEDED entry without a file is refused" bash -c "[[ ${s} -eq 1 ]] && grep -q 'libopen62541.so.* needed by .*libopcua.so.* resolves to no file' '${D}/novendor.err'"

EX="${IOCSH_TEST_REPO}/examples/iocsh/st.cmd"
cp -p "${FM}/linStat-1.2.1/dbd/linStat.dbd" "${D}/linStat.dbd.saved"
chmod u+w "${FM}/linStat-1.2.1/dbd/linStat.dbd"; printf 'recordtype(iocshbroken) {\n    field(\n' >> "${FM}/linStat-1.2.1/dbd/linStat.dbd"
iocsh.bash -v "${EX}" < /dev/null > "${D}/dbdfault.log" 2>&1; s=$?
cp -p "${D}/linStat.dbd.saved" "${FM}/linStat-1.2.1/dbd/linStat.dbd"
iocsh_test_plain "${D}/dbdfault.log" > "${D}/dbdfault.plain"
printf 'damaged DBD: status %s\n' "${s}"; grep -n -i -E 'error|break' "${D}/dbdfault.plain" | cut -c1-200 | head -n 8
iocsh_test_check "a failed DBD load stops before the application DB and iocInit" bash -c "[[ ${s} -ne 0 ]] && ! grep -q '^dbLoadRecords' '${D}/dbdfault.plain' && ! grep -q -- '${IOCSH_TEST_READY_TEXT}' '${D}/dbdfault.plain' && ! grep -q '^iocshLoad(\"/dev/fd/4\")' '${D}/dbdfault.plain'"
LIB="${FM}/linStat-1.2.1/lib/${A}/liblinStat.so"; cp -p "${LIB}" "${D}/liblinStat.so.saved"
# Cut the file just behind its dynamic section, inside the last loadable segment.
CUT=$(readelf -lW "${LIB}" | awk '$1=="DYNAMIC"{print strtonum($2)+strtonum($5)+16}')
LOADEND=$(readelf -lW "${LIB}" | awk '$1=="LOAD"{e=strtonum($2)+strtonum($5)} END{print e}')
printf 'library size %s, cut at %s, last loadable segment ends at %s\n' "$(stat -c %s "${LIB}")" "${CUT}" "${LOADEND}"
chmod u+w "${LIB}"; truncate -s "${CUT}" "${LIB}"
iocsh.bash -n "${EX}" > /dev/null 2> "${D}/libfault.show.err"; ss=$?
iocsh.bash -v "${EX}" < /dev/null > "${D}/libfault.log" 2>&1; s=$?
bash "${IOCSH_TEST_TREE}/base/bin/${A}/iocsh_elf.bash" undefined --object "${LIB}" > "${D}/libfault.undefined" 2>&1; su=$?
iocsh_test_plain "${D}/libfault.log" > "${D}/libfault.plain"
printf 'truncated library: show status %s, real start status %s, undefined mode status %s\n' "${ss}" "${s}" "${su}"; cut -c1-330 "${D}/libfault.show.err"; grep -c '^truncated ' "${D}/libfault.undefined" | sed 's/^/undefined mode truncated lines: /'
iocsh_test_check "a library cut inside its loadable segments is refused before launch in both modes" bash -c "[[ ${ss} -eq 1 && ${s} -eq 1 ]] && grep -q 'liblinStat.so is truncated: its size is ${CUT} bytes, but its last loadable segment ends at ${LOADEND}' '${D}/libfault.show.err' && ! grep -q 'softIocPVX.dbd' '${D}/libfault.plain'"
iocsh_test_check "the undefined mode reports the truncated object" bash -c "[[ ${su} -eq 1 ]] && grep -q '^truncated .*liblinStat.so\$' '${D}/libfault.undefined'"
# A cut behind the loadable segments removes debug information only.
cp -p "${D}/liblinStat.so.saved" "${LIB}"; chmod u+w "${LIB}"; truncate -s $((LOADEND + 4096)) "${LIB}"
printf 'iocInit()\n' > /dev/null
iocsh_test_ioc_start tail "${D}/libtail.log" "${EX}"; s=$?; sleep 2
printf 'library cut behind its loadable segments: start %s, MEM_FREE %s\n' "${s}" "$(caget -t EPICSENV:MEM_FREE 2>&1)"; iocsh_test_ioc_stop tail
iocsh_test_check "a library cut behind its loadable segments still loads and the IOC runs" iocsh_test_eq "${s}" 0
cp -p "${D}/liblinStat.so.saved" "${LIB}"

iocsh_test_section "generator rejections through the shipped make rules"
iocsh_test_env
cd "${S}" || exit 2
function mk { local tag="$1"; shift; make "$@" > "${D}/make-${tag}.out" 2>&1; local s=$?; printf 'make %s: status %s\n' "$*" "${s}"; grep 'iocsh_metadata.bash:' "${D}/make-${tag}.out" | cut -c1-420; return "${s}"; }
cp -p configure/CONFIG_MODS_IOCSH "${D}/CONFIG_MODS_IOCSH.saved"
function restore_src {
    cp -p "${D}/CONFIG_MODS_IOCSH.saved" configure/CONFIG_MODS_IOCSH
    [[ ! -f "${D}/measComp.site.saved" ]] || cp -p "${D}/measComp.site.saved" measComp-src/configure/CONFIG_SITE.local
}
trap restore_src EXIT
mk default-rule install.StreamDevice StreamDevice_IOCSH_LIBS= StreamDevice_IOCSH_DBDS=
iocsh_test_check "the refused module has no loader metadata and the message says so" bash -c "[[ ! -e '${M}/StreamDevice-2.8.26/cfg/iocsh.conf' && ! -e '${M}/StreamDevice-2.8.26/cfg/iocsh.conf.sha256' ]] && grep -q 'StreamDevice 2.8.26 is installed without loader metadata' '${D}/make-default-rule.out' && grep -q 'run make build.StreamDevice again' '${D}/make-default-rule.out'"
iocsh_test_check "default-rule files absent without a declaration fail the installation" grep -q 'Library entry for StreamDevice is absent: .*libStreamDevice.so; declare <module>_IOCSH_LIBS' "${D}/make-default-rule.out"
sed -i 's/^StreamDevice_IOCSH_DBDS:=.*/StreamDevice_IOCSH_DBDS:=streamApp.dbd/' configure/CONFIG_MODS_IOCSH
mk expanded-dbd install.StreamDevice
iocsh_test_check "an expanded application DBD is rejected" grep -q 'streamApp.dbd defines Base .* with a body, so it is an expanded application DBD' "${D}/make-expanded-dbd.out"
cp -p "${D}/CONFIG_MODS_IOCSH.saved" configure/CONFIG_MODS_IOCSH
sed -i 's/^pmac_IOCSH_DBDS:=.*/pmac_IOCSH_DBDS:=pmacInclude.dbd/' configure/CONFIG_MODS_IOCSH
mk unprovided-entry install.pmac
iocsh_test_check "a DBD entry that no library exports is rejected" grep -q 'DBD entries of pmac have no providing library' "${D}/make-unprovided-entry.out"
cp -p "${D}/CONFIG_MODS_IOCSH.saved" configure/CONFIG_MODS_IOCSH
iocsh_test_check "the refused pmac has no loader metadata" test ! -e "${M}/pmac-2.7.9/cfg/iocsh.conf"
mk restore-sd install.StreamDevice; s1=$?; mk restore-pmac install.pmac; s2=$?
iocsh_test_check "both modules install again with the shipped mapping, metadata, and digest" bash -c "[[ ${s1}${s2} == 00 ]] && for m in StreamDevice-2.8.26 pmac-2.7.9; do bash '${S}/tools/iocsh_metadata.bash' check --install \"${M}/\${m}\" --base '${T}/base' > /dev/null || exit 1; done"

iocsh_test_section "a library with undefined symbols is rejected at installation"
MC="${M}/measComp-c38974e"; OBJ=$(find measComp-src -path '*O.linux-x86_64/libmeasComp.so' | head -n1)
cp -p measComp-src/configure/CONFIG_SITE.local "${D}/measComp.site.saved"
readelf -d "${MC}/lib/${A}/libmeasComp.so" | grep -c 'NEEDED.*uldaq' | sed 's/^/uldaq in NEEDED before: /'
sed -i '/^measComp_LIBS_Linux/d' measComp-src/configure/CONFIG_SITE.local; rm -f "${OBJ}"
mk undefined build.measComp; grep -B6 'iocsh_metadata.bash:' "${D}/make-undefined.out" | grep '^undefined\|^missing' | head -n 5
readelf -d "${MC}/lib/${A}/libmeasComp.so" | grep -c 'NEEDED.*uldaq' | sed 's/^/uldaq in NEEDED after the build without the link line: /'
iocsh_test_check "the build fails with the undefined-symbol count" grep -q -E 'Libraries of measComp leave [0-9]+ symbols or files unresolved' "${D}/make-undefined.out"
grep 'iocsh_metadata.bash: .*installed without\|iocsh_metadata.bash: After' "${D}/make-undefined.out" | cut -c1-260
iocsh_test_check "the message names the site configuration line, the state, and the target" bash -c "grep -q 'add <library>_LIBS_Linux += <name> to the conf rule of the module in configure/RULES_MODS_CONFIG' '${D}/make-undefined.out' && grep -q 'measComp c38974e is installed without loader metadata' '${D}/make-undefined.out' && grep -q 'run make build.measComp again' '${D}/make-undefined.out'"
LISTCMD=$(sed -n 's/^iocsh_metadata.bash: List every finding with: //p' "${D}/make-undefined.out")
bash -c "${LISTCMD}" > "${D}/undefined.full" 2>&1; printf 'the printed list command: status %s, %s lines\n' $? "$(wc -l < "${D}/undefined.full")"
iocsh_test_check "the printed command lists every finding" iocsh_test_eq "$(wc -l < "${D}/undefined.full")" "$(sed -n 's/.*Libraries of measComp leave \([0-9]*\) symbols.*/\1/p' "${D}/make-undefined.out")"
iocsh_test_check "the rejected module has no loader metadata" test ! -e "${MC}/cfg/iocsh.conf" -a ! -e "${MC}/cfg/iocsh.conf.sha256"
iocsh.bash -n "$(st mc 'module measComp')" > /dev/null 2> "${D}/stale.err"; s=$?; printf 'wrapper show status for measComp after the rejected build: %s\n' "${s}"; head -n 2 "${D}/stale.err" | cut -c1-200
iocsh_test_check "the wrapper refuses the rejected module" bash -c "[[ ${s} -eq 1 ]] && grep -q 'Module measComp c38974e has no loader metadata' '${D}/stale.err'"
cp -p "${D}/measComp.site.saved" measComp-src/configure/CONFIG_SITE.local; rm -f "${OBJ}"
mk measComp-restore build.measComp
readelf -d "${MC}/lib/${A}/libmeasComp.so" | grep -c 'NEEDED.*uldaq' | sed 's/^/uldaq in NEEDED after the restoring build: /'
iocsh_test_check "the restoring build records uldaq and consistent metadata" bash -c "readelf -d '${MC}/lib/${A}/libmeasComp.so' | grep -q 'NEEDED.*uldaq' && bash '${S}/tools/iocsh_metadata.bash' check --install '${MC}' --base '${T}/base' > /dev/null"
trap - EXIT; rm -f "${D}/measComp.site.saved"
mk full-install install; s=$?
iocsh_test_check "the full installation succeeds afterwards" iocsh_test_eq "${s}" 0
iocsh_test_summary
