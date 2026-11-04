# Release record 1.5.0

Release: 1.5.0
Release branch: `release-1.5.0`, upstream `origin/release-1.5.0`
Record: `docs/milestone-1.5.0.md`
Tracker: `jeonghanlee/EPICS-env`, GitHub milestone 1.5.0 (number 7); the issue that tracks the release is #100

The release inventory is 39 modules: the 37 declared by EPICS-env and the two
site modules, `siteApps` and `unidrv` (D25). Step 2 source preparation and
inventory are complete as of 2026-10-29; the source identities and evidence
are recorded below. Step 3 is complete as of 2026-10-29, with the full tool
survey and tag/branch evidence for all 39 modules reconciled below. Resume at
step 4 of `docs/procedures/release-procedure.md`, the dependency and
compatibility assessment with the Maintainer.

Step 3 surveys all 39 modules. Step 4 checks dependencies and consumers for
all 39, settles the open updates, and records the pin-retention reasons of
ADSimDetector, ADGenICam and ADVimba (D34). Step 5 records the combined
dependency order before any module cycle. The EPICS base plan below remains
draft; its review and acceptance must include any site consumers found in step
4. Issue #111 remains its tracking issue. No build or test is authorized by
this scope decision.

## Source preparation

Step 2 result, observed 2026-10-29: all 39 module sources have the declared
origin, HEAD at the effective pin, and no tracked or untracked changes.
The [source inventory](source-inventory-1.5.0.tsv) records the owning
repository, key, module name, effective pin, version, and full resolved commit.
Owner `site` identifies the selected site module repository. These are source
preparation revisions, not accepted build or release candidates.

| Owning repository | Preparation commit |
| --- | --- |
| EPICS-env | `d1c0a1c7582084de97d9f7848509fe0a49be1dad` |
| Site module repository | `1a31f3046fef9a283a14d780e380f4973483b9e9` |

Both repositories' effective source declarations include their local override
files. The parent override sets only `EPICS_BASE`, not a module source identity.
The site repository and both site sources are fresh clones; the EPICS-env
module sources are prepared in their owning checkout. EPICS base's seven
submodules are initialized at the commits recorded by `tags/R7.0.10`.

Local evidence is in `work/source-preparation-1.5.0/`: `inputs.json`,
`inventory.tsv`, `base-submodules.txt`, and one log per module. No downstream
patch, build, installation, or IOC check ran. Upstream currency remains for
step 3, and the open outcomes and compatibility decisions remain for step 4.

## Decisions

| ID | Decision | Date |
| --- | --- | --- |
| D1 | Open `release-1.5.0` from master `4d521e7` for a module-set update, the case the 1.4.0 close reserved for 1.5.0. `ENV_RELEASE_VERS` is 1.5.0 in `configure/CONFIG_SITE` since `8a603bb`, the first commit of the branch. | 2026-10-10 |
| D2 | Every module, EPICS base included, runs the whole cycle again from EPICS base in the order of D3 (`docs/procedures/release-procedure.md`, step 6). The pins and the downstream patches stand as decided in D5 to D17; each module's build and tests run again at its candidate. The earlier runs of the ten updated modules are leads for their plans, not results of this release. | 2026-10-18 |
| D3 | Order of the cycles: EPICS base first and pvxs with it; then the dependency order of `build.<module>` in `configure/CONFIG_MODS_DEPS` from the bottom up, ties in the order of that file: MCoreUtils, autosave, ether_ip, iocStats, recsync, retools, sequencer, snmp, opcua, pcas, pscdrv, linStat, feed-core, sscan, calc, asyn, QPC, modbus, lua, std, StreamDevice, rgamv2, busy, scaler, mca, measComp, motor, motorMotorSim, pmac, ADCore, ADSimDetector, ADGenICam, and ADVimba; then the modules whose new pin carries code identical to the old pin, caPutLog and pyDevSup. The four areaDetector modules entered this order on 2026-10-19 (D21). | 2026-10-18 |
| D4 | The survey of 2026-10-11 (`tools/update-release.bash check`, exit 0, 33 of 33 lookups, 13 updates) and the reverse dependencies found at each module's pinned revision with two search tools that agree are the basis of D5 to D17. Each module finds its reverse dependencies again in its own cycle. | 2026-10-11 |
| D5 | pvxs: IN, `tags/1.5.2` (8e00eaecdee5ce8a474704e70d820e6f92693fa1) to `tags/1.5.3` (25ca43df4db909c0b1a445fb705fc81582617625). All twelve carried 1.5.2 commits are ancestors of 1.5.3, so the carry patches retire with the bump and `patch/README.md` is rewritten; the public API change is additive (`TypeCode::valid()` export, new `pvxs/json.h`) and `SHRLIB_VERSION` stays 1.5. EPICS base stays at 7.0.10 with its downstream patches unchanged. | 2026-10-11 |
| D6 | calc: IN, 4217e83a9b9067017f4dc74da6b70e3669972f16 to R3-8 (712a40453e8693fda3b90a6e9da5fdb1c708ee38): eight engine fixes, seven bounds and overflow guards and the vararg argument-count skip of the UNTIL scan, with no header or Makefile change. The four later Db-only commits at head (59d1fe5) are not taken. | 2026-10-11 |
| D7 | sscan: IN, e13699e3062145d516cfdd555aae25bb49a8c53b to head ce9660cfc05071834391225beadf7f93b776d216 (no tag after the pin): delays no longer rounded to the thread quantum except on vxWorks, npts computed with round(), K&R declarations removed from the internal writeXDR.h. | 2026-10-11 |
| D8 | std: IN, 5f2e44214963b84ea3a400f7b7c3a9f510126ddd to head 27b696702c4ebc8c698c98e3bbb10a34f1a2c821 (no tag after the pin): throttleRecord.c locks the record in its delayed callback and writes the link-status flag for the correct link. | 2026-10-11 |
| D9 | lua: IN, 17475b50ae95c801bad9573bb2b031ffb04ac75c to head 01aa7a1474a1ab525f1b97e042dcf7a7555ff15d (no tag after the pin; upstream names it Release 4-0): bundled Lua 5.5.1, device support in C++, extended luascript record, unified run and state APIs with deprecated aliases, luaaa and the C++11 requirement removed. No module of this repository links lua or includes its headers; `motor_DEPS` names `build.lua` as a build-order declaration, so the lua cycle rebuilds motor on that declaration, not on a link; motorMotorSim and pmac reach lua only through motor and rebuild in their own cycles. | 2026-10-11 |
| D10 | busy: IN, 2dfe92da63c67d6104cc9b5f7ce6fde73af2c7eb to head a4a272d94d1f4351e7d9553e6dc35782eb96ce75 (no tag after the pin): busyRecord uses TYPED_DSET and TYPED_RSET, the dbd adds the typed dset declaration, and the build moves to the cfg-based mechanism with the test IOC opt-in. | 2026-10-11 |
| D11 | scaler: IN, beb5521af49616682e4e442c3e33a06add1bd713 to head baa8e1c5e5a9a5deceef8cc39207a0da446092a6 (no tag after the pin), to keep busy and scaler on the same cfg-based build convention; no record or device-support code changes and the C17 bridge stays. | 2026-10-11 |
| D12 | motor: IN, 285f44d66cf7d07a86047719de757bd1f5d92a95 to 4b22ac950de98c2dca324c2ef8ef221e124f6651, which is R7-4 plus a documentation fix and the motorRecord.cc version-number correction the tag misses. Head 47893ed is excluded: it removes NUM_MOTOR_DRIVER_PARAMS, which pmac 2-7-9 uses in two files and pmac upstream still uses, with no newer pmac tag. | 2026-10-11 |
| D13 | caPutLog: IN, dafb0b2d6b19ccaaa23cd3aac12e3fb720b88e34 to R4.2 (6f9eb3f6c75e49201d114f8e194d53cef493a522); the difference is documentation only, so the move re-pins identical code to a release tag. | 2026-10-11 |
| D14 | pyDevSup: IN, 4527ed055a472d4688846a2cb64ac593fec1ecbb to 2.1.0 (b5cef38a6d9f74f9c59f967185ba6d1940637c03); the difference is CHANGELOG.md only. Head (80cdb15) is not taken. | 2026-10-11 |
| D15 | measComp: HOLD at c38974e85c59429b8ba48ed320681ba0296fb924; the two later commits change autoconvert .ui files and docs only. | 2026-10-11 |
| D16 | pcas: HOLD at e075fd450ab9a66bbc044eaa4c2035d3d26d9651; the two later commits change the CI workflow only. | 2026-10-11 |
| D17 | recsync: HOLD at 9834b94edc63eece42712b8355a4703d4286dd8f. From 1.10.0 the recsync repository carries only a stub client Makefile that exits 1; the client lives in ChannelFinder/reccaster (1.9.7 = bebf91f54faf93a59eb4538d3594a687a8823963, no shared history with the pin). The repository switch is module source work outside a version bump, tracked by GitHub issue #101 in the Backlog milestone and not part of 1.5.0. | 2026-10-11 |
| D18 | No module update of this release runs the module's own upstream test suite; the checks of a module are its builds, the installed-tree checks, and a started IOC or the loader suite. | 2026-10-11 |
| D19 | The test machines of the module checks are the default Debian 13 and Rocky Linux 8.10, not extended; the other operating systems are covered by the six OS workflows at release readiness. | 2026-10-18 |
| D20 | Each module gets a new issue in GitHub milestone 1.5.0, opened at the plan step of its cycle; the closed issues of the earlier run (#97 and #102 to #110) stay closed as its record. | 2026-10-18 |
| D21 | The four areaDetector modules ADCore, ADSimDetector, ADGenICam, and ADVimba, formerly in the EPICS-env-support repository, are modules of this repository from this release. They are declared in `configure/RELEASE` and `configure/CONFIG_MODS_DEPS` at their former pins and take their place in the order of D3. The ADCore libxml patch of the first declaration was dropped on 2026-10-20 (`6799bd3`), because ADCore at `ee039d2` already calls `xmlFree()` directly and the patch failed `make patch` on all six OS workflows. | 2026-10-19 |
| D22 | The branch `release-1.3.0`, the release before the previous one, is deleted locally and on origin after this release, because its tag `1.3.0` is on origin and keeps the content, and `release-1.3.0` is merged into master. | 2026-10-19 |
| D23 | The procedures under `docs/procedures/` are completed first, because every cycle follows them; this record is then written from them. | 2026-10-23 |
| D24 | The survey of 2026-10-25 (exit 0, 37 of 37 lookups) reports updates for eight modules. recsync, measComp, motor, and pcas are the HOLD and excluded heads of D17, D15, D12, and D16. calc reports `tags/R5-4-2`, dated 2015-01-21, an older tag that version sort picks over `R3-8`, dated 2026-09-17 (D6 stands). ADCore, ADGenICam, and lua are open (Open decisions). | 2026-10-25 |
| D25 | Include `siteApps` and `unidrv` with the 37 EPICS-env modules from initial source preparation: 39 modules share the inventory, survey, compatibility decisions, dependency order, and full module cycles. Prepare the site repository and both module sources before the survey; an installed EPICS-env tree is a build prerequisite only. Step 5 extends D3 using verified cross-repository dependencies. Step 4 examines ADCore, ADSimDetector, ADGenICam, and ADVimba, including the reasons for retaining unchanged pins; lua's open update remains. This decision authorizes the procedure and record update, not runtime execution or publication. | 2026-10-29 |
| D26 | EPICS base: HOLD, `tags/R7.0.10` -> `tags/R7.0.10`; exclude `tags/R7.0.11` from 1.5.0 and retain the selected base and its downstream patches. This classification records the existing pin-retention decision; `unchanged` describes only the survey of 2026-10-25, before the later release recorded below. The pin and cycle scope do not change. | 2026-10-29 |
| D27 | pvxs: retain `tags/1.5.3` and carry upstream `7176098` (unmarked single-PUT value preservation) and `96345dd` (TCP listener backlog). The Maintainer selects the latter despite missing the score rule, for increased pending-connection capacity after reviewing resource tradeoffs. Defer the unselected configuration pair `a9f8b7b`/`d23de00` because of its prerequisite cost and malformed-name-server regression concern; exclude the two documentation-only commits. The [carry decision record](pvxs-carry-1.5.0.md) preserves all six candidates, scores, order and verification limits. This authorizes patch addition and local apply/revert verification, not module build or runtime acceptance. | 2026-10-29 |
| D28 | autosave: retain `tags/R6-0` and carry upstream `f5b7da3` (initialize unknown-errno diagnostics) and `49159fc` (update the configMenu name after successful load), the two recommended fixes selected by the Maintainer. Of 21 post-pin commits, five documentation-only changes are excluded and all other 16 are scored; the remaining 14 are not carried. The [carry decision record](autosave-carry-1.5.0.md) preserves the scores, source risks, order and verification limits. This authorizes patch addition and local apply/revert verification; build and IOC functional acceptance remain for the module cycle under D18 and D19. | 2026-10-30 |
| D29 | ether_ip: retain `tags/ether_ip-3-10` with no additional carry patch. Of three post-pin commits, `f97b093` changes documentation wording only, `b486c6d` enables C99 for VxWorks, and `15432f0` merges that change without another change. The Maintainer declines the VxWorks-only carry for this release's Linux scope and proceeds without panel scoring. Build and IOC acceptance remain for the module cycle. | 2026-10-30 |
| D30 | iocStats: retain `tags/4.0.1` with no additional carry patch. After the overview of the 11 post-pin commits through `fd31816`, the Maintainer chooses to preserve the current version and behavior rather than adopt these changes in 1.5.0. No panel scoring or carry implementation is performed. Build and IOC acceptance remain for the module cycle. | 2026-10-30 |
| D31 | sequencer: retain `tags/R2-2-9` with no additional carry patch. After the overview of the 16 post-pin commits through `de4f7c2`, including queue concurrency changes, C23 prototype compatibility, and obsolete release-tool removal, the Maintainer chooses to preserve the current version and behavior in 1.5.0. No panel scoring or carry implementation is performed. Build and IOC acceptance remain for the module cycle. | 2026-10-30 |
| D32 | opcua: retain `tags/v0.11.2` and the existing `opcua-CONFIG_OPCUA` and `opcua-anon-ns-export` patches, with no additional carry patch. After the overview of the 25 post-pin commits through `e3cad37`, the Maintainer chooses to preserve the current version and patch set in 1.5.0. The existing export patch already addresses the GCC 15 namespace-export problem targeted by upstream `485922c`. No panel scoring or new carry implementation is performed. Build and IOC acceptance remain for the module cycle. | 2026-10-30 |
| D33 | linStat: retain `tags/1.2.1` and select five upstream carries: `78b6138` (netstat simplification), `6ea15c7` (RTC status), `7576edc` (Host OPI), `e48e077` (separate-install configuration), and `df0f547` (NIC P prefix). Exclude `8e6d08a` (std::filesystem removal). RTC selection requires correction and verification of null-result parsing and local-time DST handling; include its OPI with the corrected producer. The [carry decision record](linstat-carry-1.5.0.md) preserves scores, three Maintainer additions beyond the rule, and selection order. The selected five carry files and one RTC site correction are prepared; targeted native/MSI/CONFIG checks and aggregate apply/revert pass. Independent pre-build third-person and second-person reviews pass with no findings; full build and IOC acceptance remain pending. | 2026-10-30 |
| D34 | feed-core, asyn, QPC, busy, scaler, mca, motorMotorSim, ADSimDetector, lua, ADGenICam, ADVimba, and siteApps have no newer upstream release than their pins, so none needs a decision beyond the pin it already has: feed-core `0472d88`, asyn `tags/R4-46` and QPC `913fad4` (observed 2026-10-30), busy `a4a272d` (D10), scaler `baa8e1c` (D11), mca `687d563`, motorMotorSim `tags/R1-3` and ADSimDetector `0ef1305` (observed 2026-10-31), lua `01aa7a1` (D9), ADGenICam `ba5b9b8` and ADVimba `tags/R1-5` (observed 2026-10-31), and siteApps `0.1.0` of the site repository (observed 2026-11-01). The remote default branch is at the pinned commit in each of them except lua, whose branch has six commits after its pin (`be6052c` to `f682826`: device support for more record types, examples, release notes and a test fix; D49 scores four of them), ADGenICam, whose branch has three commits after its pin (`f46ed9c`, `7cb25b3` and their merge `df3d7cd`: support files for one camera model, no code change), and ADVimba, whose branch has nine commits after its pin (`00a174c` to `ddeb021`: configuration-file overrides, the order of the `ADGENICAM` definition in `configure/RELEASE`, an executable bit removed from `configure/CONFIG`, an example program limited to Linux, and an unused example IOC file removed; `conf.ADVimba` rewrites the two configuration files the build reads and leaves the example IOC unbuilt, the `CONFIG` change is a mode bit only, and the example program builds the same on Linux, so none of it reaches this build); the Maintainer takes none of the three sets. The existing `feed-core-libonly`, `QPC-dataonly` and `mca-libnet` (macOS only) patches stay. The numbers D35, D36 and D41 to D46, which commits `3b2f64e` and `dee84f9` gave to single modules, are folded into this row. Module build and IOC acceptance remain pending. | 2026-10-31 |
| D37 | modbus: retain `tags/R3-4` and carry one curated patch of upstream `4e39e7a`: the Windows min/max guard, the removal of the uninitialized-offset debug loop in `readFloat64Array`, and the explicit `epicsUInt16` cast. The two `size_t`-to-`int` bound changes of that commit are omitted because at five of the six tested capacities above 2147483647 they request a wrong register count or report a wrong element count. The other eight scored commits are not carried; all miss the rule. The [carry decision record](modbus-carry-1.5.0.md) preserves the scores, the dependency findings and the completion reviews. The carry file is prepared; targeted real-driver checks, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-30 |
| D38 | StreamDevice: retain `tags/2.8.26` and carry upstream `562dd5ad` (scalcout string value truncation) as one patch; the existing `StreamDevice-no-vxi11` and `StreamDevice-dbd-tab` patches remain. The other twelve scored commits are not carried; all miss the rule, and two of them (`e87e093c`, `f473f4d6`) replace or repeat the local patches. The [carry decision record](streamdevice-carry-1.5.0.md) preserves the scores, the dependency findings and the completion reviews. The carry file is prepared; targeted real-IOC checks, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-30 |
| D39 | sscan: retain the accepted move to `ce9660c` (D7) and carry upstream `b28ac30d` (the temporary path buffer of the saveData permission check) as one patch. The later `f5f4c90d` (`NINT` instead of `round`, which matters in practice only for vxWorks) is not carried. The [carry decision record](sscan-carry-1.5.0.md) preserves the scores and findings. The carry file is prepared; targeted function-level checks, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-30 |
| D40 | ADCore: retain the pin `ee039d2` and carry upstream `ede4c22` (the soft trigger busy record of the circular buffer plugin is cleared when an acquisition completes) as one patch that omits the unit test of that commit. The later `3f07467` (an HDF5 error message text) and `9cadb7f` (a Windows-only include) are not carried. The [carry decision record](ADCore-carry-1.5.0.md) preserves the scores and findings. The carry file is prepared; the unit test, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-31 |
| D47 | pmac: HOLD, `2-7-9` -> `2-7-9`; `2-7-10` (`34730140ae052b795bbedb54f83c6a7fe44a090a`, 18 commits) is not taken. No module consumes pmac and no header symbol is removed; the release adds Symetrie hexapod records and a following mode (master control) with move gating and one more controller query per axis in the poll, and the facility need for them is not established. `2-7-10` uses `NUM_MOTOR_DRIVER_PARAMS` like `2-7-9`, so D12 stands. Module build and IOC acceptance remain pending. | 2026-10-31 |
| D48 | pyDevSup: retain the pin `2.1.0` (D14 stands) and carry upstream `f0ad79d` (the unit test harness clears the record cache between cases, so a test case that reuses a record name no longer segfaults, and the missing-field error names the field) and `e3f5ae3` (the non-interactive `softIocPy` sleeps in a loop instead of calling the deprecated `epicsThreadExitMain()`, which ends in `cantProceed` and a stack trace on Base 7.0.10) as two patches that carry the whole upstream commits. The other five scored commits are not carried: three Python 3 ports of example applications, a compiler warning cleanup, and `5d2130e`, which changes the alarm behaviour of `devsup.ptable` for existing users. The [carry decision record](pyDevSup-carry-1.5.0.md) preserves the scores and findings. The carry files are prepared; the shipped tests, builds, a non-interactive start and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-11-01 |
| D49 | lua: retain the pin `01aa7a1` (D9 stands) and carry none of the six commits above it. Two (`b930a4d`, release notes; `f682826`, one test call) were removed as documentation and test only; the other four (`be6052c` 64-bit integer and mbbiDirect, `4db9388` lsi and lso, `b0d29c1` arrays, `ce8a474` example files) were scored by five reviewers with totals from 15 to 21 of 80, and none met the rule. `be6052c` corrects the truncation of 64-bit integers written to INT64 fields but makes `epics.get` of INT64 arrays return `nil` and a `luascript` string or array input that reads an INT64 or UINT64 field go INVALID, and `b0d29c1` returns zeros for INT64 waveforms without an alarm on Base 7.0.10. The [carry decision record](lua-carry-1.5.0.md) preserves the scores and findings. No patch is generated, and step 6.3 needs no pin edit (`configure/RELEASE` already holds `01aa7a1`). Module build and IOC acceptance remain pending. | 2026-11-01 |
| D50 | unidrv: IN, `0.5.1` (`86688df5640cc9a4abbe8d99b7c9a4bc838bc328`) -> `e5a8561` (`e5a8561100ca825b865aa49fe91c0015407ba3c6`), the head of `main`, which has no tag (the newest tag is still `0.5.1`, observed 2026-11-01). Of the four commits above the pin, `ae62ea1` and `e5a8561` are merges; `74fc372` installs the support DBD `unidrvSupport.dbd`, and its change of `unidrvApp/src` is byte-identical to the site patch `unidrv-supportdbd`; `893b761` removes `mksApp/Db/mks.substitutions`, which no Makefile builds or installs and no file references. No header or library source changes, and no module consumes unidrv. The pin edit and the retirement of the site patch are done in the module cycle (step 6.3), in the site repository (pin, patch, rules, README and its milestone) and in this one (the book page, the site-modules procedure and the release checklist), as the unidrv observation lists. This is the dated decision that the milestone of the site repository expects for moving the pin and dropping the patch, taken for the head of `main` and not for a tag. No build or test has run. | 2026-11-01 |
| D51 | Step 5, the combined order of the 39 cycles. The numbers of the table of the section Modules are inventory rows and not the order. The order is: epics-base, pvxs, the 33 modules of EPICS-env from MCoreUtils to ADVimba in the order of D3, then siteApps, unidrv, caPutLog, and pyDevSup. The rule is that of step 5: base first, pvxs next, then each module after the modules that it names with `build.` in the `_DEPS` lines of the two `configure/CONFIG_MODS_DEPS` files, ties broken by the order of the declarations with EPICS-env read before the site repository, and re-pins of identical code last when no consumer requires them earlier. Reading the two files with that rule reproduces the 35 positions of epics-base to ADVimba, and no module precedes a module that it names. A re-pin of identical code is a module whose new pin has the same source as the old pin (D3). caPutLog and pyDevSup qualify: the pin of caPutLog differs from the old pin in documentation only (D13), the pin of pyDevSup in `CHANGELOG.md` only (D14), the carries of D48 are patches and do not change the pin, and no `_DEPS` line names either. siteApps keeps its pin and is not a re-pin; it follows the EPICS-env modules because EPICS-env is read first, and it follows ether_ip, on which its templates depend at run time (its templates `ai`, `ao`, `bo`, `UDT_ai` and others in `siteApp/Db` use `DTYP "EtherIP"`, and the T5 result of the milestone of the site repository records that they need ether_ip loaded first; this is the one cross-repository dependency of step 4, not a `build.` entry, and ether_ip is the 5th cycle). unidrv takes a new pin whose source differs from the old pin (the support DBD, `unidrvApp/src/Makefile` and a removed file, D50), so it is not a re-pin of identical code either; it names only `null.base`, has no dependency on a module, and follows siteApps in the order of the site repository. No `_DEPS` line of either repository names siteApps or unidrv, and no module of EPICS-env names a module of the site repository. Only a `build.` name forces a position, and a module that names only `null.base` takes its place by the order of the declarations: the 13 modules of EPICS-env MCoreUtils, autosave, ether_ip, iocStats, recsync, retools, sequencer, snmp, opcua, pcas, pscdrv, linStat and feed-core do, with the later modules that name autosave or sequencer following them, and so do caPutLog, pyDevSup, siteApps and unidrv. This is the order that D25 asked step 5 to extend from D3. | 2026-11-01 |

### Open decisions

D25 includes `siteApps` and `unidrv` from source preparation through release
readiness, under the same module procedure as EPICS-env. It also requires the
four areaDetector modules to be considered at step 4. Existing outcomes are
retained until that review produces a dated decision.

The maintainer decides each at step 4 of `docs/procedures/release-procedure.md`, before the cycles start. Stage 3 of `docs/procedures/module-bump-procedure.md` finds the reverse dependencies of all 39 modules at their pinned revisions. Stage 4 compares the newer candidates. Present that evidence with each decision (Stage 5) and record the decision in its dated row.

| Module | Pin | Newer upstream | What it holds |
| --- | --- | --- | --- |
| modbus | `tags/R3-4` | `master` at `768d105`, 16 commits above the pin, reconfirmed 2026-10-30 | Nine carry candidates scored; one curated carry selected (D37); no pin change. |
| StreamDevice | `tags/2.8.26` | `master` at `562dd5a`, 19 commits above the pin, observed 2026-10-29 | One upstream carry selected (D38); both local patches retained; no pin change. |
| pmac | `2-7-9` | `2-7-10` at `3473014`, 18 commits above the pin, observed 2026-10-29 | The tag matches `dls-master` HEAD. D47 holds `2-7-9` and does not take `2-7-10`; D12 remains the current motor decision. |
| pyDevSup | `tags/2.1.0` (D14) | `master` at `a38e7b5`, 14 commits above the pin and 10 after D14's excluded head, observed 2026-10-29 | Latest tag remains `2.1.0`. Seven of the 14 commits were scored by five reviewers and two met the rule. D48 keeps the pin and carries `f0ad79d` and `e3f5ae3`; D14 stands and no further pin change is authorized. |
| ADCore | `ee039d2` | `master` at `36840e1`, 10 commits above the pin, observed 2026-10-29 | Commit subjects describe a circular buffer plugin busy-record fix and its unit test, a Windows header include fix, an expanded error message, and CI updates. D40 retains the pin and selects one carry (`ede4c22`); the build and IOC acceptance of the module cycle remain pending. |
| ADGenICam | `ba5b9b8` | `master` at `df3d7cd`, 3 commits above the pin, observed 2026-10-31 | The commits add the template, screens and feature XML of The Imaging Source DMK 33GX174 camera and change no code. D34 keeps the pin; the three commits are not taken. |
| lua | `01aa7a1` (D9) | `master` at `f682826`, 6 commits above the pin, observed 2026-10-31 | Commit subjects describe 64-bit integer and mbbiDirect support, lsi and lso support, array support, example and release note updates, and a test fix. Four of the six commits were scored by five reviewers and none met the rule. D49 keeps the pin `01aa7a1`; the six commits are not taken. Step 6.3 needs no pin edit; module build and IOC acceptance remain pending. |
| ADSimDetector | `0ef1305` | No later commits; `master` matches the pin, observed 2026-10-31 | Latest tag `R2-11` precedes the pin. D34 keeps the pin: it is the head of the upstream branch, and no module consumes it. |
| ADVimba | `tags/R1-5` | `master` at `ddeb021`, 9 commits above the pin, observed 2026-10-31 | Latest tag remains `R1-5`. The commits change configuration files, the example IOC and an example Makefile only, no header or library source; `conf.ADVimba` rewrites the configuration files this build reads and leaves the example IOC unbuilt, and the example program builds the same on Linux. D34 keeps the pin; the nine commits are not taken. |
| siteApps | `0.1.0` | Latest tag and `master` match the pin; no later commits, observed 2026-11-01 | No consumer in either repository and nothing newer to take. D34 keeps the pin `0.1.0`. |
| unidrv | `0.5.1` | `main` at `e5a8561`, 4 commits above the pin (2 merges), observed 2026-10-29 | Latest tag remains `0.5.1`; these are branch commits, not a newer release tag. No consumer; the changes are the content of the site patch and the removal of an unused file. D50 moves the pin to `e5a8561` and retires the site patch in the cycle. |

## Modules

Rows 1 to 37 are owned by EPICS-env; rows 38 and 39 are owned by the site
module repository. The numbers identify inventory rows, not the final combined
cycle order. D3 records the order of the 37 EPICS-env modules; D25 required step
5 to determine the site modules' positions from verified dependencies, and D51
gives the combined order, in which the site modules follow the EPICS-env modules
except the two re-pins of identical code.

The issue of a module is opened at its plan step (D20) with the label
`enhancement`, as #100 and the issues of the earlier run carry it, and its
section below is added at that step.

| No. | Module | Pin | Outcome | Issue | State |
| --- | --- | --- | --- | --- | --- |
| 1 | epics-base | `tags/R7.0.10` | HOLD (D26) | #111, closed 2026-11-02 | complete |
| 2 | pvxs | `tags/1.5.2` -> `tags/1.5.3` | IN (D5), two carry patches selected (D27) | #114, closed 2026-11-03 | complete |
| 3 | MCoreUtils | `a86e5ed` | unchanged | #115, closed 2026-11-03 | complete |
| 4 | autosave | `tags/R6-0` | pin unchanged, two carry patches selected (D28) | #116, closed 2026-11-03 | complete |
| 5 | ether_ip | `tags/ether_ip-3-10` | pin unchanged, no additional carry patch (D29) | #117, closed 2026-11-03 | complete |
| 6 | iocStats | `tags/4.0.1` | pin unchanged, no additional carry patch (D30) | none | complete |
| 7 | recsync | `9834b94` | HOLD (D17) | none | complete |
| 8 | retools | `5ada1e1` | unchanged | none | complete |
| 9 | sequencer | `tags/R2-2-9` | pin unchanged, no additional carry patch (D31) | none | complete |
| 10 | snmp | `tags/v1.1.0.4ja` | unchanged | none | complete |
| 11 | opcua | `tags/v0.11.2` | pin and two existing patches unchanged, no additional carry (D32) | none | complete |
| 12 | pcas | `e075fd4` | HOLD (D16) | none | complete |
| 13 | pscdrv | `276daca` | unchanged | none | complete |
| 14 | linStat | `tags/1.2.1` | five carries plus RTC site correction prepared (D33), full-cycle verification pending | #118, closed 2026-11-03 | complete |
| 15 | feed-core | `0472d88` | pin and existing lib-only patch unchanged (D34) | none | complete |
| 16 | sscan | `e13699e` -> `ce9660c` | IN (D7), one carry prepared (D39), full-cycle verification pending | #119, closed 2026-11-03 | complete |
| 17 | calc | `4217e83` -> `tags/R3-8` | IN (D6) | #121, closed 2026-11-03 | complete |
| 18 | asyn | `tags/R4-46` | pin unchanged, no additional carry (D34) | none | complete |
| 19 | QPC | `913fad4` | pin and existing data-only patch unchanged (D34) | none | complete |
| 20 | modbus | `tags/R3-4` | pin unchanged, one curated carry prepared (D37), full-cycle verification pending | #122, closed 2026-11-03 | complete |
| 21 | lua | `17475b5` -> `01aa7a1` | IN (D9), no newer upstream release (D34), no carry (D49) | #123, closed 2026-11-03 | complete |
| 22 | std | `5f2e442` -> `27b6967` | IN (D8) | #124, closed 2026-11-04 | complete |
| 23 | StreamDevice | `tags/2.8.26` | pin and two local patches unchanged, one carry prepared (D38), full-cycle verification pending | #125, closed 2026-11-04 | complete |
| 24 | rgamv2 | `27fc633` | unchanged | none | complete |
| 25 | busy | `2dfe92d` -> `a4a272d` | IN (D10), no newer upstream release (D34) | #126, closed 2026-11-04 | complete |
| 26 | scaler | `beb5521` -> `baa8e1c` | IN (D11), no newer upstream release (D34) | #127, closed 2026-11-04 | complete |
| 27 | mca | `687d563` | unchanged, existing `mca-libnet` patch stays (D34) | none | complete |
| 28 | measComp | `c38974e` | HOLD (D15) | none | complete |
| 29 | motor | `285f44d` -> `4b22ac9` | IN (D12), no additional carry (see the [motor decision record](motor-carry-1.5.0.md)) | #128, closed 2026-11-04 | complete |
| 30 | motorMotorSim | `tags/R1-3` | unchanged (D34) | none | complete |
| 31 | pmac | `2-7-9` | HOLD (D47) | none | complete |
| 32 | ADCore | `ee039d2` | unchanged, one carry prepared (D40), full-cycle verification pending | #129, closed 2026-11-04 | complete |
| 33 | ADSimDetector | `0ef1305` | unchanged, no newer upstream release (D34) | none | complete |
| 34 | ADGenICam | `ba5b9b8` | unchanged, no newer upstream release (D34) | none | plan accepted |
| 35 | ADVimba | `tags/R1-5` | unchanged, no newer upstream release (D34) | at the plan step | plan drafted |
| 36 | caPutLog | `dafb0b2` -> `tags/R4.2` | IN (D13) | at the plan step | plan drafted |
| 37 | pyDevSup | `4527ed0` -> `tags/2.1.0` | IN (D14), two carries prepared (D48), full-cycle verification pending | at the plan step | plan drafted |
| 38 | siteApps | `0.1.0` | unchanged, no newer upstream release (D34) | at the plan step | plan drafted |
| 39 | unidrv | `0.5.1` -> `e5a8561` | IN (D50), site patch `unidrv-supportdbd` retired at the pin edit | at the plan step | plan drafted |

A module whose Pin column shows `old -> new` has its pin edited to the new
value in sub-step 3 of its cycle, unless `configure/RELEASE` already holds it.
An unchanged or HOLD module runs the whole cycle at its pin, and its section
records why the pin did not move.

### pvxs upstream observation

Observed 2026-10-29: the latest remote version tag is `1.5.3`, matching the
effective pin and prepared source at
`25ca43df4db909c0b1a445fb705fc81582617625` (commit dated 2026-09-25).
Remote HEAD names `master` at
`4311a854a0dda75b5e97cde7a10a38052f3ae90e`, dated 2026-10-28.
The branch contains six commits after `1.5.3`; there is no newer release tag.

D5 remains the accepted move to `1.5.3`. D27 selects two of the later branch
commits as carry patches under `upstream-fix-carry-procedure.md`; the other
four dispositions and the complete panel are in the
[carry decision record](pvxs-carry-1.5.0.md). The source pin is unchanged;
module build and runtime acceptance remain for the module cycle.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/PVXS`. Baseline pin: `tags/1.5.3`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `25ca43df4db909c0b1a445fb705fc81582617625` | 2026-09-25 | equal | 0 |
| Latest release tag `1.5.3` | `25ca43df4db909c0b1a445fb705fc81582617625` | 2026-09-25 | equal | 0 |
| Default branch `master` | `4311a854a0dda75b5e97cde7a10a38052f3ae90e` | 2026-10-28 | ahead | 6 |

The default branch contains 6 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Selective single-PUT writes, TCP listener backlog, address-list validation, removal of split_addr_into, and environment-variable documentation.

This table records the survey snapshot. D27 records the subsequent carry
selection; it does not claim build or runtime compatibility verification.

Issue: #114, https://github.com/jeonghanlee/EPICS-env/issues/114

Plan status: complete
Plan acceptance: 2026-11-02, the maintainer
Implementation authorization: 2026-11-02, the maintainer
Review findings and rulings: two passes of 2026-11-02 by sub-agents, one that verified each claim against the repository, the scripts, and #114, and one from the seat of the Executor, found every fact true except one: the plan said the pin did not move, where it moved earlier in this release by `e19efe7`, so the search for the old version of Stage 6 applies; the plan now names that commit, its files, and the one documentation line that keeps `1.5.2`. The plan also gained the `metadata-lines` label for the 38 count, the pass condition of the reverse-dependency search (every module it names is among the build-order dependents, ADCore here; a module outside that list is a finding), the one-command form of the ADCore rebuild, and the SONAME values; a third-person pass by the author on the corrected text found nothing above the floor. The maintainer accepted the plan and authorized the implementation on 2026-11-02.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/1.5.3` already, moved from `tags/1.5.2` by commit `e19efe7`
   (D5), so no pin edit is made and the commit of the accepted plan is the
   candidate. That commit also set the versions the loader suite names and the
   pin table of the book. At the end of the checks the 21 files that `e19efe7`
   rewrote (`git diff --name-only e19efe7^ e19efe7`) are searched for `1.5.2`;
   the one line that holds it, a sentence of a base patch report in
   `patch/README.md` that names the softIocPVX of PVXS 1.5.2 of that test, is
   not a pin and stays.
2. The two carry patches of D27, `patch/1.5.3-01-7176098-single-put-marked-value.p0.patch`
   and `patch/1.5.3-02-96345dd-tcp-listener-backlog.p0.patch`, are applied by
   `patch.pvxs.commit.apply`, which `guest-update.bash pvxs PVXS <candidate> ~/sandbox/EPICS-env`
   runs before the build; the log shows two `Patching pvxs-src` lines.
3. The one dependent is ADCore (`build.pvxs` in its `_DEPS` line); it is
   rebuilt on each machine after the update by one command,
   `cd ~/sandbox/EPICS-env && make distclean.ADCore && make conf.ADCore && make build.ADCore`
   (label `rebuild-ADCore`, whose `rc=0` then covers the three), its top
   Makefile passing no `realuninstall` to an `iocs` directory, so `distclean`
   is safe.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> pvxs ~/sandbox`
   on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/pvxs ~/sandbox/alsu-site-modules`
   on both, `make check.deps` and `make check.env` on both, and the search for
   the reverse dependencies of pvxs in the installed tree over
   `$(make -s print-INSTALL_LOCATION_EPICS)/modules`, once per stem `pvxs` and
   `pvxsIoc` and once by the module name, as Stage 3 sets out, with the result
   in `work/pvxs-bump/reverse-deps.md`; the search is good when every module it names is
   ADCore, the one build-order dependent (its libraries under
   `modules/ADCore-ee039d2` and the `dep=pvxs` line of its `cfg/iocsh.conf`);
   the `linStat` example is excluded by its configuration and the site checkout
   names pvxs nowhere, so any other module it names is a finding for the
   maintainer. The 38 count of the suite is read on each
   machine with
   `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/pvxs/verify_install_metadata.log`
   (label `metadata-lines`). Every command runs through
   `tools/module-check/guest-run.bash` with `work/pvxs-bump/` as its log
   directory, with the labels of The checks (`build`, `patch-round-trip`,
   `consumers`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`),
   `rebuild-ADCore`, and `metadata-lines`.
5. A check that is not good stops the cycle at that check with its log kept;
   the maintainer classifies the failure and decides, as the rule of a failed
   Stage 6 sets out.

Results, candidate `dae57c3`, logs in `work/pvxs-bump/` of the local checkout
(written by `tools/module-check/guest-run.bash`; the logs of the two failed
runs below keep the suffix `-failed` and `-failed2`):

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: two `Patching pvxs-src` lines before the build, `link: modules/pvxs -> ./pvxs-1.5.3`, `SONAME libpvxs.so: libpvxs.so.1.5` and `SONAME libpvxsIoc.so: libpvxsIoc.so.1.5`, `UPDATE-DONE pvxs <candidate>` | 2026-11-02 23:04 to 23:07 UTC (Rocky), 2026-11-03 00:16 to 00:18 UTC (Debian, on the rebuilt tree) | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching pvxs-src with the file : .../1.5.3-01-7176098-single-put-marked-value.p0.patch` and `.../1.5.3-02-96345dd-tcp-listener-backlog.p0.patch` after `make PVXS`, `link: modules/pvxs -> ./pvxs-1.5.3`, both SONAME lines, `UPDATE-DONE pvxs dae57c3`, `rc=0` |
| `rebuild-ADCore`: `rc=0` | 2026-11-02 23:08 UTC (Rocky), 2026-11-03 00:18 to 00:33 UTC (Debian, in `build-debian13.log` after the update) | Debian 13, Rocky Linux 8.10 | pass | `rebuild-ADCore-rocky8.log` and `build-debian13.log` end `rc=0` after `make distclean.ADCore`, `make conf.ADCore`, `make build.ADCore` |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching pvxs-src lines: 2`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-02 23:08 to 23:13 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: all five lines, `Patching lines: 45`, `ROUNDTRIP-DONE dae57c3` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-02 23:37 to 23:49 UTC (Rocky), 2026-11-03 00:20 to 00:33 UTC (Debian) | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: the four lines, all 14 scripts `fail=0`, `records listed` 322 (Rocky) and 327 (Debian); `metadata-lines-<os>.log`: the two `OK` lines |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside ADCore | 2026-11-02 23:50 UTC (Rocky), 2026-11-03 00:34 UTC (Debian) | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log` `RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log` `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: `libpvxs` needed by `libntndArrayConverter.so`, `libntndArrayConverterPvxs.so`, `libNDPlugin.so` of ADCore, `libpvxsIoc` by `libNDPlugin.so`, `dep=pvxs` in the `iocsh.conf` of ADCore only; `reverse-deps.md` |
| No `1.5.2` left in the 21 files that `e19efe7` rewrote, except the base patch report sentence of `patch/README.md` | 2026-11-02 23:15 UTC | local host | pass | `old-version-grep.txt`: one line, `patch/README.md:294` |

Two runs of the suite failed before these results, both for a defect of the
test machines and not of pvxs, as the maintainer classified them on
2026-11-02: the first run on both machines ran out of disk (`No space left
on device` in `installed-tree-env-rocky8-failed.log`; the guests of 20 GiB
held the tree copies of three earlier suite runs, about 2.7 GB each under
`<log_dir>/copies`), and that failed run left the Debian tree damaged (a
`libasyn.so` of 717,552 bytes and no `modules/asyn` link), so the second
Debian run failed on every check that loads asyn
(`consumers-debian13-failed2.log`). The maintainer approved the removal of
the copies, and the Debian tree was rebuilt at the candidate as The checks,
item 3, sets out (`rebuild-tree-debian13.log`, `BUILD-END rc=0`, 2026-11-03
00:00 to 00:15 UTC; `make exist` lists the tree, `check.deps` `ALL 79`,
`check.env` no finding) with the site modules installed again at `1a31f30`
(`site-reinstall-debian13.log`, `modules` entries 77); the damaged tree was
removed after that. The Rocky tree was not damaged (`libasyn.so` 4,225,920
bytes, both links present) and its second run passed. The lesson is in
Lessons learned; the suite copies are the subject of the tool work before the
next cycle.

Closure: the results commit `213deea` landed on `origin/release-1.5.0`
(observed with `git ls-remote` on 2026-11-03). Issue #114 was closed on
2026-11-03 at 00:43 UTC with its body synced to these results (the five
acceptance criteria checked with their results and the two failed runs
stated) and a closing comment, and its closed state was read back. The cycle
of pvxs is complete.

### MCoreUtils upstream observation

Observed 2026-10-29: remote HEAD names `main` at
`a86e5ed193abaae5744f9a5545fc883a9348258d`, dated 2026-09-11.
The effective commit pin `a86e5ed` and prepared source HEAD resolve to that
same commit. There are no later commits on the observed default branch;
the recorded outcome remains unchanged. This observation does not complete
the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/MCOREUTILS`. Baseline pin: `a86e5ed`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `a86e5ed193abaae5744f9a5545fc883a9348258d` | 2026-09-11 | equal | 0 |
| Latest release tag `1.2.3` | `8990b59f180552fbf33697be04190381f3075643` | 2025-09-12 | behind | 0 |
| Default branch `main` | `a86e5ed193abaae5744f9a5545fc883a9348258d` | 2026-09-11 | equal | 0 |

The baseline contains 4 commits beyond the tag; the tag adds none.
The default branch contains 4 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #115, https://github.com/jeonghanlee/EPICS-env/issues/115

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: two passes of 2026-11-03 by the author, one that re-derived each fact from `configure/RELEASE`, `configure/RULES_SRC`, `configure/CONFIG_MODS_DEPS`, and the installed tree of the Debian 13 machine (the link, the one library and its SONAME `libmcoreutils.so`, no installed library that needs it, no `dep=` line that names it, no site module that names it), and one from the seat of the Executor who runs the cycle, found nothing above the floor; the maintainer accepted the plan and authorized the implementation the same day.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `a86e5ed` (version a86e5ed) and does not move (unchanged), so no pin edit is made and the commit of the accepted plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash MCoreUtils MCOREUTILS <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.MCoreUtils` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> MCoreUtils ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/MCoreUtils ~/sandbox/alsu-site-modules` on both, `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of MCoreUtils in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libmcoreutils` and the module name, as Stage 3 sets out, with the result in `work/MCoreUtils-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/MCoreUtils/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash MCoreUtils MCOREUTILS <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/MCoreUtils-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/MCoreUtils -> ./MCoreUtils-a86e5ed`, the `libmcoreutils` SONAME, `UPDATE-DONE MCoreUtils <candidate>` | 2026-11-03 04:34 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching MCoreUtils-src lines: 0`, `link: modules/MCoreUtils -> ./MCoreUtils-a86e5ed`, `SONAME libmcoreutils.so: libmcoreutils.so`, `UPDATE-DONE MCoreUtils e10a156`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching MCoreUtils-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 04:34 to 04:38 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching MCoreUtils-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 04:38 to 04:55 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `minimal IOC exit=0`, `iocRun lines: 1`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `free before:`/`free after:` 18461312/18406460 KB (Debian) and 19462896/19388248 KB (Rocky), `rc=0`; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 04:55 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem mcoreutils` and `== dep=MCoreUtils` on both, `work/MCoreUtils-bump/reverse-deps.md` judged: no consumer |

Closure: the results commit `c749f40` landed on `origin/release-1.5.0`
(observed with `git rev-parse HEAD '@{upstream}'` on 2026-11-03). Issue #115
was closed on 2026-11-03 at 07:41 UTC with its body synced to these results
(the four acceptance criteria checked with their results, the candidate and
the results commit named) and a closing comment, and its closed state was read
back. The cycle of MCoreUtils is complete; the first cycle run end to end by
`cycle.bash` took 20 minutes, of which the module build took 8 seconds, the
patch round trip 4 minutes, and the loader suite 15 to 16 minutes on each
machine.

### autosave upstream observation

Observed 2026-10-29: the latest remote release tag is `R6-0`, matching the
effective pin and prepared source at
`03b94f803be4e1844699a9c56562c96406242591`.
Remote HEAD names `master` at
`5e5957b984a97fc2dcc1202e163ef2ebf6de8f6d`, dated 2026-09-17.
The branch contains 21 commits after `R6-0`; there is no newer release tag.

The tag comparison remains unchanged. D28 settles the branch carry selection
with two patches and retains the source pin. The carry decision record
separates source applicability from pending build and IOC acceptance.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/AUTOSAVE`. Baseline pin: `tags/R6-0`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `03b94f803be4e1844699a9c56562c96406242591` | 2025-12-12 | equal | 0 |
| Latest release tag `R6-0` | `03b94f803be4e1844699a9c56562c96406242591` | 2025-12-12 | equal | 0 |
| Default branch `master` | `5e5957b984a97fc2dcc1202e163ef2ebf6de8f6d` | 2026-09-17 | ahead | 21 |

The default branch contains 21 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Long-string and zero-length waveform handling, save/restore delay and version checks, iocshSetError compatibility, dependency macros, and documentation.

This survey records source changes. D28 records the later carry selection;
the module cycle has not started.

Issue: #116, https://github.com/jeonghanlee/EPICS-env/issues/116

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: two passes of 2026-11-03 by the author, one that re-derived each fact from `configure/RELEASE`, `configure/RULES_SRC`, `configure/CONFIG_MODS_DEPS`, the patch files, and the installed tree of the Debian 13 machine (the link, the one library and its SONAME `libautosave.so`, the one library that needs it in mca and the `dep=` lines of busy, mca, measComp, and scaler, all among the four dependents; scaler the one dependent rebuilt from a new source tree), and one from the seat of the Executor who runs the cycle, found nothing above the floor; the maintainer accepted the plan and authorized the implementation the same day.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R6-0` (version 6.0.0) and does not move (pin unchanged, two carry patches selected (D28)), so no pin edit is made and the commit of the accepted plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.autosave.commit.apply` with the files `6.0.0-01-f5b7da3-unknown-errno.p0.patch`, `6.0.0-02-49159fc-configmenu-loaded-name.p0.patch` are run by `guest-update.bash autosave AUTOSAVE <candidate> ~/sandbox/EPICS-env` before the build; the log shows 2 `Patching autosave-src` lines.
3. The dependents, the modules whose `_DEPS` line lists `build.autosave`, are busy, scaler, mca, measComp; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three), except scaler, whose `distclean` is unsafe by The checks, item 1, and which is rebuilt from a new source tree instead (move `<d>-src` aside, `make <D_KEY>`, the apply targets of `<d>` if any, `make conf.<d>`, `make build.<d>`).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> autosave ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/autosave ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of autosave in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libautosave` and the module name, as Stage 3 sets out, with the result in `work/autosave-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (busy, scaler, mca, measComp), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/autosave/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash autosave AUTOSAVE <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/autosave-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 2 `Patching autosave-src` lines before the build, `link: modules/autosave -> ./autosave-6.0.0`, the `libautosave` SONAME, `UPDATE-DONE autosave <candidate>` | 2026-11-03 09:26 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching autosave-src with the file : .../6.0.0-01-f5b7da3-unknown-errno.p0.patch` and `.../6.0.0-02-49159fc-configmenu-loaded-name.p0.patch` after `make AUTOSAVE`, `link: modules/autosave -> ./autosave-6.0.0`, `SONAME libautosave.so: libautosave.so`, `UPDATE-DONE autosave 1557057`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for busy, scaler, mca, measComp | 2026-11-03 09:26 to 09:28 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{busy,scaler,mca,measComp}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for busy, mca, and measComp, `rebuild form: new source tree` for scaler |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching autosave-src lines: 2`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 09:28 to 09:32 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching autosave-src lines: 2`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 09:32 to 09:39 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example verify_fixture_tc32sim`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `verify_fixture_tc32sim` `ok=24`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside busy, scaler, mca, measComp | 2026-11-03 09:39 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: `libmcaRontec.so` of mca under `== stem autosave` and the `cfg/iocsh.conf` of busy, mca, measComp, and scaler under `== dep=autosave` on both, all among the four dependents, `work/autosave-bump/reverse-deps.md` judged |

Closure: the results commit `25b94a1` landed on `origin/release-1.5.0`
(observed with `git rev-parse HEAD '@{upstream}'` on 2026-11-03). Issue #116
was closed on 2026-11-03 at 16:18 UTC with its body synced to these results
(the five acceptance criteria checked with their results, the candidate and
the results commit named) and a closing comment, and its closed state was read
back. The cycle of autosave is complete; the first cycle run with the module
scripts of the suite took 13 minutes, of which the suite took 4 to 6 minutes
on each machine.

### ether_ip upstream observation

Observed 2026-10-29: the latest remote release tag is `ether_ip-3-10`,
matching the effective pin and prepared source at
`b069447cd55d3d72a1a58e40f18b3ec2870415e5`.
Remote HEAD names `master` at
`15432f07490f631bf5e2a951c45c6f056726221e`, dated 2026-07-29.
The branch contains three commits after `ether_ip-3-10`; there is no newer
release tag.

The remote tag and branch HEAD were rechecked on 2026-10-30 and were unchanged.
D29 retains the source pin and selects no additional carry patch. The module
cycle has not started.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/ETHERIP`. Baseline pin: `tags/ether_ip-3-10`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `b069447cd55d3d72a1a58e40f18b3ec2870415e5` | 2026-02-19 | equal | 0 |
| Latest release tag `ether_ip-3-10` | `b069447cd55d3d72a1a58e40f18b3ec2870415e5` | 2026-02-19 | equal | 0 |
| Default branch `master` | `15432f07490f631bf5e2a951c45c6f056726221e` | 2026-07-29 | ahead | 3 |

The default branch contains 3 commits beyond this tag.

Diff inspection: `f97b093` changes only wording in `changes.md`; its subject
`test` does not describe a test-code change. `b486c6d` adds
`USR_CFLAGS_vxWorks += -std=c99` to `ether_ipApp/src/Makefile`.
Merge `15432f0` has the same tree as `b486c6d`, so it adds no separate fix.

D29 records the Maintainer's decision to retain the pin without carrying this
VxWorks-only change for the Linux release scope. No panel scoring, patch
generation, build, or IOC verification was performed for this decision.

Issue: #117, https://github.com/jeonghanlee/EPICS-env/issues/117

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: two passes of 2026-11-03 by the author, one that re-derived each fact from `configure/RELEASE`, `configure/RULES_SRC`, `configure/CONFIG_MODS_DEPS`, and the installed tree of the Debian 13 machine (the link, the one library and its SONAME `libether_ip.so`, no installed library that needs it, no `dep=` line that names it, no site module that names it), and one from the seat of the Executor who runs the cycle, found nothing above the floor; the maintainer accepted the plan and authorized the implementation the same day.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/ether_ip-3-10` (version 3.10.0) and does not move (pin unchanged, no additional carry patch (D29)), so no pin edit is made and the commit of the accepted plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash ether_ip ETHERIP <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.ether_ip` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> ether_ip ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/ether_ip ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of ether_ip in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libether_ip` and the module name, as Stage 3 sets out, with the result in `work/ether_ip-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/ether_ip/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash ether_ip ETHERIP <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/ether_ip-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/ether_ip -> ./ether_ip-3.10.0`, the `libether_ip` SONAME, `UPDATE-DONE ether_ip <candidate>` | 2026-11-03 16:27 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching ether_ip-src lines: 0`, `link: modules/ether_ip -> ./ether_ip-3.10.0`, `SONAME libether_ip.so: libether_ip.so`, `UPDATE-DONE ether_ip 740250b`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching ether_ip-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 16:27 to 16:33 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching ether_ip-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 16:33 to 16:36 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 16:36 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem ether_ip` and `== dep=ether_ip` on both, `work/ether_ip-bump/reverse-deps.md` judged: no consumer |

Closure: the results commit `6908834` landed on `origin/release-1.5.0`
(observed with `git rev-parse HEAD '@{upstream}'` on 2026-11-03). Issue #117
was closed on 2026-11-03 at 16:41 UTC with its body synced to these results
(the four acceptance criteria checked with their results, the candidate and
the results commit named) and a closing comment, and its closed state was read
back. The cycle of ether_ip is complete, in 9 minutes; it is the last cycle
with an issue for an unchanged pin, by the rule of step 6, sub-step 1.

### iocStats upstream observation

Observed 2026-10-29: the latest remote release tag is `4.0.1`, matching the
effective pin and prepared source at
`b0a51778f50b97cd9c50d0aa0e03a7b7ee2f3a84`.
Remote HEAD names `master` at
`fd31816ca445307721cf1385cc8d03406042d3e4`, dated 2026-09-22.
The branch contains 11 commits after `4.0.1`; there is no newer release tag.

The remote tag and branch HEAD were rechecked on 2026-10-30 and were unchanged.
D30 retains the source pin and selects no additional carry patch. The module
cycle has not started.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/IOCSTATS`. Baseline pin: `tags/4.0.1`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `b0a51778f50b97cd9c50d0aa0e03a7b7ee2f3a84` | 2026-04-29 | equal | 0 |
| Latest release tag `4.0.1` | `b0a51778f50b97cd9c50d0aa0e03a7b7ee2f3a84` | 2026-04-29 | equal | 0 |
| Default branch `master` | `fd31816ca445307721cf1385cc8d03406042d3e4` | 2026-09-22 | ahead | 11 |

The default branch contains 11 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Single-CPU load and memory records, GiB units, waveform-based script/path fields, long environment-variable handling, and display updates.

D30 records the Maintainer's decision to preserve the current version and
behavior. The 11 post-pin commits are not carried in this release. No panel
scoring, patch generation, build, or IOC verification was performed for this
decision.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the one library `libdevIocStats.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/4.0.1` (version 4.0.1) and does not move (pin unchanged, no additional carry patch (D30)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash iocStats IOCSTATS <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.iocStats` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> iocStats ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/iocStats ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of iocStats in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libdevIocStats` and the module name, as Stage 3 sets out, with the result in `work/iocStats-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/iocStats/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash iocStats IOCSTATS <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/iocStats-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/iocStats -> ./iocStats-4.0.1`, the `libdevIocStats` SONAME, `UPDATE-DONE iocStats <candidate>` | 2026-11-03 16:52 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching iocStats-src lines: 0`, `link: modules/iocStats -> ./iocStats-4.0.1`, `SONAME libdevIocStats.so: libdevIocStats.so`, `UPDATE-DONE iocStats 7523544`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching iocStats-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 16:52 to 17:00 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching iocStats-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 17:00 to 17:03 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 17:03 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem devIocStats` and `== dep=iocStats` on both, `work/iocStats-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `7523544`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of iocStats is complete,
in 10 minutes, with its acceptance, results, and closure in one commit.

### recsync upstream observation

Observed 2026-10-29: the effective commit pin and prepared source remain at
`9834b94edc63eece42712b8355a4703d4286dd8f`.
Remote HEAD names `master` at
`79ebf6c1a3123a77ee1d94a5f43531ca1b80665b`, dated 2026-10-13.
The branch contains 276 commits after the pin. The remote tags include the
latest stable release `1.10.0` at
`e749f9e5a32af21099cc76a51789a40dc8d6ec89` and the later release candidate
`1.10.1-rc1` at `3a408bf482b3532e49e1b8e423407f52985f48e6`.

At the observed branch head, `client/Makefile` points to the separate
ChannelFinder/reccaster repository and contains an `exit 1` recipe.
This source inspection confirms the repository-migration reason recorded in
D17; it is not a build result. HOLD remains in effect, and the repository
switch stays outside 1.5.0 under issue #101. The source pin is unchanged.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/RECSYNC`. Baseline pin: `9834b94`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `9834b94edc63eece42712b8355a4703d4286dd8f` | 2025-12-03 | equal | 0 |
| Latest release tag `1.10.0` | `e749f9e5a32af21099cc76a51789a40dc8d6ec89` | 2026-08-11 | ahead | 268 |
| Prerelease tag `1.10.1-rc1` | `3a408bf482b3532e49e1b8e423407f52985f48e6` | 2026-10-09 | ahead | 274 |
| Default branch `master` | `79ebf6c1a3123a77ee1d94a5f43531ca1b80665b` | 2026-10-13 | ahead | 276 |

The default branch contains 8 commits beyond this tag.
The later 1.10.1-rc1 tag is a prerelease; 1.10.0 is the latest stable release tag.

Change summary from commit subjects and changed-file lists: Client migration to reccaster; server configuration, transaction handling, ChannelFinder integration, metrics, logging, tests, packaging, and CI changes. Later commits after 1.10.0 adjust Python compatibility, Unicode error handling, logging, and a SonarQube finding.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the one library `libreccaster.so` and its SONAME `libreccaster.so.0`, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `9834b94` (version 9834b94) and does not move (HOLD (D17)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash recsync RECSYNC <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.recsync` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> recsync ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/recsync ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of recsync in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libreccaster` and the module name, as Stage 3 sets out, with the result in `work/recsync-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/recsync/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash recsync RECSYNC <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/recsync-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/recsync -> ./recsync-9834b94`, the `libreccaster` SONAME, `UPDATE-DONE recsync <candidate>` | 2026-11-03 17:12 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching recsync-src lines: 0`, `link: modules/recsync -> ./recsync-9834b94`, `SONAME libreccaster.so: libreccaster.so.0`, `UPDATE-DONE recsync 9d68ad7`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching recsync-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 17:12 to 17:17 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching recsync-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 17:17 to 17:20 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 17:20 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem reccaster` and `== dep=recsync` on both, `work/recsync-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `9d68ad7`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of recsync is complete, in
8 minutes.

### retools upstream observation

Observed 2026-10-29: remote HEAD names `master` at
`5ada1e1573969c242d2af922c2021e9c7971dbff`, dated 2024-09-28.
The effective commit pin `5ada1e1` and prepared source HEAD resolve to that
same commit. There are no later commits on the observed default branch;
the recorded outcome remains unchanged. This observation does not complete
the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/RETOOLS`. Baseline pin: `5ada1e1`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `5ada1e1573969c242d2af922c2021e9c7971dbff` | 2024-09-28 | equal | 0 |
| Latest release tag `R1-4-1` | `809aaa0857b687a1ae588de146711944755341af` | 2019-06-19 | behind | 0 |
| Default branch `master` | `5ada1e1573969c242d2af922c2021e9c7971dbff` | 2024-09-28 | equal | 0 |

The baseline contains 31 commits beyond the tag; the tag adds none.
The default branch contains 31 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the one library `libretools.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `5ada1e1` (version 5ada1e1) and does not move (unchanged), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash retools RETOOLS <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.retools` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> retools ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/retools ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of retools in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libretools` and the module name, as Stage 3 sets out, with the result in `work/retools-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/retools/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash retools RETOOLS <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/retools-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/retools -> ./retools-5ada1e1`, the `libretools` SONAME, `UPDATE-DONE retools <candidate>` | 2026-11-03 17:23 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching retools-src lines: 0`, `link: modules/retools -> ./retools-5ada1e1`, `SONAME libretools.so: libretools.so`, `UPDATE-DONE retools 14c61ec`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching retools-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 17:23 to 17:29 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching retools-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 17:29 to 17:33 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example verify_fixture_tc32sim`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `verify_fixture_tc32sim` `ok=24`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 17:33 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem retools` and `== dep=retools` on both, `work/retools-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `14c61ec`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of retools is complete, in
10 minutes.

### sequencer upstream observation

Observed 2026-10-29: the latest remote release tag is `R2-2-9`, matching the
effective pin and prepared source at
`e5e361509df1c0d3c667872243d8f7a9894514b4`.
Remote HEAD names `main` at
`de4f7c21fb73a4fe780fa25c78d725ac050409de`, dated 2026-05-29.
The branch contains 16 commits after `R2-2-9`; there is no newer release tag.

The remote tag and branch HEAD were rechecked on 2026-10-30 and were unchanged.
D31 retains the source pin and selects no additional carry patch. The module
cycle has not started.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/SNCSEQ`. Baseline pin: `tags/R2-2-9`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `e5e361509df1c0d3c667872243d8f7a9894514b4` | 2021-05-19 | equal | 0 |
| Latest release tag `R2-2-9` | `e5e361509df1c0d3c667872243d8f7a9894514b4` | 2021-05-19 | equal | 0 |
| Default branch `main` | `de4f7c21fb73a4fe780fa25c78d725ac050409de` | 2026-05-29 | ahead | 16 |

The default branch contains 16 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Queue implementation and tests, parser prototypes, EPICS 7 test support, CI, and documentation/source-hosting updates.

D31 records the Maintainer's decision to preserve the current version and
behavior. The 16 post-pin commits are not carried in this release. No panel
scoring, patch generation, build, or IOC verification was performed for this
decision.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none against the plan; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link `modules/seq`, the two `lib=` libraries `libseq.so` and `libpv.so`, the libraries of asyn, calc, measComp, sscan, and std that need them, the `dep=seq` lines of all seven dependents, no site module that names it) before the acceptance. That check found a defect of `cycle.bash`: it searched the `dep=` lines by the module name, where they carry the installed name (`seq`); fixed at `b8267d2` before this cycle, with no effect on the earlier cycles, whose installed names equal their module names.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R2-2-9` (version 2.2.9) and does not move (pin unchanged, no additional carry patch (D31)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash sequencer SNCSEQ <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.sequencer`, are sscan, calc, asyn, std, mca, measComp, motor; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three), except std, whose `distclean` is unsafe by The checks, item 1, and which is rebuilt from a new source tree instead (move `<d>-src` aside, `make <D_KEY>`, the apply targets of `<d>` if any, `make conf.<d>`, `make build.<d>`).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> sequencer ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/sequencer ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of sequencer in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libseq`, `libpv` and the module name, as Stage 3 sets out, with the result in `work/sequencer-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (sscan, calc, asyn, std, mca, measComp, motor), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/sequencer/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash sequencer SNCSEQ <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/sequencer-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/seq -> ./seq-2.2.9`, the `libseq` and `libpv` SONAMEs, `UPDATE-DONE sequencer <candidate>` | 2026-11-03 17:38 to 17:39 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching sequencer-src lines: 0`, `link: modules/seq -> ./seq-2.2.9`, `SONAME libseq.so: libseq.so`, `SONAME libpv.so: libpv.so` (and the two support libraries `libcmdButtonsSupport.so`, `libseqSoftIocSupport.so`), `UPDATE-DONE sequencer b8267d2`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for sscan, calc, asyn, std, mca, measComp, motor | 2026-11-03 17:39 to 17:42 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{sscan,calc,asyn,std,mca,measComp,motor}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for six, `rebuild form: new source tree` for std |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching sequencer-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 17:42 to 17:48 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching sequencer-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 17:48 to 17:51 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside sscan, calc, asyn, std, mca, measComp, motor | 2026-11-03 17:51 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: the libraries of asyn (its two test libraries, in both installed versions), calc, measComp, sscan, and std under `== stem seq` and `== stem pv`, and the `cfg/iocsh.conf` of all seven dependents under `== dep=seq`, `reverse-deps names: asyn calc mca measComp motor sscan std`, `outside the dependents: none` on both; `work/sequencer-bump/reverse-deps.md` judged |

Closure: candidate `b8267d2`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of sequencer is complete,
in 13 minutes with the seven dependents rebuilt.

### snmp upstream observation

Observed 2026-10-29: the latest remote release tag is `v1.1.0.4ja`,
matching the effective pin and prepared source at
`db9ebf51bc81d6f63d9395513d94d60b3b7eda83`, dated 2023-10-18.
Remote HEAD names `master` at that same commit. There is no newer release
tag and no later commit on the observed default branch; the recorded outcome
remains unchanged. This observation does not complete the combined upstream
survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/SNMP`. Baseline pin: `tags/v1.1.0.4ja`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `db9ebf51bc81d6f63d9395513d94d60b3b7eda83` | 2023-10-18 | equal | 0 |
| Latest release tag `v1.1.0.4ja` | `db9ebf51bc81d6f63d9395513d94d60b3b7eda83` | 2023-10-18 | equal | 0 |
| Default branch `master` | `db9ebf51bc81d6f63d9395513d94d60b3b7eda83` | 2023-10-18 | equal | 0 |

The default branch contains 0 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the one library `libdevSnmp.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/v1.1.0.4ja` (version 1.1.0.4ja) and does not move (unchanged), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash snmp SNMP <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.snmp` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> snmp ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/snmp ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of snmp in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libdevSnmp` and the module name, as Stage 3 sets out, with the result in `work/snmp-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/snmp/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash snmp SNMP <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/snmp-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/snmp -> ./snmp-1.1.0.4ja`, the `libdevSnmp` SONAME, `UPDATE-DONE snmp <candidate>` | 2026-11-03 17:53 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching snmp-src lines: 0`, `link: modules/snmp -> ./snmp-1.1.0.4ja`, `SONAME libdevSnmp.so: libdevSnmp.so`, `UPDATE-DONE snmp 6a12ed5`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching snmp-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 17:53 to 17:59 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching snmp-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 17:59 to 18:01 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 18:01 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem devSnmp` and `== dep=snmp` on both, `work/snmp-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `6a12ed5`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of snmp is complete, in
8 minutes.

### opcua upstream observation

Observed 2026-10-29: the latest remote release tag is `v0.11.2`, matching
the effective pin and prepared source at
`f9b0c92faabf466e389782b7747d2162456a2b20`.
Remote HEAD names `master` at
`e3cad37b0672100d994ac4c0e225127667e9d1a4`, dated 2026-07-21.
The branch contains 25 commits after `v0.11.2`; there is no newer release tag.

The remote tag and branch HEAD were rechecked on 2026-10-30 and were unchanged.
D32 retains the source pin and both existing patches, with no additional carry
patch. The module cycle has not started.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/OPCUA`. Baseline pin: `tags/v0.11.2`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `f9b0c92faabf466e389782b7747d2162456a2b20` | 2025-11-17 | equal | 0 |
| Latest release tag `v0.11.2` | `f9b0c92faabf466e389782b7747d2162456a2b20` | 2025-11-17 | equal | 0 |
| Default branch `master` | `e3cad37b0672100d994ac4c0e225127667e9d1a4` | 2026-07-21 | ahead | 25 |

The default branch contains 25 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Node/Leaf data-element refactoring, structure counters, registry-header rename, UASDK cleanup, compiler/build support, and documentation.

D32 records the Maintainer's decision to preserve the current version and
patch set. Diff inspection shows that upstream `485922c` and the existing
`opcua-anon-ns-export` patch both move the two export declarations outside
the unnamed namespace. No additional post-pin commit is carried. No panel
scoring, new patch generation, build, or IOC verification was performed for
this decision.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the two fixed-name patch files unchanged in this release) and the installed tree of the Debian 13 machine (the link, the one library `libopcua.so` and its SONAME `libopcua.so.0.11`, no installed library that needs it, no `dep=` line that names it, no site module that names it, podman present for the fixture) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/v0.11.2` (version 0.11.2) and does not move (pin and two existing patches unchanged, no additional carry (D32)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.opcua.apply`, `patch.opcua.export.apply` are run by `guest-update.bash opcua OPCUA <candidate> ~/sandbox/EPICS-env` before the build; the log shows 2 `Patching opcua-src` lines.
3. No module lists `build.opcua` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> opcua ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/opcua ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_opcua` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of opcua in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libopcua` and the module name, as Stage 3 sets out, with the result in `work/opcua-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/opcua/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash opcua OPCUA <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/opcua-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 2 `Patching opcua-src` lines before the build, `link: modules/opcua -> ./opcua-0.11.2`, the `libopcua` SONAME, `UPDATE-DONE opcua <candidate>` | 2026-11-03 18:06 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching opcua-src with the file : opcua-CONFIG_OPCUA.p0.patch` and `opcua-anon-ns-export.p0.patch` after `make OPCUA`, `link: modules/opcua -> ./opcua-0.11.2`, `SONAME libopcua.so: libopcua.so.0.11`, `UPDATE-DONE opcua 8395b2b`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching opcua-src lines: 2`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 18:06 to 18:13 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching opcua-src lines: 2`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_opcua`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 18:13 to 18:16 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example verify_fixture_opcua`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `verify_fixture_opcua` `ok=13`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 18:16 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem opcua` and `== dep=opcua` on both, `work/opcua-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `8395b2b`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of opcua is complete, in
10 minutes.

### pcas upstream observation

Observed 2026-10-29: the effective commit pin and prepared source remain at
`e075fd450ab9a66bbc044eaa4c2035d3d26d9651`.
Remote HEAD names `master` at
`bdf2b0ab4229e0bb69dbe9107dbb40c332db4f33`, dated 2026-07-20.
The branch contains two commits after the pin. The diff between these refs
changes only `.github/workflows/ci-scripts-build.yml`, confirming the
CI-only scope recorded in D16. HOLD remains in effect and the source pin is
unchanged. This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/PCAS`. Baseline pin: `e075fd4`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `e075fd450ab9a66bbc044eaa4c2035d3d26d9651` | 2025-09-03 | equal | 0 |
| Latest release tag `v4.13.3` | `6ba32b5c3b39d05dc16d8ea8b95b5a991bdb59b0` | 2021-12-09 | behind | 0 |
| Default branch `master` | `bdf2b0ab4229e0bb69dbe9107dbb40c332db4f33` | 2026-07-20 | ahead | 2 |

The baseline contains 7 commits beyond the tag; the tag adds none.
The default branch contains 9 commits beyond this tag.

Change summary from commit subjects and changed-file lists: CI workflow changes only; the file diff contains .github/workflows/ci-scripts-build.yml.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the two libraries `libcas.so` and `libgdd.so` with their SONAMEs `libcas.so.4.13.0` and `libgdd.so.4.13.0`, no installed library that needs either, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `e075fd4` (version e075fd4) and does not move (HOLD (D16)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash pcas PCAS <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.pcas` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> pcas ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/pcas ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of pcas in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libcas`, `libgdd` and the module name, as Stage 3 sets out, with the result in `work/pcas-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/pcas/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash pcas PCAS <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/pcas-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/pcas -> ./pcas-e075fd4`, the `libcas` and `libgdd` SONAMEs, `UPDATE-DONE pcas <candidate>` | 2026-11-03 18:27 to 18:29 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching pcas-src lines: 0`, `link: modules/pcas -> ./pcas-e075fd4`, `SONAME libcas.so: libcas.so.4.13.0`, `SONAME libgdd.so: libgdd.so.4.13.0`, `UPDATE-DONE pcas 8395b2b`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching pcas-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 18:29 to 18:37 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching pcas-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 18:37 to 18:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 18:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem cas`, `== stem gdd`, and `== dep=pcas` on both, `work/pcas-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `8395b2b`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of pcas is complete, in
13 minutes.

### pscdrv upstream observation

Observed 2026-10-29: remote HEAD names `master` at
`276dacaee3fdfba954ec7d5d3cbd01852cbcf306`, dated 2026-04-16.
The effective commit pin `276daca` and prepared source HEAD resolve to that
same commit. There are no later commits on the observed default branch;
the recorded outcome remains unchanged. This observation does not complete
the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/PSCDRV`. Baseline pin: `276daca`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `276dacaee3fdfba954ec7d5d3cbd01852cbcf306` | 2026-04-16 | equal | 0 |
| Latest snapshot tag `atf-20250728` | `585da06da0d76a2f6fdfb137b2f2b2f2b91367f6` | 2025-07-28 | behind | 0 |
| Default branch `master` | `276dacaee3fdfba954ec7d5d3cbd01852cbcf306` | 2026-04-16 | equal | 0 |

The baseline contains 8 commits beyond the tag; the tag adds none.
The default branch contains 8 commits beyond this tag.
The remote exposes only this named snapshot tag; no versioned release tag is present.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the two `lib=` libraries `libpscCore.so` and `libpscUDPFast.so` beside `libpscSig.so`, all with unversioned SONAMEs, no installed library that needs them, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `276daca` (version 276daca) and does not move (unchanged), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash pscdrv PSCDRV <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.pscdrv` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> pscdrv ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/pscdrv ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of pscdrv in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libpscCore`, `libpscUDPFast` and the module name, as Stage 3 sets out, with the result in `work/pscdrv-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/pscdrv/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash pscdrv PSCDRV <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/pscdrv-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/pscdrv -> ./pscdrv-276daca`, the `libpscCore` and `libpscUDPFast` SONAMEs, `UPDATE-DONE pscdrv <candidate>` | 2026-11-03 18:48 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching pscdrv-src lines: 0`, `link: modules/pscdrv -> ./pscdrv-276daca`, `SONAME libpscCore.so: libpscCore.so`, `SONAME libpscUDPFast.so: libpscUDPFast.so` (and `libpscSig.so`), `UPDATE-DONE pscdrv f000964`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching pscdrv-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 18:48 to 18:56 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching pscdrv-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 18:56 to 18:59 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 18:59 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem pscCore`, `== stem pscUDPFast`, and `== dep=pscdrv` on both, `work/pscdrv-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `f000964`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of pscdrv is complete, in
10 minutes.

### linStat upstream observation

Observed 2026-10-29: the latest remote release tag is `1.2.1`, matching the
effective pin and prepared source at
`b4729e43c8ee9791975abbc7e06b870f46fb9661`.
Remote HEAD names `master` at
`df0f547186ab0bd69281a4ec414c36b8a1c3ce64`, dated 2026-07-21.
The branch contains six commits after `1.2.1`; there is no newer release tag.

The tag comparison remains unchanged. D33 records the 2026-10-30 selection
of five post-pin commits, excluding std::filesystem removal. RTC adoption
requires corrections for failed date/time parsing and local-time DST handling,
with its Host OPI selected alongside it. The source pin remains unchanged;
patch preparation and targeted checks are complete, while module acceptance
remains pending.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/LINSTAT`. Baseline pin: `tags/1.2.1`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `b4729e43c8ee9791975abbc7e06b870f46fb9661` | 2026-06-08 | equal | 0 |
| Latest release tag `1.2.1` | `b4729e43c8ee9791975abbc7e06b870f46fb9661` | 2026-06-08 | equal | 0 |
| Default branch `master` | `df0f547186ab0bd69281a4ec414c36b8a1c3ce64` | 2026-07-21 | ahead | 6 |

The default branch contains 6 commits beyond this tag.

Change summary from commit subjects and changed-file lists: RTC status, OPI and NIC macros, separate install-location build support, and removal of std::filesystem use.

The [carry decision record](linstat-carry-1.5.0.md) contains the five-reviewer
assessment, D33 selection, six-file patch set and verification limits. Actual
aggregate application and restoration passed; all 37 prepared source repositories
are restored. The RTC site correction passes 20 targeted cases. Independent pre-build
third-person implementation and second-person document reviews pass with no
findings. These results do not replace the full module build and IOC cycle.

Issue: #118, https://github.com/jeonghanlee/EPICS-env/issues/118

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the six patch files and the one apply target, no dependent) and the installed tree of the Debian 13 machine (the link, the one library `liblinStat.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/1.2.1` (version 1.2.1) and does not move (five carries plus RTC site correction prepared (D33), full-cycle verification pending), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.linStat.commit.apply` with the files `1.2.1-01-78b6138-netstat-path.p0.patch`, `1.2.1-02-6ea15c7-rtc-status.p0.patch`, `1.2.1-03-7576edc-host-opi.p0.patch`, `1.2.1-04-e48e077-install-config.p0.patch`, `1.2.1-05-df0f547-nic-prefix.p0.patch`, `1.2.1-site01-rtc-parse-dst.p0.patch` are run by `guest-update.bash linStat LINSTAT <candidate> ~/sandbox/EPICS-env` before the build; the log shows 6 `Patching linStat-src` lines.
3. No module lists `build.linStat` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> linStat ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/linStat ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of linStat in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `liblinStat` and the module name, as Stage 3 sets out, with the result in `work/linStat-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/linStat/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash linStat LINSTAT <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/linStat-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 6 `Patching linStat-src` lines before the build, `link: modules/linStat -> ./linStat-1.2.1`, the `liblinStat` SONAME, `UPDATE-DONE linStat <candidate>` | 2026-11-03 19:40 to 19:42 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: six `Patching linStat-src` lines after `make LINSTAT`, `link: modules/linStat -> ./linStat-1.2.1`, `SONAME liblinStat.so: liblinStat.so`, `UPDATE-DONE linStat 894ff70`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching linStat-src lines: 6`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 19:41 to 19:51 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching linStat-src lines: 6`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 19:50 to 19:54 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example verify_fixture_tc32sim`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `verify_fixture_tc32sim` `ok=24`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 19:54 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem linStat` and `== dep=linStat` on both, `work/linStat-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `894ff70`, the tip of origin at the acceptance, with the
patches already in the repository since the commit that added them. Issue #118
was closed on 2026-11-03 at 20:12 UTC with its body synced to these results
(the four acceptance criteria checked with their results, the candidate named)
and a closing comment, and its closed state was read back. The cycle of linStat
is complete, in 14 minutes, with its acceptance, results, and closure in one
commit.

### feed-core upstream observation

D34 records `0472d88` and `patch/feed-core-libonly.p0.patch` as unchanged, with no
additional carry. On 2026-10-30, `git ls-remote --symref origin HEAD
refs/heads/master 'refs/tags/*'` in the prepared source again returned
`master` at `0472d88f3a42ad8adde5b32d7e348efe43d84199` and no tag refs.
Module build and IOC acceptance remain pending.

Observed 2026-10-29: remote HEAD names `master` at
`0472d88f3a42ad8adde5b32d7e348efe43d84199`, dated 2025-02-11.
The effective commit pin `0472d88` and prepared source HEAD resolve to that
same commit. The remote tag query succeeded and returned no tags.
There are no later commits on the observed default branch; the recorded
outcome remains unchanged. This observation does not complete the combined
upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/FEEDCORE`. Baseline pin: `0472d88`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `0472d88f3a42ad8adde5b32d7e348efe43d84199` | 2025-02-11 | equal | 0 |
| Release tag: none (remote tag refs empty) | - | - | - | - |
| Default branch `master` | `0472d88f3a42ad8adde5b32d7e348efe43d84199` | 2025-02-11 | equal | 0 |


Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository and the installed tree of the Debian 13 machine (the link, the one installed version, the one library `libfeed.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `0472d88` (version 0472d88) and does not move (pin and existing lib-only patch unchanged (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.feed-core.apply` are run by `guest-update.bash feed-core FEEDCORE <candidate> ~/sandbox/EPICS-env` before the build; the log shows 1 `Patching feed-core-src` line.
3. No module lists `build.feed-core` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> feed-core ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/feed-core ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of feed-core in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libfeed` and the module name, as Stage 3 sets out, with the result in `work/feed-core-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/feed-core/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash feed-core FEEDCORE <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/feed-core-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 1 `Patching feed-core-src` line before the build, `link: modules/feed-core -> ./feed-core-0472d88`, the `libfeed` SONAME, `UPDATE-DONE feed-core <candidate>` | 2026-11-03 20:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching feed-core-src with the file : feed-core-libonly.p0.patch` after `make FEEDCORE`, `link: modules/feed-core -> ./feed-core-0472d88`, `SONAME libfeed.so: libfeed.so`, `UPDATE-DONE feed-core 985a88e`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching feed-core-src lines: 1`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 20:40 to 20:47 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching feed-core-src lines: 1`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 20:47 to 20:50 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 20:50 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem feed` and `== dep=feed-core` on both, `work/feed-core-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `985a88e`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of feed-core is complete,
in 10 minutes.

### sscan upstream observation

D7 is reaffirmed: retain the accepted move from `e13699e` to `ce9660c`.
Upstream `master` advanced to `23448e4` on 2026-10-30 with four commits (two
changes and two merges), after the observation below. D39 selects `b28ac30d`
as one patch and does not carry `f5f4c90d`. Module build and IOC acceptance
remain pending.

Observed 2026-10-29: remote HEAD names `master` at
`ce9660cfc05071834391225beadf7f93b776d216`, dated 2026-09-28.
The effective commit pin `ce9660c` and prepared source HEAD resolve to that
same commit. There are no later commits on the observed default branch.
D7 remains the accepted move from `e13699e` to `ce9660c`; the recorded
release outcome is IN, not unchanged. This observation does not complete
the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/SSCAN`. Baseline pin: `ce9660c`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `ce9660cfc05071834391225beadf7f93b776d216` | 2026-09-28 | equal | 0 |
| Latest release tag `R2-12` | `a67107fd9ca533d3056b157ad29a7e0b395f3147` | 2026-05-06 | behind | 0 |
| Default branch `master` | `ce9660cfc05071834391225beadf7f93b776d216` | 2026-09-28 | equal | 0 |

The baseline contains 8 commits beyond the tag; the tag adds none.
The default branch contains 8 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #119, https://github.com/jeonghanlee/EPICS-env/issues/119

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `e19f76b`, the one patch file and apply target, the four dependents each rebuilt from `distclean`) and the installed tree of the Debian 13 machine (the link, the libraries `libsscan.so` and `libscanProgress.so`, the libraries of asyn, calc, and mca that need `libsscan.so` and the `dep=sscan` lines of asyn, calc, mca, and measComp, all among the four dependents, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `ce9660c` (version ce9660c) already, moved from `e13699e` by commit `e19f76b` (IN (D7), one carry prepared (D39), full-cycle verification pending), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `e19f76b` rewrote are searched for `e13699e` at the end of the checks, and none may remain.
2. The apply targets `patch.sscan.commit.apply` with the files `ce9660c-01-b28ac30-checkrwpermission-tmpfile-size.p0.patch` are run by `guest-update.bash sscan SSCAN <candidate> ~/sandbox/EPICS-env` before the build; the log shows 1 `Patching sscan-src` line.
3. The dependents, the modules whose `_DEPS` line lists `build.sscan`, are calc, asyn, mca, measComp; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> sscan ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/sscan ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of sscan in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libsscan` and the module name, as Stage 3 sets out, with the result in `work/sscan-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (calc, asyn, mca, measComp), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/sscan/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash sscan SSCAN <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/sscan-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 1 `Patching sscan-src` line before the build, `link: modules/sscan -> ./sscan-ce9660c`, the `libsscan` SONAME, `UPDATE-DONE sscan <candidate>` | 2026-11-03 20:54 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching sscan-src with the file : ce9660c-01-b28ac30-checkrwpermission-tmpfile-size.p0.patch` after `make SSCAN`, `link: modules/sscan -> ./sscan-ce9660c`, `SONAME libsscan.so: libsscan.so` (and `libscanProgress.so`), `UPDATE-DONE sscan 16429df`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for calc, asyn, mca, measComp | 2026-11-03 20:55 to 20:57 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{calc,asyn,mca,measComp}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for all four |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching sscan-src lines: 1`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 20:57 to 21:04 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching sscan-src lines: 1`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 21:04 to 21:08 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside calc, asyn, mca, measComp | 2026-11-03 21:08 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names asyn, calc, mca, and measComp on both, `outside the dependents: none`, `work/sscan-bump/reverse-deps.md` judged |

Closure: candidate `16429df`, the tip of origin at the acceptance, with the pin
and the patch already in the repository since the commits that moved and added
them; the two files that `e19f76b` rewrote keep no `e13699e`. Issue #119 was
closed on 2026-11-03 at 21:32 UTC with its body synced to these results (the
five acceptance criteria checked with their results, the candidate named) and a
closing comment, and its closed state was read back. The cycle of sscan is
complete, in 14 minutes with the four dependents rebuilt.
| No `e13699e` left in the files that `e19f76b` rewrote | not run | local host | pending | none |

### calc upstream observation

D6 is reaffirmed: retain the accepted move from `4217e83` to `tags/R3-8`,
with no additional carry. Decision Date: 2026-10-30.
The four later commits through `59d1fe5` remain excluded: `041cf56`
standardizes user-record DESC text, `cadca72` makes `userTransforms10.db`
start disabled, and the other two commits merge these changes.
The 2026-10-30 remote query (`git ls-remote --symref origin HEAD refs/heads/master 'refs/tags/R3-8*'`)
again returned `R3-8` at `712a40453e8693fda3b90a6e9da5fdb1c708ee38`
and `master` at `59d1fe51c2d4e8c8eec2ad9d067831c93d69f5cb`.
Module build and IOC acceptance remain pending.

Observed 2026-10-29: the effective pin `tags/R3-8` and prepared source
resolve to `712a40453e8693fda3b90a6e9da5fdb1c708ee38`, dated 2026-09-17.
Remote HEAD names `master` at
`59d1fe51c2d4e8c8eec2ad9d067831c93d69f5cb`, dated 2026-10-01.
The branch contains four commits after `R3-8`, the same head excluded by D6.
The diff changes only `.db` files under `calcApp/Db/`.

The remote tag `R5-4-2` resolves to
`d0e9254909cb5a2e6a3c51f49cac3fc3f6d28c1f`, dated 2015-01-21, and is an
ancestor of `R3-8`. Its higher version-sort position does not make it a newer
release; the D24 qualification stands. D6 remains IN for `R3-8`, with the
four later branch commits excluded. The source pin is unchanged.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/CALC`. Baseline pin: `tags/R3-8`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `712a40453e8693fda3b90a6e9da5fdb1c708ee38` | 2026-09-17 | equal | 0 |
| Latest release tag `R3-8` | `712a40453e8693fda3b90a6e9da5fdb1c708ee38` | 2026-09-17 | equal | 0 |
| Default branch `master` | `59d1fe51c2d4e8c8eec2ad9d067831c93d69f5cb` | 2026-10-01 | ahead | 4 |

The default branch contains 4 commits beyond this tag.
The historical R5-4-2 tag predates R3-8; version-sort order is not release chronology.

Change summary from commit subjects and changed-file lists: Database changes to user record descriptions and the initial disabled state of userTransforms10.db.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #121, https://github.com/jeonghanlee/EPICS-env/issues/121

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `980e12b`, no apply target, the five dependents each rebuilt from `distclean`) and the installed tree of the Debian 13 machine (the link, the one library `libcalc.so`, the libraries of asyn and mca that need it and the `dep=calc` lines of asyn, mca, measComp, pmac, and StreamDevice, all among the five dependents, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R3-8` (version 3.8.0) already, moved from `4217e83` by commit `980e12b` (IN (D6)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `980e12b` rewrote are searched for `4217e83` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash calc CALC <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.calc`, are asyn, StreamDevice, mca, measComp, pmac; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> calc ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/calc ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of calc in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libcalc` and the module name, as Stage 3 sets out, with the result in `work/calc-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (asyn, StreamDevice, mca, measComp, pmac), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/calc/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash calc CALC <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/calc-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/calc -> ./calc-3.8.0`, the `libcalc` SONAME, `UPDATE-DONE calc <candidate>` | 2026-11-03 21:50 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching calc-src lines: 0`, `link: modules/calc -> ./calc-3.8.0`, `SONAME libcalc.so: libcalc.so`, `UPDATE-DONE calc 655a833`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for asyn, StreamDevice, mca, measComp, pmac | 2026-11-03 21:51 to 21:54 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{asyn,StreamDevice,mca,measComp,pmac}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for all five |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching calc-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 21:54 to 22:01 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching calc-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 22:00 to 22:04 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside asyn, StreamDevice, mca, measComp, pmac | 2026-11-03 22:04 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names StreamDevice, asyn, mca, measComp, and pmac on both, `outside the dependents: none`, `work/calc-bump/reverse-deps.md` judged |

Closure: candidate `655a833`, the tip of origin at the acceptance, with the pin
already in the repository since `980e12b`; the three files that `980e12b`
rewrote keep no `4217e83`. Issue #121 was closed on 2026-11-03 at 22:09 UTC
with its body synced to these results (the five acceptance criteria checked
with their results, the candidate named) and a closing comment, and its closed
state was read back. The cycle of calc is complete, in 14 minutes with the five
dependents rebuilt.
| No `4217e83` left in the files that `980e12b` rewrote | not run | local host | pending | none |

### asyn upstream observation

D34 records `tags/R4-46` as unchanged, with no additional carry.
The 2026-10-30 remote query (`git ls-remote --symref origin HEAD refs/heads/master 'refs/tags/*'`)
again returned `master` and the latest release tag `R4-46` at
`76f6164757d54b0b7dae22a911fe78fd20a95525`.
Module build and IOC acceptance remain pending.

Observed 2026-10-29: the latest remote release tag is `R4-46`, matching
the effective pin and prepared source at
`76f6164757d54b0b7dae22a911fe78fd20a95525`, dated 2026-07-30.
Remote HEAD names `master` at that same commit. There is no newer release
tag and no later commit on the observed default branch; the recorded outcome
remains unchanged. This observation does not complete the combined upstream
survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/ASYN`. Baseline pin: `tags/R4-46`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `76f6164757d54b0b7dae22a911fe78fd20a95525` | 2026-07-30 | equal | 0 |
| Latest release tag `R4-46` | `76f6164757d54b0b7dae22a911fe78fd20a95525` | 2026-07-30 | equal | 0 |
| Default branch `master` | `76f6164757d54b0b7dae22a911fe78fd20a95525` | 2026-07-30 | equal | 0 |

The default branch contains 0 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none against the plan; the claims were verified against the repository (the pin, no apply target, the seventeen dependents and the five whose `distclean` is unsafe) and the installed tree of the Debian 13 machine (the link, the library `libasyn.so`, the `dep=asyn` lines of all seventeen dependents, the libraries of fifteen of them that need `libasyn.so`, no site module that names it) before the acceptance. The run showed one defect of `cycle.bash`: it listed the second installed version of asyn itself, which the full suite installs, as a module outside the dependents; the script now leaves out other installed versions of the module.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R4-46` (version 4.46.0) and does not move (pin unchanged, no additional carry (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash asyn ASYN <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.asyn`, are QPC, modbus, lua, std, StreamDevice, rgamv2, busy, scaler, mca, measComp, motor, motorMotorSim, pmac, ADCore, ADSimDetector, ADGenICam, ADVimba; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three), except lua, std, scaler, ADSimDetector, ADVimba, whose `distclean` is unsafe by The checks, item 1, and which is rebuilt from a new source tree instead (move `<d>-src` aside, `make <D_KEY>`, the apply targets of `<d>` if any, `make conf.<d>`, `make build.<d>`).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> asyn ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/asyn ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of asyn in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libasyn` and the module name, as Stage 3 sets out, with the result in `work/asyn-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (QPC, modbus, lua, std, StreamDevice, rgamv2, busy, scaler, mca, measComp, motor, motorMotorSim, pmac, ADCore, ADSimDetector, ADGenICam, ADVimba), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/asyn/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash asyn ASYN <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/asyn-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/asyn -> ./asyn-4.46.0`, the `libasyn` SONAME, `UPDATE-DONE asyn <candidate>` | 2026-11-03 22:11 to 22:13 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching asyn-src lines: 0`, `link: modules/asyn -> ./asyn-4.46.0`, `SONAME libasyn.so: libasyn.so` (and the eleven test support libraries), `UPDATE-DONE asyn 1cb973b`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for QPC, modbus, lua, std, StreamDevice, rgamv2, busy, scaler, mca, measComp, motor, motorMotorSim, pmac, ADCore, ADSimDetector, ADGenICam, ADVimba | 2026-11-03 22:13 to 22:22 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-<d>-<os>.log` for the seventeen dependents each end `rc=0` on both; `rebuild form: distclean` for twelve, `rebuild form: new source tree` for lua, std, scaler, ADSimDetector, and ADVimba |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching asyn-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 22:22 to 22:27 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching asyn-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 22:27 to 22:29 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside QPC, modbus, lua, std, StreamDevice, rgamv2, busy, scaler, mca, measComp, motor, motorMotorSim, pmac, ADCore, ADSimDetector, ADGenICam, ADVimba | 2026-11-03 22:29 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names the seventeen dependents and the second installed version `asyn-66bafcd` of asyn itself, nothing else, `work/asyn-bump/reverse-deps.md` judged |

Closure: candidate `1cb973b`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of asyn is complete, in 18
minutes with the seventeen dependents rebuilt, the largest cycle of the release.

### QPC upstream observation

D34 records `913fad4` and `patch/QPC-dataonly.p0.patch` as unchanged, with no
additional carry. The 2026-10-30 remote query (`git ls-remote --symref origin HEAD refs/heads/alsu 'refs/tags/*'`)
again returned `alsu` at `913fad41df170063d910d0b4fdb083de696fac36`
and no tag refs. Module build and IOC acceptance remain pending.

Observed 2026-10-29: remote HEAD names `alsu` at
`913fad41df170063d910d0b4fdb083de696fac36`, dated 2026-08-23.
The effective commit pin `913fad4` and prepared source HEAD resolve to that
same commit. The remote tag query succeeded and returned no tags.
There are no later commits on the observed default branch; the recorded
outcome remains unchanged. This observation does not complete the combined
upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/QPC`. Baseline pin: `913fad4`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `913fad41df170063d910d0b4fdb083de696fac36` | 2026-08-23 | equal | 0 |
| Release tag: none (remote tag refs empty) | - | - | - | - |
| Default branch `alsu` | `913fad41df170063d910d0b4fdb083de696fac36` | 2026-08-23 | equal | 0 |


Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the one patch file `QPC-dataonly.p0.patch` unchanged in this release and its apply target, no dependent) and the installed tree of the Debian 13 machine (the link, no `lib=` entry and no installed library because the module is data only, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `913fad4` (version 913fad4) and does not move (pin and existing data-only patch unchanged (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.QPC.apply` are run by `guest-update.bash QPC QPC <candidate> ~/sandbox/EPICS-env` before the build; the log shows 1 `Patching QPC-src` line.
3. No module lists `build.QPC` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> QPC ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/QPC ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of QPC in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the module name only, because the module installs no shared library, as Stage 3 sets out, with the result in `work/QPC-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/QPC/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash QPC QPC <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/QPC-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 1 `Patching QPC-src` line before the build, `link: modules/QPC -> ./QPC-913fad4`, `UPDATE-DONE QPC <candidate>` | 2026-11-03 22:48 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching QPC-src with the file : QPC-dataonly.p0.patch` after `make QPC`, `link: modules/QPC -> ./QPC-913fad4`, no `SONAME` line, `UPDATE-DONE QPC c634f87`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching QPC-src lines: 1`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 22:49 to 22:54 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching QPC-src lines: 1`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 22:54 to 22:57 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-03 22:57 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: only the `== dep=QPC` search runs because the module installs no library, and it finds nothing on both, `work/QPC-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `c634f87`, the tip of origin at the acceptance; no issue,
the pin and the patch being unchanged. The cycle of QPC is complete, in 8
minutes.

### modbus upstream observation

Step 4 assessment and decision, 2026-10-30: the [carry decision record](modbus-carry-1.5.0.md)
and [original five-reviewer scores](modbus-carry-1.5.0-scores.json) account for
all 16 commits: four documentation changes, three represented merges and nine
scored units. Only `4e39e7a` meets the rule (36/80); the Maintainer selected it
in curated form (D37). One curated carry file is prepared and wired into
aggregate apply/revert. Targeted real-driver checks, builds and aggregate
apply/revert pass; full module/IOC/platform acceptance remains pending. The
source pin is unchanged.

Observed 2026-10-29: the latest remote release tag is `R3-4`, matching the
effective pin and prepared source at
`4a1276b0efa6f378a6dcbe58a10a1d73a44c7ed3`.
Remote HEAD names `master` at
`768d1056cfacbf7e25820087d49b2ebe3bf3e29e`, dated 2026-09-07.
The branch contains 16 commits after `R3-4`; there is no newer release tag.

The tag comparison remains unchanged. D37 settles the branch carry selection
with one curated patch and retains the source pin.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/MODBUS`. Baseline pin: `tags/R3-4`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `4a1276b0efa6f378a6dcbe58a10a1d73a44c7ed3` | 2024-12-01 | equal | 0 |
| Latest release tag `R3-4` | `4a1276b0efa6f378a6dcbe58a10a1d73a44c7ed3` | 2024-12-01 | equal | 0 |
| Default branch `master` | `768d1056cfacbf7e25820087d49b2ebe3bf3e29e` | 2026-09-07 | ahead | 16 |

The default branch contains 16 commits beyond this tag.

Change summary from commit subjects and changed-file lists: ResetStatistics support, database macros and PINI options, CRC/debug messages, Windows compilation, and documentation.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #122, https://github.com/jeonghanlee/EPICS-env/issues/122

Plan status: accepted
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the one patch file and apply target, the one dependent motor rebuilt from `distclean`) and the installed tree of the Debian 13 machine (the link, the one library `libmodbus.so` and its SONAME, no installed library that needs it, the `dep=modbus` line of motor only, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R3-4` (version 3.4.0) and does not move (pin unchanged, one curated carry prepared (D37), full-cycle verification pending), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.modbus.commit.apply` with the files `3.4.0-01-4e39e7a-readfloat64array-debug-loop.p0.patch` are run by `guest-update.bash modbus MODBUS <candidate> ~/sandbox/EPICS-env` before the build; the log shows 1 `Patching modbus-src` line.
3. The dependents, the modules whose `_DEPS` line lists `build.modbus`, are motor; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> modbus ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/modbus ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of modbus in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libmodbus` and the module name, as Stage 3 sets out, with the result in `work/modbus-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (motor), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/modbus/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash modbus MODBUS <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/modbus-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 1 `Patching modbus-src` line before the build, `link: modules/modbus -> ./modbus-3.4.0`, the `libmodbus` SONAME, `UPDATE-DONE modbus <candidate>` | 2026-11-03 23:03 to 23:05 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching modbus-src with the file : 3.4.0-01-4e39e7a-readfloat64array-debug-loop.p0.patch` after `make MODBUS`, `link: modules/modbus -> ./modbus-3.4.0`, `SONAME libmodbus.so: libmodbus.so`, `UPDATE-DONE modbus 17875a7`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for motor | 2026-11-03 23:04 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-motor-<os>.log` ends `rc=0` on both; `rebuild form: distclean` |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching modbus-src lines: 1`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 23:04 to 23:10 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching modbus-src lines: 1`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 23:09 to 23:12 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside motor | 2026-11-03 23:12 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names motor only, under `== dep=modbus`, on both, `outside the dependents: none`, `work/modbus-bump/reverse-deps.md` judged |

### lua upstream observation

D34 and D49 keep the pin `01aa7a1474a1ab525f1b97e042dcf7a7555ff15d` (D9); D49 records
the scores of four of the commits. On 2026-10-31 the
remote `master` is at `f68282674c3c654a135e23c58e2545318212f693`, six commits
after the pin; the latest release tag is still `R3-1`, an ancestor of the pin.
Stage 3 finds one build-order dependent, `motor_DEPS` (`build.lua`), and no
link-level or runtime consumer in either repository: no `*LIBS += ... lua`
and no include of a lua public header outside `lua-src` (`rg` and `find`
agree), and `motorScriptMotor`, which motor adds under `ifdef LUA`, is not
checked out and not built. The installed tree of release 1.3.0 (`~/epics/1.3.0`, the newest installed tree on
this host, whose lua link names the previous pin `17475b5`) has no object that
needs `liblua.so`. Stage 4 over the pin and the head shows 6 commits and 30
files, almost all additions (device support for 64-bit integer, mbbiDirect,
lsi, lso and array records, and tests); `luaEpics.h` gains a definition and an enumerator (inserted before the double
one, which shifts later values; safe in a coherent rebuild) and maps INT64 and
UINT64 fields to the new type instead of double, `devUtil.h` gains two function
declarations, and no symbol is removed; the 64-bit device support is built only
against Base 7.0 or later. The Maintainer keeps the pin and takes
none of the six commits. Step 6.3 needs no pin edit (`configure/RELEASE` already
holds `01aa7a1`), and no patch applies to lua. Module build and IOC acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`01aa7a1474a1ab525f1b97e042dcf7a7555ff15d` (D9).
Remote HEAD names `master` at
`f68282674c3c654a135e23c58e2545318212f693`, dated 2026-10-23.
The branch contains six commits after the pin, matching the previously
recorded head. The latest remote release tag is `R3-1`, an ancestor of the
pin; no later release tag is present.

The six commit subjects describe 64-bit integer and mbbiDirect support,
lsi and lso support, array support, example and release note updates,
and a test fix. Their author dates span 2026-10-01 to 2026-10-23;
their committer dates span 2026-10-22 to 2026-10-23.
At that observation compatibility and inclusion were open for step 4; D34 and D49
have since recorded the decision to keep the pin. D9 and the source pin are unchanged. This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/LUA`. Baseline pin: `01aa7a1`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `01aa7a1474a1ab525f1b97e042dcf7a7555ff15d` | 2026-10-06 | equal | 0 |
| Latest release tag `R3-1` | `631771e61676a6f03a668c51f272f37e2579e94b` | 2023-09-20 | behind | 0 |
| Default branch `master` | `f68282674c3c654a135e23c58e2545318212f693` | 2026-10-23 | ahead | 6 |

The baseline contains 178 commits beyond the tag; the tag adds none.
The default branch contains 184 commits beyond this tag.

Change summary from commit subjects and changed-file lists: 64-bit integer, mbbiDirect, lsi/lso, and array support, with examples, release notes, and a Base-version-specific test change.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #123, https://github.com/jeonghanlee/EPICS-env/issues/123

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `7ef47a7`, no apply target, the one dependent motor, lua itself rebuilt from a new source tree) and the installed tree of the Debian 13 machine (the link, the one library `liblua.so` and its SONAME, no installed library that needs it, the `dep=lua` line of motor only, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `01aa7a1` (version 01aa7a1) already, moved from `17475b5` by commit `7ef47a7` (IN (D9), no newer upstream release (D34), no carry (D49)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `7ef47a7` rewrote are searched for `17475b5` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash lua LUA <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.lua`, are motor; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three). The top Makefile of lua passes `realuninstall` to an `iocs` directory it does not build, so `make distclean.lua` is never run on it; `guest-update.bash` removes the source tree and rebuilds from the clone, which is the safe form.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> lua ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/lua ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of lua in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `liblua` and the module name, as Stage 3 sets out, with the result in `work/lua-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (motor), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/lua/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash lua LUA <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/lua-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/lua -> ./lua-01aa7a1`, the `liblua` SONAME, `UPDATE-DONE lua <candidate>` | 2026-11-03 23:30 to 23:32 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching lua-src lines: 0`, `link: modules/lua -> ./lua-01aa7a1`, `SONAME liblua.so: liblua.so`, `UPDATE-DONE lua b647829`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for motor | 2026-11-03 23:31 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-motor-<os>.log` ends `rc=0` on both; `rebuild form: distclean` |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching lua-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 23:31 to 23:37 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching lua-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 23:37 to 23:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside motor | 2026-11-03 23:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names motor only, under `== dep=lua`, on both, `outside the dependents: none`, `work/lua-bump/reverse-deps.md` judged |

Closure: candidate `b647829`, the tip of origin at the acceptance, with the pin
already in the repository since `7ef47a7`; the two files that `7ef47a7` rewrote
keep no `17475b5`. Issue #123 was closed on 2026-11-03 at 23:44 UTC with its
body synced to these results (the five acceptance criteria checked with their
results, the candidate named) and a closing comment, and its closed state was
read back. The cycle of lua is complete, in 10 minutes with the dependent motor
rebuilt.
| No `17475b5` left in the files that `7ef47a7` rewrote | not run | local host | pending | none |

### std upstream observation

Observed 2026-10-29: the effective pin and prepared source are
`27b696702c4ebc8c698c98e3bbb10a34f1a2c821` (D8).
Remote HEAD names `master` at the same commit, dated 2026-09-17.
There are no later commits on the observed default branch.
The latest remote module release tag is `R3-6-4`, an ancestor of the pin;
no later module release tag is present.

D8 remains the accepted move from `5f2e442` to `27b6967`; the module's
release outcome remains IN. The source pin is unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/STD`. Baseline pin: `27b6967`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `27b696702c4ebc8c698c98e3bbb10a34f1a2c821` | 2026-09-17 | equal | 0 |
| Latest release tag `R3-6-4` | `1b416dbb74fb54060395347433c30361bd276424` | 2023-06-05 | behind | 0 |
| Default branch `master` | `27b696702c4ebc8c698c98e3bbb10a34f1a2c821` | 2026-09-17 | equal | 0 |

The baseline contains 36 commits beyond the tag; the tag adds none.
The default branch contains 36 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #124, https://github.com/jeonghanlee/EPICS-env/issues/124

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `97a89e1`, no apply target, the dependents mca and measComp each rebuilt from `distclean`, std itself rebuilt from a new source tree) and the installed tree of the Debian 13 machine (the link, the one library `libstd.so` and its SONAME, no installed library that needs it, the `dep=std` lines of mca and measComp only, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `27b6967` (version 27b6967) already, moved from `5f2e442` by commit `97a89e1` (IN (D8)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `97a89e1` rewrote are searched for `5f2e442` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash std STD <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.std`, are mca, measComp; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three). The top Makefile of std passes `realuninstall` to an `iocs` directory it does not build, so `make distclean.std` is never run on it; `guest-update.bash` removes the source tree and rebuilds from the clone, which is the safe form.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> std ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/std ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of std in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libstd` and the module name, as Stage 3 sets out, with the result in `work/std-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (mca, measComp), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/std/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash std STD <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/std-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/std -> ./std-27b6967`, the `libstd` SONAME, `UPDATE-DONE std <candidate>` | 2026-11-03 23:49 to 23:51 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching std-src lines: 0`, `link: modules/std -> ./std-27b6967`, `SONAME libstd.so: libstd.so`, `UPDATE-DONE std d48c3d7`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for mca, measComp | 2026-11-03 23:49 to 23:51 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{mca,measComp}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching std-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-03 23:50 to 23:55 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching std-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-03 23:55 to 23:58 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside mca, measComp | 2026-11-03 23:58 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names mca and measComp only, under `== dep=std`, on both, `outside the dependents: none`, `work/std-bump/reverse-deps.md` judged |

Closure: candidate `d48c3d7`, the tip of origin at the acceptance, with the pin
already in the repository since `97a89e1`; the two files that `97a89e1` rewrote
keep no `5f2e442`. Issue #124 was closed on 2026-11-04 at 01:12 UTC with its
body synced to these results (the five acceptance criteria checked with their
results, the candidate named) and a closing comment, and its closed state was
read back. The cycle of std is complete, in 9 minutes with the dependents mca
and measComp rebuilt.
| No `5f2e442` left in the files that `97a89e1` rewrote | not run | local host | pending | none |

### StreamDevice upstream observation

Observed 2026-10-29: the latest remote release tag is `2.8.26`, matching
the effective pin and prepared source at
`668d1d525509604ab4ccd7382022dfb469c99841`.
Remote HEAD names `master` at
`562dd5ad36e07989a8bbb231dcb5bd165537c7f6`, dated 2026-08-10.
The branch contains 19 commits after `2.8.26`; there is no newer release tag.

The tag comparison remains unchanged. D38 settles the branch carry selection
with one patch and keeps `StreamDevice-no-vxi11` and `StreamDevice-dbd-tab`.
The observed branch includes `f473f4d`, which repeats the latter patch, and
`e87e093c`, which would replace the former. The source pin is unchanged.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/STREAM`. Baseline pin: `tags/2.8.26`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `668d1d525509604ab4ccd7382022dfb469c99841` | 2024-06-06 | equal | 0 |
| Latest release tag `2.8.26` | `668d1d525509604ab4ccd7382022dfb469c99841` | 2024-06-06 | equal | 0 |
| Default branch `master` | `562dd5ad36e07989a8bbb231dcb5bd165537c7f6` | 2026-08-10 | ahead | 19 |

The default branch contains 19 commits beyond this tag.

Change summary from commit subjects and changed-file lists: scalcout string truncation, the dbd recipe indentation fix, compiler compatibility, signed hexadecimal input, checksum handling, exit cleanup, optional VXI-11 support, and removal of EPICS 3.13 support.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #125, https://github.com/jeonghanlee/EPICS-env/issues/125

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the three apply targets and their three patch files, no dependent) and the installed tree of the Debian 13 machine (the link, the one library `libstream.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/2.8.26` (version 2.8.26) and does not move (pin and two local patches unchanged, one carry prepared (D38), full-cycle verification pending), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.StreamDevice.commit.apply`, `patch.StreamDevice.apply`, `patch.StreamDevice.dbd-tab.apply` with the files `2.8.26-01-562dd5a-scalcout-sval-size.p0.patch` are run by `guest-update.bash StreamDevice STREAM <candidate> ~/sandbox/EPICS-env` before the build; the log shows 3 `Patching StreamDevice-src` lines.
3. No module lists `build.StreamDevice` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> StreamDevice ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/StreamDevice ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim`, `verify_fixture_ioc_demo` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of StreamDevice in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libstream` and the module name, as Stage 3 sets out, with the result in `work/StreamDevice-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/StreamDevice/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash StreamDevice STREAM <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/StreamDevice-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 3 `Patching StreamDevice-src` lines before the build, `link: modules/StreamDevice -> ./StreamDevice-2.8.26`, the `libstream` SONAME, `UPDATE-DONE StreamDevice <candidate>` | 2026-11-04 01:14 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: three `Patching StreamDevice-src` lines (`2.8.26-01-562dd5a-scalcout-sval-size.p0.patch`, `StreamDevice-no-vxi11.p0.patch`, `StreamDevice-dbd-tab.p0.patch`) after `make STREAM`, `link: modules/StreamDevice -> ./StreamDevice-2.8.26`, `SONAME libstream.so: libstream.so`, `UPDATE-DONE StreamDevice ac2b9c5`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching StreamDevice-src lines: 3`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 01:14 to 01:19 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching StreamDevice-src lines: 3`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim`, `verify_fixture_ioc_demo`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 01:19 to 01:24 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example verify_fixture_tc32sim verify_fixture_ioc_demo`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `verify_fixture_tc32sim` `ok=24`, `verify_fixture_ioc_demo` `ok=10`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-04 01:24 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem stream` and `== dep=StreamDevice` on both, `work/StreamDevice-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `ac2b9c5`, the tip of origin at the acceptance, with the
pin unchanged and the patches already in the repository since `377cc3a` and
`f143d57`. Issue #125 was closed on 2026-11-04 at 01:25 UTC with its body
synced to these results (the four acceptance criteria checked with their
results, the candidate named) and a closing comment, and its closed state was
read back. The cycle of StreamDevice is complete, in 10 minutes with the two
fixtures that load it.

### rgamv2 upstream observation

Observed 2026-10-29: the effective pin and prepared source are
`27fc633c13506f23c107c7f631a87a5fdd80ce3b`.
Remote HEAD names `alsu` at the same commit, dated 2026-08-23.
The remote tag query succeeds and returns no tags.

There are no later commits on the observed default branch; the recorded
outcome remains unchanged. The source pin is unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/RGAMV2`. Baseline pin: `27fc633`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `27fc633c13506f23c107c7f631a87a5fdd80ce3b` | 2026-08-23 | equal | 0 |
| Release tag: none (remote tag refs empty) | - | - | - | - |
| Default branch `alsu` | `27fc633c13506f23c107c7f631a87a5fdd80ce3b` | 2026-08-23 | equal | 0 |


Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, no apply target, no dependent) and the installed tree of the Debian 13 machine (the link, the one library `librgamv2.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `27fc633` (version 27fc633) and does not move (unchanged), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash rgamv2 RGAMV2 <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.rgamv2` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> rgamv2 ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/rgamv2 ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of rgamv2 in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `librgamv2` and the module name, as Stage 3 sets out, with the result in `work/rgamv2-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/rgamv2/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash rgamv2 RGAMV2 <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/rgamv2-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/rgamv2 -> ./rgamv2-27fc633`, the `librgamv2` SONAME, `UPDATE-DONE rgamv2 <candidate>` | 2026-11-04 01:25 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching rgamv2-src lines: 0`, `link: modules/rgamv2 -> ./rgamv2-27fc633`, `SONAME librgamv2.so: librgamv2.so`, `UPDATE-DONE rgamv2 4c762ca`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching rgamv2-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 01:26 to 01:31 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching rgamv2-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 01:31 to 01:33 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-04 01:33 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem rgamv2` and `== dep=rgamv2` on both, `work/rgamv2-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `4c762ca`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of rgamv2 is complete, in 8
minutes.

### busy upstream observation

D34 records `a4a272d94d1f4351e7d9553e6dc35782eb96ce75` (D10): no newer upstream release, with no additional
carry. On 2026-10-31, `git ls-remote https://github.com/epics-modules/busy.git HEAD`
returned that commit, and the GitHub compare API from the pin to `master`
reported the branches identical, with 0 commits above the pin. Module build and
IOC acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`a4a272d94d1f4351e7d9553e6dc35782eb96ce75` (D10).
Remote HEAD names `master` at the same commit, dated 2026-09-21.
There are no later commits on the observed default branch.
The latest remote module release tag is `R1-7-4`, an ancestor of the pin;
no later module release tag is present.

D10 remains the accepted move from `2dfe92d` to `a4a272d`; the module's
release outcome remains IN. The source pin is unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/BUSY`. Baseline pin: `a4a272d`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `a4a272d94d1f4351e7d9553e6dc35782eb96ce75` | 2026-09-21 | equal | 0 |
| Latest release tag `R1-7-4` | `569a6b6fb1288c067ac2b22a998aa7de5375ddc4` | 2023-06-05 | behind | 0 |
| Default branch `master` | `a4a272d94d1f4351e7d9553e6dc35782eb96ce75` | 2026-09-21 | equal | 0 |

The baseline contains 16 commits beyond the tag; the tag adds none.
The default branch contains 16 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: #126, https://github.com/jeonghanlee/EPICS-env/issues/126

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `cac0441`, no apply target, the four dependents each rebuilt from `distclean`) and the installed tree of the Debian 13 machine (the link, the one library `libbusy.so` and its SONAME, the library of mca that needs it and the `dep=busy` lines of mca, measComp, motor, and pmac, all among the four dependents, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `a4a272d` (version a4a272d) already, moved from `2dfe92d` by commit `cac0441` (IN (D10), no newer upstream release (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `cac0441` rewrote are searched for `2dfe92d` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash busy BUSY <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.busy`, are mca, measComp, motor, pmac; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> busy ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/busy ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of busy in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libbusy` and the module name, as Stage 3 sets out, with the result in `work/busy-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (mca, measComp, motor, pmac), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/busy/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash busy BUSY <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/busy-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/busy -> ./busy-a4a272d`, the `libbusy` SONAME, `UPDATE-DONE busy <candidate>` | 2026-11-04 01:35 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching busy-src lines: 0`, `link: modules/busy -> ./busy-a4a272d`, `SONAME libbusy.so: libbusy.so`, `UPDATE-DONE busy abaeed5`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for mca, measComp, motor, pmac | 2026-11-04 01:36 to 01:38 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{mca,measComp,motor,pmac}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for all four |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching busy-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 01:38 to 01:43 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching busy-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 01:42 to 01:45 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside mca, measComp, motor, pmac | 2026-11-04 01:45 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names mca, measComp, motor, and pmac on both, `outside the dependents: none`, `work/busy-bump/reverse-deps.md` judged |

Closure: candidate `abaeed5`, the tip of origin at the acceptance, with the pin
already in the repository since `cac0441`; the two files that `cac0441`
rewrote keep no `2dfe92d`. Issue #126 was closed on 2026-11-04 at 02:04 UTC
with its body synced to these results (the five acceptance criteria checked
with their results, the candidate named) and a closing comment, and its closed
state was read back. The cycle of busy is complete, in 10 minutes with the four
dependents rebuilt.
| No `2dfe92d` left in the files that `cac0441` rewrote | not run | local host | pending | none |

### scaler upstream observation

D34 records `baa8e1c5e5a9a5deceef8cc39207a0da446092a6` (D11): no newer upstream release, with no additional
carry. On 2026-10-31, `git ls-remote https://github.com/epics-modules/scaler.git HEAD`
returned that commit, and the GitHub compare API from the pin to `HEAD`
reported the branches identical, with 0 commits above the pin. Module build and
IOC acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`baa8e1c5e5a9a5deceef8cc39207a0da446092a6` (D11).
Remote HEAD names `master` at the same commit, dated 2026-06-07.
There are no later commits on the observed default branch.
The latest remote release tag is `4.1`, an ancestor of the pin;
no later release tag is present.

D11 remains the accepted move from `beb5521` to `baa8e1c`; the module's
release outcome remains IN. The source pin is unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/SCALER`. Baseline pin: `baa8e1c`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `baa8e1c5e5a9a5deceef8cc39207a0da446092a6` | 2026-06-07 | equal | 0 |
| Latest release tag `4.1` | `eddb4394381d98342e7c55b51bdcc6af30c3443c` | 2023-06-07 | behind | 0 |
| Default branch `master` | `baa8e1c5e5a9a5deceef8cc39207a0da446092a6` | 2026-06-07 | equal | 0 |

The baseline contains 11 commits beyond the tag; the tag adds none.
The default branch contains 11 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: #127, https://github.com/jeonghanlee/EPICS-env/issues/127

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `65dd1db`, no apply target, the dependents mca and measComp each rebuilt from `distclean`, scaler itself rebuilt from a new source tree) and the installed tree of the Debian 13 machine (the link, the one library `libscaler.so` and its SONAME, no installed library that needs it, the `dep=scaler` lines of mca and measComp only, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `baa8e1c` (version baa8e1c) already, moved from `beb5521` by commit `65dd1db` (IN (D11), no newer upstream release (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `65dd1db` rewrote are searched for `beb5521` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash scaler SCALER <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.scaler`, are mca, measComp; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three). The top Makefile of scaler passes `realuninstall` to an `iocs` directory it does not build, so `make distclean.scaler` is never run on it; `guest-update.bash` removes the source tree and rebuilds from the clone, which is the safe form.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> scaler ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/scaler ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of scaler in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libscaler` and the module name, as Stage 3 sets out, with the result in `work/scaler-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (mca, measComp), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/scaler/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash scaler SCALER <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/scaler-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/scaler -> ./scaler-baa8e1c`, the `libscaler` SONAME, `UPDATE-DONE scaler <candidate>` | 2026-11-04 02:04 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching scaler-src lines: 0`, `link: modules/scaler -> ./scaler-baa8e1c`, `SONAME libscaler.so: libscaler.so`, `UPDATE-DONE scaler a2b0a4c`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for mca, measComp | 2026-11-04 02:05 to 02:06 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{mca,measComp}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching scaler-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 02:06 to 02:11 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching scaler-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 02:10 to 02:13 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside mca, measComp | 2026-11-04 02:13 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names mca and measComp only, under `== dep=scaler`, on both, `outside the dependents: none`, `work/scaler-bump/reverse-deps.md` judged |

Closure: candidate `a2b0a4c`, the tip of origin at the acceptance, with the pin
already in the repository since `65dd1db`; the two files that `65dd1db`
rewrote keep no `beb5521`. Issue #127 was closed on 2026-11-04 at 02:14 UTC
with its body synced to these results (the five acceptance criteria checked
with their results, the candidate named) and a closing comment, and its closed
state was read back. The cycle of scaler is complete, in 9 minutes with the
dependents mca and measComp rebuilt.
| No `beb5521` left in the files that `65dd1db` rewrote | not run | local host | pending | none |

### mca upstream observation

D34 records `687d563206d59de9097e28e95e32ad09ebcc2522` as unchanged, with no additional carry; the existing `mca-libnet` patch (macOS only) stays.
On 2026-10-31, `git ls-remote https://github.com/epics-modules/mca.git HEAD`
returned that commit, and the GitHub compare API from the pin to `HEAD`
reported the branches identical, with 0 commits above the pin. Module build and
IOC acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`687d563206d59de9097e28e95e32ad09ebcc2522`.
Remote HEAD names `master` at the same commit, dated 2025-08-25.
There are no later commits on the observed default branch.
The latest remote module release tag is `R7-10`, an ancestor of the pin;
no later module release tag is present.

The recorded outcome remains unchanged. The source pin and downstream
patch are unchanged by this survey. This observation does not complete
the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/MCA`. Baseline pin: `687d563`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `687d563206d59de9097e28e95e32ad09ebcc2522` | 2025-08-25 | equal | 0 |
| Latest release tag `R7-10` | `0c3e8b76aaad7a9616e44f0bb41fa927abd1608e` | 2022-11-25 | behind | 0 |
| Default branch `master` | `687d563206d59de9097e28e95e32ad09ebcc2522` | 2025-08-25 | equal | 0 |

The baseline contains 11 commits beyond the tag; the tag adds none.
The default branch contains 11 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the one apply target that applies `mca-libnet` on macOS only, the one dependent measComp rebuilt from `distclean`) and the installed tree of the Debian 13 machine (the link, the libraries `libmca.so` and `libmcaRontec.so`, no installed library that needs `libmca.so`, the `dep=mca` line of measComp only, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `687d563` (version 687d563) and does not move (unchanged, existing `mca-libnet` patch stays (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The one apply target, `patch.mca.apply`, applies `mca-libnet` on macOS only, so `guest-update.bash mca MCA <candidate> ~/sandbox/EPICS-env` runs it and the log shows no `Patching` line on Linux.
3. The dependents, the modules whose `_DEPS` line lists `build.mca`, are measComp; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> mca ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/mca ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of mca in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libmca` and the module name, as Stage 3 sets out, with the result in `work/mca-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (measComp), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/mca/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash mca MCA <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/mca-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/mca -> ./mca-687d563`, the `libmca` SONAME, `UPDATE-DONE mca <candidate>` | 2026-11-04 02:14 to 02:16 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching mca-src lines: 0` (the `mca-libnet` patch applies on macOS only), `link: modules/mca -> ./mca-687d563`, `SONAME libmca.so: libmca.so` and `libmcaRontec.so`, `UPDATE-DONE mca 71932c7`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for measComp | 2026-11-04 02:15 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-measComp-<os>.log` ends `rc=0` on both; `rebuild form: distclean` |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching mca-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 02:15 to 02:22 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching mca-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 02:21 to 02:24 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside measComp | 2026-11-04 02:24 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names measComp only, under `== dep=mca`, on both, `outside the dependents: none`, `work/mca-bump/reverse-deps.md` judged |

Closure: candidate `71932c7`, the tip of origin at the acceptance; no issue,
the pin and the patch being unchanged. The cycle of mca is complete, in 10
minutes with the dependent measComp rebuilt.

### measComp upstream observation

D15 stands, with no additional carry; the existing `measComp-CONFIG_MEASCOMP` and `measComp-tc32-chan-count` patches stay. On 2026-10-31, the GitHub compare API
from `c38974e` to `HEAD` listed two commits: `b00e4ab` (2026-04-22, a new
autoconvert file) and `9c8e01e` (2026-07-13, the `mistune` version in
`docs/requirements.txt`). They change `.ui` display files and a documentation
requirement only. The latest release tag is `R4-3`; no later tag is present.

Observed 2026-10-29: the effective pin and prepared source are
`c38974e85c59429b8ba48ed320681ba0296fb924` (D15).
Remote HEAD names `master` at
`9c8e01e025258668208383b370061a2b1ba9d7e8`, dated 2026-07-13.
The branch contains two commits after the pin. The latest remote release
tag is `R4-3`, an ancestor of the pin; no later release tag is present.

The diff from the pin to the observed head changes only
`measCompApp/op/ui/autoconvert/*.ui` and `docs/requirements.txt`, matching
the scope recorded in D15. The existing HOLD decision stands.
The source pin and downstream patches are unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/MEASCOMP`. Baseline pin: `c38974e`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `c38974e85c59429b8ba48ed320681ba0296fb924` | 2026-02-04 | equal | 0 |
| Latest release tag `R4-3` | `bad545061ef24acc718f40676e982b7eb3d69ff3` | 2024-02-10 | behind | 0 |
| Default branch `master` | `9c8e01e025258668208383b370061a2b1ba9d7e8` | 2026-07-13 | ahead | 2 |

The baseline contains 69 commits beyond the tag; the tag adds none.
The default branch contains 71 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Autoconverted display and documentation dependency changes only; the diff contains measCompApp/op/ui/autoconvert files and docs/requirements.txt.

This records source changes only; compatibility and adoption were left to step 4; D15 decides them.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the two apply targets and their two patch files, no dependent) and the installed tree of the Debian 13 machine (the link, the one library `libmeasComp.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance. The maintainer ruled that the TC32 reconnect work of another session, which adds a third apply target, is not part of 1.5.0: it was taken out of the working tree and kept under `work/` before this plan was accepted, so the cycle runs on the two patches of the repository.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `c38974e` (version c38974e) and does not move (HOLD (D15)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.measComp.apply`, `patch.measComp.tc32.apply` are run by `guest-update.bash measComp MEASCOMP <candidate> ~/sandbox/EPICS-env` before the build; the log shows 2 `Patching measComp-src` lines.
3. No module lists `build.measComp` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> measComp ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/measComp ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of measComp in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libmeasComp` and the module name, as Stage 3 sets out, with the result in `work/measComp-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/measComp/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash measComp MEASCOMP <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/measComp-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 2 `Patching measComp-src` lines before the build, `link: modules/measComp -> ./measComp-c38974e`, the `libmeasComp` SONAME, `UPDATE-DONE measComp <candidate>` | 2026-11-04 02:25 to 02:27 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching measComp-src with the file : measComp-CONFIG_MEASCOMP.p0.patch` and `measComp-tc32-chan-count.p0.patch` after `make MEASCOMP`, `link: modules/measComp -> ./measComp-c38974e`, `SONAME libmeasComp.so: libmeasComp.so`, `UPDATE-DONE measComp ed472c1`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching measComp-src lines: 2`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 02:26 to 02:32 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching measComp-src lines: 2`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 02:31 to 02:34 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-04 02:34 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem measComp` and `== dep=measComp` on both, `work/measComp-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `ed472c1`, the tip of origin at the acceptance; no issue,
the pin and the two patches of the repository being unchanged. The cycle of
measComp is complete, in 9 minutes.

### motor upstream observation

D12 stands (`4b22ac9`), with no additional carry. On 2026-10-31, the GitHub
compare API from the pin to `HEAD` (`47893ed11b0027b90a94622847ebc5332ba6b99a`)
listed 17 commits: seven merge commits (one of them, `33496c3`, brings a change,
`VERSION 7.4`, that is already in the pin), the documentation commit `6c37060`,
and nine commits in four groups that five independent reviewers scored (per-axis medians; the rule
is `total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`):

| Group | Commits | Change | Total /80 | Rule met |
| :-- | :-- | :-- | --: | :-- |
| F2 | `78f03d2` | HVEL=0 defaults to VELO instead of VBAS | 32 | bug (7) |
| F1 | `76f8d1f` | a missing newline in a log message of `devMotorAsyn.c` | 24 | none |
| F3 | `c01d03b` | C1-C5 macros in `pseudoMotor.db` | 23 | none |
| F4 | `05b25c1` and five more | position compare output for `asynMotorController` | 6 | none |

Each group applied to the pin and built with the same warnings as the pin.
F4 removes `NUM_MOTOR_DRIVER_PARAMS`: pmac `2-7-9` (`pmacController.cpp:137`,
`pmacCSController.cpp:151`) fails to compile against it; `2-7-10` uses the
same macro at the same two places (read in the source, not built). The Maintainer does not carry F2, which changes the
homing speed of axes that leave HVEL unset (VELO instead of VBAS, and a working
home where VBAS is 0). The [decision record](motor-carry-1.5.0.md) keeps the five
scored packets.

Observed 2026-10-29: the effective pin and prepared source are
`4b22ac950de98c2dca324c2ef8ef221e124f6651` (D12).
Remote HEAD names `master` at
`47893ed11b0027b90a94622847ebc5332ba6b99a`, dated 2026-07-30.
The branch contains 17 commits after the pin, ending at the head excluded
by D12. The latest remote module release tag is `R7-4`, an ancestor of
the pin; the pin includes two commits after that tag.

The diff to the observed head removes `NUM_MOTOR_DRIVER_PARAMS` from
`motorApp/MotorSrc/asynMotorController.h`. The prepared pmac source at
`2-7-9` uses that macro in `pmacController.cpp` and `pmacCSController.cpp`,
matching D12's exclusion reason. This is source inspection, not a build result.
D12 remains IN for `4b22ac9`, with the later head excluded.
The source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/MOTOR`. Baseline pin: `4b22ac9`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `4b22ac950de98c2dca324c2ef8ef221e124f6651` | 2026-03-09 | equal | 0 |
| Latest release tag `R7-4` | `68605b9512c8da65e83933474d17cadb453ec13b` | 2026-03-09 | behind | 0 |
| Default branch `master` | `47893ed11b0027b90a94622847ebc5332ba6b99a` | 2026-07-30 | ahead | 17 |

The baseline contains 2 commits beyond the tag; the tag adds none.
The default branch contains 19 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Position-compare output, removal of support for old asyn interfaces, HVEL fallback behavior, templates, displays, and documentation. At that observation compatibility remained for step 4; the decision recorded above has since decided it.

This records source changes only; compatibility and adoption were left to step 4; the [motor decision record](motor-carry-1.5.0.md) decides them.

Issue: #128, https://github.com/jeonghanlee/EPICS-env/issues/128

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin moved by `09e1dab`, no apply target, the dependents motorMotorSim and pmac each rebuilt from `distclean`) and the installed tree of the Debian 13 machine (the link, the libraries `libmotor.so` and `libsoftMotor.so`, the libraries of motorMotorSim and pmac that need `libmotor.so` and the `dep=motor` lines of those two, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `4b22ac9` (version 4b22ac9) already, moved from `285f44d` by commit `09e1dab` (IN (D12), no additional carry (see the [motor decision record](motor-carry-1.5.0.md))), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `09e1dab` rewrote are searched for `285f44d` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash motor MOTOR <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.motor`, are motorMotorSim, pmac; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> motor ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/motor ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of motor in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libmotor`, `libsoftMotor` and the module name, as Stage 3 sets out, with the result in `work/motor-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (motorMotorSim, pmac), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/motor/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash motor MOTOR <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/motor-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/motor -> ./motor-4b22ac9`, the `libmotor` and `libsoftMotor` SONAMEs, `UPDATE-DONE motor <candidate>` | 2026-11-04 02:37 to 02:39 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching motor-src lines: 0`, `link: modules/motor -> ./motor-4b22ac9`, `SONAME libmotor.so: libmotor.so` and `libsoftMotor.so`, `UPDATE-DONE motor 35cea07`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for motorMotorSim, pmac | 2026-11-04 02:38 to 02:39 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{motorMotorSim,pmac}-<os>.log` each end `rc=0` on both; `rebuild form: distclean` for both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching motor-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 02:39 to 02:45 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching motor-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 02:45 to 02:48 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside motorMotorSim, pmac | 2026-11-04 02:48 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names motorMotorSim and pmac on both, `outside the dependents: none`, `work/motor-bump/reverse-deps.md` judged |

Closure: candidate `35cea07`, the tip of origin at the acceptance, with the pin
already in the repository since `09e1dab`; the two files that `09e1dab`
rewrote keep no `285f44d`. Issue #128 was closed on 2026-11-04 at 02:50 UTC
with its body synced to these results (the five acceptance criteria checked
with their results, the candidate named) and a closing comment, and its closed
state was read back. The cycle of motor is complete, in 11 minutes with the
dependents motorMotorSim and pmac rebuilt.
| No `285f44d` left in the files that `09e1dab` rewrote | not run | local host | pending | none |

### motorMotorSim upstream observation

D34 records `tags/R1-3` as unchanged, with no additional carry. On 2026-10-31,
`git ls-remote https://github.com/epics-motor/motorMotorSim.git HEAD` returned
`39a66815a386b9fc8b948e369ac325df3848436e`, and the GitHub compare API from
`R1-3` to `HEAD` reported the branches identical, with 0 commits above the tag.
Module build and IOC acceptance remain pending.

Observed 2026-10-29: the latest remote release tag is `R1-3`, matching
the effective pin and prepared source at
`39a66815a386b9fc8b948e369ac325df3848436e`.
Remote HEAD names `master` at the same commit, dated 2026-01-27.
There are no later commits on the observed default branch and no newer
release tag.

The recorded outcome remains unchanged. The source pin is unchanged by
this survey. This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/MOTORSIM`. Baseline pin: `tags/R1-3`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `39a66815a386b9fc8b948e369ac325df3848436e` | 2026-01-27 | equal | 0 |
| Latest release tag `R1-3` | `39a66815a386b9fc8b948e369ac325df3848436e` | 2026-01-27 | equal | 0 |
| Default branch `master` | `39a66815a386b9fc8b948e369ac325df3848436e` | 2026-01-27 | equal | 0 |

The default branch contains 0 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, no apply target, no dependent) and the installed tree of the Debian 13 machine (the link, the one library `libmotorSimSupport.so` and its SONAME, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R1-3` (version 1.3.0) and does not move (unchanged (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash motorMotorSim MOTORSIM <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.motorMotorSim` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> motorMotorSim ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/motorMotorSim ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of motorMotorSim in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libmotorSimSupport` and the module name, as Stage 3 sets out, with the result in `work/motorMotorSim-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/motorMotorSim/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash motorMotorSim MOTORSIM <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/motorMotorSim-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/motorMotorSim -> ./motorMotorSim-1.3.0`, the `libmotorSimSupport` SONAME, `UPDATE-DONE motorMotorSim <candidate>` | 2026-11-04 02:50 to 02:51 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching motorMotorSim-src lines: 0`, `link: modules/motorMotorSim -> ./motorMotorSim-1.3.0`, `SONAME libmotorSimSupport.so: libmotorSimSupport.so`, `UPDATE-DONE motorMotorSim 96e027a`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching motorMotorSim-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 02:51 to 02:56 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching motorMotorSim-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 02:56 to 02:58 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-04 02:58 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem motorSimSupport` and `== dep=motorMotorSim` on both, `work/motorMotorSim-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `96e027a`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of motorMotorSim is
complete, in 8 minutes.

### pmac upstream observation

D47 holds `2-7-9` and does not take `2-7-10`. Stage 3 finds no consumer
module: `build.pmac` is in no `CONFIG_MODS_DEPS` of the two repositories, no
module or site source links `pmacAsynMotorPort` or includes a pmac header (`rg`
and `find` agree), and the installed tree of release 1.3.0 (`~/epics/1.3.0`, the newest installed
tree on this host; no 1.4.0 tree is installed here) has no object that needs
the library. Stage 4 counts 18 commits and 14 files for `2-7-9..2-7-10`;
no Makefile or configure file changes, and in the five changed headers no
symbol is removed and no signature changes (members are added to `pmacAxis`
and `pmacController`, two of them in the middle of their classes, and a pure
virtual `getMasterControlCmd` to `pmacHardwareInterface`, which the two classes
of the same range implement; such additions break only a consumer built
before them, and none exists).
The release adds the Symetrie hexapod speed records and screens and a master
control (following mode) record `MASTER_CTRL`; it makes `pmacAxis::move` ignore
a move while that record is set and adds one controller query per axis to the
medium poll. `2-7-10` uses `NUM_MOTOR_DRIVER_PARAMS` (`pmacController.cpp:137`,
`pmacCSController.cpp:151`) as `2-7-9` does, so D12 keeps the motor head out in
both cases. Whether the facility uses a hexapod or following mode is not
established. Module build and IOC acceptance remain pending.

Observed 2026-10-29: the effective pin is `2-7-9`, and the prepared source
matches its resolved commit, `02c4f7247c760634e73b4e5175e3380844c3a77a`.
The latest remote release tag is `2-7-10`, resolving to
`34730140ae052b795bbedb54f83c6a7fe44a090a`, with commit date 2026-10-14.
Remote HEAD names `dls-master` at that same commit.
The range from the pin to the latest tag contains 18 commits.

At that observation, compatibility and inclusion of `2-7-10` were open for
step 4, including its compatibility with motor; D47 has since decided them. D12's statement that no newer pmac tag exists
describes its 2026-10-11 decision context; the observed tag list differs.
D12 remains the current motor decision.
The pmac source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/PMAC`. Baseline pin: `2-7-9`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `02c4f7247c760634e73b4e5175e3380844c3a77a` | 2025-10-13 | equal | 0 |
| Latest release tag `2-7-10` | `34730140ae052b795bbedb54f83c6a7fe44a090a` | 2026-10-14 | ahead | 18 |
| Default branch `dls-master` | `34730140ae052b795bbedb54f83c6a7fe44a090a` | 2026-10-14 | ahead | 18 |

The default branch contains 0 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Master-control/following-mode records and readbacks, plus Symetrie hexapod speed controls and display/template changes.

This records source changes only; compatibility and adoption were left to step 4; D47 has since decided them.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, no apply target, no dependent) and the installed tree of the Debian 13 machine (the link, the three libraries `libpmacAsynIPPort.so`, `libpmacAsynMotorPort.so`, and `libpowerPmacAsynPort.so`, no installed library that needs any of them, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `2-7-9` (version 2.7.9) and does not move (HOLD (D47)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash pmac PMAC <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.pmac` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> pmac ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/pmac ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of pmac in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libpmacAsynIPPort`, `libpmacAsynMotorPort`, `libpowerPmacAsynPort` and the module name, as Stage 3 sets out, with the result in `work/pmac-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/pmac/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash pmac PMAC <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/pmac-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/pmac -> ./pmac-2.7.9`, the `libpmacAsynIPPort` and `libpmacAsynMotorPort` and `libpowerPmacAsynPort` SONAMEs, `UPDATE-DONE pmac <candidate>` | 2026-11-04 03:07 to 03:09 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching pmac-src lines: 0`, `link: modules/pmac -> ./pmac-2.7.9`, the three SONAMEs `libpmacAsynIPPort.so`, `libpmacAsynMotorPort.so`, and `libpowerPmacAsynPort.so`, `UPDATE-DONE pmac 73bc20b`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching pmac-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 03:08 to 03:12 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching pmac-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 03:11 to 03:14 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-04 03:14 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under the three stems and `== dep=pmac` on both, `work/pmac-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `73bc20b`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of pmac is complete, in 7
minutes.

### ADCore upstream observation

D40 retains the pin `ee039d2` and selects `ede4c22` as one patch; `3f07467` and
`9cadb7f` are not carried. Module build and IOC acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`ee039d24c9e89e70b31fd383b4817a40db5d6395`.
Remote HEAD names `master` at
`36840e14b683079a8eb8423278eef41f371b1914`, dated 2026-10-13.
The branch contains ten commits after the pin, matching the previously
recorded head. The latest remote release tag is `R3-14`, an ancestor of
the pin; no later release tag is present.

The commit subjects describe a circular buffer plugin busy-record fix
with its unit test, a Windows header include fix, an expanded error
message, and CI updates. At that observation compatibility and inclusion were
open for step 4 under D25; D40 has since decided them. The source pin is
unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/ADCORE`. Baseline pin: `ee039d2`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `ee039d24c9e89e70b31fd383b4817a40db5d6395` | 2026-07-20 | equal | 0 |
| Latest release tag `R3-14` | `d27d71fb73bd915bdd714c8c4c78c05e3f31b1ce` | 2024-12-01 | behind | 0 |
| Default branch `master` | `36840e14b683079a8eb8423278eef41f371b1914` | 2026-10-13 | ahead | 10 |

The baseline contains 185 commits beyond the tag; the tag adds none.
The default branch contains 195 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Circular-buffer soft-trigger/busy handling and its unit test, Windows header include order, an expanded error message, and CI updates.

This records source changes only; compatibility and adoption remain at step 4.

Issue: #129, https://github.com/jeonghanlee/EPICS-env/issues/129

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, the one patch file and apply target, the three dependents of which ADSimDetector and ADVimba are rebuilt from a new source tree) and the installed tree of the Debian 13 machine (the link, the four libraries, the libraries of ADGenICam, ADSimDetector, and ADVimba that need them and the `dep=ADCore` lines of those three, all among the three dependents, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `ee039d2` (version ee039d2) and does not move (unchanged, one carry prepared (D40), full-cycle verification pending), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The apply targets `patch.ADCore.commit.apply` with the files `ee039d2-01-ede4c22-circularbuff-softtrigger-clear.p0.patch` are run by `guest-update.bash ADCore ADCORE <candidate> ~/sandbox/EPICS-env` before the build; the log shows 1 `Patching ADCore-src` line.
3. The dependents, the modules whose `_DEPS` line lists `build.ADCore`, are ADSimDetector, ADGenICam, ADVimba; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three), except ADSimDetector, ADVimba, whose `distclean` is unsafe by The checks, item 1, and which is rebuilt from a new source tree instead (move `<d>-src` aside, `make <D_KEY>`, the apply targets of `<d>` if any, `make conf.<d>`, `make build.<d>`).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> ADCore ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/ADCore ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of ADCore in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libADBase`, `libNDPlugin`, `libntndArrayConverter`, `libntndArrayConverterPvxs` and the module name, as Stage 3 sets out, with the result in `work/ADCore-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (ADSimDetector, ADGenICam, ADVimba), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/ADCore/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash ADCore ADCORE <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/ADCore-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 1 `Patching ADCore-src` line before the build, `link: modules/ADCore -> ./ADCore-ee039d2`, the `libADBase` and `libNDPlugin` and `libntndArrayConverter` and `libntndArrayConverterPvxs` SONAMEs, `UPDATE-DONE ADCore <candidate>` | 2026-11-04 03:29 to 03:32 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching ADCore-src with the file : ee039d2-01-ede4c22-circularbuff-softtrigger-clear.p0.patch` after `make ADCORE`, `link: modules/ADCore -> ./ADCore-ee039d2`, SONAMEs `libADBase.so`, `libNDPlugin.so`, `libntndArrayConverter.so`, and `libntndArrayConverterPvxs.so`, `UPDATE-DONE ADCore 6401374`, `rc=0` on both |
| `rebuild-<d>`: `rc=0` for ADSimDetector, ADGenICam, ADVimba | 2026-11-04 03:31 to 03:33 UTC | Debian 13, Rocky Linux 8.10 | pass | `rebuild-{ADSimDetector,ADGenICam,ADVimba}-<os>.log` each end `rc=0` on both; `rebuild form: new source tree` for ADSimDetector and ADVimba, `rebuild form: distclean` for ADGenICam |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching ADCore-src lines: 1`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 03:33 to 03:38 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching ADCore-src lines: 1`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 03:37 to 03:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside ADSimDetector, ADGenICam, ADVimba | 2026-11-04 03:40 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log` names ADGenICam, ADSimDetector, and ADVimba on both, `outside the dependents: none`, `work/ADCore-bump/reverse-deps.md` judged |

Closure: candidate `6401374`, the tip of origin at the acceptance, with the pin
unchanged and the patch already in the repository since `7780d4c`. Issue #129
was closed on 2026-11-04 at 03:51 UTC with its body synced to these results
(the five acceptance criteria checked with their results, the candidate named)
and a closing comment, and its closed state was read back. The cycle of ADCore
is complete, in 11 minutes with the three dependents rebuilt.

### ADSimDetector upstream observation

D34 keeps the pin `0ef1305351ce79baedb34ab82d63d4b030f0bffd`. On 2026-10-31 the remote
`master` is at the same commit and the compare from the pin to `master` is
identical; the newest release tag `R2-11` is an ancestor of the pin, which is
the head of the branch three commits after that tag (`git describe` gives
`R2-11-3-g0ef1305`). Stage 3 finds no consumer: `build.ADSimDetector` is in no
`CONFIG_MODS_DEPS` (`ADSimDetector_DEPS` lists only the module's own
dependencies), no module or site source links `simDetector` or includes
`simDetector.h` (`rg` and `find` agree), and the installed tree of release 1.3.0
(`~/epics/1.3.0`) has no object that needs `libsimDetector.so`. Stage 4 does not
apply: there is nothing above the pin. No downstream patch applies to
ADSimDetector, and step 6.3 needs no pin edit (`configure/RELEASE` already
holds `0ef1305`). Module build and IOC acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`0ef1305351ce79baedb34ab82d63d4b030f0bffd`.
Remote HEAD names `master` at the same commit, dated 2025-07-28.
There are no later commits on the observed default branch.
The latest remote release tag is `R2-11`, an ancestor of the pin;
no later release tag is present.

The survey outcome remained unchanged. D25 required step 4 to confirm pin
retention and its reason; D34 records them.
The source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/ADSIMDETECTOR`. Baseline pin: `0ef1305`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `0ef1305351ce79baedb34ab82d63d4b030f0bffd` | 2025-07-28 | equal | 0 |
| Latest release tag `R2-11` | `ae54f7ee9d5586d76a1baf018b2ba32a0ca055f4` | 2024-04-07 | behind | 0 |
| Default branch `master` | `0ef1305351ce79baedb34ab82d63d4b030f0bffd` | 2025-07-28 | equal | 0 |

The baseline contains 3 commits beyond the tag; the tag adds none.
The default branch contains 3 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: complete
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, no apply target, no dependent, the source tree removed and rebuilt from the clone because its top Makefile passes `realuninstall` to an `iocs` directory it does not build) and the installed tree of the Debian 13 machine (the link, the one library `libsimDetector.so`, no installed library that needs it, no `dep=` line that names it, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `0ef1305` (version 0ef1305) and does not move (unchanged, no newer upstream release (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash ADSimDetector ADSIMDETECTOR <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.ADSimDetector` in its `_DEPS` line, so no dependent is rebuilt. The top Makefile of ADSimDetector passes `realuninstall` to an `iocs` directory it does not build, so `make distclean.ADSimDetector` is never run on it; `guest-update.bash` removes the source tree and rebuilds from the clone, which is the safe form.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> ADSimDetector ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/ADSimDetector ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of ADSimDetector in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libsimDetector` and the module name, as Stage 3 sets out, with the result in `work/ADSimDetector-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/ADSimDetector/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash ADSimDetector ADSIMDETECTOR <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/ADSimDetector-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/ADSimDetector -> ./ADSimDetector-0ef1305`, the `libsimDetector` SONAME, `UPDATE-DONE ADSimDetector <candidate>` | 2026-11-04 03:51 to 03:53 UTC | Debian 13, Rocky Linux 8.10 | pass | `build-<os>.log`: `Patching ADSimDetector-src lines: 0`, `link: modules/ADSimDetector -> ./ADSimDetector-0ef1305`, `SONAME libsimDetector.so: libsimDetector.so`, `UPDATE-DONE ADSimDetector 15c3533`, `rc=0` on both |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching ADSimDetector-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | 2026-11-04 03:52 to 03:58 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching ADSimDetector-src lines: 0`, `revert rc=0`, `status lines in all trees: 0`, `rc=0` |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | 2026-11-04 03:57 to 04:00 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `scripts: verify_install_metadata verify_dependency_graph verify_minimal_example`, `minimal IOC exit=0`, `iocRun lines: 1`, `verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322`, `rc=0` on both; `metadata-lines-<os>.log`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` on both |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | 2026-11-04 04:00 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log`: `SO: Total Files with RPATH / ALL: 0 / 95`, `rc=0`; `installed-tree-env-<os>.log`: `findings: 0`, `rc=0`; `reverse-deps-<os>.log`: nothing under `== stem simDetector` and `== dep=ADSimDetector` on both, `work/ADSimDetector-bump/reverse-deps.md` judged: no consumer |

Closure: candidate `15c3533`, the tip of origin at the acceptance; no issue,
the pin and the patches being unchanged. The cycle of ADSimDetector is
complete, in 9 minutes.

### ADGenICam upstream observation

D34 keeps the pin `ba5b9b8bfcd0a38e1de558096cadf1bf5aca7768`. On 2026-10-31 the
remote `master` is at `df3d7cd35b0eb2390095b6d3bfbbcb6860c92cc1`, three commits
after the pin; the latest release tag is still `R1-10` (2024-07-26), an
ancestor of the pin, which is 35 commits after it. The three commits are
`f46ed9c` and `7cb25b3` (the template, two adl screens, two bob screens and the
feature XML of The Imaging Source DMK 33GX174 camera; the second renames four
of the six files, edits the two bob screens in place, and adds the `GC_`
prefix to the record names) and their merge `df3d7cd`: six files added, no
source, header, Makefile or configure change, and no fix. Stage 3 finds one
consumer, ADVimba, which names `build.ADGenICam` in `ADVimba_DEPS`, links
`ADGenICam` in `vimbaApp/src/Makefile` and includes its headers (`rg` and
`find` agree); the range changes no header, so ADVimba needs no source change,
and it still rebuilds from clean as the dependent in the cycle that follows
this one (Stage 6). No patch file applies to ADGenICam; the in-place edit that
`conf.ADGenICam` applies through its prerequisite `patch.ADGenICam` in
`configure/RULES_MODS_CONFIG` (the `ADApp` to `cfg` change in
`GenICamApp/src/Makefile`) is untouched by the range. The Maintainer keeps the
pin and takes none of the three commits. Step 6.3 needs no pin edit
(`configure/RELEASE` already holds `ba5b9b8`). Module build and IOC
acceptance remain pending.

Observed 2026-10-29: the effective pin and prepared source are
`ba5b9b8bfcd0a38e1de558096cadf1bf5aca7768`.
Remote HEAD names `master` at
`df3d7cd35b0eb2390095b6d3bfbbcb6860c92cc1`, dated 2026-10-01.
The branch contains three commits after the pin, including one merge,
matching the previously recorded head. The latest remote release tag is
`R1-10`, an ancestor of the pin; no later release tag is present.

The two non-merge commit subjects describe support for The Imaging Source
DMK 33GX174 camera and restoration of `GC_prefix` for upstream.
At that observation compatibility and inclusion were open for step 4 under D25;
D34 has since recorded the decision to keep the pin.
The source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/ADGENICAM`. Baseline pin: `ba5b9b8`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `ba5b9b8bfcd0a38e1de558096cadf1bf5aca7768` | 2025-08-25 | equal | 0 |
| Latest release tag `R1-10` | `59622340842d7ac4ed46da92c4f3ca28f0a38cae` | 2024-07-26 | behind | 0 |
| Default branch `master` | `df3d7cd35b0eb2390095b6d3bfbbcb6860c92cc1` | 2026-10-01 | ahead | 3 |

The baseline contains 35 commits beyond the tag; the tag adds none.
The default branch contains 38 commits beyond this tag.

Change summary from commit subjects and changed-file lists: The Imaging Source DMK 33GX174 camera support and restoration of GC_prefix.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: accepted
Plan acceptance: 2026-11-04, the maintainer
Implementation authorization: 2026-11-04, the maintainer
Review findings and rulings: none; the claims were verified against the repository (the pin, no apply target, the one dependent ADVimba rebuilt from a new source tree) and the installed tree of the Debian 13 machine (the link, the one library `libADGenICam.so`, the library of ADVimba that needs it and its `dep=ADGenICam` line, both inside the one dependent, no site module that names it) before the acceptance.

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `ba5b9b8` (version ba5b9b8) and does not move (unchanged, no newer upstream release (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash ADGenICam ADGENICAM <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. The dependents, the modules whose `_DEPS` line lists `build.ADGenICam`, are ADVimba; each is rebuilt on each machine after the update by one command, `cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` (label `rebuild-<d>`, whose `rc=0` covers the three), except ADVimba, whose `distclean` is unsafe by The checks, item 1, and which is rebuilt from a new source tree instead (move `<d>-src` aside, `make <D_KEY>`, the apply targets of `<d>` if any, `make conf.<d>`, `make build.<d>`).
4. The checks on the candidate: `guest-roundtrip.bash <candidate> ADGenICam ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/ADGenICam ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of ADGenICam in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libADGenICam` and the module name, as Stage 3 sets out, with the result in `work/ADGenICam-bump/reverse-deps.md`; the search is good when every module it names is among the dependents (ADVimba), which are the build-order consumers; a module outside that list is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/ADGenICam/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash ADGenICam ADGENICAM <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/ADGenICam-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`, and `rebuild-<d>`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/ADGenICam -> ./ADGenICam-ba5b9b8`, the `libADGenICam` SONAME, `UPDATE-DONE ADGenICam <candidate>` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `rebuild-<d>`: `rc=0` for ADVimba | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching ADGenICam-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | not run | Debian 13 | pending | none |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module outside ADVimba | not run | Debian 13, Rocky Linux 8.10 | pending | none |

### ADVimba upstream observation

D34 keeps the pin `tags/R1-5` (`e2b9e4fc3d7df04c1b5ad8c50dc0d2d64e2a386e`).
On 2026-10-31 the remote `master` is at
`ddeb02109f0e76fa44a110e3df22ff3bbf025b96`, nine commits after the pin, and
`R1-5` is still the latest release tag. The nine commits (`00a174c` to
`ddeb021`, three of them merges) change eight files: `configure/CONFIG`,
`configure/CONFIG_SITE` and `configure/RELEASE` of the module and of its
example IOC (an executable bit removed, a `CONFIG_SITE.local` include added,
the `ADGENICAM` definition moved before the `RELEASE.local` includes so a
local file can override it), the unused `spinnakerAppMain.cpp` of the example
IOC removed, and `PROD_IOC` changed to `PROD_IOC_Linux` for the
`testOpenClose` example program; no header, library source or fix. None of
it reaches this build: `conf.ADVimba` writes `configure/RELEASE` and
`configure/CONFIG_SITE` of the prepared source in full, the `configure/CONFIG`
change is a mode bit only, the example IOC under `iocs/` is not built because
the rewritten `configure/CONFIG_SITE` leaves `BUILD_IOCS` unset and the top
`Makefile` enters `iocs` only when it is `YES` (so its three configuration
files and the removed file, which was never in a `SRCS` list, do not matter),
and the example program builds the same on Linux.
Stage 3 finds no consumer: no `_DEPS` line names `build.ADVimba`, and no
Makefile or source outside `ADVimba-src` links `ADVimba` or includes its
headers (`rg` and `find` agree). No patch file applies to ADVimba; the
in-place edit that `conf.ADVimba` applies through its prerequisite
`patch.ADVimba` in `configure/RULES_MODS_CONFIG` (the `ADApp` to `cfg`
change in `vimbaApp/src/Makefile`) is untouched by the range. The Maintainer
keeps the pin and takes none of the nine commits. Step 6.3 needs no pin edit
(`configure/RELEASE` already holds `tags/R1-5`). Module build and IOC
acceptance remain pending.

Observed 2026-10-29: the latest remote release tag is `R1-5`, matching
the effective pin and prepared source at
`e2b9e4fc3d7df04c1b5ad8c50dc0d2d64e2a386e`.
Remote HEAD names `master` at
`ddeb02109f0e76fa44a110e3df22ff3bbf025b96`, dated 2026-04-16.
The branch contains nine commits after `R1-5`; there is no newer release tag.

The tag comparison remains unchanged. At that observation treatment of the
later branch changes was open for step 4, and D25 required confirmation of
pin retention and its reason with the areaDetector dependencies; D34 has
since recorded the decision to keep the pin.
The source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/ADVIMBA`. Baseline pin: `tags/R1-5`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `e2b9e4fc3d7df04c1b5ad8c50dc0d2d64e2a386e` | 2024-12-01 | equal | 0 |
| Latest release tag `R1-5` | `e2b9e4fc3d7df04c1b5ad8c50dc0d2d64e2a386e` | 2024-12-01 | equal | 0 |
| Default branch `master` | `ddeb02109f0e76fa44a110e3df22ff3bbf025b96` | 2026-04-16 | ahead | 9 |

The default branch contains 9 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Linux-only build selection, local configuration overrides, ADGenICam override ordering, and removal of an unused file.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: none; the pin and the patches are unchanged (sub-step 1 of step 6).

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R1-5` (version 1.5.0) and does not move (unchanged, no newer upstream release (D34)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; no file is searched for an old version.
2. The module has no apply target in the `patch:` list, so `guest-update.bash ADVimba ADVIMBA <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.ADVimba` in its `_DEPS` line, so no dependent is rebuilt. The top Makefile of ADVimba passes `realuninstall` to an `iocs` directory it does not build, so `make distclean.ADVimba` is never run on it; `guest-update.bash` removes the source tree and rebuilds from the clone, which is the safe form.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> ADVimba ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/ADVimba ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of ADVimba in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library names `libVimbaC`, `libVimbaCPP`, `libVimbaImageTransform`, `libADVimba` and the module name, as Stage 3 sets out, with the result in `work/ADVimba-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/ADVimba/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash ADVimba ADVIMBA <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/ADVimba-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/ADVimba -> ./ADVimba-1.5.0`, the `libVimbaC` and `libVimbaCPP` and `libVimbaImageTransform` and `libADVimba` SONAMEs, `UPDATE-DONE ADVimba <candidate>` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching ADVimba-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | not run | Debian 13 | pending | none |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | not run | Debian 13, Rocky Linux 8.10 | pending | none |

### caPutLog upstream observation

Observed 2026-10-29: the latest remote release tag is `R4.2`, matching
the effective pin and prepared source at
`6f9eb3f6c75e49201d114f8e194d53cef493a522`.
Remote HEAD names `master` at the same commit, dated 2026-02-27.
There are no later commits on the observed default branch and no newer
release tag.

D13 remains the accepted move from `dafb0b2` to `R4.2`; the module's
release outcome remains IN. The source pin is unchanged by this survey.
This observation does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/CAPUTLOG`. Baseline pin: `tags/R4.2`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `6f9eb3f6c75e49201d114f8e194d53cef493a522` | 2026-02-27 | equal | 0 |
| Latest release tag `R4.2` | `6f9eb3f6c75e49201d114f8e194d53cef493a522` | 2026-02-27 | equal | 0 |
| Default branch `master` | `6f9eb3f6c75e49201d114f8e194d53cef493a522` | 2026-02-27 | equal | 0 |

The default branch contains 0 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption remain at step 4.

Issue: opened at the plan step (sub-step 1 of step 6).

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/R4.2` (version 4.2.0) already, moved from `dafb0b2` by commit `d2bf61b` (IN (D13)), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `d2bf61b` rewrote are searched for `dafb0b2` at the end of the checks, and none may remain.
2. The module has no apply target in the `patch:` list, so `guest-update.bash caPutLog CAPUTLOG <candidate> ~/sandbox/EPICS-env` runs none and the log shows no `Patching` line.
3. No module lists `build.caPutLog` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> caPutLog ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/caPutLog ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of caPutLog in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the library name `libcaPutLog` and the module name, as Stage 3 sets out, with the result in `work/caPutLog-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/caPutLog/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash caPutLog CAPUTLOG <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/caPutLog-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: no `Patching` line, `link: modules/caPutLog -> ./caPutLog-4.2.0`, the `libcaPutLog` SONAME, `UPDATE-DONE caPutLog <candidate>` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching caPutLog-src lines: 0`, `revert rc=0`, `status lines in all trees: 0` | not run | Debian 13 | pending | none |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `verify_fixture_tc32sim`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| No `dafb0b2` left in the files that `d2bf61b` rewrote | not run | local host | pending | none |

### pyDevSup upstream observation

D48 retains the pin `2.1.0` and selects `f0ad79d` and `e3f5ae3` as two patches;
the other five scored commits are not carried. Module build and IOC acceptance
remain pending.

Observed 2026-10-29: the latest remote release tag is `2.1.0`, matching
the effective pin and prepared source at
`b5cef38a6d9f74f9c59f967185ba6d1940637c03`.
Remote HEAD names `master` at
`a38e7b57c182300ef620d224c37395f63eb8a61a`, dated 2026-10-27.
The branch contains 14 commits after `2.1.0`; there is no newer release tag.

D14's excluded head, `80cdb1564b99dabf9560a188cadf450561b4f8bb`, is an
ancestor of the observed head, with ten commits after it. Their subjects
describe alarm handling with AMSG, test record-cache cleanup, compiler
warning changes, removal of `epicsThreadExitMain()`, and CI and changelog updates.
At that observation compatibility and inclusion of the additional changes
were open for step 4 under `upstream-fix-carry-procedure.md`; D48 has since
decided them.
D14 remains IN for `2.1.0`, with its excluded head not taken.
The source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/PYDEVSUP`. Baseline pin: `tags/2.1.0`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `b5cef38a6d9f74f9c59f967185ba6d1940637c03` | 2026-10-05 | equal | 0 |
| Latest release tag `2.1.0` | `b5cef38a6d9f74f9c59f967185ba6d1940637c03` | 2026-10-05 | equal | 0 |
| Default branch `master` | `a38e7b57c182300ef620d224c37395f63eb8a61a` | 2026-10-27 | ahead | 14 |

The default branch contains 14 commits beyond this tag.

Change summary from commit subjects and changed-file lists: AMSG alarm handling, record-cache cleanup in tests, deprecated thread-exit removal, compiler warnings, Python 3 examples, CI, and changelog updates.

This records source changes only; compatibility and adoption were left to step 4; D48 records the decision.

Issue: opened at the plan step (sub-step 1 of step 6).

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
on the baseline tree of the two test machines, with the tools at `afb7b3c` or
later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.
The facts of this module:

1. The pin is `tags/2.1.0` (version 2.1.0) already, moved from `4527ed0` by commit `09b9b24` (IN (D14), two carries prepared (D48), full-cycle verification pending), so no pin edit is made and the tip of origin at the acceptance of the plan is the candidate; the files that `09b9b24` rewrote are searched for `4527ed0` at the end of the checks, and none may remain.
2. The apply targets `patch.pyDevSup.commit.apply` with the files `2.1.0-01-f0ad79d-test-record-cache-clear.p0.patch`, `2.1.0-02-e3f5ae3-non-interactive-main-sleep.p0.patch` are run by `guest-update.bash pyDevSup PYDEVSUP <candidate> ~/sandbox/EPICS-env` before the build; the log shows 2 `Patching pyDevSup-src` lines.
3. No module lists `build.pyDevSup` in its `_DEPS` line, so no dependent is rebuilt.
4. The checks on the candidate: `guest-roundtrip.bash <candidate> pyDevSup ~/sandbox` on the Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/pyDevSup ~/sandbox/alsu-site-modules "<scripts>"` on both with the scripts `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example` (the module scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and the search for the reverse dependencies of pyDevSup in the installed tree over `$(make -s print-INSTALL_LOCATION_EPICS)/modules` by the module name only, because the module installs no shared library, as Stage 3 sets out, with the result in `work/pyDevSup-bump/reverse-deps.md`; the search is good when it names no module, since no module lists this one in its `_DEPS` line; a module it names is a finding for the maintainer. The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/pyDevSup/verify_install_metadata.log` (label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash pyDevSup PYDEVSUP <candidate> ~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with `work/pyDevSup-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, `patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, `reverse-deps`), stops at the first log that does not end with `rc=0`, and prints one line per row of the Results table.
5. A check that is not good stops the cycle at that check with its log kept; the
   maintainer classifies the failure and decides, as the rule of a failed Stage 6
   sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: 2 `Patching pyDevSup-src` lines before the build, `link: modules/pyDevSup -> ./pyDevSup-2.1.0`, `UPDATE-DONE pyDevSup <candidate>` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching pyDevSup-src lines: 2`, `revert rc=0`, `status lines in all trees: 0` | not run | Debian 13 | pending | none |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0` over `verify_install_metadata`, `verify_dependency_graph`, `verify_minimal_example`, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| No `4527ed0` left in the files that `09b9b24` rewrote | not run | local host | pending | none |

### siteApps upstream observation

D34 keeps the pin `0.1.0` (resolved commit
`37594135824a110c93ee49ed45a7ba82d3cb5815`). On 2026-11-01 the remote HEAD of the
module is still that commit and `0.1.0` is the only tag. Stage 3 finds no
consumer: no `_DEPS` line of either repository names `build.siteApps`, no Makefile
or source of the 37 EPICS-env modules or of `unidrv` links it, includes it or names
it (a plain-name search, a `LIBS +=` search and an `#include` search, each by `rg`
and by `find` with `grep`, since the module has no library stem or header prefix), and no shared object of
the installed tree of release 1.3.0 refers to it (that tree installs `siteApps`
with `db` and `iocsh` directories and no library, and it predates the loader
metadata and holds no `cfg/iocsh.conf`, so the search for a `dep=siteApps` there
proves nothing and is repeated in the tree of the cycle). The module installs database templates and iocsh fragments only; its templates
use the device support `EtherIP`, a run-time dependency on ether_ip through the
loader that is not a `build.` entry (D51); the IOCs that load them through the
loader are outside both repositories. There is no
changeset to read at Stage 4, no patch file applies to it, and step 6.3 needs no
pin edit (`configure/RELEASE` of the site repository already holds `0.1.0`).
Module build and acceptance remain pending.

Observed 2026-10-29: the effective pin in the selected site repository is
`0.1.0`. Its resolved commit and the prepared source are
`37594135824a110c93ee49ed45a7ba82d3cb5815`.
The remote tag query returns only `0.1.0`, resolving to that same commit.
Remote HEAD names `master` at the same commit, dated 2026-03-12.
There are no later commits on the observed default branch and no newer
release tag.

The survey finds no upstream update. At that observation the step 4 assessment of
dependencies, consumers, and pin retention was open under D25; D34 has since
recorded it.
The source pin is unchanged by this survey. This observation does not
complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `site/SITEAPPS`. Baseline pin: `0.1.0`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `37594135824a110c93ee49ed45a7ba82d3cb5815` | 2026-03-12 | equal | 0 |
| Latest release tag `0.1.0` | `37594135824a110c93ee49ed45a7ba82d3cb5815` | 2026-03-12 | equal | 0 |
| Default branch `master` | `37594135824a110c93ee49ed45a7ba82d3cb5815` | 2026-03-12 | equal | 0 |

The default branch contains 0 commits beyond this tag.

Change summary from commit subjects and changed-file lists: No commits beyond the baseline on the observed default branch.

This records source changes only; compatibility and adoption were left to step 4; D34 records that no decision was needed.

Issue: opened at the plan step (sub-step 1 of step 6).

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
in the site checkout `~/sandbox/alsu-site-modules` of the two test machines,
with `docs/procedures/site-modules-procedure.md` (Build, Cycle evidence) for the
repository-specific actions; the scripts of `tools/module-check/` do not prove a
site build, so the equivalent operations run in that checkout through
`tools/module-check/guest-run.bash` into `work/siteApps-bump/`. The site
candidate is a commit of the site repository, pushed to its origin, and the
record keeps it beside the EPICS-env candidate. The facts of this module:

1. The pin is `0.1.0` and does not move (unchanged, D34), so no pin edit is made;
   the site candidate is the commit the site checkout is at, `1a31f30`, and the
   EPICS-env candidate is the commit of this accepted plan.
2. The site repository has no patch for siteApps, so `make patch` and
   `make patch.revert` run no leg for it.
3. No module lists `build.siteApps` in its `_DEPS` line, in either repository,
   so no dependent is rebuilt; its templates use the device support of
   `ether_ip` at run time, which the IOC check exercises.
4. The checks on the candidate, in the site checkout on both machines: the clean
   rebuild of the module (move `siteApps-src` aside, `make init`, `make patch`,
   `make conf`, `make check.module-deps`, `make build.siteApps`,
   `make symlinks`; label `build`), `LC_ALL=C make exist.modules LEVEL=1 | grep siteApps`
   (label `exist`), `make check.deps` and `make check.env` (labels
   `installed-tree-deps`, `installed-tree-env`), and the IOC check of
   `docs/src/procedures/add-site-modules.md`, Verification, with
   `<tree>/setEpicsEnv.bash` sourced and `st.cmd` in `~/sandbox/site-ioc`
   (label `ioc`). On the Debian 13 machine the site patch round trip in a
   fresh clone of the site candidate at `~/sandbox/alsu-site-modules-roundtrip`
   with `INSTALL_LOCATION:=<tree>` (label `patch-round-trip`): `make init`,
   `make patch`, `make patch.revert`, each with its `rc`, then
   `git -C <module>-src status --short` for both modules. The EPICS-env loader
   suite runs on both machines with the site checkout (label `consumers`). The
   module installs no shared library, so the reverse-dependency search is by
   the module name only (label `reverse-deps`). The 38 count of the suite is read on each machine with `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/siteApps/verify_install_metadata.log` (label `metadata-lines`).
5. A check that is not good stops the cycle at that check with its log kept;
   the maintainer classifies the failure and decides, as the rule of a failed
   Stage 6 sets out.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `build`: `make check.module-deps` findings recorded, `make build.siteApps` exit 0, `exist` shows `siteApps -> ./siteApps-0.1.0` and `siteApps-0.1.0` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `ioc`: `iocRun: All initialization complete`, exit 0 on `exit`, `iocsh.bash -n st.cmd` names `# ether_ip 3.10.0`, `# siteApps 0.1.0`, `# unidrv <version>` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `revert rc=0`, no change in any module source | not run | Debian 13 | pending | none |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` by the module name | not run | Debian 13, Rocky Linux 8.10 | pending | none |

### unidrv upstream observation

D50 moves the pin from `0.5.1` to `e5a8561`
(`e5a8561100ca825b865aa49fe91c0015407ba3c6`) and retires the site patch.

Stage 3 finds no consumer: no `_DEPS` line of either repository names
`build.unidrv`, no module source of EPICS-env refers to it, the only mention in
`siteApps` is a commented-out `#UNIDRV=` line of its `configure/RELEASE` (a
template line, not a dependency), and no shared object of the installed tree of
release 1.3.0 needs `libunidrv`, `libmks` or `libre2`. That tree predates the
loader metadata and holds no `cfg/iocsh.conf`, so the search for `dep=unidrv`
there proves nothing and is repeated in the tree of the cycle. The `configure/RELEASE` of unidrv declares `ASYN`, which no Makefile or
source of the module uses.

Stage 4 over the pin and the head shows 4 commits (2 merges) and 3 files:
`unidrvApp/src/Makefile` gains five `DBD +=` lines,
`unidrvApp/src/unidrvSupport.dbd` is a new file of six lines, and
`mksApp/Db/mks.substitutions` is removed; the first two are byte-identical to
`unidrv-supportdbd.p0.patch`, and the removed file is built by no Makefile, is not
installed by the tree of release 1.3.0 and is referenced by no file. No header or
library source changes. `docs/source-inventory-1.5.0.tsv` keeps the baseline pin
`0.5.1`.

Why the commit and not a tag, the risk and the way back. The milestone of the
site repository keeps the pin and the patch until a tag carries both; D50 waives
that condition because the head holds the same change that the site already
builds as a patch plus the removal of one unused file, so the built source differs
from the patched pin only by that removal, and because upstream has not tagged
that commit and promises no tag before the release. The risk is that `main` is a branch and moves: the head is not a
published version, and the installed directory `unidrv-e5a8561` names a commit.
If upstream later tags a different commit, the pin is edited to that tag in
`configure/RELEASE`, and the installed directory name and the `modules/unidrv`
link change with it. If the head proves unsuitable before the release, the way
back is to revert the site commit of the cycle: the patch file returns from the
history of the site repository, the pin returns to `0.5.1`, and the edits of this
repository are reverted with it.

Step 6.3 and the retirement. Items 1 to 3 are in the site repository, items 4
to 6 in this one:

1. `configure/RELEASE`: set `SRC_TAG_UNIDRV:=e5a8561`, seven characters like the
   commit pins of EPICS-env, and leave `SRC_VER_UNIDRV:=$(SRC_TAG_UNIDRV)` as it
   is, derived; the installed directory becomes `unidrv-e5a8561`. Change the date
   comment above the pin from `2024-10-30` to `2026-10-27`. Reword the two
   comment lines "Select module sources by published version tag. Use each
   selected tag as the installed directory version." to say that a module is
   selected by a version tag or by a commit, and that the installed directory
   version is that value (`siteApps` keeps its tag).
2. Retire the patch: remove `patch/unidrv-supportdbd.p0.patch` with `git rm`;
   remove the block of `configure/RULES_PATCH` from its
   `unidrv-supportdbd.p0.patch` comment to its revert target, and keep the file,
   which `configure/RULES` includes; remove `patch.unidrv.supportdbd.apply` and
   `.revert` from the `patch:` and `patch.revert:` lists of `configure/RULES_SRC`;
   reword the comment of `configure/CONFIG_MODS_IOCSH` that describes the patch to
   say that the module installs `unidrvSupport.dbd` itself. The value
   `unidrv_IOCSH_DBDS:=unidrvSupport.dbd mks.dbd` does not change, because the
   head installs the same file.
3. `README.md`: in "`configure/RELEASE` holds the site Git base URL and the tag of
   each module" write "the tag or commit of each module"; delete the sentence that
   places the downstream patches in `patch/` with their targets in
   `configure/RULES_PATCH`, because the repository then carries none. In the
   milestone of the site repository add a dated decision that supersedes its lines
   keeping the pin `0.5.1` and the patch until a tag carries both (the entry point
   near line 10, the lines near 171, and the claims of D3 and D5 that the
   repository carries patches in `patch/`).
4. `docs/src/procedures/add-site-modules.md`: change "Clone the modules at their
   tags" near line 68 to say tag or commit; reword the heading of step 5 near line
   85, "Apply the downstream patches of the modules" (for example "Run the patch
   targets for the modules"), and in that step replace the
   sentence that the repository carries one patch and the `Patching` block (lines
   91 to 101) by the sentence that the repository carries no patch and the
   `make: Nothing to be done for 'patch'.` that the command prints; in the
   section that starts near line 175 remove lines 176 to 196 (the lead-in on
   reverting and reapplying, the two `make` commands and the `git -C unidrv-src
   status --short` command, the sentence "The revert prints the patch and its
   files ...", and the status block) and the sentence that the check leaves patches
   applied, and keep the closing sentences that require the fresh-checkout round
   trip of `site-modules-procedure.md`, Cycle evidence, reworded so that they
   stand without "the patched source status shown above" and without a dangling
   "also"; change the version strings `unidrv-0.5.1` and `# unidrv 0.5.1` near lines 162, 163 and 241
   to `unidrv-e5a8561` and `# unidrv e5a8561`.
5. `docs/procedures/site-modules-procedure.md`: in line 5 drop "and the downstream
   patches of its modules (`patch/`)" so that the list ends "its README, Make Rules,
   and lists"; in the paragraph near line 102 write "Use the book's Verification
   section for the site IOC." and drop "and the patch state of the build checkout"
   and the sentence "Its revert-and-apply check leaves patches applied for building;
   it does not replace the fresh-checkout apply-and-revert round trip", keeping the
   requirement of that round trip elsewhere in the procedure, whose legs are empty
   without a patch, and the next sentence reworded without its dangling "Also".
6. `docs/procedures/release-checklist.md` near line 82: drop the sentence "The build
   checkout's revert-and-apply check is separate and leaves patches applied
   (`site-modules-procedure.md`, Cycle evidence)", which cites the check that
   items 4 and 5 remove, and keep the sentence on the round trip of the fresh
   checkout.

Done when, in the tree of the cycle: `make patch` and `make patch.revert` exit 0
and print only `Nothing to be done`, with no `Patching` or `Reverting` line; `make build.unidrv` writes a
`cfg/iocsh.conf` of `unidrv-e5a8561` that lists `unidrvSupport.dbd` and `mks.dbd`,
and `iocsh.bash` loads the module; `make check.module-deps` exits 0, without the
four findings on `mks.substitutions` that it reports at the pin; and a fresh
checkout round trip runs the patch legs empty with exit 0. Module build and
acceptance remain pending.

Observed 2026-10-29: remote HEAD names `main` at
`e5a8561100ca825b865aa49fe91c0015407ba3c6`, dated 2026-10-27.
The remote tag list ends at `0.5.1`, which resolves to the prepared source
commit `86688df5640cc9a4abbe8d99b7c9a4bc838bc328`.
The range from that pin to the observed branch head contains four commits,
including two merge commits. The two non-merge commit subjects describe
dynamic IOC module loading support and removal of an unused substitutions
file; their compatibility was not assessed then.

Rechecked after siteApps on 2026-10-29: the effective pin, prepared source,
remote HEAD, latest tag, and four-commit count match the observation above.
Rechecked on 2026-11-01: the remote HEAD of `main` is still
`e5a8561100ca825b865aa49fe91c0015407ba3c6` and the newest tag is still `0.5.1`.

The source stays at `0.5.1` until the cycle. At that observation inclusion of the
branch changes was an open step 4 decision; D50 has since decided it. This
observation covers unidrv only and does not complete the combined upstream survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `site/UNIDRV`. Baseline pin: `0.5.1`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `86688df5640cc9a4abbe8d99b7c9a4bc838bc328` | 2024-10-29 | equal | 0 |
| Latest release tag `0.5.1` | `86688df5640cc9a4abbe8d99b7c9a4bc838bc328` | 2024-10-29 | equal | 0 |
| Default branch `main` | `e5a8561100ca825b865aa49fe91c0015407ba3c6` | 2026-10-27 | ahead | 4 |

The default branch contains 4 commits beyond this tag.

Change summary from commit subjects and changed-file lists: Dynamic IOC module loading support and removal of an unused substitutions file.

This records source changes only; compatibility and adoption were left to step 4; D50 decides them.

Issue: opened at the plan step (sub-step 1 of step 6).

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`
in the site checkout `~/sandbox/alsu-site-modules` of the two test machines,
with `docs/procedures/site-modules-procedure.md` (Build, Cycle evidence) for the
repository-specific actions; the scripts of `tools/module-check/` do not prove a
site build, so the equivalent operations run in that checkout through
`tools/module-check/guest-run.bash` into `work/unidrv-bump/`. The site
candidate is a commit of the site repository, pushed to its origin, and the
record keeps it beside the EPICS-env candidate. The facts of this module:

1. The pin moves from `0.5.1` to `e5a8561` (IN, D50) in sub-step 3 of this cycle,
   in the site repository: `SRC_TAG_UNIDRV:=e5a8561` in its `configure/RELEASE`
   with `SRC_VER_UNIDRV` derived, so the installed directory becomes
   `unidrv-e5a8561`; the site patch `unidrv-supportdbd` is retired in the same
   commit, and the documents of both repositories are edited as items 1 to 6 of
   the unidrv observation above list (items 1 to 3 in the site repository, 4 to
   6 in this one). The site commit of that change is the site candidate; the
   commit of this accepted plan plus items 4 to 6 is the EPICS-env candidate.
   The maintainer authorizes each commit and push, in each repository.
2. After the retirement the site repository carries no patch: `make patch` and
   `make patch.revert` print only `Nothing to be done`, with no `Patching` or
   `Reverting` line.
3. No module lists `build.unidrv` in its `_DEPS` line, in either repository, so
   no dependent is rebuilt.
4. The checks on the candidates, in the site checkout on both machines: the
   rebuild of the module from the new pin (move `unidrv-src` aside, `make init`,
   `make patch`, `make conf`, `make check.module-deps`, `make build.unidrv`,
   `make symlinks`; label `build`), which must write the `cfg/iocsh.conf` of
   `unidrv-e5a8561` listing `unidrvSupport.dbd` and `mks.dbd` and must report
   none of the four `mks.substitutions` findings of the old pin;
   `LC_ALL=C make exist.modules LEVEL=1 | grep unidrv` (label `exist`),
   `make check.deps` and `make check.env` (labels `installed-tree-deps`,
   `installed-tree-env`), and the IOC check of
   `docs/src/procedures/add-site-modules.md`, Verification, with `st.cmd` in
   `~/sandbox/site-ioc` (label `ioc`). On the Debian 13 machine the site patch
   round trip in a fresh clone of the site candidate at
   `~/sandbox/alsu-site-modules-roundtrip` with `INSTALL_LOCATION:=<tree>`
   (label `patch-round-trip`), whose patch legs run empty with exit 0. The
   EPICS-env loader suite runs on both machines with the site checkout (label
   `consumers`), where `verify_install_metadata.bash` then reads
   `unidrv e5a8561` from the site pins. The reverse-dependency search is by the
   library names `libunidrv`, `libre2`, `libmks` and the module name (label
   `reverse-deps`). At the end, no `0.5.1` may remain in the files the pin
   change rewrote, in either repository. The old installed directory
   `unidrv-0.5.1` stays beside the new one until the maintainer removes it.
5. A check that is not good stops the cycle at that check with its log kept;
   the maintainer classifies the failure and decides, as the rule of a failed
   Stage 6 sets out; a HOLD puts the pin, the patch, and the documents back.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| Pin edit and retirement: the site commit and the EPICS-env commit, items 1 to 6 done, no `0.5.1` left in the files they rewrote | not run | local host | pending | none |
| `build`: `make patch` prints only `Nothing to be done`, `make check.module-deps` exit 0 without the `mks.substitutions` findings, `make build.unidrv` exit 0, `cfg/iocsh.conf` of `unidrv-e5a8561` lists `unidrvSupport.dbd` and `mks.dbd`, `exist` shows `unidrv -> ./unidrv-e5a8561` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `ioc`: `iocRun: All initialization complete`, exit 0 on `exit`, `iocsh.bash -n st.cmd` names `# unidrv e5a8561` | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `patch-round-trip`: `init rc=0`, `patch rc=0`, `revert rc=0`, no `Patching` or `Reverting` line, no change in any module source | not run | Debian 13 | pending | none |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0`; `metadata-lines`: `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration`, with `unidrv e5a8561` read from the site pins | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` names no module | not run | Debian 13, Rocky Linux 8.10 | pending | none |

### Combined survey coverage

Observed 2026-10-29: comparison of the source inventory with the per-module
observations covers all 39 unique modules: 37 from EPICS-env and two from
the site repository. No inventory module lacks an observation, and no
observation names a module outside the inventory. The EPICS base observation
is in its module section below.

The full EPICS-env survey was run on 2026-10-29 and exited 0: 37 modules
attempted and 37 lookups completed. Its 37 keys and reported current pins
match the EPICS-env entries of the source inventory. All ten reported updates
match the existing per-module observations: BASE, RECSYNC, CALC, LUA,
MEASCOMP, MOTOR, PCAS, PMAC, ADCORE, and ADGENICAM. CALC's reported
`R5-4-2` remains the older version-sort result documented above, not a newer
release. The tool does not cover the two site modules or the later branch
commits of tag-pinned modules; their Git observations remain separate evidence.
Local execution evidence is in `work/survey-final-iG6QOd/`: `observed-at.txt`,
`survey.txt`, and `exit-status.txt`.

Step 3 is complete as of 2026-10-29. Fresh remote heads and tags were fetched
into separate Git object repositories without changing the pinned source
checkouts. Each of the 39 module sections now records its owner/key, baseline,
latest release tag or confirmed absence, default branch, exact commits and
commit dates, relationships and new-commit counts relative to the baseline,
branch commits beyond the tag, and a change summary. All source HEADs still
match the inventory and all source checkouts are clean.

Tag selection uses the observed upstream tag history, commit dates, and
ancestry rather than version sorting alone. CALC's historical R5-4-2 is not
the latest release. recsync records stable 1.10.0 and the later 1.10.1-rc1
separately. pscdrv exposes only the atf-20250728 snapshot tag, with no
versioned release tag. feed-core, QPC, and rgamv2 expose no tags.

Local supporting evidence is in `work/survey-evidence-3po9_ziq/`:
per-module `remote-head.txt`, `fetch.txt`, and `evidence.json`, plus
`completed-evidence.json` with the derived comparisons and commit subjects.
The fetched refs and objects are in each module's `objects.git` directory.
The tables record observations, not approved pin changes. Step 4 decisions,
source pins, and build status are unchanged; no build or IOC check ran.

### EPICS base

Outcome: HOLD at `tags/R7.0.10` (D26). The survey of 2026-10-25 reported `tags/R7.0.10` as the latest release; its result was unchanged at that date. R7.0.11 was released on 2026-10-27 and is excluded from 1.5.0. The 18 carry patches and 3 site patches of `patch/` stand.

Step 3 observation, 2026-10-29: the remote tag list confirms `R7.0.11` as
the latest stable version tag, resolving to
`9d60f8d0d383dd54a3f02695bfdfcb4fad29586d`. The effective pin remains
`tags/R7.0.10`; D26 stands. This is a per-module Git observation, not a
completed run of the combined survey.

**Complete ref evidence, observed 2026-10-29.**

Owner/key: `EPICS-env/BASE`. Baseline pin: `tags/R7.0.10`.
Dates below are commit dates, not publication dates. Relationships and
new-commit counts are relative to the baseline commit; counts include merges.

| Ref | Resolved commit | Commit date | Relationship | New commits |
| --- | --- | --- | --- | --- |
| Baseline | `bf11a0c31c919ba85ba2e23b72bcf0b5f9f62e77` | 2025-12-15 | equal | 0 |
| Latest release tag `R7.0.11` | `9d60f8d0d383dd54a3f02695bfdfcb4fad29586d` | 2026-10-26 | ahead | 185 |
| Default branch `7.0` | `c277e979405487c9fb5dd8f1270ca3301e856f4f` | 2026-10-26 | ahead | 187 |

The default branch contains 2 commits beyond this tag.

Change summary from commit subjects and changed-file lists: CA server message validation, database and record fixes, errlog changes, IOC shell additions, platform/build changes, and PVA submodule updates. The two commits after R7.0.11 change the core development version and submodule revisions.

This records source changes only; compatibility and adoption remain at step 4.


Issue: #111, https://github.com/jeonghanlee/EPICS-env/issues/111

Plan status: accepted
Plan acceptance: 2026-11-02, the maintainer
Implementation authorization: 2026-11-02, the maintainer
Site consumer coverage: `siteApps` and `unidrv` are installed into the tree in step 6, at the pins they hold.
Review findings and rulings: the review passes of 2026-10-28 found only items of consistency and wording, all fixed in the plan: the source of the guest resources, the place of the `Patching` count, the guest of the round trip, the undefined `<sandbox>`, the missing pointer to the tool commands, and the wording of this line. Rulings of the maintainer on 2026-10-28: both test machines are new guests, Debian 13 and Rocky Linux 8.10, as #111 says, although the local host is also Debian 13; the tree is built as `docs/src/procedures/build-and-install.md` sets out, not through the `epics_build` operator that #111 named, and the body of #111 was edited to follow the plan. On 2026-11-02 the maintainer ruled that the two site modules are installed into the tree in step 6 at the pins they hold, from the site repository at commit `1a31f30`, and that the host packages of a new guest are installed as the CI workflows do; the maintainer accepted the plan and authorized the implementation the same day.

Plan:

1. Issue #111 is open in GitHub milestone 1.5.0.
2. Review this plan in two passes, one that verifies each claim against the
   repository and one that reads it from the seat of the agent who carries it
   out. Record the findings and the maintainer's rulings here beside the
   acceptance; the maintainer accepts the plan and separately authorizes the
   implementation.
3. Commit the accepted plan and push it. The pin does not move, so that commit
   is the candidate, and the test machines fetch it from origin.
4. Ask the maintainer for the test machines
   (`docs/procedures/release-procedure.md`, Test machines). Purpose: the
   baseline build of the 1.5.0 tree at the candidate, kept as the baseline of
   every later module check. Operating systems: Debian 13 and Rocky Linux 8.10
   (D19). Resources: 2 vCPU, 4096 MiB memory, and 20 GiB disk each, which the
   request states; the values used are recorded
   (`docs/procedures/release-procedure.md`, Test machines). Duration: until
   the last module cycle ends. State: new guests whose disks are kept as
   evidence until the results are recorded. Access: SSH from the local host.
5. On each test machine install the host packages that base and the modules
   need, as the `Install required packages` step of its CI workflow does
   (`.github/workflows/debian13.yml`, `.github/workflows/rocky8.yml`), with
   `sudo` where the workflow runs as root; then install the missing tools of
   the loader suite and check `df -i /tmp`; `docs/procedures/release-procedure.md`, Test machines,
   gives the check and the install commands. `<sandbox>` is a directory that
   the user of the machine owns: the checkout is `<sandbox>/EPICS-env` and the
   install location is `<sandbox>/epics`. Clone this repository into the
   checkout, check out the candidate, set the install location, and build the
   whole tree as `docs/src/procedures/build-and-install.md` sets out. The
   baseline is good when `make exist`, `make check.deps`, and `make check.env`
   exit 0 and `git -C <sandbox>/EPICS-env rev-parse HEAD` prints the
   candidate. Record the OS point release, the kernel, the compiler, and the
   count of the entries of the installed `modules` directory, which the checks
   compare against after a failed loader suite
   (`docs/procedures/release-procedure.md`, Test machines).
6. Run the checks of `docs/procedures/module-bump-procedure.md` (The checks):
   `guest-roundtrip.bash <candidate> "" <sandbox>` on the Debian 13 machine,
   `guest-suite.bash <sandbox>/EPICS-env <sandbox>/iocsh-tests/base` on every
   machine, and `make check.deps` and `make check.env` on every machine, with
   the logs named in that section in `work/base-bump/`, which `mkdir -p`
   creates in the local checkout first; the same section says when each run is
   good. The round trip prints the line `Patching lines: <N>`, where `<N>`
   counts the patch files that apply on Linux; it is 45 for the pins of this
   release, as `docs/src/procedures/build-and-install.md` gives it, and a
   different count is a finding. After these checks, install `siteApps` and
   `unidrv` into the same tree at the pins they hold, as
   `docs/src/procedures/add-site-modules.md` sets out, from a clone of the
   site repository at commit `1a31f30` in `<sandbox>`; the install is good
   when `LC_ALL=C make exist.modules LEVEL=1 | grep -e siteApps -e unidrv`
   shows both modules and their links and `make check.deps` and
   `make check.env` exit 0 in that clone. Record the site commit with the
   results.
7. Record the results below with their observed times, test machines, and
   evidence. Commit and push them and observe their landing on origin; close
   #111 on `release-1.5.0` with its body synced and a closing comment, and read
   back its closed state; then commit and push the record of the landing and
   the closed issue, which marks the module complete.
8. Write each rule the run taught into the procedure that owns it, by the
   rules of `docs/procedures/documentation-upkeep-procedure.md` (At the close
   of every step), and any lesson no procedure holds into Lessons learned, in
   a commit of their own after the commit that marks the module complete.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| Baseline build: `make exist` exit 0, HEAD at the candidate, `modules` entry count | 2026-11-02 09:26 to 09:51 UTC (Debian), 09:30 to 09:54 UTC (Rocky) | Debian 13, Rocky Linux 8.10 | pass | `baseline-build-<os>.log` ends `BUILD-END rc=0` with 45 `Patching` lines; `baseline-exist-<os>.log` lists `.versions`, `base`, `modules`, `resetEpicsEnv.bash`, `setEpicsEnv.bash`, `vendor`; `baseline-deps-<os>.log` `SO: Total Files with RPATH / ALL: 0 / 79`, `rc=0`; `baseline-env-<os>.log` `findings: 0`, `rc=0`; `baseline-facts-<os>.log` HEAD `b4197cf8859f1a211596213a474a090223724130`, `modules` entries 73 |
| Patch apply-and-revert test | 2026-11-02 15:54 to 15:58 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `init rc=0`, `src trees: 37`, `patch rc=0`, `revert rc=0`, `status lines in all trees: 0`, `ROUNDTRIP-DONE b4197cf`; no `~/epics` appeared |
| Round trip prints `Patching lines: 45` | 2026-11-02 15:58 UTC | Debian 13 | pass | `patch-round-trip-debian13.log`: `Patching lines: 45` |
| Loader suite | 2026-11-02 15:59 to 16:11 UTC (Debian), 15:59 to 16:10 UTC (Rocky) | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `minimal IOC exit=0`, `iocRun lines: 1`, `run_all rc=0`, `FAIL lines: 0`, `SUITE-DONE`; all 14 scripts `fail=0` with the counts of `examples/iocsh/tests/README.md` (`verify_docs_and_tools` 6 on both, no `docker`); `records listed: 327` (Debian), `322` (Rocky) |
| Installed-tree checks (`make check.deps`, `make check.env`) | 2026-11-02 16:10 to 16:14 UTC | Debian 13, Rocky Linux 8.10 | pass | `installed-tree-deps-<os>.log` `RPATH / ALL: 0 / 92`, `rc=0`; `installed-tree-env-<os>.log` `findings: 0`, `rc=0`; `modules` entries 75 after the suite (the two second versions it leaves) |
| Site modules installed: `siteApps` and `unidrv` listed, `make check.deps` and `make check.env` exit 0 in the site clone | 2026-11-02 16:12 to 16:14 UTC | Debian 13, Rocky Linux 8.10 | pass | `site-install-<os>.log` `rc=0` with `Patching unidrv-src with the file : unidrv-supportdbd.p0.patch` and `module-deps rc=2`; `site-exist-<os>.log` the four lines `siteApps -> ./siteApps-0.1.0`, `siteApps-0.1.0`, `unidrv -> ./unidrv-0.5.1`, `unidrv-0.5.1`; `site-deps-<os>.log` `RPATH / ALL: 0 / 95`, `rc=0`; `site-env-<os>.log` `findings: 0`, `rc=0`; `site-facts-<os>.log` site commit `1a31f3046fef9a283a14d780e380f4973483b9e9`, `modules` entries 79 |

Test machines: two new guests of the public `cloud-provision` repository, 2 vCPU,
20 GiB disk, memory as the OS sees it 3903 MiB (Debian) and 3665 MiB (Rocky),
SSH user with passwordless `sudo`, outbound access to GitHub and `docker.io`.
Debian 13.4, kernel `6.12.85+deb13-cloud-amd64`, gcc 14.2.0; Rocky Linux 8.10,
kernel `4.18.0-553.180.1.el8_10.x86_64` after the `dnf update` of the package
step and one reboot, gcc 8.5.0. The host packages were installed as the
`Install required packages` step of the CI workflow of each system does; the
first `dnf update -y` on Rocky stalled on the last of 238 downloads and was
stopped and run again, which finished. The sandbox is `/home/<user>/sandbox`,
the install location `<sandbox>/epics`, and the disk had 9.8 GiB (Debian) and
9.3 GiB (Rocky) free after the baseline. The logs are in `work/base-bump/` of
the local checkout, written by `tools/module-check/guest-run.bash`.

The site modules were installed from a copy of the prepared site checkout at
`1a31f30` (the guests hold no key for the site repository, so `git clone`
failed there and the checkout, with its two module sources at their pins, was
copied in), with `INSTALL_LOCATION:=<tree>` in its `configure/CONFIG_SITE.local`,
by `make init`, `make patch`, `make conf`, `make check.module-deps`, `make build`,
`make install`, and `make symlinks`.

Findings of the run, none of which failed a check:

1. `records listed` is 322 on both machines before the hwmon lines, where
   `examples/iocsh/tests/README.md` gives 317; the pins of this release list
   five more records. The README value is corrected in step 8 of this plan.
2. The Debian guest prints five linStat ERROR lines (`EPICSENV:T_MAX`,
   `T_LOC_MAX`, `FAN_NRUN`, `FAN_NFAIL`, and the hwmon table scan), which
   `docs/procedures/module-bump-procedure.md`, The checks, item 3, expects on a
   machine without `/sys/class/hwmon`. The cause is the guest image: the
   Debian cloud kernel `6.12.85+deb13-cloud-amd64` is built without HWMON (no
   `CONFIG_HWMON` in its config and no hwmon module), so no package can create
   the directory; the Rocky kernel has `CONFIG_HWMON=y` and prints no such
   line. The owner of `pkg_automation` declined the change as a kernel choice
   that belongs to the guest image; the request was passed to the owner of the
   guest images (`cloud-provision`) on 2026-11-02, whose owner decided the
   same day to add the generic kernel package to the first-boot templates of
   the Debian and Ubuntu families (effective after a reboot, for guests
   created from then on, not yet committed there); the guests of this release
   stay as they are.
3. `make check.module-deps` of the site clone reports four findings on
   `unidrv`, the templates `pressure.template`, `enum.template`,
   `binary.template`, and `exp.template` that `unidrv-src/mksApp/Db/mks.substitutions`
   names; they name files of a module source, so the build went on as
   `docs/src/procedures/add-site-modules.md`, step 7, says. The file is removed
   at the pin that the unidrv cycle moves to (D50), so no action is taken.

Closure: the results commit `549ac00` landed on `origin/release-1.5.0`
(observed with `git ls-remote` on 2026-11-02). Issue #111 was closed on
2026-11-02 at 17:51 UTC with its body synced to these results (the five
acceptance criteria checked with their results, the site module install added
to the proposed change) and a closing comment, and its closed state was read
back. The cycle of EPICS base is complete; the two guests stay for the later
cycles and carry the baseline tree with the site modules installed.

Test machine change after the cycle: on 2026-11-03 the Debian guest was
replaced by one made from the generic image (kernel `6.12.113+deb13-amd64`
with `CONFIG_HWMON=y` and `/sys/class/hwmon` present, 2 vCPU, 30 GiB disk),
so that the five linStat lines of finding 2 no longer apply. Its baseline was
built at `83d3afe` with the same steps (logs in `work/base-bump/debian13-generic/`:
`packages`, `suite-tools`, `checkout`; `baseline-build-debian13.log` ends
`BUILD-END rc=0` with 45 `Patching` lines, 01:42 to 02:06 UTC; `make exist`
`rc=0`; `check.deps` `RPATH / ALL: 0 / 79`; `check.env` `findings: 0`;
`modules` entries 73), and the site modules were installed from a clone made
with agent forwarding (`site-clone-debian13.log`, commit `1a31f30`; the first
attempt, `site-clone-debian13-failed.log`, stopped at the unknown host key of
the site server, which the runbook now accepts on that first clone) by
`tools/module-check/guest-site-install.bash` (`site-install-debian13.log`:
`Patching unidrv-src with the file : unidrv-supportdbd.p0.patch`,
`module-deps rc=2`, `siteApps -> ./siteApps-0.1.0`, `unidrv -> ./unidrv-0.5.1`,
`modules entries: 77`, `SITE-INSTALL-DONE 1a31f30...`; `site-deps`
`RPATH / ALL: 0 / 82`, fewer than the 95 of the old guests because no suite
has installed its second versions yet; `site-env` `findings: 0`). Two site
installs failed before it (`site-install-debian13-failed.log`,
`-failed2.log`): the site `make init` found no agent, first because
`guest-run.bash` passed no `-A`, then because the forwarded login reused a
multiplexed connection of the local ssh configuration; the hosts file now
carries `ssh_options=-A -o ControlMaster=no -o ControlPath=none`, and the
runbook sentence on agent forwarding names both. The old Debian guest is
released to its owner once the loader suite has passed on the new one; it
passed on 2026-11-03 (`work/tools-2/pvxs/consumers-debian13.log`, `records
listed: 322` without the hwmon lines), and the notice was sent that day.

The Rocky guest was replaced the same day by a 30 GiB guest of the same
image (ruling of 2026-11-02 in Lessons learned; kernel `4.18.0-553.180.1.el8_10`
after the `dnf update` and reboot of the package step, 2 vCPU, 29 GiB root).
Its baseline was built at `83d3afe` by `tools/module-check/guest-baseline.bash`
(logs in `work/base-bump/rocky8-30g/`): the first run,
`baseline-build-rocky8-failed.log`, stopped at `make conf.rocky8` because the
script passed the vendor configuration target to EPICS-env, which takes
`make conf`; after the fix the `--rebuild` path finished with `BUILD-END rc=0`,
45 `Patching` lines, 02:37 to 02:49 UTC (the vendor libraries were installed
from their built checkouts, so no vendor compile), `modules` entries 73, the
half-built tree moved aside as `epics.damaged-<stamp>` (107 MB). `make exist`
`rc=0`, `check.deps` `RPATH / ALL: 0 / 79`, `check.env` `findings: 0`. The
site modules were installed as on the Debian guest (`site-clone-rocky8.log`
commit `1a31f30`; `site-install-rocky8.log` `SITE-INSTALL-DONE`, `modules
entries: 77`; `site-deps` `0 / 82`; `site-env` `findings: 0`). The old Rocky
guest holds nothing the record needs and is released to its owner.

## Tools of the cycle

Step 6, part A, of `docs/procedures/release-procedure.md`: the three scripts of
`tools/module-check/` and the make targets are read against what Stage 6 of
`docs/procedures/module-bump-procedure.md` says they do. The baseline build,
the cycle of EPICS base (part B), uses them as they are. One difference is known before it:
`guest-update.bash` removes a module's source tree and runs the clone, the
configuration, and the build targets, but the patches of a module are applied
only by `make patch`. A module that has downstream patches at its pin is then
built from unpatched source: opcua, feed-core, QPC, StreamDevice, and measComp
have them (the mca patch applies on macOS only). The script also prints
an empty `modules/<module>` link for a module whose installed name differs,
such as sequencer, installed as `seq`.

Result of part A, observed 2026-11-01 at commit `c5de730`.

Tools. The three scripts of `tools/module-check/` were read against Stage 6 and
The checks of `docs/procedures/module-bump-procedure.md`. Every make target
that Stage 6 names exists in the make systems of both repositories (`init`,
`patch`, `patch.revert`, `reconf.modules`, `conf.<module>`,
`check.module-deps`, `build.<module>`, `symlink.<module>`,
`distclean.<module>`, `exist.modules`, `check.deps`, `check.env`, and the
`print-` queries). The differences are three:

1. `guest-update.bash` runs no patch target, so a module that has downstream
   patches at its pin is built from unpatched source (the paragraph above).
2. `guest-update.bash` prints an empty `modules/<module>` link for a module
   whose installed name differs (the paragraph above).
3. `verify_install_metadata.bash` reads the expected name, version, tag,
   macro, dependencies, and source revision of every link of `<tree>/modules`
   from the pins of this repository and counts 36 modules inspected and 36 ok
   (lines 73 and 74). The links of `siteApps` and `unidrv` have no such
   expected values, and `guest-suite.bash` has no argument that names the
   site checkout. Once the site modules are installed into the tree, the
   script prints both with problems; the count of modules inspected fails (38
   links against 36) and the count of ok lines stays 36.

Two further points need no fix. The dependents of a module are rebuilt by hand
after `guest-update.bash` (The checks, item 1 says so), and the reverse
dependencies of Stage 3 and the `make check.deps` and `make check.env` runs are
made by hand. The scripts were not run against the site checkout; a site cycle
runs the equivalent operations in that checkout (`site-modules-procedure.md`,
Cycle evidence).

Pins. The pin of each of the 39 modules in `configure/RELEASE` of the two
repositories was compared with the pin of the Modules table of this record,
both resolved with `git -C <module>-src rev-parse <pin>^{commit}`. Thirty-eight
are the same. `unidrv` differs, as its decision expects: `configure/RELEASE`
holds `0.5.1` (`86688df564`), the table holds `e5a8561` (`e5a8561100`), and
sub-step 3 of its cycle edits the pin.

Work of part C, after the cycle of the first module (EPICS base) and before the cycle of pvxs:

Plan status: complete
Plan acceptance: 2026-11-02, the maintainer
Implementation authorization: 2026-11-02, the maintainer
Review findings and rulings: two passes of 2026-11-02 by sub-agents, one that verified each claim against the scripts and the site checkout and one from the seat of the Executor, found no false claim about the scripts; they corrected the patch-target rule to the `grep` of The checks with the hyphen (the first wording excluded the one-segment targets), the path form of the commands on the machines, the document list and the done criteria of item 3, the minimal IOC lines of the suite criterion, the record of the site commit, the one suite script that reaches the two site links, the seven dependents of sequencer and the rebuild of `std`, and the statement that the unset-variable behaviour is read, not run. The maintainer ruled on 2026-11-02 that `update-opcua` runs on the Rocky Linux 8.10 machine as well, accepted the plan, and authorized the implementation the same day.

One piece of work for the three differences of part A, because they change
the same two tools and are tested on the same machines in one run.

1. In `tools/module-check/guest-update.bash`, after the clone target, run the
   patch targets of the module in the order of the `patch:` line of
   `configure/RULES_SRC`, the words that
   `grep -o -E 'patch\.<module>\.[A-Za-z0-9.-]*apply' configure/RULES_SRC`
   lists (`patch.opcua.apply` and `patch.opcua.export.apply` for opcua;
   `patch.StreamDevice.commit.apply`, `patch.StreamDevice.apply`, and
   `patch.StreamDevice.dbd-tab.apply` for StreamDevice; none for sequencer),
   so that the output keeps the
   `Patching` lines of the module and a module with no such target runs
   none. Print every link of `<tree>/modules` whose target, resolved with
   `readlink -f`, equals the install location of the module resolved the same
   way, one line `link: modules/<name> -> <target>`
   each, and `link: none` when no link matches.
2. In `examples/iocsh/tests/verify_install_metadata.bash`, read the optional
   variable `IOCSH_TEST_SITE_REPO`, the checkout of the site repository. A
   link whose name has no pin in this repository takes its expected name,
   version, tag, dependencies, and macro key from that checkout, queried with
   `cd` into it and `make -s print-...` (never `make -C`, which breaks module
   dependency resolution with make 4.2.1 on Rocky Linux 8), and its source
   revision from the `<module>-src` of that checkout. The expected number of
   modules is the number of pins of this repository other than base plus the
   number of `SRC_NAME_` keys of the site `configure/RELEASE`, and the two
   check descriptions print that number (`<N> modules inspected`,
   `<N> modules agree with the effective configuration`); with the variable
   unset the numbers stay 36 and the script behaves as before, which the
   reading of the change in item 4 confirms and no run of this work observes. In
   `tools/module-check/guest-suite.bash`, accept an optional third argument,
   the site checkout: resolve it with `readlink -f`, require a directory that
   holds `configure/RELEASE` before the log directory is removed, exit 2 with
   a message on standard error otherwise, export it as `IOCSH_TEST_SITE_REPO`,
   and name it in the usage text. `run_all.bash` and `common.bash` change
   only in the comment that lists the variables.
3. Change the sentences that describe the tools: `docs/procedures/module-bump-procedure.md`,
   The checks, item 1 (what `guest-update.bash` prints, the hand-built case
   of a module with downstream patches, the `grep` whose character class gets
   the hyphen, and the empty link line of sequencer) and item 3 (the command
   line of the suite); `docs/src/reference/tools-and-scripts.md` (the rows of
   the two scripts and the paragraphs that say the script runs no patch
   target and leaves an empty link target, and the paragraph that names the
   three variables `guest-suite.bash` sets); the `Run` section and the
   variable table of `examples/iocsh/tests/README.md`; the variable list of
   `docs/src/procedures/run-loader-verification-suite.md`, step 2; and
   `docs/procedures/site-modules-procedure.md`, Cycle evidence, where it says
   to run the EPICS-env loader suite against the shared tree. Done when
   `grep -n "no patch target\|empty target" docs/src/reference/tools-and-scripts.md`
   and `grep -n "Until the script applies patch targets" docs/procedures/module-bump-procedure.md`
   print nothing, and
   `grep -ln IOCSH_TEST_SITE_REPO docs/src/reference/tools-and-scripts.md docs/src/procedures/run-loader-verification-suite.md examples/iocsh/tests/README.md`
   lists the three files.
4. Check the changed scripts with `bash -n` and `shellcheck -x`, which print
   nothing now; then commit and push, each with the maintainer's own
   authorization. That commit is the candidate of this work, and the pushed
   Linter run is read with `gh run list --workflow linter.yml --commit <candidate>`.
5. Every command of this item is given to `tools/module-check/guest-run.bash`
   with the label named, into `work/tools-part-c/`, and a script of
   `tools/module-check/` is named with its path on the machine,
   `bash ~/sandbox/EPICS-env/tools/module-check/<script>`. On each test
   machine bring the candidate in (`git -C ~/sandbox/EPICS-env fetch origin`,
   `checkout <candidate>`, `rev-parse HEAD` prints it; label `checkout`) and
   record `git -C ~/sandbox/alsu-site-modules rev-parse HEAD`, which prints
   `1a31f3046fef9a283a14d780e380f4973483b9e9`, the site commit the installed
   site modules were built from (label `site-commit`). On the Debian 13
   machine run `guest-update.bash opcua OPCUA <candidate> ~/sandbox/EPICS-env`
   (label `update-opcua`), which must show the two `Patching opcua-src` lines
   before its build and `UPDATE-DONE`; run the same `update-opcua` on the
   Rocky Linux 8.10 machine too, whose make 4.2.1 and older grep and
   coreutils are the second environment of the changed script; and
   `guest-update.bash sequencer SNCSEQ <candidate> ~/sandbox/EPICS-env`
   (label `update-sequencer`) followed by `make distclean.<d>`,
   `make conf.<d>`, `make build.<d>` for each module `<d>` whose `_DEPS` line
   of `configure/CONFIG_MODS_DEPS` lists `build.sequencer` (label
   `rebuild-<d>`; the seven are sscan, calc, asyn, std, mca, measComp, and
   motor), which must show no `Patching sequencer-src` line, the line
   `link: modules/seq -> ./seq-2.2.9`, `UPDATE-DONE`, and `rc=0` for every
   dependent (`std` passes `realuninstall` to an `iocs` directory it does not
   build, so by The checks, item 1, it is rebuilt from a new source tree:
   remove `std-src`, `make STD`, `make conf.std`, `make build.std`). On both
   machines run
   `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/part-c ~/sandbox/alsu-site-modules`
   (label `consumers`), which must show `minimal IOC exit=0`, `iocRun lines: 1`,
   `FAIL lines: 0`, and `run_all rc=0` with `verify_install_metadata` at
   `ok=12`, and read
   `grep -a "modules inspected\|modules agree" ~/sandbox/iocsh-tests/part-c/verify_install_metadata.log`
   on the machine (label `metadata-lines`), which must show 38 and 38. This is
   the first run of the suite on a tree that holds the two site modules; the
   one other script that reaches them is `verify_dependency_graph.bash`, whose
   last section starts one IOC with every link of `<tree>/modules`. A failure
   there, or of any script, for a reason of the two site links is written as
   a new difference in this section for the maintainer's ruling, and this
   work stands or returns to its plan by that ruling. Record the results, then
   commit and push before the cycle of pvxs starts.

Results, observed on 2026-11-02, candidate `afb7b3c` (the commit of the tool
changes, pushed to `origin/release-1.5.0`), logs in `work/tools-part-c/` of the
local checkout, written by `tools/module-check/guest-run.bash`:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `bash -n` and `shellcheck -x` on the changed scripts print nothing | 2026-11-02 20:30 UTC | local host | pass | both print nothing on `guest-update.bash`, `guest-suite.bash`, `verify_install_metadata.bash`, `run_all.bash`, `common.bash` |
| The two `grep -n` commands of item 3 print nothing and the `grep -ln` lists the three files | 2026-11-02 20:35 UTC | local host | pass | nothing printed; `grep -ln IOCSH_TEST_SITE_REPO` lists `tools-and-scripts.md`, `run-loader-verification-suite.md`, `examples/iocsh/tests/README.md` |
| Linter run of the candidate | 2026-11-02 20:45 UTC | origin | pass | `gh run list --branch release-1.5.0`: Linter Run and the six OS workflows at `afb7b3c` all `completed success` |
| `update-opcua`: two `Patching opcua-src` lines before the build, `UPDATE-DONE` | 2026-11-02 20:50 to 21:07 UTC (Debian), 20:47 to 21:02 UTC (Rocky) | Debian 13, Rocky Linux 8.10 | pass | `update-opcua-<os>.log`: `Patching opcua-src with the file : opcua-CONFIG_OPCUA.p0.patch` and `opcua-anon-ns-export.p0.patch` after `make OPCUA`, `link: modules/opcua -> ./opcua-0.11.2`, `UPDATE-DONE opcua afb7b3c`, `rc=0` |
| `checkout` prints the candidate, `site-commit` prints `1a31f30...` | 2026-11-02 20:44 UTC | Debian 13, Rocky Linux 8.10 | pass | `checkout-<os>.log` `afb7b3c038fbc9d36bbe202d8553824619118c66`; `site-commit-<os>.log` `1a31f3046fef9a283a14d780e380f4973483b9e9` |
| `update-sequencer`: no `Patching sequencer-src` line, `link: modules/seq -> ./seq-2.2.9`, `UPDATE-DONE`; `rebuild-<d>` `rc=0` for the seven dependents | 2026-11-02 20:45 to 20:50 UTC | Debian 13 | pass | `update-sequencer-debian13.log`: no `Patching` line, `link: modules/seq -> ./seq-2.2.9`, `UPDATE-DONE sequencer afb7b3c`, `rc=0`; `rebuild-{sscan,calc,asyn,std,mca,measComp,motor}-debian13.log` each end `rc=0` (`std` from a new source tree) |
| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, `run_all rc=0`, `verify_install_metadata` `ok=12`; `metadata-lines` 38 inspected, 38 agree | 2026-11-02 20:55 to 21:20 UTC | Debian 13, Rocky Linux 8.10 | pass | `consumers-<os>.log`: `site checkout: <sandbox>/alsu-site-modules`, `minimal IOC exit=0`, `iocRun lines: 1`, `run_all rc=0`, `FAIL lines: 0`, all 14 scripts `fail=0` (`verify_dependency_graph` 18 with the 38 links in one IOC), `records listed` 327 (Debian) and 322 (Rocky); `metadata-lines-<os>.log`: `pins read: 39, modules expected: 38`, `OK 38 modules inspected`, `OK 38 modules agree with the effective configuration` |

The suite passed on a tree that holds the two site modules, so no new
difference was written. The three differences of part A are fixed at
`afb7b3c`; the cycles of part D run the tools from that commit on.

A fourth difference, found in the cycle of pvxs (its record above): the loader
suite leaves about 2.7 GB of copies of the installed tree under
`<log_dir>/copies` on every run (four scripts copy the tree with
`iocsh_test_copy_tree` and none removes its copy), `guest-suite.bash` does not
check the free disk before it runs, and a run interrupted by a full disk leaves
the tree damaged although the scripts carry restore traps, because the restore
itself needs disk. The rules of 2026-11-03 in Test machines and The checks
cover it by hand; the work below makes the tools do it.

Work after the cycle of pvxs and before the cycle of MCoreUtils, one piece for
the tools of every later cycle. Item 1 fixes the fourth difference; items 2 to
4 make the tools do what the cycles of EPICS base and pvxs did by hand, which
Part C of step 6 does not name, so they stand on a dated ruling of the
maintainer recorded with the acceptance.

Plan status: complete
Plan acceptance: 2026-11-03, the maintainer
Implementation authorization: 2026-11-03, the maintainer
Review findings and rulings: two passes of 2026-11-03 by sub-agents, one that verified each claim against the suite scripts, the logs of the pvxs cycle, and the scratch generators, and one from the seat of the Executor who implements and tests the tools, found the fourth difference true and the item short of what the Executor needs; the item now names one candidate for the pvxs run and a log directory of its own, bounds the pin-commit search to the commits after the branch point of this release, takes the old-version row out of the exit status, defines `pass` as every log `rc=0`, gives the suite its limit variable and its free-space lines, reads the library stems on the machine and the inventory file for the generator, states what `--rebuild` replaces, and checks the two moved scripts against the recorded sequences instead of a byte diff. Ruling of the maintainer, 2026-11-03: Part C of step 6 extends to this work, so that the tools of the cycles do what the cycles of EPICS base and pvxs did by hand (items 2 to 4), beside the fourth difference (item 1); the maintainer accepted the plan and authorized the implementation the same day.

1. In `examples/iocsh/tests/run_all.bash`, remove `${IOCSH_TEST_OUT}/copies`
   when the run ends, whatever the results. In `tools/module-check/guest-suite.bash`,
   after the log directory is validated and before it is removed, read the free
   space of the nearest existing parent of `<log_dir>` with `df -P` (1024-byte
   blocks), refuse to start with status 2 and a message when it is below
   `GUEST_SUITE_MIN_FREE_KB` (default 6291456, 6 GB), and print the free space
   as `free before:` and, at the end, `free after:`. `docs/src/reference/tools-and-scripts.md`
   names the variable in the row of the script. Done when a suite run on a
   guest leaves no `copies` directory and `free after` is within the size of
   the logs of `free before` on a tree that already holds the second versions
   the suite installs.
2. Add `tools/module-check/cycle.bash <module> <KEY> <candidate> [site_checkout] [log_dir]`,
   run from the local checkout (it reads `work/guest-hosts.env` in line order),
   which runs sub-step 5 of a module cycle through `guest-run.bash` into
   `<log_dir>`, by default `work/<module>-bump/`, in this order, and stops at
   the first log that does not end with `rc=0`: `checkout` on every machine;
   `build` (`guest-update.bash`) on every machine; `rebuild-<d>` on every
   machine for each module `<d>` whose `_DEPS` line of
   `configure/CONFIG_MODS_DEPS` lists `build.<module>`, as one command joined
   by `&&`, or, when `grep realuninstall <d>-src/Makefile` matches and
   `BUILD_IOCS` is not `YES` in `<d>-src/Makefile` or
   `<d>-src/configure/CONFIG_SITE*`, from a new source tree (`<d>-src` moved
   aside, `make <D_KEY>`, the apply targets of `<d>`, `make conf.<d>`,
   `make build.<d>`); `patch-round-trip` on the first machine of the hosts
   file; `consumers` with the site checkout and `metadata-lines` on every
   machine; `installed-tree-deps` and `installed-tree-env` on every machine;
   `reverse-deps` on every machine, a command that reads the `lib=` stems of
   `<tree>/modules/<module>/cfg/iocsh.conf` on the machine, searches once per
   stem and once by the module name, and prints them under `== stem <stem>`
   and `== dep=<module>` headings; the search output and the list of the
   build-order dependents also go to `<log_dir>/reverse-deps.md`, whose
   judged part the Executor writes. When the pin moved in this release, that
   is, when `git log -S'<pin>' $(git merge-base release-1.5.0 master)..HEAD -- configure/RELEASE`
   names a commit, the files of that commit are searched for the version its
   parent held (`git show <commit>^:configure/RELEASE`, the `SRC_VER_<KEY>`
   line) and the hits are printed; this row is not part of the exit status,
   because a documentation line may keep the old version by the maintainer's
   reading. It prints one line per Results row, `pass` when every log of the
   row ends with `rc=0`, `fail` otherwise, with the evidence lines the row
   names so that the reader compares them, and exits 0 only when every row
   with a status passes. Done when the run on pvxs at the candidate of this
   work (item 7) gives the evidence lines of the pvxs record.
3. Move the scripts of the first cycles into the tools:
   `tools/module-check/guest-baseline.bash [--rebuild] [conf_target]`, the
   steps 1 to 11 of the build and install page with `BUILD-END rc=<n>` last,
   where `--rebuild` moves the existing tree aside, replaces steps 1 to 4 by
   `make -C ../uldaq-env build install` and the same for `open62541-env`, and
   runs `make patch.revert` before `make init`, as `work/pvxs-bump/rebuild-tree.bash`
   did; and `tools/module-check/guest-site-install.bash <site_checkout>`, the
   sequence of `docs/src/procedures/add-site-modules.md` (`make init`, `patch`,
   `conf`, `check.module-deps` with its status captured as `module-deps rc=<n>`,
   `build`, `install`, `symlinks`, then `LC_ALL=C make exist.modules LEVEL=1`
   filtered to the site modules), as the record of the cycle of EPICS base
   ran it. Done when `bash -n` and `shellcheck -x` print nothing and the make
   sequence of each script, read from its body, is the sequence of
   `work/base-bump/baseline-build.bash`, `work/pvxs-bump/rebuild-tree.bash`,
   and `work/base-bump/site-install-debian13.log`.
4. Add `tools/module-check/plan-facts.py <module> --libs <inventory>`, which
   prints the plan block of a module as this record drafts it (from the
   `Issue:` line to the last Results row): the pin and version from
   `configure/RELEASE`; whether the pin moved in this release and by which
   commit, by the rule of item 2; the outcome text from the Modules table of
   this record; the apply targets of the `patch:` line of `configure/RULES_SRC`
   and the patch files at the pin; the dependents from `configure/CONFIG_MODS_DEPS`
   and the ones whose `distclean` is unsafe, read from the sources; the library
   stems from `<inventory>`, a file of `<module>: <stem> ...` lines read from the
   installed tree of a machine with `guest-run.bash` (the `libs-inventory` label
   of the first cycle). The template is the block of this record as it stands,
   with its later edits (the one-command rebuild, `reverse-deps.md` and the
   pass rule, `metadata-lines`), not the scratch generator. Done when its
   output for autosave equals the drafted plan of autosave in this record
   apart from the issue line.
5. Change the sentences the tools change: `docs/procedures/release-procedure.md`,
   Test machines (the `copies` removal becomes the suite's own, the `df` check
   the script's own with its variable); `docs/procedures/module-bump-procedure.md`,
   The checks (the sentence "require at least 6 GB free" of item 3, and the
   cycle runner as the way to run the checks, with the labels it writes);
   `docs/src/reference/tools-and-scripts.md` (rows for the four new scripts and
   the changed row of `guest-suite.bash`); `examples/iocsh/tests/README.md` (the
   copies and their removal).
6. Check the scripts with `bash -n`, `shellcheck -x`, and `python3 -I -m py_compile`,
   then commit and push, each with the maintainer's own authorization; that
   commit is the candidate of this work, and its Linter run is read with
   `gh run list --workflow linter.yml --commit <candidate>`.
7. From the local checkout run
   `cycle.bash pvxs PVXS <candidate> ~/sandbox/alsu-site-modules work/tools-2/pvxs`,
   which brings the candidate into both machines itself (label `checkout`),
   must end with every row with a status `pass` and the evidence lines of the
   pvxs record, and leaves the logs of the pvxs cycle in `work/pvxs-bump/`
   untouched; then read on both machines `ls ~/sandbox/iocsh-tests/pvxs`
   (label `copies-after`, no `copies` entry) and the `free before:` and
   `free after:` lines of the `consumers` log. Test the refusal once on one
   machine with `GUEST_SUITE_MIN_FREE_KB` above the free space (label
   `suite-refusal`, status 2 and the message). Run `plan-facts.py autosave`
   on the local host and compare with the record. Record the results, then
   commit and push before the cycle of MCoreUtils starts.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `bash -n`, `shellcheck -x`, and `perl -c` on the changed and new scripts print nothing | 2026-11-03 02:00 UTC | local host | pass | nothing printed on `cycle.bash`, `guest-baseline.bash`, `guest-site-install.bash`, `guest-suite.bash`, `run_all.bash`; `perl -c plan-facts.pl` prints `syntax OK` (the generator is Perl, `plan-facts.pl`, by the maintainer's instruction of 2026-11-03 to write the tools in Bash and Perl) |
| `guest-baseline.bash` and `guest-site-install.bash` build the baseline and install the site modules on a fresh guest | 2026-11-03 02:08 to 02:51 UTC | Debian 13 (site install), Rocky Linux 8.10 (both) | pass after one fix | the first run on Rocky, `work/base-bump/rocky8-30g/baseline-build-rocky8-failed.log`, stopped at `make conf.rocky8`: the script passed the vendor configuration target to EPICS-env, which takes `make conf`; fixed, the `--rebuild` run ends `BUILD-END rc=0` with 45 `Patching` lines and 73 `modules` entries; `site-install-<os>.log` on both guests ends `SITE-INSTALL-DONE 1a31f30...` with `modules entries: 77` |
| `plan-facts.pl autosave --libs <inventory>` equals the drafted plan of autosave apart from the issue line | 2026-11-03 01:58 UTC | local host | pass | `diff` of the output against the autosave block of this record prints nothing, issue line included; the same holds for the other 34 drafted blocks (`epics-base` and `pvxs` have no drafted block), after one fix found by that comparison: a module added in this release (the four areaDetector modules) is not a moved pin |
| Linter run of the candidate | 2026-11-03 03:20 UTC | origin | pass | `gh run list --branch release-1.5.0`: Linter Run and the six OS workflows at `bdbd81f`, the tip pushed together with the tool commit `de81b30` (the commit between them changes only this record and the runbook), all `completed success`; GitHub runs the workflows at the pushed tip, so there is no run at `de81b30` itself |
| `cycle.bash pvxs PVXS <candidate>` into `work/tools-2/pvxs`: every row with a status `pass`, the evidence lines of the pvxs record | 2026-11-03 02:55 to 03:15 UTC | Debian 13, Rocky Linux 8.10 (the two replacement guests) | pass | `cycle.bash pvxs PVXS de81b30 ~/sandbox/alsu-site-modules work/tools-2/pvxs` prints `build: pass` (`Patching pvxs-src lines: 2`, `link: modules/pvxs -> ./pvxs-1.5.3`, both SONAME lines, `UPDATE-DONE pvxs de81b30`), `rebuild-ADCore: pass` (`rebuild form: distclean`), `patch-round-trip: pass` (`init rc=0`, `patch rc=0`, `Patching lines: 45`, `Patching pvxs-src lines: 2`, `revert rc=0`, `status lines in all trees: 0`), `consumers: pass` (`minimal IOC exit=0`, `iocRun lines: 1`, `run_all rc=0`, `FAIL lines: 0`, `records listed: 322` on both guests, the hwmon lines gone with the generic kernel, `OK 38 modules inspected`, `OK 38 modules agree`), `installed-tree: pass` (`RPATH / ALL: 0 / 95`, `findings: 0`, `reverse-deps names: ADCore`, `outside the dependents: none`), the old-version note with the one `patch/README.md` line, `CYCLE-DONE pvxs de81b30`, exit 0; `work/tools-2/pvxs/reverse-deps.md` written; `work/pvxs-bump/` untouched |
| `copies-after` lists no `copies`; `free after:` within the logs of `free before:`; `suite-refusal` exits 2 with the message | 2026-11-03 03:16 UTC | Debian 13, Rocky Linux 8.10 | pass | `copies-after-<os>.log`: `no-copies-entry` on both; `consumers-<os>.log`: `free before: 18739040 KB`, `free after: 18461700 KB` (Debian), `19799840 KB` to `19460920 KB` (Rocky), the difference the logs and the two second versions the suite installs; `suite-refusal-debian13.log`: `free space 18461700 KB on <sandbox>/iocsh-tests is below GUEST_SUITE_MIN_FREE_KB=999999999999 KB`, `rc=2` |

Closure: the tools of this work are at `de81b30` on `origin/release-1.5.0`,
with the two guest scripts corrected after their first real runs on the
replacement guests (the `make conf` fix of `guest-baseline.bash` is in that
commit). The checks of the fourth difference and of the cycle runner passed on
the two replacement guests, so the cycles of part D run `cycle.bash` from that
commit on, starting with MCoreUtils; the generator `plan-facts.pl` reproduces
every drafted plan block of this record. Two review loops of 2026-11-03 by
the author, a third-person pass by execution and a second-person pass from
the seat of the maintainer of the next cycle, converged with every finding
applied before the commit.

Suite scope of a module cycle (ruling of the maintainer, 2026-11-03, after
the cycle of MCoreUtils): of the 17 scripts of the loader suite, 11 check the
loader itself and not a module, so a module cycle runs the three module
scripts, `verify_install_metadata`, `verify_dependency_graph`, and
`verify_minimal_example`, plus the fixture that loads the module
(`verify_fixture_tc32sim` for autosave, caPutLog, linStat, retools, and
StreamDevice; `verify_fixture_ioc_demo` for StreamDevice;
`verify_fixture_opcua` for opcua), and the full suite runs once per release
in release readiness (step 7) on the final tree. The rules that the full
suite brings (6 GB of disk, the two second versions, the recovery after a
failed suite, the `docker` count) moved from The checks, item 3, to step 7;
`guest-suite.bash` takes the script list as its fourth argument,
`cycle.bash` passes the module scripts, and the plan template and the 34
drafted plans name them. Evidence: `work/tools-3/suite-module-scripts-debian13.log`,
the four scripts of autosave on the Debian 13 machine, `scripts:` line,
`verify_install_metadata` `ok=12`, `verify_dependency_graph` `ok=18`,
`verify_fixture_tc32sim` `ok=24`, `run_all rc=0`, `FAIL lines: 0`,
`records listed: 322`, 09:05 to 09:12 UTC; the cycle of MCoreUtils, run
before the ruling with the full suite, keeps its record.

## Release readiness

The work of step 7 of `docs/procedures/release-procedure.md`, on the tip of
`release-1.5.0` after the last module cycle, pushed to origin.

This includes the site modules at their recorded site repository candidate.
Both repository commits are inputs to the final installed tree and to the
candidate comparison; EPICS-env CI alone does not verify the site modules.

| Item | Evidence |
| --- | --- |
| Integration tests: the six OS workflows and the Linter, the patch apply-and-revert test on a fresh checkout, the loader suite, and the common iocsh fragments | pending |
| Version check: `ENV_RELEASE_VERS` is 1.5.0 in `configure/CONFIG_SITE` (since `8a603bb`), and `make -s print-ENV_RELEASE_VERS` prints it | pending |
| `ChangeLog.md` entry `### 1.5.0 <date> <name> <email>` | pending |
| README and book paths that name the previous release | pending |
| Production environment tests on the Debian 13 and Rocky Linux 8.10 test machines: `make exist`, `make check.deps`, `make check.env`, and `softIocPVX` started with `exit` on its standard input | pending |
| The commit that carries this evidence is the release candidate | pending |
| Site modules installed on both test machines, their patch and IOC checks, and whole-tree checks with both repository commits recorded | pending |

## Release plan

Plan status: draft
Plan acceptance: none
Day planned for the merge and tag: not set; the maintainer sets it at the acceptance, and the `ChangeLog.md` entry of release readiness carries it

One row for each action of step 8 of `docs/procedures/release-procedure.md`
with the commits and pushes around them, and for the branch deletion of
step 9. Every row has its own authorization from the
maintainer and is followed by a commit that records its result: on the release
branch before the merge, on master after it. The result commit of a row is
`git -C <checkout> commit -F work/commit-msg-release-result-<step>.txt -- docs/milestone-1.5.0.md`.
`<step>` is the number of the row, and `<checkout>` is the path of the
EPICS-env checkout. `<candidate>`, `<evidence_files>`, `<merge>`, and `<hash>`
exist only when their row runs; each is filled in when the row is shown for its
authorization. `<candidate>` is the commit that row 1 prints, `<merge>` is the
commit that row 5 prints, `<evidence_files>` are the files that step 7 of the
procedure changes (`docs/milestone-1.5.0.md`, `ChangeLog.md`, and each README
or book file that names the release), and `<hash>` is the short hash that row 13
prints. The message files
are in `<checkout>/work/`, which `mkdir -p` creates in a new checkout; each
holds a subject line, an empty line, and a body of at most ten lines. The notes
of row 9 are the `ChangeLog.md` entry of 1.5.0 in the form of the notes of
release 1.4.0, which `gh release view 1.4.0 --repo jeonghanlee/EPICS-env --json body --jq .body`
prints. The body of row 11 is the current body of #100, which
`gh issue view 100 --repo jeonghanlee/EPICS-env --json body --jq .body`
prints, with the results of the rows added, and its closing comment names the tag, the merge commit, and the
GitHub release. The three files are written and shown to the maintainer before
their rows. The evidence of the handover and of the final push cannot be committed
before they happen, so it stays `pending` in the record that is handed over.
Before the release, the read-backs of rows 9, 11, and 12 show the earlier
state: no release 1.5.0, the issue open, and the milestone with its open
issues.

| Step | Action | Command | Expected result | Evidence |
| --- | --- | --- | --- | --- |
| 1 | Commit of the release readiness evidence on `release-1.5.0`, the release candidate | `git -C <checkout> add <evidence_files>` ; `git -C <checkout> commit -F work/commit-msg-release-readiness.txt -- <evidence_files>` ; `git -C <checkout> rev-parse HEAD` | The full candidate SHA is recorded | pending |
| 2 | Push `release-1.5.0` | `git -C <checkout> push origin release-1.5.0` ; `git -C <checkout> ls-remote origin refs/heads/release-1.5.0` | The remote tip equals the reviewed local tip and contains the candidate | pending |
| 3 | Bring local `master` up to date with `origin/master` by fast-forward, without leaving the release branch (a checkout without a local `master` gets one) | `git -C <checkout> fetch origin master:master` ; `git -C <checkout> rev-list --count release-1.5.0..master` | `git rev-list --count release-1.5.0..master` prints 0 | pending |
| 4 | Push `release-1.5.0` with the result commits of rows 1 to 3 | `git -C <checkout> push origin release-1.5.0` ; `git -C <checkout> ls-remote origin refs/heads/release-1.5.0` | The remote tip equals the local tip that row 5 merges; this result is recorded on `master` after the merge | pending |
| 5 | Merge, with `--no-ff`, the tip of `release-1.5.0` after the last result commit before the merge into `master`, subject `Merge release-1.5.0: EPICS Environment 1.5.0` | `git -C <checkout> switch master` ; `git -C <checkout> merge --no-ff release-1.5.0 -m "Merge release-1.5.0: EPICS Environment 1.5.0"` ; `git -C <checkout> rev-parse HEAD` ; `git -C <checkout> diff --stat <candidate> release-1.5.0` | The merge SHA is observed, and the comparison of that tip with the candidate is recorded under the candidate rule (`docs/procedures/release-procedure.md`, step 7) | pending |
| 6 | Annotated tag `1.5.0` on the merge commit `<merge>`, message `EPICS Environment 1.5.0` | `git -C <checkout> tag -a 1.5.0 -m "EPICS Environment 1.5.0" <merge>` ; `git -C <checkout> rev-parse 1.5.0 1.5.0^{commit}` | The tag object and its peeled commit are observed | pending |
| 7 | Push `master` | `git -C <checkout> push origin master` ; `git -C <checkout> ls-remote origin refs/heads/master` | The remote tip equals the reviewed local tip and contains the merge | pending |
| 8 | Push `refs/tags/1.5.0` | `git -C <checkout> push origin refs/tags/1.5.0` ; `git -C <checkout> ls-remote origin refs/tags/1.5.0 refs/tags/1.5.0^{}` | The remote tag object and its peeled commit match | pending |
| 9 | GitHub release `1.5.0` with notes written from the `ChangeLog.md` entry of 1.5.0 in the form of the notes of release 1.4.0, shown to the maintainer before the row | `gh release create 1.5.0 --repo jeonghanlee/EPICS-env --verify-tag --title 1.5.0 --notes-file work/release-notes-1.5.0.md` ; `gh release view 1.5.0 --repo jeonghanlee/EPICS-env --json name,tagName,isDraft,isPrerelease,publishedAt,url` ; `gh api repos/jeonghanlee/EPICS-env/releases/latest --jq '"\(.id) \(.tag_name)"'` | Published, not a prerelease, latest; id, URL, and time recorded | pending |
| 10 | Delete `release-1.3.0` locally and on origin (D22); a checkout without the local branch creates it first with `git branch release-1.3.0 origin/release-1.3.0` | `git -C <checkout> branch -d release-1.3.0` ; `git -C <checkout> push origin --delete release-1.3.0` ; `git -C <checkout> ls-remote --heads origin release-1.3.0` | The deletion or the observed absence is recorded | pending |
| 11 | Close #100 after the release objects exist, with its body synced and a closing comment | `gh issue edit 100 --repo jeonghanlee/EPICS-env --body-file work/issue-100-body.md` ; `gh issue comment 100 --repo jeonghanlee/EPICS-env --body-file work/issue-100-closing.md` ; `gh issue close 100 --repo jeonghanlee/EPICS-env` ; `gh issue view 100 --repo jeonghanlee/EPICS-env --json state --jq .state` | The closed state is read back | pending |
| 12 | Close GitHub milestone 1.5.0 (number 7) | `gh api -X PATCH repos/jeonghanlee/EPICS-env/milestones/7 -f state=closed` ; `gh api repos/jeonghanlee/EPICS-env/milestones/7 --jq '"state=\(.state) open=\(.open_issues) closed=\(.closed_issues)"'` ; `gh issue list --repo jeonghanlee/EPICS-env --milestone 1.5.0 --state all --json number,state --limit 100` | Closed with zero open items; every linked issue is read back in its final state | pending |
| 13 | Hand this record to master: rename it to `docs/milestone-<hash>.md` in a commit on master, keep only the work that survives the release (the Deferred work, and each module or work row that is not complete, with the decisions those rows cite), and add the History row by hand before the commit (`<hash>` is the short hash of the result commit of row 12, which carries the closed record, and the row is as in `docs/procedures/release-procedure.md`, step 8) | `git -C <checkout> rev-parse --short HEAD` ; `git -C <checkout> mv docs/milestone-1.5.0.md docs/milestone-<hash>.md` ; `git -C <checkout> commit -F work/commit-msg-rename.txt -- docs/milestone-1.5.0.md docs/milestone-<hash>.md` | The new path exists, and its History row holds the full hash of the commit that carries the closed record | pending |
| 14 | Final push of `master` | `git -C <checkout> push origin master` ; `git -C <checkout> ls-remote origin refs/heads/master` | The remote tip equals the handover commit and contains the result commits | pending |

## Deferred work

Work left out of this release, found during it or carried over from the record
that master held (`docs/milestone-84ee626.md` at commit `4d521e7`). A line
becomes work again by a new dated decision.

| Item | Why it is deferred | Reference |
| --- | --- | --- |
| Remove the `makeRPath` Python dependency through additive `EPICS::Path` primitives (`Normalize`, `RelPath`) and a Perl `makeRPath`, pursued as an upstream epics-base submission | A local base patch removes no prerequisite, because the build already runs `makeRPath.py` under `python3` and needs `python3` to read its configuration; the value is the Base path toolkit | #25 |
| Promote the commonIocsh fragments to a dedicated public module repository, pinned like every other module | The fragments are developed in this repository until the promotion | none |
| Ship a global iocsh startup file for the common services | The fragment set ships without one; the common services are verified loading together by the integrated suite | none |
| Verify the Libera cross-build and the generated profile | Needs the real nine-module cross-build; the Libera reference is `docs/libera-cross-build.md` | none |
| Verify the patch revert on actual macOS | Linux results do not verify macOS execution; the Darwin mca path stays in the code | none |
| Read the original `opcua-IOC-demo` startup data path | The 69 nodes of its databases come from the Unified Automation example server, which needs a registered download; a server written to imitate those nodes would be a stand-in | none |
| Report the two EPICS base site patches (`7.0.10-site01-dbyacc-eof`, `7.0.10-site02-dbstatic-device-menu`) upstream | Not yet reported; each is one upstream issue or pull request | none |
| Make Eclipse Milo the default server of the OPC UA loader example | Example and documentation work, not a module-set change | #99 |
| Migrate IOC record publishing from the recsync client to the reccaster repository | Module source work outside a version bump (D17) | #101 |
| Count only records in the loader suite's minimal example | A guest without `/sys/class/hwmon` adds linStat error lines to the count | none |
| Stop `dbLoadRecords` from crashing an IOC that loads lua when called without its macros argument | The defect sits in lua's database hook at the pin that 1.4.0 shipped and at `01aa7a1` alike; reporting it upstream or carrying a patch is decided when the work is assigned | none |
| Decide how the installed shared libraries identify their version | The modules set no versioned `SONAME` (47 of the 54 distinct values in the Debian 13 tree are bare); the work decides the RUNPATH naming rule, the `SONAME` and ABI name rule, and how `check.deps` and `check.env` report a link | none |
| Load pyDevSup into a plain IOC through the loader | An exploratory run loaded its library and database definition into the plain `softIoc` and processed a record; relocation, the library name that carries the Python version, and the loader rules are not examined | none |

## Lessons learned

A rule a cycle teaches goes into the procedure that owns it; a lesson no
procedure holds is added here, one line with its evidence.

- Request 30 GiB of disk for a test guest, not 20 (ruling of the maintainer,
  2026-11-02). The loader suite leaves about 2.7 GB of copies of the installed
  tree under `<log_dir>/copies` on every run, so after the baseline, the tool
  work, and the first module cycle both 20 GiB guests were full and the pvxs
  suite failed on `No space left on device` (`work/pvxs-bump/consumers-<os>.log`,
  `installed-tree-env-rocky8.log`). The disk figure of Test machines is set to
  30 GiB in the lessons step of the pvxs cycle, and the copies the suite leaves
  are the subject of a tool work item before the next cycle.

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-10-10 | `4d521e7a0f05163d39541c0357e966397433b027` (`docs/milestone-84ee626.md` on master, the record this one started from) |
| 2026-10-18 | `f2efff0fa57c4d9154576ca3315e21e9bd7a3c1c` (`docs/milestone-1.5.0.md`) |
| 2026-10-25 | `48c60d48825594065cc0cd36b24ca68562a8a586` (`docs/milestone-1.5.0.md`, the form with the work table and the module details) |
