#!/usr/bin/env bash
# Checks of the review corrections through the shipped make rules: the link
# rule on an uninstalled module, metadata generation with a truncated
# dependency library, and the patch round trip with the site patch in the
# carry set. Every changed file of the tree and build root is restored.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/review"; rm -rf "${D}"; mkdir -p "${D}"
S="${IOCSH_TEST_REPO}"; T="${IOCSH_TEST_TREE}"; M="${T}/modules"; cd "${S}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'
iocsh_test_env
A="${EPICS_HOST_ARCH}"
function mk { local tag="$1"; shift; make "$@" > "${D}/make-${tag}.out" 2>&1; local s=$?; printf 'make %s: status %s\n' "$*" "${s}"; return "${s}"; }
function links { find "${M}" -maxdepth 1 -type l | wc -l; }
ASYN_LIB=$(readlink -e "${M}/asyn-4.46.0/lib/${A}/libasyn.so")
function restore_all {
    [[ ! -f "${D}/libasyn.keep" ]] || cp -p "${D}/libasyn.keep" "${ASYN_LIB}"
    rm -f "${M}/linStat-1.2.1/stray"
}
trap restore_all EXIT

iocsh_test_section "link rule on an uninstalled module"
LINKS_BEFORE=$(links)
mk uninstall uninstall.linStat
iocsh_test_check "uninstall.linStat leaves an empty module directory" bash -c "[[ -d '${M}/linStat-1.2.1' && -z \"\$(ls -A '${M}/linStat-1.2.1')\" ]]"
mk symlink-empty symlink.linStat; s=$?
iocsh_test_check "symlink.linStat ends with status 0 on the empty directory" iocsh_test_eq "${s}" 0
iocsh_test_check "it prints the notice with the build target" grep -q 'is empty, as after uninstall.linStat; no link is created. Run make build.linStat' "${D}/make-symlink-empty.out"
iocsh_test_check "it creates no linStat link" bash -c "[[ ! -e '${M}/linStat' && ! -L '${M}/linStat' ]]"
mk symlinks symlinks; s=$?
iocsh_test_check "make symlinks ends with status 0" iocsh_test_eq "${s}" 0
iocsh_test_check "every other module keeps its link" iocsh_test_eq "$(links)" "$((LINKS_BEFORE - 1))"
: > "${M}/linStat-1.2.1/stray"
mk symlink-stray symlink.linStat; s=$?
iocsh_test_check "a directory with a file and no metadata still stops the link" bash -c "[[ '${s}' != 0 ]] && grep -q 'Missing or empty metadata file' '${D}/make-symlink-stray.out'"
rm -f "${M}/linStat-1.2.1/stray"
mk rebuild build.linStat; s=$?
iocsh_test_check "build.linStat installs the module again" iocsh_test_eq "${s}" 0
mk symlink-again symlink.linStat; s=$?
iocsh_test_check "symlink.linStat publishes the link again" bash -c "[[ '${s}' == 0 && \"\$(readlink '${M}/linStat')\" == ./linStat-1.2.1 ]]"
iocsh_test_check "the wrapper selects linStat again" bash -c "iocsh.bash -n '${S}/examples/iocsh/st.cmd' 2>/dev/null | grep -q '^dlload.*linStat-1.2.1'"
iocsh_test_check "the link count is back" iocsh_test_eq "$(links)" "${LINKS_BEFORE}"

iocsh_test_section "metadata generation with a truncated dependency library"
cp -p "${M}/StreamDevice-2.8.26/cfg/iocsh.conf" "${D}/stream.conf.keep"
cp -p "${ASYN_LIB}" "${D}/libasyn.keep"
END=$(readelf -lW "${ASYN_LIB}" | awk '$1=="LOAD"{e=strtonum($2)+strtonum($5)} END{print e}')
truncate -s "$((END - 4096))" "${ASYN_LIB}"
printf 'libasyn size %s cut to %s, last loadable segment ends %s\n' "$(stat -c %s "${D}/libasyn.keep")" "$((END - 4096))" "${END}"
mk install-trunc install.StreamDevice; s=$?
iocsh_test_check "install.StreamDevice fails" bash -c "[[ '${s}' != 0 ]]"
iocsh_test_check "the message counts one truncated file and lists it" bash -c "grep -q 'Truncated library files that StreamDevice loads or takes symbols from: 1, listed above' '${D}/make-install-trunc.out' && grep -q -x '${ASYN_LIB}' '${D}/make-install-trunc.out'"
iocsh_test_check "it names the repair by place and no link-line change" bash -c "grep -q 'remove it and run make build.<module>' '${D}/make-install-trunc.out' && ! grep -q 'LIBS_Linux' '${D}/make-install-trunc.out'"
iocsh_test_check "the refusal states what the link target does" grep -q 'make symlink.StreamDevice creates no unversioned link for it until metadata generation succeeds' "${D}/make-install-trunc.out"
iocsh_test_check "StreamDevice has no loader metadata after the refusal" bash -c "[[ ! -e '${M}/StreamDevice-2.8.26/cfg/iocsh.conf' && ! -e '${M}/StreamDevice-2.8.26/cfg/iocsh.conf.sha256' ]]"
printf 'module StreamDevice\niocInit()\n' > "${D}/s.cmd"
iocsh.bash -n "${D}/s.cmd" > "${D}/wrapper-refused.out" 2>&1; s=$?
iocsh_test_check "the wrapper refuses StreamDevice meanwhile" bash -c "[[ '${s}' == 1 ]] && grep -q 'has no loader metadata' '${D}/wrapper-refused.out'"
cp -p "${D}/libasyn.keep" "${ASYN_LIB}"; rm -f "${D}/libasyn.keep"
mk install-restored install.StreamDevice; s=$?
iocsh_test_check "install.StreamDevice succeeds with the library restored" iocsh_test_eq "${s}" 0
iocsh_test_check "the regenerated metadata equals the earlier file" cmp -s "${D}/stream.conf.keep" "${M}/StreamDevice-2.8.26/cfg/iocsh.conf"
mk symlink-stream symlink.StreamDevice; s=$?
iocsh_test_check "symlink.StreamDevice passes its check" iocsh_test_eq "${s}" 0
iocsh.bash -n "${D}/s.cmd" > "${D}/wrapper-ok.out" 2>&1; s=$?
iocsh_test_check "the wrapper selects StreamDevice again" bash -c "[[ '${s}' == 0 ]] && grep -q '^dlload.*libstream.so' '${D}/wrapper-ok.out'"

iocsh_test_section "patch round trip with the site patches in the carry set"
function snap { local d=""; for d in "${S}"/*-src; do [[ -d "${d}/.git" ]] || continue; printf '%s %s\n' "${d##*/}" "$(git -C "${d}" diff --no-prefix | sha256sum | cut -c1-16)"; done; }
snap > "${D}/snap.before"; printf 'source trees compared: %s\n' "$(wc -l < "${D}/snap.before")"
mk patch-revert patch.revert; s=$?
iocsh_test_check "make patch.revert ends with status 0" iocsh_test_eq "${s}" 0
git -C "${S}/epics-base-src" status --short | tee "${D}/base-status.reverted"
iocsh_test_check "the reverted Base source differs only in the two files of make conf" iocsh_test_eq "$(awk '{print $2}' "${D}/base-status.reverted" | tr '\n' ' ')" "configure/CONFIG_SITE_ENV configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64 "
mk patch patch; s=$?
iocsh_test_check "make patch ends with status 0" iocsh_test_eq "${s}" 0
iocsh_test_check "20 Base patches apply" iocsh_test_eq "$(grep -c 'Patching epics-base-src' "${D}/make-patch.out")" 20
iocsh_test_check "the site patches apply last, in name order" iocsh_test_eq "$(grep 'Patching epics-base-src' "${D}/make-patch.out" | tail -n 2 | grep -o '7.0.10-site0[0-9]-[a-z-]*' | tr '\n' ' ')" "7.0.10-site01-dbyacc-eof 7.0.10-site02-dbstatic-device-menu "
snap > "${D}/snap.after"
iocsh_test_check "every source tree has the same difference as before" cmp -s "${D}/snap.before" "${D}/snap.after"
mk pr-revert patch.base.pr.revert; s=$?
iocsh_test_check "make patch.base.pr.revert ends with status 0 and reverts dbYacc.y and dbLexRoutines.c" bash -c "[[ '${s}' == 0 ]] && ! git -C '${S}/epics-base-src' status --short | grep -q -e dbYacc -e dbLexRoutines"
mk pr-apply patch.base.pr.apply; s=$?
snap > "${D}/snap.after2"
iocsh_test_check "make patch.base.pr.apply restores the same difference" bash -c "[[ '${s}' == 0 ]] && cmp -s '${D}/snap.before' '${D}/snap.after2'"
mk patch-base patch.base; s=$?
iocsh_test_check "make patch.base does nothing and ends with status 0" bash -c "[[ '${s}' == 0 ]] && ! grep -q Patching '${D}/make-patch-base.out'"
for t in patch.base.apply patch.base.revert patch.base.make; do
    make -n "${t}" > "${D}/gone-${t}.out" 2>&1; s=$?
    iocsh_test_check "${t} no longer exists" bash -c "[[ '${s}' != 0 ]] && grep -q 'No rule to make target' '${D}/gone-${t}.out'"
done
iocsh_test_summary
