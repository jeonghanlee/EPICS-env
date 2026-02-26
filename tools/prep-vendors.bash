#!/usr/bin/env bash
#
#  Copyright (c) 2025 -         Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1
#

declare -g SC_RPATH;
#declare -g SC_NAME;
declare -g SC_TOP;

SC_RPATH="$(realpath "$0")";
#SC_NAME=${0##*/};
SC_TOP="${SC_RPATH%/*}"

declare -g GIT_BASE_SSH="git@github.com:"
declare -g GIT_BASE_HTTPS="https://github.com/"
declare -g GIT_OWNER="jeonghanlee"

# Enable core dumps in case the JVM fails
ulimit -c unlimited

# Function: pushdd
# Description: Wrapper for 'pushd' that changes the current directory and
#              suppresses the command's output.
function pushdd { builtin pushd "$@" > /dev/null || exit; }
# Function: popdd
# Description: Wrapper for 'popd' that returns to the previous directory and
#              suppresses the command's output.
function popdd  { builtin popd  > /dev/null || exit; }

declare -g OS_NAME;
declare -g OS_VERSION;
declare -g INSTALL_LOCAITON_EPICS;
declare -g INSTALL_LOCATION_VER;
declare -g EPICS_BASE_PATH;
declare -g VENDOR_LIB_PATH;

declare -g VENDOR_WORKING_FOLDER=${HOME}/.vendor_temp_folder
declare -g EPICS_ENV_PATH=${SC_TOP}/..
declare -g VENDOR_ULDAQ_SRC=${VENDOR_WORKING_FOLDER}/uldaq-env
declare -g VENDOR_OPEN62451_SRC=${VENDOR_WORKING_FOLDER}/open62541-env

# Function: is_redhat_variant
# Description: Checks if the current operating system is a Red Hat variant
#              (Rocky, RHEL, CentOS, or Fedora) and sets global variables.
# Returns: 0 if a variant is detected, 1 otherwise.
function is_redhat_variant
{
  if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      "rocky"|"rhel"|"centos"|"fedora")
        return 0
        ;;
      *)
        return 1
        ;;
    esac
  else
    return 1
  fi
}

# Function: _setup_working_path
# Description: Creates and cleans the main working directory to ensure a fresh
#              environment for the build process.
function _setup_working_path
{
    echo "--- Setting up working path at ${VENDOR_WORKING_FOLDER} ---"
    mkdir -p "${VENDOR_WORKING_FOLDER}"
    pushdd "${VENDOR_WORKING_FOLDER}"
    # Use a safer way to clean the directory
    find . -maxdepth 1 -mindepth 1 -exec rm -rf {} +
    popdd
}

function _clone_with_fallback
{
    local repo_name="$1"
    local ssh_url="${GIT_BASE_SSH}${GIT_OWNER}/${repo_name}.git"
    local https_url="${GIT_BASE_HTTPS}${GIT_OWNER}/${repo_name}.git"
    local separator="----------------------------------------"

    printf "%s\n" "${separator}"
    printf "Attempting to clone via SSH : %s\n" "${ssh_url}"

    if ! git clone "${ssh_url}"; then
        printf "%s\n" "${separator}"
        printf "SSH clone failed. Falling back to HTTPS : %s\n" "${https_url}"
        git clone "${https_url}" || exit
    fi
}

function _git_clone_repos
{
    local separator="--- Cloning repositories ---"
    printf "%s\n" "${separator}"

    pushdd "${VENDOR_WORKING_FOLDER}"

    _clone_with_fallback "uldaq-env"
    _clone_with_fallback "open62541-env"

    popdd
}


# Function: _prep_env
# Description: Checks out a specific version of the main EPICS environment and
#              writes the local installation path to its configuration file.
function _prep_env
{
    pushdd "${EPICS_ENV_PATH}"
    INSTALL_LOCATION=$(make print-INSTALL_LOCATION)
    echo "INSTALL_LOCATION=${INSTALL_LOCATION}" > configure/CONFIG_SITE.local
    popdd
}


# Function: initial_setup
# Description: Performs the initial setup by creating the working folder,
#              cloning all repositories, and preparing the main EPICS environment
#              for a specified version.
function initial_setup
{
    echo "--- Preparing environment ---"
    _setup_working_path
    _git_clone_repos
    _prep_env
}

# Function: _fill_env
# Description: Fills global environment variables by running `make` commands
#              within the main EPICS environment to retrieve paths and OS information.
function _fill_env
{
    pushdd "${EPICS_ENV_PATH}"
    OS_NAME=$(make print-OS_NAME)
    OS_VERSION=$(make print-OS_VERSION)
    INSTALL_LOCATION_EPICS=$(make print-INSTALL_LOCATION_EPICS)
    INSTALL_LOCATION_VER=$(make print-INSTALL_LOCATION_VER)
    EPICS_BASE_PATH=${INSTALL_LOCATION_EPICS}/base
    VENDOR_LIB_PATH=${INSTALL_LOCATION_EPICS}/vendor
    popdd
}

# Function: _echo_env
# Description: Prints the values of all relevant global variables after the environment is set up.
function _echo_env
{
    echo "--- Environment Variables ---"
    echo "OS_NAME: ${OS_NAME}"
    echo "OS_VERSION: ${OS_VERSION}"
    echo "INSTALL_LOCAITON_EPICS: ${INSTALL_LOCATION_EPICS}"
    echo "INSTALL_LOCATION_VER: ${INSTALL_LOCATION_VER}"
    echo "EPICS_BASE_PATH: ${EPICS_BASE_PATH}"
    echo "VENDOR_LIB_PATH: ${VENDOR_LIB_PATH}"
    echo "VENDOR_WORKING_FOLDER: ${VENDOR_WORKING_FOLDER}"
    echo "EPICS_ENV_PATH: ${EPICS_ENV_PATH}"
    echo "VENDOR_ULDAQ_SRC: ${VENDOR_ULDAQ_SRC}"
    echo "VENDOR_OPEN62451_SRC: ${VENDOR_OPEN62451_SRC}"
}
# Function: _prep_vendor
# Description: A generic function that prepares a vendor library by checking out
#              its version, setting the installation path, and running the necessary
#              'make' commands to clean, configure, build, and install it.
function _prep_vendor()
{
    _fill_env;
    local folder="$1"; shift;
    local name="${folder##*/}"
    echo "--- Preparing vendor library: ${name} ---"
    pushdd "$folder"
    echo "INSTALL_LOCATION=${VENDOR_LIB_PATH}" > configure/CONFIG_SITE.local
    make distclean || exit
    make init    || exit
   	if is_redhat_variant; then
        echo "Error: This system is an ugly Red Hat variant."
        make conf.rocky8 || exit;
    else
        echo "Whoray! This system is not a Red Hat variant."
        make conf || exit;
    fi
    make build   || exit
    make install || exit
    popdd
}

# Function: prep_uldaq
# Description: Prepares the 'uldaq' vendor library by calling the generic
#              '_prep_vendor' function.
# Function: prep_open62541
# Description: Prepares the 'open62541' vendor library by calling the generic
#              '_prep_vendor' function.
function prep_uldaq     { _fill_env; _prep_vendor "${VENDOR_ULDAQ_SRC}"; }
function prep_open62541 { _fill_env; _prep_vendor "${VENDOR_OPEN62451_SRC}"; }

function prep_vendors
{
    prep_uldaq;
    prep_open62541;
}

# Function: epics_env
# Description: Builds and installs the main EPICS environment by configuring
#              release paths, cleaning, patching, and then running a full build
#              and installation process.
function epics_env
{
    _fill_env;
    echo "--- Building EPICS environment ---"
    pushdd "$EPICS_ENV_PATH"
    echo "EPICS_TS_NTP_INET=tic.lbl.gov"         > configure/RELEASE.local
    echo "VENDOR_ULDAQ_PATH=${VENDOR_LIB_PATH}" >> configure/RELEASE.local
    echo 'OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor'    >> configure/RELEASE.local
    make distclean   || exit
    make init        || exit
    make patch       || exit
    make conf        || exit
    # WHY: The build system reuses existing configuration files instead of overwriting them.
    # This can cause conflicts with stale configurations from previous Git commits.
    #
    # WHAT: Force a 'distclean' on all modules to remove old configurations
    # (e.g., CFG/CONFIG_OPCUA) and ensure a clean build state.
    # make clean.modules actually perform "make distclean" in each module source
	if [ -d "${EPICS_MODS_PATH}" ]; then
		make clean.modules || exit
	fi
    make conf        || exit
    make build       || exit
    make install     || exit
    make symlinks    || exit
    popdd
}

# Function: epics_build
# Description: A generic function to build the EPICS environment using a
#              provided 'make' command. It handles setting up release paths
#              and entering the correct directory.
#   $1         : distclean, init, patch, conf, clean.modules, conf, build
#              : install, symlinks, and so on
function epics_build
{
    local cmd="$1";shift;
    _fill_env;
    echo "--- Building EPICS environment ---"
    pushdd "$EPICS_ENV_PATH"
    echo "EPICS_TS_NTP_INET=tic.lbl.gov"         > configure/RELEASE.local
    echo "VENDOR_ULDAQ_PATH=${VENDOR_LIB_PATH}" >> configure/RELEASE.local
    echo 'OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor' >> configure/RELEASE.local
    make "${cmd}"        || exit
    popdd
}

# Function: all
# Description: Performs a full, end-to-end setup, cloning all repositories,
#              preparing vendor libraries and support modules, and building the
#              main EPICS environment.
function all
{
    local version="$1"
    initial_setup "${version}"
    prep_vendors
    epics_env
}

# Function: show_env
# Description: A public-facing function that calls _echo_env to display the
#              current environment variables.
function show_env {  _fill_env; _echo_env; }

# Function: check_deps
# Description: Runs the dependency checking script inside the EPICS environment
#              directory.
#   $1       : A flag or option to pass to the check_deps.bash script.
#              only one option -v
function check_deps
{
    local opt="$1";shift;
    _fill_env;
    pushdd "$EPICS_ENV_PATH"
    bash tools/check_deps.bash "${opt}" || exit
    popdd
}

# Function: usage
# Description: Displays the usage information and available commands for the script.
# Returns: 1 to indicate an error, and the script will exit
function usage
{
   cat << EOF

Usage: ${0##*/} <command> [<version>]

Commands:
  init                - Prepare the environment installation
  help                - Displays this help message.
  prep-uldaq          - Prepare uldaq
  prep-open62451      - Prepare open62451
  prep-vendors        - Prepare uldaq and open65451
  epics-build         - Build EPICS with a custom make command
  show-env            - Display current environment variables
  check-deps          - Check EPICS environment dependencies
  all                 - init, prep-vendors, epics-env

Example:
  # Perform a full build for version
  bash ${0##*/} all

  # Just clone the repositories
  bash ${0##*/} init

  # Build EPICS with custom make commands
  # ,which are defined in EPICS-env (for troubleshooting)
  bash ${0##*/} epics-build vars
  bash ${0##*/} epics-build exist

EOF
    exit 1;
}

if [ "$#" -eq 0 ]; then
    usage
fi

COMMAND="$1"
func_name="${COMMAND//-/_}"

case "$COMMAND" in
    init)
        initial_setup
        ;;
    help)
        usage
        ;;
    prep-uldaq|prep-open62541|prep-vendors|epics-env|show-env)
        if declare -F "$func_name" > /dev/null; then
            "$func_name"
        else
            echo "Error: Internal script error - function '$func_name' not found." >&2
            exit 1
        fi
        ;;
    epics-build)
        if [ -z "$2" ]; then
            echo "Error: $COMMAND command requires a make command as a second argument." >&2
            usage
        fi
        if declare -F "$func_name" > /dev/null; then
            "$func_name" "$2";
        else
            echo "Error: Internal script error - function '$func_name' not found." >&2
            exit 1
        fi
        ;;
    check-deps)
        if declare -F "$func_name" > /dev/null; then
            "$func_name" "$2";
        else
            echo "Error: Internal script error - function '$func_name' not found." >&2
            exit 1
        fi
        ;;
    all)
        all "${SRC_VER}"
        echo "--- All tasks completed successfully for version ${SRC_VER} ---"
        ;;
    OS)
        if is_redhat_variant; then
            echo "Error: This system is an ugly Red Hat variant."
        else
            echo "Whoray! This system is not a Red Hat variant."
        fi
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'" >&2
        usage
        ;;
esac

