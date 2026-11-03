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
# Build the whole EPICS-env tree of a sandbox checkout on a test machine: the
# steps 1 to 11 of docs/src/procedures/build-and-install.md (the baseline
# build of release-procedure.md, step 6, part B), or the rebuild of a damaged
# tree at the current candidate (module-bump-procedure.md, The checks, item 3).
#
# Without --rebuild: writes configure/RELEASE.local with the vendor path,
# clones uldaq-env and open62541-env beside the checkout and installs both
# into <tree>/vendor, then runs make init, patch, conf, check.module-deps,
# build, install, and symlinks; <conf_target> is the configuration target of
# the two vendor checkouts only (conf.rocky8 on Rocky Linux 8), EPICS-env
# itself always takes make conf. With --rebuild: moves the
# existing install location aside as <install_location>.damaged-<stamp>,
# installs the two vendor libraries again from their built checkouts, runs
# make patch.revert, and then the same steps from make init. The last line of
# the output is BUILD-END rc=<n>. Runs as the user that owns the checkout.
#
# Usage: guest-baseline.bash [--rebuild] [conf_target]
#   --rebuild      rebuild of a damaged tree, as described above
#   [conf_target]  vendor configuration target: conf (default) on Debian and
#                  Ubuntu, conf.rocky8 on Rocky Linux 8
# Environment:
#   GUEST_CHECKOUT  EPICS-env checkout; default ${HOME}/sandbox/EPICS-env

set -euo pipefail

checkout="${GUEST_CHECKOUT:-${HOME}/sandbox/EPICS-env}"
readonly checkout
uldaq_repo="https://github.com/jeonghanlee/uldaq-env"
open62541_repo="https://github.com/jeonghanlee/open62541-env"
readonly uldaq_repo open62541_repo

function usage {
    printf 'Usage: %s [--rebuild] [conf_target]\n' "${0##*/}" >&2
    exit 2
}

function on_exit {
    local rc=$?
    printf 'BUILD-END rc=%s\n' "${rc}"
}

# Clones a vendor checkout beside the EPICS-env checkout when it is absent,
# points its install location at the vendor directory, and builds and
# installs it.
function vendor_build {
    local repo="$1"
    local dir="$2"
    local conf_target="$3"
    local vendor_path="$4"

    if [[ ! -d ${dir} ]]; then
        git clone "${repo}" "${dir}"
    fi
    printf 'INSTALL_LOCATION=%s\n' "${vendor_path}" > "${dir}/configure/CONFIG_SITE.local"
    make -C "${dir}" init "${conf_target}" build install
}

rebuild=no
conf_target=conf
while [[ $# -gt 0 ]]; do
    case "$1" in
        --rebuild) rebuild=yes ;;
        -*) usage ;;
        *)
            [[ ${conf_target} == conf ]] || usage
            conf_target="$1"
            ;;
    esac
    shift
done

trap on_exit EXIT
cd "${checkout}"
printf 'started: %s\n' "$(date -u +%FT%TZ)"
printf 'HEAD: %s\n' "$(git rev-parse HEAD)"
vendor_path="$(make -s print-INSTALL_LOCATION_EPICS)/vendor"
printf 'VENDOR_PATH: %s\n' "${vendor_path}"

if [[ ${rebuild} == yes ]]; then
    install_location="$(make -s print-INSTALL_LOCATION)"
    stamp="$(date -u +%Y%m%dT%H%M%SZ)"
    mv "${install_location}" "${install_location}.damaged-${stamp}"
    printf 'damaged tree moved to: %s\n' "${install_location}.damaged-${stamp}"
    make -C ../uldaq-env build install
    make -C ../open62541-env build install
    ls "${vendor_path}/lib"
    make patch.revert
else
    # Steps 1 and 2: the vendor directory and the RELEASE.local lines.
    printf 'VENDOR_ULDAQ_PATH=%s\n' "${vendor_path}" > configure/RELEASE.local
    echo 'OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor' >> configure/RELEASE.local
    # Steps 3 and 4: the two vendor libraries.
    vendor_build "${uldaq_repo}" ../uldaq-env "${conf_target}" "${vendor_path}"
    vendor_build "${open62541_repo}" ../open62541-env "${conf_target}" "${vendor_path}"
    ls "${vendor_path}/lib"
fi

# Steps 5 to 11: base and the modules.
make init
make patch
make conf
make check.module-deps
make build
make install
make symlinks
printf 'modules entries: %s\n' "$(find "$(make -s print-INSTALL_LOCATION_EPICS)/modules" -mindepth 1 -maxdepth 1 | wc -l)"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
