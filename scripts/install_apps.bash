#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.3

declare -g SC_SCRIPT;
declare -g SC_TOP;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

function rocky_dist
{
    local VERSION_ID
    # shellcheck disable=SC2002
    # shellcheck disable=SC2046
    # shellcheck disable=SC2022
    eval $(cat /etc/os-release | grep -E "^(VERSION_ID)=")
    # shellcheck disable=SC2086
    echo ${VERSION_ID}
}


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
wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F7.22.0/pmd-dist-7.22.0-bin.zip
unzip pmd-dist-7.22.0-bin.zip
mv pmd-bin-7.22.0 "${APPS_PATH}/pmd"
ADD_BIN="${APPS_PATH}/pmd/bin"
ADD_LIB="${APPS_PATH}/pmd/lib"

OS_NAME=$(grep -Po '^ID=\K[^S].+' /etc/os-release | sed 's/\"//g')



if [[ "${OS_NAME}" == "rocky" ]]; then
    SPLINT_PATH="${APPS_PATH}/splint"
    rocky_version=$(rocky_dist)

    if [[ "$rocky_version" =~ .*"8.".* ]]; then
        dnf install -y wget
        wget -c https://www.splint.org/downloads/splint-3.1.2.src.tgz
        tar xvf splint-3.1.2.src.tgz
        pushd splint-3.1.2 || exit
    elif [[ "$rocky_version" =~ .*"9.".* ]]; then
        git clone https://github.com/jeonghanlee/splint splint
        pushd splint || exit
        autoreconf -i -v -f || exit
    elif [[ "$rocky_version" =~ .*"10.".* ]]; then
        git clone https://github.com/jeonghanlee/splint splint
        pushd splint || exit
        autoreconf -i -v -f || exit
    else
        printf "\n";
        printf "Doesn't support %s\n" "$rocky_version";
        printf "\n";
    fi

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

    SHELLCHECK_PATH="${APPS_PATH}/shellcheck"
    wget https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz
    mkdir -p "${SHELLCHECK_PATH}"
    tar -xvf shellcheck-stable.linux.x86_64.tar.xz -C "${SHELLCHECK_PATH}" --strip-components=1
    ADD_BIN+=":"
    ADD_BIN+="${SHELLCHECK_PATH}"
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

