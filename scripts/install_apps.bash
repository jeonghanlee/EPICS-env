#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.2

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

## Assumption : build_epics.bash was called before!
##
pushd "${SC_TOP}/.." || exit
epics_vers=$(make -s  print-PATH_NAME_EPICSVERS)
symlink_epics_path="${INSTALL_LOCATION}/epics/R${epics_vers}"
popd || exit


APPS_PATH="${INSTALL_LOCATION}/apps";

mkdir -p "${APPS_PATH}";

wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.35.0/pmd-bin-6.35.0.zip
unzip pmd-bin-6.35.0.zip
mv pmd-bin-6.35.0 "${APPS_PATH}/pmd"
ADD_BIN="${APPS_PATH}/pmd/bin"
ADD_LIB="${APPS_PATH}/pmd/lib"

OS_NAME=$(grep -Po '^ID=\K[^S].+' /etc/os-release | sed 's/\"//g')

if [[ "${OS_NAME}" == "rocky" ]]; then
    SPLINT_PATH="${APPS_PATH}/splint"
    # Move flex to pkg_automation
    # dnf install -y flex-devel 
    git clone https://github.com/splintchecker/splint.git splint
    pushd splint || exit
    # 2021-03-27
    git checkout 2635a52
    autoreconf -i -v -f || exit
    ./configure --prefix="${SPLINT_PATH}" || exit
    # bin
    # share/lib
    # share/{man,splint/{lib,imports}
    # we don't need to set LD path for the splint
    make || exit
    make install || exit
    popd || exit
    ADD_BIN+=":"
    ADD_BIN+="${SPLINT_PATH}/bin"
fi

cat > "${INSTALL_LOCATION}/setEnv" <<EOF
# source ${INSTALL_LOCATION}/setEnv 
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

source ${symlink_epics_path}/setEpicsEnv.bash

# User specific environment and startup programs

PATH=\${PATH}:\${HOME}/bin:${ADD_BIN}
LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${ADD_LIB}

export PATH
export LD_LIBRARY_PATH
EOF

