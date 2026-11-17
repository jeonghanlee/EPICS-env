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
# Run an IOC startup file through the installed softIocPVX, loading the
# installed modules that the startup file names with the wrapper directives
# m, mod, and module. Each directive carries a module name and an optional
# exact version. The wrapper resolves every requested module and its
# recorded dependencies from the installed metadata cfg/iocsh.conf, compares
# each metadata file with the digest recorded at its generation, rejects
# conflicting versions and dependency cycles, inspects the ELF dependencies of the native
# executable and the selected libraries through iocsh_elf.bash, compares
# the GNU build-id of every module library it will load with the build
# record cfg/build-record of the owning module, generates the
# support-loading commands, and replaces itself with the native executable
# through exec.
#
# Exit status: 64 when the command line is wrong, 78 when the wrapper
# refuses the start before the native executable runs, 0 after --show or
# --help; otherwise the exit status of the native executable. --show ends
# with the status that a start would have up to the exec.
#
# The native executable receives the generated startup as /dev/fd/3 and the
# caller's startup file, with each directive line replaced by a comment, as
# /dev/fd/4. Line numbers in native diagnostics therefore match the original
# file; the wrapper prints the descriptor mapping before starting.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly SOFTIOC_NAME="softIocPVX"
readonly NATIVE_MODULE="pvxs"
readonly CONF_FILE="cfg/iocsh.conf"
readonly DIGEST_FILE="cfg/iocsh.conf.sha256"
readonly ELF_TOOL_NAME="iocsh_elf.bash"
readonly RECORD_FILE="cfg/build-record"
readonly RECORD_DIGEST_FILE="cfg/build-record.sha256"
readonly FORMAT_VERSION="1"
readonly BUILDID_NONE="none"
readonly LOADER_DEBUG_VALUE="libs"
readonly EXIT_USAGE=64
readonly EXIT_REFUSED=78
readonly NAME_PATTERN='[A-Za-z][A-Za-z0-9_-]*'
readonly VERSION_PATTERN='[A-Za-z0-9][A-Za-z0-9._+-]*'

declare -g ENVIRONMENT=""
declare -g SHOW="NO"
declare -g STARTUP=""
declare -g STARTUP_NAME=""
declare -g BASE_VERSION=""
declare -g SOFTIOC=""
declare -g SOFTIOC_DBD=""
declare -g NATIVE_DIR=""
declare -g NATIVE_VERSION=""
declare -a IOC_ARGS=()
declare -a REQUESTS=()
declare -a COPY_LINES=()
declare -a LOAD_ORDER=()
declare -a IOC_COMMANDS=()
declare -a ELF_REPORT=()
declare -a COMPARED_FILES=()
declare -g LOADER_DEBUG="NO"

# Resolution tables keyed by installed module name. A module appears once;
# SELECTED_SOURCE records where its version was decided, as a startup
# location or as a dependency chain.
declare -A SELECTED_VERSION=()
declare -A SELECTED_DIR=()
declare -A SELECTED_SOURCE=()
declare -A MODULE_STATE=()
declare -A MODULE_LIBS=()
declare -A MODULE_DBDS=()
declare -A MODULE_MACRO=()
declare -A MODULE_DEPS=()

# Build record tables: the record format of each selected module directory,
# the recorded build-id keyed by directory name and path inside it, and the
# build-id note of each compared file for the show mode.
declare -A RECORD_FORMAT=()
declare -A RECORD_BUILDID=()
declare -A BUILDID_NOTE=()

function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit "${EXIT_REFUSED}"
}

function die_usage {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    exit "${EXIT_USAGE}"
}

function die_at {
    local line="$1"
    local message="$2"

    printf '%s: %s:%s: %s\n' "${SCRIPT_NAME}" "${STARTUP_NAME}" "${line}" "${message}" >&2
    exit "${EXIT_REFUSED}"
}

function usage {
    printf '%s\n' \
        "Usage: ${SCRIPT_NAME} [options] [--] [st.cmd]" \
        '' \
        '  -e, --environment TREE  Source TREE/setEpicsEnv.bash before startup.' \
        '  -n, --show              Print the generated startup and exit.' \
        '  -S, --non-interactive   Disable the interactive IOC shell.' \
        '  -v, --verbose           Display softIocPVX startup commands.' \
        '  -l, --loader-debug      Show the library search of the dynamic loader' \
        '                          for the IOC process (LD_DEBUG=libs).' \
        '  -h, --help              Print this help and exit.' \
        '' \
        'Without --environment, use the EPICS environment already selected.' \
        'Name the installed modules in the startup file with one directive per' \
        'line: module NAME, module NAME VERSION, or module("NAME", "VERSION");' \
        'mod and m are accepted in place of module. An omitted version follows' \
        'the installed default link; a version selects that exact installation.' \
        'The wrapper loads each module and its recorded dependencies once, sets' \
        'one environment macro per module, registers the support, then runs the' \
        'remaining startup commands. Without a startup file or -S, open' \
        'softIocPVX for interactive configuration.'
}

function require_command {
    local name="$1"
    local path=""

    if ! path=$(command -v "${name}"); then
        die "Cannot find required command: ${name}"
    fi
    [[ -x "${path}" ]] || die "Required command is not executable: ${path}"
}

function quote_iocsh {
    local value="$1"

    value="${value//\\/\\\\}"
    value="${value//\$/\\\$}"
    value="${value//\"/\\\"}"
    printf -v "$2" '"%s"' "${value}"
}

function canonical_directory {
    local path="$1"
    local resolved=""

    if ! resolved=$(readlink -e -- "${path}"); then
        return 1
    fi
    [[ -d "${resolved}" ]] || return 1
    printf '%s' "${resolved}"
}

function read_base_version {
    local header="${EPICS_BASE}/include/epicsVersion.h"
    local line=""

    [[ -r "${header}" ]] || die "Cannot read the installed Base version: ${header}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        if [[ "${line}" =~ ^[[:space:]]*#define[[:space:]]+EPICS_VERSION_SHORT[[:space:]]+\"([^\"]+)\" ]]; then
            printf '%s' "${BASH_REMATCH[1]}"
            return 0
        fi
    done < "${header}"
    die "EPICS_VERSION_SHORT is not defined in ${header}"
}

function locate_native {
    local link="${EPICS_MODULES}/${NATIVE_MODULE}"

    if ! NATIVE_DIR=$(canonical_directory "${link}"); then
        die "Cannot resolve the ${NATIVE_MODULE} module link: ${link}"
    fi
    [[ "${NATIVE_DIR##*/}" == "${NATIVE_MODULE}-"* ]] || die "Unexpected ${NATIVE_MODULE} directory name: ${NATIVE_DIR}"
    NATIVE_VERSION="${NATIVE_DIR##*/"${NATIVE_MODULE}"-}"
    SOFTIOC="${NATIVE_DIR}/bin/${EPICS_HOST_ARCH}/${SOFTIOC_NAME}"
    [[ -x "${SOFTIOC}" ]] || die "Cannot execute ${SOFTIOC}"
    SOFTIOC_DBD="${NATIVE_DIR}/dbd/${SOFTIOC_NAME}.dbd"
    [[ -s "${SOFTIOC_DBD}" ]] || die "Cannot read the IOC DBD: ${SOFTIOC_DBD}"
}

# Classifies one startup line. A directive line yields NAME and VERSION
# through the two named variables and returns 0; an ordinary line returns 1;
# a line that starts like a directive but matches none of the six forms is
# an error at that line.
function parse_directive {
    local line="$1"
    local number="$2"
    # Both namerefs return the parsed arguments to the caller.
    # shellcheck disable=SC2034
    local -n out_name="$3"
    # shellcheck disable=SC2034
    local -n out_version="$4"
    local body="${line#"${line%%[![:space:]]*}"}"
    local tail='[[:space:]]*(#.*)?$'

    [[ "${body}" =~ ^(m|mod|module)([[:space:]]|\(|$) ]] || return 1
    # shellcheck disable=SC2034
    if [[ "${body}" =~ ^(m|mod|module)[[:space:]]+(${NAME_PATTERN})${tail} ]]; then
        out_name="${BASH_REMATCH[2]}"
        out_version=""
    elif [[ "${body}" =~ ^(m|mod|module)[[:space:]]+\"(${NAME_PATTERN})\"${tail} ]]; then
        out_name="${BASH_REMATCH[2]}"
        out_version=""
    elif [[ "${body}" =~ ^(m|mod|module)[[:space:]]+(${NAME_PATTERN})[[:space:]]+(${VERSION_PATTERN})${tail} ]]; then
        out_name="${BASH_REMATCH[2]}"
        out_version="${BASH_REMATCH[3]}"
    elif [[ "${body}" =~ ^(m|mod|module)[[:space:]]+\"(${NAME_PATTERN})\"[[:space:]]+\"(${VERSION_PATTERN})\"${tail} ]]; then
        out_name="${BASH_REMATCH[2]}"
        out_version="${BASH_REMATCH[3]}"
    elif [[ "${body}" =~ ^(m|mod|module)[[:space:]]*\([[:space:]]*\"(${NAME_PATTERN})\"[[:space:]]*\)${tail} ]]; then
        out_name="${BASH_REMATCH[2]}"
        out_version=""
    elif [[ "${body}" =~ ^(m|mod|module)[[:space:]]*\([[:space:]]*\"(${NAME_PATTERN})\"[[:space:]]*,[[:space:]]*\"(${VERSION_PATTERN})\"[[:space:]]*\)${tail} ]]; then
        out_name="${BASH_REMATCH[2]}"
        out_version="${BASH_REMATCH[3]}"
    else
        die_at "${number}" "Malformed module directive: ${body}. Use module NAME, module NAME VERSION, or module(\"NAME\", \"VERSION\"), with quotes on both arguments or neither."
    fi
    return 0
}

# Reads the startup file once, collecting directives with their line numbers
# and building the line-preserving copy that the native executable runs.
function read_startup {
    local line=""
    local name=""
    local version=""
    local number=0

    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        number=$((number + 1))
        if parse_directive "${line}" "${number}" name version; then
            REQUESTS+=("${number}|${name}|${version}")
            COPY_LINES+=("# ${SCRIPT_NAME}: ${line}")
        else
            COPY_LINES+=("${line}")
        fi
    done < "${STARTUP}"
}

# Confirms that the metadata of a module still has the digest recorded at
# its generation, so a file edited afterwards is not followed.
function verify_digest {
    local name="$1"
    local version="$2"
    local directory="$3"
    local conf="${directory}/${CONF_FILE}"
    local digest_file="${directory}/${DIGEST_FILE}"
    local recorded=""
    local computed=""

    [[ -s "${digest_file}" ]] || die "Module ${name} ${version} has no metadata digest: ${digest_file}. Regenerate the metadata with make install.<module> in the EPICS-env checkout that built this tree."
    IFS= read -r recorded < "${digest_file}" || true
    recorded="${recorded//$'\r'/}"
    computed=$(sha256sum -- "${conf}") || die "Cannot digest the metadata: ${conf}"
    [[ "${recorded}" == "${computed%% *}" ]] || die "Metadata of ${name} ${version} was changed after its generation: ${conf} does not match ${digest_file}. Regenerate it with make install.<module> in the EPICS-env checkout that built this tree."
}

# Reads one module's installed metadata and checks it against the selected
# tree, the running architecture, and the requested identity.
function read_metadata {
    local name="$1"
    local version="$2"
    local directory="$3"
    local conf="${directory}/${CONF_FILE}"
    local line=""
    local key=""
    local value=""
    local libs=""
    local dbds=""
    local deps=""
    local macro=""
    local -A scalars=()
    local -A seen_entries=()

    [[ -s "${conf}" ]] || die "Module ${name} ${version} has no loader metadata: ${conf}. Install it with the metadata-generating rules of this distribution."
    verify_digest "${name}" "${version}" "${directory}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        [[ -n "${line}" && "${line}" != \#* ]] || continue
        [[ "${line}" == *=* ]] || die "Malformed metadata line in ${conf}: ${line}"
        key="${line%%=*}"
        value="${line#*=}"
        case "${key}" in
            format|name|version|base|arch) scalars["${key}"]="${value}" ;;
            macro) macro="${value}" ;;
            lib|dbd)
                [[ "${value}" =~ ^${key}/[A-Za-z0-9_./+-]+$ && "${value}" != *..* ]] || die "Metadata ${conf} has an entry outside the module's ${key} directory: ${value}"
                [[ -z "${seen_entries[${key}=${value}]:-}" ]] || die "Metadata ${conf} repeats the entry ${key}=${value}"
                seen_entries["${key}=${value}"]=1
                if [[ "${key}" == "lib" ]]; then
                    libs="${libs}${libs:+ }${value}"
                else
                    dbds="${dbds}${dbds:+ }${value}"
                fi
                ;;
            dep)
                [[ "${value}" =~ ^(${NAME_PATTERN})\ (${VERSION_PATTERN})$ ]] || die "Malformed dependency in ${conf}: ${value}"
                deps="${deps}${deps:+;}${value}"
                ;;
            *) die "Unknown metadata key in ${conf}: ${key}" ;;
        esac
    done < "${conf}"
    [[ "${scalars[format]:-}" == "${FORMAT_VERSION}" ]] || die "Unsupported metadata format in ${conf}: ${scalars[format]:-missing} (this wrapper reads format ${FORMAT_VERSION})"
    [[ "${scalars[name]:-}" == "${name}" ]] || die "Metadata ${conf} names module ${scalars[name]:-?}, not ${name}"
    [[ "${scalars[version]:-}" == "${version}" ]] || die "Metadata ${conf} records version ${scalars[version]:-?}, not ${version}"
    [[ "${scalars[arch]:-}" == "${EPICS_HOST_ARCH}" ]] || die "Module ${name} ${version} is built for ${scalars[arch]:-?}, not ${EPICS_HOST_ARCH}"
    [[ "${scalars[base]:-}" == "${BASE_VERSION}" ]] || die "Module ${name} ${version} is built against Base ${scalars[base]:-?}, not the selected Base ${BASE_VERSION}"
    [[ "${macro}" =~ ^[A-Z][A-Z0-9_]*$ ]] || die "Metadata ${conf} has no valid macro name"
    MODULE_LIBS["${name}"]="${libs}"
    MODULE_DBDS["${name}"]="${dbds}"
    MODULE_MACRO["${name}"]="${macro}"
    MODULE_DEPS["${name}"]="${deps}"
}

function conflict {
    local name="$1"
    local requested="$2"
    local requested_source="$3"

    printf '%s: Module version conflict: %s\n' "${SCRIPT_NAME}" "${name}" >&2
    printf 'Requested: %s at %s\n' "${requested}" "${requested_source}" >&2
    printf 'Selected:  %s at %s\n' "${SELECTED_VERSION[${name}]}" "${SELECTED_SOURCE[${name}]}" >&2
    printf 'Use one version of %s in this IOC.\n' "${name}" >&2
    exit "${EXIT_REFUSED}"
}

# Selects one module version, resolves its directory and metadata, then
# selects its recorded dependencies before placing it in the load order. A
# module met again while its own dependencies are being selected is a cycle;
# that test precedes the shortcut for an already selected module.
function select_module {
    local name="$1"
    local version="$2"
    local source="$3"
    local link=""
    local directory=""
    local dep=""
    local -a deps=()

    [[ -n "${version}" ]] || version=$(default_version "${name}" "${source}")
    case "${MODULE_STATE[${name}]:-}" in
        loading) die "Dependency cycle at ${name} (${source})" ;;
    esac
    if [[ -n "${SELECTED_VERSION[${name}]:-}" ]]; then
        [[ "${version}" == "${SELECTED_VERSION[${name}]}" ]] || conflict "${name}" "${version}" "${source}"
        return 0
    fi
    if [[ "${version}" == "$(default_version "${name}" 2>/dev/null || true)" ]]; then
        link="${EPICS_MODULES}/${name}"
        directory=$(canonical_directory "${link}")
    else
        link="${EPICS_MODULES}/${name}-${version}"
        if ! directory=$(canonical_directory "${link}"); then
            die "Module ${name} ${version} is not installed under ${EPICS_MODULES} (${source})"
        fi
    fi
    if [[ "${name}" == "${NATIVE_MODULE}" ]]; then
        [[ "${version}" == "${NATIVE_VERSION}" ]] || die "Module ${name} ${version} is requested at ${source}, but the native ${SOFTIOC_NAME} already provides ${name} ${NATIVE_VERSION}; use the native version or select another installation"
    fi
    MODULE_STATE["${name}"]=loading
    SELECTED_VERSION["${name}"]="${version}"
    SELECTED_DIR["${name}"]="${directory}"
    SELECTED_SOURCE["${name}"]="${source}"
    read_metadata "${name}" "${version}" "${directory}"
    if [[ -n "${MODULE_DEPS[${name}]}" ]]; then
        IFS=';' read -r -a deps <<< "${MODULE_DEPS[${name}]}"
        for dep in "${deps[@]}"; do
            select_module "${dep%% *}" "${dep#* }" "${name} ${version} (${source})"
        done
    fi
    MODULE_STATE["${name}"]=loaded
    LOAD_ORDER+=("${name}")
}

# Resolves the installed default link of a module to its version string.
function default_version {
    local name="$1"
    local source="${2:-}"
    local link="${EPICS_MODULES}/${name}"
    local directory=""
    local location=""

    [[ -z "${source}" ]] || location=" (${source})"
    [[ -L "${link}" ]] || die "Module ${name} has no installed default link: ${link}${location}"
    if ! directory=$(canonical_directory "${link}"); then
        die "Module ${name} has a broken default link: ${link}${location}"
    fi
    [[ "${directory##*/}" == "${name}-"* ]] || die "Default link ${link} does not point at a versioned ${name} directory: ${directory}${location}"
    printf '%s' "${directory##*/"${name}"-}"
}

function resolve_requests {
    local request=""
    local number=""
    local name=""
    local version=""

    for request in "${REQUESTS[@]}"; do
        number="${request%%|*}"
        request="${request#*|}"
        name="${request%%|*}"
        version="${request#*|}"
        select_module "${name}" "${version}" "${STARTUP_NAME}:${number}"
    done
}

# Inspects the ELF dependencies of the native executable and of every
# selected library in load order. A dependency that resolves into an
# installed module directory must belong to a selected version; the report
# of resolved files is kept for the show mode. The inspection is static and
# does not prove what the native loader binds.
function inspect_elf {
    local tool="${BASH_SOURCE[0]%/*}/${ELF_TOOL_NAME}"
    local name=""
    local entry=""
    local output=""
    local status=0
    local -a entries=()
    local -a arguments=()

    [[ "${BASH_SOURCE[0]}" == */* ]] || tool="./${ELF_TOOL_NAME}"
    [[ -s "${tool}" ]] || die "Cannot find the ELF inspection tool beside the wrapper: ${tool}"
    arguments=(--base "${EPICS_BASE}" --modules "${EPICS_MODULES}" --vendor "${EPICS_MODULES%/}/../vendor")
    arguments+=(--select "${NATIVE_MODULE}=${NATIVE_DIR}" --object "${SOFTIOC}")
    for name in "${LOAD_ORDER[@]}"; do
        [[ "${name}" != "${NATIVE_MODULE}" ]] || continue
        arguments+=(--select "${name}=${SELECTED_DIR[${name}]}")
        read -r -a entries <<< "${MODULE_LIBS[${name}]}" || true
        for entry in "${entries[@]}"; do
            arguments+=(--object "${SELECTED_DIR[${name}]}/${entry}")
        done
    done
    output=$(bash "${tool}" inspect "${arguments[@]}") || status=$?
    case "${status}" in
        0) ;;
        1) die "ELF inspection refused a selected or needed library; see the messages above." ;;
        *) die "ELF inspection could not run; see the messages above." ;;
    esac
    [[ -z "${output}" ]] || mapfile -t ELF_REPORT <<< "${output}"
}

# Reads the build record of one selected module directory: its format
# number and, for format 2, the build-id of each recorded library, keyed by
# the directory name and the path inside it. A record of format 1 carries
# no build-id and has no digest file, so a record that claims format 1 beside
# a digest file is refused. A record of format 2 is compared with its digest
# file before it is used, and a module directory without a record is
# refused. The format numbers this reader knows are the branches of the case
# below.
function read_build_record {
    local name="$1"
    local version="$2"
    local directory="$3"
    local owner="${directory##*/}"
    local record="${directory}/${RECORD_FILE}"
    local digest_file="${directory}/${RECORD_DIGEST_FILE}"
    local remedy="Write it again with make build.<module> in the EPICS-env checkout that built this tree."
    local line=""
    local key=""
    local value=""
    local format=""
    local recorded=""
    local computed=""

    [[ -z "${RECORD_FORMAT[${owner}]:-}" ]] || return 0
    [[ -s "${record}" ]] || die "Module ${name} ${version} has no build record: ${record}. ${remedy}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        if [[ "${line}" == format=* ]]; then
            format="${line#format=}"
            break
        fi
    done < "${record}"
    case "${format}" in
        1)
            [[ ! -e "${digest_file}" ]] || die "Build record of ${name} ${version} claims format 1 beside a digest file, which only format 2 has: ${record}. ${remedy}"
            RECORD_FORMAT["${owner}"]=1
            return 0
            ;;
        2) ;;
        *) die "Unsupported build record format in ${record}: ${format:-missing} (this wrapper reads formats 1 and 2)" ;;
    esac
    [[ -s "${digest_file}" ]] || die "Module ${name} ${version} has no build record digest: ${digest_file}. ${remedy}"
    IFS= read -r recorded < "${digest_file}" || true
    recorded="${recorded//$'\r'/}"
    computed=$(sha256sum -- "${record}") || die "Cannot digest the build record: ${record}"
    [[ "${recorded}" == "${computed%% *}" ]] || die "Build record of ${name} ${version} was changed after it was written: ${record} does not match ${digest_file}. ${remedy}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        [[ -n "${line}" && "${line}" != \#* ]] || continue
        [[ "${line}" == *=* ]] || die "Malformed build record line in ${record}: ${line}"
        key="${line%%=*}"
        value="${line#*=}"
        case "${key}" in
            format|tag|source|base|arch|dep|artifact) ;;
            name) [[ "${value}" == "${name}" ]] || die "Build record ${record} names module ${value}, not ${name}" ;;
            version) [[ "${value}" == "${version}" ]] || die "Build record ${record} records version ${value}, not ${version}" ;;
            buildid)
                [[ "${value}" =~ ^(lib/[A-Za-z0-9_./+-]+)\ ([0-9a-f]+|${BUILDID_NONE})$ && "${value}" != *..* ]] || die "Malformed build-id entry in ${record}: ${value}"
                RECORD_BUILDID["${owner}/${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
                ;;
            *) die "Unknown build record key in ${record}: ${key}" ;;
        esac
    done < "${record}"
    RECORD_FORMAT["${owner}"]=2
}

# Compares the GNU build-id of every module library the IOC will load with
# the build record of the module that owns it. The compared set is the
# union of the libraries loaded with dlload and the resolved dependency
# files of class module, each canonical file once. A build-id that differs
# from a record of format 2, or a file without a line in such a record,
# refuses the start with one summary line and one line per file. A module
# whose record is format 1 is not compared; its files are marked for the
# show mode.
function compare_build_ids {
    local tool="${BASH_SOURCE[0]%/*}/${ELF_TOOL_NAME}"
    local name=""
    local entry=""
    local line=""
    local class=""
    local owner=""
    local file=""
    local relative=""
    local id=""
    local recorded=""
    local output=""
    local index=0
    local -a entries=()
    local -a files=()
    local -a owners=()
    local -a arguments=()
    local -a errors=()
    local -A seen=()

    [[ "${BASH_SOURCE[0]}" == */* ]] || tool="./${ELF_TOOL_NAME}"
    read_build_record "${NATIVE_MODULE}" "${NATIVE_VERSION}" "${NATIVE_DIR}"
    for name in "${LOAD_ORDER[@]}"; do
        [[ "${name}" != "${NATIVE_MODULE}" ]] || continue
        read_build_record "${name}" "${SELECTED_VERSION[${name}]}" "${SELECTED_DIR[${name}]}"
        read -r -a entries <<< "${MODULE_LIBS[${name}]}" || true
        for entry in "${entries[@]}"; do
            if ! file=$(readlink -e -- "${SELECTED_DIR[${name}]}/${entry}"); then
                die "Library of ${name} ${SELECTED_VERSION[${name}]} is missing: ${SELECTED_DIR[${name}]}/${entry}"
            fi
            [[ -z "${seen[${file}]:-}" ]] || continue
            seen["${file}"]=1
            files+=("${file}")
            owners+=("${SELECTED_DIR[${name}]##*/}")
        done
    done
    for line in "${ELF_REPORT[@]}"; do
        IFS=$'\t' read -r class owner file _ <<< "${line}"
        [[ "${class}" == "module" && -z "${seen[${file}]:-}" ]] || continue
        seen["${file}"]=1
        files+=("${file}")
        owners+=("${owner}")
    done
    [[ ${#files[@]} -gt 0 ]] || return 0

    for file in "${files[@]}"; do
        arguments+=(--object "${file}")
    done
    output=$(bash "${tool}" buildid "${arguments[@]}") || die "Cannot read the build-ids of the module libraries; see the messages above."
    while IFS=$'\t' read -r id file; do
        [[ -n "${file}" ]] || continue
        owner="${owners[${index}]}"
        index=$((index + 1))
        relative="${file##*/"${owner}"/}"
        COMPARED_FILES+=("${owner}"$'\t'"${file}")
        case "${RECORD_FORMAT[${owner}]:-}" in
            1) BUILDID_NOTE["${file}"]="buildid ${id} not recorded" ;;
            2)
                BUILDID_NOTE["${file}"]="buildid ${id}"
                recorded="${RECORD_BUILDID[${owner}/${relative}]:-}"
                if [[ -z "${recorded}" ]]; then
                    errors+=("${owner} ${relative} has no build-id in ${RECORD_FILE}")
                elif [[ "${recorded}" != "${id}" ]]; then
                    errors+=("${owner} ${relative} build-id ${id} recorded ${recorded}")
                fi
                ;;
            *) die "Module library ${file} belongs to ${owner}, whose build record was not read" ;;
        esac
    done <<< "${output}"
    [[ ${#errors[@]} -gt 0 ]] || return 0
    printf '%s: ERROR: %d of %d module libraries differ from their build record\n' "${SCRIPT_NAME}" "${#errors[@]}" "${#files[@]}" >&2
    for line in "${errors[@]}"; do
        printf '%s: ERROR: %s\n' "${SCRIPT_NAME}" "${line}" >&2
    done
    exit "${EXIT_REFUSED}"
}

# Generates the native startup: support loading in dependency order, one
# macro per selected module, one registration call, then the caller's file.
function generate_commands {
    local name=""
    local entry=""
    local directory=""
    local path=""
    local quoted=""
    local quoted_includes=""
    local includes=""
    local -a entries=()
    local -a loaded_dbd_dirs=()

    IOC_COMMANDS=("on error break")
    for name in "${LOAD_ORDER[@]}"; do
        directory="${SELECTED_DIR[${name}]}"
        if [[ "${name}" == "${NATIVE_MODULE}" ]]; then
            IOC_COMMANDS+=("# ${name} ${SELECTED_VERSION[${name}]} is native to ${SOFTIOC_NAME}")
            continue
        fi
        IOC_COMMANDS+=("# ${name} ${SELECTED_VERSION[${name}]}")
        read -r -a entries <<< "${MODULE_LIBS[${name}]}" || true
        for entry in "${entries[@]}"; do
            path="${directory}/${entry}"
            [[ -s "${path}" ]] || die "Library of ${name} ${SELECTED_VERSION[${name}]} is missing: ${path}"
            quote_iocsh "${path}" quoted
            IOC_COMMANDS+=("dlload(${quoted})")
        done
        read -r -a entries <<< "${MODULE_DBDS[${name}]}" || true
        if [[ ${#entries[@]} -gt 0 ]]; then
            includes="${directory}/dbd"
            for path in "${loaded_dbd_dirs[@]}"; do
                includes="${includes}:${path}"
            done
            includes="${includes}:${EPICS_BASE}/dbd:${NATIVE_DIR}/dbd"
            quote_iocsh "${includes}" quoted_includes
            for entry in "${entries[@]}"; do
                path="${directory}/${entry}"
                [[ -s "${path}" ]] || die "DBD of ${name} ${SELECTED_VERSION[${name}]} is missing: ${path}"
                quote_iocsh "${path}" quoted
                IOC_COMMANDS+=("dbLoadDatabase(${quoted}, ${quoted_includes}, \"\")")
            done
            loaded_dbd_dirs+=("${directory}/dbd")
        fi
    done
    for name in "${LOAD_ORDER[@]}"; do
        quote_iocsh "${SELECTED_DIR[${name}]}" quoted
        IOC_COMMANDS+=("epicsEnvSet(\"${MODULE_MACRO[${name}]}\", ${quoted})")
    done
    IOC_COMMANDS+=("registerAllRecordDeviceDrivers(pdbbase)")
    IOC_COMMANDS+=("iocshLoad(\"/dev/fd/4\")")
}

function show_commands {
    local command=""

    local line=""
    local class=""
    local owner=""
    local file=""
    local -A seen=()

    printf '# %s: generated startup for %s (runs as /dev/fd/3)\n' "${SCRIPT_NAME}" "${STARTUP}"
    printf '# %s: static ELF inspection of %d dependency edges; resolved files as class, owner, file\n' "${SCRIPT_NAME}" "${#ELF_REPORT[@]}"
    for line in "${ELF_REPORT[@]}"; do
        IFS=$'\t' read -r class owner file _ <<< "${line}"
        [[ -z "${seen[${file}]:-}" ]] || continue
        seen["${file}"]=1
        printf '# elf: %s %s %s%s\n' "${class}" "${owner}" "${file}" "${BUILDID_NOTE[${file}]:+ ${BUILDID_NOTE[${file}]}}"
    done
    # A library that the wrapper loads and that no object depends on is no
    # resolved dependency; it is listed here in the same form.
    for line in "${COMPARED_FILES[@]}"; do
        IFS=$'\t' read -r owner file <<< "${line}"
        [[ -z "${seen[${file}]:-}" ]] || continue
        seen["${file}"]=1
        printf '# elf: module %s %s%s\n' "${owner}" "${file}" "${BUILDID_NOTE[${file}]:+ ${BUILDID_NOTE[${file}]}}"
    done
    for command in "${IOC_COMMANDS[@]}"; do
        printf '%s\n' "${command}"
    done
    printf '# %s: %s runs as /dev/fd/4 with %d lines, directives replaced by comments\n' "${SCRIPT_NAME}" "${STARTUP}" "${#COPY_LINES[@]}"
}

# Replaces the wrapper with the native executable. With the loader option
# the dynamic loader reports its library search for that process; the
# programs the wrapper ran before did not see the variable. A process that
# the native executable starts inherits the variable and reports under its
# own process number, so the number of the IOC process is announced first.
function start_ioc {
    if [[ "${LOADER_DEBUG}" == "YES" ]]; then
        printf '%s: loader lines of the IOC process start with %s:\n' "${SCRIPT_NAME}" "$$" >&2
        LD_DEBUG="${LOADER_DEBUG_VALUE}" exec "$@"
    fi
    exec "$@"
}

function main {
    local setup_script=""
    local prepared_startup=""
    local copy_file=""
    local -a inputs=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e|--environment)
                [[ $# -ge 2 && -n "$2" ]] || die_usage 'Missing tree for --environment.'
                ENVIRONMENT="$2"
                shift
                ;;
            -n|--show) SHOW="YES" ;;
            -S|--non-interactive) IOC_ARGS+=(-S) ;;
            -v|--verbose) IOC_ARGS+=(-v) ;;
            -l|--loader-debug) LOADER_DEBUG="YES" ;;
            -h|--help) usage; return 0 ;;
            --) shift; inputs+=("$@"); break ;;
            -*) die_usage "Unknown option: $1" ;;
            *) inputs+=("$1") ;;
        esac
        shift
    done
    [[ ${#inputs[@]} -le 1 ]] || die_usage 'Specify at most one IOC startup file.'
    if [[ ${#inputs[@]} -eq 1 ]]; then
        STARTUP="${inputs[0]}"
        [[ -f "${STARTUP}" && -r "${STARTUP}" ]] || die "Cannot read startup file: ${STARTUP}"
        [[ "${STARTUP}" == /* ]] || STARTUP="${PWD}/${STARTUP}"
        STARTUP_NAME="${STARTUP##*/}"
    fi
    [[ "${SHOW}" == "NO" || -n "${STARTUP}" ]] || die_usage '--show needs a startup file.'

    if [[ -n "${ENVIRONMENT}" ]]; then
        setup_script="${ENVIRONMENT}/setEpicsEnv.bash"
        [[ -f "${setup_script}" && -r "${setup_script}" ]] || die "Cannot read environment setup: ${setup_script}"
        set +u
        # The setup script prints notices; they stay out of the wrapper output.
        # shellcheck source=/dev/null
        source "${setup_script}" disable > /dev/null
        set -u
    fi
    if [[ -z "${EPICS_BASE:-}" || -z "${EPICS_MODULES:-}" || -z "${EPICS_HOST_ARCH:-}" ]]; then
        die 'Source setEpicsEnv.bash first, or select a tree with --environment.'
    fi
    [[ -d "${EPICS_BASE}" ]] || die "EPICS_BASE is not a directory: ${EPICS_BASE}"
    [[ -d "${EPICS_MODULES}" ]] || die "EPICS_MODULES is not a directory: ${EPICS_MODULES}"
    require_command readlink
    require_command sha256sum
    BASE_VERSION=$(read_base_version)
    locate_native

    if [[ -z "${STARTUP}" ]]; then
        start_ioc "${SOFTIOC}" -D "${SOFTIOC_DBD}" "${IOC_ARGS[@]}"
    fi
    read_startup
    if [[ ${#REQUESTS[@]} -eq 0 ]]; then
        if [[ "${SHOW}" == "YES" ]]; then
            printf '# %s: no module directive in %s; the file runs unchanged\n' "${SCRIPT_NAME}" "${STARTUP}"
            return 0
        fi
        export IOCSH_STARTUP_SCRIPT="${IOCSH_STARTUP_SCRIPT-${STARTUP}}"
        start_ioc "${SOFTIOC}" -D "${SOFTIOC_DBD}" "${IOC_ARGS[@]}" "${STARTUP}"
    fi
    resolve_requests
    inspect_elf
    compare_build_ids
    generate_commands
    if [[ "${SHOW}" == "YES" ]]; then
        show_commands
        return 0
    fi

    require_command mktemp
    copy_file=$(mktemp "${TMPDIR:-/tmp}/${SCRIPT_NAME}.XXXXXX") || die 'Cannot create the startup copy.'
    printf '%s\n' "${COPY_LINES[@]}" > "${copy_file}" || die "Cannot write the startup copy: ${copy_file}"
    exec 4< "${copy_file}"
    rm -f -- "${copy_file}"
    printf -v prepared_startup '%s\n' "${IOC_COMMANDS[@]}"
    exec 3<<< "${prepared_startup}"
    export IOCSH_STARTUP_SCRIPT="${IOCSH_STARTUP_SCRIPT-${STARTUP}}"
    printf '%s: %s runs as /dev/fd/4; generated startup runs as /dev/fd/3\n' "${SCRIPT_NAME}" "${STARTUP}" >&2
    start_ioc "${SOFTIOC}" -D "${SOFTIOC_DBD}" "${IOC_ARGS[@]}" /dev/fd/3
}

main "$@"
