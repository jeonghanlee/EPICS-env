#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Prepare the run directory of the opcua-server-sim loader fixture. The
# simulator and open62541-env are checked out at the recorded revisions, open62541
# and the server are built by the simulator's own targets, the server
# certificate is created, and the client certificate, the PKI store and the
# identity file that the simulator's IOC startup reads are written, as
# scripts/run-ioc.bash of the simulator does. Nothing of the IOC is compiled.
#
#   prepare.bash [--simulator-source DIR] [--environment-source DIR] RUN_DIR
#
# Run directory layout:
#   RUN_DIR/simulator/src            opcua-server-sim at SIMULATOR_REVISION
#   RUN_DIR/open62541-env/src        open62541-env at ENVIRONMENT_REVISION
#   RUN_DIR/open62541-1.5.10         install prefix of open62541
#   RUN_DIR/secure                   PKI store, client key and certificate, ident.txt
#
# The tools are listed in README.md. With --simulator-source or
# --environment-source, an existing unmodified checkout at the recorded
# revision is linked instead of a new clone. Prints the two revisions and
# OPCUA_SIM_RUN=<canonical run directory>.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly SIMULATOR_URL="https://github.com/jeonghanlee/opcua-server-sim"
readonly SIMULATOR_REVISION="899bc67c798effe35c2e02e7540c96c4e05b1620"
readonly ENVIRONMENT_URL="https://github.com/jeonghanlee/open62541-env"
readonly ENVIRONMENT_REVISION="fc8cc33897c84dca699a3e1a7d998ce3e2748dfe"
readonly CHECKOUT_TOOL="../checkout_application.bash"
readonly OPEN62541_PREFIX="open62541-1.5.10"
readonly MODEL="models/s7-1500-composite"
readonly REQUIRED_COMMANDS="git make cmake cc c++ python3 pkg-config openssl"
readonly REQUIRED_MODULES="libxml-2.0 openssl"

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit 1
}

function require_tools {
    local name=""
    local module=""

    for name in ${REQUIRED_COMMANDS}; do
        command -v "${name}" > /dev/null || die "Cannot find required command: ${name}"
    done
    for module in ${REQUIRED_MODULES}; do
        pkg-config --exists "${module}" || die "Cannot find the development files of ${module} (pkg-config ${module})"
    done
}

function main {
    local fixture_dir="${BASH_SOURCE[0]%/*}"
    local simulator_source=()
    local environment_source=()
    local run_dir=""
    local simulator_dir=""
    local environment_dir=""
    local simulator=""
    local environment=""
    local prefix=""
    local secure=""
    local user=""
    local password=""
    local host=""

    [[ "${BASH_SOURCE[0]}" == */* ]] || fixture_dir="."
    while (($# > 0)); do
        case "$1" in
            -h | --help)
                printf 'Usage: %s [--simulator-source DIR] [--environment-source DIR] RUN_DIR\n' "${SCRIPT_NAME}"
                return 0
                ;;
            --simulator-source)
                [[ $# -ge 2 && -n "$2" ]] || die "Missing directory for $1"
                simulator_source=(--source "$2")
                shift 2
                ;;
            --environment-source)
                [[ $# -ge 2 && -n "$2" ]] || die "Missing directory for $1"
                environment_source=(--source "$2")
                shift 2
                ;;
            -*) die "Unknown option: $1" ;;
            *) break ;;
        esac
    done
    [[ $# -eq 1 ]] || die "Specify one run directory"
    require_tools

    mkdir -p -- "$1/simulator" "$1/open62541-env"
    run_dir=$(readlink -e -- "$1") || die "Cannot resolve the run directory: $1"
    simulator_dir=$(bash "${fixture_dir}/${CHECKOUT_TOOL}" --url "${SIMULATOR_URL}" --revision "${SIMULATOR_REVISION}" \
        "${simulator_source[@]}" "${run_dir}/simulator")
    environment_dir=$(bash "${fixture_dir}/${CHECKOUT_TOOL}" --url "${ENVIRONMENT_URL}" --revision "${ENVIRONMENT_REVISION}" \
        "${environment_source[@]}" "${run_dir}/open62541-env")
    simulator="${simulator_dir}/src"
    environment="${environment_dir}/src"
    prefix="${run_dir}/${OPEN62541_PREFIX}"

    make -C "${simulator}" open62541 OPEN62541_ENV_PATH="${environment}" OPEN62541_PATH="${prefix}"
    make -C "${simulator}" build certificate OPEN62541_ENV_PATH="${environment}" OPEN62541_PATH="${prefix}"
    [[ -x "${simulator}/build/opcua-server-sim" ]] || die "The server was not built: ${simulator}/build/opcua-server-sim"
    [[ -s "${simulator}/${MODEL}/pki/server-cert.der" ]] || die "The server certificate was not created"

    read -r _ user password < <(grep -m 1 '^user[[:blank:]]' "${simulator}/${MODEL}/simulation.conf") ||
        die "The demo user is missing from the simulation file"
    secure="${run_dir}/secure"
    umask 077
    mkdir -p -- "${secure}/pki/trusted/certs" "${secure}/pki/issuers/certs"
    cp -- "${simulator}/${MODEL}/pki/server-cert.der" "${secure}/pki/trusted/certs/"
    host="${HOSTNAME:-$(uname -n)}"
    openssl req -x509 -newkey rsa:2048 -nodes -subj /O=ioc -keyout "${secure}/key.pem" -out "${secure}/cert.pem" \
        -addext "subjectAltName=URI:urn:ioc@${host}:EPICS:IOC" 2> /dev/null
    printf 'user=%s\npass=%s\n' "${user}" "${password}" > "${secure}/ident.txt"
    [[ -s "${secure}/cert.pem" && -s "${secure}/key.pem" ]] || die "openssl could not create the client certificate"

    printf 'simulator=%s\nopen62541-env=%s\n' "$(git -C "${simulator}" rev-parse HEAD)" "$(git -C "${environment}" rev-parse HEAD)"
    printf 'OPCUA_SIM_RUN=%s\n' "${run_dir}"
}

main "$@"
