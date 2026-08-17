# Work Register

Canonical milestone and carry-forward status for this repository. Every agent
and person reads this file first. Source documents named below remain as
design records and operational evidence; this register holds status.

Canonical path: `docs/milestone-1.3.0.md`

Mode: remote-authoritative for tracker-linked work. Each issue's verification
checkbox list is the status source of truth for its M-subs and this register
mirrors it. Register-local rows own their status here. Every tracker-linked
milestone closure ends with a reconcile pass against the tracker.

Cycle: 1.3.0, opened 2026-07-17 on branch `release-1.3.0`. The original cycle
verification record is `docs/testplan_1.3.0.md` (verification layers,
per-milestone subs, and dependency re-run matrix). The current M7 release plan
below governs release readiness. The released register and plan are preserved
by the release tag.

Register format — settled, not open. This cycle finishes in the format it
opened with: the five-column work table
(`Topic | Work unit | Type | Status | Evidence or next action`) and a
`## Carry-forward` section in place of a `## Backlog` one. The eight-column
schema that adds `ID`, `Ready`, and `Deps`, and the `## Milestone` /
`## Backlog` pair, begin at `docs/milestone-1.3.1.md` and apply from the 1.3.1
line onward. Converting a cycle already standing at its release gate would gain
nothing and put a complete record at risk, so the difference between the two
registers on this branch is intended. Do not re-open it as a defect. Owner
decision, 2026-08-08.

Next session entry point: shortest-first work order (owner decision
2026-07-25): M14.T2 DONE 2026-07-25 (site feed retired at alsu-site-modules
`0617c89`, llrf FEED -> feed-core at `38413bb`) -> M6 DONE 2026-07-25
(nine-module set + ADCore at 818ef60/7fe14ee, motor reverted after the
seven-platform failure; full record in `docs/module-bumps-1.3.0.md`) ->
M22 (#52, base-fix carry) DONE 2026-07-25 (fifteen patches at
54b8a44/c7aac56, T1 verified) -> M24 (#48, DONE 2026-07-25 — root cause corrected, recovery hints shipped) and M25
(#49, DONE 2026-07-25 — e824765; AC1/AC2/AC3 measured and healthy-tree
regression verified byte-identical on rocky8+debian13, #49 closed), both
moved from Backlog to 1.3.0 by the owner 2026-07-25 -> M26 (#53) pvxs fix
carry (selection COMPLETE 2026-07-25 by owner, run ahead of the milestone)
-> its implementation, twelve p0 patches on the M22 carry discipline, DONE
2026-07-26 (006c95e/c3a42c3, #53 closed) -> M27 (#54) docs modernization +
mdBook site DONE 2026-07-26 (ec9ea28..50c3388, site live, Pages on the
workflow build type) -> M31 (a vendor name spelled three ways and two
undocumented commands in `tools/prep-vendors.bash`) DONE 2026-08-08 at
`7aeac46`, T1 verified -> M30 (two documented procedures that mislead) DONE
2026-08-08, T1 and T2 verified -> M32 upstream survey integrity -> M33 Base
carry refresh against the current `7.0` branch, M34 asyn R4-46 adoption, and
M23 CI vendor relocation (returned from 1.3.1 on 2026-08-17) in any order, all
Complete -> the M7 release gate. The 1.3.0 target remains the
end of August 2026, but it may move later when new upstream changes require
another review, patch refresh, or combined-tree verification.
The review record behind M30 and M31, including what was checked and found
correct and what was never opened, is carried in `docs/milestone-1.3.1.md` under
M29 Inventory Evidence. M29 (#56) moved to the 1.3.1 canonical register by owner
decision on 2026-07-28; M23 (#51) returned to 1.3.0 on 2026-08-17 (D5 in
`docs/milestone-1.3.1.md`), its GitHub milestone reassignment still pending. Backlog
#25 (EPICS::Path) stays parked for after 1.3.0 stabilizes. M19 (#42) turned out already landed (92594a7, 2026-07-18) —
its row was stale and is corrected, so the order starts at M14.T2. M21 (#47) LANDED 2026-07-24: release 1.2.2 shipped first, then
master (9466fd7) merged into this branch at 068f511 per the
3-reviewer-accepted #47 plan; T1 evidence in the M21 rows below. Do not
start carry-forward items unless the owner explicitly reorders them.

## Milestones — 1.3.0

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| M1 Ubuntu 26.04 C23 bridge | Per-module OS-conditional C17 flags (#29) | Milestone | Complete | Eleven-module C17 bridge in `configure/RULES_MODS_CONFIG` (`b03a830`, `7cc8c1a`); final survey ledger in #29 (11 bridged / 16 clean; set is 28 modules, 27 excluding opcua) |
| M1.T1 | ubuntu26 build: base + 27 modules (opcua excluded), zero dead links, softIoc; flag list minimal | Verification | Complete | 2026-07-17 from-scratch VM build of `release-1.3.0`: 27 modules installed, flag on exactly 11 `CONFIG_SITE.local`, dead links 0, RELEASE deps resolve to one tree, softIoc CA round-trip |
| M1.T2 | debian13 full build confirms the flags are a no-op elsewhere | Verification | Complete | 2026-07-17 debian13 VM full build incl. opcua: zero flagged `CONFIG_SITE.local`, clean install, dead links 0, softIoc CA round-trip; `print-MODS_C17_BRIDGE` empty on host |
| M2 opcua on ubuntu26 | Link failure diagnosis and fix (#30) | Milestone | Complete | GCC 15 mangles the two unnamed-namespace `extern "C"` pvar exports; `patch/opcua-anon-ns-export.p0.patch` via `patch.opcua.export.apply` (`b2f957e`); diagnosis in #30 |
| M2.T1 | Diagnosis recorded, then opcua builds, links, installs on ubuntu26 | Verification | Complete | 2026-07-17 ubuntu26 VM: fresh opcua 0.11.2 + `make patch` + `build.opcua` exit 0, 0 mangled / 33 plain exports, no TEXTREL, 28-module tree, dead links 0; debian13 rebuild behavior-neutral |
| M3 resetEpicsEnv sourcing | `pushdd` terminates the sourcing shell (#27) | Milestone | Complete | Module-symlink loop commented out to match `setEpicsEnv.bash` (`ec357d3`); the only live `pushdd` call site is gone; restore-both decision deferred in #27 |
| M3.T1 | Sourcing shell survives with `EPICS_MODULES` absent; symlink loop verified | Verification | Complete | 2026-07-17: issue reproduction survives rc=0; ubuntu26 real-tree set/reset round-trip restores `PATH` and `LD_LIBRARY_PATH` exactly; shellcheck clean on both scripts |
| M3.T2 | `make check.env` stays green on a normal tree | Verification | Complete | 2026-07-17 ubuntu26 tree: `make check.env` findings 0 |
| M4 CI symlinks gap | ubuntu22/ubuntu24 never run `make symlinks` (#26) | Milestone | Complete | `make patch` + `make symlinks` added to both workflows (`b4dae49`), matching rocky10's explicit order; rehearsed on a fresh ubuntu 24.04 VM first |
| M4.T1 | Both workflows show `make symlinks` executing in a run | Verification | Complete | 2026-07-18 runs 29635291710/29635291757: success, tree shows `pvxs -> ./pvxs-1.5.1`, check.env findings 0 |
| M5 Module deps audit robustness | `check.module-deps` fails under `make -C` on Make 4.2.1 (#28) | Milestone | Complete | `make_value` insulation (`MAKEFLAGS='' make -s --no-print-directory`, `648607a`); three-reviewer pass, spin-offs #35/#36/#38; ansible `cd` workaround retires once consumers run a release with the fix |
| M5.T1 | Reproduce under `make -C` on Rocky 8 Make 4.2.1, then the fix passes the same invocation | Verification | Complete | 2026-07-18: reproduced on a fresh clone; with the fix both forms exit 0, identical output on 4.2.1 and 4.4.1; full `make -C` `github.check` completes on Rocky 8.10 |
| M5.T2 | `check.module-deps` green in the four workflows that run `github.check` | Verification | Complete | 2026-07-18 runs 29639996874-29639996941: seven platforms success; strict audit executed in the four `github.check` runs |
| M6 Module version bumps | Owner-selected bump set (#21; the five named are the floor) | Milestone | Complete | Set DECIDED 2026-07-25 after a three-reviewer delta review (fable/opus/sonnet, full record in `docs/module-bumps-1.3.0.md`): IN = floor five + calc, sscan, std, pscdrv (motor was taken and REVERTED by owner option 3 after all seven CI platforms failed — motor 05b25c1 removed NUM_MOTOR_DRIVER_PARAMS and pmac still references it; its RVEL/shutdown fixes wait for a coordinated motor+pmac move); HOLD = recsync (reccaster client moved upstream — pin kept), caPutLog, lua (REMOVE from the set in 1.4.0, owner), busy, scaler, measComp, pcas; support rides the wave with ADCore ee039d2 (`WITH_PVXS=YES`). Patch audit: no active patch touches a bumped module (pvxs-1.3.1 patch is commented-out history); C17 bridge overlaps four bumped modules and stays (calc bridge removal is a 1.4.0 revisit). Post-release owner tests: motor+pmac bench/sim, pscdrv. COMPLETE 2026-07-25: T1/T2/T3 all verified at 818ef60; support 7fe14ee (ADCore ee039d2, NDPluginPvxs linked against pvxs 1.5.2 on both OSes); issue #21 closed |
| M6.T1 | Bumped set builds and installs on debian13 and rocky8.10 VMs; PVXS 1.5.2 `cfg/CONFIG` with `INSTALL_LOCATION` verified | Verification | Complete | 2026-07-25 at 818ef60 on BOTH fresh VMs: nine new pins installed (58-entry layer 1), motor stays 285f44d, pvxs-1.5.2/cfg carries CONFIG_PVXS_MODULE/VERSION, dead links 0, calc-record + CA smoke pass; support layer 7fe14ee: ADCore-ee039d2 with NDPluginPvxs.dbd, libNDPlugin NEEDS libpvxs.so.1.5 with $ORIGIN runpath; strict check_deps exit 0 (152 bin/78 so) on both trees |
| M6.T2 | Seven-platform workflows green on the bumped set | Verification | Complete | 818ef60: 7/7 platforms + linter green (the first attempt at f3d089b failed all seven at build.pmac — the motor revert evidence) |
| M6.T3 | Re-run M1.T1 and M3.T1 per the dependency re-run matrix | Verification | Complete | Covered by the final-tree strict exit 0 on both OSes (zero DT_RPATH tree-wide incl vendors, ABSPATH 0, LOSTORG 0 across 78 so) |
| M24 stale MODULESGEN.mk | Stale generated `MODULESGEN.mk` aborts every make invocation (#48) | Milestone | Complete | Root cause CORRECTED by measurement (five review rounds + owner recollection): the reported stale-file injection vector was real only on release-1.2.2's old `.VARIABLES` harvest — the #38/#43 guard family on this line already closed it structurally (injection measured inert). Remaining exposure is RELEASE-side module-set change (add/rename, the feed->feed-core shape) ahead of its `_CONF_TYPE` declaration, where a loud abort is correct. Remedy shipped: recovery hint on all four parse-time error sites (validate_conf_type + validate_auto_conf_module) naming plain `rm configure/MODULESGEN.mk` — NOT a make target, since a parse-time error kills every make invocation including distclean.modulesgen (measured). The recipe-time move was evaluated and rejected: two gates would need moving and the abort would land after `patch`, creating a non-rerunnable stuck state |
| M24.T1 | Normal tree unaffected; every gate arm shows the recovery hint; the hint-directed recovery works | Verification | Complete | 2026-07-25, host-side make-level suite 5/5: normal tree rc 0; gate A both arms (missing declaration via a RELEASE-side ghost module, invalid value) show the hint; gate B (rename-shaped install-name pairing break) shows it; `rm configure/MODULESGEN.mk` then retry returns rc 0. The suite itself caught the first hint wording (`make distclean.modulesgen` — unreachable at parse time) and the corrected plain-rm hint passed |
| M25 check_deps robustness | Empty-bin spurious entry, dual RPATH/RUNPATH multiline, single-flag forwarding (#49) | Milestone | Complete | Landed `e824765` 2026-07-25: D1 `--no-run-if-empty` (both bin sites), D2 `paste -sd:` dual-tag collapse (both loops), D3 full-vector forwarding in `prep-vendors.bash` (`"${@:2}"` dispatcher, `"$@"` function), D4 doc-comment sync. Plan and implementation each 3-reviewer reviewed (0 blocking); AC1/AC2/AC3 measured on the edited scripts; healthy-tree regression byte-identical before/after with strict exit unchanged on rocky8 AND debian13, on both existing 1.2.2 trees and fresh release-1.3.0 builds; #49 closed |
| M25.T1 | Empty `bin/linux-x86_64` reports 0 bin files with no `(standard input)` error; a dual RPATH+RUNPATH object parses without a folded-newline token; `prep-vendors.bash check-deps -v --report-only <path>` forwards both flags | Verification | Complete | 2026-07-25: AC1 empty-bin `ALL 0`, no `(standard input)`; AC2 genuine dual-tag ELF `ABSPATH 1/1`; AC3 `-v`/`--report-only`/path all forwarded (report-only exit 0 vs strict exit 2). Healthy-tree regression `REPORT_DIFF=IDENTICAL` and strict exit before==after==0 on rocky8+debian13 VMs, on 1.2.2 and fresh release-1.3.0 trees (BIN 144 / SO 68, all counts zero) |
| M30 Misleading documented procedures | Two documented procedures that a reader can follow into a silently wrong result (#57) | Milestone | Complete | Found by the 2026-08-07 document review; owner directed that the code stays and the documents move to match it. (a) `README.md` Base Commands presents `make patch.base` as applying the needed patches, but `configure/RULES_BASE:8` binds it to `patch.base.apply` alone and never reaches `patch.base.pr.apply` (`configure/RULES_PATCH:21`), the leg that applies the fifteen M22 carry patches; the top-level `patch:` (`configure/RULES_SRC:14`) calls both. Measured: `make -n patch.base` emits no PR-carry line, `make -n patch` does. (b) Two guides point at `MODS_ZERO_VARS`, which `configure/RULES_MODS_CONFIG:48` derives from `$(MOD_CONF_AUTO_TARGETS) $(MODS_ZERO_CUSTOM_VARS)`; the hand-maintained list is `MODS_ZERO_CUSTOM_VARS` at line 47. They fail differently and both were measured on a scratch clone. `remove-a-module.md:40` says without condition to delete a module's `conf.*` entry from `MODS_ZERO_VARS`; line 48 holds no such string, so the edit changes nothing — the target count stays at 16 and the module's configure target is still there, while the reader believes it was removed. `new-module-example.md:40-43` is a fork: base-only dependencies go to `MODS_ZERO_VARS`, multi-module ones to `MODS_ONE_VARS`. Its pmac example takes the second branch and edits the literal list at line 57, so the example itself is correct; a reader taking the first branch and expanding `MODS_ZERO_VARS` into a literal drops it from 16 targets to 8 and removes the configure target of all nine auto modules. Both statements were correct when written and the code moved: `b77d340` (2026-05-24) made `MODS_ZERO_VARS` derived and updated the concept document while leaving the operator guides, and `c7aac56` (2026-07-25) added the carry leg without touching README. COMPLETE 2026-08-08: the guides now name `MODS_ZERO_CUSTOM_VARS`, README names the invocation that applies the carry set, and `module-management.md` Maintenance Rules gains the cross-check that was missing in May — which guides describe these lists |
| M30.T1 | `README.md` states what `make patch.base` really does, and points to the target that applies the carry set | Verification | Complete | 2026-08-08: carry patch files reachable from each recipe, counted with `make -n` — `patch.base` 0, `patch.base.pr.apply` 15, `patch` 15. The README statement matches |
| M30.T2 | Both guides name `MODS_ZERO_CUSTOM_VARS` as the edit point for a custom module. On a scratch clone: following the add path leaves all nine auto configure targets intact, and following the remove path actually drops the retired module's target from the derived list | Verification | Complete | 2026-08-08 on a scratch clone carrying the corrected guides: add path took `MODS_ZERO_VARS` from 16 to 17 targets with all nine auto targets intact and `conf.newmod` present; remove path dropped `conf.linStat` from the derived list with the nine auto targets still intact. Before the correction the add path left 8 targets and the remove path changed nothing |
| M31 open62541 spelling and undocumented commands | `tools/prep-vendors.bash` spells its vendor three ways and hides two working commands (#58) | Milestone | Complete | Found beside the 2026-08-07 document review. The help text prints `prep-open62451` and "Prepare open62451" on line 316 and `open65451` on line 317, while the dispatcher accepts only `prep-open62541`, so either spelling typed from the help returns `Error: Unknown command`. The variable `VENDOR_OPEN62451_SRC` at lines 57, 179, and 214 transposes the same two digits; its value resolves to the correct `open62541-env` path and every use agrees, so nothing breaks, but line 214 pairs the correctly named function `prep_open62541` with the misspelled variable. The uldaq sibling at lines 56, 178, and 213 shows the intended shape. The same help block is short in the other direction: `epics-env` and `OS` are accepted but undocumented, and `epics-env` is the largest command in the file — it rewrites `configure/RELEASE.local`, then runs `make distclean` and the full rebuild chain — as well as the third step of `all` and the last step of the recommended flow in `tools/README.md`. The `OS` command's output strings are left as they are; rewording them is outside this milestone. COMPLETE 2026-08-08 at `7aeac46`: all six spellings unified to open62541, and `epics-env` and `OS` added to the command list with the `epics-env` line naming its `distclean` and `RELEASE.local` rewrite. T1 verified |
| M31.T1 | The `prep-vendors.bash` help text and its dispatcher list the same commands in both directions; no `62451` or `65451` spelling remains; every use of the vendor source variable resolves to the one defined name; `bash -n` and `shellcheck -S warning` stay clean | Verification | Complete | 2026-08-08T21:38:48-0700 against the committed tree at `7aeac46`, working tree clean: help-to-dispatcher gap 0 and dispatcher-to-help gap 0 across 11 listed commands; stale spellings 0; the vendor source variable resolves through one defined name at all four use sites with no undefined-name use; `bash -n` clean; `shellcheck -S warning` clean |
| M32 Upstream survey integrity | Make `tools/update-release.bash check` distinguish a complete survey from remote lookup failure (register-local, no tracker issue) | Milestone | Not started | On 2026-08-11 the shipped command printed `All modules are up to date.` after every `git ls-remote` lookup failed. A lookup failure currently leaves `updates_found=0` and produces a false green result. Change the shipped path to count attempted, successful, and failed lookups; any failure must report an incomplete survey and return nonzero, never the up-to-date message. This is the first 1.3.0 blocker because M33, M34, and each M7 candidate depend on an honest survey |
| M32.T1 | A successful survey through the shipped command completes every configured lookup and reports available updates, including asyn R4-46 | Verification | Not started | Run the real command against the official remotes after the implementation; record attempted, successful, failed, and update results |
| M32.T2 | A controlled failure at the outermost Git transport boundary returns nonzero, identifies the failed lookup, and does not print the up-to-date result | Verification | Not started | Exercise the shipped command and its real parsing and aggregation path; substitute only the outermost transport boundary |
| M33 Base carry refresh | Re-evaluate and regenerate the R7.0.10 carry set against the current upstream `7.0` branch (register-local, no tracker issue) | Milestone | Not started | Keep Base pinned at the latest full release, R7.0.10. Re-run the complete `R7.0.10...7.0` enumeration under `docs/upstream-fix-carry-procedure.md`, reconcile the existing carry with every newer security, correctness, and compatibility change, record the owner selection, and regenerate every selected patch whose upstream context moved. New upstream changes remain in scope until release; there is no fixed cutoff |
| M33.T1 | The refreshed decision record covers every upstream change visible at survey time and every selected patch applies and reverts cleanly on pristine R7.0.10 | Verification | Not started | Record exclusions and dependencies, regenerate from upstream commits, then run the real `make patch` and `make patch.revert` path with a clean source tree and no `.orig` or `.rej` files |
| M33.T2 | Patched Base builds and passes its relevant tests, security scenarios, and downstream environment checks on the supported release systems | Verification | Not started | Run the affected Base tests and the final combined-tree OS coverage; prior M22 evidence does not cover the refreshed patch set |
| M34 asyn R4-46 adoption | Move the asyn pin from R4-45 to the released R4-46 tag and reconcile local compatibility work (register-local, no tracker issue) | Milestone | Not started | Review the R4-45 to R4-46 change set, update the release pin and version, and determine from a real Ubuntu 26 build whether asyn can leave `MODS_C17_SRC_PATHS`. Check every module and site consumer that links to or configures asyn; do not treat a successful source build alone as completion |
| M34.T1 | asyn R4-46 builds, installs, and passes its relevant tests on the release OS set; the C23 bridge decision is supported by the real Ubuntu 26 path | Verification | Not started | Exercise the shipped build path with and without only the bridge entry under decision, then keep the minimal working configuration |
| M34.T2 | Downstream modules, support, and site layers build and pass the relevant runtime and dependency checks against asyn R4-46 | Verification | Not started | Include the final-tree dependency audit and representative asyn port and IOC startup checks on the supported release systems |
| M23 CI vendor relocation | Install the CI vendors into the tree so `check.deps` gates strict, and give measComp a self-relative vendor `cfg` fragment so a consumer links uldaq by `$ORIGIN` (GitHub #51; register-local plan mirrored from `docs/milestone-1.3.1.md`) | Milestone | Not started | Returned from 1.3.1 by owner decision 2026-08-17 (D5 in `docs/milestone-1.3.1.md`) so the measComp/uldaq consumer-link fix ships in 1.3.0; precedes M7. Consumer-edge finding 2026-08-17: installed measComp ships `configure/{RELEASE,RELEASE.local}` only (no `cfg/`, no `CONFIG_SITE.local`), so build-time `ULDAQ_DIR` never reaches the tree and `libmeasComp.so` carries no libuldaq NEEDED; opcua ships `cfg/CONFIG_OPCUA` computing a self-relative vendor path and measComp has none, so a downstream IOC falls to `SYS_LIBS uldaq` (no `-L`, link fails) unless it sets `ULDAQ_DIR`, and then RUNPATH is absolute. Verified by `ls` of both installed trees and `readelf -d libmeasComp.so` |
| M23.T1 | All seven platform workflows report ABSPATH 0 for binaries and shared libraries and pass strict `check.deps`; a downstream IOC linking measComp resolves uldaq by a `$ORIGIN`-relative RUNPATH without defining `ULDAQ_DIR` itself | Verification | Not started | After in-tree vendor install and the measComp `cfg` fragment, run `make audit.deps` then strict `check.deps` in every workflow; build a measComp consumer IOC and inspect its RUNPATH |
| M7 Release gate | 1.3.0 release sequence (register-local, no tracker issue) | Milestone | Not started | Gates merge to `master`, tag `1.3.0`, GitHub release, milestone close. **M23 and M30-M34 must be Complete before Release Verification starts.** Version bump touches exactly two files: `configure/CONFIG_SITE:9` (`ENV_RELEASE_VERS`) and the `README.md:62` source example; `docs/README.md:11` names 1.2.2 as a shipped cycle record and must not change. Add the 1.3.0 `ChangeLog.md` entry in its own release-eve commit, as 1.2.1 (`f22d482`) and 1.2.2 (`7d432a8`) did. Release checks use the full labels in the M7 plan below. Must not close before M21 lands, else 1.3.0 reships `DT_RPATH` |
| M8 Mangled-export audit | GCC 15 unnamed-namespace export sweep (#31) | Milestone | Complete | 2026-07-18 sweep on the ubuntu26 GCC 15 build: opcua pair (#30) was the entire exposure; zero mangled registration exports remain |
| M8.T1 | Sweep evidence recorded; zero mangled registration exports after fixes | Verification | Complete | 28 modules: 512 pvar exports on both `.so` and `.a` surfaces, 0 mangled, 0 local-demoted; completeness review pass clean; record in #31 |
| M9 patch.revert order | Reverse the revert chain (#32) | Milestone | Complete | Reversed list plus mirror-order comment (`776ba85`); preventive — today's patches are disjoint |
| M9.T1 | `make patch` then `make patch.revert` leaves module sources clean | Verification | Complete | 2026-07-18 fresh rocky8 clone: round-trip exit 0, opcua pair reverts in exact reverse order, all source trees clean; base/mca legs no-op (recorded in #32) |
| M10 ubuntu22/24 patch gap | Both workflows skip `make patch` (#33) | Milestone | Complete | Landed in the same workflow edit as M4 (`b4dae49`) |
| M10.T1 | Both workflow runs apply the patch set and stay green | Verification | Complete | 2026-07-18: both run logs show the two opcua patches applying; runs green |
| M11 checkout v5 | Upgrade actions/checkout across all workflows (#34) | Milestone | Complete | All eight files on `actions/checkout@v5` (`6af213d`); super-linter untouched |
| M11.T1 | Triggered workflows green on checkout v5; no Node 20 deprecation annotation | Verification | Complete | 2026-07-18 runs 29636101848-29636101869: seven platforms success; zero deprecation annotations (ubuntu22, rocky8 spot-checked) |
| M12 Tool insulation | check_deps and prep-vendors nested make reads (#35) | Milestone | Complete | Six reads on the #28 insulation form (`d7774b4`); `_prep_env` write path protected; scripts/ sweep spun off #39 |
| M12.T1 | Insulated reads verified with the `MAKEFLAGS=w` probe on Rocky 8.10; shellcheck clean | Verification | Complete | 2026-07-18: real check_deps run clean under `MAKEFLAGS=w`; all five prep-vendors forms byte-equal to clean-env values incl. `GNUMAKEFLAGS` route; no new shellcheck findings |
| M13 Audit doc query name | Design doc says `PRINT.*`, implementation uses `print-%` (#36) | Milestone | Complete | Corrected with the format distinction (`771b3a6`) |
| M13.T1 | Document matches the implementation; format distinction stated | Verification | Complete | 2026-07-18: matches `RULES_VARS` definitions and empirical outputs; whole-docs sweep found no residual contradiction; review pass clean |
| M14 feed-core promotion | Add upstream feed-core `0472d88`; retire the site-layer `feed` copy (#37) | Milestone | Complete | Added library-only (`6590456`, M14.T1); T2 landed 2026-07-25: site feed retired (alsu-site-modules `0617c89`), llrf `FEED` -> feed-core (llrf `38413bb`, supersedes the temporary `8d2d62e`); issue #37 closes with T2 |
| M14.T1 | feed-core builds, installs, symlinks on the build VMs; audit and workflows green | Verification | Complete | 2026-07-19: library-only via `patch/feed-core-libonly.p0.patch`; debian13+rocky8 fresh-clone build, check.module-deps strict exit 0, seven-platform CI green; two 3-reviewer panels, no blocking findings |
| M14.T2 | alsu-site-modules `feed` removed; layer-3 build clean against the new tree | Verification | Complete | 2026-07-25 on the rocky8 068f511 tree (feed-core-0472d88 present): six-module site build init/build/symlinks exit 0, siteApps live, dead links 0, NO site feed beside env feed-core, check_deps strict exit 0 (74 so); llrf rebuilt clean against `$(MODULES)/feed-core`. Deferral was released by the owner the same day; precedes Release Verification 6 as required |
| M15 Module path list guard | `CONFIG_MODS` `.VARIABLES` filter picks up environment names (#38) | Milestone | Complete | Both harvests on the file-origin guard (`139017c`); absence-over-wrong-value trade recorded in #38; spin-off #40 (M17) |
| M15.T1 | Override and exported-environment invocations match the clean-path report | Verification | Complete | 2026-07-18 rocky8: three invocation forms byte-identical, duplicate block gone; clean-path lists word-identical on 4.4.1; review pass clean |
| M16 scripts insulation | Eleven unprotected nested make reads under `scripts/` (#39) | Milestone | Complete | Eleven reads on the #28 form with per-file #39 citations; the pre-pushd capture anchors to the repo top with `-C` (`ed4587f`) |
| M16.T1 | Eleven insulated captures verified with the `MAKEFLAGS=w` probe; shellcheck clean | Verification | Complete | 2026-07-18 rocky8: seven distinct variables byte-equal to clean-env values under hostile MAKEFLAGS; repo-wide sweep leaves zero unprotected captures; review pass clean |
| M17 CONFIG_VARS name guard | Unguarded `SRC_NAME_%` harvest in `configure/CONFIG_VARS` (#40) | Milestone | Complete | File-origin guard on the `SRC_NAME_%` harvest (`cd0ec3e`); persistence path into `MODULESGEN.mk` closed; spin-off #41 (M18) |
| M17.T1 | Three injection routes leave `MOD_NAMES` clean; clean path unchanged | Verification | Complete | 2026-07-18: 28 words with zero injected names on Make 4.4.1 and 4.2.1 via all three routes; `MODULESGEN.mk` regeneration identical modulo timestamp; review pass clean |
| M18 SNCSEQ direct references | Ten `$(SRC_NAME_SNCSEQ)` value expansions sit outside the #38/#40 guards (#41) | Milestone | Complete | Central `override SEQ_SRC_NAME` guard (`4f06280`); adversarial pass forced the `override` — a plain `:=` merely relocated the injection; spin-off #42 (M19) |
| M18.T1 | Injections leave the `seq` mapping intact across all consumer surfaces | Verification | Complete | 2026-07-18: A/B vs HEAD closes the aliasing; four injection routes held on Make 4.2.1 and 4.4.1; clean path byte-identical incl. rm/ln recipes; three-reviewer pass |
| M19 uninstall root guard | `remove.modules` rm -rf list carries the install root (#42) | Milestone | Complete | Landed 2026-07-18 at `92594a7` in the guard-family wave (M18 spin-off): the list is constructed from the module name list with the file-origin value guard, so `INSTALL_LOCATION_CHECK`/`_VER` cannot enter it; issue #42 was closed 2026-07-19 with the work; only this register row lagged — corrected 2026-07-25 |
| M19.T1 | List constructed from the 28 module-name tokens (not harvested from .VARIABLES); CHECK/VER excluded by construction; dry-run rm list clean; clean path unchanged | Verification | Complete | 2026-07-18: AC1/AC2 executed, parent counterfactual 30->28 executed, value guard drops to 27 on Make 4.2.1/4.4.1, empty-generation zero-iteration loop, symlink/inspection recipes byte-identical |
| M20 distclean source guard | `distclean.modules` rm -rf fed by the `SRC_PATH_%` harvest (#43) | Milestone | Complete | Source-path list constructed from module names with a file-origin value guard (`2c03088`), the #42 idiom; guard-family convergence achieved |
| M20.T1 | Local-config injection cannot reach the distclean rm list; clean path matches parent | Verification | Complete | 2026-07-18: construction blocks a file-origin non-module SRC_PATH; parent reaches rm with a paired _CONF_TYPE (arbitrary/`..` path, no SUDO); clean path 28, build-graph and audit byte-identical bar order |
| M21 forward-port DT_RUNPATH | Base flag + gate hardening to 1.3.0/master (#47) | Milestone | Complete | Merge `068f511` (master 9466fd7 = the shipped 1.2.2: base flag #44, strict-by-default gate #45 — the `--strict` design inverted before shipping, RULES_DEPS_CHECK #50) per the #47 plan, 2 review rounds + round-3 confirm, 0 blocking; conflicts resolved to the 1.3.0 side (register, .gitignore); issue #47 closed |
| M21.T1 | `readelf -d` zero DT_RPATH + DT_RUNPATH present on 1.3.0 base + modules; the strict-by-default gate proves both directions | Verification | Complete | 2026-07-24/25 at 068f511: readelf libCom/libasyn RUNPATH `$ORIGIN`, zero DT_RPATH on rocky8.10 AND rocky10.2 VM trees; strict exit 2 (66 violations) on the pre-merge 6e03843 tree, exit 0 on both post-merge trees (146 bin/68 so, ABSPATH 0, LOSTORG 0); six #35 insulation sites byte-equal under `MAKEFLAGS=w`; ubuntu22/24 run logs show patch apply + `make symlinks`; CI 8/8 green |

| M22 upstream base-fix carry | Fifteen post-R7.0.10 base fixes as patches until the next upstream release (#52) | Milestone | Complete | Issue #52 opened 2026-07-25: the July 2026 security wave (epics-base#934 RSRV validation flagship, #904 repeater UAF, plus client/local memory-safety, type-safety, and two owner-decided functional fixes incl. the invasive #856); one `patch/base-pr<NNN>-<slug>.p0.patch` per PR on the #32 revert discipline; no file overlaps (18 distinct files verified); the deep analysis is DONE 2026-07-25: applicability gate deferred #917/#856 (no target code at R7.0.10 / post-pin feature), a completeness sweep added five (incl. #890 makeRPath fail-hard — owner raised the trap, Michael landed the upstream protection), and a five-reviewer eight-axis median scoring with the four-condition OR rule adopted the FINAL SET OF FIFTEEN (decision record: `docs/base-carry-1.3.0.md`; procedure codified in the pipeline skill). Implemented 2026-07-25 at 54b8a44 (fifteen `patch/7.0.10-pr<NNNN>-<slug>.p0.patch`, #934/#837 manual-resolved, #817 curated to mbbiRecord.c) + c7aac56 (wiring: base_pr_patch_src ascending / revert reversed, RULES_SRC aggregate). Three-reviewer plan review + three-reviewer impl review, 0 blocking |
| M22.T1 | `make patch` applies the adopted fifteen (per-file lines observed) and the revert round-trip leaves sources clean; seven CI green; VM build + softIoc smoke; strict check_deps exit 0 unchanged | Verification | Complete | 2026-07-25 at c7aac56: fifteen patches round-trip clean on a fresh R7.0.10 tree (status empty, zero .orig/.rej); CI 8/8 green (patched tree builds all seven platforms); rocky8 VM full build, base-src carries the 15 (25 files), strict check_deps exit 0 (68 so, ABSPATH/LOSTORG 0); #932 dbpf INPM/INPU writable (dbgf reads back 5/7, badChoice before the fix); #890 negative test on the shipped CONFIG.Common.linuxCommon lines aborts the build on a failing MAKERPATH (rc 2) and passes on a healthy one; base-source patches are OS-independent so debian13 is covered by the Debian 13 CI leg |

| M26 upstream pvxs-fix carry | Twelve post-1.5.2 pvxs fixes as patches, managed with the base carry (#53) | Milestone | Complete | IMPLEMENTED 2026-07-26 (patches 006c95e, wiring c3a42c3; M26.T1 fully discharged, see below). Owner-added alliocs consumer check PASSED 2026-07-26 on the rocky8 VM (layers 2-3 + `iocs.bash` build-all): 34/35 built, sole failure bpc-ioc with its pre-existing hardcoded-EPICS_BASE signature (2026-07-17 diagnosis), zero new failures; cccs/pdu/llrf now build after their independent owner repairs and the llrf feed-core move. Selection COMPLETE 2026-07-25, deliberately run ahead of this milestone by owner decision to shorten the path. pvxs pinned at `tags/1.5.2`, upstream 25 commits ahead on `master` with no release above the tag, so no bump is available. Funnel: 25 enumerated, 6 removed as exclusively documentation/CI/test (judged from the diff: `67770b5` edits `src/pvxs/data.h` but only doxygen comments), 19 scored by a five-reviewer eight-axis median panel, 11 met the four-condition OR rule, `086501a` added by owner decision, 12 selected. Chain excluded: `5ab17ec` needs `8cb8d4b` needs `2b99e3c`, and the panel found a nested-array defect in that new JSON parser. Managed with M22 (#52): pvxs is the pvAccess implementation and is structurally headed into base, so retirement runs against whichever comes first: a pvxs release above 1.5.2, or the base bump that absorbs pvxs, in which case the re-examination is against the base tree. Procedure: `docs/upstream-fix-carry-procedure.md` |
| M26.T1 | Twelve p0 patches each dry-run verified against clean pvxs 1.5.2; same-file pairs verified in apply order; `make patch` exits 0 with twelve `patching file` lines and the revert round-trip leaves the source clean with no `.orig`/`.rej`; CI green, VM build green, strict `check_deps.bash` exit 0 unchanged | Verification | Complete | 2026-07-26 at c3a42c3 (patches 006c95e, wiring c3a42c3): AC1 per the adopted sequential-position reading (04-pristine failure expected, annexed); AC2 three put.cpp offsets only, no fuzz; AC3/AC4 leg round-trip 29 patching-file lines + clean tree, aggregate round-trip on the rocky8 VM (30 legs, twelve pvxs descending first on revert, between-state clean); CI 8/8 green; VM fresh build exit 0; smoke pvxput 1->5 with the patch-01 timestamped Connected line; strict check_deps exit 0 (BIN 144 / SO 68, RPATH-ABSPATH-LOSTORG all 0). Impl review 2 reviewers 0 blocking, twelve patches byte-identical to upstream regeneration |
| M27 Docs modernization | Reorganize `docs/`, modernize content, publish as an mdBook site on GitHub Pages (#54) | Milestone | Complete | Landed 2026-07-26 in five commits: `ec9ea28` (eight guide renames into `docs/src/`, all R100, `REAME.EPICSParam.md` typo corrected), `7667759` (book.toml with `create-missing=false`, SUMMARY, introduction and index pages, the records index at `docs/README.md`, six link retargets, `/docs/book/` ignored), `9b25513` (bounded content modernization of five guides), `c234e77` (`.github/workflows/docs.yml` + root README Documentation section), `50c3388` (three prose token corrections found in implementation review). Owner decisions: stale platform docs (Docker, macOS 11, Libera, ALS-U) stay records-side untouched with a links-only Archived Notes final section, full cleanup parked post-release; both-branch deploy trigger so the site flipped before the M7 gate. Pages migrated legacy -> workflow: the first `configure-pages@v6` run does NOT flip `build_type` (it runs with `enablement: false`), so an owner-directed `gh api -X PUT .../pages -f build_type=workflow` completed the migration and permanently retires the Jekyll path — without it the M7 merge would have re-rendered master `/docs` over the book. Plan reviewed in three rounds (3 reviewers; 1 blocking + 9 non-blocking folded), implementation reviewed by 3 reviewers with 0 blocking |
| M27.T1 | `mdbook build` clean; the deploy workflow publishes; the site renders the new structure with valid internal links | Verification | Complete | 2026-07-26: pinned mdBook v0.5.4 `mdbook build docs` exit 0 with `docs/src` unchanged by the build; offline lychee 0 errors / 337 OK, byte-matching the CI build-job log; `create-missing=false` proven load-bearing by a negative test (ghost SUMMARY entry -> exit 101, zero stubs) with a positive control (`create-missing=true` -> exit 0 + stub created); markdownlint 0 findings over the 17 book sources with all 46 MD010 residuals verified fence-internal; Deploy Docs green on both pushes; CI 9/9 at `c234e77`; twelve live URLs (root + all eleven SUMMARY chapters) HTTP 200 with four byte-identical to a fresh local build of the deployed sha; the four archive links plus the PDF 5/5 live. Verification-habit note: `grep -P '\xc2\xb6'` returns a FALSE not-found in a UTF-8 locale — use `hexdump` or a Python character check when auditing artifact removal |
| M28 Release-record hygiene | Mark the 1.2.0/1.2.1 release records superseded by 1.2.2 (#55) | Milestone | Complete | Owner decision 2026-07-26: consumed releases are never deleted; the GitHub yank-equivalent is a superseded warning banner prepended to the notes (original body preserved, tags untouched). Applied 2026-07-26 by owner-delegated `gh release edit` on both records. Procedure recorded in the git-workflow skill (`references/github-release.md`, "Defective release records") |
| M28.T1 | Both records begin with the #44 banner pointing to 1.2.2; original notes intact below; tags unchanged | Verification | Complete | 2026-07-26: both live bodies open with the banner; diff vs prepared notes identical except one GitHub-appended trailing blank line; tags untouched (notes-only edit) |

Tally: Milestones 33 (Complete 28, Not started 5: M23, M32, M33, M34, and M7); Verification subs 42 (Complete 35, Not started 7); Release Verification 10 (Pending 10)

## M7 Release Plan - 1.3.0

Plan Status: draft after first-person and third-person review, 2026-08-11.

Plan Acceptance: pending owner acceptance of this corrected plan.

Implementation Authorization: pending for M32-M34. The owner authorized the
review corrections on 2026-08-11; that authorization does not cover code,
commits, GitHub mutations, or release actions.

Target: the planning target is 2026-08-31. It is not a release gate. The date
may move later rather than omit an upstream change, weaken a verification, or
release a candidate invalidated by a newer Base, asyn, or security change.

Upstream policy: no snapshot cutoff applies before 1.3.0 is released. M32 runs
first. M33 and M34 must both complete before M7, and neither depends on the
other. At the start of every M7 attempt and again immediately before the
version and release sequence, the fixed survey checks every configured remote.
Any new upstream change returns the affected work to assessment, patch refresh,
and real-path verification before a new candidate is formed.

Observed starting point, 2026-08-11: Base remains pinned to the R7.0.10 release
while its `7.0` branch has advanced; asyn is pinned to R4-45 while the official
R4-46 tag is available; and the current update command can turn failed remote
lookups into an up-to-date result. These are observations to recheck, not a
release cutoff.

### Integrated Verification

| Source check | Invalidating trigger | Shared surface | Final result row |
| :--- | :--- | :--- | :--- |
| M22 / T1 and M21 / T1 | M33 changes the selected Base patches | Base source, installed Base binaries, and dependency paths | Release Verification 2 |
| M1 / T1, M5 / T1, M6 / T1, M6 / T2, M12 / T1, and M14 / T2 | M34 changes asyn and the combined module tree | Ubuntu 26 C23 configuration, module builds, linked binaries, and site consumers | Release Verification 3, Release Verification 5, and Release Verification 6 |
| M26 / T1 | M33 changes the aggregate patch path beside the pvxs leg | Patch ordering, reversal, and source-tree cleanliness | Release Verification 4 |

### Production Environment Tests

| System and version | Architecture | Deployment path | Timing | Real-path method | Expected result | Final label | Evidence target |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Rocky Linux 8.10 | x86_64 | Internal layers 1-3 under `/opt/epics/1.3.0/rocky-8.10/7.0.10` | post-change | `epics-env-pipeline` Stage 1, verification gates, and complete alliocs consumer build | All layers, gates, and consumers pass against the final tree | Release Verification 6 | Per-stage logs, PLAY RECAP records, installed-tree audit, and consumer logs |
| Debian 13 | x86_64 | Internal layers 1-3 under `/opt/epics/1.3.0/debian-13/7.0.10` | post-change | Same Stage 1 and consumer path on the Debian VM | All layers, gates, and consumers pass against the final tree | Release Verification 6 | Per-stage logs, PLAY RECAP records, installed-tree audit, and consumer logs |
| Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04, and Ubuntu 26.04 | x86_64 | Public layers 1-2 under `/opt/epics/1.3.0` using `make build.gz` | post-change | Run the public OS matrix from fresh VMs and record each complete installed path | Every listed OS builds, installs, and passes the public verification gates | Release Verification 6 | OS-specific build logs, complete installed paths, and verification reports |
| Clean Debian 13 VM as user `vmadmin` | x86_64 | `/home/vmadmin/epics/1.3.0/debian-13/7.0.10` | post-release | Follow the README source installation path from tag `1.3.0` and the published source archive without a local branch checkout | Both released sources install to the documented path and start the representative IOC checks | Release Verification 10 | VM identity, source identity, command log, installed path, and runtime output |

### Version Changes

| File and field | Before | Planned value | Pre-change method | Post-change method | Final result row |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `ChangeLog.md`, newest release entry | No 1.3.0 entry | Complete 1.3.0 entry in its own release-eve commit | Read the newest entry and record the branch commit | Read the rendered entry and compare its claims with the closed milestone evidence | Release Verification 7 |
| `configure/CONFIG_SITE`, `ENV_RELEASE_VERS` | 1.2.2 | 1.3.0 | Read the exact assignment before mutation and preserve its commit | Read the exact assignment after mutation and verify the installed tree carries 1.3.0 | Release Verification 7 |
| `README.md`, active source example | 1.2.2 | 1.3.0 | Locate the active example and distinguish historical records | Re-run the same search; require the active example at 1.3.0 and historical records unchanged | Release Verification 7 |

### Release Execution

| Action | Exact target | Required authority | Expected result | Post-execution evidence |
| :--- | :--- | :--- | :--- | :--- |
| Merge | `release-1.3.0` into `master` | Separately previewed `git-workflow` release authorization | `master` contains the accepted release candidate without unplanned commits | Merge commit identifier and parent identities |
| Create tag | Annotated tag `1.3.0` at the merged release tree | Separately previewed `git-workflow` release authorization | Local annotated tag names the accepted release commit | Tag object and peeled commit identifiers |
| Push branch and tag | `origin master refs/tags/1.3.0` | User-run release sequence command; no assistant override scope authorizes a tag push | Remote `master` and annotated tag resolve to the accepted release tree | Observed remote branch, tag object, and peeled commit identifiers |
| Publish release | GitHub release `1.3.0` | Separately previewed `git-workflow` release authorization | Published release points to tag `1.3.0` and carries the accepted notes | Release URL, tag name, and observed body identity |
| Close tracker milestone | GitHub milestone `1.3.0` | Separately previewed `git-workflow` release authorization | Milestone is closed only after its projected issues and release evidence agree | Milestone URL, state, and issue query |
| Leave next-line state | `docs/milestone-1.3.1.md` and its next session entry point | Separate `git-workflow` commit authorization | The next release line remains canonical and names its actual next work | Carrying commit identifier and checked canonical path |

### Release Verification Plan

| Release Verification | Timing | Real-path method | Expected result | Evidence target |
| :--- | :--- | :--- | :--- | :--- |
| Release Verification 1 - complete upstream survey at M7 entry | pre-change | Run the fixed shipped M32 command against every configured official remote | Every lookup succeeds and every reported change has an accepted disposition | Timestamped command output and resolved upstream identities |
| Release Verification 2 - Base carry and Base behavior | pre-change | Execute M33.T1/T2 against pristine R7.0.10 and the final selected patch set | Patch/revert is clean; affected Base, security, build, and dependency checks pass | Patch ledger, source status, test logs, and installed-tree audit |
| Release Verification 3 - asyn R4-46 and downstream consumers | pre-change | Execute M34.T1/T2 on the supported release systems | asyn, the C23 decision, downstream modules, support, site layers, and runtime checks pass | Build, test, dependency, IOC, and asyn runtime logs |
| Release Verification 4 - aggregate patch and late checks | pre-change | Execute M26.T1, M30.T1/T2, and M31.T1 on the final branch | Aggregate patch reversal and all late document/helper checks pass on the candidate | Source status and check outputs |
| Release Verification 5 - automated workflows | pre-change and post-change when a code-bearing push requires it | Observe the seven build workflows and documentation workflow for the final code and version-bearing commits | Every required workflow is green for the exact candidate commits | Workflow run URLs and commit identifiers |
| Release Verification 6 - production environments | post-change | Execute every Production Environment Tests row above | Internal and public paths pass and install under the 1.3.0 version path | Environment evidence targets above |
| Release Verification 7 - version and release-record consistency | post-change | Execute every Version Changes pre-change and post-change method | Active fields and release notes agree on 1.3.0; historical records remain unchanged | File diff, rendered records, and install path |
| Release Verification 8 - final upstream survey | post-change, immediately before release execution | Re-run the fixed shipped M32 command against every configured official remote | No failed lookup and no unresolved new change; any delta invalidates the candidate | Timestamped output adjacent to release authorization |
| Release Verification 9 - published object identity | post-release | Resolve `master`, annotated tag, GitHub release, and published source archive independently | Every object identifies the same accepted release commit and version | Commit, tag object, release URL, and archive identity |
| Release Verification 10 - released installation and tracker closure | post-release | Install from the released object on the clean host, then query milestone and next-line state | Installation and runtime checks pass; milestone is closed; 1.3.1 is the active line | Host log, milestone query, and next-line commit |

### Release Verification Results

| Release Verification | Observed time | Actual environment | Result | Evidence |
| :--- | :--- | :--- | :--- | :--- |
| Release Verification 1 - complete upstream survey at M7 entry | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 2 - Base carry and Base behavior | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 3 - asyn R4-46 and downstream consumers | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 4 - aggregate patch and late checks | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 5 - automated workflows | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 6 - production environments | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 7 - version and release-record consistency | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 8 - final upstream survey | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 9 - published object identity | Not observed | Not run | Pending | Evidence target is defined in the plan row |
| Release Verification 10 - released installation and tracker closure | Not observed | Not run | Pending | Evidence target is defined in the plan row |

## Assignment History

| Work Identity | From Canonical | To Canonical | Target Commit | Authority Moved At |
| :--- | :--- | :--- | :--- | :--- |
| M23 CI vendor relocation | 1.3.0, `docs/milestone-1.3.0.md`, `release-1.3.0` | 1.3.1, `docs/milestone-1.3.1.md`, `release-1.3.0` | `e9fb5c1` | `e9fb5c1` |
| M23 CI vendor relocation | 1.3.1, `docs/milestone-1.3.1.md`, `release-1.3.0` | 1.3.0, `docs/milestone-1.3.0.md`, `release-1.3.0` | this synchronization commit | this synchronization commit |
| M29 Documentation rewrite | 1.3.0, `docs/milestone-1.3.0.md`, `release-1.3.0` | 1.3.1, `docs/milestone-1.3.1.md`, `release-1.3.0` | this synchronization commit | this synchronization commit |

Post-release follow-up (owner note, 2026-07-25): after the 1.3.0 release,
update github.com/jeonghanlee/Dockerfile to the 1.3.0 environment; then
remove the personal CI variant in llrf `ci/` (build-deps.sh and its
deps.env-keyed image) — a stopgap that self-builds the dependencies
(including BerkeleyLab feed-core) because the official CI image still
carries the 1.2.1 environment; it retires once the image moves to 1.3.0.
The internal mirror repository `alsu/epics/modules/feed` (the lagging
personal feed-core mirror, no longer consumed since M14.T2) is to be
marked obsolete after 1.3.0.

## Carry-forward

| Topic | Work unit | Type | Status | Evidence or next action |
| :--- | :--- | :--- | :--- | :--- |
| makeRPath Perl port | Soak build implementation | Carry-forward | Conditional | `configure/RULES_RPATH`, `patch/makeRPath-perl.base.p0.patch` (commit `a74cc1c`, branch `feature/epics-path-relpath`). Code written; awaits re-review against the tree and a soak run. L2-L4 in `design-makeRPath-soak.md` unverified as of 2026-07-09 |
| makeRPath Perl port | Open upstream issue | Carry-forward | Not started | Deferred until after the soak run and #25. The drafted body predates #25 and proposes the approach #25 rejects; rewrite it around the `EPICS::Path` primitives before filing |
| makeRPath Perl port | Open upstream PR | Carry-forward | Blocked | Depends on the upstream issue; enables line-level review and CI |
| makeRPath Perl port | Maintainer calls: `-O` edge-case scope, stderr/help convention | External gate | Conditional | Await maintainer response; resolve only if raised in review |
| EPICS::Path primitives | Build `Normalize` / `RelPath` for makeRPath (#25) | Carry-forward | Not started | Backlog. `makeRPath` needs a no-stat lexical `..` collapse that neither `File::Spec::canonpath` nor `EPICS::Path::AbsPath` provides; build it once in the shared module rather than inside a leaf tool |

The 1.2.1 cycle's sixteen completed milestone rows are preserved in the tag
(`git show 1.2.1:docs/milestone.md`) and in the pre-restructure register
(`git show 5a24f55:docs/milestone.md`).

## GitHub milestones

| Milestone | State | Issues |
| :--- | :--- | :--- |
| 1.2.1 | closed | all closed: #18, #19, #20, #22, #24 |
| 1.2.2 | closed | all closed: #23, #44, #45, #46, #50 |
| 1.3.0 | open | on GitHub open 0; closed 28: #21, #26, #27, #28, #29, #30, #31, #32, #33, #34, #35, #36, #37, #38, #39, #40, #41, #42, #43, #47, #48, #49, #52, #53, #54, #55, #57, #58. M32-M34 are register-local and do not yet have tracker issues. M23 is canonical here again (D5, 2026-08-17) but its issue #51 still sits on the 1.3.1 GitHub milestone pending reassignment |
| 1.3.1 | open | on GitHub open 3: #51 (M23, now canonical in `docs/milestone-1.3.0.md`; GitHub milestone reassignment to 1.3.0 pending), #56 (M29, documentation rewrite), #59 (reproducible mdBook build and link check); canonical target is `docs/milestone-1.3.1.md` |
| Backlog | open | #25 |

Observed 2026-08-11 with `gh issue list --state all --milestone <name>` for
1.3.0, 1.3.1, and Backlog. Reconcile again before tracker closure.

## Source documents

- `docs/testplan_1.3.0.md`: the original 1.3.0 cycle verification record;
  the current M7 release plan is canonical above.
- `docs/src/module-management/module-dependency-audit.md` — module dependency audit design,
  phase definitions, and vendor dependency boundary table.
- `docs/makeRPath-perl-port/` — makeRPath design records, test plan, corrected
  port, comparison driver, and the `EPICS::Path` analysis behind #25.

## Branches

| Branch | Carries |
| :--- | :--- |
| `release-1.3.0` | The open 1.3.0 cycle (this register and the cycle plan) |
| `1.2.1` | Release 1.2.1 (shipped); merged to `master` at `b485e14`, tag `1.2.1` |
| `feature/epics-path-relpath` | makeRPath soak build and the `EPICS::Path` design record; branches from `9046fbb` |
