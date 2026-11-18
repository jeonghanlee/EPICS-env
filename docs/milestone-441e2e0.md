# Work Register

Release line: master
Milestone index: 441e2e0
Canonical path: `docs/milestone-441e2e0.md`
Canonical branch or ref: master
Git upstream: origin/master
Remote tracker: jeonghanlee/EPICS-env; the open issues are in the GitHub milestone Backlog

Next session entry point: M1, M2, M3, M5, M6, M12, M13 and M19 are complete and their issues are closed, and M24, which has no issue, is complete; M4 (#99) is deferred until the development of `opcua-server-sim` is finished with the gate G1 open; the owner set M7 (move EPICS Base to R7.0.11) aside for now, and it stays Not started; a container-based test server for the IOC checks that need a server is the Open backlog item M22 (D23); the next release uses the skill `patch` of the `dev-env` repository for its patch work, which is the Open backlog item M23 (D29); the implementation that follows M12 (identity of shared libraries by build-id) is the row M20, which is complete (#144): a build-id per library in `cfg/build-record` of format 2, a comparison in `iocsh.bash` before the IOC starts, and the exit statuses 64 and 78 are commit `49c5a4d`, and the six CI systems passed; the form of the vendor record, which the wrapper repositories asked about, is decided (D31, D32); from the next release the vendor sources are pinned by tag (D20), and the gate G2 is complete: both wrapper repositories write the vendor record in the decided form (D31, D32) and carry a tag of the new form on that commit (`uldaq-env` `1.2.2-1`, `open62541-env` `1.3.15-2`), so M21 is no longer blocked and is Not started, and every installation of the vendor libraries then names the tag; what the loader does with a vendor record is not decided and has no row yet; M13 (reccaster as a new module next to recsync, issue #101) is complete: the CI of all six systems failed from the commit that added the module (`0291307`) because the audit of module dependencies marked `reccaster.dbd`, which both modules own, as unknown, and passes since the fix (D24, commit `6e35b28`), and #101 is closed; M24 (take the changed revert tool of the skill `patch`, D30) is complete: the tool, its record and the document lines are commit `2ad1ad0` on `origin/master`, and every check passed (T1 to T7); the Ready rows are M7, which the owner set aside, and M21.

This document carries unfinished work after release 1.5.0. Completed results remain in the prior state named in History. Work continues on master with no release branch (D2), and the rows are taken in table order.

## Milestone

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| M1 | Port Python utilities to Perl | Milestone | Complete | No | D2, D5, D6, D7, D12 | The scoped tools, the two embedded helpers and their callers run without Python and match the existing results; [detail](#m1---port-python-utilities-to-perl) |
| M2 | Replace makeRPath.py in EPICS Base with Perl | Carry-forward | Complete | No | D2, D5, D8, D9, D10 | Base builds without Python through the Perl makeRPath and the rpath values match; [detail](#m2---replace-makerpathpy-in-epics-base-with-perl) |
| M3 | Minimal-example record counting | Carry-forward | Complete | No | D2, D13 | [Completion criteria](#m3---minimal-example-record-counting) |
| M4 | opcua-server-sim as the OPC UA example default | Carry-forward | Deferred | No | D2, D14, D15, G1 | The OPC UA loader example runs against `opcua-server-sim` built from source, with real example verification; [detail](#m4---opcua-server-sim-as-the-opc-ua-example-default) |
| M5 | Global IOC startup for common services | Carry-forward | Complete | No | D2, D16 | A global startup file loads the intended common services with a switch for each and passes their integrated verification; [detail](#m5---global-ioc-startup-for-common-services) |
| M6 | Lua database loading without macros | Carry-forward | Complete | No | D2, D17 | The real IOC with lua loaded survives a database load without macros, with a carried patch and verification evidence; [detail](#m6---lua-database-loading-without-macros) |
| M7 | Move EPICS Base to R7.0.11 | Milestone | Not started | Yes | D2, D3 | Each Base patch is settled for the new pin and Base builds from it; [detail](#m7---move-epics-base-to-r7011) |
| M8 | Re-examine pvxs with the Base move | Milestone | Not started | No | D3, M7 | The pvxs pin and patches are settled and pvxs builds on the new Base; [detail](#m8---re-examine-pvxs-with-the-base-move) |
| M9 | Update modbus to R3-5 | Milestone | Not started | No | D2, D3, M7, M8 | The module cycle passes on both test machines; [detail](#m9---update-modbus-to-r3-5) |
| M10 | Carry the uldaq-env timeout and alarm patches | Milestone | Not started | No | D2, D3, M7, M8 | Both patches are built and loaded through the vendor preparation; [detail](#m10---carry-the-uldaq-env-timeout-and-alarm-patches) |
| M11 | Move measComp to the jeonghanlee fork | Milestone | Not started | No | D2, D3, M7, M8 | The measComp cycle and the TC32 reconnection checks pass; [detail](#m11---move-meascomp-to-the-jeonghanlee-fork) |
| M12 | Shared-library version identification | Carry-forward | Complete | No | D2, D18, D19 | [Completion criteria](#m12---shared-library-version-identification) |
| M13 | Migrate recsync to reccaster | Carry-forward | Complete | No | D1, D2, D22, D24 | [Completion criteria](#m13---migrate-recsync-to-reccaster) |
| M14 | Load pyDevSup through the IOC loader | Carry-forward | Deferred | No | D4 | [Completion criteria](#m14---load-pydevsup-through-the-ioc-loader) |
| M15 | Patch revert on macOS | Carry-forward | Deferred | No | D4 | [Completion criteria](#m15---patch-revert-on-macos) |
| M16 | Original OPC UA demo startup data | Carry-forward | Deferred | No | D4 | [Completion criteria](#m16---original-opc-ua-demo-startup-data) |
| M17 | Libera cross-build and generated profile | Carry-forward | Deferred | No | D4 | [Completion criteria](#m17---libera-cross-build-and-generated-profile) |
| M18 | Insert `on error break` in `iocsh.bash` when the startup file has none | Carry-forward | Open | No | D2 | [Completion criteria](#m18---insert-on-error-break-in-iocshbash-when-the-startup-file-has-none) |
| M19 | Base unit test of makeRPath.pl | Milestone | Complete | No | D2, D8, D11, M2 | `test/tools/makeRPath.plt` runs under `make runtests` of the patched Base on Perl 5.10.1, 5.26.3 and 5.40.1 and each case is shown able to fail; [detail](#m19---base-unit-test-of-makerpathpl) |
| M20 | Record library fingerprints in the loader metadata and check them at start | Milestone | Complete | No | D18, D19, D25, D26, D27, M12 | `cfg/build-record` carries a build-id for each library (format 2, with a digest), `iocsh.bash` refuses a start whose module libraries differ from it, and the tests pass on both test machines; [detail](#m20---record-library-fingerprints-in-the-loader-metadata-and-check-them-at-start) |
| M21 | Pin the vendor library sources by tag | Milestone | Not started | Yes | D20, D21, G2 | The OS workflows and the scripts that install the vendor libraries use `uldaq-env` and `open62541-env` at pinned tags, with a pin variable for each and verification on both test machines; [detail](#m21---pin-the-vendor-library-sources-by-tag) |
| M24 | Take the revert tool from the patch skill | Milestone | Complete | No | D28, D30 | `tools/revert_patch.bash` is the revert tool of the skill `patch` with a record of its origin beside it, the documents state its exit statuses, and the round trip of the patch set passes on both test machines and in CI; [detail](#m24---take-the-revert-tool-from-the-patch-skill) |
| G1 | open62541-env changes committed | External gate | Open | No | | The changes that `opcua-server-sim` needs in `open62541-env` (`CMAKE_EXTRA_OPTIONS` support and `patch/1.5.10.p0.patch`) are committed in that repository; [detail](#g1---open62541-env-changes-committed) |
| G2 | uldaq-env and open62541-env pin tags | External gate | Complete | No | | Each of the two repositories has a tag that names the source of the vendor library version that EPICS-env pins, with the commit recorded by its owner; [detail](#g2---uldaq-env-and-open62541-env-pin-tags) |

Tally: 24 items, 11 Complete (M1, M2, M3, M5, M6, M12, M13, M19, M20, M24 and the gate G2), 6 Not started (M7 through M11 and M21), 2 Open (M18 and the gate G1) and 5 Deferred (M4 and M14 through M17). Ready: M7 and M21. One gate is open (G1). The Backlog holds two Open items (M22 and M23).

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Keep recsync at 9834b94edc63eece42712b8355a4703d4286dd8f until the separately scoped client migration. From 1.10.0 the recsync repository contains a stub client Makefile that exits 1; the client moved to ChannelFinder/reccaster, whose 1.9.7 commit bebf91f54faf93a59eb4538d3594a687a8823963 has no shared history with the pin. The repository switch is module source work tracked by #101. | 2026-11-11 |
| D2 | Continue on master with no release branch and no release. Take the rows in table order, the lightest first and one at a time, and hand the work over when enough of it is complete. The release number and the tie of the Base pin to a publication date, recorded in the prior state, are not carried. | 2026-11-11 |
| D3 | Move EPICS Base from `tags/R7.0.10` to `tags/R7.0.11` as a work item (M7) and examine the pvxs pin and patches together with it (M8). | 2026-11-11 |
| D4 | Defer M14 through M17 and place them after the other rows: they need a pyDevSup exploration that is not yet scoped, a macOS machine, a registered download of the Unified Automation example server, or a real nine-module cross-build. A new dated decision returns one of them to Not started. | 2026-11-11 |
| D5 | Convert every Python script that this repository authors (M1) and the one Python script of EPICS Base, makeRPath (M2), to Perl first. Start the Base work on the pin `R7.0.10`, because the files it touches are identical in `R7.0.11`. Keep the Python environment requirements of the build configuration until a later decision, because pyDevSup (M14) needs them. | 2026-11-11 |
| D6 | Fix every robustness finding (a), (e), (f) and (g) of M1 step 7, each with a check that fails on the unfixed code. Finding (b) is removed by the port, (c) is covered by the Perl test, and (d) is applied. | 2026-11-12 |
| D7 | Start and stop the IOC of the caPutLog verifiers with `ioc-runner --local` instead of launching it directly. | 2026-11-12 |
| D8 | Carry `makeRPath.pl` only inside `patch/7.0.10-site04-makerpath-perl.p0.patch` as a new file of the Base source, keep its tests in `tools/makerpath`, and remove the copy and the shell driver of `docs/design/makeRPath-perl-port`. Test the script against `makeRPath.py` and, beyond it, by linking and loading real libraries, on Perl 5.10.1, the minimum of EPICS Base. | 2026-11-12 |
| D9 | Where `makeRPath.pl` differs from `makeRPath.py` it is stricter, and `patch/README.md` records each difference with its reason: bytes written unchanged whatever `-C` options `PERL` carries, a non-zero status when writing fails, bytes that are not UTF-8 passed through, a relative entry for a directory directly below a root whose name starts with `..`, a warning for a symbolic link that changes the depth of an entry, and messages that name the consequence and the command line. The options, the path functions, the stdout text, and the exit statuses of the reference are otherwise kept. | 2026-11-12 |
| D10 | Check the inputs of a real build of modules by building the same commit twice, once with `makeRPath.py` and once with the patched `makeRPath.pl`, in the fixed install location of the flow with side-by-side release directories, starting with the Rocky Linux 8.10 test machine and a subset of modules (base, sequencer, sscan, calc, asyn, autosave, busy); keep the trees and sources on the machine until the owner decides. | 2026-11-13 |
| D11 | Write the unit test of `makeRPath.pl` that the upstream review asked for as `test/tools/makeRPath.plt` in the form Base runs under `make runtests`, carry it inside `patch/7.0.10-site04-makerpath-perl.p0.patch` so that every Base build of this repository runs it, include the cases that pin the deliberate differences from `makeRPath.py` under their own names, and track it as a row of its own (M19) that depends on M2. The upstream PR stays outside M19. | 2026-11-13 |
| D12 | Accept that `tools/site-dependency-audit.pl` prints a sentence after `SITE-DEPENDENCY-STOP:` where the Python original printed the text of its Python exception, for a report with a missing key, a path that is a number, a report that is not an object, or invalid or empty JSON; exit status and the prefix are equal, and every refusal of a well-formed report prints the same text. | 2026-11-13 |
| D13 | Count the records of the minimal example from a file that the `dbl` command of the running IOC writes by redirection, not from the prefix of the log lines, and change the README line and the procedure sentence that promise a larger count on a machine without hwmon devices in the same commit. | 2026-11-14 |
| D14 | Make `opcua-server-sim` the default server of the OPC UA loader example, built from source at recorded revisions of it and of `open62541-env`; change the existing directory `examples/iocsh/opcua-IOC-demo` in place and keep its name; remove the Milo variant; remove the Unified Automation startup file and its no-server checks from the suite, because the server-stop case covers them; leave the container image and an application image to later changes. | 2026-11-14 |
| D15 | Defer M4 until the development of `opcua-server-sim` is finished (the owner reported on 2026-11-14 that the server is not yet at the level of an IOC); a new dated decision returns the row to Not started, and its plan and the gate G1 are then taken again. | 2026-11-14 |
| D16 | Ship `commonIocsh/iocsh/global.iocsh` for the common services with a switch token for each of `caPutLog`, `autosave`, `reccaster`, `linStatProc`, `linStatHost`, `linStatNIC` and `linStatFS`, on by default for `reccaster` and `linStatProc` (the services that describe this IOC alone) and off for the others; load the four parts of linStat directly because the aggregate `linStat.iocsh` cannot switch the host records off; leave `iocLog` (it loads before the device setup), `iocStatsAdmin` (it collides with linStat) and the serial fragments outside the file; the example IOC is the tc32sim IOC of the integrated verification. | 2026-11-14 |
| D17 | Fix the lua crash on a database load without macros by carrying the patch `01aa7a1-site01-database-hook-null-macros.p0.patch` applied by a `patch.lua.commit.apply` rule, in which `myDatabaseHook` skips `macParseDefns` when the macros are NULL (`dbLexRoutines.c`, `asLibRoutines.c` and `iocsh.cpp` in Base guard NULL before calling it, so the fix belongs to the caller); prepare a report for epics-modules/lua as a file and leave sending it to the owner. | 2026-11-14 |
| D18 | Identify an installed shared library by its module directory and release, its relative path and the GNU build-id that the linker already writes into it; keep the `SONAME` of the modules and change no module repository; identify Base by its own `SONAME`, with the two copies of `libCap5.so` (bare `SONAME`) as the documented exception identified by path and build-id; keep the `RUNPATH` rule of exact versioned module directories; record the build-id in the loader metadata with `format=2` (a `buildid=<relative path> <hex>` line for every library, `none` with a notice when a library has none); the vendor record is written by the wrapper repositories, whose owners are told, and not by this repository; the rules go on the new page `docs/src/concepts/shared-library-identity.md`. | 2026-11-14 |
| D19 | Stop the identity of shared libraries (M12) at the rules page, the inventory, the definition of the mapping and the scratch trial, and do the recording in the loader metadata (`format=2` with `buildid=` lines in `iocsh_metadata.bash`, its parser, `check` and tests) and the runtime check of `iocsh.bash` in a separate row M20 that starts when M12 is complete. | 2026-11-14 |
| D20 | Pin the vendor library sources by tag from the next release, as the module pins are: the wrapper repositories carry a tag for the exact source of the installed libraries (libuldaq 1.2.2 and libopen62541 1.3.15 for 1.5.0; `uldaq-env` has the tags 1.2.1 and 1.2.2, and `open62541-env` has had the tag 1.0.0 since 2026-11-14), and EPICS-env clones each at a pin variable instead of the default branch. The vendor libraries that the sandboxes of the test machines built earlier stay as built. | 2026-11-14 |
| D21 | Every installation of the vendor libraries names the tag of the wrapper repository: the CI workflows, `tools/prep-vendors.bash` and the sandboxes of the test machines whenever they are rebuilt. Close the gate G2 only when each wrapper owner has delivered the complete solution, the tag rule for later versions and the place and format of the build-id record, not when the first tags exist. | 2026-11-14 |
| D22 | Add `ChannelFinder/reccaster` at the tag `1.9.7` (`bebf91f`) as a completely new module `reccaster` of the module set (M13), next to the unchanged module `recsync`: the key and the loader macro are `RECCASTER`, and the module name, the source directory, the installed directory and the loader name are `reccaster`, the two modules exist side by side, the demo IOC of reccaster is not built (`SKIPDEMO=YES`), and the removal of `recsync` is a later decision. The first form of this decision (keep the key `recsync` and replace its source) was dropped on 2026-11-14 because the module name follows the source directory name in about twenty places of the module set. Check the status records of the fragment as for `recsync`; delivery to a recceiver is not checked here, and a container-based test server is the backlog item M22. | 2026-11-14 |
| D23 | Keep a backlog item M22 for a container-based test server, or a program, for the IOC checks that need a server, the recceiver first, built the way `opcua-server-sim` serves OPC UA, so that the IOC verification can use it besides the static and dynamic load checks; the owner gives the program and the examples of earlier work later. | 2026-11-14 |
| D24 | Fix the strict audit of module dependencies (`tools/audit_module_deps.bash`) for DB and DBD file names only: a module that owns a DB or DBD file is not given the finding `unknown` for that name when another module owns the same name, because the modules `recsync` and `reccaster` both own `reccaster.dbd` and the CI of the commit that added `reccaster` failed on all six systems with that finding. C sources, headers and libraries are not changed. | 2026-11-15 |
| D25 | Give the row M20 the form of one means per job: the GNU build-id of each installed shared object is recorded in `cfg/build-record` only; `iocsh.bash` compares, before it starts the IOC, the build-id of each module library it will load with that record and shows it in the `-n` listing; and the option `-l, --loader-debug` sets `LD_DEBUG=libs` for the `exec` of the IOC to show what the loader loads. `cfg/build-record` and `cfg/iocsh.conf` are two formats with their own format numbers, readers and writers: the record goes to format 2 and gets the digest file `cfg/build-record.sha256`, the conf stays at format 1 and is not changed, and a reader holds the list of format numbers it reads. This replaces the form of M12 in which both files got `buildid=` lines, a running IOC was read through `/proc/<pid>/maps`, and a tree of format 1 was refused; a tree of release 1.5.0 keeps starting. Only objects under `modules/` are judged; the treatment of vendor objects is discussed again when the wrapper repositories have finished their record. | 2026-11-16 |
| D26 | A start that names a module with a `module` directive is refused by `iocsh.bash` when a compared build-id differs from the record, when a record of format 2 does not match its digest, or when a module directory has no `cfg/build-record`; a record of format 1 is passed in silence. A startup file without a directive, and a start without a startup file, are passed to `softIocPVX` as today and are not compared. The wrapper ends with status 64 when its command line is wrong and with 78 when it refuses a start, the statuses of `softIocPVX` are not changed, and `-n` ends with the status a start would have. The handling of a refused start under `procServ` belongs to jeonghanlee/epics-ioc-runner#169. | 2026-11-16 |
| D27 | The build tool reads a build record of format 1 as well as of format 2: `generate` and `check` treat a record of format 1 as the tools of release 1.5.0 did and compare no build-id for it, and `record` always writes format 2. A refusal of format 1 would damage a working tree of that release, because `generate` removes `cfg/iocsh.conf` before its checks and `symlink.<module>` removes the unversioned link before `check` runs. The loader also refuses a record that claims format 1 beside a digest file, and the build tool refuses a record line with an empty key. The output of the option `-l` is not filtered; the loader prints the process number of the IOC first. | 2026-11-16 |
| D28 | The skill `patch` of the `dev-env` repository is the original for applying and reverting patches: its rules and its revert tool `scripts/revert_patch.bash`. From 2026-11-16 a change is made in the skill first, and every holder of a copy, this repository included, takes the change from the skill. On the morning of that date `tools/revert_patch.bash` of this repository and the skill file were byte for byte equal (sha256 `d99690bb8c7b5b87dfde842d53b6b5ffbd8c990e2f9e34d8a5f78bcde2823285`; the skill at `dev-env` commit `9603b9d`). The skill changed its file later that day (`dev-env` commits `fae340b` and `2ef69e7`: one set of exit statuses for both tools and the licence header of the owner; sha256 `a327a96e6a567e1189c8c5b492b7299816457d598cc44e1caa0f6d6222ae5276`), and this repository holds the earlier file until M24 takes the new one (D30). The skill also holds an apply tool, `scripts/apply_patch.bash`, which classifies a patch before it applies it; this repository does not use it (K21). The apply side of this repository stays the direct `patch` calls of the helpers in `configure/RULES_FUNC` and of the recipes in `configure/RULES_PATCH`, as `patch/README.md` describes them, and gets no tool that skips an applied patch (`docs/CLOSED_DOORS.md`, K21); the skill `makefile-modular` of the `dev-env` repository holds the general shape of these rules and shows the code of this repository as one instance, and the code of this repository is not replaced by a copy of that shape. Known holders of a copy of the revert tool on this date: this repository and the wrapper repository `open62541-env`. The procedure for selecting and carrying upstream fixes, `docs/procedures/upstream-fix-carry-procedure.md`, stays in this repository unchanged, because the releases verified it; its general stages are copied into the skill, with this document as the source of that copy. When real use of the skill shows that a part is served by the skill alone, that part leaves the repository document in a change of its own, part by part. | 2026-11-16 |
| D29 | The next release uses the skill `patch` of the `dev-env` repository for its patch work: selecting and carrying upstream fixes, applying and reverting the patch set, and the recovery after a second apply (M23). The apply stays the direct `patch` calls of this repository and not the apply tool of the skill (D28, `docs/CLOSED_DOORS.md` K21). The EPICS-env session reviewed the skill against this repository on 2026-11-16 and found the text in agreement; the reviews of that day covered the revisions up to `dev-env` commit `82443c1`, and the later commits `fae340b` and `2ef69e7` were read only for the facts about this repository and for their revert tool (M24). That review read the skill and did not run a carry with it, so the release is its first real use. For the rules and the revert tool the skill is the original (D28). The procedure document of this repository stays as it is, and where the skill's copy of that procedure and the document differ the document wins. | 2026-11-16 |
| D30 | This repository takes the changed revert tool of the skill `patch` now, in a row of its own (M24), instead of waiting for the next release: the tool is first run beside the present one on the patch families in scratch copies, and the change is verified on both test machines and in CI. The apply side stays as it is (D28). | 2026-11-16 |
| D31 | The vendor record has the form of the module record: each wrapper writes `vendor/cfg/<library name>/build-record` and its digest `vendor/cfg/<library name>/build-record.sha256` (`uldaq`, `open62541`), so that two wrappers never write one file. The keys, in this order, are `format`, `name`, `version`, `tag`, `source`, `upstream`, `patch` (one line per patch file), `arch`, and for each installed shared object `artifact=<path> <sha256>` followed by `buildid=<path> <hex or none>`, with paths relative to `vendor`; `name` and `version` are the library and its upstream version, `tag` and `source` the tag and the commit of the wrapper repository, and the module keys `base` and `dep` are left out. The vendor directory gets no `iocsh.conf`: the loader does not load a vendor library with `dlload`, the dynamic loader brings it in through the `NEEDED` entry and the `RUNPATH` of a module library (observed for `libuldaq.so.1` under measComp and `libopen62541.so.1` under opcua). The wrappers set no file mode (it follows the umask, as for the modules), create `vendor/cfg` and their own directory only when absent, write their record completely at each install through a temporary file that is renamed, and remove only their own directory at an uninstall. The record is a format of its own with its own number and starts at `format=1`; the number of the module record does not apply to it. Not decided here: the tag rule for later versions, what the loader does with a vendor record, and the values for an untagged or changed wrapper checkout. | 2026-11-17 |
| D32 | Values of the vendor record (D31) and the tag rule of the wrapper repositories. `tag` is the highest tag in version order that points at the checked-out commit of the wrapper repository, or `untagged`; `source` is that commit, followed by `+dirty` when a tracked file of the checkout is changed; both read `unknown` when git gives no answer. The file `configure/CONFIG_SITE.local` that this repository writes into a wrapper checkout is ignored by git there and does not make the checkout `+dirty`. Only a real shared object file gets an `artifact` and a `buildid` line; a symbolic link gets none, because the loader resolves a needed name to the real file. A `patch` line names one patch file that is applied to the upstream source; a source without an applied patch has no `patch` line, and `patch=unknown` stands for a state that cannot be determined. From the next tag on, a wrapper tag has the form `<upstream version>-<N>` (`1.2.2-1`, `1.3.15-2`); the existing tags `1.2.1` and `1.2.2` of `uldaq-env` and `1.0.0` of `open62541-env` stay. Still not decided: what the loader of this repository does with a vendor record. | 2026-11-18 |

### ID Migration

| Old ID | Current ID | Reason | Updated References |
| --- | --- | --- | --- |
| M6 | M2 | The row was moved to the second position so that both Python removals come first. | work table row, detail heading, detail links |
| M2 | M3 | Shifted by the move of M6. | work table row, detail heading, detail links |
| M3 | M4 | Shifted by the move of M6. | work table row, detail heading, detail links |
| M4 | M5 | Shifted by the move of M6. | work table row, detail heading, detail links |
| M5 | M6 | Shifted by the move of M6. | work table row, detail heading, detail links |

### Milestone Details

#### M1 - Port Python utilities to Perl

Origin: 441e2e0 / M1
Identity History: none
GitHub Issue: #140 (https://github.com/jeonghanlee/EPICS-env/issues/140)
Related issue: #25 (https://github.com/jeonghanlee/EPICS-env/issues/25), carried by M2. Both issues are worked together.
Status: Complete

##### Summary

Replace the Python scripts that this repository authors with Perl, so that its tools, its verification, and its installer need no Python runtime. The repository tracked seven Python files (1278 lines in all) and two Python helpers embedded in Bash tools. The Python environment that the build configuration requires stays until a later decision, because pyDevSup (M14) still needs it.

##### Scope

Replace `tools/tree-manifest.py`, `tools/verify_tree_manifest.py`, `tools/verify_test_trash.py`, `tools/linstat-carry/verify.py`, `tools/distribution-report.py`, `tools/verify_distribution_report.py` and `examples/commonIocsh/verify_caputlog.py`. Replace the JSON helper embedded in `tools/install-distribution.bash` (the site dependency audit) and the TCP port selection embedded in `examples/commonIocsh/tests/verify_caputlog.sh`. Keep the Bash entrypoints. Update callers, documentation, and the distribution skill instructions.

After a Perl tool matches its Python original, examine it for robustness defects. The owner decides which findings are fixed, tool by tool, in steps of their own.

Out of scope: `makeRPath.py` of EPICS Base (M2), pyDevSup (M14), the Python environment requirements that stay (the `python` and `python3` check of `tools/install-distribution.bash`, the `python3` check in `configure/CONFIG_MODS`, `PYTHON = python3` in `configure/RULES_BASE`, and `python3-pip` in `.github/workflows/rocky8.yml`), and the build requirements of upstream modules.

##### Completion Criteria

- The oldest supported Perl interpreter (5.26.3 on Rocky Linux 8.10) and the modules the tools load are confirmed on both test machines.
- Each Perl tool keeps the arguments, exit status, output contract, and recorded data format of its Python original, and existing manifest records stay readable.
- A real run of each Perl tool and of its Python original on the same fixtures gives the same observable results, and the failure-path coverage and the real IOC verification are retained.
- The site-enabled and site-disabled installer paths pass, including accepted source findings and rejected dependency failures.
- No Python invocation remains in the scoped tools, the two embedded helpers, and their callers, except the environment requirements listed above, and the documentation and prerequisites say so.
- Each robustness finding that the owner accepts is fixed, with a check that fails on the unfixed code.

##### Dependencies And Decisions

D2, D5, D6, D7 and D12 apply. M1 and M2 are the first two rows and do not wait for each other.

The distribution skill instructions outside this repository are updated: the `epics-env-pipeline` skill of the dev-env repository named the removed tools (`tools/tree-manifest.py`, `tools/distribution-report.py`, `python3 <report_tool>` and `python3 <manifest_tool>` calls, and the Python 3.7 note for `verify_caputlog.py`) in `SKILL.md`, `references/distribution.md` and `references/distribution-troubleshooting.md`, and since the dev-env commit f821412 (pushed 2026-11-13) it names the Perl tools, runs them with `perl`, and states that the caPutLog verifier needs `ioc-runner`, `procServ` and a user systemd session; the requirement of the installer for Python 3 stays. The owner of the dev-env repository ran the old and the new tools on the same installed tree before the change: the manifests and the debug reports are byte-identical. `verify_caputlog.pl` was not run end to end there; M1 / T5 covers it.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-11, revision with steps 7 and 8 and T7 accepted by the owner in chat; 2026-11-13, revision with steps 9 to 11 accepted by the owner in chat
Implementation Authorization: 2026-11-11, authorized by the owner in chat for the revised plan; 2026-11-13, authorized by the owner in chat for steps 9 to 11
Superseded Plan Artifacts: the plan of steps 1 to 6, accepted and authorized on 2026-11-11, before steps 7 and 8 and T7 were added; the plan of steps 1 to 8 before steps 9 to 11 were added

1. Measure the Perl version and the installed modules on both test machines with the probe of the `perl-coding` skill, and record the oldest interpreter.
2. Run each of the seven Python tools on real fixtures and keep its arguments, exit status, stdout, stderr, and written files as the reference.
3. Write each Perl replacement next to its original under the same base name with the suffix `.pl`, following the `perl-coding` rules, and replace the two embedded helpers.
4. Compare each Perl tool with the reference of step 2, then update the callers, the documentation, and the distribution skill instructions.
5. Remove each Python file with `git rm` only after its Perl replacement passes T2.
6. Run T3 to T6 and the unfiltered search for Python invocations.
7. For each Perl tool that matches its original, record robustness findings with their evidence and obtain the owner's decision on each finding before changing anything. Findings so far: (a) the tests of `tools/test-trash.bash` do not cover a failure of the bucket creation after the trash directory exists, and do not tell apart the refusal of `..` by name from its refusal by the nested-trash rule; (b) the Python verifier of the linStat carries reads its probe source through `Path(__file__)`, which is relative on Python before 3.9 and breaks after the working directory changes, and the manifest verifier and the linStat verifier need Python 3.7 and 3.9, which Rocky Linux 8.10 does not ship by default; (c) the Python manifest test did not detect a changed mode format, sort order, string escaping or size, which the Perl test detects; (d) the caPutLog verifiers needed a built example IOC, which the installed `iocsh.bash` replaces, a decision of the owner that is applied; (e) the caPutLog verifiers choose a free port and release it before the IOC uses it, so another process can take it in between and the IOC fails to start; (f) no test rejects a manifest mode with more or fewer octal digits than `distribution-report` accepts; (g) the linStat verifier does not check the C++ sanitizer runtime it needs before compiling, so a machine without it ends with a linker error.
8. For each accepted finding, add a check, show by a scratch mutation that it fails on the unfixed code for the intended reason, then fix the code and run the check again.
9. For T4, on the Debian 13 test machine, install a fresh clone of this repository at the current commit with `tools/install-distribution.bash` and the site checkout (the owner chose one real installation with the site modules, and the refusal cases through the audit helper), keep the existing checkout and tree untouched, and record the audit output, the phase times and the hashes; the Rocky Linux 8.10 machine follows after the Debian result.
10. Run the audit helper and the Python original (from `27c0725^`) on one-change variations of the real strict report and compare exit status and messages; run `--plan` with and without the site checkout.
11. Record the result as T4 and its unresolved coverage in this detail and in the text of #140; each commit and push waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Baseline | the `perl-coding` probe of the interpreter and the modules | Debian 13 and Rocky Linux 8.10 test machines | the oldest interpreter is 5.26.3 and every module the tools load is present |
| T2 | Comparison | each Perl tool and its Python original on the same real fixtures | Debian 13 and Rocky Linux 8.10 test machines | stdout, exit status, and written files are identical |
| T3 | Compatibility | an existing manifest record read by the Perl `tree-manifest` and a Perl record read by the Python original | Debian 13 and Rocky Linux 8.10 test machines | the records round trip without change |
| T4 | Installer | `tools/install-distribution.bash` with the site modules enabled and disabled, with an accepted source finding and a rejected dependency failure | Debian 13 and Rocky Linux 8.10 test machines | exit status and messages match the Python helper |
| T5 | IOC | `examples/commonIocsh/verify_caputlog.py` replacement with real EPICS processes | Debian 13 and Rocky Linux 8.10 test machines | the same checks pass as with the original |
| T6 | Absence | a search without extension filters of the scoped files for Python invocations, and T2, T3 and T5 with `python` removed from `PATH` | Debian 13 and Rocky Linux 8.10 test machines | no Python invocation remains outside the listed requirements, and the three checks pass |
| T7 | Robustness | the check of each accepted finding, first on the unfixed code through a scratch mutation and then on the fixed code | Debian 13 and Rocky Linux 8.10 test machines | the check fails on the unfixed code and passes after the fix |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-12 07:05 to 16:51 UTC | Debian 13 and Rocky Linux 8.10 test machines | Passed | The `perl-coding` probe of the 21 modules that the shipped tools load found all of them on both machines; a first probe of a wider list found only `Time::Piece` absent on Rocky Linux 8.10, which no tool uses. The oldest interpreter is Perl 5.26.3. The Python of Rocky Linux 8.10 is 3.6.8. |
| T2 | 2026-11-12 07:47 to 08:28 UTC | local Debian 13 with Python 3.13.5, and both test machines | Passed, with the limits named in Evidence | `tree-manifest`: stdout and exit status equal to the Python original in 11 cases on all three hosts, byte for byte including invalid UTF-8 names. `distribution-report`: 204 cases equal on real manifests, a real debug scan, and 14 evidence sets locally (the first 188 held no invalid mode; the 3 invalid-mode cases that T7 added found a defect, now fixed), and 27 cases equal on each machine. The linStat `verify` report equals the original in all 72 commands once ASLR addresses, build identifiers and live network counters are masked, and the Perl verifier passes on both machines (its report holds 73 commands after T7; the added probe of the C++ sanitizer runtime is left out of the comparison). The caPutLog summary equals the original byte for byte with a built example IOC. The two Perl test suites pass on both machines (49 and 73 tests). Scratch mutations of the code under test: the Python and Perl tests catch the same mutants for `test-trash` (7 of 9), the caPutLog fragment (4 of 4) and `distribution-report` (6 of 7), and the Perl manifest test catches 12 of 12 where the Python test catches 6 of 10. For linStat the changes were made to the expected values of the verifier itself (7 changes), and the Python and Perl verifiers fail at the same command in all 7. Limits: the Python original of the linStat verifier, the distribution verifier and the caPutLog verifier ran only locally, because Rocky Linux 8.10 ships Python 3.6.8 and the distribution evidence is bound to the local tree; `verify_distribution_report.pl` (88 tests after T7) ran only locally. |
| T3 | 2026-11-12 08:01 UTC | local Debian 13 | Passed | The Perl manifest of a real 722828-byte installed tree equals the Python manifest byte for byte, and both `distribution-report` implementations report no difference between the recorded Python manifest and the Perl manifest. |
| T4 | 2026-11-13 | Debian 13 (Perl 5.40.1) and Rocky Linux 8.10 (Perl 5.26.3) test machines | Passed, with the limits named in Evidence | On each machine a fresh clone of this repository at commit 71e3a61efcf8 ran `tools/install-distribution.bash` with the vendor checkouts and the site checkout (site modules unidrv and siteApps) to the end, `INSTALLED` and `INSTALL-END rc=0`, in about 20 minutes (the whole `make build` of EPICS-env 12 and 11 minutes); the installer is sha256 e96b9826028fbdef and the helper `tools/site-dependency-audit.pl` 2b804c11ca003c00. The `check.module-deps` step of the site checkout ran for real and passed with status 0 and no findings, so the helper was not called by the real runs; the 3 installed ELF files of the site modules resolve in the loader without `not found` and `make exist.modules` lists the site modules. `--plan` prints 22 steps with the site checkout and 15 without it, none of them a site step. The helper and the Python original (extracted from `27c0725^`) were run on 22 one-change variations of the real strict report (4 accepted, 18 refused, `work/makerpath/t4/variations.py`), the expected status of each written before the run: all 22 give the expected exit status, equal for both, and 16 give equal output. The other 6 differ only in the text after `SITE-DEPENDENCY-STOP:`, where the original prints the text of its Python exception (a missing key name, the type error for a number, the error for a report that is a list, the JSON parser text for truncated or empty input) and the helper prints a sentence (decision D12). Limits: the real runs did not exercise the helper; a site-disabled installation was not run, only its `--plan`; a refusal was not triggered through the installer itself; on Rocky Linux the original ran under Python 3.12 because the system Python 3.6.8 lacks `subprocess.run(capture_output=...)` of the comparison script. Three earlier attempts on Debian 13 stopped before the audit for reasons of the preparation (checkouts copied with sources that `make init` refuses, then a site checkout whose module sources had been cleaned and cannot be cloned on the machine), not of the installer. |
| T5 | 2026-11-12 08:28 to 19:00 UTC | local Debian 13 (ioc-runner 1.4.1), a new Debian 13 machine (ioc-runner 1.4.2, EPICS-env 1.5.0), and, before the ioc-runner change, both test machines | Passed, with the limit named in Evidence | `verify_caputlog.pl` passes all six cases and `verify_caputlog.sh` passes its three checks, locally and on the new Debian 13 machine, with each IOC started and stopped by `ioc-runner --local` through the installed `iocsh.bash` and no IOC built. The cases and received-message counts equal those of the Python original run against a built example IOC. Limit: Rocky Linux 8.10 has no `ioc-runner` and no `procServ`, so the ioc-runner version did not run there; the direct-launch version passed on both machines before D7. |
| T6 | 2026-11-12 08:29 and 19:00 UTC | local Debian 13 | Passed | No tracked `.py` file remains. A search of the scoped files without extension filters finds `python` only in the kept environment checks of `tools/install-distribution.bash` and in compatibility notes of comments. Ten checks ran with a `python` that records every call and fails, again after the ioc-runner change; all exited 0 and the call log holds no entry. The run was not repeated on the machines. |
| T7 | 2026-11-12, up to 19:00 UTC | local Debian 13, a new Debian 13 machine, and Rocky Linux 8.10 (before D7) | Passed, with the limits named in Evidence | (a) `verify_test_trash.pl` gained a case for an unwritable trash and a case that refuses `.` and `..` by name with the trash outside the source (85 tests); two scratch mutations are caught. (e) A held-port test makes the first IOC start fail and checks the restart on a new port, the kept log of the failed start, and, after the ioc-runner change, that no IOC configuration or unit is left (12 tests); the unmutated baseline passed first, and 4 Perl and 4 shell scratch mutations each fail for the intended reason. (f) `verify_distribution_report.pl` rejects 7 invalid mode forms and accepts `0o0` and `0o7777` (88 tests); the new check found that `distribution-report.pl` accepted invalid modes through a list-context defect, which is fixed, and 2 scratch mutations are caught. (g) `check_sanitizer_runtime` stops `linstat-carry/verify.pl` with a named prerequisite before compiling (6 tests in `verify_prerequisites.pl`); 3 scratch mutations are caught. Limits: the ioc-runner version of (e) ran locally and on the new Debian 13 machine only; the checks of (a) and (g) also passed on both Debian 13 and Rocky Linux 8.10 machines before D7; the check of (f) ran only locally. |

##### Closure Evidence

Observed 2026-11-14 at 01:50 UTC: every change of this detail is on `origin/master` (the last one is commit c538a3c, and the local HEAD equals `origin/master`, with no differing path); issue #140 is CLOSED as completed (closed 2026-11-14 at 01:49 UTC), its body has every criterion checked, and the distribution skill instructions of the dev-env repository name the Perl tools (dev-env commit f821412). Recheck with `gh issue view 140 -R jeonghanlee/EPICS-env --json state,closedAt`.

#### M2 - Replace makeRPath.py in EPICS Base with Perl

Origin: 441e2e0 / M6
Identity History: M6 -> M2
GitHub Issue: #25 (https://github.com/jeonghanlee/EPICS-env/issues/25)
Related issue: #140 (https://github.com/jeonghanlee/EPICS-env/issues/140), carried by M1. Both issues are worked together.
Status: Complete

GitHub state observed: CLOSED as completed on 2026-11-14 at 01:49 UTC. Recheck with `gh issue view 25 -R jeonghanlee/EPICS-env --json state,closedAt`.

##### Summary

The only Python script of EPICS Base is `src/tools/makeRPath.py`. `configure/CONFIG_BASE` runs it as `MAKERPATH = $(PYTHON) $(TOOLS)/makeRPath.py`, and `PYTHON = python` in `configure/CONFIG_COMMON` is the only other Python reference in `configure` and `src/tools`. On 2026-11-12 UTC, `src/tools/makeRPath.py`, `src/tools/Makefile` and `configure/CONFIG_BASE` are identical in `R7.0.10` and `R7.0.11`. `docs/design/makeRPath-perl-port` holds the issue text and the test plan; the Perl port is carried by `patch/7.0.10-site04-makerpath-perl.p0.patch` and its tests are in `tools/makerpath`.

##### Scope

Create an independent `makeRPath.pl` carried by this repository, starting from the port in `docs/design/makeRPath-perl-port`, and a Base patch for the pin `R7.0.10` that points `MAKERPATH` at it, so that Base is built without Python. The Base move (M7) renames the patch for `R7.0.11`. The first plan step settles where the file lives and how the patch reaches it.

Out of scope: the upstream submission, the `EPICS::Path` primitives, the Python requirements of the build configuration that pyDevSup (M14) still needs, and the Base move itself (M7).

##### Completion Criteria

- `makeRPath.pl` gives the same stdout and exit status as `makeRPath.py` for the cases of `docs/design/makeRPath-perl-port/test-plan-makeRPath.md`.
- Base builds from the pin `R7.0.10` with the patch and without running Python, and the installed libraries carry the same rpath and runpath as a build with `makeRPath.py`.
- The patch applies and reverts on a fresh clone.

##### Dependencies And Decisions

D2, D5, D8, D9 and D10 apply. M1 and M2 are the first two rows and do not wait for each other. The patch is named for `R7.0.10` and M7 renames it.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-13, revisions with steps 6 to 8 and T4, and with steps 9 to 11 and T5, accepted by the owner in chat
Implementation Authorization: 2026-11-13, authorized by the owner in chat for the revisions with steps 6 to 8 and with steps 9 to 11
Superseded Plan Artifacts: the plan of steps 1 to 5, accepted and authorized on 2026-11-11, before steps 6 to 8 and T4 were added

1. Read `docs/design/makeRPath-perl-port` (the issue text lists the regressions of the earlier port, and the test plan lists the cases) and carry the corrected port forward.
2. Settle where `makeRPath.pl` lives in this repository and how the Base patch points `MAKERPATH` at it.
3. Write `makeRPath.pl` following the `perl-coding` rules, and write the Base patch for `R7.0.10` following the patch naming rules.
4. Run the comparison driver, then build Base and compare the installed rpath and runpath values.
5. Run the patch round trip on a fresh clone.
6. Write the input and output test `tools/makerpath/scenario_makeRPath.pl`: the scenarios of the build (the expected text derived by hand from the rules of the Base build and from the example in the comment of `makeRPath.py`) and the optional check of an installed tree built with `makeRPath.py`; run it under every Perl on both machines.
7. Prove each check of that test, and of the comparison and link tests, by a scratch mutation whose intended failing checks are written before the series is run, with the unchanged script run first.
8. Update the test plan, the program list, and this detail; each commit and push waits for its own trigger.
9. On the Rocky Linux 8.10 test machine, in the install location that the flow uses, build base and the modules sequencer, sscan, calc, asyn, autosave, and busy from one commit of this repository into two trees that differ only in the release directory: variant A with `makeRPath.py` (the patch `7.0.10-site04-makerpath-perl.p0.patch` left out of a scratch clone) and variant B with the patch and a failing `python` first on `PATH`. Run the flow as it is (`make init`, `patch`, `conf`, `build.<module>`, `install`, `symlinks`) and replace the installed `makeRPath` of each tree after base is installed by a stub that records the working directory, the argument count, and the arguments of every call and runs the original. Measure the time of the first variant and report before the second if it is long.
10. Compare the dynamic sections of every installed ELF file of the two trees, the recorded calls of the two builds, the replay of the calls through both scripts, the resolution of each installed file of variant B by the loader without `LD_LIBRARY_PATH`, and the assignment of each distinct call to a class of the input and output test; repeat on the Debian 13 machine after the first result.
11. Record the result as T5 and its unresolved coverage in this detail and in the text of #25; each commit and push waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Comparison | `tools/makerpath/compare_makeRPath.pl` with the real `makeRPath.py` of the pin and `makeRPath.pl`, and `tools/makerpath/link_makeRPath.pl` with real libraries, under Perl 5.10.1 and the Perl of each machine | Debian 13 and Rocky Linux 8.10 test machines | stdout and exit status are identical for every chosen and generated command line, every printed entry reaches its dependency, and the loader resolves the linked program in place and after a copy |
| T2 | Build | a clean Base build with the patch and a failing `python` first on `PATH`, then `readelf` on the installed files against a build with `makeRPath.py`; and the `makeRPath` calls of a real build replayed through both scripts | Debian 13 and Rocky Linux 8.10 test machines | the build succeeds, no Python call is recorded, and the rpath and runpath values are identical |
| T3 | Patch round trip | the patch apply and revert legs on a fresh clone | Debian 13 and Rocky Linux 8.10 test machines | both legs exit 0 and the tree returns to its original state |
| T4 | Input and output | `tools/makerpath/scenario_makeRPath.pl`: the scenarios of the build with expected text derived from the rules, and the optional check of the `RUNPATH` of every ELF file of an installed tree built with `makeRPath.py` | Debian 13 and Rocky Linux 8.10 test machines, under Perl 5.10.1, 5.26 and 5.40 | every scenario prints its expected text with the expected message, and each recorded `RUNPATH` is printed again |
| T5 | Build of modules | one commit of this repository built twice by the flow in the install location of the machine (releases `1.5.0-makerpath-py` and `1.5.0-makerpath-pl`): the dynamic sections of all installed ELF files, the recorded calls of `makeRPath` replayed through both scripts, the resolution by the loader without `LD_LIBRARY_PATH`, and the class of each distinct call | Rocky Linux 8.10 test machine, then the Debian 13 test machine | the file lists and dynamic sections are equal apart from `makeRPath.py` against `makeRPath.pl`, every call is answered alike, no file is unresolved, and every distinct call belongs to a class of the input and output test or is listed |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-12 | local Debian 13 (Perl 5.40.1 and 5.10.1, Python 3.13.5) and the Rocky Linux 8.10 test machine (Perl 5.26.3, Python 3.9.25) | Passed, with the limits named in Evidence | `compare_makeRPath.pl`: 118 chosen and 3000 generated command lines (seeds 1, 777, 5, 31337, 20261112) give the same exit status and stdout bytes as `makeRPath.py` under Perl 5.40.1 and 5.10.1, each with and without `-CSD`, apart from the differences recorded in `patch/README.md` (600 more generated lines carry names that start with `..`); on the Rocky machine the same set passes under Perl 5.26.3 (seed 20261112). The comparison also checks that every entry reaches its dependency, that a write error exits non-zero, that the build log shows the error with the command line or the warning with its consequence when the script is called by the `make` statements of the build, and that a temporary directory that cannot take 1 MB stops the run before any result is judged. Of 31 scratch mutations of `makeRPath.pl`, 30 fail the checks intended for them, written before the series was run (comparison, or `link_makeRPath.pl` with 38 checks over 6 layouts, linking and loading real libraries in place, by build name, and after the whole tree is moved), and 1 changes no output because the code cannot run. For two mutations the intended checks were first predicted wrongly and were corrected after the failing checks were examined, one needed Perl 5.10.1 in the series, and one (a dropped empty part of the root list) failed only generated command lines until the chosen cases `empty-root-*` were added. Limits: the comparison does not cover a help flag bundled with other letters (Python 3.13 and 3.6 differ), a directory name that starts with `..` for the entry check, and the text of usage errors; `link_makeRPath.pl` ran on the Rocky machine under Perl 5.26.3 (38 checks) and locally under Perl 5.40.1 and 5.10.1 (64 checks). |
| T2 | 2026-11-12 | local Debian 13 and the Rocky Linux 8.10 test machine | Passed | Base R7.0.10 with all `patch/7.0.10-*` patches built into the same install path twice. Python build and Perl build both finished; the Perl build recorded no `python` or `python3` call; the dynamic sections of the 24 installed ELF files (Debian 13) and 40 (Rocky Linux 8.10) are equal; the file lists differ only by `makeRPath.py` against `makeRPath.pl`. With a failing `python`, the build with `makeRPath.py` stops. The 139 `makeRPath` calls of a Base build (19 distinct) give identical stdout under Perl 5.40.1 and 5.10.1, the same warnings about the final directory, and no error or symbolic link warning. The build logs of Python and Perl builds hold the same number of warnings about the final directory: 116 on Debian 13 and 221 on Rocky Linux 8.10. The installed Python-built tree of 1.5.0 holds 171 ELF files with 359 relative and 6 absolute run paths; all relative entries reach existing directories inside the tree and the loader resolves every needed library without `LD_LIBRARY_PATH`. The build of modules was not repeated. |
| T3 | 2026-11-12 and 2026-11-13 | local Debian 13 and the Rocky Linux 8.10 test machine | Passed | All 22 `patch/7.0.10-*` patches apply in name order to a fresh Base source, and `tools/revert_patch.bash` reverts them in reverse order: on Debian 13 the clone is clean and `makeRPath.pl` is gone; on the Rocky machine `diff -r` finds the tree identical to the original. |
| T4 | 2026-11-13 | local Debian 13 (Perl 5.40.1 and 5.10.1), and the Debian 13 and Rocky Linux 8.10 test machines (Perl 5.40.1 and 5.26.3, Python 3.13.5 and 3.6.8) with the built tree of each | Passed, with the limits named in Evidence | The 14 scenarios (S1 to S13 and S10b) print the text derived by hand from the rules of the Base build and from the example in the comment of `makeRPath.py`, with the expected message: 113 checks locally under both Perls, 57 on each machine. The expected texts were written before the first run and all agreed; the original differs only on the directory named `..data`, which is the intended difference. The installed-tree group reproduces the recorded `RUNPATH` of every ELF file that has one: 167 files of the local tree and 198 files of the tree of each machine (4 vendor files have none). 12 scratch mutations of the script fail the checks intended for them, written before the series with the unchanged script run first and the run bound to the hash of the mutated file; for 4 of them (the one on `relpath`, the one on absolute directories, the one on the first root, and the one on the join) the prediction was wrong or incomplete, the failing checks were examined and the mutations were run again after the correction. Limits: the directory lists that a build of modules computes are not covered; the installed-tree group reads the text that `makeRPath.py` recorded and inverts the formula between a relative entry and its directory, so it does not show that the recorded text is right; the group is optional and runs only where a built tree exists. |
| T5 | 2026-11-13 | Rocky Linux 8.10 test machine (Perl 5.26.3, Python 3.6.8) and Debian 13 test machine (Perl 5.40.1, Python 3.13.5) | Passed, with the limits named in Evidence | One clone of this repository at commit 07b62438efc4 was built twice on each machine by the flow (`make init`, `patch`, `conf`, `build`) for Base R7.0.10 with sequencer, sscan, calc, asyn, autosave and busy, in the install location of the machine, as releases `1.5.0-makerpath-py` (patch `7.0.10-site04-makerpath-perl` left out) and `1.5.0-makerpath-pl` (patch applied, failing `python` and `python3` first on `PATH`). On both machines the dynamic-section dumps of the two trees are byte-identical (1001 lines on Rocky Linux, 898 on Debian), the file lists (1441 entries each) differ only by `makeRPath.py` against `makeRPath.pl`, the Perl build made 0 calls of `python` or `python3`, the recorded module calls of both builds are the same 50 distinct calls, and `replay_makeRPath.pl` reports every recorded call identical (107 recorded calls of each variant on Debian, 0 mismatches). Every distinct call belongs to a class of the input and output test: installed shared library 21, installed program 21, test product 8 as the final directory; Base library directory 48, own directory 42, sibling module library directory 22 as dependency; none of no class. Limits: the loader check is not clean, because `libCap5.so` (Perl binding of Base) lists `libca.so` and `libCom.so` as not found in both variants on both machines, equal in the Python-built and the Perl-built tree and so a property of Base and not of the script; the completion criterion that no file is unresolved is therefore not met literally, and the equality of the unresolved lists is what the result rests on; no vendor library, no system directory and no directory outside the root appeared among the dependencies of the subset, so those classes were not exercised by a build; the whole `make build`, other operating systems, static builds and cross toolchains were not run. The sources (about 1.5 GB) and the trees (about 0.5 GB) of both variants stay on both machines until the owner decides (OD4). |

##### Closure Evidence

Observed 2026-11-14 at 01:50 UTC: every change of this detail is on `origin/master` (the patch `7.0.10-site04-makerpath-perl.p0.patch` with its unit test, the tests in `tools/makerpath`, and the results; the last commit is c538a3c, and the local HEAD equals `origin/master`, with no differing path); issue #25 is CLOSED as completed (closed 2026-11-14 at 01:49 UTC) with every criterion of its body checked. The coverage that the module build did not reach (vendor libraries, system directories and directories outside the root, the whole `make build`, other operating systems, static builds and cross toolchains) is listed in T5 and in the test plan.

#### M3 - Minimal-example record counting

Origin: 441e2e0 / M2
Identity History: M2 -> M3
GitHub Issue: #136 (https://github.com/jeonghanlee/EPICS-env/issues/136)
Status: Complete

##### Summary

A guest without `/sys/class/hwmon` adds linStat error lines to the count

##### Scope

Make the line `records listed` of `examples/iocsh/tests/verify_minimal_example.bash` count the records of the IOC only. The verifier counts every line of the normalized IOC log that begins with `EPICSENV:`, and linStat diagnostic lines can share that prefix; the README of the suite expects five more on a machine without hwmon devices. Change the verifier, the README line and the sentence of the loader verification procedure that refers to it.

Out of scope: implementation beyond this retained item, the linStat fragment, the wrapper, the other verifiers, and changes to published release tags.

##### Completion Criteria

- The minimal-example count includes records only, including on a machine without hwmon devices: it equals the number of names that `dbl` lists, with and without them.
- The linStat diagnostic lines stay in the log and under `suspicious lines`, and every other check of the verifier behaves as before.
- The README and the procedure page no longer promise a larger count on a machine without hwmon devices.

##### Dependencies And Decisions

D2 and D13 apply.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-14, accepted by the owner in chat with the recommended decisions
Implementation Authorization: 2026-11-14, authorized by the owner in chat
Superseded Plan Artifacts: none

1. Run the unchanged verifier on the local Debian 13 machine (hwmon devices present) and on one test machine (the directory `/sys/class/hwmon` holds no entry), keep output and log, read the shape of the diagnostic lines, and stop and report if the count is not wrong on the second machine.
2. Check in the IOC of the verifier that the redirection `dbl > <file>` writes exactly the record inventory.
3. Change the verifier to count that file (D13), and change the README line and the procedure sentence.
4. Run the changed verifier on both machines and compare with step 1 after masking times, process ids and live values.
5. Run a scratch copy of the changed verifier without the redirection and require that the check on the machine without hwmon devices detects it.
6. Record the results here and in the text of #136; each commit and push waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Before, with devices | the unchanged verifier, real IOC and clients | local Debian 13 | `records listed` equals the number of names in the `dbl` output |
| T2 | Before, without devices | the unchanged verifier | one test machine | the observed count and the shape of the diagnostic lines; the count differs from the `dbl` names when the issue is real |
| T3 | After, without devices | the changed verifier | the same test machine | `records listed` equals the `dbl` names; the diagnostic lines remain in the log and under `suspicious lines` |
| T4 | After, with devices | the changed verifier | local Debian 13 | the number of T1 |
| T5 | Nothing else moved | output of the changed verifier against the unchanged one, times, process ids and live values masked | both machines | only the line `records listed` differs, and only without devices |
| T6 | Check can fail | a scratch copy of the changed verifier without the redirection | the test machine | the count is wrong again and T3 detects it |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-14 | local Debian 13 (hwmon devices present, 9 entries) | Passed | The unchanged verifier (sha256 8d5387b004e8fe66) with the real IOC and clients prints `records listed: 322`; the normalized log holds 322 `EPICSENV:` lines, all of them names without a space, and `suspicious lines` is `none`. |
| T2 | 2026-11-14 | local Debian 13 in a private mount namespace without `/sys/class/hwmon` (`work/makerpath/m3-nohwmon.bash`) | Passed (the issue is reproduced) | The unchanged verifier prints `records listed: 327`: 322 names and 5 lines with a space (`EPICSENV:T_MAX ERROR operator() : Not param temp_max` and four like it for `T_LOC_MAX`, `FAN_CNT`, `FAN_NRUN`, `FAN_NFAIL`), and `suspicious lines` lists those 5 and one `Tbl hwmon:localhost ERROR first : filesystem error ... [/sys/class/hwmon]` line. The test machines and a freshly created Debian 13 guest all have the directory with 0 entries and give 322, so the namespace stands in for a machine where the directory does not exist; only the filesystem view changes, the IOC and the clients are the real ones. |
| T3 | 2026-11-14 | local Debian 13 in the mount namespace; Debian 13 test machine in the namespace and with the empty directory | Passed | The changed verifier (sha256 0808c329fb452744) prints `records listed: 322` in each case; the file written by `dbl` holds 322 lines and none with a space; the `suspicious lines` section (6 error lines) is identical to that of the unchanged verifier and the log still holds them. |
| T4 | 2026-11-14 | local Debian 13 (hwmon devices present) | Passed | The changed verifier prints `records listed: 322` and the file written by `dbl` holds 322 lines. |
| T5 | 2026-11-14 | local Debian 13 with and without the namespace | Passed, with the limit named in Evidence | Times, process ids and live values masked, the full output of the changed verifier differs from that of the unchanged one in 3 lines in each environment: the trash timestamp, the echo of the added `dbl > <file>` command on the IOC console, and the masked values; the line `records listed` changes from 327 to 322 without the directory and stays 322 with it, and the `suspicious lines` section is identical. Limit: on the Debian 13 test machine only the changed verifier ran, so the comparison with the unchanged one was made locally. |
| T6 | 2026-11-14 | local Debian 13 in the mount namespace | Passed | A scratch copy of the changed verifier without the redirection (sha256 e26e20398ccbd8c2) prints `records listed:` with no number and a `No such file` error, so the expected `322` of T3 is not met. The verifier itself does not assert the count; the reference is the README line. |

##### Closure Evidence

Observed 2026-11-14 at 05:03 UTC: every change of this detail is on `origin/master` (the verifier, the README line and the procedure sentence in commit 18c4645, the results in commit a0472df; the local HEAD equals `origin/master`, with no differing path); issue #136 is CLOSED as completed (closed 2026-11-14 at 05:03 UTC) with every criterion of its body checked. The environment without `/sys/class/hwmon` was a private mount namespace, as T2 records. Recheck with `gh issue view 136 -R jeonghanlee/EPICS-env --json state,closedAt`.

#### M4 - opcua-server-sim as the OPC UA example default

Origin: 441e2e0 / M3
Identity History: M3 -> M4
GitHub Issue: #99 (https://github.com/jeonghanlee/EPICS-env/issues/99)
Status: Deferred

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 99 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

The OPC UA loader example runs against an open-source server so that the documented example needs no proprietary server file and no container tool. The owner decided on 2026-11-14 that the server is `opcua-server-sim` (https://github.com/jeonghanlee/opcua-server-sim, Apache-2.0, a C server on open62541 with the model `s7-1500-composite` and an IOC startup and databases of its own), built from source; the client is the installed distribution, the IOC with the `opcua` device support module. The example today has a startup file for the Unified Automation demo server and one for the Eclipse Milo demo server, and its verification starts the Milo container. The planning detail is `work/plan-opcua-sim-default.md` of the working copy; the decisions that matter are in D14.

##### Scope

Change the existing directory `examples/iocsh/opcua-IOC-demo` in place, keeping its name, so that it holds the example for `opcua-server-sim`: a preparation script that places the server and `open62541-env` at recorded revisions with `examples/iocsh/checkout_application.bash` and builds them, the startup file and databases for the composite model, the README, the test in `examples/iocsh/tests/verify_fixture_opcua.bash`, the book page and the expected output of the suite. Remove the Milo variant (`st-milo.cmd`, the container steps, the README section) and the Unified Automation startup file and its no-server checks. Observe IOC restart without a server restart, and server stop and start, and document the observed behavior.

Out of scope: the container image of the simulator (the move to it is a later change), the idea of one binary in an application image, an imitation of Unified Automation nodes, an implicit upgrade of the `opcua` or open62541 modules, Alarms and Conditions events and method calls (the module does not use them), and the original Unified Automation startup data (M16).

##### Completion Criteria

- The documented default example prepares, builds the server and connects without a proprietary server file or a container tool on Debian 13 and Rocky Linux 8.10.
- Server identity, device support, subscription updates, values, timestamps, alarms and bounded reads are checked through the real installed module and IOC.
- IOC restart and server restart have observed results, and a limitation that remains is accepted and documented.
- Startup path, preparation, documentation and the shipped suite agree, and no unexecuted check of another server is presented as a result of this one.

##### Dependencies And Decisions

D2, D14 and D15 apply. D15 defers the row until the development of the simulator is finished; a new dated decision returns it to Not started. G1 holds the changes that the simulator needs in `open62541-env`; until they are committed there, a recorded revision pair cannot name a reproducible build, so G1 is also complete before the plan runs.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Observe on Debian 13 and Rocky Linux 8.10 that the simulator builds with the current `open62541-env` pin plus patch and that its `t/ioc.t` passes against the distribution tree; record revisions and times.
2. After G1 is Complete, record the revision pair of the simulator and `open62541-env`.
3. Write the fixture in place: preparation script, startup file, databases, README, test; remove the Milo and Unified Automation files and steps.
4. Run T1 and T2 on both machines, then T3 and T4, and write the observed behavior into the README.
5. Update the expected output of the suite, the README and the book page (T5), search for false claims (T6), and run the scratch mutations (T7).
6. Record the results here and in the text of #99, whose title changes from Milo to the simulator; each commit and push waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Preparation | the preparation script on a clean run directory, then the build of open62541 and the server at the recorded revisions | Debian 13 and Rocky Linux 8.10 test machines | exits 0 without a proprietary file or a container tool; the checkouts are at the recorded revisions and unmodified |
| T2 | Server identity and data | the server and the IOC through `iocsh.bash`; `caget` of identity, scalar, structure, array and timestamp records, a subscription update, an alarm severity and a bounded read | both machines | each value, timestamp and severity equals what the server was configured to give; the update arrives within the bound |
| T3 | IOC restart | stop the IOC and start it again without restarting the server | both machines | the second session connects, with no `INVALID` and `COMM` |
| T4 | Server restart | stop the server, observe, start it, observe | both machines | the recorded recovery behavior; any limitation is stated in the README |
| T5 | Agreement | startup path, preparation, README, book page and the expected output of the suite compared | local checkout | they name the same files, variables and results |
| T6 | No false claim | a search of the README, book page and test for statements about checks of another server | local checkout | none presents an unexecuted check of another server as a result of this one |
| T7 | Checks can fail | scratch mutations: a wrong node id in a database, a stopped server, a wrong revision | one test machine | each makes the intended check fail |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |
| T2 | Not run | both machines | Pending | none |
| T3 | Not run | both machines | Pending | none |
| T4 | Not run | both machines | Pending | none |
| T5 | Not run | local checkout | Pending | none |
| T6 | Not run | local checkout | Pending | none |
| T7 | Not run | one test machine | Pending | none |

##### Closure Evidence

None.

#### M5 - Global IOC startup for common services

Origin: 441e2e0 / M4
Identity History: M4 -> M5
GitHub Issue: #79 (https://github.com/jeonghanlee/EPICS-env/issues/79)
Status: Complete

GitHub state observed: CLOSED as completed on 2026-11-14 at 09:35 UTC. Recheck with `gh issue view 79 -R jeonghanlee/EPICS-env --json state,closedAt`.

##### Summary

The fragment set of `commonIocsh` ships without a global startup file, and the common services are verified loading together by the integrated suite (`examples/commonIocsh/tests/verify_integrated.sh`). An IOC loads each fragment by its own `iocshLoad` today. The owner decided on 2026-11-14 that one global file offers the services that are used most, with a switch for each, and that it leaves out `iocLog`, `iocStatsAdmin` and the serial fragments. The planning detail is `work/plan-global-iocsh.md` of the working copy; the decisions are in D16.

##### Scope

Add `commonIocsh/iocsh/global.iocsh`, which loads `caPutLog`, `autosave`, `reccaster` and the four parts of `linStat` (`linStatProc`, `linStatHost`, `linStatNIC`, `linStatFS`) in the verified order after the IOC's device setup, with a switch token for each (`CAPUTLOG_ENABLE`, `AUTOSAVE_ENABLE`, `RECCASTER_ENABLE`, `LINSTATPROC_ENABLE`, `LINSTATHOST_ENABLE`, `LINSTATNIC_ENABLE`, `LINSTATFS_ENABLE`); `reccaster` and `linStatProc` are on by default, the others are options. Change the integrated verification so that the example IOC (the tc32sim IOC of that verification) loads the services only through the global file, add the cases of the plan, and update the book page, the macro reference, the example README and the text of #79.

Out of scope: `iocLog`, `iocStatsAdmin` and the serial fragments (an IOC loads them itself), changes to the individual fragments, the `caPutLog-shell.cmd` example, the move of `commonIocsh` to its own repository (#76), and changes to published release tags.

##### Completion Criteria

- An IOC that loads the services only through `global.iocsh` boots with each switched-on service working, loads nothing for a switched-off one, and has no duplicate records, on Debian 13 and Rocky Linux 8.10.
- The defaults load only the `reccaster` and `linStatProc` records.
- The process part of `linStat` works without the host records.
- The book page, the macro reference, the example README and the file header agree, and state that `iocLog`, `iocStatsAdmin` and serial are outside the file.

##### Dependencies And Decisions

D2 and D16 apply.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-14, accepted by the owner in chat
Implementation Authorization: 2026-11-14, authorized by the owner in chat
Superseded Plan Artifacts: none

1. Run the unchanged `verify_integrated.sh` on both test machines and keep the evidence (T1).
2. Settle with scratch startup files that a switch token per service turns a service on when passed empty and off otherwise (H1), that the service macros pass through the global file (H2), and that `linStatProc` boots without the host records (H3). Settled on 2026-11-14: a local `softIoc` with scratch fragments showed that a token with the default `#--` is off until passed empty, that a token with an empty default is on until passed `#--`, and that the macros given to the outer `iocshLoad` and the environment are visible in the nested one (H1, H2); the process-only boot of T5 settled H3.
3. Write `global.iocsh` with a header that states the order, the switches and defaults, the macros each service needs, and that `iocLog`, `iocStatsAdmin` and serial are outside it.
4. Change the integrated verification to load the services only through the global file and add the cases of T3 to T6.
5. Run T2 to T6 on both machines and compare with T1.
6. Update the book page, the macro reference and the example README (T7), and run the scratch mutations (T8).
7. Record the results here and in the text of #79, whose body changes because the serial part falls away; each commit and push waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Baseline | the unchanged `verify_integrated.sh` | Debian 13 and Rocky Linux 8.10 test machines | the existing assertions pass before the change |
| T2 | All on | boot with every switch on | both machines | `iocInit` completes; linStat, reccaster, autosave (save and restart restore) and caPutLog work as in T1; no duplicate records |
| T3 | Defaults | boot with only the defaults | both machines | only the `reccaster` and `linStatProc` records load; the other services leave no record and no command |
| T4 | Each off | for each service, a boot with that switch off and the others on | both machines | that service's records and commands are absent; the others work |
| T5 | linStat parts | the process, host, NIC and filesystem switches on and off, including a boot with only the process switch on | both machines | each part's records appear exactly when its switch is on; the process records work without the host records |
| T6 | No duplicates | `dbl` of each boot sorted and compared for repeated names | both machines | no name appears twice |
| T7 | Documentation | the book page, the macro reference, the example README and the file header compared | local checkout | they name the same file, switches, defaults and order, and state what is outside the file |
| T8 | Checks can fail | scratch mutations of the global file: a service left out, a switch inverted, a service always on | one machine | each makes the intended check fail |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-14 | Debian 13 and Rocky Linux 8.10 test machines, Perl and Bash of the machines | Passed | The unchanged `verify_integrated.sh` (sha256 50378e9fe465f0da) from a scratch clone of this repository at commit 0a889c6753ee, with a scratch clone of tc32sim at 61645aeb78f9 and the installed tree of each machine (autosave 6.0.0, caPutLog 4.2.0, iocStats 4.0.1, linStat 1.2.1, recsync 9834b94): 13 of 13 checks pass on each machine. |
| T2 | 2026-11-14 | both machines | Passed | The changed `verify_integrated.sh` (sha256 af698fec45401e4a) with `global.iocsh` (sha256 5e5b240f3daf18fc) in the aggregate boot, all seven switches on and `iocLog` and serial loaded by the IOC: `iocInit` completes, the linStat host, process, NIC and filesystem records and the reccaster records are present, record names resolve, no collision, the log server receives the boot messages, caPutLog initializes, autosave writes `values_pass1.sav`, and the restart restores the autosave set; 22 of 22 checks pass on each machine. |
| T3 | 2026-11-14 | both machines | Passed | The boots with no switch set (the minimal boot and the boot `defaults`) leave only the `reccaster` and the `linStatProc` markers: `State-Sts` and `IOC_` records present, no `SYS_`, `NET:lo`, `ROOT:` or autosave record, no caPutLog line. |
| T4 | 2026-11-14 | both machines | Passed | For each of the seven services a boot with that switch off and the other six on: exactly the other six leave their markers (a record name pattern, or the caPutLog success line for caPutLog) and that one does not, `iocInit` completes. |
| T5 | 2026-11-14 | both machines | Passed | The boot with only the process part on (`reccaster` switched off) completes and leaves only the `IOC_` records, so the process records work without the host records; each linStat part's records appear exactly when its switch is on (T4 covers the host, NIC and filesystem switches). |
| T6 | 2026-11-14 | both machines | Passed | In each of the nine boots of case D the sorted record list holds no repeated name and the log holds no `already exists` or `duplicate record` text. |
| T7 | 2026-11-14 | local checkout | Passed | A script compared the seven switch names, defaults and the file each loads between the lines of `global.iocsh`, its header, the concept page, and the macro reference: all agree, and the order sentence of the concept page matches the file. The procedure page names every switch and says that `iocLog.iocsh` and `serial.iocsh` are not loaded by the file; the header and the concept page state that `iocLog`, `iocStatsAdmin` and the serial fragments are outside it. The expected output and the prose of the verification suite page and of the verification procedure were brought to the new output (22 checks). The integrated script stops with one FAIL line that names the missing file when `global.iocsh` is absent from the `commonIocsh` directory it uses (checked with an installed tree that predates the file), and the documents state that the two default services need their modules and that the tree must hold `global.iocsh`. |
| T8 | 2026-11-14 | Debian 13 test machine | Passed | Six scratch mutations of `global.iocsh` (the caPutLog line removed, the autosave line removed, `RECCASTER_ENABLE` defaulting to off, `LINSTATHOST_ENABLE` defaulting to on, the NIC switch ignored, the process line removed), the failing checks of each written before the series (`work/scratch/m5/mutations.json`), the unmutated file run first (22 of 22) and each run bound to the hash of the file it used: each mutation fails the checks intended for it. The first table named the checks by the text of their PASS lines, which a failing check does not print; the same checks were named by their FAIL text and the series was run again with the same mutations. |

##### Closure Evidence

Observed 2026-11-14 at 09:57 UTC: every change of this detail is on `origin/master` (the file, the integrated verification and the documents in commit 1c829b2, the results in commit 6162138; the local HEAD equals `origin/master`, with no differing path); issue #79 is CLOSED as completed (closed 2026-11-14 at 09:35 UTC) with every criterion of its body checked; its body states that serial settings are outside the file. Recheck with `gh issue view 79 -R jeonghanlee/EPICS-env --json state,closedAt`.

#### M6 - Lua database loading without macros

Origin: 441e2e0 / M5
Identity History: M5 -> M6
GitHub Issue: #137 (https://github.com/jeonghanlee/EPICS-env/issues/137)
Status: Complete

##### Summary

An IOC that loads the lua module ends with a segmentation fault when the lua database hook receives NULL as the macros of a database load. Base passes NULL for an omitted argument (`dbLoadRecords "file"` in iocsh), `myDatabaseHook` in `luaApp/src/libs/ldatabaselib.cpp` hands it unchanged to `macParseDefns`, which calls `strlen` on it. Lua code reaches the same hook with NULL through `db.loadRecords` without macros or with an empty table and through `db.loadTemplate` with an empty entry. Observed on 2026-11-14 with the installed lua `01aa7a1`; the lua revision of the 1.4.0 release is affected as well, according to the issue. The planning detail is `work/plan-lua-null-macros.md` of the working copy; the decisions are in D17.

##### Scope

Stop `myDatabaseHook` from calling `macParseDefns` when the macros are NULL, carry that change as a patch of the pinned lua source with its provenance recorded, and verify with the real IOC that the four calls above complete and that loads with an explicit empty string and with macros still work. Prepare, but do not send, a report for epics-modules/lua.

Out of scope: a change of `macParseDefns` in Base, the upstream message itself, other lua hooks or macro callers beyond `myDatabaseHook`, lua revisions other than `01aa7a1`, and changes to published release tags.

##### Completion Criteria

- The real IOC with lua loaded survives `dbLoadRecords` without macros and the Lua calls `loadRecords` without macros, `loadRecords` with an empty table and `loadTemplate` with an empty entry, with the patch applied; the records are usable.
- Loads with an explicit empty string and with non-empty macros work with and without the patch.
- The patch applies and reverts through `make patch` and `make patch.revert`, and `patch/README.md` records its case, effect, reproduction, change, result, and upstream status.

##### Dependencies And Decisions

D2 and D17 apply.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-14, accepted by the owner in chat
Implementation Authorization: 2026-11-14, authorized by the owner in chat
Superseded Plan Artifacts: none

1. Run T1 on both test machines with scratch startup files and a one-record database file, and settle H1 and H3; stop and report if no crash is observed or the hook is not reached. Use `luaRunString` for the Lua calls.
2. Write the patch `01aa7a1-site01-database-hook-null-macros.p0.patch` and a `patch.lua.commit.apply` rule modelled on the autosave and linStat rules.
3. Build lua from the patched source in a scratch checkout and run T2 and T3 on both machines.
4. Run T4, T5 and T6.
5. Prepare the upstream report as a file; record the results here and in the text of #137; each commit, push and any upstream message waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Reproduction | the IOC with the installed unpatched lua and, one IOC start each, `dbLoadRecords "<db>"` without macros and `luaRunString` with `loadRecords("<db>")`, `loadRecords("<db>", {})` and `loadTemplate("<db>", {{}})` | Debian 13 and Rocky Linux 8.10 test machines | each IOC ends with a segmentation fault in the hook, before `iocInit` |
| T2 | Fix | the same four startup files with lua built from the patched source | both machines | each call completes, `iocInit` completes, `caget` of the record of the database answers |
| T3 | Macros paths | loads with `dbLoadRecords "<db>", ""` and with `"<db>", "P=x:"`, and from Lua with `loadRecords("<db>", {P="x:"})` and `loadTemplate("<db>", {{P="x:"}})`, with and without the patch | both machines | each completes and the records carry the macro values |
| T4 | Patch flow | `make patch` and `make patch.revert` on a fresh checkout of lua | local and one machine | the patch applies, builds, and reverts to the pinned source |
| T5 | Checks can fail | a scratch copy of the patched source with the guard removed | local | T2 fails with the crash of T1 |
| T6 | Documentation | the `patch/README.md` row and entry, the list of patches in the docs, and the report text for upstream name the same revision and files | local checkout | they agree |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-14 | Debian 13 and Rocky Linux 8.10 test machines | Passed | With the installed unpatched `lua-01aa7a1` and a one-record database file, through `iocsh.bash` (`module lua`), one IOC start each: `dbLoadRecords "t.db"` without macros, and `luaRunString` with `loadRecords("t.db")`, `loadRecords("t.db", {})` and `loadTemplate("t.db", {{}})` each end with a segmentation fault (exit 139) before `iocInit`; the four controls (`dbLoadRecords` with `""` and with `"P=x:"`, `loadRecords` and `loadTemplate` with a macros table) complete with the record loaded. The reproduction was first made locally on the installed tree. |
| T2 | 2026-11-14 | both machines | Passed | Lua built from the patched source (`ldatabaselib.cpp` sha256 e5b40165c417d202, a `configure/RELEASE.local` that names the installed Base, support directory and asyn, then `make CHECK_RELEASE=NO`; the `CONFIG_SITE.local` that the flow writes, with `INSTALL_LOCATION` and, when it is set, the C17 bridge flags, was not reproduced) and placed in an overlay tree in which only `modules/lua-01aa7a1` differs from the installed tree (the loaded path was the overlay's): the same four calls complete with exit 0, `iocInit` completes and the real `caget` reads the record (42). Libraries: Debian built acbe38f90075a560 against installed d863a95c7355c8a9, Rocky built e5cc28a241dc65dc against installed ecf32159dfb1c72e. The first run of the eight loads stopped before `iocInit` and was repeated with `iocInit` and `caget` to meet the check. |
| T3 | 2026-11-14 | both machines | Passed | With a database whose record name uses the macro (`$(P=none:)TEST`), against the unpatched installed tree and the patched overlay: `dbLoadRecords` with `""` gives `none:TEST`, with `"P=x:"` gives `x:TEST`, `loadRecords` with `{P="x:"}` and `loadTemplate` with `{{P="x:"}}` give `x:TEST`, identically in both trees; the patched tree also loads `dbLoadRecords "t3.db"` without macros as `none:TEST`. The clause of the plan about the table that a registered Lua hook receives was removed: no call form tried (`luaRunString`, `luaLoadFile`, `luaSpawn`, `luaRunFile` with async) made a registered hook run on the unpatched module, so it could not be checked. |
| T4 | 2026-11-14 | local Debian 13 and the Debian 13 test machine | Passed | In a copy of `configure`, `patch` and `tools` of this working tree with a fresh clone of lua at `01aa7a1` (locally from `lua-src`, on the machine from GitHub): `make patch.lua.commit.apply` applies `01aa7a1-site01-database-hook-null-macros.p0.patch` (sha256 6ffd0841dbefd62b; 4 insertions, 2 deletions of `ldatabaselib.cpp`) and `make patch.lua.commit.revert` leaves the source unchanged (no status line, empty diff); the runs were repeated on both with the final patch, whose only difference from the one used in T2, T3 and T5 is a comment above the hook that lost its last clause (the code lines are the same); `make -pn patch` and `patch.revert` list the new targets in the reverse order of each other. |
| T5 | 2026-11-14 | Debian 13 test machine | Passed | The expected result was written before the run: with the guard removed (the call to `macParseDefns` made unconditionally; source sha256 3b9a90ff7bdab67d, library be3c799f4870a55f) the four calls without macros end with exit 139 and the four controls with exit 0. Observed exactly that; the patched library was restored and its hash checked. Done on the test machine, where the build was set up, instead of locally. |
| T6 | 2026-11-14 | local checkout | Passed | `patch/README.md` (kind table row, the list of rules that pass `--no-backup-if-mismatch`, and the section for the patch), `docs/src/concepts/upstream-patch-carry.md` (family row, pattern row, the order of the aggregate), `docs/src/reference/make-targets.md` and the prepared report for upstream (`work/lua-upstream-report.md`, not sent) name the same revision `01aa7a1`, file `luaApp/src/libs/ldatabaselib.cpp` and function `myDatabaseHook`; every file of `patch/` is named in `patch/README.md`; `mdbook build` succeeds. |

##### Closure Evidence

Observed 2026-11-14 at 19:25 UTC: every change of this detail is on `origin/master` (the patch, the `patch.lua` rules and the documents in commit bd1d395, the results in commit 16a9675; the local HEAD equals `origin/master`, with no differing path); issue #137 is CLOSED as completed (closed 2026-11-14 at 19:18 UTC) with every criterion of its body checked. The report for epics-modules/lua stays unsent in `work/lua-upstream-report.md` by the owner's decision. Recheck with `gh issue view 137 -R jeonghanlee/EPICS-env --json state,closedAt`.

#### M7 - Move EPICS Base to R7.0.11

Origin: 441e2e0 / M7
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

The pin of EPICS Base is `tags/R7.0.10`. On 2026-11-11 the tag `R7.0.11` exists (released 2026-10-27, 185 commits after `R7.0.10`). Patches are named for the pinned version and the patch rule applies only `patch/<SRC_VER>-*.p0.patch`, so moving the pin drops the set unless each patch is renamed, re-based, or dropped (`docs/procedures/upstream-fix-carry-procedure.md`, Bump obligation).

##### Scope

Move `SRC_TAG_BASE` and `SRC_VER_BASE` in `configure/RELEASE` to `tags/R7.0.11` and `7.0.11`, and settle each of the 22 Base patches named `7.0.10-*` (18 upstream fixes and 4 site patches) under the Bump obligation.

Out of scope: a move to any tag after `R7.0.11`, the pvxs pin (M8), and module updates.

##### Completion Criteria

- Each downstream Base patch is renamed, re-based, or dropped for `tags/R7.0.11` under the Bump obligation.
- EPICS Base builds from the new pin.

##### Dependencies And Decisions

D2 and D3 apply.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is taken.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M8 - Re-examine pvxs with the Base move

Origin: 441e2e0 / M8
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

pvxs is pinned at `tags/1.5.3` with two patches, `1.5.3-01-7176098-single-put-marked-value` and `1.5.3-02-96345dd-tcp-listener-backlog`. EPICS Base and pvxs move together under the Bump obligation of `docs/procedures/upstream-fix-carry-procedure.md`.

##### Scope

Examine the pvxs pin and its two patches together with the Base move of M7, and settle each patch.

Out of scope: module updates and a pvxs version change that M7 does not require.

##### Completion Criteria

- The pvxs pin and each of its patches are settled under the Bump obligation.
- pvxs builds on the Base of the new pin.

##### Dependencies And Decisions

D3 applies. It waits for M7.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is taken.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M9 - Update modbus to R3-5

Origin: 441e2e0 / M9
Identity History: none
GitHub Issue: #141 (https://github.com/jeonghanlee/EPICS-env/issues/141)
Status: Not started

##### Summary

The pin of modbus is `tags/R3-4` (version 3.4.0, `4a1276b`). The tag `R3-5` (`47d9c40`), the head of the upstream `master` on 2026-11-11, is 17 commits ahead. They add a `ResetStatistics` record, an optional `PINI`, `DESC` fields with empty defaults in the templates, and output of the expected and actual values of a CRC error, print the debug address in decimal, fix `std::min` on Windows, and update the asyn and base entries of the module's `configure/RELEASE`. modbus carries no downstream patch. The module `motor` names `build.modbus` in its `_DEPS` line and is rebuilt with it.

##### Scope

Judge the compatibility of R3-5 with the asyn and the Base pin of M7, decide IN or HOLD, move the pin and its version value, and run the module cycle.

Out of scope: other module updates and a change of the asyn pin.

##### Completion Criteria

- The module cycle of modbus passes on the Debian 13 and Rocky Linux 8.10 test machines: the clean rebuild of modbus and of motor, the patch round trip on a fresh clone, the module scripts of the loader verification suite with the site modules counted, `make check.deps`, `make check.env`, and the reverse-dependency search.

##### Dependencies And Decisions

D2 and D3 apply. The cycle runs on the tree of the Base pin, so it waits for M7 and M8.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Verify the repository-side claims: the pin, the version value, the dependents, and the library stems.
2. Judge the 17 commits against the asyn and the Base pin of M7 and record IN or HOLD.
3. Edit the pin and version value in `configure/RELEASE` and run the cycle with `tools/module-check/cycle.bash`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Module cycle | `tools/module-check/cycle.bash modbus MODBUS <candidate> <site checkout>` | Debian 13 and Rocky Linux 8.10 test machines | every row passes with `rc=0`, the dependent `motor` rebuilds, and no installed library outside the dependents needs a library of modbus |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |

##### Closure Evidence

- none

##### GitHub Projection

Title: Update modbus to R3-5
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-11-12 00:34 UTC, #141 created

#### M10 - Carry the uldaq-env timeout and alarm patches

Origin: 441e2e0 / M10
Identity History: none
GitHub Issue: #142 (https://github.com/jeonghanlee/EPICS-env/issues/142); the related issues are jeonghanlee/uldaq-env#3 and jeonghanlee/uldaq-env#4
Status: Not started

##### Summary

The vendor library ULDAQ stays at 1.2.2 (`a5094ec`, the tag `1.2.2` of `jeonghanlee/uldaq-env`, observed 2026-11-11). The distribution is to carry two more patches beside `patch/1.2.2-tcp-receive.p0.patch`, which exists today. The first adds device configuration items for the network connection timeout and the command timeout, set with `ulDevSetConfig()` and read with `ulDevGetConfig()`, with the default of 3000 ms (jeonghanlee/uldaq-env#3). Measured in measComp, a silent second TC32 stalls a healthy one for 6.1 to 6.3 seconds and then 3.1 seconds in every 5.5 seconds, and its request count over 20 seconds falls from 481 to 512 to 240 to 243. The second adds an alarm configuration write and read for the network TC32 and E-TC (jeonghanlee/uldaq-env#4). The upstream version string stays 1.2.0 in ULDAQ 1.2.2, so the build is identified by its source commit, patch state and library hash.

##### Scope

The patches are to be written and accepted in the `uldaq-env` repository under its two issues. This item carries their integration into the EPICS-env vendor preparation, the build and installation documents, and the checks of the installed tree.

Out of scope: the lock on the device registry `DaqDeviceManager::mCreatedDevicesMap`, the broadcast discovery wait, USB devices, TCP keepalive tuning, and changes to the protocol.

##### Completion Criteria

- The two patches exist in `uldaq-env` and meet the acceptance criteria of their issues.
- The vendor preparation of EPICS-env applies them before the build and installs the patched library, and the installed IOC loads it.
- The measComp build of M11 links the patched library.

##### Dependencies And Decisions

D2 and D3 apply. The cycle runs on the tree of the Base pin, so it waits for M7 and M8.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Develop and review the two patches in `uldaq-env`.
2. Integrate the patch stage into the vendor preparation of EPICS-env and update the build and installation documents.
3. Rebuild the vendor library on the test machines and run the checks below.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Vendor build | apply, revert and build the patched ULDAQ through the vendor preparation | Debian 13 and Rocky Linux 8.10 test machines | the patches apply and revert cleanly, and the library builds and installs |
| T2 | Timeouts | connect to an address that drops packets and command a device that stops answering, with configured timeouts | a network TC32 or its simulated endpoint | each call returns within 100 ms of the configured value, and the default stays 3000 ms |
| T3 | Alarm configuration | set an alarm configuration and read it back | a network TC32 and an E-TC | the configuration read equals the configuration written |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |
| T2 | Not run | a network TC32 or its simulated endpoint | Pending | none |
| T3 | Not run | a network TC32 and an E-TC | Pending | none |

##### Closure Evidence

- none

##### GitHub Projection

Title: Carry the uldaq-env timeout and alarm patches
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-11-12 00:34 UTC, #142 created

#### M11 - Move measComp to the jeonghanlee fork

Origin: 441e2e0 / M11
Identity History: none
GitHub Issue: #120 (https://github.com/jeonghanlee/EPICS-env/issues/120)
Status: Not started

##### Summary

TC32 reconnection (#120) is carried by moving the measComp pin from `c38974e` of `epics-modules/measComp` to the branch `site` of `jeonghanlee/measComp` (`1612c38`, observed 2026-11-11), which is 70 commits ahead and holds the reconnection work, its tests and documents. The clone URL changes with `SRC_BASE_MEASCOMP=$(SRC_URL_JEONGHANLEE)`, the way `SRC_BASE_SNMP` does. This replaces the method of #120, which keeps the old pin with three patches. Of the two current patches, `patch/measComp-CONFIG_MEASCOMP.p0.patch` applies to the fork (checked with `git apply --check` on 2026-11-11), and `patch/measComp-tc32-chan-count.p0.patch` neither applies nor reverses on it, so the plan decides whether each patch is kept, regenerated or dropped. The reconnect patch held outside the repository is not applied.

##### Scope

Move the pin and the URL, decide the fate of the two patches against the fork, rebuild measComp and its consumers, and verify TC32 reconnection on the integrated build.

Out of scope: real-hardware endurance beyond the checks listed here, EXP-32, USB, Windows and other models.

##### Completion Criteria

- The module cycle of measComp passes on both test machines at the fork pin with the patches the plan keeps.
- The real-driver transport regression of #120 passes on the integrated build, with its negative controls.
- On a real TC32 without EXP-32: offline IOC startup, repeated power cycles and network loss do not restart the IOC or replace valid samples, the input records carry INVALID alarms during the loss, and valid updates resume after recovery.

##### Dependencies And Decisions

D2 and D3 apply. M10 supplies the configurable timeouts that remove the remaining three-second stall; M11 does not wait for it. The cycle runs on the tree of the Base pin, so it waits for M7 and M8.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Compare the fork with the two patches and with the held reconnect patch, and record each patch as kept, regenerated or dropped.
2. Set the pin, the version value and `SRC_BASE_MEASCOMP`, and run the module cycle with `tools/module-check/cycle.bash`.
3. Run the transport regression and the hardware checks on the integrated build.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Module cycle | `tools/module-check/cycle.bash measComp MEASCOMP <candidate> <site checkout>` | Debian 13 and Rocky Linux 8.10 test machines | every row passes with `rc=0` |
| T2 | Transport regression | the real-driver reconnection fixture of the fork with its negative controls | Debian 13 test machine, the TC32 endpoint simulated | all positive assertions pass and each negative control fails as expected |
| T3 | Hardware | offline start, power cycles and network loss on a TC32 | a real TC32 without EXP-32 | no IOC restart, no invalid replacement samples, INVALID alarms during loss, valid updates after recovery |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 test machines | Pending | none |
| T2 | Not run | Debian 13 test machine | Pending | none |
| T3 | Not run | a real TC32 | Pending | none |

##### Closure Evidence

- none

##### GitHub Projection

Title: Restore TC32 reconnection with ULDAQ and measComp patches
Labels: bug
GitHub Milestone: Backlog
Observed State: open
Observed Labels: bug
Observed Milestone: Backlog
Last Compared: 2026-11-12 00:34 UTC, after the body of #120 was rewritten to the fork method

#### M12 - Shared-library version identification

Origin: 441e2e0 / M12
Identity History: none
GitHub Issue: #138 (https://github.com/jeonghanlee/EPICS-env/issues/138)
Status: Complete

GitHub state observed: CLOSED as completed on 2026-11-14 at 21:27 UTC with every criterion of its body checked. Recheck with `gh issue view 138 -R jeonghanlee/EPICS-env --json state,closedAt`.

##### Summary

The modules set no versioned `SONAME` (47 of the 54 distinct values in the Debian 13 tree were bare when the item was recorded, and 61 of 82 in the local tree on 2026-11-14), and the owner's aim is a fingerprint inside every shared library that makes the dynamic loading of `iocsh.bash` more robust, not a new `SONAME`. Every shared object of the trees examined already carries a GNU build-id (101 of 101 on Debian 13 and on Rocky Linux 8.10), and the loader metadata already keys each library by module directory and relative path with a sha256 digest. The item decides the identification rules, measures them on the real libraries and defines the mapping between the metadata and the build-id. The planning detail is `work/plan-library-identity.md` of the working copy; the decisions are in D18. The plan was accepted and authorized on 2026-11-14; the row is complete. The implementation that follows from it is the row M20.

##### Scope

Write the rules page `docs/src/concepts/shared-library-identity.md` (identification of an installed library by module directory and release, relative path, `SONAME` and build-id; the `RUNPATH` rule of exact versioned module directories; the Base rule by its own `SONAME` with `libCap5.so` as the exception; the vendor record), measure the rules on the installed libraries of both test machines, define the `format=2` metadata with the `buildid=` lines and the report of the libraries that a running IOC maps, and try the recording and the runtime comparison in scratch.

Out of scope: changes of `iocsh_metadata.bash`, `iocsh.bash`, `iocsh_elf.bash` and the check targets (a later implementation row, decided after the trial), changes of any module repository or wrapper repository, and the renaming of libraries.

##### Completion Criteria

- The rules page states the identification, `RUNPATH`, `SONAME` and build-id rules and the report of a resolved library with its module and version, and distinguishes the release version of a module from the identity of a build.
- The rules are verified against the real installed libraries of both test machines, with the exceptions listed.
- The mapping and the runtime comparison are tried in scratch, and the constraints found (for example the permission to read a mapped image) are recorded.

##### Dependencies And Decisions

D2, D18 and D19 apply. The vendor record is written by the wrapper repositories `uldaq-env` and `open62541-env`; both were told on 2026-11-14 what it must hold, and this row only defines it.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-14, accepted by the owner in chat with the vendor notification (step 5) taken by the owner
Implementation Authorization: 2026-11-14, authorized by the owner in chat
Superseded Plan Artifacts: none

1. Run the inventory (`SONAME` form, build-id, `RUNPATH` form, uniqueness) on the installed trees of both test machines and the local tree.
2. Write the rules page from the decisions and the inventory, and link it from `installed-tree.md` and `installed-module-loader.md`.
3. Try the mapping and the runtime comparison in scratch: the `format=2` `buildid=` lines for two installed modules, the lookup from a build-id to module and version, the build-ids of the images that a real IOC maps, and a library replaced by another build.
4. Compare the documents with each other and with the criteria of #138.
5. Record the results here and in the text of #138, propose the implementation row (both wrapper repositories were told on 2026-11-14 what the vendor record must hold); each commit and push waits for its own trigger.

The owner decided that this row is steps 1 to 5 as written (D19); the recording in the metadata scripts and the runtime check of the loader are the row M20, after this row is complete.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Inventory | a read-only script over every shared object of each installed tree: module and version, `SONAME` form, build-id, `RUNPATH` form | Debian 13 and Rocky Linux 8.10 test machines | the counts and the exceptions equal what the page states |
| T2 | Uniqueness | the build-ids of one tree grouped with the sha256 of each group | both machines | one build-id per distinct content; shared only by identical files |
| T3 | Mapping | `format=2` `buildid=` lines for two installed modules, one with two versions installed, and a lookup from a build-id | both machines | each recorded value equals the value read from its file; a library of the other version is named with its own version |
| T4 | Runtime read | a real IOC through `iocsh.bash`, the mapped objects under the tree, their build-ids read from the file and from `map_files` | both machines | every mapped object has an expected build-id; the readability of `map_files` without privilege is recorded |
| T5 | Wrong build | the same IOC against a scratch tree with one library replaced by a build of different content | local | the comparison names that library as differing while the loader starts the IOC |
| T6 | Documentation | the rules page, `installed-tree.md`, `installed-module-loader.md` and the criteria of #138 compared | local checkout | they agree and each criterion has its section |
| T7 | Checks can fail | scratch mutations: a changed recorded build-id, a removed entry, a library replaced after the record | local | each makes the intended comparison fail |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-14 | Debian 13, Rocky Linux 8.10 and the local Debian 13 tree | Passed with a corrected expectation | Shared objects 101, 101 and 85, each with a build-id; 82 distinct `SONAME` values in each tree, 21 versioned and 61 bare; Base 12 of 14 versioned, the two exceptions are the copies of `libCap5.so`; no `RPATH`. The plan expected `RUNPATH` entries of exact module directories and `base` only; the trees also hold the form `$ORIGIN/.` (97 of 101 objects), the vendor directory (2 objects), the library directory of the own module from a subdirectory (2 pyDevSup objects) and one absolute system directory (4 objects, `/usr/lib/x86_64-linux-gnu` or `/usr/lib64`), and two `ADVimba` vendor SDK libraries have no `RUNPATH`; the page states these forms. |
| T2 | 2026-11-14 | the same three trees | Passed | No build-id is shared by files of different content and no two files with one SHA-256 digest differ in build-id. A build-id is shared by identical copies only: `libCap5.so` (two copies in Base, every tree) and `libre2.so` of `unidrv-0.5.1` and `unidrv-e5a8561` (both machines). So a lookup from a build-id returns a list of module directories and paths; the page states it. |
| T3 | 2026-11-14 | Debian 13, Rocky Linux 8.10, local tree | Passed | Format 2 `buildid=` lines written for real installed modules in a scratch copy: 42 lines on each machine (`asyn-4.46.0`, `asyn-66bafcd`, `linStat-1.1.1`, `linStat-1.2.1`, `unidrv-0.5.1`, `unidrv-e5a8561`) and 15 locally; every recorded value equals the value of `readelf -n` and of `file`; each library of a non-selected version is named with its own module directory; `libre2.so` returns both `unidrv` directories. |
| T4 | 2026-11-14 | Debian 13, Rocky Linux 8.10, local tree | Passed; H2 settled | A real IOC through `iocsh.bash` with five modules (three locally): the mapped objects under the tree from `/proc/<pid>/maps` are 14, 14 and 12, each with the build-id of the inventory. `/proc/<pid>/map_files` could not be opened by the user that started the IOC in any of the 40 cases (`Operation not permitted`), so the comparison uses the paths of `maps`; the use of privileged access is not examined. |
| T5 | 2026-11-14 | local tree | Passed | `libcalc.so` rebuilt from the same source (`calc-src` at the commit of 3.8.0) with another compile flag, build-id `7490fb45...` instead of `a6f27e63...`, placed in a scratch copy of `calc-3.8.0`: the IOC started (exit status 0) and the comparison named only that library, 11 of 12 equal. An unmodified tree compared 12 of 12 equal. |
| T6 | 2026-11-14 | local checkout | Passed | The page `docs/src/concepts/shared-library-identity.md`, `installed-tree.md`, `installed-module-loader.md` and the build of the book agree on the keys, files and rules. The `RUNPATH` statement and the lookup and `map_files` criteria of #138 were corrected to the measured forms, and each criterion of the body has its section on the page. |
| T7 | 2026-11-14 | local tree | Passed | A recorded build-id changed: the comparison reports `DIFFERS` for that library only; a record entry removed: `UNRECORDED` for that library only; a library replaced after the record: the case of T5. The unmodified control is 12 of 12 equal. |

##### Closure Evidence

Observed 2026-11-14 at 21:27 UTC: every change of this detail is on `origin/master` (the page and its links in commit 614233d, the results in commit 49701cb; the local HEAD equals `origin/master`, with no differing path); issue #138 is CLOSED as completed (closed 2026-11-14 at 21:27 UTC) with every criterion of its body checked. The sessions of the two wrapper repositories, `uldaq-env` and `open62541-env`, were told on 2026-11-14 what the vendor record must hold; no reply is recorded yet. Recheck with `gh issue view 138 -R jeonghanlee/EPICS-env --json state,closedAt`.

#### M13 - Migrate recsync to reccaster

Origin: 441e2e0 / M13
Identity History: none
GitHub Issue: #101 (https://github.com/jeonghanlee/EPICS-env/issues/101)
Status: Complete

GitHub state observed: CLOSED as completed on 2026-11-15 at 17:20 UTC. Recheck with `gh issue view 101 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

Module source work outside a version bump (D1). The recsync client moved to its own repository `ChannelFinder/reccaster` (recsync 1.10.0 keeps a stub that exits 1). The histories share no commit, but the content is a rewritten copy: against the tag `1.9.7` the current pin differs in 15 hunks of eight source files (14 hunks in seven files of `castApp` with 30 lines added and 19 removed, one in the demo file with 1 and 1; none changing behavior) and in the include depth of the configuration files. The owner decided on 2026-11-14 to add it as a completely new module `reccaster` next to the unchanged module `recsync`. The planning detail is `work/plan-reccaster.md` of the working copy; the decisions are in D22.

##### Scope

Add the module `reccaster` (`ChannelFinder/reccaster` at the tag `1.9.7`) next to the unchanged module `recsync`, so that IOC record publishing can use the reccaster repository. The audit of module dependencies is changed for DB and DBD file names only (D24), because both modules own `reccaster.dbd`.

Out of scope: any change to the module `recsync`, the removal of `recsync` and the migration of IOC startup files, and changes to published release tags.

##### Completion Criteria

- The module `reccaster` is added next to `recsync` with verified build, installation, loader start and the status records of the IOC fragment on both test machines; delivery to a recceiver is not checked here and is carried by the backlog item M22.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1, D2, D22 and D24 apply.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-14, the revision (a separate new module `reccaster`, `recsync` untouched) accepted by the owner in chat, replacing the first plan; 2026-11-15, the second revision (audit of module dependencies, step 7, T10) accepted by the owner in chat
Implementation Authorization: 2026-11-14, authorized by the owner in chat for the revision; 2026-11-15, authorized for the second revision
Superseded Plan Artifacts: the first plan of 2026-11-14 (replace the client of `recsync`, keep the key `recsync`)

1. Done: read every hunk of the diff between the `client/` directory of the pin and reccaster `1.9.7` (T1).
2. Add the pin block of `reccaster` with the key `RECCASTER` and its declarations (`reccaster_DEPS`, `reccaster_CONF_TYPE`) to the module set following the procedure for adding a module; `auto` when the module allows it, otherwise a `conf.reccaster` rule, and `reccaster_CONF_SITE_LINES:=SKIPDEMO=YES` so that the demo IOC is not built (D22).
3. Run `make init` and `make conf` on both test machines from a clean checkout (the step stays even if the module does not need it), build and install, then run the metadata and the checks.
4. Run the loader, the reccaster fragment verification and the integrated verification.
5. Compare the status records of an IOC with `recsync` and with `reccaster`; run the case of both modules in one tree.
6. Update the documents of this repository that name recsync or reccaster, run the scratch mutations, record the results here and in the text of #101; each commit, push and issue operation waits for its own trigger.
7. Reproduce the failure of the CI (`make check.module-deps` with the source of `recsync` and of `reccaster` both present), change the audit for DB and DBD names only (D24), and verify the full-tree audit before and after, with a scratch mutation in which a third module names the ambiguous DBD (T10); then push and read the CI of all six systems.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Source | every hunk of the diff between the pin `client/` and the new pin read and classified | local | no hunk that changes behavior, or each one named and accepted |
| T2 | Build | the new pin block and declarations, `make init`, `make conf` and the module build from a clean checkout | both machines | `libreccaster.so`, `reccaster.dbd` and `db/reccaster.db` installed in `reccaster-1.9.7` and no `bin/<arch>/demo`; `recsync` untouched |
| T3 | Metadata and checks | `iocsh_metadata.bash record`, `generate`, `check`, then `check.module-deps`, `check.deps`, `check.env` | both machines | each passes for the new module |
| T4 | Loader | an IOC through `iocsh.bash` with `module reccaster`, the static inspection, and a start with `module recsync` unchanged | both machines | each library loads from its selected module directory with no inspection defect |
| T5 | Fragment | `verify_reccaster.sh` with `RECCASTER` set to the new module, and the integrated verification | both machines | the status records exist as with `recsync` and the integrated verification passes |
| T6 | Status records | the status-record check of T5 for an IOC with `recsync` and for an IOC with `reccaster`; delivery to a recceiver is not checked | both machines | the status records of the two modules are equal; the missing delivery check is carried by the backlog item M22 |
| T7 | Coexistence | both modules installed in one tree, and an IOC that asks for both modules | both machines | the outcome is recorded: a start that loads both is stopped or reported, or the duplicate registration is shown and documented |
| T8 | Documentation | the documents of this repository that name recsync or reccaster, with the module table of `module-set.md`, compared with each other and with `configure/RELEASE`; the module count in the README of the distribution repository is out of scope | local checkout | they agree on both modules, the pin, the key and the directory |
| T9 | Checks can fail | scratch mutations: a wrong repository URL, a missing `reccaster_CONF_TYPE`, a wrong `RECCASTER` path in the fragment test, and `SKIPDEMO=YES` left out (the `demo` executable is installed) | local | each makes the intended check fail |
| T10 | Full-tree audit | `make check.module-deps` for every module with the source of `recsync` and of `reccaster` both present, before and after the change of the audit, and a scratch mutation in which a third module names the ambiguous DBD | local, then both machines | before: the two findings of CI; after: no finding; the third module still gets `unknown` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-14 | local | Passed | The `client/` directory of the pin `9834b94` exported and compared with the tag `1.9.7` of reccaster (`diff -ru`): 15 hunks in `caster.c`, `castMain.cpp`, `castudp.c`, `dbcb.c`, `sockhelpers.c`, `testsock.c`, `testtcp.c` and `demoMain.cpp`, all read; none changes behavior (renamed variables, split declarations, `return(0)` to `return 0`; in `castudp.c` the renamed inner `ret` hid an outer `ret` that every exit leaves unchanged). `configure/CONFIG_SITE` and `configure/RELEASE` differ only in the depth of their `-include` lines; `castApp/Db` and `iocBoot` are identical. |
| T2 | 2026-11-14 | Debian 13 and Rocky Linux 8.10 test machines, and the local Debian 13 tree | Passed | The new pin block (`RECCASTER`, `tags/1.9.7`), `reccaster_DEPS`, `reccaster_CONF_TYPE:=auto` and `reccaster_CONF_SITE_LINES:=SKIPDEMO=YES` built through `make RECCASTER`, `make conf.release.modules`, `make conf.reccaster`, `make build.reccaster` and `make symlink.reccaster` in a scratch overlay of the installed tree (the installed tree is only linked). The source checkout is at the tag `1.9.7`; the module `reccaster-1.9.7` holds `cfg`, `configure`, `db/reccaster.db`, `dbd/reccaster.dbd` and `lib/linux-x86_64/libreccaster.so`, and has no `bin` directory, so no `demo`. `recsync` is untouched. The `auto` type needs no `conf.reccaster` rule of its own. Deviation from the plan: `make RECCASTER` and `make conf.release.modules` replaced the whole `make init` and `make conf`, which would clone every module. The first attempt installed into the wrong place because the harness gave `INSTALL_LOCATION` on the make command line instead of in `configure/CONFIG_SITE.local`; the evidence is the corrected run. |
| T3 | 2026-11-15 | the same three trees; CI of all six systems | Passed | The CI of the commit that added the module (`0291307`) failed on all six systems: `make github.check` stopped in `check.module-deps` with two findings, `unknown: reccaster.dbd` at `castApp/src/Makefile:26` of `recsync-src/client` and of `reccaster-src` (a DBD name that two modules own is ambiguous in the audit). The first result below, written on 2026-11-14, ran `check.module-deps` for `reccaster` alone in a checkout without `recsync-src`, so it did not show this; T10 reran the full-tree audit. After the fix of the audit (`6e35b28`, pushed with the register commit `5c5e54c`) the CI passes on Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04 and Ubuntu 26.04, and the linter passes. Earlier evidence: `check.module-deps` for `reccaster`: declared `null.base`, observed none, no finding. The loader metadata is written by the build (`record` and `generate`) and checked by `symlink.reccaster`; it names the macro `RECCASTER`, the library `reccaster` and the DBD `reccaster.dbd`. `check.deps`: 0 files with `RPATH`, `ABSPATH` or lost `$ORIGIN`; `check.env`: 0 findings. Limit: in the overlay the scan counts 16 shared objects, not the 82 of a full tree, because the other modules are links. |
| T4 | 2026-11-14 | the same three trees | Passed | A real IOC through the `iocsh.bash` of the overlay with `module reccaster` loads `reccaster-1.9.7/lib/linux-x86_64/libreccaster.so` and exits 0 after the static inspection of the loader; `module recsync` loads its own library and exits 0. |
| T5 | 2026-11-14 | the same three trees | Passed | `verify_reccaster.sh` with `RECCASTER_MODULE=recsync` and with `RECCASTER_MODULE=reccaster` (the tc32sim IOC rebuilt against each module, then `iocInit`): 2 of 2 checks each. `verify_integrated.sh` with each module: 22 of 22 checks each, as before. The two scripts read the new variable `RECCASTER_MODULE` (default `recsync`); the checks of `recsync` are unchanged. A first run failed because the harness used a `base` that was a link: `$(EPICS_BASE)/../modules` then named the installed tree and not the overlay; the evidence is the run with `base` as a directory of links. |
| T6 | 2026-11-14 | the same three trees | Passed | The same fragment loaded after `module reccaster` and after `module recsync` creates the same records, `t13:Msg-I` and `t13:State-Sts`. Delivery to a recceiver is not checked, as for `recsync` today; the backlog item M22 carries the test server. |
| T7 | 2026-11-14 | the same three trees | Passed | An IOC that loads `module recsync` and `module reccaster` starts, exits 0 and prints no message; both libraries are loaded. The `var` table lists `reccastTimeout` and `reccastMaxHoldoff` once, as it does with either module alone. What the second registration does to a variable that the IOC sets afterwards was not examined, so an IOC loads only one of the two modules. |
| T8 | 2026-11-14 | local checkout | Passed | `module-pins.md` names `reccaster`, `RECCASTER`, `tags/1.9.7`, `1.9.7` and `reccaster-1.9.7`, equal to `make print-INSTALL_LOCATION_RECCASTER` and `configure/RELEASE`; `module-set.md` (source directory and organization variable; `reccaster` follows the default rule, so the loader table, which lists the exceptions, has no row for it), `make-targets.md` (`conf.reccaster` is in the zero-dependency list that `make print-MODS_ZERO_VARS` prints), `common-iocsh-fragments.md`, `common-iocsh-fragment-macros.md`, `load-common-iocsh-fragments.md`, `first-environment.md` and `run-fragment-verification-suite.md` (the variable `RECCASTER_MODULE`) agree; the book builds with no warning. |
| T9 | 2026-11-14 | local | Passed | Four scratch mutations: a wrong repository URL stops `make RECCASTER` (exit 2); a missing `reccaster_CONF_TYPE` stops it with `Missing reccaster_CONF_TYPE declaration`; leaving out `SKIPDEMO=YES` builds and installs `bin/linux-x86_64/demo`, which the T2 expectation of no `bin` directory rejects; a wrong module name in `RECCASTER_MODULE` stops `verify_reccaster.sh` (exit 2). |
| T10 | 2026-11-15 | local checkout, and the Debian 13 and Rocky Linux 8.10 test machines | Passed | `make check.module-deps` for all 37 modules with the sources of `recsync` (pin) and of `reccaster` (tag `1.9.7`) both present: with `tools/audit_module_deps.bash` before the change it stops with the two findings of the CI (`unknown: reccaster.dbd` at `castApp/src/Makefile:26` of both modules), exit status 2, on all three; after the change exit status 0 and no finding, and the rest of the output is equal. Scratch mutations in a hard-linked copy that leaves the sources unchanged: a third module (`std`) that names `reccaster.dbd` in its Makefile and a third module (`iocStats`) that names `reccaster.db` in a substitutions file still get `unknown`; the module `reccaster` that names its own `reccaster.db` in a substitutions file passes with the change and fails with three findings before it. `bash -n` and `shellcheck` of the tool report nothing. Limit: a scratch checkout whose module sources are symlinks gives empty catalogs, because the audit lists files with `find` and does not follow a symlinked root, so it cannot reproduce the failure. |

##### Closure Evidence

Observed 2026-11-15 at 17:28 UTC: the module and its documents are on `origin/master` in the commits `a667fcc` and `0a972ea`, and the change of the audit of module dependencies in `6e35b28` (D24); the register commits are `0291307`, `c4559e6` and `5c5e54c`. The CI of all six systems and the linter pass for `5c5e54c` (Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04 and Ubuntu 26.04); the CI of `0291307` had failed on all six with the two findings `unknown: reccaster.dbd` (T3). Issue #101 is CLOSED as completed (closed 2026-11-15 at 17:20 UTC) with its six acceptance criteria checked and its body updated for the audit change. T1 to T10 are Passed. The register change that records this closure is the commit that follows `5c5e54c`.

#### M14 - Load pyDevSup through the IOC loader

Origin: 441e2e0 / M14
Identity History: none
GitHub Issue: #139 (https://github.com/jeonghanlee/EPICS-env/issues/139)
Status: Deferred

##### Summary

An exploratory run loaded its library and database definition into the plain `softIoc` and processed a record; relocation, the library name that carries the Python version, and the loader rules are not examined

##### Scope

Load pyDevSup into a plain IOC through the loader.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The real loader starts pyDevSup in a plain IOC and verifies relocation, Python-version library naming, and loader selection.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M15 - Patch revert on macOS

Origin: 441e2e0 / M15
Identity History: none
GitHub Issue: #134 (https://github.com/jeonghanlee/EPICS-env/issues/134)
Status: Deferred

##### Summary

Linux results do not verify macOS execution; the Darwin mca path stays in the code

##### Scope

Verify the patch revert on actual macOS.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- Actual macOS patch apply/revert execution verifies the Darwin mca path and clean restored sources.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M16 - Original OPC UA demo startup data

Origin: 441e2e0 / M16
Identity History: none
GitHub Issue: #135 (https://github.com/jeonghanlee/EPICS-env/issues/135)
Status: Deferred

Related issue: [#93](https://github.com/jeonghanlee/EPICS-env/issues/93), observed CLOSED on 2026-11-05 at 03:05 UTC. Its acceptance text and closure comment explicitly leave the original Unified Automation startup data path outside the completed loader scope. It is not a dedicated issue for this item. Recheck with `gh issue view 93 -R jeonghanlee/EPICS-env --json state,body,comments`.

##### Summary

The 69 nodes of its databases come from the Unified Automation example server, which needs a registered download; a server written to imitate those nodes would be a stand-in

##### Scope

Read the original `opcua-IOC-demo` startup data path.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The original demo startup data path is documented from the real Unified Automation server and its 69 database nodes.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M17 - Libera cross-build and generated profile

Origin: 441e2e0 / M17
Identity History: none
GitHub Issue: #133 (https://github.com/jeonghanlee/EPICS-env/issues/133)
Status: Deferred

##### Summary

Needs the real nine-module cross-build; the Libera reference is `docs/libera-cross-build.md`

##### Scope

Verify the Libera cross-build and the generated profile.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The actual nine-module cross-build and generated profile pass the checks in docs/libera-cross-build.md.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D4 applies. No implementation plan or authorization is carried by the prior deferred row.

The required inputs and verification requirements are in [Libera cross-build reference](libera-cross-build.md).

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this deferred item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None. This item remains Deferred.

#### M18 - Insert `on error break` in `iocsh.bash` when the startup file has none

Origin: 441e2e0 / M18
Identity History: none
GitHub Issue: none
Status: Open

##### Summary

The startup files of this repository carry the line `on error break`. The idea is that `iocsh.bash` inserts that line itself when the startup file has none. The default of the `iocsh` command `on error` is `continue` (`iocshScope` starts with `onerr(Continue)` in `modules/libcom/src/iocsh/iocsh.cpp` of `R7.0.10`), so an insertion changes what an existing startup file does after an error. The scope is not settled: whether to insert, how a user turns it off, and which startup files it reaches.

##### Scope

Decide whether `iocsh.bash` inserts `on error break` and, if it does, how the insertion is controlled and verified.

Out of scope: implementation before the decision, and a GitHub issue until the owner opens one.

##### Completion Criteria

- The decision on the insertion, with its control, is recorded and verified on startup files with and without the line, including a file that sets another `on error` mode.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D2 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M19 - Base unit test of makeRPath.pl

Origin: 441e2e0 / M19
Identity History: none
GitHub Issue: none
Related issue: #25 (https://github.com/jeonghanlee/EPICS-env/issues/25), carried by M2. The review of epics-base/epics-base#879 asked for the test.
Status: Complete

##### Summary

The upstream review of the corrected `makeRPath.pl` (epics-base/epics-base#879) asked for the comparison driver to become a Perl unit test of the kind Base runs under `make runtests`, after `test/tools/Snippets.plt`, `modules/libcom/test/yajlTest.plt` and `modules/database/test/ioc/dbtemplate/msi.plt`. Such a test runs from `O.<arch>` against the installed `@TOP@/bin/@ARCH@/makeRPath.pl`, uses only Perl 5.10.1 and core modules, and needs no Python original: the expected text of each case is derived by hand from the rules of the Base build, as `tools/makerpath/scenario_makeRPath.pl` already does for 14 scenarios.

##### Scope

Write `test/tools/makeRPath.plt` and the line `TESTS += makeRPath` of `test/tools/Makefile`, carry both inside `patch/7.0.10-site04-makerpath-perl.p0.patch`, verify the test through the real `make -C test/tools runtests` of the patched Base, and show that each case can fail. The cases: the 14 build inputs of the scenario test, the option forms (`-F` absent, another origin text, an empty root part, `--`, a usage error with exit 2, `-h`), `EPICS_DEBUG_RPATH`, and the deliberate differences (the symbolic link warning, a directory named with leading dots).

Out of scope: the upstream PR (the cherry-pick of the original port and the submission), the comparison with `makeRPath.py` and the installed-tree group, which stay in `tools/makerpath`, and hosts other than Linux.

##### Completion Criteria

- `make -C test/tools runtests` of the patched Base passes every case of `makeRPath.plt` under Perl 5.40.1 and 5.10.1 locally and under Perl 5.26.3 on the Rocky Linux 8.10 test machine.
- Each case is shown able to fail by a scratch mutation of the installed script, with the intended failing case written before the run.
- The patch with the two files applies and reverts on a fresh clone, and `patch/README.md` and the test plan name the test.

##### Dependencies And Decisions

D2, D8 and D11 apply. M2 provides the script and the scenarios; M19 waits for no other row.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-13, accepted by the owner in chat (`work/makerpath/plan-plt-test.md`, decisions as recommended)
Implementation Authorization: 2026-11-13, authorized by the owner in chat
Superseded Plan Artifacts: none

1. Write `test/tools/makeRPath.plt` in the style of `Snippets.plt`: a helper that runs the installed script as a child process and captures stdout, stderr and exit status; the cases of Scope with their expected texts written before the first run.
2. Add `TESTS += makeRPath` to `test/tools/Makefile`.
3. Build `src/tools` and `test/tools` of the patched Base source kept for the tests of M2, run `make -C test/tools runtests` with `PERL` as 5.40.1 and as 5.10.1, and keep the `.tap` files; report the first run before the patch is touched.
4. Prove each case can fail by the scratch mutations of M2 / T4, each with its intended failing case written before the run, the unmutated run first and the hash of the mutated file recorded.
5. Regenerate the site patch with the two files and run the patch round trip again.
6. Run `make build.base` and `make -C epics-base-src/test/tools runtests` on the Rocky Linux 8.10 test machine.
7. Record the results here, in `patch/README.md` and in the test plan; each commit and push waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Unit test | `make -C test/tools runtests` of the patched Base, the `.t` generated by `expandVars.pl` from `makeRPath.plt` | local Debian 13 under Perl 5.40.1 and 5.10.1; Rocky Linux 8.10 test machine under Perl 5.26.3 | every planned case passes; the `.tap` reports the planned count |
| T2 | Proof of failure | the scratch mutations of M2 / T4 applied to the installed script, the intended failing case of each written before the series | local Debian 13 | the unmutated run passes first; each mutation fails the intended case |
| T3 | Patch round trip | the patch with the two files applied in name order with the other patches and reverted in reverse order on a fresh clone | local Debian 13 and the Rocky Linux 8.10 test machine | both legs exit 0 and the tree returns to its original state |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-13 | local Debian 13 (Perl 5.40.1 and 5.10.1) and the Rocky Linux 8.10 test machine (Perl 5.26.3) | Passed | `make -C test/tools tapfiles` and `runtests` of the patched Base source, with the `.t` that `expandVars.pl` generates from `makeRPath.plt` (sha256 69cfe8a6decac3fe) against the installed `makeRPath.pl` (sha256 eee0f2160a3408af): 72 of 72 checks pass (24 cases on stdout, exit status and stderr) under each of the three interpreters; the Rocky run used a fresh clone of the pinned Base with all 22 patches applied and built with its own install location. A first run of the test under Perl 5.40.1 failed 21 stdout checks because the test did not strip the newline (`chomp` under a file-wide `local $/`); the test was corrected, the script unchanged. A first Rocky run against the tree kept from M2 / T5 failed the 4 message cases because that tree still holds the recording stub of T5 in place of `makeRPath.pl`; the tree was left as it is. |
| T2 | 2026-11-13 | local Debian 13 (Perl 5.40.1 and 5.10.1) | Passed | The 12 scratch mutations of M2 / T4 copied into the installed location and run through the same `makeRPath.t`: the unchanged script passed first (72 of 72), and each mutation fails the checks intended for it, written before the series (`work/makerpath/plt/mut-table.json`), with the run bound to the hash of each mutated file; under both interpreters. Two predictions were corrected after the first run and the series was run again: the stderr pattern of the `EPICS_DEBUG_RPATH` case anchors only the debug line, so the appended warning of the relpath mutation does not fail it; and the join mutation also changes `py_abspath` of relative inputs, so four cases whose directories exist warn on stderr. |
| T3 | 2026-11-13 | local Debian 13 and the Rocky Linux 8.10 test machine | Passed | All 22 `patch/7.0.10-*` patches, with the regenerated site04 patch, apply in name order to a fresh clone of the pinned Base, `makeRPath.plt` in the clone is byte-identical to the file of the test, and `tools/revert_patch.bash` reverts them in reverse order leaving no change and no `makeRPath.plt`, on both machines. |

##### Closure Evidence

T1 to T3 passed on 2026-11-13 on the artifacts named in the results: `test/tools/makeRPath.plt` (sha256 69cfe8a6decac3fe) carried in `patch/7.0.10-site04-makerpath-perl.p0.patch` together with the line `TESTS += makeRPath` of `test/tools/Makefile`; the test plan and `patch/README.md` name the test.

#### M20 - Record library fingerprints in the loader metadata and check them at start

Origin: 441e2e0 / M20
Identity History: none
GitHub Issue: #144
Status: Complete

##### Summary

M12 defines how an installed shared library is identified and tried the recording in scratch. This row carries the implementation in the form of D25 and D26: the build tool records the GNU build-id of each library, and the loader compares the libraries it is about to load with that record before it starts the IOC.

##### Scope

Record a `buildid=<relative path> <hex>` line for every shared object in `cfg/build-record` (`none` with a notice when a library has no build-id), raise that file to format 2 with the digest file `cfg/build-record.sha256`, and split the reader and the format number of `tools/iocsh_metadata.bash` by file; `cfg/iocsh.conf` is not changed. In `tools/iocsh.bash`, read the record, compare the build-id of each loaded module library and each resolved module dependency with it before the `exec`, show the build-ids in the `-n` listing, refuse a start as D26 states with the exit statuses 64 and 78, and add the option `-l, --loader-debug`. Change the tests that read the metadata or expect status 1, and update the documents of the metadata and the loader.

Out of scope: any module repository and any wrapper repository (the vendor record is written by the wrappers), a record for Base, the renaming of libraries, any check inside a running IOC or through `/proc`, and the integration of `iocsh.bash` in `ioc-runner` with its handling of a refused start (jeonghanlee/epics-ioc-runner#169).

##### Completion Criteria

- A module built with the changed scripts has a `cfg/build-record` of format 2 with a build-id for every shared object and a digest file, `check` verifies both, and its `cfg/iocsh.conf` is unchanged.
- `iocsh.bash` refuses, with status 78 and a message that names the module directory, the path and both build-ids, a start whose loaded module library differs from the record, whose record does not match its digest, or whose module has no record; it starts a correct tree without a message and a tree of release 1.5.0 as before.
- `iocsh.bash -n` shows the build-id of every compared file and ends with the status a start would have; `-l` shows the output of the loader for the IOC process, marked by its process number, and for no program that the wrapper runs.
- The tests of the metadata and of the loader pass on both test machines, and each check is shown able to fail.

##### Dependencies And Decisions

D18, D19, D25, D26 and D27 apply; D25 replaces the form that the page `docs/src/concepts/shared-library-identity.md` describes after M12, and that page is rewritten in this row. Constraints that stay from the trial of M12:

- A build-id can be held by identical copies in several module directories, so the key of a library stays its module directory and path, and the comparison goes from the path to the record of its module.
- Every `RUNPATH` entry has one of six forms, so a check cannot assume that every entry names an exact module directory.
- The vendor libraries have no build-id record until the wrapper repositories write one (the gate G2 and D21).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-16, accepted by the owner in chat after two forms of the plan and five third-person passes; the first form (a check inside the running IOC) was dropped the same day
Implementation Authorization: 2026-11-16, authorized by the owner in chat
Superseded Plan Artifacts: the first form of the plan of 2026-11-15 (iocsh `system` command, `/proc/<pid>/maps`, `buildid=` lines in both files, refusal of format 1 trees)

1. `tools/iocsh_elf.bash`: a function that reads the GNU build-id of a file with `readelf -n` and returns `none` when the file has none.
2. `tools/iocsh_metadata.bash`: one format constant per file (`cfg/build-record` 2, `cfg/iocsh.conf` 1); one reader per file with its accepted keys and its list of readable format numbers, sharing the line handling; `record` writes the `buildid=` lines and the digest file; `generate` and `check` read the format line first, read a record of format 1 as before (D27), verify the digest of format 2, and `check` compares each recorded build-id of a format 2 record with the file.
3. `tools/iocsh.bash`: a reader of `cfg/build-record` (format line first; format 1 without a digest, format 2 with one); the compared set as the union of the libraries loaded with `dlload` and the resolved files of class `module`; the `-n` listing with the build-ids; the comparison before the `exec` with the error lines; the exit statuses 64 and 78; the option `-l, --loader-debug`.
4. Tests in `examples/iocsh/tests`: change the checks that expect status 1 from a refusal of the wrapper (`verify_elf_inspection.bash`, `verify_make_rules.bash`) and the expectations of `verify_install_metadata.bash`; add checks for the split readers, the digest of the record, a build-id that differs, a record of format 1, a missing record and the loader option.
5. Documents: `shared-library-identity.md`, `installed-tree.md`, `installed-module-loader.md`, `tools-and-scripts.md`, `run-ioc-from-installed-modules.md` and the glossary, with the note that a tree of release 1.5.0 keeps working with the build rules and that a module gets a record of format 2 when it is built again.
6. Run the checks in three stages: in a scratch overlay of the installed 1.5.0 tree, with a few modules built by the changed scripts beside records of format 1; on a full installation, with mutations; and on that installation under `ioc-runner` in local mode through a launcher script. Record the results here.
7. After the implementation, tell the other repositories by message: the error lines and the exit statuses to jeonghanlee/epics-ioc-runner#169, the form of the record to the two wrapper repositories, and the exit statuses to the repository of the `epics-ioc-run` skill. Each commit, push and issue operation waits for its own trigger.

Settled during the implementation: the comparison adds 25 to 35 ms to a start on the local machine and no measurable time on the two test machines, and the sandbox checkouts of both test machines hold their build directories.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Record | build two modules with the changed scripts (`make build.<module>`); read both files | local, then both machines | `cfg/build-record` has `format=2`, one `buildid=` per shared object equal to `readelf -n`, and a digest file; `cfg/iocsh.conf` is byte for byte as before |
| T2 | Check | `iocsh_metadata.bash check` on the new records | both machines | consistent |
| T3 | Check can fail | in a hard-linked scratch copy: a library of another build at a recorded path; an edited `buildid=` line; an edited record with the old digest; a `lib=` line in the record; an `artifact=` line in the conf | scratch | each makes the intended check fail for its own reason |
| T4 | Old tree | the changed `iocsh.bash` on the installed 1.5.0 tree (records of format 1) | local, both machines | the IOC starts as before and prints no line about build-ids; `-n` marks each module as having no build-id record |
| T5 | Correct start | a real IOC with several modules, on a tree with format 2 records; `-n` on the same startup | both machines | no line with `ERROR`; `iocRun: All initialization complete`; `-n` exits 0 |
| T6 | Mismatch | the same with `libasyn.so`, which is loaded and is no dependency target, replaced by another build after the record; then with an edited record | scratch | the error lines name the module directory, the path and both build-ids; `iocsh.bash` exits 78 and no IOC process starts; `-n` exits 78 with the same lines; the edited record is refused for its digest |
| T7 | Listing | `iocsh.bash -n` with `module asyn` and `module calc` | both machines | every file of the compared set shows its build-id, `libasyn.so` and `libcalc.so` included |
| T8 | Loader option | a real IOC with the loader option | both machines | the wrapper prints the process number of the IOC; `calling init:` lines carry that number; the only other number is the `sh` that `softIocPVX` starts; no output from the programs the wrapper runs, and none without the option |
| T9 | Missing record | a module directory without `cfg/build-record`, in a scratch copy | scratch | `iocsh.bash` exits 78 with a message that names the file; no IOC process starts |
| T10 | Mixed tree | a startup that selects one module with a format 2 record and one with a format 1 record | local, both machines | the IOC starts; `-n` shows the build-id of the first as recorded and marks the second as not recorded |
| T11 | Under `ioc-runner` | `ioc-runner --local` with a launcher that runs `iocsh.bash -e <tree> <startup>`; a correct start, then a refused start (a library of another build) | local | recorded as observed: what `ioc-runner start` prints, whether the IOC is restarted without end, where the message of `iocsh.bash` appears |
| T12 | Exit status | an unknown option; a module that is not installed; `-n` and a start for each | local | 64 for the option and 78 for the module, the same with `-n` and with a start; a correct `-n` exits 0 |
| T13 | Existing tests | `examples/iocsh/tests/run_all.bash` | both machines | all pass |
| T14 | CI | `make github.check` on the pushed change | CI, six systems | pass |

##### Verification Results

The runs used the uncommitted tools with the SHA-256 digests `8161f805f2fa64f8` (`iocsh.bash`), `af616698ca7a33e5` (`iocsh_elf.bash`) and `d923b20fbb44c0f1` (`iocsh_metadata.bash`), first sixteen digits each. Stage 1 ran in a scratch overlay of an installed 1.5.0 tree, which was only linked; stage 2 ran in the sandbox checkout and tree of each test machine, moved to `origin/master` (`30c6919`) with the changed files laid over it and every module and Base built again.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | Stage 1: `make build.iocStats` and `make build.autosave` (and `make build.pvxs` locally) write `cfg/build-record` with `format=2`, one `buildid=` line per library artifact equal to `readelf -n`, and a digest file that matches; `cfg/iocsh.conf` is identical to the one of the installed tree. The record of pvxs carries a line for each name of a versioned library (`libpvxs.so` and `libpvxs.so.1.5`). Stage 2: `make build` writes 40 records of format 2 on each test machine; 3 records of modules that this checkout does not build stay format 1. |
| T2 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | `iocsh_metadata.bash check` reports the new records consistent, and `make symlinks` ends with status 0 on the stage 2 trees with their 40 records of format 2 and 3 of format 1. |
| T3 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | Each mutation of a copy of one module directory makes `check` fail for its own reason: a library of another build (`Installed artifact differs`), an edited `buildid=` line with a recomputed digest (`Installed library differs from the build record ... has build-id ..., recorded ...`), an edited record with the old digest (`was changed after it was written`), a `lib=` line in the record and an `artifact=` line in the conf (`Unknown key`), a missing digest file, a removed `buildid=` line, a `buildid=` line for a file that is no artifact, and format 3 (`Unsupported format`). The unchanged copy and a record of format 1 pass (D27). Locally also: a record line with an empty key is refused, and a library linked without a build-id is recorded as `none` with a notice and accepted by `check`. |
| T4 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | The changed `iocsh.bash` on the installed 1.5.0 tree, with `module asyn` and `module calc`: the show mode and a real start end with status 0, the IOC reaches `iocRun: All initialization complete`, no line about build-ids is printed, and `-n` marks the module files `not recorded`. Locally `make install.<module>` and `make symlink.<module>` on a module in the state of release 1.5.0 end with status 0 and leave its loader metadata and link in place. |
| T5 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | A real IOC with `module iocStats` and `module autosave` on records of format 2: status 0, the readiness line, no line with `ERROR`; `-n` ends with status 0. Stage 2: the fixtures of the loader suite start on trees whose records are format 2. |
| T6 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | A library of another build at the recorded path: `iocsh.bash` and `iocsh.bash -n` print the same two lines, `ERROR: 1 of 2 module libraries differ from their build record` and `ERROR: iocStats-4.0.1 lib/linux-x86_64/libdevIocStats.so build-id <found> recorded <recorded>`, end with status 78, and start no IOC. An edited record with its old digest is refused with `Build record of iocStats 4.0.1 was changed after it was written`, status 78. The module is one that the wrapper loads and that no object depends on. |
| T7 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | `iocsh.bash -n` with `module asyn` and `module calc` on the stage 2 trees: 7 lines of class `module`, each ending with a build-id of 40 digits, `libasyn.so` and `libcalc.so` among them, none marked `not recorded`. |
| T8 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | `iocsh.bash -l`: the wrapper prints `loader lines of the IOC process start with <number>:`, the `calling init:` lines of that number name the library of the module, and without the option no loader line appears. The only other process number is the `sh` that `softIocPVX` starts when it registers the `system` command (23 lines locally). |
| T9 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | A module directory without `cfg/build-record`, and a record of format 2 without its digest file: status 78 in both modes, a message that names the file, no IOC. A record that claims format 1 beside a digest file is refused in the same way. |
| T10 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | A startup that selects iocStats (record of format 2) and asyn (format 1): the IOC starts; `-n` shows the build-id of the first and marks the files of the second `not recorded`. |
| T11 | 2026-11-16 | local Debian 13, `ioc-runner` 1.4.1 in local mode | Passed | Observed with a launcher script that runs `iocsh.bash -e <tree> <startup>`. Correct start: `ioc-runner start` ends with status 0 and `successfully started`, one child start, the readiness line. Refused start (a library of another build): `ioc-runner start` ends with status 1 and `Error: IOC '<name>' is crash-looping before reaching iocInit.` with the log hint; in about 50 s procServ starts the child 5 times, each ends with `Normal exit status = 78`, the summary line of `iocsh.bash` is in the log 5 times, and the unit stays `active`. The message of `iocsh.bash` is not shown by `ioc-runner start`. |
| T12 | 2026-11-16 | local Debian 13 and the Debian 13 and Rocky Linux 8.10 test machines | Passed | An unknown option, `-n` without a startup file, two startup files and `-e` without its argument end with 64; a module that is not installed and an unreadable startup file end with 78 in the show mode and in a start; `-h` and a correct `-n` end with 0. |
| T13 | 2026-11-16 | Debian 13 and Rocky Linux 8.10 test machines | Passed | `examples/iocsh/tests/run_all.bash` through `guest-suite.bash` on the stage 2 trees: 18 scripts end with status 0, 301 checks pass and none fails on each machine, the new `verify_build_ids` with 29 checks among them. This is the run after the two changes that the code review of the same day brought: the path inside the module directory is cut at the last occurrence of the directory name (`iocsh.bash`), so that a tree whose path holds the name of a module directory is not refused, and three checks that each metadata reader refuses a key of the other file. Before those changes the same run gave 298 and 26. Two checks that the change itself broke were found by the first full run and corrected: a count of a library name in the `-n` output (`verify_directives`), which now counts `dlload` lines, and one more expectation of status 1 (`verify_resolved_paths`). The other failures of the earlier runs came from the sandbox, not from the change: its sources carried the patch set of an older commit, and a repeated `make patch` of the test harness left a reject file in the Base source (`docs/CLOSED_DOORS.md`, K21). |
| T14 | 2026-11-17 | GitHub Actions, commit `49c5a4d` | Passed | The six OS workflows (Debian 12, Debian 13, Rocky 8, Rocky 10, Ubuntu 24.04, Ubuntu 26.04) and the workflows Linter Run and Deploy Docs completed with `success`, read at 17:59 UTC. The vendor library of this run came from `uldaq-env` after its commit that writes `vendor/cfg`; nothing in this repository reads those files. |

##### Closure Evidence

The tools, the tests and the seven document pages are commit `49c5a4d` ("Record library build-ids and compare them before an IOC starts"), pushed on 2026-11-17; `origin/master` pointed to it after the push. `tools/iocsh.bash` and `examples/iocsh/tests/verify_build_ids.bash` of that commit have the sha256 that the last suite runs on the two test machines printed for them (`05f721d26d70f38f` and `9b30ceac25e93d78`). The plan, the decisions D25 to D27 and the results T1 to T13 are commit `18e37d4`. The issue #144 was opened on 2026-11-17. The other repositories were told on 2026-11-17: the error lines, the exit statuses and the observations of T11 for jeonghanlee/epics-ioc-runner#169, the form of the record to the sessions of `uldaq-env` and `open62541-env`, and the exit statuses to the session that maintains the `epics-ioc-run` skill. The new test script was committed without the execute bit, which the suite does not need because it starts each script with `bash`; the bit is set in the commit that sets this row to Complete.

#### M21 - Pin the vendor library sources by tag

Origin: 441e2e0 / M21
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

The CI workflows clone `uldaq-env` and `open62541-env` without a tag or commit, so each build takes the default branch of that day. The published 1.5.0 distribution holds libuldaq 1.2.2 and libopen62541 1.3.15 in its six trees, but no record names the commit that built them, and a sandbox of a test machine built libuldaq 1.2.1 from an older commit. D20 pins the vendor sources by tag from the next release, as the module pins are. The tags come from the wrappers (G2); this row changes EPICS-env.

##### Scope

Add a pin variable for each of the two wrapper repositories to `configure/RELEASE` (names decided in the plan), make the six OS workflows and the scripts `tools/prep-vendors.bash`, `tools/module-check/guest-baseline.bash` (which skips the clone when the directory already exists) and `tools/install-distribution.bash` (which builds the checkouts that the user placed beside the checkout) use each repository at its pin, with the way decided in the plan, and make every documented installation of the vendor libraries name the tag (D21), document the variables and the pinned vendor libraries in the configuration reference and the pages about the vendor directory, and verify a build on both test machines with the pinned sources.

Out of scope: the tags in the wrapper repositories (created by their owners), `pkg_automation`, and the installed trees that already exist.

##### Completion Criteria

- Each of the six OS workflows, `tools/prep-vendors.bash`, `tools/module-check/guest-baseline.bash` and `tools/install-distribution.bash` installs the vendor libraries from the source at the pin of `configure/RELEASE`, and a changed pin changes the source that is used.
- A build on Debian 13 and Rocky Linux 8.10 installs vendor libraries from the pinned sources, and the version of each installed library is the version that the documents give for its tag (tag 1.2.2 of `uldaq-env` gives libuldaq 1.2.2, tag 1.0.0 of `open62541-env` gives libopen62541 1.3.15).
- The documents name the pin variables and the pinned library versions.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D20 and D21 apply. The row depends on the gate G2, which supplies the tags and closes only with the complete solution of both wrappers (D21). G2 was Complete on 2026-11-18, and the row was restored from Blocked to Not started on that date; the tags to pin are `1.2.2-1` of `uldaq-env` and `1.3.15-2` of `open62541-env`, or later ones of the same form (D32).

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M24 - Take the revert tool from the patch skill

Origin: 441e2e0 / M24
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The skill `patch` of the `dev-env` repository is the original of the revert tool since 2026-11-16 (D28). On that day the skill changed its file: both of its tools now end with one set of exit statuses (0 done or skipped, 1 `patch` failed while changing the source, 2 usage or input error, 3 the state cannot be classified), and the file carries the licence header of the owner. `tools/revert_patch.bash` of this repository was, when this row was opened, the earlier file (218 lines, sha256 `d99690bb8c7b5b87…`), which ends with status 2 for a state it cannot classify and has no header and no record of its origin. The owner decided to take the new file now (D30).

##### Scope

Replace `tools/revert_patch.bash` by the file of the skill at a named `dev-env` commit, add the record `tools/revert_patch.bash.source` that step 9 of the skill requires, and bring the documents that state the exit statuses or the size of the tool to the new file.

Out of scope: the apply rules and the apply tool of the skill (D28, `docs/CLOSED_DOORS.md` K21), the patch files, a change of the tool itself (it is proposed to the skill), the carry procedure document, and a GitHub issue until the owner opens one.

##### Completion Criteria

- `tools/revert_patch.bash` equals the revert tool of the skill at the commit that `tools/revert_patch.bash.source` names, and `check-copy.bash` of the skill reports it as the same.
- `docs/src/reference/tools-and-scripts.md` states the four exit statuses of the tool, and no document of this repository states the earlier ones.
- `make patch.revert` followed by `make patch` gives the same sources as before on both test machines, and a second `make patch.revert` ends with status 0.
- CI passes on the six systems.

##### Dependencies And Decisions

D28 and D30 apply. The row changes no rule in `configure/`: the ten revert macros and the nine named revert recipes call the tool without reading the value of its status.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-16
Implementation Authorization: 2026-11-16
Superseded Plan Artifacts: none

The plan is `work/plan-revert-tool-from-skill.md` (2026-11-16): copy the skill file over `tools/revert_patch.bash`, write the record `tools/revert_patch.bash.source`, correct the documents that state the exit statuses or the size of the tool, and verify as in the Test Plan.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Tool on the real families | both tools side by side in scratch copies of the unpatched sources, with the loop of the revert macro: revert of a copy patched by the direct calls, a second revert, and for Base a copy patched up to `pr0934` | local scratch | the new tool gives the same statuses, the same counts of reversed and skipped patches and the same sources as the present one |
| T2 | Copy | `check-copy.bash` of the skill in the repository root; the four lines of the record against the file | local | `same`; the recorded sha256 is the sha256 of the file |
| T3 | Static | `bash -n` and shellcheck on the tool | local | no finding |
| T4 | Round trip through make | `examples/iocsh/tests/run_all.bash`, whose `verify_make_rules.bash` runs `make patch.revert` and `make patch` on every source | both test machines | all scripts pass |
| T5 | Revert twice through make | `make patch.revert` on the reverted sources of the sandbox checkout | both test machines | status 0, every patch skipped, the sources unchanged |
| T6 | Statuses | the tool with a wrong option, with a missing patch file, and with a patch that fits neither direction | local scratch | 2, 2 and 3, as the document row states |
| T7 | CI | `make github.check` on the pushed change | six systems | pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-16 | local Debian 13, scratch copies of the clean source checkouts | Passed | Skill tool of `dev-env` commit `2ef69e7` (sha256 `a327a96e6a567e11`, 255 lines) beside `tools/revert_patch.bash` (sha256 `d99690bb8c7b5b87`, 218 lines). For each of the ten families (Base 22 patches, pvxs 2, autosave 2, linStat 6, lua 1, modbus 1, StreamDevice 1, sscan 1, ADCore 1, pyDevSup 2) both tools reverse every patch of a patched copy with status 0, leave it equal to the unpatched copy with no `.orig` or `.rej` file, and skip every patch in a second revert with status 0. For a Base copy patched up to `pr0934` both reverse 15 and skip 7 and reach the unpatched copy. The message lines of the two tools for the first revert of Base are the same. The nine named patches of `configure/RULES_PATCH` were not in this run. |
| T2 | 2026-11-16 | local Debian 13 | Passed | `check-copy.bash` of the skill in the repository root prints `same a327a96e6a567e11 tools/revert_patch.bash` and ends with status 0. The sha256 in `tools/revert_patch.bash.source` is the sha256 of the file, its commit is the HEAD of the skill checkout (`2ef69e7`), whose tool files had no uncommitted change, and its first four lines are `Original`, `Skill commit`, `sha256` and `Copied on`. |
| T3 | 2026-11-16 | local Debian 13 | Passed | `bash -n` and shellcheck on `tools/revert_patch.bash` end with status 0 and print nothing. `verify_docs_and_tools.bash` does not list this tool, so the check was run on the file directly. |
| T4 | 2026-11-16 | Debian 13 and Rocky Linux 8.10 test machines, sandbox checkout at `30c6919` with the uncommitted files of M20 and the tool and record of this row laid over it | Passed | On each machine the tool in the checkout has the sha256 `a327a96e6a567e11` and 255 lines, as the record names. `guest-suite.bash` ends with status 0: 18 scripts end with status 0, 301 checks pass and none fails, `verify_make_rules` with 33 checks among them (1167 s on Debian, 1026 s on Rocky). |
| T5 | 2026-11-16 | the same two sandbox checkouts, after the suite | Passed | On each machine the first `make patch.revert` ends with status 0 and reverses 47 patches, which are the 49 files under `patch/` without `mca-libnet` (its recipe runs on Darwin only) and `pvxs-1.3.1` (its recipe is commented out). The second `make patch.revert` ends with status 0, reverses none and skips 47, and the `git diff` of the source checkouts is the same before and after it; no `.rej` or `.orig` file lies in the sources. `make patch` afterwards ends with status 0 and gives the `git diff` the sources had before the first revert. |
| T6 | 2026-11-16 | local Debian 13, scratch copy of the unpatched Base source | Passed | A wrong option ends with status 2 and the usage line; a missing patch file with 2 (`Patch file missing, empty or unreadable`); a four-file patch of which one file was put back, which fits neither direction, with 3 (`Prerequisite view does not confirm an unapplied patch`), and the source is unchanged. The row of the tool in `docs/src/reference/tools-and-scripts.md` states these statuses. With the directory of the last file of a four-file patch made read-only, the tool ends with status 1 and `Patch failed while reverting; the source may be changed`; the first three files are reverted and the last is not. |
| T7 | 2026-11-17 | GitHub Actions, commit `2ad1ad0` | Passed | The six OS workflows (Debian 12, Debian 13, Rocky 8, Rocky 10, Ubuntu 24.04, Ubuntu 26.04) and the workflows Linter Run and Deploy Docs completed with `success`, read at 16:23 UTC. |

##### Closure Evidence

The tool, its record and the two changed places of `docs/src/reference/tools-and-scripts.md` are commit `2ad1ad0` ("Replace revert_patch.bash with the revert tool of the patch skill"), pushed on 2026-11-17; `origin/master` pointed to it after the push. The `dev-env` session was told the commit, and its skill names it since `dev-env` commit `dcaf8b8`. This detail, the decisions D28 to D30 and the sentence of `docs/CLOSED_DOORS.md` K21 that this row changed are commit `18e37d4`, pushed on 2026-11-17; `origin/master` pointed to it after the push. A check of the change against the tool found one sentence of the tool note in `docs/src/reference/tools-and-scripts.md` that no longer held: the new tool names a missing source directory or patch file by itself, not together with the other. The sentence is corrected in the commit that sets this row to Complete. The row has no GitHub issue.

#### G1 - open62541-env changes committed

Origin: 441e2e0 / G1
Identity History: none
GitHub Issue: none
Status: Open

##### Summary

The simulator `opcua-server-sim` builds open62541 through a checkout of `open62541-env` and needs the `CMAKE_EXTRA_OPTIONS` support in its `configure/CONFIG_SITE` and `configure/RULES_INSTALL` and the patch `patch/1.5.10.p0.patch`. According to the register of the simulator they were uncommitted in `open62541-env` on 2026-11-13. The owner commits them there. This gates M4.

##### Completion Criteria

- `git status --short` of the `open62541-env` repository shows those paths committed, and the commit that carries them is on its upstream.

##### Responsible Party And Affected Work

The owner of the `open62541-env` repository. M4 depends on it.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| Not run | Pending | `git -C <open62541-env path> status --short` |

##### Closure Evidence

None.

#### G2 - uldaq-env and open62541-env pin tags

Origin: 441e2e0 / G2
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

EPICS-env pins the vendor sources by tag from the next release (D20) and needs, in each of `uldaq-env` and `open62541-env`, a tag that names the exact source of the library version that it pins: libuldaq 1.2.2 and libopen62541 1.3.15 for the published 1.5.0 distribution. On 2026-11-14 `uldaq-env` has the tags 1.2.1 (commit 988b152) and 1.2.2 (commit a5094ec), and its owner confirmed the tag 1.2.2 as the source of the libuldaq 1.2.2 in the 1.5.0 distribution (the libraries of the Debian 12 and Debian 13 trees equal the digests that its verification document records; for the other four trees the statement rests on the owner's recollection that they were built from the master of that date). `open62541-env` has the annotated tag 1.0.0 on origin at commit 00e5e60, which its owner confirmed as the source of the libopen62541 1.3.15 of the 1.5.0 distribution; that repository holds no build record. The gate stays Open by D21 until both owners deliver the tag rule for later versions and the place and format of the build-id record. This gates M21.

##### Completion Criteria

- `git ls-remote --tags` of each repository shows the tag that names the pinned source (`uldaq-env`: the tag 1.2.2, `open62541-env`: the tag 1.0.0, both confirmed by their owners on 2026-11-14), and the owner has recorded the commit that it points at.
- Each owner has delivered the tag rule for later versions and the place and format of the build-id record.

##### Responsible Party And Affected Work

The owners of the `uldaq-env` and `open62541-env` repositories. M21 depends on it.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| 2026-11-14 | Pending | `git ls-remote --tags https://github.com/jeonghanlee/uldaq-env` shows 1.2.1 and 1.2.2, and the same command for `open62541-env` shows 1.0.0; the tag rule and the build-id record are not decided |
| 2026-11-17 | Pending | The place and the format of the vendor record are decided (D31) and were sent to the sessions of both wrapper repositories. `uldaq-env` writes an earlier form of its own since its commit `c9f31c9` (`vendor/cfg/uldaq-env.buildid` and `vendor/cfg/uldaq-env.source`), which it changes to the decided form; `open62541-env` writes no record yet. The tag rule for later versions is not decided. |
| 2026-11-18 | Pending | The values of the record and the tag rule are decided (D32) and were sent to the sessions of both wrapper repositories. Neither repository has a commit that writes the decided form yet: `uldaq-env` has it in its working tree, and `open62541-env` starts after this decision. |
| 2026-11-18 | Pending | `open62541-env` delivered: `git ls-remote https://github.com/jeonghanlee/open62541-env` shows `master` at `ab75700` ("Write the vendor record at install and remove it at uninstall") and the annotated tag `1.3.15-2` (tag object `97473d8`) pointing at that commit, which follows the tag rule of D32. Its session reports that the install step writes `<prefix>/cfg/open62541/build-record` and its digest in the form of D31 and D32, and that a build with its opt-in patch installs the library as the single file `lib/libopen62541.so`, so the record of such a build names that file. `uldaq-env` has no such commit yet. |
| 2026-11-18 | Pending | `uldaq-env` delivered the record: `git ls-remote https://github.com/jeonghanlee/uldaq-env` shows `master` at `29994f2`, and its session reports that the install step of that commit writes `<prefix>/cfg/uldaq/build-record` and its digest in the form of D31 and D32. The repository has no tag of the new form yet (its tags are `1.2.1` and `1.2.2`), so the installed record of that commit reads `tag=untagged`. |
| 2026-11-18 | Passed | `git ls-remote https://github.com/jeonghanlee/uldaq-env` shows the annotated tag `1.2.2-1` (tag object `598f1ce`) pointing at `29994f2`, the commit that writes the record. Both repositories now have a commit that writes the vendor record in the form of D31 and D32 and a tag of the form `<upstream version>-<N>` on it: `uldaq-env` `29994f2` with `1.2.2-1`, `open62541-env` `ab75700` with `1.3.15-2`. |

##### Closure Evidence

Both completion criteria are met on 2026-11-18. The tags that name the source of the 1.5.0 libraries were confirmed by their owners on 2026-11-14 (`uldaq-env` `1.2.2`, `open62541-env` `1.0.0`). The tag rule for later versions is `<upstream version>-<N>` (D32), and each repository carries its first tag of that form on the commit whose install step writes the vendor record (D31): `uldaq-env` `1.2.2-1` on `29994f2`, `open62541-env` `1.3.15-2` on `ab75700`, both read with `git ls-remote` on that date. The install behaviour and the test results of the two commits are reported by the sessions of those repositories and were not run from this repository. What the loader of this repository does with a vendor record is not part of this gate.

## Backlog

Two items are unassigned: M22 and M23.

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| M22 | Container-based test server for IOC checks that need a server | Milestone | Open | No | D23 | A test server, as a container or a program like `opcua-server-sim`, serves the IOC checks that need a server, the recceiver first, and the IOC verification uses it; [detail](#m22---container-based-test-server-for-ioc-checks-that-need-a-server) |
| M23 | Use the patch skill for the patch work of the next release | Milestone | Open | No | D28, D29 | The patch work of the next release is done with the skill `patch`, and each place where the skill and the repository documents differ is recorded and settled; [detail](#m23---use-the-patch-skill-for-the-patch-work-of-the-next-release) |

### Backlog Details

#### M22 - Container-based test server for IOC checks that need a server

Origin: 441e2e0 / M22
Identity History: none
GitHub Issue: none
Status: Open

##### Summary

The static and dynamic load checks of this repository run without an external service, but the IOC checks of some services need a server. The check of the reccaster fragment stops at the status records because delivery to a recceiver needs one (`verify_reccaster.sh`). The owner decided on 2026-11-14 to keep a test server for such checks as a backlog item, built the way `opcua-server-sim` serves OPC UA: a container-based server, or a program that serves the same purpose. The owner gives the program and the examples of earlier work later.

##### Scope

Decide the form of the test server (a container or a program) and the services it covers, the recceiver first, and decide how the IOC verification starts and stops it.

Out of scope: implementation before the decision, the module `reccaster` (M13), and a GitHub issue until the owner opens one.

##### Completion Criteria

- The decision on the form and the covered services is recorded, and the IOC verification of at least the recceiver delivery runs against the server on both test machines.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D23 applies.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence and resolve the scope questions above when this item is activated.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

#### M23 - Use the patch skill for the patch work of the next release

Origin: 441e2e0 / M23
Identity History: none
GitHub Issue: none
Status: Open

##### Summary

The skill `patch` of the `dev-env` repository states the rules for applying and reverting carried patches, holds the revert tool, of which `tools/revert_patch.bash` is a copy, and holds a condensed copy of the general stages of `docs/procedures/upstream-fix-carry-procedure.md`. The skill is the original of the rules and of the tool, and this repository is the source of the procedure copy (D28). The owner decided on 2026-11-16 that the next release uses the skill for its patch work (D29). The EPICS-env session reviewed the skill against the repository on that date and found the text in agreement, but no carry was run with it; D29 names the reviewed revision. The item is Open until the next release cycle starts.

##### Scope

At the next release, do the patch work with the skill: the selection of upstream fixes to carry, the generation and naming of the patches, apply and revert of the set, and the recovery after a second apply. The apply is done with the direct `patch` calls of this repository, not with the apply tool of the skill (D28, `docs/CLOSED_DOORS.md` K21). Before use, confirm that `tools/revert_patch.bash` of this repository equals the revert tool of the skill, and take the skill file when they differ (D28). Record each place where the skill is wrong, incomplete or differs from a repository document, tell the `dev-env` session, and settle it. Name the parts of the repository document that the skill alone served, as candidates for leaving the document (D28).

Out of scope: a change of the apply side, an edit of the copy `tools/revert_patch.bash` (a change of the tool is proposed to the skill), moving a part out of the repository document (a change of its own after this item, D28), editing the skill from this repository (the `dev-env` session is its writer), and a GitHub issue until the owner opens one.

##### Completion Criteria

- The patch work of the next release was done with the skill, and the record names the commit of the skill that was used.
- Each difference found between the skill and the repository is recorded with its outcome.
- The parts of `docs/procedures/upstream-fix-carry-procedure.md` that the skill alone served are listed for the owner's decision.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D28 and D29 apply. The item is Open until the release cycle of the next release starts; it then becomes Not started.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence when this item is activated with the release cycle.

##### Test Plan

No accepted test plan is recorded for this item. Define checks using the real implementation and required environment before execution.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |

##### Verification Results

No completed acceptance result is carried for this item. The context in Summary does not establish completion.

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |

##### Closure Evidence

None.

## History

| Reset Date | Prior State Commit |
| --- | --- |
| 2026-11-11 | 441e2e08467b3af7668a605c1447f5d07d23bce9 |
