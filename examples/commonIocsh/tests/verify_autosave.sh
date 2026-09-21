#!/usr/bin/env bash
# Verify autosave restart retention: change values and settings fields, save,
# restart a fresh IOC that restores them, re-save, and compare value lines for
# both the pass1 (VAL) and settings (PREC/SCAN/...) groups.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh disable=SC1091
source "${SCRIPT_DIR}/common.sh"

AS1="$(mktemp -d)"
AS2="$(mktemp -d)"
WORK="$(mktemp -d)"
readonly AS1 AS2 WORK
trap 'rm -rf "${AS1}" "${AS2}" "${WORK}"' EXIT

readonly REL_PASS1="ioctestlab-tc32sim/save/values_pass1.sav"
readonly REL_SETTINGS="ioctestlab-tc32sim/save/settings.sav"

function device_and_autosave {
    # args: <as_top> <tail-commands>
    local as_top="$1"
    local tail="$2"
    cat <<CMD
#!../../bin/${ARCH}/tc32sim
< envPaths
epicsEnvSet("IOCSH_TOP","${IOCSH_TOP_DIR}")
epicsEnvSet("IOC","ioctestlab-tc32sim")
epicsEnvSet("AS_TOP","${as_top}")
epicsEnvSet("DB_TOP","\$(TOP)/db")
dbLoadDatabase "\$(TOP)/dbd/tc32sim.dbd"
tc32sim_registerRecordDeviceDriver pdbbase
cd "\${TOP}/iocBoot/ioctestlab-tc32sim"
epicsEnvSet("PORT1","TCP001")
epicsEnvSet("P1","TC32:001:")
epicsEnvSet("TCPPORT1","9400")
iocshLoad("\$(IOCSH_LOCAL_TOP=\$(TOP)/iocsh)/tc32sim.iocsh","PORT=\$(PORT1),P=\$(P1),TCP_PORT=\$(TCPPORT1),DATABASE_TOP=\$(DB_TOP),PVX=")
iocshLoad("\$(IOCSH_TOP)/iocsh/autosave.iocsh","IOC=\$(IOC),AS_TOP=\$(AS_TOP)")
iocInit
${tail}
CMD
}

# Compare the value lines of a saved group between AS1 (baseline) and AS2 (restored).
function compare_group {
    local rel="$1" label="$2"
    if [[ ! -s "${AS1}/${rel}" ]]; then
        log_fail "autosave ${label} baseline save file not written"
        return
    fi
    grep -vE '^#|^!|^<' "${AS1}/${rel}" | sort > "${WORK}/${label}-b.txt"
    grep -vE '^#|^!|^<' "${AS2}/${rel}" | sort > "${WORK}/${label}-r.txt"
    if diff -q "${WORK}/${label}-b.txt" "${WORK}/${label}-r.txt" >/dev/null 2>&1; then
        log_pass "autosave ${label} retained across restart (all lines identical)"
    else
        log_fail "autosave ${label} differs after restart"
    fi
}

function main {
    local save_tail restore_tail

    log_info "autosave: enabling module and rebuilding"
    # shellcheck disable=SC2016
    write_release_local 'AUTOSAVE = $(MODULES)/autosave'
    rebuild_ioc

    save_tail='epicsThreadSleep 2
dbpf("TC32:001:Ti0Scale","3")
dbpf("TC32:001:Ti1Scale","2")
dbpf("TC32:001:Ti0.PREC","4")
dbpf("TC32:001:Ti0.HIGH","95")
dbpf("TC32:001:Ti0.SCAN","6")
dbpf("TC32:001:Ti5.PREC","5")
dbpf("TC32:001:Ti31.PREC","2")
manual_save("values_pass1.req")
manual_save("settings.req")
epicsThreadSleep 1'
    run_ioc "$(device_and_autosave "${AS1}" "${save_tail}")" "${WORK}/save.log"

    mkdir -p "${AS2}/ioctestlab-tc32sim/save" "${AS2}/ioctestlab-tc32sim/req"
    [[ -s "${AS1}/${REL_PASS1}" ]]    && cp "${AS1}/${REL_PASS1}"    "${AS2}/${REL_PASS1}"
    [[ -s "${AS1}/${REL_SETTINGS}" ]] && cp "${AS1}/${REL_SETTINGS}" "${AS2}/${REL_SETTINGS}"

    restore_tail='epicsThreadSleep 2
manual_save("values_pass1.req")
manual_save("settings.req")
epicsThreadSleep 1'
    run_ioc "$(device_and_autosave "${AS2}" "${restore_tail}")" "${WORK}/restore.log"

    compare_group "${REL_PASS1}"    "pass1"
    compare_group "${REL_SETTINGS}" "settings"

    summary
}

main "$@"
