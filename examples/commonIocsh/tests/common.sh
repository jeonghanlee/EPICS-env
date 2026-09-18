#!/usr/bin/env bash
# shellcheck disable=SC2034  # config vars are consumed by the sourcing verify_*.sh scripts
# Common helpers for commonIocsh fragment verification scripts.
# Sourced by each verify_<service>.sh. Paths are overridable via environment.

set -euo pipefail

: "${DIST_TOP:=/home/jeonglee/gitsrc/EPICS-env-distribution/1.3.0/debian-13/7.0.10}"
: "${TC32SIM:=/home/jeonglee/gitsrc/tc32sim}"
: "${COMMONIOCSH:=/home/jeonglee/gitsrc/EPICS-env/commonIocsh}"
: "${ARCH:=linux-x86_64}"

readonly EPICS_BASE_DIR="${DIST_TOP}/base"
readonly IOC_BIN="${TC32SIM}/bin/${ARCH}/tc32sim"
readonly IOCBOOT="${TC32SIM}/iocBoot/ioctestlab-tc32sim"
readonly IOCSH_TOP_DIR="${COMMONIOCSH}"

pass_count=0
fail_count=0

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

# Write configure/RELEASE.local with EPICS_BASE plus the given module macro lines.
# Module macro values use Make syntax such as $(MODULES); keep them single-quoted
# at the call site so the shell does not expand them.
function write_release_local {
    local line
    {
        printf "EPICS_BASE = %s\n" "${EPICS_BASE_DIR}"
        for line in "$@"; do
            printf "%s\n" "${line}"
        done
    } > "${TC32SIM}/configure/RELEASE.local"
}

function rebuild_ioc {
    make -C "${TC32SIM}" clean >/dev/null 2>&1
    make -C "${TC32SIM}" >/dev/null 2>&1
}

# Run a startup snippet through the built IOC. args: <startup-content> <output-file>
function run_ioc {
    local content="$1"
    local outfile="$2"
    local tmpcmd
    tmpcmd="$(mktemp "${IOCBOOT}/st-verify-XXXXXX.cmd")"
    printf "%s\n" "${content}" > "${tmpcmd}"
    (
        cd "${IOCBOOT}"
        timeout 20 "${IOC_BIN}" "$(basename "${tmpcmd}")" < /dev/null
    ) > "${outfile}" 2>&1 || true
    rm -f "${tmpcmd}"
}

# Block for N seconds without the sleep builtin; tail exits when timeout fires.
function wait_seconds {
    timeout "$1" tail -f /dev/null || true
}

function summary {
    printf "%s\n" "--------------------"
    printf "PASS=%d FAIL=%d\n" "${pass_count}" "${fail_count}"
    [[ "${fail_count}" -eq 0 ]]
}
