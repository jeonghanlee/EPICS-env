# Autosave R6-0 carry decision for EPICS-env 1.5.0

Decision date: 2026-10-30. The Maintainer selected `f5b7da3` and `49159fc`
as carry patches. The source pin remains `tags/R6-0`. This record covers
selection, patch generation, and local apply/revert verification. Module build,
installed-tree and IOC acceptance remain for the release cycle under D18 and
D19 of [the release record](milestone-1.5.0.md).

## Scope

This record gives the Maintainer the complete post-pin candidate set, independent
scores, dependencies, and source findings for a carry decision. The governing
rules are Stages 2b-5 of [the carry procedure](procedures/upstream-fix-carry-procedure.md).
The release still includes all 37 EPICS-env modules and siteApps/unidrv.

**Out of scope:** builds, installed-tree checks, and IOC acceptance.
Those follow the authorized module cycle under
[the release procedure](procedures/release-procedure.md).

## Source range and coverage

- Upstream: `https://github.com/epics-modules/autosave`.
- R6-0 baseline: `03b94f803be4e1844699a9c56562c96406242591`.
- Survey tip: `5e5957b984a97fc2dcc1202e163ef2ebf6de8f6d`, committed 2026-09-17.
- Remote observation on 2026-10-29: master remained at that tip; latest release
  tag remained R6-0.
- Base remains R7.0.10. All scored commits are upstream changes after the pin.

There are 21 commits in the range. Five documentation-only changes are excluded:
`92272df` (documentation reorganization), `b6184cd` (documentation formatting),
`940be79` (documented function presentation), `ff67d6f` (horizontal rules), and
`fefe474` (documented examples). The remaining 16 are all scored, including
include guards, ignore rules, version metadata, and dependency features.
`ca564b2` remains in the set because it changes a production header as well as
test syntax. No candidate was omitted for a low score or a suspected defect.

## Panel method

Five fresh-context reviewers independently examined the full set in batches of
three and two. They did not read one another's reports or scores. The Executor
froze a sixth assessment before reading any delegated result. All used the
inherited model; these are independent contexts, not different model families
or a statistical confidence estimate.

Each reviewer scored eight axes from 0 to 10: security (remote exposure reduced),
safety (memory safety and robustness), bug (functional correctness), perf
(runtime performance), ops (facility value), urgency (harm before the next bump),
fit (applicability and regression risk), and locality (narrow impact scores high).
Code validates all entries, computes each axis median, and sums those medians.
For six votes, the median is the average of the middle two values.
The recommendation rule is `total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`.
It is not a carry decision. Introduced defects remain relevant regardless of score.

The raw numbers and notes are retained in the [companion score file](autosave-carry-1.5.0-scores.json). They remain
unchanged when later source reconciliation corrects a finding; the corrected
technical conclusions below govern interpretation.

### Six assessments including the Executor

| Commit | Change | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule basis |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| f5b7da3 | Unknown errno diagnostics | 0 | 5 | 5 | 0 | 5 | 3.5 | 10 | 10 | 38.5 | bug, safety |
| 89e2489 | Remaining delay | 0 | 1 | 4.5 | 3 | 4.5 | 2.5 | 10 | 9 | 34.5 | none |
| 49159fc | Loaded configuration name | 0 | 0 | 5.5 | 0 | 6.5 | 3 | 8.5 | 8 | 31.5 | bug |
| ca564b2 | Macro and test parentheses | 0 | 1 | 2 | 0 | 2 | 1 | 10 | 10 | 26 | none |
| 66a251a | Version comparison | 0 | 0 | 3.5 | 0 | 3 | 1.5 | 8 | 9 | 25 | none |
| 970361c | Header guards | 0 | 0 | 2 | 0 | 2 | 1 | 10 | 9 | 24 | none |
| 8804347 | Generated release header | 0 | 0 | 3 | 0 | 4.5 | 1 | 6.5 | 9 | 24 | none |
| 5432670 | Cache string length | 0 | 0 | 0.5 | 2 | 1 | 0 | 10 | 10 | 23.5 | none |
| e59d846 | MIN/MAX guards | 0 | 0 | 2 | 0 | 2 | 0.5 | 9 | 9 | 22.5 | none |
| 8e4c0bb | Ignore installed iocsh | 0 | 0 | 0 | 0 | 1 | 0 | 10 | 10 | 21 | none |
| 5e5957b | Old-Base compatibility | 0 | 0 | 0 | 0 | 1 | 0 | 10 | 9 | 20 | none |
| 75ba4db | Release label 6.1 | 0 | 0 | 2 | 0 | 2.5 | 0 | 3.5 | 10 | 18 | none |
| bd94b1a | Dependency metadata | 0 | 0 | 1 | 0 | 3 | 0 | 6 | 5 | 15 | none |
| 186f467 | IOC dependency macros | 0 | 0 | 1 | 0 | 1.5 | 0 | 3.5 | 8 | 14 | none |
| 520b4ae | Long-string buffers | 0 | 1 | 3 | 0 | 3 | 1 | 1 | 4 | 13 | none |
| dcb3206 | Waveform save and verify | 0 | 0 | 2 | 0 | 3.5 | 1.5 | 0 | 3 | 10 | none |

### Five independent reviewers only

| Commit | Change | security | safety | bug | perf | ops | urgency | fit | locality | Total /80 | Rule basis |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| f5b7da3 | Unknown errno diagnostics | 0 | 5 | 5 | 0 | 5 | 4 | 10 | 10 | 39 | bug, safety |
| 89e2489 | Remaining delay | 0 | 1 | 4 | 3 | 4 | 2 | 10 | 9 | 33 | none |
| 49159fc | Loaded configuration name | 0 | 0 | 5 | 0 | 7 | 3 | 8 | 8 | 31 | bug |
| ca564b2 | Macro and test parentheses | 0 | 1 | 2 | 0 | 2 | 1 | 10 | 10 | 26 | none |
| 8804347 | Generated release header | 0 | 0 | 3 | 0 | 5 | 1 | 7 | 9 | 25 | none |
| 66a251a | Version comparison | 0 | 0 | 3 | 0 | 3 | 1 | 8 | 9 | 24 | none |
| 970361c | Header guards | 0 | 0 | 2 | 0 | 2 | 1 | 10 | 9 | 24 | none |
| 5432670 | Cache string length | 0 | 0 | 0 | 2 | 1 | 0 | 10 | 10 | 23 | none |
| e59d846 | MIN/MAX guards | 0 | 0 | 2 | 0 | 2 | 0 | 9 | 9 | 22 | none |
| 8e4c0bb | Ignore installed iocsh | 0 | 0 | 0 | 0 | 1 | 0 | 10 | 10 | 21 | none |
| 5e5957b | Old-Base compatibility | 0 | 0 | 0 | 0 | 1 | 0 | 10 | 9 | 20 | none |
| 75ba4db | Release label 6.1 | 0 | 0 | 2 | 0 | 3 | 0 | 4 | 10 | 19 | none |
| bd94b1a | Dependency metadata | 0 | 0 | 1 | 0 | 3 | 0 | 6 | 5 | 15 | none |
| 186f467 | IOC dependency macros | 0 | 0 | 1 | 0 | 2 | 0 | 4 | 8 | 15 | none |
| 520b4ae | Long-string buffers | 0 | 1 | 3 | 0 | 3 | 1 | 1 | 4 | 13 | none |
| dcb3206 | Waveform save and verify | 0 | 0 | 1 | 0 | 3 | 1 | 0 | 3 | 8 | none |

Both calculations meet the rule for exactly `f5b7da3` and `49159fc`; all 16 rule outcomes agree. `89e2489` ranks second by six-vote total but misses every OR condition. The Maintainer adopted exactly these two rule-pass candidates on 2026-10-30.

### Selection funnel

| Stage | Count |
| --- | ---: |
| Enumerated | 21 |
| Documentation-only exclusions | 5 |
| Scored | 16 |
| Returned assessments | 6 |
| Individual integer axis scores | 768 |
| Met rule, five-only and six-vote | 2 |
| Selected for carry | 2 |
| Added or removed by rule override | 0 |


## Source findings and constraints

### dcb3206: array type and verification capacity disagree

The new writer predicate compares `pchannel->field_type`, obtained from database
`DBADDR`, with the CA `DBF_CHAR` constant visible in `save_restore.c`.
Database CHAR is 1, database USHORT is 4, and CA CHAR is 4. The new branch therefore
selects database USHORT arrays as strings, while ordinary database CHAR arrays
continue through numeric array serialization. Saving USHORT bytes as text can
truncate values at NUL and loses the numeric array representation. The string
copy also lacks a bound tied to the source allocation.

Separately, `verify.c` correctly recognizes the CA CHAR type but reduces its
storage accounting to bytes even when the save file uses the existing `@array@`
format. It still calls `read_array` with DBF_STRING, whose parser writes
MAX_STRING_SIZE (40) bytes per element. The initial allocation is 400 bytes:
for a first 16-element CHAR array, a read buffer beginning at offset 16 can
receive 640 bytes of string slots. This is a source-derived capacity mismatch,
not an executed overflow.

Evidence at the surveyed tip: `asApp/src/save_restore.c:1850`,
`asApp/src/dbrestore.c:1332`, and `asApp/src/verify.c:110`, `:158`, `:166`,
`:173`, `:197`, `:575`, and `:588`. Base R7.0.10 sources:
`modules/database/src/ioc/dbStatic/dbFldTypes.h:24` and
`modules/ca/src/client/db_access.h:61`.
The shipped `asApp/Db/SR_test.db` contains both CHAR and USHORT waveform fixtures.
Recommendation: defer this raw patch pending correction and real save/restore
and verifier checks using those fixtures.

### 520b4ae: long-link allocation and character transfer use different views

Base R7.0.10 already supports the `$` field modifier. A link field with `$`
exposes a 1024-character view; without it, database metadata describes one
native DBLINK structure. The patch strips `$` before allocating from database
metadata, then requests up to 200 DBR_CHAR elements through the original CA
name. It never compares that request against the allocated native field size.
The earlier 200-byte allocation branch does not cover this route because it
tests the original CA count before metadata changes.

Evidence: tip `asApp/src/save_restore.c:1327`, `:1337`, `:1350`, `:1365`,
`:1533`, `:1550`, and `:1582`; Base `modules/database/src/ioc/db/dbAccess.c:635`
and `:681`, `modules/libcom/src/misc/dbDefs.h:79`, and
`modules/database/src/ioc/dbStatic/link.h:194`.
This is a source-grounded risk; native ABI size and an actual overrun have not
been measured. Recommendation: defer the raw patch pending consistent sizing
and a real long-link and late-connection check.

### Other candidate limits

- `89e2489` repairs the sign of the remaining delay. Base clamps negative
  `ca_pend_event` delay to zero, but autosave also waits on its message queue.
  No universal busy loop, CPU reduction, or timing improvement was measured.
- `f5b7da3` initializes diagnostic buffers for unhandled errno values before
  printing them. It addresses an error-reporting path, not filesystem permissions.
- `49159fc` adds a status-gated current-name copy to all 11 configMenu load
  paths. Structural coverage is 11/11; asynchronous IOC sequencing is untested.
- `66a251a` fixes version comparison. Its alias-check caller computes
  `searchRecord` outside the per-record loop, so it is not a complete alias
  filtering fix and its operational benefit should not be overstated. Version-macro
  availability in the compiled translation unit was not established by a build or
  preprocessing run; expression correctness alone does not establish Linux behavior.
- `8804347` uses a header already generated at R6-0, but inherits the configured
  5.10.3 value. `75ba4db` changes that value to 6.1, which does not truthfully
  identify an arbitrary selected R6-0 carry set. Any labeling change needs a
  separate Maintainer decision.
- `5e5957b` enables its compatibility fallback only below Base 7.0.3.1;
  the pinned Base 7.0.10 does not use it.

### Reconciliation of initial findings

Source checks corrected three initial interpretations. First, the new writer
branch targets database USHORT, not database CHAR, because the two type
namespaces differ. Second, `asVerify` initially allocates 400 bytes, so the
claim that `svalue[199]` alone overruns a first two-element waveform allocation
is rejected; the legacy array parser mismatch above remains. Third, Base's
`configure/CONFIG:108-124` automatically includes installed dependency
`cfg/CONFIG*` files, so the Executor's claimed missing include path for
`186f467` is rejected. Its real dependency on `bd94b1a` remains.

The frozen raw assessments retain their original notes and scores. These
corrections prevent a mistaken detail or reviewer majority from becoming the
technical conclusion. No score was silently revised after comparison.

## Dependencies and downstream consumers

| Relationship | Evidence | Decision implication |
| --- | --- | --- |
| `8e4c0bb` before `bd94b1a` | Executed zero-fuzz context failure and successful pair | Required by the exact raw `.gitignore` hunk; not a runtime dependency |
| `bd94b1a` before `186f467` | Source definitions and Base cfg discovery | Install the macro producer before the example IOC consumes it |
| `8804347` with release identity | Existing generator and configured value | Header generation exists; version labeling is a separate decision |
| Overlapping source edits | All 16 applied in upstream order | Recheck the actual selected subset and its order before shipping |

Shared-file groups are `save_restore.c` (`89e2489`, `f5b7da3`, `8804347`,
`dcb3206`, `520b4ae`), `save_restore.h` (`ca564b2`, `e59d846`, `970361c`),
`configMenuSub.c` (`e59d846`, `5432670`), and `.gitignore` (`8e4c0bb`,
`bd94b1a`). File overlap alone does not make `dcb3206` a prerequisite of
`520b4ae`; both apply independently to the pin.

The release build graph declares autosave dependencies for busy, scaler, mca,
and measComp. Source scans across the combined 39-module inventory also found
runtime references, including the installed siteApps autosave IOC-shell scripts.
No direct autosave header/link/runtime match was found in unidrv. A source match
does not establish that a particular IOC is enabled or that installed-tree
validation has passed. These consumers remain relevant to later cycle verification.

## Verification boundary and Maintainer decision

Executed checks used real source exported from immutable Git objects: all 16
raw diffs matched those objects; 15 of 16 standalone zero-fuzz dry-runs passed;
the one failure was the documented `.gitignore` context. All 16 applied in
upstream order, and the isolated context prerequisite pair passed. The actual
baseline Python test file failed syntax parsing; the patched file parsed.
All 11 configMenu copy paths were checked structurally. These results establish
source applicability and structure only.

No C build, IOC execution, CA save/restore scenario, sanitizer, runtime timing,
or installed-tree acceptance ran. Static regression findings are not reproduced
crashes. The selected subset has its own application and revert results below;
build, functional and release-cycle verification remain pending. The full
candidate scratch stack is not a proposed carry list.

## Maintainer decision and ordered apply-selection list

On 2026-10-30 the Maintainer selected both recommended fixes: initialize
unknown-errno diagnostics and update the configMenu name after a successful
load. No rule-miss was added and no rule-pass was removed. The other 14 scored
commits are not carried in this set; their scores and constraints remain above.
In particular, `dcb3206` and `520b4ae` remain deferred with unresolved source
risks, and the release label remains unchanged.

| Order | Commit | Title | Total /80 | Basis | Overlap with selected set |
| --- | --- | --- | ---: | --- | --- |
| 1 | `f5b7da398ae5ef3a4cf16efdfacc86a0507de158` | Initialize unknown-errno diagnostics | 38.5 | bug, safety | none |
| 2 | `49159fc9ba1b34e1a66f7f4cad506916d1de5af1` | Update name on successful load | 31.5 | bug | none |

The selected commits modify `asApp/src/save_restore.c` and
`asApp/Db/configMenu.db`, respectively. Neither requires another post-pin
commit or introduces a new build dependency. The second uses the existing
configMenu `status`, `name`, `currName` and sseq load paths. Full upstream
hunks are retained without curation.

## Patch generation and local verification

The patch files retain the complete raw `git diff --no-prefix <sha>^ <sha>`
output, with no added header or dropped hunk:

| Order | Patch file |
| --- | --- |
| 1 | `6.0.0-01-f5b7da3-unknown-errno.p0.patch` |
| 2 | `6.0.0-02-49159fc-configmenu-loaded-name.p0.patch` |

The `6.0.0` prefix follows `SRC_VER_AUTOSAVE` for the unchanged `tags/R6-0`
pin. `patch.autosave.commit.apply` uses the sorted version-anchored glob;
`patch.autosave.commit.revert` reverses that list through the shipped
`tools/revert_patch.bash`. Both targets are wired into the aggregate targets
in `configure/RULES_SRC`, whose revert list reverses the apply list.
[The patch summary](../patch/README.md) has one row for each file.
Re-examine both patches when the autosave pin changes.

Executed locally on 2026-10-30 against the actual prepared module sources:

| Check | Observed result |
| --- | --- |
| Patch provenance | Both files are byte-identical to the complete upstream no-prefix diffs |
| Forward and reverse dry-runs | Both patches exit 0 with `--fuzz=0` in their appropriate source state |
| Aggregate apply | `make -j1 patch` exits 0 and applies both autosave patches in order |
| Applied autosave changes | Exactly `asApp/src/save_restore.c` and `asApp/Db/configMenu.db`; applied hunks match the selected upstream diffs |
| Aggregate revert | `make -j1 patch.revert` exits 0 |
| Source restoration | All 37 module Git statuses return to clean; the 12,737 tracked regular files compared across their root indexes have identical before/after hashes |
| Residue | No `.orig` or `.rej` files before or after the round trip |
| Unapplied autosave revert | Exits 0 and skips both already-unapplied patches |
| Nonmatching version glob | Both autosave legs exit 0 without applying or reverting a patch |

Command output, the actual applied source diff and hash comparisons are in
`work/autosave-carry-verify-aw6nopog/`; this table retains the outcome.
The prepared module sources are restored to their pins. The new carry files
will be applied by the next `make patch`.

## Remaining functional verification and completion reviews

The module cycle must verify unknown-errno diagnostic output through the
actual autosave path and configMenu's successful-load name update, including
failure behavior and all 11 load routes. Source inspection and patch application
do not establish these runtime results. Builds, installed-tree checks, and
IOC acceptance on Debian 13 and Rocky Linux 8.10 remain pending under D18/D19;
no upstream test-suite execution is planned.

After functional verification, run the carry procedure's third-person review
of the complete result, then its second-person review of the documentation.
Both completion reviews and their finding dispositions remain pending and must
be recorded here or in the module's milestone entry before marking the patches
complete. The current result is patch preparation and apply/revert verification,
not completed module acceptance.



## Pre-build review results

On 2026-10-30, independent third-person verification and then second-person
reader review of the selected patch preparation both passed with zero
must-fix, minor, info, hygiene or out-of-scope findings. The implementation
and document contents were unchanged between the two passes; this result
paragraph was appended afterward. No corrective change was required.

The third-person pass repeated actual aggregate apply/revert, checked failure
propagation for a missing source directory, and confirmed restoration. The
second-person pass independently checked the numerical tables, links,
selection, patch order and distinction between proven and pending work.
These are cumulative reviews 7 and 8 of the autosave carry work; the six earlier
passes assessed candidates. This pre-build review does not replace the
post-functional completion reviews specified above.
