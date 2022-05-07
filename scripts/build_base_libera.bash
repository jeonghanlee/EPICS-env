#!/usr/bin/env bash
#
#  Copyright (c) 2022  Jeong Han Lee
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
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1


declare -g SC_SCRIPT;
declare -g SC_TOP;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

INSTALL_LOCATION="$1";

if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/usr/local";
fi

pushd "${SC_TOP}/.."

echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > configure/CONFIG_SITE.local 
make init.base      || exit
scp configure/os/CONFIG_SITE.linux-x86_64.linux-arm epics-base-src/configure/os/
make conf.base      || exit
make conf.base.show || exit
make patch.base     || exit
make build.base     || exit
make install.base   || exit

popd
