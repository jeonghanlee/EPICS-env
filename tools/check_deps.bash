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
#declare -g SC_RPATH;
#declare -g SC_NAME;
#declare -g SC_TOP;
#declare -g SC_TIME;

#SC_RPATH="$(realpath "$0")";
#SC_NAME=${0##*/};
#SC_TOP="${SC_RPATH%/*}"
#SC_TIME="$(date +%y%m%d%H%M)"

ulimit -c unlimited

function pushdd { builtin pushd "$@" > /dev/null || exit; }
function popdd  { builtin popd  > /dev/null || exit; }

declare -a bin_files;
declare -a so_files;
declare -g VERBOSE="NO"
declare -i bin_rpath_count=0
declare -i so_rpath_count=0
declare -i bin_abspath_count=0
declare -i so_abspath_count=0

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
## If there is no input, use it with the EPICS-env variable definition.
##
if [ -z "$TARGET" ]; then
    TARGET=$(make print-INSTALL_LOCATION_EPICS)
fi


BASE_TARGET=${TARGET}/base
MODS_TARGET=${TARGET}/modules
VEND_TARGET=${TARGET}/vendor

if [[ "$VERBOSE" == "YES" ]]; then
    printf "%s\n" "${BASE_TARGET}"
    printf "%s\n" "${MODS_TARGET}"
    printf "%s\n" "${VEND_TARGET}"
fi

## BASE bin and lib folders
BASE_BIN_PATH=${BASE_TARGET}/${BIN_FOLDER}
BASE_SO_PATH=${BASE_TARGET}/${SO_FOLDER}

## MODULES bin folders
# shellcheck disable=SC2206
declare -a MODS_BIN_PATHS=( ${MODS_TARGET}/*/${BIN_FOLDER} )
## exclude symlinks
# declare -a MODS_SO_PATHS=( ${MODS_TARGET}/*/${SO_FOLDER} )
## MODULES lib folders
mapfile -t MODS_SO_PATHS < <(find -P "${MODS_TARGET}" -type d -wholename "*/${SO_FOLDER}")
if [[ "$VERBOSE" == "YES" ]]; then
    printf '%s\n' "${MODS_SO_PATHS[@]}"
fi
## VENDOR lib folder
VEND_SO_PATH=${VEND_TARGET}/lib

## BASE : exec files, exclude symlinks
if [ -d "$BASE_BIN_PATH" ]; then
    mapfile -t bin_files < <(find "${BASE_BIN_PATH}" -type f -print0 |xargs -0 grep -IL .)
else
    echo ">> Directory '$BASE_BIN_PATH' does not exist."
fi
## MODULES : exec files, exclude symlinks
for path in "${MODS_BIN_PATHS[@]}"; do
    if [ -d "$path" ]; then
        mapfile -t -O "${#bin_files[@]}" bin_files < <(find "$path" -type f -print0 |xargs -0 grep -IL .)
    else
        echo ">> Directory '$path' does not exist."
    fi
done
## BASE : so files
if [ -d "$BASE_SO_PATH" ]; then
    mapfile -t so_files  < <(find -P "${BASE_SO_PATH}" -type f -name "*.so")
else
    echo ">> Directory '$BASE_SO_PATH' does not exist."
fi
## MODULES : so files
for path in "${MODS_SO_PATHS[@]}"; do
    if [ -d "$path" ]; then
        mapfile -t -O "${#so_files[@]}" so_files < <(find -P "${path}" -type f -name "*.so")
    else
        echo ">> Directory '$path' does not exist."
    fi
done
## VENDOR : so files
if [ -d "$VEND_SO_PATH" ]; then
    mapfile -t -O "${#so_files[@]}" so_files < <(find -P "${VEND_SO_PATH}" -type f -name "*.so")
else
    echo ">> Directory '$VEND_SO_PATH' does not exist."
fi

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
    bin_runpath_string=$(echo "$readelf_output" | grep -E 'R(UN)?PATH' | awk '{print $NF}' | tr -d '[]' )
    IFS=':' read -ra bin_paths <<< "$bin_runpath_string"
    for bin_entry in "${bin_paths[@]}"; do
        if [[ "$bin_entry" =~ ^/usr/lib(|64|32|/[^/]+-linux-gnu) ]]; then
            echo -e ">> \033[33mNOTE: R(UN)PATH in $exec_file includes a standard system library path (e.g., /usr/lib, /usr/lib64, etc.).\033[0m" >&2
        elif [[ "$bin_entry" =~ ^/ ]]; then
            echo -e ">> \033[31mWARNING: R(UN)PATH contains an absolute path in $exec_file. This can cause portability issues.\033[0m" >&2
            ((bin_abspath_count++))
        fi
    done
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
    so_runpath_string=$(echo "$readelf_output" | grep -E 'R(UN)?PATH' | awk '{print $NF}' | tr -d '[]' )
    IFS=':' read -ra so_paths <<< "$so_runpath_string"
    for so_entry in "${so_paths[@]}"; do
        if [[ "$so_entry" =~ ^/usr/lib(|64|32|/[^/]+-linux-gnu) ]]; then
            echo -e ">> \033[33mNOTE: R(UN)PATH in $so_file includes a standard system library path (e.g., /usr/lib, /usr/lib64, etc.).\033[0m" >&2
        elif [[ "$so_entry" =~ ^/ ]]; then
            echo -e ">> \033[31mWARNING: $so_file R(UN)PATH contains an absolute path :$so_entry. This can cause portability issues.\033[0m" >&2
            ((so_abspath_count++))
        fi
    done
done

# Print the final count at the end of the script
echo "--------------------------------------------------------"
printf " >> BIN: Total Files with   RPATH / ALL: \033[31m%3s\033[0m / %3s\n" "$bin_rpath_count" "${#bin_files[@]}"
printf " >>  SO: Total Files with   RPATH / ALL: \033[31m%3s\033[0m / %3s\n" "$so_rpath_count" "${#so_files[@]}"
printf " >> BIN: Total Files with ABSPATH / ALL: \033[31m%3s\033[0m / %3s\n" "$bin_abspath_count" "${#bin_files[@]}"
printf " >>  SO: Total Files with ABSPATH / ALL: \033[31m%3s\033[0m / %3s\n" "$so_abspath_count" "${#so_files[@]}"
echo "--------------------------------------------------------"

