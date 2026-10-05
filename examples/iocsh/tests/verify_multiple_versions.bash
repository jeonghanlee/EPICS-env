#!/usr/bin/env bash
# Multiple versions with the pin-related parts of the installation check: a second real version of linStat and
# of asyn built and installed through the shipped rules, exact and default
# selection, the alias publication check, stale build identities, and a
# source checkout that is not at the pinned tag. The pins and source trees
# are restored at the end; the second versions stay installed.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/multiple_versions"; rm -rf "${D}"; mkdir -p "${D}"
S="${IOCSH_TEST_REPO}"; T="${IOCSH_TEST_TREE}"; M="${T}/modules"; cd "${S}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
cp configure/RELEASE.local "${D}/RELEASE.local.orig"
function pins { cp "${D}/RELEASE.local.orig" configure/RELEASE.local; [[ $# -eq 0 ]] || printf '%s\n' "$@" >> configure/RELEASE.local; }
function mk { local tag="$1"; shift; make "$@" > "${D}/make-${tag}.out" 2>&1; local s=$?; printf 'make %s: status %s\n' "$*" "${s}"; return "${s}"; }
function show_sel { # prints the versions the show mode selects
    printf '%s\n' "$@" 'iocInit()' > "${D}/sel.cmd"
    iocsh.bash -n "${D}/sel.cmd" 2> "${D}/sel.err" | grep -E '^# [A-Za-z]' | grep -v 'iocsh.bash\|elf:' | tr '\n' ';'; printf ' status %s\n' "${PIPESTATUS[0]}"
}
function ioc_maps { # starts the IOC with the given lines and prints mapped module libraries
    printf '%s\n' "$@" 'iocInit()' > "${D}/run.cmd"
    iocsh_test_ioc_start sel "${D}/run.log" "${D}/run.cmd"; local s=$?
    iocsh_test_maps "${IOCSH_TEST_IOC_PID[sel]}" | grep -F '/modules/' | grep -v '/pvxs-' | sed "s|${M}/||"
    iocsh_test_ioc_stop sel > /dev/null
    return "${s}"
}
iocsh_test_env
# A failed step must not leave the pins, the source trees, or the aliases changed.
function restore_all {
    cd "${S}" || return
    cp "${D}/RELEASE.local.orig" configure/RELEASE.local
    if [[ -d "${D}/linStat-src.pinned" ]]; then rm -rf linStat-src; mv "${D}/linStat-src.pinned" linStat-src; make conf.linStat > /dev/null 2>&1; fi
    if [[ -d "${D}/asyn-src.pinned" ]]; then rm -rf asyn-src; mv "${D}/asyn-src.pinned" asyn-src; make conf.asyn > /dev/null 2>&1; fi
    ln -sfn ./linStat-1.2.1 "${M}/linStat"; ln -sfn ./asyn-4.46.0 "${M}/asyn"
}
trap restore_all EXIT

iocsh_test_section "second linStat version through the documented bump steps"
pins 'SRC_TAG_LINSTAT:=tags/1.1.1' 'SRC_VER_LINSTAT:=1.1.1'
make print-INSTALL_LOCATION_LINSTAT
mv linStat-src "${D}/linStat-src.pinned"
mk clone LINSTAT; git -C linStat-src describe --tags; mk conf conf.linStat; mk deps check.module-deps MODULE=linStat
mk build build.linStat; tail -n 3 "${D}/make-build.out" | cut -c1-200
iocsh_test_check "linStat 1.1.1 is installed with metadata" test -s "${M}/linStat-1.1.1/cfg/iocsh.conf" -a -s "${M}/linStat-1.1.1/cfg/build-record"
grep -E '^(version|tag|source)=' "${M}/linStat-1.1.1/cfg/build-record"
iocsh_test_check "the other version survives" test -s "${M}/linStat-1.2.1/cfg/iocsh.conf" -a -s "${M}/linStat-1.2.1/lib/${EPICS_HOST_ARCH}/liblinStat.so"
iocsh_test_check "the default alias still points at 1.2.1 before symlink.linStat" iocsh_test_eq "$(readlink "${M}/linStat")" "./linStat-1.2.1"
iocsh_test_check "the two libraries differ" bash -c "! cmp -s '${M}/linStat-1.1.1/lib/${EPICS_HOST_ARCH}/liblinStat.so' '${M}/linStat-1.2.1/lib/${EPICS_HOST_ARCH}/liblinStat.so'"

iocsh_test_section "exact and default selection, alias at 1.2.1"
printf 'default:      '; show_sel 'module linStat'
printf 'exact 1.1.1:  '; show_sel 'module linStat 1.1.1'
printf 'exact 1.2.1:  '; show_sel 'module("linStat", "1.2.1")'
printf 'absent 9.9.9: '; show_sel 'module linStat 9.9.9'; cat "${D}/sel.err"
iocsh_test_check "an unavailable version is refused before launch" grep -q 'Module linStat 9.9.9 is not installed under' "${D}/sel.err"
printf 'conflict:     '; show_sel 'module linStat 1.1.1' 'm linStat 1.2.1'; cat "${D}/sel.err"; cp "${D}/sel.err" "${D}/conflict-direct.err"
iocsh_test_check "two versions in one IOC are refused with both locations" bash -c "grep -q 'Module version conflict: linStat' '${D}/conflict-direct.err' && grep -q 'Requested: 1.2.1 at sel.cmd:2' '${D}/conflict-direct.err' && grep -q 'Selected:  1.1.1 at sel.cmd:1' '${D}/conflict-direct.err'"
iocsh_test_check "real IOC, exact 1.1.1 maps only linStat-1.1.1" iocsh_test_eq "$(ioc_maps 'module linStat 1.1.1')" "linStat-1.1.1/lib/${EPICS_HOST_ARCH}/liblinStat.so"
iocsh_test_check "real IOC, default maps only linStat-1.2.1" iocsh_test_eq "$(ioc_maps 'module linStat')" "linStat-1.2.1/lib/${EPICS_HOST_ARCH}/liblinStat.so"

iocsh_test_section "alias publication"
mv "${M}/linStat-1.1.1/cfg/iocsh.conf" "${D}/iocsh.conf.saved"
mk symlink-fault symlink.linStat; tail -n 3 "${D}/make-symlink-fault.out" | cut -c1-220
printf 'alias after the failed publication: [%s]\n' "$(readlink "${M}/linStat" 2>/dev/null || echo absent)"
iocsh_test_check "an installation without metadata is not published" bash -c "! grep -q 'status 0' <<< \"\$(tail -n1 '${D}/make-symlink-fault.out')\" && [[ \"\$(readlink '${M}/linStat' 2>/dev/null)\" != './linStat-1.1.1' ]]"
mv "${D}/iocsh.conf.saved" "${M}/linStat-1.1.1/cfg/iocsh.conf"
mk symlink symlink.linStat
iocsh_test_check "the alias points at 1.1.1 after symlink.linStat" iocsh_test_eq "$(readlink "${M}/linStat")" "./linStat-1.1.1"
printf 'default:      '; show_sel 'module linStat'
printf 'exact 1.2.1:  '; show_sel 'm "linStat" "1.2.1"'
iocsh_test_check "real IOC, default follows the alias to 1.1.1" iocsh_test_eq "$(ioc_maps 'module linStat')" "linStat-1.1.1/lib/${EPICS_HOST_ARCH}/liblinStat.so"
iocsh_test_check "real IOC, exact 1.2.1 against the alias" iocsh_test_eq "$(ioc_maps 'mod("linStat", "1.2.1")')" "linStat-1.2.1/lib/${EPICS_HOST_ARCH}/liblinStat.so"
NIC=$(ip route show default | awk '{print $5; exit}'); export NIC
iocsh_test_ioc_start ex "${D}/example-1.1.1.log" "${S}/examples/iocsh/st.cmd"; s=$?; sleep 3
printf 'minimal example with the 1.1.1 default: start %s, MEM_FREE %s\n' "${s}" "$(caget -t EPICSENV:MEM_FREE 2>&1)"; iocsh_test_ioc_stop ex

iocsh_test_section "stale build identities"
pins 'SRC_TAG_LINSTAT:=tags/1.1.1'
mk stale-tag install.linStat; grep -i 'iocsh_metadata' "${D}/make-stale-tag.out" | cut -c1-260
iocsh_test_check "the refusal states the resulting state and the target to run" bash -c "grep -q 'linStat 1.2.1 is installed without loader metadata; iocsh.bash refuses it' '${D}/make-stale-tag.out' && grep -q 'After the correction, run make build.linStat again' '${D}/make-stale-tag.out'"
iocsh_test_check "the refused module has no loader metadata" test ! -e "${M}/linStat-1.2.1/cfg/iocsh.conf" -a ! -e "${M}/linStat-1.2.1/cfg/iocsh.conf.sha256"
printf 'exact 1.2.1 after the refusal: '; show_sel 'module linStat 1.2.1'; cat "${D}/sel.err"
iocsh_test_check "the wrapper refuses the module without metadata" grep -q 'Module linStat 1.2.1 has no loader metadata' "${D}/sel.err"
iocsh_test_check "a changed tag without a rebuild fails the installation" grep -q 'Stale tag in .*linStat-1.2.1/cfg/build-record: recorded tags/1.2.1, effective tags/1.1.1' "${D}/make-stale-tag.out"
pins
mk wrong-source build.linStat; grep -i 'iocsh_metadata' "${D}/make-wrong-source.out" | cut -c1-300
iocsh_test_check "a checkout that is not at the pinned tag fails the build record" grep -q 'Source checkout .*linStat-src is at .*, but the pinned tag tags/1.2.1 is' "${D}/make-wrong-source.out"
find "${M}/linStat-1.2.1/cfg" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort | tr '\n' ' '; printf '(files of 1.2.1 after the two refusals)\n'

iocsh_test_section "restore linStat"
rm -rf linStat-src; mv "${D}/linStat-src.pinned" linStat-src
mk conf-restore conf.linStat; mk install-restore install.linStat; mk symlink-restore symlink.linStat
iocsh_test_check "linStat pin, alias, metadata, and digest are restored" bash -c "[[ \"\$(readlink '${M}/linStat')\" == './linStat-1.2.1' ]] && [[ -s '${M}/linStat-1.2.1/cfg/iocsh.conf' && -s '${M}/linStat-1.2.1/cfg/iocsh.conf.sha256' ]] && git -C linStat-src describe --tags | grep -q '^1.2.1\$'"

iocsh_test_section "second asyn version; StreamDevice keeps its recorded asyn"
pins 'SRC_TAG_ASYN:=66bafcde239ddc902000e9ec380872c8b621fdf9' 'SRC_VER_ASYN:=66bafcd'
mv asyn-src "${D}/asyn-src.pinned"
mk asyn-clone ASYN; git -C asyn-src rev-parse HEAD; mk asyn-conf conf.asyn
mk asyn-build build.asyn; tail -n 2 "${D}/make-asyn-build.out" | cut -c1-200
iocsh_test_check "asyn 66bafcd is installed with metadata" test -s "${M}/asyn-66bafcd/cfg/iocsh.conf"
mk asyn-symlink symlink.asyn
iocsh_test_check "the asyn alias points at 66bafcd" iocsh_test_eq "$(readlink "${M}/asyn")" "./asyn-66bafcd"
printf 'StreamDevice:          '; show_sel 'module StreamDevice'
printf 'asyn default:          '; show_sel 'module asyn'
printf 'asyn then StreamDevice: '; show_sel 'module asyn' 'module StreamDevice'; cat "${D}/sel.err"; cp "${D}/sel.err" "${D}/conflict-transitive.err"
iocsh_test_check "a transitive conflict names the dependency chain" bash -c "grep -q 'Module version conflict: asyn' '${D}/conflict-transitive.err' && grep -q 'Requested: 4.46.0 at StreamDevice 2.8.26 (sel.cmd:2)' '${D}/conflict-transitive.err' && grep -q 'Selected:  66bafcd at sel.cmd:1' '${D}/conflict-transitive.err'"
ioc_maps 'module StreamDevice' > "${D}/stream.maps"; cat "${D}/stream.maps"
iocsh_test_check "real IOC, StreamDevice maps asyn-4.46.0 although the alias is 66bafcd" bash -c "grep -q '^asyn-4.46.0/' '${D}/stream.maps' && ! grep -q '^asyn-66bafcd/' '${D}/stream.maps'"
ioc_maps 'module asyn' > "${D}/asyn.maps"
iocsh_test_check "real IOC, default asyn maps asyn-66bafcd" bash -c "grep -q '^asyn-66bafcd/' '${D}/asyn.maps' && ! grep -q '^asyn-4.46.0/' '${D}/asyn.maps'"

iocsh_test_section "restore asyn"
pins
rm -rf asyn-src; mv "${D}/asyn-src.pinned" asyn-src
mk asyn-conf-restore conf.asyn; mk asyn-symlink-restore symlink.asyn; mk asyn-install-restore install.asyn
iocsh_test_check "asyn pin and alias are restored" iocsh_test_eq "$(readlink "${M}/asyn")" "./asyn-4.46.0"
cmp configure/RELEASE.local "${D}/RELEASE.local.orig" && printf 'RELEASE.local restored\n'
trap - EXIT

iocsh_test_section "full installation after the module-level operations"
mk full-install install; s=$?
iocsh_test_check "full installation succeeds with the second versions present" iocsh_test_eq "${s}" 0
for v in linStat-1.1.1 linStat-1.2.1 asyn-66bafcd asyn-4.46.0; do bash "${S}/tools/iocsh_metadata.bash" check --install "${M}/${v}" --base "${T}/base"; done
printf '%s\n' "${M}"/linStat-* "${M}"/asyn-* | sed "s|${M}/||" | tr '\n' ' '; printf '\n'
iocsh_test_summary
