# Build and install verification gates

EPICS-env checks the Experimental Physics and Industrial Control System
(EPICS) build at two points: before compilation, it compares module
dependencies against the sources, and after installation, it inspects the
installed tree. Each check is a make target in two forms. The report form
prints findings and exits 0 on them, and the strict form exits with a
failure code on a finding. Both forms exit with a failure code on a usage
error or a missing tool. The strict form is the gate.
[Run the verification gates](../procedures/run-verification-gates.md) runs
them, and
[Verification and inspection targets](../reference/make-targets.md#verification-and-inspection-targets)
lists the targets.

## Gates and the stage each one guards

| Gate | Report form | Stage | What it reads | Script |
| --- | --- | --- | --- | --- |
| `check.module-deps` | `audit.module-deps` | After `conf`, before `build` | Module source trees | `tools/audit_module_deps.bash` |
| `check.deps` | `audit.deps` | After `install` | Installed binaries and shared libraries | `tools/check_deps.bash` |
| `check.env` | `audit.env` | After `install` | Installed `setEpicsEnv.bash` | `tools/check_env.bash` |

`check.module-deps` is static: it reads text and compiles nothing.
`check.deps` and `check.env` read the installed tree, so they belong after
`make install`. Neither aggregate `github` nor `github.check` runs them.

## Static module dependency audit

`check.module-deps` compares, for each module, the dependencies the module
declares with the dependencies its source tree shows. The declared list is
the `<module>_DEPS` variable in `configure/CONFIG_MODS_DEPS`.
[Module set and dependencies](module-set.md#build-order-from-declared-dependencies)
describes that variable.

The audit reads these files in each module source tree and records every
reference to another module:

| Source | Reference | Strength |
| --- | --- | --- |
| `configure/RELEASE.local`, which `conf` writes | A macro that names a module, such as `ASYN` | Required |
| `Makefile` files | A database definition (`.dbd`) file in a `DBD` line | Required |
| `Makefile` files | A library in a `_LIBS` line | Probable |
| Database definition, database, and protocol files | A referenced `.dbd`, database, or `.proto` file | Required |
| Database files | A record type | Probable |
| Startup scripts (`st.cmd`, `*.cmd`, `*.iocsh`) | A file that `dbLoadRecords`, `dbLoadTemplate`, or `dbLoadDatabase` loads | Required |
| C and C++ sources and headers | An included header | Probable |

The location of a file can weaken a reference to optional. A reference under
a test, example, demonstration, or `iocBoot` directory is optional, and so is
one inside a conditional block of a `Makefile`. Documentation directories
are ignored. Build output directories are ignored too, except under a test
directory, where their files count as optional. A reference to a
known external library, such as `ftdi`, appears as `external` and never
fails. References under `os/Linux`, `os/posix`, and
`os/default` stay required only when the `PLATFORM` variable is `Linux`, the
default on a Linux host. Only required references can produce a failing
finding; probable and optional references appear in the report.

The audit reports three kinds of finding:

| Finding | Meaning | Fails the strict form |
| --- | --- | --- |
| `undeclared-observed` | A required reference names a module that `<module>_DEPS` does not list | Yes |
| `unknown` | A required reference matches no module, EPICS base library, or known external library | Yes |
| `declared-unobserved` | `<module>_DEPS` lists a module that no required reference names | No |

The audit maps several spellings to one module, such as `SNCSEQ`, `seq`, and
`pv` to `sequencer`. `configure/CONFIG_MODS_AUDIT` holds the spellings, the
EPICS base libraries and record types, and the external libraries such as
`ssl` and `z`.

Because the audit reads patched sources and the `RELEASE.local` files that
`conf` writes, `github.check` runs it after `patch` and `conf`. The
`feed-core` and `QPC` patches remove source references to modules those
builds do not use; the strict audit passes for both modules with or without
those patches.

## Installed runpath scan

`check.deps` inspects the Executable and Linkable Format (ELF) files of the
installed tree with `readelf -d`. It scans the executables under
`base/bin/linux-x86_64` and `modules/*/bin/linux-x86_64`, and the shared
libraries under `base/lib/linux-x86_64`, each module's `lib/linux-x86_64`,
and `vendor/lib`.

It counts three defects:

- An `RPATH` entry in any scanned file. A `RUNPATH` entry, the run-time
  library search path, belongs there instead.
- An absolute directory in a library search path, other than a system
  library directory such as `/usr/lib` or `/usr/lib/x86_64-linux-gnu`.
- A shared library whose search path lacks `$ORIGIN` but that needs a
  library found in the tree. The scan calls this a lost runpath.

A system library directory in a search path prints a note and is not a
defect. [Installed tree and relocation](installed-tree.md#why-the-tree-can-be-moved)
explains why these defects break relocation.

`check.deps` scans whatever it finds at the path of the installed tree. When
that path does not exist, it scans no file and exits 0, so it proves
nothing until `make install` has run.

## Environment script library path check

`check.env` sources the installed `setEpicsEnv.bash` in a child Bash shell
started with an empty environment and a `PATH` of `/usr/bin:/bin`. It then
reads the `LD_LIBRARY_PATH` that the script produced. The empty environment
keeps the caller's own `LD_LIBRARY_PATH`, `PATH`, and `EPICS_*` variables out
of the result.

The check reports each `LD_LIBRARY_PATH` entry that contains a `pvxs/bundle`
path component. The build links the system libevent library, so that bundle
directory never exists, and the dynamic loader skips a missing directory
without an error. The check compares normalized entries, so doubled slashes
and `.` segments do not hide such an entry.

## Report and strict forms and their exit codes

| Target | Exit 0 | Exit 1 | Exit 2 | Exit 3 |
| --- | --- | --- | --- | --- |
| `audit.module-deps` | Audit ran | Invalid argument or no matching module | Not used | Not used |
| `check.module-deps` | No failing finding | Invalid argument or no matching module | One or more failing findings | Not used |
| `audit.deps` | Scan ran | Invalid option | `readelf` not found | Not used |
| `check.deps` | No defect | Invalid option | A defect, or `readelf` not found | Not used |
| `audit.env` | Check ran or skipped | Invalid option | Not used | Not used |
| `check.env` | No finding | Invalid option | One or more findings | No inspectable environment |

`check.env` treats three states as no inspectable environment: no installed
`setEpicsEnv.bash`, an empty `EPICS_MODULES` or `EPICS_HOST_ARCH` after the
script runs, and an empty `LD_LIBRARY_PATH`. `audit.env` prints `SKIP` for
the same states and exits 0.

When a script fails under a make target, make reports the script's code in
its error message, such as `Error 3`, and exits 2 itself.

## Where continuous integration runs each gate

Every continuous integration (CI) workflow for an operating system ends with
`make exist`, `make check.env`, and `make check.deps`, after `make install`.
The workflows for Debian 12, Debian 13, and Rocky Linux 8 build through
`make github.check`, so they also run `check.module-deps` before the build.
The workflows for Rocky Linux 10, Ubuntu 24.04, and Ubuntu 26.04 run the
stages one by one and do not run `check.module-deps`.
[Supported platforms and CI](../reference/supported-platforms-and-ci.md)
lists the workflows.
