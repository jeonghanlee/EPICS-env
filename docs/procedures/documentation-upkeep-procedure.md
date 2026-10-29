# Documentation Upkeep - General Procedure

How a procedure of this repository is changed during a release, and what is
reconciled after the release, so that the next release starts from documents,
not from anyone's memory. What a release records, and when, is set out in
`release-procedure.md`; this file holds only the rules for changing a
procedure and for the reconciliation after the release.

## At the close of every step

These rules apply at the close of every step of `release-procedure.md`, a
module cycle or any other.

1. Write every rule the step taught, as a general sentence, into the
   procedure that owns it (`release-procedure.md` lists which procedure holds
   which work). Name a concrete case in one line at most, and only when it
   makes the rule clearer. Name no item of one release's record, since the
   procedure serves every release; the release record cites a rule by the
   procedure's step, stage, or item.
2. Run every command the procedure now shows once, on the real path, and make
   the text match its output.
3. Review the changed procedure in two passes, one that verifies each claim
   against the repository and one that reads it from the seat of the Executor
   who carries it out; the maintainer accepts the wording. These roles are
   defined in `release-procedure.md`, Roles and interaction.
4. Commit the change with the maintainer's authorization, in a commit of its
   own after the commit that records the step's results (for a module cycle,
   the commit that marks the module complete, `release-procedure.md` step 6).

## After the release

Reconcile the procedures of this repository and the archive in one pass
(`release-procedure.md`, step 9); the pass is done when the three items below
are done:

1. Read the lessons learned of the closed release record, at the commit that
   carries it (`release-procedure.md`, step 8), and write each one that
   changes a procedure into that procedure by rules 1 to 3 above, committed
   with the maintainer's authorization.
2. Move each decision record of the downstream patches of the release
   (`docs/<module>-carry-<ver>.md`, `upstream-fix-carry-procedure.md`) to
   `docs/archive/`; a release may have none.
3. Bring the index of `docs/README.md` in line with the procedures and the
   archive.
