# PVXS 1.5.3 carry decision for EPICS-env 1.5.0

Decision date: 2026-10-29. Maintainer selected two upstream commits as carry
patches: unmarked single-PUT value preservation and TCP listener backlog.
The source pin remains `tags/1.5.3`. This record covers selection and patch
application; module build, installed-tree and IOC acceptance remain for the
release cycle under D18 and D19 of [the release record](milestone-1.5.0.md).

## Source range

- Upstream: `https://github.com/mdavidsaver/pvxs`.
- Baseline 1.5.3: `25ca43df4db909c0b1a445fb705fc81582617625`.
- Survey snapshot: `4311a854a0dda75b5e97cde7a10a38052f3ae90e`, committed 2026-10-28.
- Latest release tag observed on 2026-10-29: `1.5.3`; no newer release tag.
- All six commits below are upstream changes after the baseline, not local patches.

| Order | Commit | Change | Classification | Selection |
| --- | --- | --- | --- | --- |
| 1 | `a9f8b7b32f4145e97ff694ac22f5f8422a176e64` | Defer address parsing | code | Defer: configuration regression risk |
| 2 | `d23de00df491fc22fbebf243bb7dfefd1f27d4f8` | All-invalid address list rejection | code | Defer: prerequisite and regression risk |
| 3 | `7176098fd46ad5f7c49721cbea03c34d00fdc906` | Unmarked single-PUT value guard | code | Carry: rule and Maintainer |
| 4 | `96345ddbbad50144b9f4464b9a24a2e490bbbf45` | TCP listener backlog | code | Carry: Maintainer override |
| 5 | `61e42305e62bc9e8176f68f10d59723106d4b775` | Environment-variable definitions | documentation only | Exclude: documentation only |
| 6 | `4311a854a0dda75b5e97cde7a10a38052f3ae90e` | Environment-variable references | documentation only | Exclude: documentation only |

## Selection funnel

| Stage | Count | Basis |
| --- | ---: | --- |
| Enumerated | 6 | Entire baseline-to-snapshot range |
| Documentation-only | 2 | 61e4230 and 4311a85 change only RST; ineligible as code carries |
| Scored | 6 | Maintainer explicitly requested scoring every commit, including documentation |
| Applicability relation | 1 chain | Original d23de00 patch requires a9f8b7b; no standalone substitute was generated |
| Met rule | 2 | 7176098 and d23de00 |
| Added by Maintainer | 1 | 96345dd, for increased pending-connection capacity |
| Rule-pass omitted from selected set | 1 | d23de00, whose prerequisite carries unresolved regression risk |
| Selected | 2 | 7176098 then 96345dd |

The Maintainer selected these two after comparing their scores and discussing
backlog memory cost, the upstream rationale, and CA server backlog values.
The backlog choice is an explicit override of the score rule; no measured
site outage, latency improvement or urgent operational incident is claimed.
The configuration pair is deferred from this set, and both documentation-only
commits are excluded. EPICS Base remains R7.0.10 with its existing 18 carry
and three site patches under D26; no Base patch was changed by this selection.

## Panel method

Five fresh-context reviewers assessed every full diff independently in batches
of three and two. They did not read one another's scores. The Executor's sixth
author-context assessment was frozen before reading delegated results and was
not revised afterward. The Maintainer explicitly requested that sixth vote.
All used the inherited model; separate contexts do not imply different model
families or statistical confidence.

Each axis is an integer from 0 to 10: security (reduced remote exposure), safety
(memory safety and robustness), bug (functional correctness), perf (runtime
performance), ops (facility value), urgency (harm before the next bump), fit
(baseline applicability and regression surface), and locality (narrow impact
scores higher). Medians were computed separately per axis, then summed in code.
With six votes, the median averages the middle two values. Recommendation is
`total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`; it is not adoption.
The six-vote totals below are the selected record totals. Five-only results
preserve the normal procedure comparison; rank and rule outcomes are unchanged.

### Six assessments, including the Executor

| Commit | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule basis | Outcome |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| 7176098 | 0.5 | 3.5 | 9 | 0 | 9 | 7.5 | 9 | 8 | 46.5 | total, bug, urgency | Carry: rule and Maintainer |
| 96345dd | 0 | 1 | 3 | 5 | 6.5 | 3 | 9 | 9 | 36.5 | none | Carry: Maintainer override |
| d23de00 | 4 | 3 | 6 | 0 | 6 | 4 | 4 | 4 | 31 | bug | Defer: prerequisite and regression risk |
| 61e4230 | 0 | 0 | 0 | 0 | 2 | 0 | 8 | 10 | 20 | none | Exclude: documentation only |
| 4311a85 | 0 | 0 | 0 | 0 | 2 | 0 | 6.5 | 10 | 18.5 | none | Exclude: documentation only |
| a9f8b7b | 0 | 0 | 2 | 1 | 3 | 1 | 3 | 3.5 | 13.5 | none | Defer: configuration regression risk |

### Five independent reviewers only

| Commit | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule basis | Outcome |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| 7176098 | 1 | 4 | 9 | 0 | 9 | 8 | 9 | 8 | 48 | total, bug, urgency | Carry: rule and Maintainer |
| 96345dd | 0 | 1 | 3 | 5 | 7 | 3 | 9 | 9 | 37 | none | Carry: Maintainer override |
| d23de00 | 4 | 3 | 6 | 0 | 6 | 4 | 4 | 4 | 31 | bug | Defer: prerequisite and regression risk |
| 61e4230 | 0 | 0 | 0 | 0 | 2 | 0 | 8 | 10 | 20 | none | Exclude: documentation only |
| 4311a85 | 0 | 0 | 0 | 0 | 2 | 0 | 6 | 10 | 18 | none | Exclude: documentation only |
| a9f8b7b | 0 | 0 | 2 | 1 | 3 | 1 | 3 | 4 | 14 | none | Defer: configuration regression risk |

## Dependencies and review findings

`7176098` applies independently to the pin and uses the existing
`Value::isMarked(true, true)` API. Its scalar-mapping guard prevents an unmarked
value from reaching the database write; the single-PV caller retains its
processing call. Upstream adds the directly related `testqsingle.cpp` and
`testqsingle.db` regression fixtures; these are retained in the patch without
curation. The test's blocking-process count differs before Base 7.0.11 because
of a separate Base issue. This patch does not claim to fix that issue, and no
Base bump is required by the inspected source.

`96345dd` applies independently and shares no file with `7176098`. Its commit
message compares pvAccessCPP at 4, PCAS at 5 and RSRV at 20, using OS as an
approximation of resource availability. The actual change uses 32 on Linux
and other non-RTOS targets, retaining 4 on RTEMS and VxWorks. It increases
pending TCP connection capacity, not established-connection throughput or the
maximum number of PVs. Kernel resource use can rise while more connections
wait; neither the commit log nor this assessment supplies a benchmark.

`d23de00` fails its configuration hunk on untouched 1.5.3 and succeeds after
`a9f8b7b`. The refactor alone lets an entirely invalid explicit server-interface
list reach wildcard fallback; the follow-up restores rejection of that case.
It does not restore every baseline mixed-validity policy. Four of five
independent reviewers also found that malformed environment name-server tokens
now reach the existing `client.cpp` catch-without-continue path, which appends
an `AF_UNSPEC` address and can reach failed connection construction. The source
path was rechecked, but runtime failure was not reproduced. The pair is deferred;
no defect is marked fixed merely because it was omitted.

Both documentation commits are scored by instruction but excluded by content.
`4311a85` uses envvar targets supplied by `61e4230` despite applying independently
as text. All five reviewers found the missing local `EPICS_PVA_SERVER_PORT`
reference target; the actual documentation scan confirms it. No Sphinx render
was run. No introduced defect was found by static review in either selected
code change; this is not runtime acceptance.

## Ordered apply-selection list

| Order | Commit | Patch file | Total /80 | Basis | Overlap with selected set |
| --- | --- | --- | ---: | --- | --- |
| 1 | `7176098` | `1.5.3-01-7176098-single-put-marked-value.p0.patch` | 46.5 | total, bug, urgency | none |
| 2 | `96345dd` | `1.5.3-02-96345dd-tcp-listener-backlog.p0.patch` | 36.5 | Maintainer decision: pending-connection capacity | none |

Each file is the complete raw `git diff --no-prefix <sha>^ <sha>` output with
no added header and no dropped hunk. The existing `patch.pvxs.commit.apply`
version glob discovers them in this order; `patch.pvxs.commit.revert` uses the
reverse order. Both targets are already in the aggregate patch lists, so no
Makefile change is needed. [The patch summary](../patch/README.md) has one row
per file. Re-examine both at the next pvxs pin change.

## Verification

Selection-stage checks established genuine-source patch applicability and
baseline API availability; they did not compile or run the candidates.
Local production-format verification completed on 2026-10-29:

| Check | Observed result |
| --- | --- |
| Patch provenance | Both files byte-identical to the complete upstream `git diff --no-prefix <sha>^ <sha>` output |
| Individual p0 dry-run | Both exit 0 on clean 1.5.3 with `--fuzz=0` |
| Actual aggregate apply | `make -j1 patch` exits 0 and applies both pvxs files in sequence |
| Applied pvxs contents | All four changed files byte-identical to their upstream commit postimages |
| Actual aggregate revert | `make -j1 patch.revert` exits 0 |
| Source restoration | All four pvxs files byte-identical to their pre-apply contents; all 37 module Git statuses return to clean |
| Residue | No `.orig` or `.rej` before or after the round trip |

These checks used the shipped Makefile, patch files and revert implementation
against the actual prepared module sources. The verification leaves those
sources at their original pins; the new files apply at the next `make patch`.
Local command logs and byte-comparison results are retained in
`work/pvxs-carry-verify-a71e4p6p/`; this table records the durable outcome.

Builds, CI platform matrix, installed-tree `check.deps`, IOC functional proof
for the unmarked PUT, and reconnect-burst behavior remain unexecuted for this
candidate. Release D18 excludes upstream module test-suite execution; the
retained regression fixtures are upstream evidence, not a claimed local pass.
Use the authorized module cycle to establish installed behavior on Debian 13
and Rocky Linux 8.10. The source pin and prepared inventory remain unchanged.

## Raw score appendix

These 36 rows preserve all 288 original integer values. `codex_r1` through
`codex_r5` are independent delegates; `codex_root` is the frozen author-context
assessment. Every reviewer inspected all six commits. Common evidence and
candidate-specific differences are captured above; the raw numbers allow
independent reproduction of both median tables without a working directory.

| Reviewer | Commit | security | safety | bug | perf | ops | urgency | fit | locality |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| codex_r1 | a9f8b7b | 0 | 0 | 2 | 1 | 3 | 1 | 3 | 3 |
| codex_r1 | d23de00 | 4 | 3 | 6 | 0 | 6 | 4 | 4 | 4 |
| codex_r1 | 7176098 | 1 | 2 | 9 | 0 | 9 | 8 | 9 | 7 |
| codex_r1 | 96345dd | 0 | 1 | 3 | 4 | 6 | 3 | 10 | 9 |
| codex_r1 | 61e4230 | 0 | 0 | 0 | 0 | 2 | 0 | 7 | 10 |
| codex_r1 | 4311a85 | 0 | 0 | 0 | 0 | 2 | 0 | 6 | 10 |
| codex_r2 | a9f8b7b | 0 | 0 | 2 | 1 | 2 | 1 | 3 | 3 |
| codex_r2 | d23de00 | 5 | 3 | 7 | 0 | 6 | 4 | 4 | 3 |
| codex_r2 | 7176098 | 1 | 4 | 8 | 0 | 9 | 7 | 9 | 8 |
| codex_r2 | 96345dd | 0 | 1 | 4 | 5 | 7 | 3 | 9 | 9 |
| codex_r2 | 61e4230 | 0 | 0 | 0 | 0 | 2 | 0 | 8 | 10 |
| codex_r2 | 4311a85 | 0 | 0 | 0 | 0 | 2 | 0 | 6 | 10 |
| codex_r3 | a9f8b7b | 0 | 0 | 2 | 2 | 3 | 1 | 3 | 4 |
| codex_r3 | d23de00 | 4 | 4 | 6 | 0 | 5 | 3 | 4 | 4 |
| codex_r3 | 7176098 | 0 | 3 | 9 | 0 | 9 | 7 | 9 | 8 |
| codex_r3 | 96345dd | 0 | 1 | 4 | 4 | 7 | 3 | 9 | 9 |
| codex_r3 | 61e4230 | 0 | 0 | 1 | 0 | 2 | 0 | 8 | 10 |
| codex_r3 | 4311a85 | 0 | 0 | 1 | 0 | 2 | 0 | 7 | 10 |
| codex_r4 | a9f8b7b | 0 | 0 | 2 | 2 | 2 | 1 | 3 | 4 |
| codex_r4 | d23de00 | 4 | 3 | 5 | 0 | 5 | 3 | 4 | 5 |
| codex_r4 | 7176098 | 1 | 4 | 9 | 0 | 9 | 8 | 9 | 8 |
| codex_r4 | 96345dd | 0 | 2 | 3 | 5 | 7 | 3 | 10 | 9 |
| codex_r4 | 61e4230 | 0 | 0 | 0 | 0 | 2 | 0 | 7 | 10 |
| codex_r4 | 4311a85 | 0 | 0 | 0 | 0 | 2 | 0 | 6 | 10 |
| codex_r5 | a9f8b7b | 0 | 1 | 3 | 1 | 3 | 1 | 2 | 4 |
| codex_r5 | d23de00 | 4 | 4 | 6 | 0 | 6 | 5 | 4 | 4 |
| codex_r5 | 7176098 | 0 | 4 | 9 | 0 | 9 | 8 | 9 | 8 |
| codex_r5 | 96345dd | 0 | 2 | 3 | 5 | 6 | 4 | 9 | 8 |
| codex_r5 | 61e4230 | 0 | 0 | 1 | 0 | 2 | 0 | 8 | 10 |
| codex_r5 | 4311a85 | 0 | 0 | 0 | 0 | 2 | 0 | 7 | 10 |
| codex_root | a9f8b7b | 0 | 1 | 2 | 0 | 3 | 1 | 4 | 3 |
| codex_root | d23de00 | 2 | 3 | 6 | 0 | 6 | 4 | 5 | 4 |
| codex_root | 7176098 | 0 | 1 | 8 | 0 | 8 | 7 | 8 | 7 |
| codex_root | 96345dd | 0 | 1 | 3 | 5 | 5 | 3 | 9 | 8 |
| codex_root | 61e4230 | 0 | 0 | 0 | 0 | 2 | 0 | 9 | 10 |
| codex_root | 4311a85 | 0 | 0 | 0 | 0 | 1 | 0 | 8 | 10 |
