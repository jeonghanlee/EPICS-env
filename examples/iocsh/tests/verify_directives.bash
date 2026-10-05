#!/usr/bin/env bash
# The six directive forms for each of m, mod, and module, compared
# through the show mode and loaded in the real IOC.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
iocsh_test_env
D="${IOCSH_TEST_OUT}/directives"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
VER=$(basename "$(readlink -e "${EPICS_MODULES}/linStat")"); VER="${VER#linStat-}"
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'linStat default version %s\n' "${VER}"

iocsh_test_section "18 forms through the show mode"
n=0
for kw in m mod module; do
    forms=("${kw} linStat" "${kw} \"linStat\"" "${kw}(\"linStat\")" "${kw} linStat ${VER}" "${kw} \"linStat\" \"${VER}\"" "${kw}(\"linStat\", \"${VER}\")")
    for form in "${forms[@]}"; do
        n=$((n + 1))
        f="${D}/form-${n}.cmd"
        printf '%s\n%s\n%s\n' '# form test' "${form}" 'epicsEnvSet("IOCSH_TEST_FORM","x")' > "${f}"
        if iocsh.bash -n "${f}" > "${D}/form-${n}.show" 2> "${D}/form-${n}.err"; then status=0; else status=$?; fi
        grep -v '^# iocsh.bash:' "${D}/form-${n}.show" > "${D}/form-${n}.norm"
        printf '%2d status=%s sha=%s  %s\n' "${n}" "${status}" "$(sha256sum < "${D}/form-${n}.norm" | cut -c1-12)" "${form}"
    done
done
iocsh_test_check "18 forms were generated" iocsh_test_eq "${n}" 18
iocsh_test_check "all 18 normalized startups are identical" iocsh_test_eq "$(cat "${D}"/form-*.norm | sha256sum)" "$(for i in $(seq 1 18); do cat "${D}/form-1.norm"; done | sha256sum)"
iocsh_test_check "no form wrote a diagnostic" iocsh_test_eq "$(cat "${D}"/form-*.err | wc -c)" 0
printf 'normalized startup of form 1:\n'; grep -v '^# elf:' "${D}/form-1.norm"

iocsh_test_section "mixed file: comments, whitespace, duplicates, hyphenated name, ordinary commands"
MIX="${D}/mixed.cmd"
{
    printf '%s\n' '# module linStat 9.9.9 in a comment is not a directive'
    printf '%s\n' 'epicsEnvSet("IOCSH_TEST_A","module one")'
    printf '\t  module   linStat   # trailing comment\n'
    printf '%s\n' 'epicsEnvSet("IOCSH_TEST_B","mod two m three")'
    printf '%s\n' "mod(\"linStat\", \"${VER}\")"
    printf '%s\n' 'm "feed-core"'
    printf '%s\n' 'echo module linStat inside an ordinary command'
    printf '%s\n' "m linStat ${VER}"
    printf '%s\n' 'epicsEnvSet("IOCSH_TEST_C","modules")'
    printf '%s\n' 'iocInit()'
} > "${MIX}"
cat -A "${MIX}" | cut -c1-120
iocsh.bash -n "${MIX}" > "${D}/mixed.show" 2> "${D}/mixed.err"; printf 'show status %s\n' $?
grep -v '^# elf:' "${D}/mixed.show"; cat "${D}/mixed.err"
iocsh_test_check "linStat library appears once in the generated startup" iocsh_test_eq "$(grep -c 'liblinStat.so' "${D}/mixed.show")" 1
iocsh_test_check "feed library appears once in the generated startup" iocsh_test_eq "$(grep -c '^dlload.*libfeed.so' "${D}/mixed.show")" 1
iocsh_test_check "one registration call" iocsh_test_eq "$(grep -c '^registerAllRecordDeviceDrivers' "${D}/mixed.show")" 1

iocsh_test_section "real IOC with the mixed file"
iocsh_test_ioc_start mix "${D}/mixed.log" -v "${MIX}"; printf 'start status %s\n' $?
pid="${IOCSH_TEST_IOC_PID[mix]}"
iocsh_test_maps "${pid}" | grep -F '/modules/' > "${D}/mixed.maps"; cat "${D}/mixed.maps"
iocsh_test_ioc_cmd mix 'epicsEnvShow IOCSH_TEST_A' 'epicsEnvShow IOCSH_TEST_B' 'epicsEnvShow IOCSH_TEST_C' 'epicsEnvShow LINSTAT' 'epicsEnvShow FEEDCORE'
iocsh_test_ioc_stop mix
iocsh_test_plain "${D}/mixed.log" > "${D}/mixed.plain"
sed -n '/^iocshLoad("\/dev\/fd\/4")/,$p' "${D}/mixed.plain"
iocsh_test_check "iocInit completed" grep -q -- "${IOCSH_TEST_READY_TEXT}" "${D}/mixed.plain"
iocsh_test_check "linStat mapped once, version ${VER}" iocsh_test_eq "$(grep -c "linStat-${VER}/lib/.*liblinStat.so" "${D}/mixed.maps")" 1
iocsh_test_check "dlload lines are unique" iocsh_test_eq "$(grep -c '^dlload' "${D}/mixed.plain")" "$(grep '^dlload' "${D}/mixed.plain" | sort -u | wc -l)"
# The ordinary lines of the file, in order, as the IOC echoed them.
grep -v -E '^[[:space:]]*(m|mod|module)([[:space:]]|\()' "${MIX}" | grep -v '^#' > "${D}/mixed.expected"
sed -n '/^iocshLoad("\/dev\/fd\/4")/,/^iocInit()/p' "${D}/mixed.plain" | grep -E '^(epicsEnvSet|echo|iocInit)' > "${D}/mixed.observed"
iocsh_test_check "ordinary commands keep order and text" diff "${D}/mixed.expected" "${D}/mixed.observed"
iocsh_test_check "no suspicious line" iocsh_test_eq "$(iocsh_test_suspicious "${D}/mixed.log")" none

iocsh_test_section "real IOC with the default form and with the exact form"
for i in 1 18; do
    printf 'iocInit()\n' >> "${D}/form-${i}.cmd"
    iocsh_test_ioc_start "f${i}" "${D}/form-${i}.log" -v "${D}/form-${i}.cmd"; s=$?
    iocsh_test_maps "${IOCSH_TEST_IOC_PID[f${i}]}" | grep -F '/modules/linStat' > "${D}/form-${i}.maps"
    iocsh_test_ioc_stop "f${i}"
    iocsh_test_check "form ${i}: iocInit completed" iocsh_test_eq "${s}" 0
    iocsh_test_check "form ${i}: maps hold only linStat-${VER}" iocsh_test_eq "$(cat "${D}/form-${i}.maps")" "${EPICS_MODULES}/linStat-${VER}/lib/${EPICS_HOST_ARCH}/liblinStat.so"
done
iocsh_test_summary
