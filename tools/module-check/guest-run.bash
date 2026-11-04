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
# Run one command on a test machine over SSH and keep its output as a log.
#
# The command runs in the login shell of the machine; its exit status is
# appended to the log as the last line, "rc=<n>", because a redirected ssh
# keeps no exit status of its own. The log is <log_dir>/<label>-<os>.log,
# by default under work/base-bump of the checkout, the name that
# module-bump-procedure.md, The checks, gives it. Prints the log path and its last line. The script exits 0 once the
# log is written, whatever the status of the command; a log of that name that
# already exists is not overwritten, and the script exits 2 instead.
#
# The machines are read from a hosts file that stays outside the repository
# (work/ is gitignored), one line per machine, "<os>=<user>@<address>", and
# an optional line "ssh_options=<options>" that every ssh call receives in
# addition to -o BatchMode=yes -o ConnectTimeout=30. The login must work
# without a prompt: the key is in the agent or the configuration, and the host
# key is known, or ssh_options carries -o StrictHostKeyChecking=accept-new for
# a new guest (release-procedure.md, Test machines). A login that prompts ends
# in the log as "ssh exit 255".
#
# Usage: guest-run.bash <os> <label> <command> [log_dir]
#   <os>       key of the machine in the hosts file, such as debian13 or rocky8
#   <label>    log label, such as baseline-build or consumers
#   <command>  the command, one argument in single quotes so that its $ and
#              quotes reach the shell of the machine, which runs it
#   [log_dir]  directory of the log, absolute or relative to the current
#              directory; default <checkout>/work/base-bump
# Environment:
#   GUEST_HOSTS_FILE  hosts file; default <checkout>/work/guest-hosts.env

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
checkout="$(cd "${script_dir}/../.." && pwd)"
hosts_file="${GUEST_HOSTS_FILE:-${checkout}/work/guest-hosts.env}"
readonly script_dir checkout hosts_file

function usage {
    printf 'Usage: %s <os> <label> <command> [log_dir]\n' "${0##*/}" >&2
    exit 2
}

# Prints the value of a key of the hosts file; returns 1 when the key is absent.
function read_host_var {
    local key="$1"
    local line=""
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        [[ "${line}" == "${key}="* ]] || continue
        printf '%s\n' "${line#*=}"
        return 0
    done < "${hosts_file}"
    return 1
}

[[ $# -ge 3 && $# -le 4 ]] || usage
os="$1"
label="$2"
command="$3"
log_dir="${4:-${checkout}/work/base-bump}"

if [[ ! -s "${hosts_file}" ]]; then
    printf 'hosts file %s is missing or empty\n' "${hosts_file}" >&2
    exit 2
fi
if ! host=$(read_host_var "${os}") || [[ -z "${host}" ]]; then
    printf 'no line "%s=<user>@<address>" in %s\n' "${os}" "${hosts_file}" >&2
    exit 2
fi
ssh_options=$(read_host_var ssh_options || true)

mkdir -p "${log_dir}"
log="${log_dir}/${label}-${os}.log"
if [[ -e "${log}" ]]; then
    printf 'log %s exists; move it aside before running again\n' "${log}" >&2
    exit 2
fi
rc=0
# ssh_options is a space-separated list of options and must split.
# shellcheck disable=SC2086
ssh -o BatchMode=yes -o ConnectTimeout=30 ${ssh_options} "${host}" "${command}; echo rc=\$?" > "${log}" 2>&1 || rc=$?
if [[ ${rc} -ne 0 ]]; then
    printf 'ssh exit %s\n' "${rc}" >> "${log}"
fi
printf '%s\n' "${log}"
tail -n 1 "${log}"
