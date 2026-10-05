#!/usr/bin/env bash
# Observes how the native executable and readelf treat a truncated library.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/trunc"; rm -rf "${D}"; mkdir -p "${D}"; cd "${D}" || exit 2
iocsh_test_env
SRC="${EPICS_MODULES}/linStat/lib/${EPICS_HOST_ARCH}/liblinStat.so"
SIZE=$(stat -c %s "${SRC}")
DYN=$(readelf -lW "${SRC}" | awk '$1=="DYNAMIC"{print strtonum($2)+strtonum($5)}')
LOADEND=$(readelf -lW "${SRC}" | awk '$1=="LOAD"{e=strtonum($2)+strtonum($5)} END{print e}')
SHOFF=$(readelf -hW "${SRC}" | awk -F: '/Start of section headers/{print $2+0}')
printf 'size %s, dynamic section ends %s, last loadable segment ends %s, section headers start %s\n' "${SIZE}" "${DYN}" "${LOADEND}" "${SHOFF}"
ldd --version | head -n1
for cut in "$((DYN + 16))" "$((LOADEND + 4096))" "$((SIZE - 1000))"; do
    cp "${SRC}" "${D}/lib.so"; truncate -s "${cut}" "${D}/lib.so"
    printf 'dlload("%s")\n' "${D}/lib.so" > "${D}/t.cmd"
    softIocPVX -D "${EPICS_MODULES}/pvxs/dbd/softIocPVX.dbd" "${D}/t.cmd" < /dev/null > "${D}/out" 2>&1; s=$?
    printf '\ncut at %s: softIocPVX status %s; %s\n' "${cut}" "${s}" "$(iocsh_test_plain "${D}/out" | grep -a -i -E 'error|short|cannot|invalid' | head -n 2 | tr '\n' '~' | cut -c1-200)"
    readelf -h -d -W "${D}/lib.so" > "${D}/re.out" 2> "${D}/re.err"; printf 'readelf -h -d status %s, stderr lines %s: %s\n' $? "$(wc -l < "${D}/re.err")" "$(head -n 1 "${D}/re.err" | cut -c1-150)"
    o=0; e=0; n=0
    eval "$(readelf -hW "${D}/lib.so" 2>/dev/null | awk -F: '/Start of section headers/{printf "o=%d;", $2} /Size of section headers/{printf "e=%d;", $2} /Number of section headers/{printf "n=%d;", $2}')"
    printf 'section header table ends at %s, file size %s: %s\n' "$((o + e * n))" "${cut}" "$([[ $((o + e * n)) -le ${cut} ]] && echo fits || echo 'beyond the end of the file')"
done
