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


declare -g SC_RPATH;
declare -g SC_TOP;
declare -g SC_TIME;

SC_RPATH="$(realpath "$0")";
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
VERBOSE=false

# Function: pushdd
function pushdd { builtin pushd "$@" > /dev/null || exit; }

# Function: popdd
function popdd  { builtin popd  > /dev/null || exit; }

# Function: _check_file_exists
function _check_file_exists
{
    if [ ! -f "$RELEASE_FILE" ]; then
        echo -e "${RED}Error: RELEASE file not found at ${RELEASE_FILE}${NC}" >&2
        exit 1
    fi
}

# Function: _check_token_status
function _check_token_status
{
    if [ "$VERBOSE" = false ]; then
        return
    fi

    if [ -n "$GITHUB_TOKEN" ]; then
        echo -e "${GREEN}>>> GITHUB_TOKEN found.${NC} Full API features enabled."
    else
        echo -e "${MAGENTA}>>> GITHUB_TOKEN not found.${NC} Running in limited mode (60 requests/hr)."
    fi
    echo ""
}

# Function: _fetch_github_api
# [UPDATED] User-Agent: EPICS-env
# [UPDATED] Timeout: 1s if no token, 3s if token exists
function _fetch_github_api
{
    local url="$1"
    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -L --max-time 3 -H "User-Agent: EPICS-env" -H "Authorization: Bearer $GITHUB_TOKEN" "$url"
    else
        # Fast timeout (1s) to prevent hanging when rate-limited or slow network
        curl -s -L --max-time 1 -H "User-Agent: EPICS-env" "$url"
    fi
}

# Function: _print_diff_info
function _print_diff_info
{
    local repo_url="$1"
    local old_ver="$2"
    local new_ver="$3"
    
    local web_url="${repo_url%.git}"
    local compare_url="${web_url}/compare/${old_ver}...${new_ver}"
    
    echo -e "    ${CYAN}➜ Diff Link:${NC} ${compare_url}"
    
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
         echo -ne "    ${RED}➜ Connection Failed:${NC} "
         local curl_err
         # [UPDATED] Apply same User-Agent and Timeout logic for error fetching
         if [ -n "$GITHUB_TOKEN" ]; then
             curl_err=$(curl -sS -L --max-time 2 -H "User-Agent: EPICS-env" -H "Authorization: Bearer $GITHUB_TOKEN" "$new_commit_api" 2>&1 >/dev/null)
         else
             curl_err=$(curl -sS -L --max-time 1 -H "User-Agent: EPICS-env" "$new_commit_api" 2>&1 >/dev/null)
         fi
         echo "${curl_err}"

    else
        new_date=$(echo "$new_json" | grep -o '"date":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4 | cut -d 'T' -f 1)
        
        if [ -z "$new_date" ]; then
             local err_msg
             err_msg=$(echo "$new_json" | grep -o '"message":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4)
             
             if [ -n "$err_msg" ]; then
                 echo -e "    ${RED}➜ API Error:${NC} $err_msg"
             else
                 local raw_snippet=${new_json:0:60}
                 if [[ "$raw_snippet" != *"{"* ]]; then
                     echo -e "    ${RED}➜ API Error:${NC} Invalid Response (Not JSON)."
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

        echo -e "    ${CYAN}➜ Info     :${NC} Date: ${date_str} | Author: ${last_author}"
        
        if [ ${#last_msg} -gt 60 ]; then
            last_msg="${last_msg:0:57}..."
        fi
        echo -e "    ${CYAN}➜ Message  :${NC} \"${last_msg}\""
    fi

    # D. Fetch Stats (Commit Count)
    if [ -n "$new_date" ]; then
        local compare_json
        compare_json=$(_fetch_github_api "$compare_api")
        
        if [ -n "$compare_json" ]; then
            local commit_count
            commit_count=$(echo "$compare_json" | grep -o '"total_commits":[[:space:]]*[0-9]*' | grep -o '[0-9]*')
            
            if [ -n "$commit_count" ]; then
                echo -e "    ${CYAN}➜ Stats    :${NC} ${commit_count} commits ahead."
            fi
        fi
    fi
}

# Function: _process_release_file
function _process_release_file
{
    local mode="$1"
    local current_repo_url=""
    local current_module_suffix=""
    local updated_val="" 
    
    echo "--- Processing RELEASE file: ${RELEASE_FILE} ---"

    > "$NEW_FILE"

    while IFS= read -r line || [ -n "$line" ]; do
        
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
                     echo ""
                     echo -e "${RED}>>> FATAL ERROR: Repo URL / Module Name Mismatch!${NC}"
                     echo -e "    It seems the URL comment is missing for module: ${MAGENTA}${module_raw_name}${NC}"
                     echo -e "    The script is trying to use the URL from the PREVIOUS block:"
                     echo -e "      - Active URL  : ${current_repo_url}"
                     echo -e "      - Module Name : ${module_raw_name}"
                     echo ""
                     echo -e "    ${CYAN}Fix suggestion:${NC} Add '## https://github.com/...' above SRC_NAME_${current_module_suffix}"
                     echo ""
                     exit 1
                fi
            fi
        fi

        # 3. Process TAG
        if [[ "$line" =~ ^SRC_TAG_([A-Z0-9_]+):=(.*) ]]; then
            local tag_suffix="${BASH_REMATCH[1]}"
            local current_val="${BASH_REMATCH[2]}"

            if [[ "$tag_suffix" == "$current_module_suffix" && -n "$current_repo_url" ]]; then
                echo -ne " Checking ${MAGENTA}${tag_suffix}${NC} ... "
                
                local remote_refs
                remote_refs=$(git ls-remote "$current_repo_url" 2>/dev/null)
                
                if [ -z "$remote_refs" ]; then
                    echo -e "${RED}FAILED${NC} (git ls-remote failed)"
                    echo "$line" >> "$NEW_FILE"
                    updated_val=""
                else
                    # Find HEAD Hash
                    local head_hash
                    head_hash=$(echo "$remote_refs" | awk '/HEAD/ {print $1}' | head -n 1)
                    
                    if [ -z "$head_hash" ]; then
                         echo -e "${RED}FAILED${NC} (No HEAD found)"
                         echo "$line" >> "$NEW_FILE"
                         updated_val=""
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
                        echo -e "${GREEN}UPDATE${NC} ($current_val -> $new_val)"
                        echo "SRC_TAG_${tag_suffix}:=${new_val}" >> "$NEW_FILE"
                        updated_val="$new_val"
                        _print_diff_info "$current_repo_url" "$current_val" "$new_val"
                    else
                        echo -e "${BLUE}OK${NC} (Matches $new_val)"
                        echo "$line" >> "$NEW_FILE"
                        updated_val=""
                    fi
                fi
            else
                echo "$line" >> "$NEW_FILE"
                updated_val=""
            fi
            continue
        fi

        # 4. Process VER
        if [[ "$line" =~ ^SRC_VER_([A-Z0-9_]+):=(.*) ]]; then
            local ver_suffix="${BASH_REMATCH[1]}"
            if [[ "$ver_suffix" == "$current_module_suffix" && -n "$updated_val" ]]; then
                echo "SRC_VER_${ver_suffix}:=${updated_val}" >> "$NEW_FILE"
            else
                echo "$line" >> "$NEW_FILE"
            fi
            continue
        fi

        echo "$line" >> "$NEW_FILE"

    done < "$RELEASE_FILE"
}

# Function: _finalize_changes
function _finalize_changes
{
    echo "--- Summary ---"
    if diff -q "$RELEASE_FILE" "$NEW_FILE" > /dev/null; then
        echo -e "${GREEN}No updates available. Everything is up to date.${NC}"
        rm "$NEW_FILE"
    else
        echo -e "${MAGENTA}Updates detected!${NC}"
        echo "---------------------------------------------------"
        diff -u --color=always "$RELEASE_FILE" "$NEW_FILE"
        echo "---------------------------------------------------"
        
        read -p "Do you want to apply these changes? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            cp "$RELEASE_FILE" "$BACKUP_FILE"
            mv "$NEW_FILE" "$RELEASE_FILE"
            echo -e "${GREEN}Updated RELEASE file.${NC} Backup saved to ${BACKUP_FILE}"
        else
            rm "$NEW_FILE"
            echo -e "${RED}Update cancelled.${NC}"
        fi
    fi
}

# Function: check
function check
{
    _check_file_exists
    _check_token_status
    _process_release_file "check"
    
    if diff -q "$RELEASE_FILE" "$NEW_FILE" > /dev/null; then
        echo -e "${GREEN}Everything is up to date.${NC}"
    else
        echo -e "${MAGENTA}Changes detected (Run 'update' to apply):${NC}"
        diff -u --color=always "$RELEASE_FILE" "$NEW_FILE"
    fi
    rm "$NEW_FILE"
}

# Function: update
function update
{
    _check_file_exists
    _check_token_status
    _process_release_file "apply"
    _finalize_changes
}

# Function: usage
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
  update              - Check and prompt to apply changes
  help                - Displays this help message.
EOF
    exit 1;
}

# -----------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------

# Argument Parsing for Verbose flag
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
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
        echo "Error: Unknown command '$COMMAND'" >&2
        usage
        ;;
esac
