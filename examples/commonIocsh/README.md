# Common iocsh example

The startup file `iocBoot/caPutLog-shell.cmd` loads the `caPutLog.iocsh` common
fragment through the installed `iocsh.bash`, and `verify_caputlog.pl` checks that
fragment through it. The EPICS-env book,
published at <https://jeonghanlee.github.io/EPICS-env/>, describes both:

- [Run the fragment verification suite](../../docs/src/procedures/run-fragment-verification-suite.md):
  run `verify_caputlog.pl` against an installed tree, which needs no IOC build,
  and read its evidence.
- [Common iocsh fragments](../../docs/src/concepts/common-iocsh-fragments.md):
  what each fragment does, and how an IOC loads it through `IOCSH_TOP`.

Agents follow
[`docs/procedures/commonIocsh-verification-procedure.md`](../../docs/procedures/commonIocsh-verification-procedure.md).
