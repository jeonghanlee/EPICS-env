# Scripts

The scripts in this directory are described in the EPICS-env book,
published at <https://jeonghanlee.github.io/EPICS-env/>:

- [Set up a shell with the environment](../docs/src/procedures/set-up-shell.md):
  `setEpicsEnv.bash` and `resetEpicsEnv.bash`.
- [Tools and scripts reference](../docs/src/reference/tools-and-scripts.md):
  every script in this directory except the two Libera scripts, its use, and
  whether `make install` installs it.

The Libera cross-build scripts are outside the book: `build_base_libera.bash`
builds EPICS base, and `build_modules_libera.bash` builds nine of the modules,
for the Libera `linux-arm` cross target.
