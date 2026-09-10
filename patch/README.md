# Patch Set

Patches applied to the fetched module sources by `make patch` and removed
by `make patch.revert` ([`configure/RULES_SRC`](../configure/RULES_SRC),
[`configure/RULES_PATCH`](../configure/RULES_PATCH)).
All files are `p0` diffs generated with `git diff --no-prefix` and applied
with `patch -p0 --ignore-whitespace` from the module source root (the pvxs
rule adds `--no-backup-if-mismatch`).

Three kinds of file live here:

| Kind | File pattern | Applied by | Lifecycle key |
| :-- | :-- | :-- | :-- |
| Upstream carry, epics-base | `7.0.10-pr<NNNN>-<slug>.p0.patch` (PR unit) or `7.0.10-<NN>-<sha>-<slug>.p0.patch` (direct-commit unit) | `patch.base.pr.apply`, glob `$(SRC_VER_BASE)-*.p0.patch`, C-locale ascending | base pin 7.0.10 |
| Upstream carry, pvxs | `1.5.2-<NN>-<sha>-<slug>.p0.patch` | `patch.pvxs.commit.apply`, ascending `NN` = upstream merge order | pvxs pin 1.5.2 |
| Local build patch | `<module>-<slug>.p0.patch` | one named `patch.<module>.apply` rule each | the module pin it targets |

An upstream carry is a post-release fix taken from the module's upstream
branch because no upstream release above the pin contains it yet. Every
carry is selected by the procedure in
[`docs/upstream-fix-carry-procedure.md`](../docs/upstream-fix-carry-procedure.md):
applicability gate at the pinned version, then a five-reviewer panel scoring
eight axes (security, safety, bug, perf, ops, urgency, fit, locality; 0-10
each, per-axis median), then the adoption rule — ADOPT when ANY of
`total >= 40/80`, `bug >= 5`, `safety >= 5`, `urgency >= 5` holds — then the
owner's decision, which may add or remove a candidate with a recorded reason.
The full score tables, the swept and deferred candidates, and the owner
decisions are in [`docs/base-carry-1.3.0.md`](../docs/base-carry-1.3.0.md) and
[`docs/pvxs-carry-1.3.0.md`](../docs/pvxs-carry-1.3.0.md);
the tables below summarize the outcome per file.

Carries are recorded against the pinned version exactly. When a pin moves,
every carry is re-examined (dropped if upstream now contains it, re-based if
the region moved) before the new version ships; see "Bump obligation" in
[`docs/upstream-fix-carry-procedure.md`](../docs/upstream-fix-carry-procedure.md)
and "Base-bump obligation" in
[`docs/base-carry-1.3.0.md`](../docs/base-carry-1.3.0.md).

## epics-base 7.0.10 carry (18)

Apply order is the file-name sort order. `Basis` lists the adoption
conditions met by the per-axis median; `owner` marks an owner decision.
`Record` names the run as the decision record does: the milestone ID of the
initial run (M22 in [`docs/base-carry-1.3.0.md`](../docs/base-carry-1.3.0.md), M26 in
[`docs/pvxs-carry-1.3.0.md`](../docs/pvxs-carry-1.3.0.md)) or the refresh's label and date.

| File | Upstream | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `7.0.10-01-b2d2758-putnotify-type-check` | commit `b2d2758` (no PR) dbPutNotifyBlocker type check | 39 | bug, safety | M33 refresh |
| `7.0.10-pr0817-mbbi-cosv-aftc` | epics-base/epics-base#817 mbbiRecord COSV/LALM + AFTC (record hunk only) | 37 | bug, urgency | M22 |
| `7.0.10-pr0837-maclib-delim` | epics-base/epics-base#837 macLib mismatched delimiters | 39 | bug, urgency | M22 |
| `7.0.10-pr0870-strprintescaped-unterminated` | epics-base/epics-base#870 epicsStrPrintEscaped OOB read | 38 | bug, safety, urgency | M22 |
| `7.0.10-pr0890-makerpath-failhard` | epics-base/epics-base#890 configure: fail hard when makeRPath errors | 25 | bug; owner (guards the empty `$ORIGIN` runpath trap) | M22 |
| `7.0.10-pr0904-carepeater-uaf` | epics-base/epics-base#904 caRepeaterThread use-after-free | 42 | total, bug, safety | M22 |
| `7.0.10-pr0913-histogram-oob` | epics-base/epics-base#913 histogramRecord heap OOB write | 51 | total, bug, safety, urgency | M22 |
| `7.0.10-pr0914-printf-ls-overflow` | epics-base/epics-base#914 printfRecord `%ls` VAL overflow | 46 | total, bug, safety, urgency | M22 |
| `7.0.10-pr0915-ringbytes-hwm` | epics-base/epics-base#915 epicsRingBytes high-water-mark operands | 30 | bug | M22 |
| `7.0.10-pr0918-iocsh-onerror-wait` | epics-base/epics-base#918 iocsh `on error wait` parse | 39 | bug, urgency | M22 |
| `7.0.10-pr0919-dbconvert-uint64-string` | epics-base/epics-base#919 dbConvert UInt64 to String truncation | 37 | bug, urgency | M22 |
| `7.0.10-pr0920-dbstatic-uint64` | epics-base/epics-base#920 dbStaticLib UINT64 read through 32-bit pointer | 46 | total, bug, safety, urgency | M22 |
| `7.0.10-pr0922-dbjlink-assign-compare` | epics-base/epics-base#922 dbJLink assignment-instead-of-compare | 37 | bug, urgency | M22 |
| `7.0.10-pr0932-ca-input-validation` | epics-base/epics-base#932 database/CA client input validation | 46 | total, bug, safety, urgency | M22 |
| `7.0.10-pr0934-rsrv-msg-validation` | epics-base/epics-base#934 RSRV message validation | 52 | total, bug, safety, urgency | M22 |
| `7.0.10-pr0935-caget-null` | epics-base/epics-base#935 caget missing NULL check | 35 | safety | M22 |
| `7.0.10-pr0948-dbchannel-put-timestring` | epics-base/epics-base#948 dbChannel_put DBR_TIME_STRING | 37 | bug | M33 refresh |
| `7.0.10-pr0949-rsrv-scalar-string-put` | epics-base/epics-base#949 RSRV scalar-string PUT (fixes epics-base/epics-base#943, a regression of the carried epics-base/epics-base#934) | 51 | total, bug, safety, urgency | Carry refresh 2026-09-03 |

Deferred at the applicability gate (no target code at R7.0.10; re-enter on a
base bump): epics-base/epics-base#917 errlog OOB read, epics-base/epics-base#856 dbCa iocInit wait. Scored and
dropped: commit `6cf9fe9d8` Repeater announcement silence (total 22).

## pvxs 1.5.2 carry (12)

Apply order is the file-name sort order (`NN` = upstream merge order).

| File | Upstream commit | Total /80 | Basis | Record |
| :-- | :-- | :--: | :-- | :-- |
| `1.5.2-01-086501a-pvxmonitor-conn-ts` | `086501a` pvxmonitor connect/disconnect timestamps | 30 | owner (commissioning value; no gating axis) | M26 |
| `1.5.2-02-090bf5f-cli-flush` | `090bf5f` CLI cerr/cout flush | 37 | bug, urgency | M26 |
| `1.5.2-03-7490286-pvalink-seq-point` | `7490286` pvalink sequence point after dbProcess | 28 | bug | M26 |
| `1.5.2-04-0b3fcca-cli-dtor-order` | `0b3fcca` CLI destructor ordering | 37 | safety, urgency | M26 |
| `1.5.2-05-084336b-client-retry-slowdown` | `084336b` client slow retry after refused CREATE_CHANNEL | 44 | total, bug, urgency | M26 |
| `1.5.2-06-9a6b4cc-oncreate-log-deescalate` | `9a6b4cc` server onCreate exception log de-escalation | 40 | total, urgency | M26 |
| `1.5.2-07-39cc6fa-infoop-early-dtor` | `39cc6fa` client Op early-destruction guard | 43 | total, bug, safety, urgency | M26 |
| `1.5.2-08-c969383-clientmon-cb-guard` | `c969383` clientmon callback-functor guard | 43 | total, bug, safety, urgency | M26 |
| `1.5.2-09-c17812a-clientget-cb-guard` | `c17812a` clientget callback-functor guard | 42 | total, bug, safety, urgency | M26 |
| `1.5.2-10-eab3275-clientdiscover-cb-guard` | `eab3275` clientdiscover callback-functor guard | 32 | safety | M26 |
| `1.5.2-11-d5ecc88-clientintrospect-cb-guard` | `d5ecc88` clientintrospect callback-functor guard | 34 | safety | M26 |
| `1.5.2-12-cc7bc72-synccancel-diag` | `cc7bc72` syncCancel-on-worker diagnostic | 29 | safety | M26 |

Scored and not carried: `67447cb`, `12fbe53`, `2b99e3c`, `8cb8d4b`,
`27ccb3c`, `5ab17ec`, `2342090` (the last three form a JSON-feature chain);
refresh 2026-08-21 dropped `1044240` and `b552fe9`. None was deferred at the
applicability gate. Details in [`docs/pvxs-carry-1.3.0.md`](../docs/pvxs-carry-1.3.0.md).

## Local build patches

| File | Target | Purpose | Rule |
| :-- | :-- | :-- | :-- |
| `feed-core-libonly` | feed-core | build the library only; the example IOC's module references are stripped so the strict module-deps audit passes | `patch.feed-core.apply` |
| `QPC-dataonly` | QPC | strip the unbuilt `qpcApp` example IOC's module references (same pattern as feed-core) | `patch.QPC.apply` |
| `measComp-CONFIG_MEASCOMP` | measComp | install `cfg/CONFIG_MEASCOMP` so a consumer naming `MEASCOMP` inherits `ULDAQ_DIR` | `patch.measComp.apply` |
| `opcua-CONFIG_OPCUA` | opcua | in the installed cfg (`CONFIG_OPCUA@`), derive the open62541 lib and include paths from `OPEN62541` instead of separate placeholders | `patch.opcua.apply` |
| `opcua-anon-ns-export` | opcua | move the two `epicsExport` declarations out of the unnamed namespace so GCC 15 does not mangle them (EPICS-env #30) | `patch.opcua.export.apply` |
| `StreamDevice-no-vxi11` | StreamDevice | asyn R4-46 gates vxi11 behind `DRV_VXI11`; drop the vxi11 registrar from the example `asynRegistrars.dbd` | `patch.StreamDevice.apply` |
| `mca-libnet` | mca | macOS only: build the Canberra (libnet) targets only when `DARWIN_NET_INSTALLED` is `YES` | `patch.mca.apply` (Darwin) |

Dormant history, not applied on the current pins: `3.15.5.base`,
`7.0.5.base`, `7.0.7.base` (the `$(SRC_VER_BASE).base.p0.patch` leg of
earlier base pins; none exists for 7.0.10) and `pvxs-1.3.1` (its rule block
is commented out in [`configure/RULES_PATCH`](../configure/RULES_PATCH)).
