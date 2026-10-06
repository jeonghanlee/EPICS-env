# docs/ layout

This directory holds the EPICS-env book, the procedures that AI agents follow,
and the work records of the release cycles.

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

## Agent procedures

`procedures/` holds procedures written for AI agents to follow. Each carries
the roles, judgment stages, and record rules of one kind of work; the book
pages cover the commands of the same work for a person.

- `module-bump-procedure.md`: move a module pin to a newer upstream release.
- `upstream-fix-carry-procedure.md`: select upstream fixes merged after the
  pin of EPICS base or pvxs and carry them as patches.
- `upstream-fix-verification-procedure.md`: verify a fixed module against a
  production installation before adoption.
- `measComp-tc32-fix-20260912-215519.md`: an execution example of the
  verification procedure, the record of its first run, made before
  `tools/verify_fix_build.bash` and `tools/pv_snapshot.bash` existed.
- `commonIocsh-verification-procedure.md`: verify each common iocsh fragment
  against a test IOC.

## Work records

- [milestone-1.5.0.md](milestone-1.5.0.md): the active release plan and Backlog on
  `release-1.5.0`; read it first.
- `milestone-84ee626.md`: the retained historical master snapshot, including
  completed work and earlier evidence. The released 1.4.0 register is
  `milestone-1.4.0.md` at commit `84ee626`.
- `CLOSED_DOORS.md`: examined candidates the owner decided to keep as they
  are, so a later review does not repeat the investigation.
- `design/makeRPath-perl-port/`: design records of the makeRPath port
  (issue #25).
- `archive/`: records of earlier cycles and era-specific notes, kept as
  written:
  - `milestone-1.3.0.md`: the released 1.3.0 work register.
  - `testplan_1.3.0.md`: the 1.3.0 cycle test plan.
  - `plantest_1.2.2.md`: the 1.2.2 cycle test plan.
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
