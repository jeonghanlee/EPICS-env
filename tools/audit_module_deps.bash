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
declare -A DBD_CATALOG=()

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

function make_value
{
    local var_name="$1"
    make -s -C "$TOP" "print-${var_name}"
}

function relative_path
{
    local path="$1"
    printf "%s" "${path#"${TOP}"/}"
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
}

function normalize_declared_deps
{
    local raw="$1"
    local dep
    local name
    local normalized=()

    for dep in $raw; do
        [[ "$dep" == "null.base" ]] && continue
        name="${dep#build.}"
        normalized+=( "$(normalize_module_token "$name")" )
    done
    printf "%s" "${normalized[*]}"
}

function normalize_module_token
{
    local token="$1"
    token="${token%,}"
    token="${token%;}"
    token="${token#\"}"
    token="${token%\"}"
    token="${token#\'}"
    token="${token%\'}"

    if [[ -n "${ALIASES[$token]:-}" ]]; then
        printf "%s" "${ALIASES[$token]}"
        return 0
    fi

    printf "%s" "$token"
}

function is_selected_module
{
    local module="$1"
    [[ -z "$MODULE_FILTER" || "$MODULE_FILTER" == "$module" ]]
}

function classify_path
{
    local path="$1"

    case "$path" in
        */docs/*|*/documentation/*|*/README*|*/CHANGELOG*|*/LICENSE*)
            printf "%s" "ignored"
            ;;
        */test/*|*/tests/*|*/test*App/*|*/unitTest*/*|*/demo*/*|*/example*/*|*/iocBoot/*)
            printf "%s" "optional"
            ;;
        */O.*/*)
            printf "%s" "ignored"
            ;;
        */os/Linux/*|*/os/posix/*|*/os/default/*)
            if [[ -z "$PLATFORM" || "$PLATFORM" == "Linux" ]]; then
                printf "%s" "active"
            else
                printf "%s" "optional"
            fi
            ;;
        */os/Darwin/*|*/os/vxWorks/*|*/os/WIN32/*|*/os/RTEMS/*|*/os/solaris/*)
            printf "%s" "optional"
            ;;
        *)
            printf "%s" "active"
            ;;
    esac
}

function evidence_class_for_path
{
    local path="$1"
    local context
    context="$(classify_path "$path")"
    case "$context" in
        active) printf "%s" "required" ;;
        optional) printf "%s" "optional" ;;
        *) printf "%s" "ignored" ;;
    esac
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

function build_artifact_catalog
{
    local module
    local source_path
    local full_path
    local file
    local base

    for module in "${MODULES[@]}"; do
        source_path="${MODULE_BY_PATH[$module]}"
        full_path="${TOP}/${source_path}"
        [[ -d "$full_path" ]] || continue
        while IFS= read -r -d '' file; do
            base="${file##*/}"
            case "$base" in
                *.dbd) add_catalog_value DBD_CATALOG "$base" "$module" ;;
            esac
        done < <(find "$full_path" -type f -name "*.dbd" -print0)
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

    token="$(trim "$token")"
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

    normalized="$(normalize_module_token "$token")"
    if module_exists "$normalized"; then
        add_record "$module" "$normalized" "$class" "$source" "$path" "$line_no" "$token"
        return 0
    fi

    add_unknown "$module" "$token" "$class" "$source" "$path" "$line_no"
}

function module_exists
{
    local needle="$1"
    local module
    for module in "${MODULES[@]}"; do
        [[ "$module" == "$needle" ]] && return 0
    done
    return 1
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
    display_path="$(relative_path "$file")"
    while IFS= read -r line || [[ -n "$line" ]]; do
        line_no=$((line_no + 1))
        line="${line%%#*}"
        line="$(trim "$line")"
        [[ "$line" =~ ^([A-Za-z0-9_]+)[[:space:]]*:?=[[:space:]]*(.*)$ ]] || continue
        macro="${BASH_REMATCH[1]}"
        value="$(trim "${BASH_REMATCH[2]}")"
        [[ "$macro" == "EPICS_BASE" || "$macro" == "SUPPORT" ]] && continue
        [[ -n "$value" ]] || continue
        [[ "$value" == "YES" || "$value" == "NO" ]] && continue
        dep="$(normalize_module_token "$macro")"
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

    line="${line%%#*}"
    line="$(trim "$line")"
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

function scan_makefiles
{
    local module="$1"
    local source_path="${MODULE_BY_PATH[$module]}"
    local source_root="${TOP}/${source_path}"
    local file
    local line
    local line_no
    local class
    local display_path

    [[ -d "$source_root" ]] || return 0
    while IFS= read -r -d '' file; do
        class="$(evidence_class_for_path "$file")"
        [[ "$class" != "ignored" ]] || continue
        display_path="$(relative_path "$file")"
        line_no=0
        while IFS= read -r line || [[ -n "$line" ]]; do
            line_no=$((line_no + 1))
            scan_makefile_line "$module" "$display_path" "$line_no" "$line" "$class"
        done < "$file"
    done < <(find "$source_root" -type f -name Makefile -print0)
}

function scan_dbd_files
{
    local module="$1"
    local source_path="${MODULE_BY_PATH[$module]}"
    local source_root="${TOP}/${source_path}"
    local file
    local line
    local line_no
    local class
    local include_name
    local display_path

    [[ -d "$source_root" ]] || return 0
    while IFS= read -r -d '' file; do
        class="$(evidence_class_for_path "$file")"
        [[ "$class" != "ignored" ]] || continue
        display_path="$(relative_path "$file")"
        line_no=0
        while IFS= read -r line || [[ -n "$line" ]]; do
            line_no=$((line_no + 1))
            if [[ "$line" =~ include[[:space:]]+\"([^\"]+\.dbd)\" ]]; then
                include_name="${BASH_REMATCH[1]##*/}"
                classify_dbd_token "$module" "$include_name" "$class" "dbd-include" "$display_path" "$line_no"
            fi
        done < "$file"
    done < <(find "$source_root" -type f -name "*.dbd" -print0)
}

function scan_module
{
    local module="$1"
    scan_release_local "$module"
    scan_makefiles "$module"
    scan_dbd_files "$module"
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

    observed_required="$(required_observed_set "$module" | paste -sd ' ' -)"

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
        printf "Strict mode is report-only in Phase 4A.\n"
    fi
    printf "\n"

    for module in "${MODULES[@]}"; do
        is_selected_module "$module" || continue
        print_module_text "$module"
    done
}

function main
{
    parse_args "$@"
    load_make_metadata
    build_artifact_catalog

    local module
    local selected_count=0
    for module in "${MODULES[@]}"; do
        is_selected_module "$module" || continue
        selected_count=$((selected_count + 1))
        scan_module "$module"
    done

    [[ "$selected_count" -gt 0 ]] || die "No module matched: $MODULE_FILTER"
    print_report
}

main "$@"
