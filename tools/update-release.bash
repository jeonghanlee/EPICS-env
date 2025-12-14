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

# Function: pushdd
# Description: Wrapper for 'pushd' that changes the current directory and
#              suppresses the command's output.
function pushdd { builtin pushd "$@" > /dev/null || exit; }

# Function: popdd
# Description: Wrapper for 'popd' that returns to the previous directory and
#              suppresses the command's output.
function popdd  { builtin popd  > /dev/null || exit; }


# Function: _check_file_exists
# Description: Verifies that the RELEASE file exists at the expected path.
#              Exits the script with an error if missing.
function _check_file_exists
{
    if [ ! -f "$RELEASE_FILE" ]; then
        echo -e "${RED}Error: RELEASE file not found at ${RELEASE_FILE}${NC}" >&2
        exit 1
    fi
}

# Function: _check_token_status
# Description: Checks if GITHUB_TOKEN is set and prints a clear status message.
function _check_token_status
{
    if [ -n "$GITHUB_TOKEN" ]; then
        echo -e "${GREEN}>>> GITHUB_TOKEN found.${NC} Full API features enabled."
    else
        echo -e "${MAGENTA}>>> GITHUB_TOKEN not found.${NC} Running in limited mode (60 requests/hr)."
    fi
    echo ""
}

# Function: _fetch_github_api
# Description: Wrapper for curl that includes the Authorization header if present.
#              Replaced 'eval' with standard if/else for safety.
#   $1       : API URL
function _fetch_github_api
{
    local url="$1"
    
    # If GITHUB_TOKEN is set in environment, use it with Bearer
    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -L --max-time 3 -H "User-Agent: EPICS-Updater" -H "Authorization: Bearer $GITHUB_TOKEN" "$url"
    else
        # No token
        curl -s -L --max-time 3 -H "User-Agent: EPICS-Updater" "$url"
    fi
}

# Function: _print_diff_info
# Description: Generates links and ALWAYS attempts to fetch details via API.
#              If parsing fails, it now prints the RAW JSON error message.
#   $1       : Repository URL
#   $2       : Old Version
#   $3       : New Version
function _print_diff_info
{
    local repo_url="$1"
    local old_ver="$2"
    local new_ver="$3"
    
    local web_url="${repo_url%.git}"
    local compare_url="${web_url}/compare/${old_ver}...${new_ver}"
    
    # 1. Always print Diff Link
    echo -e "    ${CYAN}➜ Diff Link:${NC} ${compare_url}"
    
    # -------------------------------------------------------------------------
    # API Logic
    # -------------------------------------------------------------------------
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
         # [UPDATE]: Fixed to show only one line error message
         echo -ne "    ${RED}➜ Connection Failed:${NC} "
         
         # Use -sS (Silent but Show Error) to hide progress bar but keep error msg
         local curl_err
         if [ -n "$GITHUB_TOKEN" ]; then
             curl_err=$(curl -sS -L --max-time 2 -H "User-Agent: EPICS-Updater" -H "Authorization: Bearer $GITHUB_TOKEN" "$new_commit_api" 2>&1 >/dev/null)
         else
             curl_err=$(curl -sS -L --max-time 2 -H "User-Agent: EPICS-Updater" "$new_commit_api" 2>&1 >/dev/null)
         fi
         
         # Print clean error message
         echo "${curl_err}"

    else
        # Try to parse Date
        new_date=$(echo "$new_json" | grep -o '"date":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4 | cut -d 'T' -f 1)
        
        # If we got JSON but NO Date, it's likely an error message (Bad credentials, Not found, etc)
        if [ -z "$new_date" ]; then
             # Extract 'message' field from JSON error
             local err_msg
             err_msg=$(echo "$new_json" | grep -o '"message":[[:space:]]*"[^"]*"' | head -n 1 | cut -d '"' -f 4)
             
             if [ -n "$err_msg" ]; then
                 echo -e "    ${RED}➜ API Error:${NC} $err_msg"
             else
                 # Fallback: Print raw json (truncated) if weird
                 local raw_snippet=${new_json:0:60}
                 if [[ "$raw_snippet" != *"{"* ]]; then
                     # Not even JSON?
                     echo -e "    ${RED}➜ API Error:${NC} Invalid Response (Not JSON)."
                 fi
             fi
        else
            # Parsing Successful
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
# Description: Core logic to parse and update RELEASE file.
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
        if [[ "$line" =~ ^##[[:space:]]*(https://.*) ]]; then
            current_repo_url=$(echo "${BASH_REMATCH[1]}" | xargs)
        fi

        # 2. Parse Module Name
        if [[ "$line" =~ ^SRC_NAME_([A-Z0-9_]+):=(.*) ]]; then
            current_module_suffix="${BASH_REMATCH[1]}"
        fi

        # 3. Process TAG
        if [[ "$line" =~ ^SRC_TAG_([A-Z0-9_]+):=(.*) ]]; then
            local tag_suffix="${BASH_REMATCH[1]}"
            local current_val="${BASH_REMATCH[2]}"

            if [[ "$tag_suffix" == "$current_module_suffix" && -n "$current_repo_url" ]]; then
                echo -ne "Checking ${MAGENTA}${tag_suffix}${NC} ... "
                
                # Fetch Refs using git ls-remote (Works without Token for Public Repos)
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
                        # -- It IS a Tag --
                        new_val=$(echo "$matching_tag_ref" | sed -e 's/\^{}$//' -e 's/^refs\///')
                    else
                        # -- It is a Regular Commit --
                        new_val="${head_hash:0:7}"
                    fi
                    
                    # Compare and Update
                    if [ "$current_val" != "$new_val" ]; then
                        echo -e "${GREEN}UPDATE${NC} ($current_val -> $new_val)"
                        echo "SRC_TAG_${tag_suffix}:=${new_val}" >> "$NEW_FILE"
                        updated_val="$new_val"
                        
                        # Call info printer
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
# Description: Compares the new file with the original.
#              If changes exist, prompts the user to apply them.
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
# Description: Public command. Checks for updates and displays differences.
#              This is a dry-run mode (does not save changes).
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
# Description: Public command. Checks for updates, displays diffs/links,
#              and prompts the user to overwrite the RELEASE file.
function update
{
    _check_file_exists
    _check_token_status
    _process_release_file "apply"
    _finalize_changes
}

# Function: usage
# Description: Displays the usage information and available commands.
function usage
{
   cat << EOF

Usage: ${0##*/} <command>

Environment:
  GITHUB_TOKEN        - Optional (Recommended).
                        If NOT set: Limited to 60 req/hr.
                        If SET: Up to 5000 req/hr.
                        export GITHUB_TOKEN="your_token_here"

Commands:
  check               - Check for updates and show diff (Dry-run)
  update              - Check for updates and prompt to apply changes
  help                - Displays this help message.

EOF
    exit 1;
}

# -----------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------

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
