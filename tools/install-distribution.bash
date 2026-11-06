#!/usr/bin/env bash
# Build a prepared EPICS-env checkout and optional site checkout on this OS.
# Vendor checkouts must be adjacent to EPICS-env, at the selected revisions.

set -euo pipefail

plan=no
step=preflight
args=()

function usage {
    printf '%s\n' \
        'Usage: install-distribution.bash [--plan] <epics-checkout> <install-root> <build|build.gz> [site-checkout]' \
        '' \
        'Prepare packages and source revisions before running.' \
        'Place uldaq-env and open62541-env beside the EPICS-env checkout.' \
        'Pass the JSON build value; provide site-checkout only when site=true.' \
        '--plan queries the prepared checkouts and prints actions without installing.' \
        'Paths must contain only ASCII letters, digits, /, ., _, +, and -.' \
        'Output goes to stdout/stderr; the first required failure stops installation.'
}

function die {
    printf 'ERROR: %s\n' "$*" >&2
    exit 2
}

function finish {
    local rc=$?
    printf 'INSTALL-END rc=%s plan=%s step=%s\n' "${rc}" "${plan}" "${step}"
}

function run_make {
    local checkout=$1
    local target=$2
    step="${checkout##*/}:${target}"
    printf '\n[%s] make %s\n' "${checkout}" "${target}"
    if [[ ${plan} == no ]]; then
        (cd "${checkout}" && make "${target}")
    fi
}

function configure_line {
    local file=$1
    local line=$2
    printf '[%s] %s\n' "${file}" "${line}"
    if [[ ${plan} == no ]]; then
        printf '\n%s\n' "${line}" >> "${file}"
    fi
}

function check_site_dependencies {
    local checkout=$1
    local audit_rc=0
    local report
    step=site:check.module-deps
    printf '\n[%s] make -s check.module-deps FORMAT=json\n' "${checkout}"
    [[ ${plan} == no ]] || return 0
    report=$(cd "${checkout}" && make -s --no-print-directory check.module-deps FORMAT=json) || audit_rc=$?
    printf '%s\n' "${report}"
    [[ ${audit_rc} -ne 0 ]] || return 0
    [[ ${audit_rc} -eq 2 ]] || return "${audit_rc}"

    # A failed audit permits only unknown tokens in existing module source files.
    if ! python3 -c '
import json
import sys
from pathlib import Path

try:
    report = json.load(sys.stdin)
    if report["strict"] != "YES" or not report["modules"]:
        raise ValueError("incomplete strict report")
    count = 0
    for module in report["modules"]:
        for finding in module["findings"]:
            if finding["type"] == "declared-unobserved":
                continue
            path = Path(finding.get("path", ""))
            source = finding.get("source", "")
            if (finding["type"] != "unknown"
                    or source not in {"make-libs", "make-dbd", "dbd-include", "db-file",
                                      "db-record", "db-proto", "startup-db", "startup-dbd",
                                      "source-include"}
                    or path.is_absolute() or len(path.parts) < 2
                    or not path.parts[0].endswith("-src")
                    or ".." in path.parts or "configure" in path.parts
                    or not (Path(sys.argv[1]) / path).is_file()):
                raise ValueError("configuration or unclassified finding")
            count += 1
    if not count:
        raise ValueError("failed audit without source findings")
except (ValueError, KeyError, TypeError, AttributeError, OSError) as error:
    print("SITE-DEPENDENCY-STOP: " + str(error), file=sys.stderr)
    sys.exit(2)
print("SITE-DEPENDENCY-FINDINGS: retain the audit output for review.")
' "${checkout}" <<< "${report}"; then
        return 2
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --plan) plan=yes ;;
        -h|--help) usage; exit 0 ;;
        --) shift; args+=("$@"); break ;;
        -*) die "Unknown option: $1" ;;
        *) args+=("$1") ;;
    esac
    shift
done
[[ ${#args[@]} -ge 3 && ${#args[@]} -le 4 ]] || { usage >&2; exit 2; }
[[ ${args[2]} == build || ${args[2]} == build.gz ]] || die 'Build target must be build or build.gz.'
[[ ${EUID} -ne 0 ]] || die 'Run as the build user.'
for command in make git readlink uname python python3; do
    [[ -x $(command -v "${command}") ]] || die "Required command not found: ${command}"
done
python_version=$(python --version 2>&1) || die 'Cannot run python --version.'
[[ ${python_version} == Python\ 3.* ]] || die 'The python command must select Python 3.'
[[ $(uname -s) == Linux && $(uname -m) == x86_64 ]] || die 'This installer requires Linux x86_64.'

epics=$(readlink -f -- "${args[0]}")
install_root=$(readlink -m -- "${args[1]}")
build=${args[2]}
site=''
[[ ${#args[@]} -eq 3 ]] || site=$(readlink -f -- "${args[3]}")
uldaq="${epics%/*}/uldaq-env"
open62541="${epics%/*}/open62541-env"
checkouts=("${epics}" "${uldaq}" "${open62541}")
[[ -z ${site} ]] || checkouts+=("${site}")
for path in "${install_root}" "${checkouts[@]}"; do
    [[ ${path} =~ ^/[a-zA-Z0-9_./+-]+$ ]] || die "Unsupported path: ${path}"
done
[[ ${install_root} != / ]] || die 'Select a dedicated installation root.'
for checkout in "${checkouts[@]}"; do
    [[ -s ${checkout}/Makefile && -s ${checkout}/configure/RELEASE ]] || die "Checkout is not prepared: ${checkout}"
    [[ -w ${checkout}/configure ]] || die "Configuration is not writable: ${checkout}"
    source_root=$(git -C "${checkout}" rev-parse --show-toplevel)
    [[ $(readlink -f -- "${source_root}") == "${checkout}" ]] || die "Path is not a repository root: ${checkout}"
    source_commit=$(git -C "${checkout}" rev-parse HEAD)
    printf 'SOURCE %s %s\n' "${checkout}" "${source_commit}"
done
trap finish EXIT

os=$(cd "${epics}" && make -s print-OS_NAME)
os_version=$(cd "${epics}" && make -s print-OS_VERSION)
case "${os}:${os_version%%.*}" in
    debian:*|ubuntu:*) vendor_conf=conf ;;
    rocky:8) vendor_conf=conf.rocky8 ;;
    rocky:10) vendor_conf=conf.rocky10 ;;
    *) die "No vendor configuration selected for ${os} ${os_version}." ;;
esac
tree=$(cd "${epics}" && make -s print-INSTALL_LOCATION_EPICS "INSTALL_LOCATION=${install_root}")
tree=$(readlink -m -- "${tree}")
[[ ${tree} == "${install_root}/"* ]] || die "Tree is outside the installation root: ${tree}"
[[ ! -e ${tree} && ! -L ${tree} ]] || die "Installation tree already exists: ${tree}"
permission=$(cd "${epics}" && make -s print-SUDO_INFO "INSTALL_LOCATION=${install_root}")
[[ ${permission} == 0 ]] || die "Installation root is not writable: ${install_root}"
vendor="${tree}/vendor"
printf 'OS=%s %s BUILD=%s TREE=%s SITE=%s\n' "${os}" "${os_version}" "${build}" "${tree}" "${site:-none}"

# Append installation settings while retaining prepared module pins and overrides.
configure_line "${epics}/configure/CONFIG_SITE.local" "INSTALL_LOCATION:=${install_root}"
configure_line "${epics}/configure/RELEASE.local" "VENDOR_ULDAQ_PATH:=${vendor}"
configure_line "${epics}/configure/RELEASE.local" 'OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor'
if [[ ${plan} == no ]]; then
    resolved=$(cd "${epics}" && make -s print-INSTALL_LOCATION_EPICS)
    [[ $(readlink -m -- "${resolved}") == "${tree}" ]] || die 'EPICS-env installation path differs from the selected tree.'
fi

for checkout in "${uldaq}" "${open62541}"; do
    configure_line "${checkout}/configure/CONFIG_SITE.local" "INSTALL_LOCATION:=${vendor}"
    if [[ ${plan} == no ]]; then
        resolved=$(cd "${checkout}" && make -s print-INSTALL_LOCATION)
        [[ ${resolved} == 'INSTALL_LOCATION = '* ]] || die "Unexpected vendor path query output: ${checkout}"
        resolved=${resolved#'INSTALL_LOCATION = '}
        resolved=${resolved%%$'\n'*}
        [[ $(readlink -m -- "${resolved}") == "${vendor}" ]] || die "Vendor installation path differs: ${checkout}"
    fi
    for target in init "${vendor_conf}" build install; do
        run_make "${checkout}" "${target}"
    done
done

for target in init patch conf check.module-deps "${build}" install symlinks; do
    run_make "${epics}" "${target}"
done

if [[ -n ${site} ]]; then
    configure_line "${site}/configure/CONFIG_SITE.local" "INSTALL_LOCATION:=${tree}"
    if [[ ${plan} == no ]]; then
        resolved=$(cd "${site}" && make -s print-INSTALL_LOCATION_EPICS)
        [[ $(readlink -m -- "${resolved}") == "${tree}" ]] || die 'Site checkout must use the tree-based installation convention.'
    fi
    for target in init patch conf; do
        run_make "${site}" "${target}"
    done
    check_site_dependencies "${site}"
    for target in "${build}" install symlinks; do
        run_make "${site}" "${target}"
    done
fi

step=complete
if [[ ${plan} == yes ]]; then
    printf '\nPLAN: %s\n' "${tree}"
else
    printf '\nINSTALLED: %s\n' "${tree}"
fi
