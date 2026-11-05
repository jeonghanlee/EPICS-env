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
  naming at each step the file that holds the rule; Maintainer and Executor
  responsibilities, starting inputs, and the default non-interactive execution
  through step 3, with interactive confirmation on request.
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
- `site-modules-procedure.md`: prepare site module sources with EPICS-env
  before the survey, include them in the combined dependency order and module
  cycles, and build and verify them in the shared installed tree.
- `documentation-upkeep-procedure.md`: change a procedure at the close of a
  step, and reconcile the procedures and the archive after the release.

## Work records

- [milestone-d8dcbe1.md](milestone-d8dcbe1.md): the current work register on master; read it first. It carries unfinished work after 1.5.0. The [closed 1.5.0 release record](https://github.com/jeonghanlee/EPICS-env/blob/d8dcbe12147842c34b8ec1f3f8187c18c6decc86/docs/milestone-1.5.0.md) is preserved at commit `d8dcbe1`. Earlier records remain reachable through its History.
- `source-inventory-1.5.0.tsv`: the combined source identities prepared at
  release step 2, including each module's owning repository, key, pin,
  version, and resolved commit; its preparation evidence is in the release record.
- `CLOSED_DOORS.md`: newer upstream releases examined outside a release cycle
  and left unchanged by the maintainer's decision, so a later review does not
  repeat the investigation.
- `design/makeRPath-perl-port/`: design records of the makeRPath port
  (issue #25).
- `archive/`: historical release records and era-specific notes. Findings
  retain their original scope; relative links follow the archive location.
  The ten 1.5.0 carry decision records are listed below; their nine companion
  score JSON files are stored beside them.

  - [ADCore-carry-1.5.0.md](archive/ADCore-carry-1.5.0.md): ADCore carry decisions.
  - [autosave-carry-1.5.0.md](archive/autosave-carry-1.5.0.md): autosave carry decisions.
  - [linstat-carry-1.5.0.md](archive/linstat-carry-1.5.0.md): linStat carry decisions.
  - [lua-carry-1.5.0.md](archive/lua-carry-1.5.0.md): lua carry decisions.
  - [modbus-carry-1.5.0.md](archive/modbus-carry-1.5.0.md): modbus carry decisions.
  - [motor-carry-1.5.0.md](archive/motor-carry-1.5.0.md): motor carry decisions.
  - [pvxs-carry-1.5.0.md](archive/pvxs-carry-1.5.0.md): pvxs carry decisions.
  - [pyDevSup-carry-1.5.0.md](archive/pyDevSup-carry-1.5.0.md): pyDevSup carry decisions.
  - [sscan-carry-1.5.0.md](archive/sscan-carry-1.5.0.md): sscan carry decisions.
  - [streamdevice-carry-1.5.0.md](archive/streamdevice-carry-1.5.0.md): StreamDevice carry decisions.

  Earlier records and platform notes:

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
