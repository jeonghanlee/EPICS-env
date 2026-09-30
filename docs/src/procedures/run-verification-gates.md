# Run the verification gates

Run the three verification gates to confirm that the module dependencies match
the sources, that the installed libraries find each other, and that the
installed environment script adds no `LD_LIBRARY_PATH` entry under
`pvxs/bundle`.

## Prerequisites

- An EPICS-env clone configured with `make init`, `make patch`, and
  `make conf` for the module dependency gate.
- An installed tree built with `make install` and `make symlinks` for the
  runpath and environment gates; see
  [Build and install the environment](build-and-install.md).
- `readelf` on `PATH` for the runpath gate.

1. To compare each module's declared dependencies with the dependencies found
   in its sources, run the module dependency gate from the repository top:

   ```bash
   make check.module-deps
   ```

   The report prints one block per module. For each module, `Declared` lists
   the build targets it waits for, `Observed` lists the dependencies found in
   its `RELEASE.local`, makefiles, databases, and sources, and `Findings`
   lists the differences. An `undeclared-observed` or `unknown` finding makes
   the gate fail with exit status 2. A `declared-unobserved` finding is
   reported and does not fail the gate. Run this gate after `make conf` and
   before `make build`, the place it takes in `make github.check`.

2. Optional: to audit one module, add `MODULE`:

   ```bash
   make check.module-deps MODULE=asyn
   ```

   On a configured clone before `make build`, the output is:

   ```
   Module Dependency Audit
   Strict: YES
   Source state: generated RELEASE.local files are used when present.
   Platform: Linux
   Strict policy: undeclared-observed and unknown findings fail.

   Module: asyn
   Declared: null.base build.sequencer build.sscan build.calc
   Observed:
     required sequencer        asyn-src/configure/RELEASE.local:1 SNCSEQ
     required sscan            asyn-src/configure/RELEASE.local:2 SSCAN
     required calc             asyn-src/configure/RELEASE.local:3 CALC
     optional sequencer        asyn-src/testIPServerApp/src/Makefile:20 seq
     optional sequencer        asyn-src/testIPServerApp/src/Makefile:20 pv
     optional sequencer        asyn-src/testIPServerApp/src/Makefile:31 seq
     optional sequencer        asyn-src/testIPServerApp/src/Makefile:31 pv
     optional calc             asyn-src/testEpicsApp/src/Makefile:24 calc
     optional sscan            asyn-src/testEpicsApp/src/Makefile:27 sscan
     optional sequencer        asyn-src/testEpicsApp/src/Makefile:30 seq
     optional sequencer        asyn-src/testEpicsApp/src/Makefile:30 pv
     optional calc             asyn-src/testEpicsApp/src/Makefile:44 calc
     optional sscan            asyn-src/testEpicsApp/src/Makefile:48 sscan
     optional sequencer        asyn-src/testEpicsApp/src/Makefile:51 seq
     optional sequencer        asyn-src/testEpicsApp/src/Makefile:51 pv
     optional iocStats         asyn-src/testApp/src/Makefile:15 test.dbd
     optional sequencer        asyn-src/makeSupport/app/_NAME_App/src/Makefile:31 seq
     optional sequencer        asyn-src/makeSupport/app/_NAME_App/src/Makefile:31 pv
     optional calc             asyn-src/asyn/Makefile:193 calc
     external ftdi1            asyn-src/asyn/Makefile:268 ftdi1
     external ftdi1            asyn-src/asyn/Makefile:270 ftdi1
     external ftdi             asyn-src/asyn/Makefile:275 ftdi
     external ftdi             asyn-src/asyn/Makefile:277 ftdi
     optional calc             asyn-src/testEpicsApp/Db/devOctetCalc.db:6 scalcout
   Findings:
     none
   ```

   The `Observed` lines follow the order in which the file system lists the
   files, so their order can differ. The audit also reads files that the
   build generates, so a built clone can list different `Observed` lines.
   `make audit.module-deps` prints the same report and exits 0 whatever it
   finds.

3. To scan the installed executables and shared libraries for runpath
   defects, run the runpath gate:

   ```bash
   make check.deps
   ```

   The scan ends with a summary of counts. For the verified Debian 13
   installed tree, the summary is:

   ```
   --------------------------------------------------------
    >> BIN: Total Files with   RPATH / ALL:   0 /  85
    >>  SO: Total Files with   RPATH / ALL:   0 /  69
    >> BIN: Total Files with ABSPATH / ALL:   0 /  85
    >>  SO: Total Files with ABSPATH / ALL:   0 /  69
    >>  SO: Total Files with LOSTORG / ALL:   0 /  69
   --------------------------------------------------------
   ```

   The block shows the text of the summary. The tool wraps each defect count
   in terminal color codes, which a terminal shows as color and a file or pipe
   keeps as escape sequences.

   Each canonical executable is counted once, including executables reached
   through both versioned module directories and unversioned links. File
   counts depend on the installed module set. An empty tree path or a path
   that is not a directory exits 2 and directs the caller to set
   `INSTALL_LOCATION_EPICS` or pass a valid `<installed_tree>`.

   The gate reads the dynamic section of the executables in
   `bin/linux-x86_64` and the shared libraries in `lib/linux-x86_64` of base
   and every module, and of the shared libraries in `vendor/lib`. Each row
   counts one defect:

   - `RPATH`: the file carries a run-time search path (`RPATH`), which the
     loader searches before `LD_LIBRARY_PATH`, instead of a run-time library
     search path (`RUNPATH`).
   - `ABSPATH`: the search path holds an absolute directory.
   - `LOSTORG`: the shared library needs a library of the installed tree, and
     its search path lacks `$ORIGIN`, the loader token for the directory of
     the file itself.

   Any nonzero count makes the gate exit with status 2. A `NOTE` line above
   the summary marks a search path that holds a standard system directory such
   as `/usr/lib`; it does not count. `make audit.deps` prints the same scan and
   exits 0.

   An existing tree directory can still contain no files in the scan locations.
   Check that the `ALL` counts match the components you installed; a zero-defect
   result alone does not prove a complete installation.

4. To check the library paths that the installed `setEpicsEnv.bash` adds, run
   the environment gate:

   ```bash
   make check.env
   ```

   The output is:

   ```
   Inspecting <installed_tree>/setEpicsEnv.bash
     EPICS_MODULES    <installed_tree>/modules
     EPICS_HOST_ARCH  linux-x86_64

   OK: no pvxs/bundle path in LD_LIBRARY_PATH

   findings: 0
   ```

   `<installed_tree>` is the path that `make print-INSTALL_LOCATION_EPICS`
   prints. The gate sources the script in a clean child shell and reports each
   `LD_LIBRARY_PATH` entry that points at a `pvxs/bundle` directory, which the
   build never creates. The tool exits with status 2 on a finding and with
   status 3 when it cannot inspect the tree, such as before `make install`;
   `make` then reports `Error 2` or `Error 3` and exits with status 2.
   `make audit.env` prints the same report, exits 0 on a finding, and skips
   the check when the tree is absent.

## Verification

- Run all three gates and print the exit status:

  ```bash
  make check.module-deps check.deps check.env > /dev/null 2>&1; echo $?
  ```

  The output is:

  ```
  0
  ```

  `make` stops at the first gate that fails, so `0` means that all three
  passed.

[Make targets by purpose](../reference/make-targets.md#verification-and-inspection-targets)
lists every verification target, and
[Variables set on the command line](../reference/configuration-variables.md#variables-set-on-the-command-line)
lists `MODULE`, `FORMAT`, and `PLATFORM`.
