# Documentation Upkeep - General Procedure

How the records of a release cycle are kept so that the next cycle starts from
documents, not from anyone's memory. One rule governs it: a procedure holds
general rules, and the register, read under its tag once the release closes,
holds the memory of one release. Each rule has one file;
`release-procedure.md` is the entry that orders the steps of a release and
names the file of each.

## Roles

- The session that runs a step writes its lessons at the step's close.
- The owner decides what a lesson means for a procedure and accepts the
  wording.
- The session that owns the skills repository, the owner's `dev-env`
  repository outside this one, receives the lessons about the sessions' own
  working method; this repository holds none of them.

## Where each kind of record lives

| Record | Place | Form |
| :-- | :-- | :-- |
| A rule any module or release follows | `docs/procedures/<work>-procedure.md` | A general sentence; one concrete case as a one-line example at most |
| What one release did: numbers, decisions, observations, mistakes and their causes | `docs/milestone-<release>.md`, the work register | Verification Results, Closure Evidence, and Decisions of the detail that produced them |
| A module bump decision (IN or HOLD) | The Decisions of the register | A dated row per module |
| A fix-carry decision for base or pvxs | `docs/<module>-carry-<ver>.md` | The funnel and the scored table (`upstream-fix-carry-procedure.md`) |
| A candidate examined and kept unchanged | `docs/CLOSED_DOORS.md` | Keep verdict with premise, evidence, date, and carrying commit |
| A lesson no procedure of this repository can hold | The register's Backlog row for the cycle's lessons, created with its detail at the cycle's first such lesson under the register rules of the milestone-tracking skill | One line each: the lesson, its evidence, its destination |
| The closed register of a release | The release tag; at the close the register is reset into the next generation | Read with `git show <tag>:docs/milestone-<release>.md` |

## At the close of every step

1. Write into the procedure that the step changed or followed every rule the
   step taught, as a general sentence. Name the concrete case in one line only
   when it makes the rule clearer.
2. Run every command the procedure now shows once, on the real path, and make
   the text match its output.
3. Put the step's own facts into the register: the observed results in
   Verification Results, the landing and issue state in Closure Evidence, the
   decisions in Decisions.
4. Add every lesson that is not a procedure rule to the cycle's lessons row in
   the Backlog, creating the row and its detail at the cycle's first such
   lesson; one line with its evidence and its destination: the skills
   repository for the sessions' working method, the post-release
   reconciliation for a decision about the release procedure itself.
5. Review the changed procedure in the third-person and second-person passes,
   then commit it with the register under the commit rules.

## At the close of the cycle

1. Send the skills items of the lessons row to the session that owns the
   skills repository as one request, and record its reply in the row's detail.
2. Hand the reconciliation items to the post-release reconciliation work.

## After the release

1. Reconcile the procedures of this repository, the archive, and the release
   references of the skills repository in one pass, with every divergence
   named and settled.
2. Keep the closed register under the release tag and reset it into the next
   generation; the next cycle's register starts from the surviving work.

## Record discipline

A lesson that stays in a chat transcript, a scratchpad, or a session log is
lost at the next session. A lesson written into a procedure as a general rule
is kept; a lesson written only as a story of one release belongs in that
release's register.
