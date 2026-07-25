# Module Bump Review — 1.3.0 (M6, #21)

Per-module review record for the 1.3.0 bump set. The owner and the agent
review each candidate's upstream delta one by one; the decisions here are
the durable record behind the `configure/RELEASE` edits and feed the 1.3.0
release notes. Candidates measured 2026-07-25 with
`tools/update-release.bash check` (17 in EPICS-env) and the support repo's
check (1 in EPICS-env-support).

Floor set (#21): ether_ip, iocStats, linStat, pmac, pvxs — in the set by
prior decision; review refines, it does not re-open them.

## Candidates and decisions

| # | Module | Current -> Latest | Moved | Decision |
| :-- | :-- | :-- | :-- | :-- |
| 1 | ether_ip ★ | ether_ip-3-8 -> ether_ip-3-10 | 2026-02-19 | IN — additive driver diagnostics, low risk (F:IN O:EITHER S:EITHER) |
| 2 | iocStats ★ | 4.0.0 -> 4.0.1 | 2026-04-29 | IN — housekeeping + DESC-overflow fix in the db generator, no runtime code (F:EITHER O:EITHER S:IN) |
| 3 | linStat ★ | 1.1.0 -> 1.2.1 | 2026-06-08 | IN — review exempt (owner) |
| 4 | pmac ★ | 2-7-8 -> 2-7-9 | 2025-10-13 | IN — one additive error message exposing silent scale_==0 (F:IN O:EITHER S:IN) |
| 5 | pvxs ★ | 1.5.1 -> 1.5.2 | 2026-06-24 | IN — review exempt (owner); install layout re-check at M6.T1 (cfg/CONFIG with INSTALL_LOCATION) |
| 6 | recsync | 9834b94 -> 4879f2b | 2026-06-25 | HOLD — owner confirmed: keep 9834b94. Not a bump: the reccaster client/ tree we build was removed upstream (moved to ChannelFinder/reccaster; stub Makefile exits 1). Migration is a separate future decision |
| 7 | caPutLog | dafb0b2 -> 6f9eb3f | 2026-02-26 | HOLD (owner, per recommendation) — docs-only delta, zero code |
| 8 | calc | f6a39b6 -> 7ab5914 | 2026-06-07 | IN (owner) — record-runtime memory-safety and crash fixes (F:IN O:IN S:IN) |
| 9 | sscan | 6cf6740 -> e13699e | 2026-06-05 | IN (owner) — scan-record buffer/path hardening (F:IN O:IN S:IN) |
| 10 | lua | 17475b5 -> a905067 | 2026-06-07 | HOLD for 1.3.0 (unanimous — 131-commit rewrite, fixes inseparable); owner decision 2026-07-25: REMOVE the module from the set in 1.4.0 |
| 11 | std | d3fa510 -> 5f2e442 | 2026-07-20 | IN (owner) — epidRecord UDF-alarm and devEpidSoft constant-INP fixes (F:IN O:IN S:IN) |
| 12 | busy | 2dfe92d -> e015bc7 | 2026-06-07 | HOLD (owner) — build/docs only, zero runtime delta |
| 13 | scaler | beb5521 -> baa8e1c | 2026-06-07 | HOLD (owner) — build/docs only, zero runtime delta |
| 14 | measComp | c38974e -> 9c8e01e | 2026-07-13 | HOLD (owner) — screens + docs tooling only |
| 15 | motor | 285f44d -> f3d089b | 2026-05-15 | IN (owner) — motor_task shutdown-hang + RVEL fixes outweigh the feature/submodule breadth (F:IN O:IN S:IN); M6.T1 adds a motorSim smoke; POST-RELEASE: combined motor+pmac test on the lab bench or in simulation (owner, 2026-07-25) |
| 16 | pcas | e075fd4 -> bdf2b0a | 2026-07-20 | HOLD (owner) — pure CI, zero shipped-code delta |
| 17 | pscdrv | 1ed650d -> 276daca | 2026-04-17 | IN (owner) — PSC Reg F* init fix, disconnect->INVALID propagation, feed-core RecInfo name-conflict fix (F:IN O:IN S:IN); POST-RELEASE: pscdrv test required (owner, 2026-07-25), alongside the motor+pmac bench/sim test |
| 18 | ADCore (support) | 72593ed -> ee039d2 | 2026-07-20 | IN — review exempt (owner); reviewed in depth 2026-07-25: 81 commits, adds NDPluginPvxs; build with `WITH_PVXS=YES`; companion to the pvxs 1.5.2 bump |

Unchanged (check OK): retools, sncseq, MCoreUtils, autosave, asyn, modbus,
mca, StreamDevice, snmp, opcua, motorSim, feed-core.

asyn note: R4-45 remains the latest tag (master is 76 commits ahead,
untagged). ADCore's new code names asyn R4-45 as its baseline (verified in
its RELEASE.md), so the ADCore move forces no asyn change.

## Per-module review

### 1. ether_ip — ether_ip-3-8 -> ether_ip-3-10 (5 commits, 10 files)

- 2026-02-13..19, passing through 3.9: STRING handling notes, tag listing
  support, `drvEtherIP_describe` diagnostic, custom struct info.
- Character: feature additions (PLC tag browsing and diagnostics), not bug
  fixes. Low risk; nothing broken today that it repairs.
- Decision: pending owner confirm (floor-set member).

### 2. iocStats — 4.0.0 -> 4.0.1 (7 commits, 10 files)
Build-dep .d switch, iocEnvVar DESC 40-char truncation in the db generator,
stderr warning, screen TZ updates. No record/driver code. IN (floor).

### 3. pmac — 2-7-8 -> 2-7-9 (2 commits, 1 file)
Error message in pmacCSAxis::move exposing silent scale_==0. IN (floor).

### 4. recsync — HOLD (unanimous, structural)
249 commits/126 files: the Python recceiver server was rewritten AND the
IOC-side client/ tree (reccaster, the part EPICS-env builds) was REMOVED —
at 4879f2b it is a stub Makefile that exits 1 ("moved to
ChannelFinder/reccaster"). A bump alone breaks the build; repointing to the
new repository is a separate migration decision, out of M6 scope.

### 5. caPutLog — HOLD (owner, per recommendation)
3 commits/2 files, docs/*.rst only (R4-2 release prep). No code, no benefit.

### Verified observation — MODULESGEN.mk stale URLs (not a defect)
The generated MODULESGEN.mk writes default epics-modules URLs for pmac,
recsync, and pscdrv (nonexistent repos), but CONFIG_MODS re-defines all
three with the special-case URLs immediately after the include; effective
make values verified correct (DiamondLightSource/pmac, ChannelFinder/recsync,
mdavidsaver/pscdrv). Harmless for builds; misleading to direct readers of
the generated file. Candidate backlog item: teach the generator the
per-module SRC_URL overrides.

## Final set (owner-decided, 2026-07-25)

IN — EPICS-env (10): ether_ip 3-10, iocStats 4.0.1, linStat 1.2.1,
pmac 2-7-9, pvxs 1.5.2 (floor five) + calc 7ab5914, sscan e13699e,
std 5f2e442, motor f3d089b, pscdrv 276daca.
IN — EPICS-env-support (1): ADCore ee039d2, built with WITH_PVXS=YES.

HOLD (7): recsync (pin kept; reccaster migration is a separate future
decision), caPutLog, lua (REMOVED from the set in 1.4.0), busy, scaler,
measComp, pcas.

Post-release tests (owner): combined motor+pmac on the lab bench or in
simulation; pscdrv test. M6.T1 adds a motorSim smoke; pvxs install layout
re-checked at M6.T1.
