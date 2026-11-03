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
# Run the checks of one module cycle (release-procedure.md, step 6, sub-step
# 5; module-bump-procedure.md, The checks) on every test machine of the hosts
# file through guest-run.bash, from the local checkout, and print one line
# per Results row of the release record with the evidence lines of the row.
#
# The order, each label a log <log_dir>/<label>-<os>.log: checkout and build
# (guest-update.bash) on every machine; rebuild-<d> on every machine for each
# module <d> whose _DEPS line of configure/CONFIG_MODS_DEPS at the candidate
# lists build.<module>, by one command that rebuilds from distclean, or from
# a new source tree when the top Makefile of <d> passes realuninstall and
# BUILD_IOCS is not YES; patch-round-trip (guest-roundtrip.bash) on the first
# machine; consumers (guest-suite.bash with the site checkout when given and
# the module scripts of The checks, item 3: verify_install_metadata,
# verify_dependency_graph, verify_minimal_example, and the fixture that loads
# the module) and metadata-lines on every machine; installed-tree-deps and
# installed-tree-env on every machine; reverse-deps on every machine, the
# search over the installed modules once per lib= stem of the module's
# cfg/iocsh.conf and once by its installed name (the name= line of that file,
# seq for sequencer) in the dep= lines, whose output and the list of
# the dependents also go to <log_dir>/reverse-deps.md with a judgement part
# left for the maintainer. The run stops at the first log that does not end
# with rc=0. A row passes when every log of the row ends with rc=0; its
# evidence lines are printed under it for the reader to compare with the
# record. When the pin moved after the branch point of the release (the
# oldest commit of git log -S'<pin>' <merge-base>..<candidate> -- configure/RELEASE),
# the files of that commit are searched at the candidate for the version its
# parent held, and the hits are printed as a note that is not part of the
# exit status.
#
# Usage: cycle.bash <module> <KEY> <candidate> [site_checkout] [log_dir]
#   <module>         module name of the make targets, such as pvxs
#   <KEY>            key of the module in configure/RELEASE, such as PVXS
#   <candidate>      commit on origin that the machines check out
#   [site_checkout]  site module checkout on the machines, passed to
#                    guest-suite.bash; an empty string for none
#   [log_dir]        log directory on the local host; default
#                    <checkout>/work/<module>-bump
# Environment:
#   GUEST_HOSTS_FILE  hosts file of guest-run.bash; default work/guest-hosts.env
#   GUEST_SANDBOX     sandbox directory on the machines; default ~/sandbox
# Exit status: 0 every row passed; 1 a row failed and the run stopped there;
# 2 a usage or configuration error.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
checkout="$(cd "${script_dir}/../.." && pwd)"
hosts_file="${GUEST_HOSTS_FILE:-${checkout}/work/guest-hosts.env}"
sandbox="${GUEST_SANDBOX:-~/sandbox}"
guest_run="${script_dir}/guest-run.bash"
main_branch=master
readonly script_dir checkout hosts_file sandbox guest_run main_branch

function usage {
    printf 'Usage: %s <module> <KEY> <candidate> [site_checkout] [log_dir]\n' "${0##*/}" >&2
    exit 2
}

# The machine keys of the hosts file, in line order.
function read_machines {
    local line=""
    while IFS= read -r line || [[ -n "${line:-}" ]]; do
        line="${line//$'\r'/}"
        [[ "${line}" == *=* ]] || continue
        [[ "${line}" == ssh_options=* ]] && continue
        printf '%s\n' "${line%%=*}"
    done < "${hosts_file}"
}

# The last line of a log.
function last_line {
    tail -n 1 -- "$1"
}

# Runs one label on the given machines at once and waits; prints the row as
# failed and exits 1 when a log does not end with rc=0.
function run_step {
    local row="$1"
    local label="$2"
    local command="$3"
    shift 3
    local -a pids=()
    local os=""
    local pid=""
    local log=""
    local failed=0

    for os in "$@"; do
        bash "${guest_run}" "${os}" "${label}" "${command}" "${log_dir}" > /dev/null &
        pids+=($!)
    done
    for pid in "${pids[@]}"; do
        wait "${pid}" || failed=1
    done
    for os in "$@"; do
        log="${log_dir}/${label}-${os}.log"
        if [[ ! -s "${log}" ]] || [[ "$(last_line "${log}")" != "rc=0" ]]; then
            printf '%s: fail\n  %s: %s: %s\n' "${row}" "${os}" "${label}" "$(last_line "${log}" 2>/dev/null || printf 'no log')"
            exit 1
        fi
    done
    [[ ${failed} -eq 0 ]] || { printf '%s: fail (guest-run.bash exited nonzero: a log of the label exists in %s, or the hosts file is wrong)\n' "${row}" "${log_dir}"; exit 1; }
}

# Prints the matching lines of a log under the machine name.
function evidence {
    local os="$1"
    local label="$2"
    local pattern="$3"
    sed 's/\x1b\[[0-9;]*m//g' "${log_dir}/${label}-${os}.log" | grep -a -E -- "${pattern}" \
        | sed "s/^/  ${os}: /" || true
}

# The apply targets of a module from the patch: line of RULES_SRC at the
# candidate, as make targets joined by " && ".
function apply_target_commands {
    local dep_module="$1"
    local target=""
    local out=""
    while IFS= read -r target; do
        [[ -n "${target}" ]] || continue
        out="${out}make ${target} && "
    done < <(git -C "${checkout}" show "${candidate}:configure/RULES_SRC" | grep '^patch:' \
        | grep -o -E "patch\.${dep_module}\.[A-Za-z0-9.-]*apply" || true)
    printf '%s' "${out}"
}

# Prints the suite scripts of a module cycle: the three module scripts and
# the fixture that loads the module, from the module directives of the
# fixture startup files under examples/iocsh.
function module_scripts {
    local name="$1"
    local scripts="verify_install_metadata verify_dependency_graph verify_minimal_example"
    case "${name}" in
        autosave|caPutLog|linStat|retools) scripts="${scripts} verify_fixture_tc32sim" ;;
        StreamDevice) scripts="${scripts} verify_fixture_tc32sim verify_fixture_ioc_demo" ;;
        opcua) scripts="${scripts} verify_fixture_opcua" ;;
    esac
    printf '%s' "${scripts}"
}

# Prints the module names of the installed directories a reverse-deps log
# names (<name>-<version> under modules/), by the SRC_NAME lines of
# configure/RELEASE at the candidate; a directory without a module keeps its
# own name.
function reverse_deps_names {
    local log="$1"
    local dir=""
    local name=""
    local found=""
    while IFS= read -r dir; do
        [[ -n "${dir}" ]] || continue
        found="${dir}"
        for name in "${module_names[@]}"; do
            [[ "${dir}" == "${name}-"* ]] || continue
            found="${name}"
            break
        done
        printf '%s\n' "${found}"
    done < <(grep -a -v '^==\|^rc=' "${log}" | sed -n 's#.*/modules/\([^/]*\)/.*#\1#p' | LC_ALL=C sort -u) \
        | LC_ALL=C sort -u
}

[[ $# -ge 3 && $# -le 5 ]] || usage
module="$1"
key="$2"
candidate="$3"
site_checkout="${4:-}"
log_dir="${5:-${checkout}/work/${module}-bump}"
readonly module key candidate site_checkout

if [[ ! -s "${hosts_file}" ]]; then
    printf 'hosts file %s is missing or empty\n' "${hosts_file}" >&2
    exit 2
fi
mapfile -t machines < <(read_machines)
if [[ ${#machines[@]} -eq 0 ]]; then
    printf 'no machine line in %s\n' "${hosts_file}" >&2
    exit 2
fi
if ! git -C "${checkout}" cat-file -e "${candidate}^{commit}" 2>/dev/null; then
    printf 'candidate %s is not a commit of %s\n' "${candidate}" "${checkout}" >&2
    exit 2
fi
mkdir -p "${log_dir}"
log_dir="$(cd "${log_dir}" && pwd)"
readonly log_dir

mapfile -t module_names < <(git -C "${checkout}" show "${candidate}:configure/RELEASE" | sed -n 's/^SRC_NAME_[A-Z0-9_]*:=//p')
env_checkout="${sandbox}/EPICS-env"
tools="${env_checkout}/tools/module-check"
printf 'module: %s (%s)  candidate: %s  machines: %s  logs: %s\n' \
    "${module}" "${key}" "${candidate}" "${machines[*]}" "${log_dir}"

# checkout and build on every machine
run_step checkout checkout \
    "git -C ${env_checkout} fetch -q origin && git -C ${env_checkout} checkout -q ${candidate} && git -C ${env_checkout} rev-parse HEAD" \
    "${machines[@]}"
run_step build build \
    "bash ${tools}/guest-update.bash ${module} ${key} ${candidate} ${env_checkout}" \
    "${machines[@]}"
printf 'build: pass\n'
for os in "${machines[@]}"; do
    printf '  %s: Patching %s-src lines: %s\n' "${os}" "${module}" \
        "$(grep -a -c "^Patching ${module}-src" "${log_dir}/build-${os}.log" || true)"
    evidence "${os}" build '^(link:|SONAME |UPDATE-DONE )'
done

# the build-order dependents, each rebuilt on every machine
mapfile -t dependents < <(git -C "${checkout}" show "${candidate}:configure/CONFIG_MODS_DEPS" \
    | awk -v want="build.${module}" '/^[^ ]+_DEPS:=/ { split($0, a, "_DEPS:="); n = split(a[2], d, " "); for (i = 1; i <= n; i++) if (d[i] == want) { print a[1]; break } }')
for dep in "${dependents[@]}"; do
    dep_key="$(git -C "${checkout}" show "${candidate}:configure/RELEASE" | sed -n "s/^SRC_NAME_\([A-Z0-9_]*\):=${dep}\$/\1/p")"
    if [[ -z "${dep_key}" ]]; then
        printf 'no SRC_NAME_<KEY>:=%s in configure/RELEASE at %s\n' "${dep}" "${candidate}" >&2
        exit 2
    fi
    apply="$(apply_target_commands "${dep}")"
    run_step "rebuild-${dep}" "rebuild-${dep}" \
        "cd ${env_checkout} && if grep -q realuninstall ${dep}-src/Makefile && ! grep -q -s -E 'BUILD_IOCS *= *YES' ${dep}-src/Makefile ${dep}-src/configure/CONFIG_SITE*; then echo 'rebuild form: new source tree' && mv ${dep}-src ${sandbox}/${dep}-src.before-rebuild-\$(date -u +%Y%m%dT%H%M%SZ) && make ${dep_key} && ${apply}make conf.${dep} && make build.${dep}; else echo 'rebuild form: distclean' && make distclean.${dep} && make conf.${dep} && make build.${dep}; fi" \
        "${machines[@]}"
    printf 'rebuild-%s: pass\n' "${dep}"
    for os in "${machines[@]}"; do
        evidence "${os}" "rebuild-${dep}" '^(rebuild form:|rc=)'
    done
done

# patch round trip on the first machine
run_step patch-round-trip patch-round-trip \
    "bash ${tools}/guest-roundtrip.bash ${candidate} ${module} ${sandbox}" \
    "${machines[0]}"
printf 'patch-round-trip: pass\n'
evidence "${machines[0]}" patch-round-trip '^(init rc=|patch rc=|Patching |revert rc=|status lines in all trees:)'

# the module scripts of the loader suite with the site checkout, and the two
# count lines; an empty site checkout is passed as an empty argument
suite_scripts="$(module_scripts "${module}")"
site_arg="${site_checkout:-''}"
run_step consumers consumers \
    "bash ${tools}/guest-suite.bash ${env_checkout} ${sandbox}/iocsh-tests/${module} ${site_arg} \"${suite_scripts}\"" \
    "${machines[@]}"
run_step consumers metadata-lines \
    "grep -a \"modules inspected\\|modules agree\" ${sandbox}/iocsh-tests/${module}/verify_install_metadata.log" \
    "${machines[@]}"
printf 'consumers: pass\n'
for os in "${machines[@]}"; do
    evidence "${os}" consumers '^(site checkout:|scripts:|minimal IOC exit=|iocRun lines:|FAIL lines:|run_all rc=|records listed:|free before:|free after:)'
    evidence "${os}" metadata-lines '^OK'
done

# the two make checks and the reverse dependencies in the installed tree
run_step installed-tree installed-tree-deps "cd ${env_checkout} && make check.deps" "${machines[@]}"
run_step installed-tree installed-tree-env "cd ${env_checkout} && make check.env" "${machines[@]}"
run_step installed-tree reverse-deps \
    "cd ${env_checkout} && tree=\$(make -s print-INSTALL_LOCATION_EPICS) && loc=\$(readlink -f \"\$(make -s print-INSTALL_LOCATION_${key})\") && name=\$(sed -n 's/^name=//p' \"\$loc/cfg/iocsh.conf\") && for s in \$(sed -n 's#^lib=.*/lib\\([^/]*\\)\\.so\$#\\1#p' \"\$loc/cfg/iocsh.conf\"); do echo \"== stem \$s\"; for d in \"\$tree\"/modules/*/; do d=\${d%/}; [ -L \"\$d\" ] && continue; [ \"\$d\" = \"\$loc\" ] && continue; for f in \"\$d\"/lib/*/*.so; do [ -f \"\$f\" ] || continue; readelf -d \"\$f\" 2>/dev/null | grep -q \"NEEDED.*\\[lib\$s\\.so\" && echo \"\$f\"; done; done; done; echo \"== dep=\$name\"; for d in \"\$tree\"/modules/*/; do d=\${d%/}; [ -L \"\$d\" ] && continue; grep -l -E \"^dep=\$name( |\$)\" \"\$d/cfg/iocsh.conf\" 2>/dev/null; done; true" \
    "${machines[@]}"
printf 'installed-tree: pass\n'
for os in "${machines[@]}"; do
    evidence "${os}" installed-tree-deps 'SO: Total Files with +RPATH'
    evidence "${os}" installed-tree-env '^findings:'
    mapfile -t named < <(reverse_deps_names "${log_dir}/reverse-deps-${os}.log")
    outside=()
    for name in "${named[@]}"; do
        found=no
        for dep in "${dependents[@]}"; do
            [[ "${name}" == "${dep}" ]] && found=yes
        done
        [[ ${found} == yes ]] || outside+=("${name}")
    done
    printf '  %s: reverse-deps names: %s\n' "${os}" "${named[*]:-none}"
    printf '  %s: outside the dependents: %s\n' "${os}" "${outside[*]:-none}"
done
# The backquotes of the Markdown lines below are literal.
# shellcheck disable=SC2016
{
    printf '# Reverse dependencies of %s in the installed tree (Stage 3), candidate %s\n\n' "${module}" "${candidate}"
    printf 'Observed %s on the machines %s, logs `reverse-deps-<os>.log` of this directory.\n' \
        "$(date -u +%F)" "${machines[*]}"
    printf 'Build-order dependents, the modules whose `_DEPS` line lists `build.%s`: %s.\n\n' \
        "${module}" "${dependents[*]:-none}"
    printf '## Search output\n\n'
    for os in "${machines[@]}"; do
        printf '### %s\n\n```\n' "${os}"
        grep -a -v '^rc=' "${log_dir}/reverse-deps-${os}.log"
        printf '```\n\n'
    done
    printf '## Judgement\n\nTo be written by the maintainer: the modules the search names, their kind (link-level or `dep=` only), and whether each is among the build-order dependents.\n'
} > "${log_dir}/reverse-deps.md"
printf '  reverse-deps.md written to %s\n' "${log_dir}/reverse-deps.md"

# the old version in the files of the pin commit, a note outside the status
pin="$(git -C "${checkout}" show "${candidate}:configure/RELEASE" | sed -n "s/^SRC_TAG_${key}:=//p")"
base="$(git -C "${checkout}" merge-base "${candidate}" "${main_branch}")"
pin_commit="$(git -C "${checkout}" log --format=%h "-S${pin}" "${base}..${candidate}" -- configure/RELEASE | tail -n 1)"
old=""
if [[ -n "${pin_commit}" ]]; then
    old="$(git -C "${checkout}" show "${pin_commit}^:configure/RELEASE" 2>/dev/null | sed -n "s/^SRC_VER_${key}:=//p" || true)"
fi
if [[ -z "${pin_commit}" || -z "${old}" ]]; then
    printf 'old-version: note: pin %s did not move after %s; no file is searched\n' "${pin}" "${base:0:7}"
else
    mapfile -t pin_files < <(git -C "${checkout}" diff --name-only "${pin_commit}^" "${pin_commit}")
    printf 'old-version: note: pin %s set by %s; its %s files searched at %s for %s:\n' \
        "${pin}" "${pin_commit}" "${#pin_files[@]}" "${candidate}" "${old}"
    git -C "${checkout}" grep -n -F -- "${old}" "${candidate}" -- "${pin_files[@]}" | sed 's/^/  /' || printf '  no hit\n'
fi
printf 'CYCLE-DONE %s %s\n' "${module}" "${candidate}"
