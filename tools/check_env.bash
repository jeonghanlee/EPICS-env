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
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.2

# Inspects the environment produced by the installed setEpicsEnv.bash and
# reports LD_LIBRARY_PATH entries that the loader can never resolve. The
# installed copy is sourced in a child bash scrubbed with env -i, so the probe
# measures only what the script itself contributes - the caller's
# LD_LIBRARY_PATH, PATH, and EPICS_* never reach the child, and the child's
# exports never reach the caller.
#
# The dynamic loader silently skips a non-existent LD_LIBRARY_PATH entry, and
# EPICS objects carry an $ORIGIN-relative RUNPATH, so a dead entry produces no
# runtime error and no ldd difference. It is observable only as a literal
# string inside the variable, which is what this tool inspects. Matching runs
# on normalized fields at path-component boundaries, so slash variants, dot
# segments, and relative spellings of the same dead path are all caught.
#
# Declared scope: LD_LIBRARY_PATH only (PATH is not inspected); EPICS_MODULES
# is assumed colon-free; newline-bearing paths and reintroductions that rename
# the on-disk module directory (case variants, symlinked parents) are out of
# scope.

set -euo pipefail

declare -g EPICS_ROOT=""
declare -g STRICT="NO"
declare -g REQUIRE_RUN="NO"
declare -g FINDINGS=0

readonly SCRIPT_NAME="${0##*/}"
readonly ENV_SCRIPT_NAME="setEpicsEnv.bash"
readonly BUNDLE_SUBPATH="pvxs/bundle"
readonly EXIT_FINDING=2
readonly EXIT_NORUN=3

function die
{
    printf "%s: %s\n" "${SCRIPT_NAME}" "$1" >&2
    exit 1
}

function usage
{
    printf "%s\n" "Usage: ${SCRIPT_NAME} --epics <install-root> [--strict] [--require-run]"
    printf "\n"
    printf "%s\n" "  --epics <path>   directory holding the installed ${ENV_SCRIPT_NAME}"
    printf "%s\n" "  --strict         exit ${EXIT_FINDING} when a finding is reported"
    printf "%s\n" "  --require-run    exit ${EXIT_NORUN} when the check cannot inspect an installed"
    printf "%s\n" "                   environment (absent script, unresolved host arch, empty"
    printf "%s\n" "                   LD_LIBRARY_PATH) instead of skipping"
    printf "%s\n" "  --help           print this message"
    printf "\n"
    printf "%s\n" "Without --require-run, exits 0 when the installed tree is absent; the"
    printf "%s\n" "check is skipped."
}

function parse_args
{
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --epics)
                [[ $# -ge 2 ]] || die "--epics requires a value"
                EPICS_ROOT="$2"
                shift 2
                ;;
            --strict)
                STRICT="YES"
                shift
                ;;
            --require-run)
                REQUIRE_RUN="YES"
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            --)
                shift
                break
                ;;
            -*)
                die "unknown option: $1"
                ;;
            *)
                die "unexpected argument: $1"
                ;;
        esac
    done
}

# Collapses every run of slashes and every /./ segment, then strips one
# trailing slash (root / is kept). Both loops strictly shorten the string, so
# termination is guaranteed. The result is written through the nameref so the
# per-field loop stays fork-free.
function normalize_path
{
    local -n _np_result="$1"
    local f="$2"

    while [[ "${f}" == *//* ]]; do
        f="${f//\/\//\/}"
    done
    while [[ "${f}" == */./* ]]; do
        f="${f//\/.\//\/}"
    done
    [[ "${f}" == "/" ]] || f="${f%/}"

    _np_result="${f}"
}

# Sources the installed script in a scrubbed child bash and echoes the three
# values the checks need. env -i drops the caller's LD_LIBRARY_PATH, PATH,
# and EPICS_* so the probe measures only what the script itself contributes;
# /usr/bin:/bin covers every command the script runs (perl, sed, dirname).
# Positional parameters are cleared because a sourced script inherits the
# caller's "$@" and setEpicsEnv.bash reads "$1" as an EPICS_HOST_ARCH
# override. nounset is disabled because the script dereferences variables it
# has not yet assigned.
function probe_env
{
    local env_script="$1"

    # shellcheck disable=SC2016  # the expansions must run in the child, not here
    env -i PATH=/usr/bin:/bin bash -c '
        set +u
        set --
        . "$0" >/dev/null 2>&1
        printf "MODULES=%s\n" "${EPICS_MODULES-}"
        printf "ARCH=%s\n"    "${EPICS_HOST_ARCH-}"
        printf "LDPATH=%s\n"  "${LD_LIBRARY_PATH-}"
    ' "${env_script}"
}

# The bundled libevent tree is never built in this environment: the build
# links the system libevent, so any LD_LIBRARY_PATH entry carrying a
# pvxs/bundle path component resolves to nothing. Fields are normalized and
# matched at component boundaries; every matching field is a finding.
function check_bundle_path
{
    local ld_path="$1"
    local entry=""
    local entry_norm=""
    local -a entries=()

    IFS=':' read -r -a entries <<< "${ld_path}"

    for entry in "${entries[@]}"; do
        normalize_path entry_norm "${entry}"
        case "/${entry_norm}/" in
            *"/${BUNDLE_SUBPATH}/"*)
                printf "FINDING: LD_LIBRARY_PATH carries a %s path\n" "${BUNDLE_SUBPATH}"
                printf "  %s\n" "${entry}"
                printf "  %s\n" "The build links the system libevent; this directory is never created."
                FINDINGS=$((FINDINGS + 1))
                ;;
            *)
                ;;
        esac
    done

    if [[ "${FINDINGS}" -eq 0 ]]; then
        printf "OK: no %s path in LD_LIBRARY_PATH\n" "${BUNDLE_SUBPATH}"
    fi

    return 0
}

function main
{
    local env_script=""
    local line=""
    local key=""
    local value=""
    local modules=""
    local arch=""
    local ld_path=""

    parse_args "$@"

    [[ -n "${EPICS_ROOT}" ]] || die "--epics <install-root> is required"

    env_script="${EPICS_ROOT}/${ENV_SCRIPT_NAME}"

    if [[ ! -f "${env_script}" ]]; then
        if [[ "${REQUIRE_RUN}" == "YES" ]]; then
            printf "%s\n" "FAIL: no installed environment script at ${env_script}"
            printf "%s\n" "      --require-run demands an inspectable install; run 'make install' first"
            return "${EXIT_NORUN}"
        fi
        printf "%s\n" "SKIP: no installed environment script at ${env_script}"
        printf "%s\n" "      run 'make install' first"
        return 0
    fi

    while read -r line; do
        line="${line//$'\r'/}"
        key="${line%%=*}"
        value="${line#*=}"
        case "${key}" in
            MODULES) modules="${value}" ;;
            ARCH)    arch="${value}"    ;;
            LDPATH)  ld_path="${value}" ;;
            *)       ;;
        esac
    done < <(probe_env "${env_script}")

    if [[ -z "${modules}" || -z "${arch}" ]]; then
        if [[ "${REQUIRE_RUN}" == "YES" ]]; then
            printf "%s\n" "FAIL: ${ENV_SCRIPT_NAME} left EPICS_MODULES or EPICS_HOST_ARCH empty"
            printf "%s\n" "      plausible causes: perl not found in the scrubbed PATH (/usr/bin:/bin),"
            printf "%s\n" "      or EpicsHostArch.pl absent from both base/startup/ and base/lib/perl/,"
            printf "%s\n" "      or the sourced script exited before exporting them"
            return "${EXIT_NORUN}"
        fi
        printf "%s\n" "SKIP: ${ENV_SCRIPT_NAME} left EPICS_MODULES or EPICS_HOST_ARCH empty"
        printf "%s\n" "      the library-path block never ran; nothing to inspect"
        return 0
    fi

    if [[ -z "${ld_path}" ]]; then
        if [[ "${REQUIRE_RUN}" == "YES" ]]; then
            printf "%s\n" "FAIL: ${ENV_SCRIPT_NAME} produced an empty LD_LIBRARY_PATH"
            printf "%s\n" "      a correct run always adds base/lib/<arch>; the library block never ran"
            return "${EXIT_NORUN}"
        fi
        printf "%s\n" "SKIP: ${ENV_SCRIPT_NAME} produced an empty LD_LIBRARY_PATH; nothing to inspect"
        return 0
    fi

    printf "%s\n" "Inspecting ${env_script}"
    printf "  %-16s %s\n" "EPICS_MODULES" "${modules}"
    printf "  %-16s %s\n" "EPICS_HOST_ARCH" "${arch}"
    printf "\n"

    check_bundle_path "${ld_path}"

    printf "\n"
    printf "%s\n" "findings: ${FINDINGS}"

    if [[ "${STRICT}" == "YES" && "${FINDINGS}" -gt 0 ]]; then
        return "${EXIT_FINDING}"
    fi

    return 0
}

main "$@"
