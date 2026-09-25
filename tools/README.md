# Tools

This folder `tools` contains a suite of Bash scripts, and one C++ device query, for interacting with this repository EPICS Environment (Experimental Physics and Industrial Control System) and analyzing software distributions. These tools are designed to streamline common development and maintenance tasks.

## `pvs_gets.bash`

This script is a versatile utility for interacting with EPICS Channel Access (CA) Process Variables (PVs). It provides a user-friendly way to fetch values from a list of PVs, with options for filtering, continuous monitoring, and managing network settings. It's particularly useful for EPICS developers, operators, and engineers who need to quickly inspect PV values.

### Usage

To run the script, you must provide a PV list file using the `-l` option.

```bash
bash pvs_gets.bash [-l pvlist_file] [-w watch_interval_sec] [-f <filter_string>] [-r <record_field>] [-c] [-n] [-7]
```
* **-l <pvlist_file>:** **(Required)** Specifies a file containing a list of Process Variables, one per line. Blank lines and lines starting with # are ignored.
* **-w <watch_interval_sec>:** Puts the script into a "watch" mode, continuously fetching and displaying the PV values at the specified interval in seconds.
* **-f <filter_string>:** Filters the PV list using a regular expression. Only PVs matching the pattern will be processed.
* **-r <record_field>:** Appends a specific record field to each PV (e.g., `PV.EGU`).
* **-c:** Clears any existing `EPICS_CA_ADDR_LIST` and sets it to the host machine's IP address. This can be useful for resolving connectivity issues.
* **-n:** Disables the use of `EPICS_CA_AUTO_ADDR_LIST`.
* **-7:** Uses the `pvget` command instead of the default `caget` command.

### Examples

1. Get values from a simple PV list file:
```bash
bash pvs_gets.bash -l pvlist_file.txt
```
2. Filter PVs and get a specific record field:

This example gets the EGU (Engineering Units) field for all PVs in `pvlist_file.txt` that contain "Ti" followed by a number from 1 to 8. It also resets the EPICS CA address.
```bash
bash pvs_gets.bash -l pvlist_file.txt -f "Ti[1-8]$" -c -r "EGU"
```

3. Continuously watch PVs with a 5-second interval:

```bash
bash pvs_gets.bash -l pvlist_file.txt -w 5
```

## `check_deps.bash`

This script analyzes the dynamic library dependencies of executable and shared object files. It identifies required libraries (`NEEDED`) and the runtime search paths (`RUNPATH/RPATH`) embedded in the files' headers. The script is particularly useful for verifying the portability and integrity of a software distribution by highlighting potential issues like hardcoded paths especially on Redhat variant OS.

### Usage

To run the script, provide the path to the software distribution as the first command-line argument. By default the script **gates**: it exits `2` when any file carries a `DT_RPATH`, an absolute runpath, or (for a shared object) a runpath that has lost its `$ORIGIN` while still needing a tree-local library. Pass `--report-only` to keep the historical behavior - print the report and exit `0`.

```bash
## Default EPICS-env path (gates; exit 2 on a finding)
bash check_deps.bash
## Specific path
bash check_deps.bash <path-to-distribution>
bash check_deps.bash -v <path-to-distribution>
bash check_deps.bash --verbose <path-to-distribution>
## Report only, never fail (historical behavior)
bash check_deps.bash --report-only <path-to-distribution>
```

* Example:
If your installed environment is at `~/epics/1.3.0/debian-13/7.0.10`, run the script as follows (the totals below are illustrative and vary by tree):

```bash
bash tools/check_deps.bash ~/epics/1.3.0/debian-13/7.0.10/
--------------------------------------------------------
 >> BIN: Total Files with   RPATH / ALL:   0 / 156
 >>  SO: Total Files with   RPATH / ALL:   0 /  62
 >> BIN: Total Files with ABSPATH / ALL:   0 / 156
 >>  SO: Total Files with ABSPATH / ALL:   0 /  62
 >>  SO: Total Files with LOSTORG / ALL:   0 /  62
--------------------------------------------------------
```

### Features:
* **Dependency Listing:** Lists all executables and shared libraries (`.so`) required by each binary executable and shared library file.
* **Path Analysis:** Identifies and displays the `RUNPATH` and `RPATH` values, which are used by the dynamic linker to find dependencies at runtime.
* **RPATH Warning:** Provides a clear, colored warning if `RPATH` is detected in a file. `RPATH` is generally considered a less flexible and potentially insecure alternative to `RUNPATH`, as it can lead to issues when the software is moved to a different location.
* **Automated Scanning:** The script automatically scans a predefined directory structure (`base`, `modules`, and `vendor`) to find both binary executables and shared library files.
* **Strict Gate (default):** Exits `2` when any `DT_RPATH`, absolute runpath, or lost-`$ORIGIN` shared object is found, so CI fails on a regression. A self-contained prebuilt blob whose `NEEDED` entries are all system libraries is exempt. Use `--report-only` to print without failing.

## `prep-vendors.bash`

While `prep-vendors.bash` is capable of orchestrating the full EPICS environment build, its **most critical role is to automate the complex and error-prone process of vendor library setup and integration**. The script's modular commands also offer flexibility: for tasks like new release preparation or standalone testing, developers can choose to focus only on specific steps, such as building the core EPICS environment (`EPICS-env`), rather than rebuilding all vendor libraries.

Using this script, you can easily handle the downloading, configuration, compilation, and installation of external dependencies (`uldaq`, `open62541`) into a consistent path. This frees developers to focus on coding by providing a reliably configured environment.

### Key Automation Features

* **`init`**: **Initial Environment Setup** Creates the necessary temporary working folders and clones the vendor repositories (`uldaq-env` and `open62541-env`) in a single step.
* **`prep-uldaq`**, **`prep-open62541`**: **Vendor Library Preparation** Navigates to the vendor library source, sets the installation path, and sequentially executes `make` rules to complete the library installation.
* **`prep-vendors`**: **Batch Vendor Preparation** Executes both `prep-uldaq` and `prep-open62541` sequentially.
* **`epics-env`**: **EPICS Integration** Automatically detects the installation paths of the vendor libraries and accurately reflects them in the main EPICS environment's `configure/RELEASE.local` file before building.

### Recommended Workflow

The workflow, when focused on vendor library configuration automation, is as follows:

1.  **Initial Setup and Source Acquisition:**
    ```bash
    bash prep-vendors.bash init
    ```
2.  **Automated Vendor Library Compilation and Installation:**
    ```bash
    bash prep-vendors.bash prep-vendors
    ```
3.  **Verify Environment Paths:**
    ```bash
    bash prep-vendors.bash show-env
    ```
4.  **Compile the EPICS Environment (Optional):**
    ```bash
    bash prep-vendors.bash epics-env
    ```


## `update-release.bash`

This script automates the maintenance of the EPICS `configure/RELEASE` file by keeping module versions synchronized with their upstream Git repositories. It parses the existing release file, queries remote repositories for the latest tags or commit hashes, and generates a detailed summary of changes. This tool is designed to prevent version drift and simplify the tedious process of manual version tracking.

### Usage

To run the script, execute it with one of the available commands. You can optionally use the `-v` flag for more detailed output.

```bash
bash tools/update-release.bash [-v|--verbose] <command>
```

* **-v, --verbose:** Enables detailed information fetching via the GitHub API (Commit Date, Author, Message). Without this flag, the script runs in a faster "stats-only" mode, showing only version differences and diff links.
* **check:** Performs a "dry-run" analysis. It compares local versions against remote HEADs and displays pending updates and GitHub comparison links without modifying any files.
* **update:** Performs the same analysis as `check`, but enters an **interactive mode** when updates are detected. Users can choose to apply the update, keep the old version, or manually enter a specific tag/hash. A backup (`RELEASE.bak`) is automatically created before overwriting.
* **help:** Displays usage information.

### Examples

1. Check for available updates (Fast Mode):

This command prints a summary of differences and diff links but skips detailed commit metadata for speed.
```bash
bash tools/update-release.bash check
```

2. Check for updates with details (Verbose Mode):

This includes commit date, author, and message (requires GitHub API access and is slower due to network requests).
```bash
bash tools/update-release.bash -v check
>>> GITHUB_TOKEN not found. Running in limited mode (60 requests/hr).

--- Processing RELEASE file: .../configure/RELEASE ---
 Checking BASE ... UPDATE DETECTED
    >> Diff Link: [https://github.com/epics-base/epics-base/compare/4b6a6dd...7d6ef32](https://github.com/epics-base/epics-base/compare/4b6a6dd...7d6ef32)
    >> Info     : Date: 2025-08-19 -> 2025-12-13 | Author: Edmund Blomley
    >> Message  : "Docs: Mention that pva is supported for JSON links"
    >> Stats    : 4 commits ahead.
 Checking RETOOLS ... OK (Matches 5ada1e1)
```

3. Update the release file interactively:

```bash
bash tools/update-release.bash update
```

### GitHub Token (Recommended)

To avoid GitHub API rate limits (60 req/hr for unauthenticated calls) and to see detailed commit statistics (Date, Author, etc.) when using verbose mode, setting a `GITHUB_TOKEN` is recommended. The script supports both **Classic** and **Fine-grained** tokens.

* [Create a GitHub Token](https://github.com/settings/tokens)

```bash
# 1. Set your token (Temporary environment variable)
export GITHUB_TOKEN="github_pat_xxxxxxxxxxxx"

# 2. Run the script with verbose mode
bash tools/update-release.bash -v check
```

### Features

* **Smart Version Detection:**
    * Intelligently determines whether to use a readable Git Tag (e.g., `tags/R1.2`) or a Short Hash (e.g., `a1b2c3d`) based on the remote repository's state.
    * **Git Hash Preservation:** If a version is explicitly set to a full Git Hash (7-40 hex characters), the script respects it and does not attempt to sanitize it.
* **Automatic Version Sanitization:**
    * Automatically converts Git tags into semantic version strings for `SRC_VER` variables.
    * Removes prefixes like `tags/`, `v`, `R`, or module names (e.g., `ether_ip-`).
    * Converts separators (`-`, `_`) to dots (`.`).
    * Ensures strict Semantic Versioning by appending `.0` to `Major.Minor` versions (e.g., `R4-45` becomes `4.45.0`).
* **Interactive Update Selection:**
    * When an update is found, the user is presented with a menu to:
        1.  Keep the old version.
        2.  Apply the latest remote version.
        3.  Manually enter a specific tag or hash.
        4.  Exit the process.
* **Visual Diff Links:** Generates direct GitHub "Compare" URLs for every update, allowing maintainers to instantly review code changes between the old and new versions.

## `audit_module_deps.bash`

This script audits the declared module build dependencies against the evidence in the module source trees. It backs the `make audit.module-deps` and `make check.module-deps` targets: the audit reports declared-versus-observed dependencies, and the strict mode fails when a required, observed dependency is not declared. See [Module Dependency Audit](../docs/src/usage/module-dependency-audit.md) in the book for the model.

### Usage

```bash
bash tools/audit_module_deps.bash [--top <repo>] [--module <name>] [--format text|json] [--strict] [--platform <name>]
```

* **--top <repo>:** Repository root to audit (defaults to the current tree).
* **--module <name>:** Restrict the audit to one module key.
* **--format text|json:** Report format; `text` is the default.
* **--strict:** Exit non-zero when a required, observed dependency is undeclared. This is the mode `make check.module-deps` uses.
* **--platform <name>:** Platform name used when resolving platform-specific evidence.

Prefer the make targets (`make audit.module-deps`, `make check.module-deps`) over calling the script directly; they pass `--top` and the configured maps for you.

## `check_env.bash`

This script inspects an installed environment for runtime library-path problems. Its declared scope is `LD_LIBRARY_PATH` only; it does not inspect `PATH`. It backs the `make check.env` and `make audit.env` targets.

### Usage

```bash
bash tools/check_env.bash --epics <install-root> [--strict] [--require-run]
```

* **--epics <path>:** **(Required)** Directory holding the installed `setEpicsEnv.bash`.
* **--strict:** Exit non-zero when a finding is reported.
* **--require-run:** Exit non-zero when the check cannot inspect an installed environment.

## `gen_dep_graph.bash`

This script renders the module dependency declarations as a graph image. It reads `configure/CONFIG_MODS_DEPS` and produces a PNG using Graphviz.

### Usage

```bash
bash tools/gen_dep_graph.bash [-f <config-file>] [-o <output-file>]
```

* **-f, --file <file>:** Dependency config file (default `configure/CONFIG_MODS_DEPS`).
* **-o, --output <file>:** Output image filename (default `epics_deps.png`).

Requires Graphviz (the `dot` command) installed on the system.

## `verify_fix_build.bash`

Runs steps 2-3 of `docs/procedures/upstream-fix-verification-procedure.md`.
It builds a fixed module and a consumer IOC copy, both already placed in a
scratch directory, against the production tree. It then checks that both link
only into that tree, that the IOC links the module from the scratch
directory, and that nothing under the tree was written. Running the IOC copy
and comparing values stay manual.

### Usage

```bash
source <tree>/setEpicsEnv.bash
tools/verify_fix_build.bash <module-dir> <ioc-dir>
```

* The production tree is `EPICS_BASE` without `/base`.
* `<module-dir>` holds the module source with the fix and the environment
  patches applied; its directory name is the installed module name in
  `<tree>/modules/`.
* `<ioc-dir>` holds the consumer IOC source; its directory name is the IOC
  binary name.
* The module's dependencies come from the installed module,
  `<tree>/modules/<module>/configure/RELEASE.local`, so the build uses the
  same dependency versions as production. A module installed without that
  file depends on base only.
* The module's own configuration (vendor paths and switches) comes from
  `make conf.<module>.show` in the EPICS-env checkout that holds the script,
  with paths rewritten to the tree and every vendor path pointed at
  `<tree>/vendor`. Run `make <MODULE>` and
  `make conf.release.modules conf.<module>` there first.
* `<MODULE>` is the module's key in the checkout's `configure/MODULESGEN.mk`
  (`INSTALL_LOCATION_<MODULE>`), which the script reads. The configuration
  target is `conf.<module>`, or `conf.<MODULE in lower case>` when no
  `conf.<module>` exists.
* The IOC gets `EPICS_BASE`, `<MODULE>`, and
  every vendor variable of the module's `cfg/CONFIG_*` set to `<tree>/vendor`,
  in its `configure/RELEASE.local` and `configure/CONFIG_SITE.local`, which
  each run rewrites. The copy's `configure/RELEASE` must name the module by
  `<MODULE>`; if it uses another variable, edit that file in the copy.

Checks, each against the production tree:

* The dependencies the EPICS-env checkout generates must match the installed
  module's. On a difference the script shows it and asks the operator to
  confirm on the terminal; without a terminal it stops.
* Every shared library the production module installs must be rebuilt and
  must resolve its own shared libraries (`ldd`, paths normalized) to the same
  files as the production copy.
* Runpaths name only the tree, `$ORIGIN`, and, for the IOC, the scratch
  module. The IOC links at least one module library, each from
  `<module-dir>`. Nothing under the tree was written.

Exit status: 0 on success, 1 on a failed build or check or an unconfirmed
difference, 2 on a usage error. Build logs are written next to `<module-dir>`.

## `pv_snapshot.bash`

Captures EPICS PV values into a snapshot file and compares two snapshots, for
step 5 of `docs/procedures/upstream-fix-verification-procedure.md`: the
values before the test IOC runs, while it runs, and after production is
restored.

### Usage

```bash
tools/pv_snapshot.bash capture -l <pvlist> -o <snapshot> [-w <seconds>]
tools/pv_snapshot.bash compare [-t <tolerance>] <before> <after>
```

`<pvlist>` holds one PV name per line; blank lines and `#` comments are
ignored. `capture` reads the list with `caget` and writes one
`<pv><TAB><value>` line per PV after a `#` line with the capture time; a PV
that does not connect is written as `__DISCONNECTED__`. `compare` prints
each PV of `<before>` as `SAME`, `WITHIN` (numeric difference not above
`<tolerance>`, default 0), `DIFF`, `MISSING` (absent from `<after>`), or
`DISCONN`, then a summary with the largest numeric difference.

Exit status: 0 when every PV is `SAME` or `WITHIN`, 1 otherwise, 2 on a usage
or runtime error.

## `tc32-expansion-query.cpp`

This C++ program reports whether a measComp TC-32 or E-TC32 has the EXP-32
expansion attached, reading `DEV_CFG_HAS_EXP` through the installed uldaq
library. It selects the device with the same `uniqueID` rules as the measComp
driver, so the flag comes from the unit the IOC drives. Build it on the
production OS against the tree's `vendor/`, so it links the same uldaq as the
IOC.

### Usage

```bash
g++ -std=c++11 -Wall -Wextra -O2 -I<tree>/vendor/include -o tc32-expansion-query tools/tc32-expansion-query.cpp -L<tree>/vendor/lib -luldaq
LD_LIBRARY_PATH=<tree>/vendor/lib ./tc32-expansion-query <uniqueID>
```

* **<tree>:** Installed tree of the production OS that holds `vendor/`, e.g. `<install-root>/<version>/<os>/<base-version>`.
* **<uniqueID>:** The value the IOC passes to `MultiFunctionConfig`: a USB serial number, an Ethernet MAC address, or an IP address or DNS name with an optional `:port`.

Prints `key=value` lines and `has_exp` only when exactly one device matches
and every uldaq call succeeds. Exit status: 0 success, 2 usage error, 3 no
device or more than one device matches, 4 a uldaq call failed. Run it while
the IOC that owns the device is stopped.
