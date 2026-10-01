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

# Resolve arguments, tree, and architecture before replacing the environment.
function set_epics_environment
{
    local fallback_arch=""
    local summary=""
    local this_src="${BASH_SOURCE[0]}"
    local source_dir=""
    local SRC_PATH=""
    local SRC_NAME="${BASH_SOURCE[0]##*/}"
    local candidate_base=""
    local candidate_modules=""
    local candidate_arch=""
    local arch_script=""
    local arch_command=perl
    local path_present="${PATH+x}"
    local ld_present="${LD_LIBRARY_PATH+x}"

    if [[ $# -gt 2 ]]; then
        printf 'Usage: source %s [<fallback_arch>] [disable]\n' "${SRC_NAME}" >&2
        return 2
    fi
    while [[ $# -gt 0 ]]; do
        case "$1" in
            disable)
                if [[ $# -ne 1 ]]; then
                    printf 'Usage: source %s [<fallback_arch>] [disable]\n' "${SRC_NAME}" >&2
                    return 2
                fi
                summary=disable
                ;;
            '')
                printf 'Usage: source %s [<fallback_arch>] [disable]\n' "${SRC_NAME}" >&2
                return 2
                ;;
            *)
                if [[ -n "${fallback_arch}" ]]; then
                    printf 'Usage: source %s [<fallback_arch>] [disable]\n' "${SRC_NAME}" >&2
                    return 2
                fi
                fallback_arch="$1"
                ;;
        esac
        shift
    done
    if [[ -L "${this_src}" ]]; then
        if ! this_src=$(readlink -f -- "${this_src}"); then
            printf '%s: cannot resolve the setup script\n' "${SRC_NAME}" >&2
            return 1
        fi
    fi
    source_dir="${this_src%/*}"
    [[ "${source_dir}" != "${this_src}" ]] || source_dir=.
    if ! SRC_PATH=$(cd -P -- "${source_dir}" && pwd -P); then
        printf '%s: cannot resolve the installed tree\n' "${SRC_NAME}" >&2
        return 1
    fi
    candidate_base="${SRC_PATH}/base"
    candidate_modules="${SRC_PATH}/modules"
    if command -v perl >/dev/null 2>&1; then
        if [[ -e "${candidate_base}/startup/EpicsHostArch.pl" ]]; then
            arch_script="${candidate_base}/startup/EpicsHostArch.pl"
        elif [[ -e "${candidate_base}/lib/perl/EpicsHostArch.pl" ]]; then
            arch_script="${candidate_base}/lib/perl/EpicsHostArch.pl"
        elif [[ -e "${candidate_base}/startup/EpicsHostArch" ]]; then
            arch_script="${candidate_base}/startup/EpicsHostArch"
            arch_command="sh"
        fi
    fi
    if [[ -n "${arch_script}" ]]; then
        if ! candidate_arch=$("${arch_command}" "${arch_script}"); then
            printf '%s: cannot determine EPICS_HOST_ARCH from %s\n' "${SRC_NAME}" "${arch_script}" >&2
            return 1
        fi
    else
        candidate_arch="${fallback_arch}"
    fi
    if [[ -z "${candidate_arch}" ]]; then
        printf '%s: cannot determine EPICS_HOST_ARCH; supply <fallback_arch>\n' "${SRC_NAME}" >&2
        return 1
    fi

    if [[ -n "${EPICS_BASE-}" ]]; then
        printf '\nEPICS_BASE is defined as %s\n\n' "${EPICS_BASE}"
    fi
    if [[ -n "${EPICS_HOST_ARCH-}" ]]; then
        if [[ -n "${path_present}" ]]; then
            if [[ -n "${EPICS_BASE-}" ]]; then
                drop_from_path "${PATH}" "${EPICS_BASE}/bin/${EPICS_HOST_ARCH}" PATH path_present
            fi
            if [[ -n "${EPICS_MODULES-}" && -n "${path_present}" ]]; then
                drop_from_path "${PATH}" "${EPICS_MODULES}/pvxs/bin/${EPICS_HOST_ARCH}" PATH path_present
                if [[ -n "${path_present}" ]]; then
                    drop_from_path "${PATH}" "${EPICS_MODULES}/pmac/bin/${EPICS_HOST_ARCH}" PATH path_present
                fi
            fi
            if [[ -n "${EPICS_EXTENSIONS-}" && -n "${path_present}" ]]; then
                drop_from_path "${PATH}" "${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}" PATH path_present
            fi
        fi
        if [[ -n "${EPICS_BASE-}" && -n "${ld_present}" ]]; then
            drop_from_path "${LD_LIBRARY_PATH}" "${EPICS_BASE}/lib/${EPICS_HOST_ARCH}" LD_LIBRARY_PATH ld_present
        fi
    fi
    if [[ -n "${EPICS_EXTENSIONS-}" ]]; then
        unset EPICS_EXTENSIONS
    fi
    EPICS_PATH="${SRC_PATH}"
    EPICS_BASE="${candidate_base}"
    EPICS_MODULES="${candidate_modules}"
    EPICS_HOST_ARCH="${candidate_arch}"
    export EPICS_PATH EPICS_BASE EPICS_MODULES EPICS_HOST_ARCH

    set_variable "${PATH-}" "${EPICS_BASE}/bin/${EPICS_HOST_ARCH}" "${path_present}" PATH
    set_variable "${PATH}" "${EPICS_MODULES}/pvxs/bin/${EPICS_HOST_ARCH}" x PATH
    set_variable "${PATH}" "${EPICS_MODULES}/pmac/bin/${EPICS_HOST_ARCH}" x PATH
    export PATH
    set_variable "${LD_LIBRARY_PATH-}" "${EPICS_BASE}/lib/${EPICS_HOST_ARCH}" "${ld_present}" LD_LIBRARY_PATH
    if [[ -f "${SRC_PATH}/.libera_epics_modules_lib_path" ]]; then
        # shellcheck source=/dev/null
        . "${SRC_PATH}/.libera_epics_modules_lib_path"
        if [[ -n "${MOD_LD_LIBRARY_PATH-}" ]]; then
            set_variable "${LD_LIBRARY_PATH}" "${MOD_LD_LIBRARY_PATH}" x LD_LIBRARY_PATH
        fi
    fi
    export LD_LIBRARY_PATH
    print_env "${summary}"
    return 0
}

set_epics_environment "$@"
