# linStat 1.2.1 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-10-30. The Maintainer selected five upstream
commits: netstat simplification, RTC status, Host OPI, separate-install
configuration loading, and NIC P support. The std::filesystem removal is excluded.
The five carry files and one RTC site correction are prepared and wired into
aggregate apply/revert. Both RTC defects pass targeted before/after verification.
The source remains pinned to `tags/1.2.1`; full module and IOC acceptance remain pending.

## Scope

This record presents every post-pin candidate, five independent scores,
application checks, dependencies and introduced defects for the Maintainer's
carry decision, ordered selection, patch implementation and local verification. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md).

**Out of scope:** complete module/release
builds, IOC and hardware acceptance, and git publication. Release decisions
D18/D19 in the [release record](milestone-1.5.0.md) govern later verification;
upstream test suites were not run.

## Source range and coverage

- Upstream: `https://github.com/mdavidsaver/linStat`.
- Pin: `tags/1.2.1`, `b4729e43c8ee9791975abbc7e06b870f46fb9661`.
- Survey tip: `df0f547186ab0bd69281a4ec414c36b8a1c3ce64`, committed 2026-07-21.
- Remote observation on 2026-10-30 confirmed that tip and no release tag above 1.2.1.
- Base remains R7.0.10 and pvxs remains 1.5.3.

All six commits survive content classification: none is exclusively documentation,
CI or tests. Display changes affect executable OPI content; the NIC change also
modifies substitutions, examples and an upstream test. All six frozen diffs were
checked byte-for-byte against their actual Git objects. The companion JSON retains
full SHAs, changed-file lists and diff hashes.

## Panel method and complete result

Five fresh-context reviewers independently read the entire six-commit set in
batches of three and two, without reading peers' results. They used the inherited
model, so these are independent contexts rather than different model families.
The Facilitator reconciled evidence without adding a sixth score.

Each axis is an integer from 0 to 10. Security measures reduced remote exposure;
safety measures memory safety and robustness; bug measures functional correctness
fixed; perf measures runtime performance; ops measures facility value; urgency
measures harm before a bump; fit measures applicability and regression surface;
locality scores narrow impact high. Introduced defects do not earn safety or bug
benefit points. Code validated all 240 integers, took each axis's median across
five reviewers, then summed those medians. The rule is
`total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`.

The [raw scores and notes](linstat-carry-1.5.0-scores.json) preserve every
reviewer's original six rows. A rule outcome is a recommendation, not approval.

| Commit | Change | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule basis |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| df0f547 | Support NIC P prefix | 0 | 0 | 5 | 0 | 6 | 2 | 9 | 8 | 30 | bug |
| e48e077 | Fix separate-install CONFIG loading | 0 | 0 | 5 | 0 | 4 | 1 | 9 | 9 | 28 | bug |
| 8e6d08a | Remove std::filesystem | 0 | 0 | 4 | 0 | 5 | 2 | 8 | 6 | 25 | none |
| 78b6138 | Simplify netstat path storage | 0 | 0 | 0 | 1 | 0 | 0 | 10 | 10 | 21 | none |
| 7576edc | Update Host OPI | 0 | 0 | 0 | 0 | 3 | 0 | 4 | 9 | 16 | none |
| 6ea15c7 | Add RTC status | 0 | 0 | 0 | 0 | 4 | 1 | 3 | 5 | 13 | none |

| Stage | Count |
| --- | ---: |
| Enumerated | 6 |
| Removed as exclusively doc / CI / test | 0 |
| Deferred for missing application target | 0 |
| Scored | 6 |
| Independent reviewers | 5 |
| Integer axis scores | 240 |
| Met the recommendation rule | 2 |
| Added by Maintainer beyond the rule | 3 |
| Rule-pass fixes removed by Maintainer | 0 |
| Selected upstream carries | 5 (RTC requires corrections) |
| Excluded upstream candidates | 1 |

## Findings affecting selection

### RTC: failed parsing dereferences null

Commit `6ea15c7`, `statApp/src/tblRTC.cpp:73` and `:82`, dereferences the
return from `strptime` before checking it for null. Malformed time/date files
produced null-load diagnostics and SIGSEGV in narrow executables using the
actual upstream parser and its table/reactor support. Factory-based probes used
the real `StatTable::lookup`; the exception handler does not handle SIGSEGV.
Valid input and the live host RTC succeeded in the probes that exercised them.

The malformed files were explicitly synthesized inputs at the filesystem
boundary. No internal function was mocked. This establishes the parser failure,
not a claim that a deployed kernel emits malformed RTC output or that an IOC
crash was reproduced. The pinned version has no RTC feature, so this is a defect
introduced by the candidate. The Maintainer selected RTC with this defect to be
corrected. The unmodified RTC feature is not accepted as complete. The site correction
and observed real-path verification are recorded below; final cycle acceptance
is separate.

### RTC: local time during DST reports a false one-hour difference

At `6ea15c7`, `tblRTC.cpp:37` zero-initializes `tm_isdst`, and `:96-97`
passes it to `mktime` without enabling DST inference. Files generated from the
current correct local wall clock under a DST timezone produced `delta=3600`
and `ref=1` through the actual parser. Corresponding UTC cases produced zero.
The new `logicHost.template:175,179` sets HIHI=10/HHSV=MAJOR; the false value
exceeds that threshold. Actual IOC alarm processing was not executed.

Four reviewers independently reproduced this behavior. Three classified it as
minor and one as must-fix; all treat it as an unresolved functional defect.
The severity difference does not change the evidence or permit silent acceptance.
UTC-only operation avoids this particular case but does not fix the null access.

### Host OPI requires the RTC producer

`7576edc`, `opi/bob/linStatHost.bob:500,508,515`, adds RTC:DLT, RTC:REF and
RTC:BAT references. The records come from `6ea15c7`,
`statApp/Db/logicHost.template:168,188,196`. Actual MSI-generated host DBs and
Phoebus macro evaluation confirmed these three references are absent at the pin
and present with RTC. Preexisting field-qualified PVs were normalized to record
names for this comparison and were not misclassified as missing records.

This is a runtime data dependency, not a textual patch dependency. The Maintainer
selected the full OPI change alongside RTC, with the corrected RTC producer
required before acceptance.

## Candidate interpretation and consumers

`df0f547` fixes the advertised independent `P` prefix while retaining `NIC` as
the kernel interface selector. Actual Base MSI expansion produced byte-identical
legacy IOC/NIC DBs before and after the change. Explicit P without IOC and P with
IOC also expanded correctly. The actual installed Phoebus macro library resolved
the display's PV names to matching generated records in all three modes. The
existing `commonIocsh/iocsh/linStatNIC.iocsh:12` still exposes IOC/NIC only;
adopting the patch does not add a custom-P parameter to that wrapper.

`e48e077` fixes generic upstream CONFIG discovery when INSTALL_LOCATION differs
from TOP. Actual CONFIG evaluation changed missing LINSTAT version/TOP values
into defined values. However, `configure/RULES_MODS_CONFIG:379-385` already
includes source and installed CONFIG_LINSTAT_VERSION explicitly. Running that
actual recipe against pin and patched archives preserved the effective version
settings in both cases. The patch is a valid upstream correctness fix with low
immediate urgency for this environment, not a demonstrated repair of its current
module build.

`8e6d08a` removes std::filesystem and the GCC 8 stdc++fs linking special case.
The pin already has that linking workaround. Actual utility/hwmon paths compiled
and ran on the available host, but changing live sensor values do not establish
byte equivalence. The shared ReadDir helper also serves process FD enumeration.
GCC 8 static linkage, DT_UNKNOWN filesystems, hotplug and all error paths remain
unverified; no measured performance benefit is claimed.

`78b6138` removes redundant filename storage and uses the immutable
StatTable::inst already present at the pin. Actual old/new netstat paths gave
byte-identical results on captured kernel input. This is a small maintenance
simplification, with no demonstrated correctness repair or measured speedup.

## Applicability and order

All five reviewers independently checked all six patches against real pristine
pin archives with zero-fuzz dry-runs, then applied the complete upstream-ordered
stack in separate scratch trees. No text-application prerequisite was found.
Referenced pin symbols and build variables were checked; narrow component
compilation is not a complete module build.

| Upstream order | Commit | Relation |
| ---: | --- | --- |
| 1 | 8e6d08a | Shares statApp/src/Makefile with 6ea15c7; overlap only |
| 2 | 78b6138 | No other candidate required in checked scope |
| 3 | 6ea15c7 | Compiles narrowly against the pin without 8e6d08a |
| 4 | 7576edc | Runtime RTC record dependency on 6ea15c7 |
| 5 | e48e077 | Uses existing Base INSTALL_CFG; independent |
| 6 | df0f547 | Uses existing templates/macro support; independent |

The two rule recommendations touch separate files and need no other candidate
in the checked scope. The table above preserves the complete candidate ordering;
the selected subset is listed below. It requires its own patch preparation,
apply/revert and functional verification.

## Verification limits

The reviewers executed strict patch application, real-source native components,
MSI expansion, actual CONFIG evaluation and the existing conf.linStat recipe.
One reviewer also executed the actual Phoebus macro engine. These are bounded
checks; they do not establish IOC loading, CA connections or alarm behavior.
Phoebus/JavaFX rendering attempts failed with DISPLAY unavailable, so visual
layout and clipping remain unverified. No full module/release build, six-OS CI,
Rocky Linux 8.10 acceptance or hardware acceptance ran.

The existing linStat verification script checks record-name groups; it does not
prove RTC arithmetic, malformed-input handling or custom-P operation. It and the
upstream test suite were read, not executed. Native probes used installed Base
7.0.10; synthesized RTC inputs were boundary fixtures, not replacement internal
implementations or claimed shipped fixtures.

Five delegated third-person passes produced 13 finding entries: six must-fix,
three minor and four info entries. After deduplication these are two RTC defects
and one OPI dependency. Both defects were open at assessment time. The Maintainer accepted them as
required corrections and chose RTC with its OPI. The implementation and
targeted correction results are recorded below; this historical assessment
does not itself prove those later results.


## Maintainer decision and ordered apply-selection list

On 2026-10-30, the Maintainer selected both rule-pass fixes and added three
rule-miss candidates: RTC for battery/clock monitoring, Host OPI to display that
monitoring, and netstat simplification to include the small redundant-storage
cleanup. The std::filesystem removal is excluded for this carry set: the pin
already handles the GCC 8 link requirement, and its shared directory traversal
change is left for a later version assessment. No score was revised.
The release record records this selection as D33.

| Order | Commit | Title | Total /80 | Basis | Overlap with selected upstream set |
| ---: | --- | --- | ---: | --- | --- |
| 1 | `78b61382545843441fcf53f2182d5f1d1c5151f8` | Simplify netstat path storage | 21 | maintainer: include small cleanup | none |
| 2 | `6ea15c7446c0bc979da4d663f487b83b61717741` | Add RTC status | 13 | maintainer: RTC monitoring, corrections required | none |
| 3 | `7576edcd286a988448e5a236948ba81dfa82c85c` | Update Host OPI | 16 | maintainer: display selected RTC monitoring | none |
| 4 | `e48e077964255f66ea2a47fbd2a20ed31c06e391` | Fix separate-install CONFIG loading | 28 | bug | none |
| 5 | `df0f547186ab0bd69281a4ec414c36b8a1c3ce64` | Support NIC P prefix | 30 | bug | none |

All five selected upstream changes passed the same independent pin-application
and dependency checks described above, including the three added by Maintainer
choice. RTC compiled narrowly without the excluded filesystem change. The OPI
requires RTC records; the other selected commits have no observed prerequisite
on a nonselected candidate. The selected upstream commits share no files.

The five upstream commits produce five carry files. One additional site patch
handles null strptime results and DST-aware local-time conversion. It applies
after the upstream RTC addition and reverts before it. No local corrective
change has been scored as though it were an upstream commit.

This selection does not mark module build, installed-tree, IOC or visual
acceptance complete. The selected stack plus RTC correction has the local
verification below; the full module cycle remains pending.


## Patch implementation and local verification

The five carry files preserve the complete upstream no-prefix diffs, including
related documentation, display and example/test-invocation changes. No hunk was
curated. The separate local correction keeps upstream provenance visible.

| Apply order | Patch file |
| ---: | --- |
| 1 | `1.2.1-01-78b6138-netstat-path.p0.patch` |
| 2 | `1.2.1-02-6ea15c7-rtc-status.p0.patch` |
| 3 | `1.2.1-03-7576edc-host-opi.p0.patch` |
| 4 | `1.2.1-04-e48e077-install-config.p0.patch` |
| 5 | `1.2.1-05-df0f547-nic-prefix.p0.patch` |
| 6 | `1.2.1-site01-rtc-parse-dst.p0.patch` |

`patch.linStat.commit.apply` sorts `$(SRC_VER_LINSTAT)-*.p0.patch` and fails
on the first unsuccessful application. Its revert target reverses the same
list using the shipped revert helper. Both are present in the aggregate targets
in inverse order. The [patch summary](../patch/README.md) contains five carry
rows and one site-patch subsection. The version glob requires re-examination
when the pin changes.

The site correction checks both strptime return pointers before dereferencing
them and keeps the existing complete-parse check. Invalid/incomplete date or
time omits delta/ref from the new table snapshot; battery parsing remains
available. The local-time candidate sets tm_isdst=-1 before mktime. UTC conversion
still uses its own struct copy. This narrow correction does not validate every
impossible calendar date or resolve the repeated local hour at the autumn DST
transition without an offset.

Observed on Debian 13, GCC 14.2.0 and installed Base 7.0.10, 2026-10-30:

| Check | Observed result |
| --- | --- |
| Five carry files versus Git objects | Byte-identical to the selected full upstream diffs |
| Strict forward and reverse application | All six patches pass with fuzz zero in the required order |
| Invalid RTC time/date negative controls | Upstream-only executable reports null-load UB and exits nonzero; corrected executable succeeds without delta/ref |
| RTC current-clock invariant | Every successful probe confirms the controlled OS clock reached the real Transaction timestamp |
| RTC seasonal cases | Twelve UTC/local cases across winter, summer and nonambiguous spring/autumn transition boundaries report zero delta with the expected ref |
| Summer local-time negative control | Same input and clock change from upstream delta=3600 to corrected delta=0 |
| RTC other cases | Malformed date/time, trailing characters, missing date/time, missing file and a five-second offset give expected results; 20 corrected cases total |
| Netstat simplification | Actual old/new implementations produce identical 219 values from one captured kernel input |
| NIC prefix | Legacy IOC/NIC DB is byte-identical; P-only and P+IOC produce all 48 correctly prefixed records and retain NIC=lo |
| RTC database records | Actual MSI output contains all three new RTC records |
| Separate-install CONFIG | Actual upstream CONFIG evaluation resolves the version only after the carry; the existing EPICS-env recipe resolves it both before and after |
| Aggregate apply/revert | Actual make patch and make patch.revert exit 0 |
| Source restoration | All 37 root source Git statuses and 12,731 indexed regular-file hashes match the pre-apply snapshot; the added RTC file is absent after revert |
| Residue | No .orig or .rej files before or after the round trip |
| Already-unapplied revert | linStat revert exits 0 |
| Nonmatching version | Both linStat legs exit 0 without patch operations |
| Missing source | linStat apply fails at the first patch and does not continue |

The component verifier is retained at
[`tools/linstat-carry/verify.py`](../tools/linstat-carry/verify.py), with
[`table_probe.cpp`](../tools/linstat-carry/table_probe.cpp). It exports the real
pin and applies the actual patch files in new scratch trees. Native executables
compile the shipped table, factory, Transaction, reactor and IOC-hook source and
link installed Base libraries. Only the outer filesystem input and OS wall clock
are controlled; no internal implementation is mocked or replaced. The OS clock
interposition is Linux-specific and does not alter the machine clock.

From the repository root, set `base` to an existing Base 7.0.10 installation.
The source must be clean at the recorded pin and the work directory must not
exist. The tool requires Python with zoneinfo, timezone data, g++, GNU make,
Git, tar, patch and the installation's msi; it installs nothing.

```bash
base=/path/to/installed/base
python3 tools/linstat-carry/verify.py --source linStat-src --base "$base" --work-dir work/linstat-verify-001
```

Success prints PASS and writes report.json containing arguments, command output,
exit status and results. Failure returns nonzero and retains the workspace and
report; choose a different new directory for another run. For a different Linux
EPICS host architecture or compiler, pass `--arch` or `--cxx` explicitly.

Local execution records are in `work/linstat-carry-verification-20261030-b/`
and `work/linstat-aggregate-o17_flop/`. The table above retains the durable
outcomes. All prepared module sources have been restored; the next make patch
will apply the new six-file linStat set.

## Remaining acceptance and reviews

No full module build, Rocky Linux 8.10 run, installed-tree verification, IOC
startup/alarm processing, CA connections or hardware acceptance ran. Prior
Phoebus macro checks establish naming only; visual rendering remains unverified.
The upstream test suite remains excluded by D18. Full module-cycle acceptance
and the carry procedure's post-functional third-person and second-person
completion reviews remain pending. The local preparation reviews below do not
replace those full-cycle reviews.

## Pre-build review results

On 2026-10-30, an independent third-person implementation review followed by
an independent second-person reader review passed with zero must-fix, minor,
info, hygiene or out-of-scope findings in either pass. No correction was
required by these two passes.

The third-person reviewer checked all six patches and the complete changed
implementation, reran the real-source verifier, and independently exercised
strict forward/reverse application and the actual linStat make targets in
private source trees. An additional partial-stack failure check confirmed that
failure on the fourth patch stops the fifth carry and the site correction.
The second-person reviewer followed every affected document passage and ran
the published reproduction command in a new directory. Both runs reproduced
the recorded RTC, netstat, MSI and CONFIG results; both reviewers independently
confirmed all 37 source statuses and 12,731 recorded file hashes were restored.

These are cumulative reviews 6 and 7 of the linStat carry work; the earlier
five passes assessed the candidates. Their two RTC defects are corrected and
the OPI dependency is satisfied by the selected producer. The original scores
and assessment findings remain unchanged as historical evidence. Full module
and IOC acceptance, visual verification and the completion reviews above remain
pending.
