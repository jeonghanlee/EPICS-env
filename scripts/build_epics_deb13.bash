#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1

declare -g SC_SCRIPT;
declare -g SC_TOP;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushdd { builtin pushd "$@" > /dev/null || exit; }
function popdd  { builtin popd  > /dev/null || exit; }

INSTALL_LOCATION="$1";

if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/usr/local";
fi

pushdd "${SC_TOP}/.." || exit
echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > configure/CONFIG_SITE.local
make -s init || exit
rm -rf pyDevSup-src || exit
git clone https://github.com/jeonghanlee/pyDevSup pyDevSup-src || exit
echo "SRC_TAG_PYDEVSUP:=796f7d7"  > configure/RELEASE.local
echo "SRC_VER_PYDEVSUP:=796f7d7" >> configure/RELEASE.local
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
pushdd "${symlink_epics_path}" || exit
cp -f "${epics_path}/setEpicsEnv.bash" .
ln -snf "${base_path}" base
ln -snf "${modules_path}" modules
popdd || exit
popdd || exit
