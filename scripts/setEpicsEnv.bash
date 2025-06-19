#!/usr/bin/env bash
#
#  Copyright (c) 2017 -       Jeong Han Lee
#  Copyright (c) 2024 -       Lawrence Berkeley National Laboratory
#  Copyright (c) 2017 - 2018  European Spallation Source ERIC
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
#   Shell   : setEpicsEnv.bash
#   Author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    :
#   version : 4.2.1
#

function pushdd { builtin pushd "$@" > /dev/null || exit; }
function popdd  { builtin popd  > /dev/null || exit; }

#  The following function drop_from_path was copied from
#  the ROOT build system in ${ROOTSYS}/bin/, and modified
#  a little to return its result

function drop_from_path
{
    #
    # Assert that we got enough arguments
    if test $# -ne 2 ; then
        echo "drop_from_path: needs 2 arguments"
        return 1
    fi

    local p=$1
    local drop=$2

    local new_path=""
     # shellcheck disable=SC2086
    new_path=$(echo $p | sed -e "s;:${drop}:;:;g" \
                 -e "s;:${drop};;g"   \
                 -e "s;${drop}:;;g"   \
                 -e "s;${drop};;g";)
    echo "${new_path}"
}

function set_variable
{
    if test $# -ne 2 ; then
        echo "set_variable: needs 2 arguments"
        return 1
    fi

    local old_path="$1"
    local add_path="$2"

    local new_path=""
    local system_old_path=""

    if [ -z "$old_path" ]; then
        new_path=${add_path}
    else
        system_old_path=$(drop_from_path "${old_path}" "${add_path}")

        if [ -z "$system_old_path" ]; then
            new_path=${add_path}
        else
            new_path=${add_path}:${system_old_path}
        fi
    fi

    echo "${new_path}"

}

function print_env
{
    local enable="$1";shift;

    if [ "$enable" = "disable" ]; then
        printf "\n";
    else
        printf "\nSet the EPICS Environment as follows:\n";
        printf "THIS Source NAME    : %s\n" "${SRC_NAME}"
        printf "THIS Source PATH    : %s\n" "${SRC_PATH}"
        printf "EPICS_BASE          : %s\n" "${EPICS_BASE}"
        printf "EPICS_HOST_ARCH     : %s\n" "${EPICS_HOST_ARCH}"
        printf "EPICS_MODULES       : %s\n" "${EPICS_MODULES}"
        printf "PATH                : %s\n" "${PATH}"
        printf "LD_LIBRARY_PATH     : %s\n" "${LD_LIBRARY_PATH}"
        printf "\n";
        printf "Enjoy Everlasting EPICS!\n";
    fi
}

THIS_SRC=${BASH_SOURCE[0]:-${0}}

INPUT_EPICS_HOST_ARCH="$1"

# Reset all EPICS related PRE-EXIST VARIABLES
# Remove them from PATH and LD_LIBRARY_PATH
#
# If EPICS_BASE is defined,
# 1) Remove EPICS_BASE bin in the system PATH
# 2) Remove EPICS_BASE lib in the system LD_LIBRARY_PATH
# 3) Unset EPICS_BASE, EPICS_HOST_ARCH, and so on
if [ -n "$EPICS_BASE" ]; then
    printf "\n"
    echo "EPICS_BASE is defined as ${EPICS_BASE}"
    echo ""

    # Clean up all executable paths
    # EPICS Base Bin
    # PVXS Bin
    # PMAC Bin

    system_path=${PATH}
    drop_base_path="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}"
    system_path=$(drop_from_path "${system_path}" "${drop_base_path}")
    drop_pvxs_path="${EPICS_MODULES}/pvxs/bin/${EPICS_HOST_ARCH}"
    system_path=$(drop_from_path "${system_path}" "${drop_pvxs_path}")
    drop_pmac_path="${EPICS_MODULES}/pmac/bin/${EPICS_HOST_ARCH}"
    system_path=$(drop_from_path "${system_path}" "${drop_pmac_path}")
    PATH=${system_path}
    export PATH

    # Clean up all existing LIB Paths
    # 1. EPICS BASE LIB
    # 2. ALL LIBs
    # 3. EVENT LIB

#    pushdd "${EPICS_MODULES}"
#    mapfile -d $'\0' -t old_symlinks_modules < <(find . -type l -exec test -d {} \; -print0)
#    popdd

    system_ld_path=${LD_LIBRARY_PATH}
    drop_ld_path="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"
    system_ld_path=$(drop_from_path "${system_ld_path}" "${drop_ld_path}")
#    for module in "${old_symlinks_modules[@]}"; do
#        drop_module_ld_path="${EPICS_MODULES}/${module}/lib/${EPICS_HOST_ARCH}"
#        system_ld_path=$(drop_from_path "${system_ld_path}" "${drop_module_ld_path}")
#    done

    drop_event_ld_path="${EPICS_MODULES}/pvxs/bundle/usr/${EPICS_HOST_ARCH}/lib"
    system_ld_path=$(drop_from_path "${system_ld_path}" "${drop_event_ld_path}")

    LD_LIBRARY_PATH=${system_ld_path}
    export LD_LIBRARY_PATH

    # If EPICS_ENTENSIONS, it is epics_builder
    if [ -n "$EPICS_EXTENSIONS" ]; then
        ext_path=${PATH}
        drop_ext_path="${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}"

        PATH=$(drop_from_path "${ext_path}" "${drop_ext_path}")
        export PATH

        unset EPICS_EXTENSIONS
        unset EPICS_PATH
        unset EPICS_MODULES
        #unset EPICS_EXTENSIONS
        #unset EPICS_AREADETECTOR
        #unset EPICS_APPS
    fi

    unset EPICS_BASE
    unset EPICS_HOST_ARCH
    unset EPICS_MODULES
fi

if [ -L "$THIS_SRC" ]; then
    # shellcheck disable=SC2046
    SRC_PATH="$( cd -P "$( dirname $(readlink -f "$THIS_SRC") )" && pwd )"
else
    SRC_PATH="$( cd -P "$( dirname "$THIS_SRC" )" && pwd )"
fi

SRC_NAME=${THIS_SRC##*/}

## New the EPICS_PATH according to this source file
EPICS_PATH=${SRC_PATH}
## New EPICS_BASE
EPICS_BASE=${EPICS_PATH}/base
## NEW EPICS_MODULES
EPICS_MODULES=${EPICS_PATH}/modules
#EPICS_EXTENSIONS=${EPICS_PATH}/extensions
#EPICS_AREADETECTOR=${EPICS_PATH}/areaDetector
#EPICS_APPS=${EPICS_PATH}/epics-Apps

if command -v perl > /dev/null 2>&2; then
    epics_host_arch_file1="${EPICS_BASE}/startup/EpicsHostArch.pl"
    epics_host_arch_file2="${EPICS_BASE}/lib/perl/EpicsHostArch.pl"
    epics_host_arch_file3="${EPICS_BASE}/startup/EpicsHostArch"
    if [ -e "$epics_host_arch_file1" ]; then
        EPICS_HOST_ARCH=$(perl "${epics_host_arch_file1}")
    elif [ -e "$epics_host_arch_file2" ]; then
        EPICS_HOST_ARCH=$(perl "${epics_host_arch_file2}")
    elif [ -e "$epics_host_arch_file3" ]; then
        EPICS_HOST_ARCH=$(sh   "${epics_host_arch_file3}")
    elif [ -z "${INPUT_EPICS_HOST_ARCH}" ]; then
       printf ">>>> We cannot determine %s.\n" "EPICS_HOST_ARCH";
    else
       EPICS_HOST_ARCH="${INPUT_EPICS_HOST_ARCH}"
    fi
else
    if [ -z "${INPUT_EPICS_HOST_ARCH}" ]; then
       printf ">>>> We cannot determine %s.\n" "EPICS_HOST_ARCH";
    else
       EPICS_HOST_ARCH="${INPUT_EPICS_HOST_ARCH}"
    fi
fi

if [ -n "$EPICS_HOST_ARCH" ]; then
    export EPICS_PATH
    export EPICS_BASE
    export EPICS_MODULES
    #export EPICS_EXTENSIONS
    #export EPICS_AREADETECTOR
    #export EPICS_APPS
    export EPICS_HOST_ARCH

    # PATH Definition
    # Read the existing PATH, add EPICS BASE PATH to
    old_path="${PATH}"
    new_PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}"
    PATH=$(set_variable "${old_path}" "${new_PATH}")

    #ext_path="${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}"
    #PATH=$(set_variable "${PATH}" "${ext_path}")
    # we have the assumption, we run make symlinks
    pvxs_path="${EPICS_MODULES}/pvxs/bin/${EPICS_HOST_ARCH}"
    PATH=$(set_variable "${PATH}" "${pvxs_path}")
    pmac_path="${EPICS_MODULES}/pmac/bin/${EPICS_HOST_ARCH}"
    PATH=$(set_variable "${PATH}" "${pmac_path}")
    export PATH

    # Redefine Current LIB Paths
    # 1. EPICS BASE LIB
    # 2. All modules LIB
    # 3. EVENT LIB

#    pushdd "${EPICS_MODULES}"
#        mapfile -d $'\0' -t symlinks_modules < <(find . -type l -exec test -d {} \; -print0)
#    popdd
    # Check if any symlinks were found
#    if [[ ${#symlinks_modules[@]} -eq 0 ]]; then
#        echo "No symbolic links to directories found in $EPICS_MODULES"
#        return
#    fi

    old_ld_path=${LD_LIBRARY_PATH}
    new_LD_LIBRARY_PATH="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"
    LD_LIBRARY_PATH=$(set_variable "${old_ld_path}" "${new_LD_LIBRARY_PATH}")

#    for module in "${symlinks_modules[@]}"; do
#        module_LD_LIBRARY_PATH="${EPICS_MODULES}/${module}/lib/${EPICS_HOST_ARCH}"
#        LD_LIBRARY_PATH=$(set_variable "${LD_LIBRARY_PATH}" "${module_LD_LIBRARY_PATH}")
#    done

    event_LD_LIBRARY_PATH="${EPICS_MODULES}/pvxs/bundle/usr/${EPICS_HOST_ARCH}/lib"
    LD_LIBRARY_PATH=$(set_variable "${LD_LIBRARY_PATH}" "${event_LD_LIBRARY_PATH}")

    if [ -f "${SRC_PATH}/.libera_epics_modules_lib_path" ]; then
        # shellcheck source=/dev/null
        . "${SRC_PATH}/.libera_epics_modules_lib_path"
        old_ld_path=${LD_LIBRARY_PATH}
        new_LD_LIBRARY_PATH="${MOD_LD_LIBRARY_PATH}"
        LD_LIBRARY_PATH=$(set_variable "${old_ld_path}" "${new_LD_LIBRARY_PATH}")
    fi
    export LD_LIBRARY_PATH
    print_env "$1"
else
    printf ">>>> Please define it through an input argument\n";
    printf "For example, %s linux-arm\n" "${SRC_NAME}";
fi
