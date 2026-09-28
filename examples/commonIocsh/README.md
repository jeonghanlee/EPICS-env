# Common iocsh example

This example IOC loads the `caPutLog.iocsh` common fragment, and
`verify_caputlog.py` checks that fragment through it. The EPICS-env book,
published at <https://jeonghanlee.github.io/EPICS-env/>, describes both:

- [Run the fragment verification suite](../../docs/src/procedures/run-fragment-verification-suite.md):
  build the IOC against an installed tree with `make CHECK_RELEASE=NO`, run
  `verify_caputlog.py`, and read its evidence.
- [Common iocsh fragments](../../docs/src/concepts/common-iocsh-fragments.md):
  what each fragment does, and the `IOCSH_TOP` form this IOC uses.

Agents follow
[`docs/procedures/commonIocsh-verification-procedure.md`](../../docs/procedures/commonIocsh-verification-procedure.md).
