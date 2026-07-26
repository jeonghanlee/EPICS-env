# Work Register

Canonical milestone and carry-forward status for this repository. Every agent
and person reads this file first. Source documents named below remain as
design records and operational evidence; this register holds status.

Mode: remote-authoritative. Each issue's verification checkbox list is the
status source of truth for its M-subs; this register mirrors them, and every
milestone closure ends with a reconcile pass against the tracker.

Cycle: 1.3.0, opened 2026-07-17 on branch `release-1.3.0`. Cycle test plan:
`docs/testplan_1.3.0.md` (verification layers, per-milestone subs, dependency
re-run matrix, release gate). No standing plan exists yet. The released
register and plan are preserved by the release tag.

Next session entry point: shortest-first work order (owner decision
2026-07-25): M14.T2 DONE 2026-07-25 (site feed retired at alsu-site-modules
`0617c89`, llrf FEED -> feed-core at `38413bb`) -> M6 DONE 2026-07-25
(nine-module set + ADCore at 818ef60/7fe14ee, motor reverted after the
seven-platform failure; full record in `docs/module-bumps-1.3.0.md`) ->
M22 (#52, base-fix carry) DONE 2026-07-25 (fifteen patches at
54b8a44/c7aac56, T1 verified) -> M24 (#48, DONE 2026-07-25 — root cause corrected, recovery hints shipped) and M25
(#49, DONE 2026-07-25 — e824765; AC1/AC2/AC3 measured and healthy-tree
regression verified byte-identical on rocky8+debian13, #49 closed), both
moved from Backlog to 1.3.0 by the owner 2026-07-25 -> the M7 release gate
is now the next code-closable entry point; M23 (#51) stays post-release. Backlog
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
| M7 Release gate | 1.3.0 release sequence (register-local, no tracker issue) | Milestone | Not started | Gates merge to `master`, tag `1.3.0`, GitHub release, milestone close. Must not close before M21 lands, else 1.3.0 reships `DT_RPATH` |
| M7.T1 | Cycle batch re-run: every milestone's T1 against the final tree | Verification | Not started | |
| M7.T2 | Full automated suites: all seven workflows green on the release branch | Verification | Not started | |
| M7.T3 | Full-environment install verification on real VMs (epics-env-pipeline: internal 2 OS 3 layers; public gz on unblocked OSes) | Verification | Not started | |
| M7.T4 | Release sequence executed per the git-workflow release reference | Verification | Not started | |
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
| M14.T2 | alsu-site-modules `feed` removed; layer-3 build clean against the new tree | Verification | Complete | 2026-07-25 on the rocky8 068f511 tree (feed-core-0472d88 present): six-module site build init/build/symlinks exit 0, siteApps live, dead links 0, NO site feed beside env feed-core, check_deps strict exit 0 (74 so); llrf rebuilt clean against `$(MODULES)/feed-core`. Deferral was released by the owner the same day; precedes M7.T3 as required |
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

| M23 CI vendor relocation | Install the CI vendors into the tree so `check.deps` can gate strict in CI (#51, from the 1.2.2 cycle) | Milestone | Not started | NOT release-blocking — ordered after the M7 gate. CI workflows install uldaq/open62541 under /usr/local, so measComp/opcua carry ABSPATH and CI stays report-only `audit.deps`; relocating the vendors into the tree enables the strict flip (the #50 staged-rollout completion, relocated to #51) |
| M23.T1 | `make audit.deps` reports ABSPATH 0 in all seven workflows; then the seven flip to `check.deps` and exit 0 | Verification | Not started | |

| M26 upstream pvxs-fix carry | Twelve post-1.5.2 pvxs fixes as patches, managed with the base carry (#53) | Milestone | Not started | Selection COMPLETE 2026-07-25, deliberately run ahead of this milestone by owner decision to shorten the path; implementation not started. pvxs pinned at `tags/1.5.2`, upstream 25 commits ahead on `master` with no release above the tag, so no bump is available. Funnel: 25 enumerated, 6 removed as exclusively documentation/CI/test (judged from the diff — `67770b5` edits `src/pvxs/data.h` but only doxygen comments), 19 scored by a five-reviewer eight-axis median panel, 11 met the four-condition OR rule, `086501a` added by owner decision, 12 selected. Chain excluded: `5ab17ec` needs `8cb8d4b` needs `2b99e3c`, and the panel found a nested-array defect in that new JSON parser. Managed with M22 (#52): pvxs is the pvAccess implementation and is structurally headed into base, so retirement runs against whichever comes first — a pvxs release above 1.5.2, or the base bump that absorbs pvxs, in which case the re-examination is against the base tree. Procedure: `docs/upstream-fix-carry-procedure.md` |
| M26.T1 | Twelve p0 patches each dry-run verified against clean pvxs 1.5.2; same-file pairs verified in apply order; `make patch` exits 0 with twelve `patching file` lines and the revert round-trip leaves the source clean with no `.orig`/`.rej`; CI green, VM build green, strict `check_deps.bash` exit 0 unchanged | Verification | Not started | |

Tally: Milestones 26 (Complete 23, Not started 3 — the M7 gate; M23 post-release; M26 pvxs carry) · Verification subs 35 (Complete 29, Not started 6)

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
| 1.3.0 | open | closed (23): #21, #26, #27, #28, #29, #30, #31, #32, #33, #34, #35, #36, #37, #38, #39, #40, #41, #42, #43, #47, #48, #49, #52; open: #51 (M23, CI vendor relocation, post-release) |
| Backlog | open | #25 |

## Source documents

- `docs/testplan_1.3.0.md` — the 1.3.0 cycle test plan.
- `docs/README.module-dependency-audit.md` — module dependency audit design,
  phase definitions, and vendor dependency boundary table.
- `docs/makeRPath-perl-port/` — makeRPath design records, test plan, corrected
  port, comparison driver, and the `EPICS::Path` analysis behind #25.

## Branches

| Branch | Carries |
| :--- | :--- |
| `release-1.3.0` | The open 1.3.0 cycle (this register and the cycle plan) |
| `1.2.1` | Release 1.2.1 (shipped); merged to `master` at `b485e14`, tag `1.2.1` |
| `feature/epics-path-relpath` | makeRPath soak build and the `EPICS::Path` design record; branches from `9046fbb` |
