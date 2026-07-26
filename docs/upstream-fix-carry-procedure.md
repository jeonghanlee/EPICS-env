# Upstream Fix Carry — General Procedure

How to decide which upstream fixes, merged after the version this environment
pins, are carried as local patches until the next version bump — and how to
carry them.

This document is written to be executed from itself. An agent arriving with no
memory of any previous execution should be able to work through it end to end.
Everything needed to reproduce the mechanics — commands, the scoring harness,
the verification recipes — is written here rather than referenced from a
scratch directory, because `/work/` is gitignored in this repository and does
not survive.

Applies to any pinned upstream module. First executed for epics-base R7.0.10
(decision record: `docs/base-carry-1.3.0.md`, M22 / #52); second execution is
pvxs `tags/1.5.2` -> `master`. This document is the general form; each
execution keeps its own decision record under `docs/` holding the candidate
table and the outcome.

## Roles

| Role | Does | Does NOT |
| :-- | :-- | :-- |
| Owner | Decides which candidates are carried; signs the result | — |
| Agent | Enumerates the range, classifies by evidence, verifies dependencies, runs the scoring panel, presents the full table | Narrow the candidate set to a shortlist; treat the rule outcome as the decision |

The scoring rule produces a **recommendation**, not a decision. The adopted set
is whatever the owner says it is: the owner may adopt a candidate the rule
drops, or drop one the rule adopts. Record such calls with their reason in the
execution's decision record (epics-base #890 and pvxs `086501a` are the worked
examples).

**The agent presents every surviving candidate, scored.** Reducing the set to
the ones the agent finds interesting removes the owner's material before the
decision is made. The only removals the agent may perform are the mechanical
ones in Stage 2, and each must be defensible from the diff. In the pvxs run the
agent first cut 25 candidates to 6 on its own judgement; scoring the full
surviving 19 later showed `090bf5f`, one of the commits that cut had discarded
as cosmetic, meeting the rule at bug 6 / ops 8.

## Working layout

```
work/<module>-carry/          # scratch; gitignored, nothing here survives
  commits.tsv                 # Stage 1: sha, date, subject
  files.txt                   # Stage 1: changed-file list per commit
  patches.txt                 # Stage 1: real diff text per commit
  classification.md           # Stage 2/2b: per-commit verdict + dependency chains
  panel.mjs                   # Stage 3: scoring harness
  panel-result.json           # Stage 3: raw panel output, kept for audit
docs/<module>-carry-<ver>.md  # durable decision record; this is what survives
```

Anything that must outlive the session goes into `docs/`. Treat `work/` as a
desk, not a filing cabinet.

## Stage 1 — Enumerate the full range

Compare the pinned tag against the upstream default branch and take every
commit in between. No sampling, no "the interesting ones".

```bash
gh api repos/<org>/<repo>/compare/<pinned-tag>...<default-branch> --jq '.commits[] | .sha + "\t" + (.commit.author.date[0:10]) + "\t" + (.commit.message|split("\n")[0])' > work/<module>-carry/commits.tsv
```

Record the total, and confirm upstream has published no release tag above the
pin — a carry is the correct response only while no bump is available:

```bash
gh api repos/<org>/<repo>/tags --jq '.[].name' | head -5
```

The commit order returned by `compare` is the upstream merge order. Keep it:
it is the default apply order later.

Then fetch each commit's changed-file list and its real diff. **Run these in
the background.** Twenty-five sequential API calls exceed a one-minute
foreground tool timeout; a background script that appends to a file survives
and can be read as it fills.

```bash
# work/<module>-carry/fetch.sh — run in background, then read the output files
while IFS=$'\t' read -r sha date subj; do
  printf '%s\t%s\t%s\n\t%s\n' "${sha:0:7}" "$date" "$subj" \
    "$(gh api "repos/<org>/<repo>/commits/$sha" --jq '[.files[] | (.status[0:1]) + ":" + .filename] | join("  ")')" >> files.txt
  { printf '\n########## %s ##########\n' "$sha"
    gh api "repos/<org>/<repo>/commits/$sha" --jq '.commit.message, (.files[] | "\n----- FILE: " + .filename + " (" + .status + ", +" + (.additions|tostring) + "/-" + (.deletions|tostring) + ") -----", .patch)'
  } >> patches.txt
done < commits.tsv
echo DONE >> files.txt
```

Upstream projects differ in how work lands. epics-base moves through pull
requests, so the carry unit is a PR. pvxs is committed directly by its
maintainer, so the carry unit is a commit. Do not assume PR numbers exist.

## Stage 2 — Mechanical removal, judged by content

Remove a commit only when it is **exclusively** one of:

1. documentation,
2. CI configuration,
3. test code.

**Judge from the diff, never from the file path.** A commit touching a path
under `src/` may still be documentation-only, and a commit touching a
documentation path may still change code. Path-based classification is provably
wrong: pvxs `67770b5` modifies `src/pvxs/data.h`, but every changed line sits
inside doxygen comment blocks — the prose moved to `value.rst` and a link
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

## Stage 2b — Dependency between candidates

Where the carry unit is a commit rather than a PR, candidates are not
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

Verification without cloning the upstream repository — fetch only the files
involved, at the pinned tag, into a scratch tree:

```bash
# 1. the file(s) the commit touches, as of the pinned version
gh api "repos/<org>/<repo>/contents/<path>?ref=<pinned-tag>" -H "Accept: application/vnd.github.raw" > <scratch>/<path>
# 2. the commit as a git-format patch (a/ b/ prefixes, so -p1)
gh api "repos/<org>/<repo>/commits/<sha>" -H "Accept: application/vnd.github.patch" > <scratch>/<sha>.patch
# 3. apply test — exit 0 means it applies, nothing more
cd <scratch> && patch -p1 --dry-run < <sha>.patch
# 4. build dependency — do the names the change uses exist at the pin?
gh api "repos/<org>/<repo>/contents/<header-path>?ref=<pinned-tag>" -H "Accept: application/vnd.github.raw" | grep -n -A 12 "<symbol>"
```

Worked examples from the pvxs run. Prerequisite chain: `5ab17ec` fails
`git apply --check` at 1.5.2 (`tools/Makefile`) without `8cb8d4b`, and
`8cb8d4b` cannot build without the public header `2b99e3c` adds — one adopted
tail therefore carries roughly a thousand lines of new feature code. Clean
single candidate: `086501a` dry-runs clean at 1.5.2, and the members it uses
(`client::Connected::time`, `client::Disconnect::time`) are both present in
1.5.2 `src/pvxs/client.h`, so it stands alone. File overlap: `39cc6fa`,
`d5ecc88`, and `cc7bc72` each modify `src/clientintrospect.cpp` independently,
so their apply order must be fixed though none requires another.

Present each chain alongside its candidates, so the decision is made on the
true cost of adopting them.

## Stage 3 — Five-reviewer eight-axis scoring

Every candidate that survives Stage 2 is scored by **five independent
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
| locality | blast radius — leaf high, deep core low |

Each axis is an integer 0-10 (max 80). Take the **per-axis median** across the
five reviewers, not the mean and not a per-reviewer total.

Four properties make the panel trustworthy; preserve them in any
reimplementation.

- **Independence.** The five run concurrently and never see each other's
  scores. Reviewers are told not to anchor to any expected outcome.
- **Forced shape.** The output schema requires all eight axes as integers
  0-10 for every candidate, so a reviewer cannot skip an axis or return prose
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
  a six-candidate run and total 44 in the nineteen-candidate run.
- **Reviewers report findings, not only numbers.** Alongside the scores,
  require each reviewer to state the apply/build verification it performed and
  any defect it found *in the candidate itself*. A defect in the upstream
  change is a reason not to carry it, and it will not show up in a score. In
  the pvxs run one reviewer verified that `5ab17ec` fails to apply, and another
  found that the JSON parser added by `2b99e3c` mishandles an array nested in
  an array, with no test covering it.

### Scoring harness

The implementation below targets an agent runtime offering `agent()` and
`parallel()`; the four properties above are what must be preserved if the
runtime differs. Candidates arrive as `args.candidates`, each
`{key, slug, shas[], desc}`.

```javascript
const AXES = ['security','safety','bug','perf','ops','urgency','fit','locality']

const RUBRIC = `
Score EACH candidate on EIGHT axes, integer 0-10 each.
[...axis definitions, verbatim from the table above...]
Baseline is upstream tag <PIN>. These candidates were merged AFTER it and this
environment pins it, so each is a "carry as a patch until the bump" question.
You MUST read the REAL upstream diff of every listed sha before scoring:
  gh api repos/<org>/<repo>/commits/<sha> --jq '.files[] | "=== "+.filename+" ===", .patch'
Do not score from the description alone. Also report the apply/build check you
performed and any defect you find in the candidate itself.
Judge independently; do not anchor to any expected outcome.`

const SCHEMA = { type:'object', required:['scores'], properties:{ scores:{ type:'array',
  items:{ type:'object', required:['key',...AXES,'note'], properties:{
    key:{type:'string'}, note:{type:'string'},
    ...Object.fromEntries(AXES.map(a=>[a,{type:'integer',minimum:0,maximum:10}])) } } } } }

const dossier = candidates.map(c =>
  `[${c.key}] ${c.slug}\n  shas: ${c.shas.join(', ')}\n  what: ${c.desc}`).join('\n\n')

const raw = (await parallel([1,2,3,4,5].map(n => () =>
  agent(`You are independent reviewer #${n} of five on a fix-carry adoption panel.
${RUBRIC}\n\nCandidates (score ALL of them):\n\n${dossier}`,
    { label:`reviewer-${n}`, schema:SCHEMA })
  .then(r => ({ reviewer:n, scores:(r && r.scores) || [] }))))).filter(Boolean)

const median = a => { const s=[...a].sort((x,y)=>x-y), m=s.length>>1
                      return s.length%2 ? s[m] : (s[m-1]+s[m])/2 }

const table = candidates.map(c => {
  const med = {}
  for (const ax of AXES) {
    const v = raw.map(r => (r.scores.find(x=>x.key===c.key)||{})[ax])
                 .filter(x => typeof x === 'number')
    med[ax] = v.length ? median(v) : null
  }
  const total = AXES.reduce((t,ax) => t + (med[ax]||0), 0)
  const conditions = [ total>=40 && 'total>=40', med.bug>=5 && 'bug>=5',
                       med.safety>=5 && 'safety>=5', med.urgency>=5 && 'urgency>=5' ].filter(Boolean)
  return { key:c.key, slug:c.slug, ...med, total, pct:Math.round(total/80*1000)/10,
           meetsRule: conditions.length > 0, conditions }
}).sort((a,b) => b.total - a.total)

return { table, raw, reviewerCount: raw.length }
```

Two failure modes seen in execution. If the runtime hands `args` to the script
as a JSON string rather than an object, `args.candidates` is undefined and the
run finishes with zero agents — parse defensively. And a panel over nineteen
candidates reading real diffs takes on the order of fifteen minutes and a few
hundred thousand tokens; run it in the background and do other work meanwhile.

## Stage 4 — Rule outcome

A candidate meets the rule when **any one** of:

1. total >= 40 (50% of 80), OR
2. bug >= 5, OR
3. safety >= 5, OR
4. urgency >= 5.

The OR shape is deliberate: it is generous toward memory safety, plain
correctness, and time pressure, and indifferent to a candidate whose value is
spread thinly across the non-gating axes. The outcome is therefore not a total
ordering. In the pvxs run, `7490286` met the rule at total 28 (bug 5) and
`cc7bc72` at total 29 (safety 5), while `086501a` missed at total 30 — its
value sat in ops 7, fit 9, locality 9, none of which gate. Such near-misses in
both directions are exactly what the owner decision exists for — present them,
do not bury them.

## Stage 5 — Owner decision

Present the complete table: every scored candidate, its eight medians, its
total, which conditions it met, and the dependency chains from Stage 2b. The
owner decides.

Record every owner call — adoption of a rule-miss, removal of a rule-pass —
with its reason, in the execution's decision record.

**A candidate the owner adds receives the same Stage 2b verification as any
other.** Entering the set by owner decision rather than by rule does not
exempt it from the apply and build-dependency checks; run them and record the
result beside the decision.

## Stage 6 — Apply-selection list

Before any patch is generated, produce the ordered list that the patch set will
mirror. This is the artefact that carries the decision into implementation.

| Column | Content |
| :-- | :-- |
| order | position in upstream merge order — the default apply order |
| sha / PR | the carry unit |
| title | short description |
| total | panel total, for traceability |
| basis | which rule conditions were met, or "owner decision" |
| overlap | which *other members of this list* modify a file this one modifies |

The overlap column is what makes the apply order verifiable: every pair sharing
a file must be dry-run tested in the listed order. A member that touches many
of the others' files belongs at the end of the list.

## Patch generation

Applies to the adopted set only.

- Generate a no-prefix p0 diff with `git diff --no-prefix`. Do **not** use
  `gh pr diff`, which emits `a/ b/` prefixes (p1) and fails `patch -p0`.
- Name the upstream source (PR URL or commit sha) and the pinned version in the
  patch header.
- Verify every patch per-hunk with `patch --dry-run` against the pinned source.
  Blob drift after the tag is common; a clean apply is proven, never assumed.
  Hunks that reject need manual resolution against the pinned source, then a
  clean forward+reverse dry-run before wiring.
- Curate when a commit mixes a fix with unrelated feature or test material —
  carry the fix hunks only, and record what was dropped.

File naming, so that a lexicographic sort equals the apply order:

| Carry unit | Pattern | Example |
| :-- | :-- | :-- |
| PR | `<pin>-pr<NNNN>-<slug>.p0.patch`, PR number zero-padded to fixed width | `7.0.10-pr0817-mbbi-cosv-aftc.p0.patch` |
| Commit | `<pin>-<NN>-<sha7>-<slug>.p0.patch`, `NN` a zero-padded sequence in upstream merge order | `1.5.2-03-7490286-pvalink-seq-point.p0.patch` |

Commit hashes carry no order, so the sequence number supplies it. Assign the
numbers from the Stage 6 list and never renumber a released set.

## Wiring

- Build the apply list with `$(sort $(wildcard ...))` (C-locale ascending) and
  run `patch ... || exit 1` so a mid-stack failure fails the target.
- Revert reverses the list explicitly (`sort -r` / `tac`). Stacked patches only
  unapply in reverse apply order.
- Make the order between the version patch leg and the fix-carry leg explicit;
  do not leave it to a hyphen-vs-dot byte accident.
- Where two carried patches touch the same file, the apply order is fixed and
  dry-run verified.

## Verification

- `make patch` exits 0 with one `patching file` line observed per patch.
- Round trip: `make patch` then `make patch.revert` leaves the source tree clean
  (`git status --short` empty) with no `.orig` / `.rej` residue.
- CI green across the platform matrix; VM build and smoke test pass; strict
  `check_deps.bash` exit 0 unchanged — necessary, not sufficient.
- Targeted functional proof for any fix whose behaviour is not otherwise
  exercised, since the module's own test suite generally does not run here.
  Where per-fix proof is left upstream, record it as a scope limit rather than
  leaving a silent gap.

## Record discipline

The decision record states the funnel, so that nothing disappears quietly
between stages:

| Line | pvxs 1.5.2 run |
| :-- | :-- |
| enumerated | 25 |
| removed as exclusively doc / CI / test | 6 (one of them, `67770b5`, only after re-reading the diff) |
| deferred at the applicability gate | none deferred; no separate gate pass was run, the question was absorbed into the per-candidate apply checks |
| scored | 19 |
| met the rule | 11 |
| added by owner decision | 1 (`086501a`) |
| removed by owner decision | 0 |
| selected for carry (Stage 6 list) | 12 |

Every removal names its reason and, where the classification is not obvious
from the path, the evidence from the diff.

## Bump obligation

Patches are recorded against the pinned version exactly. At the next version
change every carry is re-examined — dropped if upstream now contains it,
re-based if the region moved — and the verification above re-runs on the new
version before release.

## Glossary (용어)

### Procedure terms

| English | 한글 | 뜻 |
| :-- | :-- | :-- |
| upstream | 상류 | 우리가 가져다 쓰는 원본 저장소 |
| pinned version | 고정 버전 | 이 환경이 고정해 쓰는 특정 태그 (base 7.0.10, pvxs 1.5.2) |
| carry | 캐리 | 고정 버전은 그대로 둔 채, 상류가 고친 것만 우리 쪽 패치로 얹어 두는 일 |
| bump | 버전 갱신 | 고정 버전을 상류의 새 버전으로 올리는 일 |
| candidate | 후보 | 캐리 여부를 판단할 대상 커밋 또는 PR |
| applicability gate | 적용 가능성 관문 | 고정 버전에 고칠 대상 코드가 실제로 있는지 보는 첫 관문 |
| sweep | 제외 | 문서·CI·테스트만 건드린 커밋을 목록에서 덜어내는 일 |
| prerequisite | 선행 관계 | 그것이 먼저 없으면 붙지도 빌드되지도 않는 관계 |
| file overlap | 같은 파일 겹침 | 서로 필요하지는 않지만 같은 파일을 고쳐 적용 순서가 정해져야 하는 관계 |
| axis | 평가 축 | 후보를 재는 여덟 가지 잣대 |
| median | 중앙값 | 리뷰어 다섯 명의 점수를 크기순으로 늘어놓았을 때 한가운데 값 |
| four-condition OR | 네 조건 중 하나 | 합계 40 이상, 결함 5 이상, 안전 5 이상, 시급 5 이상 중 하나만 넘으면 규칙 통과 |
| apply-selection list | 적용 선택 목록 | 결정된 것을 적용 순서대로 늘어놓은 표 |
| decision record | 결정 기록 | 무엇을 왜 실었는지 남기는 문서 |

### The eight axes

| English | 한글 | 뜻 |
| :-- | :-- | :-- |
| security | 보안 | 원격에서 건드릴 수 있는 공격 표면이 줄어드는 정도 |
| safety | 안전 | 메모리 안전과 견고성 (해제 후 사용, 범위 밖 접근, 수명, 널 참조) |
| bug | 결함 | 이것이 없으면 틀린 결과가 나오는 문제를 고치는 정도 |
| perf | 성능 | 실행 속도나 자원 사용이 나아지는 정도 |
| ops | 운영 | 가속기 제어 현장에서의 실제 쓸모 |
| urgency | 시급 | 다음 버전 갱신 전까지 싣지 않으면 생기는 피해 |
| fit | 적합 | 고정 버전에 깔끔히 적용되고 회귀 위험이 낮은 정도 |
| locality | 국소성 | 파급 범위. 말단 수정은 높게, 여러 곳이 기대는 핵심 수정은 낮게 |

### Patch terms

| English | 한글 | 뜻 |
| :-- | :-- | :-- |
| p0 patch | 접두어 없는 패치 | 파일 경로 앞에 `a/` `b/` 가 붙지 않은 형식. `patch -p0` 로 적용 |
| hunk | 변경 덩어리 | 패치 안에서 `@@` 로 시작하는 한 구간 |
| dry-run | 모의 적용 | 실제로 고치지 않고 적용되는지만 확인하는 것 |
| reject (`.rej`) | 거부된 덩어리 | 적용에 실패해 따로 남는 파일 |
| blob drift | 원본 어긋남 | 태그 이후 주변 코드가 바뀌어 패치가 그대로 맞지 않는 상태 |
| round trip | 왕복 확인 | 적용했다가 되돌렸을 때 원래대로 돌아오는지 보는 검사 |
| blast radius | 파급 범위 | 그 수정에 기대는 코드가 얼마나 되는지 |

### Defect terms

| English | 한글 | 뜻 |
| :-- | :-- | :-- |
| use-after-free (UAF) | 해제 후 사용 | 이미 반납한 메모리를 다시 사용하는 결함 |
| out-of-bounds (OOB) | 범위 밖 접근 | 정해진 범위 밖을 읽거나 쓰는 결함 |
| undefined behavior (UB) | 정의되지 않은 동작 | 표준이 결과를 보장하지 않는 코드. 잘 도는 것처럼 보이다 어긋남 |
| lifetime | 수명 | 객체가 살아 있는 구간. 콜백이 도는 중에 그 객체를 없애면 어긋남 |
