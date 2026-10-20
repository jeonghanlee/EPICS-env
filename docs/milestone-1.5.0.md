# Work Register

Release line: 1.5.0
Milestone index: 1.5.0
Canonical path: `docs/milestone-1.5.0.md`
Canonical branch or ref: `release-1.5.0`
Git upstream: `origin/release-1.5.0`
Remote tracker: `jeonghanlee/EPICS-env`; GitHub milestone 1.5.0, number 7

Next session entry point: M1 (EPICS base) is next under step 6 of `docs/procedures/release-procedure.md`. The four areaDetector modules (D53), the procedures with their checklist, and this register land in three commits before M1 starts; after them the tree is clean. Its issue is #111 and its plan is drafted in its detail; the plan review, the owner's acceptance, and the separate implementation authorization come next, then the plan commit as the candidate and the guest request to the cloud-provision session (D45, D46). Milestone tally: 44 rows, all Not started (M1 and M59 Ready; M50 follows M1 directly (D54); M2 to M33 and M51 to M54 follow in the order of D3, then the site modules M55 to M56 (D22), the rehearsal M57, the tag of the site module repository M58, and the release M34). Backlog: 15 rows, M42 In progress (the release-procedure reconciliation), the rest Deferred. References of the form `f2efff0 M<n>` or `f2efff0 D<n>` point to this file at `f2efff0`, the generation before the reset; `84ee626 M<n>` or `84ee626 D<n>` point to `docs/milestone-84ee626.md` at `4d521e7`; `1.4.0 M<n>` or `1.4.0 D<n>` point to `docs/milestone-1.4.0.md` at `84ee626`.

## Milestone

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| EPICS-env | M1 | Run EPICS base through the module cycle | Milestone | Not started | Yes | D2, D3, D4, D5, D18, D19, D20, D41, D42, D43, D45, D46 | EPICS base at `tags/R7.0.10` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m1---epics-base-cycle) |
| EPICS-env | M2 | Run pvxs through the module cycle | Milestone | Not started | No | M1, M50, D2, D3, D5, D18, D19, D20, D41, D43, D54 | pvxs at `tags/1.5.3` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m2---pvxs-cycle) |
| EPICS-env | M3 | Run MCoreUtils through the module cycle | Milestone | Not started | No | M2, D2, D3, D4, D18, D19, D20, D41, D43 | MCoreUtils at `a86e5ed` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m3---mcoreutils-cycle) |
| EPICS-env | M4 | Run autosave through the module cycle | Milestone | Not started | No | M3, D2, D3, D4, D18, D19, D20, D41, D43 | autosave at `tags/R6-0` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m4---autosave-cycle) |
| EPICS-env | M5 | Run ether_ip through the module cycle | Milestone | Not started | No | M4, D2, D3, D4, D18, D19, D20, D41, D43 | ether_ip at `tags/ether_ip-3-10` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m5---ether_ip-cycle) |
| EPICS-env | M6 | Run iocStats through the module cycle | Milestone | Not started | No | M5, D2, D3, D4, D18, D19, D20, D41, D43 | iocStats at `tags/4.0.1` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m6---iocstats-cycle) |
| EPICS-env | M7 | Run recsync through the module cycle | Milestone | Not started | No | M6, D2, D3, D17, D18, D19, D20, D41, D43 | recsync at `9834b94` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m7---recsync-cycle) |
| EPICS-env | M8 | Run retools through the module cycle | Milestone | Not started | No | M7, D2, D3, D4, D18, D19, D20, D41, D43 | retools at `5ada1e1` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m8---retools-cycle) |
| EPICS-env | M9 | Run sequencer through the module cycle | Milestone | Not started | No | M8, D2, D3, D4, D18, D19, D20, D41, D43 | sequencer at `tags/R2-2-9` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m9---sequencer-cycle) |
| EPICS-env | M10 | Run snmp through the module cycle | Milestone | Not started | No | M9, D2, D3, D4, D18, D19, D20, D41, D43 | snmp at `tags/v1.1.0.4ja` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m10---snmp-cycle) |
| EPICS-env | M11 | Run opcua through the module cycle | Milestone | Not started | No | M10, M59, D2, D3, D4, D18, D19, D20, D41, D43 | opcua at `tags/v0.11.2` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m11---opcua-cycle) |
| EPICS-env | M12 | Run pcas through the module cycle | Milestone | Not started | No | M11, D2, D3, D16, D18, D19, D20, D41, D43 | pcas at `e075fd4` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m12---pcas-cycle) |
| EPICS-env | M13 | Run pscdrv through the module cycle | Milestone | Not started | No | M12, D2, D3, D4, D18, D19, D20, D41, D43 | pscdrv at `276daca` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m13---pscdrv-cycle) |
| EPICS-env | M14 | Run linStat through the module cycle | Milestone | Not started | No | M13, D2, D3, D4, D18, D19, D20, D41, D43 | linStat at `tags/1.2.1` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m14---linstat-cycle) |
| EPICS-env | M15 | Run feed-core through the module cycle | Milestone | Not started | No | M14, D2, D3, D4, D18, D19, D20, D41, D43 | feed-core at `0472d88` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m15---feed-core-cycle) |
| EPICS-env | M16 | Run sscan through the module cycle | Milestone | Not started | No | M15, D2, D3, D7, D18, D19, D20, D41, D43 | sscan at `ce9660c` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m16---sscan-cycle) |
| EPICS-env | M17 | Run calc through the module cycle | Milestone | Not started | No | M16, D2, D3, D6, D18, D19, D20, D41, D43 | calc at `tags/R3-8` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m17---calc-cycle) |
| EPICS-env | M18 | Run asyn through the module cycle | Milestone | Not started | No | M17, D2, D3, D4, D18, D19, D20, D41, D43 | asyn at `tags/R4-46` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m18---asyn-cycle) |
| EPICS-env | M19 | Run QPC through the module cycle | Milestone | Not started | No | M18, D2, D3, D4, D18, D19, D20, D41, D43 | QPC at `913fad4` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m19---qpc-cycle) |
| EPICS-env | M20 | Run modbus through the module cycle | Milestone | Not started | No | M19, D2, D3, D4, D18, D19, D20, D41, D43 | modbus at `tags/R3-4` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m20---modbus-cycle) |
| EPICS-env | M21 | Run lua through the module cycle | Milestone | Not started | No | M20, D2, D3, D9, D18, D19, D20, D41, D43 | lua at `01aa7a1` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m21---lua-cycle) |
| EPICS-env | M22 | Run std through the module cycle | Milestone | Not started | No | M21, D2, D3, D8, D18, D19, D20, D41, D43 | std at `27b6967` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m22---std-cycle) |
| EPICS-env | M23 | Run StreamDevice through the module cycle | Milestone | Not started | No | M22, D2, D3, D4, D18, D19, D20, D41, D43 | StreamDevice at `tags/2.8.26` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m23---streamdevice-cycle) |
| EPICS-env | M24 | Run rgamv2 through the module cycle | Milestone | Not started | No | M23, D2, D3, D4, D18, D19, D20, D41, D43 | rgamv2 at `27fc633` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m24---rgamv2-cycle) |
| EPICS-env | M25 | Run busy through the module cycle | Milestone | Not started | No | M24, D2, D3, D10, D18, D19, D20, D41, D43 | busy at `a4a272d` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m25---busy-cycle) |
| EPICS-env | M26 | Run scaler through the module cycle | Milestone | Not started | No | M25, D2, D3, D11, D18, D19, D20, D41, D43 | scaler at `baa8e1c` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m26---scaler-cycle) |
| EPICS-env | M27 | Run mca through the module cycle | Milestone | Not started | No | M26, D2, D3, D4, D18, D19, D20, D41, D43 | mca at `687d563` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m27---mca-cycle) |
| EPICS-env | M28 | Run measComp through the module cycle | Milestone | Not started | No | M27, D2, D3, D15, D18, D19, D20, D41, D43 | measComp at `c38974e` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m28---meascomp-cycle) |
| EPICS-env | M29 | Run motor through the module cycle | Milestone | Not started | No | M28, D2, D3, D12, D18, D19, D20, D41, D43 | motor at `4b22ac9` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m29---motor-cycle) |
| EPICS-env | M30 | Run motorMotorSim through the module cycle | Milestone | Not started | No | M29, D2, D3, D4, D18, D19, D20, D41, D43 | motorMotorSim at `tags/R1-3` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m30---motormotorsim-cycle) |
| EPICS-env | M31 | Run pmac through the module cycle | Milestone | Not started | No | M30, D2, D3, D4, D18, D19, D20, D41, D43 | pmac at `2-7-9` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m31---pmac-cycle) |
| EPICS-env | M32 | Run caPutLog through the module cycle | Milestone | Not started | No | M54, D2, D3, D13, D18, D19, D20, D41, D43 | caPutLog at `tags/R4.2` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m32---caputlog-cycle) |
| EPICS-env | M33 | Run pyDevSup through the module cycle | Milestone | Not started | No | M32, D2, D3, D14, D18, D19, D20, D41, D43 | pyDevSup at `tags/2.1.0` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m33---pydevsup-cycle) |
| Procedure | M50 | Make the module check tools take the site module repository | Milestone | Not started | No | M1, D47, D54 | The survey, `check.module-deps`, and the three guest check scripts of this repository run against the site module repository with the same completeness signals as for EPICS-env, and the repository table states their use for that repository; [detail](#m50---module-check-tools-for-the-site-module-repository) |
| Procedure | M59 | Apply a module's carried patches in the guest update script | Milestone | Not started | Yes | D2, D20 | `guest-update.bash` applies the patch targets of the module it rebuilds and prints the installed link of a module whose install name differs, such as sequencer; [detail](#m59---guest-update-patches) |
| EPICS-env | M51 | Run ADCore through the module cycle | Milestone | Not started | No | M31, M59, D2, D3, D4, D18, D19, D20, D41, D43, D53 | ADCore at `ee039d2` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m51---adcore-cycle) |
| EPICS-env | M52 | Run ADSimDetector through the module cycle | Milestone | Not started | No | M51, D2, D3, D4, D18, D19, D20, D41, D43, D53 | ADSimDetector at `0ef1305` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m52---adsimdetector-cycle) |
| EPICS-env | M53 | Run ADGenICam through the module cycle | Milestone | Not started | No | M52, D2, D3, D4, D18, D19, D20, D41, D43, D53 | ADGenICam at `ba5b9b8` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m53---adgenicam-cycle) |
| EPICS-env | M54 | Run ADVimba through the module cycle | Milestone | Not started | No | M53, D2, D3, D4, D18, D19, D20, D41, D43, D53 | ADVimba at `tags/R1-5` passes T1 to T5 at its candidate commit, the results are committed and pushed, and its issue is closed on `release-1.5.0`; [detail](#m54---advimba-cycle) |
| Site modules | M55 | Run siteApps through the module cycle | Milestone | Not started | No | M33, M50, D2, D3, D18, D19, D20, D22, D41, D45, D47, D51 | siteApps passes T1 to T5 at its candidate commit, and the results and the closure are committed and pushed; [detail](#m55---siteapps-cycle) |
| Site modules | M56 | Run unidrv through the module cycle | Milestone | Not started | No | M55, D2, D3, D18, D19, D20, D22, D41, D45, D47, D51 | unidrv passes T1 to T5 at its candidate commit, and the results and the closure are committed and pushed; [detail](#m56---unidrv-cycle) |
| Release | M57 | Rehearse the combined stack of the two repositories | Milestone | Not started | No | M56, D21, D41, D45 | The two release-line tips build together on new guests and `make check.deps` and `make check.env` pass; [detail](#m57---combined-stack-rehearsal) |
| Release | M58 | Merge and tag the release line of the site module repository | Milestone | Not started | No | M57, D22, D49 | The site module repository has its `1.5.0` tag on its merge commit, observed on its remote; [detail](#m58---merge-and-tag-of-the-site-module-repository) |
| Release | M34 | Verify and publish EPICS-env 1.5.0 | Milestone | Not started | No | M1 to M33, M50 to M59, D3, D18, D48, D50, D52 | Every Release Verification row is Pass, the release objects exist with recorded identities, GitHub milestone 7 is closed, and the next line's canonical path is recorded; [detail](#m34---release-epics-env-150) |

### Decisions

| ID | Decision | Decision Date |
| --- | --- | --- |
| D1 | Open the 1.5.0 release line on `release-1.5.0` from master `4d521e7` for a module-set update, the case the 1.4.0 closure reserved for 1.5.0. `ENV_RELEASE_VERS` is 1.5.0 in `configure/CONFIG_SITE` since 8a603bb, the first commit of this line. | 2026-10-10 |
| D2 | Reset this register from its state at f2efff0. Every module of the two repositories, EPICS base included, runs the whole cycle again from EPICS base in the order of D3, as `docs/procedures/release-procedure.md` steps 6 and 7 set out. The pins and the patches of EPICS-env stand as decided (D4 to D17); each module's build and tests run again at its candidate commit. Stages 1, 2, 4, and 5 of an EPICS-env module stand from that survey; its cycle runs the census of Stage 3 for its dependents, and Stage 6. The earlier runs of the ten updated modules (f2efff0 M9 to M18) are leads for their plans, not results of this cycle. | 2026-10-18 |
| D3 | Cycle order (`docs/procedures/release-procedure.md` step 5): EPICS base (M1) first and pvxs (M2) with it; then the dependency order of `build.<module>` in `configure/CONFIG_MODS_DEPS` from the bottom up, ties in the order of that file: MCoreUtils, autosave, ether_ip, iocStats, recsync, retools, sequencer, snmp, opcua, pcas, pscdrv, linStat, feed-core, sscan, calc, asyn, QPC, modbus, lua, std, StreamDevice, rgamv2, busy, scaler, mca, measComp, motor, motorMotorSim, pmac, ADCore, ADSimDetector, ADGenICam, and ADVimba (M3 to M31, then M51 to M54); then the identical-code re-pins caPutLog (M32) and pyDevSup (M33). The site modules siteApps and unidrv follow the EPICS-env modules (M55 and M56, D22). The four areaDetector modules entered this order on 2026-10-19 with D53. | 2026-10-18 |
| D4 | Keep the 1.5.0 module survey's decision record in this Decisions table and in the module details below; no separate `docs/module-bumps-1.5.0.md` is created. The survey ran on 2026-10-11 (`tools/update-release.bash check` exit 0, 33 of 33 lookups, 13 updates, before the four areaDetector modules of D53 joined `configure/RELEASE`; they carry the pins of their former repository as unchanged, and the next survey of this repository covers all 37 keys), the census was taken at each module's pinned revision with two search tools agreeing, and EPICS-env-support and the site module repository were read from ADCore ee039d2 and the sibling site-module checkout; those readings are leads, and each EPICS-env-support module and site module takes its own census in its cycle (D22). | 2026-10-11 |
| D5 | pvxs: IN, `tags/1.5.2` (8e00eaecdee5ce8a474704e70d820e6f92693fa1) to `tags/1.5.3` (25ca43df4db909c0b1a445fb705fc81582617625). All twelve carried 1.5.2 commits are ancestors of 1.5.3, so the carry files retire with the bump and `patch/README.md` is rewritten; the public API change is additive (`TypeCode::valid()` export, new `pvxs/json.h`) and `SHRLIB_VERSION` stays 1.5. EPICS base stays at 7.0.10 with its carry set unchanged. | 2026-10-11 |
| D6 | calc: IN, 4217e83a9b9067017f4dc74da6b70e3669972f16 to R3-8 (712a40453e8693fda3b90a6e9da5fdb1c708ee38): eight engine fixes, seven bounds and overflow guards and the vararg argument-count skip of the UNTIL scan, with no header or Makefile change. The four later Db-only commits at head (59d1fe5) are not taken. | 2026-10-11 |
| D7 | sscan: IN, e13699e3062145d516cfdd555aae25bb49a8c53b to head ce9660cfc05071834391225beadf7f93b776d216 (no tag after the pin): delays no longer rounded to the thread quantum except on vxWorks, npts computed with round(), K&R declarations removed from the internal writeXDR.h. | 2026-10-11 |
| D8 | std: IN, 5f2e44214963b84ea3a400f7b7c3a9f510126ddd to head 27b696702c4ebc8c698c98e3bbb10a34f1a2c821 (no tag after the pin): throttleRecord.c locks the record in its delayed callback and writes the link-status flag for the correct link. | 2026-10-11 |
| D9 | lua: IN, 17475b50ae95c801bad9573bb2b031ffb04ac75c to head 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d (no tag after the pin; upstream names it Release 4-0): bundled Lua 5.5.1, device support in C++, extended luascript record, unified run and state APIs with deprecated aliases, luaaa and the C++11 requirement removed. No module in the two repositories links lua or includes its headers; `motor_DEPS` names `build.lua` as a build-order declaration, so the lua cycle rebuilds motor on that declaration, not on a link; motorMotorSim and pmac reach lua only through motor and rebuild in their own cycles. | 2026-10-11 |
| D10 | busy: IN, 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb to head a4a272d94d1f4351e7d9553e6dc35782eb96ce75 (no tag after the pin): busyRecord uses TYPED_DSET and TYPED_RSET, the dbd adds the typed dset declaration, and the build moves to the cfg-based mechanism with the test IOC opt-in. | 2026-10-11 |
| D11 | scaler: IN, beb5521af49616682e4e442c3e33a06add1bd713 to head baa8e1c5e5a9a5deceef8cc39207a0da446092a6 (no tag after the pin), to keep busy and scaler on the same cfg-based build convention; no record or device-support code changes and the C17 bridge stays. | 2026-10-11 |
| D12 | motor: IN, 285f44d66cf7d07a86047719de757bd1f5d92a95 to 4b22ac950de98c2dca324c2ef8ef221e124f6651, which is R7-4 plus the motorRecord.cc version-number correction the tag misses. Head 47893ed is excluded: it removes NUM_MOTOR_DRIVER_PARAMS, which pmac 2-7-9 uses in two files and pmac upstream still uses, with no newer pmac tag. | 2026-10-11 |
| D13 | caPutLog: IN, dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 to R4.2 (6f9eb3f6c75e49201d114f8e194d53cef493a522); the difference is documentation only, so the move re-pins identical code to a release tag. | 2026-10-11 |
| D14 | pyDevSup: IN, 4527ed055a472d4688846a2cb64ac593fec1ecbb to 2.1.0 (b5cef38a6d9f74f9c59f967185ba6d1940637c03); the difference is CHANGELOG.md only. Head (80cdb15) is not taken. | 2026-10-11 |
| D15 | measComp: HOLD at c38974e85c59429b8ba48ed320681ba0296fb924; the two later commits change autoconvert .ui files and docs only. | 2026-10-11 |
| D16 | pcas: HOLD at e075fd450ab9a66bbc044eaa4c2035d3d26d9651; the two later commits change the CI workflow only. | 2026-10-11 |
| D17 | recsync: HOLD at 9834b94edc63eece42712b8355a4703d4286dd8f. From 1.10.0 the recsync repository carries only a stub client Makefile that exits 1; the client lives in ChannelFinder/reccaster (1.9.7 = bebf91f54faf93a59eb4538d3594a687a8823963, no shared history with the pin). The repository switch is module source work outside a version bump, tracked by GitHub issue #101 in the Backlog milestone and not part of 1.5.0. | 2026-10-11 |
| D18 | Verification cadence: each module update runs its incremental real-path checks on Debian 13 and Rocky Linux 8.10; the six OS workflows, the public gz product on six OS, and the internal product with the site modules and the alliocs consumer check run on the final combined tree under M34's Integrated Verification and Production Environment Tests. | 2026-10-11 |
| D19 | No module update of this line runs the module's own upstream test suite; the real-path checks of a module update are its builds, the installed-tree checks, and a started IOC or the loader suite. | 2026-10-11 |
| D20 | Build environment of the incremental platforms (D18). Each platform is an OS-matched x86-64 virtual machine, the form of the 1.4.0 checks (1.4.0 D21 and 1.4.0 M6): the `debian13-epics-dev` and `rocky8-epics-dev` guests that `cloud-provision` provisions (`make epics-env.provision`), built from source by the `epics_build` role of `ansible-provision` through cloud-provision's `bin/run_epics_env_build.bash -e epics_env_tag=<commit>`, run once per operator playbook `playbooks/operators/common.yml`, `python.yml`, and `epics_build.yml` so that the `epics_support` operator of the `epics_dev` species does not add EPICS-env-support to the tree; the commit is the candidate commit of EPICS base, the first module of the cycle, and is on `origin`, because the role clones the public remote; the role's default tag is `release-1.3.0` and its checkout accepts a commit hash, so the extra var is required and pins the baseline. A reused guest is reset first with the provisioner's `make <os>.clean`, because the role skips the build when a tree already exists under `/opt/epics`. The role clones the repository into the guest and writes `INSTALL_LOCATION=/opt/epics`, its `path_epics_install`, which is the production install root and belongs to `ansible-provision`; this register sets no root of its own for a guest. The role builds uldaq and open62541 under the generated tree's `vendor/`, writes `configure/RELEASE.local` from `make print-INSTALL_LOCATION_EPICS`, and runs `make init`, `make patch`, `make conf`, `make build`, `make install`, `make symlinks`, and `make check.env`; the tree is `/opt/epics/1.5.0/<os_id>-<os_version>/7.0.10`, generated by the tracked configuration, and no path is written by hand. That build is the baseline; each module check brings the candidate into the guest's checkout, as the fetched candidate commit or as the working-tree patch with its SHA-256 recorded, both forms the 1.4.0 record used, and rebuilds only its module and its dependents into the same tree. A container build, including the CI workflows that M34 runs under D18, is not evidence for an incremental platform. The results record each guest's OS point release, kernel, and compiler version. | 2026-10-11 |
| D21 | Before the tag of the site module repository is created, the EPICS-env agent builds the two repositories together at the two release-line tips as a rehearsal of the final stack, and the tag waits for its result; the verification of a site module runs against the EPICS-env tree of its own cycle, so a failure that only the combined stack at the tips has would otherwise show after the tag exists. The method is step 8 of `docs/procedures/release-procedure.md`, and the rehearsal is M57, which precedes the tag of the site module repository (M58) and the release (M34). | 2026-10-16 |
| D22 | A module of the site module repository is an extra module of this release and is run exactly as an EPICS-env module by this session: it edits, commits, and pushes in that repository, opens that repository's `release-1.5.0` from master before its first module, and merges and tags it (M58), each action under the owner's authority (`git-workflow`); a site module has no issue and is recorded in this register only. The modules are rows of this register (M55 and M56): siteApps and unidrv. They follow the EPICS-env modules (D3). Their Stages 1 to 5 run at the start of their own cycles, after M50 gives the tools of D47. The site module repository's own register file stays as it is and is not edited during this release. What differs by repository is the repository table of `docs/procedures/module-bump-procedure.md`. | 2026-10-18 |
| D23 | Assign the makeRPath work (#25) to the Milestone: remove the `makeRPath` Python dependency through additive `EPICS::Path` primitives, delivered as a local patch on the pinned EPICS base. Its earlier ordering dependency, the installed-tree relocation work (84ee626 M16), is Complete. | 2026-10-02 |
| D24 | The durable home for the commonIocsh fragments and the global iocsh is a dedicated public module named `commonIocsh`, its own repository pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP`; per-module patching is not used. Interim: the fragments are developed and held in EPICS-env until the promotion. | 2026-09-12 |
| D25 | Defer the D24 promotion of commonIocsh to its public module (public repository and RELEASE pin). The 1.4.0 fragment work (1.4.0 M6) completed on the interim EPICS-env home with its verification satisfied on Debian 13 and Rocky Linux 8.10; the promotion is Backlog M36. | 2026-09-21 |
| D26 | The 1.4.0 fragment work (1.4.0 M6) ships the commonIocsh fragment set without a single global iocsh file. The common services are verified loading together in one IOC by the integrated suite, and the example IOC exercises only the caPutLog fragment. A shipped global startup file is Backlog M37. | 2026-09-24 |
| D27 | Exclude the Libera cross-build, the actual generated-profile repetition, and the Libera output comparison from the completion of the environment-script work (84ee626 M14); retain them as Deferred Backlog M38. The Libera reference is its own document, `docs/libera-cross-build.md`, and both Libera scripts keep their paths. | 2026-09-30 |
| D28 | Exclude actual macOS patch-revert verification from the completion of the clean, uninstall, and patch-revert work (84ee626 M15) and retain it as Deferred Backlog M39. Preserve the runtime code and platform conditions; Linux results do not verify macOS execution. Resume requires a new execution decision. | 2026-10-01 |
| D29 | The loader work (84ee626 M23) completes with the Eclipse Milo startup variant as the data-path evidence for opcua-IOC-demo. The databases of the original startup name 69 nodes under `ns=2;s=Demo.Static`, `Demo.Dynamic`, and `Demo.WorkOrder` that only the Unified Automation example server `uaservercpp` provides; that server needs a registered download, the Milo server names its nodes differently, and the test server of the opcua module provides its own test nodes only. A server written to imitate those nodes would be a stand-in and is not used. The data path of the original startup is Deferred Backlog M40 until that server is available. | 2026-10-04 |
| D30 | The segmentation fault of the combined load of the linStat and iocStatsAdmin fragments is a defect of EPICS base R7.0.10, carried as the site patch `patch/7.0.10-site02-dbstatic-device-menu.p0.patch` (84ee626 M30). Cause, observed 2026-10-05 on Debian 13: when a database loads a record whose name exists with another record type and sets a field that the existing type lacks, `dbRecordField` in `modules/database/src/ioc/dbStatic/dbLexRoutines.c` suggests a field name by walking the fields of the existing type, and for the device type field of a record type without device support it reads `ftPvt`, which is NULL, at line 1345. Two small database files reproduce it in `softIocPVX` without linStat. The report of this patch and of `7.0.10-site01-dbyacc-eof.p0.patch` to the upstream EPICS base repository is Deferred Backlog M41. | 2026-10-05 |
| D31 | Defer the reconciliation of the release-procedure records, the documents in this repository and the owner's release, milestone, git, and environment-pipeline procedures, until after the 1.5.0 release; the 1.5.0 cycle runs on the 1.4.0 precedent as executed. Track the reconciliation as Backlog M42. | 2026-10-10 |
| D32 | Keep the Milo-based OPC UA example-server work (#99) out of 1.5.0 as Deferred Backlog work M43: it is example and documentation work, not a module-set change, and it is examined together with the original-startup data path kept as M40. | 2026-10-11 |
| D33 | Move the makeRPath work (M35) to the Backlog and pursue it as an upstream epics-base submission instead of a local base patch, superseding the delivery form of D23. The EPICS-env build already runs `makeRPath.py` under `python3` (`configure/RULES_BASE` writes `PYTHON = python3` into the base `CONFIG_SITE.local`) and requires `python3` to read its own configuration, so a local patch removes no prerequisite; the value of the work is the Base path toolkit and `src/tools` consistency, and upstream carries no change to `makeRPath.py`, `EPICS/Path.pm`, `CONFIG_BASE`, or `src/tools/Makefile` since R7.0.10. Design notes for the upstream work: remove `makeRPath.py` and repoint `MAKERPATH` and the install entry; `Normalize` collapses POSIX `//a` to `/a` and rejects an empty string; verification is the edge catalog with the 37-case parity driver and a RUNPATH comparison between a Python-built and a Perl-built tree; no separate soak wiring is kept. The result enters this repository when a Base release that carries it is pinned. | 2026-10-11 |
| D34 | Keep the loader suite's record-count fix as Backlog work M45 until the release work refreshes the suite counts. | 2026-10-12 |
| D35 | Each module update or procedure step ends by writing its procedure lessons into the procedure it changed, as `docs/procedures/documentation-upkeep-procedure.md` sets out; on 2026-10-12 the installed-tree census rule, the exact-ref count rule, and the carry retirement rule entered `docs/procedures/module-bump-procedure.md` and `docs/procedures/upstream-fix-carry-procedure.md`. Lessons about the sessions' own working method, and the release-procedure decisions to reconcile after the release, collect in Backlog M46 for the skills repository and for M42. | 2026-10-12 |
| D36 | The crash of `dbLoadRecords` called without its macros argument while lua is loaded, found by the plan review of the lua update on 2026-10-13, stays out of 1.5.0 as Deferred Backlog work M47: the defect sits in lua's database hook at the pin 17475b5 that 1.4.0 shipped and at 01aa7a1 alike, so the update neither causes nor removes it; reporting it upstream or carrying a patch is decided when the work is assigned. | 2026-10-13 |
| D37 | How the installed shared libraries identify their version stays out of 1.5.0 as Deferred Backlog work M48. Found on 2026-10-14 in the caPutLog plan review, when the question was what the RUNPATH of an example IOC built through `modules/caPutLog` proves: the modules do not set a versioned `SONAME` (47 of the 54 distinct `SONAME` values of the module libraries in the Debian 13 tree are bare), objects built inside this tree name the versioned directory through `$ORIGIN`, and an object built against the convenience link records the link, which later points at whichever version is installed last. The work decides the RUNPATH naming rule, the `SONAME` and ABI name rule, how `check.deps` and `check.env` report a link, and the long-term operation and security design of the library resolution; it informs M35, whose Perl `makeRPath` computes the entries. A new dated decision assigns it. | 2026-10-14 |
| D38 | Loading pyDevSup into a plain IOC through the loader stays out of 1.5.0 as Deferred Backlog work M49. pyDevSup installs `libpyDevSup<PYVER>.so`, `dbd/pyDevSup.dbd`, a Python package, and the executable `softIocPy<PYVER>` that links the library and libpython at build time, and the loader treats it as a data-only module. An exploratory run of 2026-10-14 on Debian 13 and Rocky Linux 8.10 at the installed pin 4527ed0 loaded the library and its database definition into the plain `softIoc` of base with `dlload`, `dbLoadDatabase`, and `registerAllRecordDeviceDrivers`, and a Python device-support record processed; relocation, the library name that carries the Python version, and the loader rules are not examined. A new dated decision assigns it. | 2026-10-14 |
| D39 | The release-procedure reconciliation (M42) runs now, before the EPICS-env-support modules start, instead of after the 1.5.0 release as D31 set. Its shape: one procedure with one entry file under `docs/procedures/` and several files behind it, each rule in exactly one file and the others pointing to it; the module procedure is the unit repeated at every size (a module, a repository, the release), and a module of EPICS-env-support or of the site module repository differs from an EPICS-env module only in the rows of one table (the survey tool, the register that holds its rows, the session that commits, and what its verification adds). The general rules stay in the owner's skills (`release-cycle`, `milestone-tracking`, `git-workflow`) and the deployment in the environment pipeline; the entry file points at both. D31 stands for everything M42 lists that the executed 1.5.0 route must settle. | 2026-10-17 |
| D40 | The eight rule choices of M42, decided as recommended: the closed register is reset into the next generation and read at its closure commit (D52), not moved to `docs/archive/`; the version value is set when the release line opens, and no release-eve version commit exists; the `ChangeLog.md` form of this repository (`### <version> <date> <name> <email>`) stands, and the git release procedure defers to the repository's form; an issue of a release-line milestone closes on the release branch when its work closes, as in 1.5.0; the master push and the tag push are separate rows with separate authority; the next release line opens by a separate dated decision after the release; the 1.4.0 candidate rule (a later commit that changes only evidence, documentation, or tools that no build or CI file references leaves the candidate valid once the comparison of its inputs is recorded) goes into the release-cycle skill; a bump decision lives in the register's Decisions and a fix-carry decision in its own `docs/<module>-carry-<ver>.md`, stated in the upkeep procedure. | 2026-10-17 |
| D41 | The guests of this cycle are the default Debian 13 and Rocky Linux 8.10 epics-dev guests of D20, not extended; the other operating systems are covered by the six OS workflows and the two products of M34. | 2026-10-18 |
| D42 | M1 runs on new guests requested at the candidate commit of EPICS base; the guests built at the line commit 0c157cf are not reset and reused for it. | 2026-10-18 |
| D43 | Each of M1 to M33 and M51 to M54 gets a new issue in GitHub milestone 1.5.0; the closed issues of the earlier run (#97 and #102 to #110) stay closed as its record. Each issue is opened at the plan step of its module and follows the form of #111: the title `Rebuild and verify <module> for 1.5.0`, the label `enhancement`, the assignee `jeonghanlee`, and a body without register IDs. | 2026-10-18 |
| D44 | The skill corrections of M42 step 8 are sent after M1 closes, so that the request carries what the EPICS base cycle shows; the corrections that later modules and the release add are sent as one request at the close of the cycle. | 2026-10-18 |
| D45 | Guests for the module checks are asked of the cloud-provision session, which owns the hypervisor and the provisioner, with a resource request in the form of the `agent-collaboration` skill (`message-formats.md` and `vm-request-handling.md`): Purpose first, then Platform, Resources, Duration, State, Access, and Follow-up, filled by this session. The EPICS-env build at the candidate is the Follow-up; who runs it, and under whose approval, follows that skill. This session uses only the guests created for it, sends a finished notice when its use ends, and asks for removal only through that notice. The provisioner commands that D20 names record how the earlier guests were made; under this decision they are the cloud-provision session's to choose, and the `make <os>.clean` that D20 names for a reused guest removes the guest, its disk, and its seed, which is the owner's decision under that skill. | 2026-10-18 |
| D46 | The guests built at 0c157cf for the earlier run (f2efff0 M9 to M18) are shut down, and their disks are kept as the evidence of that run. They were made with the provisioner's make target, not given through a request, so this session asks the cloud-provision session to shut them down by their profiles, `debian13-epics-dev` and `rocky8-epics-dev`, instead of sending a finished notice. | 2026-10-18 |
| D47 | Every procedure of an EPICS-env module applies to a site module as it stands: the survey with its completeness test, the `_DEPS` audit of `check.module-deps`, and the three guest check scripts. The tools of this repository take the target repository instead of being copied into it, because every guest carries an EPICS-env checkout; the work is M50, done before the site modules start. | 2026-10-18 |
| D48 | The merge of the release into `master` takes the tip of `release-1.5.0` after its last pre-merge checkpoint commit, not the candidate SHA, because the checkpoints that follow the candidate's push would otherwise stay off `master`; the comparison of that tip with the candidate is recorded under the candidate rule of `docs/procedures/release-procedure.md` step 10. | 2026-10-19 |
| D49 | If the `release-1.5.0` of the site module repository holds no commit beyond master, every module of it unchanged, it is not merged: its annotated tag `1.5.0` goes on the master commit that M57 built, `release-1.5.0` is still pushed, and M58 records the case. | 2026-10-19 |
| D50 | The release line of the release before the previous one, `release-1.3.0`, is deleted locally and on origin after this release, because its tag `1.3.0` is on origin and keeps the content, and `release-1.3.0` is merged into master. | 2026-10-19 |
| D51 | The documents of the site module repository, such as its version policy and the scope statement of its README, are read as reference during this release and are not edited by it; they are reconciled with the procedures of this repository after the procedures are complete. D22 stands. | 2026-10-19 |
| D52 | A closed register is read at its closure commit, which the History row of the next register names, not under the release tag: the tag marks the merge and precedes the post-release evidence, so the register at the tag of the previous release still shows five Release Verification rows as not run, and none at its closure commit. This replaces the tag as the reading position in D40. | 2026-10-19 |
| D53 | The four modules of EPICS-env-support (ADCore, ADSimDetector, ADGenICam, ADVimba) are modules of this repository from this release, declared in `configure/RELEASE` and `configure/CONFIG_MODS_DEPS` at their former pins, with the ADCore libxml carry as `patch/ADCore-libxml-free.p0.patch`; EPICS-env-support is no longer a repository of the release, and a release carries the modules of two repositories, this one and the site module repository, in one order. | 2026-10-19 |
| D54 | M50 runs right after M1 and before M2, on the guests that M1 makes: the three guest check scripts, changed to take the module's repository, serve every module cycle that follows, and the EPICS-env parity check of M50 runs on guests that carry the candidate tree and nothing else. | 2026-10-20 |

### Milestone Details

#### M1 - EPICS base Cycle

Origin: 1.5.0 / M1
Identity History: none
GitHub Issue: #111, https://github.com/jeonghanlee/EPICS-env/issues/111
Status: Not started

##### Summary

Run EPICS base (`SRC_TAG_BASE` at `tags/R7.0.10`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4 and D5: no newer upstream release at the survey, and EPICS base stays at 7.0.10 with its carry set unchanged); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` for EPICS base: the full build of the tree at its candidate commit on fresh guests, the baseline build of D20, with the carry set of `patch/` as it stands.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4, D5, and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- First module of the cycle (D3).
- D42 sets new guests at the candidate commit of EPICS base.
- D2 sets the cycle, D4 and D5 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Open the issue of this work in GitHub milestone 1.5.0 (D43) and record its number here.
2. Review this plan in a third-person pass and a second-person pass; the owner accepts it and separately authorizes the implementation.
3. Commit the accepted plan and push it. The pin does not move, so that commit is the candidate (`docs/procedures/release-procedure.md` step 6), and the guests fetch it from origin.
4. Ask the owner which session is cloud-provision, for the approval of the build on the new guests (the guest section of `docs/procedures/module-bump-procedure.md`), and for the approval of the shutdown below, which lies outside that session's standing authorization because no finished notice of a requester applies. Send that session the request to shut down the guests built at 0c157cf (D46), then a resource request (D45). Purpose: the baseline build of the 1.5.0 tree at the candidate, kept up as the baseline of the module checks of M2 to M33 and M51 to M54. Platform: Debian 13 and Rocky Linux 8.10, the epics-dev profiles. Resources: 2 vCPU, 4096 MiB memory, and a 20 GiB disk each, as the earlier epics-dev guests of this line. Duration: until M33, M50, and M59 close, since M50 and M59 verify their tools on these guests. State: new guests (D42); the disks are evidence to keep. Access: this session connects by SSH from the same host. Follow-up: the EPICS-env build with the candidate as `epics_env_tag` through the operator playbooks `common`, `python`, and `epics_build` (D20, D41). The guest access comes in the private handoff that the reply names. The build is T1; its census is every module, since each builds on base through `null.base`.
5. In each guest, add the tools of the loader suite (`gawk`, `expect`, `strace`, `socat`, `podman`, and ShellCheck, from EPEL on Rocky Linux), then run T2 (`guest-roundtrip.bash`) on the Debian 13 guest and T3 (`guest-suite.bash`) on both, as root from `tools/module-check/` of the guest checkout `/opt/epics-env-src/EPICS-env`, which the build left at the candidate, and T4 (`make check.deps` and `make check.env`) in that checkout; redirect each output to a log under `work/` of the local checkout.
6. Record T1 to T5 here with their observed times, guests, and evidence; commit and push the results and record their landing on `origin/release-1.5.0`; close #111 and read back its closed state; then make the closure commit that records the landing and the closed issue in Closure Evidence and marks M1 Complete, and push it.
7. Write a rule the run taught into the procedure that owns it, as `docs/procedures/documentation-upkeep-procedure.md` sets out, and record each gap the run shows in the procedure files under M42 step 9, in a commit of their own after the closure commit.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The `epics_build` operator builds the tree from source at the candidate commit (D20); record the OS point release, kernel, and compiler | Debian 13 and Rocky Linux 8.10 epics-dev guests, new (D42) | The build and its `make check.env` succeed; the tree is `/opt/epics/1.5.0/<os_id>-<os_version>/7.0.10` |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate>` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Rebuild and verify EPICS base for 1.5.0
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-20; remote updated 2026-10-20T04:09:07Z, after the body edit that names the module set of the candidate

#### M2 - pvxs Cycle

Origin: 1.5.0 / M2
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run pvxs (`SRC_TAG_PVXS` at `tags/1.5.3`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D5); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.pvxs` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D5 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M1 precedes this work (D3).
- M50 precedes this work, and the guest check scripts it changes serve this cycle (D54).
- D2 sets the cycle, D5 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M9, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash pvxs PVXS <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> pvxs` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M3 - MCoreUtils Cycle

Origin: 1.5.0 / M3
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run MCoreUtils (`SRC_TAG_MCOREUTILS` at `a86e5ed`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.MCoreUtils` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M2 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash MCoreUtils MCOREUTILS <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> MCoreUtils` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M4 - autosave Cycle

Origin: 1.5.0 / M4
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run autosave (`SRC_TAG_AUTOSAVE` at `tags/R6-0`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.autosave` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of autosave outside `configure/CONFIG_MODS_DEPS`: siteApps of the site module repository calls `save_restoreSet_*` and `makeAutosaveFileFromDbInfo` and loads `save_restoreStatus.db` at run time from its iocsh fragments and links no module library; it builds on the tree this cycle leaves, in M55, and is not rebuilt here.
- M3 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash autosave AUTOSAVE <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> autosave` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M5 - ether_ip Cycle

Origin: 1.5.0 / M5
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run ether_ip (`SRC_TAG_ETHERIP` at `tags/ether_ip-3-10`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.ether_ip` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of ether_ip outside `configure/CONFIG_MODS_DEPS`: siteApps of the site module repository names `DTYP "EtherIP"` in its database templates and links no module library; it builds on the tree this cycle leaves, in M55, and is not rebuilt here.
- M4 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash ether_ip ETHERIP <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> ether_ip` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M6 - iocStats Cycle

Origin: 1.5.0 / M6
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run iocStats (`SRC_TAG_IOCSTATS` at `tags/4.0.1`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.iocStats` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of iocStats outside `configure/CONFIG_MODS_DEPS`: siteApps of the site module repository loads `iocAdminSoft.db` at run time from `iocStatsAdmin.iocsh` and links no module library (its `ioc_stats.db` is the site's own iocStatsALS, not this module); it builds on the tree this cycle leaves, in M55, and is not rebuilt here.
- M5 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash iocStats IOCSTATS <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> iocStats` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M7 - recsync Cycle

Origin: 1.5.0 / M7
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run recsync (`SRC_TAG_RECSYNC` at `9834b94`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (HOLD, D17); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.recsync` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D17 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of recsync outside `configure/CONFIG_MODS_DEPS`: siteApps of the site module repository loads `reccaster.db` at run time from its iocsh fragments and links no module library; it builds on the tree this cycle leaves, in M55, and is not rebuilt here.
- M6 precedes this work (D3).
- D2 sets the cycle, D17 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash recsync RECSYNC <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> recsync` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M8 - retools Cycle

Origin: 1.5.0 / M8
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run retools (`SRC_TAG_RETOOLS` at `5ada1e1`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.retools` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M7 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash retools RETOOLS <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> retools` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M9 - sequencer Cycle

Origin: 1.5.0 / M9
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run sequencer (`SRC_TAG_SNCSEQ` at `tags/R2-2-9`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.sequencer` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M8 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash sequencer SNCSEQ <candidate>` with `CONF_TARGET=conf.sncseq`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> sequencer` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M10 - snmp Cycle

Origin: 1.5.0 / M10
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run snmp (`SRC_TAG_SNMP` at `tags/v1.1.0.4ja`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.snmp` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M9 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash snmp SNMP <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> snmp` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M11 - opcua Cycle

Origin: 1.5.0 / M11
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run opcua (`SRC_TAG_OPCUA` at `tags/v0.11.2`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.opcua` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M10 precedes this work (D3), and M59 makes the guest update script apply the opcua patches.
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash opcua OPCUA <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> opcua` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M12 - pcas Cycle

Origin: 1.5.0 / M12
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run pcas (`SRC_TAG_PCAS` at `e075fd4`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (HOLD, D16); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.pcas` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D16 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M11 precedes this work (D3).
- D2 sets the cycle, D16 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash pcas PCAS <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> pcas` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M13 - pscdrv Cycle

Origin: 1.5.0 / M13
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run pscdrv (`SRC_TAG_PSCDRV` at `276daca`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.pscdrv` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M12 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash pscdrv PSCDRV <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> pscdrv` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M14 - linStat Cycle

Origin: 1.5.0 / M14
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run linStat (`SRC_TAG_LINSTAT` at `tags/1.2.1`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.linStat` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M13 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash linStat LINSTAT <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> linStat` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M15 - feed-core Cycle

Origin: 1.5.0 / M15
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run feed-core (`SRC_TAG_FEEDCORE` at `0472d88`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.feed-core` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M14 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash feed-core FEEDCORE <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> feed-core` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M16 - sscan Cycle

Origin: 1.5.0 / M16
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run sscan (`SRC_TAG_SSCAN` at `ce9660c`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D7); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.sscan` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D7 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M15 precedes this work (D3).
- D2 sets the cycle, D7 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M10, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash sscan SSCAN <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> sscan` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M17 - calc Cycle

Origin: 1.5.0 / M17
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run calc (`SRC_TAG_CALC` at `tags/R3-8`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D6); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.calc` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D6 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M16 precedes this work (D3).
- D2 sets the cycle, D6 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M11, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash calc CALC <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> calc` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M18 - asyn Cycle

Origin: 1.5.0 / M18
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run asyn (`SRC_TAG_ASYN` at `tags/R4-46`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.asyn` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of asyn outside `configure/CONFIG_MODS_DEPS`: in the site module repository, unidrv names `ASYN` in its `configure/RELEASE` without linking it, and siteApps calls `asynSetOption` at run time from its iocsh fragments; both build on the tree this cycle leaves, in M55 and M56, and neither is rebuilt here. The same holds for the other run-time consumers of siteApps, in the cycles of ether_ip, iocStats, recsync, std, autosave, and caPutLog.
- M17 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash asyn ASYN <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> asyn` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M19 - QPC Cycle

Origin: 1.5.0 / M19
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run QPC (`SRC_TAG_QPC` at `913fad4`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.QPC` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M18 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash QPC QPC <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> QPC` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M20 - modbus Cycle

Origin: 1.5.0 / M20
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run modbus (`SRC_TAG_MODBUS` at `tags/R3-4`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.modbus` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M19 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash modbus MODBUS <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> modbus` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M21 - lua Cycle

Origin: 1.5.0 / M21
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run lua (`SRC_TAG_LUA` at `01aa7a1`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D9); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.lua` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D9 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M20 precedes this work (D3).
- D2 sets the cycle, D9 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M15, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash lua LUA <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> lua` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M22 - std Cycle

Origin: 1.5.0 / M22
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run std (`SRC_TAG_STD` at `27b6967`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D8); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.std` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D8 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of std outside `configure/CONFIG_MODS_DEPS`: siteApps of the site module repository calls `doAfterIocInit` at run time from its iocsh fragments and links no module library; it builds on the tree this cycle leaves, in M55, and is not rebuilt here.
- M21 precedes this work (D3).
- D2 sets the cycle, D8 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M14, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash std STD <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> std` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M23 - StreamDevice Cycle

Origin: 1.5.0 / M23
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run StreamDevice (`SRC_TAG_STREAM` at `tags/2.8.26`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.StreamDevice` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M22 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash StreamDevice STREAM <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> StreamDevice` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M24 - rgamv2 Cycle

Origin: 1.5.0 / M24
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run rgamv2 (`SRC_TAG_RGAMV2` at `27fc633`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.rgamv2` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M23 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash rgamv2 RGAMV2 <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> rgamv2` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M25 - busy Cycle

Origin: 1.5.0 / M25
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run busy (`SRC_TAG_BUSY` at `a4a272d`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D10); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.busy` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D10 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M24 precedes this work (D3).
- D2 sets the cycle, D10 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M12, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash busy BUSY <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> busy` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M26 - scaler Cycle

Origin: 1.5.0 / M26
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run scaler (`SRC_TAG_SCALER` at `baa8e1c`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D11); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.scaler` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D11 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M25 precedes this work (D3).
- D2 sets the cycle, D11 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M13, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash scaler SCALER <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> scaler` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M27 - mca Cycle

Origin: 1.5.0 / M27
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run mca (`SRC_TAG_MCA` at `687d563`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.mca` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M26 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash mca MCA <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> mca` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M28 - measComp Cycle

Origin: 1.5.0 / M28
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run measComp (`SRC_TAG_MEASCOMP` at `c38974e`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (HOLD, D15); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.measComp` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D15 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M27 precedes this work (D3).
- D2 sets the cycle, D15 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash measComp MEASCOMP <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> measComp` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M29 - motor Cycle

Origin: 1.5.0 / M29
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run motor (`SRC_TAG_MOTOR` at `4b22ac9`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D12); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.motor` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D12 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M28 precedes this work (D3).
- D2 sets the cycle, D12 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M16, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash motor MOTOR <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> motor` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M30 - motorMotorSim Cycle

Origin: 1.5.0 / M30
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run motorMotorSim (`SRC_TAG_MOTORSIM` at `tags/R1-3`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.motorMotorSim` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M29 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash motorMotorSim MOTORSIM <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> motorMotorSim` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M31 - pmac Cycle

Origin: 1.5.0 / M31
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run pmac (`SRC_TAG_PMAC` at `2-7-9`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (unchanged, D4: no newer upstream release at the survey); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.pmac` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M30 precedes this work (D3).
- D2 sets the cycle, D4 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash pmac PMAC <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> pmac` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M32 - caPutLog Cycle

Origin: 1.5.0 / M32
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run caPutLog (`SRC_TAG_CAPUTLOG` at `tags/R4.2`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D13); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.caPutLog` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D13 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- The consumers of caPutLog outside `configure/CONFIG_MODS_DEPS`: siteApps of the site module repository calls `caPutLogInit` at run time from its iocsh fragments and links no module library; it builds on the tree this cycle leaves, in M55, and is not rebuilt here.
- M54 precedes this work (D3).
- D2 sets the cycle, D13 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M17, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash caPutLog CAPUTLOG <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> caPutLog` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M33 - pyDevSup Cycle

Origin: 1.5.0 / M33
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run pyDevSup (`SRC_TAG_PYDEVSUP` at `tags/2.1.0`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin and patches stand (IN, D14); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.pyDevSup` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.
- After the closure of M33 and of M50, which uses these guests, the finished notice of the baseline guests of this cycle to the cloud-provision session (D45), since the EPICS-env modules no longer need them.

Out of scope: moving the pin or changing a patch, which D14 and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M32 precedes this work (D3).
- D2 sets the cycle, D14 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.
- The earlier run of this module, f2efff0 M18, is a lead for the plan, not a result of this cycle.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash pyDevSup PYDEVSUP <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> pyDevSup` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M50 - Module Check Tools For The Site Module Repository

Origin: 1.5.0 / M50
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

A module of the site module repository runs the same procedure as an EPICS-env module (D47), but the tools of that procedure work on this repository only: the survey's completeness signal, the `_DEPS` audit of `check.module-deps`, and the guest check scripts under `tools/module-check/`, which take a checkout path already (`guest-roundtrip.bash` takes a parent directory and the repository to clone) but whose defaults and make targets are this repository's (`print-INSTALL_LOCATION_EPICS`, the module targets, the loader suite under `examples/iocsh/tests`). Make each tool take the target repository, so the modules of the site module repository run through them.

##### Scope

- The survey of the site module repository: `git ls-remote --tags` per key, as the repository table names it; `tools/update-release.bash` is not changed.
- `check.module-deps` (`tools/audit_module_deps.bash`): audit the `_DEPS` of a module of a named repository, and record the dependencies of the module sources as the census where the `_DEPS` line is empty.
- `guest-update.bash`, `guest-roundtrip.bash`, and `guest-suite.bash`: work on a named repository's make targets, install location, and checks, beyond the checkout path they already take.
- The site module cell of the repository table in `docs/procedures/module-bump-procedure.md`: name these tools instead of the checks by hand, and the matching item of `docs/procedures/release-checklist.md`.
- The dependency order of the site modules, which D22 names, since their `_DEPS` lines are empty.
- The guest of a site module, written into the repository table: the checkout path in the guest (`/opt/alsu-site-modules-src`), the environment its build sources (`setEpicsEnv.bash` of the tree), the resources and the duration of the request, and whether a set of guests serves one module or the whole repository.
- The build of the site module repository on a guest: who runs its playbook, with the forwarded agent and the proxy it needs as a user other than root.

Out of scope: the modules' own cycles; the first run of the guest check scripts on the guests of the site module repository, which M55 makes.

##### Completion Criteria

- Each tool runs against this repository with the same output as before the change.
- The guest scripts and the `_DEPS` audit run against the site module checkout, the audit recording the source dependencies where the `_DEPS` line is empty, with the same completeness signals as for this repository.
- The repository table names the tools for every repository.

##### Dependencies And Decisions

- D47 sets the principle; this work precedes the site modules (M55 to M56) and the release (M34).
- D54, Decision Date: 2026-10-20, places this work right after M1 and before M2, on the guests of M1; M1 precedes it.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Give the three guest scripts of `tools/module-check/` one more argument, the checkout of the module's repository in the guest; the module's clone, patch, configuration, and build targets run in that checkout, and the install-location query, `check.module-deps`, the loader suite, and `make check.deps` and `make check.env` keep running in the EPICS-env checkout. Without the argument the scripts behave as today.
2. In `guest-update.bash`, when the module's `_DEPS` line is empty, as in the site module repository, record the dependencies that the module sources declare (its `configure/RELEASE` and App Makefiles) as the census in place of the `_DEPS` audit, and print that the audit compared no declaration.
3. Leave `tools/update-release.bash` as it is: the site module repository has no survey tool, and its survey is the `git ls-remote --tags` of the repository table.
4. Write the guest of a site module into the repository table: the checkout path, the environment its build sources, the resources and duration of the request, and that one set of guests serves both site modules.
5. Run T1 to T3, then commit and push before M2 starts (D54).

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | `bash -n` and ShellCheck on every changed tool | Local checkout | No error |
| T2 | EPICS-env parity | Each tool against this repository before and after the change | Local checkout and an EPICS-env guest | The outputs match |
| T3 | Site module survey and audit | The survey and the `_DEPS` audit against the site module checkout | Local checkout of that repository | A complete survey and an audit result for each module; an unanswered remote gives exit 1 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Local checkout | Pending | none |
| T2 | Not run | Local checkout and an EPICS-env guest | Pending | none |
| T3 | Not run | Local checkout | Pending | none |

##### Closure Evidence

- None.

#### M59 - Guest Update Patches

Origin: 1.5.0 / M59
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

`tools/module-check/guest-update.bash` removes a module's source tree and runs the clone target, the configuration target, and the build, but the clone target of `configure/RULES_MODS` only clones and checks out; the module patches are applied only by `make patch` (`configure/RULES_SRC`). A module that carries a patch is then built from unpatched source: opcua, feed-core, QPC, StreamDevice, measComp, and ADCore (D53), the first of them M11; the mca patch applies on Darwin only (`configure/RULES_PATCH`), so no Linux guest applies it. The script also prints the link `modules/<module>`, which is empty for a module whose install name differs, such as sequencer, installed as `seq-2.2.9` and linked as `modules/seq`.

##### Scope

- `tools/module-check/guest-update.bash`: after the clone target, run the patch targets of the module that the `patch:` prerequisite list of `configure/RULES_SRC` names, and print the installed link from the install location of the module.
- The guest section of `docs/procedures/module-bump-procedure.md`: the sentence that describes the script.

Out of scope: the patch files and the patch rules.

##### Completion Criteria

- The script applies the patches of a patched module and records them, and prints the link of sequencer.
- T1 to T3 are Pass, and the change is committed and pushed before M11 starts.

##### Dependencies And Decisions

- D2 and D20 set the module checks this script carries; M11 is the first module that needs it.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the change and review the plan before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Static | `bash -n` and ShellCheck on the script | Local checkout | No error |
| T2 | Patched module | The script on a patched module, such as opcua, on a baseline guest | The Debian 13 guest of this cycle | The `Patching` lines of the module appear, and its source tree carries the patch before the build |
| T3 | Unpatched module and link | The script on sequencer with `CONF_TARGET=conf.sncseq` | The Debian 13 guest of this cycle | No patch line, and the link line names `modules/seq` |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Local checkout | Pending | none |
| T2 | Not run | Debian 13 guest | Pending | none |
| T3 | Not run | Debian 13 guest | Pending | none |

##### Closure Evidence

- None.

#### M51 - ADCore Cycle

Origin: 1.5.0 / M51
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run ADCore (`SRC_TAG_ADCORE` at `ee039d2`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin is the one it carried in its former repository and is unchanged (D4 and D53: the module came to this repository in this release at its former pin); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.ADCore` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4, D53, and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M31 precedes this work (D3), and M59 makes the guest update script apply the ADCore patch, `patch/ADCore-libxml-free.p0.patch` (D53); ADCore is the first module after pmac that carries a patch.
- D2 sets the cycle, D4 and D53 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash ADCore ADCORE <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> ADCore` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M52 - ADSimDetector Cycle

Origin: 1.5.0 / M52
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run ADSimDetector (`SRC_TAG_ADSIMDETECTOR` at `0ef1305`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin is the one it carried in its former repository and is unchanged (D4 and D53: the module came to this repository in this release at its former pin); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.ADSimDetector` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4, D53, and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M51 precedes this work (D3).
- D2 sets the cycle, D4 and D53 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash ADSimDetector ADSIMDETECTOR <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> ADSimDetector` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M53 - ADGenICam Cycle

Origin: 1.5.0 / M53
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run ADGenICam (`SRC_TAG_ADGENICAM` at `ba5b9b8`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin is the one it carried in its former repository and is unchanged (D4 and D53: the module came to this repository in this release at its former pin); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.ADGenICam` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4, D53, and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M52 precedes this work in the order of D3; `ADGenICam_DEPS` names ADCore, not ADSimDetector.
- D2 sets the cycle, D4 and D53 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash ADGenICam ADGENICAM <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> ADGenICam` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M54 - ADVimba Cycle

Origin: 1.5.0 / M54
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run ADVimba (`SRC_TAG_ADVIMBA` at `tags/R1-5`) through the module cycle of `docs/procedures/release-procedure.md` step 6. Its pin is the one it carried in its former repository and is unchanged (D4 and D53: the module came to this repository in this release at its former pin); its build and tests run again at its candidate commit (D2).

##### Scope

- The module issue, the plan review, the plan commit, and the push of the candidate.
- Stage 6 of `docs/procedures/module-bump-procedure.md` from step 2: the module rebuilt from its pin and every module whose `_DEPS` lists `build.ADVimba` rebuilt from clean.
- The results in this detail, the results commit and push with their landing observed, the issue closed on `release-1.5.0`, and the closure commit and push.

Out of scope: moving the pin or changing a patch, which D4, D53, and D2 settle.

##### Completion Criteria

- The plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results are committed and pushed, and the issue is closed on `release-1.5.0`.

##### Dependencies And Decisions

- M53 precedes this work (D3; `ADVimba_DEPS` names ADCore and ADGenICam).
- D2 sets the cycle, D4 and D53 the pin, D18 the cadence, D19 the scope of the checks, D20 the guests, D41 their operating systems, and D43 the issue.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan from the Test Plan below and the census of Stage 3, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | `guest-update.bash ADVimba ADVIMBA <candidate>`, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Patch round trip | `guest-roundtrip.bash <candidate> ADVimba` | Debian 13 guest | `make init`, `make patch`, and `make patch.revert` exit 0 and every source tree is clean after the revert |
| T3 | Consumers | `guest-suite.bash` | Debian 13 and Rocky Linux 8.10 epics-dev guests | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the guest checkout | Debian 13 and Rocky Linux 8.10 epics-dev guests | Both exit 0 |
| T5 | Text agreement | The pin does not move in this cycle, so no file is rewritten | Repository | The row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M55 - siteApps Cycle

Origin: 1.5.0 / M55
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run siteApps (`SRC_TAG_SITEAPPS` at `0.1.0` in the site module repository) through the module cycle of `docs/procedures/release-procedure.md` step 7, the same cycle as an EPICS-env module, run by this session (D22). Its outcome, IN, HOLD, or unchanged, comes from the survey at the start of its cycle; its build and tests run on the guests of the repository table.

##### Scope

- Before this module's first commit: the owner confirms that no other session writes in the site module repository during the cycle; this session opens `release-1.5.0` from master there, as the owner directs, and pushes it with `--set-upstream`, under the owner's Push authority (D22).
- Stages 1 to 5 of `docs/procedures/module-bump-procedure.md`: the survey with the tool of the repository table, the census, the break surface, and the owner's decision, recorded in the Decisions.
- The plan review (a site module has no issue; this register records it), the plan commit, the pin change for an IN outcome, and the push of the candidate.
- The resource request for the guests of this repository (D45): its Follow-up names the EPICS-env build at the tip of `release-1.5.0` on origin and then the playbook of the site module repository at the candidate, run by a user other than root with a forwarded agent and the proxy the site remote needs, as that repository's own README sets out.
- Stage 6 on the guests of the repository table: the module rebuilt from its pin. The `_DEPS` lines of the site module repository are empty, so its dependencies show in the module sources, and the census of Stage 3 reads them there: unidrv names `ASYN` in its `configure/RELEASE` and links no module library, a declaration and not a link; siteApps links no module library and uses seven EPICS-env modules at run time from its iocsh fragments and templates: asyn (`asynSetOption`), caPutLog (`caPutLogInit`), autosave (`save_restoreSet_*`, `makeAutosaveFileFromDbInfo`, `save_restoreStatus.db`), recsync (`reccaster.db`), iocStats (`iocAdminSoft.db` in `iocStatsAdmin.iocsh`; the `ioc_stats.db` of `iocStats.iocsh` belongs to the site's own iocStatsALS), std (`doAfterIocInit`), and ether_ip (`DTYP "EtherIP"` in its templates); its `sys_stats.db` has no provider in either repository; the order of its modules is the one D22 names.
- The results in this detail, the results commit and push with their landing observed, and the closure commit and push.

Out of scope: the modules of the other repositories.

##### Completion Criteria

- The outcome is decided and recorded, and the plan is accepted and its implementation authorized.
- The tools of M50 run on this module's guests, the first run on this repository.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results and the closure are committed and pushed.

##### Dependencies And Decisions

- M33, the last EPICS-env module, precedes this work (D3, D22), and M50 gives the tools of D47.
- D2 sets the cycle, D22 the way a module of another repository runs, D18 the cadence, D19 the scope of the checks, D20 and D41 the guests, D45 their request, D47 the tools, and D51 the status of the site repository's own documents.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan after the survey and the owner's decision, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The same script as the T1 of an EPICS-env module, run on the site module repository, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests of the repository table | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Source trees | `make init` on a fresh clone of the site module repository at the candidate, then `git status --short` in every source tree; the repository carries no `patch/` directory | Debian 13 guest of the repository table | `make init` exits 0 and every source tree is clean |
| T3 | Consumers | The same script as the T3 of an EPICS-env module, run on the repository of the module | Debian 13 and Rocky Linux 8.10 epics-dev guests of the repository table | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the EPICS-env checkout of the guest | Debian 13 and Rocky Linux 8.10 epics-dev guests of the repository table | Both exit 0 |
| T5 | Text agreement | `grep -rn '<old version>'` over the files the update rewrote; none when the pin does not move | Repository | No stale value, or the row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M56 - unidrv Cycle

Origin: 1.5.0 / M56
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Run unidrv (`SRC_TAG_UNIDRV` at `0.5.1` in the site module repository) through the module cycle of `docs/procedures/release-procedure.md` step 7, the same cycle as an EPICS-env module, run by this session (D22). Its outcome, IN, HOLD, or unchanged, comes from the survey at the start of its cycle; its build and tests run on the guests of the repository table.

##### Scope

- Stages 1 to 5 of `docs/procedures/module-bump-procedure.md`: the survey with the tool of the repository table, the census, the break surface, and the owner's decision, recorded in the Decisions.
- The plan review (a site module has no issue; this register records it), the plan commit, the pin change for an IN outcome, and the push of the candidate.
- Stage 6 on the guests of the repository table: the module rebuilt from its pin. The `_DEPS` lines of the site module repository are empty, so its dependencies show in the module sources, and the census of Stage 3 reads them there: unidrv names `ASYN` in its `configure/RELEASE` and links no module library, a declaration and not a link; siteApps links no module library and uses seven EPICS-env modules at run time from its iocsh fragments and templates: asyn (`asynSetOption`), caPutLog (`caPutLogInit`), autosave (`save_restoreSet_*`, `makeAutosaveFileFromDbInfo`, `save_restoreStatus.db`), recsync (`reccaster.db`), iocStats (`iocAdminSoft.db` in `iocStatsAdmin.iocsh`; the `ioc_stats.db` of `iocStats.iocsh` belongs to the site's own iocStatsALS), std (`doAfterIocInit`), and ether_ip (`DTYP "EtherIP"` in its templates); its `sys_stats.db` has no provider in either repository.
- The results in this detail, the results commit and push with their landing observed, and the closure commit and push.

- After the closure, the finished notice of the guests of the site module repository to the cloud-provision session (D45).

Out of scope: the modules of the other repositories.

##### Completion Criteria

- The outcome is decided and recorded, and the plan is accepted and its implementation authorized.
- T1 to T5 are Pass with evidence from the guests named in the Test Plan.
- The results and the closure are committed and pushed.

##### Dependencies And Decisions

- M55 precedes this work (D3, D22).
- D2 sets the cycle, D22 the way a module of another repository runs, D18 the cadence, D19 the scope of the checks, D20 and D41 the guests, D45 their request, D47 the tools, and D51 the status of the site repository's own documents.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan after the survey and the owner's decision, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The same script as the T1 of an EPICS-env module, run on the site module repository, then each dependent from clean | Debian 13 and Rocky Linux 8.10 epics-dev guests of the repository table | Exit 0; the install location, the link, the SONAME of each library, and the loader metadata are recorded; every dependent rebuilds |
| T2 | Source trees | `make init` on a fresh clone of the site module repository at the candidate, then `git status --short` in every source tree; the repository carries no `patch/` directory | Debian 13 guest of the repository table | `make init` exits 0 and every source tree is clean |
| T3 | Consumers | The same script as the T3 of an EPICS-env module, run on the repository of the module | Debian 13 and Rocky Linux 8.10 epics-dev guests of the repository table | The `FAIL` count is 0, and the counts match the suite README except the deviations that the guest section of `docs/procedures/module-bump-procedure.md` names for a guest without Docker or without `/sys/class/hwmon` |
| T4 | Installed tree | `make check.deps` and `make check.env` in the EPICS-env checkout of the guest | Debian 13 and Rocky Linux 8.10 epics-dev guests of the repository table | Both exit 0 |
| T5 | Text agreement | `grep -rn '<old version>'` over the files the update rewrote; none when the pin does not move | Repository | No stale value, or the row records that no file was rewritten |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 | Pending | none |
| T3 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T4 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T5 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

#### M57 - Combined Stack Rehearsal

Origin: 1.5.0 / M57
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Before the tag of the site module repository, build the two repositories together at the two release-line tips and run the installed-tree checks, so a failure that only the combined stack has shows before the tag exists (D21; `docs/procedures/release-procedure.md` step 8).

##### Scope

- A resource request to the cloud-provision session for new Debian 13 and Rocky Linux 8.10 guests (D41, D45), with the Follow-up of the two repositories at their tips: the `epics_build` operator at the EPICS-env tip and the playbook of the site module repository at its tip, each tip a full commit hash read from its remote when the guests are requested.
- `make check.deps` and `make check.env` on the combined tree.
- After the result is recorded, the finished notice of the rehearsal guests (D45).

Out of scope: the per-module checks, which M1 to M33, M51 to M54, M55, and M56 own.

##### Completion Criteria

- T1 and T2 are Pass on both guests, the module count of the passing tree is recorded in this detail, and the result is committed and pushed.

##### Dependencies And Decisions

- M56, the last module of the site module repository, precedes this work; D21 sets it, D41 and D45 its guests.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the plan when the last module of the site module repository closes, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The two repositories built in order at their tips | New Debian 13 and Rocky Linux 8.10 guests | Each repository builds and installs |
| T2 | Installed tree | `make check.deps` and `make check.env` on the combined tree, and the count of the entries of its `modules` directory | The same guests | Both exit 0, and the count is recorded for the inventory check of Release Verification 2 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

#### M58 - Merge And Tag Of The Site Module Repository

Origin: 1.5.0 / M58
Identity History: none
GitHub Issue: none
Status: Not started

##### Summary

Merge the `release-1.5.0` line of the site module repository into master, tag the merge `1.5.0`, and push, before the EPICS-env release (D22; `docs/procedures/release-procedure.md` step 9).

##### Scope

- In the site module repository: the local master brought to its remote, the merge with the subject form of that repository's last release merge, the tree check of the merge against the commit M57 built, the annotated tag on the merge commit, and the push of master and of the tag as separate rows, each under its own authority (`git-workflow`).
- If its `release-1.5.0` holds no commit beyond master, it is not merged (D49): the annotated tag goes on the master commit that M57 built, with the same push and observation rows.
- The tag message in the form of that repository's last release tag.
- The observation of its line and tag on its remote.

Out of scope: the EPICS-env merge, tag, and release, which M34 owns.

##### Completion Criteria

- T1 and T2 are Pass, and the result is committed and pushed.

##### Dependencies And Decisions

- M57 precedes this work; D22 sets it, and D49 the case of a repository with no new commit.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Draft the command list when M57 closes, and review it before acceptance.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Merge tree | `git diff --stat` between the merge commit and the commit M57 built | The checkout of the site module repository | No difference, or documentation files only (the files under `docs/`, README files, and the change log) |
| T2 | Remote | `git ls-remote` of master and of the tag, with the peeled tag | The remote of the site module repository | Master is the merge commit, or the built commit when nothing was merged (D49), and the tag peels to it |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Checkout of the site module repository | Pending | none |
| T2 | Not run | Remote of the site module repository | Pending | none |

##### Closure Evidence

- None.

#### M34 - Release EPICS-env 1.5.0

Origin: 1.5.0 / M34
Identity History: none
GitHub Issue: #100, https://github.com/jeonghanlee/EPICS-env/issues/100
Status: Not started

##### Summary

Release EPICS-env 1.5.0 from `release-1.5.0`: re-run the checks that later module changes invalidate against the final combined tree, run the production environment tests, confirm the version fields, execute the release actions in the recorded order with separate authority each, verify the released objects, and close the cycle. The version field was set at branch open (8a603bb), so release readiness checks that commit and adds no version commit.

##### Scope

- Integrated re-runs of the module checks on the final combined tree, as the Integrated Verification table maps them.
- The production environment tests of the two products: the six OS workflows, the public gz build on six OS, and the internal build with the site modules and the alliocs consumer check on three OS, through the environment pipeline procedure.
- The `ChangeLog.md` 1.5.0 entry, the README and book paths naming 1.5.0, the release-note draft, and the readiness-evidence commit that is the release candidate.
- The release execution rows and their checkpoint commits, the released-tag installation, the tracker reconciliation, and the next-line record.

Out of scope: the ship runs into the two distribution repositories, which follow the pipeline's distribution procedure after the tag exists and are not part of this milestone's completion; the content of the module cycles, which M1 to M33 and M51 to M56 own.

##### Completion Criteria

- Every non-final Milestone row is Complete or has an owner-approved assignment transfer.
- Every Release Verification row is Pass with reachable real-path evidence.
- The merge commit, annotated tag, GitHub release, and milestone closure exist with their identifiers recorded, and the next release line's canonical path or the master generation register is recorded.

##### Dependencies And Decisions

- M1 to M33 and M50 to M59 precede this work.
- D3 fixes the cycle order, D18 the verification cadence, D48 the commit that the merge takes, D50 the branch that is deleted, and D52 the reading position of this register once closed.
- `docs/procedures/release-procedure.md` is the entry that orders this release; the executed 1.4.0 sequence is its precedent (`docs/milestone-1.4.0.md` at `84ee626`, its M11).

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. After the last module cycle, record the combined-tree comparison from each module's tested commit to the candidate tip and run the Integrated Verification re-runs (Release Verification 1 to 6).
2. Confirm the version field against 8a603bb (Release Verification 7); update the README and book paths that name the release and add the `ChangeLog.md` 1.5.0 entry in the format of the 1.4.0 entry, dated to the day of the merge and tag (Release Verification 12), as separately authorized commits.
3. Run the production environment tests of both products on the candidate (Release Verification 2, 3) by the gates of the environment pipeline (`verification.md`, and `layer3.md` for the internal product), and the released-tag installation after the tag exists (Release Verification 10), after the storage preflight of the release-cycle procedure.
4. Make the readiness-evidence commit, the release candidate; the rule for a later commit is step 10 of `docs/procedures/release-procedure.md`.
5. Execute the Release Execution rows in order, each after its own preview, preflight, and authority, with a checkpoint commit after each release-object or remote-state mutation.
6. Run the post-release Release Verification rows (8 to 11; 12 is post-change and runs with step 2), prepare the closure record, reconcile the GitHub milestone and linked issues, and make the closure commit on master.

###### Checkpoint And Object Identity Rule

Before each release mutation, resolve its exact target and show the exact command with the applicable authority. After each release-object or remote-state mutation, observe the result, record it in this document, run the repository checks, and make a separately authorized checkpoint commit before any dependent action. Before the merge, checkpoint commits advance `release-1.5.0`; after the merge, they advance `master`. Every tag operation names the captured merge SHA, never the current HEAD. Before each push, capture the reviewed local tip; afterwards require the observed remote tip to equal it.

##### Integrated Verification

| Source Check | Re-run Trigger | Shared Surface | Release Verification Label | Expected Result | Result Evidence |
| --- | --- | --- | --- | --- | --- |
| M1 to M33 and M51 to M54 / T1 | Any later module cycle changes the combined source and the installed library set | The whole module build, install, and dependency resolution | Release Verification 1 | All six OS workflows and the Linter succeed at the candidate | pending |
| M1 to M33 and M51 to M54 / T2 | Any change to `patch/` or to a pinned source after the module's cycle | The shipped patch and reverse-patch aggregates | Release Verification 4 | Round trip clean on a fresh checkout at the candidate | pending |
| M1 to M33 and M51 to M54 / T3 | The installed library set and loader metadata differ from the recorded module environment | The installed loader, its metadata, and the module libraries it loads | Release Verification 5 | The loader verification suite passes on the final combined tree | pending |
| `docs/procedures/commonIocsh-verification-procedure.md` | The installed caPutLog, base, or fragment set differ from the recorded environment | The commonIocsh fragments and their consumer IOC | Release Verification 6 | The commonIocsh fragment suite passes on the final combined tree | pending |
| M1 to M33 and M51 to M56 / T1, T4 | Later module cycles relink the dependents again | The dependents rebuilt from clean and the fixture IOCs | Release Verification 2 | Gates 1 to 7, `check_deps`, and the alliocs consumer check pass on the internal product | pending |

##### Production Environment Tests

| Release Verification Label | Timing | System | Version | Architecture | Deployment Path | Method | Expected Result | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Release Verification 1 | post-change | Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04, Ubuntu 26.04 (CI) | 1.5.0 | linux-x86_64 | Each workflow's configured install tree | The six OS workflows and the Linter at the candidate commit | All succeed | run URLs, pending |
| Release Verification 2 | post-change | Debian 12, Debian 13, Rocky Linux 8.10 (internal product) | 1.5.0 | linux-x86_64 | `/opt/epics/1.5.0/<os>/7.0.10/` on fresh guests | Pipeline Stage 1 with the two repositories at the derived selectors, Gates 1 to 7, `check_deps`, alliocs | Every gate passes, with the inventory count equal to the count that M57 recorded; every consumer builds | pending |
| Release Verification 3 | post-change | Debian 12, Debian 13, Rocky Linux 8, Rocky Linux 10, Ubuntu 24.04, Ubuntu 26.04 (public gz product) | 1.5.0 | linux-x86_64 | Fresh gz install tree per OS | `make build.gz`, install, `make check.deps`, `make check.env` through the pipeline | `check.deps` and `check.env` exit 0 on every OS | pending |
| Release Verification 10 | post-release | Debian 13, fresh production-equivalent host | 1.5.0 | linux-x86_64 | `$HOME/epics/1.5.0/debian-13/7.0.10` | The released `README.md` Prerequisites and Getting Started path from the `1.5.0` tag, then `make check.env`, `make check.deps`, and a started `softIoc`, after the storage preflight | Build, install, and checks succeed and the IOC starts | pending |

##### Version Changes

| Field | File | Before | Planned After | Pre-check | Pre-check Label | Post-check | Post-check Label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `ENV_RELEASE_VERS` | `configure/CONFIG_SITE` | 1.4.0 (origin/master 4d521e7) | 1.5.0, applied at branch open in 8a603bb | Inspect `8a603bb^` and the one-line diff of `8a603bb` | Release Verification 7 | Read the candidate `configure/CONFIG_SITE` and the installed path of Release Verification 2 and 10 | Release Verification 8 |

##### Release Execution

| Step | Action | Authorization | Expected Result | Evidence |
| --- | --- | --- | --- | --- |
| 1 | Readiness-evidence commit on `release-1.5.0` (the release candidate) | Commit/add scope | Full candidate SHA recorded | pending |
| 2 | Push `release-1.5.0` | Push scope | Remote tip equals the reviewed local tip and contains the candidate | pending |
| 3 | Local `master` fast-forward to `origin/master` | Explicit Sync scope | `master` current; `git rev-list --count release-1.5.0..master` prints 0 | pending |
| 4 | `--no-ff` merge of the recorded tip of `release-1.5.0` after its last pre-merge checkpoint (D48) into `master`, subject `Merge release-1.5.0: EPICS Environment 1.5.0` | Release scope, previewed | Merge SHA observed and checkpointed | pending |
| 5 | Annotated tag `1.5.0` naming the merge SHA, message `EPICS Environment 1.5.0` | Release scope, previewed | Tag object and peeled commit observed and checkpointed | pending |
| 6 | Push `master` | Push scope | Remote tip equals the reviewed local tip and contains the merge | pending |
| 7 | Push `refs/tags/1.5.0` | Tag push scope | Remote tag object and peeled commit match | pending |
| 8 | GitHub release `1.5.0` from `work/release-notes-1.5.0.md` | Release scope, previewed | Published, not prerelease, Latest; ID, URL, and time recorded | pending |
| 9 | After the release objects exist, delete `release-1.3.0` locally and on origin (D50) | User-run | Deletion or observed absence recorded | pending |
| 10 | Close the release issue #100 by hand, after the release objects exist, not on the release branch as a module issue is: body synced with checked acceptance items, closing comment, close, and its closed state read back | Issue scope | Closed state observed | pending |
| 11 | GitHub milestone 7 close | Release scope, previewed | Closed with zero open items | pending |
| 12 | Checkpoint and closure commits on `master` | Commit/add scope | Each recorded identifier committed before the next dependent action | pending |
| 13 | Final `master` push | Push scope | Remote tip equals the closure commit | pending |
| 14 | Reset this register into the master generation `docs/milestone-<hash>.md`; the next release line opens later, by a separate dated decision | Commit/add scope, under the Reset procedure of `milestone-tracking` | The next canonical path exists and this register's entry point names it | pending |

Plan acceptance does not authorize any execution row. Immediately before each delegated action, re-show its exact command and complete the matching preflight.

##### Release Verification Plan

| Label | Layer | Timing | Method | Environment | Expected Result | Evidence Target |
| --- | --- | --- | --- | --- | --- | --- |
| Release Verification 1 | CI | post-change | The six OS workflows and the Linter at the candidate commit | GitHub Actions | All succeed | Run URLs |
| Release Verification 2 | Internal product | post-change | Pipeline Stage 1, the two repositories, Gates 1 to 7, `check_deps`, alliocs | Debian 12, Debian 13, Rocky Linux 8.10 guests | Every gate and consumer passes, and the inventory count equals the count that M57 recorded | `work/release-1.5.0-verification/` evidence tree |
| Release Verification 3 | Public product | post-change | gz build, install, `check.deps`, `check.env` | Six OS guests | Exit 0 on every OS | Same evidence tree |
| Release Verification 4 | Patch set | post-change | `make init`, `make patch`, `make patch.revert`, tree comparison on a fresh checkout | Debian 13 | Every source tree pristine after the revert | Same evidence tree |
| Release Verification 5 | Loader | post-change | The loader verification suite on the combined tree | Debian 13 and Rocky Linux 8.10 | Every check passes | Same evidence tree |
| Release Verification 6 | Fragments | post-change | The commonIocsh fragment suite on the combined tree | Debian 13 and Rocky Linux 8.10 | Every assertion passes | Same evidence tree |
| Release Verification 7 | Version | pre-change | Inspect `8a603bb^` and the diff of `8a603bb` | Repository | Before 1.4.0, after 1.5.0, one line changed | Commit identity |
| Release Verification 8 | Version | post-release | Read the candidate `configure/CONFIG_SITE` and the installed paths of Release Verification 2 and 10 | Repository and installed trees | Every path names 1.5.0 | Observed paths |
| Release Verification 9 | Release objects | post-release | Resolve the remote tag to its peeled commit and read the GitHub release flags | GitHub | Tag peels to the recorded merge; release published, not prerelease, Latest | Identifiers |
| Release Verification 10 | Installation | post-release | The released-tag installation method | Fresh Debian 13 host | Build, install, checks, and IOC start succeed | Evidence tree and run id |
| Release Verification 11 | Tracker | post-release | Read GitHub milestone 7 and every linked issue | GitHub | Milestone closed with zero open items; every linked issue matches its projection | Observed metadata |
| Release Verification 12 | Documentation | post-change | Read `ChangeLog.md`, `README.md`, and the book pages that name the release against the candidate | Repository | The 1.5.0 entry is dated to the tag day and every named path reads 1.5.0 | Commit identity |

##### Release Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| Release Verification 1 | Not run | GitHub Actions | Pending | none |
| Release Verification 2 | Not run | Internal product guests | Pending | none |
| Release Verification 3 | Not run | Public product guests | Pending | none |
| Release Verification 4 | Not run | Debian 13 | Pending | none |
| Release Verification 5 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| Release Verification 6 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| Release Verification 7 | Not run | Repository | Pending | none |
| Release Verification 8 | Not run | Repository and installed trees | Pending | none |
| Release Verification 9 | Not run | GitHub | Pending | none |
| Release Verification 10 | Not run | Fresh Debian 13 host | Pending | none |
| Release Verification 11 | Not run | GitHub | Pending | none |
| Release Verification 12 | Not run | Repository | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Verify and publish EPICS-env 1.5.0
Labels: enhancement
GitHub Milestone: 1.5.0
Observed State: open
Observed Labels: enhancement
Observed Milestone: 1.5.0
Last Compared: 2026-10-11; remote updated 2026-10-11T17:56:33Z

## Backlog

### Work

| Group | ID | Work unit | Type | Status | Ready | Deps | Done when / Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| makeRPath | M35 | Build EPICS::Path Normalize/RelPath primitives for makeRPath upstream | Milestone | Deferred | No | D23, D33 | EPICS base ships `Normalize` and `RelPath` in `EPICS::Path` and a Perl `makeRPath` that consumes them, and this repository adopts that release at a pin bump; [detail](#m35---epicspath-normalizerelpath) |
| IOC shell | M36 | Promote commonIocsh to its public module repository | Milestone | Deferred | No | D24, D25 | The `commonIocsh` fragments move to a dedicated public repository, pinned like every other module and consumed through `IOCSH_TOP`, with EPICS-env's `configure/RELEASE` pinning it and the interim in-tree copy removed; [detail](#m36---commoniocsh-promotion) |
| IOC shell | M37 | Ship a global iocsh startup file for the common services | Milestone | Deferred | No | D26 | `commonIocsh/iocsh/` ships one global startup file that loads the common-service fragments with optional serial configuration, and an example IOC boots with only that file; [detail](#m37---global-iocsh-startup-file) |
| Libera | M38 | Verify the Libera cross-build and generated profile | Milestone | Deferred | No | D27 | Real nine-module cross-build, generated-profile repetition, and documentation comparison pass; [detail](#m38---libera-cross-build-and-generated-profile) |
| macOS | M39 | Verify patch revert on actual macOS | Milestone | Deferred | No | D28 | Real macOS patch-revert cases pass with the Darwin mca path active, recorded patch executable, and preserved failure-boundary inventories; [detail](#m39---macos-patch-revert-verification) |
| Runtime | M40 | Verify the original opcua-IOC-demo startup against the Unified Automation example server | Milestone | Deferred | No | D29 | With `uaservercpp` running, the original `examples/iocsh/opcua-IOC-demo/st.cmd` reads its `Demo` records without alarm on Debian 13 and Rocky Linux 8.10; [detail](#m40---original-opcua-startup-data-path) |
| Upstream | M41 | Report the two Base site patches to the upstream EPICS base repository | Milestone | Deferred | No | D30 | One upstream issue or pull request each for the parser crash at end of input and the field-name suggestion crash, filed by the owner, with the site patches kept until an upstream release contains the fixes; [detail](#m41---upstream-report-of-the-base-site-patches) |
| Procedures | M42 | Reconcile the release-procedure records into one procedure | Milestone | In progress | No | D31, D39, D40 | Each listed discrepancy between this repository's documents and the owner's release, milestone, git, and environment-pipeline procedures is resolved or recorded as a closed door, and the documents agree with the 1.5.0 release as executed; [detail](#m42---release-procedure-reconciliation) |
| opcua | M43 | Make Eclipse Milo the default server of the OPC UA loader example | Milestone | Deferred | No | D32 | The documented default example prepares and connects with a reproducible Milo server image on Debian 13 and Rocky Linux 8.10, IOC and server restart cases have observed results, and the fixture README, book pages, and shipped suite agree; [detail](#m43---milo-opc-ua-example-server) |
| Modules | M44 | Migrate IOC record publishing from the recsync client to the reccaster repository | Milestone | Deferred | No | D17 | `configure/RELEASE` names the reccaster repository, the `recsync-src/client` special case is gone, the module builds and installs as `reccaster`, and the commonIocsh reccaster fragment publishes records to a running recceiver; [detail](#m44---reccaster-migration) |
| Loader | M45 | Count only records in the loader suite's minimal example | Milestone | Deferred | No | D34 | `verify_minimal_example.bash` reports the record count on a guest without hwmon and the suite README names the hwmon lines; [detail](#m45---loader-suite-record-count) |
| Procedure | M46 | Collect the lessons of the 1.5.0 cycle for the skills repository and the procedure reconciliation | Milestone | Deferred | No | D35 | Every listed lesson has landed in its destination or been handed to its owning session with the reply recorded; [detail](#m46---lessons-of-the-150-cycle) |
| lua | M47 | Stop dbLoadRecords from crashing an IOC that loads lua without a macros argument | Milestone | Deferred | No | D36 | An IOC with lua loaded runs `dbLoadRecords` with the file name alone and reaches `iocInit` on both incremental guests, through a fix in upstream lua or a carried patch; [detail](#m47---lua-database-hook-crash) |
| Loader | M48 | Decide how installed shared libraries identify their version | Milestone | Deferred | No | D37, M35 | A dated decision sets the RUNPATH naming rule, the `SONAME` and ABI name rule, and the reporting of a link by the check tools, and a design review of the long-term operation and security of the library resolution is recorded; [detail](#m48---shared-library-version-identification) |
| Loader | M49 | Load pyDevSup into a plain IOC through the loader | Milestone | Deferred | No | D38, M48 | An IOC started through `iocsh.bash` with `module pyDevSup` processes a Python device-support record on both incremental guests without `softIocPy`, and the relocated-tree check passes; [detail](#m49---pydevsup-in-a-plain-ioc) |

### Backlog Details

#### M35 - EPICS::Path Normalize/RelPath

Origin: 1.5.0 / M35
Identity History: none
GitHub Issue: #25, https://github.com/jeonghanlee/EPICS-env/issues/25
Status: Deferred

##### Summary

`makeRPath` computes relocatable `$ORIGIN`-relative rpath entries. Removing its bare-`python` dependency (the fragility behind #18) requires re-implementing in Perl the lexical path algebra Python's `os.path` provides as primitives; the earlier straight port (upstream PR #589) regressed at exactly this point and was reverted. The proper fix builds the missing primitive once in the shared module and has `makeRPath` consume it.

##### Scope

Additive extension of `src/tools/EPICS/Path.pm`, leaving `AbsPath` untouched: `Normalize($path)` (lexical, no-stat normalization of `.`, `..`, `//`, trailing slash) and `RelPath($target, $base)` (Normalize both, then relativize). The missing operation is lexical `..` collapse without `stat`: `File::Spec->abs2rel` does not normalize embedded `..`, `canonpath` does not collapse `..`, and `Cwd::abs_path` / `EPICS::Path::AbsPath` collapse `..` only by touching the filesystem, unusable for a not-yet-existing `--final` path. Full edge catalog: `docs/makeRPath-perl-port/relpath-design-analysis.md` at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the file is not on `master`.

Delivery (D33): an upstream epics-base submission that adds the primitives and `src/tools/makeRPath.pl`, removes `src/tools/makeRPath.py`, and repoints `MAKERPATH` in `configure/CONFIG_BASE` and the script entry in `src/tools/Makefile`; this repository adopts the result when a Base release that carries it is pinned. The local-patch delivery of D23 is superseded.

Out of scope: a straight port that hand-rolls the algebra inside the leaf tool.

##### Completion Criteria

- `makeRPath` consumes the shared `Normalize`/`RelPath` primitives.
- `AbsPath` is unchanged.
- The reverted straight-port regression does not recur on the edge catalog.

##### Dependencies And Decisions

- D23, Decision Date: 2026-10-02, assigned this work to the Milestone as a local patch on the pinned EPICS base; D33, Decision Date: 2026-10-11, moves it to the Backlog and supersedes that delivery with an upstream submission. A new dated decision assigns it again.
- The EPICS-env build runs `makeRPath.py` under `python3` through `configure/RULES_BASE` and requires `python3` for its own configuration (`configure/CONFIG_MODS`), so no prerequisite of this repository depends on this work.
- Existing artifacts: the corrected port, the 37-case parity driver, the test plan, and the upstream issue body under `docs/design/makeRPath-perl-port/`; the edge catalog and the API proposal at commit `e6a0ee8` on `origin/feature/epics-path-relpath`; the reverted upstream baseline and an unrun soak wiring on the same branch, which D33 does not keep.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Carry the edge catalog and the API proposal from the feature branch into `docs/design/makeRPath-perl-port/` with the two specification decisions of D33 recorded.
2. In a fork of epics-base at the pinned tag, add `Normalize` and `RelPath` to `src/tools/EPICS/Path.pm` with POD and a test under `src/tools/test/`, add `src/tools/makeRPath.pl` built on the corrected port, remove `src/tools/makeRPath.py`, and repoint `MAKERPATH` and the install entry.
3. Run T1 and T2 on the fork; open the upstream issue from the prepared body, then the pull request.
4. When a Base release carries the change, adopt it through the module bump procedure; until then nothing in this repository changes.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Path algebra | Run the 37-case parity driver `docs/design/makeRPath-perl-port/compare_makeRPath.sh` and the edge catalog cases against the fork's `makeRPath.pl` | Fork checkout with the pinned `makeRPath.py` as the reference | Every parity case matches the Python output byte for byte; every catalog case matches its specified result with no `stat` |
| T2 | Build | Build and install EPICS base from the fork and from the pinned tag into two roots on the same host; compare the `readelf -d` RUNPATH entries of every installed ELF object | Debian 13 and Rocky Linux 8.10 | The two RUNPATH sets are identical and `make check.deps` exits 0 on both trees |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Fork checkout | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Build EPICS::Path Normalize/RelPath primitives for makeRPath
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-11; remote updated 2026-10-11T17:56:27Z

#### M36 - commonIocsh Promotion

Origin: 1.5.0 / M36
Identity History: none
GitHub Issue: #76, https://github.com/jeonghanlee/EPICS-env/issues/76
Status: Deferred

##### Summary

The `commonIocsh` fragments and the global iocsh are developed and held in EPICS-env since the 1.4.0 fragment work (1.4.0 M6; D24 interim home). Their durable home is a dedicated public module named `commonIocsh` with its own repository, pinned like every other module and installed under `modules/commonIocsh/iocsh/`, reached by an IOC through `IOCSH_TOP` (D24). The 1.4.0 verification is complete on the interim home (T1/T2/T3 on Debian 13 and Rocky Linux 8.10); the promotion itself is deferred to this item per D25.

##### Scope

- Create the public `commonIocsh` repository from the interim in-tree fragments, preserving the `iocsh/` layout.
- Pin `commonIocsh` in EPICS-env's `configure/RELEASE` like every other module and install it under `modules/commonIocsh/`.
- Remove the interim in-tree copy from EPICS-env once the pinned module builds and installs.

Out of scope: any change to the fragment behavior verified under 1.4.0 M6; the `siteApps` de-duplication (84ee626 D3), which is the site owner's.

##### Completion Criteria

- The `commonIocsh` public repository exists and carries the verified fragments.
- EPICS-env pins `commonIocsh` in `configure/RELEASE` and installs it under `modules/commonIocsh/iocsh/`, resolved through `IOCSH_TOP`.
- The interim in-tree fragments are removed, and the installed-path checks (T1/T2/T3 of 1.4.0 M6) still pass on the two OS targets against the pinned module.

##### Dependencies And Decisions

- D24 sets the durable home: a dedicated public `commonIocsh` module, pinned and reached through `IOCSH_TOP`.
- D25 defers the promotion from the 1.4.0 fragment work to this Backlog item.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Create the public `commonIocsh` repository from the interim fragments, preserving the `iocsh/` layout.
2. Pin it in `configure/RELEASE` and build and install it under `modules/commonIocsh/`.
3. Remove the interim in-tree copy from EPICS-env.
4. Re-run the installed-path checks against the pinned module on the two OS targets.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Pinned-module install | Pin and install `commonIocsh`, remove the interim copy, and run the installed-path suite against the pinned module | Target-OS VMs (Debian 13, Rocky Linux 8.10) | The suite passes against the pinned module with no interim in-tree copy present |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Target-OS VMs | Pending | none |

##### Closure Evidence

- None; deferred to the Backlog per D25.

##### GitHub Projection

Title: Promote commonIocsh to its public module repository
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-21

#### M37 - Global iocsh Startup File

Origin: 1.5.0 / M37
Identity History: none
GitHub Issue: #79, https://github.com/jeonghanlee/EPICS-env/issues/79
Status: Deferred

##### Summary

The 1.4.0 fragment work (1.4.0 M6) shipped the `commonIocsh` fragment set and verified the services loading together in one IOC, but no single global iocsh file ships, and the example IOC exercises only the caPutLog fragment (`examples/commonIocsh/README.md`). D26 deferred the global startup file here.

##### Scope

- Add one global startup file under `commonIocsh/iocsh/` that loads the common-service fragments, with the optional IOC-owned serial configuration file of the 1.4.0 design (84ee626 D4 and 84ee626 D5).
- Make the example IOC boot with only that file for the common services.

Out of scope: changes to the individual fragments verified under 1.4.0 M6, and the D24 promotion tracked as M36.

##### Completion Criteria

- The global startup file loads the common services in one call and applies serial settings only when serial configuration is supplied.
- The example IOC passes the integrated checks using only the global startup file for the common services, on Debian 13 and Rocky Linux 8.10.

##### Dependencies And Decisions

- D26 defers the global startup file from the 1.4.0 fragment work to this item.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Compose the global startup file from the fragment order that `examples/commonIocsh/tests/verify_integrated.sh` already verifies.
2. Point the example IOC at it and rerun the integrated, installed-path, and isolated-path checks.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Global startup | Boot the example IOC with only the global startup file; run the integrated assertions with serial absent and present | Debian 13 and Rocky Linux 8.10 VMs | Every service's assertions pass with no duplicate records |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 VMs | Pending | none |

##### Closure Evidence

- None.

##### GitHub Projection

Title: Ship a global iocsh startup file for the common services
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-09-25

#### M38 - Libera Cross-Build And Generated Profile

Origin: 1.5.0 / M38
Identity History: none
GitHub Issue: none; #87 is the historical source of the Libera requirements and remains linked to the environment-script work (84ee626 M14)
Status: Deferred

##### Summary

The Libera module script uses the current sequencer targets in published commit `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f`. Its actual cross-build, generated-profile repetition, and documentation comparison require a real compiler, sysroot, and installed host/ARM base. These checks were separated from the native environment-script work on 2026-09-30 (D27), with the original acceptance, implementation, and verification evidence of that work retained, and the original #87 Libera requirements retained here on 2026-10-01.

##### Scope

- Preserve the published `scripts/build_modules_libera.bash` identifier correction from `sequencer-2-2` to `sequencer`, with `seq` as the installed link name.
- Retain the original #87 requirement to verify the obsolete target correction through actual `build_modules_libera.bash` execution against the real installed tree and current make targets; T1 owns that execution.
- Verify the real nine-module cross-build, installed profile, and repeated setup/reset using that profile.
- Maintain `docs/libera-cross-build.md` as the separate functional reference and verification requirements, linked from `scripts/README.md`.

Out of scope: relocation of either Libera script; changes to `build_base_libera.bash`, compiler or sysroot, module pins, configuration rules, or target-board `/opt` mapping; the completion of the native environment-script work; target-board runtime verification.

##### Completion Criteria

1. The real module script completes all nine build/install/symlink sequences, including current sequencer targets, and `modules/seq` resolves to the installed sequencer directory.
2. The actual installed profile has mode 0444 and nine target-board library paths independently derived from real make locations and the existing `/opt` mapping.
3. Repeated installed setup with the generated profile preserves directory order and retains each profile directory and the base library once. Unrelated library fields retain their bytes, duplicates, order, and empty fields. Reset removes the base library entry and retains the profile entries.
4. The dedicated reference agrees with actual prompts, module order, targets, links, profile bytes, and installation mode. All three actual checks pass; target queries, native products, or an invented profile do not count.

##### Dependencies And Decisions

- D27, Decision Date: 2026-09-30, excludes the Libera checks from the completion of the environment-script work and retains them as Deferred Backlog work. The selected extraction separates the document and preserves both script paths. Resume requires a new execution decision; no cross-build pass or Keep is inferred.
- Decision Date: 2026-10-01; retain only #87's Libera items here. Keep #87 as the native setup/reset issue linked to 84ee626 M14; its closure does not complete, retire, or authorize execution of any M38 check.
- Actual verification requires the real `arm-xilinx-linux-gnueabi` compiler and target sysroot selected by the shipped site file, and installed base products for both `linux-x86_64` and `linux-arm`.
- The configured compiler was absent when inspected on 2026-09-30. This is an unavailable preparation input, not a verification pass.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-09-30; retains the Libera requirements of the accepted combined environment-script plan (84ee626 M14); D27 authorizes their extraction without changing the requirements
Implementation Authorization: 2026-09-30; the original combined implementation authority covered the identifier correction; actual Libera execution is subsequently deferred by D27
Superseded Plan Artifacts: `work/m14-implementation-20260930/before-libera-extraction.md` retains the original combined plan and observations

1. Preserve the implemented identifier correction, other module order, prompt, configuration calls, `seq` mapping, and library-profile policy. Preserve existing setup profile loading and reset cleanup scope. No further code change follows from extraction.
2. Upon a new execution decision, prepare the real isolated compiler/sysroot/base environment according to the dedicated reference's cross-base requirements. Use shipped init, patch, conf, build, and install targets and the unchanged cross site file; inspect effective architecture, GNU target/directory, and installed host/ARM ELF products before the module run.
3. Execute the actual module script, then use its actual installed profile for repeated setup/reset. Compare the dedicated document with the observed outputs and retain statuses, versions, pins, hashes, argv, stdout, stderr, modes, and timestamps under ignored `work/`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Cross-build | Inspect generated targets, then run the actual `build_modules_libera.bash` through configuration, every build/install/symlink call, and final profile install; use a real PTY and wait for the prompt before confirmation | Isolated checkout, HOME, and install root; real compiler/sysroot; real host and ARM base; pinned module sources | Script and all nested operations return 0; nine module sequences run; current sequencer targets and seq link match; host/ARM ELF products and profile bytes/mode match independently checked real make locations |
| T2 | Generated profile | Source T1's actual installed setup twice in fresh Bash children with nounset on and off; compare each library field independently; source actual installed reset | Actual T1 installation and profile; unrelated fields include duplicates, spaces, literal special characters, and leading/middle/trailing empty fields | Each of the nine profile directories occurs once in generated order; base library occurs once; unrelated fields retain exact bytes and structure; reset removes only the known base library entry and retains profile entries |
| T3 | Documentation | Read the dedicated reference and README link against the actual T1/T2 prompts, targets, links, generated profile, and modes | Same real cross-build installation and candidate docs | Document matches the observed execution; no native or host result is described as target-board runtime verification |

No internal span can be replaced by a stub, fake make, invented base tree, or manually written profile. Only the outer environment, filesystem availability, and download transport can be controlled. A timeout, incomplete run, or missing input is not a pass. Never run Libera initialization against the owner's working checkout or installation.

##### Plan Review Evidence

The following premise observations come from the accepted combined environment-script plan (84ee626 M14) at baseline `e1e2df3f266fed6f658a0beca7da7af1f06e81dc`. Their original T labels refer to that combined plan: original 84ee626 M14 / T7 maps to M38 / T1, its T3 profile case maps to M38 / T2, and its T8 Libera comparison maps to M38 / T3.

| Class | Scope Clause | Observed Evidence | Original Plan Consequence |
| --- | --- | --- | --- |
| Confirmed finding | Sequencer target/link identity | The real make query returned build.sequencer and symlink.sequencer, with no build.sequencer-2-2; CONFIG_VARS and RULES_FUNC map its installed name to seq | Change the build identifier while retaining seq; require the real T7 script run |
| Hypothesis / preparation requirement | Libera integration feasibility | The configured cross compiler is absent on this host; a complete current Libera build has not run | Check a real compiler/sysroot/base environment before T7; do not infer cross-build success from native target inspection |
| Confirmed finding | Cross-base preparation | `configure/CONFIG_BASE` defaults both cross architecture variables to empty; `conf.base.site` writes the selected target architecture but does not copy the Libera OS site file. The existing `build_base_libera.bash` separately sets the architectures and copies that file | T7 preparation names the isolated local settings, unchanged file copy, effective configuration checks, and actual host/ARM base products |
| Hypothesis / required coverage | Libera profile repetition | Setup passes the profile's entire colon-separated library list to `set_variable`; the Libera script generates that list from make locations. No candidate profile repetition has run, so a duplicate regression after changing field comparison is unverified | T3 uses T7's real installed profile and setup, and independently checks each directory's count and order after both source calls |

The original case matrix and preparation details are preserved in `work/m14-implementation-20260930/before-libera-extraction.md`. Their functional requirements are extracted into `docs/libera-cross-build.md`. Premise inputs and observations remain in `work/m14-plan-20260930/baseline.json`.

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-09-30 | Real Libera compiler/sysroot unavailable | Pending: current sequencer targets and native seq mapping were inspected; no actual Libera script or cross-build pass is claimed | `work/m14-implementation-20260930/verification-summary.json`, `target-query.stdout`, and D27 |
| T2 | Not run; deferred on 2026-09-30 | Actual cross-build installation and generated profile unavailable | Pending: native path cases do not verify actual generated-profile repetition | `work/m14-implementation-20260930/shell-final/summary.json` records the unexecuted profile case; D27 |
| T3 | Not run; deferred on 2026-09-30 | Actual Libera outputs unavailable | Pending: source/reference extraction and local link checks do not verify runtime assertions | `work/m14-implementation-20260930/verification-summary.json` and D27 |

##### Closure Evidence

- The identifier correction, dedicated reference, README link, and D27 scope separation are published in `b7f6c288bc6e988e1e824ab5ffbc37d0186ff17f` on `origin/master`, with publication confirmed at 2026-10-01T06:44:52.634205+00:00. This is source and document publication evidence; it does not complete or retire the deferred cross-build work.
- All three actual Libera checks remain Pending. Native CI success does not verify cross-build or generated-profile execution.

#### M39 - macOS Patch-Revert Verification

Origin: 1.5.0 / M39
Identity History: none
GitHub Issue: none; #88 remains linked to the clean, uninstall, and patch-revert work (84ee626 M15) and is the source of the patch-revert scope
Status: Deferred

##### Summary

The clean, uninstall, and patch-revert work (84ee626 M15) verified patch revert on actual Rocky Linux 10.2. Its Linux mca target is inactive; no real macOS execution is recorded. This separate work, split from that work's T2 on 2026-10-01 (D28), retains native macOS patch-revert verification, including the active Darwin mca target, without delaying that completion or changing its runtime code.

##### Scope

- Verify the shipped individual and aggregate revert targets on actual macOS with real pinned sources and patch files, preserving the Darwin condition.
- Exercise the active `patch.mca.apply` and `patch.mca.revert` paths with confirmed unapplied, applied, repeated, conflicting, and missing-input states.
- Verify whole-patch classification, reverse order, stack prefixes, independent source edits, existing backups, and errors through the shared revert helper.
- Record actual command resolution, versions, source pins, statuses, outputs, and source inventories, including ignored rejection and backup files.

Out of scope: the completed Linux checks of 84ee626 M15; std cleanup or general macOS build qualification; changes to module pins, patch contents, apply recipes, or platform conditions; Libera M38; other milestone work.

##### Completion Criteria

1. Actual macOS execution activates the Darwin mca path without replacing `uname`, make, the revert helper, or the patch executable with a substitute.
2. Confirmed unapplied, applied, supported partial sets of whole patches, and repeated revert return 0; actual patch order and source inventories agree, preserving unrelated edits and existing backups.
3. Conflicting, partially applied individual patches, missing required inputs, and unresolved states fail with the source and patch identified. Sources and inventories match the actual failing-patch boundary; earlier completed reversals remain, later reversals do not run, and no new `.rej` or `.orig` files appear on classification failure.
4. Evidence names the real macOS version, architecture, make, Bash, patch executable and version, source pins, commands, timestamps, and outputs. Linux results or a forced Darwin variable do not satisfy these checks.

##### Dependencies And Decisions

- D28, Decision Date: 2026-10-01, retains this scope as Deferred Backlog and excludes it from the completion of 84ee626 M15. A new execution decision is required to resume; no macOS verification pass or Keep is inferred.
- Preparation must inspect the commands actually selected by the macOS environment, including whether the selected patch supports the shipped GNU patch options. Missing preparation inputs are not successful checks.
- The Linux ptrace observer used by 84ee626 M15 is not a macOS observation procedure. Review and validate a native method that captures the real failing-patch boundary before executing failure-preservation cases.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On a new execution decision, review this draft and prepare an isolated real macOS checkout, HOME, and writable test roots; preserve the owner's checkout, installation, and previous evidence.
2. Inspect the actual platform, architecture, make, Bash, patch executable, option support, pins, and target activation. Validate the native boundary observation procedure before any failure case; do not substitute an internal program or reconstruct expected source files.
3. Run the shipped individual and aggregate patch paths on independently restored pinned source trees, compare real inventories, and retain exact commands and observations under ignored `work/`.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Platform and successful revert | Inspect real command resolution and platform, then execute individual mca and aggregate apply/revert with none/all applied, stack prefixes, independent source shifts, and repetition | Actual macOS; isolated real pinned source checkouts; shipped make, helper, and patch files; recorded patch executable | Darwin mca path is active; successful cases return 0 in the expected reverse order; repeated revert changes nothing; unrelated edits and existing backups survive |
| T2 | Failure preservation | Use controlled edits to real patch-owned files and required-input absence; capture the real first failing boundary with a validated native observation procedure, then let the shipped invocation finish | Same actual macOS environment; independent writable cases; unchanged internal programs and original protected trees outside the writable roots | Actual target fails with source/patch diagnostics; failing-boundary inventory equals final inventory; preceding reversals remain, later reversals do not run, and no new rejection or backup files appear |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-10-01 | Actual macOS execution not performed | Pending: the Linux inactive mca result of 84ee626 M15 does not verify the active Darwin path or native helper execution | D28; 84ee626 M15 / T2 records only the executed Linux scope |
| T2 | Not run; deferred on 2026-10-01 | Native macOS boundary observation not prepared or executed | Pending: no macOS failure-preservation result is claimed | D28; native observation procedure requires review before execution |

##### Closure Evidence

- None. The scope separation records Deferred work only; the publication of 84ee626 M15 or #88 closure does not complete, retire, or authorize execution of M39.

#### M40 - Original opcua Startup Data Path

Origin: 1.5.0 / M40
Identity History: none
GitHub Issue: none in this repository; #93 remains linked to the loader work (84ee626 M23) and states this check as pending. jeonghanlee/opcua-IOC-demo#1 proposes replacing the Unified Automation server in the application with an open-source server
Status: Deferred

##### Summary

The loader work (84ee626 M23) verifies the opcua-IOC-demo data path with the Eclipse Milo startup variant. The original startup of the application reads nodes that only the Unified Automation example server `uaservercpp` provides, and no such server was available. This work, split from that work's T13 on 2026-10-04 (D29), keeps that check without delaying the loader work.

##### Scope

- Run the original `examples/iocsh/opcua-IOC-demo/st.cmd` through the installed `iocsh.bash` against a running `uaservercpp` at its default address `opc.tcp://127.0.0.1:48020`.
- Read the records of the eight `Demo` databases and of `Demo.WorkOrder` through CA, and judge them by the criteria of the fixture `README.md`: no alarm, the `Demo.Dynamic` records advancing their timestamps within the 200 millisecond subscription plus 2 seconds, and a read answering within 5 seconds.

Out of scope: the loader behavior and the Milo variant, which the loader work verifies; a server written to imitate the `Demo` nodes.

##### Completion Criteria

1. The session of the original startup connects to a real `uaservercpp` on Debian 13 and Rocky Linux 8.10.
2. The records meet the fixture criteria, and the evidence names the server version and the bundle it came from.

##### Dependencies And Decisions

- D29, Decision Date: 2026-10-04, keeps this scope as Deferred Backlog and excludes it from the completion of the loader work. A new execution decision is required to resume, when the server bundle is available.
- The server comes from a Unified Automation software bundle, which needs a registered download.
- jeonghanlee/opcua-IOC-demo#1, opened on 2026-10-04, proposes that the application use an open62541-based server or the Eclipse Milo demo server. When the application changes that way, its original startup no longer needs `uaservercpp`; the fixture then follows the new application revision and this work is re-examined.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On a new execution decision, obtain the bundle and start `uaservercpp` on each target.
2. Run the fixture with its original startup and record the results against the fixture criteria.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Data path | Start `uaservercpp`, prepare the fixture run directory, start the original startup through the installed wrapper, and read the `Demo` records twice through CA | Candidate installations on Debian 13 and Rocky Linux 8.10; a real `uaservercpp` | The session connects; the records read without alarm; the `Demo.Dynamic` records change value and timestamp between the reads |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run; deferred on 2026-10-04 | No `uaservercpp` available | Pending: the original startup reaches `iocInit` and its records read `INVALID` with `COMM` without the server, recorded under 84ee626 M23 / T13 | D29 |

##### Closure Evidence

- None. The separation records Deferred work only; the completion of the loader work or #93 closure does not complete or authorize M40.

#### M41 - Upstream Report Of The Base Site Patches

Origin: 1.5.0 / M41
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

The Base site patches `patch/7.0.10-site01-dbyacc-eof.p0.patch` and `patch/7.0.10-site02-dbstatic-device-menu.p0.patch` correct two segmentation faults of the EPICS base database loader that exist in R7.0.10 and in the 7.0 branch observed on 2026-10-05. Report both to the upstream EPICS base repository so that a later release carries them and the site patches can be dropped at a pin bump.

##### Scope

- One upstream issue or pull request for the parser crash at end of input and one for the field-name suggestion crash, each with its reproduction files, the observed fault location, and the patch.
- The owner files them; this repository records the upstream references when they exist.

Out of scope: any change to the carried patches, which the two site-patch works (84ee626 M25 and 84ee626 M30) own.

##### Completion Criteria

1. Each defect has an upstream reference, or the owner records that it is not reported, with the reason.

##### Dependencies And Decisions

- D30, Decision Date: 2026-10-05, defers the report until the owner chooses to file it.
- The carry rules admit only fixes merged upstream, so the site patches stay until an upstream release above the pin contains the fixes.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Prepare the two upstream texts from the reproduction files of the two site-patch works when the owner asks for them.
2. The owner files them and this register records the references.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Upstream state | Read the two upstream references | GitHub | Each is open, merged, or closed with a reason recorded here |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | None | Pending | Deferred |

##### Closure Evidence

- None; the work is Deferred.

#### M42 - Release Procedure Reconciliation

Origin: 1.5.0 / M42
Identity History: none
GitHub Issue: none
Status: In progress

##### Summary

The documents that describe how this repository is released disagree in places, between this repository and the owner's procedures and among those procedures, and the rules for carrying the modules of EPICS-env-support and the site module repository were written in several places during the 1.5.0 cycle. Bring the records into one procedure (D39): one entry file, several files behind it, each rule in one place, the module procedure as the repeated unit, and one table for what differs by repository. The work runs before the EPICS-env-support modules start.

##### Scope

The discrepancies found on 2026-10-10 while opening this line:

- The time of the version change: the owner's git release procedure describes a release-eve bump from a `-dev` version, its own notes and the environment-pipeline procedure set `ENV_RELEASE_VERS` at branch-open without `-dev`, and the release-cycle procedure describes a version commit during readiness. This repository sets the value at branch-open; the procedures should say so in one place.
- The changelog: `ChangeLog.md` uses `### <version> <date> <author>` headings and the release merge uses the subject `Merge release-X.Y.Z: EPICS Environment X.Y.Z`; the git release procedure describes a `CHANGELOG.md` with a moniker heading and release notes derived from it, and the release-cycle procedure has no changelog step.
- Issue closure in a release line: direct closure on the release branch and `Closes` footers at the master merge both occur in the 1.3.0 to 1.4.0 history; the git procedure describes only the footer route, and its milestone procedure presumes a status document this repository does not have. The GitHub milestone of this line also received the issues closed by master work before the line opened.
- The route map: an earlier 1.5.0 attempt, not on this line, tracked `docs/procedures/epics-env-release-route.md` and cited an environment-pipeline reference that does not exist; decide whether a route map belongs in this repository and, if so, write it against the executed 1.5.0 route.
- The register reset: the 1.4.0 reset deleted the prior canonical file, as the milestone procedure requires; the earlier attempt kept it under a snapshot banner and added a register for a future line, which the procedure does not allow.
- Stale statements: the environment-pipeline procedure names a role default of `release-1.3.0` and predates the installed-module loader and the Base site patches; the git milestone procedure gates on a `docs/STATUS.md`.
- Procedure copies: the owner's procedures differ between working hosts; synchronize the copies before the next cycle opens.

The discrepancies found on 2026-10-17 while reading every procedure and skill reference against the 1.4.0 and 1.5.0 records:

- The closed register: `documentation-upkeep-procedure.md` moves it to `docs/archive/`, the milestone procedure deletes the file and reads it from Git, and 1.4.0 reset it into the master generation; `docs/archive/` holds only the 1.3.0 register.
- The release candidate: the release-cycle procedure makes the readiness-evidence commit the candidate and says nothing about the checkpoint commits that the release execution requires after it; 1.4.0 settled it with the evidence-only comparison rule, now written into the entry file until the skill carries it.
- The release push: the git release procedure pushes master and the tag in one command, which the Push scope forbids; 1.4.0 pushed the branch and the tag as separate rows.
- The next release line: the git release procedure opens it right after the release; 1.4.0 deferred it by a dated decision (1.4.0 D27).
- The decision record: a module bump keeps its IN or HOLD rows in the register (D4), while a fix carry keeps a separate `docs/<module>-carry-<ver>.md`; no procedure states the split.
- The released-tag installation: the release-cycle procedure requires the storage preflight before it, which the release order of the module procedure omits.
- Verification of the site module repository: the pipeline's `layer3.md` requires Gates 2 to 7, `check_deps`, the alliocs consumer build, and the preservation comparison; the verification of the other two repositories written into the module procedure names only `check.deps`, `check.env`, a started IOC, and `readelf`.
- The build selector: the pipeline resolves `epics_env_tag`, `epics_env_support_tag`, and `site_modules_version` to the tag or the `release-X.Y.Z` branch and stops on a mismatch; the module checks (D20) and the verification of the other two repositories name a commit; the two uses are not told apart anywhere.
- The site module run variables are written in three places: `layer3.md`, the `ansible/README.md` of the site module repository, and the module procedure.
- `combinations.md` of the pipeline mixes 1.3.0 observations (module counts, VM names of the earlier model) with its rules.
- Three entry points for one release: the release-cycle skill, the module procedure's release order, and M34; none calls the others in sequence.

Out of scope: the content of the procedures beyond their agreement with the executed route; the work content of the earlier 1.5.0 attempt.

##### Completion Criteria

1. Each listed discrepancy is resolved in its owning document or recorded in `docs/CLOSED_DOORS.md` as kept, with the reason.
2. `docs/README.md`, `ChangeLog.md`, and the procedures under `docs/procedures/` agree with the 1.5.0 release as executed.
3. The owner's procedures name one place for the version change and one for the changelog, and the route map question is decided.

##### Dependencies And Decisions

- D31, Decision Date: 2026-10-10, deferred this work until after the 1.5.0 release; D39, Decision Date: 2026-10-17, runs it now, before the EPICS-env-support modules, and sets its shape.
- The 1.4.0 register at `84ee626` (M11 as executed), this register at f2efff0 (M9 to M18, G1, G2, M19, D25, D26, D32, D39, D40), and the owner's skills `release-cycle`, `milestone-tracking`, `git-workflow`, and `epics-env-pipeline` are the inputs.
- D40, Decision Date: 2026-10-17, settles the eight rule choices as recommended: the closed register is reset and read at its closure commit (D52, which replaced the tag of 1.4.0); the version value is set at branch open; the `ChangeLog.md` form of this repository stands and the git procedure defers to the repository; issues close on the release branch as in 1.5.0; the master push and the tag push are separate rows; the next line opens by a separate decision; the candidate rule of 1.4.0 goes into the release-cycle skill; a bump decision lives in the register and a carry decision in its own file, stated in one line of the upkeep procedure.
- The skills live in the owner's `dev-env` repository; their corrections go to that session as one request under the upkeep procedure's close-of-cycle rule.
- D44, Decision Date: 2026-10-18, sends that request after M1 closes.

##### Implementation Plan

Plan Status: accepted
Plan Acceptance: 2026-10-17; revised the same day (the sentence on removing the candidate rule from the entry file, step 8) and accepted the same day; revised on 2026-10-18 (step 9 and T3: the real test is the EPICS base cycle, M1) and accepted the same day
Implementation Authorization: 2026-10-17, steps 2 to 7 in this repository, given again after the same-day revision with the same scope; the removal of the candidate rule from the entry file under step 8 needs its own authorization; git and GitHub actions keep their own authority; 2026-10-19, step 9 with the real test revised on 2026-10-18, the EPICS base cycle, by the owner's direction to fix the procedure documents directly as the run shows the gaps
Superseded Plan Artifacts: none

1. The owner settles the eight rule choices; each becomes a dated decision here.
2. Add the entry file under `docs/procedures/` (name chosen by the owner): the phases, the twelve-step order, and at each step the file it calls (the module procedure, the fix-carry procedure for base and pvxs, the commonIocsh and fix-verification procedures, the release-cycle skill for the general phases, the pipeline for the release verification and the deployment). One page; no rule of its own that another file already holds.
3. Keep `module-bump-procedure.md` the one-module unit, and add one table of what differs by repository (the survey tool and its completeness test, the register that holds the rows, the session that confirms idle and commits, the build selector of the guest request, and what the verification adds for the site module repository by `layer3.md`). The Stage texts change only where they contradict the entry file.
4. Correct `documentation-upkeep-procedure.md`: the closed-register row, the bump-versus-carry record line, and the pointer to the entry file. Update `docs/README.md` to list the entry file first.
5. In this register: shorten D22 to point at the entry file; reduce the gates G1 and G2 of f2efff0 to the module table and the pointer sentence, moving their method notes into the repository table of step 3; add the storage preflight and the pipeline pointers to the M34 plan.
6. Record the kept shapes in `docs/CLOSED_DOORS.md`.
7. Review the entry file in one second-person pass from the seat of an EPICS-env agent arriving with no memory, then commit this repository's files under the commit rules.
8. Send the skill corrections to the `dev-env` session as one request and record its reply here. When the release-cycle skill carries the candidate rule, remove that rule's sentences from step 10 of the entry file, leaving the pointer.
9. The real test is the first module of the cycle: run EPICS base (M1) through the entry file and fix only what that run shows.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Documents | Read each listed document against the executed 1.5.0 route and the corrected text | Repository checkout and the owner's procedure files | No listed discrepancy remains, or each is a recorded closed door |
| T2 | Entry file | A second-person pass by a reader acting as an EPICS-env agent with no memory, following the entry file from its first line through the twelve steps | The committed entry file and the files it calls | Every step names its file and its done state; no rule appears in two files |
| T3 | Real path | The EPICS base cycle (M1) run from the entry file | This repository and the epics-dev guests | The cycle reaches Complete without a step that the files do not cover; each gap found is fixed in its one file |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Repository checkout | Pending | none |
| T2 | Not run | Repository checkout | Pending | none |
| T3 | Not run | This repository and the epics-dev guests | Pending | none |

##### Closure Evidence

- None.

#### M43 - Milo OPC UA Example Server

Origin: 1.5.0 / M43
Identity History: none
GitHub Issue: #99, https://github.com/jeonghanlee/EPICS-env/issues/99
Status: Deferred

##### Summary

Make Eclipse Milo the primary server of the OPC UA loader example, so the documented example needs no Unified Automation server installation. The Milo variant reads real server values today, but the fixture README and test record a second IOC session failing with `INVALID` and `COMM` unless the server is restarted. The application boundary is coordinated with jeonghanlee/opcua-IOC-demo#1; this work owns the EPICS-env fixture, book pages, and shipped verification script.

##### Scope

- Make the default startup and preparation use real Milo nodes and a reproducible server image identity.
- Align the fixture README, the book pages, the shipped verification script, and the expected test results with the default example.
- Exercise IOC restart without server restart and server stop and start, then document and verify the accepted recovery behavior.
- Preserve unrelated containers and installations during verification.

Out of scope: an imitation of Unified Automation nodes, acquisition of its proprietary server, an implicit opcua or open62541 module upgrade, and the original-startup data path kept as M40.

##### Completion Criteria

- The documented default example prepares and connects without proprietary server files on Debian 13 and Rocky Linux 8.10.
- Server identity, device support, subscription updates, values, timestamps, alarms, and bounded reads are checked through the real installed module and IOC.
- IOC and server restart cases have observed results; any remaining limitation is explicitly accepted and documented.
- Startup path compatibility, preparation, documentation, and the shipped suite agree, and no unexecuted Unified Automation check is represented as a Milo result.

##### Dependencies And Decisions

- D32, Decision Date: 2026-10-11, keeps this work out of 1.5.0 as Deferred Backlog work; a new dated decision assigns it.
- M40 keeps the original-startup data path against the Unified Automation server; the two are examined together when either resumes.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On assignment, select the reproducible Milo server image identity and record it in the fixture README.
2. Switch the default startup and preparation to the Milo nodes; update the book pages and the shipped verification script.
3. Run the fixture through the installed loader on both platforms, including the restart cases, and record the results.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Fixture | Prepare and start the opcua-IOC-demo fixture through the installed loader against the selected Milo server image; read the records; restart the IOC without restarting the server; stop and start the server | Debian 13 and Rocky Linux 8.10, installed tree | The session connects, the records read without alarm, and each restart case has an observed result |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None; deferred by D32.

##### GitHub Projection

Title: Use Milo as the default OPC UA loader example server
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-11; remote updated 2026-10-11T09:40:55Z

#### M44 - reccaster Migration

Origin: 1.5.0 / M44
Identity History: none
GitHub Issue: #101, https://github.com/jeonghanlee/EPICS-env/issues/101
Status: Deferred

##### Summary

The recsync repository stopped carrying the IOC client: from 1.10.0 its `client/` directory holds only a Makefile that announces the move and exits 1, while releases through 1.9.6 still carry it. The client now lives in ChannelFinder/reccaster, whose newest tag 1.9.7 is bebf91f54faf93a59eb4538d3594a687a8823963 (2026-08-19) with no shared history with the pinned recsync commit 9834b94edc63eece42712b8355a4703d4286dd8f. Moving forward means switching the module source to the reccaster repository, which is module source work rather than a version bump.

##### Scope

- Point the module at the reccaster repository in `configure/RELEASE` (`SRC_BASE`, `SRC_NAME`, pin) and remove the `recsync-src/client` path special case in `configure/CONFIG_MODS`.
- Keep the installed names `reccaster` and `reccaster.dbd`, which the commonIocsh reccaster fragment and the loader metadata use.
- Update the module pins page and the add-or-bump procedure of the book.

Out of scope: the recceiver server side; any change to the commonIocsh fragment beyond what the new source requires.

##### Completion Criteria

- `configure/RELEASE` names the reccaster repository and a release tag of it; `make init` fetches it without the client path special case.
- The module builds, installs, and symlinks as `reccaster` on Debian 13 and Rocky Linux 8.10; `make check.deps` and `make check.env` exit 0.
- The commonIocsh reccaster fragment publishes an IOC's records to a running recceiver, observed through the recceiver's output.

##### Dependencies And Decisions

- D17, Decision Date: 2026-10-11, holds recsync at the pin for 1.5.0 and names this migration as separate work; a new dated decision assigns it to a release line.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. On assignment, compare the pinned client tree with the selected reccaster tag file by file and record the behavioral differences.
2. Edit `configure/RELEASE` and `configure/CONFIG_MODS`; run `make init`, the configuration target, `make check.module-deps MODULE=recsync` or its renamed form, build, install, and symlink.
3. Run the commonIocsh reccaster fragment check against a running recceiver and record the result.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Build | The shipped init, configure, audit, build, install, and symlink targets from a tree without the old source | Debian 13 and Rocky Linux 8.10 | Every target exits 0; the module installs as `reccaster` with `reccaster.dbd` |
| T2 | Fragment | The commonIocsh reccaster fragment check of `docs/procedures/commonIocsh-verification-procedure.md` with a running recceiver | Debian 13 and Rocky Linux 8.10, installed tree | The recceiver records the IOC's channels |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |
| T2 | Not run | Debian 13 and Rocky Linux 8.10 | Pending | none |

##### Closure Evidence

- None; deferred by D17.

##### GitHub Projection

Title: Migrate IOC record publishing to reccaster for 1.6.0
Labels: enhancement
GitHub Milestone: Backlog
Observed State: open
Observed Labels: enhancement
Observed Milestone: Backlog
Last Compared: 2026-10-11; remote updated 2026-10-08T00:00:30Z

#### M45 - Loader Suite Record Count

Origin: 1.5.0 / M45
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

`examples/iocsh/tests/verify_minimal_example.bash` reports `records listed` as the count of output lines that begin with `EPICSENV:`. On the Debian 13 epics-dev guest, a cloud guest without `/sys/class/hwmon`, linStat prints five error lines that begin with a record name, so the count read 322 for the same 317 records that the Rocky Linux 8.10 guest listed, and the suspicious-lines section held those five lines (f2efff0 M9 / T3, 2026-10-12). The suite README expects 317 and no suspicious line.

##### Scope

- Count only the record list, so that an error line beginning with a record name is not counted as a record.
- State in the suite README that a guest without `/sys/class/hwmon` prints the five linStat hwmon lines, and keep the expected count at 317 for the current pins.

Out of scope: linStat's behaviour on a host without hwmon; the hwmon records themselves.

##### Completion Criteria

- On the Debian 13 guest the count line reads 317 and the README names the hwmon lines as an environment output.

##### Dependencies And Decisions

- D34, Decision Date: 2026-10-12: deferred until the release work refreshes the suite counts.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Change the count expression of `verify_minimal_example.bash` to the record list.
2. Add the hwmon note to `examples/iocsh/tests/README.md`.
3. Run T1 and record it.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Real path | `run_all.bash verify_minimal_example` after the change | The Debian 13 guest of D20 | The log reads `records listed: 317` and the README names the hwmon lines |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | The Debian 13 guest of D20 | Pending | none |

##### Closure Evidence

- None; deferred by D34.

#### M46 - Lessons of the 1.5.0 Cycle

Origin: 1.5.0 / M46
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

Lessons that a module update or a review pass produced and that no procedure of this repository can hold: how the sessions work, and the release-procedure decisions that D31 defers to the reconciliation after the release (M42). Procedure lessons go into the procedures at the step that produced them (D35) and are not listed here. The list grows during the cycle; each item names its destination.

##### Scope

For the skills repository (agent-review, milestone-tracking, agent-collaboration, git-workflow references), observed in the pvxs update:

- A full-read pass from a seat not yet taken finds what angle passes miss: the second-person pass from the implementer's seat found that the installed linStat links no pvxs, after four third-person passes verified the link at source level; the procedure owner's seat found the contradiction between Stage 6 step 3 and the guest section.
- A fact that replaces an owner's decision is surfaced as a decision change, not written in silently: the install root rule of the local host was replaced by the role's `/opt/epics` without saying so until the owner-seat pass.
- The entry point holds the state; review history goes to commit messages, not to the register.
- The register's structural checks (heading nesting, detail links, table widths, D and M references, consecutive T labels, plan gate fields, the release detail's own subsections) ran from a scratchpad script; they belong to the milestone-tracking skill as a tracked asset.
- The test VM request protocol worked across three sessions on one host; the provider needed its owner's approval for a host change (an inactive libvirt network) and for running the requester's build commands on the guests.
- An issue closes in three steps: the body synced with checked acceptance items and results, the close comment, the close; the register records the observed times afterwards.
- The environment-pipeline skill states that the build driver cannot take extra variables; the driver takes `-e`, `-n`, and `-P`.
- The git-workflow release reference reads `isLatest` from `gh release view`, which the installed `gh` rejects; `gh api repos/<owner>/<repo>/releases/latest` gives the same answer.
- The release-cycle reference makes the close of the register a path of its own, and the git-workflow release reference says that the released register is kept in the tag; this repository reads a closed register at its closure commit (D52).
- Gate 2 of the environment-pipeline verification takes its expected module count from a table of an earlier release; this repository records the count of the rehearsal tree.
- The release-cycle readiness phase asks for a pre-change evidence commit that the release procedure of this repository does not name.
- The environment-pipeline skill carries three layers (`epics_support`, `epics_env_support_tag`, and the third layer of `distribution.md`), while the release runs across two repositories since D53 and the EPICS-env tree holds the areaDetector modules; observed in the tabletop runs of the procedures on 2026-10-19 and 2026-10-20.

For the procedure reconciliation after the release (M42): the test-scope decisions of this cycle, D19 (no upstream test suites), the full fresh-checkout round trip kept as a module check, and `patch/README.md` keeping no history text, become rules of the release procedure or are reversed there.

Out of scope: procedure lessons, which D35 routes into the procedures at each step; the loader suite's record count (M45).

##### Completion Criteria

- Each skills item is handed to the session that owns the skills repository with its reply recorded here, or applied there with the commit named.
- Each reconciliation item is settled in M42 with the decision recorded.

##### Dependencies And Decisions

- D35, Decision Date: 2026-10-12.
- D31 defers the procedure reconciliation to M42 after the release.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Keep appending items with their destination during the cycle.
2. At the cycle's close, send the skills items to the skills repository's session as one request and record the reply.
3. Hand the reconciliation items to M42.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Hand-off | The skills request sent and answered; each M42 item named in M42's detail | This register and the skills repository's session | Every item has a destination record |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | This register and the skills repository's session | Pending | none |

##### Closure Evidence

- None; deferred by D35.

#### M47 - Lua Database Hook Crash

Origin: 1.5.0 / M47
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

An IOC that loads the lua module ends with SIGSEGV when a startup script calls `dbLoadRecords` with the database file name alone. The database hook of lua, `myDatabaseHook` in `luaApp/src/libs/ldatabaselib.cpp`, passes the absent macro string to `macParseDefns` as a null pointer; the stack of the crash is `dbLoadRecords`, `myDatabaseHook`, `macParseDefns`. It was observed on 2026-10-13 on the Debian 13 guest with the installed pin 17475b5 through the loader and with 01aa7a1 built in a scratch directory; `dbLoadRecords("file.db", "")` runs, and the chunk that reads the loaded record prints its value. The lua update (f2efff0 M15) neither causes nor fixes it.

##### Scope

- Decide, when the work is assigned, between a report to upstream lua with the reproduction and a patch carried under `patch/` that passes an empty string to the macro parser when the argument is null.
- Verify the result through the installed loader with a database loaded without macros.

Out of scope: the other behaviour of the lua database library; any change to base.

##### Completion Criteria

- An IOC with lua loaded runs `dbLoadRecords("file.db")` and reaches `iocInit` on both incremental guests of D20.

##### Dependencies And Decisions

- D36, Decision Date: 2026-10-13: kept out of 1.5.0 as Deferred Backlog work; a new dated decision assigns it.
- The lua update (f2efff0 M15) records the observation in its plan review.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Choose the route on assignment: the upstream report or the carried patch.
2. If the patch is carried, add it under `patch/` with its make, apply, and revert rules, and verify it through the patch round trip.
3. Run T1 and record it.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Real path | In a new directory write `t.db` holding one `ai` record and `st.cmd` holding `module lua`, `dbLoadRecords("t.db")`, `iocInit()`, and `exit`; source the installed tree's `setEpicsEnv.bash` and run `iocsh.bash st.cmd` | The two guests of D20, installed tree | The IOC reaches `iocInit` and exits with status 0 |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | The two guests of D20, installed tree | Pending | none |

##### Closure Evidence

- None; deferred by D36.

#### M48 - Shared Library Version Identification

Origin: 1.5.0 / M48
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

The modules of this tree do not give their shared libraries a name that carries the version or the ABI. Of the 54 distinct `SONAME` values of the module libraries installed on the Debian 13 guest on 2026-10-14, 47 are bare (`libmotor.so`, `libcaPutLog.so`) and 7 are versioned; the base libraries are versioned (`libCom.so.3.25.0`). An object built inside this tree names the versioned directory of its dependency through a `$ORIGIN`-relative RUNPATH entry, such as `$ORIGIN/../../../motor-4b22ac9/lib/linux-x86_64` in `libpmacAsynMotorPort.so`. An object built against the convenience link `modules/<name>` records the link path instead, and the link points at whichever version was installed last. Two objects built before and after a version change then carry the same RUNPATH entry and the same bare `NEEDED` name, and the ELF data of neither tells which library it was built against. The motor update of 2026-10-13 is the concrete case: `asynMotorController` gained a member in the middle, `libmotor.so` kept its `SONAME`, and an object built at the old pin and loaded through the link would run against the new layout with no signal in its ELF data. For the modules of this tree the loader metadata (`dep=` lines of `cfg/iocsh.conf`) and `check.deps` carry the version; for an object built outside it, nothing does.

##### Scope

Decisions to take when the work is assigned:

- Whether an object built against the tree must name the versioned install directory in its RELEASE paths, never the link, and what the link is for.
- Whether the modules set a versioned `SONAME` or another ABI compatibility name, and how that is carried for modules whose upstream does not set one.
- How `check.deps` and `check.env` report an object whose RUNPATH names a link.
- A review of the long-term operation and security of the library resolution: which library an installed binary loads must follow from the object and the recorded metadata, and not from the state of a link that a later install changes.
- The relation to M35: the Perl `makeRPath` that M35 delivers computes the RUNPATH entries, so this decision informs its design; M35 itself stays the path algebra.

Out of scope: any change in 1.5.0; the format of the loader metadata; changes to the build systems of upstream modules.

##### Completion Criteria

- A dated decision records the RUNPATH naming rule, the `SONAME` and ABI name rule, and the reporting of a link by the check tools.
- The design review of the long-term operation and security is recorded.

##### Dependencies And Decisions

- D37, Decision Date: 2026-10-14: kept out of 1.5.0 as Deferred Backlog work; a new dated decision assigns it.
- M35: the RUNPATH entries are computed by `makeRPath`, which M35 ports to Perl upstream (D33).
- The caPutLog plan review (f2efff0 M17) and the motor update (f2efff0 M16) record the observations.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Survey the installed tree: for every ELF object, record whether its RUNPATH entries name a versioned directory, a link, or an absolute path outside the origin root, and count the distinct `SONAME` forms per module.
2. Write a design note with the options for the RUNPATH rule, the `SONAME` rule, and the check tool reporting, and the review of the long-term operation and security; take the decision with the owner.
3. Implement the decided rules through the build rules, the check tools, and the procedures, or through M35 where they belong to `makeRPath`; run T1.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Real path | Build a probe object against `modules/<module>` before a version change of that module and again after it, then run `readelf -d`, `make check.deps`, and `make check.env` on both | The two guests of D20, installed tree | The decided rules hold: the probe either names the versioned directory or is reported by the check tools as resolving through a link |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | The two guests of D20, installed tree | Pending | none |

##### Closure Evidence

- None; deferred by D37.

#### M49 - pyDevSup In A Plain IOC

Origin: 1.5.0 / M49
Identity History: none
GitHub Issue: none
Status: Deferred

##### Summary

pyDevSup installs `libpyDevSup<PYVER>.so` with the SONAME `libpyDevSup<PYVER>.so.0`, `dbd/pyDevSup.dbd`, a Python package, and `softIocPy<PYVER>`, an IOC executable that links the library and libpython at build time; `<PYVER>` is the Python version of the build, 3.13 on Debian 13, 3.9 on Rocky Linux 8.10, and 3.14 on Ubuntu 26.04. The loader treats pyDevSup as a data-only module: `pyDevSup_IOCSH_LIBS` and `pyDevSup_IOCSH_DBDS` are empty, so `module pyDevSup` sets only the `PYDEVSUP` environment variable and a Python device-support record needs the `softIocPy` executable. An exploratory run of 2026-10-14 on the Debian 13 and Rocky Linux 8.10 guests at the installed pin 4527ed0 used the plain `softIoc` of base with `dlload` of `libpyDevSup<PYVER>.so`, `dbLoadDatabase` of `pyDevSup.dbd`, `registerAllRecordDeviceDrivers(pdbbase)`, a `py` command that extended `sys.path`, and a `longin` record with `DTYP "Python Device"` and `SCAN "1 second"`: the IOC reached `iocRun`, the record counter read 1 and then 4 after three more seconds, and the IOC exited 0. Not examined: the compile-time paths of the build (`XPYDEV_BASE`, `XEPICS_BASE`) in a relocated tree, the import of the installed `devsup` package, the loader rule for a library name that carries the Python version, and Ubuntu 26.04.

##### Scope

Decisions to take when the work is assigned:

- Whether the loader loads `libpyDevSup<PYVER>.so` and `pyDevSup.dbd` for `module pyDevSup`, and how the rule resolves the library name from the Python version of the build.
- Whether `softIocPy` stays as the supported way to run Python device support, or the loader path replaces it.
- The behaviour in a relocated tree, where the build writes the install path into the library.
- The checks: the loader suite and the dependency graph, which assert that pyDevSup has no `dlload`, change with the rule.

Out of scope: any change in 1.5.0; the Python device-support API of pyDevSup.

##### Completion Criteria

- An IOC started through `iocsh.bash` with `module pyDevSup` processes a Python device-support record on both incremental guests of D20 without `softIocPy`.
- The relocated-tree check of the loader suite passes with the library loaded.

##### Dependencies And Decisions

- D38, Decision Date: 2026-10-14: kept out of 1.5.0 as Deferred Backlog work; a new dated decision assigns it.
- M48: how an installed library identifies its version bears on a library name that carries the Python version.

##### Implementation Plan

Plan Status: draft
Plan Acceptance: none
Implementation Authorization: none
Superseded Plan Artifacts: none

1. Repeat the exploratory run in a relocated copy of the installed tree and record the result.
2. Decide the loader rule and the fate of `softIocPy` with the owner.
3. Implement the rule in `configure/CONFIG_MODS_IOCSH` and the suite, then run T1.

##### Test Plan

| Label | Layer | Method | Environment | Expected Result |
| --- | --- | --- | --- | --- |
| T1 | Real path | In a new directory write a Python module with a device-support class, a database with one `longin` record using it, and a startup script with `module pyDevSup`, `py "import sys; sys.path.insert(0, '<dir>')"`, `dbLoadRecords`, `iocInit()`, two `dbgf` reads separated by `epicsThreadSleep`, and `exit`; run `iocsh.bash` from the installed tree's environment, then repeat from a relocated copy of the tree | The two guests of D20, installed tree | The IOC reaches `iocRun` with no error and the counter increases between the reads, in both trees |

##### Verification Results

| Label | Observed At | Environment | Result | Evidence |
| --- | --- | --- | --- | --- |
| T1 | Not run | The two guests of D20, installed tree | Pending | none |

##### Closure Evidence

- None; deferred by D38.

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-10-18 | `f2efff0fa57c4d9154576ca3315e21e9bd7a3c1c` (`docs/milestone-1.5.0.md`) |
