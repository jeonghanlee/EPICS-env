# docs/ layout

This directory holds the EPICS-env book, the procedures of the work on this
repository, and the records of the releases.

## The book

The book source lives under [src/](./src), with its configuration in
`book.toml`. `.github/workflows/docs.yml` builds it with the
`jeonghanlee/mdbook` container image and publishes it at
<https://jeonghanlee.github.io/EPICS-env/>.

To build the book the same way from the repository root, run the same image
as your own user, so the output directory stays writable:

```bash
docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/work" -w /work jeonghanlee/mdbook mdbook build docs
```

The HTML lands in `docs/book/`, which Git ignores. To preview while editing,
serve it instead and open <http://localhost:3000>:

```bash
docker run --rm -it -u "$(id -u):$(id -g)" -p 3000:3000 -v "$PWD:/work" -w /work jeonghanlee/mdbook mdbook serve docs -n 0.0.0.0
```

## Procedures

`procedures/` holds the procedures of the work on this repository. Each
carries the roles, judgment stages, and record rules of one kind of work; the
book pages under `src/` cover the commands of the same work.

- `release-procedure.md`: the entry; the order of a release of EPICS-env,
  naming at each step the file that holds the rule.
- `release-checklist.md`: the checks of every step of the release, each
  checked only with its evidence.
- `module-bump-procedure.md`: move one pinned module, EPICS base included, to
  a newer upstream release or commit and verify it against the modules that
  build on it; one table gives the names a module has.
- `upstream-fix-carry-procedure.md`: decide which upstream fixes merged after
  the pin become carry patches, and how carry patches and site patches, the
  downstream patches of a module, are named, wired, verified, and re-examined
  at a bump. The summary of the patch set is
  [`patch/README.md`](../patch/README.md). The book pages that cover the
  commands are
  [`src/procedures/carry-upstream-fix.md`](src/procedures/carry-upstream-fix.md)
  for a carry patch and
  [`src/procedures/add-module-site-patch.md`](src/procedures/add-module-site-patch.md)
  for a site patch of a module.
- `upstream-fix-verification-procedure.md`: verify a fixed module against a
  production installation before adoption.
- `measComp-tc32-fix-20260912-215519.md`: an execution example of the
  verification procedure, the record of its first run, made before
  `tools/verify_fix_build.bash` and `tools/pv_snapshot.bash` existed.
- `commonIocsh-verification-procedure.md`: verify each common iocsh fragment
  against a test IOC.
- `site-modules-procedure.md`: build the site modules of a facility, which
  live in a site module repository that follows the make rules of EPICS-env,
  into an installed tree, and check the tree with the check targets of
  EPICS-env.
- `documentation-upkeep-procedure.md`: change a procedure at the close of a
  step, and reconcile the procedures and the archive after the release.

## Work records

- `milestone-1.5.0.md`: the release record of 1.5.0 on `release-1.5.0`; read
  it first. The record that master carries between 1.4.0 and 1.5.0 is
  `milestone-84ee626.md` at commit `4d521e7`, and the released 1.4.0 record is
  `milestone-1.4.0.md` at commit `84ee626`.
- `CLOSED_DOORS.md`: newer upstream releases examined outside a release cycle
  and left unchanged by the maintainer's decision, so a later review does not
  repeat the investigation.
- `design/makeRPath-perl-port/`: design records of the makeRPath port
  (issue #25).
- `archive/`: records of earlier releases and era-specific notes, kept as
  written:
  - `milestone-1.3.0.md`: the released 1.3.0 record.
  - `testplan_1.3.0.md`: the 1.3.0 test plan.
  - `plantest_1.2.2.md`: the 1.2.2 test plan.
  - `base-carry-1.3.0.md`: the EPICS base fix-carry decision record (#52).
  - `pvxs-carry-1.3.0.md`: the pvxs fix-carry decision record (#53).
  - `module-bumps-1.3.0.md`: the 1.3.0 module bump decision record (#21).
  - `module-management/`: the module-management section of the book before
    the 1.4.0 rebuild.
  - `README.macOS.11.md`: a platform note of the macOS 11 era.
  - `Libera_EPICS_configuration.md`: a cross-compile note for Libera
    (`linux-arm`).
  - `ALS-U-EPICS-Environment.md`: an install guide of the ALS-U RC era, with
    its exported PDF beside it.
