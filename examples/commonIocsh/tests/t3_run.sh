#!/usr/bin/env bash
# T3 installed-path isolation runner (run on a built target-OS VM).
#
# Assemble a runtime-only bundle from the built example IOC and test IOC, hide
# every EPICS-env and test-IOC source root by renaming it, verify the source roots
# are absent and nothing in the bundle references them, then run the T1/T2
# assertions against the installed commonIocsh with no rebuild (SKIP_REBUILD=1).
# The roots are renamed back when the run ends, so nothing is deleted. This proves
# the installed fragments resolve through IOCSH_TOP with no source tree present.
#
# Prerequisites: the target-OS distribution is installed at DIST_TOP; the example
# IOC (examples/commonIocsh) and the test IOC (tc32sim, all service modules) are
# already built from their source trees. Host tools: socat, ss, iocLogServer.

set -uo pipefail

: "${DIST_TOP:?set DIST_TOP, e.g. /opt/epics/1.4.0/debian-13/7.0.10}"
: "${SRC_EPICS:=/opt/epics-env-src/EPICS-env}"
: "${TC32SIM_SRC:=${HOME}/tc32sim}"
: "${BUNDLE:=${HOME}/t3-bundle}"
: "${ARCH:=linux-x86_64}"

readonly EX_SRC="${SRC_EPICS}/examples/commonIocsh"
readonly EX_DST="${BUNDLE}/examples/commonIocsh"
readonly TC_DST="${BUNDLE}/tc32sim"
readonly MANIFEST="${BUNDLE}/manifest.sha256"
readonly SRCROOTS="${BUNDLE}/source-roots.txt"
readonly BUNDLE_MARKER=".t3-bundle"
readonly HIDDEN_SUFFIX=".t3-hidden"
declare -a HIDDEN_ROOTS=()

function die {
    printf "T3 ERROR: %s\n" "$*" >&2
    exit 1
}

function phase {
    printf "\n=== %s ===\n" "$*"
}

# Refuses an empty value, the filesystem root, and the home directory.
function check_path_safe {
    local label="$1" path="$2"
    if [[ -z "${path}" || "${path}" == "/" || "${path}" == "${HOME}" || "${path}" == "${HOME}/" ]]; then
        die "${label} is unsafe: '${path}'"
    fi
}

function export_bundle {
    local d f
    check_path_safe "BUNDLE" "${BUNDLE}"
    if [[ -e "${BUNDLE}" && ! -e "${BUNDLE}/${BUNDLE_MARKER}" ]]; then
        die "BUNDLE exists and is not a bundle of an earlier run: ${BUNDLE}"
    fi
    rm -rf "${BUNDLE}"
    mkdir -p "${EX_DST}" "${TC_DST}"
    : > "${BUNDLE}/${BUNDLE_MARKER}"
    # Example IOC runtime (env-driven launcher; no envPaths to fix).
    for d in bin db dbd fixtureDb iocBoot lib tests; do
        if [[ -e "${EX_SRC}/${d}" ]]; then
            sudo cp -a "${EX_SRC}/${d}" "${EX_DST}/"
        fi
    done
    # Test IOC runtime (uses envPaths; its TOP is rewritten below).
    for d in bin db dbd iocBoot iocsh lib; do
        if [[ -e "${TC32SIM_SRC}/${d}" ]]; then
            cp -a "${TC32SIM_SRC}/${d}" "${TC_DST}/"
        fi
    done
    sudo chown -R "$(id -u):$(id -g)" "${BUNDLE}"
    # Rewrite the test IOC TOP to the relocated bundle path.
    while IFS= read -r -d '' f; do
        sed -i "s|^epicsEnvSet(\"TOP\",.*|epicsEnvSet(\"TOP\",\"${TC_DST}\")|" "${f}"
    done < <(find "${TC_DST}/iocBoot" -name envPaths -print0)
}

function record_provenance {
    printf "%s\n" "${SRC_EPICS}" "${TC32SIM_SRC}" > "${SRCROOTS}"
    (
        cd "${BUNDLE}" || exit 1
        find . -type f ! -name manifest.sha256 ! -name source-roots.txt ! -name "${BUNDLE_MARKER}" \
            -exec sha256sum {} + | sort
    ) > "${MANIFEST}"
}

# Renames each source root to a hidden name; a root that is missing is skipped.
function hide_source_roots {
    local root
    while IFS= read -r root; do
        check_path_safe "source root" "${root}"
        if [[ -e "${root}${HIDDEN_SUFFIX}" ]]; then
            die "a hidden copy of a source root exists: ${root}${HIDDEN_SUFFIX}"
        fi
        if [[ -e "${root}" ]]; then
            sudo mv -- "${root}" "${root}${HIDDEN_SUFFIX}" || die "cannot hide ${root}"
            HIDDEN_ROOTS+=("${root}")
        fi
    done < "${SRCROOTS}"
}

# Renames every hidden source root back; runs on every exit of the script.
function restore_source_roots {
    local root
    for root in "${HIDDEN_ROOTS[@]}"; do
        if [[ -e "${root}${HIDDEN_SUFFIX}" && ! -e "${root}" ]]; then
            sudo mv -- "${root}${HIDDEN_SUFFIX}" "${root}"
        fi
    done
}

function isolation_preflight {
    local root fail=0 refs
    while IFS= read -r root; do
        if [[ -e "${root}" ]]; then
            printf "  FAIL source root still present: %s\n" "${root}"
            fail=1
        else
            printf "  ok absent: %s\n" "${root}"
        fi
    done < "${SRCROOTS}"
    # Check runtime artifacts only; the T3 tooling and inventory legitimately
    # name the source-root paths (as this runner's defaults and the recorded
    # inventory), so exclude them from the reference scan.
    refs="$(grep -rIl -e "${SRC_EPICS}" -e "${TC32SIM_SRC}" "${BUNDLE}" 2>/dev/null \
        | grep -vE '/(source-roots\.txt|manifest\.sha256|t3_run\.sh)$' || true)"
    if [[ -n "${refs}" ]]; then
        printf "  FAIL bundle runtime references a removed source root:\n"
        printf "%s\n" "${refs}"
        fail=1
    else
        printf "  ok no runtime reference to removed source roots\n"
    fi
    if ( cd "${BUNDLE}" || exit 1; sha256sum --quiet -c "${MANIFEST}" ); then
        printf "  ok manifest hashes verified\n"
    else
        printf "  FAIL manifest hash mismatch\n"
        fail=1
    fi
    [[ "${fail}" -eq 0 ]] || die "isolation preflight failed"
}

function main {
    local rc=0

    phase "export runtime bundle -> ${BUNDLE}"
    export_bundle
    record_provenance

    phase "hide source roots"
    hide_source_roots

    phase "isolation preflight"
    isolation_preflight

    phase "run T1/T2 assertions (SKIP_REBUILD=1, installed IOCSH_TOP)"
    env DIST_TOP="${DIST_TOP}" \
        TC32SIM="${TC_DST}" \
        COMMONIOCSH="${DIST_TOP}/modules/commonIocsh" \
        ARCH="${ARCH}" \
        SKIP_REBUILD=1 \
        bash "${EX_DST}/tests/run_all.sh" || rc=$?

    phase "T3 result"
    if [[ "${rc}" -eq 0 ]]; then
        printf "T3 ISOLATION: PASS (installed fragments verified with no source tree)\n"
    else
        printf "T3 ISOLATION: FAIL (see assertions above)\n"
    fi
    return "${rc}"
}

trap restore_source_roots EXIT
main "$@"
