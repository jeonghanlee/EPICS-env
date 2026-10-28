# Upstream Fix Carry - General Procedure

How to decide which upstream fixes, merged after the version this environment
pins, are carried as downstream patches until the next version bump - and how to
carry them.

This document is written to be executed from itself. An agent arriving with no
memory of any previous execution should be able to work through it end to end.
Everything needed to reproduce the mechanics - commands, the scoring rules,
the verification recipes - is written here rather than referenced from a
scratch directory, because `/work/` is gitignored in this repository and does
not survive.

Applies to any pinned upstream module. First executed for epics-base R7.0.10
(decision record: `docs/archive/base-carry-1.3.0.md`, issue #52); second
execution is pvxs `tags/1.5.2` -> `master` (decision record:
`docs/archive/pvxs-carry-1.3.0.md`). This document is the general form; each
execution keeps its own decision record under `docs/` holding the table of
fixes and the outcome, and the record moves to `docs/archive/` in the
reconciliation after the release (`documentation-upkeep-procedure.md`). The
general rules that must outlive the records live here.

A downstream patch is a patch this repository applies to the source of a
pinned module. It is one of two kinds. A carry patch holds an upstream fix
merged after the pinned version, carried until the bump brings it. A site
patch holds a fix for a bug in the module itself that no upstream release
contains yet. Both kinds exist for any module. When the pin moves, a patch found by a
version-anchored glob is dropped without a message, and a patch applied by its
own rule fails `make patch` where the source no longer matches it; either way
it is re-examined (Bump obligation). This procedure decides which fixes become
carry patches; a site patch is recorded in its own section of
`patch/README.md` (Patch-set summary table). In this procedure a fix is an
upstream commit or pull request considered for carrying, the carry unit of
Stage 1. The stages named here are the stages of this procedure, not those of
`module-bump-procedure.md`.

**base and pvxs move in lockstep.** pvxs is the pvAccess implementation this
environment depends on and is structurally headed for absorption into EPICS
base, so its carry patches are worked alongside those of base, not on their
own. Survey and refresh the two in the same pass - never refresh base without
also refreshing pvxs - and retire them together. Retirement runs at whichever
comes first: a pvxs release above its pin, or the base bump that absorbs pvxs;
in the base-bump case both sets are re-examined against the base tree in one
Bump-obligation re-examination (see below), each carry patch dropped if the
absorbed sources already contain it, re-based if the region moved. Every other
pinned module is carried on its own.

## Roles

| Role | Does | Does NOT |
| :-- | :-- | :-- |
| Maintainer | Decides which fixes are carried; signs the result | - |
| Agent | Enumerates the range, classifies by evidence, verifies dependencies, runs the scoring panel, presents the full table | Narrow the set of fixes to a shortlist; treat the rule outcome as the decision |

The scoring rule produces a **recommendation**, not a decision. The adopted set
is whatever the maintainer says it is: the maintainer may adopt a fix the rule
drops, or drop one the rule adopts. Record such calls with their reason in the
execution's decision record (epics-base #890 and pvxs `086501a` are the worked
examples).

**The agent presents every surviving fix, scored.** Reducing the set to
the ones the agent finds interesting removes the maintainer's material
before the decision is made. The only removals the agent may perform are
the mechanical ones in Stage 2, and each must be defensible from the diff.
In the pvxs run the agent first cut 25 fixes to 6 on its own judgement;
scoring the full surviving 19 later showed `090bf5f`, one of the commits
that cut had discarded as cosmetic, meeting the rule at bug 6 / ops 8.

## Working layout

```
work/<module>-carry/          # scratch; gitignored, nothing here survives
  commits.tsv                 # Stage 1: sha, date, subject
  files.txt                   # Stage 1: changed-file list per commit
  patches.txt                 # Stage 1: real diff text per commit
  classification.md           # Stage 2/2b: per-commit verdict + dependency chains
  panel.<ext>                 # Stage 3: scoring script of the agent runtime in use
  panel-result.json           # Stage 3: raw panel output, kept for audit
docs/<module>-carry-<ver>.md  # durable decision record; moves to docs/archive/ after the release
patch/README.md               # durable per-file summary of the whole patch set
```

Anything that must outlive the session goes into `docs/`. Treat `work/` as a
desk, not a filing cabinet.

## Stage 1 - Enumerate the full range

Compare the pinned tag against the upstream default branch and take every
commit in between. No sampling, no "the interesting ones". The `compare` API
lists at most 250 commits; check `total_commits` first, and when it exceeds
250, enumerate from a local clone with `git log --reverse <pinned-tag>..origin/<default-branch>`
instead.

```bash
gh api repos/<org>/<repo>/compare/<pinned-tag>...<default-branch> --jq '.total_commits'
gh api repos/<org>/<repo>/compare/<pinned-tag>...<default-branch> --jq '.commits[] | .sha + "\t" + (.commit.author.date[0:10]) + "\t" + (.commit.message|split("\n")[0])' > work/<module>-carry/commits.tsv
```

Record the total and the survey snapshot - the branch tip commit and its date -
which a later Refresh reconciles against, so it is not optional. Then confirm
upstream has published no release tag above the pin, since a carry is the correct
response only while no bump is available:

```bash
git ls-remote --tags --refs https://github.com/<org>/<repo>.git | awk -F/ '{print $3}' | grep '<release-tag-pattern>' | sort -V | tail -5
```

A tag listing does not come in version order, so sort the names locally. Keep
only the release tags with `<release-tag-pattern>`: epics-base publishes other
tags too (`end-of-*-master`, `libcom-*`), so its pattern is `^R[0-9]`; the tags
of pvxs are plain version numbers, so `^[0-9]` keeps them.

The commit order returned by `compare` is the upstream merge order. Keep it:
it is the default apply order later.

Then fetch each commit's changed-file list and its real diff. **Run these in
the background.** Twenty-five sequential API calls exceed a one-minute
foreground tool timeout; a background script that appends to a file survives
and can be read as it fills.

```bash
# work/<module>-carry/fetch.sh - run in background from work/<module>-carry/,
# where commits.tsv is; then read the output files
while IFS=$'\t' read -r sha date subj; do
  printf '%s\t%s\t%s\n\t%s\n' "${sha:0:7}" "$date" "$subj" \
    "$(gh api "repos/<org>/<repo>/commits/$sha" --jq '[.files[] | (.status[0:1]) + ":" + .filename] | join("  ")')" >> files.txt
  { printf '\n########## %s ##########\n' "$sha"
    gh api "repos/<org>/<repo>/commits/$sha" --jq '.commit.message, (.files[] | "\n----- FILE: " + .filename + " (" + .status + ", +" + (.additions|tostring) + "/-" + (.deletions|tostring) + ") -----", .patch)'
  } >> patches.txt
done < commits.tsv
echo DONE >> files.txt
```

Upstream projects differ in how work lands. epics-base is mixed: most work
merges through pull requests (carry unit a PR), but some fixes land as direct
commits with no PR, so its carry unit there can be either. pvxs lands most
work as direct commits and some through pull requests; its carry unit is
always a commit, and a pull request's commits are carried one by one (the five
1.5.2 carries of pvxs pull request #194 are the example). Do not assume
PR numbers exist - even on epics-base: resolve each adopted commit's PR (e.g.
`gh api repos/<org>/<repo>/commits/<sha>/pulls`) and fall back to the commit-unit
naming when there is none.

**Refresh (the carry already exists).** When re-running for a module whose carry
is already in place and whose branch has advanced since the last survey - a
mid-version refresh, not a version bump (see Bump obligation) - enumerate the
full current range as above, then reconcile against the prior decision record:
the fixes to score are the commits merged since that record's snapshot;
commits it already adopted, deferred, or swept keep their recorded verdict and
are not re-scored. Take the delta by diffing the two enumerations by sha,
not by date: `commits.tsv` records the author date, which does not follow
merge order. The earlier enumeration does not survive in `work/`; rebuild it
with the Stage 1 command, naming the recorded snapshot tip in place of the
branch, which lists exactly the commits that the record's total counts. Confirm
no release tag above the pin still exists, since a bump would replace the carry
entirely. (The 1.3.0 refresh recorded in `docs/archive/base-carry-1.3.0.md`
refreshed the R7.0.10 carry this way: 151 in range, 8 new since the initial
survey snapshot, 5 swept, 3 scored.)

## Stage 2 - Mechanical removal, judged by content

Remove a commit only when it is **exclusively** one of:

1. documentation,
2. CI configuration,
3. test code.

**Judge from the diff, never from the file path.** A commit touching a path
under `src/` may still be documentation-only, and a commit touching a
documentation path may still change code. Path-based classification is provably
wrong: pvxs `67770b5` modifies `src/pvxs/data.h`, but every changed line sits
inside doxygen comment blocks - the prose moved to `value.rst` and a link
replaced it. No code changed. Classified by path it survives; classified by
content it is documentation.

Use the file list as a first pass only, then read the diff of anything that is
not unambiguous. Everything else advances to scoring, including tool-only
changes, cosmetic one-liners, and feature work. Whether those are worth
carrying is a scoring and decision question, not a filing question.

Applicability gate: a fix whose target code does not exist at the pinned
version cannot be carried. Record it as deferred, to re-enter at the next bump,
and state which prerequisite is missing (epics-base #917 and #856 are the
worked examples).

## Stage 2b - Dependency between fixes

Where the carry unit is a commit rather than a PR, fixes are not
independent. A commit merged after the pin may need an earlier post-pin commit
to apply or to build, and a PR-based range can chain the same way when one PR
builds on another. Establish the chains **before** scoring: `fit` cannot be
judged without them, and the decision is made on the chain, not on the tail
commit alone.

Two distinct relations, both worth recording, only one of which is a
dependency:

| Relation | Test | Consequence |
| :-- | :-- | :-- |
| Prerequisite | fails to apply or to build without the other | adopting the tail adopts the whole chain |
| File overlap | both modify the same file, neither needs the other | apply order is fixed and dry-run verified |

**Apply-clean does not imply build-clean.** A commit can apply without conflict
and still reference a symbol, header, or build rule that an earlier post-pin
commit introduced. Check both.

Verification without cloning the upstream repository - fetch only the files
involved, at the pinned tag, into a scratch tree:

```bash
# 1. the file(s) the commit touches, as of the pinned version
mkdir -p "$(dirname <scratch>/<path>)"
gh api "repos/<org>/<repo>/contents/<path>?ref=<pinned-tag>" -H "Accept: application/vnd.github.raw" > <scratch>/<path>
# 2. the commit as a git-format patch (a/ b/ prefixes, so -p1)
gh api "repos/<org>/<repo>/commits/<sha>" -H "Accept: application/vnd.github.patch" > <scratch>/<sha>.patch
# 3. apply test - exit 0 means it applies, nothing more
cd <scratch> && patch -p1 --dry-run < <sha>.patch
# 4. build dependency - do the names the change uses exist at the pin?
gh api "repos/<org>/<repo>/contents/<header-path>?ref=<pinned-tag>" -H "Accept: application/vnd.github.raw" | grep -n -A 12 "<symbol>"
```

Worked examples from the pvxs run. Prerequisite chain: `5ab17ec` fails
`git apply --check` at 1.5.2 (`tools/Makefile`) without `8cb8d4b`, and
`8cb8d4b` cannot build without the public header `2b99e3c` adds - one adopted
tail therefore carries roughly a thousand lines of new feature code. Clean
single fix: `086501a` dry-runs clean at 1.5.2, and the members it uses
(`client::Connected::time`, `client::Disconnect::time`) are both present in
1.5.2 `src/pvxs/client.h`, so it stands alone. File overlap: `39cc6fa`,
`d5ecc88`, and `cc7bc72` each modify `src/clientintrospect.cpp` independently,
so their apply order must be fixed though none requires another.

Present each chain alongside its fixes, so the decision is made on the
true cost of adopting them.

## Stage 3 - Five-reviewer eight-axis scoring

Every fix that survives Stage 2 is scored by **five independent
reviewers**, each of which reads the real upstream diff before scoring. A
one-line commit subject is a pointer, not evidence.

| Axis | Meaning |
| :-- | :-- |
| security | remote exposure reduced |
| safety | memory safety / robustness (UAF, OOB, lifetime, null deref) |
| bug | functional correctness fixed |
| perf | runtime performance |
| ops | facility operational value |
| urgency | harm if not carried before the next bump |
| fit | clean apply at the pinned version + low regression surface |
| locality | blast radius - leaf high, deep core low |

Each axis is an integer 0-10 (max 80). Take the **per-axis median** across the
five reviewers, not the mean and not a per-reviewer total.

Four properties make the panel trustworthy; preserve them in any
implementation.

- **Independence.** The five run concurrently and never see each other's
  scores. Reviewers are told not to anchor to any expected outcome.
- **Forced shape.** The output schema requires all eight axes as integers
  0-10 for every fix, so a reviewer cannot skip an axis or return prose
  where a number belongs.
- **Arithmetic outside the model.** Medians, totals, and the rule verdict are
  computed in code from the returned numbers. No model is asked to add or to
  decide adoption.
- **Raw scores kept.** The per-reviewer scores and notes are written to a file
  before anything is summarised, so a table can always be traced back.

Two further rules learned in execution:

- **Score the full surviving set in one run.** Scores are relative to the set
  in front of the reviewer. The same commit scored in a narrow set and in the
  full set will not land on the same medians, so never carry numbers across
  runs with different membership. In the pvxs run `084336b` scored total 37 in
  a six-fix run and total 44 in the nineteen-fix run.
- **Reviewers report findings, not only numbers.** Alongside the scores,
  require each reviewer to state the apply/build verification it performed and
  any defect it found *in the fix itself*. A defect in the upstream
  change is a reason not to carry it, and it will not show up in a score. In
  the pvxs run one reviewer verified that `5ab17ec` fails to apply, and another
  found that the JSON parser added by `2b99e3c` mishandles an array nested in
  an array, with no test covering it.

### Running the panel

Run the panel in an agent runtime that can start independent reviewers, with a
script of that runtime's own; the four properties above are what the script
must preserve. The input is the list of fixes that survive Stage 2, each with
a key, a slug, its commit shas, and a one-line description. Every reviewer gets
the same rubric:

- the eight axes of the table above, each an integer 0-10, defined as in that
  table;
- the baseline, the pinned upstream tag, and the statement that every fix was
  merged after it, so each is a "carry as a patch until the bump" question;
- the instruction to read the real upstream diff of every listed sha before
  scoring (`gh api repos/<org>/<repo>/commits/<sha> --jq '.files[] | "=== "+.filename+" ===", .patch'`),
  to report the apply and build check it performed and any defect it found in
  the fix itself, and to judge independently without anchoring to an expected
  outcome.

A reviewer answers with one entry per fix: the key, the eight integers, and a
note; any other shape is refused. The script then computes, in code, the median
of each axis over the reviewers, the total, and which conditions of Stage 4 the
fix meets, orders the table by total, and writes the raw scores and notes to
`panel-result.json` before any summary.

Two failure modes seen in execution. A reviewer that fails keeps its entry in
the raw output with an error and no scores; count only the reviewers that
returned scores, and run the panel again when fewer than five did. And a panel
over nineteen fixes reading real diffs takes on the order of fifteen minutes
and a few hundred thousand tokens; run it in the background and do other work
meanwhile.

## Stage 4 - Rule outcome

A fix meets the rule when **any one** of:

1. total >= 40 (50% of 80), OR
2. bug >= 5, OR
3. safety >= 5, OR
4. urgency >= 5.

The OR shape is deliberate: it is generous toward memory safety, plain
correctness, and time pressure, and indifferent to a fix whose value is
spread thinly across the non-gating axes. The outcome is therefore not a total
ordering. In the pvxs run, `7490286` met the rule at total 28 (bug 5) and
`cc7bc72` at total 29 (safety 5), while `086501a` missed at total 30 - its
value sat in ops 7, fit 9, locality 9, none of which gate. Such near-misses in
both directions are exactly what the maintainer decision exists for - present
them, do not bury them.

## Stage 5 - Maintainer decision

Present the complete table: every scored fix, its eight medians, its
total, which conditions it met, and the dependency chains from Stage 2b. The
maintainer decides.

Record every maintainer call - adoption of a rule-miss, removal of a rule-pass -
with its reason, in the execution's decision record.

**A fix the maintainer adds receives the same Stage 2b verification as any
other.** Entering the set by maintainer decision rather than by rule does not
exempt it from the apply and build-dependency checks; run them and record the
result beside the decision.

## Stage 6 - Apply-selection list

Before any patch is generated, produce the ordered list that the patch set will
mirror. This is the artefact that carries the decision into implementation.

| Column | Content |
| :-- | :-- |
| order | position in upstream merge order - the default apply order |
| sha / PR | the carry unit |
| title | short description |
| total | panel total, for traceability |
| basis | which rule conditions were met, or "maintainer decision" |
| overlap | which *other members of this list* modify a file this one modifies |

The overlap column is what makes the apply order verifiable: every pair sharing
a file must be dry-run tested in the listed order. A member that touches many
of the others' files belongs at the end of the list.

Every row of this list becomes one row of the patch-set summary table in
`patch/README.md`, added in the same change that adds the patch file (see
"Patch-set summary table" below). The summary carries no overlap column -
the apply order is fixed by the file names - and writes `maintainer` where this
list says "maintainer decision".

## Patch generation

Applies to the adopted set only.

- Generate a no-prefix p0 diff with `git diff --no-prefix`. Do **not** use
  `gh pr diff`, which emits `a/ b/` prefixes (p1) and fails `patch -p0`.
- Carry no added header - the patch is the raw `git diff --no-prefix`. The
  upstream source (PR number or commit sha) and the pinned version live in the
  file name instead (see the naming table below), so the provenance travels
  with the file without a header comment to drift.
- Verify every patch per-hunk with `patch --dry-run` against the pinned source.
  Blob drift after the tag is common; a clean apply is proven, never assumed.
  Hunks that reject need manual resolution against the pinned source, then a
  clean forward+reverse dry-run before wiring.
- Curate when a commit mixes a fix with unrelated feature or test material -
  carry the fix hunks only, and record what was dropped.

File naming, so that a lexicographic sort equals the apply order:

| Kind | Pattern | Example |
| :-- | :-- | :-- |
| Carry patch, PR | `<pin>-pr<NNNN>-<slug>.p0.patch`, PR number zero-padded to fixed width | `7.0.10-pr0817-mbbi-cosv-aftc.p0.patch` |
| Carry patch, commit | `<pin>-<NN>-<sha7>-<slug>.p0.patch`, `NN` a zero-padded sequence in upstream merge order | `1.5.2-03-7490286-pvalink-seq-point.p0.patch` |
| Site patch | `<pin>-site<NN>-<slug>.p0.patch`, or `<pin>-<NN>-site-<slug>.p0.patch` when it must apply before the PR patches; `NN` a zero-padded sequence in the order the patches were written. A module without a version-anchored glob names its site patch `<module>-<slug>.p0.patch` and applies it by its own `patch.<name>.apply` rule | `7.0.10-site01-dbyacc-eof.p0.patch` |

Commit hashes carry no order, so the sequence number supplies it. Assign the
numbers of carry patches from the Stage 6 list and never renumber a released
set; site patches are numbered in the order they are written.

## Wiring

- Build the apply list with `$(sort $(wildcard ...))` (C-locale ascending) and
  run `patch ... || exit 1` so a mid-stack failure fails the target.
- Revert reverses the list explicitly (`sort -r` / `tac`). Stacked patches only
  unapply in reverse apply order.
- Where a module has more than one apply leg, make the order between the
  legs explicit; do not leave it to a hyphen-vs-dot byte accident.
- Where two downstream patches touch the same file, the apply order is fixed
  and dry-run verified.
- Every apply rule is listed in `patch:` of `configure/RULES_SRC` and every
  revert rule in `patch.revert:`, the revert list in the reverse order of the
  apply list; a rule that is not listed never runs under `make patch`.
- A patch applied by its own rule, such as the site patch of a module without a
  version-anchored glob, has three rules in `configure/RULES_PATCH`:
  `patch.<name>.make`, which regenerates the file with `git diff --no-prefix`
  from the patched source tree, `patch.<name>.apply`, and `patch.<name>.revert`.
  A glob leg has the apply and the revert rule only.
- A carry that mixes commit-unit (`<NN>-<sha7>`) and PR (`pr<NNNN>`) filenames
  sorts every commit-unit before every PR patch (`0`-`9` precede `p`) - lexical
  order, not upstream merge order. That is harmless while no two of them touch
  the same file; where a commit-unit and a PR patch do, pin and dry-run the
  apply order per the rule above rather than trusting the sort. A site patch of
  the `site<NN>` form (`s` after `p`) sorts after both, so it applies on top
  of the carry patches; the `<NN>-site-` form sorts with the commit-unit
  patches, before the PR patches. The base apply glob is `-*` (not `-pr*`)
  precisely so it catches every filename form, site patches included.

## Verification

- `make patch` exits 0, and every downstream patch prints one `patching file`
  line for each file it touches.
- Patch apply-and-revert test: `make patch` then `make patch.revert` leaves
  each patched source tree as it was before the apply, with no `.orig` /
  `.rej` residue. `git status --short` in `pvxs-src` prints nothing; in
  `epics-base-src` it lists only `configure/CONFIG_SITE_ENV` and
  `configure/os/CONFIG_SITE.linux-x86_64.linux-x86_64`, which `make conf`
  writes.
- CI green across the platform matrix; the module checks pass on the test
  machines (`module-bump-procedure.md`, Stage 6); `make check.deps` exit 0
  unchanged - necessary, not sufficient.
- Targeted functional proof for any fix whose behaviour is not otherwise
  exercised, since the module's own test suite generally does not run here.
  Where per-fix proof is left upstream, record it as a scope limit rather than
  leaving a silent gap.
- Summary agreement: `patch/README.md` matches the directory. For each carry
  track, three numbers are the same: the carry files the track's apply glob
  matches (``ls patch/<pin>-*.p0.patch | grep -v -E '^patch/<pin>-(site[0-9]|[0-9]+-site-)' | wc -l``),
  the table rows (``grep -c '^| `<pin>-' patch/README.md``), and the count in
  that table's heading. For the site patches, three numbers are the same: the
  site files (``ls patch/<pin>-*.p0.patch | grep -c -E '^patch/<pin>-(site[0-9]|[0-9]+-site-)'``),
  the subsections (``grep -c -E '^### <pin>-(site[0-9]|[0-9]+-site-)' patch/README.md``),
  and the count in the heading of the site section. For a module without a
  version-anchored glob, the three numbers are the files its site patch rules
  name, the subsections of its site section, and the count in that heading. A
  patch without its row or subsection, or a row or subsection without its
  file, fails this check.

## Record discipline

The decision record states the funnel, so that nothing disappears quietly
between stages:

| Line | pvxs 1.5.2 run |
| :-- | :-- |
| enumerated | 25 |
| removed as exclusively doc / CI / test | 6 (one of them, `67770b5`, only after re-reading the diff) |
| deferred at the applicability gate | none deferred; no separate gate pass was run, the question was absorbed into the per-fix apply checks |
| scored | 19 |
| met the rule | 11 |
| added by maintainer decision | 1 (`086501a`) |
| removed by maintainer decision | 0 |
| selected for carry (Stage 6 list) | 12 |

Every removal names its reason and, where the classification is not obvious
from the path, the evidence from the diff.

## Patch-set summary table (`patch/README.md`)

The per-execution decision record holds the full funnel; the patch directory
holds the files. `patch/README.md` joins the two: one table row per carry
patch file and one subsection per site patch file, so that anyone looking at
the patch set can see why each file is there without opening the decision
records. It is a summary, never a second source of truth - the score tables
and maintainer decisions stay in the decision record, and the summary points
at them.

Draft each row from the Stage 6 list, complete it when the file name is fixed
(Patch generation), and add it to `patch/README.md` in the same change that
adds the patch file (Wiring); a retired patch's row leaves in the change that
removes its file. A patch without its summary row or subsection, or a row or
subsection without its file, is a wiring defect and fails the summary
agreement check in Verification above.

One table per carry track (`<module> <pin> carry (<count>)`), with these
columns:

| Column | Content |
| :-- | :-- |
| File | the patch file name without `.p0.patch` |
| Upstream | PR number or commit sha, and the upstream subject in a few words |
| Total /80 | the panel median total, copied from the decision record |
| Basis | the rule conditions the median met (`total`, `bug`, `safety`, `urgency`), and `maintainer` with a few words of the recorded reason when a maintainer decision added the file |
| Record | the run the row comes from, named without the identifier of an item in a release record: the release of the initial run (`1.3.0 initial run`), or the refresh's label and date (`Carry refresh 2026-09-03`). A closed release record is read at the commit that carries it, named by the History row of the next record, with `git show <commit>:docs/milestone-<release>.md` |

Below each table, one short paragraph names what was scored and not carried,
and what was deferred at the applicability gate - or states that none was -
so the table cannot be read as the whole set of fixes. Local build patches
(not upstream carries) get their own table with target, purpose, and the
`patch.<name>.apply` rule; dormant files that no rule applies are listed
as such.

Site patches get their own section, headed `<module> <pin> site patches
(<count>)`, with one subsection per file that names the case, the effect
without the patch, the reproduction, the change, the result with the patch,
where it was tested, and the upstream status.

Update rules:

- A refresh that adopts a patch adds its row. A refresh that adopts nothing
  adds no row; the fixes it scored and dropped are added to the
  paragraph below the table, and the refresh itself is recorded in the
  decision record.
- Rows are never re-scored in place. A later decision about the same file
  (curation, a maintainer reversal) adds to the `Basis` or `Record` cell; the
  original total stays.
- At a bump, rows and subsections of retired patches leave the tables together
  with their files, and those of patches that stay move under the headings of
  the new pin together with their renamed files, in the bump change. The retirement outcome (dropped as
  contained upstream, re-based, still needed) is recorded in the new release's
  decision record, and the summary tables are rebuilt from that record.
- The count in each table heading is the number of rows or subsections; the
  summary agreement check (Verification above) confirms it equals the number
  of files of that kind for that track.

## Bump obligation

Patches are recorded against the pinned version exactly. At the next version
change every downstream patch is re-examined - a carry patch dropped if
upstream now contains it, a site patch dropped if upstream now has the fix,
either one re-based if the region moved - and the verification above re-runs
on the new version before release. A patch that stays moves to the name of the
new pin (`git mv`), because the apply glob is anchored to the version and would
otherwise drop it without a message.

When the new release contains every carried fix and no site patch is re-based
onto it, the track retires: the version-anchored glob matches nothing, which
is confirmed by a real run of the apply and revert legs with the new version
on the make command line (`make patch.<leg>.apply SRC_VER_<KEY>=<new>` and the
revert), both exiting 0 with no iteration; the files, their `patch/README.md`
section, and every book sentence that names them go, and a book example that
regenerated one of them moves to a carry that stays on the tree, so that the
example still runs.
The pvxs 1.5.2 track retired this way at the 1.5.3 bump.
