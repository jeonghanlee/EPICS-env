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
#  version : 0.0.21

# -----------------------------------------------------------------------------
# Environment Settings
# -----------------------------------------------------------------------------
# Disable X11 forwarding for git operations to prevent "request failed" warnings
export GIT_SSH_COMMAND="ssh -x"

declare -g SC_RPATH
declare -g SC_TOP

SC_RPATH="$(realpath "$0")"
SC_TOP="${SC_RPATH%/*}"

# -----------------------------------------------------------------------------
# Global Path Configurations
# -----------------------------------------------------------------------------
declare -g PROJECT_ROOT="${SC_TOP}/.."
declare -g CONFIG_DIR="${PROJECT_ROOT}/configure"
declare -g RELEASE_FILE="${CONFIG_DIR}/RELEASE"
declare -g NEW_FILE="${RELEASE_FILE}.new"
declare -g BACKUP_FILE="${RELEASE_FILE}.bak"

# Track which modules were auto-updated OR manually changed to enforce validation
declare -g UPDATED_MODULES=""

# -----------------------------------------------------------------------------
# Timeout Settings for curl
# -----------------------------------------------------------------------------
declare -gi CURL_TIMEOUT_WITH_TOKEN=3
declare -gi CURL_TIMEOUT_NO_TOKEN=1

# -----------------------------------------------------------------------------
# Output & Color Settings
# -----------------------------------------------------------------------------
declare -g RED='\033[0;31m'
declare -g GREEN='\033[0;32m'
declare -g MAGENTA='\033[1;35m'
declare -g BLUE='\033[0;34m'
declare -g CYAN='\033[0;36m'
declare -g YELLOW='\033[0;33m'
declare -g NC='\033[0m'

# Enable core dumps in case the JVM fails
ulimit -c unlimited

# Global Verbose Flag (Default: false)
declare -g VERBOSE=false

# Function: pushdd
# Description: Wrapper for pushd to suppress output
function pushdd { builtin pushd "$@" > /dev/null || exit; }

# Function: popdd
# Description: Wrapper for popd to suppress output
function popdd  { builtin popd  > /dev/null || exit; }

# Function: _check_file_exists
# Description: Validates the existence of the RELEASE file
function _check_file_exists
{
    if [ ! -f "$RELEASE_FILE" ]; then
        printf "%bError: RELEASE file not found at %s%b\n" "${RED}" "${RELEASE_FILE}" "${NC}" >&2
        exit 1
    fi
}

# Function: _check_token_status
# Description: Checks for GITHUB_TOKEN to determine API rate limits
function _check_token_status
{
    if [ "$VERBOSE" = false ]; then
        return
    fi

    if [ -n "$GITHUB_TOKEN" ]; then
        printf "%b>>> GITHUB_TOKEN found.%b Full API features enabled.\n" "${GREEN}" "${NC}"
    else
        printf "%b>>> GITHUB_TOKEN not found.%b Running in limited mode (60 requests/hr).\n" "${MAGENTA}" "${NC}"
    fi
    printf "\n"
}

# Function: _fetch_github_api
# Description: Helper to execute curl commands against GitHub API
function _fetch_github_api
{
    local url="$1"
    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -L --max-time ${CURL_TIMEOUT_WITH_TOKEN} -H "User-Agent: EPICS-env" -H "Authorization: Bearer $GITHUB_TOKEN" "$url"
    else
        curl -s -L --max-time ${CURL_TIMEOUT_NO_TOKEN} -H "User-Agent: EPICS-env" "$url"
    fi
}

# Function: _get_commit_date
# Description: Fetches the commit date for a specific hash using the GitHub API.
function _get_commit_date
{
    local repo_url="$1"
    local commit_hash="$2"

    if [ -z "$commit_hash" ]; then
        printf "Unknown"
        return
    fi

    local web_url="${repo_url%.git}"
    local api_base="${web_url/https:\/\/github.com/https:\/\/api.github.com\/repos}"
    local commit_api="${api_base}/commits/${commit_hash}"

    local json_resp
    json_resp=$(_fetch_github_api "$commit_api")

    local date_str=""
    if [ -n "$json_resp" ]; then
        date_str=$(printf "%s" "$json_resp" | grep -o '"date":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4 | cut -d 'T' -f 1)
    fi

    if [ -n "$date_str" ]; then
        printf "%s" "$date_str"
    else
        printf "Unknown"
    fi
}

# Function: _print_diff_info
# Description: Prints comparison details between old and new versions
function _print_diff_info
{
    local repo_url="$1"
    local old_ver="$2"
    local new_ver="$3"

    local web_url="${repo_url%.git}"
    local compare_url="${web_url}/compare/${old_ver}...${new_ver}"

    printf "    %b>> Diff Link:%b %s\n" "${CYAN}" "${NC}" "${compare_url}"
}

# Function: _validate_generated_file
# Description: Scans the newly generated RELEASE file.
#              Validates modules updated automatically OR manually.
#              Skips validation ONLY for "Keep Old Version".
function _validate_generated_file
{
    local target_file="$1"
    local issues_found=0

    printf "%s\n" "--- performing Final Integrity Check ---"

    while IFS= read -r line; do
        if [[ "$line" =~ ^SRC_VER_([A-Z0-9_]+):=(.*) ]]; then
            local suffix="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"

            # Check if this module is in the UPDATED_MODULES list
            # We surround with spaces to ensure exact match
            if [[ " $UPDATED_MODULES " == *" $suffix "* ]]; then

                # Validation Rule: Must be numeric+dots OR git hash
                if [[ ! "$value" =~ ^[0-9.]+$ ]] && [[ ! "$value" =~ ^[0-9a-fA-F]{7,40}$ ]]; then
                    printf "  %b[WARN]%b Suspicous version format in %s: '%s'\n" "${RED}" "${NC}" "SRC_VER_${suffix}" "$value"
                    ((issues_found++))
                fi
            else
                # Module was not touched (Keep Old), skip validation.
                :
            fi
        fi
    done < "$target_file"

    if [ "$issues_found" -eq 0 ]; then
        printf "  %b[PASS]%b Integrity check passed.\n" "${GREEN}" "${NC}"
        return 0
    else
        printf "  %b[FAIL]%b Found %d potential issue(s) in updated modules.\n" "${RED}" "${NC}" "$issues_found"
        return 1
    fi
}


# Function: _sanitize_version
# Description: Extracts a 3-digit version (X.Y.Z) from a tag string.
#              Preserves the original if it already matches the expected format.
function _sanitize_version
{
    local input_tag="$1"
    local clean_ver

    clean_ver="${input_tag#tags/}"
    clean_ver="${clean_ver#v}"

    # If it is a git hash, return as is
    if [[ "$clean_ver" =~ ^[0-9a-fA-F]{7,40}$ ]]; then
        printf "%s" "$clean_ver"
        return
    fi

    # Extract only digits and dots, then parse Major.Minor.Patch
    local numeric_part
    numeric_part=$(printf "%s" "$clean_ver" | tr -cd '0-9.')

    IFS='.' read -r -a parts <<< "$numeric_part"

    local major="${parts[0]:-0}"
    local minor="${parts[1]:-0}"
    local patch="${parts[2]:-0}"

    printf "%d.%d.%d" "$major" "$minor" "$patch"
}

# Function: _check_updates_only
# Description: Read-only check for available updates without modifying any files
function _check_updates_only
{
    local current_module_suffix=""
    local current_repo_url=""
    local updates_found=0

    printf "%s\n" "--- Checking for Updates (Read-Only) ---"

    while IFS= read -u 3 -r line; do
        # Parse Repository URL from comments
        if [[ "$line" =~ ^#+[[:space:]]*(https://.*) ]]; then
            current_repo_url=$(printf "%s" "${BASH_REMATCH[1]}" | xargs)
            continue
        fi

        # Skip empty lines
        if [[ -z "$line" ]]; then
            continue
        fi

        # Parse SRC_NAME to determine module
        if [[ "$line" =~ ^SRC_NAME_([A-Z0-9_]+):=(.*) ]]; then
            current_module_suffix="${BASH_REMATCH[1]}"
            continue
        fi

        # Parse SRC_TAG
        if [[ "$line" =~ ^SRC_TAG_([A-Z0-9_]+):=(.*) ]]; then
            local tag_suffix="${BASH_REMATCH[1]}"
            local current_val="${BASH_REMATCH[2]}"

            if [[ "$tag_suffix" != "$current_module_suffix" ]]; then
                continue
            fi

            if [[ -z "$current_repo_url" ]]; then
                continue
            fi

            # Fetch remote HEAD
            local new_head_val
            new_head_val=$(git ls-remote "${current_repo_url}" HEAD 2>/dev/null | awk '{print $1}')

            if [ -z "$new_head_val" ]; then
                continue
            fi

            local new_head_hash="$new_head_val"
            new_head_val=$(printf "%.7s" "$new_head_val")

            # Check if current version matches HEAD
            local match_found=false

            if [[ "$current_val" =~ ^[0-9a-fA-F]{7,40}$ ]]; then
                if [[ "$new_head_hash" == "$current_val"* ]]; then
                    match_found=true
                fi
            else
                local tag_ref="$current_val"
                if [[ "$tag_ref" == tags/* ]]; then
                    tag_ref="refs/${tag_ref}"
                fi
                local current_tag_refs
                current_tag_refs=$(git ls-remote "$current_repo_url" "$tag_ref" 2>/dev/null)
                if [[ -n "$new_head_hash" && "$current_tag_refs" == *"$new_head_hash"* ]]; then
                    match_found=true
                fi
            fi

            if [ "$match_found" = true ]; then
                printf "%b%-15s%b: %bOK%b (Current: %s matches HEAD)\n" \
                    "${MAGENTA}" "${current_module_suffix}" "${NC}" \
                    "${BLUE}" "${NC}" "${current_val}"
            else
                printf "%b%-15s%b: %bUPDATE AVAILABLE%b\n" \
                    "${MAGENTA}" "${current_module_suffix}" "${NC}" \
                    "${GREEN}" "${NC}"
                printf "    Current: %s\n" "${current_val}"
                printf "    Latest:  %s\n" "${new_head_val}"

                local head_date="Unknown"
                if [ -n "$new_head_hash" ]; then
                    head_date=$(_get_commit_date "$current_repo_url" "$new_head_hash")
                fi
                printf "    Date:    %s\n" "${head_date}"

                _print_diff_info "$current_repo_url" "$current_val" "$new_head_val"
                ((updates_found++))
            fi
        fi
    done 3< "$RELEASE_FILE"

    printf "\n"
    if [ "$updates_found" -eq 0 ]; then
        printf "%bAll modules are up to date.%b\n" "${GREEN}" "${NC}"
    else
        printf "%bFound %d module(s) with available updates.%b\n" "${YELLOW}" "$updates_found" "${NC}"
        printf "Run '%s update' to apply changes interactively.\n" "${0##*/}"
    fi
}

# Function: _process_release_file
# Description: Parses the RELEASE file and handles version updates interactively.
function _process_release_file
{
    local current_module_suffix=""
    local current_repo_url=""
    local tag_changed=false
    local active_tag_val=""

#    > "$NEW_FILE"
    UPDATED_MODULES=""

    exec 3< "$RELEASE_FILE"

    while IFS= read -u 3 -r line; do
        # Reset tag_changed flag for each new module
        if [[ "$line" =~ ^SRC_NAME_([A-Z0-9_]+):= ]]; then
            tag_changed=false
        fi

        # 1. Parse Repository URL from comments
        if [[ "$line" =~ ^#+[[:space:]]*(https://.*) ]]; then
            current_repo_url=$(printf "%s" "${BASH_REMATCH[1]}" | xargs)
            printf "%s\n" "$line" >> "$NEW_FILE"
            continue
        fi

        # 2. Skip empty lines and other comments
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "$line" ]]; then
            printf "%s\n" "$line" >> "$NEW_FILE"
            continue
        fi

        # 3. Process Module Name (SRC_NAME)
        if [[ "$line" =~ ^SRC_NAME_([A-Z0-9_]+):=(.*) ]]; then
            current_module_suffix="${BASH_REMATCH[1]}"
            printf "%s\n" "$line" >> "$NEW_FILE"
            continue
        fi

        # 4. Process Tag/Version Reference (SRC_TAG)
        if [[ "$line" =~ ^SRC_TAG_([A-Z0-9_]+):=(.*) ]]; then
            local tag_suffix="${BASH_REMATCH[1]}"
            local current_val="${BASH_REMATCH[2]}"

            if [[ "$tag_suffix" == "$current_module_suffix" && -n "$current_repo_url" ]]; then
                printf "%b>> Checking %s%b: " "${MAGENTA}" "${current_module_suffix}" "${NC}"

                local new_head_val
                new_head_val=$(git ls-remote "${current_repo_url}" HEAD 2>/dev/null | awk '{print $1}')

                if [ -z "$new_head_val" ]; then
                    printf "%bSKIP%b (Remote not accessible)\n" "${YELLOW}" "${NC}"
                    printf "%s\n" "$line" >> "$NEW_FILE"
                    active_tag_val="$current_val"
                    continue
                fi

                local new_head_hash="$new_head_val"
                new_head_val=$(printf "%.7s" "$new_head_val")

                local match_found=false

                if [[ "$current_val" =~ ^[0-9a-fA-F]{7,40}$ ]]; then
                    if [[ "$new_head_hash" == "$current_val"* ]]; then
                        match_found=true
                    fi
                else
                    local tag_ref="$current_val"
                    if [[ "$tag_ref" == tags/* ]]; then
                        tag_ref="refs/${tag_ref}"
                    fi
                    local current_tag_refs
                    current_tag_refs=$(git ls-remote "$current_repo_url" "$tag_ref" 2>/dev/null)
                    if [[ -n "$new_head_hash" && "$current_tag_refs" == *"$new_head_hash"* ]]; then
                        match_found=true
                    fi
                fi

                if [ "$match_found" = true ]; then
                    printf "%bOK%b (Matches HEAD)\n" "${BLUE}" "${NC}"
                    printf "%s\n" "$line" >> "$NEW_FILE"
                    active_tag_val="$current_val"
                else
                    printf "%bUPDATE DETECTED%b\n" "${GREEN}" "${NC}"
                    _print_diff_info "$current_repo_url" "$current_val" "$new_head_val"

                    local head_date="Unknown"
                    if [ -n "$new_head_hash" ]; then
                        head_date=$(_get_commit_date "$current_repo_url" "$new_head_hash")
                    fi

                    while true; do
                        printf "\n"
                        printf "Select version for %b%s%b:\n" "${MAGENTA}" "${current_module_suffix}" "${NC}"
                        printf "  1) Keep Old Version             (%s) (Default)\n" "${current_val}"
                        printf "  2) Apply Latest HEAD            (%s) [%s]\n" "${new_head_val}" "${head_date}"
                        printf "  3) Enter Specific Version/Hash manually\n"
                        printf "  4) Exit (Cancel Update)\n"
                        printf "Enter number [1]: "
                        read -r choice
                        choice=${choice:-1}

                        case "$choice" in
                            1)
                                printf ">> %bKept Old Version%b\n" "${BLUE}" "${NC}"
                                printf "%s\n" "$line" >> "$NEW_FILE"
                                active_tag_val="$current_val"
                                break
                                ;;
                            2)
                                printf ">> %bSelected HEAD Version%b\n" "${GREEN}" "${NC}"
                                printf "SRC_TAG_%s:=%s\n" "${tag_suffix}" "${new_head_val}" >> "$NEW_FILE"
                                active_tag_val="$new_head_val"
                                tag_changed=true
                                UPDATED_MODULES+="${tag_suffix} "
                                break
                                ;;
                            3)
                                printf "Enter Version/Tag/Hash: "
                                read -r custom_val
                                if [ -z "$custom_val" ]; then
                                    printf "%bError: Input cannot be empty.%b\n" "${RED}" "${NC}"
                                    continue
                                fi
                                printf ">> %bSelected: %s%b\n" "${GREEN}" "$custom_val" "${NC}"
                                printf "SRC_TAG_%s:=%s\n" "${tag_suffix}" "${custom_val}" >> "$NEW_FILE"
                                active_tag_val="$custom_val"
                                tag_changed=true
                                UPDATED_MODULES+="${tag_suffix} "
                                break
                                ;;
                            4)
                                printf "%bUpdate cancelled.%b\n" "${YELLOW}" "${NC}"
                                rm -f "$NEW_FILE"
                                exit 0
                                ;;
                            *)
                                printf ">> Invalid input. Defaulting to option 1.\n"
                                printf "%s\n" "$line" >> "$NEW_FILE"
                                active_tag_val="$current_val"
                                break
                                ;;
                        esac
                    done
                fi
            else
                printf "%s\n" "$line" >> "$NEW_FILE"
                active_tag_val="$current_val"
            fi
            continue
        fi

        # 5. Process Version Number (SRC_VER)
        if [[ "$line" =~ ^SRC_VER_([A-Z0-9_]+):=(.*) ]]; then
            local ver_suffix="${BASH_REMATCH[1]}"
            if [[ "$ver_suffix" == "$current_module_suffix" && "$tag_changed" = true ]]; then
                local sanitized_ver
                sanitized_ver=$(_sanitize_version "$active_tag_val")
                printf "SRC_VER_%s:=%s\n" "${ver_suffix}" "${sanitized_ver}" >> "$NEW_FILE"
            else
                printf "%s\n" "$line" >> "$NEW_FILE"
            fi
            continue
        fi

        # 6. Passthrough for other lines
        printf "%s\n" "$line" >> "$NEW_FILE"
    done 3< "$RELEASE_FILE"
}

# Function: _finalize_changes
# Description: Summarizes changes, Validates, and prompts for confirmation
function _finalize_changes
{
    printf "%s\n" "--- Summary ---"
    if diff -q "$RELEASE_FILE" "$NEW_FILE" > /dev/null; then
        printf "%bNo updates applied.%b\n" "${GREEN}" "${NC}"
        rm "$NEW_FILE"
    else
        printf "%bChanges Summary:%b\n" "${MAGENTA}" "${NC}"
        printf "%s\n" "---------------------------------------------------"
        diff -u --color=always "$RELEASE_FILE" "$NEW_FILE"
        printf "%s\n" "---------------------------------------------------"

        _validate_generated_file "$NEW_FILE"

        printf "Do you want to save these changes? [Y/n]: "
        read -r choice
        choice=${choice:-Y}

        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            cp "$RELEASE_FILE" "$BACKUP_FILE"
            mv "$NEW_FILE" "$RELEASE_FILE"
            printf "%bUpdated RELEASE file.%b Backup saved to %s\n" "${GREEN}" "${NC}" "${BACKUP_FILE}"
        else
            rm "$NEW_FILE"
            printf "%bUpdate cancelled.%b\n" "${RED}" "${NC}"
        fi
    fi
}

# Function: check
# Description: Read-only check for updates
function check
{
    _check_file_exists
    _check_token_status
    _check_updates_only
}

# Function: update
# Description: Checks for updates and prompts to apply them
function update
{
    _check_file_exists
    _check_token_status
    _process_release_file
    _finalize_changes
}

# Function: usage
# Description: Prints help message
function usage
{
   cat << EOF

Usage: ${0##*/} [OPTIONS] <command>

Options:
  -v, --verbose       Fetch detailed commit info (Date, Msg, Author) via CURL.
                      (Slower, but provides more context)

Environment:
  GITHUB_TOKEN        - Optional. Improves API rate limits.

Commands:
  check               - Check for updates (Read-only, no file modification)
  update              - Check and prompt to apply changes (Interactive)
  help                - Displays this help message.
EOF
    exit 1;
}

# -----------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    --*|-*)
      printf "Unknown option %s\n" "$1"
      usage
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}"

if [ "$#" -eq 0 ]; then
    usage
fi

COMMAND="$1"

case "$COMMAND" in
    check)
        check
        ;;
    update)
        update
        ;;
    help)
        usage
        ;;
    *)
        printf "Error: Unknown command '%s'\n" "$COMMAND" >&2
        usage
        ;;
esac
