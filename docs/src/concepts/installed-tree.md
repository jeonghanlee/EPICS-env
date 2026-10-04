# Installed tree and relocation

The installed tree is the directory that holds one built Experimental
Physics and Industrial Control System (EPICS) base, every module in the
module set, and the files that set up a shell for them. Its binaries find
their shared libraries by position relative to themselves, so the whole
directory works after you move or copy it.
[Choose the install location and release](../procedures/choose-install-location.md) sets
where the tree goes, and
[Set up a shell with the environment](../procedures/set-up-shell.md) uses it.

## Directory layout by release, system, and base version

EPICS-env installs each tree at this path:

```
$(INSTALL_LOCATION)/$(ENV_RELEASE_VERS)/<os_id>-<os_version>/$(SRC_VER_BASE)
```

`<os_id>` and `<os_version>` are the `ID` and `VERSION_ID` values from
`/etc/os-release`. The make variable `INSTALL_LOCATION_EPICS` holds the whole
path, such as `/home/user/epics/1.4.0/debian-13/7.0.10`, so trees for several
releases, operating systems, and EPICS base versions can share one
`INSTALL_LOCATION`.
[Install location and release](../reference/configuration-variables.md#install-location-and-release)
lists the variables.

One tree has this layout, shown for two of its modules:

```
<install_location_epics>/
|-- setEpicsEnv.bash
|-- resetEpicsEnv.bash
|-- .versions
|-- base/
|   |-- bin/linux-x86_64/
|   |   |-- iocsh.bash
|   |   `-- iocsh_elf.bash
|   `-- lib/linux-x86_64/
|-- modules/
|   |-- asyn-4.46.0/
|   |   `-- cfg/
|   |       |-- build-record
|   |       `-- iocsh.conf
|   |-- asyn -> ./asyn-4.46.0
|   |-- seq-2.2.9/
|   |-- seq -> ./seq-2.2.9
|   `-- commonIocsh/
|       `-- iocsh/
`-- vendor/
    `-- lib/
```

## Versioned directories and unversioned links

Each module installs into `modules/<name>-<version>`, where `<version>` is the
`SRC_VER_<MODULE_KEY>` value of the module, such as `asyn-4.46.0` or
`calc-4217e83`. The sequencer installs as `seq-<version>`.

`make symlinks` adds an unversioned link for each module, such as
`modules/asyn`, that points to the versioned directory by a relative path.
The link gives a path that stays the same when a pin changes. Before it
creates the link of an installed module, the target checks that module's
loader metadata against the installed files and stops on a mismatch.

The build itself uses only versioned directories. Every module
`RELEASE.local` and every library search path in a binary names a versioned
directory, so removing or replacing the links changes no binary.
`setEpicsEnv.bash` uses the `pvxs` and `pmac` links to put their executables
on `PATH`.

## Loader metadata in each module

Each installed module carries two text files under `cfg/` that the
`iocsh.bash` loader and the build rules read. Both hold one `key=value`
per line, a repeated key forms an ordered list, and nothing in them is run
as shell code. Every path in them is relative to the module directory.

| File | Written by | Content |
| --- | --- | --- |
| `cfg/build-record` | `build.<module>`, after the module build succeeds | Module name, version, and tag, the source commit that was built, the EPICS base version and architecture, each declared dependency with its version, and a SHA-256 digest of every installed library and database definition (DBD) file |
| `cfg/iocsh.conf` | `build.<module>` and `install.<module>`, from the build record | Module name and version, the EPICS base version and architecture, the environment macro name, each dependency with its version, and the ordered libraries and DBD files that the loader loads |

The build record requires the source checkout to sit at the commit of the
pinned tag, and rejects a module path in the source release files that
names an undeclared dependency version or a directory outside the tree.
`cfg/iocsh.conf` is written only when the record matches the current
configuration and the installed files still have their recorded digests,
so changing a pin without rebuilding the module fails instead of relabeling
old binaries. The `cfg/iocsh.conf` of StreamDevice reads:

```
format=1
name=StreamDevice
version=2.8.26
base=7.0.10
arch=linux-x86_64
macro=STREAM
dep=asyn 4.46.0
dep=calc 4217e83
lib=lib/linux-x86_64/libstream.so
dbd=dbd/stream.dbd
```

[Loader entries in CONFIG_MODS_IOCSH](module-set.md#loader-entries-in-config_mods_iocsh)
explains how the `lib` and `dbd` lines are chosen and checked.

## Environment script and version record

`install.base` copies `scripts/setEpicsEnv.bash` and
`scripts/resetEpicsEnv.bash` to the top of the tree with mode 0644. It backs
up files it replaces. You source setup in a Bash shell. The script finds the tree from its own location,
and follows a symbolic link to the script when there is one. It then sets
the shell environment in four ways:

- It sets `EPICS_PATH` to the tree, `EPICS_BASE` to its `base` directory,
  and `EPICS_MODULES` to its `modules` directory.
- It sets `EPICS_HOST_ARCH` from the `EpicsHostArch.pl` script of EPICS
  base, which `perl` runs, or else from `base/startup/EpicsHostArch`, which
  `sh` runs. When `perl` or all three scripts are absent, it uses its own
  fallback architecture argument. Its interface is `[<fallback_arch>]
  [disable]`; `disable` controls only the summary.
- It adds `base/bin/<arch>`, `modules/pvxs/bin/<arch>`, and
  `modules/pmac/bin/<arch>` to the front of `PATH`.
- It adds `base/lib/<arch>` to the front of `LD_LIBRARY_PATH`.

When `EPICS_BASE` is already set, the script first removes the entries of the
earlier tree from `PATH` and `LD_LIBRARY_PATH` after resolving the selected
tree and architecture. Complete-field comparison preserves unrelated entries
and empty fields; repeated setup adds managed directories once. Directly
sourcing another tree's setup selects that tree. Resolution failure preserves
the existing managed environment.

Reset removes the known executable and base library entries and unsets
`EPICS_PATH`, `EPICS_BASE`, `EPICS_MODULES`, `EPICS_HOST_ARCH`, and legacy
`EPICS_EXTENSIONS`, including when base is absent. Both scripts preserve
independently configured CA settings and operate with Bash nounset enabled.

`install.iocsh` copies `tools/iocsh.bash` and `tools/iocsh_elf.bash` into
`base/bin/<arch>` with mode 0755, so the loader is on `PATH` wherever the
setup script has been sourced and needs no entry of its own.

`src_version` writes `.versions` at the top of the tree. It records when the
install ran and which EPICS-env commit it used. The `.versions` file of one
tree reads:

```
Timestamps : 20260926-225114/YYYYMMDD-HHMMSS
git version :4601e4049ac3f846806ec59a7cf462f4f9459393
```

## Common iocsh fragment directory

`install.commoniocsh` copies `commonIocsh/iocsh/*.iocsh` from the repository
to `modules/commonIocsh/iocsh`. That directory has no version in its name and
no unversioned link. An input/output controller (IOC) sets `IOCSH_TOP` to
its parent, `modules/commonIocsh`, and loads each fragment as
`$(IOCSH_TOP)/iocsh/<fragment>.iocsh`.
[Common iocsh fragments](common-iocsh-fragments.md) explains the fragments,
and [Load common iocsh fragments in an IOC](../procedures/load-common-iocsh-fragments.md)
uses them.

## Vendor library directory

`vendor/` holds third-party libraries that two modules link: uldaq for
`measComp` and open62541 for `opcua`. No EPICS-env make target creates it.
The continuous integration (CI) workflows and `tools/prep-vendors.bash`
install both libraries there, and point `VENDOR_ULDAQ_PATH` and
`OPEN62541_PATH` at it in `configure/RELEASE.local`. With the default value
`/usr/local` of both variables, the modules link the libraries from that
system location instead.
[Vendor library locations](../reference/configuration-variables.md#vendor-library-locations)
lists the two variables.

`vendor/` lies inside the tree, so `make uninstall` removes it with the rest
of the tree.

## Library search paths relative to ORIGIN

A shared library or executable in the Executable and Linkable Format (ELF)
carries a list of directories that the dynamic loader searches for the
libraries it needs. EPICS-env makes every entry for a library inside the tree
relative to `$ORIGIN`, which the loader replaces with the directory of the
file being loaded.

Two EPICS base build variables produce the relative entries:

- `LINKER_USE_RPATH` is `ORIGIN`. `conf.base.site` writes it to the EPICS
  base site file, and every build receives it on the make command line.
- `LINKER_ORIGIN_ROOT` names the root of the relocatable tree. Every EPICS
  base and module build receives it on the make command line, set to
  `INSTALL_LOCATION_EPICS`, the top of the tree.

EPICS base records a library directory under that root as a path relative to
`$ORIGIN`, and a directory outside the root as an absolute path.

The linker option `-Wl,--enable-new-dtags` stores the list as a `RUNPATH`
entry, the run-time library search path, rather than an `RPATH` entry.
`check.deps` fails on any `RPATH` entry, and the configuration passes the
option to every kind of link:

| Where the configuration sets it | Variable | Links |
| --- | --- | --- |
| EPICS base `configure/CONFIG_SITE.local` | `PROD_LDFLAGS_DEFAULT` | Executables of EPICS base and of every module, because EPICS base installs this file and its `configure/CONFIG_SITE` reads it |
| EPICS base `configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64` | `SHRLIB_LDFLAGS`, `LOADABLE_SHRLIB_LDFLAGS` | Shared libraries of EPICS base and of every module, because EPICS base installs this file |
| `CONFIG_SITE.local` at the repository top | `PROD_LDFLAGS` | Executables of the modules that read this file |

The EPICS base `configure/CONFIG_SITE.local` also adds
`-Wl,--no-as-needed` to `USR_LDFLAGS`, which every link of EPICS base, of
the modules, and of applications built against the installed base reads.
With it the linker records every shared library named on a link line as a
needed library, whatever its position. Toolchains that default to
`--as-needed` drop a library named before the object files that use it; the
snmp support library lost its net-snmp entry that way and could not be
loaded on its own. For the same reason `conf.measComp` names uldaq for the
measComp support library, which the module's own makefile links only into
its IOC executable.

From the top of an installed tree, this command prints the libraries that
the asyn library needs and its search path:

```bash
readelf -d modules/asyn-4.46.0/lib/linux-x86_64/libasyn.so | grep -E 'NEEDED|RUNPATH'
```

The output is:

```
 0x0000000000000001 (NEEDED)             Shared library: [libdbRecStd.so.3.25.0]
 0x0000000000000001 (NEEDED)             Shared library: [libdbCore.so.3.25.0]
 0x0000000000000001 (NEEDED)             Shared library: [libca.so.4.15.0]
 0x0000000000000001 (NEEDED)             Shared library: [libCom.so.3.25.0]
 0x0000000000000001 (NEEDED)             Shared library: [libtirpc.so.3]
 0x0000000000000001 (NEEDED)             Shared library: [libreadline.so.8]
 0x0000000000000001 (NEEDED)             Shared library: [libstdc++.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libm.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libgcc_s.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000001d (RUNPATH)            Library runpath: [$ORIGIN/../../../../base/lib/linux-x86_64:$ORIGIN/.]
```

The first entry leads from `modules/asyn-4.46.0/lib/linux-x86_64` up four
levels to the top of the tree and down to the EPICS base libraries. No entry
names the directory the tree was built in.

## Why the tree can be moved

Two properties make the tree independent of the directory it was built in:

- Every library search path to a library inside the tree is relative to
  `$ORIGIN`, so the loader finds EPICS base, module, and vendor libraries at
  the same relative positions after a move.
- `setEpicsEnv.bash` computes every path it sets from its own location.
- The loader metadata names files relative to each module directory, and
  `iocsh.bash` builds every path from `EPICS_BASE` and `EPICS_MODULES`. It
  reads no file of the EPICS-env checkout that built the tree.

`check.deps` guards the first property. It fails when an installed binary
carries an `RPATH` entry or an absolute path outside the system library
directories. It also fails on a shared library that needs a library of the
tree but has no `$ORIGIN` entry.
[Build and install verification gates](verification-gates.md) describes it.

A search path can also name a system library directory, such as
`/usr/lib/x86_64-linux-gnu` in the `pmac` and `pyDevSup` libraries. Such a
path does not depend on where the tree lies.

Relocation covers the loader and the environment script, not every text
file. These installed files keep the absolute path of the original tree:

- The EPICS base `configure/CONFIG_SITE.local`.
- The `configure/RELEASE.local` file that 16 of the installed modules carry,
  except the one of `iocStats`, which sets only `MAKE_TEST_IOC_APP=NO`.
- The `S99caRepeater`, `S99logServer`, and `caRepeater.service` files in
  `base/bin/linux-x86_64`.
- The `epics-base.pc` and `epics-base-linux-x86_64.pc` files in
  `base/lib/pkgconfig`.
- The `libuldaq.la` and `pkgconfig/open62541.pc` files under `vendor/lib`.

The tree path names one operating system and version, and the tree links the
system libraries of that system. A moved tree therefore belongs on a host
that runs the same operating system and version.

`make uninstall` removes the tree at the path that the current configuration
computes. [Uninstall and clean](../procedures/uninstall-and-clean.md) covers
removal.
