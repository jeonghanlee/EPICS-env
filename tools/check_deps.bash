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

declare -g VERBOSE="NO"

declare -i bin_rpath_count=0
declare -i so_rpath_count=0

BIN_FOLDER="bin/linux-x86_64"
SO_FOLDER="lib/linux-x86_64"

while [[ "$1" =~ ^- ]]; do
  case $1 in
    -v | --verbose ) VERBOSE="YES" ;;
    * ) echo "Invalid option: $1" >&2; exit 1 ;;
  esac
  shift
done

TARGET="$1";

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

## exclude symlinks
#declare -a MODS_SO_PATHS=( ${MODS_TARGET}/*/${SO_FOLDER} )
mapfile -t MODS_SO_PATHS < <(find -P "${MODS_TARGET}" -type d -wholename "*/${SO_FOLDER}")
if [[ "$VERBOSE" == "YES" ]]; then
    printf '%s\n' "${MODS_SO_PATHS[@]}"
fi

VEND_SO_PATH=${VEND_TARGET}/lib

## only file, exclude symlinks
## exec files
mapfile -t bin_files < <(find ${BASE_BIN_PATH} -type f -print0 |xargs -0 grep -IL .)

for path in "${MODS_BIN_PATHS[@]}"; do
    mapfile -t -O "${#bin_files[@]}" bin_files < <(find "$path" -type f -print0 |xargs -0 grep -IL .)
done

## so files
mapfile -t so_files  < <(find -P ${BASE_SO_PATH} -type f -name "*.so")

for path in "${MODS_SO_PATHS[@]}"; do
     mapfile -t -O "${#so_files[@]}" so_files < <(find -P ${path} -type f -name "*.so")
done

mapfile -t -O "${#so_files[@]}" so_files < <(find -P ${VEND_SO_PATH} -type f -name "*.so")

if [[ "$VERBOSE" == "YES" ]]; then
	echo ">> Binary Files"
fi

for exec_file in "${bin_files[@]}"; do
    readelf_output=$(readelf -d "$exec_file")
	if [[ "$VERBOSE" == "YES" ]]; then
		echo ">> BIN : $exec_file"
		echo "$readelf_output" | grep "NEEDED\|RUNPATH\|RPATH"
	fi
    if echo "$readelf_output" | grep -q "RPATH"; then
        echo -e ">> \033[31mWARNING: RPATH detected in $exec_file. This can cause portability issues.\033[0m" >&2
        ((bin_rpath_count++))
    fi
done

if [[ "$VERBOSE" == "YES" ]]; then
	echo ">> Shared Library Files"
fi

for so_file in "${so_files[@]}"; do
    readelf_output=$(readelf -d "$so_file")
	if [[ "$VERBOSE" == "YES" ]]; then
	    echo ">> SO  : $so_file "
		echo "$readelf_output" | grep "NEEDED\|RUNPATH\|RPATH"
	fi
    if echo "$readelf_output" | grep -q "RPATH"; then
        echo -e ">> \033[31mWARNING: RPATH detected in $so_file. This can cause portability issues.\033[0m" >&2
        ((so_rpath_count++))
    fi
done


# Print the final count at the end of the script
echo "--------------------------------------------------------"
printf " >> BIN: Total Files with RPATH / ALL: \033[31m%3s\033[0m / %3s\n" "$bin_rpath_count" "${#bin_files[@]}"
printf " >>  SO: Total Files with RPATH / ALL: \033[31m%3s\033[0m / %3s\n" "$so_rpath_count" "${#so_files[@]}"
echo "--------------------------------------------------------"

