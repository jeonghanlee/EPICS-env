#!/usr/bin/env bash
# Shared helpers for the loader verification runs. The caller sets
#   IOCSH_TEST_TREE  installed distribution directory holding setEpicsEnv.bash
#   IOCSH_TEST_REPO  EPICS-env checkout that holds examples/iocsh
#   IOCSH_TEST_OUT   directory for the logs of this host
set -uo pipefail
# A write to the FIFO of an IOC that already ended must not end the test.
trap '' PIPE

readonly IOCSH_TEST_READY_TEXT='iocRun: All initialization complete'
declare -gA IOCSH_TEST_IOC_PID=()
declare -gA IOCSH_TEST_IOC_FD=()

function iocsh_test_require {
    local name=""
    for name in IOCSH_TEST_TREE IOCSH_TEST_REPO IOCSH_TEST_OUT; do
        [[ -n "${!name:-}" ]] || { printf 'missing %s\n' "${name}" >&2; exit 2; }
    done
    # The caller sets the three variables, which the loop above checks by name.
    # shellcheck disable=SC2153
    mkdir -p "${IOCSH_TEST_OUT}"
}

# Sources the selected tree and gives the run dedicated loopback ports.
function iocsh_test_env {
    local tree="${1:-${IOCSH_TEST_TREE}}"
    set +u
    # shellcheck source=/dev/null
    source "${tree}/setEpicsEnv.bash" > /dev/null 2>&1
    set -u
    export EPICS_CA_SERVER_PORT=55064 EPICS_CA_REPEATER_PORT=55065
    export EPICS_PVA_SERVER_PORT=55075 EPICS_PVA_BROADCAST_PORT=55076
    export EPICS_CA_AUTO_ADDR_LIST=NO EPICS_CA_ADDR_LIST=127.0.0.1 EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
    export EPICS_PVA_AUTO_ADDR_LIST=NO EPICS_PVA_ADDR_LIST=127.0.0.1 EPICS_PVAS_INTF_ADDR_LIST=127.0.0.1
}

function iocsh_test_sleep {
    perl -e 'select(undef,undef,undef,$ARGV[0])' "$1"
}

# iocsh_test_ioc_start NAME LOG WRAPPER_ARGS...
# Starts the wrapper with a FIFO as standard input so the IOC shell stays
# open and ends through its own exit command. Returns 0 once iocInit is
# reported, 1 when the process ends first or the wait times out.
function iocsh_test_ioc_start {
    local name="$1"
    local log="$2"
    shift 2
    local fifo="${IOCSH_TEST_OUT}/.${name}.in"
    local fd=""
    local i=0

    rm -f -- "${fifo}"
    mkfifo -- "${fifo}"
    iocsh.bash "$@" < "${fifo}" > "${log}" 2>&1 &
    IOCSH_TEST_IOC_PID["${name}"]=$!
    exec {fd}> "${fifo}"
    IOCSH_TEST_IOC_FD["${name}"]="${fd}"
    for ((i = 0; i < 160; i++)); do
        grep -q -- "${IOCSH_TEST_READY_TEXT}" "${log}" 2>/dev/null && return 0
        kill -0 "${IOCSH_TEST_IOC_PID[${name}]}" 2>/dev/null || return 1
        iocsh_test_sleep 0.25
    done
    return 1
}

function iocsh_test_ioc_cmd {
    local name="$1"
    shift
    printf '%s\n' "$@" >&"${IOCSH_TEST_IOC_FD[${name}]}"
}

# Ends the IOC through its exit command and prints its exit status.
function iocsh_test_ioc_stop {
    local name="$1"
    local pid="${IOCSH_TEST_IOC_PID[${name}]}"
    local fd="${IOCSH_TEST_IOC_FD[${name}]}"
    local status=0
    local i=0

    { printf 'exit\n' >&"${fd}"; } 2>/dev/null || true
    exec {fd}>&-
    for ((i = 0; i < 60; i++)); do
        kill -0 "${pid}" 2>/dev/null || break
        iocsh_test_sleep 0.25
    done
    if kill -0 "${pid}" 2>/dev/null; then
        kill -TERM "${pid}" 2>/dev/null
        printf 'ioc %s needed SIGTERM\n' "${name}"
    fi
    wait "${pid}" || status=$?
    rm -f -- "${IOCSH_TEST_OUT}/.${name}.in"
    printf 'ioc %s exit status %s\n' "${name}" "${status}"
}

# Prints the installed-tree libraries mapped into a process, one per line.
function iocsh_test_maps {
    local pid="$1"
    sed -n 's/^[^ ]* [^ ]* [^ ]* [^ ]* [^ ]* *//p' "/proc/${pid}/maps" | grep -E '\.so' | LC_ALL=C sort -u
}

# Prints a log without terminal color sequences.
function iocsh_test_plain {
    sed 's/\x1b\[[0-9;]*m//g' "$1"
}

# Lists log lines that suggest a failed load or an unknown command.
function iocsh_test_suspicious {
    iocsh_test_plain "$1" | grep -n -i -E '\berror\b|not found|cannot|can.t |undefined|unknown|no dset|\bfail|illegal|not registered|No such' | grep -v 'on error break' || printf 'none\n'
}

function iocsh_test_section {
    printf '\n===== %s =====\n' "$1"
}

declare -g IOCSH_TEST_OK=0
declare -g IOCSH_TEST_FAIL=0

# iocsh_test_check DESCRIPTION COMMAND...  records OK when the command succeeds.
function iocsh_test_check {
    local description="$1"
    shift
    if "$@"; then
        IOCSH_TEST_OK=$((IOCSH_TEST_OK + 1))
        printf 'OK    %s\n' "${description}"
    else
        IOCSH_TEST_FAIL=$((IOCSH_TEST_FAIL + 1))
        printf 'FAIL  %s\n' "${description}"
    fi
}

function iocsh_test_eq {
    [[ "$1" == "$2" ]] || { printf '      got [%s] expected [%s]\n' "$1" "$2"; return 1; }
}

function iocsh_test_summary {
    printf '\nSUMMARY ok=%s fail=%s\n' "${IOCSH_TEST_OK}" "${IOCSH_TEST_FAIL}"
}

# iocsh_test_copy_tree DEST  copies the candidate tree to DEST/<base version dir>
# and prints the copied tree path. An existing copy is replaced.
function iocsh_test_copy_tree {
    local dest="$1"
    rm -rf -- "${dest}"
    mkdir -p -- "${dest}"
    cp -a -- "${IOCSH_TEST_TREE}" "${dest}/"
    printf '%s' "${dest}/${IOCSH_TEST_TREE##*/}"
}

# Runs a command in a fresh shell without any EPICS selection.
function iocsh_test_clean_shell {
    env -i HOME="${HOME}" PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin TERM="${TERM:-dumb}" \
        TREE1="${TREE1:-}" TREE2="${TREE2:-}" ARCH="${ARCH:-}" ST="${ST:-}" bash --noprofile --norc "$@"
}
