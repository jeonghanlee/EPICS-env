# motor 4b22ac9 carry assessment for EPICS-env 1.5.0

Assessment and decision date: 2026-10-31. Nine upstream commits in four groups
were scored by five independent reviewers. One group meets the rule. The
Maintainer carries none of them. No patch file is generated and the pin stays
at `4b22ac9`. Module build and IOC acceptance remain pending.

## Scope

This record presents every post-pin commit that survives classification, five
independent scores, application and build checks, dependencies and defects
found in the candidates. It follows the
[carry procedure](procedures/upstream-fix-carry-procedure.md). The move of the
pin from `285f44d` to `4b22ac9` was decided earlier (D12 of the release
record); this record covers only the commits merged after it.

**Out of scope:** complete module and release builds, IOC and hardware
acceptance, platforms other than Linux, and git publication. Release decisions
in the [release record](milestone-1.5.0.md) govern later verification.

## Source range and coverage

- Upstream: `https://github.com/epics-modules/motor`, default branch `master`.
- Pin: `4b22ac950de98c2dca324c2ef8ef221e124f6651`, release `R7-4` plus a
  documentation fix and the correction of the `VERSION` number in
  `motorRecord.cc`. The newest release tag, `R7-4`, is an ancestor of the pin;
  no release tag exists above the pin.
- Survey tip: `47893ed11b0027b90a94622847ebc5332ba6b99a`, committed 2026-07-30.
- The environment builds motor against Base 7.0.10, asyn 4.46.0, the sequencer
  and busy on Linux only. `motorMotorSim` R1-3 and `pmac` 2-7-9 are built
  against the installed motor. No downstream patch is applied to motor.

| Stage | Count | Detail |
| :-- | :--: | :-- |
| Enumerated | 17 | GitHub compare API from the pin to `master` |
| Removed as exclusively documentation, CI or tests | 1 | `6c37060`: `docs/motorRecord.html` only |
| Merge commits | 7 | `080f31a`, `7202b74`, `33496c3`, `78b474c`, `b43050d`, `c7e6cb7`, `47893ed`; represented by their constituents. The change of `33496c3` (`VERSION 7.4`) is already in the pin |
| Deferred at the applicability gate | 0 | the target code of all scored commits exists at the pin |
| Scored | 9 | in four groups, by five independent reviewers |
| Met the rule | 1 | group F2 (`78f03d2`) |
| Added by the Maintainer | 0 | |
| Removed by the Maintainer | 1 | `78f03d2`, which met the rule |
| Selected for carry | 0 | |

Merge commits are not one of the three removal categories of the procedure.
They are not scored because their content equals their constituents; the range
changes 20 files, and the files of the nine scored commits and the documentation
commit account for them.

## Scores

Per-axis median of five reviewers, integers 0-10 per axis. Medians, totals and
the rule were computed in code from the five original packets, which are kept
with their notes, verification reports, defects and relations in
[`motor-carry-1.5.0-scores.json`](motor-carry-1.5.0-scores.json). The rule is
`total >= 40 OR bug >= 5 OR safety >= 5 OR urgency >= 5`.

Axis columns: `sec` security (remote exposure reduced), `saf` safety (memory
safety and robustness), `bug` functional correctness fixed, `perf` runtime
performance, `ops` facility operational value, `urg` urgency (harm if not
carried before the next bump), `fit` clean apply at the pin with a low
regression surface, `loc` locality (blast radius: a leaf scores high, deep core
code scores low). Higher is better on every axis. The full definitions are in the
[carry procedure](procedures/upstream-fix-carry-procedure.md), Stage 3.

| Group | Commits | Change | sec | saf | bug | perf | ops | urg | fit | loc | Total /80 | Rule met |
| :-- | :-- | :-- | --: | --: | --: | --: | --: | --: | --: | --: | --: | :-- |
| F2 | `78f03d2` | `check_speed_and_resolution()` sets HVEL to VELO instead of VBAS when HVEL is 0 | 0 | 1 | 7 | 0 | 6 | 4 | 8 | 6 | 32 | bug |
| F1 | `76f8d1f` | a missing `\n` in a log message of `devMotorAsyn.c` | 0 | 0 | 2 | 0 | 1 | 1 | 10 | 10 | 24 | none |
| F3 | `c01d03b` | C1 to C5 become macros with a default of 1 in `pseudoMotor.db` | 0 | 0 | 1 | 0 | 2 | 1 | 9 | 10 | 23 | none |
| F4 | `8cec391`, `82d2657`, `e534811`, `05b25c1`, `41e6efa`, `f3d089b` | position compare output: five parameters and `enablePCO()` in `asynMotorController` and `asynMotorAxis`, a template, request file and display files; the asyn pre-4.32 branch is removed | 0 | 0 | 0 | 0 | 2 | 0 | 2 | 2 | 6 | none |

All totals are the sums of the recorded per-axis medians. The five totals of F2
range from 20 to 35, of F1 from 23 to 25, of F3 from 22 to 25 and of F4 from 4
to 7. The spread of F2 comes from how the reviewers weighed its change of
behavior; the lowest total (20) is from the reviewer who judged that it changes
the homing speed that pmac uses.

## Dependencies and conflicts

The four groups change separate files, so they have no prerequisite among each
other. Inside F4 the commits are a chain: `41e6efa` fails to apply to the pin
without the earlier F4 commits (all 17 hunks), `f3d089b` fails one hunk without
`e534811`, and the template needs the parameters that `05b25c1` adds. The
chain is applied in the order of the table. All four groups applied singly and
together with `patch -p1`.

## Findings on the candidates

- **F2 `78f03d2`.** When HVEL is 0 the record used VBAS as the home velocity.
  With VBAS = 0 that leaves HVEL at 0 and the home command does nothing: on a
  motorSim IOC the pin never homes, and with the change it does. With VBAS > 0
  the home speed rises from VBAS to VELO (reviewers measured 4 to 20 times, depending on the ratio of VELO to VBAS). It
  is a change of documented behavior (`docs/motor_release.html` says HVEL is
  set to VBAS when unset) and the commit does not update that page. The new
  value takes effect at the next IOC restart. For pmac, `pmacAxis::home` sends
  `#n HOME` and uses the velocity only to choose the direction of its limit
  protection, so the effect on pmac is limited to the case of VBAS = 0; one
  reviewer judged it larger from the code and did not run it.
- **F1 `76f8d1f`.** One log message of `devMotorAsyn::init_record` lacked a
  trailing newline, so it joined the next message. A reviewer reproduced the
  joined and the separated lines on a motorSim IOC. No operational effect.
- **F3 `c01d03b`.** `pseudoMotor.db` takes `C1` to `C5` as macros with a default
  of 1 and is re-indented. `msi` expansion shows the macros take effect on the
  change and are ignored on the pin; the default output is unchanged. No consumer
  in this environment uses `pseudoMotor.db`.
- **F4 (position compare).** It is a new feature, not a fix, and nothing in this
  environment acts on it: `enablePCO()` is an empty base function and no driver
  overrides it. Defects found in the change:
    - `05b25c1` removes `LAST_MOTOR_PARAM` and `NUM_MOTOR_DRIVER_PARAMS` from
      `asynMotorController.h`. pmac 2-7-9 uses the macro in
      `pmacController.cpp:137` and `pmacCSController.cpp:151`, and
      `pmacApp/src` fails to compile against the changed motor (all five
      reviewers). pmac 2-7-10 uses it in the same two places.
    - It adds data members to `asynMotorController` and a virtual function to
      `asynMotorAxis`; a motorSim binary built on the pin crashes with the
      changed `libmotor`, so every driver must be rebuilt.
    - `positionCompare.template` sets `ZSV` twice on `PCOEnable_RBV`, and
      `positionCompare_settings.req` uses `$(R)` where the template uses `$(M)`.
- **Consumers.** `motorMotorSim` builds against the pin and against each group.
  The complete pmac build stops at a missing `libssh2.a` for `powerPmacAsynPort`
  on this host with the pin as well; the reviewers built `pmacApp/src` only.

## Decision

Maintainer decision, 2026-10-31: carry none of the groups.

- F2 meets the rule through bug and is removed by the Maintainer. It changes the
  home speed of every axis that leaves HVEL unset.
- F1 and F3 miss the rule and are not carried.
- F4 misses the rule and cannot be adopted while pmac uses
  `NUM_MOTOR_DRIVER_PARAMS`; D12 keeps the motor head `47893ed` out for the same
  reason.

The release decision is D45 and the closed door is K28. The pin stays at
`4b22ac9`.

## Verification

The reviewers built the pin and each group with the real motor source, Base
7.0.10, asyn 4.46.0, the sequencer and busy installed copies, following the
`conf.motor` recipe with the release check off; the busy copy was the one of the
previous release (`busy-2dfe92d`), not the pin `a4a272d`.

| Check | Result |
| :-- | :-- |
| Pin build | exit 0 with `libmotor` and `libsoftMotor` installed |
| Each group applied to the pin, and all four together | applied with `patch -p1`; builds exited 0 with the same compiler warnings as the pin |
| F4 commits alone | `41e6efa` and `f3d089b` do not apply to the pin without the earlier F4 commits |
| F2 on a motorSim IOC, pin against pin with the change | VBAS = 0: the pin leaves HVEL at 0 and does not home, the change homes; VBAS > 0: the home speed rises to VELO |
| F1 on a motorSim IOC | the pin joins two log lines, the change separates them |
| F3 with `msi` | C1 and C3 take effect with the change and stay 1 on the pin |
| pmac against the changed motor (F4) | `pmacApp/src` fails to compile at `pmacController.cpp:137` and `pmacCSController.cpp:151`; it compiles against the pin |
| `motorMotorSim` against the pin and the changed motor | builds in every case |
| motorSim built on the pin, run with the F4 `libmotor` | segmentation fault |

## Not verified

- the complete pmac build on this host (it stops at `libssh2` with the pin too),
  and an IOC run of any pmac axis;
- a GCC 15 build, other platforms, the CI matrix, `make check.deps`, an
  installed-tree check and a strict release-check build;
- a build of pmac 2-7-10 against the changed motor; its failure is inferred from
  the same macro use at the same two lines as 2-7-9, which was built;
- the effect of F2 on the home speed of a real pmac axis; the reading of
  `pmacAxis::home` above is from the code.

## Completion review

No patch file is generated, so the completion reviews of the carry procedure
for a patch do not apply. A second-person reviewer with fresh context read this
record, the decision rows and observation paragraphs of the release record and
the closed doors K24 to K30 as the next maintainer and ran the remote queries
they name.

| No | Person | Must-fix | Minor | Info | Disposition |
| --: | :-- | --: | --: | --: | :-- |
| 1 | second | 1 | 3 | 1 | the must-fix corrected: the statement that the scored packets are not kept, and the missing links from the decision D45 and the closed door K28 to this record; the three minor corrected: the pmac 2-7-10 build stated as inferred from the source and listed as not verified, the range of the home speed change stated as 4 to 20 times, and the sentences of the release record that still called the pmac and motor compatibility open |
