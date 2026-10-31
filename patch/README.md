# Patch Set

Patches applied to the fetched module sources by `make patch` and removed
by `make patch.revert` ([`configure/RULES_SRC`](../configure/RULES_SRC),
[`configure/RULES_PATCH`](../configure/RULES_PATCH)).
All files are `p0` diffs generated with `git diff --no-prefix` and applied
with `patch -p0 --ignore-whitespace` from the module source root (the pvxs, autosave, linStat, modbus, sscan
and StreamDevice carry rules add `--no-backup-if-mismatch`).

The patch tracks and file kinds are:

| Kind | File pattern | Applied by | Lifecycle key |
| :-- | :-- | :-- | :-- |
| Carry patch, epics-base | `7.0.10-pr<NNNN>-<slug>.p0.patch` (PR unit) or `7.0.10-<NN>-<sha>-<slug>.p0.patch` (direct-commit unit) | `patch.base.pr.apply`, glob `$(SRC_VER_BASE)-*.p0.patch`, C-locale ascending | base pin 7.0.10 |
| Carry patch, pvxs | `<pvxs_version>-<NN>-<sha>-<slug>.p0.patch` | `patch.pvxs.commit.apply`, ascending `NN` = upstream merge order | pvxs pin 1.5.3; two post-release commits carried |
| Carry patch, autosave | `<autosave_version>-<NN>-<sha>-<slug>.p0.patch` | `patch.autosave.commit.apply`, ascending `NN` = upstream merge order | autosave pin R6-0, version 6.0.0; two post-release commits carried |
| Carry patch, linStat | `<linstat_version>-<NN>-<sha>-<slug>.p0.patch` | `patch.linStat.commit.apply`, ascending `NN` = upstream merge order | linStat pin 1.2.1; five post-release commits carried |
| Site patch, linStat | `<linstat_version>-site<NN>-<slug>.p0.patch` | `patch.linStat.commit.apply`, same version glob after the carries | linStat pin 1.2.1; RTC parse and DST correction |
| Carry patch, modbus | `<modbus_version>-<NN>-<sha>-<slug>.p0.patch` | `patch.modbus.commit.apply`, ascending `NN` = upstream merge order | modbus pin R3-4, version 3.4.0; one post-release commit carried, curated |
| Carry patch, sscan | `<sscan_version>-<NN>-<sha>-<slug>.p0.patch` | `patch.sscan.commit.apply`, ascending `NN` = upstream merge order | sscan pin ce9660c; one post-pin commit carried |
| Carry patch, StreamDevice | `<stream_version>-<NN>-<sha>-<slug>.p0.patch` | `patch.StreamDevice.commit.apply`, ascending `NN` = upstream merge order, before the two local StreamDevice patches | StreamDevice pin 2.8.26; one post-release commit carried |
| Site patch, epics-base | `7.0.10-site<NN>-<slug>.p0.patch`; `7.0.10-<NN>-site-<slug>.p0.patch` when it must apply before the PR units | `patch.base.pr.apply`, the same glob; the `site<NN>` form sorts after the carry patches | base pin 7.0.10 |
| Site patch, other module | `<module>-<slug>.p0.patch` | one named `patch.<name>.apply` rule each, such as `patch.measComp.tc32.apply` | the module pin it targets |
| Local build patch | `<module>-<slug>.p0.patch` | one named `patch.<name>.apply` rule each, such as `patch.measComp.apply` | the module pin it targets |

A carry patch holds an upstream fix merged after the pinned version, taken
from the module's upstream branch because no upstream release above the pin
contains it yet. Every carry patch is selected by the procedure in
[`docs/procedures/upstream-fix-carry-procedure.md`](../docs/procedures/upstream-fix-carry-procedure.md):
applicability gate at the pinned version, then a five-reviewer panel scoring
eight axes (security, safety, bug, perf, ops, urgency, fit, locality; 0-10
each, per-axis median), then the adoption rule (ADOPT when ANY of
`total >= 40/80`, `bug >= 5`, `safety >= 5`, `urgency >= 5` holds), then the
maintainer's decision, which may add or remove a fix with a recorded reason.
The full score tables, the swept and deferred fixes, and the maintainer
decisions are in [`docs/archive/base-carry-1.3.0.md`](../docs/archive/base-carry-1.3.0.md);
the table below summarizes the outcome per file. The retired pvxs carry patches
keep their record in [`docs/archive/pvxs-carry-1.3.0.md`](../docs/archive/pvxs-carry-1.3.0.md).
The current pvxs selection, including the Maintainer-requested sixth
assessment, is recorded in
[`docs/pvxs-carry-1.5.0.md`](../docs/pvxs-carry-1.5.0.md).

Downstream patches are recorded against the pinned version exactly. When a
pin moves, every downstream patch is re-examined (a carry patch dropped if
upstream now contains it, a site patch dropped if upstream now has the fix,
either one re-based if the region moved) before the new version ships; see
"Bump obligation" in
[`docs/procedures/upstream-fix-carry-procedure.md`](../docs/procedures/upstream-fix-carry-procedure.md)
and "Base-bump obligation" in
[`docs/archive/base-carry-1.3.0.md`](../docs/archive/base-carry-1.3.0.md).

## epics-base 7.0.10 carry (18)

Apply order is the file-name sort order. `Basis` lists the adoption
conditions met by the per-axis median; `maintainer` marks a maintainer
decision. `Record` names the run without the identifier of an item in a
release record: `1.3.0 initial run` for the initial run
([`docs/archive/base-carry-1.3.0.md`](../docs/archive/base-carry-1.3.0.md)) or the refresh's label and date
(`Carry refresh 2026-09-03`).

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `7.0.10-01-b2d2758-putnotify-type-check` | commit `b2d2758` (no PR) dbPutNotifyBlocker type check | 39 | bug, safety | Carry refresh 2026-08-21 |
| `7.0.10-pr0817-mbbi-cosv-aftc` | epics-base/epics-base#817 mbbiRecord COSV/LALM + AFTC (record hunk only) | 37 | bug, urgency | 1.3.0 initial run |
| `7.0.10-pr0837-maclib-delim` | epics-base/epics-base#837 macLib mismatched delimiters | 39 | bug, urgency | 1.3.0 initial run |
| `7.0.10-pr0870-strprintescaped-unterminated` | epics-base/epics-base#870 epicsStrPrintEscaped OOB read | 38 | bug, safety, urgency | 1.3.0 initial run |
| `7.0.10-pr0890-makerpath-failhard` | epics-base/epics-base#890 configure: fail hard when makeRPath errors | 25 | bug; maintainer (guards the empty `$ORIGIN` runpath trap) | 1.3.0 initial run |
| `7.0.10-pr0904-carepeater-uaf` | epics-base/epics-base#904 caRepeaterThread use-after-free | 42 | total, bug, safety | 1.3.0 initial run |
| `7.0.10-pr0913-histogram-oob` | epics-base/epics-base#913 histogramRecord heap OOB write | 51 | total, bug, safety, urgency | 1.3.0 initial run |
| `7.0.10-pr0914-printf-ls-overflow` | epics-base/epics-base#914 printfRecord `%ls` VAL overflow | 46 | total, bug, safety, urgency | 1.3.0 initial run |
| `7.0.10-pr0915-ringbytes-hwm` | epics-base/epics-base#915 epicsRingBytes high-water-mark operands | 30 | bug | 1.3.0 initial run |
| `7.0.10-pr0918-iocsh-onerror-wait` | epics-base/epics-base#918 iocsh `on error wait` parse | 39 | bug, urgency | 1.3.0 initial run |
| `7.0.10-pr0919-dbconvert-uint64-string` | epics-base/epics-base#919 dbConvert UInt64 to String truncation | 37 | bug, urgency | 1.3.0 initial run |
| `7.0.10-pr0920-dbstatic-uint64` | epics-base/epics-base#920 dbStaticLib UINT64 read through 32-bit pointer | 46 | total, bug, safety, urgency | 1.3.0 initial run |
| `7.0.10-pr0922-dbjlink-assign-compare` | epics-base/epics-base#922 dbJLink assignment-instead-of-compare | 37 | bug, urgency | 1.3.0 initial run |
| `7.0.10-pr0932-ca-input-validation` | epics-base/epics-base#932 database/CA client input validation | 46 | total, bug, safety, urgency | 1.3.0 initial run |
| `7.0.10-pr0934-rsrv-msg-validation` | epics-base/epics-base#934 RSRV message validation | 52 | total, bug, safety, urgency | 1.3.0 initial run |
| `7.0.10-pr0935-caget-null` | epics-base/epics-base#935 caget missing NULL check | 35 | safety | 1.3.0 initial run |
| `7.0.10-pr0948-dbchannel-put-timestring` | epics-base/epics-base#948 dbChannel_put DBR_TIME_STRING | 37 | bug | Carry refresh 2026-08-21 |
| `7.0.10-pr0949-rsrv-scalar-string-put` | epics-base/epics-base#949 RSRV scalar-string PUT (fixes epics-base/epics-base#943, a regression of the carried epics-base/epics-base#934) | 51 | total, bug, safety, urgency | Carry refresh 2026-09-03 |

Deferred at the applicability gate (no target code at R7.0.10; re-enter on a
base bump): epics-base/epics-base#917 errlog OOB read, epics-base/epics-base#856 dbCa iocInit wait. Scored and
dropped: commit `6cf9fe9d8` Repeater announcement silence (total 22).

## pvxs 1.5.3 carry (2)

Apply order is the file-name sort order. Totals are the sum of per-axis
medians across five independent reviewers and the Executor's frozen sixth
assessment, as requested by the Maintainer; the five-reviewer comparison is
in the [decision record](../docs/pvxs-carry-1.5.0.md).

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `1.5.3-01-7176098-single-put-marked-value` | commit `7176098` single PUT writes only a marked value | 46.5 | total, bug, urgency | 1.5.0 initial run |
| `1.5.3-02-96345dd-tcp-listener-backlog` | commit `96345dd` adjust TCP listener backlog | 36.5 | maintainer (increase pending-connection capacity on non-RTOS targets) | 1.5.0 initial run |

Scored and not carried: `a9f8b7b` (13.5) and `d23de00` (31), deferred as a
configuration pair because the latter needs the former and the refactor
exposes a malformed-name-server path requiring runtime verification. The
documentation-only commits `61e4230` (20) and `4311a85` (18.5) were scored by
request but remain excluded from code carries. No selected patch has an
unmet applicability prerequisite. Build and runtime acceptance remains for
the module cycle; see the decision record's verification status.

## autosave R6-0 carry (2)

File prefix `6.0.0` is `SRC_VER_AUTOSAVE` for `tags/R6-0`. The apply glob
`$(SRC_VER_AUTOSAVE)-*.p0.patch` follows filename order; revert reverses it.
Totals use five independent reviewers and the Executor's frozen sixth
assessment. The [decision record](../docs/autosave-carry-1.5.0.md) preserves
the five-only comparison and the Maintainer's selection.

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `6.0.0-01-f5b7da3-unknown-errno` | commit `f5b7da3` add default error message | 38.5 | bug, safety | 1.5.0 initial run |
| `6.0.0-02-49159fc-configmenu-loaded-name` | commit `49159fc` update name on successful load | 31.5 | bug | 1.5.0 initial run |

Of 21 post-pin commits, five documentation-only changes were excluded and
all 16 remaining commits were scored. The other 14 scored commits are not
carried; all miss the rule. In particular, `dcb3206` and `520b4ae` have
unresolved array representation or buffer-sizing risks. None was removed at
the applicability gate, and neither selected patch needs another post-pin
commit. Build and IOC functional acceptance remain for the module cycle.

## linStat 1.2.1 carry (5)

The version-anchored glob `$(SRC_VER_LINSTAT)-*.p0.patch` applies these five
carries before the RTC site correction below. Revert uses the exact reverse
order. Totals use per-axis medians from five independent reviewers; the
[decision record](../docs/linstat-carry-1.5.0.md) preserves the complete set.

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `1.2.1-01-78b6138-netstat-path` | commit `78b6138` simplify netstat path storage | 21 | maintainer (include small cleanup) | 1.5.0 initial run |
| `1.2.1-02-6ea15c7-rtc-status` | commit `6ea15c7` add RTC status | 13 | maintainer (RTC monitoring, site correction required) | 1.5.0 initial run |
| `1.2.1-03-7576edc-host-opi` | commit `7576edc` update Host OPI | 16 | maintainer (display selected RTC monitoring) | 1.5.0 initial run |
| `1.2.1-04-e48e077-install-config` | commit `e48e077` separate-install configuration | 28 | bug | 1.5.0 initial run |
| `1.2.1-05-df0f547-nic-prefix` | commit `df0f547` independent NIC P prefix | 30 | bug | 1.5.0 initial run |

All six post-pin commits were scored; none was removed as documentation, CI,
tests or a missing target. The remaining `8e6d08a` filesystem refactor (25)
is excluded. The OPI requires the RTC producer; RTC does not require the
excluded filesystem refactor. Full module/IOC and visual acceptance remain
for the module cycle. Re-examine both carries and the site patch on a pin change.

## modbus R3-4 carry (1)

File prefix `3.4.0` is `SRC_VER_MODBUS` for `tags/R3-4`. The apply glob
`$(SRC_VER_MODBUS)-*.p0.patch` follows filename order; revert reverses it.
Totals are per-axis medians from five independent reviewers. The
[decision record](../docs/modbus-carry-1.5.0.md) preserves the complete set.

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `3.4.0-01-4e39e7a-readfloat64array-debug-loop` | commit `4e39e7a` curated: Windows min/max guard, Float64 debug-loop removal, explicit cast; the two size_t-to-int bound changes are omitted | 36 | bug, safety, urgency; maintainer (curated: both size_t-to-int bound changes omitted) | 1.5.0 initial run |

Of 16 post-pin commits, four documentation-only changes were excluded, three
merge commits were represented by their constituents, and the remaining nine
were scored. The other eight scored commits are not carried; all miss the
rule. The omitted bound changes narrow a `size_t` capacity to `int`; at capacities
above 2147483647 the request or the reported element count is wrong for five
of six tested values (see the decision record). The score rates the
whole upstream commit, not the curated file. None was removed at the
applicability gate. Build and IOC functional acceptance remain for the module
cycle. Re-examine the carry on a pin change.

## sscan ce9660c carry (1)

File prefix `ce9660c` is `SRC_VER_SSCAN` for the pinned commit `ce9660c`. The
apply glob `$(SRC_VER_SSCAN)-*.p0.patch` follows filename order; revert reverses
it. Totals are per-axis medians from five independent reviewers. The
[decision record](../docs/sscan-carry-1.5.0.md) preserves the complete set.

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `ce9660c-01-b28ac30-checkrwpermission-tmpfile-size` | commit `b28ac30d` fix path truncation due to hard-coded tmpfile size in checkRWpermission() | 36 | bug | 1.5.0 initial run |

Of four post-pin commits, two are merge commits represented by their
constituents and two were scored. The other scored commit, `f5f4c90d`, is not
carried; it misses the rule and matters in practice only for vxWorks. None was removed at
the applicability gate. Build and IOC functional acceptance remain for the
module cycle. Re-examine the carry on a pin change.

## StreamDevice 2.8.26 carry (1)

File prefix `2.8.26` is `SRC_VER_STREAM` for `tags/2.8.26`. The apply glob
`$(SRC_VER_STREAM)-*.p0.patch` follows filename order; `patch.StreamDevice.commit.apply`
runs before the two local StreamDevice patches, which keep their own rules,
and revert reverses it. Totals are per-axis medians from five independent
reviewers. The [decision record](../docs/streamdevice-carry-1.5.0.md) preserves the complete set.

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `2.8.26-01-562dd5a-scalcout-sval-size` | commit `562dd5ad` fix string truncation in scalcout SVAL | 41 | total, bug, urgency | 1.5.0 initial run |

Of 19 post-pin commits, six documentation or CI changes were excluded and the
remaining 13 were scored. The other 12 are not carried; all miss the rule. Two
of them touch what the local patches already cover: `e87e093c` would replace
`StreamDevice-no-vxi11` and cannot be applied with it, and `f473f4d6` repeats
the change of `StreamDevice-dbd-tab`. Both local patches stay. None was removed
at the applicability gate. Build and IOC functional acceptance remain for the
module cycle. Re-examine the carry and both local patches on a pin change.

## linStat 1.2.1 site patches (1)

### 1.2.1-site01-rtc-parse-dst

`1.2.1-site01-rtc-parse-dst.p0.patch` changes `statApp/src/tblRTC.cpp`
after the upstream RTC addition. Both changes are local corrections to
the selected RTC feature, not additional scored upstream commits.

| Item | Content |
| :-- | :-- |
| Case | Malformed RTC date/time, or an RTC using local time during DST |
| Effect without the patch | Failed strptime is dereferenced; native execution reports null-load UB. A correct local DST input reports a false 3600-second difference. |
| Change | Check the parse pointer and complete conversion before use; set tm_isdst to -1 for the local mktime candidate. |
| Result with the patch | Invalid/incomplete inputs omit delta/ref without crashing. Summer local time reports zero difference; UTC, winter and nonambiguous transition cases pass. |
| Reproduction | Run `tools/linstat-carry/verify.py` with the pinned source, an installed Base and a new work directory; the decision record provides the command. |
| Tested | Real RTC factory/lookup/Transaction source with Base 7.0.10 on the local Linux host, 2026-10-30. Only filesystem inputs and the OS clock boundary are controlled. |
| Upstream | Local correction to 6ea15c7; absent from surveyed tip df0f547. No upstream submission is claimed. |

The verifier confirms the controlled clock reaches the actual Transaction,
reproduces both upstream failures, and passes 20 corrected RTC cases. It does
not run an IOC or prove hardware behavior. DST's repeated local hour remains
ambiguous without an offset, and impossible calendar dates are not newly
validated by this narrow correction. These limits remain explicit in the
decision record.

## epics-base 7.0.10 site patches (3)

A site patch holds a fix for a bug in the module itself that no upstream
release contains yet, and its name has no PR number and no commit. It applies and
reverts with the carry patches and, like them, stops applying when the base
pin moves.

### 7.0.10-site01-dbyacc-eof

`7.0.10-site01-dbyacc-eof.p0.patch` changes `yyerror` in
`modules/database/src/ioc/dbStatic/dbYacc.y`.

| Item | Content |
| :-- | :-- |
| Case | A database definition or database file ends inside an open construct, for example `recordtype(x) {` without its closing brace, `field(` without its end, or `device(ai, CONSTANT, devX` without `)`. The parser reports the error after the last input file is closed, and `yyerror` reads `pinputFileNow->line_num` through a null pointer. |
| Effect without the patch | `softIoc` and `softIocPVX` print `ERROR: syntax error` and end with a segmentation fault, status 139. A syntax error before the end of the file is reported normally. |
| Reproduction | Write the one line `recordtype(x) {` to `x.dbd`, write `dbLoadDatabase("x.dbd")` to `x.cmd`, and run `softIoc -D <base>/dbd/softIoc.dbd x.cmd < /dev/null`. |
| Change | When no input file is open, `yyerror` prints ` at end of input` and returns; it reads neither `yytext`, which no longer holds input text at that point, nor the line buffer. |
| Result with the patch | The same commands print `ERROR: syntax error` and ` at end of input`; with `on error break` the startup ends with status 2 and `iocInit` does not run. |
| Tested | EPICS base R7.0.10 with the carry patches, on Debian 13 with GCC 14.2.0 and on Rocky Linux 8.10 with GCC 8.5.0, 2026-10-04. |
| Upstream | The read was added by commit `f9e53dded658b21bbf93155766fe34085ec47099`, "show buffered line along with DB parse error", first released in R7.0.9; the `7.0` branch held the same code on 2026-10-04. R7.0.8 and earlier do not have it. |

### 7.0.10-site02-dbstatic-device-menu

`7.0.10-site02-dbstatic-device-menu.p0.patch` changes the field-name
suggestion of `dbRecordField` in
`modules/database/src/ioc/dbStatic/dbLexRoutines.c`.

| Item | Content |
| :-- | :-- |
| Case | A database file loads a record whose name already exists with another record type and then sets a field that the existing type lacks, for example `record(calc, "T:X") {}` followed by `record(ai, "T:X") { field(INP, "@x") }`. |
| Effect without the patch | `softIoc` and `softIocPVX` print the loader errors and end with a segmentation fault, status 139, in `dbRecordField` at `dbLexRoutines.c:1345`. |
| Reproduction | Write the two records to `a.db` and `b.db`, write `dbLoadRecords("a.db")` and `dbLoadRecords("b.db")` to `x.cmd`, and run `iocsh.bash x.cmd < /dev/null`. |
| Change | The suggestion walks the fields of the existing record type. For the device type field of a record type without device support the device menu is NULL; the patch takes no choices from a missing menu instead of reading it. |
| Result with the patch | The same commands print the loader errors and `Failed to load` and end without a fault; the messages of the cases that did not fault are unchanged. |
| Tested | EPICS base R7.0.10 with the carry patches, on Debian 13 with GCC 14.2.0 and on Rocky Linux 8.10 with GCC 8.5.0, 2026-10-06. |
| Upstream | The `7.0` branch held the same code on 2026-10-05. |

### 7.0.10-site03-lsi-udf

`7.0.10-site03-lsi-udf.p0.patch` changes `read_string` in
`modules/database/src/std/dev/devLsiSoft.c`.

| Item | Content |
| :-- | :-- |
| Case | A `lsi` record with `DTYP="Soft Channel"` reads a value from a link that is not a constant, for example `INP="raw.VAL$"` from another `lsi`. |
| Effect without the patch | The value, `LEN`, and `TIME` are updated and `STAT` and `SEVR` stay `NO_ALARM`, but `UDF` stays 1. A `lsi` raises no `UDF_ALARM`, so only a read of the `UDF` field shows it. The input record contract in `dbCommonInput.dbd.pod` says that the soft device support sets `UDF` to `FALSE` when the link returned a value, and the soft device supports of the other input records do, for example `devSiSoft.c` of `stringin`. |
| Reproduction | Load `record(lsi, "raw") {field(SIZV, "256")}` and `record(lsi, "public") {field(SIZV, "256") field(DTYP, "Soft Channel") field(INP, "raw.VAL$")}`, write a 63-character string to `raw.VAL$`, process `public`, and read `public.UDF`. |
| Change | After a read that returned a value from a link that is not a constant, `read_string` sets `UDF` to `FALSE`. The condition is the one of `read_stringin` in `devSiSoft.c` plus `prec->len`: `dbGetLinkLS()` returns 0 without touching the buffer or `LEN` when the link is not connected (`dbGetLinkLS()` in `dbLink.c`), where `dbGetLink()` returns -1 with a `LINK` alarm, so the `stringin` condition alone would also clear `UDF` for an unconnected CA link. |
| Result with the patch | `public.UDF` is 0 after the read; `LEN` stays 63 and `STAT` stays `NO_ALARM`. For a constant `INP`, no `INP`, and an unconnected CA link, `UDF` is 0, 1, and 1, the same values a `stringin` shows in the same IOC. |
| Tested | The comparison above with the base rebuilt once with every downstream patch reverted and once with all applied: EPICS base R7.0.10 on Debian 13 with GCC 14.2.0, and R7.0.11 on Debian 13 and on Rocky Linux 8.10 with GCC 8.5.0, 2026-10-27. In each run `public.UDF` is 1 without the patch and 0 with it; the four link cases above were run on Rocky Linux 8.10 with R7.0.11. `make patch` and `make patch.revert` return the source to the pinned state. |
| Upstream | `devLsiSoft.c` of R7.0.11 has no `UDF` handling either; its read path has never cleared `UDF` since the record type was added in 2012 (e01a42805), and the two other callers of `dbGetLinkLS()` in base, `lsoRecord.c` and the `lsi` simulation path, clear `UDF` on a zero return without the length guard. Reported as epics-base/epics-base#1031 on 2026-10-27, asking whether the behavior is intended; the patch stays until a base release settles it. Tracked as issue #112 of this repository. |

## measComp c38974e site patches (1)

The patch is applied by its own rule, `patch.measComp.tc32.apply`. When the
measComp pin moves, the rule fails `make patch` wherever the patch does not
apply to the changed source.

### measComp-tc32-chan-count

`measComp-tc32-chan-count.p0.patch` changes the constructor of `MultiFunction`
in `measCompApp/src/drvMultiFunction.cpp`.

| Item | Content |
| :-- | :-- |
| Case | A TC-32 or E-TC32 without the EXP-32 expansion. `ulAIGetInfo(AI_INFO_NUM_CHANS_BY_TYPE, AI_TC)` returns the thermocouple channel count including the EXP-32 expansion channels, so `numTemperatureIn_` is twice the number of channels that exist. |
| Effect without the patch | The driver reports twice the thermocouple channel count and polls channels that do not exist. |
| Reproduction | Attach a TC-32-family unit without the EXP-32 expansion and start an IOC with the measComp multi-function driver for it. |
| Change | For `USB_TC32`, the constructor reads `ulDevGetConfig(DEV_CFG_HAS_EXP)` and, when the unit has no expansion, halves `numTemperatureIn_`; the count is unchanged when the flag is nonzero or the query fails. |
| Result with the patch | An E-TC32 on the production environment reports 32 temperature inputs, shows no `err=14` over about 2000 poll cycles, and keeps its readings within 0.04 C of the baseline (2026-09-23). |
| Tested | `make patch` and `make patch.revert` return the source to the pinned state (2026-09-21); all seven OS workflows pass with the patch applied (2026-09-22); the E-TC32 check above (2026-09-23). The 64-input path with EXP-32 is not tested, since no unit with the expansion is available. |
| Upstream | Tracked as epics-modules/measComp#39; the patch stays until a measComp release includes it. |

## StreamDevice 2.8.26 site patches (1)

The patch is applied by its own rule, `patch.StreamDevice.dbd-tab.apply`.
When the StreamDevice pin moves, the rule fails `make patch` wherever the
patch does not apply to the changed source.

### StreamDevice-dbd-tab

`StreamDevice-dbd-tab.p0.patch` changes `src/Makefile`.

| Item | Content |
| :-- | :-- |
| Case | StreamDevice builds against EPICS base R7.0.10 and R7.0.11. The three recipe lines of `src/Makefile` that create `stream.dbd.d`, `stream-base.dbd.d`, and `stream-scalcout.dbd.d` begin with eight spaces, which make does not read as a recipe. |
| Effect without the patch | `dbdExpand.pl` runs without an input file and prints `No input files for ../O.Common/stream.dbd`, and the same for `stream-base.dbd` and `stream-scalcout.dbd`. With base R7.0.10 the build ends with status 0 and the three `.dbd.d` files stay empty, where they hold `stream.dbd: ../CONFIG_STREAM` and the like with the patch. With base R7.0.11 `make build.StreamDevice` ends with status 2: `No rule to make target 'stream.dbd.d', needed by 'build'`. R7.0.11 writes a `.dbd.d` file only when its recipe succeeds (upstream commit `d44ddf441`), where R7.0.10 left an empty file behind. |
| Reproduction | Build the pinned tree with base R7.0.10 or R7.0.11, remove every `O.*` directory of `StreamDevice-src`, and run `make build.StreamDevice` (observed 2026-10-27 with R7.0.10 on Debian 13 and with R7.0.11 on Debian 13 and Rocky Linux 8.10). |
| Change | The three recipe lines begin with a tab, and a three-line comment above the first rule says why. |
| Result with the patch | `make build.StreamDevice` ends with status 0 and prints no `No input files` line, the three `.dbd.d` files hold `stream.dbd: ../CONFIG_STREAM` and the like, and with base R7.0.11 the complete tree of 73 module entries passes `make check.deps` and `make check.env`. |
| Tested | `make patch.revert`, `make patch`, a second `make patch.revert` returning every source tree to its pin, and `make build.StreamDevice` with status 0, on Debian 13 and Rocky Linux 8.10 with base R7.0.11 and on Debian 13 with base R7.0.10, 2026-10-27. |
| Upstream | Fixed by StreamDevice commit `f473f4d6d` (2026-05-08, "fix wrong (non-tab) indent in Makefile"), which is 18 commits after the 2.8.26 tag and in no release tag; the patch stays until the pin includes that commit. |

## Local build patches

| File | Target | Purpose | Rule |
| :-- | :-- | :-- | :-- |
| `feed-core-libonly` | feed-core | build the library only; drop the unused bundled applications and their module references | `patch.feed-core.apply` |
| `QPC-dataonly` | QPC | strip the module references of the unbuilt `qpcApp` example IOC | `patch.QPC.apply` |
| `measComp-CONFIG_MEASCOMP` | measComp | install `cfg/CONFIG_MEASCOMP` so a consumer naming `MEASCOMP` inherits `ULDAQ_DIR` | `patch.measComp.apply` |
| `opcua-CONFIG_OPCUA` | opcua | in the installed cfg (`CONFIG_OPCUA@`), derive the open62541 lib and include paths from `OPEN62541` instead of separate placeholders | `patch.opcua.apply` |
| `opcua-anon-ns-export` | opcua | move the two `epicsExport` declarations out of the unnamed namespace so GCC 15 does not mangle them (EPICS-env #30) | `patch.opcua.export.apply` |
| `StreamDevice-no-vxi11` | StreamDevice | asyn R4-46 gates vxi11 behind `DRV_VXI11`; drop the vxi11 registrar from the example `asynRegistrars.dbd` | `patch.StreamDevice.apply` |
| `mca-libnet` | mca | macOS only: build the Canberra (libnet) targets only when `DARWIN_NET_INSTALLED` is `YES` | `patch.mca.apply` (Darwin) |

Dormant history, not applied on the current pins: `pvxs-1.3.1` (its rule
block is commented out in [`configure/RULES_PATCH`](../configure/RULES_PATCH)).
