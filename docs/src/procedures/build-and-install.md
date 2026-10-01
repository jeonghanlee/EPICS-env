# Build and install the environment

Build the vendor libraries, then run the EPICS-env target sequence to clone,
patch, configure, build, and install Experimental Physics and Industrial
Control System (EPICS) base and every module into the installed tree.

## Prerequisites

- The install location is set; see
  [Choose the install location and release](choose-install-location.md).
- The host packages that EPICS base and the modules need are installed. The
  continuous integration (CI) workflows install them with
  <https://github.com/jeonghanlee/pkg_automation>; see
  [Supported platforms and CI](../reference/supported-platforms-and-ci.md).
- `python3` is on `PATH`; `make` stops while reading its configuration when it
  is missing.
- The host can clone from GitHub.
- Every command runs from the top of the EPICS-env clone, in one shell, so the
  `VENDOR_PATH` variable of step 1 stays set.

When the uldaq and open62541 libraries are installed under `/usr/local`, the
default of `VENDOR_ULDAQ_PATH` and `OPEN62541_PATH`, skip steps 1 through 4.

1. To place the vendor libraries inside the installed tree, set a shell
   variable to its `vendor` directory:

   ```bash
   VENDOR_PATH="$(make print-INSTALL_LOCATION_EPICS)/vendor"
   ```

2. In `configure/RELEASE.local`, point the `measComp` and `opcua` modules at
   that directory:

   ```bash
   echo "VENDOR_ULDAQ_PATH=${VENDOR_PATH}" > configure/RELEASE.local
   echo 'OPEN62541_PATH=\$$\$$\(\_OPEN62541_CONFIG_OPCUA\)/../../../vendor' >> configure/RELEASE.local
   ```

   `conf.measComp` writes `VENDOR_ULDAQ_PATH` into the `measComp`
   configuration as the uldaq library and header directories. The escaped
   `OPEN62541_PATH` value reaches the installed `opcua` configuration file
   `cfg/CONFIG_OPCUA` as `$(_OPEN62541_CONFIG_OPCUA)/../../../vendor`, a path
   relative to that file's own directory, so it keeps pointing at the `vendor`
   directory of the same installed tree.

3. Build the uldaq library into the `vendor` directory:

   ```bash
   git clone https://github.com/jeonghanlee/uldaq-env ../uldaq-env
   echo "INSTALL_LOCATION=${VENDOR_PATH}" > ../uldaq-env/configure/CONFIG_SITE.local
   make -C ../uldaq-env init conf build install
   ```

4. Build the open62541 library into the `vendor` directory:

   ```bash
   git clone https://github.com/jeonghanlee/open62541-env ../open62541-env
   echo "INSTALL_LOCATION=${VENDOR_PATH}" > ../open62541-env/configure/CONFIG_SITE.local
   make -C ../open62541-env init conf build install
   ```

   Both libraries are in the `vendor` directory:

   ```bash
   ls "${VENDOR_PATH}/lib"
   ```

   The output lists the libraries of both packages:

   ```
   cmake
   libopen62541.so
   libopen62541.so.1
   libopen62541.so.1.3.15
   libuldaq.a
   libuldaq.la
   libuldaq.so
   libuldaq.so.1
   libuldaq.so.1.2.1
   pkgconfig
   ```

5. Clone EPICS base and every module at its pinned tag or commit:

   ```bash
   make init
   ```

   Each source tree lands in a `<name>-src` directory at the repository top.
   [Module pins and dependencies](../reference/module-pins.md) lists the pins.

6. Apply the carried upstream patches:

   ```bash
   make patch
   ```

   The output prints one `Patching` line per patch file.

7. Write the site configuration of base and every module:

   ```bash
   make conf
   ```

   The output is one empty line.

8. Build base and every module:

   ```bash
   make build
   ```

   Base installs into the installed tree as it builds, and each module
   installs after its build completes.

9. Complete the install of base and the modules, and add the `commonIocsh`
   fragments, `setEpicsEnv.bash`, `resetEpicsEnv.bash`, and the `.versions` file:

   ```bash
   make install
   ```

10. Create the unversioned module links, such as `asyn` for `asyn-4.46.0`:

    ```bash
    make symlinks
    ```

    `setEpicsEnv.bash` finds the `pvxs` and `pmac` tools through these links.

The Debian 12, Debian 13, and Rocky 8 CI workflows run `make github.check`
and then `make install`. `github.check` runs steps 5 through 8, step 10, and
the `vars` listing, with the module dependency gate between `make conf` and
`make build`.

## Verification

1. List the top level of the installed tree:

   ```bash
   LC_ALL=C make exist LEVEL=1
   ```

   With the vendor libraries of steps 1 through 4, the tree holds base, the
   modules, the vendor libraries, both environment scripts, and the version
   file:

   ```
   <install_location>/1.4.0/debian-13/7.0.10
   |-- .versions
   |-- base
   |-- modules
   |-- resetEpicsEnv.bash
   |-- setEpicsEnv.bash
   `-- vendor

   4 directories, 3 files
   ```

   `<install_location>` is the value of `INSTALL_LOCATION`. When you skip steps
   1 through 4 because the vendor libraries are under `/usr/local`, the tree
   has no `vendor` directory, and the listing has no `vendor` line.

   This listing shows a first install. Replacing existing setup or reset
   scripts also leaves backup files, which add entries to the listing.

   `LC_ALL=C` makes `tree` draw its lines with American Standard Code for
   Information Interchange (ASCII) characters. `make exist` uses `tree` when
   it is installed and `find` otherwise, so the drawing differs on a host
   without `tree`.

2. Run the runpath and environment gates:

   ```bash
   make check.deps check.env > /dev/null 2>&1; echo $?
   ```

   The output is:

   ```
   0
   ```

   [Run the verification gates](run-verification-gates.md) explains each gate
   and its report.
