# Work Register

Release line: master
Milestone index: 441e2e0
Canonical path: `docs/milestone-441e2e0.md`
Canonical branch or ref: master
Git upstream: origin/master
Remote tracker: jeonghanlee/EPICS-env; the open issues are in the GitHub milestone Backlog

Next session entry point: M1, M2, M3 and M19 are complete and their issues are closed; the next row in table order is M4 (Milo as the OPC UA example default), which is Ready.

This document carries unfinished work after release 1.5.0. Completed results remain in the prior state named in History. Work continues on master with no release branch (D2), and the rows are taken in table order.

## Milestone

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| M1 | Port Python utilities to Perl | Milestone | Complete | No | D2, D5, D6, D7, D12 | The scoped tools, the two embedded helpers and their callers run without Python and match the existing results; [detail](#m1---port-python-utilities-to-perl) |
| M2 | Replace makeRPath.py in EPICS Base with Perl | Carry-forward | Complete | No | D2, D5, D8, D9, D10 | Base builds without Python through the Perl makeRPath and the rpath values match; [detail](#m2---replace-makerpathpy-in-epics-base-with-perl) |
| M3 | Minimal-example record counting | Carry-forward | Complete | No | D2, D13 | [Completion criteria](#m3---minimal-example-record-counting) |
| M4 | Milo as the OPC UA example default | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m4---milo-as-the-opc-ua-example-default) |
| M5 | Global IOC startup for common services | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m5---global-ioc-startup-for-common-services) |
| M6 | Lua database loading without macros | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m6---lua-database-loading-without-macros) |
| M7 | Move EPICS Base to R7.0.11 | Milestone | Not started | Yes | D2, D3 | Each Base patch is settled for the new pin and Base builds from it; [detail](#m7---move-epics-base-to-r7011) |
| M8 | Re-examine pvxs with the Base move | Milestone | Not started | No | D3, M7 | The pvxs pin and patches are settled and pvxs builds on the new Base; [detail](#m8---re-examine-pvxs-with-the-base-move) |
| M9 | Update modbus to R3-5 | Milestone | Not started | No | D2, D3, M7, M8 | The module cycle passes on both test machines; [detail](#m9---update-modbus-to-r3-5) |
| M10 | Carry the uldaq-env timeout and alarm patches | Milestone | Not started | No | D2, D3, M7, M8 | Both patches are built and loaded through the vendor preparation; [detail](#m10---carry-the-uldaq-env-timeout-and-alarm-patches) |
| M11 | Move measComp to the jeonghanlee fork | Milestone | Not started | No | D2, D3, M7, M8 | The measComp cycle and the TC32 reconnection checks pass; [detail](#m11---move-meascomp-to-the-jeonghanlee-fork) |
| M12 | Shared-library version identification | Carry-forward | Not started | Yes | D2 | [Completion criteria](#m12---shared-library-version-identification) |
| M13 | Migrate recsync to reccaster | Carry-forward | Not started | Yes | D1, D2 | [Completion criteria](#m13---migrate-recsync-to-reccaster) |
| M14 | Load pyDevSup through the IOC loader | Carry-forward | Deferred | No | D4 | [Completion criteria](#m14---load-pydevsup-through-the-ioc-loader) |
| M15 | Patch revert on macOS | Carry-forward | Deferred | No | D4 | [Completion criteria](#m15---patch-revert-on-macos) |
| M16 | Original OPC UA demo startup data | Carry-forward | Deferred | No | D4 | [Completion criteria](#m16---original-opc-ua-demo-startup-data) |
| M17 | Libera cross-build and generated profile | Carry-forward | Deferred | No | D4 | [Completion criteria](#m17---libera-cross-build-and-generated-profile) |
| M18 | Insert `on error break` in `iocsh.bash` when the startup file has none | Carry-forward | Open | No | D2 | [Completion criteria](#m18---insert-on-error-break-in-iocshbash-when-the-startup-file-has-none) |
| M19 | Base unit test of makeRPath.pl | Milestone | Complete | No | D2, D8, D11, M2 | `test/tools/makeRPath.plt` runs under `make runtests` of the patched Base on Perl 5.10.1, 5.26.3 and 5.40.1 and each case is shown able to fail; [detail](#m19---base-unit-test-of-makerpathpl) |

Tally: 19 items, 4 Complete (M1, M2, M3 and M19), 10 Not started (M4 through M13), 1 Open (M18) and 4 Deferred (M14 through M17). Ready: M4 through M7, M12 and M13. No gate is open.

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

#### M4 - Milo as the OPC UA example default

Origin: 441e2e0 / M3
Identity History: M3 -> M4
GitHub Issue: #99 (https://github.com/jeonghanlee/EPICS-env/issues/99)
Status: Not started

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 99 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

Example and documentation work, not a module-set change

##### Scope

Make Eclipse Milo the default server of the OPC UA loader example.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The OPC UA loader example uses Eclipse Milo by default, with matching instructions and real example verification.

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

#### M5 - Global IOC startup for common services

Origin: 441e2e0 / M4
Identity History: M4 -> M5
GitHub Issue: #79 (https://github.com/jeonghanlee/EPICS-env/issues/79)
Status: Not started

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 79 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

The fragment set ships without one; the common services are verified loading together by the integrated suite

##### Scope

Ship a global iocsh startup file for the common services.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- A global startup file loads the intended common services and passes their integrated verification.

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

#### M6 - Lua database loading without macros

Origin: 441e2e0 / M5
Identity History: M5 -> M6
GitHub Issue: #137 (https://github.com/jeonghanlee/EPICS-env/issues/137)
Status: Not started

##### Summary

The defect sits in lua's database hook at the pin that 1.4.0 shipped and at `01aa7a1` alike; reporting it upstream or carrying a patch is decided when the work is assigned

##### Scope

Stop `dbLoadRecords` from crashing an IOC that loads lua when called without its macros argument.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The real IOC survives dbLoadRecords without macros while lua is loaded; the selected upstream fix or carry has verification evidence.

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
Status: Not started

##### Summary

The modules set no versioned `SONAME` (47 of the 54 distinct values in the Debian 13 tree are bare); the work decides the RUNPATH naming rule, the `SONAME` and ABI name rule, and how `check.deps` and `check.env` report a link

##### Scope

Decide how the installed shared libraries identify their version.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The agreed RUNPATH, SONAME/ABI, and dependency-reporting rules are documented and verified against real installed libraries.

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

#### M13 - Migrate recsync to reccaster

Origin: 441e2e0 / M13
Identity History: none
GitHub Issue: #101 (https://github.com/jeonghanlee/EPICS-env/issues/101)
Status: Not started

GitHub state observed: OPEN on 2026-11-05 at 03:05 UTC. Recheck with `gh issue view 101 -R jeonghanlee/EPICS-env --json state,url`.

##### Summary

Module source work outside a version bump (D1)

##### Scope

Migrate IOC record publishing from the recsync client to the reccaster repository.

Out of scope: implementation beyond this retained item and changes to published release tags.

##### Completion Criteria

- The selected reccaster source replaces the recsync client with verified build, installation, and IOC publishing.

These criteria describe the retained outcome; detailed acceptance methods require a plan before activation.

##### Dependencies And Decisions

D1 and D2 apply.

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

## Backlog

No work is unassigned.

### Work

| ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- |

### Backlog Details

None.

## History

| Reset Date | Prior State Commit |
| --- | --- |
| 2026-11-11 | 441e2e08467b3af7668a605c1447f5d07d23bce9 |
