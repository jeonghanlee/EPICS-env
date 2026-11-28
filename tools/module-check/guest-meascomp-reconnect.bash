#!/usr/bin/env bash
#
#  Copyright (c) 2026 -         Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Run the reconnection test of the measComp fork on a test machine, at the
# commit that configure/RELEASE pins.
#
# Runs as the user that owns the checkout and the installed tree; the checkout
# path is resolved with readlink -f. Reads the pin (SRC_TAG_MEASCOMP), the
# clone URL (SRC_BASE_MEASCOMP and SRC_NAME_MEASCOMP) and the installed tree
# (make print-INSTALL_LOCATION_EPICS) from the checkout, clones the fork into
# <root>/<SRC_NAME_MEASCOMP> when it is absent, checks out the pin, and builds
# the reconnect IOC of the fork against the Base, asyn and ULDAQ of the tree.
# Then it runs every case of the table below in a user and network namespace,
# up to three attempts each, and the exit loop of the fork. The pin is an
# abbreviated commit; the script prints the full commit it resolves to and
# refuses a commit that does not begin with the pin.
#
# The table names the cases of the README of the fork at the pin; a case that
# test_reconnect.pl does not know fails, so a pin that adds a case fails here
# until the table names it. The run directory <root>/run holds summary.txt,
# build.out, and, for each attempt of each case, <case>.attempt<n>.out (the
# JSON result lines of test_reconnect.pl) and <case>.attempt<n>.log; the exit
# loop writes exit-loop.out and the files of its runs under exit-loop. An
# earlier run directory moves into <root>/trash.
#
# Usage: guest-meascomp-reconnect.bash [checkout] [root]
#   [checkout] EPICS-env checkout; default ${HOME}/sandbox/EPICS-env
#   [root]     directory of the fork clone, the run directory and the trash;
#              default ${HOME}/sandbox/reconnect
# Exit status: 0 every case passed within three attempts and the exit loop
#   reported every run passed; 1 a case or the exit loop failed, or the clone,
#   the checkout or the build of the fork failed; 2 a usage error, a checkout
#   without configure/RELEASE, a missing tool, or no value for SRC_TAG_MEASCOMP,
#   SRC_BASE_MEASCOMP, SRC_NAME_MEASCOMP, or INSTALL_LOCATION_EPICS. The last
#   line of the output is RECONNECT-END rc=<n>.

set -uo pipefail
# shellcheck source=../test-trash.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../test-trash.bash" || exit 1

# One line per case: name, time limit of one attempt, template (temperature or
# analog), and hosts when the case binds the file endpoint-hosts over
# /etc/hosts. The case named default runs test_reconnect.pl without --case.
readonly -a cases=(
    "default|100s|temperature|"
    "digital-word|90s|temperature|"
    "digital-control|90s|temperature|"
    "digital-policy|90s|temperature|"
    "digital-bits|90s|temperature|"
    "enum-tc32-online|90s|analog|"
    "enum-tc32-offline|90s|analog|"
    "enum-e1608-online|90s|analog|"
    "enum-e1608-offline|90s|analog|"
    "enum-e1608-init|90s|analog|"
    "bounds-tc32-online|90s|analog|"
    "bounds-tc32-offline|90s|analog|"
    "bounds-e1608-online|90s|analog|"
    "bounds-e1608-offline|90s|analog|"
    "mac-tc32-online|150s|temperature|"
    "mac-tc32-offline|150s|temperature|"
    "mac-two-ports|150s|temperature|"
    "mac-known-absent|150s|temperature|"
    "endpoint-same-ip|120s|temperature|hosts"
    "endpoint-mixed|120s|temperature|hosts"
    "endpoint-distinct-ip|120s|temperature|hosts"
    "endpoint-default-port|120s|temperature|hosts"
    "endpoint-alt-port|120s|temperature|hosts"
    "endpoint-hostname|120s|temperature|hosts"
    "endpoint-hostname-port|120s|temperature|hosts"
    "endpoint-wrong-port|120s|temperature|hosts"
    "silent-device|240s|temperature|"
    "read-error|120s|temperature|"
    "temperature-array|120s|temperature|"
    "temperature-diagnostics|120s|temperature|"
)
readonly attempts=3
readonly exit_loop_case=endpoint-same-ip
readonly exit_loop_runs=150
readonly exit_loop_jobs=3

function usage {
    printf 'Usage: %s [checkout] [root]\n' "${0##*/}" >&2
    exit 2
}

function on_exit {
    local rc=$?
    printf 'RECONNECT-END rc=%s\n' "${rc}"
}

# Prints the value of a make variable of the checkout and returns 1 with a
# message when the value is missing; a caller in a command substitution ends
# the script on that status.
function read_variable {
    local name="$1"
    local value=""

    value=$(make -s "print-${name}") || value=""
    if [[ -z ${value} ]]; then
        printf 'make print-%s gives no value in the checkout\n' "${name}" >&2
        return 1
    fi
    printf '%s\n' "${value}"
}

# One attempt of one case in a user and network namespace with the fixture
# addresses; the working directory is the fork clone. Sets ATTEMPT_FAILED to
# the names of the failed assertions that the result lines of the attempt name.
function attempt_case {
    local n="$1"
    local case_name="$2"
    local limit="$3"
    local template="$4"
    local hosts="$5"
    local case_arg="${case_name}"
    local out="${run}/${case_name}.attempt${n}.out"
    local log="${run}/${case_name}.attempt${n}.log"
    local st=0

    [[ ${case_name} != default ]] || case_arg=""
    # The single-quoted script is expanded by the inner shell, which receives
    # its arguments positionally.
    # shellcheck disable=SC2016
    unshare -Urnm bash -c '
        ip link set lo up && ip link add sim0 type dummy && ip addr add 192.0.2.1/24 dev sim0 && ip link set sim0 up &&
        ip addr add 192.0.2.2/32 dev lo && ip addr add 192.0.2.3/32 dev lo || exit 90
        if [[ -n "$6" ]]; then mount --bind "$PWD/tests/endpoint-hosts" /etc/hosts || exit 91; fi
        if [[ -n "$2" ]]; then
            timeout "$1" perl tests/test_reconnect.pl --case "$2" "$3/reconnect-ioc" "$3/reconnect.dbd" "$4" "$5"
        else
            timeout "$1" perl tests/test_reconnect.pl "$3/reconnect-ioc" "$3/reconnect.dbd" "$4" "$5"
        fi
    ' _ "${limit}" "${case_arg}" "${BUILD}" "${template}" "${log}" "${hosts}" > "${out}" 2>&1
    st=$?
    ATTEMPT_FAILED=$(grep -o '"name":"[^"]*","passed":false' "${out}" | sed 's/"name":"//; s/","passed":false//' | tr '\n' ';')
    return "${st}"
}

# Runs one line of the table with up to three attempts and prints the status
# of each attempt; returns 0 when an attempt passed.
function run_case {
    local line="$1"
    local case_name=""
    local limit=""
    local template_key=""
    local hosts=""
    local template=""
    local history=""
    local n=0
    local st=0

    IFS='|' read -r case_name limit template_key hosts <<< "${line}"
    case ${template_key} in
        temperature) template="${temperature_template}" ;;
        analog) template="${analog_template}" ;;
        *)
            printf 'case %s names the template %s, which this script does not know\n' "${case_name}" "${template_key}" >&2
            return 1
            ;;
    esac
    for n in $(seq 1 "${attempts}"); do
        st=0
        attempt_case "${n}" "${case_name}" "${limit}" "${template}" "${hosts}" || st=$?
        history+="${st}"
        if [[ ${st} -eq 0 ]]; then
            break
        fi
        history+="(${ATTEMPT_FAILED:-no named assertion}) "
    done
    printf 'case %-26s attempts: %s\n' "${case_name}" "${history}" | tee -a "${summary}"
    [[ ${st} -eq 0 ]]
}

[[ $# -le 2 ]] || usage
checkout=$(readlink -f -- "${1:-${HOME}/sandbox/EPICS-env}")
root=$(readlink -m -- "${2:-${HOME}/sandbox/reconnect}")
[[ ${root} != / ]] || usage
if [[ ! -s ${checkout}/configure/RELEASE ]]; then
    printf 'checkout %s holds no configure/RELEASE\n' "${checkout}" >&2
    exit 2
fi
missing=""
for tool in git make perl unshare ip timeout mount seq; do
    command -v "${tool}" > /dev/null 2>&1 || missing="${missing} ${tool}"
done
if [[ -n ${missing} ]]; then
    printf 'missing tools:%s\n' "${missing}" >&2
    exit 2
fi

trap on_exit EXIT
cd "${checkout}" || exit 1
pin=$(read_variable SRC_TAG_MEASCOMP) || exit 2
base=$(read_variable SRC_BASE_MEASCOMP) || exit 2
name=$(read_variable SRC_NAME_MEASCOMP) || exit 2
tree=$(read_variable INSTALL_LOCATION_EPICS) || exit 2
tree=$(readlink -f -- "${tree}")
repo="${root}/${name}"
run="${root}/run"
summary="${run}/summary.txt"

mkdir -p -- "${root}" || exit 1
if [[ ! -d ${repo}/.git ]]; then
    git clone --quiet "${base}/${name}" "${repo}" || exit 1
fi
if ! git -C "${repo}" cat-file -e "${pin}^{commit}" 2> /dev/null; then
    git -C "${repo}" fetch --quiet origin || exit 1
fi
git -C "${repo}" checkout --quiet "${pin}" || exit 1
commit=$(git -C "${repo}" rev-parse HEAD) || exit 1
if [[ ${commit} != "${pin}"* ]]; then
    printf 'the commit %s of the fork does not begin with the pin %s\n' "${commit}" "${pin}" >&2
    exit 1
fi

test_move_to_trash "${root}/trash" "${run}" || exit 1
mkdir -- "${run}" || exit 1
export BASE="${tree}/base"
ASYN=$(readlink -f -- "${tree}/modules/asyn")
export ASYN
export ULDAQ_INCLUDE="${tree}/vendor/include"
export ULDAQ_LIB="${tree}/vendor/lib"
export BUILD="${run}/build"
printf 'run: %s\ntree: %s\npin: %s\ncommit: %s\nasyn: %s\n' "${run}" "${tree}" "${pin}" "${commit}" "${ASYN##*/}" | tee -a "${summary}"

build_status=0
(cd "${repo}" && perl tests/build_reconnect.pl > "${run}/build.out" 2>&1) || build_status=$?
printf 'build status %s\n' "${build_status}" | tee -a "${summary}"
[[ ${build_status} -eq 0 ]] || exit 1

cd "${repo}" || exit 1
temperature_template="${repo}/measCompApp/Db/measCompTemperatureIn.template"
analog_template="${repo}/measCompApp/Db/measCompAnalogIn.template"

failed=0
for line in "${cases[@]}"; do
    run_case "${line}" || failed=$((failed + 1))
done
printf 'cases: %s of %s failed\n' "${failed}" "${#cases[@]}" | tee -a "${summary}"

loop_status=0
bash tests/exit_loop.bash "${exit_loop_case}" "${exit_loop_runs}" "${exit_loop_jobs}" "${BUILD}/reconnect-ioc" \
    "${BUILD}/reconnect.dbd" "${temperature_template}" "${run}/exit-loop" > "${run}/exit-loop.out" 2>&1 || loop_status=$?
printf 'exit loop status=%s: %s\n' "${loop_status}" "$(tail -n 1 "${run}/exit-loop.out")" | tee -a "${summary}"

[[ ${failed} -eq 0 && ${loop_status} -eq 0 ]] || exit 1
