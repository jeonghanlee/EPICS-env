#!/usr/bin/env bash
#
#  Copyright (c) 2026 -         Jeong Han Lee
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
# Puts the checkout of a vendor wrapper repository at the tag pinned in
# configure/RELEASE, or confirms that an existing checkout is at that tag.
#
# Usage: vendor-checkout.bash [--any-commit] <wrapper> <directory>
#
#   <wrapper>     uldaq-env or open62541-env
#   <directory>   Checkout of the wrapper. An absent directory is cloned at
#                 the pinned tag. An existing checkout must be at the commit
#                 of the pinned tag with no changed tracked file; it is never
#                 changed and never fetched into.
#   --any-commit  Accept an existing checkout as it is and say so. For work on
#                 a wrapper together with this repository.
#
# The pin is read with "make -s print-<VARIABLE>" in the checkout that holds
# this script, so configure/RELEASE.local can replace it. The clone comes from
# <base>/<wrapper>, where <base> is the environment variable VENDOR_GIT_BASE
# when it is set.
#
# Exit status: 0 the checkout is at the pin, --any-commit accepted it, or
#              help; 1 the checkout or the pin is refused; 2 usage error.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly DEFAULT_GIT_BASE="https://github.com/jeonghanlee"
readonly TAG_PATTERN='^[A-Za-z0-9][A-Za-z0-9._-]*$'
readonly EXIT_REFUSED=1
readonly EXIT_USAGE=2

declare -g ANY_COMMIT="NO"

function usage_text {
    printf 'Usage: %s [--any-commit] <wrapper> <directory>\n' "${SCRIPT_NAME}"
    printf '       <wrapper> is uldaq-env or open62541-env\n'
}

function usage {
    usage_text >&2
    exit "${EXIT_USAGE}"
}

function refuse {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit "${EXIT_REFUSED}"
}

# Prints the name of the pin variable of a wrapper.
function pin_variable {
    case "$1" in
        uldaq-env) printf 'VENDOR_ULDAQ_TAG' ;;
        open62541-env) printf 'VENDOR_OPEN62541_TAG' ;;
        *) usage ;;
    esac
}

# Prints the pinned tag of a wrapper. make prints an empty line with status
# 0 for a variable that is not set, so an empty or malformed value is refused.
function read_pin {
    local top="$1"
    local variable="$2"
    local output=""
    local pin=""

    if ! output=$(MAKEFLAGS='' make -s --no-print-directory -C "${top}" "print-${variable}"); then
        refuse "Cannot read ${variable} with make in ${top}"
    fi
    pin="${output%%$'\n'*}"
    [[ "${pin}" =~ ${TAG_PATTERN} ]] || refuse "${variable} is empty or is no tag name in ${top}/configure/RELEASE: '${pin}'"
    printf '%s' "${pin}"
}

# Confirms that an existing checkout is at the commit of the pinned tag with
# no changed tracked file. Nothing in the checkout is changed.
function check_existing {
    local wrapper="$1"
    local directory="$2"
    local pin="$3"
    local head=""
    local pinned=""
    local root=""

    # A directory inside another work tree is no checkout of the wrapper.
    root=$(git -C "${directory}" rev-parse --show-toplevel 2> /dev/null) || root=""
    if [[ -z "${root}" || "$(cd -- "${root}" && pwd -P)" != "$(cd -- "${directory}" && pwd -P)" ]]; then
        refuse "${directory} is no git checkout of ${wrapper}"
    fi
    if ! head=$(git -C "${directory}" rev-parse --verify --quiet 'HEAD^{commit}'); then
        refuse "${directory} is a git checkout of ${wrapper} without a commit"
    fi
    if [[ "${ANY_COMMIT}" == "YES" ]]; then
        printf '%s: %s pin %s NOT checked (--any-commit): %s is at %s\n' "${SCRIPT_NAME}" "${wrapper}" "${pin}" "${directory}" "${head}"
        return 0
    fi
    if ! pinned=$(git -C "${directory}" rev-parse --verify --quiet "refs/tags/${pin}^{commit}"); then
        refuse "${directory} does not hold the pinned tag ${pin} of ${wrapper}. Fetch it with: git -C ${directory} fetch --tags"
    fi
    [[ "${head}" == "${pinned}" ]] || refuse "${directory} is at ${head}, not at the pinned tag ${pin} (${pinned}) of ${wrapper}. Switch it with: git -C ${directory} checkout ${pin}"
    if ! git -C "${directory}" diff --quiet HEAD; then
        refuse "${directory} is at the pinned tag ${pin} of ${wrapper} but a tracked file is changed. Show the changes with: git -C ${directory} status"
    fi
    printf '%s: %s %s %s %s\n' "${SCRIPT_NAME}" "${wrapper}" "${pin}" "${head}" "${directory}"
}

# Clones the wrapper at the pinned tag into the absent directory.
function clone_pinned {
    local wrapper="$1"
    local directory="$2"
    local pin="$3"
    local base="${VENDOR_GIT_BASE:-${DEFAULT_GIT_BASE}}"
    local head=""
    local pinned=""

    if ! git clone --depth 1 --branch "${pin}" "${base}/${wrapper}" "${directory}" >&2; then
        refuse "Cannot clone ${base}/${wrapper} at the pinned tag ${pin}"
    fi
    head=$(git -C "${directory}" rev-parse --verify --quiet 'HEAD^{commit}') || refuse "The clone ${directory} has no commit"
    pinned=$(git -C "${directory}" rev-parse --verify --quiet "refs/tags/${pin}^{commit}") || refuse "${pin} is no tag of ${base}/${wrapper}"
    [[ "${head}" == "${pinned}" ]] || refuse "The clone ${directory} is at ${head}, not at the tag ${pin} (${pinned})"
    printf '%s: %s %s %s %s\n' "${SCRIPT_NAME}" "${wrapper}" "${pin}" "${head}" "${directory}"
}

function main {
    local top=""
    local wrapper=""
    local directory=""
    local variable=""
    local pin=""
    local -a arguments=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --any-commit) ANY_COMMIT="YES" ;;
            -h|--help) usage_text; exit 0 ;;
            --) shift; arguments+=("$@"); break ;;
            -*) usage ;;
            *) arguments+=("$1") ;;
        esac
        shift
    done
    [[ ${#arguments[@]} -eq 2 && -n "${arguments[1]}" ]] || usage
    wrapper="${arguments[0]}"
    directory="${arguments[1]}"
    variable=$(pin_variable "${wrapper}")

    top=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
    command -v git > /dev/null || refuse "git is not available"
    command -v make > /dev/null || refuse "make is not available"
    pin=$(read_pin "${top}" "${variable}")

    if [[ -e "${directory}" || -L "${directory}" ]]; then
        [[ -d "${directory}" ]] || refuse "${directory} exists and is no directory"
        check_existing "${wrapper}" "${directory}" "${pin}"
    else
        clone_pinned "${wrapper}" "${directory}" "${pin}"
    fi
}

main "$@"
