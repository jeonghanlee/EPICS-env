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
#   version : 0.0.2

declare -g OS_VERSION;
declare -g OS_NAME;
declare -g DEFAULT_EPICS_TOP;
declare -g DEFAULT_EPICS_BASE_VERSION;

OS_VERSION=$(grep -Po '^VERSION_ID=\K[^d].+' /etc/os-release | sed 's/\"//g')
OS_NAME=$(grep -Po '^ID=\K[^S].+' /etc/os-release | sed 's/\"//g')


DEFAULT_EPICS_TOP=${HOME};
DEFAULT_EPICS_BASE_VERSION=7.0.4.1;

EPICS_TOP=
EPICS_BASE_VERSION=

function usage
{
    {
        echo "";
        echo "Usage    : $0 options";
        echo "";
        echo "              possbile options";
        echo "";
        echo "              [-t <default epics top path>] [-b <base_version>]";
        echo "";
        echo "               -t : default ${DEFAULT_EPICS_TOP}";
        echo "               -b : default ${DEFAULT_BASE_VERSION}";
        echo "";
        echo " bash $0 -t \${HOME} -b ${DEFAULT_EPICS_BASE_VERSION}";
        echo ""
    } 1>&2;
    exit 1;
}


options="t:b:h"

while getopts "${options}" opt; do
    case "${opt}" in
        t) 
            EPICS_TOP=${OPTARG}
            ;;
        b) 
            EPICS_BASE_VERSION=${OPTARG}
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage;
        ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$EPICS_TOP" ]; then
    EPICS_TOP=${DEFAULT_EPICS_TOP}
fi

if [ -z "$EPICS_BASE_VERSION" ]; then
    EPICS_BASE_VERSION=${DEFAULT_EPICS_BASE_VERSION}
fi

EPICS_TARGET="${EPICS_TOP}/epics/${OS_NAME}/${OS_VERSION}/${EPICS_BASE_VERSION}"

# shellcheck disable=SC1090
source "${EPICS_TARGET}/setEpicsEnv.bash"
