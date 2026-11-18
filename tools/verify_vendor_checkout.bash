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
# Checks each behaviour of vendor-checkout.bash against two local wrapper
# repositories with tags. Only the remote is replaced: the helper, make and
# git are the real ones, and the helper reads its pins from a scratch copy of
# Makefile and configure/ of this checkout.
#
# Usage: verify_vendor_checkout.bash [<helper>]
#
#   <helper>  The helper to check; default tools/vendor-checkout.bash beside
#             this script. Another file serves a mutation run.
#
# The scratch directory is made under ${TMPDIR:-/tmp}; it is removed when
# every check passes and kept, with its path printed, otherwise.
# The repositories of the test use no git configuration and no hook of the
# user.
#
# Exit status: 0 every check passes; 1 a check fails; 2 the test cannot run.

set -uo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly OLD_TAG="0.0.1-1"
readonly PIN_TAG="9.9.9-1"
readonly WRAPPERS="uldaq-env open62541-env"

declare -g WORK=""
declare -g TOP=""
declare -g HELPER=""
declare -g CHECKS_OK=0
declare -g CHECKS_FAIL=0
declare -g LAST_STATUS=0

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit 2
}

# Runs git without the configuration and the hooks of the user.
function test_git {
    GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
        git -c user.name=verify -c user.email=verify@example.invalid -c init.defaultBranch=master -c advice.detachedHead=false "$@"
}

function check {
    local label="$1"
    shift
    if "$@"; then
        printf 'OK    %s\n' "${label}"
        CHECKS_OK=$((CHECKS_OK + 1))
    else
        printf 'FAIL  %s\n' "${label}"
        CHECKS_FAIL=$((CHECKS_FAIL + 1))
    fi
}

# Runs the helper of the scratch checkout; keeps its status and its output.
function run_helper {
    LAST_STATUS=0
    GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null VENDOR_GIT_BASE="file://${WORK}/remote" \
        bash "${TOP}/tools/vendor-checkout.bash" "$@" > "${WORK}/helper.out" 2> "${WORK}/helper.err" || LAST_STATUS=$?
}

function status_is { [[ "${LAST_STATUS}" -eq "$1" ]]; }
function message_has { grep -q -- "$1" "${WORK}/helper.err" "${WORK}/helper.out"; }
function head_of { test_git -C "$1" rev-parse HEAD; }
function tag_commit { test_git -C "${WORK}/remote/$1" rev-parse "refs/tags/$2^{commit}"; }

# Writes the pins that the scratch checkout reads.
function set_pins {
    printf 'VENDOR_ULDAQ_TAG:=%s\nVENDOR_OPEN62541_TAG:=%s\n' "$1" "$2" > "${TOP}/configure/RELEASE.local"
}

# Makes one local wrapper repository: a commit with the old tag, a commit
# with the pinned tag, and an untagged commit at the tip.
function make_remote {
    local repo="${WORK}/remote/$1"

    test_git init -q "${repo}" || return 1
    printf 'one\n' > "${repo}/file"
    test_git -C "${repo}" add file && test_git -C "${repo}" commit -q -m one || return 1
    test_git -C "${repo}" tag -a "${OLD_TAG}" -m "${OLD_TAG}" || return 1
    printf 'two\n' > "${repo}/file"
    test_git -C "${repo}" commit -q -a -m two && test_git -C "${repo}" tag -a "${PIN_TAG}" -m "${PIN_TAG}" || return 1
    printf 'three\n' > "${repo}/file"
    test_git -C "${repo}" commit -q -a -m three
}

function prepare {
    local source_top=""
    local wrapper=""

    source_top=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P) || die "Cannot find the checkout"
    HELPER="${1:-${source_top}/tools/vendor-checkout.bash}"
    [[ -s "${HELPER}" ]] || die "Cannot read the helper: ${HELPER}"
    for wrapper in git make cmp; do
        command -v "${wrapper}" > /dev/null || die "${wrapper} is not available"
    done
    WORK=$(mktemp -d "${TMPDIR:-/tmp}/verify_vendor_checkout.XXXXXX") || die "Cannot make a scratch directory"
    TOP="${WORK}/top"
    mkdir -p "${TOP}/tools" "${WORK}/remote" "${WORK}/co" || die "Cannot fill ${WORK}"
    cp -- "${source_top}/Makefile" "${TOP}/" || die "Cannot copy Makefile"
    cp -r -- "${source_top}/configure" "${TOP}/" || die "Cannot copy configure/"
    cp -- "${HELPER}" "${TOP}/tools/vendor-checkout.bash" || die "Cannot copy the helper"
    for wrapper in ${WRAPPERS}; do
        make_remote "${wrapper}" || die "Cannot make the local repository ${wrapper}"
    done
    printf 'helper %s\nscratch %s\n' "${HELPER}" "${WORK}"
}

function checks {
    local wrapper=""
    local dir=""
    local before=""

    set_pins "${PIN_TAG}" "${PIN_TAG}"
    for wrapper in ${WRAPPERS}; do
        dir="${WORK}/co/${wrapper}"
        run_helper "${wrapper}" "${dir}"
        check "${wrapper}: an absent directory is cloned at the pinned tag" \
            bash -c "[[ ${LAST_STATUS} -eq 0 && '$(head_of "${dir}" 2> /dev/null)' == '$(tag_commit "${wrapper}" "${PIN_TAG}")' ]]"
        run_helper "${wrapper}" "${dir}"
        check "${wrapper}: a checkout at the pin is accepted" status_is 0
    done

    wrapper="uldaq-env"
    set_pins "${OLD_TAG}" "${PIN_TAG}"
    run_helper "${wrapper}" "${WORK}/co/other-pin"
    check "a changed pin changes the commit that is cloned" \
        bash -c "[[ ${LAST_STATUS} -eq 0 && '$(head_of "${WORK}/co/other-pin" 2> /dev/null)' == '$(tag_commit "${wrapper}" "${OLD_TAG}")' ]]"
    set_pins "${PIN_TAG}" "${PIN_TAG}"

    dir="${WORK}/co/off-pin"
    test_git clone -q "file://${WORK}/remote/${wrapper}" "${dir}" || die "Cannot clone ${wrapper}"
    before=$(head_of "${dir}")
    run_helper "${wrapper}" "${dir}"
    check "a checkout at another commit is refused and left as it is" \
        bash -c "[[ ${LAST_STATUS} -eq 1 && '$(head_of "${dir}")' == '${before}' ]] && grep -q 'not at the pinned tag ${PIN_TAG}' '${WORK}/helper.err'"
    run_helper --any-commit "${wrapper}" "${dir}"
    check "--any-commit accepts that checkout and says that the pin was not checked" \
        bash -c "[[ ${LAST_STATUS} -eq 0 && '$(head_of "${dir}")' == '${before}' ]] && grep -q 'NOT checked (--any-commit)' '${WORK}/helper.out'"

    dir="${WORK}/co/${wrapper}"
    printf 'changed\n' > "${dir}/file"
    run_helper "${wrapper}" "${dir}"
    check "a changed tracked file at the pin is refused and left as it is" \
        bash -c "[[ ${LAST_STATUS} -eq 1 && \"\$(cat '${dir}/file')\" == changed ]] && grep -q 'a tracked file is changed' '${WORK}/helper.err'"
    test_git -C "${dir}" checkout -q -- file

    dir="${WORK}/co/no-tag"
    test_git clone -q --no-tags "file://${WORK}/remote/${wrapper}" "${dir}" || die "Cannot clone ${wrapper} without tags"
    run_helper "${wrapper}" "${dir}"
    check "a checkout without the pinned tag is refused, named with the fetch command, and not fetched into" \
        bash -c "[[ ${LAST_STATUS} -eq 1 && -z '$(test_git -C "${dir}" tag)' ]] && grep -q 'fetch --tags' '${WORK}/helper.err'"

    set_pins "" "${PIN_TAG}"
    run_helper "${wrapper}" "${WORK}/co/empty-pin"
    check "an empty pin is refused as such and nothing is cloned" bash -c "[[ ${LAST_STATUS} -eq 1 && ! -e '${WORK}/co/empty-pin' ]] && grep -q 'is empty or is no tag name' '${WORK}/helper.err'"
    set_pins "not a tag" "${PIN_TAG}"
    run_helper "${wrapper}" "${WORK}/co/bad-pin"
    check "a pin that is no tag name is refused as such and nothing is cloned" bash -c "[[ ${LAST_STATUS} -eq 1 && ! -e '${WORK}/co/bad-pin' ]] && grep -q 'is empty or is no tag name' '${WORK}/helper.err'"
    set_pins "7.7.7-7" "${PIN_TAG}"
    run_helper "${wrapper}" "${WORK}/co/absent-tag"
    check "a pin that names no tag of the repository is refused" status_is 1
    set_pins "${PIN_TAG}" "${PIN_TAG}"

    run_helper "other-env" "${WORK}/co/other"
    check "a wrapper name that is not known is a usage error" status_is 2
    run_helper "${wrapper}"
    check "a missing directory argument is a usage error" status_is 2
    run_helper --help
    check "--help prints the usage and ends with status 0" bash -c "[[ ${LAST_STATUS} -eq 0 ]] && grep -q '^Usage: ' '${WORK}/helper.out'"
    printf 'plain file\n' > "${WORK}/co/plain"
    run_helper "${wrapper}" "${WORK}/co/plain"
    check "a path that is no directory is refused" status_is 1
    mkdir -p "${WORK}/co/no-repo"
    run_helper "${wrapper}" "${WORK}/co/no-repo"
    check "a directory that is no git checkout is refused" bash -c "[[ ${LAST_STATUS} -eq 1 ]] && grep -q 'is no git checkout' '${WORK}/helper.err'"
    mkdir -p "${WORK}/co/${wrapper}/inner"
    run_helper "${wrapper}" "${WORK}/co/${wrapper}/inner"
    check "a directory inside a checkout at the pin is refused" bash -c "[[ ${LAST_STATUS} -eq 1 ]] && grep -q 'is no git checkout' '${WORK}/helper.err'"
}

function main {
    prepare "$@"
    checks
    printf '\nSUMMARY ok=%s fail=%s\n' "${CHECKS_OK}" "${CHECKS_FAIL}"
    if [[ "${CHECKS_FAIL}" -eq 0 ]]; then
        rm -rf -- "${WORK:?}"
        return 0
    fi
    printf 'scratch kept: %s\n' "${WORK}"
    return 1
}

main "$@"
