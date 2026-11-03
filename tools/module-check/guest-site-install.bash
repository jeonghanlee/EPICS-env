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
# Install the site modules of a site checkout into the installed tree of a
# sandbox EPICS-env checkout on a test machine, the sequence of
# docs/src/procedures/add-site-modules.md as the cycle of EPICS base ran it
# (release-procedure.md, step 6, part B).
#
# Writes INSTALL_LOCATION of the tree into configure/CONFIG_SITE.local of the
# site checkout, prints the counts of the modules directory before and after,
# and runs make init, patch, conf, check.module-deps (its status is printed
# as "module-deps rc=<n>" and does not stop the run), build, install, and
# symlinks, then lists the installed site modules with
# LC_ALL=C make exist.modules LEVEL=1. The last line is
# SITE-INSTALL-DONE <site commit>. Runs as the user that owns both checkouts
# and the tree.
#
# Usage: guest-site-install.bash <site_checkout> [checkout]
#   <site_checkout>  site module checkout, at the commit to install
#   [checkout]       EPICS-env checkout whose tree receives the modules;
#                    default ${HOME}/sandbox/EPICS-env

set -euo pipefail

function usage {
    printf 'Usage: %s <site_checkout> [checkout]\n' "${0##*/}" >&2
    exit 2
}

[[ $# -ge 1 && $# -le 2 ]] || usage
site_arg=$1
checkout_arg=${2:-${HOME}/sandbox/EPICS-env}
for dir in "${site_arg}" "${checkout_arg}"; do
    if [[ ! -d ${dir} ]]; then
        printf '%s is not a directory\n' "${dir}" >&2
        exit 2
    fi
done
site_checkout=$(readlink -f -- "${site_arg}")
checkout=$(readlink -f -- "${checkout_arg}")
if [[ ! -s ${site_checkout}/configure/RELEASE ]]; then
    printf 'site checkout %s holds no configure/RELEASE\n' "${site_arg}" >&2
    exit 2
fi

cd "${site_checkout}"
site_commit=$(git rev-parse HEAD)
printf 'started: %s\n' "$(date -u +%FT%TZ)"
printf 'site HEAD: %s\n' "${site_commit}"
printf 'site status lines: %s\n' "$(git status --short | wc -l)"
tree=$(make -s -C "${checkout}" print-INSTALL_LOCATION_EPICS)
printf 'INSTALL_LOCATION:=%s\n' "${tree}" > configure/CONFIG_SITE.local
printf 'CONFIG_SITE.local: %s\n' "$(cat configure/CONFIG_SITE.local)"
printf 'site INSTALL_LOCATION_EPICS: %s\n' "$(make -s print-INSTALL_LOCATION_EPICS)"
printf 'modules before: %s\n' "$(find "${tree}/modules" -mindepth 1 -maxdepth 1 | wc -l)"

make init
make patch
make conf
module_deps_rc=0
make check.module-deps || module_deps_rc=$?
printf 'module-deps rc=%s\n' "${module_deps_rc}"
make build
make install
make symlinks

# The installed entries of the site modules, by the names of the site RELEASE.
mapfile -t site_modules < <(sed -n 's/^SRC_NAME_[A-Z0-9_]*:=//p' configure/RELEASE)
grep_args=()
for module in "${site_modules[@]}"; do
    grep_args+=(-e "${module}")
done
LC_ALL=C make exist.modules LEVEL=1 | grep "${grep_args[@]}"
printf 'modules entries: %s\n' "$(find "${tree}/modules" -mindepth 1 -maxdepth 1 | wc -l)"
printf 'finished: %s\n' "$(date -u +%FT%TZ)"
printf 'SITE-INSTALL-DONE %s\n' "${site_commit}"
