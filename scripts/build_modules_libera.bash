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

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

function yes_or_no_to_go 
{
    local input="$1"; shift;
    printf  "> \n";
    printf  "> This procedure could help to install    \n"
    printf  "> the EPICS Modules Environment for Libera BLM\n"
    printf  "> \n";
    printf  "> $1\n";
    read -p ">> Do you want to continue (y/N)? " answer
    case ${answer:0:1} in
	y|Y )
	    printf ">> Modules will be installed......... ";
	    ;;
	* )
        printf ">> Stop here.\n";
	    exit;
    ;;
    esac
}

function build_module 
{
    local module="$1"; shift;
    make build."${module}"     || exit
    make install."${module}"   || exit
    make symlink."${module}"   || exit
}

epics_path=$(make -s print-INSTALL_LOCATION_EPICS)

yes_or_no_to_go "${epics_path}"

pushd "${SC_TOP}/.." || exit

make init.modules         || exit
make conf.modules         || exit
make conf.modules.libera  || exit

modules=("iocStats" "recsync" "retools" "caPutLog" "autosave" "sequencer-2-2" "sscan" "calc" "asyn")
symlinks=("iocStats" "recsync" "retools" "caPutLog" "autosave" "seq" "sscan" "calc" "asyn")
allmodules_locations=($(make -s print-MODS_INSTALL_LOCATIONS_SYMLINKS | tr '  ' '\n'))
modules_locations=()
((j=0));
for a_path in "${allmodules_locations[@]}"; do
    for a_module in "${symlinks[@]}"; do
        if test "${a_path#*$a_module}" != "$a_path"; then
#             echo "$j $a_path $a_module"             
             modules_locations[j]="$a_path"
            ((++j))
        fi
    done
done

path_prefix=$(make -s print-INSTALL_LOCATION);
ld_lib_path="MOD_LD_LIBRARY_PATH="
((k=0))
for a_sym in "${modules_locations[@]}"; do
#    echo $a_sym
    trim_sym=${a_sym/#$path_prefix}
    ld_lib_path+="/opt$trim_sym/lib/linux-arm"
    ((++k))
    if [ "$j" -ne "$k" ]; then
        ld_lib_path+=":";
    fi
done

echo $ld_lib_path > ${SC_TOP}/.libera_epics_modules_lib_path

for mod in "${modules[@]}"; do
   build_module "$mod"
done

install -m 444 ${SC_TOP}/.libera_epics_modules_lib_path -t ${epics_path}
popd || exit
