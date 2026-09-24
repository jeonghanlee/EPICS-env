#!/usr/bin/env bash
#
# verify_fix_build.bash - steps 2-3 of
# docs/procedures/upstream-fix-verification-procedure.md: build a fixed module
# and a consumer IOC copy, both already placed in a scratch directory, against
# the production tree, then verify the links and that the production tree was
# not touched.
#
# The production tree is the one the current shell's EPICS environment names:
# source <tree>/setEpicsEnv.bash first, so EPICS_BASE is <tree>/base.
# The module directory name is the installed module name in <tree>/modules
# (measComp, seq); the IOC directory name is the IOC binary name. The module's dependencies
# are read from the installed module in the production tree, and its own
# configuration from the EPICS-env checkout that holds this script.
#
# Running the IOC copy and comparing values (steps 4-5) stay manual.

set -euo pipefail

readonly PROG="${0##*/}"
ENV_CHECKOUT="$(cd "$(dirname "$(realpath "$0")")/.." && pwd)"
readonly ENV_CHECKOUT
readonly ARCH="${EPICS_HOST_ARCH:-linux-x86_64}"
# Vendor prefix EPICS-env uses when none is configured; every production tree
# holds its vendor libraries in <tree>/vendor.
readonly DEFAULT_VENDOR="/usr/local"

function die {
    printf "%s: error: %s\n" "$PROG" "$1" >&2
    exit 1
}

function info {
    printf "[%s] %s\n" "$PROG" "$1"
}

function need_cmd {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1 || die "required command not found: $cmd"
    [[ -x "$(command -v "$cmd")" ]] || die "not executable: $cmd"
}

function usage {
    cat <<EOF
Usage: source <tree>/setEpicsEnv.bash; $PROG <module-dir> <ioc-dir>

  <module-dir>  module source with the fix and the environment patches applied;
                its directory name is the installed module name in <tree>/modules
  <ioc-dir>     consumer IOC source at its production commit;
                its directory name is the IOC binary name

Builds both against the production tree named by EPICS_BASE, checks that the
module and the IOC link only into that tree and that the IOC links the module
from <module-dir>, and checks that nothing under the tree was written.
EOF
}

# Asks the operator to confirm on the terminal; without a terminal, or on any
# answer other than y, the run stops.
function confirm {
    local question="$1"
    local answer=""
    { : > /dev/tty; } 2>/dev/null || die "$question (confirmation needs a terminal)"
    printf "%s [y/N] " "$question" > /dev/tty
    read -r answer < /dev/tty || true
    [[ "$answer" == "y" || "$answer" == "Y" ]] || die "stopped by the operator"
    return 0
}

# Fails when a library or binary carries a runpath entry outside the
# production tree, \$ORIGIN, and the optional extra directory.
function check_runpath {
    local file="$1" extra="${2:-}"
    local runpath entry
    runpath="$(readelf -d "$file" 2>/dev/null \
               | sed -nE 's/.*R(UN)?PATH.*\[(.*)\]/\2/p' | head -1)"
    [[ -n "$runpath" ]] || return 0
    local IFS=':'
    for entry in $runpath; do
        [[ -z "$entry" ]] && continue
        case "$entry" in
            "\$ORIGIN"*) : ;;
            "$PROD_TREE"/*) : ;;
            *) if [[ -n "$extra" && "$entry/" == "$extra"/* ]]; then continue; fi
               die "$(basename "$file") runpath names a path outside the production tree: $entry" ;;
        esac
    done
    return 0
}

# --- arguments and environment ----------------------------------------------
case "${1:-}" in
    -h|--help) usage; exit 0 ;;
esac
[[ $# -eq 2 ]] || { usage >&2; exit 2; }
[[ -d "$1" ]] || die "module directory not found: $1"
[[ -d "$2" ]] || die "IOC directory not found: $2"
[[ -n "${EPICS_BASE:-}" ]] || die "EPICS_BASE is not set; source <tree>/setEpicsEnv.bash of the production tree first"

MODULE_DIR="$(realpath "$1")"
IOC_DIR="$(realpath "$2")"
PROD_TREE="$(realpath "${EPICS_BASE%/}/..")"
MODULE="$(basename "$MODULE_DIR")"
IOC_NAME="$(basename "$IOC_DIR")"
SCRATCH="$(dirname "$MODULE_DIR")"
STARTED="${SCRATCH}/.started"
readonly MODULE_DIR IOC_DIR PROD_TREE MODULE IOC_NAME SCRATCH STARTED

[[ -d "${PROD_TREE}/base" && -d "${PROD_TREE}/modules" ]] \
    || die "EPICS_BASE does not point into a production tree with base/ and modules/: $EPICS_BASE"
case "$MODULE_DIR/" in "$PROD_TREE"/*) die "module directory is inside the production tree" ;; esac
case "$IOC_DIR/" in "$PROD_TREE"/*) die "IOC directory is inside the production tree" ;; esac
[[ -d "${MODULE_DIR}/configure" ]] || die "not an EPICS module top: $MODULE_DIR"
[[ -d "${IOC_DIR}/configure" ]] || die "not an EPICS IOC top: $IOC_DIR"

need_cmd make
need_cmd readelf
need_cmd ldd

# EPICS-env names each module by a key: configure/MODULESGEN.mk installs it as
# INSTALL_LOCATION_<KEY>:=$(INSTALL_LOCATION_MODS)/<module>-<version>. The key
# is the module's clone target and the variable an IOC's RELEASE uses for it.
# Its configuration target is conf.<module>, or conf.<key in lower case>.
MODULE_VAR="$(sed -nE "s#^INSTALL_LOCATION_([A-Z0-9_]+):=\\\$\(INSTALL_LOCATION_MODS\)/${MODULE}-[^/]*\$#\1#p" \
    "${ENV_CHECKOUT}/configure/MODULESGEN.mk" | head -1)"
[[ -n "$MODULE_VAR" ]] || die "module $MODULE not found in ${ENV_CHECKOUT}/configure/MODULESGEN.mk; name the module directory after the installed module"
CONF_NAME="$MODULE"
if ! make -s -n -C "$ENV_CHECKOUT" "conf.${CONF_NAME}.show" >/dev/null 2>&1; then
    CONF_NAME="${MODULE_VAR,,}"
fi
readonly MODULE_VAR CONF_NAME

# shellcheck disable=SC2317  # invoked through the EXIT trap
function on_exit {
    local ec=$?
    if [[ "$ec" -ne 0 ]]; then
        printf "\n[%s] failed (exit %d); build logs kept in %s\n" "$PROG" "$ec" "$SCRATCH" >&2
    fi
}
trap on_exit EXIT

info "production tree: $PROD_TREE"
info "module: $MODULE_DIR"
info "IOC: $IOC_DIR"
: > "$STARTED"

# --- step 2: build the module against the production tree -------------------
# The module's dependencies are the ones the production module was built
# with: its installed configure/RELEASE.local, with the install root it
# records rewritten to the production tree. An installed module without that
# file has no module dependencies beyond base. The module's own configuration
# lines (vendor paths and switches) come from the EPICS-env checkout, with
# every vendor prefix, configured or default, pointed at <tree>/vendor.
installed_dir="${PROD_TREE}/modules/${MODULE}"
installed_release="${installed_dir}/configure/RELEASE.local"
[[ -d "$installed_dir" ]] || die "no installed ${MODULE} in the production tree: $installed_dir"

# Prints the lines of one file of the conf.<module>.show listing: the
# checkout's top RELEASE.local, or the module's configure/RELEASE.local or
# configure/CONFIG_SITE.local. The listing marks each file with a
# "cat -b <path>" line; the order of the files differs between modules.
function conf_file {
    local want="$1"
    printf "%s\n" "$conf_out" \
        | awk -v want="$want" '
            /^cat -b / {
                cur = ""
                if ($3 ~ /\/configure\/RELEASE[.]local$/)          cur = "module-release"
                else if ($3 ~ /\/configure\/CONFIG_SITE[.]local$/) cur = "module-config"
                else if ($3 ~ /\/RELEASE[.]local$/)                 cur = "top-release"
                next
            }
            /^[[:space:]]*[0-9]+[[:space:]]/ { if (cur == want) print }' \
        | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//'
    return 0
}

# Prints dependency lines without comments, blank lines, and EPICS_BASE.
function dep_lines {
    grep -vE '^[[:space:]]*(#|$|EPICS_BASE[[:space:]]*:?=)' || true
}

# MAKEFLAGS is cleared so that a silent make in the caller's environment
# cannot hide the "cat -b <path>" lines that mark each file.
conf_out="$(MAKEFLAGS='' make -C "$ENV_CHECKOUT" "conf.${CONF_NAME}.show" 2>/dev/null)" \
    || die "cannot read conf.${CONF_NAME}.show; run 'make ${MODULE_VAR} conf.release.modules conf.${CONF_NAME}' in $ENV_CHECKOUT first"
env_root="$(conf_file top-release | sed -nE 's/^EPICS_BASE[[:space:]]*:?=[[:space:]]*(.*)\/base[[:space:]]*$/\1/p' | head -1)"
[[ -n "$env_root" ]] || die "cannot derive the configured tree root from conf.${CONF_NAME}.show"

tree_deps=""
if [[ -s "$installed_release" ]]; then
    recorded_root="$(sed -nE 's#^[A-Za-z0-9_]+[[:space:]]*:?=[[:space:]]*(/.*)/(base|modules/[^/]+)([/].*)?$#\1#p' "$installed_release" | head -1)"
    [[ -n "$recorded_root" ]] || die "cannot find the install root recorded in $installed_release"
    tree_deps="$(dep_lines < "$installed_release" | sed "s#${recorded_root}/#${PROD_TREE}/#g")"
fi
env_deps="$(conf_file module-release | dep_lines | sed "s#${env_root}/#${PROD_TREE}/#g")"

{
    printf "EPICS_BASE:=%s/base\n" "$PROD_TREE"
    [[ -z "$tree_deps" ]] || printf "%s\n" "$tree_deps"
} > "${MODULE_DIR}/configure/RELEASE.local"
{
    conf_file module-config \
        | { grep -vE '^(INSTALL_LOCATION|-include)' || true; } \
        | sed -E "s#${env_root}/vendor(/|\$)#${PROD_TREE}/vendor\1#g; s#(=[[:space:]]*)${DEFAULT_VENDOR}(/|\$)#\1${PROD_TREE}/vendor\2#g" \
        | sed "s#${env_root}/#${PROD_TREE}/#g"
    printf "CHECK_RELEASE = NO\n"
    printf "PROD_LDFLAGS += -Wl,--enable-new-dtags\n"
} > "${MODULE_DIR}/configure/CONFIG_SITE.local"
info "module dependencies from the production tree: $(printf "%s" "$tree_deps" | grep -c '=' || true) entries"

# Cross-check: the dependencies the EPICS-env checkout generates must name
# the same modules as the installed module. A difference means the checkout
# is not at the production release, so its module configuration lines may
# differ from production as well.
if [[ "$(printf "%s\n" "$env_deps" | LC_ALL=C sort)" == "$(printf "%s\n" "$tree_deps" | LC_ALL=C sort)" ]]; then
    info "dependency cross-check: EPICS-env checkout matches the installed module"
else
    info "EPICS-env checkout dependencies differ from the installed module (< installed, > checkout):"
    diff <(printf "%s\n" "$tree_deps" | LC_ALL=C sort) <(printf "%s\n" "$env_deps" | LC_ALL=C sort) | sed 's/^/    /' || true
    info "the build uses the installed module's dependencies; the checkout's module"
    info "configuration may not match production (check out the release production runs)"
    confirm "continue with this module configuration?"
fi

make -C "$MODULE_DIR" -j4 > "${SCRATCH}/module-build.log" 2>&1 \
    || die "module build failed; see ${SCRATCH}/module-build.log"
info "module build: OK"

# The module's shared libraries are the ones the production module installs;
# each must be rebuilt, and its runpath must name only the production tree.
prod_libdir="${PROD_TREE}/modules/${MODULE}/lib/${ARCH}"
mapfile -t module_libs < <(find "$prod_libdir" -maxdepth 1 -name 'lib*.so' -printf '%f\n' 2>/dev/null | LC_ALL=C sort)
for lib in "${module_libs[@]}"; do
    [[ -s "${MODULE_DIR}/lib/${ARCH}/${lib}" ]] || die "module library not produced: ${MODULE_DIR}/lib/${ARCH}/${lib}"
    check_runpath "${MODULE_DIR}/lib/${ARCH}/${lib}"
done
if [[ ${#module_libs[@]} -eq 0 ]]; then
    info "the production module installs no shared library; library checks skipped"
else
    info "module libraries (${module_libs[*]}): runpath only the production tree"
fi

# The rebuilt library must resolve every shared library to the same file as
# the production module does. Paths are compared after normalization, since
# production resolves through \$ORIGIN, and a library of the module itself
# counts as the same on both sides.
function resolved_libs {
    local lib="$1" own="$2"
    local name path
    ldd "$lib" | awk '$3 ~ /^\// { print $1, $3 }' | while read -r name path; do
        path="$(realpath "$path")"
        printf "%s %s\n" "$name" "${path/#"$own"\//<module>/}"
    done
    return 0
}
prod_own="$(realpath "${PROD_TREE}/modules/${MODULE}")"
for lib in "${module_libs[@]}"; do
    ldd_diff="$(diff <(resolved_libs "${prod_libdir}/${lib}" "$prod_own") \
                     <(resolved_libs "${MODULE_DIR}/lib/${ARCH}/${lib}" "$MODULE_DIR") || true)"
    [[ -z "$ldd_diff" ]] || die "${lib} resolves shared libraries differently from production: $ldd_diff"
done
[[ ${#module_libs[@]} -eq 0 ]] || info "module libraries resolve the same shared libraries as production"

# --- step 3: build the IOC against the module -------------------------------
# A vendor path the module hands its consumers through an installed
# cfg/CONFIG_* file is self-located and does not exist for a module built
# outside the tree, so the IOC declares it against the production tree.
{
    printf "EPICS_BASE=%s/base\n" "$PROD_TREE"
    printf "%s=%s\n" "$MODULE_VAR" "$MODULE_DIR"
} > "${IOC_DIR}/configure/RELEASE.local"
{
    printf "CHECK_RELEASE = NO\n"
    if compgen -G "${MODULE_DIR}/cfg/CONFIG_*" >/dev/null; then
        sed -nE 's#^[[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=.*/vendor[[:space:]]*$#\1#p' \
            "${MODULE_DIR}"/cfg/CONFIG_* \
            | sort -u \
            | while IFS= read -r var; do
                printf "%s=%s/vendor\n" "$var" "$PROD_TREE"
            done
    fi
} > "${IOC_DIR}/configure/CONFIG_SITE.local"

make -C "$IOC_DIR" -j4 > "${SCRATCH}/ioc-build.log" 2>&1 \
    || die "IOC build failed; see ${SCRATCH}/ioc-build.log"
ioc_bin="${IOC_DIR}/bin/${ARCH}/${IOC_NAME}"
[[ -x "$ioc_bin" ]] || die "IOC binary not produced: $ioc_bin (the IOC directory name must be the binary name)"
check_runpath "$ioc_bin" "$MODULE_DIR"
# The IOC must link at least one module library, and every module library it
# links must come from the module directory, not from production.
IOC_HINT="the copy's configure/RELEASE must name the module by ${MODULE_VAR}; edit that file in the copy if it uses another variable"
if [[ ${#module_libs[@]} -gt 0 ]]; then
    ioc_ldd="$(ldd "$ioc_bin")"
    linked=0
    for lib in "${module_libs[@]}"; do
        path="$(printf "%s\n" "$ioc_ldd" | awk -v n="$lib" '$1 == n { print $3 }')"
        [[ -n "$path" ]] || continue
        [[ "$path" == "$MODULE_DIR"/* ]] \
            || die "IOC links ${lib} from ${path}, not from $MODULE_DIR; ${IOC_HINT}"
        linked=$((linked + 1))
    done
    [[ "$linked" -gt 0 ]] || die "IOC links none of the module libraries (${module_libs[*]}); ${IOC_HINT}"
    info "IOC build: OK; links ${linked} module librar$([[ "$linked" -eq 1 ]] && printf "y" || printf "ies") from the module directory"
else
    info "IOC build: OK"
fi

# --- production tree untouched ----------------------------------------------
touched="$(find "$PROD_TREE" -type f \( -newer "$STARTED" -o -cnewer "$STARTED" \) 2>/dev/null | head -1 || true)"
[[ -z "$touched" ]] || die "production tree was written during the build: $touched"
info "production tree untouched"

printf "\n%s\n" "----------------------------------------------------------------"
printf "Steps 2-3 PASSED: %s and %s against %s\n" "$MODULE" "$IOC_NAME" "$PROD_TREE"
printf "Build logs: %s/module-build.log, %s/ioc-build.log\n" "$SCRATCH" "$SCRATCH"
printf "%s\n" "----------------------------------------------------------------"
printf "%s\n" "Steps 4-5 (manual, one IOC at a time):"
printf "%s\n" "  1. tools/pv_snapshot.bash capture -l <pvlist> -o before.txt  (production running)"
printf "%s\n" "  2. stop the production IOC; start the copy from its iocBoot with the defect visible"
printf "%s\n" "  3. observe the defect check; capture after.txt"
printf "%s\n" "  4. stop the copy; restart production; capture restored.txt"
printf "%s\n" "  5. tools/pv_snapshot.bash compare -t <tolerance> before.txt after.txt"
printf "%s\n" "     tools/pv_snapshot.bash compare -t <tolerance> before.txt restored.txt"

exit 0
