#!/usr/bin/env bash
#
#  Copyright (c) 2025 -         Jeong Han Lee
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
#
#
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    :
# version : 1.0.0
#
declare -g SC_RPATH;
#declare -g SC_NAME;
declare -g SC_TOP;
declare -g SC_TIME;

SC_RPATH="$(realpath "$0")";
#SC_NAME=${0##*/};
SC_TOP="${SC_RPATH%/*}"
SC_TIME="$(date +%y%m%d%H%M)"

# Enable core dumps in case the JVM fails
ulimit -c unlimited

function pushdd { builtin pushd "$@" > /dev/null || exit; }
function popdd  { builtin popd  > /dev/null || exit; }

declare -a bin_files;
declare -a so_files;

BIN_FOLDER="bin/linux-x86_64"
SO_FOLDER="lib/linux-x86_64"

TARGET="$1";shift;
if [ -z "$TARGET" ]; then
    echo "Please set the EPICS path. For example \"bash ${0} 1.1.2/debian-12/7.0.7\""
    exit
fi

BASE_TARGET=${TARGET}/base
MODS_TARGET=${TARGET}/modules
VEND_TARGET=${TARGET}/vendor

BASE_BIN_PATH=${BASE_TARGET}/${BIN_FOLDER}
BASE_SO_PATH=${BASE_TARGET}/${SO_FOLDER}

declare -a MODS_BIN_PATHS=( ${MODS_TARGET}/*/${BIN_FOLDER} )
declare -a MODS_SO_PATHS=( ${MODS_TARGET}/*/${SO_FOLDER} )

VEND_SO_PATH=${VEND_TARGET}/lib

mapfile -t bin_files < <(grep -rIL . "$BASE_BIN_PATH")
mapfile -t so_files  < <(find ${BASE_SO_PATH} -name "*.so")

for path in "${MODS_BIN_PATHS[@]}"; do
    mapfile -t -O "${#bin_files[@]}" bin_files < <(grep -rIL . "$path")
done

for path in "${MODS_SO_PATHS[@]}"; do
     mapfile -t -O "${#so_files[@]}" so_files < <(find "$path" -name "*.so")
done

mapfile -t -O "${#so_files[@]}" so_files < <(find ${VEND_SO_PATH} -name "*.so")

echo ">>> Binary Files"
for exec_file in "${bin_files[@]}"; do

    echo ">> BIN : $exec_file "
    readelf_output=$(readelf -d "$exec_file")
    if echo "$readelf_output" | grep -q "RPATH"; then
        echo -e ">> \033[31mWARNING: RPATH detected in $exec_file. This can cause portability issues.\033[0m" >&2
    fi
    echo "$readelf_output" | grep "NEEDED\|RUNPATH\|RPATH"
done

echo ">> Shared Library Files"
for so_file in "${so_files[@]}"; do
    echo ">> SO  : $so_file "
    readelf_output=$(readelf -d "$so_file")
    if echo "$readelf_output" | grep -q "RPATH"; then
        echo -e ">> \033[31mWARNING: RPATH detected in $so_file. This can cause portability issues.\033[0m" >&2
    fi
    echo "$readelf_output" | grep "NEEDED\|RUNPATH\|RPATH"
done

