#!/usr/bin/env bash
#
#  Copyright (c) 2022  Jeong Han Lee
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
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.2


declare -g SC_SCRIPT;
declare -g SC_TOP;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

ENV_TOP="$SC_TOP/.."

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

function yes_or_no_to_go 
{
    local input="$1"; shift;
    printf  "> \n";
    printf  "> This procedure could help to install    \n"
    printf  "> the EPICS Base Environment for Libera BLM\n"
    printf  "> \n";
    printf  "> $1\n";
    read -p ">> Do you want to continue (y/N)? " answer
    case ${answer:0:1} in
	y|Y )
	    printf ">> Base will be installed......... ";
	    ;;
	* )
        printf ">> Stop here.\n";
	    exit;
    ;;
    esac
}

INSTALL_LOCATION="$1";

if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/srv/liberablm";
    [[ -d "${INSTALL_LOCATION}" ]] || sudo install -d -o nobody -g nogroup -m 777 "${INSTALL_LOCATION}";
fi

pushd "${SC_TOP}/.."
echo "INSTALL_LOCATION:=${INSTALL_LOCATION}"  > configure/CONFIG_SITE.local 
echo "CROSS_COMPILER_TARGET_ARCHS=linux-arm" >> configure/CONFIG_SITE.local
echo "EPICS_TS_NTP_INET=tic.lbl.gov"         >> configure/CONFIG_SITE.local    
echo "SRC_TAG_BASE:=tags/R3.15.5"             > configure/RELEASE.local
echo "SRC_VER_BASE:=3.15.5"                  >> configure/RELEASE.local
make init.base      || exit
scp configure/os/CONFIG_SITE.linux-x86_64.linux-arm       epics-base-src/configure/os/
echo "-include \$(CONFIG)/CONFIG_SITE.local"         >>  epics-base-src/configure/CONFIG_SITE
make conf.base      || exit
make conf.base.show || exit
yes_or_no_to_go;

make patch.base     || exit
make build.base     || exit
make install.base   || exit

scp -r epics-base-src/startup $(make print-INSTALL_LOCATION_BASE)/

popd
