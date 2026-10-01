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
#   Shell   : resetEpicsEnv.bash
#   Author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    :
#   version : 4.2.1
#

function pushdd { builtin pushd "$@" > /dev/null || exit; }
function popdd  { builtin popd  > /dev/null || exit; }

# Compare complete fields and preserve empty fields and literal path bytes.
function drop_from_path
{
    local remaining="${1-}"
    local drop="${2-}"
    local field=""
    local more=""
    local retained=""
    local new_path=""

    if [[ $# -lt 2 || $# -gt 4 ]]; then
        printf '%s\n' 'drop_from_path: needs a path and removal fields' >&2
        return 1
    fi
    while :; do
        case "${remaining}" in
            *:*) field="${remaining%%:*}"; remaining="${remaining#*:}"; more=x ;;
            *) field="${remaining}"; more="" ;;
        esac
        if [[ -z "${drop}" || -z "${field}" || ":${drop}:" != *":${field}:"* ]]; then
            [[ -z "${retained}" ]] || new_path+=:
            new_path+="${field}"
            retained=x
        fi
        [[ -n "${more}" ]] || break
    done
    if [[ $# -ge 3 ]]; then
        printf -v "$3" '%s' "${new_path}"
        if [[ $# -eq 4 ]]; then
            printf -v "$4" '%s' "${retained}"
        fi
    else
        printf '%s' "${new_path}"
    fi
}

# Prepend a directory list once, retaining every unrelated existing field.
function set_variable
{
    local remaining="${1-}"
    local add_path="${2-}"
    local old_present="${3-x}"
    local field=""
    local more=""
    local new_path="${2-}"

    if [[ $# -lt 2 || $# -gt 4 ]]; then
        printf '%s\n' 'set_variable: needs a path and addition fields' >&2
        return 1
    fi
    if [[ -n "${old_present}" ]]; then
        while :; do
            case "${remaining}" in
                *:*) field="${remaining%%:*}"; remaining="${remaining#*:}"; more=x ;;
                *) field="${remaining}"; more="" ;;
            esac
            if [[ -z "${field}" || ":${add_path}:" != *":${field}:"* ]]; then
                new_path+=":${field}"
            fi
            [[ -n "${more}" ]] || break
        done
    fi
    if [[ $# -eq 4 ]]; then
        printf -v "$4" '%s' "${new_path}"
    else
        printf '%s' "${new_path}"
    fi
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

# Remove only paths whose identifying components are available.
function reset_epics_environment
{
    if [[ -n "${EPICS_BASE-}" ]]; then
        printf '\nEPICS_BASE is defined as %s\n\nReset ...\n' "${EPICS_BASE}"
    fi
    if [[ -n "${EPICS_HOST_ARCH-}" ]]; then
        if [[ -n "${PATH+x}" ]]; then
            if [[ -n "${EPICS_BASE-}" ]]; then
                drop_from_path "${PATH}" "${EPICS_BASE}/bin/${EPICS_HOST_ARCH}" PATH
            fi
            if [[ -n "${EPICS_MODULES-}" ]]; then
                drop_from_path "${PATH}" "${EPICS_MODULES}/pvxs/bin/${EPICS_HOST_ARCH}" PATH
                drop_from_path "${PATH}" "${EPICS_MODULES}/pmac/bin/${EPICS_HOST_ARCH}" PATH
            fi
            if [[ -n "${EPICS_EXTENSIONS-}" ]]; then
                drop_from_path "${PATH}" "${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}" PATH
            fi
            export PATH
        fi
        if [[ -n "${EPICS_BASE-}" && -n "${LD_LIBRARY_PATH+x}" ]]; then
            drop_from_path "${LD_LIBRARY_PATH}" "${EPICS_BASE}/lib/${EPICS_HOST_ARCH}" LD_LIBRARY_PATH
            export LD_LIBRARY_PATH
        fi
    fi
    unset EPICS_PATH EPICS_BASE EPICS_MODULES EPICS_HOST_ARCH EPICS_EXTENSIONS
    return 0
}

reset_epics_environment
