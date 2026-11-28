# Work Register

Release line: master
Milestone index: 441e2e0
Canonical path: `docs/milestone-441e2e0.md`
Canonical branch or ref: master
Git upstream: origin/master
Remote tracker: jeonghanlee/EPICS-env; the open issues are in the GitHub milestone Backlog

Next session entry point: M1, M2, M3, M5, M6, M12, M13 and M19 are complete and their issues are closed, and M24, which has no issue, is complete; M4 (#99) is complete and its issue is closed: `opcua-server-sim` is the default server of the OPC UA loader example (D36), the fixture, its test, the guard of `guest-suite.bash` and the documents are commits `b4eb90f`, `8b9e2fd` and `4c41136`, T1 to T12 passed (the whole suite on both test machines, 349 checks, and the six CI systems on `ac94cca`); M26 (#146) is retired and its issue is closed as not planned: the exit crash of the `opcua` module after a server restart is already fixed in the upstream `master` (D38), so this repository carries no patch and takes the fix when the module is moved to upstream `master` with the module bump of the release, where `opcua-anon-ns-export` is retired, `opcua-CONFIG_OPCUA` stays and the limitation paragraph of the README of the opcua fixture is removed; D39 (2026-11-23) plans the release: M7 (Base to R7.0.11), M8 (pvxs), M9 (modbus) and M27 (the `opcua` module to upstream `master`, D38) are release work, and M23 (the skill `patch` of the `dev-env` repository for the patch work of the release, D29) records that work and waits for M7 and M8, and D40 defers M7, M8, M9, M23 and M27 until the release starts; M10, M11 and M22 run on the Base pin R7.0.10 and do not wait for them (M22 is complete (D45): its check passed on both test machines against the published image, the commit is `3ad58bd`, the CI of the six systems passed, and K22 of `docs/CLOSED_DOORS.md` records that the CI does not run it); M14 is retired by D42 and complete: the loader does not support pyDevSup, since that would need a general extension or a fragment of its own, and the Python work goes on separately, and its issue #139 is closed as not planned; M16 is retired by D39 and complete, and its issue #135 is closed as not planned; M15 and M17 stay Deferred; the implementation that follows M12 (identity of shared libraries by build-id) is the row M20, which is complete (#144): a build-id per library in `cfg/build-record` of format 2, a comparison in `iocsh.bash` before the IOC starts, and the exit statuses 64 and 78 are commit `49c5a4d`, and the six CI systems passed; the form of the vendor record, which the wrapper repositories asked about, is decided (D31, D32); from the next release the vendor sources are pinned by tag (D20), and the gate G2 is complete: both wrapper repositories write the vendor record in the decided form (D31, D32) and carry a tag of the new form on that commit (`uldaq-env` `1.2.2-1`, `open62541-env` `1.3.15-2`), and M21 (#145) is complete: `configure/RELEASE` pins the two wrapper tags, `tools/vendor-checkout.bash` takes them for the six OS workflows and the scripts, which is commit `0b8db64`, both test machines built the vendor libraries from the pins and passed the loader suite, and the six CI systems passed; M13 (reccaster as a new module next to recsync, issue #101) is complete: the CI of all six systems failed from the commit that added the module (`0291307`) because the audit of module dependencies marked `reccaster.dbd`, which both modules own, as unknown, and passes since the fix (D24, commit `6e35b28`), and #101 is closed; M24 (take the changed revert tool of the skill `patch`, D30) is complete: the tool, its record and the document lines are commit `2ad1ad0` on `origin/master`, and every check passed (T1 to T7); M10 is complete and its issue #142 stays open for M29: the pin `VENDOR_ULDAQ_TAG` is the tag `1.2.2-2` of `uldaq-env`, which is on `5bf26d9` and holds the timeout patch (the gate G4, observed 2026-11-27T08:02Z), the pin is commit `90eb845` (on `origin/master` at 2026-11-27T18:42Z), and both test machines built and loaded the patched library and passed the loader suite (349 checks), the reconnection test of the fork `1612c38` and the module cycle; the first run of the suite had failed until the plan rebuilt measComp after the install of the library (#3 and #5 of `uldaq-env` are complete, and #4, the alarm write, is closed as not planned and is not part of M10); M30 (the reconnection test and the vendor library update of the test machines as tools of `tools/module-check`) is Ready, and its plan was revised after its check that can fail (T4) did not fail on its first run, and the revised plan is accepted and authorized on 2026-11-27; T1 to T5 of the revised plan passed (the revised T4 failed `verify_install_metadata` as planned), and the row waits for its commit and the landing evidence; M11 has its checks T1 to T7 passed on 2026-11-25 (D44) and its hardware check T8 waits for the gate G5, the real TC32 session with the permission and the time of the owner of `tcmd`, which also carries M29, the real-device check of the timeout patch, a row of its own since D47 that waits for G5 now that M10 is complete (D46); M28 tracks the development loader of #143 as a Deferred item that the owner keeps so that the idea is not lost (D43); M18 (D35: `iocsh.bash` inserts `on error break` into a startup file that has none) is complete: the loader, its test section and the documents are commit `323c921`, the suite passed on both test machines, and the six CI systems passed, and the notice of its plan step 4 went to the 36 live peer sessions on 2026-11-21; M25 (D34) is complete: `iocsh.bash` compares the build-id of each vendor library that a selected module needs with the vendor records and refuses a start that differs (status 78), which is commit `69f03dc`, the whole suite passed on both test machines with the final files, and the six CI systems passed.

This document carries unfinished work after release 1.5.0. Completed results remain in the prior state named in History. Work continues on master with no release branch (D2), and the rows are taken in table order.

## Milestone

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| M1 | Port Python utilities to Perl | Milestone | Complete | No | D2, D5, D6, D7, D12 | The scoped tools, the two embedded helpers and their callers run without Python and match the existing results; [detail](#m1---port-python-utilities-to-perl) |
| M2 | Replace makeRPath.py in EPICS Base with Perl | Carry-forward | Complete | No | D2, D5, D8, D9, D10 | Base builds without Python through the Perl makeRPath and the rpath values match; [detail](#m2---replace-makerpathpy-in-epics-base-with-perl) |
| M3 | Minimal-example record counting | Carry-forward | Complete | No | D2, D13 | [Completion criteria](#m3---minimal-example-record-counting) |
| M4 | opcua-server-sim as the OPC UA example default | Carry-forward | Complete | No | D2, D14, D15, D36, G1 | The OPC UA loader example runs against `opcua-server-sim` built from source, with real example verification; [detail](#m4---opcua-server-sim-as-the-opc-ua-example-default) |
| M5 | Global IOC startup for common services | Carry-forward | Complete | No | D2, D16 | A global startup file loads the intended common services with a switch for each and passes their integrated verification; [detail](#m5---global-ioc-startup-for-common-services) |
| M6 | Lua database loading without macros | Carry-forward | Complete | No | D2, D17 | The real IOC with lua loaded survives a database load without macros, with a carried patch and verification evidence; [detail](#m6---lua-database-loading-without-macros) |
| M7 | Move EPICS Base to R7.0.11 | Milestone | Deferred | No | D2, D3, D39, D40 | Each Base patch is settled for the new pin and Base builds from it; [detail](#m7---move-epics-base-to-r7011) |
| M8 | Re-examine pvxs with the Base move | Milestone | Deferred | No | D3, D39, D40, M7 | The pvxs pin and patches are settled and pvxs builds on the new Base; [detail](#m8---re-examine-pvxs-with-the-base-move) |
| M9 | Update modbus to R3-5 | Milestone | Deferred | No | D2, D3, D39, D40, M7, M8 | The module cycle passes on both test machines; [detail](#m9---update-modbus-to-r3-5) |
| M10 | Carry the uldaq-env timeout patch | Milestone | Complete | No | D2, D3, D39, D46, D47, G4 | The pin of the vendor library names the tag of uldaq-env that carries the timeout patch, and both test machines build and load it and pass the measComp reconnection test and the module cycle with it; [detail](#m10---carry-the-uldaq-env-timeout-patch) |
| M11 | Move measComp to the jeonghanlee fork | Milestone | Blocked | No | D2, D3, D39, D44, D46, G5 | The measComp cycle and the TC32 reconnection checks pass; [detail](#m11---move-meascomp-to-the-jeonghanlee-fork) |
| M12 | Shared-library version identification | Carry-forward | Complete | No | D2, D18, D19 | [Completion criteria](#m12---shared-library-version-identification) |
| M13 | Migrate recsync to reccaster | Carry-forward | Complete | No | D1, D2, D22, D24 | [Completion criteria](#m13---migrate-recsync-to-reccaster) |
| M14 | Load pyDevSup through the IOC loader | Carry-forward | Complete | No | D4, D39, D41, D42 | Retired by D42: the loader does not support pyDevSup, since that would need a general extension or a fragment of its own, and the Python work goes on separately; [detail](#m14---load-pydevsup-through-the-ioc-loader) |
| M15 | Patch revert on macOS | Carry-forward | Deferred | No | D4 | [Completion criteria](#m15---patch-revert-on-macos) |
| M16 | Original OPC UA demo startup data | Carry-forward | Complete | No | D4, D39 | Retired by D39: the original startup files are removed and `opcua-server-sim` is the example default, so no original startup is left to verify; [detail](#m16---original-opc-ua-demo-startup-data) |
| M17 | Libera cross-build and generated profile | Carry-forward | Deferred | No | D4 | [Completion criteria](#m17---libera-cross-build-and-generated-profile) |
| M18 | Insert `on error break` in `iocsh.bash` when the startup file has none | Carry-forward | Complete | No | D2, D35 | `iocsh.bash` inserts `on error break` in place of the first directive line of a startup file that has a directive and no `on error` line, as D35 states, with tests on both test machines; [detail](#m18---insert-on-error-break-in-iocshbash-when-the-startup-file-has-none) |
| M19 | Base unit test of makeRPath.pl | Milestone | Complete | No | D2, D8, D11, M2 | `test/tools/makeRPath.plt` runs under `make runtests` of the patched Base on Perl 5.10.1, 5.26.3 and 5.40.1 and each case is shown able to fail; [detail](#m19---base-unit-test-of-makerpathpl) |
| M20 | Record library fingerprints in the loader metadata and check them at start | Milestone | Complete | No | D18, D19, D25, D26, D27, M12 | `cfg/build-record` carries a build-id for each library (format 2, with a digest), `iocsh.bash` refuses a start whose module libraries differ from it, and the tests pass on both test machines; [detail](#m20---record-library-fingerprints-in-the-loader-metadata-and-check-them-at-start) |
| M21 | Pin the vendor library sources by tag | Milestone | Complete | No | D20, D21, G2 | The OS workflows and the scripts that install the vendor libraries use `uldaq-env` and `open62541-env` at pinned tags, with a pin variable for each and verification on both test machines; [detail](#m21---pin-the-vendor-library-sources-by-tag) |
| M22 | Container-based test server for IOC checks that need a server | Milestone | Complete | No | D23, D39, D45, G3 | The IOC check of the reccaster fragment runs against a recceiver in the published Debian 13 container image on both test machines: the recceiver reaches the IOC, the IOC connects, and the recceiver receives its channel list; [detail](#m22---container-based-test-server-for-ioc-checks-that-need-a-server) |
| M23 | Use the patch skill for the patch work of the next release | Milestone | Deferred | No | D28, D29, D39, D40, M7, M8 | The patch work of the next release is done with the skill `patch`, and each place where the skill and the repository documents differ is recorded and settled; [detail](#m23---use-the-patch-skill-for-the-patch-work-of-the-next-release) |
| M24 | Take the revert tool from the patch skill | Milestone | Complete | No | D28, D30 | `tools/revert_patch.bash` is the revert tool of the skill `patch` with a record of its origin beside it, the documents state its exit statuses, and the round trip of the patch set passes on both test machines and in CI; [detail](#m24---take-the-revert-tool-from-the-patch-skill) |
| M25 | Compare the vendor libraries with their record before an IOC starts | Milestone | Complete | No | D18, D25, D26, D31, D32, D34, M20, M21 | `iocsh.bash` reads the vendor records and treats a vendor library that a selected module needs as the accepted plan states, with tests on both test machines; [detail](#m25---compare-the-vendor-libraries-with-their-record-before-an-ioc-starts) |
| M26 | Fix the exit crash of the `opcua` module after a server restart | Milestone | Complete | No | D36, D37, D38, M4 | Retired by D38: the fix is in upstream `master` and this repository takes it with the module bump of the release, so no patch of its own is written; [detail](#m26---fix-the-exit-crash-of-the-opcua-module-after-a-server-restart) |
| M27 | Move the `opcua` module to upstream master with the module bump | Carry-forward | Deferred | No | D38, D39, D40, M7, M8 | The `opcua` module is pinned to a commit of the upstream `master`, `opcua-anon-ns-export` is retired, `opcua-CONFIG_OPCUA` still applies, and the repeated runs of the opcua fixture test end with status 0; [detail](#m27---move-the-opcua-module-to-upstream-master-with-the-module-bump) |
| M28 | Add a development loader for modules outside the installed tree | Milestone | Deferred | No | D43 | `tools/dev_iocsh.bash` starts an IOC through the installed `softIocPVX` with modules taken from directories outside the installed tree, `iocsh.bash` behaves as before, and the new test file and the documents are in place; [detail](#m28---add-a-development-loader-for-modules-outside-the-installed-tree) |
| M29 | Check the ULDAQ timeout patch on a real TC32 | Milestone | Blocked | No | D2, D3, D39, D46, D47, M10, G5 | In one session on a real TC32 without EXP-32, a failed command of the library in the lab tree, whose commit equals that of the tag that M10 pins, ends after the command timeout with error 7, and the times of the attempts are recorded with the identity of the library; [detail](#m29---check-the-uldaq-timeout-patch-on-a-real-tc32) |
| M30 | Move the reconnection test and the vendor library update into tools/module-check | Milestone | Not started | Yes | D2, D3 | `tools/module-check/guest-meascomp-reconnect.bash` runs the cases and the exit loop of the measComp fork at the pin of `configure/RELEASE` with no value of a machine in the file, `tools/module-check/guest-vendor-update.bash` installs `uldaq-env` at its pin and rebuilds measComp, both pass on the two test machines with the results of the checks of M10, and the tools reference lists them; [detail](#m30---move-the-reconnection-test-and-the-vendor-library-update-into-toolsmodule-check) |
| G1 | open62541-env changes committed | External gate | Complete | No | | The changes that `opcua-server-sim` needs in `open62541-env` (`CMAKE_EXTRA_OPTIONS` support and `patch/1.5.10.p0.patch`) are committed in that repository; [detail](#g1---open62541-env-changes-committed) |
| G2 | uldaq-env and open62541-env pin tags | External gate | Complete | No | | Each of the two repositories has a tag that names the source of the vendor library version that EPICS-env pins, with the commit recorded by its owner; [detail](#g2---uldaq-env-and-open62541-env-pin-tags) |
| G3 | recceiver test image available | External gate | Complete | No | | The image `jeonghanlee/debian13-epics-recceiver-test:1.5.0.1` holds the recsync server at `9834b94` with its packages pinned by version and is published on Docker Hub at the digest recorded in the detail; [detail](#g3---recceiver-test-image-available) |
| G4 | uldaq-env tag with the timeout patch | External gate | Complete | No | | `uldaq-env` has a tag of the form `<upstream version>-<N>` (`1.2.2-2`) on a commit that holds `patch/1.2.2-net-timeout.p0.patch`, and its owner has recorded the commit; [detail](#g4---uldaq-env-tag-with-the-timeout-patch) |
| G5 | Real TC32 session and its permission | External gate | Open | No | | The owner of the TC32 has given the permission and the time for one session that cuts its power, pulls its network cable and stops the IOC that normally runs on it; [detail](#g5---real-tc32-session-and-its-permission) |

Tally: 35 items, 23 Complete (M1, M2, M3, M4, M5, M6, M10, M12, M13, M14, M16, M18, M19, M20, M21, M22, M24, M25, M26 and the gates G1, G2, G3 and G4), 1 Not started (M30), 2 Blocked (M11 and M29, both by G5), 8 Deferred (M7, M8, M9, M15, M17, M23, M27 and M28) and 1 Open (the gate G5). Ready: M30. G5 waits for the permission and the time of the owner of `tcmd` for the real TC32 session and blocks M11 and M29 (D46, D47). The Backlog holds no item.

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Keep recsync at 9834b94edc63eece42712b8355a4703d4286dd8f until the separately scoped client migration. From 1.10.0 the recsync repository contains a stub client Makefile that exits 1; the client moved to ChannelFinder/reccaster, whose 1.9.7 commit bebf91f54faf93a59eb4538d3594a687a8823963 has no shared history with the pin. The repository switch is module source work tracked by #101. | 2026-11-11 |
| D2 | Continue on master with no release branch and no release. Take the rows in table order, the lightest first and one at a time, and hand the work over when enough of it is complete. The release number and the tie of the Base pin to a publication date, recorded in the prior state, are not carried. Partly replaced by D39. | 2026-11-11 |
| D3 | Move EPICS Base from `tags/R7.0.10` to `tags/R7.0.11` as a work item (M7) and examine the pvxs pin and patches together with it (M8). | 2026-11-11 |
| D4 | Defer M14 through M17 and place them after the other rows: they need a pyDevSup exploration that is not yet scoped, a macOS machine, a registered download of the Unified Automation example server, or a real nine-module cross-build. A new dated decision returns one of them to Not started. D39 returns M14 to Not started and retires M16; M15 and M17 stay deferred. | 2026-11-11 |
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
| D33 | Form of the vendor tag pin (M21). The pinned tags are the new ones, `1.2.2-1` of `uldaq-env` and `1.3.15-2` of `open62541-env`, whose install steps write the vendor record. The pin variables are `VENDOR_ULDAQ_TAG` and `VENDOR_OPEN62541_TAG` in `configure/RELEASE`, each beside the path line of its library, with the plain tag name as value. One helper, `tools/vendor-checkout.bash <wrapper> <directory>`, takes the pin for every caller: it clones the tag when the directory is absent and checks an existing directory, and the six OS workflows and the scripts call it. An existing checkout that is not at the commit of the pinned tag, or that has a changed tracked file, stops the helper with a message; the helper never changes an existing checkout. The option `--any-commit` skips that check for work on a wrapper together with this repository, and the helper says so. The verification rebuilds the vendor libraries of the sandboxes on both test machines from the pinned tags and runs the whole loader suite there. The row gets a GitHub issue. | 2026-11-18 |
| D34 | What the loader does with a vendor record (M25). `iocsh.bash` compares the build-id of each vendor library that its static inspection resolves for the selected modules with the vendor record, by the same means as for a module library, and refuses the start with status 78 when they differ. A resolved vendor library that no record names is passed and is marked `not recorded` in the show mode, so that a tree of release 1.5.0 and a vendor directory installed before the wrapper tags `1.2.2-1` and `1.3.15-2` keep starting. A vendor record that differs from its digest file, or that has a format number the loader does not read, refuses the start with status 78. The loader reads every `vendor/cfg/*/build-record` and finds the line of a file by its path relative to `vendor`; two records that name the same path are an error. A check at build time of the vendor record against the pinned tag is not part of this row. | 2026-11-18 |
| D35 | `iocsh.bash` inserts `on error break` into a startup file that has none (M18). When a startup file has at least one directive and no line whose first two words are `on error` (leading blanks allowed, any mode), the loader writes `on error break # added by iocsh.bash` in place of the copy line of the first directive, so that no line moves and the line numbers of IOC messages keep matching the original file; the mode applies from that line on. A file that has an `on error` line, a file without a directive and a start without a startup file are unchanged. The way to keep the old behaviour is the line `on error continue` in the file; no option or variable is added. The loader says that it added the line, and at which line, by appending `; on error break added at line <line>` to the start message (`iocsh.bash: <file> runs as /dev/fd/4; generated startup runs as /dev/fd/3`) and to the last line of the output of `-n` (`# iocsh.bash: <file> runs as /dev/fd/4 with <n> lines, directives replaced by comments`); the text of the directive is not copied into the inserted line, because iocsh expands macros in a trailing comment. A startup file that relied on an error that does not stop the start now stops at its first error, and the IOC ends with a non-zero status. | 2026-11-20 |
| D36 | The development of `opcua-server-sim` is finished (owner, 2026-11-21), which is the condition of D15: M4 returns to Not started and then starts under its accepted plan. The fixture takes the simulator `master` at `899bc67c798effe35c2e02e7540c96c4e05b1620` and the branch `1.5` of `open62541-env` at `fc8cc33897c84dca699a3e1a7d998ce3e2748dfe`, pinned by commit id; the owner moves the pin by a later instruction. It runs the IOC files `ioc/st.cmd` and `ioc/composite.db` of the simulator unchanged through `iocsh.bash` of the tree under test, and it does not run the simulator's own tests. No container tool is needed anywhere in the suite, its guard or its documents, because the simulator replaces the Milo container: the guard of `tools/module-check/guest-suite.bash` and the lists and install commands of six documents lose that requirement. | 2026-11-21 |
| D37 | The exit crash of the `opcua` module after a server restart (M26) is fixed first with a patch that this repository carries, and the report to the upstream repository `epics-modules/opcua` is written only after the patch is verified (owner, 2026-11-22). Replaced by D38. | 2026-11-22 |
| D38 | The exit crash of the `opcua` module after a server restart (M26) is already fixed in the upstream `master` of `epics-modules/opcua`: the commits `608ba37` ("Fix crash/hang when exiting the IOC while a session (re)connects") and `454525f` ("open62541: serialize all client accesses under clientlock") of 2026-11-03 follow the release v0.11.2, which has the crash and is the latest release. This repository therefore carries no patch for it and writes no report to the upstream repository. It takes the fix when the module is moved to upstream `master` with the module bump of the release, which also handles the upstream patches and the carried patches: the patch `opcua-anon-ns-export` is then retired, because the upstream code already holds its change, and the patch `opcua-CONFIG_OPCUA` stays, because it applies to `master` (`eb098d6`, checked 2026-11-22 with a dry run; upstream builds `master` with open62541 1.3.15, the version of the vendor library). Until then the README of the opcua fixture states the limitation. D38 replaces D37. | 2026-11-22 |
| D39 | The next release is planned. The Base move (M7), the pvxs examination (M8), the modbus update (M9) and the move of the `opcua` module to upstream `master` (M27) are release work, and the patch work of the release is done with the skill `patch` and recorded by M23 (D29), which therefore waits for M7 and M8. The rows M10, M11, M14 and M22 run on the Base pin `tags/R7.0.10` and do not wait for M7 or M8. M22, M23 and M27 move from the Backlog to the Milestone. M14 returns to Not started, and its first step is to find the scope of the exploration. M16 is retired because the original startup files of the opcua example are gone and `opcua-server-sim` is its default (D36, commit `b4eb90f`); the row is Complete since its issue #135 was closed on 2026-11-23. M15 and M17 stay Deferred (D4). D39 replaces D2 where it says that there is no release, and D4 for M14 and M16. | 2026-11-23 |
| D40 | The release rows M7, M8, M9, M23 and M27 are Deferred until the release starts; none of them is started before. A new dated decision at the start of the release returns them to Not started. D40 keeps what D39 says about them: they are release work with their dependencies and order. | 2026-11-23 |
| D41 | The loader loads pyDevSup into a plain IOC (M14, #139). The library stem is computed where `pyDevSup_IOCSH_LIBS` is declared, from `PY_LD_VER` of the build and not from `PY_VER`, so the written metadata names the exact library (`libpyDevSup3.13.so` on Debian 13, `libpyDevSup3.6m.so` on Rocky Linux 8.10); the loader parser does not change. The Python package path is set in the metadata of the module if the check M14 / T2 shows that a plain IOC needs it. The real record of the check is chosen from the examples of the module after M14 / T3. The Keep verdict of `docs/CLOSED_DOORS.md` that the loader needs no DBD list for pyDevSup gets a new dated entry in the commit that carries the change (owner, 2026-11-23). Replaced by D42. | 2026-11-23 |
| D42 | M14 (load pyDevSup through the loader, #139) is not carried out. The check M14 / T2 of 2026-11-23 showed that a plain IOC needs more than the plan declared: the three device DBD files that sit in the Python package tree of the module and not in its `dbd` directory, the command `import devsup` after the registration of the library, and the variable `PYDEV_BASE`, without which the IOC imports `devsup` from the install path that the build recorded. That needs a general extension of the loader metadata or a fragment of its own for one module, and the owner decided that this is too much work for the item: the loader does not support pyDevSup, and the Python work goes on separately from this register. The implementation authorization of the same day ends with this decision. D42 replaces D41. | 2026-11-23 |
| D43 | The development loader of issue #143 (`tools/dev_iocsh.bash`, an IOC through the installed `softIocPVX` with modules from directories outside the installed tree) is only tracked, as M28 with the status Deferred, so that the idea is not lost. The owner recalls that the earlier work stopped because the loader needed too many changes, and that the work went on with a new iocsh instead. The draft plan of the snmp3 session of the lab host (revision 9, based on `62599f0`, never accepted) is not taken over, and no work starts on the item (owner, 2026-11-23). | 2026-11-23 |
| D44 | M11 (move measComp to the jeonghanlee fork, #120): the pin is `SRC_BASE_MEASCOMP=$(SRC_URL_JEONGHANLEE)` with the commit id of the head of `origin/site` of the fork read at the start of the work, not a branch name. The patch `measComp-tc32-chan-count` is retired because the pinned source, the fork, holds its change as the commit `f69e794`; its rule, its entries in the `patch` and `patch.revert` lists and its section of `patch/README.md` are removed in the same change as the pin move. The patch `measComp-CONFIG_MEASCOMP` stays. The reconnection test of the fork is a separate check on the sources of the pinned fork commit with the Base, asyn and ULDAQ of the installed tree, and is not part of the loader suite; no further reconnection check of the installed library is planned beyond the module cycle, the loader suite and the hardware check. The hardware check on a real TC32 without EXP-32 stays open until a device is available, and the row is not Complete before it unless the owner records a dated exception. The check that the fork test can fail (T5) runs its nine original-behavior controls and four mutation controls of the reconnect core, thirteen scratch builds, not all 52 mutations; the halving of the temperature channel count, which the fork test cannot detect, is read in the pinned source and shown on the hardware (owner, 2026-11-24). | 2026-11-24 |
| D45 | M22 (container-based test server): the scope is that a recceiver reaches the IOC, the IOC connects to it, and the recceiver receives the channel list of the IOC, with no ChannelFinder. The image lives in the `Dockerfiles` repository, whose session builds it, and the check pulls a ready-made image and does not build it at each run. There is one image, for Debian 13: `jeonghanlee/debian13-epics-recceiver-test:1.5.0.1` on Docker Hub, built from `jeonghanlee/debian13-epics-runner:1.5.0.1` with the recsync server at `9834b94` and the recceiver as a second `s6` service; there is no Rocky Linux image, and the same image runs on both test machines under `podman`. The IOC of the check is the `demo` binary of the image tree with the fragment `reccaster.iocsh` of this repository mounted read-only, and the delivery check is a new script beside `verify_reccaster.sh`, which stays unchanged. | 2026-11-26 |
| D46 | The remaining work on the ULDAQ patch and on the real TC32 (M10, M11): (1) the alarm configuration write (`uldaq-env#4`, closed as not planned on 2026-11-26 because no write command is known) is not part of M10, which carries the timeout patch `1.2.2-net-timeout.p0.patch` of `uldaq-env#3` and `#5` through a new tag of `uldaq-env` that `VENDOR_ULDAQ_TAG` pins (the gate G4); (2) measComp `1612c38` and the patched ULDAQ are checked as one pair on a real TC32, in one session that covers the hardware check M11 / T8 and the real-device check M10 / T3, and the result is recorded in both rows with the identity of the library (the build record: tag, source commit, patch); a result on an untagged build holds when the tag is later put on the same commit and is repeated when it is put on another; (3) the session needs the permission and the time of the owner of the TC32 (the gate G5). | 2026-11-26 |
| D47 | The real-device check of the timeout patch is a row of its own, M29, and the gate G4 is complete. (1) M10 carries the pin, the documents and the checks on both test machines (T1 and T2) and no longer depends on G5; its former real-device check T3 is M29 / T1, which depends on M10 and on G5 and is done in the one session of D46 together with M11 / T8, so D46 reads M29 / T1 where it says M10 / T3. (2) The second completion criterion of G4, that the build record of a build from the tag names the tag and the patch, moves to M10 / T1, because a gate that M10 waits for cannot hold a result of M10; G4 is complete by its tag, the commit that holds the patch and the record of the owner of `uldaq-env`. (3) M10 can be started and finished while G5 is open; the real-device result is then the work of M29, and the issue #142 keeps the real-device criterion, so it stays open when M10 is complete and is closed when M29 is complete. (4) The library of the real-device session is the one in the lab tree of the unit, and M29 compares its commit with the commit of the tag that M10 pins before the session. | 2026-11-27 |

### ID Migration

| Old ID | Current ID | Reason | Updated References |
| --- | --- | --- | --- |
| M6 | M2 | The row was moved to the second position so that both Python removals come first. | work table row, detail heading, detail links |
| M2 | M3 | Shifted by the move of M6. | work table row, detail heading, detail links |
| M3 | M4 | Shifted by the move of M6. | work table row, detail heading, detail links |
| M4 | M5 | Shifted by the move of M6. | work table row, detail heading, detail links |
| M5 | M6 | Shifted by the move of M6. | work table row, detail heading, detail links |

### Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| --- | --- | --- | --- | --- |
| 441e2e0 / M22 | docs/milestone-441e2e0.md, Backlog | docs/milestone-441e2e0.md, Milestone | this synchronization commit | this synchronization commit |
| 441e2e0 / M23 | docs/milestone-441e2e0.md, Backlog | docs/milestone-441e2e0.md, Milestone | this synchronization commit | this synchronization commit |
| 441e2e0 / M27 | docs/milestone-441e2e0.md, Backlog | docs/milestone-441e2e0.md, Milestone | this synchronization commit | this synchronization commit |

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
Status: Complete

GitHub state observed: CLOSED (reason completed) at 2026-11-23T01:59:48Z; its body was rewritten before with D36 and the removal of the container requirement, and at the close all six criteria were checked with a result each, and a closing comment names the commits. Recheck with `gh issue view 99 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

The OPC UA loader example runs against an open-source server so that the documented example needs no proprietary server file and no container tool. The owner decided on 2026-11-14 that the server is `opcua-server-sim` (https://github.com/jeonghanlee/opcua-server-sim, Apache-2.0, a C server on open62541 with the model `s7-1500-composite` and an IOC startup and databases of its own), built from source; the client is the installed distribution, the IOC with the `opcua` device support module. The example today has a startup file for the Unified Automation demo server and one for the Eclipse Milo demo server, and its verification starts the Milo container. The planning detail is `work/plan-opcua-sim-default.md` of the working copy; the decisions that matter are in D14.

##### Scope

Change the existing directory `examples/iocsh/opcua-IOC-demo` in place, keeping its name, so that it holds the example for `opcua-server-sim`: a preparation script that places the server and `open62541-env` at recorded revisions with `examples/iocsh/checkout_application.bash` and builds them, the README, the test in `examples/iocsh/tests/verify_fixture_opcua.bash`, the book page and the expected output of the suite; the IOC runs the startup file and the database of the simulator unchanged (D36). Remove the Milo variant (`st-milo.cmd`, the container steps, the README section) and the Unified Automation startup file and its no-server checks. Observe IOC restart without a server restart, and server stop and start, and document the observed behavior. Remove the requirement of a container tool (`docker` or `podman`, the Milo image, access to `docker.io`) from the guard of `tools/module-check/guest-suite.bash` and from the documents that state it (D36).

Out of scope: the container image of the simulator (the move to it is a later change), the idea of one binary in an application image, an imitation of Unified Automation nodes, an implicit upgrade of the `opcua` or open62541 modules, Alarms and Conditions events and method calls (the module does not use them), and the original Unified Automation startup data (M16).

##### Completion Criteria

- The documented default example prepares, builds the server and connects without a proprietary server file or a container tool on Debian 13 and Rocky Linux 8.10.
- Server identity, device support, subscription updates, values, timestamps, alarms and bounded reads are checked through the real installed module and IOC.
- IOC restart and server restart have observed results, and a limitation that remains is accepted and documented.
- Startup path, preparation, documentation and the shipped suite agree, and no unexecuted check of another server is presented as a result of this one.
- No container tool is required by the suite, its guard or its documents.

##### Dependencies And Decisions

D2, D14 and D36 apply. D15 deferred the row until the development of the simulator was finished; D36 (2026-11-21) records that it is finished and returns the row to Not started, and the row then ran under the accepted plan. G1 is Complete (the `open62541-env` changes are committed on the branch `1.5`, observed 2026-11-22T06:22Z), so the recorded pair of revisions names a reproducible build.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-21, accepted by the owner after three third-person and two second-person passes on `work/plan-opcua-sim-default.md`
Implementation Authorization: 2026-11-21, authorized by the owner
Superseded Plan Artifacts: `work/scratch/plan-opcua-sim-default-2026-11-13.md` (the draft of 2026-11-13, replaced after the simulator was finished and the owner decided that no container tool is needed)

The plan is `work/plan-opcua-sim-default.md` (2026-11-21); its steps follow D36. Its local labels T0 to T11 are T1 to T12 here.

1. T1 on both test machines before any file of the repository is changed: the tools of the plan, the build of the simulator at the pinned commits and the tests `t/ioc.t` of the simulator against the installed tree; record revisions, times and free disk. A missing tool or a failing step stops the plan.
2. Write the fixture in place: `prepare.bash` (two checkouts at the pinned commits through `checkout_application.bash` with two run directories, the build of open62541 and the server, `make certificate`, the PKI and identity files), the README and `examples/iocsh/tests/verify_fixture_opcua.bash`; remove `st.cmd`, `st-milo.cmd` and the Milo and Unified Automation steps.
3. Remove the container requirement from the guard of `tools/module-check/guest-suite.bash` and from `run-loader-verification-suite.md`, `tools-and-scripts.md`, `module-bump-procedure.md`, `release-procedure.md`, `examples/iocsh/tests/README.md` and the book page that names the example.
4. T2 to T6 on both machines, T7 and T8 locally, T9 on one machine, T11 on one machine and locally, then T10; fix what the runs show.
5. Record the results here and in the text of #99, whose title changes from Milo to the simulator; each commit, push and issue operation waits for its own trigger; T12 follows the push.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Premise | check the tools with `command -v` and `pkg-config`; build the simulator at `899bc67` with `open62541-env` at `fc8cc33` and run its `t/ioc.t` against the tree; record times and free disk | both test machines | every tool is found, the build exits 0 and `t/ioc.t` passes; a missing tool or a failing step stops the plan and is reported |
| T2 | Preparation | `prepare.bash` on a clean run directory | both machines | exits 0 without a proprietary file or a container tool; both checkouts at the pinned commits, unmodified |
| T3 | Data path | server and IOC; `caget SIM:Static:Int SIM:Mode`, a structure member, an array, a clock record, one subscription update, the secured session value | both machines | `42` and `8`; the other values equal what the model gives; the update arrives within a stated bound |
| T4 | Two libraries | memory maps of the server and the IOC | both machines | the server maps `libopen62541` 1.5.10 from its prefix, the IOC maps 1.3.15 from the tree `vendor`; neither maps the other |
| T5 | IOC restart | stop the IOC and start it again without restarting the server | both machines | the second session connects, no `INVALID` and no `COMM` |
| T6 | Server restart | stop the server, observe the records, start it, observe | both machines | the recovery behavior is recorded; a limitation is stated in the README |
| T7 | Agreement | startup path, preparation, README, book page and the expected output of the suite compared | local checkout | they name the same files, variables, pins and results |
| T8 | No false claim | search of README, book pages, the test and the documents named in the plan for statements about Unified Automation or Milo | local checkout | none presents an unexecuted check of another server as a result of this one |
| T9 | Checks can fail | scratch mutations: a wrong node id in a database copy, a stopped server, a wrong pinned commit | one test machine | each fails the intended check |
| T10 | Suite | `examples/iocsh/tests/run_all.bash` through `tools/module-check/guest-suite.bash` | both machines | the suite passes with the new fixture |
| T11 | No container tool | the changed `guest-suite.bash` on a machine or with a scratch `PATH` where `command -v docker podman` finds nothing, up to its preflight; a case-insensitive search of the repository for `docker`, `podman`, `milo` and `digitalpetri`, leaving out `.git`, `work/`, `epics-base-src`, `docs/archive/`, `ChangeLog.md`, `docs/README.md` and this register | one test machine, local checkout | the preflight does not refuse for a missing container tool; the search finds no line |
| T12 | CI | the pushed change | six systems | pass (the CI does not run the loader suite) |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-22T06:26Z | sandboxes of Debian 13 and Rocky Linux 8.10, a new run directory on each; the simulator `899bc67c798effe35c2e02e7540c96c4e05b1620` and `open62541-env` `fc8cc33897c84dca699a3e1a7d998ce3e2748dfe` cloned and checked out | Pass on both: every tool and the development files were found; `make open62541` exited 0 (119 s on Debian 13, 167 s on Rocky Linux 8.10), `make check-open62541` and `make build probe certificate` exited 0, and `t/ioc.t` of the simulator passed 28 checks (13 s and 23 s); the run directory used about 0.48 GB | `work/scratch/m4/t1-log-debian13.txt`, `t1-log-rocky8.txt`; `~/sandbox/m4-t1/` on each machine |
| T2 | 2026-11-22T06:37Z | both machines, `verify_fixture_opcua` through `guest-suite.bash`, test script `b7aabaa7d2a84e4a`, `prepare.bash` `9445f2d9c8e39dd8`; the 28-check test script ran ten times in all, six on Debian 13 and four on Rocky Linux 8.10 (two direct runs, the repeated runs and the first whole suite of T10), after two earlier runs with a script that had one wrong check; the 31-check script `d9775d7edc33f2e6` then ran once on each machine (2026-11-23T00:13Z) and in the second whole suite of T10 | Pass on both in every run of the 28-check script: `prepare.bash` exits 0, prints the two pinned revisions that equal the heads of the checkouts, and both checkouts have no modified tracked file; the Rocky Linux 8.10 runs used the free-space limit of `guest-suite.bash` lowered to 2000000 KB for that one script, because 5.0 GB were free | `work/scratch/m4/f2-debian13.out`, `f2-rocky8.out`, `loop-debian13.out`, `loop-rocky8.out` |
| T3 | 2026-11-22T06:37Z | as T2 | Pass on both in all ten runs of the 28-check script (28 checks, no failure): the server listens on 4840; the IOC reaches `iocInit` and both sessions connect, the secured one as the user of the simulation file with mode `SignAndEncrypt` and policy `Basic256Sha256`; `SIM:Mode` is 8; the start values are Bool true, Byte 171, Word 52719, Int 42; `SIM:Udt:Int` is 42; the array record holds 38 elements; `SIM:Secure:Byte` is 171; device support is `OPCUA` on `I/O Intr`; `SIM:Clock:Byte` took 21 to 25 distinct values in 6 s in the runs whose count was read; `SIM:Static:Int` has no alarm. The criterion of this row also names the server identity, the timestamps and bounded reads, which the first version of the script did not check; on 2026-11-22 three checks were added (31 checks in all) and passed on both machines: the module reports through `opcuaShowSecurity OPC1` the application name and URI that `server.json5` configures, the timestamp of `SIM:Clock:Byte` advances between two reads 1.2 s apart, and a read of `SIM:Static:Int` returns 42 in 47 ms on Debian 13 and 40 ms on Rocky Linux 8.10 (limit 2 s) | as T2, and `work/scratch/m4/g1-debian13.out`, `g1-rocky8.out` |
| T4 | 2026-11-22T06:37Z | as T2 | Pass on both in all ten runs of the 28-check script: the server maps `libopen62541.so` from the install prefix of the run, whose `config.h` names 1.5.10 (the library is one file, because the 1.5.10 patch removes the SONAME); the IOC maps `libopcua.so.0.11` of the `opcua` module of the tree and `libopen62541.so.1.3.15` from the `vendor` directory, and nothing from the prefix of the run | as T2 |
| T5 | 2026-11-22T06:37Z | as T2 | Pass on both in all ten runs of the 28-check script: a second IOC session started while the server keeps running reaches `iocInit`, reads `SIM:Mode` 8 and has no alarm on `SIM:Static:Int` | as T2 |
| T6 | 2026-11-22T06:37Z | as T2 | Pass on both in all ten runs of the 28-check script: after the server stops, `SIM:Static:Int` is `INVALID` with `COMM` at once; after the server starts again it returns to no alarm without an IOC restart, which took 5 s in every run whose time was read, and `SIM:Mode` and `SIM:Static:Int` have their values again. Limitation: the IOC that lived through that stop and start ended with exit status 139 (SIGSEGV) in four of nine runs on Debian 13 (two direct runs and both whole suites of T10) after it printed `OPC UA session OPC2: disconnected`, and with status 0 in the other five and in all seven runs on Rocky Linux 8.10; an IOC without a server restart ended with 0 in every run; the cause is not investigated, the test prints that status and does not fail on it, and the README states it | as T2 |
| T7 | 2026-11-22T07:27Z | local checkout | Pass: the two pins in `prepare.bash` equal the two in the README; the test has 28 checks, as the tests README and the README of the fixture state; the files that the README names exist | `work/scratch/m4/local-checks.log` |
| T8 | 2026-11-22T07:27Z | local checkout | Pass: a search of `examples`, `docs/src`, `docs/procedures` and `tools` for `unified automation`, `UaDemo`, `st-milo` and `milo` finds no line, so no statement about another server remains | `work/scratch/m4/local-checks.log` |
| T9 | 2026-11-22T06:53Z | Debian 13 sandbox, a scratch repository holding the real test script, the real `prepare.bash`, the real simulator build and the real installed tree, with one change each | Pass: a wrong node id in the database that the IOC loads (`myInt` to `myIntX`) fails the check of the start values and four more (23 passed, 5 failed); the server stopped before the IOC starts fails the checks of the sessions, the mode and the values (18 passed, 10 failed); the simulator revision with its last digit changed fails `prepare: exits 0` and the checks that depend on it (8 passed, 20 failed). The three checks added on 2026-11-22 fail one each on a changed copy of the test (preparation skipped, which is why the unchanged copy shows 28): the expected application URI with a letter added fails the identity check, the second timestamp set equal to the first fails the timestamp check, and the read limit set to 1 ms fails the read check | `work/scratch/m4/mut-debian13.out`, `mut3-debian13.out`; `~/sandbox/m4-t9-065342/` |
| T10 | 2026-11-23T00:23Z | both machines, the whole suite through `guest-suite.bash`, checkout `30c6919` with the files of the change laid over it, loader `3268bc2fce587c00`, test script `d9775d7edc33f2e6`, `guest-suite.bash` `c80281f02c787698` | Pass on both: status 0, 18 scripts with exit 0, 349 checks passed on Debian 13 and the same per-script counts on Rocky Linux 8.10, none failed (1163 s and 1029 s), `verify_fixture_opcua` 31 and `verify_shell_lifecycle` 45. The same suite had passed on 2026-11-22T07:07Z with the 28-check script (346 checks, 1131 s and 1012 s) | `work/scratch/m4/suite2-debian13.out`, `suite2-rocky8.out`; the first run `suite-debian13.out`, `suite-rocky8.out` |
| T11 | 2026-11-22T07:27Z | Debian 13 sandbox with a scratch `PATH` of 1495 links that leaves out `docker` and `podman`, and the local checkout | Pass: with that `PATH` `command -v docker podman` finds nothing, and the changed `guest-suite.bash` (no `docker-or-podman` line) ran `verify_directives` with status 0 and 15 checks; a case-insensitive search of the repository for `docker`, `podman`, `milo` and `digitalpetri`, leaving out the paths of the plan, finds no line; `bash -n` and shellcheck are clean on the three changed scripts | `work/scratch/m4/guard-debian13.log`, `local-checks.log` |
| T12 | 2026-11-23T01:51Z | CI of commit `ac94cca0c48d62001ade86c6ff4e941090ec5e77` on `origin/master`, which holds the three added checks and the READMEs (`4c41136`) and the register (`ac94cca`) on top of the fixture (`b4eb90f`), the removal of the container requirement (`8b9e2fd`) and the register (`8687282`) | Pass: the six OS workflows and the linter ended with success (7 runs: Debian 12, Debian 13, Rocky 8, Rocky 10, Ubuntu 24.04, Ubuntu 26.04, Linter Run); `Deploy Docs` did not run, because it starts only for a change under `docs/src`, `docs/book.toml` or its own file, and this push changed none of them. The same six OS workflows, the linter and the documentation deployment had passed on `8687282` (2026-11-22T19:32Z) | `gh run list --repo jeonghanlee/EPICS-env --commit ac94cca0c48d62001ade86c6ff4e941090ec5e77`; run ids 45092852982, 45092852971, 45092853064, 45092853018, 45092852996, 45092852986, 45092853005; for `8687282` the run ids 45048870773, 45048870784, 45048870709, 45048870686, 45048870683, 45048870726, 45048870735, 45048870765. The CI does not run the loader suite, so T12 shows that the build and the existing checks still pass |

The plan lists the Channel Access port of the fixture as 5164; the suite gives every script its own loopback ports (55064 and the others of `iocsh_test_env`), so the test runs on 55064 and only the server uses the fixed port 4840. The owner approved the removal of directories of the sandbox trash, all of them copies or logs of earlier runs: five on the Debian 13 machine before T1, six on the Rocky Linux 8.10 machine before the first whole suite of T10, and seven on the Debian 13 machine and two on the Rocky Linux 8.10 machine before the second whole suite; `rt-review-20261104T060500Z` was left. The sandboxes keep the stale files `st.cmd` and `st-milo.cmd` of the fixture in their trash, moved there before the first whole suite. `gdb` 16.3 with seven library packages was installed on the Debian 13 machine at 2026-11-22T07:51Z for the analysis of the crash of M26, with the owner's approval, and is still installed.

##### Closure Evidence

The fixture, its preparation script and its test are commit `b4eb90f` ("Run the OPC UA loader example against opcua-server-sim"), the removal of the container requirement from the guard of `guest-suite.bash` and from the documents is `8b9e2fd` ("Drop the container tool requirement from the loader suite"), and the checks of the server identity, the timestamps and the read time with the counts of the READMEs are `4c41136` ("Check identity, timestamps and read time in the opcua example"); the decisions D36 and D37, the results T1 to T12 as they stood and the rows M26 and G1 are in `8687282` and `ac94cca`; this closure and the T12 row for `ac94cca` are in the commit that carries this text. All five commits were pushed on 2026-11-22, and a fetch at 2026-11-23T02:00Z showed `origin/master` at `ac94cca` with no difference to the local branch. The files of the whole suite of T10 (test script `d9775d7edc33f2e6`, `guest-suite.bash` `c80281f02c787698`, `prepare.bash` `9445f2d9c8e39dd8`) equal the committed files. The six OS workflows passed on `8687282` and on `ac94cca` (T12). The issue #99 was closed as completed at 2026-11-23T01:59:48Z. The limitation that remains, the exit crash of the `opcua` module after a server restart, is accepted and documented in the README of the fixture and is the row M26 (#146).

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
Status: Deferred

##### Summary

The pin of EPICS Base is `tags/R7.0.10`. On 2026-11-11 the tag `R7.0.11` exists (released 2026-10-27, 185 commits after `R7.0.10`). Patches are named for the pinned version and the patch rule applies only `patch/<SRC_VER>-*.p0.patch`, so moving the pin drops the set unless each patch is renamed, re-based, or dropped (`docs/procedures/upstream-fix-carry-procedure.md`, Bump obligation).

##### Scope

Move `SRC_TAG_BASE` and `SRC_VER_BASE` in `configure/RELEASE` to `tags/R7.0.11` and `7.0.11`, and settle each of the 22 Base patches named `7.0.10-*` (18 upstream fixes and 4 site patches) under the Bump obligation.

Out of scope: a move to any tag after `R7.0.11`, the pvxs pin (M8), and module updates.

##### Completion Criteria

- Each downstream Base patch is renamed, re-based, or dropped for `tags/R7.0.11` under the Bump obligation.
- EPICS Base builds from the new pin.

##### Dependencies And Decisions

D2, D3, D39 and D40 apply; D39 replaces D2 where it says that there is no release. The patch work is done with the skill `patch` and recorded by M23 (D29). D40 defers the item until the release starts, and a new dated decision then returns it to Not started.

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
Status: Deferred

##### Summary

pvxs is pinned at `tags/1.5.3` with two patches, `1.5.3-01-7176098-single-put-marked-value` and `1.5.3-02-96345dd-tcp-listener-backlog`. EPICS Base and pvxs move together under the Bump obligation of `docs/procedures/upstream-fix-carry-procedure.md`.

##### Scope

Examine the pvxs pin and its two patches together with the Base move of M7, and settle each patch.

Out of scope: module updates and a pvxs version change that M7 does not require.

##### Completion Criteria

- The pvxs pin and each of its patches are settled under the Bump obligation.
- pvxs builds on the Base of the new pin.

##### Dependencies And Decisions

D3, D39 and D40 apply. It waits for M7, and its patch work is recorded by M23 (D29). D40 defers the item until the release starts, and a new dated decision then returns it to Not started.

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
Status: Deferred

##### Summary

The pin of modbus is `tags/R3-4` (version 3.4.0, `4a1276b`). The tag `R3-5` (`47d9c40`), the head of the upstream `master` on 2026-11-11, is 17 commits ahead. They add a `ResetStatistics` record, an optional `PINI`, `DESC` fields with empty defaults in the templates, and output of the expected and actual values of a CRC error, print the debug address in decimal, fix `std::min` on Windows, and update the asyn and base entries of the module's `configure/RELEASE`. modbus carries no downstream patch. The module `motor` names `build.modbus` in its `_DEPS` line and is rebuilt with it.

##### Scope

Judge the compatibility of R3-5 with the asyn and the Base pin of M7, decide IN or HOLD, move the pin and its version value, and run the module cycle.

Out of scope: other module updates and a change of the asyn pin.

##### Completion Criteria

- The module cycle of modbus passes on the Debian 13 and Rocky Linux 8.10 test machines: the clean rebuild of modbus and of motor, the patch round trip on a fresh clone, the module scripts of the loader verification suite with the site modules counted, `make check.deps`, `make check.env`, and the reverse-dependency search.

##### Dependencies And Decisions

D2, D3, D39 and D40 apply. It is release work, and the cycle runs on the tree of the Base pin of the release, so it waits for M7 and M8. D40 defers the item until the release starts, and a new dated decision then returns it to Not started.

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

#### M10 - Carry the uldaq-env timeout patch

Origin: 441e2e0 / M10
Identity History: none
GitHub Issue: #142 (https://github.com/jeonghanlee/EPICS-env/issues/142); the related issues are jeonghanlee/uldaq-env#3, #4 and #5
Status: Complete

##### Summary

The vendor library ULDAQ stays at 1.2.2. The timeout patch of `jeonghanlee/uldaq-env` (issue #3, with #5) adds device configuration items for the network connection timeout and the command timeout, set with `ulDevSetConfig()` and read with `ulDevGetConfig()`, with the default of 3000 ms, and makes a failed command of the TC32 and E-TC end after the command timeout. The patch file is `patch/1.2.2-net-timeout.p0.patch`, which replaced `1.2.2-tcp-receive.p0.patch`; it is on `master` of `uldaq-env` at `5bf26d9`, and the tag `1.2.2-2` is on that commit (observed 2026-11-27T08:02Z; it had no tag on 2026-11-26). Measured in measComp, a silent second TC32 stalls a healthy one for 6.1 to 6.3 seconds and then 3.1 seconds in every 5.5 seconds, and its request count over 20 seconds falls from 481 to 512 to 240 to 243. The second patch of the first plan, the alarm configuration write for the network TC32 and E-TC (#4), is closed as not planned because no write command is known (D46). EPICS-env carries no ULDAQ patch file: it pins a tag of `uldaq-env` in `VENDOR_ULDAQ_TAG`, which was `1.2.2-1`, whose build record named the old patch, and is `1.2.2-2` since commit `90eb845`. The upstream version string stays 1.2.0 in ULDAQ 1.2.2, so the build is identified by its source commit, patch state and library hash.

##### Scope

Move the pin `VENDOR_ULDAQ_TAG` to the tag of `uldaq-env` that carries the timeout patch (G4), update the configuration variable reference, which is the only document that names the tag (no document names the old patch), and check the installed tree: the vendor build on both test machines, the installed IOC that loads the patched library, and the measComp checks with it. The real-device session on the TC32 is the row M29 (D47).

Out of scope: the real-device session (M29), the alarm configuration write (`uldaq-env#4`), the E-TC device check of the owner of `uldaq-env`, the lock on the device registry `DaqDeviceManager::mCreatedDevicesMap`, the broadcast discovery wait, USB devices, TCP keepalive tuning, and changes to the protocol.

##### Completion Criteria

- `VENDOR_ULDAQ_TAG` names a tag of `uldaq-env` that carries `patch/1.2.2-net-timeout.p0.patch` (G4), and the configuration variable reference names it.
- Both test machines build the vendor library from that tag and install it, the installed IOC loads it, and the vendor record of the installed tree names the tag and the patch `1.2.2-net-timeout.p0.patch` (the second criterion of G4, moved here by D47).
- The reconnection test of the fork of M11 and the module cycle pass with that library on both test machines.

##### Dependencies And Decisions

D2, D3, D39, D46 and D47 apply. G4 is complete (observed 2026-11-27T08:02Z), so the row was Not started and Ready until its plan was accepted and authorized on 2026-11-27, and it is Complete (2026-11-27); the plan was revised once, after the first run of T1, and accepted and authorized again the same day. The real-device check of the library is M29, which depends on this row and on G5; this row does not wait for G5 (D47). The issue #142 carries the real-device criterion of M29 and stays open when this row is complete (D47). The cycle runs on the tree of the Base pin `tags/R7.0.10` and does not wait for M7 or M8 (D39).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-27, the plan as revised after the first run of T1, which adds the rebuild of measComp as step 4, with the choices of the owner of the earlier acceptance unchanged (the pin is the tag `1.2.2-2`, the install takes the route of the build and installation page, and neither a check of the six CI systems nor a ChangeLog entry is part of this row)
Implementation Authorization: 2026-11-27, the owner, for the plan as accepted above
Superseded Plan Artifacts: the first draft of this detail (two patches, timeout and alarm configuration), which was never accepted; the draft of 2026-11-27, whose step 2 listed documents that do not name the tag and whose step 3 rebuilt the vendor library through `tools/prep-vendors.bash`; the plan of commit `e07ab5d`, accepted and authorized on 2026-11-27 with the choices of the owner (the pin is the tag `1.2.2-2`, the install takes the route of the build and installation page and not `tools/prep-vendors.bash`, and neither a check of the six CI systems nor a ChangeLog entry is part of this row), which had no rebuild of measComp after the install of the library, so that its first run of T1 failed

1. The tag to pin is `1.2.2-2` (G4); the owner of EPICS-env confirms it when the plan is accepted, because the owner of `uldaq-env` may add a later tag after the check of the E-TC command, which is not part of this row.
2. Set `VENDOR_ULDAQ_TAG:=1.2.2-2` in `configure/RELEASE` and change the default and the description of `VENDOR_ULDAQ_TAG` in `docs/src/reference/configuration-variables.md`, which read `1.2.2-1` and "this tag builds libuldaq 1.2.2"; the description adds that the tag carries the timeout patch. No other file of the tree, the workflows and the tools included, names the tag or the old patch (searched 2026-11-27): `tools/vendor-checkout.bash`, the build and installation page and the tools reference read the pin from `configure/RELEASE`.
3. On each test machine, put the edited `configure/RELEASE` into the sandbox checkout and take a new checkout of `uldaq-env` at the pin, because `tools/vendor-checkout.bash` never changes an existing checkout and refuses one that is at another commit, so the old `../uldaq-env` is moved aside first. Install the library again as in step 1 and step 3 of the build and installation page, in one shell from the top of the EPICS-env clone: `VENDOR_PATH="$(make print-INSTALL_LOCATION_EPICS)/vendor"`, `bash tools/vendor-checkout.bash uldaq-env ../uldaq-env`, `echo "INSTALL_LOCATION=${VENDOR_PATH}" > ../uldaq-env/configure/CONFIG_SITE.local`, and `make -C ../uldaq-env init conf build install`, with `conf.rocky8` in place of `conf` on Rocky Linux; step 2, which writes `configure/RELEASE.local`, and step 4, which builds open62541, are not repeated, and `tools/prep-vendors.bash`, which clones into a folder of its own, is the other route and is not used here.
4. On each test machine, rebuild measComp with `make build.measComp` from the top of the sandbox checkout. The install of the library gives `vendor/include/uldaq.h` and `libuldaq.so` a new time, so the next `make install` recompiles the sources of measComp whose dependency files name `uldaq.h` (four in the first run of T1) and relinks `libmeasComp.so`, whose hash then differs from its build record, and `iocsh.bash` refuses the module (the first run of T1). The rule builds the module, writes its build record and generates its loader metadata.
5. On each test machine, run the loader suite `examples/iocsh/tests/run_all.bash` through `tools/module-check/guest-suite.bash`, which takes the site checkout as its third argument: `bash tools/module-check/guest-suite.bash "$HOME/sandbox/EPICS-env" "$HOME/sandbox/iocsh-tests" "$HOME/sandbox/alsu-site-modules"`; without it `verify_install_metadata` expects 37 modules and finds 39. The suite compares the installed vendor library with `vendor/cfg/uldaq/build-record` (T1).
6. Run the reconnection test of measComp `1612c38` and the module cycle against the patched library on both test machines (T2).

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Vendor build | a new checkout of `uldaq-env` at the pin, step 1 and step 3 of the build and installation page, `make build.measComp`, `vendor/cfg/uldaq/build-record` of the installed tree, and `examples/iocsh/tests/run_all.bash` through `tools/module-check/guest-suite.bash` | Debian 13 and Rocky Linux 8.10 test machines | the library builds and installs, the record has `tag=1.2.2-2`, a `source` that begins with `5bf26d9` and `patch=1.2.2-net-timeout.p0.patch`, and the suite passes |
| T2 | Pair, simulated | all cases and the exit loop of the reconnection test of the fork at `1612c38`, and the module cycle, with the patched library of the installed tree | Debian 13 and Rocky Linux 8.10 test machines | the same results as with the library of `1.2.2-1`: every case passes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-27T16:23Z | Debian 13 and Rocky Linux 8.10 test machines, sandbox at `15b5549` with the edited `configure/RELEASE` | Fail on both machines (first run, before the rebuild of measComp): the install and the vendor record passed, the suite did not | The record of the installed library has `tag=1.2.2-2`, `source=5bf26d9a87095b2beb8ac6d981fe9db24dcf2a13` and `patch=1.2.2-net-timeout.p0.patch`, and the checkout is at that commit. `guest-suite.bash` with the site checkout ran until 16:40Z and reported 12 failed checks on each machine: `verify_install_metadata` 3, `verify_dependency_graph` 1, `verify_multiple_versions` 1, `verify_build_ids` 1 and `verify_elf_inspection` 6. One cause: the repeated `make install` of `verify_install_metadata` recompiled four sources of measComp whose dependency files name `uldaq.h` and relinked `libmeasComp.so`, whose hash differed from its build record (`Installed artifact differs from the build record`), so measComp lost its loader metadata and the later scripts stopped with status 78. The logs are not kept as evidence |
| T1 | 2026-11-27T17:31Z | Debian 13 and Rocky Linux 8.10 test machines, sandbox at `15b5549` with the edited pin, after `make build.measComp` on both (status 0) | Pass on both machines (second run, after the rebuild of measComp) | `guest-suite.bash` with the site checkout ran 17:31Z to 17:50Z: the 15 scripts with a `SUMMARY` line gave 349 ok and 0 fail on each machine, `FAIL lines: 0`, and the minimal IOC reached `iocRun` with no ERROR line; the five scripts that failed in the first run (`verify_install_metadata`, `verify_dependency_graph`, `verify_multiple_versions`, `verify_build_ids`, `verify_elf_inspection`) gave fail=0. The vendor record is the one of the first run. On Rocky Linux the first `make build.measComp` stopped with a full disk (`No space left on device`) and left `seq` without loader metadata; after old logs and backups of the test machines were removed it ran again with status 0. The logs are not kept as evidence |
| T2 | 2026-11-27T17:52Z (reconnection) and 2026-11-27T18:31Z (cycle) | Debian 13 and Rocky Linux 8.10 test machines: the fork checkout at `1612c38` with the Base, asyn 4.46.0 and the patched ULDAQ of each sandbox tree, in a user and network namespace; and `cycle.bash measComp MEASCOMP 3a646d915133933f8511eb8be22cfa5c2f715376 '~/sandbox/alsu-site-modules'` | Pass on both; one case needed a second attempt on Debian 13 | Reconnection: the 30 cases and the exit loop passed on both, and the loop reported 150 runs, 150 passed, 0 failed; on Debian 13 `bounds-e1608-online` failed at the first attempt (`polling stopped before no-sample check`) and passed at the second, a case that M11 / T4 records as intermittent on that machine before the patch; on Rocky Linux every case passed at the first attempt (12 minutes). Cycle (18:31Z to 18:41Z): every row `rc=0` on both machines (build, consumers, installed tree), and the patch round trip, which the cycle runs on the first machine only, `rc=0` on Debian 13, `verify_install_metadata` ok=12 fail=0, `verify_dependency_graph` ok=18 fail=0, `run_all` rc=0, `FAIL lines: 0`, 39 modules inspected and agreeing, installed-tree RPATH 0 of 100, findings 0, no dependent module, and the pin `1612c38` did not move. The logs are not kept as evidence |

##### Closure Evidence

- The pin and its reference line are commit `90eb845` (`VENDOR_ULDAQ_TAG:=1.2.2-2` in `configure/RELEASE` and the default and the description in `docs/src/reference/configuration-variables.md`); `git branch -r --contains 90eb845` printed `origin/master` after `git fetch` at 2026-11-27T18:42Z, where `origin/master` was `3a646d915133933f8511eb8be22cfa5c2f715376`.
- T1 and T2 passed on both test machines, with the rebuild of measComp that the first run of T1 showed to be necessary (the fourth step of the plan).
- Not covered by this row: the failed command of the library on a real TC32 (M29), the E-TC device, and the continuous integration of the six systems on the pushed pin, which the accepted plan leaves out. The issue #142 stays open until M29 is complete (D47).

##### GitHub Projection

Title: Carry the uldaq-env timeout patch
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
Status: Blocked

##### Summary

TC32 reconnection (#120) is carried by moving the measComp pin from `c38974e` of `epics-modules/measComp` to the branch `site` of `jeonghanlee/measComp` (`1612c38`, observed 2026-11-11), which is 70 commits ahead and holds the reconnection work, its tests and documents. The clone URL changes with `SRC_BASE_MEASCOMP=$(SRC_URL_JEONGHANLEE)`, the way `SRC_BASE_SNMP` does. This replaces the method of #120, which keeps the old pin with three patches. Of the two current patches, `patch/measComp-CONFIG_MEASCOMP.p0.patch` applies to the fork (checked with `git apply --check` on 2026-11-11), and `patch/measComp-tc32-chan-count.p0.patch` neither applies nor reverses on it, so the plan keeps the first and drops the second, because the fork holds its change as the commit `f69e794` (D44). The reconnect patch held outside the repository is not applied.

##### Scope

Move the pin to the commit id of the head of `origin/site` and the URL to the fork, drop `measComp-tc32-chan-count` with its rule, list entries and `patch/README.md` section, keep `measComp-CONFIG_MEASCOMP`, rebuild measComp and its consumers, and verify TC32 reconnection with the reconnection test of the fork on the sources of the pinned fork commit and, later, on a real TC32.

Out of scope: real-hardware endurance beyond the checks listed here, EXP-32, USB, Windows and other models.

##### Completion Criteria

- The module cycle of measComp passes on both test machines at the fork pin with the patches the plan keeps.
- The patch set applies, reverts and applies again cleanly at the new pin, and the retired patch file, its rule, its list entries and its `patch/README.md` section are gone.
- The reconnection test of the fork passes with the sources of the pinned fork commit against the Base, asyn and ULDAQ of the installed tree on both test machines, and its nine original-behavior controls and four chosen mutation controls fail as the fork README states.
- On a real TC32 without EXP-32: the IOC log holds no `Calling TIn channel N` error for N from 32 to 63; offline IOC startup, repeated power cycles and network loss do not restart the IOC or replace valid samples, the input records carry INVALID alarms during the loss, and valid updates resume after recovery.

##### Dependencies And Decisions

D2, D3, D39 and D44 apply. M10 supplies the configurable timeouts that remove the remaining three-second stall; M11 does not wait for it. D46 applies: the hardware check T8 is one real-device session with M29 / T1 (D47), on the pair of measComp `1612c38` and the patched ULDAQ. G5 blocks T8; resume as In progress. The cycle runs on the tree of the Base pin `tags/R7.0.10` and does not wait for M7 or M8 (D39).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-24, accepted by the owner in chat after the third-person passes on `work/plan-meascomp-fork.md` and the second-person passes on this detail, with the revisions of 2026-11-24
Implementation Authorization: 2026-11-24, authorized by the owner in chat
Superseded Plan Artifacts: none

1. Read the 70 commits for changes of installed files and the `docs/reconnection.md` of the fork, and read `drvMultiFunction.cpp` of the pinned commit for the halving of the temperature channel count that the fork test does not detect (T1); the installed library, DBD and templates of the build of step 5 are compared with the loader entries there.
2. Run the nine original-behavior controls and the four mutation controls `no-reconnect`, `ignore-auto`, `ignore-enable` and `silent-retry-unspaced` of the fork README with its runner before any change (T5).
3. Set `SRC_BASE_MEASCOMP`, `SRC_TAG_MEASCOMP` and `SRC_VER_MEASCOMP` in `configure/RELEASE`; remove the rule `patch.measComp.tc32.*` from `configure/RULES_PATCH`, its entries from the `patch` and `patch.revert` lists of `configure/RULES_SRC`, the file `patch/measComp-tc32-chan-count.p0.patch` with `git rm` and its section of `patch/README.md`; update `docs/src/reference/module-pins.md`, the other documents that name the old pin or the patch, and the pin name in `examples/iocsh/tests/verify_elf_inspection.bash`.
4. Commit the change and push it, each on its own trigger of the owner, because `cycle.bash` takes a commit on origin.
5. Run the patch round trip (T2, its local part before the push), the module cycle with `tools/module-check/cycle.bash` on that commit (T3) and the reconnection test of the fork on a checkout at the pinned commit with the tree of each machine (T4).
6. Run the whole suite through `guest-suite.bash` on both machines with the final files (T6), record the results in this detail and in #120, and read the CI of the pushed commit (T7).
7. The hardware check (T8) is one session on a real TC32 without EXP-32 together with M29 / T1 (the gate G5, D46, D47).

##### Test Plan

Objective: the installed `measComp` is the fork build, the module cycle passes on both machines, the reconnection test of the fork passes with the sources of the pinned fork commit, and the carried patch set applies and reverts cleanly. Real target: for T1 to T3 and T6, the installed tree of each test machine rebuilt by the repository rules at the new pin; for T4 and T5, a checkout of the fork at the pinned commit, its `tests/` as shipped, and the Base, asyn and ULDAQ of that installed tree (`BASE`, `ASYN`, `ULDAQ_INCLUDE`, `ULDAQ_LIB` from the vendor build of the tree, and a `BUILD` directory that does not exist); the installed `measComp` is not an input of T4 and T5.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Premises | read the 70 commits for changes of installed files and `docs/reconnection.md` of the fork; read `drvMultiFunction.cpp` of the pinned commit for the halving of the temperature channel count when `DEV_CFG_HAS_EXP` reports no expansion, which the fork test does not detect; at T3, compare the installed library, DBD and templates of the cycle build with the loader entries (the metadata and dependency-graph rows) | local reading of the fork checkout; both test machines at T3 | the halving code is present in the pinned commit; the entries `measCompSupport.dbd` and the library stem stay valid, or the differences are listed |
| T2 | Patch set | `make patch.apply`, `make patch.revert` and `make patch.apply` again on the source at the new pin, with the retired rule removed | local checkout and one test machine | each step clean; the second apply gives the same files; the retired patch file is absent |
| T3 | Module cycle | `tools/module-check/cycle.bash measComp MEASCOMP <candidate> '~/sandbox/alsu-site-modules'`, where the candidate is the commit of the change on origin and the last argument is the site checkout whose modules are installed in the trees of the machines (without it `verify_install_metadata` expects 37 modules and finds 39); its consumers row runs `verify_install_metadata`, `verify_dependency_graph` (one IOC that loads every installed module, so the library and the DBD of `measComp`) and `verify_minimal_example`; no fixture of the cycle loads `measComp`; the `SUMMARY ok= fail=` lines of the consumers log are read, because the cycle prints the row as pass when the scripts exit 0 | Debian 13 and Rocky Linux 8.10 test machines | every row passes with `rc=0` |
| T4 | Reconnection | `tests/build_reconnect.pl` and `tests/test_reconnect.pl` of the fork checkout at the pinned commit, inside the user and network namespace, with the libraries of the tree built at T3: all cases of the fork README (digital 4, enum 5, bounds 4, MAC 4, endpoint 8, `silent-device`, `read-error`, `temperature-array`, `temperature-diagnostics` and the default reconnect case) and its exit loop of 150 runs | both test machines | all assertions pass in every case, the exit loop reports 150 passed, every IOC exits normally, the JSON results are kept |
| T5 | Check can fail | the nine original-behavior controls that `tests/README.md` of the fork defines (analog bounds, MAC rediscovery with its two baselines, discovery endpoint, silent device, read error, temperature array, temperature diagnostics and the exit loop; the IOC built from earlier sources in a scratch copy) and the four mutation controls `no-reconnect`, `ignore-auto`, `ignore-enable` and `silent-retry-unspaced` of its "Negative controls" table, thirteen scratch builds in all; each control runs only the cases that its README section or table row names, with the same runner | Debian 13 test machine | each control fails as the README states, at the assertion or deadline it names |
| T6 | Suite | the whole loader suite through `guest-suite.bash` with the changed pin | both test machines | the suite passes |
| T7 | CI | the pushed change | the six CI systems | pass |
| T8 | Hardware | offline start, power cycles and network loss on a real TC32 without EXP-32; the IOC log read from start | a real TC32 | the IOC log holds no `Calling TIn channel N` error for N from 32 to 63; no IOC restart, no invalid replacement samples, INVALID alarms during the loss, valid updates after recovery |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-25T16:26Z | local reading of the fork checkout; Debian 13 and Rocky Linux 8.10 test machines | Pass: the pinned commit `1612c38` holds the halving (`if (infoValue == 0) numTemperatureIn_ /= 2;` at line 1238 of `drvMultiFunction.cpp`, one such line in the source of the build on both machines); the installed `measComp-1612c38` on both machines has `lib=lib/linux-x86_64/libmeasComp.so` and `dbd=dbd/measCompSupport.dbd` as loader entries and both files exist; `measCompSupport.dbd` includes the new `devMeasComp.dbd`, which is installed in `dbd/`; `libmeasComp.so` holds symbols named `measCompAiInt32Average`; `measCompTemperatureBank.template`, `measCompTemperatureCJC.template` and `TC32Network.substitutions` are installed | commit `15b5549`; the probe output is not kept as evidence |
| T2 | 2026-11-25T05:04Z | local scratch clone of the fork at `1612c38` with the rules `patch.measComp.apply` and `patch.measComp.revert`, and the patch-round-trip row of T3 on Debian 13 | Pass: the apply changes `measCompApp/src/Makefile` and adds `CONFIG_MEASCOMP`; the revert returns the source to the pinned commit byte for byte; the second apply gives the same diff hash; the patch-round-trip row of the cycle gives `Patching lines: 46`, `Patching measComp-src lines: 1` and `status lines in all trees: 0` | commit `15b5549`; the scratch clone is not kept |
| T3 | 2026-11-25T16:26Z | Debian 13 and Rocky Linux 8.10 test machines, `cycle.bash measComp MEASCOMP 15b55496d8f81155be7b2e930106dda627fcbfd5 '~/sandbox/alsu-site-modules'` | Pass in the fourth run: every row `rc=0`; `verify_install_metadata` ok=12 fail=0, `verify_dependency_graph` ok=18 fail=0, `run_all rc=0`, `FAIL lines: 0`, 39 modules inspected and agreeing on both machines; installed-tree RPATH 0 of 100, findings 0, no dependent module. Three runs stopped before: the log directory of an old run (nothing ran), the sandbox checkouts with the files of an earlier verification laid over them (moved into a stash on both machines), and a run without the site checkout, whose `verify_install_metadata` gave ok=11 fail=1 (37 modules expected, 39 installed) while the cycle still printed the row as pass | commit `15b5549`; the logs of `work/measComp-bump` are not kept as evidence |
| T4 | 2026-11-25T16:28Z | both test machines: fork checkout at `1612c38`, with the Base, asyn 4.46.0 and ULDAQ of each sandbox tree built at T3, in a user and network namespace | Pass on both: the 30 cases (default, digital 4, enum 5, bounds 4, MAC 4, endpoint 8, `silent-device`, `read-error`, `temperature-array`, `temperature-diagnostics`) passed at the first attempt, and the exit loop reported 150 runs, 150 passed, 0 failed. In earlier runs on Debian 13, `bounds-e1608-online` failed twice (`polling stopped before no-sample check`) and passed in 10 of 10 repeats; it passed at the first attempt on both machines here | fork commit `1612c38`; the scripts are not kept as evidence |
| T5 | 2026-11-25T04:38Z (original-behavior controls) and 2026-11-25T04:58Z (mutation controls) | Debian 13 test machine, Base, asyn 4.46.0 and ULDAQ of a copy of its tree | Pass: the nine original-behavior controls and the four mutation controls failed as the fork README states: analog bounds with the template from before the bounds change (TC32 offline `startup A0 conversion coefficients`, E-1608 offline `startup A0 raw 32768 engineering value`, both online cases pass), MAC rediscovery before it and with exact-case compare (deadline exceeded at the connection deadline), discovery endpoint (`endpoint second port reads its device` for `endpoint-same-ip` and `endpoint-mixed`, the six others pass), `silent healthy port keeps polling`, `read error reported once per channel`, `temperature array one request per poll`, `temperature diagnostics one cold-junction request per poll`, the exit loop (150 runs, 141 passed, 9 failed), and the mutations `no-reconnect` (deadline exceeded), `ignore-auto` (`autoconnect disabled but connected`), `ignore-enable` (`disabled port stops polling`) and `silent-retry-unspaced` (`silent healthy port keeps polling`). The first analog bounds run used the template of `c38974e` by mistake and was redone with the template of `0bb9e82^` | fork commit `1612c38` and its history; the scripts are not kept as evidence |
| T6 | 2026-11-25T16:45Z | both test machines, `guest-suite.bash` with the site checkout, sandbox at `15b5549` | Pass: 18 scripts, suite status 0, 349 ok and 0 fail by the SUMMARY lines on both machines (957 s on Debian 13, 865 s on Rocky Linux 8.10) | commit `15b5549`; the logs are not kept as evidence |
| T7 | 2026-11-25T08:09Z | the six CI systems | Pass: Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04 and Ubuntu 26.04 completed with success for `b23db1b`, which holds the pin move `15b5549` | GitHub Actions runs 45570048281 to 45570048444 of `b23db1b` |
| T8 | Not run | a real TC32 | Pending | none |

Open check: T8 waits for the session of the gate G5 (D46). The unit exists on the lab network (it serves the IOC of `tcmd`, and the owner states that it has no EXP-32); the owner of `tcmd` decides its use. The session `LAB-measComp` reported on 2026-11-26 a read-only check of the pair (150 s, no power cycle, no cable pull): ModelNumber 306, 32 of 32 temperature channels valid with NO_ALARM, no `Calling TIn channel` line and no error for the channels 32 to 63; this covers only those two items, and the loss and recovery items are open. D44 keeps the row open until T8 is done or the owner records a dated exception.

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
Status: Complete

Retired on 2026-11-23 by D42: the loader does not support pyDevSup, and the Python work goes on separately. The scope, the plan and the tests below are the plan that D42 replaced.

GitHub state observed: CLOSED (reason not planned) at 2026-11-23T19:20:22Z, label `enhancement`, milestone Backlog; its body was rewritten at the close with the result of the trial and the criteria that apply, all checked, and a closing comment names the reason. Recheck with `gh issue view 139 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

An exploratory run loaded its library and database definition into the plain `softIoc` and processed a record; relocation, the library name that carries the Python version, and the loader rules are not examined

##### Scope

Make the installed loader `iocsh.bash` load pyDevSup into a plain IOC (`softIocPVX`): declare its library and DBD in `configure/CONFIG_MODS_IOCSH`, with the library stem computed from `PY_LD_VER` (D41), and set the Python package path in the module metadata if the check shows it is needed. Add a check that processes a real Python-backed record and repeats the start from a relocated tree, and change the pyDevSup assertion of `verify_dependency_graph.bash` from no load to the loaded library and DBD.

Out of scope: a pyDevSup version update, a change of the installed Python runtime, a new pyDevSup patch, the `softIocPy` executable as a loader target, platforms other than the two test machines, macOS (M15), and changes to published release tags.

##### Completion Criteria

- The real loader starts pyDevSup in a plain IOC and verifies relocation, Python-version library naming, and loader selection.
- A Python-backed record is processed through the loader, and the loaded library and the Python runtime are identified.
- The start works from a relocated copy of the tree with the original tree and checkout unavailable, on Debian 13 and Rocky Linux 8.10.
- The new check fails on the unchanged loader, and the whole loader suite passes on both machines.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D4, D39 and D41 apply; D39 returns the item to Not started and D41 fixes the design decisions of the plan. The prior deferred row carried no plan; the plan below is accepted, and the implementation was authorized on 2026-11-23 and stopped the same day. D42 decides that the loader does not support pyDevSup and that the Python work goes on separately, so the item is not carried out; the row is Complete as a retirement since #139 was closed, with its Closure Evidence and the waived criteria.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-23, accepted by the owner after two third-person passes on `work/plan-pydevsup-loader.md`
Implementation Authorization: 2026-11-23, authorized by the owner in chat; ended the same day by D42
Superseded Plan Artifacts: none

1. Read the installed pyDevSup and the loader on copies of the trees of both test machines: the stem expression from `PY_LD_VER`, and whether a plain IOC needs the Python package path (T1, T2).
2. Write the new check `examples/iocsh/tests/verify_pydevsup.bash` (a start through `iocsh.bash` with a real Python-backed record, the identification of the loaded library and runtime, and the relocated start) and run it on the unchanged loader (T5).
3. Declare `pyDevSup_IOCSH_LIBS` and `pyDevSup_IOCSH_DBDS` in `configure/CONFIG_MODS_IOCSH` (the library from `PY_LD_VER`, `pyDevSup.dbd`) and, if T2 shows it, the Python package path in the module metadata; write the metadata again and rerun the check (T3, T4).
4. Change the pyDevSup assertion of `verify_dependency_graph.bash` from no load to the loaded library and DBD.
5. Add a dated entry for the changed premise to `docs/CLOSED_DOORS.md`, update the `pyDevSup` row of `docs/src/concepts/module-set.md` and the counts and the script list of `examples/iocsh/tests/README.md`.
6. Run the whole suite through `guest-suite.bash` on both machines with the final files (T6), record the results in this detail and in #139, and read the CI of the pushed commit (T7).

##### Test Plan

Objective: the installed loader starts a plain IOC with pyDevSup, processes a real record, selects the right library on both machines and does the same from a relocated tree; the new check fails on the unchanged loader. Real target: copies of the installed trees of the `1.5.0` environment of each test machine, the loader `iocsh.bash`, the real library, DBD and Python package of pyDevSup, and a loopback `caget`.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Library name | the stem expression (`pyDevSup` plus `PY_LD_VER`) evaluated by the build rules on each machine; the written metadata names the library that exists | Debian 13 and Rocky Linux 8.10 test machines | `libpyDevSup3.13.so` and `libpyDevSup3.6m.so` are named and the loader finds each |
| T2 | Python path | a plain IOC loads the library and the DBD with and without the Python package path | Debian 13 test machine | the result decides whether the loader sets the path |
| T3 | Real record | an IOC through `iocsh.bash` processes a Python-backed record, `caget` reads its value, and the loaded library and the Python runtime are identified (`ldd` or the process maps) | both test machines | the value is the expected one; the library is the stem of T1 and the runtime is the installed Python |
| T4 | Relocation | the same start from a copy of the tree under another path, with the original tree and checkout unavailable | both test machines | status 0 and the same value; no path of the original appears in the loaded libraries |
| T5 | Check can fail | the new check on the unchanged loader | Debian 13 test machine | it fails and the test reports the failure |
| T6 | Suite | the whole loader suite through `guest-suite.bash` with the changed assertion | both test machines | the suite passes |
| T7 | CI | the pushed change | the six CI systems | pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | both test machines | Waived by D42 | Closure Evidence |
| T2 | 2026-11-23T19:13Z | Debian 13 test machine, copy of the installed `1.5.0` tree | Result: a plain IOC started by `iocsh.bash` processed the installed `pidmon` record (`caget` read `Running`) after `dlload` of the library, `dbLoadDatabase` of `pyDevSup.dbd`, `registerAllRecordDeviceDrivers`, `py "import devsup"` and `dbLoadDatabase` of the three DBD files under the Python package tree. Without `PYDEV_BASE`, `devsup` was imported from the original install path; with it, from the copy | scratch scripts of this session, not kept as evidence |
| T3 | Not run | both test machines | Waived by D42 | Closure Evidence |
| T4 | Not run | both test machines | Waived by D42 | Closure Evidence |
| T5 | Not run | Debian 13 test machine | Waived by D42 | Closure Evidence |
| T6 | Not run | both test machines | Waived by D42 | Closure Evidence |
| T7 | Not run | the six CI systems | Waived by D42 | Closure Evidence |

##### Closure Evidence

Retired by D42 on 2026-11-23, with no change of the loader: the trial M14 / T2 on a copy of the installed tree of Debian 13 processed the installed `pidmon` record through `iocsh.bash`, but needed the three device DBD files of the Python package tree (`_dbapi.dbd`, `_int64.dbd`, `_lsilso.dbd`), the command `import devsup` after the registration of the library, and the variable `PYDEV_BASE`, without which the IOC imports `devsup` from the install path that the build recorded. The library names follow `PY_LD_VER` (`libpyDevSup3.13.so` on Debian 13, `libpyDevSup3.6m.so` on Rocky Linux 8.10). Supporting this needs a general extension of the loader metadata or a fragment of its own for one module, which the owner judged too much work: the loader does not support pyDevSup, and the Python work goes on separately. Waived checks: T1 and T3 to T7 of this row and its four completion criteria, which belong to a loader change that is not written. The issue #139 was closed as not planned at 2026-11-23T19:20:22Z with its body rewritten to carry the trial result. The plan `work/plan-pydevsup-loader.md` and the copy of the tree used for the trial are not evidence of this row.

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
Status: Complete

Retired on 2026-11-23 by D39: the original startup files of the opcua example are removed and `opcua-server-sim` is its default, so no original startup is left to verify.

GitHub state observed: CLOSED (reason not planned) at 2026-11-23T08:35:20Z, label `enhancement`, milestone Backlog; its body was rewritten at the close with the criteria that apply, all checked, and a closing comment names the removal. Recheck with `gh issue view 135 -R jeonghanlee/EPICS-env --json state,url`.

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

D4 and D39 apply. D39 retires the item on 2026-11-23: the original startup files of the opcua example are removed (commit `b4eb90f`) and `opcua-server-sim` is its default (D36), so the documentation from the real Unified Automation server is no longer needed. The row is Complete since #135 was closed, with its Closure Evidence and the waived criterion. No implementation plan or authorization is carried by the prior deferred row.

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

Retired by D39 on 2026-11-23: the original startup files `st.cmd` and `st-milo.cmd` of the opcua example were removed by commit `b4eb90f`, and `opcua-server-sim` is the default server of the example (D36, #99 closed), so no original startup is left to verify. Waived check: the documentation of the original startup data path from the real Unified Automation server and its 69 database nodes, which is the only completion criterion. The issue #135 was closed as not planned at 2026-11-23T08:35:20Z.

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
Status: Complete

##### Summary

The startup files of this repository carry the line `on error break`; a startup file of a user may not. The generated startup of `iocsh.bash` sets `on error break` for itself, but it loads the caller's file with `iocshLoad`, whose new scope starts with `on error continue` (`iocshScope` in `modules/libcom/src/iocsh/iocsh.cpp` of `R7.0.10`), so a file without the line goes on after an error and the IOC ends with status 0 (probe of 2026-11-20 with the installed `softIocPVX`). The owner decided on 2026-11-20 that `iocsh.bash` reads the startup file and inserts the line when the file has none, and took the recommended answers to the design questions (D35).

##### Scope

Implement D35 in `read_startup` of `tools/iocsh.bash`, its tests and the documents.

Out of scope: a startup file without a directive, a start without a startup file, the generated startup, an error inside a file that the startup file loads with `iocshLoad` (that file runs in a scope of its own that starts with `on error continue`), an option or a variable to turn the insertion off, and a GitHub issue until the owner opens one.

##### Completion Criteria

- `iocsh.bash` writes `on error break` in place of the first directive line of a startup file that has a directive and no `on error` line, without moving a line, and says so with the clause `; on error break added at line <line>` at the end of the start message and of the last line of `-n`; a file with an `on error` line, a file without a directive and a start without a startup file are unchanged; verified with the real loader and `softIocPVX` on both test machines, and the loader suite passes there.
- The documents state the behaviour and the line `on error continue` as the way to keep the old behaviour.

##### Dependencies And Decisions

D2 and D35 apply.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-21, accepted by the owner after four third-person and three second-person passes on the plan
Implementation Authorization: 2026-11-21, authorized by the owner
Superseded Plan Artifacts: none

The plan is `work/plan-on-error-break.md` (2026-11-20); its steps follow D35.

1. `tools/iocsh.bash`: `read_startup` notes an `on error` line and the first directive line and, when a directive exists and no `on error` line, writes `on error break # added by iocsh.bash` into that copy line; the start message and the last line of `-n` end with `; on error break added at line <line>`; the header comment and usage text where they describe the startup file.
2. `examples/iocsh/tests/verify_shell_lifecycle.bash`: checks for a file with a directive and no `on error` line (the error is named at its original line, later lines do not run, and the start message and the last line of `-n` end with `; on error break added at line <line>`), a file with `on error continue`, a file with `on error break`, a file whose first directive is not the first line, a file with two directives (only the first is replaced), a file with an `on error` line below the first directive, a directive line with a trailing comment that holds a macro reference, and a file without a directive; each check shown to fail on a scratch copy of the loader with the behaviour removed.
3. Documents: `installed-module-loader.md` (The generated startup), `run-ioc-from-installed-modules.md`, the row of `iocsh.bash` in `tools-and-scripts.md`, and a sentence on the changed behaviour in `docs/src/tutorial/first-loader-ioc.md`, the first page of the book that shows a startup file and that does not explain its `on error break` line.
4. Register, and a notice to the sessions that write startup files for the loader.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | New checks | the new checks of `examples/iocsh/tests/verify_shell_lifecycle.bash` with the real loader and `softIocPVX`, after `make install.iocsh` has installed the changed loader into the tree that the tests run | both test machines | every check passes |
| T2 | Checks can fail | scratch copies of the loader with one behaviour removed each, each put in place of `base/bin/<arch>/iocsh.bash` in a copy of the installed tree that `IOCSH_TEST_TREE` names | one test machine | each copy fails the matching check |
| T3 | Suite | `examples/iocsh/tests/run_all.bash` in the sandboxes through `tools/module-check/guest-suite.bash`, with the uncommitted files laid over the sandbox checkout and the changed loader installed | both test machines | the suite passes |
| T4 | Static | `bash -n` and shellcheck on the changed scripts | local | no finding |
| T5 | CI | the pushed change | six systems | pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-21T08:15Z | sandboxes of Debian 13 and Rocky Linux 8.10: the 41 files that differ from the sandbox checkout `30c6919` laid over it, `make install.iocsh` status 0, installed loader and `tools/iocsh.bash` with the same SHA-256 (`3268bc2fce587c00`), test script `1e6cccec84012aaf` | Pass on both: `verify_shell_lifecycle` ends with 42 checks and no failure, 12 of them the new checks (the six cases of the plan, the message and the show mode in the first case, and one more case with an indented `on error continue` line). Before the indented case was added, the same script on the local tree of release 1.5.0 passed 41 checks | `work/scratch/m18-r/guest/t1-debian13.log`, `t1-rocky8.log` |
| T2 | 2026-11-21T08:19Z | local Debian 13, a scratch copy of the local tree with the loader under test in place of `base/bin/linux-x86_64/iocsh.bash`, the test script of T1 | Pass: the changed loader passes all 42 checks, and each of eight scratch copies fails the matching checks and no other: no insertion fails seven checks; a line written although the file has an `on error` line fails three; only an `on error break` line counting as one fails two; a new first line in place of the directive line fails six; the directive text copied into the line fails one (the macro case); no clause in the show mode fails one; no clause in the start message fails three; no indented line counting fails one. No copy can fail the check that a file without a directive is unchanged, because the code has no path that writes a line for such a file. The runs were local and not on a test machine as the plan states; the script and the loaders are the real ones | `work/scratch/m18-r/mut-run.out`; the copies `work/scratch/m18-r/mutants/` |
| T3 | 2026-11-21T08:36Z | sandboxes of Debian 13 and Rocky Linux 8.10, checkout `30c6919` with the 41 files laid over it, installed loader `3268bc2fce587c00` and test script `1e6cccec84012aaf` | Pass on both: the suite ends with status 0, 18 scripts with exit 0, 328 checks, no FAIL line (868 s on Rocky Linux, 975 s on Debian); `verify_shell_lifecycle` has 42 checks in it. Before the run the owner approved the removal of two leftover directories of earlier runs on the Rocky Linux machine, which had too little free space | `work/scratch/m18-r/guest/t3-rocky8.log`, `t3-debian13.log` |
| T4 | 2026-11-21T08:22Z | local Debian 13 | Pass: `bash -n` and shellcheck give no finding on `tools/iocsh.bash` and `examples/iocsh/tests/verify_shell_lifecycle.bash` | command output |
| T5 | 2026-11-21T19:25Z | CI of commit `17c218acf38009910d92b0553a8d2d9388f411ed` on `origin/master`, which holds the loader change (`323c921`) and the register change (`17c218a`) | Pass: the six OS workflows, the linter and the documentation deployment ended with success (Debian 12, Debian 13, Rocky 10, Rocky 8, Ubuntu 24.04, Ubuntu 26.04, Linter Run, Deploy Docs) | `gh run list --repo jeonghanlee/EPICS-env --commit 17c218acf38009910d92b0553a8d2d9388f411ed`; run ids 44938287399, 44938287372, 44938287388, 44938287466, 44938287452, 44938287422, 44938287500, 44938287387. The CI does not run the loader suite, so T5 shows that the build and the existing checks still pass |

The runs of T1 to T3 were made with the test script `1e6cccec84012aaf`. The review of the implementation then found that no check used a file with two directives or an `on error` line below the first directive: a loader that writes the line at the last directive, and a loader that counts only an `on error` line above the first directive, passed all 42 checks. Three checks were added (45 in `verify_shell_lifecycle`, 15 of them new) and the header comment of the script was completed. On 2026-11-21 the changed script (`ada817981daac8aa`) passed 45 checks on both test machines with the loader `3268bc2fce587c00` installed (`work/scratch/m18-r/guest/t1b-debian13.log`, `t1b-rocky8.log`; on the Debian machine with the free-space limit of `guest-suite.bash` lowered to 2000000 KB for that one script, because 3.0 GB were free after the suite run) and locally on the tree of release 1.5.0, and the two loaders that had passed now fail one new check each (`work/scratch/m18-r2/`). The loader is the same file as in T3; the whole suite of T3 ran with the script before the three checks were added and was not run again.

##### Closure Evidence

The loader, its test section and the four document pages are commit `323c921` ("Insert on error break into a startup file that has none"); the decision, the plan state and the results T1 to T4 are commit `17c218a`. Both were pushed on 2026-11-21, and a fetch at 2026-11-21T19:42Z showed `origin/master` at `17c218a` with no difference to the local branch. The six OS workflows passed on `17c218a` (T5). On 2026-11-21 the notice of plan step 4 (what the loader now does with a startup file that has no `on error` line, and `on error continue` as the way to keep the earlier behavior) was sent to the 36 peer sessions that were live; the 10 offline sessions were not told.
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

The tools, the tests and the seven document pages are commit `49c5a4d` ("Record library build-ids and compare them before an IOC starts"), pushed on 2026-11-17; `origin/master` pointed to it after the push. `tools/iocsh.bash` and `examples/iocsh/tests/verify_build_ids.bash` of that commit have the sha256 that the last suite runs on the two test machines printed for them (`05f721d26d70f38f` and `9b30ceac25e93d78`). The plan, the decisions D25 to D27 and the results T1 to T13 are commit `18e37d4`. The issue #144 was opened on 2026-11-17. The other repositories were told on 2026-11-17: the error lines, the exit statuses and the observations of T11 for jeonghanlee/epics-ioc-runner#169, the form of the record to the sessions of `uldaq-env` and `open62541-env`, and the exit statuses to the session that maintains the `epics-ioc-run` skill. On 2026-11-18 the session of `epics-ioc-runner` reported the revised body of jeonghanlee/epics-ioc-runner#169: the contract of this repository stays as it is (78 for every refusal, 64 for a usage error, `iocsh.bash -n` as the check before a start), and its proposal is that `start` also prints the message of the loader from the log on a refusal; a refused start is still restarted by procServ, because `iocsh.bash` runs as the child of procServ and the unit never sees the status 78, which agrees with the observation of T11, and that repository keeps this out of the scope of its issue by its earlier decisions (its `docs/CLOSED_DOORS.md` CI-35 and `docs/adr/0001-restart-supervision-c1h.md`). No tracked file of this repository states that a unit shows the status 78. The new test script was committed without the execute bit, which the suite does not need because it starts each script with `bash`; the bit is set in the commit that sets this row to Complete.

#### M21 - Pin the vendor library sources by tag

Origin: 441e2e0 / M21
Identity History: none
GitHub Issue: #145 (https://github.com/jeonghanlee/EPICS-env/issues/145)
Status: Complete

##### Summary

The CI workflows clone `uldaq-env` and `open62541-env` without a tag or commit, so each build takes the default branch of that day. The published 1.5.0 distribution holds libuldaq 1.2.2 and libopen62541 1.3.15 in its six trees, but no record names the commit that built them, and the sandboxes of both test machines hold libuldaq 1.2.1, built from wrapper checkouts of 2026-09-29 (`uldaq-env` `988b152`, `open62541-env` `00e5e60`, read on 2026-11-18). D20 pins the vendor sources by tag from the next release, as the module pins are. The tags come from the wrappers (G2); this row changes EPICS-env.

##### Scope

Add a pin variable for each of the two wrapper repositories to `configure/RELEASE` (`VENDOR_ULDAQ_TAG` and `VENDOR_OPEN62541_TAG`, D33), make the six OS workflows and the scripts `tools/prep-vendors.bash`, `tools/module-check/guest-baseline.bash` (which skips the clone when the directory already exists) and `tools/install-distribution.bash` (which builds the checkouts that the user placed beside the checkout) use each repository at its pin through the helper `tools/vendor-checkout.bash` (D33), and make every documented installation of the vendor libraries name the tag (D21), document the variables and the pinned vendor libraries in the configuration reference and the pages about the vendor directory, and verify a build on both test machines with the pinned sources.

Out of scope: the tags in the wrapper repositories (created by their owners), `pkg_automation`, and the installed trees that already exist.

##### Completion Criteria

- Each of the six OS workflows, `tools/prep-vendors.bash`, `tools/module-check/guest-baseline.bash` and `tools/install-distribution.bash` installs the vendor libraries from the source at the pin of `configure/RELEASE`, and a changed pin changes the source that is used.
- A build on Debian 13 and Rocky Linux 8.10 installs vendor libraries from the pinned sources, and the version of each installed library is the version that the documents give for its tag (tag `1.2.2-1` of `uldaq-env` gives libuldaq 1.2.2, tag `1.3.15-2` of `open62541-env` gives libopen62541 1.3.15), and the vendor record of each names the pinned tag.
- The documents name the pin variables and the pinned library versions.

##### Dependencies And Decisions

D20, D21, D31, D32 and D33 apply. The row depends on the gate G2, which supplies the tags and closes only with the complete solution of both wrappers (D21). G2 was Complete on 2026-11-18, and the row was restored from Blocked to Not started on that date; the tags to pin are `1.2.2-1` of `uldaq-env` and `1.3.15-2` of `open62541-env`, or later ones of the same form (D32).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-18, accepted by the owner after three third-person and three second-person passes on the plan
Implementation Authorization: 2026-11-18, authorized by the owner
Superseded Plan Artifacts: none

The plan is `work/plan-vendor-tag-pin.md` (2026-11-18, with the decisions of D33).

1. `configure/RELEASE`: `VENDOR_ULDAQ_TAG:=1.2.2-1` beside `VENDOR_ULDAQ_PATH` and `VENDOR_OPEN62541_TAG:=1.3.15-2` beside `OPEN62541_PATH`.
2. `tools/vendor-checkout.bash` (new, with the licence header of the other tools), usage `[--any-commit] <wrapper> <directory>`: it reads the pin with `make -s print-<VARIABLE>`, run in the checkout that holds the script, and stops with status 1 when the pin is empty or is no tag name, because that command prints an empty line with status 0 for a variable that is not set. It clones the tag with `git clone --depth 1 --branch <tag>` from `https://github.com/jeonghanlee/<wrapper>`, or from the base in the environment variable `VENDOR_GIT_BASE`, when the directory is absent. It requires an existing directory to be at the commit of the pinned tag with no changed tracked file; a checkout that does not hold the tag is not fetched, and the message names `git -C <directory> fetch --tags`. It prints the wrapper, the tag and the commit. Exit status 0 at the pin or with `--any-commit`, 1 when it refuses, 2 for a usage error.
3. `tools/verify_vendor_checkout.bash` (new): the retained test of the helper. It builds two local repositories with tags in a scratch directory, points `VENDOR_GIT_BASE` and the pins at them, and checks each behaviour of the helper. Only the remote is replaced by a local repository; the helper, `make` and `git` are the real ones. The repositories that the test makes use no global git configuration and no hook of the user, and get their author name and email on the command line.
4. The six OS workflows call the helper in place of their two `git clone` lines.
5. `tools/prep-vendors.bash` calls the helper with its SSH base and, when that fails, with its HTTPS base; `tools/module-check/guest-baseline.bash` and `tools/install-distribution.bash` call the helper before they build.
6. Documents: `docs/src/reference/tools-and-scripts.md`, the configuration reference, the pages that tell a reader to clone the wrappers or name the vendor variables (`installed-tree.md` among them), `docs/procedures/release-procedure.md`, and the sentence of `shared-library-identity.md` on the vendor record.
7. Register and issue.

Added while implementing: the helper also requires an existing directory to be the root of its own repository, so that a plain directory inside another checkout is not read as that checkout.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Pin is read | `make -s print-VENDOR_ULDAQ_TAG` and `make -s print-VENDOR_OPEN62541_TAG` | local | `1.2.2-1` and `1.3.15-2` |
| T2 | Helper behaviours | `tools/verify_vendor_checkout.bash`: clone of an absent directory, a checkout at the pin, at another commit, with a changed tracked file, without the tag, an empty pin, a pin that is no tag name, a wrong wrapper name, and `--any-commit` | local | every check passes; a scratch copy of the helper with one behaviour changed at a time (no check of the commit, no check of changed files, an empty pin accepted) makes the matching check fail |
| T3 | Real remotes | the helper on an absent directory for each wrapper, with the pins as committed, and again in a scratch copy of `Makefile` and `configure/` whose pins are set to the other real tags (`1.2.2` of `uldaq-env`, `1.0.0` of `open62541-env`), so that no local setting of the checkout is touched | local scratch, network | the checkout is at the commit of the pinned tag (`29994f2`, `ab75700`); with the other tags it is at their commits (`a5094ec`, `00e5e60`) |
| T4 | Callers | in a scratch clone of this repository with the changed files laid over it, and with `HOME` set to a scratch directory, so that no file of the working checkout and no directory of the user is touched: `guest-baseline.bash` (with `GUEST_CHECKOUT` naming the clone) and `install-distribution.bash`, each with a wrapper checkout off the pin beside the clone; and `bash tools/prep-vendors.bash init`, which empties `~/.vendor_temp_folder`, clones both wrappers there and rewrites `configure/CONFIG_SITE.local` of its checkout | local scratch | each of the first two stops before it builds; the two clones of `prep-vendors.bash` under the scratch `HOME` are at the pins |
| T5 | Build from the pins | in each sandbox: move the two wrapper checkouts and the `vendor` directory of the tree aside under new names (nothing is removed), let the helper clone both wrappers at the pins, build and install them with the targets that `guest-baseline.bash` uses, then run `examples/iocsh/tests/run_all.bash` | both test machines | the helper leaves both checkouts at the pinned tags; `vendor/lib` holds libuldaq 1.2.2 and libopen62541 1.3.15 and no file of another version; the vendor record of each names the pinned tag and matches its digest; the suite passes |
| T6 | Static | `bash -n` and shellcheck on the new and the changed scripts; the six workflow files parse as YAML | local | no finding |
| T7 | CI | the pushed change | six systems | pass; each workflow log shows the commits of the pinned tags |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-18 | local, Debian 13, uncommitted change on `0abc552` | Pass: `1.2.2-1` and `1.3.15-2` | output of the two commands |
| T2 | 2026-11-18 | local, Debian 13, uncommitted change on `0abc552` | Pass: 18 checks, no failure. Eight scratch copies of the helper, each with one behaviour changed (no comparison of the commit with the pinned tag, no check of changed tracked files, an empty or malformed pin accepted, a fetch into an existing checkout, `--any-commit` ignored, no check that the directory is the root of its repository, an unknown wrapper name taken as `uldaq-env`, `--help` ended as a usage error), each fail the matching check | `tools/verify_vendor_checkout.bash`; mutation table `work/scratch/m21-mutants.py` |
| T3 | 2026-11-18 | local scratch, network | Pass: `uldaq-env` at `29994f2`, `open62541-env` at `ab75700`; with the other tags in the scratch copy `a5094ec` and `00e5e60` | output line of the helper for each of the four clones |
| T4 | 2026-11-18 | scratch clone at `0abc552` with the changed files laid over it, scratch `HOME` | Pass: `guest-baseline.bash` stops with status 1 before any build and leaves both wrappers unchanged; `install-distribution.bash` stops with status 2 and writes nothing; `prep-vendors.bash init` clones both wrappers at the pins through SSH, and through HTTPS when SSH is made to fail; the working checkout has no new local configuration file | `work/scratch/m21-t4.bash` |
| T5 | 2026-11-18T21:02Z | sandboxes of Rocky Linux 8.10 and Debian 13, the 34 files that differ from the sandbox checkout `30c6919` laid over it | Pass on both: the helper clones `uldaq-env` at `29994f2` and `open62541-env` at `ab75700` and gives status 0 again on the built checkouts; both builds end with status 0; `vendor/lib` holds `libuldaq.so.1.2.2` and `libopen62541.so.1.3.15` and no library of another version; each vendor record names its pinned tag (`1.2.2-1`, `1.3.15-2`) and its commit, equals its digest file, and its `buildid=` line equals `readelf -n` of the installed library; the suite ends with status 0, 18 scripts, 301 checks, no FAIL line. The earlier wrapper checkouts and `vendor` directory stay beside the new ones under names ending in `.before-pin-<stamp>` | `work/scratch/m20/guest/t5-rocky8.log`, `work/scratch/m20/guest/t5-debian13.log` |
| T6 | 2026-11-18 | local, Debian 13 | Pass: `bash -n` and shellcheck give no finding on the two new scripts, `guest-baseline.bash` and `install-distribution.bash`; `prep-vendors.bash` keeps the one shellcheck note it had before the change (`SC1091`) and gains none; the six workflow files parse as YAML | command output |
| T7 | 2026-11-18T23:59Z | GitHub Actions, commit `d69d9ee`: Debian 12, Debian 13, Ubuntu 24.04, Ubuntu 26.04, Rocky 8, Rocky 10 | Pass: the six OS workflows end with success, and the log of each shows `uldaq-env 1.2.2-1 29994f2e0bba4a1aee86fe1fb1c8b5c6d00c1fb2` and `open62541-env 1.3.15-2 ab7570088aa813cc1a906db6a638bd332ef03df1` in the lines of the helper; the Linter and the Deploy Docs workflows also end with success | `gh run list --repo jeonghanlee/EPICS-env --commit d69d9eed9023ed49e8c70821f3c7cc01f5246fcd` and `gh run view <run> --log` |

T3, T4 and T5 ran before two changes that the reviews of the change brought: `guest-baseline.bash --rebuild` checks the pins before it moves the install location aside, and `vendor-checkout.bash --help` prints the usage with status 0. Neither changes the code that clones a wrapper or checks an existing checkout. T1, T2 and T6 were run again on the final files on 2026-11-18. The changed order was observed on that date in a scratch clone with both wrappers off their pins: `guest-baseline.bash --rebuild` ends with status 1 and leaves the install location in place. T7 runs the final files.

##### Closure Evidence

The pins, the helper, its test, the changed workflows and scripts and the eight document pages are commit `0b8db64` ("Pin the vendor wrapper repositories by tag through one helper"), and the results T1 to T6 are commit `d69d9ee`; both were pushed on 2026-11-18, and a fetch at 2026-11-19T00:01Z showed `origin/master` at `d69d9ee` with no difference to the local branch. The six OS workflows passed on `d69d9ee` (T7). The issue #145 was opened on 2026-11-18 and closes with the commit that records this closure.

#### M22 - Container-based test server for IOC checks that need a server

Origin: 441e2e0 / M22
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The static and dynamic load checks of this repository run without an external service, but the IOC checks of some services need a server. The check of the reccaster fragment stops at the status records because delivery to a recceiver needs one (`verify_reccaster.sh`). The owner decided on 2026-11-14 to keep a test server for such checks, built the way `opcua-server-sim` serves OPC UA: a container-based server, or a program that serves the same purpose.

On 2026-11-26 the owner decided the form (D45): one Debian 13 container image that carries the recceiver beside the IOC, run on both test machines. A trial by the session of the `Dockerfiles` repository on the runner images showed that the recceiver starts on Debian 13 and Rocky Linux 8.10, that its announce reaches an IOC in the same container, and that the log of its `show` processor lists the records of the IOC; that session then published the image (G3).

##### Scope

A new check script beside `verify_reccaster.sh` that pulls the published Debian 13 image `jeonghanlee/debian13-epics-recceiver-test:1.5.0.1` by its digest, runs it under `podman` on both test machines, starts the IOC with the reccaster fragment of this repository in it and reads the channel list in the log of the recceiver; the image itself is built by the session of the `Dockerfiles` repository (G3).

Out of scope: ChannelFinder and elasticsearch, the module `reccaster` (M13), the IOC side of other services, a distribution image, a Rocky Linux image, running the check in CI (`docs/CLOSED_DOORS.md`, K22), pinning `python3-venv` and the base tag of the image (the `Dockerfiles` repository), and a GitHub issue until the owner opens one.

##### Completion Criteria

- The new check passes on both test machines against the pulled image and fails when the recceiver is stopped or when the announce address has no listener.
- The digest of the image is recorded in the new script and in this detail.

##### Dependencies And Decisions

D23, D39 and D45 apply. G3 is complete: the image is published. The item runs on the Base pin `tags/R7.0.10` and does not wait for M7 or M8.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-26, accepted by the owner in chat after the second-person passes on `work/plan-m22-recceiver-image.md` (revised for one Debian 13 image) and on this detail; the T3 method and step 3 were corrected on 2026-11-26 at the owner's instruction to match the implemented check (the names of `dbl` equal the record and alias names of the recceiver log, and the output of `install` is shown on failure only), and on 2026-11-26 the T1 method and expected result were extended to the build record of the image at the owner's instruction, and the wait of T2 was set to the 40 s of the script when the results were recorded
Implementation Authorization: 2026-11-26, authorized by the owner in chat
Superseded Plan Artifacts: the first draft of `work/plan-m22-recceiver-image.md` (two images, one per OS), accepted and authorized by the owner on 2026-11-26 and replaced by the revision for one Debian 13 image on the same day; its file was overwritten by the revision

1. Done: the session of the `Dockerfiles` repository built the Debian 13 image and published it (G3).
2. Pull the image by its digest and run it under `podman` as the test user on each test machine: it shows whether the containers run rootless, whether `s6-svscan` runs as PID 1 and whether the loopback announce works with `RECC_ADDRLIST=127.0.0.1:5049` and no network (before T5).
3. Write the new check script beside `verify_reccaster.sh`: it pulls the image by its digest, mounts the directory `commonIocsh` of the checked repository read-only, starts the `demo` IOC with `ioc-runner --container` (the IOC directory, `-f` for `install`; the output of `install` is shown only when the start fails), waits at least 30 s, reads the recceiver log and the IOC values, and removes the container (T2, T3). State the new check in `docs/procedures/commonIocsh-verification-procedure.md`.
4. Prove that the check can fail with the scratch mutations of T4, then run it on both test machines (T5).
5. Commit and push each on its own trigger of the owner, and read the CI of the pushed commit when the script is in the suite.

##### Test Plan

Objective: the recceiver in the image receives the channel list of an IOC that loads the reccaster fragment of this repository, on both test machines with the same image, and the check fails when the delivery fails. Real target: the pulled image, `ioc-runner --container`, the fragment `reccaster.iocsh` of this repository and the log of the recceiver; no stub of the announce, the connection or the delivery.

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Image | the digest of the stored image; `podman inspect` for the labels `epics.recsync-ref` and `epics.base-image-digest`; `cat` of `/etc/epics-bake.manifest` and the hash of `/etc/recceiver/pip-freeze.txt`; the version that the venv reports | the stored image on a test machine | the recorded digest, the label `9834b94`, the manifest line `9834b94edc63eece42712b8355a4703d4286dd8f`, `recceiver` 1.5, the base-image digest of the manifest equal to its label, the `python3-venv`, `python3.13-venv` and venv Python versions recorded, and the manifest hash of `pip-freeze.txt` equal to the file |
| T2 | Announce and connection | the new script starts the image and the `demo` IOC; `caget` of `State-Sts` and `Msg-I`; the recceiver log | the Debian 13 test machine under `podman` | the IOC reads `State-Sts = Done` and `Msg-I = Synchronized` within 40 s (the default of `RECC_WAIT`); the log shows the announcer started and one transaction from the IOC |
| T3 | Channel list | the `show` log of the same run | the same run as T2 | the log lists the records of the IOC (`State-Sts`, `Msg-I` and a record of the loaded database) and the names of `dbl` on the IOC console equal the record names plus the alias names of that log |
| T4 | Check can fail | scratch mutations: the recceiver stopped, and `addrlist` set to an address with no listener | scratch copies on a test machine | the check reports failure for that reason in both |
| T5 | Both test machines | T1 to T3 with the same image | the Debian 13 and the Rocky Linux 8.10 test machine | all pass on both |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-27T06:56Z (Debian 13) and 2026-11-27T06:57Z (Rocky Linux 8.10) | the committed script of `3ad58bd` cloned into a scratch folder on each test machine, with the image stored from Docker Hub at the digest of the script | Passed on both machines: the digest, the label `epics.recsync-ref` `9834b94`, the full commit `9834b94edc63eece42712b8355a4703d4286dd8f` in the manifest, `recceiver` 1.5, the base-image digest `sha256:cd492e31795e533b35aca903c8a961713c6758ed8624c9ba4c84cd33ba9ed82b` of the manifest equal to its label, `python3-venv` 3.13.5-1, `python3.13-venv` 3.13.5-2+deb13u5, the venv Python 3.13.5, and the manifest hash of `pip-freeze.txt` equal to the file | commit `3ad58bd`; the run output is not kept as evidence |
| T2 | the same runs | the same | Passed on both machines: `State-Sts = Done` and `Msg-I = Synchronized` after 14 s in the runs before the commit; the committed script reports PASS=19 FAIL=0 in 31 s (Debian 13) and 33 s (Rocky Linux 8.10); the log shows the announcer and one transaction from the IOC | commit `3ad58bd` |
| T3 | the same runs | the same | Passed on both machines: the log lists `RECCHK:State-Sts`, `RECCHK:Msg-I`, `RECCHK:li` and `RECCHK:lo`, and the six names of `dbl` (the four records and the aliases `lix1` and `lix2`) equal the record and alias names of the log | commit `3ad58bd` |
| T4 | 2026-11-27T06:48Z to 06:52Z | scratch copies of the script on both test machines | Passed: with the recceiver service stopped and with the announce list `127.0.0.1:5999` (no listener), each run on each machine reports PASS=12 FAIL=7: `State-Sts` stays `Listening` and `Msg-I` `Searching` for 40 s, the log shows no transaction and no record. A scratch copy with the manifest keys renamed reports PASS=15 FAIL=4 on Debian 13, one failure for each renamed key group. A stored image is used without contacting the registry (the run passes with the registry unreachable, 32 s on both machines); an absent image is pulled and the run passes (34 s on Debian 13) | commit `3ad58bd` and its scratch copies; the copies are not kept as evidence |
| T5 | 2026-11-27T06:56Z (Debian 13) and 2026-11-27T06:57Z (Rocky Linux 8.10) | the Debian 13 and the Rocky Linux 8.10 test machine under rootless `podman` (5.4.2 and 4.9.4), one image | Passed: T1 to T3 pass on both machines with the same image, PASS=19 FAIL=0 | commit `3ad58bd` |

##### Closure Evidence

Both completion criteria are met on 2026-11-27. The check `examples/commonIocsh/tests/verify_reccaster_delivery.sh` passed on the Debian 13 and the Rocky Linux 8.10 test machines against the image `jeonghanlee/debian13-epics-recceiver-test` at the digest `sha256:f5092f132f1074d8909f9ca22853151ae7002c2c374752e8aa30322ef2932a97`, which the script and this detail record, and it fails for each of its two mutations on both machines (T1 to T5). The commit `3ad58bd` is on the upstream: on 2026-11-27T07:26Z `origin/master` was `3ad58bdf62be7a64e26f40fd95a34c1c917e2669`, and the committed script and procedure document equal it. The CI of that commit passed on the Linter and on the six systems (runs 45955011283 to 45955011379, completed between 2026-11-27T06:57Z and 07:25Z). The CI does not run the check (`docs/CLOSED_DOORS.md`, K22).

#### M23 - Use the patch skill for the patch work of the next release

Origin: 441e2e0 / M23
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

The skill `patch` of the `dev-env` repository states the rules for applying and reverting carried patches, holds the revert tool, of which `tools/revert_patch.bash` is a copy, and holds a condensed copy of the general stages of `docs/procedures/upstream-fix-carry-procedure.md`. The skill is the original of the rules and of the tool, and this repository is the source of the procedure copy (D28). The owner decided on 2026-11-16 that the next release uses the skill for its patch work (D29). The EPICS-env session reviewed the skill against the repository on that date and found the text in agreement, but no carry was run with it; D29 names the reviewed revision. The release is planned (D39), so the item waits for M7 and M8, whose patch work it records, and D40 defers it until the release starts.

##### Scope

At the next release, do the patch work with the skill: the selection of upstream fixes to carry, the generation and naming of the patches, apply and revert of the set, and the recovery after a second apply. The apply is done with the direct `patch` calls of this repository, not with the apply tool of the skill (D28, `docs/CLOSED_DOORS.md` K21). Before use, confirm that `tools/revert_patch.bash` of this repository equals the revert tool of the skill, and take the skill file when they differ (D28). Record each place where the skill is wrong, incomplete or differs from a repository document, tell the `dev-env` session, and settle it. Name the parts of the repository document that the skill alone served, as candidates for leaving the document (D28).

Out of scope: a change of the apply side, an edit of the copy `tools/revert_patch.bash` (a change of the tool is proposed to the skill), moving a part out of the repository document (a change of its own after this item, D28), editing the skill from this repository (the `dev-env` session is its writer), and a GitHub issue until the owner opens one.

##### Completion Criteria

- The patch work of the next release was done with the skill, and the record names the commit of the skill that was used.
- Each difference found between the skill and the repository is recorded with its outcome.
- The parts of `docs/procedures/upstream-fix-carry-procedure.md` that the skill alone served are listed for the owner's decision.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D28, D29, D39 and D40 apply. It waits for M7 and M8: the patch work of the release is their patch work. D40 defers the item until the release starts, and a new dated decision then returns it to Not started.

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

#### M25 - Compare the vendor libraries with their record before an IOC starts

Origin: 441e2e0 / M25
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

`iocsh.bash` compares the build-id of each module library with the record of its module before it starts an IOC (M20, D25, D26). The vendor libraries `libuldaq` and `libopen62541` have a record of the same form since the wrapper tags `1.2.2-1` and `1.3.15-2` (D31, D32, M21), and nothing reads it: D25, D31 and D32 left open what the loader does with a vendor record. The owner asked on 2026-11-18 to take this up next and decided the behaviour on that date (D34).

##### Scope

Implement what D34 decides for the vendor records and for a vendor library that a selected module needs, in the loader, its tests and the documents, and correct the sentence of `docs/src/concepts/shared-library-identity.md` (Limits) that says the libraries of `vendor` have no record.

Out of scope: the wrapper repositories and the form of the record (D31, D32), libraries of EPICS base and of the system, a check at build time of the vendor record against the pinned tag (D34), and the handling of a refused start under `procServ` (jeonghanlee/epics-ioc-runner#169).

##### Completion Criteria

- `iocsh.bash` behaves as D34 states for a vendor library whose build-id differs from its record, for a vendor directory without a record, and for a changed record, in a start and with `-n`, and the loader suite passes on both test machines.
- The documents state the behaviour and no longer say that the vendor libraries have no record.

##### Dependencies And Decisions

D18, D25, D26, D31, D32 and D34 apply. M20 supplies the comparison and M21 the records on the test machines; both are Complete. The owner answered the five questions of the draft plan on 2026-11-18 (D34).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-18, accepted by the owner after two third-person and three second-person passes on the plan
Implementation Authorization: 2026-11-18, authorized by the owner
Superseded Plan Artifacts: none

The plan is `work/plan-vendor-record-check.md` (2026-11-18). Its facts are read from commit `74db939`; its implementation steps follow D34.

1. `tools/iocsh.bash`: a reader for the vendor records and the comparison of the resolved files of class `vendor`, with paths taken against the vendor directory resolved to its real path.
2. The show mode marks a vendor file with its build-id.
3. `examples/iocsh/tests/verify_build_ids.bash`: a vendor section on its copy of the installed tree, with startup files that name `opcua` and `measComp`, the real loader and the real ELF tool.
4. Documents: `shared-library-identity.md`, `installed-module-loader.md`, `installed-tree.md`, the page `run-ioc-from-installed-modules.md` with its table of messages (added after the review of the implementation), and the row of `iocsh.bash` in `tools-and-scripts.md` when its text changes.
5. Register, and information to the sessions of the wrapper repositories and of `epics-ioc-runner`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Vendor cases | the vendor section of `examples/iocsh/tests/verify_build_ids.bash` with every record case, after `make install.iocsh` has installed the changed loader into the tree that the tests run | both test machines, whose trees hold vendor records | every check passes |
| T2 | Tree without a record | the same script on a tree whose vendor directory has no record, after `make install.iocsh` | local | the two checks that need no record pass (the show mode marks the vendor file `not recorded`, and a start reaches `iocInit`), and the script prints that the record cases were not run |
| T3 | Checks can fail | scratch copies of the loader with one behaviour removed each (no vendor comparison, no digest check, no format check, no duplicate check, a missing record refused, the vendor directory not resolved), each put in place of `base/bin/<arch>/iocsh.bash` in a copy of the installed tree that `IOCSH_TEST_TREE` names | one test machine | each copy fails the matching check |
| T4 | Suite | `examples/iocsh/tests/run_all.bash` in the sandboxes through `tools/module-check/guest-suite.bash`, with the uncommitted files laid over the sandbox checkout and the changed loader installed | both test machines | the suite passes |
| T5 | Static | `bash -n` and shellcheck on the changed scripts | local | no finding |
| T6 | CI | the pushed change | six systems | pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-19T00:53Z | sandboxes of Debian 13 and Rocky Linux 8.10: the 39 files that differ from the sandbox checkout `30c6919` laid over it, `make install.iocsh` status 0, installed loader and `tools/iocsh.bash` with the same SHA-256 (`3a5e3bcfba9013aa`) | Pass on both: `verify_build_ids` ends with 42 checks and no failure, 13 of them in the vendor section, on trees whose vendor directories hold the records of `open62541` and `uldaq`. A first run on both machines failed one check, the one for a tree reached through a symbolic link, because the check compared the whole error line with a shortened text; the loader had refused the start with status 78 and the expected line. The check was corrected and the run repeated | `work/scratch/m25/guest/t1b-debian13.log`, `t1b-rocky8.log`; the first run `t1-debian13.log`, `t1-rocky8.log` |
| T2 | 2026-11-19T00:55Z | local Debian 13, a tree of release 1.5.0 whose vendor directory has no record, after `make install.iocsh` (same SHA-256 as above) | Pass for the vendor section: the script prints that the record cases were not run, and its two checks pass. The script as a whole reports 18 failed checks on this tree, all outside the vendor section: the module records of a release 1.5.0 tree are format 1, and the script expects a tree with records of format 2. The committed script reports the same 18 failures on the same tree (11 passed there, 13 with the vendor section) | `work/scratch/m25/out-local2/verify_build_ids.log`; the committed script `work/scratch/m25/out-local0/verify_build_ids.log` |
| T3 | 2026-11-19T02:00Z | Debian 13 test machine, a copy of the sandbox tree with the loader under test in place of `base/bin/linux-x86_64/iocsh.bash`, the test script of T1 | Pass: the unchanged loader passes all 42 checks, and each of the six changed copies fails the matching check and no other outside it: no vendor comparison fails ten checks of the vendor section; no digest check fails "a vendor record changed after it was written"; no format check fails "an unknown vendor record format"; no check of a path that two records name fails "two vendor records that name one path"; a refusal of a library that no record names fails the two checks for that case; an unresolved vendor directory fails the check for a tree reached through a symbolic link. The log gives the SHA-256 of each loader | `work/scratch/m25/guest/t3-debian13.log`; the changed copies `work/scratch/m25/mutants/` |
| T4 | 2026-11-21T01:08Z | sandboxes of Debian 13 and Rocky Linux 8.10, checkout `30c6919` with the 39 files laid over it, installed loader `b7ffc1dddd633ca2` and test script `54e4776407dd0c81` | Pass on both: the suite ends with status 0, 18 scripts with exit 0, 316 checks, no FAIL line (854 s on Rocky Linux, 976 s on Debian). An earlier run on the loader `3a5e3bcfba9013aa` (314 checks) passed too, after a first run that did not count: the disk of the Rocky Linux machine filled while the suite ran and its last four scripts failed for lack of space, and on the Debian machine the suite refused to start with too little free space. The owner approved the removal of the leftovers of earlier runs on both machines twice, and the suite was run again each time | `work/scratch/m25/guest/t4c-rocky8.log`, `t4c-debian13.log`; the earlier runs `t4b-*.log`, `t4-*.log` |
| T5 | 2026-11-19T00:56Z | local Debian 13 | Pass: `bash -n` and shellcheck give no finding on `tools/iocsh.bash` and `examples/iocsh/tests/verify_build_ids.bash` | command output |
| T6 | 2026-11-21T00:43Z | GitHub Actions, commit `2deb695` | Pass: the six OS workflows (Debian 12, Debian 13, Ubuntu 24.04, Ubuntu 26.04, Rocky 8, Rocky 10) end with success, and Linter Run and Deploy Docs also end with success | `gh run list --repo jeonghanlee/EPICS-env --commit 2deb69566f167cd688a8524ca4d32b01323bdc78` |

The first runs of T1 to T4 were made on the files as they stood on 2026-11-19. The review of the implementation then brought four changes: the message for a path that one vendor record names twice, the name of one check, one more check for that message (43 checks in `verify_build_ids` in place of 42, 14 of them in the vendor section), and the page `run-ioc-from-installed-modules.md`. After them, on 2026-11-20, `verify_build_ids` was run again on both test machines with the loader `5c5b89341cfbe3eb` installed (43 checks, no failure; `work/scratch/m25/guest/t1c-debian13.log`, `t1c-rocky8.log`), also locally on a tree without vendor records (13 checks passed, 18 failed outside the vendor section as in T2) and on a scratch copy with vendor records (43 checks, no failure). The two mutants that touch the changed code (no check of a path that records name twice, and the new message reported as two records) were run on the Debian machine: the unchanged loader passes 43 checks, the first mutant fails the two checks for a path named twice, the second fails the one new check (`t3c-debian13.log`). The other five mutants of T3 change code that was not touched and were not run again. The whole suite of T4 was run again on the final files on 2026-11-21 (see its row). A later change of the remedy text of the vendor messages of the loader (loader `b7ffc1dddd633ca2`) and of the message table of the procedure page was followed on 2026-11-20 by another run of `verify_build_ids` on both test machines (43 checks, no failure; `t1d-rocky8.log`, `t1e-debian13.log`) and locally on both trees (13 checks passed on the tree without vendor records, 43 on the scratch copy with records). On the Debian machine the free-space limit of `guest-suite.bash` (`GUEST_SUITE_MIN_FREE_KB`) was lowered to 3000000 KB for that one script, because the leftovers of the mutation run left 5.6 GB free and the script needs about 1.2 GB. The mutants ran on the loader `5c5b89341cfbe3eb`, which differs from the final one in the remedy text only. The review of the documents then brought two more changes: the two message rows of the procedure page now point to steps 1, 3 and 4 of the build page, and `verify_build_ids` counts a refusal of the correct case on a tree with vendor records as a failed check (44 checks in all, 15 of them in the vendor section), because such a refusal had made the whole vendor section skip with no failure (`ok=29 fail=0` on a scratch copy that held a second record for one path). With the loader changed to read format 2 only, the script ends with one failed check on that copy (run locally on the scratch copy). On 2026-11-20 the script passed again on both test machines (44 checks; `t1f-rocky8.log`, `t1f-debian13.log`) with the free-space limit of `guest-suite.bash` lowered as before, and on the scratch copy with records (44 checks); on the tree without records 13 checks passed as before. The test machines hold 3.8 GB (Rocky Linux) and 3.3 GB (Debian) free after these runs.
`shellcheck` and `bash -n` of T5 were run again on the final files.

##### Closure Evidence

The loader, its test and the four document pages are commit `69f03dc` ("Compare vendor libraries with their records before an IOC starts"); the decision, the plan state and the results T1 to T5 are commit `2deb695`. Both were pushed on 2026-11-20, and a fetch at 2026-11-21T01:08Z showed `origin/master` at `2deb695` with no difference to the local branch. The six OS workflows passed on `2deb695` (T6). On 2026-11-20 the sessions of `uldaq-env`, `open62541-env` and `epics-ioc-runner` were told what the loader accepts and the new message lines.

#### M26 - Fix the exit crash of the `opcua` module after a server restart

Origin: 441e2e0 / M26
Identity History: none
GitHub Issue: #146 (https://github.com/jeonghanlee/EPICS-env/issues/146)
Status: Complete

Retired on 2026-11-22 by D38: the exit crash is fixed in the upstream `master` of `epics-modules/opcua` (commits `608ba37` and `454525f`), and this repository takes the fix with the module bump of the release. The scope, the plan and the tests below are the plan that D38 replaced.

GitHub state observed: CLOSED (reason not planned) at 2026-11-23T07:11:37Z, label `bug`, milestone Backlog; its body was rewritten at the close with the upstream fix and the three criteria that apply, all checked, and a closing comment names the upstream commits. Recheck with `gh issue view 146 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

An IOC that runs the `opcua` module 0.11.2 (open62541 1.3.15 as the client library) and has lived through a stop and a start of its OPC UA server can end with SIGSEGV (exit status 139) when it is closed with `exit`. M4 saw it on 2026-11-22: 4 of 9 runs of the fixture test on Debian 13 and 0 of 7 on Rocky Linux 8.10 (the IOC without a server restart ended with status 0 in all of them), and 3 of 10 repeated runs of the body of that test on Debian 13, each of which left a core file. The three cores show the crash in the reconnect timer thread of the module (`Session::AutoConnect::expire`, `SessionOpen62541::connect`, `connectSync`, `connectionStatusChanged` with the session state ACTIVATED) with a null client: in one core `__UA_Client_Service(client=0x0)` at `ua_client.c` line 465 through `readCustomTypeDictionaries`, in two cores `findSubscription` at `ua_client_subscriptions.c` line 130 through `addAllMonitoredItems`. The source of v0.11.2 shows how: `connect()` creates the client and runs `UA_Client_connect` without `clientlock`, and `SessionOpen62541::atExit()` deletes the client under `clientlock` and sets it to null without stopping the reconnect timer or waiting for a connect that is running. The server is not involved: the simulator sets no session or channel timing and its own tests never restart the server. A search of `epics-modules/opcua` on 2026-11-22 found no issue with this symptom, and v0.11.2 is the latest release. The cause is a reading of the cores and the source until the patch is shown to remove the crash.

##### Scope

Write a patch for `devOpcuaSup/Session.h` and `devOpcuaSup/open62541/SessionOpen62541.cpp` of the `opcua` source that this repository carries, by the patch rules of the skill `patch`: at IOC exit `atExit()` first turns the automatic reconnection off and cancels the reconnect timer (waiting for an expiry that is running), and then closes the sessions. Add the patch to the `patch.opcua.*` targets of `configure/RULES_SRC`, rebuild and install the module, and show the effect with the repeated runs of the fixture test of M4. Remove the limitation paragraph from `examples/iocsh/opcua-IOC-demo/README.md` and the matching text where the results of M4 state it.

Out of scope: the report to `epics-modules/opcua` (D37 puts it after the verification), a change of the open62541 library or of the simulator, an upgrade of the module, and a change of what the module does at connection loss other than at exit.

##### Completion Criteria

- The patch applies to and reverts from the `opcua` source twice in a row, and the rebuilt module is installed in the tree of each test machine.
- The repeated runs of the body of `verify_fixture_opcua.bash` that ended with status 139 in 3 of 10 runs on Debian 13 end with status 0 in at least 30 runs on Debian 13 and in at least 30 runs on Rocky Linux 8.10, and no core file is left.
- A check of the fixture test fails on the unpatched module and passes on the patched module, so that the exit status of an IOC after a server restart is no longer only printed.
- The whole loader suite passes on both machines and the six CI systems pass.
- The limitation text of the fixture README is removed.

##### Dependencies And Decisions

D36, D37 and D38 apply; D38 replaces D37. M4 supplies the fixture test whose runs show the crash and the README text that this row removes; M26 starts after M4 is committed.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: `work/plan-opcua-exit-crash.md` (the draft of 2026-11-22 that carried a patch, replaced by D38)

1. Reproduce the crash on Debian 13 with the unpatched module in at least 30 runs of the body of the fixture test with core dumps enabled, and keep the rate.
2. Read `connect()`, `disconnect()`, `atExit()`, the worker thread `run()` and `connectionStatusChanged()` of the source and decide the smallest change that removes the race; stop for the owner if more than `atExit()` and the timer class need a change.
3. Write the patch, add its apply and revert targets, and rebuild and install the module in the sandbox of each test machine.
4. Repeat the runs of step 1 with the patched module and run the whole suite on both machines.
5. Change the fixture test so that the exit status after a server restart is checked, remove the limitation text, and record the results here and in the results of M4.
6. After the verification write the report for `epics-modules/opcua`; each commit, push and issue operation waits for its own trigger.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Baseline | at least 30 runs of the body of `verify_fixture_opcua.bash` with the unpatched module and core dumps enabled | Debian 13 test machine | status 139 in about a third of the runs, as observed before; the rate is recorded |
| T2 | Patch round trip | `make patch.opcua.apply`, `make patch.opcua.revert` and apply again on the `opcua` source | local checkout and one test machine | each step is clean and the second apply gives the same files |
| T3 | Effect | the runs of T1 with the patched module installed | Debian 13 and Rocky Linux 8.10 test machines | at least 30 runs on each end with status 0, no core file |
| T4 | Check can fail | the new check of the fixture test on the unpatched module | one test machine | it fails in the runs that crash and the test reports the failure |
| T5 | Suite | the whole loader suite through `guest-suite.bash` | both test machines | the suite passes |
| T6 | CI | the pushed change | six systems | pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 test machine | Waived by D38 | Closure Evidence |
| T2 | Not run | local checkout and one test machine | Waived by D38 | Closure Evidence |
| T3 | Not run | both test machines | Waived by D38 | Closure Evidence |
| T4 | Not run | one test machine | Waived by D38 | Closure Evidence |
| T5 | Not run | both test machines | Waived by D38 | Closure Evidence |
| T6 | Not run | six CI systems | Waived by D38 | Closure Evidence |

##### Closure Evidence

Retired by D38 on 2026-11-22, with no patch of this repository: the exit crash of the `opcua` module after a server restart is fixed in the upstream `master` of `epics-modules/opcua` by `608ba37` and `454525f` (2026-11-03), which follow the release v0.11.2 that this repository pins. The upstream commits were read on 2026-11-22 through the API of GitHub (both are in `master`, the head of which was `eb098d6` and 65 commits ahead of v0.11.2), and the carried patches were tried with `patch --dry-run` on a shallow clone of `master`: `opcua-CONFIG_OPCUA.p0.patch` applies, and `opcua-anon-ns-export.p0.patch` does not, because `master` already holds its change. The issue #146 was closed as not planned at 2026-11-23T07:11:37Z. Waived checks: T1 to T6 of this row, which belong to a patch that is not written; the repeated runs of the fixture test on the new module belong to the module bump of the release, where the limitation paragraph of the README of the opcua fixture is removed. The draft plan `work/plan-opcua-exit-crash.md` and the shallow clone under `work/scratch/opcua-master/` are not kept as evidence.

#### M27 - Move the opcua module to upstream master with the module bump

Origin: 441e2e0 / M27
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

The `opcua` module is pinned to the release `tags/v0.11.2`. The exit crash after a server restart, which the fixture test of M4 shows, is fixed in the upstream `master` by `608ba37` and `454525f`, which follow that release (D38). The owner decided on 2026-11-22 that this repository takes the fix by moving the module to the upstream `master` with the module bump of the release. It is release work (D39) and waits for M7 and M8, as M9 does.

##### Scope

At the module bump of the release, pin `SRC_TAG_OPCUA` to a commit of the upstream `master` and set `SRC_VER_OPCUA` to match, following `docs/procedures/module-bump-procedure.md`. Retire `patch/opcua-anon-ns-export.p0.patch`, which does not apply to `master` because the upstream code already holds its change, together with its `patch.opcua.export.*` rules in `configure/RULES_PATCH` and its entries in `configure/RULES_SRC`. Keep `patch/opcua-CONFIG_OPCUA.p0.patch`, which applies to `master`. Update `docs/src/reference/module-pins.md`. Remove the limitation paragraph of `examples/iocsh/opcua-IOC-demo/README.md` after the repeated runs end with status 0.

Out of scope: a patch of this repository for the exit crash, a report to `epics-modules/opcua` (D38), a change of the vendor library open62541, and a GitHub issue until the owner opens one.

##### Completion Criteria

- `SRC_TAG_OPCUA` names a commit of the upstream `master` that contains `608ba37` and `454525f`.
- `opcua-anon-ns-export` is retired, `opcua-CONFIG_OPCUA` applies, and apply and revert of the patch set are clean.
- At least 30 runs of the opcua fixture test on each test machine end with exit status 0 and leave no core file, and the whole loader suite passes on both.
- The limitation paragraph of the README of the opcua fixture is removed.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D38, D39 and D40 apply. It waits for M7 and M8, as M9 does, because the module bump runs on the tree of the Base pin of the release. D40 defers the item until the release starts, and a new dated decision then returns it to Not started.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

Define the implementation sequence when this item is activated with the module bump.

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

#### M28 - Add a development loader for modules outside the installed tree

Origin: 441e2e0 / M28
Identity History: none
GitHub Issue: #143 (https://github.com/jeonghanlee/EPICS-env/issues/143)
Status: Deferred

GitHub state observed: OPEN on 2026-11-23, label `enhancement`, no milestone. Recheck with `gh issue view 143 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

`iocsh.bash` loads only modules installed under `<tree>/modules`, from the metadata that the build wrote for the pinned commit. A module built outside the installed tree, such as `snmp3` from a working tree, stops with `Module snmp3 has no installed default link`, and the fix verification procedure has the same gap for an IOC that runs through the loader, which has no compiled executable. The snmp3 session of the lab host wrote a draft plan for a second loader `dev_iocsh.bash` on 2026-11-13 (revision 9, based on `62599f0`, never accepted); no code exists. The item is only tracked: the owner recalls that the earlier work stopped because the loader needed too many changes and that a new iocsh went on instead (D43).

##### Scope

Add `tools/dev_iocsh.bash`, which sources `iocsh.bash` and starts an IOC through the installed `softIocPVX` with one or more modules taken from directories outside the installed tree, a module that the tree lacks or a replacement of an installed one, under the production startup file. `iocsh.bash` is divided into step functions and keeps its options, messages and guarantee that it loads only installed modules built at their pins. `iocsh_metadata.bash` gains a mode that writes the loader metadata of the outside modules of one start into a temporary directory, and `iocsh_elf.bash undefined` gains an option for libraries that count as already loaded. A start marks each outside module and sets `DEV_IOCSH_MODULES` in the running IOC. The details are in the issue.

Out of scope: a change of how `iocsh_metadata.bash record` treats a checkout with uncommitted changes, running a production IOC with the new script, building the outside module, a separate class for outside files in the ELF inspection report, and a change of how that inspection compares directory names.

##### Completion Criteria

- The existing loader suite passes unchanged after the change of `tools/iocsh.bash`, and its output for the cases that print loader messages and generated startups is the same before and after; a case that pins the order of the checks of `select_module` is added before the change.
- A new test file runs the shipped scripts against a real installed tree and real builds outside it, with no substitute for a step of the loader path: an outside module that the tree lacks starts and serves a record, an installed module is replaced by an outside build with the entries of the installed module, an outside module that depends on another loads it first, and a replacement that lacks a function that an installed dependent calls directly is refused before the IOC starts.
- Every refusal of the plan is covered by a case, the tree and every outside directory are byte for byte unchanged after each case, and the temporary directory is removed after a start, after `-n` and after a refusal.
- The marks and `DEV_IOCSH_MODULES` are present, and one run against the released 1.5.0 tree with the `snmp3` working tree as the outside module starts.
- The new file is listed where the suite holds fixed lists, and the documents named in the plan are written or updated.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D43 applies: the item is Deferred and no work starts on it. If it is taken up again, the draft plan of the lab host is rewritten against the `master` of that day, because the three loader tools have changed since `62599f0`, and the figures that it rests on (the counts of installed modules, their `EPICS_BASE` lines and library entries, the lazy binding of the native loader and the references of the installed dependents of `asyn`) are measured again with a stated method; a check on 2026-11-23 reproduced the counts of `EPICS_BASE` lines and of dependents of `asyn` and did not reproduce the reference counts.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

None while the item is Deferred.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Basis | the counts and the lazy-binding observation of the draft plan measured again on the installed tree of each machine | Debian 13 and Rocky Linux 8.10 test machines | the figures are recorded and the plan states them |
| T2 | Loader suite | the whole existing suite before and after the change of `tools/iocsh.bash`, with the added case for the order of the checks | both test machines | the same results and the same loader output |
| T3 | New file | the cases of the plan against a real installed tree and real builds outside it | both test machines | each case ends as the plan states |
| T4 | Released tree | `dev_iocsh.bash` from the checkout against the released 1.5.0 tree with the `snmp3` working tree as the outside module | one test machine | the IOC starts |
| T5 | Lists and documents | the fixed lists of the suite and the documents of the plan | local checkout | complete |
| T6 | CI | the pushed change | the six CI systems | pass |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | both test machines | Pending | none |
| T2 | Not run | both test machines | Pending | none |
| T3 | Not run | both test machines | Pending | none |
| T4 | Not run | one test machine | Pending | none |
| T5 | Not run | local checkout | Pending | none |
| T6 | Not run | the six CI systems | Pending | none |

##### Closure Evidence

None.

#### M29 - Check the ULDAQ timeout patch on a real TC32

Origin: 441e2e0 / M29
Identity History: none
GitHub Issue: #142 (https://github.com/jeonghanlee/EPICS-env/issues/142), shared with M10; the issue carries the real-device criterion of this row and is closed when this row is complete (D47)
Status: Blocked

##### Summary

The timeout patch of ULDAQ (`1.2.2-net-timeout.p0.patch`, carried by M10) is verified against the simulator of `uldaq-env` and by a read-only check of `LAB-measComp` on the lab unit (G5), not on a failed command of a real TC32. This row holds that check, taken out of M10 by D47: a failed command of the TC32 ends after the command timeout with error 7 and without a second wait for the connection timeout. The session is the one of D46, the same as the hardware check M11 / T8, on the pair of measComp `1612c38` and the library of the tag that M10 pins. The only known unit is on the lab network; the permission and the time belong to the owner of `tcmd` (G5).

##### Scope

One session on a real network TC32 without EXP-32, with the library that is installed in the lab tree of the unit: `LAB-measComp` built it from `uldaq-env` `5bf26d9` (G5), the commit on which the tag `1.2.2-2` is. The session needs the commit in its build record under `vendor/cfg/uldaq` to equal the commit of the tag that M10 pins (D46). The items of M11 / T8 and a failed command are run, with the times of the attempts and the identity of the library from that build record (tag, source commit, patch). The results are recorded here and in M11 / T8.

Out of scope: the E-TC device check, the alarm configuration write (`uldaq-env#4`), a unit with EXP-32, and the checks on the test machines (M10).

##### Completion Criteria

- A failed command of the TC32 with the patched library ends after the command timeout with error 7, and the times of the attempts are recorded with the identity of the library (tag, source commit, patch) and the local times of the session, without host names or addresses.
- The commit in the build record of the library in the lab tree equals the commit of the tag that M10 pins.
- The items of M11 / T8 are recorded in the same session.
- The checklist of G5 is revised for the patched library before the session: its retry-pattern step compares with the older library.

##### Dependencies And Decisions

D2, D3, D39, D46 and D47 apply. M10 is complete and pins the tag `1.2.2-2` (commit `5bf26d9`), whose commit the library of the lab tree is compared with; the row waits for G5 (the permission and the time of the owner of `tcmd`) and resumes as Not started. When the commit of the lab tree differs from the commit of the pinned tag, `LAB-measComp` builds the library again from the pinned tag before the session. If the session is done on a build of an untagged commit, D46 applies: the result holds when the tag is later put on the same commit and is repeated when it is put on another. The cycle runs on the tree of the Base pin `tags/R7.0.10` and does not wait for M7 or M8 (D39).

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Revise `work/checklist-t8-tc32.md` (untracked) for the patched library and send it to `LAB-tcmd` again.
2. After M10, read the build record under `vendor/cfg/uldaq` of the lab tree and compare its commit with the commit of the tag that M10 pins; when they differ, `LAB-measComp` builds the library again from the pinned tag.
3. When the owner of `tcmd` gives the permission and the time (G5), run the session with the owner of EPICS-env and `LAB-measComp`; read the IOC log from the start.
4. Record the results in T1 and in M11 / T8, and close #142 with the body in step with the result.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Pair, real device | one session of G5 on a real TC32 without EXP-32: the items of M11 / T8, and a failed command; the IOC log read from start | a real TC32 | the library commit of the lab tree equals the commit of the pinned tag, the expected results of M11 / T8, a failed command ends after the command timeout with error 7, and the times of the attempts are recorded with the identity of the library |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | a real TC32 | Pending | none |

##### Closure Evidence

None.

#### M30 - Move the reconnection test and the vendor library update into tools/module-check

Origin: 441e2e0 / M30
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

The checks of M10 ran two procedures that are not in the repository. The reconnection test of the measComp fork ran through `m11/t4.bash`, which exists only on the two test machines and has the pin `1612c38254e3584ac32279665df6962379601c1b`, the root `/home/vmadmin/m11` and the tree (the first match of `sandbox/epics/1.5.0/*/7.0.10`) written in the file. The install of a vendor library into the tree of a sandbox was done by hand, as steps 1 and 3 of the build and installation page, and it leaves the modules that include the header of the library out of date: after the install of `uldaq-env` at its new pin the next `make install` recompiled four sources of measComp and relinked `libmeasComp.so`, whose hash then differed from its build record, and the first run of the loader suite failed with 12 checks on each machine (M10 / T1); `make build.measComp` after the install removed the failures. This row puts both procedures into `tools/module-check/`, next to `guest-update.bash` and `guest-suite.bash`, as scripts that read their values from the checkout and run on a machine through `guest-run.bash`.

##### Scope

- `tools/module-check/guest-meascomp-reconnect.bash`, from `t4.bash`: the pin of measComp comes from `SRC_TAG_MEASCOMP` and the clone URL from `SRC_BASE_MEASCOMP` and `SRC_NAME_MEASCOMP` of `configure/RELEASE` of the checkout, the tree from `make print-INSTALL_LOCATION_EPICS`, and the checkout and the run root are arguments. It builds the reconnect IOC of the fork against the Base, asyn and ULDAQ of that tree, runs each case in a user and network namespace with up to three attempts, runs the exit loop, keeps the logs and the JSON results of the run in the run directory, and moves an earlier run directory into `trash` through `tools/test-trash.bash`.
- `tools/module-check/guest-vendor-update.bash <wrapper> [conf_target] [checkout]`, from `work/m10-vm-install.bash`: `<wrapper>` is `uldaq-env`; `conf_target` is the configuration target of the wrapper, `conf` by default and `conf.rocky8` on Rocky Linux 8, as for `guest-baseline.bash`; `checkout` is the EPICS-env checkout, `${HOME}/sandbox/EPICS-env` by default, and the wrapper checkout is the directory `uldaq-env` beside it. The script moves the old wrapper checkout into the directory `trash` beside it, takes the checkout at the pin with `tools/vendor-checkout.bash`, installs the library into the `vendor` directory of the tree with `conf_target` as step 3 of the build and installation page, and then runs `make build.measComp`, which rebuilds the module, writes its build record and generates its loader metadata. It prints the vendor record keys `tag`, `source` and `patch` and ends with `BUILD-END rc=<n>`, as `guest-baseline.bash` does.
- Two rows in `docs/src/reference/tools-and-scripts.md`, in the table of the other `module-check` scripts, and the item of the same file that says where the `module-check` scripts run (it now counts five scripts that run on a test machine and three on the local host), which then counts seven and three and names the two new scripts among those that run on a test machine.

Out of scope: `t5.bash` and `t5m.bash` (the negative controls of the fork README, which belong with the fork), `suite-run.bash` and `baseline-build.bash` (`guest-suite.bash` and `guest-baseline.bash` replace them), the vendor update of `open62541-env` (its consumer module `opcua` is configured with care by `RULES_MODS_BUILD`, and no measurement shows that its update leaves the module out of date), a call of the new scripts from `cycle.bash`, and a helper that reads the logs of the CI jobs.

##### Completion Criteria

- Both scripts are in `tools/module-check/` with a header that names the usage, the arguments, the environment and the exit status, like the other scripts of the directory, and `bash -n` and ShellCheck print nothing for them.
- `guest-meascomp-reconnect.bash` run on both test machines at the pin of `configure/RELEASE` gives the results of M10 / T2 for the reconnection test: the cases pass and the exit loop reports every run passed, and no value of a machine is written in the file.
- `guest-vendor-update.bash` run on both test machines leaves `vendor/cfg/uldaq/build-record` with the tag, the source commit and the patch of the pin, and `guest-suite.bash` with the site checkout `~/sandbox/alsu-site-modules` as its third argument passes (349 checks, as in M10 / T1) with no rebuild step outside the script.
- On a tree whose measComp was built against the library of the previous pin (`1.2.2-1`), a scratch copy of `guest-vendor-update.bash` without its `make build.measComp` step, run at the new pin, makes `verify_install_metadata` fail as in the first run of M10 / T1, and the script restores the tree.
- The tools reference lists both scripts, and its item on where the `module-check` scripts run counts them.

##### Dependencies And Decisions

D2 and D3 apply. M10 is complete and supplies the measurements for both scripts (M10 / T1 and T2). The row does not depend on G5, M11 or M29. The owner of EPICS-env accepted three points with the plan on 2026-11-27, each as this plan recommends: (1) the vendor update covers `uldaq-env` only, because the effect on `open62541-env` and `opcua` is not measured (recommended); (2) the table of cases of `guest-meascomp-reconnect.bash` stays in the script as one table that names the README of the fork at the pin, since `test_reconnect.pl` fails on a case it does not know (recommended), and is not read from the fork; (3) `cycle.bash` does not call the new scripts in this row (recommended).

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-11-27, the revision of step 5, of T4 and of the completion criterion on the scratch copy accepted by the owner in chat after the fourth second-person pass on the plan, which read the revision (the first three passes read the plan before it), with the other choices of the earlier acceptance unchanged
Implementation Authorization: 2026-11-27, the owner, for the plan as accepted above, including the deletion of earlier suite logs in `trash` of the sandbox when the free space of a machine is below the limit of `guest-suite.bash`
Superseded Plan Artifacts: Step 5 and T4 with the completion criterion on the scratch copy of the plan accepted and authorized on 2026-11-27 (commit `766e6fa`); the first run of that T4 did not fail `verify_install_metadata` (Verification Results, T4)

1. Read the sources again: `t4.bash` (the two copies are identical), `work/m10-vm-install.bash`, and `tools/module-check/guest-update.bash`, `guest-suite.bash` and `guest-baseline.bash` for the header form, the `set` options, the use of `tools/test-trash.bash` and the exit statuses.
2. Write `tools/module-check/guest-meascomp-reconnect.bash` as in the scope. Arguments `[checkout] [root]`, with the defaults `${HOME}/sandbox/EPICS-env` and `${HOME}/sandbox/reconnect`. The table of cases (the default case, `digital-word`, `digital-control`, `digital-policy`, `digital-bits`, the five `enum-` cases, the four `bounds-` cases, the four `mac-` cases, the eight `endpoint-` cases, `silent-device`, `read-error`, `temperature-array`, `temperature-diagnostics`, 30 in all, each with its time limit and template) is one table at the top. `SRC_TAG_MEASCOMP` holds an abbreviated commit; the script checks out the commit it names and prints the full hash. The exit status is 0 only when every case passed within three attempts and the exit loop reported every run passed.
3. Write `tools/module-check/guest-vendor-update.bash <wrapper> [conf_target] [checkout]` as in the scope, with the defaults named there. A wrapper other than `uldaq-env` ends with a usage error.
4. Add the two rows to `docs/src/reference/tools-and-scripts.md` and change its item on where the `module-check` scripts run so that it counts seven scripts on a test machine and three on the local host.
5. On both test machines, lay the two scripts over the sandbox checkout and run them through `guest-run.bash` (T2 and T3), then the check that can fail (T4) on the Debian machine. When the free space of a machine is below the limit of `guest-suite.bash`, the earlier suite logs in `trash` of the sandbox are deleted first, as the owner allowed in chat on 2026-11-27.
6. Record the results in this detail. Commit and push only under the separate commit and push authority.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Syntax | `bash -n` and ShellCheck on both scripts | local | no output, status 0 |
| T2 | Reconnection test | `guest-meascomp-reconnect.bash` through `guest-run.bash` on each machine, with the sandbox checkout and its tree | Debian 13 and Rocky Linux 8.10 test machines | every case passes within three attempts, the exit loop reports 150 runs and 150 passed, the commit in the output begins with `SRC_TAG_MEASCOMP` of the checkout, and the run directory under the run root (not the log directory of `guest-run.bash`) holds the JSON results |
| T3 | Vendor library update | `guest-vendor-update.bash uldaq-env <conf_target>` through `guest-run.bash` (`conf` on Debian, `conf.rocky8` on Rocky Linux), then `guest-suite.bash` with the site checkout `~/sandbox/alsu-site-modules` as its third argument | Debian 13 and Rocky Linux 8.10 test machines | `BUILD-END rc=0`, the record shows `tag=1.2.2-2`, a source that begins with `5bf26d9` and `patch=1.2.2-net-timeout.p0.patch`, and the suite gives 349 ok and 0 fail |
| T4 | Check can fail | (1) the sandbox checkout at `e07ab5d`, the commit before the pin (`VENDOR_ULDAQ_TAG` is `1.2.2-1`), and the real script with `conf`, which installs the library of `1.2.2-1` and builds measComp against it; (2) the checkout back at `3a646d9`, its commit before this step; (3) the same script copied, with the line `make build.measComp` removed, to the file `scratch-no-rebuild.bash` in `tools/module-check/` of the sandbox checkout (the scripts of that directory source `../test-trash.bash` relative to their own place), run with `conf`, which installs the library of `1.2.2-2` over it; (4) `guest-suite.bash` with the site checkout `~/sandbox/alsu-site-modules` as its third argument and the script `verify_install_metadata`; (5) the real script again with `conf`; (6) `guest-suite.bash` with the site checkout for every script | Debian 13 test machine | step 4 fails in `verify_install_metadata` with `Installed artifact differs from the build record`; after step 5 the suite of step 6 gives 349 ok and 0 fail; the scratch file is moved into `trash` afterwards |
| T5 | Document | the two rows of the tools reference and its item on where the `module-check` scripts run; `examples/iocsh/tests/verify_docs_and_tools.bash` | local | the rows name the scripts as the files are named, the item counts seven scripts on a test machine and three on the local host, and the script passes |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | 2026-11-28T06:34Z (`bash -n` and `shellcheck` on the files after the changes of the second-person review; the first run 2026-11-28T06:19Z gave the same result) | local | Pass: `bash -n` and plain `shellcheck` on both scripts print nothing, status 0; no value of a machine is written in the code | `bash -n tools/module-check/guest-meascomp-reconnect.bash tools/module-check/guest-vendor-update.bash`; `shellcheck` on the same two files; `grep -n -i -E 'vmadmin\|debian\|rocky\|/home/'` on the two files, without the comment lines, prints nothing (no value of a machine is written in the code; the only address literals are the fixture addresses 192.0.2.1 to 192.0.2.3 of the namespace) |
| T2 | finished 2026-11-27T23:10Z | Debian 13 and Rocky Linux 8.10 test machines, sandbox at `3a646d9` with the two scripts laid over it, trees `debian-13/7.0.10` and `rocky-8.10/7.0.10`, asyn 4.46.0 | Pass on both machines: the commit is `1612c38254e3584ac32279665df6962379601c1b`, which begins with `SRC_TAG_MEASCOMP` `1612c38`, the build status is 0, `cases: 0 of 30 failed`, the exit loop reports `case endpoint-same-ip: 150 runs, 150 passed, 0 failed`, and the last line is `RECONNECT-END rc=0`; the run directory `~/sandbox/reconnect/run` of each machine holds 30 files `<case>.attempt1.out` and 30 files `<case>.attempt1.log.json` (95 files in all), observed 2026-11-28T06:21Z; the file of `guest-meascomp-reconnect.bash` changed after these runs in one message of an error path and in comments (a finding of the second-person review of 2026-11-28), and no run reaches that message | `work/m30/m30-review-run-debian13.log`, `work/m30/m30-review-run-rocky8.log` for the run directory, and `work/m30/m30-reconnect-debian13.log` and `work/m30/m30-reconnect-rocky8.log` (the run directory is `~/sandbox/reconnect/run` on each machine; the time is the modification time of the log) |
| T3 | Debian 13 2026-11-27T23:11:01Z to 23:28:13Z; Rocky Linux 8.10 2026-11-27T23:10:41Z to 23:26:37Z | Debian 13 and Rocky Linux 8.10 test machines, sandbox at `3a646d9`, site checkout `~/sandbox/alsu-site-modules` as the third argument of `guest-suite.bash` | Pass on both machines (`conf` on Debian and `conf.rocky8` on Rocky Linux, as the commands of the runs give): `guest-vendor-update.bash uldaq-env` ends with `BUILD-END rc=0` and the record shows `tag=1.2.2-2`, `source=5bf26d9a87095b2beb8ac6d981fe9db24dcf2a13` and `patch=1.2.2-net-timeout.p0.patch`; the suite that follows gives `run_all rc=0`, 0 FAIL lines, and the `SUMMARY` lines add up to 349 ok and 0 fail | `work/m30/m30-vendor-update-debian13.log`, `work/m30/m30-vendor-update-rocky8.log`, `work/m30/m30-suite-debian13.log`, `work/m30/m30-suite-rocky8.log` |
| T4 | 2026-11-28T03:26:50Z to 03:52:54Z (revised method) | Debian 13 test machine, sandbox checkout moved to `e07ab5d` and back to `3a646d9` | Pass: step 1 installed `tag=1.2.2-1` (`BUILD-END rc=0`); step 3, the copy without `make build.measComp`, installed `tag=1.2.2-2`; step 4, `guest-suite.bash` with the site checkout and the script `verify_install_metadata` (03:31:07Z to 03:33:16Z), gave `ok=9 fail=3` with `Installed artifact differs from the build record` for `libmeasComp.so` and the failed checks `repeated make install succeeded`, `content is unchanged after the repeated installation` and `content is unchanged after the repeated base installation`; step 5, the real script, restored `tag=1.2.2-2` (`BUILD-END rc=0`, 03:36:31Z); step 6, the whole suite with the site checkout (finished 03:52:46Z), gave `run_all rc=0`, 0 FAIL lines and 349 ok, 0 fail; the scratch file is in `~/sandbox/trash` and `git status` of the sandbox shows only the two new scripts. The first method of the superseded T4 (2026-11-27T23:30Z to 23:35Z) installed the library of `1.2.2-2` over the same library and `verify_install_metadata` gave `ok=12 fail=0`, so that method did not fail | `work/m30/t4r-1-prev-pin-debian13.log`, `t4r-3-scratch-debian13.log`, `t4r-4-suite-fail-debian13.log`, `t4r-4-fail-detail-debian13.log`, `t4r-5-real-debian13.log`, `t4r-6-suite-pass-debian13.log`, `t4r-7-cleanup-debian13.log`; the first method: `work/m30/m30-t4-*-debian13.log`; before step 1 the earlier suite logs of `~/sandbox/trash/20261127T233042Z.SCIRTd` (6.3 G) were deleted, as the plan allows (`t4r-clean-debian13.log`) |
| T5 | 2026-11-28T06:19Z for the rows; the script ran inside the suites (T3, T4 step 6) | local for the rows; Debian 13 and Rocky Linux 8.10 test machines for `verify_docs_and_tools.bash` | Pass: the two rows are in `docs/src/reference/tools-and-scripts.md` (lines 55 and 60) under the names of the files, the item on where the `module-check` scripts run counts seven scripts on a test machine, names both new scripts, and names `guest-run.bash`, `cycle.bash` and `plan-facts.pl` as the three that run on the local host, and `verify_docs_and_tools` gave `ok=6 fail=0` in each of the three suite runs; the script needs an installed tree, so it was not run on the local host | `grep -n -E 'guest-meascomp-reconnect\|guest-vendor-update\|Seven scripts' docs/src/reference/tools-and-scripts.md`; `work/m30/m30-suite-debian13.log`, `work/m30/m30-suite-rocky8.log`, `work/m30/t4r-6-suite-pass-debian13.log` |

##### Closure Evidence

None.

#### G1 - open62541-env changes committed

Origin: 441e2e0 / G1
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The simulator `opcua-server-sim` builds open62541 through a checkout of `open62541-env` and needs the `CMAKE_EXTRA_OPTIONS` support in its `configure/CONFIG_SITE` and `configure/RULES_INSTALL` and the patch `patch/1.5.10.p0.patch`. According to the register of the simulator they were uncommitted in `open62541-env` on 2026-11-13. The owner commits them there. This gates M4.

##### Completion Criteria

- `git status --short` of the `open62541-env` repository shows those paths committed, and the commit that carries them is on its upstream.

##### Responsible Party And Affected Work

The owner of the `open62541-env` repository. M4 depends on it.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| 2026-11-22T06:22Z | Pass: on the branch `1.5` of `open62541-env`, `origin/1.5` is at `fc8cc33897c84dca699a3e1a7d998ce3e2748dfe`; `16e8fa2` (2026-11-16, `CMAKE_EXTRA_OPTIONS` appended to the cmake lines of the conf targets, in `configure/CONFIG_SITE` and `configure/RULES_INSTALL`) and `05ecc5e` (2026-11-16, `patch/1.5.10.p0.patch`) are in it, and the register of the simulator records its G1 as Complete | `git ls-remote --heads https://github.com/jeonghanlee/open62541-env refs/heads/1.5`; `gh api repos/jeonghanlee/open62541-env/compare/master...1.5`; the contents of `patch/` and `configure/` on `1.5` |

##### Closure Evidence

The changes are commits `16e8fa2` and `05ecc5e` on the branch `1.5` of `open62541-env`, which the branch carries on its upstream (observed 2026-11-22T06:22Z); the simulator builds open62541 1.5.10 from that branch (D13 of its register).

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

#### G3 - recceiver test image available

Origin: 441e2e0 / G3
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

The check of M22 pulls a ready-made image instead of building one: the runner image of the EPICS-env distribution 1.5.0 for Debian 13 with the recsync server at `9834b94` and the recceiver as a second `s6` service. The session of the `Dockerfiles` repository built it, after a trial on both runner images, and published it on Docker Hub on 2026-11-26. The owner decided that there is one image, for Debian 13, and no Rocky Linux image.

##### Completion Criteria

- The image is published at a place the owner has decided, and its name, tag and digest are recorded.
- The image carries a label and a file that name the source commit `9834b94`, and its Python packages are pinned by version.

##### Responsible Party And Affected Work

The session of the `Dockerfiles` repository, the single writer of that repository, builds and publishes the image; the owner decides its place. M22 depends on it.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| 2026-11-26 | Pending | The session of the `Dockerfiles` repository reported the local trial on both runner images (nothing pushed, nothing changed in its repository); no image was published yet |
| 2026-11-26T21:51Z | Passed | `docker buildx imagetools inspect` of `jeonghanlee/debian13-epics-recceiver-test:1.5.0.1` and of `:latest` shows the same digest `sha256:36c50ef0f7b91c7d28dcc0f1a342c9200587580860fd69ee76bbe9818856a173`, and the same command for `jeonghanlee/rocky8-epics-recceiver-test:1.5.0.1` reports it as not found; `git -C <Dockerfiles checkout> log -1` shows `ad57cef` and its directory `debian13-epics-recceiver-test/` sets `RECSYNC_REF=9834b94`, the label `epics.recsync-ref`, the full commit in `/etc/epics-bake.manifest`, and the packages of `requirements.txt` pinned by version (the pyCFClient archive also by `sha256`); `python3-venv` and the base tag are not pinned |

##### Closure Evidence

Both completion criteria are met on 2026-11-26: the image is published on Docker Hub as `jeonghanlee/debian13-epics-recceiver-test:1.5.0.1` at the digest above, and the source directory names `9834b94` in its label and manifest and pins the packages by version. That the two test machines can pull and run it is checked in M22 (T5).

#### G4 - uldaq-env tag with the timeout patch

Origin: 441e2e0 / G4
Identity History: none
GitHub Issue: none
Status: Complete

##### Summary

M10 takes the timeout patch of ULDAQ from `uldaq-env`, and EPICS-env pins a tag of that repository, never a commit. On 2026-11-26 `master` of `uldaq-env` is `5bf26d9` with `patch/1.2.2-net-timeout.p0.patch` (issues #3 and #5 completed, #4 closed as not planned) and its last tag is `1.2.2-1` (commit `29994f2`), whose build record names the old patch `1.2.2-tcp-receive.p0.patch`. The session of `uldaq-env` creates a tag only with the delegation of its owner and on that day no tag was decided (the tag `1.2.2-2` exists since 2026-11-27, see Verification Results); by the rule `<upstream version>-<N>` the next one would be `1.2.2-2`. The owner of `uldaq-env` may first check an E-TC command against the command timeout, which can lead to one more change and tag; nothing else is open there, and no change of the library file names, the install layout or the build-record format (`format=1`) is planned.

##### Completion Criteria

- `git ls-remote --tags https://github.com/jeonghanlee/uldaq-env` shows a tag of the form `<upstream version>-<N>` on a commit that holds `patch/1.2.2-net-timeout.p0.patch`, and the owner of `uldaq-env` has recorded the commit.

The check that the build record of a build from that tag names the tag and the patch is M10 / T1 (D47).

##### Responsible Party And Affected Work

The owner of the `uldaq-env` repository decides the tag and its commit; its session creates it only with the tag delegation. The owner of EPICS-env asks for it. M10 depended on it, and the identity of the library of the real-device session (M11 / T8, M29 / T1) names its commit.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| 2026-11-26 | Pending | `git tag` of the repository shows `1.2.1`, `1.2.2` and `1.2.2-1` only, and `master` is `5bf26d9`; the session of `uldaq-env` answered that no tag is decided and nothing else is open |
| 2026-11-27T08:02Z | Complete | `git ls-remote --tags https://github.com/jeonghanlee/uldaq-env` shows `refs/tags/1.2.2-2` as the annotated tag object `f5edeca5249a3def1af48385223896254ac89c15` peeled to `5bf26d9a87095b2beb8ac6d981fe9db24dcf2a13`, which is the tip of `master`; the tree of that tag holds `patch/1.2.2-net-timeout.p0.patch`; the session of `uldaq-env` reported the commit and the tag in its push notice |

##### Closure Evidence

Complete on 2026-11-27: the tag `1.2.2-2` of `uldaq-env` names the commit `5bf26d9a87095b2beb8ac6d981fe9db24dcf2a13` that holds the timeout patch, observed with the command of the Observed At 2026-11-27T08:02Z row. Not covered: the E-TC command is not run on a device, so a later tag may follow, and the TC32 behavior is verified on the simulator of `uldaq-env` only, both reported by the owner of `uldaq-env`; the pin of EPICS-env was still `1.2.2-1` on that day and moved to `1.2.2-2` in M10.

#### G5 - Real TC32 session and its permission

Origin: 441e2e0 / G5
Identity History: none
GitHub Issue: none
Status: Open

##### Summary

The hardware check of M11 (T8) and the real-device check of the timeout patch (M29) need a real network TC32 without EXP-32, and their loss items cut the power of the unit for minutes, pull its network cable and stop the IOC that normally runs on it. The only known unit is on the lab network and serves the IOC of the `tcmd` repository. The permission and the time to use it again belong to the owner of `tcmd`, and the session `LAB-tcmd` relays a request to that owner. The session `LAB-measComp` reported on 2026-11-26 a read-only check on that unit with `measComp-1612c38` and the ULDAQ library built from `uldaq-env` `5bf26d9`, which it installed into the shared 1.5.0 tree of the lab: ModelNumber 306, firmware 1.08, 32 of 32 channels valid with NO_ALARM, no `Calling TIn channel` line and no error for the channels 32 to 63. The loss and recovery items are not done; the session planned them with the owner of `tcmd` for the week after 2026-11-26.

##### Completion Criteria

One session on the unit with the pair, whose results are recorded in M11 / T8 and M29 / T1 with the local times and without host names or addresses, and with the identity of the library (the build record under `vendor/cfg/uldaq`: tag, source commit, patch) and of `measComp-1612c38`:

- the online start: ModelNumber 306, the 32 temperature records and their severity, no `Calling TIn channel` error for N from 32 to 63, the diagnostics records sane;
- the offline start: the IOC stays up, the records are INVALID, the connection failures are logged with an `err=` code, and the recovery follows at the first attempt after the path returns;
- three power cycles of 2 minutes and one network loss of 5 minutes: all 32 records INVALID with the last value held, no IOC restart, the time to the first valid update;
- the retry pattern after a loss and the time that a failed command takes, compared with the earlier result of the `tcmd` runs (three attempts about 5.1 s apart, then 30.2 to 32.3 s apart, with the older library); a difference is reported, not a failure;
- the normal end of the IOC with no crash, and the normal IOC of the unit started again.

The working copy of the checklist is `work/checklist-t8-tc32.md` (not tracked); it was sent to `LAB-tcmd` on 2026-11-26. Its retry-pattern step compares with the older library and must be revised for the patched library before the session.

##### Responsible Party And Affected Work

The owner of `tcmd` gives the permission and the time; `LAB-tcmd` relays. The owner of EPICS-env asks the owner of `tcmd` and decides when. `LAB-measComp` built and installed the pair in the shared lab tree and planned the loss items with the owner of `tcmd`. The session of EPICS-env revises the checklist and records the results in M11 / T8 and M29 / T1. M11 (T8) and M29 depend on it.

##### Verification Results

| Observed At | Result | Evidence |
| --- | --- | --- |
| 2026-11-26 | Pending | Reported by `LAB-measComp`, not observed in this repository: the read-only check of the summary (one IOC, 150 s, local Channel Access, no power cycle, no cable pull) covers only the items "no error for the channels 32 to 63" and "valid samples"; the other items are open |

##### Closure Evidence

None.

## Backlog

No item is unassigned: M22, M23 and M27 moved to the Milestone on 2026-11-23 (D39).

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |

### Backlog Details

## History

| Reset Date | Prior State Commit |
| --- | --- |
| 2026-11-11 | 441e2e08467b3af7668a605c1447f5d07d23bce9 |
