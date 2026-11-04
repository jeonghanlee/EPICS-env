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
# Start the minimal example IOC and run the loader verification suite against
# the installed tree of a sandbox checkout.
#
# Checks the tools the suite needs, starts examples/iocsh/st.cmd through the
# installed iocsh.bash and reports whether it reached iocRun, then runs
# examples/iocsh/tests/run_all.bash, every script or the ones named, and
# prints the per-script lines, the FAIL count, and the count-less outputs of
# the scripts that ran. Runs as the user that owns the
# checkout and the tree; the suite modifies both and restores them. Every path
# is resolved with readlink, because the loader reports resolved paths and the
# suite compares them with the ones it was given.
#
# Usage: guest-suite.bash [checkout] [log_dir] [site_checkout] [scripts]
#   [checkout]      EPICS-env checkout; default ${HOME}/sandbox/EPICS-env
#   [log_dir]       suite log directory, an absolute path without white space
#                   outside the checkout and the tree; default
#                   ${HOME}/sandbox/iocsh-tests
#                   Earlier logs move into <log_dir parent>/trash.
#   [site_checkout] site module checkout whose modules are installed in the
#                   tree, passed to the suite as IOCSH_TEST_SITE_REPO; an
#                   empty string for none
#   [scripts]       the scripts to run, space separated in one argument, in
#                   the order given; empty or absent runs every script
# Environment:
#   GUEST_SUITE_MIN_FREE_KB  free space the volume of the log directory must
#                            hold before the run, in 1024-byte blocks; default
#                            6291456 (6 GB). The script refuses to start with
#                            status 2 below it, and prints the free space as
#                            "free before:" and "free after:".

set -uo pipefail
# shellcheck source=../test-trash.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../test-trash.bash" || exit 1

min_free_kb=${GUEST_SUITE_MIN_FREE_KB:-6291456}
readonly min_free_kb

usage() {
    printf 'Usage: %s [checkout] [log_dir] [site_checkout] [scripts]\n' "${0##*/}" >&2
    exit 2
}

[[ $# -le 4 ]] || usage
scripts=${4:-}
checkout=$(readlink -f -- "${1:-${HOME}/sandbox/EPICS-env}")
log_dir=${2:-${HOME}/sandbox/iocsh-tests}
if [[ -L ${log_dir} ]]; then
    printf 'log path is a symlink: %s; choose a directory path\n' "${log_dir}" >&2
    exit 2
fi
site_checkout=""
if [[ -n ${3:-} ]]; then
    site_checkout=$(readlink -f -- "$3")
    if [[ ! -s ${site_checkout}/configure/RELEASE ]]; then
        printf 'site checkout %s holds no configure/RELEASE\n' "$3" >&2
        exit 2
    fi
fi

cd "${checkout}" || exit 1
tree=$(readlink -m -- "$(make -s print-INSTALL_LOCATION_EPICS)")
printf 'tree: %s\n' "${tree}"
case ${log_dir} in
    /) usage ;;
    /*) ;;
    *) usage ;;
esac
if [[ ${log_dir} == *[[:space:]]* ]]; then
    usage
fi
log_dir=$(readlink -m -- "${log_dir}")
[[ ${log_dir} != / ]] || usage
case ${log_dir} in
    "${checkout}"|"${checkout}"/*|"${tree}"|"${tree}"/*)
        printf 'log_dir %s lies inside the checkout or the installed tree\n' "${log_dir}" >&2
        exit 2
        ;;
esac
if [[ ${checkout}/ == "${log_dir}/"* || ${tree}/ == "${log_dir}/"* ]]; then
    printf 'log_dir %s contains the checkout or the installed tree\n' "${log_dir}" >&2
    exit 2
fi
# The suite writes several gigabytes of tree copies under the log directory;
# the free space of its nearest existing parent, in 1024-byte blocks, must
# reach the limit before the run starts.
parent=${log_dir}
while [[ ! -d ${parent} ]]; do
    parent=${parent%/*}
    [[ -n ${parent} ]] || parent=/
done
free_kb=$(df -P -k -- "${parent}" | awk 'NR == 2 { print $4 }')
if [[ ${free_kb} -lt ${min_free_kb} ]]; then
    printf 'free space %s KB on %s is below GUEST_SUITE_MIN_FREE_KB=%s KB\n' \
        "${free_kb}" "${parent}" "${min_free_kb}" >&2
    exit 2
fi
printf 'free before: %s KB\n' "${free_kb}"

missing=""
for tool in bash gawk perl git patch readelf ldd ss ip pgrep ps stat timeout \
            expect strace setsid mkfifo truncate sha256sum make socat; do
    command -v "${tool}" > /dev/null 2>&1 || missing="${missing} ${tool}"
done
command -v docker > /dev/null 2>&1 || command -v podman > /dev/null 2>&1 \
    || missing="${missing} docker-or-podman"
if [[ -n ${missing} ]]; then
    printf 'missing tools:%s\n' "${missing}" >&2
    exit 2
fi

printf 'started: %s\n' "$(date -u +%FT%TZ)"
# setEpicsEnv.bash reads its first argument as a fallback architecture, and a
# sourced file inherits the positional parameters of this script.
set --
# shellcheck source=/dev/null
source "${tree}/setEpicsEnv.bash" > /dev/null

test_move_to_trash "${log_dir%/*}/trash" "${log_dir}" || exit 1
mkdir -p -- "${log_dir%/*}" || exit 1
mkdir -- "${log_dir}" || exit 1
minimal_log="${log_dir}/minimal-ioc.log"
(cd examples/iocsh && timeout 90 iocsh.bash st.cmd < /dev/null > "${minimal_log}" 2>&1)
printf 'minimal IOC exit=%s\n' "$?"
printf 'iocRun lines: %s\n' "$(grep -c 'iocRun: All initialization complete' "${minimal_log}")"
printf 'minimal IOC ERROR lines: %s\n' "$(grep -c 'ERROR' "${minimal_log}")"

export IOCSH_TEST_TREE="${tree}"
export IOCSH_TEST_REPO="${checkout}"
export IOCSH_TEST_OUT="${log_dir}"
if [[ -n ${site_checkout} ]]; then
    export IOCSH_TEST_SITE_REPO="${site_checkout}"
    printf 'site checkout: %s\n' "${site_checkout}"
fi
[[ -z ${scripts} ]] || printf 'scripts: %s\n' "${scripts}"
# The script list is one argument of space-separated names and must split.
# shellcheck disable=SC2086
bash "${checkout}/examples/iocsh/tests/run_all.bash" ${scripts}
printf 'run_all rc=%s\n' "$?"
printf 'FAIL lines: %s\n' "$(grep -a -c '^FAIL' "${log_dir}"/*.log | awk -F: '{ s += $2 } END { print s + 0 }')"
if [[ -f ${log_dir}/verify_minimal_example.log ]]; then
    printf 'records listed: %s\n' "$(grep -a -o 'records listed: [0-9]*' "${log_dir}/verify_minimal_example.log" | sed 's/.*: //')"
fi
if [[ -f ${log_dir}/verify_readme_update_command.log ]]; then
    printf 'readme update count: %s\n' "$(grep -a -B1 'ioc tc exit status' "${log_dir}/verify_readme_update_command.log" | head -n 1)"
fi
if [[ -f ${log_dir}/observe_truncated_library.log ]]; then
    grep -a '^cut at' "${log_dir}/observe_truncated_library.log"
fi
printf 'free after: %s KB\n' "$(df -P -k -- "${parent}" | awk 'NR == 2 { print $4 }')"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
printf 'SUITE-DONE\n'
