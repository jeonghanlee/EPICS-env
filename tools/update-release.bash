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


declare -g SC_RPATH
declare -g SC_TOP
declare -g SC_TIME

SC_RPATH="$(realpath "$0")"
SC_TOP="${SC_RPATH%/*}"
SC_TIME="$(date +%y%m%d%H%M)"

# -----------------------------------------------------------------------------
# Global Path Configurations
# -----------------------------------------------------------------------------
declare -g PROJECT_ROOT="${SC_TOP}/.."
declare -g CONFIG_DIR="${PROJECT_ROOT}/configure"
declare -g RELEASE_FILE="${CONFIG_DIR}/RELEASE"
declare -g NEW_FILE="${RELEASE_FILE}.new"
declare -g BACKUP_FILE="${RELEASE_FILE}.bak"

# -----------------------------------------------------------------------------
# Output & Color Settings
# -----------------------------------------------------------------------------
declare -g RED='\033[0;31m'
declare -g GREEN='\033[0;32m'
declare -g MAGENTA='\033[1;35m'
declare -g BLUE='\033[0;34m'
declare -g CYAN='\033[0;36m'
declare -g NC='\033[0m' # No Color

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
        curl -s -L --max-time 3 -H "User-Agent: EPICS-env" -H "Authorization: Bearer $GITHUB_TOKEN" "$url"
    else
        curl -s -L --max-time 1 -H "User-Agent: EPICS-env" "$url"
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

    if [ "$VERBOSE" = false ]; then
        return
    fi

    local api_base="${web_url/https:\/\/github.com/https:\/\/api.github.com\/repos}"
    local compare_api="${api_base}/compare/${old_ver}...${new_ver}"
    local new_commit_api="${api_base}/commits/${new_ver}"
    local old_commit_api="${api_base}/commits/${old_ver}"

    # A. Fetch NEW Commit Details
    local new_json
    new_json=$(_fetch_github_api "$new_commit_api")

    local new_date=""
    local last_author=""
    local last_msg=""

    if [ -z "$new_json" ]; then
         printf "    %b>> Connection Failed:%b " "${RED}" "${NC}"
         local curl_err
         if [ -n "$GITHUB_TOKEN" ]; then
             curl_err=$(curl -sS -L --max-time 2 -H "User-Agent: EPICS-env" -H "Authorization: Bearer $GITHUB_TOKEN" "$new_commit_api" 2>&1 >/dev/null)
         else
             curl_err=$(curl -sS -L --max-time 1 -H "User-Agent: EPICS-env" "$new_commit_api" 2>&1 >/dev/null)
         fi
         printf "%s\n" "${curl_err}"

    else
        new_date=$(echo "$new_json" | grep -o '"date":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4 | cut -d 'T' -f 1)

        if [ -z "$new_date" ]; then
             local err_msg
             err_msg=$(echo "$new_json" | grep -o '"message":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4)
             if [ -n "$err_msg" ]; then
                 printf "    %b>> API Error:%b %s\n" "${RED}" "${NC}" "$err_msg"
             else
                 local raw_snippet=${new_json:0:60}
                 if [[ "$raw_snippet" != *"{"* ]]; then
                     printf "    %b>> API Error:%b Invalid Response (Not JSON).\n" "${RED}" "${NC}"
                 fi
             fi
        else
            last_author=$(echo "$new_json" | grep -o '"name":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4)
            last_msg=$(echo "$new_json" | grep -o '"message":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4)
        fi
    fi

    # B. Fetch OLD Commit Details (Date Only)
    local old_date=""
    if [ -n "$new_date" ]; then
        local old_json
        old_json=$(_fetch_github_api "$old_commit_api")
        if [ -n "$old_json" ]; then
            old_date=$(echo "$old_json" | grep -o '"date":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4 | cut -d 'T' -f 1)
        fi
    fi

    # C. Print Details
    if [ -n "$new_date" ]; then
        local date_str="${MAGENTA}${new_date}${NC}"
        if [ -n "$old_date" ]; then
            date_str="${old_date} -> ${MAGENTA}${new_date}${NC}"
        fi

        printf "    %b>> Info     :%b Date: %s | Author: %s\n" "${CYAN}" "${NC}" "${date_str}" "${last_author}"

        if [ ${#last_msg} -gt 60 ]; then
            last_msg="${last_msg:0:57}..."
        fi
        printf "    %b>> Message  :%b \"%s\"\n" "${CYAN}" "${NC}" "${last_msg}"
    fi

    # D. Fetch Stats (Commit Count)
    if [ -n "$new_date" ]; then
        local compare_json
        compare_json=$(_fetch_github_api "$compare_api")
        if [ -n "$compare_json" ]; then
            local commit_count
            commit_count=$(echo "$compare_json" | grep -o '"total_commits":[[:space:]]*[0-9]*' | grep -o '[0-9]*')
            if [ -n "$commit_count" ]; then
                printf "    %b>> Stats    :%b %s commits ahead.\n" "${CYAN}" "${NC}" "${commit_count}"
            fi
        fi
    fi
}

# Function: _sanitize_version
# Description: Converts a git tag into a semantic version string OR preserves Git Hash.
#              1. Removes 'tags/' prefix.
#              2. Checks if the remaining string is a pure Hex Git Hash (7-40 chars).
#              3. If Git Hash, return as is.
#              4. If Tag, strips non-digit prefixes, normalizes separators, applies SemVer.
function _sanitize_version
{
    local input_tag="$1"
    local clean_ver

    # 1. Remove 'tags/' prefix first
    clean_ver="${input_tag#tags/}"

    # 2. Check if it looks like a Git Hash (Hex string, 7-40 chars, no dots/hyphens)
    #    This prevents stripping 'd', 'e', 'f', 'a', 'b', 'c' from the start of a hash.
    if [[ "$clean_ver" =~ ^[0-9a-fA-F]{7,40}$ ]]; then
        printf "%s" "$clean_ver"
        return
    fi

    # 3. If NOT a hash, proceed with aggressive Tag sanitization

    # Remove everything leading up to the first digit (v, R, module-)
    clean_ver=$(echo "$clean_ver" | sed 's/^[^0-9]*//')

    # Replace all hyphens and underscores with dots
    clean_ver="${clean_ver//-/.}"
    clean_ver="${clean_ver//_/.}"

    # Check if format is strictly Number.Number (e.g., 4.45 or 1.3)
    # If so, append .0 to make it Number.Number.0
    if [[ "$clean_ver" =~ ^[0-9]+\.[0-9]+$ ]]; then
        clean_ver="${clean_ver}.0"
    fi

    printf "%s" "$clean_ver"
}

# Function: _process_release_file
# Description: Parses the RELEASE file, checks for updates, and applies changes
function _process_release_file
{
    local mode="$1"
    local current_repo_url=""
    local current_module_suffix=""
    local active_tag_val="" # Holds the determined tag (either old or new)

    printf "%s\n" "--- Processing RELEASE file: ${RELEASE_FILE} ---"

    > "$NEW_FILE"

    # Use FD 3 to allow reading user input (stdin) inside the loop
    while IFS= read -r line <&3 || [ -n "$line" ]; do

        # 1. Parse URL from comments
        if [[ "$line" =~ ^#+[[:space:]]*(https://.*) ]]; then
            current_repo_url=$(echo "${BASH_REMATCH[1]}" | xargs)
        fi

        # 2. Parse Module Name
        if [[ "$line" =~ ^SRC_NAME_([A-Z0-9_]+):=(.*) ]]; then
            current_module_suffix="${BASH_REMATCH[1]}"
            local module_raw_name="${BASH_REMATCH[2]}"

            # Cross-Validation: URL vs Module Name
            if [ -n "$current_repo_url" ]; then
                local repo_clean="${current_repo_url%.git}"
                local repo_name="${repo_clean##*/}"
                local mod_lower="${module_raw_name,,}"
                local repo_lower="${repo_name,,}"

                if [[ "$repo_lower" != *"$mod_lower"* && "$mod_lower" != *"$repo_lower"* ]]; then
                     printf "\n"
                     printf "%b>>> FATAL ERROR: Repo URL / Module Name Mismatch!%b\n" "${RED}" "${NC}"
                     printf "    It seems the URL comment is missing for module: %b%s%b\n" "${MAGENTA}" "${module_raw_name}" "${NC}"
                     printf "    Active URL  : %s\n" "${current_repo_url}"
                     printf "    Module Name : %s\n" "${module_raw_name}"
                     printf "\n"
                     exit 1
                 fi
            fi
        fi

        # 3. Process TAG
        if [[ "$line" =~ ^SRC_TAG_([A-Z0-9_]+):=(.*) ]]; then
            local tag_suffix="${BASH_REMATCH[1]}"
            local current_val="${BASH_REMATCH[2]}"

            if [[ "$tag_suffix" == "$current_module_suffix" && -n "$current_repo_url" ]]; then
                printf " Checking %b%s%b ... " "${MAGENTA}" "${tag_suffix}" "${NC}"

                local remote_refs
                remote_refs=$(git ls-remote "$current_repo_url" 2>/dev/null)

                if [ -z "$remote_refs" ]; then
                    printf "%bFAILED%b (git ls-remote failed)\n" "${RED}" "${NC}"
                    printf "%s\n" "$line" >> "$NEW_FILE"
                    active_tag_val="$current_val"
                else
                    # Find HEAD Hash
                    local head_hash
                    head_hash=$(echo "$remote_refs" | awk '/HEAD/ {print $1}' | head -n 1)

                    if [ -z "$head_hash" ]; then
                         printf "%bFAILED%b (No HEAD found)\n" "${RED}" "${NC}"
                         printf "%s\n" "$line" >> "$NEW_FILE"
                         active_tag_val="$current_val"
                         continue
                    fi

                    # Check if Hash matches a Tag
                    local matching_tag_ref
                    matching_tag_ref=$(echo "$remote_refs" | grep "$head_hash" | grep "refs/tags/" | head -n 1 | awk '{print $2}')

                    local new_val=""
                    if [ -n "$matching_tag_ref" ]; then
                        new_val=$(echo "$matching_tag_ref" | sed -e 's/\^{}$//' -e 's/^refs\///')
                    else
                        new_val="${head_hash:0:7}"
                    fi

                    # Compare and Update
                    if [ "$current_val" != "$new_val" ]; then

                        if [ "$mode" == "apply" ]; then
                            printf "%bUPDATE DETECTED%b\n" "${GREEN}" "${NC}"
                            _print_diff_info "$current_repo_url" "$current_val" "$new_val"

                            while true; do
                                printf "\n"
                                printf "Select version for %b%s%b:\n" "${MAGENTA}" "${current_module_suffix}" "${NC}"
                                printf "  1) Keep Old Version           (%s) (Default)\n" "${current_val}"
                                printf "  2) Apply Latest Remote Version (%s)\n" "${new_val}"
                                printf "  3) Enter Specific Version/Hash manually\n"
                                printf "  4) Exit (Cancel Update)\n"

                                read -p "Enter number [1]: " choice
                                choice=${choice:-1}

                                case "$choice" in
                                    1)
                                        printf ">> %bKept Old Version%b\n" "${BLUE}" "${NC}"
                                        printf "%s\n" "$line" >> "$NEW_FILE"
                                        active_tag_val="$current_val"
                                        break
                                        ;;
                                    2)
                                        printf ">> %bSelected New Version%b\n" "${GREEN}" "${NC}"
                                        printf "SRC_TAG_%s:=%s\n" "${tag_suffix}" "${new_val}" >> "$NEW_FILE"
                                        active_tag_val="$new_val"
                                        break
                                        ;;
                                    3)
                                        read -p "Enter Version/Tag/Hash: " custom_val
                                        if [ -z "$custom_val" ]; then
                                            printf "%bError: Input cannot be empty.%b\n" "${RED}" "${NC}"
                                            continue
                                        fi

                                        if git ls-remote --exit-code "$current_repo_url" "$custom_val" > /dev/null 2>&1 || \
                                           echo "$remote_refs" | grep -q "$custom_val"; then
                                            printf ">> %bValidated and Selected: %s%b\n" "${GREEN}" "$custom_val" "${NC}"
                                            printf "SRC_TAG_%s:=%s\n" "${tag_suffix}" "${custom_val}" >> "$NEW_FILE"
                                            active_tag_val="$custom_val"
                                            break
                                        else
                                            printf "%bWarning: '%s' not found as a Tag or Branch on remote.%b\n" "${RED}" "$custom_val" "${NC}"
                                            read -p "Do you want to apply it anyway? [y/N]: " force_choice
                                            if [[ "$force_choice" == "y" || "$force_choice" == "Y" ]]; then
                                                printf ">> %bForced selection: %s%b\n" "${GREEN}" "$custom_val" "${NC}"
                                                printf "SRC_TAG_%s:=%s\n" "${tag_suffix}" "${custom_val}" >> "$NEW_FILE"
                                                active_tag_val="$custom_val"
                                                break
                                            else
                                                printf "Please try again.\n"
                                                continue
                                            fi
                                        fi
                                        ;;
                                    4)
                                        printf "%bUpdate cancelled by user. Exiting...%b\n" "${YELLOW}" "${NC}"
                                        rm -f "$NEW_FILE"
                                        exit 0
                                        ;;
                                    *)
                                        printf ">> Invalid input '%s'. Defaulting to %bKeep Old Version%b\n" "$choice" "${BLUE}" "${NC}"
                                        printf "%s\n" "$line" >> "$NEW_FILE"
                                        active_tag_val="$current_val"
                                        break
                                        ;;
                                esac
                            done
                            printf "\n"
                        else
                            # Check Mode
                            printf "%bUPDATE%b (%s -> %s)\n" "${GREEN}" "${NC}" "$current_val" "$new_val"
                            printf "SRC_TAG_%s:=%s\n" "${tag_suffix}" "${new_val}" >> "$NEW_FILE"
                            active_tag_val="$new_val"
                            _print_diff_info "$current_repo_url" "$current_val" "$new_val"
                        fi
                    else
                        printf "%bOK%b (Matches %s)\n" "${BLUE}" "${NC}" "$new_val"
                        printf "%s\n" "$line" >> "$NEW_FILE"
                        active_tag_val="$current_val"
                    fi
                fi
            else
                printf "%s\n" "$line" >> "$NEW_FILE"
                active_tag_val="$current_val"
            fi
            continue
        fi

        # 4. Process VER (Sanitization Logic Applied)
        if [[ "$line" =~ ^SRC_VER_([A-Z0-9_]+):=(.*) ]]; then
            local ver_suffix="${BASH_REMATCH[1]}"

            # If the suffix matches the current module and we have a valid tag value
            if [[ "$ver_suffix" == "$current_module_suffix" && -n "$active_tag_val" ]]; then
                local sanitized_ver
                sanitized_ver=$(_sanitize_version "$active_tag_val")

                printf "SRC_VER_%s:=%s\n" "${ver_suffix}" "${sanitized_ver}" >> "$NEW_FILE"
            else
                printf "%s\n" "$line" >> "$NEW_FILE"
            fi
            continue
        fi

        printf "%s\n" "$line" >> "$NEW_FILE"

    done 3< "$RELEASE_FILE"
}

# Function: _finalize_changes
# Description: Summarizes changes and prompts for confirmation
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

        read -p "Do you want to save these changes? [Y/n]: " choice
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
    _process_release_file "check"

    if diff -q "$RELEASE_FILE" "$NEW_FILE" > /dev/null; then
        printf "%bEverything is up to date.%b\n" "${GREEN}" "${NC}"
    else
        printf "%bChanges detected (Run 'update' to apply):%b\n" "${MAGENTA}" "${NC}"
        diff -u --color=always "$RELEASE_FILE" "$NEW_FILE"
    fi
    rm "$NEW_FILE"
}

# Function: update
# Description: Checks for updates and prompts to apply them
function update
{
    _check_file_exists
    _check_token_status
    _process_release_file "apply"
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
  check               - Check for updates (Dry-run)
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
    -*|--*)
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
