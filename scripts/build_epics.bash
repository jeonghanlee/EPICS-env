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
pushd ${PWD} || exit
git clone https://github.com/jeonghanlee/EPICS-env
echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > CONFIG_SITE.local 
make -s -C EPICS-env/ init
make -s -C EPICS-env/ conf
make -s -C EPICS-env/ patch
epics_path=$(make -s -C EPICS-env/ print-INSTALL_LOCATION_EPICS)
base_path=$(make -s -C EPICS-env/ print-INSTALL_LOCATION_BASE)
modules_path=$(make -s -C EPICS-env/ print-INSTALL_LOCATION_MODS)
epics_vers=$(make -s -C EPICS-env/ print-PATH_NAME_EPICS)
symlink_epics_path="${INSTALL_LOCATION}/epics/R${epics_vers}"
make -s -C EPICS-env/ build
make -s -C EPICS-env/ install
make -s -C EPICS-env/ symlinks.modules
mkdir -p ${symlink_epics_path}
pushd ${symlink_epics_path} || exit
ln -snf ${epics_path}/setEpicsEnv.bash setEpicsEnv.bash
ln -snf ${base_path} base
ln -snf ${modules_path} module
popd
popd
