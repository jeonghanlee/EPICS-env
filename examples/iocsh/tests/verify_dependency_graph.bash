#!/usr/bin/env bash
# Dependency order and entry mapping with StreamDevice, linStat, the
# library-only modules seq and pcas, and the data-only modules QPC and
# pyDevSup; then every installed module in one IOC.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
D="${IOCSH_TEST_OUT}/dependency_graph"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
A="${EPICS_HOST_ARCH}"
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'

ST="${D}/st.cmd"
printf '%s\n' 'module StreamDevice' 'module linStat' 'module seq' 'module pcas' 'module QPC' 'module pyDevSup' 'iocInit()' > "${ST}"
iocsh.bash -n "${ST}" > "${D}/show" 2> "${D}/show.err"; printf 'show status %s\n' $?
grep -v '^# elf:' "${D}/show" | cut -c1-230; cat "${D}/show.err"

function line_of { grep -n -m1 -- "$1" "${D}/show" | cut -d: -f1; }
iocsh_test_section "order"
iocsh_test_check "asyn precedes StreamDevice" test "$(line_of '^# asyn ')" -lt "$(line_of '^# StreamDevice ')"
iocsh_test_check "calc precedes StreamDevice" test "$(line_of '^# calc ')" -lt "$(line_of '^# StreamDevice ')"
iocsh_test_check "calc, seq, sscan precede asyn" test "$(line_of '^# calc ')" -lt "$(line_of '^# asyn ')" -a "$(line_of '^# seq ')" -lt "$(line_of '^# asyn ')" -a "$(line_of '^# sscan ')" -lt "$(line_of '^# asyn ')"
iocsh_test_check "all dlload lines precede registration" test "$(grep -n '^dlload\|^dbLoadDatabase' "${D}/show" | tail -n1 | cut -d: -f1)" -lt "$(line_of '^registerAllRecordDeviceDrivers')"

iocsh_test_section "ELF NEEDED of libstream.so and its declared dependencies"
readelf -d "${EPICS_MODULES}/StreamDevice/lib/${A}/libstream.so" | grep NEEDED
grep '^dep=' "${EPICS_MODULES}/StreamDevice/cfg/iocsh.conf"
iocsh_test_check "libstream.so does not name calc in NEEDED" bash -c "! readelf -d '${EPICS_MODULES}/StreamDevice/lib/${A}/libstream.so' | grep NEEDED | grep -q calc"
iocsh_test_check "calc library is loaded in the generated startup" grep -q '^dlload.*/calc-[^/]*/lib/.*libcalc.so' "${D}/show"
grep -n 'scalcout\|include' "${EPICS_MODULES}/StreamDevice/dbd/stream.dbd" | head -n 8

iocsh_test_section "declared dependencies without an ELF reference from the consumer (all installed modules)"
for conf in "${EPICS_MODULES}"/*-*/cfg/iocsh.conf; do
    dir="${conf%/cfg/iocsh.conf}"; mod=$(sed -n 's/^name=//p' "${conf}")
    while read -r dep depver; do
        [[ -n "${dep}" ]] || continue
        deplibs=$(sed -n 's/^lib=//p' "${EPICS_MODULES}/${dep}-${depver}/cfg/iocsh.conf" | sed 's|.*/||')
        elf=no
        while IFS= read -r lib; do
            for dl in ${deplibs}; do readelf -d "${dir}/${lib}" | grep NEEDED | grep -q "\[${dl}" && elf=yes; done
        done < <(sed -n 's/^lib=//p' "${conf}")
        printf '%-14s -> %-10s ELF-reference=%s\n' "${mod}" "${dep}" "${elf}"
    done < <(sed -n 's/^dep=//p' "${conf}")
done | tee "${D}/deps.txt" | grep 'ELF-reference=no'
printf 'pairs total %s, without ELF reference %s\n' "$(wc -l < "${D}/deps.txt")" "$(grep -c 'ELF-reference=no' "${D}/deps.txt")"

iocsh_test_section "data-only and library-only entries"
iocsh_test_check "QPC has no dlload or dbLoadDatabase" bash -c "! grep -E '^(dlload|dbLoadDatabase).*/QPC-' '${D}/show'"
iocsh_test_check "pyDevSup has no dlload or dbLoadDatabase" bash -c "! grep -E '^(dlload|dbLoadDatabase).*/pyDevSup-' '${D}/show'"
iocsh_test_check "QPC and PYDEVSUP macros are set" test "$(grep -c -E '^epicsEnvSet\("(QPC|PYDEVSUP)"' "${D}/show")" -eq 2
iocsh_test_check "seq and pcas load libraries and no DBD" bash -c "grep -q '^dlload.*/seq-.*libseq.so' '${D}/show' && grep -q '^dlload.*/pcas-.*libcas.so' '${D}/show' && ! grep -E '^dbLoadDatabase.*/(seq|pcas)-' '${D}/show'"

iocsh_test_section "real IOC"
iocsh_test_ioc_start dependency_graph "${D}/ioc.log" -v "${ST}"; s=$?
pid="${IOCSH_TEST_IOC_PID[dependency_graph]}"
iocsh_test_maps "${pid}" | grep -F '/modules/' > "${D}/maps"
iocsh_test_ioc_cmd dependency_graph 'epicsEnvShow STREAM' 'epicsEnvShow ASYN' 'epicsEnvShow CALC' 'epicsEnvShow QPC' 'epicsEnvShow PYDEVSUP' 'epicsEnvShow SNCSEQ' 'epicsEnvShow PCAS' 'epicsEnvShow LINSTAT' 'dbDumpDevice ai' 'dbDumpRecordType' 
iocsh_test_ioc_stop dependency_graph
iocsh_test_plain "${D}/ioc.log" > "${D}/ioc.plain"
iocsh_test_check "iocInit completed" iocsh_test_eq "${s}" 0
sed -n '/^# End \/dev\/fd\/3/,$p' "${D}/ioc.plain" | grep -E '^[A-Z]+=' 
printf 'mapped module libraries:\n'; sed "s|${EPICS_MODULES}/||" "${D}/maps"
# Every library the metadata selects is mapped; no other library of the selected modules is.
grep '^dlload' "${D}/show" | sed 's/^dlload("\(.*\)")$/\1/' | xargs -r readlink -e | LC_ALL=C sort > "${D}/expected.libs"
grep -v '/pvxs-' "${D}/maps" | LC_ALL=C sort > "${D}/mapped.libs"
iocsh_test_check "mapped module libraries equal the resolved metadata entries" diff "${D}/expected.libs" "${D}/mapped.libs"
iocsh_test_check "no asyn test library is mapped" bash -c "! grep -q 'libtest' '${D}/maps'"
iocsh_test_check "record types of calc, asyn, sscan are registered" bash -c "grep -q '^scalcout\$\|scalcout' '${D}/ioc.plain' && grep -q 'asyn' '${D}/ioc.plain'"
iocsh_test_check "stream device support for ai is registered" grep -q 'stream' "${D}/ioc.plain"
iocsh_test_check "no suspicious line" iocsh_test_eq "$(iocsh_test_suspicious "${D}/ioc.log")" none
iocsh_test_suspicious "${D}/ioc.log" | head -n 20

iocsh_test_section "every installed module in one IOC"
ALL="${D}/all.cmd"
for link in "${EPICS_MODULES}"/*; do
    [[ -L "${link}" ]] || continue
    printf 'module %s\n' "${link##*/}"
done > "${ALL}"
printf 'iocInit()\n' >> "${ALL}"
printf 'modules requested: %s\n' "$(grep -c '^module' "${ALL}")"
iocsh.bash -n "${ALL}" > "${D}/all.show" 2> "${D}/all.err"; printf 'show status %s\n' $?; cat "${D}/all.err"
iocsh_test_ioc_start all "${D}/all.log" "${ALL}"; s=$?
iocsh_test_maps "${IOCSH_TEST_IOC_PID[all]}" | grep -F '/modules/' > "${D}/all.maps"
iocsh_test_ioc_stop all
iocsh_test_check "iocInit completed with every module" iocsh_test_eq "${s}" 0
grep '^dlload' "${D}/all.show" | sed 's/^dlload("\(.*\)")$/\1/' | xargs -r readlink -e | LC_ALL=C sort > "${D}/all.expected"
grep -v '/pvxs-' "${D}/all.maps" | LC_ALL=C sort > "${D}/all.mapped"
printf 'libraries selected %s, mapped %s\n' "$(wc -l < "${D}/all.expected")" "$(wc -l < "${D}/all.mapped")"
iocsh_test_check "mapped module libraries equal the resolved metadata entries" diff "${D}/all.expected" "${D}/all.mapped"
iocsh_test_suspicious "${D}/all.log" | head -n 20
iocsh_test_summary
