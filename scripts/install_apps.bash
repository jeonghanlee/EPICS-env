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

## Assumption : build_epics.bash was called before!
##
pushd "${SC_TOP}/.." || exit
epics_path=$(make -s print-INSTALL_LOCATION_EPICS)
popd || exit


APPS_PATH="${INSTALL_LOCATION}/apps";

mkdir -p "${APPS_PATH}";

wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.35.0/pmd-bin-6.35.0.zip
unzip pmd-bin-6.35.0.zip
mv pmd-bin-6.35.0 "${APPS_PATH}/pmd"
PMD_BIN="${APPS_PATH}/pmd/bin"
PMD_LIB="${APPS_PATH}/pmd/lib"


#SPLINT:="${APPS_PATH}/splint"
#git clone https://github.com/splintchecker/splint.git splint

#pushd splint || exit
#
#git checkout tags/splint-3_1_2
#autoconf -i -v -f
#./configure --prefix=${SPLINT}"
# make
# make install
#popd



cat > "${APPS_PATH}/bash_profile" <<EOF
# .bash_profile
#
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi    

source ${epics_path}/setEpicsEnv.bash

# User specific environment and startup programs

PATH=\${PATH}:\${HOME}/bin:${PMD_BIN}
LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${PMD_LIB}

export PATH
export LD_LIBRARY_PATH
EOF

