# Architecture

## Purpose

EPICS-env assembles one authoritative EPICS foundation — a curated EPICS
Base plus a pinned set of EPICS modules — that every IOC and site
application at the facility builds on. It is designed to be rebuilt from
source at any point in the facility's lifetime, on a supported operating
system, using nothing but GNU Make and the system toolchain. It relies on
no OS-level EPICS packages and no external build service, so the same
inputs produce the same tree years apart.

## Design principles

The environment follows a small set of principles, and the rest of this
chapter shows the mechanisms that enforce each one.

- **Reproducible and long-lived.** The whole build is plain GNU Make.
  There is no wrapper language, container, or hosted service in the build
  path, so a checkout plus a compiler is enough to rebuild the tree.
- **Curated and version-pinned.** Base and every module are pinned to an
  exact tag or commit in `configure/RELEASE`; a version moves only by an
  explicit, reviewed edit to that pin. Vendored libraries such as open62541
  and uldaq are provided from a system path, not pinned here.
- **Self-contained.** Everything installs under one prefix, so a build
  never depends on EPICS artifacts placed elsewhere on the host.
- **Fixes carried in-tree.** Upstream fixes not yet in a pinned release are
  applied as patches under `patch/`, not by forking the upstream
  repository. A carried patch is distinct from a version bump.
- **Relocatable.** The installed tree uses an `$ORIGIN`-relative RUNPATH
  and versionless symlinks, so it can be moved or copied to another host
  without rebuilding.
- **Controlled, auditable evolution.** Two independent gates — a pre-build
  source dependency audit and a post-install binary audit — must pass
  before a tree is accepted, and both run in CI.
- **Proven on a matrix.** Each supported operating system builds and
  passes those gates in its own CI workflow.

## How it is organized

The top-level `Makefile` includes `configure/CONFIG` and `configure/RULES`.
These two files are the aggregation points: `CONFIG` pulls in the
`CONFIG_*` fragments (the version pins, the site settings, the source and
Base and module variables, and the audit variables), and `RULES` pulls in
the `RULES_*` fragments (the patch, source, Base, module, install, and
audit targets). Adding a concern means adding a fragment, not enlarging one
large file.

Two files hold the hand-edited site identity:

- `configure/RELEASE` — the version pins. For each source it records the
  repository URL, the name, and the exact tag or commit to check out.
- `configure/CONFIG_SITE` — `INSTALL_LOCATION` (the install prefix) and
  `ENV_RELEASE_VERS` (the environment's own version, which names the
  install path).

The top-level `RELEASE.local` and `CONFIG_SITE.local` are generated during
configuration from those files and the detected platform; they are not
edited by hand. Each module is cloned into its own `<name>-src/` working
tree, the module build variables are generated into
`configure/MODULESGEN.mk`, and the carried fixes live under `patch/`.

## Build pipeline

A full build runs as an ordered sequence of make targets, each adding one
contribution toward the reproducible tree:

1. `make init` — clone Base and every pinned module at its pin, and
   generate the module build variables.
2. `make patch` — apply the version-anchored Base and module fixes from
   `patch/` to the checked-out sources.
3. `make conf` — configure Base and the modules, writing the generated
   `RELEASE.local` and `CONFIG_SITE.local` for the detected platform.
4. `make check.module-deps` — the pre-build audit gate: check the declared
   inter-module dependencies before compiling anything. CI runs it; a local
   build from source does not need it as a routine step.
5. `make build` — compile Base and then the modules, in dependency order.
6. `make install` — install the built artifacts under the version-named
   prefix.
7. `make symlinks` — create the versionless symlinks the installed tree
   uses to find its own libraries and executables.

The public distribution uses the same sequence with `make build.gz` in
place of `make build`; that flavor strips debug information for a smaller
installed tree.

## Consistency and relocatability

Two independent gates protect every accepted tree, at opposite ends of the
build:

- **`make check.module-deps`** is the pre-build source audit. It reads the
  declared dependencies across the module set and fails before compilation
  if they are inconsistent.
- **`make check.deps`** is the post-install binary audit. It inspects the
  installed ELF files and their RUNPATH entries and fails on any
  absolute path, any leftover build-tree RPATH, or any lost
  `$ORIGIN` reference. In CI it runs strict, so any finding is an error.

Relocatability comes from three mechanisms working together: the single
install prefix, the `$ORIGIN`-relative RUNPATH that lets a binary find its
siblings by relative position, and the versionless symlinks that give
consumers a stable path independent of the pinned version. Because the
`check.deps` gate proves there is no absolute or build-tree path left in
the binaries, the whole tree can be moved to another host and still run.

The carry mechanism keeps the pinned Base and pvxs current without forking:
fixes are stored as version-anchored patches under `patch/` and reapplied
on each build, and they drop automatically when the pin they target moves,
forcing a re-examination. This is deliberately distinct from a module
version bump, which changes a pin in `configure/RELEASE`.

For deployment, the built tree is published as a prebuilt distribution, so
a consumer that only needs to run the environment installs that instead of
building from source.

## Platforms and verification

The environment is built and verified on a matrix of supported operating
systems, each with its own CI workflow that runs the full pipeline and both
audit gates. Downstream consumers — individual IOCs, site application
trees, and the shared services brought up by a global iocsh — build on the
foundation this repository produces, so a green matrix is the contract they
depend on.
