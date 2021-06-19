#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1

declare -g SC_SCRIPT;
declare -g SC_TOP;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

INSTALL_LOCATION="$1";

if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/usr/local";
fi

# this script must be called where Dockerfile exists
#
pushd ${SC_TOP}/../ || exit
echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > CONFIG_SITE.local 
make -s init
make -s conf
make -s  patch
epics_path=$(make -s print-INSTALL_LOCATION_EPICS)
base_path=$(make -s print-INSTALL_LOCATION_BASE)
modules_path=$(make -s print-INSTALL_LOCATION_MODS)
epics_vers=$(make -s  print-PATH_NAME_EPICS)
symlink_epics_path="${INSTALL_LOCATION}/epics/R${epics_vers}"
make -s build
make -s install
make -s symlinks
mkdir -p ${symlink_epics_path}
pushd ${symlink_epics_path} || exit
ln -snf ${epics_path}/setEpicsEnv.bash setEpicsEnv.bash
ln -snf ${base_path} base
ln -snf ${modules_path} module
popd
popd
