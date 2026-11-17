# Installed module loader

The loader is the program `iocsh.bash`. It runs an Experimental Physics and
Industrial Control System (EPICS) input/output controller (IOC) from the
installed `softIocPVX` and a startup file that names the installed modules it
needs. No IOC executable is compiled. The loader resolves each named module
and its dependencies from metadata that the build wrote into the installed
tree, checks the files it is about to load, and starts the IOC with a
generated startup that loads them.
[Run an IOC from installed modules](../procedures/run-ioc-from-installed-modules.md)
describes how to use it, and the
[Tools and scripts reference](../reference/tools-and-scripts.md#behavior-details-of-the-tools)
lists the directive forms, the messages, and the exit statuses.

## Where the loader gets its information

The loader reads only the installed tree. It takes the tree from the
environment that `setEpicsEnv.bash` set, or sources
`<installed_tree>/setEpicsEnv.bash` itself with the option `-e`. It reads no
file of the EPICS-env checkout that built the tree.

Each installed module carries `cfg/iocsh.conf`, which names its libraries,
its database definition (DBD) files, its dependencies with their versions,
and its environment macro, and `cfg/iocsh.conf.sha256`, which holds the
digest of that file. It also carries `cfg/build-record`, which names the GNU
build-id of each installed library, and `cfg/build-record.sha256`.
[Loader metadata in each module](installed-tree.md#loader-metadata-in-each-module)
describes the files, and
[Loader entries in CONFIG_MODS_IOCSH](module-set.md#loader-entries-in-config_mods_iocsh)
explains how the build chooses the entries and what it rejects.

## Directives

A directive is a complete line of the startup file that starts with
`module`, `mod`, or `m`. It carries a module name and an optional exact
version, in one of six forms. The loader reads the directives from the
startup file given on the command line before the IOC starts. They are not
IOC shell commands: a directive typed at the IOC prompt, or placed in a file
that the startup loads with `iocshLoad`, is not recognized.

## Selecting versions and dependencies

A directive without a version follows the unversioned link of the module,
such as `modules/asyn`. A directive with a version uses
`modules/<name>-<version>` exactly. A version is compared as text; there is
no range and no ordering.

The module `pvxs` is native to `softIocPVX`. The loader does not load its
libraries again and records its version; a directive that asks for another
version of `pvxs` stops the start.

The loader resolves the requested modules and their recorded dependencies
once, and uses the canonical paths of that resolution for every library,
DBD file, and environment macro of the start. Each dependency is loaded in
the version that the selected module recorded, not in the version its link
points to, and loads before the module that needs it, even when the
module's own library does not reference it. A module appears once; two
requests that need different versions of one module stop the start, and
so does a dependency cycle.

## The generated startup

The loader does not run the startup file directly. It passes `softIocPVX` a
generated startup as `/dev/fd/3`. That startup sets `on error break`, loads
each library with `dlload` and each DBD file with `dbLoadDatabase` in
dependency order, sets one environment macro per module to its directory,
such as `LINSTAT`, calls `registerAllRecordDeviceDrivers(pdbbase)` once, and
loads the startup file. A startup file without a directive runs unchanged.

The loader loads a copy of the startup file in which each directive line is
a comment line, passed as `/dev/fd/4`, so that the line numbers of IOC
messages match the original file. The IOC shell names a startup file by the
last part of its path, so an error in your startup file names the file `4`.
The loader prints this mapping before it starts the IOC, and the show mode
prints the generated startup without starting the IOC.

## Checks before the IOC starts

The loader stops before it starts the IOC, and names the startup file and
line when the cause is a directive, in these cases:

- A directive is malformed, or a module or version is not installed.
- The metadata of a selected module is missing, was built for another EPICS
  base version or architecture, or differs from the digest recorded when the
  build wrote it, which means the file was changed afterwards.
- Two requests need different versions of one module, or the recorded
  dependencies form a cycle.

Then the loader inspects the executable files that it is about to use. It
runs `iocsh_elf.bash inspect` on `softIocPVX` and on every selected library
and stops when a needed library resolves to no file, or to a file of an
installed module version that is not selected, which the environment
variables `LD_LIBRARY_PATH` or `LD_PRELOAD` can cause. It also stops when
a library file is shorter than the end of its last loadable segment: the
dynamic loader cannot map such a file, and with some C library versions the
IOC would end with a bus error instead of a message.

The inspection follows the search order of the dynamic loader: a library
already loaded under that name, the `RPATH` of the requesting file when it
has no `RUNPATH`, `LD_LIBRARY_PATH`, the `RUNPATH`, the `ldconfig` cache, and
the default directories, with `$ORIGIN` taken from the requesting file. It
needs `readelf`. It is a static check and does not prove which files the
dynamic loader binds. Each resolved file is classified as a file of EPICS
base, of an installed module, of the `vendor` directory, or of the system.

Last, the loader compares build-ids. For each library that it loads with
`dlload`, and each file of an installed module that the inspection resolved,
it reads the GNU build-id of the file and compares it with the line of that
file in the `cfg/build-record` of the module directory that holds it. It
stops when a build-id differs or a file has no line, and prints one summary
line and one line per file, each with the word `ERROR`:

```
iocsh.bash: ERROR: 1 of 2 module libraries differ from their build record
iocsh.bash: ERROR: iocStats-4.0.1 lib/linux-x86_64/libdevIocStats.so build-id bea8ff920414572890cec471fc100131ce049098 recorded dbbde0a296378196d2605d7fcf01a0a790adf16e
```

It also stops when a module directory has no `cfg/build-record`, or when the
record does not match `cfg/build-record.sha256`. A record of format 1, which
the tools of release 1.5.0 wrote, has no build-id: the loader compares nothing
for that module and prints nothing. Files of EPICS base, of the `vendor`
directory, and of the system are not compared.
[Shared library identity](shared-library-identity.md) describes the record
and the comparison.

A stop in this section ends `iocsh.bash` with exit status 78 and starts no
IOC; a wrong command line ends it with 64. The show mode makes the same
checks and ends with the same status, so `iocsh.bash -n <startup_file>` tells
whether a start would proceed without starting anything.

## What the dynamic loader loads

The checks above are static. To see the search of the dynamic loader itself,
start the IOC with `iocsh.bash -l <startup_file>`. The option sets
`LD_DEBUG=libs` for the IOC process only, so the programs that the loader ran
before do not report. The dynamic loader then writes its lines to the
standard error output, each with a process number in front; a `calling init:`
line names the file of each library in load order. `iocsh.bash` prints the
process number of the IOC first:

```
iocsh.bash: loader lines of the IOC process start with 2849365:
   2849365:	calling init: <installed_tree>/modules/iocStats-4.0.1/lib/linux-x86_64/libdevIocStats.so
```

A process that the IOC starts inherits the variable and reports under its own
number. `softIocPVX` starts one `sh` when it registers the `system` command,
so a start shows the lines of that process as well. The output is not
filtered and carries no build-id.

## How the metadata is made

The build writes the metadata, not the loader. After a module builds,
`iocsh_metadata.bash record` writes `cfg/build-record` with the build-id of
each library, and its digest: it requires the
module source checkout at the commit of its pinned tag. `generate` then
writes `cfg/iocsh.conf` and its digest. It requires a build record that
matches the current pins and the installed files, and rejects a library that
leaves symbols undefined after its needed libraries, EPICS base, and its
dependency modules are considered. Both `record` and `generate` remove the
metadata of an earlier build before their checks, so a module whose record or
generation is refused carries no loader metadata. `check` compares
`cfg/iocsh.conf` and `cfg/build-record` with their digests and the recorded
digests and build-ids with the installed files; `symlink.<module>`, which `make symlinks` runs for each module, runs it
before it creates the unversioned link of an installed module.
[Loader metadata in each module](installed-tree.md#loader-metadata-in-each-module)
describes the files.

## Limits

- The inspection is static. It validates the files against the metadata and
  the search order; it does not prove what the dynamic loader binds.
- The digest of `cfg/iocsh.conf` detects an edit of that one file. It does not
  detect an edit that also replaces the digest. The digests of the libraries
  and DBD files are checked by `iocsh_metadata.bash check`, which
  `symlink.<module>` runs, and not by `iocsh.bash` at every start.
- The build-id comparison covers the libraries that the loader loads and the
  module files that the inspection resolves. It does not cover a startup file
  without a directive or a start without a startup file, which the loader
  passes to `softIocPVX` unchanged, nor a library that a startup file loads
  by itself.
- Directives work only in the startup file named on the command line.
