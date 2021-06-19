#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1

INSTALL_LOCATION="$1";

if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/usr/local";
fi

# this script must be called where Dockerfile exists
#

mkdir -p "${INSTALL_LOCATION}/apps";

wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.35.0/pmd-bin-6.35.0.zip
unzip pmd-bin-6.35.0.zip
mv pmd-bin-6.35.0 "${INSTALL_LOCATION}/apps/pmd"

