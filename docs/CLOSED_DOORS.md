# Closed Doors

Candidates examined during a review and deliberately left as they are. Each row
states why the shape is principled, so a later sweep can close the same door in
seconds instead of investigating it again. Nothing here is tracked work.

## 2026-08-08

### K1 - `base_patch_src` and `base_revert_patch_src` carry no `|| exit 1`

**Premise.** Six helpers in `configure/RULES_FUNC` loop `patch` over a wildcard
list. Four end the invocation with `|| exit 1`; `base_patch_src` and
`base_revert_patch_src` do not. Read as a list, that is an asymmetry, and the
two unguarded helpers are the older ones, which makes it look like a step the
later carry work forgot.

**Verdict: Keep.** The guard answers a specific failure - a mid-stack miss,
where one patch in a stack fails and a later success masks it, because the shell
returns the status of the last command it ran. That situation needs a stack. The
two unguarded helpers glob `$(SRC_VER_BASE).base.p0.patch`, which has no
wildcard character, so the loop iterates over at most one file and the single
`patch` is always the last command. Its failure propagates on its own. Adding
the guard changes nothing while the glob stays literal.

**Evidence.**

- The rationale was written down when the guarded helpers were added.
  `configure/RULES_FUNC:26-27` states it in the code: "`|| exit 1` fails the
  target on any mid-stack miss instead of masking it behind a later success."
  Commit `c7aac56` says "each loop gated `|| exit 1`" of the new stacked legs.
  `docs/archive/base-carry-1.3.0.md:104` and
  `docs/procedures/upstream-fix-carry-procedure.md:359` both phrase the rule as
  "so a **mid-stack** failure fails the target."
- M22 passed a three-reviewer plan review and a three-reviewer implementation
  review with zero blocking findings, so the distinction was in front of six
  readers.
- Measured 2026-08-08 on two scratch clones, one with the guard added and one
  without: a deliberately unappliable `patch/7.0.10.base.p0.patch` makes
  `make patch.base` exit 2 in both. The guard does not change the outcome.

**If this returns.** It becomes a real defect only if the glob is ever widened
to match several files - for example a `7.0.10.base-*.p0.patch` form. Add the
guard together with that change, not before it.

Examined at `11cbe64`; recorded in the commit that carries this file.

## 2026-09-24

### K2 - Four patch files with no row in the `patch/README.md` tables

**Premise.** `patch/` holds `3.15.5.base`, `7.0.5.base`, `7.0.7.base`, and
`pvxs-1.3.1` patch files that none of the per-file tables list, which reads
like the tables fell behind the directory.

**Verdict: Keep.** They are dormant history for earlier pins and are not
applied on the current pins. `patch/README.md` says so directly below the
tables.

**Evidence.**

- `patch/README.md:109-112` names all four as "Dormant history, not applied on
  the current pins".
- `configure/RULES_FUNC` applies the `.base` leg only through
  `$(SRC_VER_BASE).base.p0.patch`, and no `7.0.10.base.p0.patch` exists.

**If this returns.** It becomes a defect only if a current pin matches one of
these files again; list it in the table then.

Examined at `df483f1`; recorded in the commit that carries this file.

### K3 - `linStat{FS,Host,NIC,Proc}.iocsh` are not named by any doc or test

**Premise.** Of the twelve `commonIocsh/iocsh` fragments, four appear in no
document and no test by name, which reads like untested fragments.

**Verdict: Keep.** `linStat.iocsh` loads them itself, so every linStat test
exercises them, and the linStat documentation covers them through it.

**Evidence.**

- `commonIocsh/iocsh/linStat.iocsh:16-19` loads `linStatHost` and
  `linStatProc` always, and `linStatNIC` and `linStatFS` behind `NICENABLE`
  and `FSENABLE`; line 13 tells the user to load the NIC and FS fragments
  again per extra instance.

**If this returns.** It becomes a gap only if a sub-fragment gains behavior
that `linStat.iocsh` does not reach, such as a macro the parent never passes.

Examined at `df483f1`; recorded in the commit that carries this file.

### K4 - `pvs_gets.bash` and `pv_snapshot.bash` both read a PV list with `caget`

**Premise.** Two tools read the same kind of PV list file and call `caget`,
which reads like duplicated logic.

**Verdict: Keep.** They answer different questions. `pvs_gets.bash` is a
viewer: it sorts, filters, can watch, and hides PVs that do not answer.
`pv_snapshot.bash` records every listed PV, including the ones that do not
connect, and compares two records.

**Evidence.**

- `tools/pvs_gets.bash:151` suppresses failed reads so only working results show.
- `tools/pv_snapshot.bash` writes `__DISCONNECTED__` for a PV that does not
  connect and reports it as `DISCONN`, which a viewer must not hide.

**If this returns.** Merge them only if one tool must both display and
record; the disconnected-PV handling is the part that must not be shared.

Examined at `df483f1`; recorded in the commit that carries this file.
