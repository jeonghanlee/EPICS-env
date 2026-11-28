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
# Install a vendor library at its pinned tag into the tree of a sandbox
# checkout and rebuild the module that links it.
#
# Runs as the user that owns the checkout and the installed tree; the checkout
# path is resolved with readlink -f. Moves the old wrapper checkout, the
# directory uldaq-env beside the EPICS-env checkout, into <parent>/trash
# through tools/test-trash.bash, takes the checkout at the tag that
# VENDOR_ULDAQ_TAG pins in configure/RELEASE with tools/vendor-checkout.bash,
# writes its INSTALL_LOCATION into the vendor directory of the tree, and runs
# make init, <conf_target>, build and install in it, as step 3 of
# docs/src/procedures/build-and-install.md. The new header and library carry a
# new time, so the next make install of the tree would recompile the sources
# of measComp that include uldaq.h and relink libmeasComp.so, and its hash
# would then differ from its build record; the script therefore runs make
# build.measComp, which rebuilds the module, writes its build record, and
# generates its loader metadata. Prints the pin, the vendor directory, and the
# tag, source, and patch lines of the vendor record cfg/<library>/build-record.
# The last line of the output is BUILD-END rc=<n>.
#
# Usage: guest-vendor-update.bash <wrapper> [conf_target] [checkout]
#   <wrapper>      uldaq-env; any other wrapper is a usage error
#   [conf_target]  configuration target of the wrapper: conf (default) on
#                  Debian and Ubuntu, conf.rocky8 on Rocky Linux 8
#   [checkout]     EPICS-env checkout; default ${HOME}/sandbox/EPICS-env
# Exit status: 0 the library is installed, measComp is rebuilt, and the vendor
#   record is printed; 2 a usage error or a missing vendor record; otherwise
#   the exit status of the first command that failed.

set -euo pipefail
# shellcheck source=../test-trash.bash disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../test-trash.bash"

readonly wrapper_name=uldaq-env
readonly module=measComp

function usage {
    printf 'Usage: %s %s [conf_target] [checkout]\n' "${0##*/}" "${wrapper_name}" >&2
    exit 2
}

function on_exit {
    local rc=$?
    printf 'BUILD-END rc=%s\n' "${rc}"
}

[[ $# -ge 1 && $# -le 3 ]] || usage
[[ $1 == "${wrapper_name}" ]] || usage
conf_target=${2:-conf}
checkout=$(readlink -f -- "${3:-${HOME}/sandbox/EPICS-env}")
parent=$(dirname -- "${checkout}")
wrapper_dir="${parent}/${wrapper_name}"
library=${wrapper_name%-env}

trap on_exit EXIT
cd "${checkout}"
printf 'started: %s\n' "$(date -u +%FT%TZ)"
printf 'HEAD: %s\n' "$(git rev-parse HEAD)"
printf 'pin: %s\n' "$(make -s print-VENDOR_ULDAQ_TAG)"
vendor_path="$(make -s print-INSTALL_LOCATION_EPICS)/vendor"
printf 'VENDOR_PATH: %s\n' "${vendor_path}"

test_move_to_trash "${parent}/trash" "${wrapper_dir}"
bash tools/vendor-checkout.bash "${wrapper_name}" "${wrapper_dir}"
printf 'INSTALL_LOCATION=%s\n' "${vendor_path}" > "${wrapper_dir}/configure/CONFIG_SITE.local"
make -C "${wrapper_dir}" init "${conf_target}" build install

make "build.${module}"

record="${vendor_path}/cfg/${library}/build-record"
if [[ ! -s ${record} ]]; then
    printf 'no vendor record %s\n' "${record}" >&2
    exit 2
fi
grep -E '^(tag|source|patch)=' "${record}"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
