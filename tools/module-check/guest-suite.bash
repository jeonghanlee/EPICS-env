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
# the installed tree of an epics-dev guest.
#
# Checks the tools the suite needs, starts examples/iocsh/st.cmd through the
# installed iocsh.bash and reports whether it reached iocRun, then runs
# examples/iocsh/tests/run_all.bash and prints the per-script lines, the three
# count-less outputs, and the FAIL count. Prints the values that the Consumers
# row of the module's register detail records. Runs as root in the guest; the
# suite modifies the tree and the checkout and restores them.
#
# Usage: guest-suite.bash [checkout] [log_dir]
#   [checkout] EPICS-env checkout in the guest; default /opt/epics-env-src/EPICS-env
#   [log_dir]  suite log directory, an absolute path without white space outside
#              the checkout and the tree; default /var/tmp/iocsh-tests

set -uo pipefail

usage() {
    printf 'Usage: %s [checkout] [log_dir]\n' "${0##*/}" >&2
    exit 2
}

[[ $# -le 2 ]] || usage
checkout=${1:-/opt/epics-env-src/EPICS-env}
log_dir=${2:-/var/tmp/iocsh-tests}

cd "${checkout}" || exit 1
tree=$(make -s print-INSTALL_LOCATION_EPICS)
printf 'tree: %s\n' "${tree}"
case ${log_dir} in
    /) usage ;;
    /*) ;;
    *) usage ;;
esac
if [[ ${log_dir} == *[[:space:]]* ]]; then
    usage
fi
case ${log_dir} in
    "${checkout}"|"${checkout}"/*|"${tree}"|"${tree}"/*)
        printf 'log_dir %s lies inside the checkout or the installed tree\n' "${log_dir}" >&2
        exit 2
        ;;
esac

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
# shellcheck source=/dev/null
source "${tree}/setEpicsEnv.bash" > /dev/null

rm -rf "${log_dir}"
mkdir -p "${log_dir}"
minimal_log="${log_dir}/minimal-ioc.log"
(cd examples/iocsh && timeout 90 iocsh.bash st.cmd < /dev/null > "${minimal_log}" 2>&1)
printf 'minimal IOC exit=%s\n' "$?"
printf 'iocRun lines: %s\n' "$(grep -c 'iocRun: All initialization complete' "${minimal_log}")"
printf 'minimal IOC ERROR lines: %s\n' "$(grep -c 'ERROR' "${minimal_log}")"

export IOCSH_TEST_TREE="${tree}"
export IOCSH_TEST_REPO="${checkout}"
export IOCSH_TEST_OUT="${log_dir}"
bash "${checkout}/examples/iocsh/tests/run_all.bash"
printf 'run_all rc=%s\n' "$?"
printf 'FAIL lines: %s\n' "$(grep -a -c '^FAIL' "${log_dir}"/*.log | awk -F: '{ s += $2 } END { print s + 0 }')"
printf 'records listed: %s\n' "$(grep -a -o 'records listed: [0-9]*' "${log_dir}/verify_minimal_example.log" | sed 's/.*: //')"
printf 'readme update count: %s\n' "$(grep -a -B1 'ioc tc exit status' "${log_dir}/verify_readme_update_command.log" | head -n 1)"
grep -a '^cut at' "${log_dir}/observe_truncated_library.log"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
printf 'SUITE-DONE\n'
