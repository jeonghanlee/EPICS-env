#!/usr/bin/env bash
#
# verify_fix_stage3.bash - automate the no-hardware part of Stage 3 of
# docs/upstream-fix-verification-procedure.md: build a fixed upstream module
# beside a selected production tree, build a consumer IOC copy against it, and
# verify the links and that the install root was not touched.
#
# It does NOT run the hardware verification (stopping the production IOC,
# capturing the baseline, starting the test copy): that touches a running IOC
# and stays manual. The script prints those steps at the end.
#
# The build is done in a scratch directory outside the install root and any
# checkout; nothing is written under the production tree.

set -euo pipefail

readonly PROG="${0##*/}"

# --- configuration (all overridable by CLI flags) ---------------------------
MODULE="measComp"
FORK_CHECKOUT="/data/gitsrc/measComp"
BASE_COMMIT="9c8e01e"
FIX_PATCH=""                         # required: the git-diff fix patch (p1)
ENV_CHECKOUT="/data/gitsrc/EPICS-env"
PROD_TREE=""                         # required: absolute path to the selected tree
IOC_CHECKOUT=""                      # optional: consumer IOC repo
IOC_COMMIT=""                        # required if IOC_CHECKOUT set
IOC_RELEASE_VAR="MEASCOMP"           # the RELEASE entry pointing at this module
VENDOR_VAR=""                        # e.g. ULDAQ_DIR; empty to skip vendor decl
SCRATCH=""                           # default ~/scratchpad/<module>-fix
ARCH="linux-x86_64"

# --- helpers ----------------------------------------------------------------
function die {
    printf "%s: error: %s\n" "$PROG" "$1" >&2
    exit 1
}

function info {
    printf "[%s] %s\n" "$PROG" "$1"
}

function need_cmd {
    local cmd="$1" bin
    bin="${cmd%% *}"
    command -v "$bin" >/dev/null 2>&1 || die "required command not found: $bin"
    [[ -x "$(command -v "$bin")" ]] || die "not executable: $bin"
}

function usage {
    cat <<EOF
Usage: $PROG --fix-patch FILE --prod-tree DIR [options]

Automates the no-hardware Stage 3 build and verification for one module.

Required:
  --fix-patch FILE     the fix as a git-diff patch (p1), applied onto the base
  --prod-tree DIR      absolute path to the selected production install tree
                       (<root>/<ver>/<os>/<base>; owner-confirmed or latest)

Common options (defaults for measComp shown):
  --module NAME        module name                     [$MODULE]
  --fork-checkout DIR  a checkout of the module fork   [$FORK_CHECKOUT]
  --base-commit REF    base commit for git archive     [$BASE_COMMIT]
  --env-checkout DIR   the EPICS-env checkout          [$ENV_CHECKOUT]
  --local-patch FILE   an environment p0 patch (repeatable)
  --ioc-checkout DIR   a consumer IOC repo to build against the fix
  --ioc-commit REF     the IOC commit to git archive
  --ioc-release-var V  RELEASE entry naming this module [$IOC_RELEASE_VAR]
  --vendor-var NAME    consumer vendor prefix var, e.g. ULDAQ_DIR
  --scratch DIR        scratch root [~/scratchpad/<module>-fix]
  --arch ARCH          EPICS target arch               [$ARCH]
  -h, --help           this help
EOF
}

# --- CLI --------------------------------------------------------------------
declare -a local_patch_list=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --module)         MODULE="$2"; shift 2 ;;
        --fork-checkout)  FORK_CHECKOUT="$2"; shift 2 ;;
        --base-commit)    BASE_COMMIT="$2"; shift 2 ;;
        --fix-patch)      FIX_PATCH="$2"; shift 2 ;;
        --env-checkout)   ENV_CHECKOUT="$2"; shift 2 ;;
        --local-patch)    local_patch_list+=("$2"); shift 2 ;;
        --prod-tree)      PROD_TREE="$2"; shift 2 ;;
        --ioc-checkout)   IOC_CHECKOUT="$2"; shift 2 ;;
        --ioc-commit)     IOC_COMMIT="$2"; shift 2 ;;
        --ioc-release-var) IOC_RELEASE_VAR="$2"; shift 2 ;;
        --vendor-var)     VENDOR_VAR="$2"; shift 2 ;;
        --scratch)        SCRATCH="$2"; shift 2 ;;
        --arch)           ARCH="$2"; shift 2 ;;
        -h|--help)        usage; exit 0 ;;
        --)               shift; break ;;
        -*)               die "unknown option: $1" ;;
        *)                die "unexpected argument: $1" ;;
    esac
done

[[ -n "$FIX_PATCH" ]]  || { usage >&2; die "--fix-patch is required"; }
[[ -n "$PROD_TREE" ]]  || { usage >&2; die "--prod-tree is required"; }
[[ -s "$FIX_PATCH" ]]  || die "fix patch missing or empty: $FIX_PATCH"
[[ -d "$PROD_TREE/base" ]] || die "prod tree has no base/: $PROD_TREE"
[[ -d "$FORK_CHECKOUT/.git" ]] || die "fork checkout is not a git repo: $FORK_CHECKOUT"
[[ -z "$IOC_CHECKOUT" || -n "$IOC_COMMIT" ]] || die "--ioc-commit required with --ioc-checkout"

for f in "${local_patch_list[@]}"; do
    [[ -s "$f" ]] || die "local patch missing or empty: $f"
done

need_cmd git
need_cmd make
need_cmd patch
need_cmd readelf
need_cmd tar

[[ -n "$SCRATCH" ]] || SCRATCH="${HOME}/scratchpad/${MODULE}-fix"
readonly MODULE FORK_CHECKOUT BASE_COMMIT FIX_PATCH ENV_CHECKOUT PROD_TREE
readonly IOC_CHECKOUT IOC_COMMIT IOC_RELEASE_VAR VENDOR_VAR SCRATCH ARCH
readonly MODULE_DIR="${SCRATCH}/${MODULE}"

# --- cleanup ----------------------------------------------------------------
function on_exit {
    local ec=$?
    if [[ "$ec" -ne 0 ]]; then
        printf "\n[%s] failed (exit %d); scratch kept for inspection: %s\n" \
            "$PROG" "$ec" "$SCRATCH" >&2
    fi
}
trap on_exit EXIT

# --- Stage 3: build the module beside production ----------------------------
info "scratch: $SCRATCH"
mkdir -p "$SCRATCH"
: > "${SCRATCH}/.started"                # timestamp; must predate every build

rm -rf "$MODULE_DIR"
mkdir -p "$MODULE_DIR"
git -C "$FORK_CHECKOUT" archive "$BASE_COMMIT" | tar -x -C "$MODULE_DIR"
info "base source unpacked: ${MODULE}@${BASE_COMMIT}"

if ! git -C "$MODULE_DIR" apply "$FIX_PATCH" 2>/dev/null; then
    patch -d "$MODULE_DIR" -p1 < "$FIX_PATCH" >/dev/null 2>&1 \
        || die "fix patch did not apply onto ${MODULE}@${BASE_COMMIT}: $FIX_PATCH"
fi
info "fix applied: $(basename "$FIX_PATCH") (sha256 $(sha256sum "$FIX_PATCH" | cut -c1-16))"

for f in "${local_patch_list[@]}"; do
    patch -d "$MODULE_DIR" --ignore-whitespace -p0 < "$f" >/dev/null
    info "environment patch applied: $(basename "$f")"
done

# compose configure/*.local from conf.<module>.show, paths rewritten to PROD_TREE.
# Read the environment's generated config once and derive the tree root it used.
conf_out="$(make -C "$ENV_CHECKOUT" "conf.${MODULE}.show" 2>/dev/null)"
[[ -n "$conf_out" ]] || die "cannot read conf.${MODULE}.show; run 'make conf' in $ENV_CHECKOUT first"
env_root="$(printf "%s\n" "$conf_out" | grep -m1 -E 'EPICS_BASE' | sed -E 's/.*=//; s#/base##; s/[[:space:]]//g')"
[[ -n "$env_root" ]] || die "cannot derive the environment tree root from conf.${MODULE}.show"
info "rewriting paths: $env_root -> $PROD_TREE"
# RELEASE.local: EPICS_BASE + the module's dependency lines
{
    printf "EPICS_BASE:=%s/base\n" "$PROD_TREE"
    # rewrite the tree root, then drop the module version suffix so paths use
    # the unversioned symlink (modules/asyn) present in every tree, not the
    # env's pinned versioned dir (modules/asyn-4.45.0) which the target tree
    # need not have.
    printf "%s\n" "$conf_out" \
        | grep -E '^[[:space:]]*[0-9]+[[:space:]]+[A-Z].*=' \
        | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' \
        | grep -vE '^(EPICS_BASE|INSTALL_LOCATION|HAVE_ULDAQ|ULDAQ_|LINUX_|CHECK_RELEASE|PROD_LDFLAGS|SUPPORT)' \
        | sed "s#${env_root}#${PROD_TREE}#g" \
        | sed -E 's#(/modules/[A-Za-z][A-Za-z0-9_+-]*)-([0-9][^/]*|[0-9a-f]{7,})($|/)#\1\3#g'
} > "${MODULE_DIR}/configure/RELEASE.local"
# CONFIG_SITE.local: module CONFIG lines except INSTALL_LOCATION, + guards
{
    printf "%s\n" "$conf_out" \
        | grep -E '^[[:space:]]*[0-9]+[[:space:]]+(HAVE_|ULDAQ_|LINUX_)' \
        | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' \
        | sed "s#${env_root}#${PROD_TREE}#g"
    printf "CHECK_RELEASE = NO\n"
    printf "PROD_LDFLAGS += -Wl,--enable-new-dtags\n"
} > "${MODULE_DIR}/configure/CONFIG_SITE.local"
info "configure files composed (INSTALL_LOCATION dropped, CHECK_RELEASE=NO kept)"

make -C "$MODULE_DIR" -j4 >"${SCRATCH}/module-build.log" 2>&1 \
    || die "module build failed; see ${SCRATCH}/module-build.log"
info "module build: OK"

local_so="${MODULE_DIR}/lib/${ARCH}/lib${MODULE}.so"
[[ -s "$local_so" ]] || die "module library not produced: $local_so"

# verify the module links only into the prod tree + itself: split the runpath
# on ':' and require every entry to be $ORIGIN-based or under the prod tree.
function check_runpath {
    local file="$1" runpath entry
    runpath="$(readelf -d "$file" 2>/dev/null \
               | sed -nE 's/.*R(UN)?PATH.*\[(.*)\]/\2/p' | head -1)"
    [[ -n "$runpath" ]] || return 0
    local IFS=':'
    for entry in $runpath; do
        [[ -z "$entry" ]] && continue
        case "$entry" in
            "\$ORIGIN"*) : ;;                 # relative to the binary, fine
            "$PROD_TREE"/*) : ;;              # under the selected prod tree, fine
            *) die "$(basename "$file") runpath names a foreign path: $entry" ;;
        esac
    done
}
check_runpath "$local_so"
info "module RUNPATH: only $PROD_TREE (+ \$ORIGIN)"

# --- Stage 3: build the consumer IOC copy (optional) ------------------------
if [[ -n "$IOC_CHECKOUT" ]]; then
    ioc_name="$(basename "$IOC_CHECKOUT")"
    ioc_dir="${SCRATCH}/${ioc_name}"
    rm -rf "$ioc_dir"; mkdir -p "$ioc_dir"
    git -C "$IOC_CHECKOUT" archive "$IOC_COMMIT" | tar -x -C "$ioc_dir"
    info "consumer IOC unpacked: ${ioc_name}@${IOC_COMMIT}"

    {
        printf "EPICS_BASE=%s/base\n" "$PROD_TREE"
        printf "%s=%s\n" "$IOC_RELEASE_VAR" "$MODULE_DIR"
    } > "${ioc_dir}/configure/RELEASE.local"
    {
        printf "CHECK_RELEASE = NO\n"
        [[ -n "$VENDOR_VAR" ]] && printf "%s=%s/vendor\n" "$VENDOR_VAR" "$PROD_TREE"
    } > "${ioc_dir}/configure/CONFIG_SITE.local"

    make -C "$ioc_dir" -j4 >"${SCRATCH}/ioc-build.log" 2>&1 \
        || die "IOC build failed; see ${SCRATCH}/ioc-build.log"
    info "consumer IOC build: OK"

    # Enforce the core Stage 3 guarantee: the IOC must resolve the module from
    # the scratch build, not from the production tree. A binary that links the
    # production module tests nothing, so an unmet check is a failure, not a note.
    ioc_bin="${ioc_dir}/bin/${ARCH}/${ioc_name}"
    [[ -x "$ioc_bin" ]] || die "IOC binary not produced: $ioc_bin (does the IOC name differ from '$ioc_name'? pass the right --arch/checkout)"
    need_cmd ldd
    ldd "$ioc_bin" | grep -E "lib${MODULE}\.so" | grep -qF "$MODULE_DIR" \
        || die "IOC does not link lib${MODULE}.so from the scratch build ($MODULE_DIR); it would test the production module, not the fix"
    info "IOC links lib${MODULE}.so from the scratch build"
fi

# --- teardown: prove the install root was not touched -----------------------
touched="$(find "$PROD_TREE" -type f \
            \( -newer "${SCRATCH}/.started" -o -cnewer "${SCRATCH}/.started" \) \
            2>/dev/null | head -1 || true)"
[[ -z "$touched" ]] || die "install root was modified during the build: $touched"
info "install root untouched: verified"

# --- summary + manual hardware steps ----------------------------------------
printf "\n%s\n" "----------------------------------------------------------------"
printf "Stage 3 no-hardware verification PASSED for %s against %s\n" "$MODULE" "$PROD_TREE"
printf "%s\n" "Evidence in: $SCRATCH (module-build.log, ioc-build.log)"
printf "%s\n" "----------------------------------------------------------------"
printf "%s\n" "Hardware run (manual, in a maintenance window):"
printf "%s\n" "  1. capture the baseline: caget over the device's PVs"
printf "%s\n" "  2. stop the production IOC; start the copy from its iocBoot with error output on"
printf "%s\n" "  3. check: no TIn error over >=10 poll cycles; asynReport shows the corrected count"
printf "%s\n" "  4. stop the copy; restart production; re-read the baseline PVs"
printf "%s\n" "Record the result in the datetime-named record per the procedure."

exit 0
