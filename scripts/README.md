# Scripts

Operational helper scripts for the environment. The first three are sourced
or run to work with an installed tree; the rest build the environment or the
Libera cross target.

- `setEpicsEnv.bash` — source it to activate an installed EPICS environment:
  it sets `EPICS_BASE` and adds the tree's `bin` and `lib` to `PATH` and
  `LD_LIBRARY_PATH`. This script also ships inside each installed tree.
- `resetEpicsEnv.bash` — the reverse of `setEpicsEnv.bash`; sourcing it removes
  the environment from `PATH` and `LD_LIBRARY_PATH`.
- `selectEpicsEnv.bash` — pick among several installed environment versions and
  source the matching `setEpicsEnv.bash`.
- `build_epics.bash` — build EPICS-env (and EPICS-env-support) into an install
  location, writing the `configure/CONFIG_SITE.local` it needs first.
- `install_apps.bash` — build and install the example applications; assumes
  `build_epics.bash` has already run.
- `build_base_libera.bash` — build EPICS Base for the Libera `linux-arm` cross
  target.
- `build_modules_libera.bash` — build the module set for the Libera `linux-arm`
  cross target.

The former `caget_pvs.bash` has been removed; its successor is
[`tools/pvs_gets.bash`](../tools/README.md), documented under `tools/`.
