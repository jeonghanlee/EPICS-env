# Supported platforms and CI

EPICS-env builds the Experimental Physics and Industrial Control System (EPICS)
base and modules on six Linux operating systems (OS). Each OS has one
continuous integration (CI) workflow in `.github/workflows/` that builds and
checks the whole environment in a container. Two more workflows lint the Bash
sources and publish this book. Every workflow runs on a GitHub Actions
`ubuntu-latest` runner.

## Supported operating systems and containers

The supported OS list is the set of OS workflows. `README.md` shows one status
badge for each of them and one for the Linter Run workflow.

| OS | Workflow file | Workflow name | Container image |
| --- | --- | --- | --- |
| Debian 12 | `debian12.yml` | Debian 12 | `debian:bookworm-slim` |
| Debian 13 | `debian13.yml` | Debian 13 | `debian:trixie-slim` |
| Rocky Linux 8 | `rocky8.yml` | Rocky 8 | `rockylinux/rockylinux:8` |
| Rocky Linux 10 | `rocky10.yml` | Rocky 10 | `rockylinux/rockylinux:10` |
| Ubuntu 24.04 | `ubuntu24.yml` | Ubuntu 24.04 | `ubuntu:24.04` |
| Ubuntu 26.04 | `ubuntu26.yml` | Ubuntu 26.04 | `ubuntu:26.04` |

## Package setup in the OS workflows

Each OS workflow prepares its container in the `Install required packages`
step:

- It installs `git`, `make`, `sudo`, `bash`, `wget`, and `unzip` with `apt`
  or `dnf`. The Rocky 8 workflow runs `dnf update` first and also installs
  `tree`.
- It clones `pkg_automation` from `https://github.com/jeonghanlee` and runs
  `pkg_automation.bash -y` to install the build dependencies.
- The Rocky 8 workflow then installs `python3-pip` and `libusbx-devel`, and
  installs `numpy` and `nose` with `pip3`.
- The Ubuntu workflows set the time zone to `America/Los_Angeles` and export
  `LC_CTYPE` and `LC_ALL` as `C.UTF-8`.

## Vendor library build in the OS workflows

Each OS workflow builds the uldaq and open62541 libraries before EPICS-env.
The vendor directory is the `vendor` directory of the installed tree, the value
of `make print-INSTALL_LOCATION_EPICS` followed by `/vendor`. The workflow
first writes `configure/RELEASE.local` with `VENDOR_ULDAQ_PATH` set to that
directory and `OPEN62541_PATH` set to a path relative to the `opcua`
configuration. It then clones `uldaq-env` and `open62541-env` from
`https://github.com/jeonghanlee` and installs both into the vendor directory.

| Workflows | Clone depth | Build targets in each vendor repository |
| --- | --- | --- |
| Debian 12, Debian 13, Ubuntu 24.04, Ubuntu 26.04 | Full history | `github` |
| Rocky 8, Rocky 10 | `--depth 1` | `init`, `conf.rocky8`, `build`, and `install` |

## Build sequence in each OS workflow

The `EPICS installation` step runs these make targets in order.
`github.check` runs `init`, `patch`, `vars`, `conf`, `check.module-deps`,
`build`, and `symlinks`.

| Workflows | Make targets in order |
| --- | --- |
| Debian 12, Debian 13, Rocky 8 | `github.check`, `install` |
| Rocky 10 | `init`, `patch`, `conf`, `build`, `install`, `symlinks` |
| Ubuntu 24.04, Ubuntu 26.04 | `init`, `patch`, `conf`, `vars`, `build`, `install`, `symlinks` |

Only the Debian 12, Debian 13, and Rocky 8 workflows run the module dependency
gate `check.module-deps`.

## Final checks in each OS workflow

The `EPICS Environment Check` step runs the same three targets in every OS
workflow, after the install:

1. `make exist` prints the installed tree to depth 2.
2. `make check.env` fails the job when the installed `setEpicsEnv.bash` adds
   a `pvxs/bundle` path to `LD_LIBRARY_PATH`, or when it cannot be inspected.
3. `make check.deps` fails the job on any runpath finding in the installed
   executables and shared libraries.

[Tools and scripts reference](tools-and-scripts.md#programs-in-the-tools-directory)
lists the exit status of each check.

## Workflow triggers and path filters

A `paths-ignore` filter skips a push only when every changed file matches one
of its patterns. A push that changes at least one other file runs the
workflow. A pull request runs every workflow that has a `pull_request`
trigger, with no path filter. The push triggers of the OS workflows and Linter
Run have no branch or tag filter, so a tag push also runs them; GitHub Actions
does not apply path filters to tag pushes.

| Workflow | Push trigger | Pull request trigger | Manual run |
| --- | --- | --- | --- |
| Each OS workflow | Any branch or tag; `paths-ignore` on branch pushes: `**.md`, `docs/**`, `site-template/**`, `LICENSE`, `linter.yml`, `docs.yml`, and the five other OS workflow files | Pull requests to `master` | No |
| Linter Run (`linter.yml`) | Any branch or tag; `paths-ignore` on branch pushes: `docs/**` and `ChangeLog.md` | Pull requests to `master` | No |
| Deploy Docs (`docs.yml`) | `master` only; `paths`: `docs/src/**`, `docs/book.toml`, and `.github/workflows/docs.yml` | None | Yes, through `workflow_dispatch` |

The workflow file names in the OS filters are paths under
`.github/workflows/`. An OS workflow does not ignore its own file, so a push
that changes only one OS workflow file runs that OS workflow and Linter Run.

## Linter Run workflow steps

The Linter Run workflow has one job, `Lint Code Base`:

1. It checks out the full history with `fetch-depth: 0` and without stored
   credentials.
2. It runs `super-linter/super-linter@v8.7.0` with `VALIDATE_BASH` set to
   `true`.

The workflow grants no permissions at the top level. The job receives
`contents: read`, `packages: read`, and `statuses: write`.

## Deploy Docs workflow steps

The Deploy Docs workflow builds this book with mdBook and publishes it to
GitHub Pages. It runs in the concurrency group `pages` and does not cancel a
run in progress. It holds `contents: read`, `pages: write`, and
`id-token: write`.

| Job | Container | Steps |
| --- | --- | --- |
| `build` | `jeonghanlee/mdbook` | Checks out the repository, prints `mdbook --version`, runs `mdbook build docs`, fails when `git status` reports a change under `docs/src` after the build, sets up Pages with `actions/configure-pages`, and uploads `docs/book` as the Pages artifact |
| `deploy` | None | Runs after `build` and deploys the artifact to the `github-pages` environment |
