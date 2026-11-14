# Shared library identity

An installed shared library is identified by the module directory that holds it and its path inside that directory. Its
fingerprint is the GNU build-id that the linker writes into the file. The `SONAME` of a library is left as the build made it
and is not part of the identity. This page states the rules, the record that carries the fingerprint, and what a check can
report about a library that a running IOC has mapped.
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

## The record in format 2

The metadata of the installed trees is format 1 today and has no `buildid=` line. This section specifies format 2 for the
change that makes the metadata scripts write it.

The loader metadata of a module is `cfg/build-record` and `cfg/iocsh.conf`
([Loader metadata in each module](installed-tree.md#loader-metadata-in-each-module)). Format 2 adds one line to each library:

```
format=2
lib=lib/linux-x86_64/liblinStat.so
buildid=lib/linux-x86_64/liblinStat.so 2784cde48f97d89da21e7d3c2e9c3a9620ee23a5
```

- In `cfg/iocsh.conf`, a `buildid=<path> <hex>` line follows each `lib=` line. In `cfg/build-record`, a `buildid=` line
  follows each `artifact=` line of a shared object. The path is relative to the module directory and the hex value is the
  build-id as `readelf -n` prints it.
- A library without a build-id is recorded as `none`. A reader gives a notice for it and no error.
- A file with `format=1` is stale: the record is raised to 2, so every installed tree is rebuilt for it, and a reader of
  format 2 refuses a record of format 1.

### The vendor record

`vendor/` holds the libraries that the wrapper repositories `uldaq-env` and `open62541-env` install, and it has no `cfg`
directory. The wrappers write the vendor record: the same `buildid=` lines, keyed by the path relative to `vendor`, such as
`lib/libuldaq.so.1.2.2`. Until a wrapper writes it, a vendor library is classified and reported without a fingerprint
comparison.

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

## What a running IOC maps

No command makes this comparison today. This section defines what it does.

The libraries that the IOC has mapped are listed in `/proc/<pid>/maps`, which the user that started the IOC can read. Each
mapped path under the tree gives a key, and the build-id read from the file is compared with the recorded one. A mapped
object whose build-id differs, or that has no record, is reported with its key.

`/proc/<pid>/map_files` names the exact file that was mapped, even after its path was replaced. The user that started the
IOC cannot open it on Debian 13 or on Rocky Linux 8.10 (`Operation not permitted`), so the comparison uses the path of the
`maps` entry. It reads the file that lies at that path when the comparison runs; it does not read the memory of the IOC.

## Report of a resolved library

Neither `check.deps`, which counts files with runpath defects, nor `check.env`, which checks `LD_LIBRARY_PATH`, reports the library that a
name resolves to. A check that resolves a library is to report its key and, when the metadata has one, its fingerprint:

```
libasyn.so -> asyn-4.46.0 lib/linux-x86_64/libasyn.so buildid ce0ebac3242d...
libre2.so -> unidrv-0.5.1 lib/linux-x86_64/libre2.so | unidrv-e5a8561 lib/linux-x86_64/libre2.so buildid 68109e4f501b...
```

The second line shows a build-id that has two owners: the report names both, and the key that the loader selected decides
which one the IOC uses.

## Limits

- The record and the comparison are specified here; the scripts that write the record and the loader that compares are not
  changed by this page.
- The comparison covers libraries that lie under the tree. A library that the system supplies, such as `libc.so.6`, is not
  in the record.
- A library loaded by a consumer other than the loader, for example by a Python extension, is not covered.
- The rules are measured on Debian 13 and Rocky Linux 8.10.
