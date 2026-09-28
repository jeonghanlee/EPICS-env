# Tools

The programs in this directory are described in the EPICS-env book,
published at <https://jeonghanlee.github.io/EPICS-env/>:

- [Tools and scripts reference](../docs/src/reference/tools-and-scripts.md):
  the purpose, interface, exit status, and callers of every tool.
- [Build and install verification gates](../docs/src/concepts/verification-gates.md)
  and [Run the verification gates](../docs/src/procedures/run-verification-gates.md):
  the make targets that run `check_deps.bash`, `check_env.bash`, and
  `audit_module_deps.bash`.
- [Verify a fix against an installed tree](../docs/src/procedures/verify-fix-against-installed-tree.md):
  `verify_fix_build.bash` and `pv_snapshot.bash`.
- [Add or bump a module](../docs/src/procedures/add-or-bump-module.md):
  `update-release.bash check`.

Agents follow the procedures in `docs/procedures/`:
[`upstream-fix-verification-procedure.md`](../docs/procedures/upstream-fix-verification-procedure.md)
uses `verify_fix_build.bash` and `pv_snapshot.bash`, and
[`module-bump-procedure.md`](../docs/procedures/module-bump-procedure.md)
uses `update-release.bash`.
