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
#  version : 0.0.2

declare -g SC_RPATH
declare -g SC_TOP

SC_RPATH="$(realpath "$0")"
SC_TOP="${SC_RPATH%/*}"

# -----------------------------------------------------------------------------
# Global Configurations
# -----------------------------------------------------------------------------
declare -g PROJECT_ROOT="${SC_TOP}/.."
declare -g CONFIG_DIR="${PROJECT_ROOT}/configure"
declare -g DEFAULT_CONFIG_FILE="${CONFIG_DIR}/CONFIG_MODS_DEPS"
declare -g CONFIG_FILE="${DEFAULT_CONFIG_FILE}"

declare -g OUTPUT_FILE="epics_deps.png"
declare -g OUTPUT_FORMAT="png"
declare -g DOT_CMD=""

# -----------------------------------------------------------------------------
# Output & Color Settings
# -----------------------------------------------------------------------------
declare -g RED='\033[0;31m'
declare -g GREEN='\033[0;32m'
declare -g BLUE='\033[0;34m'
declare -g NC='\033[0m' # No Color

# Enable core dumps in case the JVM fails
ulimit -c unlimited

# Global Verbose Flag (Default: false)
declare -g VERBOSE=false

# Function: usage
# Description: Prints help message
function usage
{
   cat << EOF

Usage: ${0##*/} [OPTIONS]

Options:
  -f, --file <file>   Specify the dependency config file (Default: configure/CONFIG_MODS_DEPS)
  -o, --output <file> Specify the output filename (Default: epics_deps.png)
  -v, --verbose       Enable verbose logging
  -h, --help          Displays this help message.

Description:
  Parses the EPICS-env configuration file and generates a dependency graph image.
  Requires 'graphviz' (dot command) installed on the system.
  Automatically embeds the current Git Commit Hash and Date into the graph label.

EOF
    exit 1;
}

# Function: _check_requirements
# Description: Checks for necessary tools and files
function _check_requirements
{
    # 1. Check Config File
    if [ ! -f "$CONFIG_FILE" ]; then
        printf "%bError: Configuration file not found at %s%b\n" "${RED}" "${CONFIG_FILE}" "${NC}" >&2
        exit 1
    fi

    # 2. Check Graphviz (dot)
    if ! command -v dot &> /dev/null; then
        printf "%bError: 'dot' command not found. Please install graphviz.%b\n" "${RED}" "${NC}" >&2
        printf "       (e.g., sudo dnf install graphviz or sudo apt install graphviz)\n" >&2
        exit 1
    fi
    DOT_CMD=$(command -v dot)

    if [ "$VERBOSE" = true ]; then
        printf "%b>>> Parsing file : %s%b\n" "${GREEN}" "${CONFIG_FILE}" "${NC}" >&2
        printf "%b>>> Using dot    : %s%b\n" "${GREEN}" "${DOT_CMD}" "${NC}" >&2
    fi
}

# Function: _get_git_metadata
# Description: Retrieves Git Hash and Date for the graph label
function _get_git_metadata
{
    local git_hash="N/A"
    local git_date="N/A"

    # Check if we are inside a git repo
    if git -C "${PROJECT_ROOT}" rev-parse --is-inside-work-tree &> /dev/null; then
        git_hash=$(git -C "${PROJECT_ROOT}" rev-parse --short HEAD)
        git_date=$(git -C "${PROJECT_ROOT}" log -1 --format=%cd --date=short)
    else
        # Fallback if not a git repo
        git_date=$(date +%Y-%m-%d)
    fi

    # Return formatted string for DOT label
    # \n needs to be escaped for DOT syntax
    printf "Build: %s (Commit: %s)" "${git_date}" "${git_hash}"
}

# Function: _generate_dot_content
# Description: Generates the DOT content and streams it to stdout
#              This is intended to be piped directly to the dot command.
function _generate_dot_content
{
    local meta_label
    meta_label=$(_get_git_metadata)

    printf "digraph EPICS_Module_Deps {\n"
    printf "    rankdir=LR;\n"
    printf "    node [shape=box, style=filled, fillcolor=lightblue, fontname=\"Helvetica\", fontsize=10];\n"
    printf "    edge [color=gray50, arrowsize=0.8];\n"
    printf "    labelloc=\"b\";\n"
    printf "    labeljust=\"r\";\n"
    printf "    fontsize=10;\n"
    printf "    fontcolor=gray30;\n"
    printf "    label=\"EPICS Module Dependencies\\n%s\";\n" "${meta_label}"
    printf "\n"

    local line
    local module_name
    local deps_string
    local dep
    local clean_dep

    while IFS= read -r line || [ -n "$line" ]; do
        # Regex to match module_DEPS:= ...
        if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_]+)_DEPS[:?]?=(.*) ]]; then
            module_name="${BASH_REMATCH[1]}"
            deps_string="${BASH_REMATCH[2]}"

            module_name=$(echo "$module_name" | xargs)
            deps_string=$(echo "$deps_string" | xargs)

            if [ "$VERBOSE" = true ]; then
                 printf "%b  > Processing: %s%b\n" "${BLUE}" "${module_name}" "${NC}" >&2
            fi

            for dep in ${deps_string}; do
                if [[ -z "$dep" || "$dep" == "null.base" ]]; then
                    continue
                fi
                clean_dep="${dep#build.}"
                printf "    \"%s\" -> \"%s\";\n" "${module_name}" "${clean_dep}"
            done
        fi
    done < "$CONFIG_FILE"

    printf "}\n"
}

# Function: generate_image
# Description: Orchestrates the generation of the image file
function generate_image
{
    _check_requirements

    printf "%b>>> Generating Dependency Graph...%b\n" "${GREEN}" "${NC}"

    # Pipe the DOT content directly into the dot command
    if _generate_dot_content | "$DOT_CMD" -T"${OUTPUT_FORMAT}" -o "$OUTPUT_FILE"; then
        printf "%b>>> Success! Image created at: %s%b\n" "${GREEN}" "${OUTPUT_FILE}" "${NC}"
    else
        printf "%bError: Failed to generate image.%b\n" "${RED}" "${NC}" >&2
        exit 1
    fi
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
    -f|--file)
      CONFIG_FILE="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT_FILE="$2"
      # Simple extension extraction to set format (e.g., .svg -> svg)
      if [[ "$OUTPUT_FILE" == *.* ]]; then
          OUTPUT_FORMAT="${OUTPUT_FILE##*.}"
      fi
      shift 2
      ;;
    -h|--help)
      usage
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

generate_image
