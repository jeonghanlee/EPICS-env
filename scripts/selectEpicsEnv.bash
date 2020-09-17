#!/usr/bin/env bash
#
#  Copyright (c) 2020  Jeong Han Lee
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
#   Shell   : selectEpicsEnv.bash
#   Author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    : 
#   version : 0.0.3

declare -g OS_VERSION;
declare -g OS_NAME;
declare -g DEFAULT_EPICS_TOP;
declare -g DEFAULT_EPICS_BASE_VERSION;


# Perl Regular Expression options are slightly different according to grep version
# \K[^d]+ works with grep 3, but doesn't work with grep 2. Somehow
# \K[^d].+ works with grep 2 and 3. 
#
OS_VERSION=$(grep -Po '^VERSION_ID=\K[^d].+' /etc/os-release | sed 's/\"//g')
OS_NAME=$(grep -Po '^ID=\K[^S].+' /etc/os-release | sed 's/\"//g')

DEFAULT_EPICS_TOP=${HOME};
DEFAULT_EPICS_BASE_VERSION=7.0.4.1;

EPICS_TOP="$1"; shift;
EPICS_BASE_VERSION="$1"; shift;

if [ -z "$EPICS_TOP" ]; then
    EPICS_TOP=${DEFAULT_EPICS_TOP}
fi

if [ -z "$EPICS_BASE_VERSION" ]; then
    EPICS_BASE_VERSION=${DEFAULT_EPICS_BASE_VERSION}
fi

EPICS_TARGET="${EPICS_TOP}/epics/${OS_NAME}/${OS_VERSION}/${EPICS_BASE_VERSION}"

# shellcheck disable=SC1090
source "${EPICS_TARGET}/setEpicsEnv.bash"
