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
# Inspect the ELF dynamic dependencies of installed-module objects with
# readelf. The metadata generator and the iocsh.bash loader share this
# resolver.
#
#   undefined  Report every symbol an object leaves undefined after the
#              object, its NEEDED closure, and the given provider objects
#              with their closures are considered, and every NEEDED entry
#              that resolves to no file. The environment search path is
#              ignored: the result describes the installed objects.
#   inspect    Resolve the NEEDED closure of the given objects in the order
#              given, the native executable first and then each library in
#              load order, and classify each resolved file as base, module,
#              vendor, or system. A file inside an installed module
#              directory must belong to a selected module version.
#              LD_LIBRARY_PATH and LD_PRELOAD take part as the native
#              loader applies them.
#
# The search order per NEEDED entry follows the native loader: an object
# already loaded under that name or soname, the RPATH of the requesting
# object when it has no RUNPATH, LD_LIBRARY_PATH, the RUNPATH of the
# requesting object, the ldconfig cache, and the default directories. A
# candidate of another ELF class or machine is skipped. $ORIGIN expands to
# the directory of the requesting object's canonical path. An RPATH
# inherited from the loading chain, hardware-capability subdirectories, and
# the $LIB and $PLATFORM tokens are not modeled, and an empty search-path
# entry, which the native loader reads as the current directory, is skipped.
# A system library is found through the ldconfig cache, so a host without
# that cache resolves only the default directories. The result is therefore
# a static validation and never proof of what the native loader binds.
#
# Both modes also report an object whose file is shorter than the end of
# its last loadable segment: the native loader cannot map such a file, and
# depending on the C library it ends the process with a bus error instead
# of an error message. A file that is cut behind its loadable segments
# still loads and is not reported here.
#
# Exit status: 0 when nothing is reported, 1 when a finding is reported,
# 2 when the inspection itself cannot run.

set -euo pipefail

export LC_ALL=C

readonly SCRIPT_NAME="${0##*/}"
readonly EXIT_FINDING=1
readonly EXIT_ERROR=2
readonly DEFAULT_DIRS="/lib64:/usr/lib64:/lib:/usr/lib"
readonly LDCONFIG_NAMES="ldconfig /sbin/ldconfig /usr/sbin/ldconfig"

declare -g MODE=""
declare -g BASE_DIR=""
declare -g MODULES_DIR=""
declare -g VENDOR_DIR=""
declare -g USE_ENVIRONMENT="NO"
declare -g CACHE_READ="NO"
declare -g RESULT=""
declare -g FINDINGS=0
declare -a OBJECTS=()
declare -a PROVIDERS=()
declare -a SELECTIONS=()
declare -a EDGES=()
declare -a VISITED=()

# Per-object dynamic data keyed by canonical path, the canonical-path
# cache, the loaded name table, and the ldconfig cache keyed by file name.
declare -A OBJ_STATE=()
declare -A OBJ_KIND=()
declare -A OBJ_NEEDED=()
declare -A OBJ_RPATH=()
declare -A OBJ_RUNPATH=()
declare -A OBJ_SONAME=()
declare -A OBJ_TRUNCATED=()
declare -A CANONICAL=()
declare -A LOADED_NAME=()
declare -A VISITED_SET=()
declare -A LD_CACHE=()
declare -A CLASS_OF=()

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit "${EXIT_ERROR}"
}

function finding {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    FINDINGS=$((FINDINGS + 1))
}

function usage {
    printf '%s\n' \
        "Usage: ${SCRIPT_NAME} undefined|inspect [options]" \
        '' \
        '  --object FILE       Object to inspect; repeat in load order' \
        '  --provider FILE     Object whose symbols are available (undefined)' \
        '  --base DIR          Installed EPICS Base directory (inspect)' \
        '  --modules DIR       Installed modules directory (inspect)' \
        '  --vendor DIR        Installed vendor directory (inspect, optional)' \
        '  --select NAME=DIR   Selected module and its directory (inspect)' \
        '  -h, --help          Print this help and exit' \
        '' \
        'undefined prints one "undefined SYMBOL OBJECT", "missing NAME OBJECT", or' \
        '"truncated OBJECT" line per finding. inspect prints one tab-separated' \
        'line per resolved dependency: class, owner, resolved file, needed name,' \
        'requesting object.'
}

function require_command {
    local name="$1"
    local path=""

    if ! path=$(command -v "${name}"); then
        die "Cannot find required command: ${name} (binutils provides readelf and nm)"
    fi
    [[ -x "${path}" ]] || die "Required command is not executable: ${path}"
}

# Sets RESULT to the canonical path of an existing file and returns 1 when
# the path does not resolve.
function canonical {
    local path="$1"

    if [[ -z "${CANONICAL[${path}]:-}" ]]; then
        if ! CANONICAL["${path}"]=$(readlink -e -- "${path}"); then
            CANONICAL["${path}"]="-"
        fi
    fi
    RESULT="${CANONICAL[${path}]}"
    [[ "${RESULT}" != "-" ]]
}

# Reads the ELF header and dynamic section of one canonical path once. The
# state is elf for a readable ELF object and other for anything else.
function load_object {
    local path="$1"
    local output=""
    local line=""
    local class=""
    local machine=""
    local needed=""
    local size=""
    local load_end=0
    local segment_end=0

    [[ -z "${OBJ_STATE[${path}]:-}" ]] || return 0
    OBJ_STATE["${path}"]="other"
    if ! output=$(readelf -h -l -d -W -- "${path}" 2>/dev/null); then
        return 0
    fi
    while IFS= read -r line; do
        if [[ "${line}" =~ ^[[:space:]]*Class:[[:space:]]*(.*)$ ]]; then
            class="${BASH_REMATCH[1]}"
        elif [[ "${line}" =~ ^[[:space:]]*Machine:[[:space:]]*(.*)$ ]]; then
            machine="${BASH_REMATCH[1]}"
        elif [[ "${line}" =~ \(NEEDED\).*\[(.*)\] ]]; then
            needed="${needed}${needed:+$'\n'}${BASH_REMATCH[1]}"
        elif [[ "${line}" =~ \(SONAME\).*\[(.*)\] ]]; then
            OBJ_SONAME["${path}"]="${BASH_REMATCH[1]}"
        elif [[ "${line}" =~ \(RPATH\).*\[(.*)\] ]]; then
            OBJ_RPATH["${path}"]="${BASH_REMATCH[1]}"
        elif [[ "${line}" =~ \(RUNPATH\).*\[(.*)\] ]]; then
            OBJ_RUNPATH["${path}"]="${BASH_REMATCH[1]}"
        elif [[ "${line}" =~ ^[[:space:]]*LOAD[[:space:]]+(0x[0-9a-fA-F]+)[[:space:]]+0x[0-9a-fA-F]+[[:space:]]+0x[0-9a-fA-F]+[[:space:]]+(0x[0-9a-fA-F]+)[[:space:]] ]]; then
            # A program header line: file offset, two addresses, file size.
            segment_end=$((BASH_REMATCH[1] + BASH_REMATCH[2]))
            [[ "${segment_end}" -le "${load_end}" ]] || load_end="${segment_end}"
        fi
    done <<< "${output}"
    [[ -n "${class}" && -n "${machine}" ]] || return 0
    if size=$(stat -c %s -- "${path}" 2>/dev/null) && [[ "${size}" -lt "${load_end}" ]]; then
        OBJ_TRUNCATED["${path}"]="${size} ${load_end}"
    fi
    OBJ_STATE["${path}"]="elf"
    OBJ_KIND["${path}"]="${class}/${machine}"
    OBJ_NEEDED["${path}"]="${needed}"
}

function read_ld_cache {
    local name=""
    local tool=""
    local line=""

    CACHE_READ="YES"
    for name in ${LDCONFIG_NAMES}; do
        if tool=$(command -v "${name}"); then
            break
        fi
        tool=""
    done
    [[ -n "${tool}" ]] || return 0
    while IFS= read -r line; do
        if [[ "${line}" =~ ^[[:space:]]+([^[:space:]]+)[[:space:]]\(.*\)[[:space:]]=\>[[:space:]](.+)$ ]]; then
            name="${BASH_REMATCH[1]}"
            LD_CACHE["${name}"]="${LD_CACHE[${name}]:-}${LD_CACHE[${name}]:+$'\n'}${BASH_REMATCH[2]}"
        fi
    done < <("${tool}" -p 2>/dev/null || true)
}

# Accepts a candidate file for a requesting object when it is an ELF object
# of the same class and machine; sets RESULT to its canonical path.
function accept_candidate {
    local object="$1"
    local candidate="$2"

    [[ -e "${candidate}" ]] || return 1
    canonical "${candidate}" || return 1
    load_object "${RESULT}"
    [[ "${OBJ_STATE[${RESULT}]}" == "elf" && "${OBJ_KIND[${RESULT}]}" == "${OBJ_KIND[${object}]}" ]]
}

# Searches a colon-separated directory list for a needed name.
function search_dirs {
    local object="$1"
    local needed="$2"
    local list="$3"
    local origin="${object%/*}"
    local dir=""
    local -a dirs=()

    [[ -n "${list}" ]] || return 1
    IFS=':' read -r -a dirs <<< "${list}"
    for dir in "${dirs[@]}"; do
        dir="${dir//\$\{ORIGIN\}/${origin}}"
        dir="${dir//\$ORIGIN/${origin}}"
        [[ -n "${dir}" && "${dir}" != *\$* ]] || continue
        if accept_candidate "${object}" "${dir}/${needed}"; then
            return 0
        fi
    done
    return 1
}

# Resolves one NEEDED entry of an object; sets RESULT to the canonical path
# and returns 1 when no candidate exists.
function resolve {
    local object="$1"
    local needed="$2"
    local candidate=""

    if [[ -n "${LOADED_NAME[${needed}]:-}" ]]; then
        RESULT="${LOADED_NAME[${needed}]}"
        return 0
    fi
    if [[ "${needed}" == */* ]]; then
        accept_candidate "${object}" "${needed}"
        return
    fi
    if [[ -z "${OBJ_RUNPATH[${object}]:-}" ]] && search_dirs "${object}" "${needed}" "${OBJ_RPATH[${object}]:-}"; then
        return 0
    fi
    if [[ "${USE_ENVIRONMENT}" == "YES" ]] && search_dirs "${object}" "${needed}" "${LD_LIBRARY_PATH:-}"; then
        return 0
    fi
    if search_dirs "${object}" "${needed}" "${OBJ_RUNPATH[${object}]:-}"; then
        return 0
    fi
    [[ "${CACHE_READ}" == "YES" ]] || read_ld_cache
    if [[ -n "${LD_CACHE[${needed}]:-}" ]]; then
        while IFS= read -r candidate; do
            if accept_candidate "${object}" "${candidate}"; then
                return 0
            fi
        done <<< "${LD_CACHE[${needed}]}"
    fi
    search_dirs "${object}" "${needed}" "${DEFAULT_DIRS}"
}

# Records an object under its path, file name, and soname the way the
# native loader recognizes an object that is already loaded.
function register_loaded {
    local path="$1"
    local name=""

    for name in "${path##*/}" "${OBJ_SONAME[${path}]:-}"; do
        [[ -n "${name}" && -z "${LOADED_NAME[${name}]:-}" ]] || continue
        LOADED_NAME["${name}"]="${path}"
    done
}

# Reports an object that the native loader cannot map because its file ends
# before its last loadable segment does.
function report_truncated {
    local path="$1"
    local sizes="${OBJ_TRUNCATED[${path}]:-}"
    local advice=""

    [[ -n "${sizes}" ]] || return 0
    if [[ "${MODE}" == "undefined" ]]; then
        # The undefined mode lists its findings on standard output.
        printf 'truncated %s\n' "${path}"
        FINDINGS=$((FINDINGS + 1))
        return 0
    fi
    # The repair depends on where the file lives: a file of the installed
    # tree is restored from its distribution or rebuilt after its removal,
    # because an installation over a damaged file does not replace it.
    if [[ "${path}" == "${MODULES_DIR}/"* ]]; then
        advice="It is a file of an installed module. In a tree taken from a distribution, restore the file from that distribution. In a tree built from an EPICS-env checkout, remove the file and run make build.<module> there; an installation over the damaged file does not replace it, and <module> is the make name of the module, which for the sequencer in seq-<version> is sequencer."
    elif [[ "${path}" == "${BASE_DIR}/"* ]]; then
        advice="It is a file of the installed EPICS Base. In a tree taken from a distribution, restore the file from that distribution. In a tree built from an EPICS-env checkout, remove the file and run make install.base there; an installation over the damaged file does not replace it."
    elif [[ -n "${VENDOR_DIR}" && "${path}" == "${VENDOR_DIR}/"* ]]; then
        advice="It is a vendor file of the installed tree. Restore it from the distribution the tree came from, or remove it and install that vendor library again."
    else
        advice="It lies outside the installed tree. Reinstall the package that provides it."
    fi
    finding "${path} is truncated: its size is ${sizes%% *} bytes, but its last loadable segment ends at ${sizes#* }. The native loader cannot map it. ${advice}"
}

# Walks the NEEDED closure of one top-level object breadth first, appending
# one "object|needed|resolved" edge per entry; resolved is empty for a
# missing file.
function walk {
    local top="$1"
    local object=""
    local needed=""
    local -a queue=("${top}")

    load_object "${top}"
    [[ "${OBJ_STATE[${top}]}" == "elf" ]] || die "Not a readable ELF object: ${top}"
    register_loaded "${top}"
    if [[ -z "${VISITED_SET[${top}]:-}" ]]; then
        VISITED_SET["${top}"]=1
        VISITED+=("${top}")
        report_truncated "${top}"
    fi
    while [[ ${#queue[@]} -gt 0 ]]; do
        object="${queue[0]}"
        queue=("${queue[@]:1}")
        [[ -n "${OBJ_NEEDED[${object}]}" ]] || continue
        while IFS= read -r needed; do
            if ! resolve "${object}" "${needed}"; then
                EDGES+=("${object}|${needed}|")
                continue
            fi
            EDGES+=("${object}|${needed}|${RESULT}")
            LOADED_NAME["${needed}"]="${RESULT}"
            register_loaded "${RESULT}"
            if [[ -z "${VISITED_SET[${RESULT}]:-}" ]]; then
                VISITED_SET["${RESULT}"]=1
                VISITED+=("${RESULT}")
                queue+=("${RESULT}")
                report_truncated "${RESULT}"
            fi
        done <<< "${OBJ_NEEDED[${object}]}"
    done
}

function walk_inputs {
    local path=""

    for path in "$@"; do
        canonical "${path}" || die "Cannot read object: ${path}"
        walk "${RESULT}"
    done
}

function defined_symbols {
    local path=""

    for path in "${VISITED[@]}"; do
        nm -D --defined-only -- "${path}" 2>/dev/null || true
    done | awk 'NF >= 3 { sub(/@.*/, "", $NF); print $NF }' | sort -u
}

function undefined_symbols {
    { nm -D --undefined-only -- "$1" 2>/dev/null || true; } | awk '$1 == "U" { sub(/@.*/, "", $2); print $2 }' | sort -u
}

function do_undefined {
    local edge=""
    local object=""
    local symbol=""
    local rest=""

    [[ ${#OBJECTS[@]} -gt 0 ]] || die "undefined needs at least one --object"
    require_command nm
    require_command awk
    require_command sort
    require_command comm
    walk_inputs "${OBJECTS[@]}" "${PROVIDERS[@]}"
    for edge in "${EDGES[@]}"; do
        [[ "${edge}" == *"|" ]] || continue
        object="${edge%%|*}"
        rest="${edge#*|}"
        printf 'missing %s %s\n' "${rest%|}" "${object}"
        FINDINGS=$((FINDINGS + 1))
    done
    for object in "${OBJECTS[@]}"; do
        canonical "${object}"
        object="${RESULT}"
        while IFS= read -r symbol; do
            [[ -n "${symbol}" ]] || continue
            printf 'undefined %s %s\n' "${symbol}" "${object}"
            FINDINGS=$((FINDINGS + 1))
        done < <(comm -23 <(undefined_symbols "${object}") <(defined_symbols))
    done
}

# Classifies one resolved file once; sets RESULT to "class<TAB>owner" and
# reports a finding for a file of an installed module that is not selected.
function classify {
    local path="$1"
    local requester="$2"

    if [[ -n "${CLASS_OF[${path}]:-}" ]]; then
        RESULT="${CLASS_OF[${path}]}"
        return 0
    fi
    classify_new "${path}" "${requester}"
    CLASS_OF["${path}"]="${RESULT}"
}

function classify_new {
    local path="$1"
    local requester="$2"
    local directory=""
    local selection=""
    local name=""
    local selected=""

    if [[ "${path}" == "${MODULES_DIR}/"* ]]; then
        directory="${path#"${MODULES_DIR}/"}"
        directory="${directory%%/*}"
        RESULT="module"$'\t'"${directory}"
        for selection in "${SELECTIONS[@]}"; do
            selected="${selection#*=}"
            if [[ "${selected##*/}" == "${directory}" ]]; then
                return 0
            fi
        done
        for selection in "${SELECTIONS[@]}"; do
            name="${selection%%=*}"
            selected="${selection#*=}"
            if [[ "${directory}" == "${name}-"* ]]; then
                finding "${path} belongs to ${directory}, but the selected ${name} is ${selected##*/} (${requester}). Remove the other version from LD_LIBRARY_PATH or LD_PRELOAD, or select ${directory}."
                return 0
            fi
        done
        finding "${path} belongs to ${directory}, which is not a selected module or a recorded dependency (${requester})."
    elif [[ "${path}" == "${BASE_DIR}/"* ]]; then
        RESULT="base"$'\t'"-"
    elif [[ -n "${VENDOR_DIR}" && "${path}" == "${VENDOR_DIR}/"* ]]; then
        RESULT="vendor"$'\t'"-"
    else
        RESULT="system"$'\t'"-"
    fi
}

function do_inspect {
    local edge=""
    local object=""
    local needed=""
    local resolved=""
    local entry=""
    local selection=""
    local index=0
    local -a preloads=()
    local -a preload_paths=()

    [[ ${#OBJECTS[@]} -gt 0 ]] || die "inspect needs at least one --object"
    [[ -n "${BASE_DIR}" && -n "${MODULES_DIR}" ]] || die "inspect needs --base and --modules"
    canonical "${BASE_DIR}" || die "Cannot resolve the Base directory: ${BASE_DIR}"
    BASE_DIR="${RESULT}"
    canonical "${MODULES_DIR}" || die "Cannot resolve the modules directory: ${MODULES_DIR}"
    MODULES_DIR="${RESULT}"
    if [[ -n "${VENDOR_DIR}" ]]; then
        if canonical "${VENDOR_DIR}"; then
            VENDOR_DIR="${RESULT}"
        else
            VENDOR_DIR=""
        fi
    fi
    for index in "${!SELECTIONS[@]}"; do
        selection="${SELECTIONS[${index}]}"
        canonical "${selection#*=}" || die "Cannot resolve the selected module directory: ${selection#*=}"
        SELECTIONS[index]="${selection%%=*}=${RESULT}"
    done
    USE_ENVIRONMENT="YES"

    # Preloaded objects enter the process before the executable's own
    # dependencies, so they take part first. The native loader ignores a
    # preload entry it cannot open, so such an entry is no finding.
    if [[ -n "${LD_PRELOAD:-}" ]]; then
        read -r -a preloads <<< "${LD_PRELOAD//:/ }" || true
        canonical "${OBJECTS[0]}" || die "Cannot read object: ${OBJECTS[0]}"
        object="${RESULT}"
        load_object "${object}"
        for entry in "${preloads[@]}"; do
            if resolve "${object}" "${entry}"; then
                preload_paths+=("${RESULT}")
                EDGES+=("LD_PRELOAD|${entry}|${RESULT}")
            fi
        done
    fi
    walk_inputs "${preload_paths[@]}" "${OBJECTS[@]}"

    for edge in "${EDGES[@]}"; do
        object="${edge%%|*}"
        needed="${edge#*|}"
        resolved="${needed#*|}"
        needed="${needed%%|*}"
        if [[ -z "${resolved}" ]]; then
            finding "${needed} needed by ${object} resolves to no file of the same architecture."
            continue
        fi
        classify "${resolved}" "${needed} needed by ${object}"
        printf '%s\t%s\t%s\t%s\n' "${RESULT}" "${resolved}" "${needed}" "${object}"
    done
}

function main {
    [[ $# -ge 1 ]] || { usage >&2; exit "${EXIT_ERROR}"; }
    case "$1" in
        undefined|inspect) MODE="$1" ;;
        -h|--help) usage; return 0 ;;
        *) die "Unknown mode: $1" ;;
    esac
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --object) [[ $# -ge 2 ]] || die "Missing value for $1"; OBJECTS+=("$2"); shift ;;
            --provider) [[ $# -ge 2 ]] || die "Missing value for $1"; PROVIDERS+=("$2"); shift ;;
            --base) [[ $# -ge 2 ]] || die "Missing value for $1"; BASE_DIR="${2%/}"; shift ;;
            --modules) [[ $# -ge 2 ]] || die "Missing value for $1"; MODULES_DIR="${2%/}"; shift ;;
            --vendor) [[ $# -ge 2 ]] || die "Missing value for $1"; VENDOR_DIR="${2%/}"; shift ;;
            --select)
                [[ $# -ge 2 ]] || die "Missing value for $1"
                [[ "$2" == ?*=?* ]] || die "Selection must be NAME=DIR: $2"
                SELECTIONS+=("$2")
                shift
                ;;
            -h|--help) usage; return 0 ;;
            *) die "Unknown option: $1" ;;
        esac
        shift
    done
    require_command readelf
    require_command readlink
    require_command stat
    case "${MODE}" in
        undefined) do_undefined ;;
        inspect) do_inspect ;;
    esac
    [[ "${FINDINGS}" -eq 0 ]] || exit "${EXIT_FINDING}"
}

main "$@"
