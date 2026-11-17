# Shared library identity

An installed shared library is identified by the module directory that holds it and its path inside that directory. Its
fingerprint is the GNU build-id that the linker writes into the file. The `SONAME` of a library is left as the build made it
and is not part of the identity. This page states the rules, the record that carries the fingerprint, the comparison that
the loader makes before it starts an IOC, and how to see what the dynamic loader loads.
[Installed tree and relocation](installed-tree.md) describes the directories, and
[Installed module loader](installed-module-loader.md) describes the loader that selects the libraries.

## What identifies a library

| Part | Example | Role |
| --- | --- | --- |
| Module directory | `asyn-4.46.0`, `calc-3.8.0`, `unidrv-e5a8561` | Names the module and its release (a version number or the first seven characters of a commit). It is the identity of the module version. |
| Path in the module | `lib/linux-x86_64/libasyn.so` | With the module directory, it keys every entry of the loader metadata. |
| `SONAME` | `libCom.so.3.25.0` or `libasyn.so` | The name that the dynamic loader matches. It is as built and may be bare. |
| Build-id | `ce0ebac3242d80e16aca5d0a67ac44980ea81a6e` | Identifies one build of the file. It lies inside the file, so it stays with a copy. |

The module directory and the path form the key of a library. The build-id is the fingerprint of that key: it tells whether
the file at the key is the file that was recorded. The release version of a module (`4.46.0`) and the identity of a build
(the build-id) are different things: rebuilding a release with other compiler options keeps the release version and gives a
new build-id.

## The `SONAME` rule

The modules do not set a versioned `SONAME`, and EPICS-env does not change that: no module repository is changed to add one,
and no library is renamed. Of the 82 distinct `SONAME` values of an installed tree, 21 have a `.so.N` part and 61 do not.

- EPICS base is identified by its own `SONAME`. 12 of its 14 shared objects have a versioned one, such as `libCom.so.3.25.0`.
- The two copies of `libCap5.so`, the Perl binding, are the exception. Their `SONAME` is the bare `libCap5.so`. One lies in
  `base/lib/linux-x86_64` and one under `base/lib/perl`. They are identified by path and
  build-id, and the two copies are identical files.
- The vendor libraries keep the `SONAME` of their packages: `libopen62541.so.1` and `libuldaq.so.1`.

## The build-id

Every shared object of the installed trees examined has a build-id: 101 of 101 on Debian 13 (GCC 14.2) and on Rocky Linux
8.10 (GCC 8.5), and 85 of 85 in a local Debian 13 tree. From a module directory of an installed tree, such as `modules/asyn-4.46.0`, this
command prints it:

```bash
readelf -n lib/linux-x86_64/libasyn.so | grep 'Build ID'
```

The value differs for every build. The build-ids in the examples of this page are those of the trees examined; a tree built
elsewhere has other values.

Files with different content have different build-ids, and files with the same content have the same one. In every tree
examined, no build-id is shared by files of different content, and no two files with the same SHA-256 digest differ in
build-id. A build-id is shared only by identical copies:

- the two copies of `libCap5.so` in EPICS base, and
- `lib/linux-x86_64/libre2.so` of `unidrv-0.5.1` and of `unidrv-e5a8561`, which the two module versions each install. Both
  versions are installed on the Debian 13 and the Rocky Linux 8.10 test machines.

A build-id therefore names every module directory that holds a file with that content, not one module. A lookup from a
build-id returns a list of keys, and the key of a library stays its module directory and path.

## The record

The build record `cfg/build-record` of a module carries the fingerprint of each installed shared object
([Loader metadata in each module](installed-tree.md#loader-metadata-in-each-module)):

```
artifact=lib/linux-x86_64/libdevIocStats.so <sha256>
buildid=lib/linux-x86_64/libdevIocStats.so dbbde0a296378196d2605d7fcf01a0a790adf16e
```

- `iocsh_metadata.bash record` writes a `buildid=<path> <hex>` line after the `artifact=` line of each shared object. The
  path is relative to the module directory and the hex value is the build-id as `readelf -n` prints it.
- A library without a build-id is recorded as `none`, and `record` prints a notice for it.
- The line raises `cfg/build-record` to format 2, and the record gets the digest file `cfg/build-record.sha256`.
  `cfg/iocsh.conf` carries no build-id and stays format 1: the two files are separate formats with separate numbers.
- The SHA-256 digest of each artifact stays in the record and keeps its job: `iocsh_metadata.bash check` compares the
  installed file with the built file. `check` compares the build-id as well.
- A record of format 1, as the tools of release 1.5.0 wrote it, has no build-id. `iocsh.bash` reads it and compares
  nothing for that module; the build rules read it as before, and `make build.<module>` writes the record of that
  module in format 2.

### The vendor record

`vendor/` holds the libraries that the wrapper repositories `uldaq-env` and `open62541-env` install, and it has no `cfg`
directory. EPICS-env reads no record there, and a vendor library is not compared. The form of a vendor record is not
decided.

## The `RUNPATH` rule

The `RUNPATH` of a library that lies in the tree names exact installed directories, and an unversioned link only for
`base`. In the trees examined, every `RUNPATH` entry has one of these forms:

| Form | Example | Used by |
| --- | --- | --- |
| Exact module directory | `$ORIGIN/../../../asyn-4.46.0/lib/linux-x86_64` | libraries that need another module |
| EPICS base | `$ORIGIN/../../../../base/lib/linux-x86_64` | the libraries of modules that need EPICS base; the directory is `base` and has no version |
| The directory of the file | `$ORIGIN/.` | most libraries |
| Vendor directory | `$ORIGIN/../../../../vendor/lib` | `libmeasComp.so` and `libopcua.so.0.11` |
| Library directory of the own module, from a subdirectory | `$ORIGIN/../../../lib/linux-x86_64` | the pyDevSup Python extensions |
| System library directory, absolute | `/usr/lib/x86_64-linux-gnu` on Debian, `/usr/lib64` on Rocky Linux | `libpowerPmacAsynPort.so` and the pyDevSup library and extensions |

No library has an `RPATH` entry. `libVimbaC.so` and `libVimbaImageTransform.so` of `ADVimba`, the libraries of a vendor
SDK, have no `RUNPATH`. The module directory in an entry names the version the library was built against. The dynamic
loader takes a library that is already loaded under the same name before it searches `RUNPATH`, so with a bare `SONAME` a
library of another version that was loaded earlier satisfies the need.

## The comparison before a start

`iocsh.bash` compares build-ids before it starts the IOC, at every start whose startup file names a module with a
directive ([Installed module loader](installed-module-loader.md#checks-before-the-ioc-starts)).

- The compared files are the libraries that the loader loads with `dlload` and the files of installed modules that its
  static inspection resolves as their dependencies and as those of `softIocPVX`, each file once.
- For each file the loader reads the build-id with `readelf -n` and compares it with the `buildid=` line of that file in
  the `cfg/build-record` of the module directory that holds the file. The path decides the owner, so a build-id that
  identical copies share causes no ambiguity.
- A build-id that differs, or a file without a line in a record of format 2, stops the start with exit status 78 and
  these lines on the standard error output:

  ```
  iocsh.bash: ERROR: 1 of 2 module libraries differ from their build record
  iocsh.bash: ERROR: iocStats-4.0.1 lib/linux-x86_64/libdevIocStats.so build-id bea8ff920414572890cec471fc100131ce049098 recorded dbbde0a296378196d2605d7fcf01a0a790adf16e
  ```

  The summary line counts the compared files that got a line. A file without a line in the record reads
  `iocStats-4.0.1 lib/linux-x86_64/libdevIocStats.so has no build-id in cfg/build-record`.
- A record of format 2 that does not match its digest file, and a module directory without a record, stop the start in
  the same way.
- A module whose record is format 1 is not compared, and the loader prints nothing for it.
- Libraries of EPICS base, of `vendor`, and of the system are not compared.

The comparison reads the file at each path when `iocsh.bash` runs; it does not read the memory of an IOC.

## The listing of the show mode

`iocsh.bash -n <startup_file>` lists each resolved file as a line that starts with `# elf:`. The line of a compared file
ends with its build-id, and `not recorded` marks a file of a module whose record is format 1:

```
# elf: module iocStats-4.0.1 <installed_tree>/modules/iocStats-4.0.1/lib/linux-x86_64/libdevIocStats.so buildid dbbde0a296378196d2605d7fcf01a0a790adf16e
# elf: module asyn-4.46.0 <installed_tree>/modules/asyn-4.46.0/lib/linux-x86_64/libasyn.so buildid 99ab16b015fd2a08bd8bddaec7ee01af38a5dd73 not recorded
```

When a build-id differs, `-n` prints the error lines and no listing, as for every other refusal, and ends with the same
status as a start. It therefore serves as a check before a start.

## What the dynamic loader loads

The comparison and the inspection are static. `iocsh.bash -l <startup_file>` sets `LD_DEBUG=libs` for the IOC process,
and the dynamic loader then reports its own search on the standard error output; each `calling init:` line names the file
of a loaded library. [Installed module loader](installed-module-loader.md#what-the-dynamic-loader-loads) describes the
output. It shows paths and no build-id, and nothing compares it with the record.

## Limits

- The comparison covers the libraries that the loader loads and the module files that its static inspection resolves. It
  does not prove which files the dynamic loader binds; the option `-l` shows that for a person to read.
- A startup file without a directive, and a start without a startup file, are not compared.
- A library that a startup file loads by itself, and a library loaded by another consumer, for example by a Python
  extension, are not compared.
- Libraries of EPICS base and of `vendor` have no record. A library that the system supplies, such as `libc.so.6`, has
  none either.
- The rules are measured on Debian 13 and Rocky Linux 8.10.
