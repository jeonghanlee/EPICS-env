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

#THIS_SRC=${BASH_SOURCE[0]:-${0}}

#INPUT_EPICS_HOST_ARCH="$1"

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
    echo "Reset ..."
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

    pushdd "${EPICS_MODULES}"
    mapfile -d $'\0' -t old_symlinks_modules < <(find . -type l -exec test -d {} \; -print0)
    popdd

    system_ld_path=${LD_LIBRARY_PATH}
    drop_ld_path="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"
    system_ld_path=$(drop_from_path "${system_ld_path}" "${drop_ld_path}")
    for module in "${old_symlinks_modules[@]}"; do
        drop_module_ld_path="${EPICS_MODULES}/${module}/lib/${EPICS_HOST_ARCH}"
        system_ld_path=$(drop_from_path "${system_ld_path}" "${drop_module_ld_path}")
    done

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

