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

4. Add the configuration target to `configure/RULES_MODS_CONFIG`.

The current system still uses explicit `conf.*` targets for all modules.
Keep the group target list and the concrete rule synchronized.

```makefile
MODS_ZERO_VARS:=conf.iocStats conf.MCoreUtils conf.retools conf.caPutLog \
    conf.recsync conf.autosave conf.sncseq conf.ether_ip conf.sscan \
    conf.snmp conf.opcua conf.pvxs conf.pcas conf.pscdrv conf.linStat
```

```makefile
conf.snmp:
	@echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_SNMP)" > $(TOP)/$(SRC_PATH_SNMP)/configure/CONFIG_SITE.local

conf.snmp.show: conf.release.modules.show
	cat -b $(TOP)/$(SRC_PATH_SNMP)/configure/CONFIG_SITE.local
```

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
generated from a simple pattern or must remain hand-written. The value is
currently validation-only; automatic `conf.*` rule generation is a separate
build-system step.

See [README.module-management.md](README.module-management.md) for the
classification table and naming rules.
