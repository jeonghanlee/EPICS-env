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

function build_module 
{
    local module="$1"; shift;
    make build."${module}"  || exit
    make install."${module}"  || exit
    make symlink."${module}" || exit
}

INSTALL_LOCATION="$1";

if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/usr/local";
fi

pushd "${SC_TOP}/.." || exit
echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > configure/CONFIG_SITE.local 
make init.base || exit
scp configure/os/CONFIG_SITE.linux-x86_64.linux-arm epics-base-src/configure/os/
make conf.base  || exit
make conf.base.show  || exit
make patch.base  || exit
make build.base   || exit
make install.base  || exit

make init.modules  || exit
make conf.modules   || exit
make conf.modules.libera  || exit

modules=("iocStats" "recsync" "retools" "caPutLog" "autosave" "sequencer-2-2" "sscan" "calc" "asyn")

for mod in "${modules[@]}"; do
    build_module "$mod";
done

popd || exit
