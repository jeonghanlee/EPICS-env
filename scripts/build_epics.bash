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

pushd "${SC_TOP}/.." || exit
echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > configure/CONFIG_SITE.local 
make -s init || exit
make -s patch || exit
make -s conf || exit
epics_path=$(make -s print-INSTALL_LOCATION_EPICS)
base_path=$(make -s print-INSTALL_LOCATION_BASE)
modules_path=$(make -s print-INSTALL_LOCATION_MODS)
epics_vers=$(make -s  print-PATH_NAME_EPICSVERS)
symlink_epics_path="${INSTALL_LOCATION}/epics/R${epics_vers}"
make -s build || exit
make -s install || exit
make -s symlinks || exit
mkdir -p "${symlink_epics_path}"
pushd "${symlink_epics_path}" || exit
cp -f "${epics_path}/setEpicsEnv.bash" .
ln -snf "${base_path}" base
ln -snf "${modules_path}" modules
popd || exit
popd || exit

git clone https://github.com/ronpandolfi/EPICS-env-support
echo "INSTALL_LOCATION=${base_path}" > EPICS-env-support/configure/CONFIG_SITE.local
make -s -C EPICS-env-support/ init || exit
make -s -C EPICS-env-support/ conf || exit
make -s -C EPICS-env-support/ build || exit
make -s -C EPICS-env-support/ symlinks || exit

