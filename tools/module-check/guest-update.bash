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
# Rebuild one module at its new pin inside an epics-dev guest checkout.
#
# Runs as root in the guest, where the checkout and the installed tree are
# root-owned. Fetches and checks out the candidate commit, then runs the
# module steps of the bump procedure: reconf.modules, the install location,
# removal of the source tree, the clone target, the configuration target, the
# dependency check, the build, and the symlink. Prints the values that the
# Build row of the module's register detail records.
#
# Usage: guest-update.bash <module> <KEY> <commit> [checkout]
#   <module>   make name of the module, such as pvxs or sscan
#   <KEY>      upper-case key of its SRC_* variables, such as PVXS or SSCAN
#   <commit>   candidate commit, pushed to origin
#   [checkout] EPICS-env checkout in the guest; default /opt/epics-env-src/EPICS-env
# Environment:
#   CONF_TARGET  configuration target when it differs from conf.<module>,
#                such as conf.sncseq for sequencer

set -euo pipefail

usage() {
    printf 'Usage: %s <module> <KEY> <commit> [checkout]\n' "${0##*/}" >&2
    exit 2
}

[[ $# -ge 3 && $# -le 4 ]] || usage
module=$1
key=$2
commit=$3
checkout=${4:-/opt/epics-env-src/EPICS-env}
conf_target=${CONF_TARGET:-conf.${module}}

cd "${checkout}"
git fetch -q origin
git checkout -q "${commit}"
printf 'HEAD: %s\n' "$(git rev-parse HEAD)"
printf 'started: %s\n' "$(date -u +%FT%TZ)"

make reconf.modules
tag=$(make -s "print-SRC_TAG_${key}")
if [[ -z ${tag} ]]; then
    printf 'configure/RELEASE defines no SRC_TAG_%s\n' "${key}" >&2
    exit 2
fi
if [[ ! -d ${module}-src ]]; then
    printf '%s-src is not a directory in %s\n' "${module}" "${checkout}" >&2
    exit 2
fi
printf 'pin: %s\n' "${tag}"
location=$(make -s "print-INSTALL_LOCATION_${key}")
printf 'INSTALL_LOCATION_%s: %s\n' "${key}" "${location}"
rm -rf "${module}-src"
make "${key}"
make "${conf_target}"
make check.module-deps "MODULE=${module}"
make "build.${module}"
make "symlink.${module}"

tree=$(make -s print-INSTALL_LOCATION_EPICS)
printf 'link: modules/%s -> %s\n' "${module}" "$(readlink "${tree}/modules/${module}")"
for lib in "${location}"/lib/linux-x86_64/lib*.so; do
    [[ -e ${lib} ]] || continue
    printf 'SONAME %s: %s\n' "${lib##*/}" \
        "$(readelf -d "${lib}" | awk '/SONAME/ { gsub(/[][]/, "", $5); print $5 }')"
done
if [[ -f ${location}/cfg/iocsh.conf ]]; then
    printf 'iocsh.conf %s\n' "$(grep '^version=' "${location}/cfg/iocsh.conf")"
fi
printf 'cfg: %s\n' "$(find "${location}/cfg" -mindepth 1 -maxdepth 1 -printf '%f ' 2>/dev/null)"
printf 'modules entries: %s\n' "$(find "${tree}/modules" -mindepth 1 -maxdepth 1 | wc -l)"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
printf 'UPDATE-DONE %s %s\n' "${module}" "${commit}"
