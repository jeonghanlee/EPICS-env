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

function build_module 
{
    local module="$1"; shift;
    make build."${module}"   || exit
    make install."${module}" || exit
    make symlink."${module}" || exit
}

pushd "${SC_TOP}/.."

make init.modules         || exit
make conf.modules         || exit
make conf.modules.libera  || exit

modules=("iocStats" "recsync" "retools" "caPutLog" "autosave" "sequencer-2-2" "sscan" "calc" "asyn")

for mod in "${modules[@]}"; do
    build_module "$mod";
done

popd
