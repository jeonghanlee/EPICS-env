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
all 39, settles the open updates, and checks the pin-retention reasons for
ADSimDetector and ADVimba. Step 5 records the combined
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
| D34 | feed-core: retain `0472d88` and the existing `feed-core-libonly` patch, with no additional carry. The remote default branch remains at the pinned commit and exposes no tags. Module build and IOC acceptance remain pending. | 2026-10-30 |
| D35 | asyn: retain `tags/R4-46` with no additional carry. The remote default branch and latest release tag remain at the pinned commit. Module build and IOC acceptance remain pending. | 2026-10-30 |
| D36 | QPC: retain `913fad4` and the existing `QPC-dataonly` patch, with no additional carry. The remote default branch `alsu` remains at the pinned commit and exposes no tags. Module build and IOC acceptance remain pending. | 2026-10-30 |
| D37 | modbus: retain `tags/R3-4` and carry one curated patch of upstream `4e39e7a`: the Windows min/max guard, the removal of the uninitialized-offset debug loop in `readFloat64Array`, and the explicit `epicsUInt16` cast. The two `size_t`-to-`int` bound changes of that commit are omitted because at five of the six tested capacities above 2147483647 they request a wrong register count or report a wrong element count. The other eight scored commits are not carried; all miss the rule. The [carry decision record](modbus-carry-1.5.0.md) preserves the scores, the dependency findings and the completion reviews. The carry file is prepared; targeted real-driver checks, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-30 |
| D38 | StreamDevice: retain `tags/2.8.26` and carry upstream `562dd5ad` (scalcout string value truncation) as one patch; the existing `StreamDevice-no-vxi11` and `StreamDevice-dbd-tab` patches remain. The other twelve scored commits are not carried; all miss the rule, and two of them (`e87e093c`, `f473f4d6`) replace or repeat the local patches. The [carry decision record](streamdevice-carry-1.5.0.md) preserves the scores, the dependency findings and the completion reviews. The carry file is prepared; targeted real-IOC checks, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-30 |
| D39 | sscan: retain the accepted move to `ce9660c` (D7) and carry upstream `b28ac30d` (the temporary path buffer of the saveData permission check) as one patch. The later `f5f4c90d` (`NINT` instead of `round`, which matters in practice only for vxWorks) is not carried. The [carry decision record](sscan-carry-1.5.0.md) preserves the scores and findings. The carry file is prepared; targeted function-level checks, builds and aggregate apply/revert pass. Full build and IOC acceptance remain pending. | 2026-10-30 |

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
| pmac | `2-7-9` | `2-7-10` at `3473014`, 18 commits above the pin, observed 2026-10-29 | The tag matches `dls-master` HEAD. Assess compatibility with motor and decide inclusion at step 4; D12 remains the current motor decision and no pin change is authorized. |
| pyDevSup | `tags/2.1.0` (D14) | `master` at `a38e7b5`, 14 commits above the pin and 10 after D14's excluded head, observed 2026-10-29 | Latest tag remains `2.1.0`. Review the additional changes at step 4 under the downstream-carry procedure; D14 stands and no further pin change is authorized. |
| ADCore | `ee039d2` | `master` at `36840e1`, 10 commits above the pin, observed 2026-10-29 | Commit subjects describe a circular buffer plugin busy-record fix and its unit test, a Windows header include fix, an expanded error message, and CI updates. Compatibility and inclusion remain open for step 4. |
| ADGenICam | `ba5b9b8` | `master` at `df3d7cd`, 3 commits above the pin, observed 2026-10-29 | Commit subjects describe support for The Imaging Source DMK 33GX174 camera and restoration of `GC_prefix` for upstream. Compatibility and inclusion remain open for step 4. |
| lua | `01aa7a1` (D9) | `master` at `f682826`, 6 commits above the pin, observed 2026-10-29 | Commit subjects describe 64-bit integer and mbbiDirect support, lsi and lso support, array support, example and release note updates, and a test fix. Compatibility and inclusion remain open for step 4; D9 stands. |
| ADSimDetector | `0ef1305` | No later commits; `master` matches the pin, observed 2026-10-29 | Latest tag `R2-11` precedes the pin. Confirm pin retention and its reason at step 4 under D25. |
| ADVimba | `tags/R1-5` | `master` at `ddeb021`, 9 commits above the pin, observed 2026-10-29 | Latest tag remains `R1-5`. Review the branch changes under the downstream-carry procedure and confirm pin retention and its reason at step 4 under D25. |
| siteApps | `0.1.0` | Latest tag and `master` match the pin; no later commits, observed 2026-10-29 | Confirm consumers, pin retention, and outcome at step 4 with the combined inventory. |
| unidrv | `0.5.1` | `main` at `e5a8561`, 4 commits above the pin (2 merges), observed 2026-10-29 | Latest tag remains `0.5.1`; these are branch commits, not a newer release tag. Review consumers, compatibility, and whether to include the changes at step 4; no pin change is authorized. |

## Modules

Rows 1 to 37 are owned by EPICS-env; rows 38 and 39 are owned by the site
module repository. The numbers identify inventory rows, not the final combined
cycle order. D3 records the order of the 37 EPICS-env modules; D25 requires step
5 to determine the site modules' positions from verified dependencies. Their
placement at the end of this table does not schedule them last.

The issue of a module is opened at its plan step (D20) with the label
`enhancement`, as #100 and the issues of the earlier run carry it, and its
section below is added at that step.

| No. | Module | Pin | Outcome | Issue | State |
| --- | --- | --- | --- | --- | --- |
| 1 | epics-base | `tags/R7.0.10` | HOLD (D26) | #111 | plan drafted |
| 2 | pvxs | `tags/1.5.2` -> `tags/1.5.3` | IN (D5), two carry patches selected (D27) | at the plan step | not started |
| 3 | MCoreUtils | `a86e5ed` | unchanged | at the plan step | not started |
| 4 | autosave | `tags/R6-0` | pin unchanged, two carry patches selected (D28) | at the plan step | not started |
| 5 | ether_ip | `tags/ether_ip-3-10` | pin unchanged, no additional carry patch (D29) | at the plan step | not started |
| 6 | iocStats | `tags/4.0.1` | pin unchanged, no additional carry patch (D30) | at the plan step | not started |
| 7 | recsync | `9834b94` | HOLD (D17) | at the plan step | not started |
| 8 | retools | `5ada1e1` | unchanged | at the plan step | not started |
| 9 | sequencer | `tags/R2-2-9` | pin unchanged, no additional carry patch (D31) | at the plan step | not started |
| 10 | snmp | `tags/v1.1.0.4ja` | unchanged | at the plan step | not started |
| 11 | opcua | `tags/v0.11.2` | pin and two existing patches unchanged, no additional carry (D32) | at the plan step | not started |
| 12 | pcas | `e075fd4` | HOLD (D16) | at the plan step | not started |
| 13 | pscdrv | `276daca` | unchanged | at the plan step | not started |
| 14 | linStat | `tags/1.2.1` | five carries plus RTC site correction prepared (D33), full-cycle verification pending | at the plan step | not started |
| 15 | feed-core | `0472d88` | pin and existing lib-only patch unchanged (D34) | at the plan step | not started |
| 16 | sscan | `e13699e` -> `ce9660c` | IN (D7), one carry prepared (D39), full-cycle verification pending | at the plan step | not started |
| 17 | calc | `4217e83` -> `tags/R3-8` | IN (D6) | at the plan step | not started |
| 18 | asyn | `tags/R4-46` | pin unchanged, no additional carry (D35) | at the plan step | not started |
| 19 | QPC | `913fad4` | pin and existing data-only patch unchanged (D36) | at the plan step | not started |
| 20 | modbus | `tags/R3-4` | pin unchanged, one curated carry prepared (D37), full-cycle verification pending | at the plan step | not started |
| 21 | lua | `17475b5` -> `01aa7a1` | IN (D9), newer upstream open | at the plan step | not started |
| 22 | std | `5f2e442` -> `27b6967` | IN (D8) | at the plan step | not started |
| 23 | StreamDevice | `tags/2.8.26` | pin and two local patches unchanged, one carry prepared (D38), full-cycle verification pending | at the plan step | not started |
| 24 | rgamv2 | `27fc633` | unchanged | at the plan step | not started |
| 25 | busy | `2dfe92d` -> `a4a272d` | IN (D10) | at the plan step | not started |
| 26 | scaler | `beb5521` -> `baa8e1c` | IN (D11) | at the plan step | not started |
| 27 | mca | `687d563` | unchanged | at the plan step | not started |
| 28 | measComp | `c38974e` | HOLD (D15) | at the plan step | not started |
| 29 | motor | `285f44d` -> `4b22ac9` | IN (D12) | at the plan step | not started |
| 30 | motorMotorSim | `tags/R1-3` | unchanged | at the plan step | not started |
| 31 | pmac | `2-7-9` | open | at the plan step | not started |
| 32 | ADCore | `ee039d2` | open | at the plan step | not started |
| 33 | ADSimDetector | `0ef1305` | unchanged | at the plan step | not started |
| 34 | ADGenICam | `ba5b9b8` | open | at the plan step | not started |
| 35 | ADVimba | `tags/R1-5` | unchanged, later branch changes open | at the plan step | not started |
| 36 | caPutLog | `dafb0b2` -> `tags/R4.2` | IN (D13) | at the plan step | not started |
| 37 | pyDevSup | `4527ed0` -> `tags/2.1.0` | IN (D14), later branch changes open | at the plan step | not started |
| 38 | siteApps | `0.1.0` | open | at the plan step | not started |
| 39 | unidrv | `0.5.1` | open | at the plan step | not started |

The pin of a changed module in `configure/RELEASE` is already the new one. An
unchanged or HOLD module runs the whole cycle at its pin, and its section
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


### feed-core upstream observation

D34 retains `0472d88` and `patch/feed-core-libonly.p0.patch`, with no
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

This records source changes only; compatibility and adoption remain at step 4.


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


### asyn upstream observation

D35 retains `tags/R4-46`, with no additional carry.
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

This records source changes only; compatibility and adoption remain at step 4.


### QPC upstream observation

D36 retains `913fad4` and `patch/QPC-dataonly.p0.patch`, with no
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

This records source changes only; compatibility and adoption remain at step 4.


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


### lua upstream observation

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
Compatibility and inclusion remain open for step 4. D9 and the source pin
are unchanged. This observation does not complete the combined upstream survey.

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


### busy upstream observation

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

This records source changes only; compatibility and adoption remain at step 4.


### scaler upstream observation

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

This records source changes only; compatibility and adoption remain at step 4.


### mca upstream observation

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

This records source changes only; compatibility and adoption remain at step 4.


### measComp upstream observation

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

This records source changes only; compatibility and adoption remain at step 4.


### motor upstream observation

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

Change summary from commit subjects and changed-file lists: Position-compare output, removal of support for old asyn interfaces, HVEL fallback behavior, templates, displays, and documentation. Compatibility remains for step 4.

This records source changes only; compatibility and adoption remain at step 4.


### motorMotorSim upstream observation

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

This records source changes only; compatibility and adoption remain at step 4.


### pmac upstream observation

Observed 2026-10-29: the effective pin is `2-7-9`, and the prepared source
matches its resolved commit, `02c4f7247c760634e73b4e5175e3380844c3a77a`.
The latest remote release tag is `2-7-10`, resolving to
`34730140ae052b795bbedb54f83c6a7fe44a090a`, with commit date 2026-10-14.
Remote HEAD names `dls-master` at that same commit.
The range from the pin to the latest tag contains 18 commits.

Compatibility and inclusion of `2-7-10` remain open for step 4, including
its compatibility with motor. D12's statement that no newer pmac tag exists
describes its 2026-10-11 decision context; the observed tag list differs.
D12 remains the current motor decision pending that assessment.
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

This records source changes only; compatibility and adoption remain at step 4.


### ADCore upstream observation

Observed 2026-10-29: the effective pin and prepared source are
`ee039d24c9e89e70b31fd383b4817a40db5d6395`.
Remote HEAD names `master` at
`36840e14b683079a8eb8423278eef41f371b1914`, dated 2026-10-13.
The branch contains ten commits after the pin, matching the previously
recorded head. The latest remote release tag is `R3-14`, an ancestor of
the pin; no later release tag is present.

The commit subjects describe a circular buffer plugin busy-record fix
with its unit test, a Windows header include fix, an expanded error
message, and CI updates. Compatibility and inclusion remain open for
step 4 under D25. The source pin is unchanged by this survey.
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


### ADSimDetector upstream observation

Observed 2026-10-29: the effective pin and prepared source are
`0ef1305351ce79baedb34ab82d63d4b030f0bffd`.
Remote HEAD names `master` at the same commit, dated 2025-07-28.
There are no later commits on the observed default branch.
The latest remote release tag is `R2-11`, an ancestor of the pin;
no later release tag is present.

The survey outcome remains unchanged. D25 still requires step 4 to
confirm pin retention and its reason with the areaDetector dependencies.
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


### ADGenICam upstream observation

Observed 2026-10-29: the effective pin and prepared source are
`ba5b9b8bfcd0a38e1de558096cadf1bf5aca7768`.
Remote HEAD names `master` at
`df3d7cd35b0eb2390095b6d3bfbbcb6860c92cc1`, dated 2026-10-01.
The branch contains three commits after the pin, including one merge,
matching the previously recorded head. The latest remote release tag is
`R1-10`, an ancestor of the pin; no later release tag is present.

The two non-merge commit subjects describe support for The Imaging Source
DMK 33GX174 camera and restoration of `GC_prefix` for upstream.
Compatibility and inclusion remain open for step 4 under D25.
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

This records source changes only; compatibility and adoption remain at step 4.


### ADVimba upstream observation

Observed 2026-10-29: the latest remote release tag is `R1-5`, matching
the effective pin and prepared source at
`e2b9e4fc3d7df04c1b5ad8c50dc0d2d64e2a386e`.
Remote HEAD names `master` at
`ddeb02109f0e76fa44a110e3df22ff3bbf025b96`, dated 2026-04-16.
The branch contains nine commits after `R1-5`; there is no newer release tag.

The tag comparison remains unchanged. Treatment of the later branch changes
is open for step 4 under `upstream-fix-carry-procedure.md`; compatibility
and inclusion have not been decided. D25 also requires confirmation of
pin retention and its reason with the areaDetector dependencies.
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

This records source changes only; compatibility and adoption remain at step 4.


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


### pyDevSup upstream observation

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
Compatibility and inclusion of the additional changes remain open for
step 4 under `upstream-fix-carry-procedure.md`.
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

This records source changes only; compatibility and adoption remain at step 4.


### siteApps upstream observation

Observed 2026-10-29: the effective pin in the selected site repository is
`0.1.0`. Its resolved commit and the prepared source are
`37594135824a110c93ee49ed45a7ba82d3cb5815`.
The remote tag query returns only `0.1.0`, resolving to that same commit.
Remote HEAD names `master` at the same commit, dated 2026-03-12.
There are no later commits on the observed default branch and no newer
release tag.

The survey finds no upstream update. The step 4 assessment of dependencies,
consumers, and pin retention remains open under D25.
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

This records source changes only; compatibility and adoption remain at step 4.


### unidrv upstream observation

Observed 2026-10-29: remote HEAD names `main` at
`e5a8561100ca825b865aa49fe91c0015407ba3c6`, dated 2026-10-27.
The remote tag list ends at `0.5.1`, which resolves to the prepared source
commit `86688df5640cc9a4abbe8d99b7c9a4bc838bc328`.
The range from that pin to the observed branch head contains four commits,
including two merge commits. The two non-merge commit subjects describe
dynamic IOC module loading support and removal of an unused substitutions
file; their compatibility has not been assessed.

Rechecked after siteApps on 2026-10-29: the effective pin, prepared source,
remote HEAD, latest tag, and four-commit count match the observation above.

The source stays at `0.5.1`. Inclusion of the branch changes is an open
step 4 decision. This observation covers unidrv only and does not complete
the combined upstream survey.

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

This records source changes only; compatibility and adoption remain at step 4.


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

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Site consumer coverage: pending the combined dependency check of step 4 (D25).
Review findings and rulings: the review passes of 2026-10-28 found only items of consistency and wording, all fixed in the plan: the source of the guest resources, the place of the `Patching` count, the guest of the round trip, the undefined `<sandbox>`, the missing pointer to the tool commands, and the wording of this line. Rulings of the maintainer on 2026-10-28: both test machines are new guests, Debian 13 and Rocky Linux 8.10, as #111 says, although the local host is also Debian 13; the tree is built as `docs/src/procedures/build-and-install.md` sets out, not through the `epics_build` operator that #111 named, and the body of #111 was edited to follow the plan. Open: the maintainer's acceptance of the plan and the separate authorization of the implementation.

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
5. On each test machine install the missing tools of the loader suite and
   check `df -i /tmp`; `docs/procedures/release-procedure.md`, Test machines,
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
   counts the patch files that apply on Linux; it is 42 for the pins of this
   release, as `docs/src/procedures/build-and-install.md` gives it, and a
   different count is a finding.
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
| Baseline build: `make exist` exit 0, HEAD at the candidate, `modules` entry count | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| Patch apply-and-revert test | not run | Debian 13 | pending | none |
| Round trip prints `Patching lines: 42` | not run | Debian 13 | pending | none |
| Loader suite | not run | Debian 13, Rocky Linux 8.10 | pending | none |
| Installed-tree checks (`make check.deps`, `make check.env`) | not run | Debian 13, Rocky Linux 8.10 | pending | none |

## Tools of the cycle

Step 5a of `docs/procedures/release-procedure.md`: the three scripts of
`tools/module-check/` and the make targets are read against what Stage 6 of
`docs/procedures/module-bump-procedure.md` says they do. The cycle of EPICS
base uses them as they are. One difference is known before it:
`guest-update.bash` removes a module's source tree and runs the clone, the
configuration, and the build targets, but the patches of a module are applied
only by `make patch`. A module that has downstream patches at its pin is then
built from unpatched source: opcua, feed-core, QPC, StreamDevice, and measComp
have them (the mca patch applies on macOS only). The script also prints
an empty `modules/<module>` link for a module whose installed name differs,
such as sequencer, installed as `seq`.

Work, after the cycle of EPICS base and before the cycle of pvxs:

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

1. In `guest-update.bash`, after the clone target, run the patch targets of the
   module in the order of the `patch:` list of `configure/RULES_SRC`, so that
   the output keeps the `Patching` lines of the module and a module with no
   such target runs none.
2. Print every link of `<tree>/modules` that points to the install location of
   the module instead of the one link `modules/<module>`.
3. Change the sentences of `docs/procedures/module-bump-procedure.md`, The
   checks, item 1, that describe the script: what it prints, the hand-built
   case of a module with downstream patches and its `grep`, and the empty
   `modules/<module>` link of sequencer.
4. Check the script with `bash -n` and ShellCheck, then commit and push the
   change; that commit is the candidate of this work.
5. On the Debian 13 test machine run
   `guest-update.bash opcua OPCUA <candidate> <sandbox>/EPICS-env`, which must
   show the `Patching` lines of opcua before its build, and
   `guest-update.bash sequencer SNCSEQ <candidate> <sandbox>/EPICS-env`
   followed by the rebuild of each module whose `_DEPS` lists
   `build.sequencer`, which must show no
   `Patching sequencer-src` line, the link `modules/seq`, and a successful
   build of every dependent. Record the results, then commit and push before
   the cycle of pvxs starts.

Results:

| Check | Observed at | Test machine | Result | Evidence |
| --- | --- | --- | --- | --- |
| `bash -n` and ShellCheck on `guest-update.bash` | not run | local host | pending | none |
| `guest-update.bash opcua`: `Patching` lines before the build, `UPDATE-DONE` | not run | Debian 13 | pending | none |
| `guest-update.bash sequencer`: no `Patching sequencer-src` line, link `modules/seq`, `UPDATE-DONE` | not run | Debian 13 | pending | none |
| Rebuild of each module whose `_DEPS` lists `build.sequencer` | not run | Debian 13 | pending | none |

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

None yet. A rule a cycle teaches goes into the procedure that owns it; a lesson
no procedure holds is added here, one line with its evidence.

## History

| Reset Date | Prior Canonical Commit |
| --- | --- |
| 2026-10-10 | `4d521e7a0f05163d39541c0357e966397433b027` (`docs/milestone-84ee626.md` on master, the record this one started from) |
| 2026-10-18 | `f2efff0fa57c4d9154576ca3315e21e9bd7a3c1c` (`docs/milestone-1.5.0.md`) |
| 2026-10-25 | `48c60d48825594065cc0cd36b24ca68562a8a586` (`docs/milestone-1.5.0.md`, the form with the work table and the module details) |
