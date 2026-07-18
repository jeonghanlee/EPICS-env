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
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt

set -euo pipefail

declare -g TOP="."
declare -g MODULE_FILTER=""
declare -g FORMAT="text"
declare -g STRICT="NO"
declare -g PLATFORM=""

declare -a MODULES=()
declare -a SOURCE_PATHS=()
declare -a RECORDS=()
declare -a UNKNOWN_RECORDS=()

declare -A MODULE_BY_PATH=()
declare -A DECLARED_RAW_BY_MODULE=()
declare -A DECLARED_NORM_BY_MODULE=()
declare -A ALIASES=()
declare -A EXTERNAL_TOKENS=()
declare -A BASE_TOKENS=()
declare -A MODULE_EXISTS=()
declare -A MODULE_INDEX=()
declare -A DBD_CATALOG=()
declare -A DB_CATALOG=()
declare -A PROTO_CATALOG=()
declare -A HEADER_CATALOG=()
declare -A RECORD_TYPE_CATALOG=()
declare -A PATH_EVIDENCE_CLASS=()
declare -A MODULE_FILE_LIST_READY=()

function usage
{
    printf "%s\n" "Usage: ${0##*/} [--top <repo>] [--module <name>] [--format text|json] [--strict] [--platform <name>]"
}

function die
{
    printf "Error: %s\n" "$1" >&2
    exit 1
}

function trim
{
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf "%s" "$value"
}

function trim_var
{
    declare -n value_ref="$1"
    value_ref="${value_ref#"${value_ref%%[![:space:]]*}"}"
    value_ref="${value_ref%"${value_ref##*[![:space:]]}"}"
}

function parse_args
{
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --top)
                [[ $# -ge 2 ]] || die "--top requires a value"
                TOP="$2"
                shift 2
                ;;
            --module)
                [[ $# -ge 2 ]] || die "--module requires a value"
                MODULE_FILTER="$2"
                shift 2
                ;;
            --format)
                [[ $# -ge 2 ]] || die "--format requires a value"
                FORMAT="$2"
                shift 2
                ;;
            --strict)
                STRICT="YES"
                shift
                ;;
            --platform)
                [[ $# -ge 2 ]] || die "--platform requires a value"
                PLATFORM="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                die "Unknown argument: $1"
                ;;
        esac
    done

    [[ -n "$FORMAT" ]] || FORMAT="text"
    [[ -n "$PLATFORM" ]] || PLATFORM="$(uname -s)"
    [[ "$FORMAT" == "text" || "$FORMAT" == "json" ]] || die "Unsupported format: $FORMAT"
    [[ -d "$TOP" ]] || die "Repository root does not exist: $TOP"
}

# Nested make runs with the caller's MAKEFLAGS cleared: under an outer
# "make -C" GNU Make 4.2.1 injects the print-directory flag into the
# inherited MAKEFLAGS (newer makes only with an explicit -w), a nested
# "-s" does not suppress an inherited flag, and the Entering/Leaving
# lines pollute the captured value (issue #28). --no-print-directory
# covers the same flag arriving by other routes.
function make_value
{
    local var_name="$1"
    MAKEFLAGS='' make -s --no-print-directory -C "$TOP" "print-${var_name}"
}

function module_file_list_name
{
    local module="$1"
    local list_type="$2"
    declare -n list_name_ref="$3"
    local module_index="${MODULE_INDEX[$module]:-}"

    [[ -n "$module_index" ]] || die "Unknown module for file list: $module"
    [[ "$module_index" =~ ^[0-9]+$ ]] || die "Invalid module index for file list: $module"
    [[ "$list_type" =~ ^[A-Z_]+$ ]] || die "Unsupported module file list type: $list_type"
    # shellcheck disable=SC2034
    list_name_ref="MODULE_${list_type}_FILES_${module_index}"
}

function load_module_file_lists
{
    local module="$1"
    local source_path="${MODULE_BY_PATH[$module]}"
    local source_root="${TOP}/${source_path}"
    local catalog_name
    local makefile_name
    local dbd_name
    local database_name
    local startup_name
    local source_name
    local file
    local base
    local find_expr=(
        -name "Makefile"
        -o -name "*.dbd"
        -o -name "*.db"
        -o -name "*.template"
        -o -name "*.substitutions"
        -o -name "*.proto"
        -o -name "st.cmd"
        -o -name "*.cmd"
        -o -name "*.iocsh"
        -o -name "*.c"
        -o -name "*.cc"
        -o -name "*.cpp"
        -o -name "*.cxx"
        -o -name "*.h"
        -o -name "*.hpp"
        -o -name "*.hh"
        -o -name "*.hxx"
    )

    [[ -z "${MODULE_FILE_LIST_READY[$module]:-}" ]] || return 0

    module_file_list_name "$module" "CATALOG" catalog_name
    module_file_list_name "$module" "MAKEFILE" makefile_name
    module_file_list_name "$module" "DBD" dbd_name
    module_file_list_name "$module" "DATABASE" database_name
    module_file_list_name "$module" "STARTUP" startup_name
    module_file_list_name "$module" "SOURCE" source_name

    declare -g -a "$catalog_name"
    declare -g -a "$makefile_name"
    declare -g -a "$dbd_name"
    declare -g -a "$database_name"
    declare -g -a "$startup_name"
    declare -g -a "$source_name"
    # shellcheck disable=SC2178
    declare -n catalog_files="$catalog_name"
    # shellcheck disable=SC2178
    declare -n makefile_files="$makefile_name"
    # shellcheck disable=SC2178
    declare -n dbd_files="$dbd_name"
    # shellcheck disable=SC2178
    declare -n database_files="$database_name"
    # shellcheck disable=SC2178
    declare -n startup_files="$startup_name"
    # shellcheck disable=SC2178
    declare -n source_files="$source_name"

    catalog_files=()
    makefile_files=()
    dbd_files=()
    database_files=()
    startup_files=()
    source_files=()

    if [[ -d "$source_root" ]]; then
        while IFS= read -r -d '' file; do
            base="${file##*/}"
            case "$base" in
                Makefile)
                    catalog_files+=( "$file" )
                    makefile_files+=( "$file" )
                    ;;
                *.dbd)
                    catalog_files+=( "$file" )
                    dbd_files+=( "$file" )
                    ;;
                *.db|*.template|*.substitutions)
                    catalog_files+=( "$file" )
                    database_files+=( "$file" )
                    ;;
                *.proto)
                    catalog_files+=( "$file" )
                    ;;
                st.cmd|*.cmd|*.iocsh)
                    startup_files+=( "$file" )
                    ;;
                *.c|*.cc|*.cpp|*.cxx|*.h|*.hpp|*.hh|*.hxx)
                    source_files+=( "$file" )
                    ;;
            esac
        done < <(find "$source_root" -type f \( "${find_expr[@]}" \) -print0)
    fi

    MODULE_FILE_LIST_READY["$module"]="YES"
}

function read_words
{
    local var_name="$1"
    local value
    value="$(make_value "$var_name")"
    printf "%s\n" "$value"
}

function load_make_metadata
{
    local module_string
    local path_string
    local alias_string
    local external_string
    local base_string
    local base_record_string
    local index=0
    local module
    local path
    local entry
    local key
    local value

    module_string="$(read_words MOD_CONF_TYPE_MODULES)"
    path_string="$(read_words SRC_PATH_MODULES)"

    # shellcheck disable=SC2206
    MODULES=( $module_string )
    # shellcheck disable=SC2206
    SOURCE_PATHS=( $path_string )

    [[ "${#MODULES[@]}" -eq "${#SOURCE_PATHS[@]}" ]] || die "Module and source path counts differ"

    for module in "${MODULES[@]}"; do
        path="${SOURCE_PATHS[$index]}"
        MODULE_BY_PATH["$module"]="$path"
        MODULE_EXISTS["$module"]="YES"
        MODULE_INDEX["$module"]="$index"
        DECLARED_RAW_BY_MODULE["$module"]="$(make_value "${module}_DEPS")"
        index=$((index + 1))
    done

    alias_string="$(read_words AUDIT_MODULE_ALIASES)"
    for entry in $alias_string; do
        key="${entry%%=*}"
        value="${entry#*=}"
        [[ "$entry" == *"="* && -n "$key" && -n "$value" ]] || continue
        ALIASES["$key"]="$value"
    done
    for module in "${MODULES[@]}"; do
        ALIASES["$module"]="$module"
    done
    for module in "${MODULES[@]}"; do
        DECLARED_NORM_BY_MODULE["$module"]="$(normalize_declared_deps "${DECLARED_RAW_BY_MODULE[$module]}")"
    done

    external_string="$(read_words AUDIT_EXTERNAL_TOKENS)"
    for entry in $external_string; do
        EXTERNAL_TOKENS["$entry"]="YES"
    done

    base_string="$(read_words AUDIT_BASE_TOKENS)"
    for entry in $base_string; do
        BASE_TOKENS["$entry"]="YES"
    done

    base_record_string="$(read_words AUDIT_BASE_RECORD_TYPES)"
    for entry in $base_record_string; do
        BASE_TOKENS["record:${entry}"]="YES"
    done
}

function normalize_declared_deps
{
    local raw="$1"
    local dep
    local name
    local normalized_dep
    local normalized=()

    for dep in $raw; do
        [[ "$dep" == "null.base" ]] && continue
        name="${dep#build.}"
        normalize_module_token_var "$name" normalized_dep
        normalized+=( "$normalized_dep" )
    done
    printf "%s" "${normalized[*]}"
}

function normalize_module_token_var
{
    local token="$1"
    declare -n normalized_ref="$2"

    token="${token%,}"
    token="${token%;}"
    token="${token#\"}"
    token="${token%\"}"
    token="${token#\'}"
    token="${token%\'}"

    if [[ -n "${ALIASES[$token]:-}" ]]; then
        # shellcheck disable=SC2034
        normalized_ref="${ALIASES[$token]}"
        return 0
    fi

    # shellcheck disable=SC2034
    normalized_ref="$token"
}

function is_selected_module
{
    local module="$1"
    [[ -z "$MODULE_FILTER" || "$MODULE_FILTER" == "$module" ]]
}

function classify_path
{
    local path="$1"
    declare -n class_ref="$2"
    local result

    case "$path" in
        */docs/*|*/documentation/*|*/README*|*/CHANGELOG*|*/LICENSE*)
            result="ignored"
            ;;
        */test/*|*/tests/*|*/test*App/*|*/unitTest*/*|*/demo*/*|*/example*/*|*/iocBoot/*)
            result="optional"
            ;;
        */O.*/*)
            result="ignored"
            ;;
        */os/Linux/*|*/os/posix/*|*/os/default/*)
            if [[ -z "$PLATFORM" || "$PLATFORM" == "Linux" ]]; then
                result="active"
            else
                result="optional"
            fi
            ;;
        */os/Darwin/*|*/os/vxWorks/*|*/os/WIN32/*|*/os/RTEMS/*|*/os/solaris/*)
            result="optional"
            ;;
        *)
            result="active"
            ;;
    esac

    # shellcheck disable=SC2034
    class_ref="$result"
}

function evidence_class_for_path
{
    local path="$1"
    declare -n evidence_ref="$2"
    local context
    local result

    if [[ -n "${PATH_EVIDENCE_CLASS[$path]:-}" ]]; then
        # shellcheck disable=SC2034
        evidence_ref="${PATH_EVIDENCE_CLASS[$path]}"
        return 0
    fi

    classify_path "$path" context
    case "$context" in
        active) result="required" ;;
        optional) result="optional" ;;
        *) result="ignored" ;;
    esac

    PATH_EVIDENCE_CLASS["$path"]="$result"
    # shellcheck disable=SC2034
    evidence_ref="$result"
}

function add_catalog_value
{
    local map_name="$1"
    local artifact="$2"
    local module="$3"
    local existing

    [[ -n "$artifact" ]] || return 0
    declare -n catalog="$map_name"
    existing="${catalog[$artifact]:-}"
    if [[ -z "$existing" ]]; then
        catalog["$artifact"]="$module"
    elif [[ "$existing" != "$module" ]]; then
        catalog["$artifact"]="__ambiguous__"
    fi
}

function artifact_name_var
{
    local token="$1"
    declare -n artifact_ref="$2"

    trim_var token
    token="${token#\"}"
    token="${token%\"}"
    token="${token#\'}"
    token="${token%\'}"
    token="${token#<}"
    token="${token%>}"
    token="${token%,}"
    token="${token%;}"
    token="${token%\{}"
    token="${token##*/}"
    while [[ "$token" == *")" ]]; do
        token="${token%)}"
    done

    # shellcheck disable=SC2034
    artifact_ref="$token"
}

function header_artifact_key_var
{
    local token="$1"
    declare -n artifact_ref="$2"

    trim_var token
    token="${token#\"}"
    token="${token%\"}"
    token="${token#\'}"
    token="${token%\'}"
    token="${token#<}"
    token="${token%>}"
    token="${token%,}"
    token="${token%;}"
    while [[ "$token" == *")" ]]; do
        token="${token%)}"
    done

    # shellcheck disable=SC2034
    artifact_ref="$token"
}

function add_header_catalog_token
{
    local module="$1"
    local token="$2"
    local key
    local make_var_ref="\$("
    local shell_var_ref="\${"

    header_artifact_key_var "$token" key
    [[ -n "$key" ]] || return 0
    [[ "$key" == *"$make_var_ref"* || "$key" == *"$shell_var_ref"* ]] && return 0

    case "$key" in
        *.h|*.hpp|*.hh|*.hxx) ;;
        *) return 0 ;;
    esac

    add_catalog_value HEADER_CATALOG "$key" "$module"
}

function add_db_catalog_token
{
    local module="$1"
    local token="$2"
    local artifact

    artifact_name_var "$token" artifact
    case "$artifact" in
        *.db|*.template|*.substitutions)
            add_catalog_value DB_CATALOG "$artifact" "$module"
            ;;
    esac
}

function add_record_type_catalog
{
    local module="$1"
    local file="$2"
    local line
    local record_type

    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        line="${line%%#*}"
        if [[ "$line" =~ recordtype\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*\) ]]; then
            record_type="${BASH_REMATCH[1]}"
            [[ -n "${BASE_TOKENS["record:${record_type}"]:-}" ]] && continue
            add_catalog_value RECORD_TYPE_CATALOG "$record_type" "$module"
        fi
    done < "$file"
}

function add_db_catalog_from_makefile
{
    local module="$1"
    local file="$2"
    local line
    local rhs
    local token

    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        line="${line%%#*}"
        trim_var line
        [[ -n "$line" ]] || continue

        if [[ "$line" =~ ^([A-Za-z0-9_]+_)?(DB|DB_INSTALLS)[[:space:]]*[:+?]?=[[:space:]]*(.*)$ ]]; then
            rhs="${BASH_REMATCH[3]}"
            for token in $rhs; do
                add_db_catalog_token "$module" "$token"
            done
        fi
    done < "$file"
}

function add_header_catalog_from_makefile
{
    local module="$1"
    local file="$2"
    local line
    local rhs
    local token

    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        line="${line%%#*}"
        trim_var line
        [[ -n "$line" ]] || continue

        if [[ "$line" =~ ^INC(_[A-Za-z0-9_$()]+)?[[:space:]]*[:+?]?=[[:space:]]*(.*)$ ]]; then
            rhs="${BASH_REMATCH[2]}"
            for token in $rhs; do
                add_header_catalog_token "$module" "$token"
            done
        fi
    done < "$file"
}

function build_artifact_catalog
{
    local module
    local file
    local base
    local class
    local catalog_name

    for module in "${MODULES[@]}"; do
        load_module_file_lists "$module"
        module_file_list_name "$module" "CATALOG" catalog_name
        # shellcheck disable=SC2178
        declare -n catalog_files="$catalog_name"
        for file in "${catalog_files[@]}"; do
            evidence_class_for_path "$file" class
            [[ "$class" != "ignored" ]] || continue
            base="${file##*/}"
            case "$base" in
                Makefile)
                    add_db_catalog_from_makefile "$module" "$file"
                    add_header_catalog_from_makefile "$module" "$file"
                    ;;
                *.dbd)
                    add_catalog_value DBD_CATALOG "$base" "$module"
                    if [[ "$class" == "required" ]]; then
                        add_record_type_catalog "$module" "$file"
                    fi
                    ;;
                *.db|*.template|*.substitutions)
                    add_catalog_value DB_CATALOG "$base" "$module"
                    if [[ "$base" == *.substitutions ]]; then
                        add_catalog_value DB_CATALOG "${base%.substitutions}.db" "$module"
                    fi
                    ;;
                *.proto)
                    add_catalog_value PROTO_CATALOG "$base" "$module"
                    ;;
            esac
        done
    done
}

function add_record
{
    local module="$1"
    local dep="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local detail="$7"

    [[ "$dep" != "$module" ]] || return 0
    [[ "$class" != "ignored" ]] || return 0

    RECORDS+=( "${module}|${dep}|${class}|${source}|${path}|${line_no}|${detail}" )
}

function add_unknown
{
    local module="$1"
    local token="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"

    [[ "$class" == "required" ]] || return 0
    UNKNOWN_RECORDS+=( "${module}|${token}|unknown|${source}|${path}|${line_no}|unmapped token" )
}

function token_is_noise
{
    local token="$1"
    local make_var_ref="\$("
    local shell_var_ref="\${"
    [[ -z "$token" ]] && return 0
    [[ "$token" == *"$make_var_ref"* || "$token" == *"$shell_var_ref"* ]] && return 0
    [[ "$token" == -* ]] && return 0
    [[ "$token" == *"/"* ]] && return 0
    [[ "$token" == *"."* && "$token" != *.dbd ]] && return 0
    [[ "$token" =~ ^[0-9]+$ ]] && return 0
    return 1
}

function classify_token
{
    local module="$1"
    local token="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local normalized

    trim_var token
    token="${token%,}"
    token="${token%;}"
    [[ -n "$token" ]] || return 0

    if token_is_noise "$token"; then
        return 0
    fi

    if [[ -n "${BASE_TOKENS[$token]:-}" ]]; then
        return 0
    fi

    if [[ -n "${EXTERNAL_TOKENS[$token]:-}" ]]; then
        add_record "$module" "$token" "external" "$source" "$path" "$line_no" "$token"
        return 0
    fi

    normalize_module_token_var "$token" normalized
    if module_exists "$normalized"; then
        add_record "$module" "$normalized" "$class" "$source" "$path" "$line_no" "$token"
        return 0
    fi

    add_unknown "$module" "$token" "$class" "$source" "$path" "$line_no"
}

function module_exists
{
    local needle="$1"
    [[ -n "${MODULE_EXISTS[$needle]:-}" ]]
}

function scan_release_local
{
    local module="$1"
    local source_path="${MODULE_BY_PATH[$module]}"
    local file="${TOP}/${source_path}/configure/RELEASE.local"
    local line
    local line_no=0
    local display_path
    local macro
    local value
    local dep

    [[ -f "$file" ]] || return 0
    display_path="${file#"${TOP}"/}"
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line_no=$((line_no + 1))
        line="${line//$'\r'/}"
        line="${line%%#*}"
        trim_var line
        [[ "$line" =~ ^([A-Za-z0-9_]+)[[:space:]]*:?=[[:space:]]*(.*)$ ]] || continue
        macro="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        trim_var value
        [[ "$macro" == "EPICS_BASE" || "$macro" == "SUPPORT" ]] && continue
        [[ -n "$value" ]] || continue
        [[ "$value" == "YES" || "$value" == "NO" ]] && continue
        normalize_module_token_var "$macro" dep
        if module_exists "$dep"; then
            add_record "$module" "$dep" "required" "release-local" "$display_path" "$line_no" "$macro"
        else
            classify_token "$module" "$macro" "required" "release-local" "$display_path" "$line_no"
        fi
    done < "$file"
}

function scan_makefile_line
{
    local module="$1"
    local path="$2"
    local line_no="$3"
    local line="$4"
    local class="$5"
    local lib_class
    local rhs
    local token

    line="${line//$'\r'/}"
    line="${line%%#*}"
    trim_var line
    [[ -n "$line" ]] || return 0

    if [[ "$line" =~ ^[A-Za-z0-9_]*(_LIBS|PROD_LIBS|LIB_LIBS)[[:space:]]*[:+?]?=[[:space:]]*(.*)$ ]]; then
        rhs="${BASH_REMATCH[2]}"
        lib_class="$class"
        if [[ "$class" == "required" ]]; then
            lib_class="probable"
        fi
        for token in $rhs; do
            classify_token "$module" "$token" "$lib_class" "make-libs" "$path" "$line_no"
        done
    elif [[ "$line" =~ ^[A-Za-z0-9_]*(DBD|DBD_INSTALLS)[[:space:]]*[:+?]?=[[:space:]]*(.*)$ ]]; then
        rhs="${BASH_REMATCH[2]}"
        for token in $rhs; do
            classify_dbd_token "$module" "$token" "$class" "make-dbd" "$path" "$line_no"
        done
    fi
    return 0
}

function classify_dbd_token
{
    local module="$1"
    local token="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local dep

    token="${token#../}"
    token="${token#\"}"
    token="${token%\"}"
    [[ "$token" == *.dbd ]] || return 0
    dep="${DBD_CATALOG[$token]:-}"
    if [[ -n "$dep" && "$dep" != "__ambiguous__" ]]; then
        add_record "$module" "$dep" "$class" "$source" "$path" "$line_no" "$token"
    elif [[ "$dep" == "__ambiguous__" ]]; then
        add_unknown "$module" "$token" "$class" "$source" "$path" "$line_no"
    fi
    return 0
}

function classify_db_token
{
    local module="$1"
    local token="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local artifact
    local dep

    artifact_name_var "$token" artifact
    case "$artifact" in
        *.db|*.template|*.substitutions) ;;
        *) return 0 ;;
    esac

    dep="${DB_CATALOG[$artifact]:-}"
    if [[ -n "$dep" && "$dep" != "__ambiguous__" ]]; then
        add_record "$module" "$dep" "$class" "$source" "$path" "$line_no" "$artifact"
    elif [[ "$dep" == "__ambiguous__" ]]; then
        add_unknown "$module" "$artifact" "$class" "$source" "$path" "$line_no"
    else
        add_unknown "$module" "$artifact" "$class" "$source" "$path" "$line_no"
    fi
}

function classify_proto_token
{
    local module="$1"
    local token="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local artifact
    local dep

    artifact_name_var "$token" artifact
    [[ "$artifact" == *.proto ]] || return 0

    dep="${PROTO_CATALOG[$artifact]:-}"
    if [[ -n "$dep" && "$dep" != "__ambiguous__" ]]; then
        add_record "$module" "$dep" "$class" "$source" "$path" "$line_no" "$artifact"
    elif [[ "$dep" == "__ambiguous__" ]]; then
        add_unknown "$module" "$artifact" "$class" "$source" "$path" "$line_no"
    else
        add_unknown "$module" "$artifact" "$class" "$source" "$path" "$line_no"
    fi
}

function classify_header_token
{
    local module="$1"
    local token="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local artifact
    local dep

    header_artifact_key_var "$token" artifact
    case "$artifact" in
        *.h|*.hpp|*.hh|*.hxx) ;;
        *) return 0 ;;
    esac

    dep="${HEADER_CATALOG[$artifact]:-}"
    if [[ -n "$dep" && "$dep" != "__ambiguous__" ]]; then
        add_record "$module" "$dep" "$class" "$source" "$path" "$line_no" "$artifact"
    fi
}

function classify_record_type
{
    local module="$1"
    local record_type="$2"
    local class="$3"
    local source="$4"
    local path="$5"
    local line_no="$6"
    local dep

    [[ -n "${BASE_TOKENS["record:${record_type}"]:-}" ]] && return 0
    dep="${RECORD_TYPE_CATALOG[$record_type]:-}"
    if [[ -n "$dep" && "$dep" != "__ambiguous__" ]]; then
        add_record "$module" "$dep" "$class" "$source" "$path" "$line_no" "$record_type"
    elif [[ "$dep" == "__ambiguous__" ]]; then
        add_unknown "$module" "$record_type" "$class" "$source" "$path" "$line_no"
    fi
}

function scan_makefiles
{
    local module="$1"
    local makefile_name
    local file
    local line
    local line_no
    local class
    local display_path

    load_module_file_lists "$module"
    module_file_list_name "$module" "MAKEFILE" makefile_name
    # shellcheck disable=SC2178
    declare -n makefile_files="$makefile_name"
    for file in "${makefile_files[@]}"; do
        evidence_class_for_path "$file" class
        [[ "$class" != "ignored" ]] || continue
        display_path="${file#"${TOP}"/}"
        line_no=0
        while IFS= read -r line || [[ -n "${line:-}" ]]; do
            line_no=$((line_no + 1))
            scan_makefile_line "$module" "$display_path" "$line_no" "$line" "$class"
        done < "$file"
    done
}

function scan_dbd_files
{
    local module="$1"
    local dbd_name
    local file
    local line
    local line_no
    local class
    local include_name
    local display_path

    load_module_file_lists "$module"
    module_file_list_name "$module" "DBD" dbd_name
    # shellcheck disable=SC2178
    declare -n dbd_files="$dbd_name"
    for file in "${dbd_files[@]}"; do
        evidence_class_for_path "$file" class
        [[ "$class" != "ignored" ]] || continue
        display_path="${file#"${TOP}"/}"
        line_no=0
        while IFS= read -r line || [[ -n "${line:-}" ]]; do
            line_no=$((line_no + 1))
            line="${line//$'\r'/}"
            if [[ "$line" =~ include[[:space:]]+\"([^\"]+\.dbd)\" ]]; then
                include_name="${BASH_REMATCH[1]##*/}"
                classify_dbd_token "$module" "$include_name" "$class" "dbd-include" "$display_path" "$line_no"
            fi
        done < "$file"
    done
}

function scan_database_line
{
    local module="$1"
    local path="$2"
    local line_no="$3"
    local line="$4"
    local class="$5"
    local record_class="$class"
    local field_proto_re='field\((INP|OUT)[[:space:]]*,[[:space:]]*"[^"]*@([^[:space:]",)]+\.proto)'
    local token

    line="${line//$'\r'/}"
    line="${line%%#*}"
    trim_var line
    [[ -n "$line" ]] || return 0

    if [[ "$line" =~ ^file[[:space:]]+\"([^\"]+)\" ]]; then
        classify_db_token "$module" "${BASH_REMATCH[1]}" "$class" "db-file" "$path" "$line_no"
    elif [[ "$line" =~ ^file[[:space:]]+([^[:space:]\{]+) ]]; then
        classify_db_token "$module" "${BASH_REMATCH[1]}" "$class" "db-file" "$path" "$line_no"
    fi

    if [[ "$line" =~ record\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*, ]]; then
        if [[ "$class" == "required" ]]; then
            record_class="probable"
        fi
        classify_record_type "$module" "${BASH_REMATCH[1]}" "$record_class" "db-record" "$path" "$line_no"
    fi

    if [[ "$line" =~ $field_proto_re ]]; then
        token="${BASH_REMATCH[2]}"
        classify_proto_token "$module" "$token" "$class" "db-proto" "$path" "$line_no"
    fi
}

function scan_database_files
{
    local module="$1"
    local database_name
    local file
    local line
    local line_no
    local class
    local display_path

    load_module_file_lists "$module"
    module_file_list_name "$module" "DATABASE" database_name
    # shellcheck disable=SC2178
    declare -n database_files="$database_name"
    for file in "${database_files[@]}"; do
        evidence_class_for_path "$file" class
        [[ "$class" != "ignored" ]] || continue
        display_path="${file#"${TOP}"/}"
        line_no=0
        while IFS= read -r line || [[ -n "${line:-}" ]]; do
            line_no=$((line_no + 1))
            scan_database_line "$module" "$display_path" "$line_no" "$line" "$class"
        done < "$file"
    done
}

function scan_startup_line
{
    local module="$1"
    local path="$2"
    local line_no="$3"
    local line="$4"
    local class="$5"
    local db_load_re='dbLoad(Records|Template)[[:space:]]*\([[:space:]]*"?([^",)]+)'
    local dbd_load_re='dbLoadDatabase[[:space:]]*\([[:space:]]*"?([^",)]+)'

    line="${line//$'\r'/}"
    line="${line%%#*}"
    trim_var line
    [[ -n "$line" ]] || return 0

    if [[ "$line" =~ $db_load_re ]]; then
        classify_db_token "$module" "${BASH_REMATCH[2]}" "$class" "startup-db" "$path" "$line_no"
    elif [[ "$line" =~ $dbd_load_re ]]; then
        classify_dbd_token "$module" "${BASH_REMATCH[1]}" "$class" "startup-dbd" "$path" "$line_no"
    fi
}

function scan_startup_files
{
    local module="$1"
    local startup_name
    local file
    local line
    local line_no
    local class
    local display_path

    load_module_file_lists "$module"
    module_file_list_name "$module" "STARTUP" startup_name
    # shellcheck disable=SC2178
    declare -n startup_files="$startup_name"
    for file in "${startup_files[@]}"; do
        evidence_class_for_path "$file" class
        [[ "$class" != "ignored" ]] || continue
        display_path="${file#"${TOP}"/}"
        line_no=0
        while IFS= read -r line || [[ -n "${line:-}" ]]; do
            line_no=$((line_no + 1))
            scan_startup_line "$module" "$display_path" "$line_no" "$line" "$class"
        done < "$file"
    done
}

function scan_source_line
{
    local module="$1"
    local path="$2"
    local line_no="$3"
    local line="$4"
    local class="$5"
    local header_class="$class"
    local include_re='^#[[:space:]]*include[[:space:]]+[<"]([^>"]+)[>"]'

    line="${line//$'\r'/}"
    trim_var line
    [[ -n "$line" ]] || return 0

    if [[ "$line" =~ $include_re ]]; then
        if [[ "$class" == "required" ]]; then
            header_class="probable"
        fi
        classify_header_token "$module" "${BASH_REMATCH[1]}" "$header_class" "source-include" "$path" "$line_no"
    fi
}

function scan_source_files
{
    local module="$1"
    local source_name
    local file
    local line
    local line_no
    local class
    local display_path

    load_module_file_lists "$module"
    module_file_list_name "$module" "SOURCE" source_name
    # shellcheck disable=SC2178
    declare -n source_files="$source_name"
    for file in "${source_files[@]}"; do
        evidence_class_for_path "$file" class
        [[ "$class" != "ignored" ]] || continue
        display_path="${file#"${TOP}"/}"
        line_no=0
        while IFS= read -r line || [[ -n "${line:-}" ]]; do
            line_no=$((line_no + 1))
            scan_source_line "$module" "$display_path" "$line_no" "$line" "$class"
        done < "$file"
    done
}

function scan_module
{
    local module="$1"
    scan_release_local "$module"
    scan_makefiles "$module"
    scan_dbd_files "$module"
    scan_database_files "$module"
    scan_startup_files "$module"
    scan_source_files "$module"
}

function record_matches_module
{
    local record="$1"
    local module="$2"
    [[ "${record%%|*}" == "$module" ]]
}

function module_records
{
    local module="$1"
    local record
    for record in "${RECORDS[@]}"; do
        if record_matches_module "$record" "$module"; then
            printf "%s\n" "$record"
        fi
    done
}

function module_unknown_records
{
    local module="$1"
    local record
    for record in "${UNKNOWN_RECORDS[@]}"; do
        if record_matches_module "$record" "$module"; then
            printf "%s\n" "$record"
        fi
    done
}

function required_observed_set
{
    local module="$1"
    local record
    local rest
    local dep
    local class
    local seen=" "

    while IFS= read -r record; do
        [[ -n "$record" ]] || continue
        rest="${record#*|}"
        dep="${rest%%|*}"
        rest="${rest#*|}"
        class="${rest%%|*}"
        [[ "$class" == "required" ]] || continue
        if [[ "$seen" != *" ${dep} "* ]]; then
            printf "%s\n" "$dep"
            seen="${seen}${dep} "
        fi
    done < <(module_records "$module")
}

function contains_word
{
    local haystack="$1"
    local needle="$2"
    [[ " $haystack " == *" $needle "* ]]
}

function module_findings
{
    local module="$1"
    local unknown
    local rest
    local dep
    local source
    local path
    local line_no
    local observed_required
    local declared_norm="${DECLARED_NORM_BY_MODULE[$module]}"
    local dep_seen

    observed_required=""
    while IFS= read -r dep_seen; do
        [[ -n "$dep_seen" ]] || continue
        if [[ -n "$observed_required" ]]; then
            observed_required="${observed_required} ${dep_seen}"
        else
            observed_required="$dep_seen"
        fi
    done < <(required_observed_set "$module")

    for dep_seen in $observed_required; do
        if ! contains_word "$declared_norm" "$dep_seen"; then
            printf "undeclared-observed|%s|||\n" "$dep_seen"
        fi
    done

    for dep in $declared_norm; do
        if ! contains_word "$observed_required" "$dep"; then
            printf "declared-unobserved|%s|||\n" "$dep"
        fi
    done

    while IFS= read -r unknown; do
        [[ -n "$unknown" ]] || continue
        rest="${unknown#*|}"
        dep="${rest%%|*}"
        rest="${rest#*|}"
        rest="${rest#*|}"
        source="${rest%%|*}"
        rest="${rest#*|}"
        path="${rest%%|*}"
        rest="${rest#*|}"
        line_no="${rest%%|*}"
        printf "unknown|%s|%s|%s|%s\n" "$dep" "$source" "$path" "$line_no"
    done < <(module_unknown_records "$module")
}

function finding_is_strict_failure
{
    local finding_type="$1"
    case "$finding_type" in
        undeclared-observed|unknown)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

function strict_failure_count
{
    local module
    local finding
    local finding_type
    local count=0

    for module in "${MODULES[@]}"; do
        is_selected_module "$module" || continue
        while IFS= read -r finding; do
            [[ -n "$finding" ]] || continue
            finding_type="${finding%%|*}"
            if finding_is_strict_failure "$finding_type"; then
                count=$((count + 1))
            fi
        done < <(module_findings "$module")
    done

    printf "%s" "$count"
}

function print_module_text
{
    local module="$1"
    local record
    local finding
    local rest
    local dep
    local class
    local source
    local path
    local line_no
    local detail
    local finding_type
    local finding_count=0

    printf "Module: %s\n" "$module"
    printf "Declared: %s\n" "${DECLARED_RAW_BY_MODULE[$module]}"
    printf "Observed:\n"

    while IFS= read -r record; do
        [[ -n "$record" ]] || continue
        rest="${record#*|}"
        dep="${rest%%|*}"
        rest="${rest#*|}"
        class="${rest%%|*}"
        rest="${rest#*|}"
        source="${rest%%|*}"
        rest="${rest#*|}"
        path="${rest%%|*}"
        rest="${rest#*|}"
        line_no="${rest%%|*}"
        detail="${rest#*|}"
        printf "  %-8s %-16s %s:%s %s\n" "$class" "$dep" "$path" "$line_no" "$detail"
    done < <(module_records "$module")

    printf "Findings:\n"

    while IFS= read -r finding; do
        [[ -n "$finding" ]] || continue
        finding_type="${finding%%|*}"
        rest="${finding#*|}"
        dep="${rest%%|*}"
        rest="${rest#*|}"
        source="${rest%%|*}"
        rest="${rest#*|}"
        path="${rest%%|*}"
        rest="${rest#*|}"
        line_no="${rest%%|*}"
        case "$finding_type" in
            undeclared-observed|declared-unobserved)
                printf "  %s: %s\n" "$finding_type" "$dep"
                ;;
            unknown)
                printf "  unknown: %s at %s:%s (%s)\n" "$dep" "$path" "$line_no" "$source"
                ;;
        esac
        finding_count=$((finding_count + 1))
    done < <(module_findings "$module")

    if [[ "$finding_count" -eq 0 ]]; then
        printf "  none\n"
    fi
    printf "\n"
}

function json_escape
{
    local value="$1"
    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//$'\n'/\\n}"
    printf "%s" "$value"
}

function print_json_string_array
{
    local values="$1"
    local first="YES"
    local value
    printf "["
    for value in $values; do
        [[ "$first" == "YES" ]] || printf ", "
        printf "\"%s\"" "$(json_escape "$value")"
        first="NO"
    done
    printf "]"
}

function print_module_json
{
    local module="$1"
    local first_record="YES"
    local first_finding="YES"
    local record
    local finding
    local rest
    local dep
    local class
    local source
    local path
    local line_no
    local finding_type

    printf "  {\n"
    printf "    \"module\": \"%s\",\n" "$(json_escape "$module")"
    printf "    \"declared\": "
    print_json_string_array "${DECLARED_NORM_BY_MODULE[$module]}"
    printf ",\n"
    printf "    \"observed\": [\n"
    while IFS= read -r record; do
        [[ -n "$record" ]] || continue
        rest="${record#*|}"
        dep="${rest%%|*}"
        rest="${rest#*|}"
        class="${rest%%|*}"
        rest="${rest#*|}"
        source="${rest%%|*}"
        rest="${rest#*|}"
        path="${rest%%|*}"
        rest="${rest#*|}"
        line_no="${rest%%|*}"
        [[ "$first_record" == "YES" ]] || printf ",\n"
        printf "      {\"dependency\": \"%s\", \"class\": \"%s\", \"source\": \"%s\", \"path\": \"%s\", \"line\": %s}" \
            "$(json_escape "$dep")" \
            "$(json_escape "$class")" \
            "$(json_escape "$source")" \
            "$(json_escape "$path")" \
            "$line_no"
        first_record="NO"
    done < <(module_records "$module")
    printf "\n    ],\n"
    printf "    \"findings\": [\n"
    while IFS= read -r finding; do
        [[ -n "$finding" ]] || continue
        finding_type="${finding%%|*}"
        rest="${finding#*|}"
        dep="${rest%%|*}"
        rest="${rest#*|}"
        source="${rest%%|*}"
        rest="${rest#*|}"
        path="${rest%%|*}"
        rest="${rest#*|}"
        line_no="${rest%%|*}"
        [[ "$first_finding" == "YES" ]] || printf ",\n"
        printf "      {\"type\": \"%s\", \"dependency\": \"%s\"" \
            "$(json_escape "$finding_type")" "$(json_escape "$dep")"
        if [[ "$finding_type" == "unknown" ]]; then
            printf ", \"source\": \"%s\", \"path\": \"%s\", \"line\": %s" \
                "$(json_escape "$source")" "$(json_escape "$path")" "$line_no"
        fi
        printf "}"
        first_finding="NO"
    done < <(module_findings "$module")
    printf "\n    ]\n"
    printf "  }"
}

function print_report
{
    local module
    local first_module="YES"

    if [[ "$FORMAT" == "json" ]]; then
        printf "{\n"
        printf "  \"strict\": \"%s\",\n" "$STRICT"
        printf "  \"source_state\": \"%s\",\n" "generated-release-local-when-present"
        printf "  \"platform\": \"%s\",\n" "$(json_escape "$PLATFORM")"
        printf "  \"modules\": [\n"
        for module in "${MODULES[@]}"; do
            is_selected_module "$module" || continue
            [[ "$first_module" == "YES" ]] || printf ",\n"
            print_module_json "$module"
            first_module="NO"
        done
        printf "\n  ]\n"
        printf "}\n"
        return
    fi

    printf "Module Dependency Audit\n"
    printf "Strict: %s\n" "$STRICT"
    printf "Source state: generated RELEASE.local files are used when present.\n"
    printf "Platform: %s\n" "$PLATFORM"
    if [[ "$STRICT" == "YES" ]]; then
        printf "Strict policy: undeclared-observed and unknown findings fail.\n"
    fi
    printf "\n"

    for module in "${MODULES[@]}"; do
        is_selected_module "$module" || continue
        print_module_text "$module"
    done
}

function main
{
    local module
    local selected_count=0
    local strict_failures=0

    parse_args "$@"
    load_make_metadata
    build_artifact_catalog

    for module in "${MODULES[@]}"; do
        is_selected_module "$module" || continue
        selected_count=$((selected_count + 1))
        scan_module "$module"
    done

    [[ "$selected_count" -gt 0 ]] || die "No module matched: $MODULE_FILTER"
    print_report
    if [[ "$STRICT" == "YES" ]]; then
        strict_failures="$(strict_failure_count)"
        if (( strict_failures > 0 )); then
            printf "Strict dependency check failed: %s finding(s)\n" "$strict_failures" >&2
            exit 2
        fi
    fi
}

main "$@"
