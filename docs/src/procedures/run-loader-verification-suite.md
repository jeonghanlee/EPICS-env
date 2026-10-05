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

- A candidate installation on Debian 13 or Rocky Linux 8.10, built in a clone
  of EPICS-env that only the suite uses, with a default route on the host. The
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
- For `verify_docs_and_tools.bash` only: ShellCheck, and Docker with the
  `jeonghanlee/mdbook` image. Without ShellCheck that script gives one passing
  check fewer, without Docker two fewer; Rocky Linux 8.10 has no Docker and
  gives 6 of 8.
- Network access to GitHub, for the application checkouts of the fixtures and
  for the sources of the second versions of linStat and asyn, and to
  `docker.io`, for the image `docker.io/digitalpetri/opc-ua-demo-server` that
  the opcua fixture runs as the Eclipse Milo demo server and for the image
  `jeonghanlee/mdbook`.
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
   make print-INSTALL_LOCATION_EPICS
   ```

   The printed directory is the installed tree for one host, such as
   `<install_location>/1.4.0/debian-13/7.0.10`. This procedure calls it
   `<installed_tree>`.

2. Choose a directory for the logs and name the tree, the clone, and the log
   directory:

   ```bash
   export IOCSH_TEST_TREE=<installed_tree>
   export IOCSH_TEST_REPO=<repo>
   export IOCSH_TEST_OUT=<log_dir>
   ```

   `<repo>` is the clone of step 1. `<log_dir>` is an absolute path without
   white space, outside the clone and outside the install location:
   `verify_relocated_tree.bash` renames the installed tree and the clone while
   it runs, `verify_install_metadata.bash` compares the file lists of both
   before and after its queries, and the tc32sim fixture refuses a path with
   white space.

3. Run every script in its fixed order:

   ```bash
   bash "${IOCSH_TEST_REPO}/examples/iocsh/tests/run_all.bash"
   ```

   On the recorded runs it took about eleven minutes on Debian 13 and ten on
   Rocky Linux 8.10. It prints one line per script, such as
   `verify_directives exit 0, SUMMARY ok=15 fail=0`, and ends with
   `run done <time>`. `verify_minimal_example`,
   `verify_readme_update_command`, and `observe_truncated_library` print no
   `SUMMARY` line, because they count no checks.

4. To run one script, or a few in the order given, name them:

   ```bash
   bash "${IOCSH_TEST_REPO}/examples/iocsh/tests/run_all.bash" verify_directives verify_multiple_versions verify_failure_diagnostics
   ```

   `verify_resolved_paths`, `verify_failure_diagnostics`, and
   `verify_elf_inspection` use the second versions that
   `verify_multiple_versions` installs, so run that one first when the tree
   has not run it.

5. Read a script log when a line shows a nonzero exit status or `fail` above 0.
   Each check is a line that starts with `OK` or `FAIL`, and the log of one
   script is `<log_dir>/<script>.log`:

   ```bash
   grep -a '^FAIL' "${IOCSH_TEST_OUT}"/*.log
   ```

## Verification

1. The command of step 3 exits with status 0 and no script line shows
   `fail` above 0.
2. Each script gives the passing count of the table in the
   [`README.md` of the suite](https://github.com/jeonghanlee/EPICS-env/blob/master/examples/iocsh/tests/README.md).
   The counts apply to the pins of the tree they were recorded on; after a
   change of a pin, the scripts are adjusted with it.
3. The three scripts without a count give their expected output, which the
   same README lists, in their own logs: the line `records listed: 317` in
   `verify_minimal_example.log`, the line `32` in
   `verify_readme_update_command.log`, and the three lines
   `cut at <n>: softIocPVX status <s>` in `observe_truncated_library.log`.
