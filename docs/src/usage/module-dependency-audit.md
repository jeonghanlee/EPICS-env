# Module Dependency Audit

`configure/CONFIG_MODS_DEPS` is the build-order source of truth, and its
`<module>_DEPS` lines are maintained by hand. The dependency audit checks
those declarations against evidence gathered from the module source trees, so
a missing or wrong prerequisite is caught before it produces a broken build
order.

## What it inspects

For each module the audit reads the declared `<module>_DEPS`, then collects
the dependencies actually visible in the source: `RELEASE.local` macros,
Makefile library references, DBD and DB includes, StreamDevice protocol
references, and source header includes. A single signal is not proof on its
own, so the audit keeps the evidence behind each dependency it reports.

Every observed token is classified against the maps in
`configure/CONFIG_MODS_AUDIT`: module aliases (for example `SNCSEQ` resolves
to `sequencer`), external tokens (system libraries such as `usb`, `ssl`, or
`z`), and EPICS Base tokens and record types. Tokens outside the module set
are not treated as missing module dependencies.

## Required versus optional

A dependency is **required** when the source uses it unconditionally, and
**optional** when its use is guarded. A module inclusion wrapped in an
`ifeq` / `ifneq` / `ifdef` / `ifndef` block, or a startup script referenced
only from a conditional path, is classified optional rather than required, so
a guarded dependency that is not declared is not reported as a missing
required dependency.

## Commands

```bash
make audit.module-deps
make audit.module-deps MODULE=calc
make audit.module-deps FORMAT=json
make check.module-deps
```

`audit.module-deps` prints a human-readable report (or JSON with
`FORMAT=json`) and does not fail the build. `check.module-deps` applies the
strict policy: it fails when a required, observed dependency is not declared.
Scope either command to one module with `MODULE=<key>`, using the module key
convention from [Managing Modules](managing-modules.md).

## Where it runs

`check.module-deps` is the pre-build gate. CI runs it as part of
`make github.check` before compiling, so a dependency-declaration mismatch
stops the build early. It is distinct from `make check.deps`, the
post-install audit that inspects the installed binaries and their RUNPATH
entries; the two gates guard opposite ends of the build.
