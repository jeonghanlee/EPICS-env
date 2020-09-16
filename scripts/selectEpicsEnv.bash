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
#   version : 0.0.1



declare -g OS_VERSION;
declare -g OS_NAME;

OS_VERSION=$(grep -Po '^VERSION_ID="\K[^"]*' /etc/os-release)
OS_NAME=$(grep -Po '^ID=\K[^S]+' /etc/os-release | sed 's/\"//g')

EPICS_TOP_INSTALL_PATH="$HOME/epics"
EPICS_BASE_VERSION="7.0.4.1"

# shellcheck disable=SC1090
source "${EPICS_TOP_INSTALL_PATH}/${OS_NAME}${OS_VERSION}/epics-${EPICS_BASE_VERSION}/setEpicsEnv.bash"
