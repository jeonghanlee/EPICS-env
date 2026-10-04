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
# Record, generate, and check the installed-module metadata that the
# iocsh.bash loader reads at IOC startup.
#
#   record    Write cfg/build-record after a successful module build: the
#             effective identity, the source revision actually built, Base
#             and architecture, declared dependencies, and a SHA-256 digest
#             of every installed library and DBD file. The source checkout
#             must sit at the pinned tag, and every module path in its
#             configure/RELEASE.local or configure/RELEASE must be a
#             declared dependency version.
#   generate  Write cfg/iocsh.conf from the build record, the installed
#             inventory, and the entry mapping. The record must match the
#             effective configuration and the installed artifacts. Every
#             selected DBD must resolve its includes inside the module or
#             its dependencies, except a Base or PVXS file that carries
#             menus only; it must not define a Base menu or record type
#             with a body, and every entry must be provided by a selected,
#             dependency, Base, or PVXS library. A selected library must
#             leave no symbol undefined after its NEEDED closure, Base, and
#             its dependency modules are considered. The SHA-256 digest of
#             the written file goes beside it as cfg/iocsh.conf.sha256.
#   check     Read cfg/iocsh.conf and confirm its digest, its files, and
#             the recorded artifact digests still match the installed tree.
#
# record and generate remove an existing cfg/iocsh.conf and its digest
# before their checks, so a module whose record or generation is refused
# carries no loader metadata until a later generation succeeds.
#
# Both files are line-oriented key=value data: a repeated key is a list and
# list order is significant. Nothing in them is executed as shell code.

set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly FORMAT_VERSION="1"
readonly RECORD_FILE="cfg/build-record"
readonly CONF_FILE="cfg/iocsh.conf"
readonly DIGEST_FILE="cfg/iocsh.conf.sha256"
readonly BASE_DBD="base.dbd"
readonly PVXS_IOC_DBD="pvxsIoc.dbd"
readonly ELF_TOOL_NAME="iocsh_elf.bash"
readonly FINDING_PREVIEW=5

declare -g MODE=""
declare -g MODULE=""
declare -g INSTALL_DIR=""
declare -g VERSION=""
declare -g TAG=""
declare -g BASE_VERSION=""
declare -g BASE_DIR=""
declare -g MODULES_DIR=""
declare -g PVXS_DIR=""
declare -g SOURCE_DIR=""
declare -g MACRO=""
declare -g TARGET=""
declare -g METADATA_CLEARED="NO"
declare -g ARCH=""
declare -g LIBS=""
declare -g DBDS=""
declare -g LIBS_GIVEN="NO"
declare -g DBDS_GIVEN="NO"
declare -g VERBOSE="NO"
declare -a DEPS=()

# Scan results: Base definitions, required and provided pvar symbols, and
# the dependency closure with each member's selected library paths.
declare -A BASE_DEFINED=()
declare -A REQUIRED=()
declare -A PROVIDED=()
declare -A DEP_SEEN=()
declare -a DEP_LIB_PATHS=()
declare -a DEP_DBD_DIRS=()

# Reports a failure. Once record or generate has removed the earlier
# metadata, the report also states the resulting state of the module and
# the make target to run after the correction.
function die {
    printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    if [[ "${METADATA_CLEARED}" == "YES" ]]; then
        printf '%s: %s %s is installed without loader metadata; iocsh.bash refuses it and its unversioned link is not published until metadata generation succeeds.\n' "${SCRIPT_NAME}" "${MODULE}" "${VERSION}" >&2
        printf '%s: After the correction, run make build.%s again; when the correction changes the site configuration of the module, first run make distclean.%s and the conf target of the module, because a changed configuration alone does not relink the library. The conf target is usually conf.%s; when no such target exists, docs/src/reference/make-targets.md names it under Source configuration targets.\n' "${SCRIPT_NAME}" "${TARGET:-${MODULE}}" "${TARGET:-${MODULE}}" "${TARGET:-${MODULE}}" >&2
    fi
    exit 1
}

function note {
    if [[ "${VERBOSE}" == "YES" ]]; then
        printf '%s: %s\n' "${SCRIPT_NAME}" "$1" >&2
    fi
}

function usage {
    printf '%s\n' \
        "Usage: ${SCRIPT_NAME} record|generate|check [options]" \
        '' \
        '  --module NAME           Installed module name (seq for the sequencer)' \
        '  --install DIR           Installed module directory, modules/<name>-<version>' \
        '  --version VERSION       Effective module version (SRC_VER)' \
        '  --tag TAG               Effective source tag (SRC_TAG)' \
        '  --base-version VERSION  EPICS Base version' \
        '  --base DIR              Installed EPICS Base directory' \
        '  --modules DIR           Installed modules directory (generate)' \
        '  --pvxs DIR              Installed pvxs module directory (generate, optional)' \
        '  --source DIR            Module source checkout that was built (record)' \
        '  --macro NAME            Environment macro name for the module top (generate)' \
        '  --target NAME           Module name of the make targets, for messages' \
        '  --dep NAME=VERSION      Declared dependency; repeat per dependency' \
        '  --libs "STEM ..."       Library stems; an empty value declares library-free' \
        '  --dbds "FILE ..."       DBD file names; an empty value declares DBD-free' \
        '  -v, --verbose           Report each step' \
        '  -h, --help              Print this help and exit' \
        '' \
        'Without --libs or --dbds, generate applies the default rule' \
        'lib<name>.so with <name>.dbd under the installed module directory.' \
        'record needs --module, --install, --version, --tag, --base-version,' \
        '--base, and --source; generate needs those except --source, plus' \
        '--modules and --macro; check needs --install and --base, and compares' \
        '--module, --version, and --base-version when they are given.'
}

function require_command {
    local name="$1"
    local path=""

    if ! path=$(command -v "${name}"); then
        die "Cannot find required command: ${name}"
    fi
    [[ -x "${path}" ]] || die "Required command is not executable: ${path}"
}

function require_value {
    local option="$1"
    local value="$2"

    [[ -n "${value}" ]] || die "Missing required option: ${option}"
}

function require_directory {
    local label="$1"
    local path="$2"

    [[ -d "${path}" ]] || die "${label} is not a directory: ${path}"
}

function sha256_of {
    local file="$1"
    local digest=""

    digest=$(sha256sum -- "${file}") || die "Cannot digest file: ${file}"
    printf '%s' "${digest%% *}"
}

# Writes stdin to the target file through a temporary file in the same
# directory so a reader never sees a partial file.
function write_atomic {
    local target="$1"
    local directory="${target%/*}"
    local temp=""

    mkdir -p -- "${directory}"
    temp=$(mktemp -- "${directory}/.${target##*/}.XXXXXX") || die "Cannot create a temporary file in ${directory}"
    if ! cat > "${temp}"; then
        rm -f -- "${temp}"
        die "Cannot write ${target}"
    fi
    chmod 644 -- "${temp}"
    mv -f -- "${temp}" "${target}"
}

# Removes the loader metadata of an earlier build. A failure after this
# point leaves the module without metadata instead of with stale metadata.
function clear_metadata {
    rm -f -- "${INSTALL_DIR}/${CONF_FILE}" "${INSTALL_DIR}/${DIGEST_FILE}" || die "Cannot remove the earlier metadata under ${INSTALL_DIR}/cfg"
    METADATA_CLEARED="YES"
}

# Confirms that a generated metadata file still has the digest recorded at
# its generation.
function verify_conf_digest {
    local conf="$1"
    local digest_file="${conf}.sha256"
    local recorded=""

    [[ -s "${digest_file}" ]] || die "Metadata ${conf} has no recorded digest: ${digest_file}; regenerate it with the install target of its module"
    IFS= read -r recorded < "${digest_file}" || true
    recorded="${recorded//$'\r'/}"
    [[ "${recorded}" == "$(sha256_of "${conf}")" ]] || die "Metadata ${conf} was changed after its generation: it does not match ${digest_file}; regenerate it with the install target of its module"
}

function detect_arch {
    local perl_script="${BASE_DIR}/lib/perl/EpicsHostArch.pl"
    local sh_script="${BASE_DIR}/startup/EpicsHostArch"
    local arch=""

    if [[ -f "${perl_script}" ]]; then
        require_command perl
        arch=$(perl "${perl_script}") || die "Cannot determine the host architecture with ${perl_script}"
    elif [[ -f "${sh_script}" ]]; then
        arch=$(sh "${sh_script}") || die "Cannot determine the host architecture with ${sh_script}"
    else
        die "Cannot find EpicsHostArch.pl or EpicsHostArch under ${BASE_DIR}"
    fi
    arch="${arch//$'\r'/}"
    [[ "${arch}" =~ ^[A-Za-z0-9_.-]+$ ]] || die "Unexpected host architecture value: ${arch}"
    printf '%s' "${arch}"
}

# Lists the installed library and DBD artifacts relative to the module
# directory, sorted, one per line.
function list_artifacts {
    local lib_dir="${INSTALL_DIR}/lib/${ARCH}"
    local dbd_dir="${INSTALL_DIR}/dbd"
    local path=""

    {
        if [[ -d "${lib_dir}" ]]; then
            for path in "${lib_dir}"/*.so "${lib_dir}"/*.so.*; do
                [[ -f "${path}" ]] || continue
                printf 'lib/%s/%s\n' "${ARCH}" "${path##*/}"
            done
        fi
        if [[ -d "${dbd_dir}" ]]; then
            for path in "${dbd_dir}"/*.dbd; do
                [[ -f "${path}" ]] || continue
                printf 'dbd/%s\n' "${path##*/}"
            done
        fi
    } | LC_ALL=C sort
}

function sorted_deps {
    local dep=""

    for dep in "${DEPS[@]}"; do
        printf '%s\n' "${dep}"
    done | LC_ALL=C sort -u
}

# Prints the commit of the source checkout after confirming that it is the
# commit the pinned tag names, so a changed pin cannot relabel a build of
# another revision. The safe.directory override lets a privileged build
# read a checkout owned by the invoking user.
function read_source_commit {
    local head=""
    local pinned=""

    require_command git
    require_directory "Module source checkout" "${SOURCE_DIR}"
    if ! head=$(git -c safe.directory='*' -C "${SOURCE_DIR}" rev-parse --verify --quiet 'HEAD^{commit}'); then
        die "Cannot read the source revision of ${SOURCE_DIR}"
    fi
    if ! pinned=$(git -c safe.directory='*' -C "${SOURCE_DIR}" rev-parse --verify --quiet "${TAG}^{commit}"); then
        die "The pinned tag ${TAG} does not resolve in ${SOURCE_DIR}; fetch the source of the configured pin, then rebuild"
    fi
    [[ "${head}" == "${pinned}" ]] || die "Source checkout ${SOURCE_DIR} is at ${head}, but the pinned tag ${TAG} is ${pinned}; check out the pinned source and rebuild before recording"
    printf '%s' "${head}"
}

# Confirms that every installed-module path the build read from the source
# checkout's release files is a declared dependency at its declared version
# inside the selected tree; a module path in another tree is rejected.
function verify_source_deps {
    local modules_dir="${INSTALL_DIR%/*}"
    local file=""
    local line=""
    local value=""
    local built=""
    local dep=""
    local -A declared=()

    for dep in "${DEPS[@]}"; do
        declared["${dep%%=*}-${dep#*=}"]=1
    done
    for file in "${SOURCE_DIR}/configure/RELEASE.local" "${SOURCE_DIR}/configure/RELEASE"; do
        [[ -f "${file}" ]] || continue
        while IFS= read -r line || [[ -n "${line:-}" ]]; do
            line="${line//$'\r'/}"
            [[ "${line}" == *=* && ! "${line}" =~ ^[[:space:]]*# ]] || continue
            value="${line#*=}"
            value="${value%%#*}"
            value="${value#"${value%%[![:space:]]*}"}"
            value="${value%"${value##*[![:space:]]}"}"
            if [[ "${value}" == "${modules_dir}/"* ]]; then
                built="${value#"${modules_dir}/"}"
                built="${built%%/*}"
                [[ "${built}" != "${INSTALL_DIR##*/}" ]] || continue
                [[ -n "${declared[${built}]:-}" ]] || die "${file} builds ${MODULE} against ${built}, which is not a declared dependency version; reconfigure and rebuild, or correct the declared dependencies"
            elif [[ "${value}" =~ /modules/[^/]+/?$ ]]; then
                die "${file} builds ${MODULE} against ${value}, a module outside the selected tree ${modules_dir%/*}; reconfigure for the selected tree and rebuild"
            fi
        done < "${file}"
    done
}

function do_record {
    local artifact=""
    local dep=""
    local source_commit=""
    local -a artifacts=()
    local -a deps=()

    require_value --module "${MODULE}"
    require_value --install "${INSTALL_DIR}"
    require_value --version "${VERSION}"
    require_value --tag "${TAG}"
    require_value --base-version "${BASE_VERSION}"
    require_value --base "${BASE_DIR}"
    require_value --source "${SOURCE_DIR}"
    require_directory "Installed module directory" "${INSTALL_DIR}"
    require_directory "Installed Base directory" "${BASE_DIR}"
    require_command sha256sum
    clear_metadata
    ARCH=$(detect_arch)
    source_commit=$(read_source_commit)
    verify_source_deps

    mapfile -t artifacts < <(list_artifacts)
    mapfile -t deps < <(sorted_deps)
    {
        printf 'format=%s\n' "${FORMAT_VERSION}"
        printf 'name=%s\n' "${MODULE}"
        printf 'version=%s\n' "${VERSION}"
        printf 'tag=%s\n' "${TAG}"
        printf 'source=%s\n' "${source_commit}"
        printf 'base=%s\n' "${BASE_VERSION}"
        printf 'arch=%s\n' "${ARCH}"
        for dep in "${deps[@]}"; do
            printf 'dep=%s %s\n' "${dep%%=*}" "${dep#*=}"
        done
        for artifact in "${artifacts[@]}"; do
            printf 'artifact=%s %s\n' "${artifact}" "$(sha256_of "${INSTALL_DIR}/${artifact}")"
        done
    } | write_atomic "${INSTALL_DIR}/${RECORD_FILE}"
    note "wrote ${INSTALL_DIR}/${RECORD_FILE} with ${#artifacts[@]} artifacts"
}

# Reads a key=value file into the named associative array of scalar keys
# and the named indexed array of list entries formatted as key=value. A
# library or DBD entry must be a relative path inside the module directory
# and may appear once.
function read_data_file {
    local file="$1"
    # Both namerefs fill the caller's arrays.
    # shellcheck disable=SC2034
    local -n out_scalars="$2"
    # shellcheck disable=SC2034
    local -n out_lists="$3"
    local line=""
    local key=""
    local value=""
    local -A seen_entries=()

    [[ -s "${file}" ]] || die "Missing or empty metadata file: ${file}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        [[ -n "${line}" && "${line}" != \#* ]] || continue
        [[ "${line}" == *=* ]] || die "Malformed line in ${file}: ${line}"
        key="${line%%=*}"
        value="${line#*=}"
        # shellcheck disable=SC2034
        case "${key}" in
            lib|dbd)
                [[ "${value}" =~ ^${key}/[A-Za-z0-9_./+-]+$ && "${value}" != *..* ]] || die "Entry in ${file} is not a path inside the module's ${key} directory: ${value}"
                [[ -z "${seen_entries[${key}=${value}]:-}" ]] || die "Duplicate entry in ${file}: ${key}=${value}"
                seen_entries["${key}=${value}"]=1
                out_lists+=("${key}=${value}")
                ;;
            dep|artifact) out_lists+=("${key}=${value}") ;;
            format|name|version|tag|source|base|arch|macro) out_scalars["${key}"]="${value}" ;;
            *) die "Unknown key in ${file}: ${key}" ;;
        esac
    done < "${file}"
}

function require_scalar {
    local file="$1"
    local -n in_table="$2"
    local key="$3"
    local expected="$4"

    [[ -n "${in_table[${key}]:-}" ]] || die "Missing ${key} in ${file}"
    if [[ -n "${expected}" && "${in_table[${key}]}" != "${expected}" ]]; then
        die "Stale ${key} in ${file}: recorded ${in_table[${key}]}, effective ${expected}"
    fi
}

# Confirms that every recorded artifact still exists with its recorded
# digest and that the installed inventory gained no file since the record.
function verify_artifacts {
    local file="$1"
    local -n in_entries="$2"
    local entry=""
    local relative=""
    local recorded=""
    local artifact=""
    local -A recorded_set=()
    local -a current=()

    for entry in "${in_entries[@]}"; do
        [[ "${entry}" == artifact=* ]] || continue
        entry="${entry#artifact=}"
        relative="${entry%% *}"
        recorded="${entry#* }"
        [[ -f "${INSTALL_DIR}/${relative}" ]] || die "Recorded artifact is missing: ${INSTALL_DIR}/${relative}"
        if [[ "$(sha256_of "${INSTALL_DIR}/${relative}")" != "${recorded}" ]]; then
            die "Installed artifact differs from the build record: ${INSTALL_DIR}/${relative}"
        fi
        recorded_set["${relative}"]=1
    done
    mapfile -t current < <(list_artifacts)
    for artifact in "${current[@]}"; do
        [[ -n "${recorded_set[${artifact}]:-}" ]] || die "Installed artifact is absent from the build record: ${INSTALL_DIR}/${artifact}"
    done
    note "verified ${#recorded_set[@]} recorded artifacts against ${file}"
}

function verify_record_deps {
    local file="$1"
    local -n in_entries="$2"
    local entry=""
    local recorded=""
    local effective=""

    recorded=$(for entry in "${in_entries[@]}"; do
        [[ "${entry}" == dep=* ]] || continue
        entry="${entry#dep=}"
        printf '%s=%s\n' "${entry%% *}" "${entry#* }"
    done | LC_ALL=C sort -u)
    effective=$(sorted_deps)
    if [[ "${recorded}" != "${effective}" ]]; then
        die "Declared dependencies differ from the build record ${file}: recorded [${recorded//$'\n'/ }], effective [${effective//$'\n'/ }]"
    fi
}

# Collects provided pvar symbols from one shared library.
function collect_provided {
    local library="$1"
    local symbol=""

    [[ -f "${library}" ]] || die "Cannot read library: ${library}"
    while IFS= read -r symbol; do
        [[ -n "${symbol}" ]] || continue
        PROVIDED["${symbol}"]="${library}"
    done < <(nm -D --defined-only -- "${library}" 2>/dev/null | awk '$3 ~ /^pvar_/ { print $3 }')
}

function collect_provided_dir {
    local directory="$1"
    local library=""

    [[ -d "${directory}" ]] || return 0
    for library in "${directory}"/*.so; do
        [[ -f "${library}" ]] || continue
        collect_provided "${library}"
    done
}

# Loads a dependency's generated metadata, its selected libraries, and its
# own dependencies recursively, rejecting a cycle or a missing file.
function load_dependency {
    local name="$1"
    local version="$2"
    local directory="${MODULES_DIR}/${name}-${version}"
    local conf="${directory}/${CONF_FILE}"
    local entry=""
    local -A scalars=()
    local -a lists=()

    case "${DEP_SEEN[${name}]:-}" in
        loading) die "Dependency cycle at ${name}" ;;
        "${version}") return 0 ;;
        "") ;;
        *) die "Dependency ${name} is requested as both ${DEP_SEEN[${name}]} and ${version}" ;;
    esac
    DEP_SEEN["${name}"]=loading
    require_directory "Dependency directory" "${directory}"
    [[ -s "${conf}" ]] || die "Dependency ${name} ${version} has no generated metadata: ${conf}"
    verify_conf_digest "${conf}"
    read_data_file "${conf}" scalars lists
    require_scalar "${conf}" scalars format "${FORMAT_VERSION}"
    require_scalar "${conf}" scalars name "${name}"
    require_scalar "${conf}" scalars version "${version}"
    require_scalar "${conf}" scalars arch "${ARCH}"
    DEP_DBD_DIRS+=("${directory}/dbd")
    for entry in "${lists[@]}"; do
        case "${entry}" in
            lib=*) DEP_LIB_PATHS+=("${directory}/${entry#lib=}") ;;
            dep=*)
                entry="${entry#dep=}"
                load_dependency "${entry%% *}" "${entry#* }"
                ;;
        esac
    done
    DEP_SEEN["${name}"]="${version}"
}

# Resolves an include name through the search directories, printing the
# first match and returning 1 when none exists.
function find_include {
    local name="$1"
    shift
    local directory=""

    for directory in "$@"; do
        if [[ -f "${directory}/${name}" ]]; then
            printf '%s' "${directory}/${name}"
            return 0
        fi
    done
    return 1
}

# Tells whether a Base or PVXS DBD file, with the includes it resolves in
# the same directories, carries menu definitions only. A support record DBD
# may include such a file, since the IOC skips the repeated menu; a file
# with record types or support entries marks an application DBD.
function is_menu_only_dbd {
    local file="$1"
    local depth="$2"
    local line=""
    local resolved=""

    [[ "${depth}" -lt 32 ]] || die "DBD include nesting is too deep at ${file}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        line="${line%%#*}"
        if [[ "${line}" =~ ^[[:space:]]*include[[:space:]]+\"?([^\"[:space:]]+)\"? ]]; then
            if ! resolved=$(find_include "${BASH_REMATCH[1]}" "${file%/*}" "${BASE_DIR}/dbd" "${PVXS_DIR:+${PVXS_DIR}/dbd}"); then
                return 1
            fi
            is_menu_only_dbd "${resolved}" $((depth + 1)) || return 1
        elif [[ "${line}" =~ ^[[:space:]]*(recordtype|device|driver|registrar|function|variable|link)[[:space:]]*\( ]]; then
            return 1
        fi
    done < "${file}"
    return 0
}

# Scans one DBD file and the includes it resolves. Mode base collects the
# menu and record type definitions of Base. Mode candidate rejects a
# definition of a Base name, rejects an include of a Base or PVXS file that
# carries more than menus, and collects the symbols its entries require.
# The file name is passed on for diagnostics only; nothing writes it.
# shellcheck disable=SC2094
function scan_dbd {
    local mode="$1"
    local file="$2"
    local depth="$3"
    local line=""
    local rest=""
    local name=""
    local kind=""
    local pending=""
    local resolved=""
    local brace_depth=0
    local opens=""
    local closes=""

    [[ "${depth}" -lt 32 ]] || die "DBD include nesting is too deep at ${file}"
    [[ -f "${file}" ]] || die "Cannot read DBD file: ${file}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        [[ "${line}" != *([[:space:]])%* ]] || continue
        line="${line%%#*}"
        if [[ -n "${pending}" ]]; then
            if [[ "${line}" =~ ^[[:space:]]*\{[[:space:]]*\}[[:space:]]*$ ]]; then
                pending=""
            elif [[ "${line}" =~ ^[[:space:]]*\{ ]]; then
                record_definition "${mode}" "${file}" "${pending%% *}" "${pending#* }"
                pending=""
            else
                pending=""
            fi
        fi
        if [[ "${brace_depth}" -eq 0 ]]; then
            if [[ "${line}" =~ ^[[:space:]]*include[[:space:]]+\"?([^\"[:space:]]+)\"? ]]; then
                name="${BASH_REMATCH[1]}"
                if [[ "${mode}" == "base" ]]; then
                    if resolved=$(find_include "${name}" "${file%/*}" "${BASE_DIR}/dbd" "${PVXS_DIR:+${PVXS_DIR}/dbd}"); then
                        scan_dbd base "${resolved}" $((depth + 1))
                    else
                        die "Cannot resolve Base DBD include ${name} from ${file}"
                    fi
                else
                    if resolved=$(find_include "${name}" "${file%/*}" "${INSTALL_DIR}/dbd" "${DEP_DBD_DIRS[@]}"); then
                        scan_dbd candidate "${resolved}" $((depth + 1))
                    elif resolved=$(find_include "${name}" "${BASE_DIR}/dbd" "${PVXS_DIR:+${PVXS_DIR}/dbd}"); then
                        is_menu_only_dbd "${resolved}" 0 || die "${file} includes ${name} from Base or PVXS with record types or support entries, so it is an application DBD, not a support DBD"
                    else
                        die "Cannot resolve DBD include ${name} from ${file}"
                    fi
                fi
            elif [[ "${line}" =~ ^[[:space:]]*(menu|recordtype)[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*\)(.*)$ ]]; then
                kind="${BASH_REMATCH[1]}"
                name="${BASH_REMATCH[2]}"
                rest="${BASH_REMATCH[3]}"
                if [[ "${rest}" =~ \{[[:space:]]*\} ]]; then
                    :
                elif [[ "${rest}" == *\{* ]]; then
                    record_definition "${mode}" "${file}" "${kind}" "${name}"
                else
                    pending="${kind} ${name}"
                fi
            elif [[ "${mode}" == "candidate" ]]; then
                collect_required "${line}"
            fi
        fi
        opens="${line//[^\{]/}"
        closes="${line//[^\}]/}"
        brace_depth=$((brace_depth + ${#opens} - ${#closes}))
        [[ "${brace_depth}" -ge 0 ]] || brace_depth=0
    done < "${file}"
}

function record_definition {
    local mode="$1"
    local file="$2"
    local kind="$3"
    local name="$4"

    if [[ "${mode}" == "base" ]]; then
        BASE_DEFINED["${kind} ${name}"]="${file}"
        return 0
    fi
    if [[ -n "${BASE_DEFINED[${kind} ${name}]:-}" ]]; then
        die "${file} defines Base ${kind} ${name} with a body, so it is an expanded application DBD; declare the support DBD in configure/CONFIG_MODS_IOCSH"
    fi
    if [[ "${kind}" == "recordtype" ]]; then
        REQUIRED["pvar_rset_${name}RSET"]="${file}"
        REQUIRED["pvar_func_${name}RecordSizeOffset"]="${file}"
    fi
}

# Maps one top-level DBD entry to the pvar symbol that
# registerAllRecordDeviceDrivers resolves for it.
function collect_required {
    local line="$1"
    local type="int"

    if [[ "${line}" =~ ^[[:space:]]*device[[:space:]]*\([^,]+,[^,]+,[[:space:]]*([A-Za-z0-9_]+) ]]; then
        REQUIRED["pvar_dset_${BASH_REMATCH[1]}"]="${line}"
    elif [[ "${line}" =~ ^[[:space:]]*driver[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+) ]]; then
        REQUIRED["pvar_drvet_${BASH_REMATCH[1]}"]="${line}"
    elif [[ "${line}" =~ ^[[:space:]]*registrar[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+) ]]; then
        REQUIRED["pvar_func_${BASH_REMATCH[1]}"]="${line}"
    elif [[ "${line}" =~ ^[[:space:]]*function[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+) ]]; then
        REQUIRED["pvar_func_register_func_${BASH_REMATCH[1]}"]="${line}"
    elif [[ "${line}" =~ ^[[:space:]]*variable[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*(,[[:space:]]*([A-Za-z]+))? ]]; then
        [[ -z "${BASH_REMATCH[3]:-}" ]] || type="${BASH_REMATCH[3]}"
        REQUIRED["pvar_${type}_${BASH_REMATCH[1]}"]="${line}"
    elif [[ "${line}" =~ ^[[:space:]]*link[[:space:]]*\([^,]+,[[:space:]]*([A-Za-z0-9_]+) ]]; then
        REQUIRED["pvar_jlif_${BASH_REMATCH[1]}"]="${line}"
    fi
}

# Runs the shared ELF tool over the selected libraries with the Base and
# dependency libraries as symbol providers; nothing may stay undefined.
function verify_undefined {
    local tool="${BASH_SOURCE[0]%/*}/${ELF_TOOL_NAME}"
    local library=""
    local output=""
    local status=0
    local count=0
    local command_line=""
    local -a arguments=()
    local -a preview=()

    [[ "${BASH_SOURCE[0]}" == */* ]] || tool="./${ELF_TOOL_NAME}"
    [[ -s "${tool}" ]] || die "Cannot find the ELF inspection tool: ${tool}"
    for library in "$@"; do
        arguments+=(--object "${INSTALL_DIR}/${library}")
    done
    for library in "${BASE_DIR}/lib/${ARCH}"/*.so "${DEP_LIB_PATHS[@]}"; do
        [[ -f "${library}" ]] || continue
        arguments+=(--provider "${library}")
    done
    output=$(bash "${tool}" undefined "${arguments[@]}") || status=$?
    case "${status}" in
        0) ;;
        1)
            count=$(wc -l <<< "${output}")
            mapfile -t -n "${FINDING_PREVIEW}" preview <<< "${output}"
            printf '%s\n' "${preview[@]}" >&2
            printf -v command_line '%q ' bash "${tool}" undefined "${arguments[@]}"
            printf '%s: List every finding with: %s\n' "${SCRIPT_NAME}" "${command_line% }" >&2
            die "Libraries of ${MODULE} leave ${count} symbols or files unresolved after their NEEDED closure, Base, and the dependency modules; name the missing library on the library's link line in the module build. In this repository, add <library>_LIBS_Linux += <name> to the conf rule of the module in configure/RULES_MODS_CONFIG"
            ;;
        *) die "ELF inspection of ${MODULE} could not run" ;;
    esac
}

function do_generate {
    local record="${INSTALL_DIR}/${RECORD_FILE}"
    local base_dbd="${BASE_DIR}/dbd/${BASE_DBD}"
    local pvxs_dbd=""
    local dep=""
    local stem=""
    local dbd=""
    local library=""
    local symbol=""
    local entry=""
    local -A scalars=()
    local -a lists=()
    local -a stems=()
    local -a dbds=()
    local -a lib_paths=()
    local -a dbd_paths=()
    local -a missing=()
    local -a deps=()

    require_value --module "${MODULE}"
    require_value --install "${INSTALL_DIR}"
    require_value --version "${VERSION}"
    require_value --tag "${TAG}"
    require_value --base-version "${BASE_VERSION}"
    require_value --base "${BASE_DIR}"
    require_value --modules "${MODULES_DIR}"
    require_value --macro "${MACRO}"
    [[ "${MACRO}" =~ ^[A-Z][A-Z0-9_]*$ ]] || die "Macro name must be upper-case letters, digits, and underscores: ${MACRO}"
    require_directory "Installed module directory" "${INSTALL_DIR}"
    require_directory "Installed Base directory" "${BASE_DIR}"
    require_directory "Installed modules directory" "${MODULES_DIR}"
    # The pvxs module builds in its own turn of the dependency order, so a
    # module built before it has no pvxs directory yet; the PVXS definitions
    # and libraries then simply do not take part in the checks.
    if [[ -n "${PVXS_DIR}" && ! -d "${PVXS_DIR}" ]]; then
        note "pvxs directory ${PVXS_DIR} is not installed yet; continuing without PVXS"
        PVXS_DIR=""
    fi
    require_command sha256sum
    require_command nm
    require_command awk
    clear_metadata
    ARCH=$(detect_arch)

    read_data_file "${record}" scalars lists
    require_scalar "${record}" scalars format "${FORMAT_VERSION}"
    require_scalar "${record}" scalars name "${MODULE}"
    require_scalar "${record}" scalars version "${VERSION}"
    require_scalar "${record}" scalars tag "${TAG}"
    require_scalar "${record}" scalars source ""
    require_scalar "${record}" scalars base "${BASE_VERSION}"
    require_scalar "${record}" scalars arch "${ARCH}"
    verify_record_deps "${record}" lists
    verify_artifacts "${record}" lists

    mapfile -t deps < <(sorted_deps)
    for dep in "${deps[@]}"; do
        load_dependency "${dep%%=*}" "${dep#*=}"
    done

    if [[ "${LIBS_GIVEN}" == "YES" ]]; then
        read -r -a stems <<< "${LIBS}" || true
    else
        stems=("${MODULE}")
    fi
    if [[ "${DBDS_GIVEN}" == "YES" ]]; then
        read -r -a dbds <<< "${DBDS}" || true
    else
        dbds=("${MODULE}.dbd")
    fi
    for stem in "${stems[@]}"; do
        [[ "${stem}" =~ ^[A-Za-z0-9_.+-]+$ ]] || die "Invalid library stem: ${stem}"
        library="lib/${ARCH}/lib${stem}.so"
        [[ -s "${INSTALL_DIR}/${library}" ]] || die "Library entry for ${MODULE} is absent: ${INSTALL_DIR}/${library}; declare <module>_IOCSH_LIBS for it in configure/CONFIG_MODS_IOCSH, keyed by the source module name"
        lib_paths+=("${library}")
    done
    for dbd in "${dbds[@]}"; do
        [[ "${dbd}" =~ ^[A-Za-z0-9_.+-]+\.dbd$ ]] || die "Invalid DBD file name: ${dbd}"
        [[ -s "${INSTALL_DIR}/dbd/${dbd}" ]] || die "DBD entry for ${MODULE} is absent: ${INSTALL_DIR}/dbd/${dbd}; declare <module>_IOCSH_DBDS for it in configure/CONFIG_MODS_IOCSH, keyed by the source module name"
        dbd_paths+=("dbd/${dbd}")
    done

    [[ -s "${base_dbd}" ]] || die "Cannot read the Base DBD: ${base_dbd}"
    scan_dbd base "${base_dbd}" 0
    if [[ -n "${PVXS_DIR}" ]]; then
        pvxs_dbd="${PVXS_DIR}/dbd/${PVXS_IOC_DBD}"
        [[ ! -f "${pvxs_dbd}" ]] || scan_dbd base "${pvxs_dbd}" 0
    fi
    for dbd in "${dbd_paths[@]}"; do
        scan_dbd candidate "${INSTALL_DIR}/${dbd}" 0
    done

    for library in "${lib_paths[@]}"; do
        collect_provided "${INSTALL_DIR}/${library}"
    done
    for library in "${DEP_LIB_PATHS[@]}"; do
        collect_provided "${library}"
    done
    collect_provided_dir "${BASE_DIR}/lib/${ARCH}"
    [[ -z "${PVXS_DIR}" ]] || collect_provided_dir "${PVXS_DIR}/lib/${ARCH}"
    for symbol in "${!REQUIRED[@]}"; do
        [[ -n "${PROVIDED[${symbol}]:-}" ]] || missing+=("${symbol} (${REQUIRED[${symbol}]})")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        die "DBD entries of ${MODULE} have no providing library among its selected, dependency, Base, or PVXS libraries: ${missing[*]}"
    fi
    [[ ${#lib_paths[@]} -eq 0 ]] || verify_undefined "${lib_paths[@]}"

    {
        printf 'format=%s\n' "${FORMAT_VERSION}"
        printf 'name=%s\n' "${MODULE}"
        printf 'version=%s\n' "${VERSION}"
        printf 'base=%s\n' "${BASE_VERSION}"
        printf 'arch=%s\n' "${ARCH}"
        printf 'macro=%s\n' "${MACRO}"
        for dep in "${deps[@]}"; do
            printf 'dep=%s %s\n' "${dep%%=*}" "${dep#*=}"
        done
        for entry in "${lib_paths[@]}"; do
            printf 'lib=%s\n' "${entry}"
        done
        for entry in "${dbd_paths[@]}"; do
            printf 'dbd=%s\n' "${entry}"
        done
    } | write_atomic "${INSTALL_DIR}/${CONF_FILE}"
    printf '%s\n' "$(sha256_of "${INSTALL_DIR}/${CONF_FILE}")" | write_atomic "${INSTALL_DIR}/${DIGEST_FILE}"
    METADATA_CLEARED="NO"
    note "wrote ${INSTALL_DIR}/${CONF_FILE}: ${#lib_paths[@]} libraries, ${#dbd_paths[@]} DBDs, ${#REQUIRED[@]} entries resolved"
}

function do_check {
    local conf="${INSTALL_DIR}/${CONF_FILE}"
    local record="${INSTALL_DIR}/${RECORD_FILE}"
    local entry=""
    local -A scalars=()
    local -a lists=()
    # Filled through nameref parameters of read_data_file.
    # shellcheck disable=SC2034
    local -A record_scalars=()
    # shellcheck disable=SC2034
    local -a record_lists=()

    require_value --install "${INSTALL_DIR}"
    require_value --base "${BASE_DIR}"
    require_directory "Installed module directory" "${INSTALL_DIR}"
    require_directory "Installed Base directory" "${BASE_DIR}"
    require_command sha256sum
    ARCH=$(detect_arch)

    [[ -s "${conf}" ]] || die "Missing or empty metadata file: ${conf}"
    verify_conf_digest "${conf}"
    read_data_file "${conf}" scalars lists
    require_scalar "${conf}" scalars format "${FORMAT_VERSION}"
    require_scalar "${conf}" scalars name "${MODULE}"
    require_scalar "${conf}" scalars version "${VERSION}"
    require_scalar "${conf}" scalars base "${BASE_VERSION}"
    require_scalar "${conf}" scalars arch "${ARCH}"
    require_scalar "${conf}" scalars macro ""
    for entry in "${lists[@]}"; do
        case "${entry}" in
            lib=*|dbd=*)
                [[ -s "${INSTALL_DIR}/${entry#*=}" ]] || die "Metadata entry is absent: ${INSTALL_DIR}/${entry#*=}"
                ;;
        esac
    done
    read_data_file "${record}" record_scalars record_lists
    require_scalar "${record}" record_scalars name "${scalars[name]}"
    require_scalar "${record}" record_scalars version "${scalars[version]}"
    verify_artifacts "${record}" record_lists
    printf '%s: %s %s is consistent\n' "${SCRIPT_NAME}" "${scalars[name]}" "${scalars[version]}"
}

function main {
    [[ $# -ge 1 ]] || { usage >&2; exit 1; }
    case "$1" in
        record|generate|check) MODE="$1" ;;
        -h|--help) usage; return 0 ;;
        *) die "Unknown mode: $1" ;;
    esac
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --module) [[ $# -ge 2 ]] || die "Missing value for $1"; MODULE="$2"; shift ;;
            --install) [[ $# -ge 2 ]] || die "Missing value for $1"; INSTALL_DIR="${2%/}"; shift ;;
            --version) [[ $# -ge 2 ]] || die "Missing value for $1"; VERSION="$2"; shift ;;
            --tag) [[ $# -ge 2 ]] || die "Missing value for $1"; TAG="$2"; shift ;;
            --base-version) [[ $# -ge 2 ]] || die "Missing value for $1"; BASE_VERSION="$2"; shift ;;
            --base) [[ $# -ge 2 ]] || die "Missing value for $1"; BASE_DIR="${2%/}"; shift ;;
            --modules) [[ $# -ge 2 ]] || die "Missing value for $1"; MODULES_DIR="${2%/}"; shift ;;
            --pvxs) [[ $# -ge 2 ]] || die "Missing value for $1"; PVXS_DIR="${2%/}"; shift ;;
            --source) [[ $# -ge 2 ]] || die "Missing value for $1"; SOURCE_DIR="${2%/}"; shift ;;
            --macro) [[ $# -ge 2 ]] || die "Missing value for $1"; MACRO="$2"; shift ;;
            --target) [[ $# -ge 2 ]] || die "Missing value for $1"; TARGET="$2"; shift ;;
            --dep)
                [[ $# -ge 2 ]] || die "Missing value for $1"
                [[ "$2" =~ ^[A-Za-z][A-Za-z0-9_-]*=[^[:space:]=]+$ ]] || die "Dependency must be NAME=VERSION: $2"
                DEPS+=("$2")
                shift
                ;;
            --libs) [[ $# -ge 2 ]] || die "Missing value for $1"; LIBS="$2"; LIBS_GIVEN="YES"; shift ;;
            --dbds) [[ $# -ge 2 ]] || die "Missing value for $1"; DBDS="$2"; DBDS_GIVEN="YES"; shift ;;
            -v|--verbose) VERBOSE="YES" ;;
            -h|--help) usage; return 0 ;;
            *) die "Unknown option: $1" ;;
        esac
        shift
    done
    [[ -z "${MODULE}" || "${MODULE}" =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]] || die "Invalid module name: ${MODULE}"
    case "${MODE}" in
        record) do_record ;;
        generate) do_generate ;;
        check) do_check ;;
    esac
}

main "$@"
