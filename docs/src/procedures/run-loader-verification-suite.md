# Run the loader verification suite

Check the `iocsh.bash` loader of an installed tree against real input/output
controllers (IOCs). The suite is the set of scripts under
`examples/iocsh/tests`. It runs the loader through the show mode and in real
starts, injects faults into a copy of the tree, and starts the three example
fixtures against their simulators or demo server. The scripts build nothing
for the loader itself; they need an installed tree, which this procedure takes
from a candidate installation.
[Set up a shell with the environment](set-up-shell.md) describes the loader
that the suite checks, and the
[`README.md` of the suite](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/tests/README.md)
lists every script, the expected counts, and the refusal cases.

## Prerequisites

- A candidate installation on the selected
  [supported operating system](../reference/supported-platforms-and-ci.md),
  built in a clone of EPICS-env that only the suite uses, with a default route
  on the host. The
  suite modifies the tree and its source: it installs second versions of
  linStat and asyn, uninstalls and rebuilds linStat, reverts and applies the
  Base patches again, changes the default link of linStat, edits
  `configure/CONFIG_MODS_IOCSH` and the `measComp` configuration to provoke
  generator rejections and rebuilds StreamDevice, pmac, and measComp, renames
  the installed tree and the clone for the duration of one IOC start, and
  replaces source trees and truncates the installed `libasyn.so` for a while.
  Each script restores what it changed when it ends. After an interrupted run,
  check those places before you trust the tree. Do not run it on a tree in
  use. The scripts name the architecture `linux-x86_64`, so the host is an
  x86_64 host.
- The tools `bash`, `gawk`, `perl`, `git`, `patch`, `readelf`, `ldd`, `ss`,
  `ip`, `pgrep`, `ps`, `stat`, `timeout`, `expect`, `strace`, `setsid`,
  `mkfifo`, `truncate`, and `sha256sum`, `make` and the compilers of the build
  prerequisites, `socat` for the tc32sim simulator, `socat` or `tcpsvd` for the
  EPICS-IOC-Demo simulator, and `docker` or `podman`. `gawk` is needed because
  the scripts use `strtonum`, which `mawk` lacks.
- The EPICS client tools of the installed tree, `caget`, `caput`, `pvget`,
  `pvxget`, `pvxmonitor`, and `camonitor`, which the environment script puts on
  `PATH`; the scripts source that environment script themselves.
- For `verify_docs_and_tools.bash` only: ShellCheck. With it the script has
  six checks; without it the script has five.
- Network access to GitHub, for the application checkouts of the fixtures and
  for the sources of the second versions of linStat and asyn, and to
  `docker.io`, for the image `docker.io/digitalpetri/opc-ua-demo-server` that
  the opcua fixture runs as the Eclipse Milo demo server.
- A successful demo-server image pull as the test user. After changing Docker group
  membership, open a fresh SSH connection with
  `ssh -S none -o ControlMaster=no <guest>`, run `docker info`, and pull the
  demo-server image. For Podman, use its corresponding commands. Record its digest.
- These Transmission Control Protocol (TCP) and User Datagram Protocol (UDP)
  ports free on the local host: 55064, 55065, 55075, and 55076 for Channel
  Access (CA) and pvAccess (PVA) on the loopback interface, 9400 for the
  tc32sim simulator, 9399 for the EPICS-IOC-Demo simulator, 4840 for the demo
  server, and 7004 for the log server of the caPutLog fragment.

## Steps

1. Build the candidate installation with an install location of its own:
   follow [Choose the install location and release](choose-install-location.md)
   to set `INSTALL_LOCATION` in the clone, then
   [Build and install the environment](build-and-install.md) through
   `make symlinks`, including its steps 1 through 4 for the vendor libraries,
   which the opcua fixture checks. On Rocky Linux the vendor builds use the
   configuration target `conf.rocky8` in place of `conf`, as in
   `make -C ../uldaq-env init conf.rocky8 build install`; the same holds for
   `open62541-env`, and [Supported platforms and CI](../reference/supported-platforms-and-ci.md)
   lists the target and the extra packages of each operating system. The
   workflow of the operating system that you run, such as
   `.github/workflows/debian13.yml` or `rocky8.yml`, runs the same sequence
   through `make github.check` and `make install`. Print the tree that the
   build installed:

   ```bash
   readlink -f "$(make -s print-INSTALL_LOCATION_EPICS)"
   ```

   The printed directory is the installed tree for one host, such as
   `<install_location>/<release>/debian-13/7.0.10`, where `<release>` is the
   EPICS-env release number, for example `1.5.0`. This procedure calls it
   `<installed_tree>`.

   For a release with site modules, complete
   [Add the site modules to an installed tree](add-site-modules.md), including
   its verification, before continuing. Both checkouts must resolve
   `INSTALL_LOCATION_EPICS` to this same canonical path. Use the selected
   site revision and record the module-entry count after site installation.
   The full suite checks this combined tree after installation is complete.

2. Select the release source, the tools checkout, and an unused log directory:

   ```bash
   mkdir -p "<log_dir>"
   LOGS="$(readlink -f "<log_dir>")"
   TOOLS="$(readlink -f "<tools_checkout>")"
   export IOCSH_TEST_TREE="$(readlink -f "<installed_tree>")"
   export IOCSH_TEST_REPO="$(readlink -f "<repo>")"
   export IOCSH_TEST_OUT="$LOGS/loader"
   mkdir -p "$IOCSH_TEST_OUT" "$LOGS/tmp"
   export TMPDIR="$LOGS/tmp"
   LOADER="$TOOLS/examples/iocsh/tests/run_all.bash"
   df -h "$LOGS" "$TMPDIR"
   unset IOCSH_TEST_SITE_REPO
   ```

   `<repo>` is the release clone of step 1. `<tools_checkout>` is the complete
   EPICS-env checkout at the recorded verification-suite revision. The runner
   and its sibling scripts come from this checkout; fixtures and build
   configuration come from `<repo>`. These checkouts can be the same when
   their selected revisions match. Use the resolved paths, not symbolic-link
   spellings, because verification compares them with resolved library paths.
   Stop if any resolved value is empty or names the wrong directory.
   Require at least 6 GiB free on the log volume before running the suite.
   Keep `TMPDIR` exported in every test shell so temporary copies use that
   volume too; the default `/tmp` may be a small tmpfs.
   When the site modules are installed, also select their checkout:

   ```bash
   export IOCSH_TEST_SITE_REPO="$(readlink -f "<site_checkout>")"
   ```

   `<site_checkout>` is the checkout at the selected site revision.
   `verify_install_metadata.bash` reads its pins and includes its modules in
   the expected count. `<log_dir>` is an absolute path without
   white space, outside the clone and outside the install location:
   `verify_relocated_tree.bash` renames the installed tree and the clone while
   it runs, `verify_install_metadata.bash` compares the file lists of both
   before and after its queries, and the tc32sim fixture refuses a path with
   white space.

3. Run every script in its fixed order:

   ```bash
   status=0
   bash "$LOADER" > "$LOGS/loader-run.log" 2>&1 || status=$?
   printf '%s\n' "$status" > "$LOGS/loader-run.exit"
   cat "$LOGS/loader-run.log"
   ```

   Require status 0 and inspect the saved log before continuing. The `.exit`
   file records the runner's exit, independent of the subsequent `cat` command.
   On the recorded runs it took about eleven minutes on Debian 13 and ten on
   Rocky Linux 8.10. The log contains one line per script, such as
   `verify_directives exit 0, SUMMARY ok=15 fail=0`, and ends with
   `run done <time>`. `verify_minimal_example`,
   `verify_readme_update_command`, and `observe_truncated_library` print no
   `SUMMARY` line, because they count no checks.

   The command can run again on the same installation: each script restores
   what it changed, and the counts of the suite `README.md` hold on every run.

4. To run one script, or a few in the order given, name them:

   ```bash
   selected=(verify_directives verify_multiple_versions verify_failure_diagnostics)
   status=0
   IOCSH_TEST_OUT="$LOGS/loader-selected" bash "$LOADER" "${selected[@]}" > "$LOGS/loader-selected.log" 2>&1 || status=$?
   printf '%s\n' "$status" > "$LOGS/loader-selected.exit"
   cat "$LOGS/loader-selected.log"
   ```

   These partial-run logs are separate from the full suite evidence.
   Require status 0 and inspect them before continuing.
   `verify_resolved_paths`, `verify_failure_diagnostics`, and
   `verify_elf_inspection` use the second versions that
   `verify_multiple_versions` installs, so run that one first when the tree
   has not run it. A module cycle of a release names three scripts this way,
   `verify_install_metadata`, `verify_dependency_graph`, and
   `verify_minimal_example`, with the fixture that loads the module; the
   other scripts check the loader itself and run once per release, on the
   final tree.

5. Read a script log when a line shows a nonzero exit status or `fail` above 0.
   Each check is a line that starts with `OK` or `FAIL`, and the log of one
   script is `<log_dir>/loader/<script>.log` (or `loader-selected` for step 4):

   ```bash
   grep -a '^FAIL' "${IOCSH_TEST_OUT}"/*.log
   ```

## Verification

1. Every script line reports exit status 0 and no `fail` above 0.
   The `run_all.bash` completion status alone does not establish a pass;
   inspect each result and the logs.
2. Each script gives the passing count from the recorded tools checkout's
   `examples/iocsh/tests/README.md`. The
   [online README](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/tests/README.md)
   shows the current development revision.
   Compare counts and runtime observations with the accepted baseline for the
   selected OS, source pins, and suite revision. If no matching baseline exists,
   record the trial results and obtain Maintainer confirmation before marking
   verification passed.
3. The three scripts without a count give their expected output, which the
   same README lists, in their own logs: the `records listed:` result in
   `verify_minimal_example.log`, the line `32` in
   `verify_readme_update_command.log`, and the three lines
   `cut at <n>: softIocPVX status <s>` in `observe_truncated_library.log`.
   Use the README's count for the selected release; the count of the
   minimal example is the same on a machine without `/sys/class/hwmon`, where
   its `suspicious lines` section lists six linStat error lines.
