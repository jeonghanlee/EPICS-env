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
# Patch round trip on a fresh clone at a candidate commit, beside the
# baseline checkout of an epics-dev guest.
#
# Clones the repository at the commit, runs make init, make patch, and
# make patch.revert, and prints the Patching line counts and the status line
# count of every source tree. Prints the values that the Patch round trip
# row of the module's register detail records. Runs as root in the guest.
#
# Usage: guest-roundtrip.bash <commit> [module] [parent]
#   <commit>  candidate commit, pushed to origin
#   [module]  module whose Patching line count is printed
#   [parent]  directory that holds the clone; default /opt/epics-env-src
# Environment:
#   EPICS_ENV_REPO  repository to clone; default https://github.com/jeonghanlee/EPICS-env

set -uo pipefail

usage() {
    printf 'Usage: %s <commit> [module] [parent]\n' "${0##*/}" >&2
    exit 2
}

[[ $# -ge 1 && $# -le 3 ]] || usage
commit=$1
module=${2:-}
parent=${3:-/opt/epics-env-src}
repo=${EPICS_ENV_REPO:-https://github.com/jeonghanlee/EPICS-env}
clone="${parent}/EPICS-env-roundtrip"

cd "${parent}" || exit 1
rm -rf "${clone}"
git clone -q "${repo}" "${clone}" || exit 1
cd "${clone}" || exit 1
git checkout -q "${commit}" || exit 1
printf 'HEAD: %s\n' "$(git rev-parse HEAD)"
printf 'started: %s\n' "$(date -u +%FT%TZ)"

make init > roundtrip-init.log 2>&1
printf 'init rc=%s\n' "$?"
printf 'src trees: %s\n' "$(find . -mindepth 1 -maxdepth 1 -type d -name '*-src' | wc -l)"
make patch > roundtrip-patch.log 2>&1
printf 'patch rc=%s\n' "$?"
printf 'Patching lines: %s\n' "$(grep -c '^Patching' roundtrip-patch.log)"
if [[ -n ${module} ]]; then
    printf 'Patching %s-src lines: %s\n' "${module}" "$(grep -c "^Patching ${module}-src" roundtrip-patch.log)"
fi
make patch.revert > roundtrip-revert.log 2>&1
printf 'revert rc=%s\n' "$?"

total=0
for dir in ./*-src; do
    lines=$(git -C "${dir}" status --short | wc -l)
    printf '%s %s\n' "${dir#./}" "${lines}"
    total=$((total + lines))
done
printf 'status lines in all trees: %s\n' "${total}"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
printf 'ROUNDTRIP-DONE %s\n' "${commit}"
