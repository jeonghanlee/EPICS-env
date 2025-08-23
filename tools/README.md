# Tools

This folder `tools` contains a suite of Bash scripts for interacting with this repository EPICS Environment (Experimental Physics and Industrial Control System) and analyzing software distributions. These tools are designed to streamline common development and maintenance tasks.

## `pvs_gets.bash`

This script is a versatile utility for interacting with EPICS Channel Access (CA) Process Variables (PVs). It provides a user-friendly way to fetch values from a list of PVs, with options for filtering, continuous monitoring, and managing network settings. It's particularly useful for EPICS developers, operators, and engineers who need to quickly inspect PV values.

### Usage

To run the script, you must provide a PV list file using the -l option.

```bash
bash pvs_gets.bash [-l pvlist_file] [-w watch_interval_sec] [-f <filter_string>] [-r <record_field>] [-c] [-n] [-7]
```

### Options:

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

This example gets the EGU (Engineering Units) field for all PVs in pvlist_file.txt that contain "Ti" followed by a number from 1 to 8. It also resets the EPICS CA address.
```bash
bash pvs_gets.bash -l pvlist_file.txt -f "Ti[1-8]$" -c -r "EGU"
```

3. Continuously watch PVs with a 5-second interval:

```bash
bash pvs_gets.bash -l pvlist_file.txt -w 5
```


## `check_deps.bash`

This script analyzes the dynamic library dependencies of executable and shared object files. It identifies required libraries (`NEEDED`) and the runtime search paths (`RUNPATH/RPATH`) embedded in the files' headers. The script is particularly useful for verifying the portability and integrity of a software distribution by highlighting potential issues like hardcoded paths.

### Usage

To run the script, provide the path to the software distribution as the first command-line argument.

```bash
bash check_deps.sh <path-to-distribution>
```

* Example:
If your software distribution is located at 1.1.2/debian-12/7.0.7, run the script as follows:

```bash
bash check_deps.sh ../1.1.2/debian-12/7.0.7
```

### Features:
* **Dependency Listing:** Lists all executables and shared libraries (`.so`) required by each binary executable and shared library file.
* **Path Analysis:** Identifies and displays the `RUNPATH` and `RPATH` values, which are used by the dynamic linker to find dependencies at runtime.
* **RPATH Warning:** Provides a clear, colored warning if `RPATH` is detected in a file. `RPATH` is generally considered a less flexible and potentially insecure alternative to `RUNPATH`, as it can lead to issues when the software is moved to a different location.
* **Automated Scanning:** The script automatically scans a predefined directory structure (`base`, `modules`, and `vendor`) to find both binary executables and shared library files.
