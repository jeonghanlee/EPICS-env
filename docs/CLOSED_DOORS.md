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

**Verdict: Keep.** The guard answers a specific failure — a mid-stack miss,
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
to match several files — for example a `7.0.10.base-*.p0.patch` form. Add the
guard together with that change, not before it.

Examined at `11cbe64`; recorded in the commit that carries this file.
