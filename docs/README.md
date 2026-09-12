# docs/ Layout

User-facing guides live under [src/](./src) and are published as an
mdBook site: <https://jeonghanlee.github.io/EPICS-env/>

## Building the book locally

CI builds the site with the `jeonghanlee/mdbook` container image (see
`.github/workflows/docs.yml`). Reproduce it from the repository root with the
same image, so a local build matches what CI runs:

    docker run --rm -v "$PWD:/work" -w /work jeonghanlee/mdbook mdbook build docs

The HTML lands in `docs/book/` (git-ignored). To preview while editing, serve
it instead and open <http://localhost:3000>:

    docker run --rm -it -p 3000:3000 -v "$PWD:/work" -w /work jeonghanlee/mdbook mdbook serve docs -n 0.0.0.0

## Working records

Everything outside `src/` is a working record, not part of the book:

- `milestone-1.4.0.md` — the active 1.4.0 Work Register (read first).
- `CLOSED_DOORS.md` — examined candidates the owner decided to keep as they
  are, so a later review does not repeat the investigation.
- `procedures/` — general procedures that outlive one release cycle:
  - `upstream-fix-carry-procedure.md` — the general fix-carry procedure.
  - `module-bump-procedure.md` — the module version bump procedure.
- `design/makeRPath-perl-port/` — makeRPath port design records (#25 context).
- `archive/` — past-cycle records and era-specific notes, kept as written:
  - `milestone-1.3.0.md` — the released 1.3.0 Work Register.
  - `testplan_1.3.0.md` — the 1.3.0 cycle test plan.
  - `plantest_1.2.2.md` — the 1.2.2 cycle test plan (shipped).
  - `base-carry-1.3.0.md` — base fix-carry decision record (#52).
  - `pvxs-carry-1.3.0.md` — pvxs fix-carry decision record (#53).
  - `module-bumps-1.3.0.md` — 1.3.0 module bump decision record (#21).
  - `module-management/` — the book's module-management section as it stood
    before the 1.4.0 rebuild.
  - `README.macOS.11.md` — archived platform note (macOS 11 / M1 era).
  - `Libera_EPICS_configuration.md` — archived cross-compile note (Libera,
    `linux-arm`).
  - `ALS-U-EPICS-Environment.md` — archived ALS-U RC-era install guide, with
    its exported PDF alongside.
