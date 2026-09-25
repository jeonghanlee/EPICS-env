# Managing Modules

This guide covers the routine module operations: adding a module, changing
its version, switching its source repository, and retiring it. All of them
edit the same small set of declaration files and then rerun the build targets
those declarations generate.

## How module metadata flows

A module is described by declarations that the build system reads in order:

1. `configure/RELEASE` — `SRC_NAME_*`, `SRC_TAG_*`, and `SRC_VER_*` name the
   source repository, the checked-out ref, and the installed version string.
2. `configure/CONFIG_MODS` — `SRC_GITURL_*` overrides the Git URL for a
   module not hosted under `github.com/epics-modules`, and generates
   `configure/MODULESGEN.mk` and `SRC_PATH_MODULES`.
3. `configure/CONFIG_MODS_DEPS` — `<module>_DEPS` (build prerequisites) and
   `<module>_CONF_TYPE` (`auto` or `custom`).
4. `configure/RULES_MODS_CONF_AUTO` generates the `conf.*` targets for `auto`
   modules; `configure/RULES_MODS_CONFIG` holds the hand-written `conf.*`
   rules for `custom` modules.

## Conventions

**Module key.** The key used in every declaration is derived from
`SRC_PATH_MODULES` by dropping a trailing `-src` and reducing
`recsync-src/client` to `recsync`. The sequencer module carries three names:
the source name `sequencer`, the build target `build.sequencer`, and the
installed symlink `seq`. Its dependency key is `sequencer_DEPS`.

**Build prerequisites.** `<module>_DEPS` lists the build order, and the order
is significant because it becomes the prerequisite order of the generated
`build.<module>` target. A module that needs only EPICS Base uses `null.base`;
otherwise it names the `build.<dep>` targets it requires, in build order:

```makefile
<module>_DEPS:=null.base
<module>_DEPS:=null.base build.<dep> build.<dep>
```

**Configure type.** Each module declares exactly one `<module>_CONF_TYPE`:

| Type | Meaning |
| :--- | :--- |
| `auto` | Configuration needs only `INSTALL_LOCATION` and simple local flags; the `conf.*` rule is generated. |
| `custom` | Configuration needs module paths, vendor paths, or source edits; the `conf.*` rule is hand-written in `RULES_MODS_CONFIG`. |

`CONFIG_MODS_DEPS` validates this at make parse time: every module derived
from `SRC_PATH_MODULES` must declare a `<module>_CONF_TYPE` of `auto` or
`custom`, so a missing or misspelled value fails before any build recipe runs.

**Derived lists are not edit points.** A `custom` module's `conf.*` target
joins `MODS_ZERO_CUSTOM_VARS` (Base-only dependency) or `MODS_ONE_VARS`
(module dependencies). `MODS_ZERO_VARS` is derived from `MODS_ZERO_CUSTOM_VARS`
plus the generated auto targets; replacing it with a literal list drops every
auto module's configure target.

## Add a module

1. Declare the source and version in `configure/RELEASE` (`SRC_NAME_*`,
   `SRC_TAG_*`, `SRC_VER_*`).
2. In `configure/CONFIG_MODS`, add a `SRC_GITURL_*` override only when the
   module is not under `github.com/epics-modules`.
3. Declare `<module>_DEPS` and `<module>_CONF_TYPE` in
   `configure/CONFIG_MODS_DEPS`.
4. For a `custom` module, add its `conf.<module>` rule to
   `configure/RULES_MODS_CONFIG` and add the target to `MODS_ZERO_CUSTOM_VARS`
   or `MODS_ONE_VARS`. An `auto` module needs no rule; `conf.<module>` is
   generated.
5. Regenerate and build:

```bash
make reconf.modules
make init.modules
make conf.<module>
make build.<module>
make install.<module>
make symlink.<module>
```

Before building, `make -n conf.<module>` and `make -n build.<module>` confirm
the new targets resolve.

## Change a module version

Edit `SRC_TAG_*` and `SRC_VER_*` in `configure/RELEASE`, then re-clone and
rebuild that one module:

```bash
rm -rf <module>-src
make init.modules
make conf.<module>
make build.<module>
make install.<module>
```

## Change a module repository URL

`SRC_GITURL_*` in `configure/CONFIG_MODS` selects the source repository. The
default points at `github.com/epics-modules`, so moving a module back to the
community repository means commenting out its `SRC_GITURL_*` override and
setting the community ref in `configure/RELEASE`. Moving to a fork is the
reverse: add or uncomment the `SRC_GITURL_*` line pointing at the fork.
Re-clone and rebuild the module afterward, as in a version change.

## Remove a module

Retire a module by commenting out its declarations rather than deleting them,
so the record of what the module was stays in the files. Comment out:

- the `SRC_NAME_*`, `SRC_TAG_*`, and `SRC_VER_*` lines in `configure/RELEASE`
  (with any leading comment block);
- the `SRC_GITURL_*` line in `configure/CONFIG_MODS`, if present;
- the `<module>_DEPS` and `<module>_CONF_TYPE` lines in
  `configure/CONFIG_MODS_DEPS`;
- for a `custom` module, its `conf.<module>` and `conf.<module>.show` rules in
  `configure/RULES_MODS_CONFIG`, and its entry in `MODS_ZERO_CUSTOM_VARS` or
  `MODS_ONE_VARS`.

Commenting out the `RELEASE` pins drops the module from `SRC_PATH_MODULES`, so
its configure-type validation no longer applies. Then `make reconf.modules`,
`make init.modules`, and `make exist` confirm the module is gone.
