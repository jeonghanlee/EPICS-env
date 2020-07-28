#!/bin/bash
#  Copyright (c) 2017 - 2019  Jeong Han Lee
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
#   date    : Monday, September 16 14:52:59 CEST 2019
#
#   version : 1.2.1


# the following function drop_from_path was copied from
# the ROOT build system in ${ROOTSYS}/bin/, and modified
# a little to return its result
# Wednesday, July 11 23:19:00 CEST 2018, jhlee 
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

    local new_path=`echo $p | sed -e "s;:${drop}:;:;g" \
                 -e "s;:${drop};;g"   \
                 -e "s;${drop}:;;g"   \
                 -e "s;${drop};;g";`
    echo ${new_path}
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
	system_old_path=$(drop_from_path ${old_path} ${add_path})
	if [ -z "$system_old_path" ]; then
	    new_path=${add_path}
	else
	    new_path=${add_path}:${system_old_path}
	fi
   
    fi

    echo "${new_path}"
    
}



# Reset all EPICS, E3, and EEE related PRE-EXIST VARIABLES
# Remove them from PATH and LD_LIBRARY_PATH
# 
# If EPICS_BASE is defined,
# 1) Remove EPICS_BASE bin in the system PATH
# 2) Remove EPICS_BASE lib in the system LD_LIBRARY_PATH
# 3) Unset EPICS_BASE, EPICS_HOST_ARCH, and so on
if [ -n "$EPICS_BASE" ]; then
    
    system_path=${PATH}
    drop_base_path="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}"
    
    PATH=$(drop_from_path "${system_path}" "${drop_base_path}")
    export PATH
    
    system_ld_path=${LD_LIBRARY_PATH}
    drop_ld_path="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"
    
    LD_LIBRARY_PATH=$(drop_from_path "${system_ld_path}" "${drop_ld_path}")
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
	unset EPICS_EXTENSIONS
	unset EPICS_AREADETECTOR
	unset EPICS_APPS
    fi

    # If E3_REQUIRE_NAME, it is E3
    if [ -n "$E3_REQUIRE_NAME" ]; then

	e3_path=${PATH}
	
	PATH=$(drop_from_path "${e3_path}" "${E3_REQUIRE_BIN}")
	export PATH
	
	e3_ld_path=${LD_LIBRARY_PATH}
	drop_e3_ld_path1="${E3_REQUIRE_LIB}/${EPICS_HOST_ARCH}"
	drop_e3_ld_path2="${E3_SITELIBS_PATH}/${EPICS_HOST_ARCH}"
	e3_ld_path_0=$(drop_from_path "${e3_ld_path}" "${drop_e3_ld_path1}")
	
	LD_LIBRARY_PATH=$(drop_from_path "${e3_ld_path_0}" "${drop_e3_ld_path2}")
	export LD_LIBRARY_PATH
	
	unset E3_REQUIRE_NAME
	unset E3_REQUIRE_VERSION
	unset E3_REQUIRE_LOCATION
	
	unset E3_REQUIRE_BIN
	unset E3_REQUIRE_LIB
	unset E3_REQUIRE_INC
	unset E3_REQUIRE_DB
	
	unset E3_SITEMODS_PATH
	unset E3_SITELIBS_PATH
	unset E3_SITEAPPS_PATH
        
	unset EPICS_DRIVER_PATH
	unset SCRIPT_DIR
	
    fi
    
    # If EPICS_ENV_PATH, it is EEE
    if [ -n "$EPICS_ENV_PATH" ]; then

	eee_path=${PATH}
	PATH=$(drop_from_path "${eee_path}" "${EPICS_ENV_PATH}")
	export PATH

	eee_pvaccess_path=${PATH}
	drop_eee_pvaccess_path="${EPICS_MODULES_PATH}/pvAccessCPP/5.0.0/${BASE}/bin/${EPICS_HOST_ARCH}"
	
	PATH=$(drop_from_path "${eee_pvaccess_path}" "${drop_eee_pvaccess_path}")
	export PATH
	
	unset EPICS_BASES_PATH
	unset EPICS_MODULES_PATH
	unset BASE
	unset EPICS_ENV_PATH
	unset PYTHONPATH
    fi
    
    unset EPICS_BASE
    unset EPICS_HOST_ARCH
    
fi



THIS_SRC=${BASH_SOURCE[0]}
SRC_PATH="$( cd -P "$( dirname "$THIS_SRC" )" && pwd )"
SRC_NAME=${THIS_SRC##*/}
REAL_SRC_PATH="/builder/tools"


if [[ $SRC_PATH == *${REAL_SRC_PATH}* ]]; then
    
    printf "\nPlease do not source %s directly\n" "${SRC_NAME}"
    printf "Your attempt is forwarding to .... %s\n"  ${SRC_PATH}/../../;
    sleep 5
    cd  ${SRC_PATH}/../../
    source ${SRC_NAME}

else

    EPICS_PATH=${SRC_PATH}
    EPICS_BASE=${EPICS_PATH}/epics-base
    EPICS_MODULES=${EPICS_PATH}/epics-modules
    EPICS_EXTENSIONS=${EPICS_PATH}/extensions
    EPICS_AREADETECTOR=${EPICS_PATH}/areaDetector
    EPICS_APPS=${EPICS_PATH}/epics-Apps
    
    epics_host_arch_file="${EPICS_BASE}/startup/EpicsHostArch.pl"
    if [ -e "$epics_host_arch_file" ]; then
	EPICS_HOST_ARCH=$("${EPICS_BASE}/startup/EpicsHostArch.pl")
    else
	EPICS_HOST_ARCH=$(perl ${EPICS_BASE}/lib/perl/EpicsHostArch.pl)
    fi
  
    export EPICS_PATH
    export EPICS_BASE
    export EPICS_MODULES
    export EPICS_EXTENSIONS
    export EPICS_AREADETECTOR
    export EPICS_APPS
    export EPICS_HOST_ARCH

    old_path=${PATH}
    new_PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}"
    PATH=$(set_variable "${old_path}" "${new_PATH}")

    ext_path="${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}"
    PATH=$(set_variable "${PATH}" "${ext_path}")
    export PATH

    old_ld_path=${LD_LIBRARY_PATH}
    new_LD_LIBRARY_PATH="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}"

    LD_LIBRARY_PATH=$(set_variable "${old_ld_path}" "${new_LD_LIBRARY_PATH}")

    export LD_LIBRARY_PATH

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
