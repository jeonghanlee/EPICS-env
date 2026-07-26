# Add a Module

## Scope

This document covers the operator procedure for adding an EPICS module to
this repository.

**Out of scope:** module naming rules, dependency key rules, and configure
type semantics are defined in [README.module-management.md](README.module-management.md).

## Procedure

1. Define the module source and version in `configure/RELEASE`.

```makefile
SRC_NAME_SNMP:=snmp
SRC_TAG_SNMP:=tags/v1.0.0.2j
SRC_VER_SNMP:=1.0.0.2j
```

2. Override the generated Git URL in `configure/CONFIG_MODS` when the
   module is not hosted under `github.com/epics-modules`.

```makefile
SRC_GITURL_SNMP:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_SNMP))
```

3. Declare the build dependencies and configure type in
   `configure/CONFIG_MODS_DEPS`.

```makefile
snmp_DEPS:=null.base
snmp_CONF_TYPE:=auto
```

4. Provide the configuration target.

For `auto` modules, `configure/RULES_MODS_CONF_AUTO` generates `conf.*` and
`conf.*.show` from the declarations in `configure/CONFIG_MODS_DEPS`.
The `snmp` example is an `auto` module, so it does not need an explicit rule
in `configure/RULES_MODS_CONFIG`.

For `custom` modules, add the target to `configure/RULES_MODS_CONFIG` and
keep the group target list and concrete rule synchronized.

5. Regenerate module metadata and verify the new module targets.

```bash
make reconf.modules
make PRINT.SRC_GITURL_SNMP
make PRINT.snmp_CONF_TYPE
make -n conf.snmp
make -n build.snmp
```

6. Initialize, configure, build, install, and link the module.

```bash
make init.modules
make conf.snmp
make conf.snmp.show
make build.snmp
make install.snmp
make symlink.snmp
make exist.modules LEVEL=0
```

## Configure Type

`<module>_CONF_TYPE` classifies whether the module configuration can be
generated from a simple pattern or must remain hand-written. `auto` modules
use generated `conf.*` targets; `custom` modules remain explicit rules.

See [README.module-management.md](README.module-management.md) for the
classification table and naming rules.
