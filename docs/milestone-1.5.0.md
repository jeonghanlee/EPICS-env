# Release record 1.5.0

Release: 1.5.0
Release branch: `release-1.5.0`, upstream `origin/release-1.5.0`
Record: `docs/milestone-1.5.0.md`
Tracker: `jeonghanlee/EPICS-env`, GitHub milestone 1.5.0 (number 7); the issue that tracks the release is #100

Entry point for the next work: the procedures under `docs/procedures/` are complete,
and this record follows them. Step 4 of `docs/procedures/release-procedure.md`
needs three decisions first (Open decisions): ADCore, ADGenICam, and lua. The
cycle of EPICS base follows (step 6). Its issue is #111 and its plan is drafted
in its section below: the plan review in two passes, the maintainer's
acceptance, and the separate authorization of the implementation come next,
then the plan commit as the candidate and the request for test machines. The
site modules are not part of this record; they are added later.

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

### Open decisions

The maintainer decides each at step 4 of `docs/procedures/release-procedure.md`, before the cycles start. Stages 3 and 4 of `docs/procedures/module-bump-procedure.md` come first for the newer commits: the reverse dependencies at the pinned revision and the API/ABI judgement, presented to the maintainer with the decision (Stage 5) and recorded in its decision row.

| Module | Pin | Newer upstream | What it holds |
| --- | --- | --- | --- |
| ADCore | `ee039d2` | `36840e1`, 10 commits above the pin | A circular buffer plugin fix that clears the busy record after the last loop iteration, with its unit test; a header include fix for Windows; a longer error message; and CI configuration updates |
| ADGenICam | `ba5b9b8` | `df3d7cd`, 3 commits above the pin | Support for The Imaging Source DMK 33GX174 camera and the restore of the `GC_prefix` for upstream |
| lua | `01aa7a1` (D9) | `f682826`, 6 commits above the pin, dated 2026-10-01 to 2026-10-23 | 64-bit integer and mbbiDirect support, lsi and lso support, array support, example and release note updates, and a test fix |

## Modules

Order of the cycles is D3. The issue of a module is opened at its plan step (D20), and its section below is added at that step.

| Order | Module | Pin | Outcome | Issue | State |
| --- | --- | --- | --- | --- | --- |
| 1 | epics-base | `tags/R7.0.10` | unchanged | #111 | plan drafted |
| 2 | pvxs | `tags/1.5.2` -> `tags/1.5.3` | IN (D5) | at the plan step | not started |
| 3 | MCoreUtils | `a86e5ed` | unchanged | at the plan step | not started |
| 4 | autosave | `tags/R6-0` | unchanged | at the plan step | not started |
| 5 | ether_ip | `tags/ether_ip-3-10` | unchanged | at the plan step | not started |
| 6 | iocStats | `tags/4.0.1` | unchanged | at the plan step | not started |
| 7 | recsync | `9834b94` | HOLD (D17) | at the plan step | not started |
| 8 | retools | `5ada1e1` | unchanged | at the plan step | not started |
| 9 | sequencer | `tags/R2-2-9` | unchanged | at the plan step | not started |
| 10 | snmp | `tags/v1.1.0.4ja` | unchanged | at the plan step | not started |
| 11 | opcua | `tags/v0.11.2` | unchanged | at the plan step | not started |
| 12 | pcas | `e075fd4` | HOLD (D16) | at the plan step | not started |
| 13 | pscdrv | `276daca` | unchanged | at the plan step | not started |
| 14 | linStat | `tags/1.2.1` | unchanged | at the plan step | not started |
| 15 | feed-core | `0472d88` | unchanged | at the plan step | not started |
| 16 | sscan | `e13699e` -> `ce9660c` | IN (D7) | at the plan step | not started |
| 17 | calc | `4217e83` -> `tags/R3-8` | IN (D6) | at the plan step | not started |
| 18 | asyn | `tags/R4-46` | unchanged | at the plan step | not started |
| 19 | QPC | `913fad4` | unchanged | at the plan step | not started |
| 20 | modbus | `tags/R3-4` | unchanged | at the plan step | not started |
| 21 | lua | `17475b5` -> `01aa7a1` | IN (D9), newer upstream open | at the plan step | not started |
| 22 | std | `5f2e442` -> `27b6967` | IN (D8) | at the plan step | not started |
| 23 | StreamDevice | `tags/2.8.26` | unchanged | at the plan step | not started |
| 24 | rgamv2 | `27fc633` | unchanged | at the plan step | not started |
| 25 | busy | `2dfe92d` -> `a4a272d` | IN (D10) | at the plan step | not started |
| 26 | scaler | `beb5521` -> `baa8e1c` | IN (D11) | at the plan step | not started |
| 27 | mca | `687d563` | unchanged | at the plan step | not started |
| 28 | measComp | `c38974e` | HOLD (D15) | at the plan step | not started |
| 29 | motor | `285f44d` -> `4b22ac9` | IN (D12) | at the plan step | not started |
| 30 | motorMotorSim | `tags/R1-3` | unchanged | at the plan step | not started |
| 31 | pmac | `2-7-9` | unchanged | at the plan step | not started |
| 32 | ADCore | `ee039d2` | open | at the plan step | not started |
| 33 | ADSimDetector | `0ef1305` | unchanged | at the plan step | not started |
| 34 | ADGenICam | `ba5b9b8` | open | at the plan step | not started |
| 35 | ADVimba | `tags/R1-5` | unchanged | at the plan step | not started |
| 36 | caPutLog | `dafb0b2` -> `tags/R4.2` | IN (D13) | at the plan step | not started |
| 37 | pyDevSup | `4527ed0` -> `tags/2.1.0` | IN (D14) | at the plan step | not started |

The pin of a changed module in `configure/RELEASE` is already the new one. An
unchanged or HOLD module runs the whole cycle at its pin, and its section
records why the pin did not move.

### EPICS base

Outcome: unchanged. The survey of 2026-10-25 reports `tags/R7.0.10` as the latest release; the 18 carry patches and 2 site patches of `patch/` stand.

Issue: #111, https://github.com/jeonghanlee/EPICS-env/issues/111

Plan status: draft
Plan acceptance: none
Implementation authorization: none
Review findings and rulings: none

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
   (D19). Resources: 2 vCPU, 4096 MiB memory, and 20 GiB disk each, as the
   guests of the earlier run. Duration: until the last module cycle ends. State:
   new guests whose disks are kept as evidence until the results are recorded.
   Access: SSH from the local host.
5. On each test machine install the tools of the loader suite, check
   `df -i /tmp`, clone this repository into the sandbox, check out the
   candidate, set the install location inside the sandbox, and build the whole
   tree as `docs/src/procedures/build-and-install.md` sets out. The baseline is
   good when `make exist`, `make check.deps`, and `make check.env` exit 0 and
   `git -C <sandbox>/EPICS-env rev-parse HEAD` prints the candidate. Record the
   OS point release, the kernel, the compiler, and the count of the entries of
   the installed `modules` directory, which the checks compare against after a
   failed loader suite (`docs/procedures/release-procedure.md`, Test machines).
6. Run the checks of `docs/procedures/module-bump-procedure.md` (The checks):
   `guest-roundtrip.bash <candidate> "" <sandbox>` on one machine,
   `guest-suite.bash <sandbox>/EPICS-env <sandbox>/iocsh-tests/base` on every
   machine, and `make check.deps` and `make check.env` on every machine, with
   the logs named in that section in `work/base-bump/`.
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
| Patch apply-and-revert test | not run | one machine | pending | none |
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

| Item | Evidence |
| --- | --- |
| Integration tests: the six OS workflows and the Linter, the patch apply-and-revert test on a fresh checkout, the loader suite, and the common iocsh fragments | pending |
| Version check: `ENV_RELEASE_VERS` is 1.5.0 in `configure/CONFIG_SITE` (since `8a603bb`), and `make -s print-ENV_RELEASE_VERS` prints it | pending |
| `ChangeLog.md` entry `### 1.5.0 <date> <name> <email>` | pending |
| README and book paths that name the previous release | pending |
| Production environment tests on the Debian 13 and Rocky Linux 8.10 test machines: `make exist`, `make check.deps`, `make check.env`, and `softIocPVX` started with `exit` on its standard input | pending |
| The commit that carries this evidence is the release candidate | pending |

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
EPICS-env checkout. `<candidate>`,
`<evidence_files>`, and `<hash>` exist only when their row runs; each is filled
in when the row is shown for its authorization. The note files of rows 9 and 11
are written and shown to the maintainer before their rows.

| Step | Action | Command | Expected result | Evidence |
| --- | --- | --- | --- | --- |
| 1 | Commit of the release readiness evidence on `release-1.5.0`, the release candidate | `git -C <checkout> add <evidence_files>` ; `git -C <checkout> commit -F work/commit-msg-release-readiness.txt -- <evidence_files>` ; `git -C <checkout> rev-parse HEAD` | The full candidate SHA is recorded | pending |
| 2 | Push `release-1.5.0` | `git -C <checkout> push origin release-1.5.0` ; `git -C <checkout> ls-remote origin refs/heads/release-1.5.0` | The remote tip equals the reviewed local tip and contains the candidate | pending |
| 3 | Bring local `master` up to date with `origin/master` by fast-forward, without leaving the release branch | `git -C <checkout> fetch origin master:master` ; `git -C <checkout> rev-list --count release-1.5.0..master` | `git rev-list --count release-1.5.0..master` prints 0 | pending |
| 4 | Push `release-1.5.0` with the result commits of rows 1 to 3 | `git -C <checkout> push origin release-1.5.0` ; `git -C <checkout> ls-remote origin refs/heads/release-1.5.0` | The remote tip equals the local tip that row 5 merges; this result is recorded on `master` after the merge | pending |
| 5 | Merge, with `--no-ff`, the tip of `release-1.5.0` after the last result commit before the merge into `master`, subject `Merge release-1.5.0: EPICS Environment 1.5.0` | `git -C <checkout> switch master` ; `git -C <checkout> merge --no-ff release-1.5.0 -m "Merge release-1.5.0: EPICS Environment 1.5.0"` ; `git -C <checkout> rev-parse HEAD` ; `git -C <checkout> diff --stat <candidate> release-1.5.0` | The merge SHA is observed, and the comparison of that tip with the candidate is recorded under the candidate rule (`docs/procedures/release-procedure.md`, step 7) | pending |
| 6 | Annotated tag `1.5.0` on the merge commit, message `EPICS Environment 1.5.0` | `git -C <checkout> tag -a 1.5.0 -m "EPICS Environment 1.5.0"` ; `git -C <checkout> rev-parse 1.5.0 1.5.0^{commit}` | The tag object and its peeled commit are observed | pending |
| 7 | Push `master` | `git -C <checkout> push origin master` ; `git -C <checkout> ls-remote origin refs/heads/master` | The remote tip equals the reviewed local tip and contains the merge | pending |
| 8 | Push `refs/tags/1.5.0` | `git -C <checkout> push origin refs/tags/1.5.0` ; `git -C <checkout> ls-remote origin refs/tags/1.5.0 refs/tags/1.5.0^{}` | The remote tag object and its peeled commit match | pending |
| 9 | GitHub release `1.5.0` with notes written from the `ChangeLog.md` entry of 1.5.0 in the form of the notes of release 1.4.0, shown to the maintainer before the row | `gh release create 1.5.0 --repo jeonghanlee/EPICS-env --verify-tag --title 1.5.0 --notes-file work/release-notes-1.5.0.md` ; `gh release view 1.5.0 --repo jeonghanlee/EPICS-env --json name,tagName,isDraft,isPrerelease,publishedAt,url` ; `gh api repos/jeonghanlee/EPICS-env/releases/latest --jq '"\(.id) \(.tag_name)"'` | Published, not a prerelease, latest; id, URL, and time recorded | pending |
| 10 | Delete `release-1.3.0` locally and on origin (D22) | `git -C <checkout> branch -d release-1.3.0` ; `git -C <checkout> push origin --delete release-1.3.0` ; `git -C <checkout> ls-remote --heads origin release-1.3.0` | The deletion or the observed absence is recorded | pending |
| 11 | Close #100 after the release objects exist, with its body synced and a closing comment | `gh issue edit 100 --repo jeonghanlee/EPICS-env --body-file work/issue-100-body.md` ; `gh issue comment 100 --repo jeonghanlee/EPICS-env --body-file work/issue-100-closing.md` ; `gh issue close 100 --repo jeonghanlee/EPICS-env` ; `gh issue view 100 --repo jeonghanlee/EPICS-env --json state --jq .state` | The closed state is read back | pending |
| 12 | Close GitHub milestone 1.5.0 (number 7) | `gh api -X PATCH repos/jeonghanlee/EPICS-env/milestones/7 -f state=closed` ; `gh api repos/jeonghanlee/EPICS-env/milestones/7 --jq '"state=\(.state) open=\(.open_issues) closed=\(.closed_issues)"'` ; `gh issue list --repo jeonghanlee/EPICS-env --milestone 1.5.0 --state all --json number,state --limit 100` | Closed with zero open items; every linked issue is read back in its final state | pending |
| 13 | Result commits on `master` after the merge | `git -C <checkout> commit -F work/commit-msg-release-result-13.txt -- docs/milestone-1.5.0.md` | Each recorded identifier is committed before the next dependent action | pending |
| 14 | Hand this record to master: rename it to `docs/milestone-<hash>.md` in a commit on master, keep only the work that survives the release, and add the History row (`<hash>` and the row as in `docs/procedures/release-procedure.md`, step 8) | `git -C <checkout> rev-parse --short HEAD` ; `git -C <checkout> mv docs/milestone-1.5.0.md docs/milestone-<hash>.md` ; `git -C <checkout> commit -F work/commit-msg-rename.txt -- docs/milestone-1.5.0.md docs/milestone-<hash>.md` | The new path exists, and its History row holds the full hash of the commit that carries the closed record | pending |
| 15 | Final push of `master` | `git -C <checkout> push origin master` ; `git -C <checkout> ls-remote origin refs/heads/master` | The remote tip equals the handover commit and contains the result commits | pending |

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
