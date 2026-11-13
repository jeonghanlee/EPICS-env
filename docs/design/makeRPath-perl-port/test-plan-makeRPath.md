# makeRPath.pl - Test Plan

## Scope

`makeRPath.pl` decides the search path of every shared library and program
that a build with `LINKER_USE_RPATH=ORIGIN` links. Its contract has two parts:

- **Text**: the `-Wl,-rpath-link` and `-Wl,-rpath` entries on stdout, which the
  build captures with `$(shell ...)`, and the exit status. The reference is the
  upstream `makeRPath.py` of the Base pin: a run passes when the exit status
  and the stdout bytes equal those of the Python original for the same command
  line, working directory, and environment.
- **Meaning**: the entries lead the dynamic loader from the installed file to
  each dependency, in place and after the tree is copied.

The script under test is `src/tools/makeRPath.pl`, added by
`patch/7.0.10-site04-makerpath-perl.p0.patch`. It needs Perl 5.10.1, the
minimum of EPICS Base, and the core module `Cwd`. The tests run it under every
interpreter named in `MAKERPATH_PERLS`, with and without `-CSD`, which is the
`PERL` of the Base build.

## Instruments

| Instrument | What it runs | What a pass shows |
| --- | --- | --- |
| `tools/makerpath/compare_makeRPath.pl` | The chosen command lines, `MAKERPATH_FUZZ` generated ones (default 1500, fixed seed), and one fifth as many generated ones with directory names that start with `..`, through `makeRPath.py` and `makeRPath.pl`; the script is also called by the `make` statements of the build | Same exit status and stdout bytes, except where the reference takes a name that starts with `..` for the parent directory; the warning about the final directory appears in both or in neither; every printed entry resolves, from the final directory, to the dependency it was printed for, and every dependency has an entry; a write error, a removed working directory, and the debug line behave as specified; the build log shows the error and the command line, or the warning and its consequence |
| `tools/makerpath/scenario_makeRPath.pl` | The inputs that the Base build gives it (14 scenarios) with an expected text derived by hand from the rules of the build and from the example in the comment of `makeRPath.py`, and, when an installed tree built with `makeRPath.py` is given, the `RUNPATH` of every ELF file of that tree | Each scenario prints its expected text with the expected message; the run path of each ELF file is printed again, in order; without a tree that group is skipped and the report says so |
| `tools/makerpath/link_makeRPath.pl` | Links two shared libraries and a program with the printed flags in six layouts, and runs the program with the loader | The loader resolves the installed program without `LD_LIBRARY_PATH`, by its physical path and by its build name, and after the whole tree is moved; the flags, link status, and outcome equal those with `makeRPath.py` except in the layout of a directory named with leading dots |
| `tools/makerpath/replay_makeRPath.pl` | The `makeRPath` calls recorded from a Base build, through both scripts | Same exit status, stdout, and stderr for every recorded call |
| Base build comparison | Base with the patches built twice into the same install path, once with `makeRPath.py` and once with the `site04` patch and a `python` and `python3` that fail and record their calls | Both builds finish, the Perl build calls neither command, the lists of installed files differ only by `makeRPath.py` against `makeRPath.pl`, and the `RUNPATH` and `NEEDED` lines of every installed ELF file are equal |
| Module build comparison | One clone of this repository built twice by the flow in the install location of the machine (Base, sequencer, sscan, calc, asyn, autosave, busy), once without and once with the `site04` patch and a failing `python` and `python3`; the `makeRPath` calls of the module builds are recorded | The dynamic sections of all installed ELF files and the file lists are equal apart from the script names, the Perl build calls neither command, the recorded calls of both builds are the same set and a replay through both scripts is identical, and every distinct call belongs to a class of the input and output scenarios |
| `test/tools/makeRPath.plt` (in the patch) | Under `make runtests` of Base, the installed script on the inputs of the build (the 14 scenarios), the option forms, `EPICS_DEBUG_RPATH`, and a symbolic link that changes the depth of an entry; 24 cases, each checked on stdout, exit status and stderr, with no reference script | Every check passes under the Perl that runs the tests; the expected texts are the ones derived from the build rules, so the test needs no `makeRPath.py` |
| Patch round trip | Every `7.0.10-*` patch applied in name order on a fresh Base clone, then reverted in reverse order with `tools/revert_patch.bash` | Both legs exit 0 and the tree returns to its original state, without `makeRPath.pl` |

## Chosen command lines

| Group | Content |
| --- | --- |
| Option forms | Attached values (`-Fvalue`, `-F=value`), long names and their abbreviations, `--name=value`, repeated options, options after, between, and around paths, `--`, a lone `-`, negative numbers, a value that starts with `-`, upper and lower case, missing values, unknown options, `-h` with and without other letters |
| Defaults | `-F` absent, working directory through a symbolic link, at `/`, below the root |
| Path algebra | Leading `//`, `///`, and `////`; inner repeated slashes; `.` and `..` components above the root and in the root; names that start with `..`; the root `/`; trailing separators; newline, tab, quote, backslash, and trailing spaces in names; roots with empty parts; 5000-character and 300-path lines; duplicates after normalizing |
| Origin | Empty, absolute, relative, with one or two trailing slashes, and a leading `//` |
| Encodings | UTF-8 names in paths, root, final directory, origin, and working directory, a four-byte character, a combining mark, and, in the `C` locale, bytes that are not UTF-8 |
| Environment | `EPICS_DEBUG_RPATH` as `YES`, `yes`, and empty |
| Generated | A fixed generator builds paths below the working directory, the roots, and the final directory, with option forms, order, and invalid words chosen at random; the summary counts the outcomes of the reference (entries under a root, relative entries, entries outside every root, final directory outside every root, usage errors) |

## Input and output scenarios

The directory layout is a root `R` with `base`, `modules/<name>-<version>`, and `vendor`; the origin is passed as the
build passes it, a backslash and `$ORIGIN`. The expected text is derived from the rules of the Base build
(`configure/RULES_BUILD`, `configure/os/CONFIG.Common.UnixCommon`, `configure/os/CONFIG.Common.linuxCommon`) and, for the
roots, from the example in the comment of `makeRPath.py`; it is never taken from an output.

| Scenario | Claim |
| --- | --- |
| S1 | A library of Base links against its own directory: a link entry and `$ORIGIN/.` |
| S2 | A program of Base reaches the library directory two levels up |
| S3 | A module library reaches Base four levels up and itself in place |
| S4 | A module program reaches Base, a sibling module, and its own library |
| S5 | A vendor library inside the root is relative |
| S6 | A system directory outside the root is absolute and has no link-time entry |
| S7 | A test product runs in its build directory, outside the root: absolute entries and a warning |
| S8 | A tree named through a real symbolic link prefix keeps the prefix as written |
| S9 | An IOC installed outside the root gets absolute entries and a warning |
| S10 | The build tree and the install tree as roots give one relative entry for a library in either (the example of the comment of `makeRPath.py`) |
| S10b | The same with the final directory in the build tree |
| S11 | A directory named with leading dots directly below the root is relative |
| S12 | A cross target keeps its own architecture directory |
| S13 | A directory named twice gives one entry |

Several roots are tested although this repository and Base do not use them: the script documents them.

The installed-tree group rebuilds the input of each ELF file that has a `RUNPATH` from the place of the file and from that
`RUNPATH`, and requires that the printed run path be the recorded one. It supports that the script reproduces the text
that `makeRPath.py` recorded for the production paths; it does not support that the recorded text is right, which the link
test and the audit of the tree cover. The directory lists that a build of modules computes from `RELEASE.local` are covered
by the module build comparison, for the subset of modules it builds.

## Coverage not exercised by the module build

- Directory classes that the subset does not produce: vendor libraries, system directories, and directories outside the root.
- The whole `make build`, other operating systems, static builds, and cross toolchains.
- `libCap5.so` is installed twice and the copy below `lib/perl` finds neither `libca` nor `libCom` through its `RUNPATH`; the Python-built and the Perl-built tree are equal in this, so the loader check of the comparison is not clean for it.

## Proof that the checks can fail

For each of the three tests and the unit test, scratch mutations of `makeRPath.pl` were run with the failing checks of each mutation written
before the series, the unchanged script run first, and the file that ran bound to the recorded hash. Where a prediction
was wrong, the old prediction and the correction were recorded and the same mutation was run again. One mutation changes
no output because the code cannot run.

## Link layouts

| Layout | Expected result |
| --- | --- |
| `plain` | Loads in place and after the move |
| `dependency-outside-root` | Loads in place and after the move; the outside directory keeps an absolute entry |
| `tree-named-through-a-link` | The build names the tree through a symbolic link; loads in place and after the move |
| `version-link-same-depth` | A module directory is a symbolic link to a directory of the same depth; loads in place and after the move |
| `directory-named-with-leading-dots` | A directory named `..data` directly below the root holds a library; with `makeRPath.pl` the program loads in place and after the move, with `makeRPath.py` it loads in place and not after the move |
| `version-link-different-depth` | A module directory is a symbolic link to a deeper directory; the loader does not resolve the program with either script, and `makeRPath.pl` warns on stderr |

## Differences from `makeRPath.py`

`makeRPath.pl` keeps the options, the path functions, the stdout text, and the exit statuses of `makeRPath.py`,
and improves on it where the reference breaks the purpose of the script. Each difference, its reason, and
the test that pins it are in the table of `7.0.10-site04-makerpath-perl` in `patch/README.md`; in short:

- It writes bytes unchanged whatever `-C` options `PERL` carries, because `perl -CSD` encodes the output a
  second time.
- It exits with status 1 when writing the result fails, also when stdout is closed.
- It passes bytes that are not UTF-8 through, where Python 3 stops in a UTF-8 locale.
- A directory directly below a root whose name starts with `..` gets a relative entry; the reference takes
  it for the parent directory and prints an absolute entry. For command lines that contain such a name the
  comparison requires the property check of the script under test instead of equal output.
- It warns on stderr when a symbolic link makes a `$ORIGIN` entry reach another directory than the one
  printed for. stdout is unchanged.
- The warning that the final directory is outside every root names its consequence, and each error is
  followed by the command line of the call. The text of the reference is not compared; the comparison requires
  that the warning appears in both or in neither, and that an error names itself and the command line.

## Behavior shared with `makeRPath.py`

- A help flag bundled with other letters (`-hF`) is handled differently by different Python versions; the
  runs are counted and compared only when `MAKERPATH_HELP_BUNDLE=1`, which holds for Python 3.13.
- The help text equals that of Python 3.13 and is compared only when `MAKERPATH_HELP_TEXT=1`.

## How to run

Run from the top of an EPICS-env clone, after `make patch` has applied the
patches to `epics-base-src`:

    perl tools/makerpath/compare_makeRPath.pl
    perl tools/makerpath/link_makeRPath.pl

The unit test inside the patch runs with the Base build:

    make -C epics-base-src/test/tools runtests

`MAKERPATH_PY` and `MAKERPATH_PL` name the reference and the script under test
for another layout, `MAKERPATH_PERLS` lists the interpreters (for example
`"perl /path/to/perl-5.10.1/bin/perl"`), and `MAKERPATH_FUZZ` and
`MAKERPATH_SEED` set the generated lines. To record the calls of a build, run
`make` with `MAKERPATH` set to a script that appends the working directory, the
argument count, and the arguments, each followed by NUL, to a file and then
runs `makeRPath.py`; replay the file with

    perl tools/makerpath/replay_makeRPath.pl <recording>

The Base build comparison and the patch round trip use scratch clones of
`epics-base-src` and never the checkout that `make` builds.
