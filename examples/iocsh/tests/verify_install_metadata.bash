#!/usr/bin/env bash
# Installation check, part A: read-only Make queries against filesystem inventories, the
# generated metadata of every installed module against the effective
# configuration, and repeated installation through the shipped rules.
# shellcheck source=common.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/common.bash"
iocsh_test_require
D="${IOCSH_TEST_OUT}/install_metadata"; rm -rf "${D}"; mkdir -p "${D}"
S="${IOCSH_TEST_REPO}"; T="${IOCSH_TEST_TREE}"; cd "${S}" || exit 2
iocsh_test_section "context"; date -u +'%Y-%m-%dT%H:%M:%SZ'; printf 'build root %s\n' "${S}"

function inventory { find "$1" -printf '%P\t%y\t%s\t%T@\t%l\n' | LC_ALL=C sort; }
# Digests of the files the loader reads: metadata, shared libraries, DBDs,
# and the Base executable directory. Static archives are listed apart.
function content { ( cd "${T}" && find modules/*-*/cfg base/bin modules/*-*/lib modules/*-*/dbd -type f ! -name '*.a' -print0 2>/dev/null | LC_ALL=C sort -z | xargs -0 sha256sum ); }
function archives { ( cd "${T}" && find modules/*-*/lib base/lib -type f -name '*.a' -print0 2>/dev/null | LC_ALL=C sort -z | xargs -0 sha256sum ); }

iocsh_test_section "read-only queries"
inventory "${S}" > "${D}/src.before"; inventory "${T%/*/*/*}" > "${D}/tree.before"
QUERIES=(vars env exist exist.modules show.genmk print-INSTALL_LOCATION_LINSTAT PRINT.SRC_VER_LINSTAT ls.INSTALL_LOCATION_MODS conf.show conf.base.show conf.modules.show conf.linStat.show conf.StreamDevice.show conf.asyn.show)
for q in "${QUERIES[@]}"; do
    make "${q}" > "${D}/query-${q}.out" 2>&1; printf '%-34s status %s, %s lines\n' "${q}" $? "$(wc -l < "${D}/query-${q}.out")"
done
inventory "${S}" > "${D}/src.after"; inventory "${T%/*/*/*}" > "${D}/tree.after"
iocsh_test_check "queries left the build checkout inventory unchanged" diff -q "${D}/src.before" "${D}/src.after"
iocsh_test_check "queries left the install root inventory unchanged" diff -q "${D}/tree.before" "${D}/tree.after"
diff "${D}/src.before" "${D}/src.after" | head -n 10

iocsh_test_section "metadata of every installed module against the effective configuration"
BASEVER=$(make print-SRC_VER_BASE)
ARCH=$(perl "${T}/base/lib/perl/EpicsHostArch.pl")
printf 'Base %s arch %s\n' "${BASEVER}" "${ARCH}"
declare -A VER=() TAG=() KEYOF=()
# Keys come from the pin file; every value is the effective one that make reports.
mapfile -t keys < <(grep -o '^SRC_NAME_[A-Za-z0-9_]*' configure/RELEASE | sed 's/^SRC_NAME_//' | sort -u)
for key in "${keys[@]}"; do
    mapfile -t triple < <(make "print-SRC_NAME_${key}" "print-SRC_VER_${key}" "print-SRC_TAG_${key}" 2>/dev/null)
    name="${triple[0]:-}"; [[ -n "${name}" ]] || continue
    VER["${name}"]="${triple[1]:-}"; TAG["${name}"]="${triple[2]:-}"; KEYOF["${name}"]="${key}"
done
printf 'pins read: %s\n' "${#VER[@]}"
count=0
for link in "${T}"/modules/*; do
    [[ -L "${link}" ]] || continue
    inst="${link##*/}"; src="${inst}"; [[ "${inst}" != "seq" ]] || src="sequencer"
    ver="${VER[${src}]:-}"; dir="${T}/modules/${inst}-${ver}"; rec="${dir}/cfg/build-record"; conf="${dir}/cfg/iocsh.conf"
    problems=""
    [[ "$(readlink "${link}")" == "./${inst}-${ver}" ]] || problems+=" alias=$(readlink "${link}")"
    [[ -s "${rec}" && -s "${conf}" ]] || problems+=" missing-files"
    for pair in "name=${inst}" "version=${ver}" "tag=${TAG[${src}]:-}" "base=${BASEVER}" "arch=${ARCH}"; do
        grep -q -x -- "${pair}" "${rec}" || problems+=" record:${pair}"
    done
    for pair in "format=1" "name=${inst}" "version=${ver}" "base=${BASEVER}" "arch=${ARCH}" "macro=${KEYOF[${src}]:-}"; do
        grep -q -x -- "${pair}" "${conf}" || problems+=" conf:${pair}"
    done
    # Source revision recorded against the checkout and the pinned tag.
    srcdir="${S}/${src}-src"; [[ -d "${srcdir}" ]] || srcdir=$(find "${S}" -maxdepth 1 -name "${src}-src*" 2>/dev/null | sort | head -n1)
    head=$(git -C "${srcdir}" rev-parse HEAD 2>/dev/null)
    grep -q -x "source=${head}" "${rec}" || problems+=" source!=${head:0:8}"
    # Declared dependencies with their effective versions.
    exp=$(make "print-${src}_DEPS" 2>/dev/null | tr ' ' '\n' | sed -n 's/^build\.//p' | while read -r d; do i="${d}"; [[ "${d}" != "sequencer" ]] || i=seq; printf 'dep=%s %s\n' "${i}" "${VER[${d}]}"; done | LC_ALL=C sort)
    [[ "$(grep '^dep=' "${rec}" | LC_ALL=C sort)" == "${exp}" ]] || problems+=" record-deps"
    [[ "$(grep '^dep=' "${conf}" | LC_ALL=C sort)" == "${exp}" ]] || problems+=" conf-deps"
    while IFS= read -r entry; do
        path="${entry#*=}"
        [[ "${path}" != /* && "${path}" != *..* && -s "${dir}/${path}" ]] || problems+=" entry:${path}"
    done < <(grep -E '^(lib|dbd)=' "${conf}")
    [[ "$(cat "${conf}.sha256" 2>/dev/null)" == "$(sha256sum < "${conf}" | cut -d' ' -f1)" ]] || problems+=" digest"
    bash "${S}/tools/iocsh_metadata.bash" check --module "${inst}" --install "${dir}" --version "${ver}" --base-version "${BASEVER}" --base "${T}/base" > "${D}/check-${inst}.out" 2>&1 || problems+=" check-tool"
    count=$((count + 1))
    printf '%-14s %-10s deps=%s libs=%s dbds=%s artifacts=%s %s\n' "${inst}" "${ver}" "$(grep -c '^dep=' "${conf}")" "$(grep -c '^lib=' "${conf}")" "$(grep -c '^dbd=' "${conf}")" "$(grep -c '^artifact=' "${rec}")" "${problems:-ok}"
done | tee "${D}/modules.txt"
iocsh_test_check "32 modules inspected" iocsh_test_eq "$(wc -l < "${D}/modules.txt")" 32
iocsh_test_check "every module agrees with the effective configuration" iocsh_test_eq "$(grep -c ' ok$' "${D}/modules.txt")" 32
grep -l 'include.*"menu' "${T}"/modules/*-*/dbd/*.dbd 2>/dev/null | head -n 3 > "${D}/menu-includes"
printf 'selected DBD files that include a Base menu file:\n'
for conf in "${T}"/modules/*-*/cfg/iocsh.conf; do d="${conf%/cfg/iocsh.conf}"; while IFS= read -r e; do grep -l -E '^[[:space:]]*include[[:space:]]+"?menu' "${d}/${e}" 2>/dev/null; done < <(sed -n 's/^dbd=//p' "${conf}"); done | sed "s|${T}/modules/||" | head -n 6

iocsh_test_section "individual module installation"
content > "${D}/content.before"; archives > "${D}/archives.before"
make install.linStat > "${D}/install-linStat.out" 2>&1; s=$?; printf 'make install.linStat status %s\n' "${s}"; tail -n 3 "${D}/install-linStat.out"
iocsh_test_check "make install.linStat succeeded" iocsh_test_eq "${s}" 0
content > "${D}/content.after1"
iocsh_test_check "shared libraries, DBDs, metadata, and Base executables are unchanged" diff -q "${D}/content.before" "${D}/content.after1"

iocsh_test_section "repeated full installation"
make install > "${D}/install.out" 2>&1; s=$?; printf 'make install status %s\n' "${s}"; tail -n 4 "${D}/install.out" | cut -c1-200
iocsh_test_check "repeated make install succeeded" iocsh_test_eq "${s}" 0
content > "${D}/content.after2"
iocsh_test_check "content is unchanged after the repeated installation" diff -q "${D}/content.before" "${D}/content.after2"
diff "${D}/content.before" "${D}/content.after2" | head -n 10

iocsh_test_section "repeated base installation"
make install.base > "${D}/install-base.out" 2>&1; s=$?; printf 'make install.base status %s\n' "${s}"; tail -n 3 "${D}/install-base.out" | cut -c1-200
iocsh_test_check "repeated make install.base succeeded" iocsh_test_eq "${s}" 0
iocsh_test_check "wrapper is present and equals the source after base installation" cmp "${S}/tools/iocsh.bash" "${T}/base/bin/${ARCH}/iocsh.bash"
iocsh_test_check "ELF tool is present and equals the source after base installation" cmp "${S}/tools/iocsh_elf.bash" "${T}/base/bin/${ARCH}/iocsh_elf.bash"
content > "${D}/content.after3"
diff "${D}/content.before" "${D}/content.after3" | head -n 10
iocsh_test_check "content is unchanged after the repeated base installation" diff -q "${D}/content.before" "${D}/content.after3"
archives > "${D}/archives.after"
printf 'static archives changed by the repeated installations: %s\n' "$(diff "${D}/archives.before" "${D}/archives.after" | grep -c '^>')"
diff "${D}/archives.before" "${D}/archives.after" | grep '^>' | cut -c69- | head -n 5
iocsh_test_summary
