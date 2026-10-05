#!/usr/bin/env bash
#
# Run the loader verification scripts in their fixed order against one
# installed tree. The caller sets
#   IOCSH_TEST_TREE  installed distribution directory holding setEpicsEnv.bash
#   IOCSH_TEST_REPO  EPICS-env checkout that holds examples/iocsh and the
#                    configuration the tree was built from
#   IOCSH_TEST_OUT   directory for the logs of this run
# Each script writes IOCSH_TEST_OUT/<script>.log. With script names as
# arguments, only those run, in the order given. The order below is
# load-bearing: verify_resolved_paths needs the second versions that
# verify_multiple_versions installs.
#
# Exit status: 0 when every script exits 0 and reports no failed check, 1
# otherwise, 2 when a variable is missing.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly ORDER=(
    verify_install_metadata
    verify_directives
    verify_dependency_graph
    verify_minimal_example
    verify_relocated_tree
    verify_fixture_tc32sim
    verify_fixture_ioc_demo
    verify_fixture_opcua
    verify_multiple_versions
    verify_resolved_paths
    verify_failure_diagnostics
    verify_elf_inspection
    verify_docs_and_tools
    verify_shell_lifecycle
    verify_readme_update_command
    observe_truncated_library
    verify_make_rules
)

function main {
    local name=""
    local script=""
    local status=0
    local summary=""
    local failed=0
    local -a scripts=()

    for name in IOCSH_TEST_TREE IOCSH_TEST_REPO IOCSH_TEST_OUT; do
        if [[ -z "${!name:-}" ]]; then
            printf 'missing %s\n' "${name}" >&2
            return 2
        fi
    done
    mkdir -p "${IOCSH_TEST_OUT}"
    export IOCSH_TEST_TREE IOCSH_TEST_REPO IOCSH_TEST_OUT
    if [[ $# -gt 0 ]]; then
        scripts=("$@")
    else
        scripts=("${ORDER[@]}")
    fi
    for script in "${scripts[@]}"; do
        if [[ ! -f "${SCRIPT_DIR}/${script}.bash" ]]; then
            printf '%s: no such script\n' "${script}" >&2
            failed=1
            continue
        fi
        status=0
        bash "${SCRIPT_DIR}/${script}.bash" > "${IOCSH_TEST_OUT}/${script}.log" 2>&1 || status=$?
        summary=$(grep -a '^SUMMARY ' "${IOCSH_TEST_OUT}/${script}.log" | tail -n 1)
        printf '%s exit %s%s\n' "${script}" "${status}" "${summary:+, ${summary}}"
        [[ "${status}" -eq 0 ]] || failed=1
        [[ -z "${summary}" || "${summary}" == *" fail=0" ]] || failed=1
    done
    date -u +'run done %Y-%m-%dT%H:%M:%SZ'
    return "${failed}"
}

main "$@"
