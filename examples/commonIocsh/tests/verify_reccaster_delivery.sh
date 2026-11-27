#!/usr/bin/env bash
# Verify the delivery of the reccaster fragment to a recceiver: a published container image
# holds the recceiver and an EPICS runner; an IOC that loads the reccaster.iocsh of this
# repository starts under ioc-runner inside it, and the recceiver log must show that the IOC
# connected after the announce and that the recceiver received the record list of the IOC.
#
# Environment (all optional):
#   CONTAINER_TOOL  container command, default podman; only podman is tested, and docker is not
#                   supported because the digest is read with a field of image inspect that docker lacks
#   RECC_ADDRLIST   announce address list of the recceiver, default 127.0.0.1:5049
#   RECC_WAIT       seconds to wait for the delivery, default 40 (the announce interval is 15)
#   COMMONIOCSH     commonIocsh directory to check, default the one of this repository
#   KEEP_WORKSPACE  1 keeps the workspace with the logs of the run
#   COMMONIOCSH_TEST_TRASH  directory that receives the moved workspace, default <repo>/work/trash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
# shellcheck source=../../../tools/test-trash.bash disable=SC1091
source "${REPO_ROOT}/tools/test-trash.bash"

readonly IMAGE_NAME="docker.io/jeonghanlee/debian13-epics-recceiver-test"
readonly IMAGE_TAG="1.5.0.1"
readonly IMAGE_DIGEST="sha256:f5092f132f1074d8909f9ca22853151ae7002c2c374752e8aa30322ef2932a97"
readonly IMAGE_REF="${IMAGE_NAME}@${IMAGE_DIGEST}"
readonly RECSYNC_REF="9834b94"
readonly RECSYNC_COMMIT="9834b94edc63eece42712b8355a4703d4286dd8f"
readonly RECCEIVER_VERSION="1.5"
readonly IOC_NAME="recchk"
readonly PREFIX="RECCHK"
readonly MOUNT_POINT="/opt/commonIocsh-checked"
readonly TRASH="${COMMONIOCSH_TEST_TRASH:-${REPO_ROOT}/work/trash}"
: "${CONTAINER_TOOL:=podman}"
: "${RECC_ADDRLIST:=127.0.0.1:5049}"
: "${RECC_WAIT:=40}"
: "${COMMONIOCSH:=${REPO_ROOT}/commonIocsh}"

pass_count=0
fail_count=0
container=""
workspace=""

function log_info {
    printf "%s\n" "$*"
}

function log_pass {
    printf "PASS: %s\n" "$*"
    pass_count=$((pass_count + 1))
}

function log_fail {
    printf "FAIL: %s\n" "$*"
    fail_count=$((fail_count + 1))
}

function summary {
    printf "%s\n" "--------------------"
    printf "PASS=%d FAIL=%d\n" "${pass_count}" "${fail_count}"
    [[ "${fail_count}" -eq 0 ]]
}

# Block for N seconds without the sleep builtin; tail exits when timeout fires.
function wait_seconds {
    timeout "$1" tail -f /dev/null || true
}

# Stop and remove the container, then move the workspace into the trash unless KEEP_WORKSPACE=1.
function cleanup {
    if [[ -n "${container}" ]]; then
        "${CONTAINER_TOOL}" rm -f "${container}" > /dev/null 2>&1 || true
    fi
    if [[ -n "${workspace}" && "${KEEP_WORKSPACE:-0}" != "1" ]]; then
        test_move_to_trash "${TRASH}" "${workspace}" || true
    fi
}

# Run a command inside the container; the script text arrives on standard input.
function in_container {
    "${CONTAINER_TOOL}" exec -i "${container}" bash -s -- "$@"
}

# Print the recceiver and IOC output of the container from its standard output.
function container_log {
    "${CONTAINER_TOOL}" logs "${container}" 2>&1
}

# Image checks: the pulled digest, the source commit in the label and the manifest, and the
# recceiver version of the venv.
function check_image {
    local digest label manifest version
    digest="$("${CONTAINER_TOOL}" image inspect "${IMAGE_REF}" --format '{{.Digest}}' 2>&1)" || digest="unreadable"
    if [[ "${digest}" == "${IMAGE_DIGEST}" ]]; then
        log_pass "image digest is ${IMAGE_DIGEST} (tag ${IMAGE_TAG})"
    else
        log_fail "image digest is ${digest}, expected ${IMAGE_DIGEST}"
    fi
    label="$("${CONTAINER_TOOL}" image inspect "${IMAGE_REF}" --format '{{index .Labels "epics.recsync-ref"}}' 2>&1)" || label="unreadable"
    if [[ "${label}" == "${RECSYNC_REF}" ]]; then
        log_pass "label epics.recsync-ref is ${RECSYNC_REF}"
    else
        log_fail "label epics.recsync-ref is ${label}, expected ${RECSYNC_REF}"
    fi
    manifest="$("${CONTAINER_TOOL}" run --rm "${IMAGE_REF}" cat /etc/epics-bake.manifest 2>&1)" || manifest=""
    if grep -q -F "${RECSYNC_COMMIT}" <<< "${manifest}"; then
        log_pass "manifest holds the recsync commit ${RECSYNC_COMMIT}"
    else
        log_fail "manifest does not hold the recsync commit ${RECSYNC_COMMIT}"
    fi
    version="$("${CONTAINER_TOOL}" run --rm "${IMAGE_REF}" /opt/recceiver-venv/bin/pip show recceiver 2>&1 | sed -n 's/^Version: //p')" || version=""
    if [[ "${version}" == "${RECCEIVER_VERSION}" ]]; then
        log_pass "the venv reports recceiver ${RECCEIVER_VERSION}"
    else
        log_fail "the venv reports recceiver '${version}', expected ${RECCEIVER_VERSION}"
    fi
    check_build_record "${manifest}"
}

# Build record checks: the manifest names the inputs that the image build does not pin, namely
# the base image digest (equal to its label), the venv packages of the Debian archive and the
# Python version of the venv, and the hash of the pip freeze file equals the file in the image.
function check_build_record {
    local manifest="$1" base_digest label_base key key_version freeze_hash actual_hash
    base_digest="$(awk '$1 == "base-image" {print $3}' <<< "${manifest}")"
    label_base="$("${CONTAINER_TOOL}" image inspect "${IMAGE_REF}" --format '{{index .Labels "epics.base-image-digest"}}' 2>&1)" || label_base="unreadable"
    if [[ "${base_digest}" =~ ^sha256:[0-9a-f]{64}$ && "${base_digest}" == "${label_base}" ]]; then
        log_pass "manifest base-image digest ${base_digest} equals the label epics.base-image-digest"
    else
        log_fail "manifest base-image digest '${base_digest}' differs from the label epics.base-image-digest '${label_base}'"
    fi
    for key in python3-venv python3.13-venv recceiver-venv-python; do
        key_version="$(awk -v k="${key}" '$1 == k {print $3}' <<< "${manifest}")"
        if [[ -n "${key_version}" ]]; then
            log_pass "manifest records ${key} ${key_version}"
        else
            log_fail "manifest does not record ${key}"
        fi
    done
    freeze_hash="$(awk '$1 == "recceiver-venv-freeze" {print $3}' <<< "${manifest}")"
    actual_hash="sha256:$("${CONTAINER_TOOL}" run --rm "${IMAGE_REF}" sha256sum /etc/recceiver/pip-freeze.txt 2>&1 | cut -d ' ' -f 1)"
    if [[ "${freeze_hash}" =~ ^sha256:[0-9a-f]{64}$ && "${freeze_hash}" == "${actual_hash}" ]]; then
        log_pass "manifest hash of pip-freeze.txt equals the file in the image"
    else
        log_fail "manifest hash of pip-freeze.txt '${freeze_hash}' differs from the file '${actual_hash}'"
    fi
}

# Create the IOC directory inside the container, the startup file that loads the reccaster
# fragment of the checked repository, and start the IOC under ioc-runner.
function start_ioc {
    local out
    out="$(in_container "${IOC_NAME}" "${PREFIX}" "${MOUNT_POINT}" 2>&1 <<'REMOTE'
set -eu
ioc="$1"; prefix="$2"; mount="$3"
m="${EPICS_MODULES}"; r="${m}/recsync-9834b94"; d="/opt/${ioc}"
mkdir -p "${d}"
cat > "${d}/st.cmd" <<CMD
#!${r}/bin/linux-x86_64/demo
dbLoadDatabase("${r}/dbd/demo.dbd")
demo_registerRecordDeviceDriver(pdbbase)
epicsEnvSet("RECCASTER","${r}")
dbLoadRecords("${r}/db/somerecords.db","P=${prefix}:")
iocshLoad("${mount}/iocsh/reccaster.iocsh","IOC=${prefix}")
iocInit
CMD
chmod +x "${d}/st.cmd"
ioc-runner --container generate "${d}" > /dev/null
ioc-runner --container -f install "${d}/${ioc}.conf" > /dev/null
ioc-runner --container start "${ioc}"
REMOTE
    )" || out="${out:-ioc-runner failed}"
    if grep -q "successfully started" <<< "${out}"; then
        log_pass "IOC ${IOC_NAME} started under ioc-runner --container"
        return 0
    fi
    log_fail "IOC ${IOC_NAME} did not start under ioc-runner: ${out}"
    return 1
}

# Read one PV of the IOC through Channel Access on the loopback of the container.
function read_pv {
    in_container "$1" <<'REMOTE' 2>/dev/null || true
EPICS_CA_ADDR_LIST=127.0.0.1 EPICS_CA_AUTO_ADDR_LIST=NO caget -t "$1"
REMOTE
}

# Wait until the IOC status records report the synchronized state or RECC_WAIT seconds pass.
function check_delivery_state {
    local waited=0 state="" msg=""
    while (( waited < RECC_WAIT )); do
        state="$(read_pv "${PREFIX}:State-Sts")"
        msg="$(read_pv "${PREFIX}:Msg-I")"
        if [[ "${state}" == "Done" && "${msg}" == "Synchronized" ]]; then
            log_pass "IOC reads State-Sts=Done and Msg-I=Synchronized after ${waited} s"
            return 0
        fi
        wait_seconds 2
        waited=$((waited + 2))
    done
    log_fail "IOC reads State-Sts='${state}' Msg-I='${msg}' after ${RECC_WAIT} s; the recceiver did not complete the delivery"
    return 1
}

# Recceiver log checks: the announcer started and one transaction from the IOC arrived.
function check_recceiver_log {
    local log_text="$1" count
    if grep -q "Announcer starting" <<< "${log_text}"; then
        log_pass "recceiver log shows the announcer started"
    else
        log_fail "recceiver log does not show the announcer started"
    fi
    count="$(grep -c -E "Commit: Transaction\(Src:127\.0\.0\.1:[0-9]+, Init:True" <<< "${log_text}" || true)"
    if [[ "${count}" == "1" ]]; then
        log_pass "recceiver log shows one transaction from the IOC"
    else
        log_fail "recceiver log shows ${count} transactions from the IOC, expected 1"
    fi
}

# Channel list check: the show log of the recceiver names the records of the IOC, and the
# names of dbl on the IOC console equal the record names plus the alias names of that log.
function check_channel_list {
    local log_text="$1" name dbl_names shown_names alias_names
    local -a required=("${PREFIX}:State-Sts" "${PREFIX}:Msg-I" "${PREFIX}:li" "${PREFIX}:lo")
    shown_names="$(sed -n 's/.*processors.*record([a-z]*, "\([^"]*\)").*/\1/p' <<< "${log_text}" | sort -u)"
    for name in "${required[@]}"; do
        if grep -q -x -F "${name}" <<< "${shown_names}"; then
            log_pass "recceiver log lists the record ${name}"
        else
            log_fail "recceiver log does not list the record ${name}"
        fi
    done
    alias_names="$(sed -n 's/.*processors.*alias("\([^"]*\)").*/\1/p' <<< "${log_text}" | sort -u)"
    dbl_names="$(in_container "${IOC_NAME}" <<'REMOTE' 2>/dev/null | sed -n "s/^\\(${PREFIX}:[^ ]*\\).*/\\1/p" | sort -u
ioc="$1"
{ timeout 2 tail -f /dev/null; printf 'dbl\r\n'; timeout 3 tail -f /dev/null; } \
    | socat -t 2 - "UNIX-CONNECT:/run/procserv/${ioc}/control" | tr -d '\r' | strings
REMOTE
    )" || dbl_names=""
    if [[ -n "${dbl_names}" && "${dbl_names}" == "$(printf "%s\n%s\n" "${shown_names}" "${alias_names}" | sed '/^$/d' | sort -u)" ]]; then
        log_pass "the names of dbl equal the records and aliases in the recceiver log"
    else
        log_fail "the names of dbl differ from the records and aliases in the recceiver log"
        log_info "dbl names: $(tr '\n' ' ' <<< "${dbl_names}")"
        log_info "log names: $(printf "%s\n%s\n" "${shown_names}" "${alias_names}" | sed '/^$/d' | sort -u | tr '\n' ' ')"
    fi
}

function main {
    local pid1 log_text

    if ! command -v "${CONTAINER_TOOL}" > /dev/null 2>&1; then
        log_fail "container tool ${CONTAINER_TOOL} is not installed"
        summary
        return
    fi
    if [[ ! -f "${COMMONIOCSH}/iocsh/reccaster.iocsh" ]]; then
        log_fail "reccaster.iocsh is missing in ${COMMONIOCSH}"
        summary
        return
    fi
    mkdir -p "${REPO_ROOT}/work/tmp"
    workspace="$(mktemp -d "${REPO_ROOT}/work/tmp/reccaster-delivery.XXXXXX")"
    trap cleanup EXIT

    # An image that is pinned by digest cannot change, so a stored copy is used without contacting
    # the registry; only an absent image is pulled.
    if "${CONTAINER_TOOL}" image exists "${IMAGE_REF}" > /dev/null 2>&1; then
        log_info "reccaster delivery: using the stored image ${IMAGE_REF}"
    else
        log_info "reccaster delivery: pulling ${IMAGE_REF}"
        if ! "${CONTAINER_TOOL}" pull --quiet "${IMAGE_REF}" > "${workspace}/pull.out" 2>&1; then
            log_fail "pull of ${IMAGE_REF} failed: $(tail -n 1 "${workspace}/pull.out")"
            summary
            return
        fi
    fi
    check_image

    container="${IOC_NAME}-$$"
    log_info "reccaster delivery: starting the image with the announce list ${RECC_ADDRLIST}"
    if ! "${CONTAINER_TOOL}" run -d --rm --name "${container}" --network none --security-opt label=disable \
        -e "RECC_ADDRLIST=${RECC_ADDRLIST}" -v "${COMMONIOCSH}:${MOUNT_POINT}:ro" "${IMAGE_REF}" > "${workspace}/run.out" 2>&1; then
        log_fail "the container did not start: $(tail -n 1 "${workspace}/run.out")"
        container=""
        summary
        return
    fi
    wait_seconds 6
    pid1="$("${CONTAINER_TOOL}" exec "${container}" ps -o args= -p 1 2>&1 || true)"
    if [[ "${pid1}" == s6-svscan* ]]; then
        log_pass "process 1 of the container is ${pid1}"
    else
        log_fail "process 1 of the container is '${pid1}', expected s6-svscan"
    fi

    if start_ioc; then
        check_delivery_state || true
    fi
    log_text="$(container_log)"
    printf "%s\n" "${log_text}" > "${workspace}/container.log"
    check_recceiver_log "${log_text}"
    check_channel_list "${log_text}"
    summary
}

main "$@"
