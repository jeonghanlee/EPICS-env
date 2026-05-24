# Module Management

## Scope

This document defines the module naming, dependency declaration, configure
type declaration, and validation conventions used by the EPICS-env Makefile
system.

**Out of scope:** operator commands for adding a module are covered in
[README.md](README.md). Module-specific patches and external vendor setup are
covered by each module's existing configuration rules.

## Data Flow

Module metadata flows through the build system in this order.

1. `configure/RELEASE` declares `SRC_NAME_*`, `SRC_TAG_*`, and `SRC_VER_*`.
2. `configure/CONFIG_MODS` generates `configure/MODULESGEN.mk` and
   `SRC_PATH_MODULES`.
3. `configure/CONFIG_MODS_DEPS` declares `<module>_DEPS` and
   `<module>_CONF_TYPE`.
4. `configure/RULES_FUNC` derives generated target names from
   `SRC_PATH_MODULES`.
5. `configure/RULES_MODS_CONFIG` provides the current explicit `conf.*`
   and `conf.*.show` targets.

## Module Keys

The module key used in `CONFIG_MODS_DEPS` must match the generated build
target key. The key is derived from `SRC_PATH_MODULES` by removing a trailing
`-src` path component and by reducing `recsync-src/client` to `recsync`.

```makefile
$(patsubst %-src,%, $(patsubst %/client, %, $(dir)))
```

The sequencer module has three names in the system.

| Layer | Name |
| :--- | :--- |
| Source module name | `sequencer` |
| Generated build target | `build.sequencer` |
| Installed module symlink | `seq` |

The dependency key is therefore `sequencer_DEPS`, not `sncseq_DEPS` or
`seq_DEPS`.

## Build Dependency Declarations

Each module declares its build prerequisites with `<module>_DEPS`.

```makefile
asyn_DEPS:=null.base build.sequencer build.sscan build.calc
```

The prerequisite order is significant because it becomes the prerequisite
order of the generated `build.<module>` target.

Modules with only EPICS Base as a prerequisite use `null.base`.

```makefile
pcas_DEPS:=null.base
```

## Configure Type Declarations

Each module declares exactly one configure type.

| Type | Meaning |
| :--- | :--- |
| `auto` | Configuration needs only `INSTALL_LOCATION` and simple local flags. |
| `custom` | Configuration needs module paths, vendor paths, source edits, or special files. |

Current behavior: `<module>_CONF_TYPE` is a validated declaration only. All
`conf.*` rules are still provided by `configure/RULES_MODS_CONFIG`.

Intended use: `auto` modules can later share generated `conf.*` and
`conf.*.show` rules. `custom` modules remain hand-written.

## Current Classification

| `auto` | `custom` |
| :--- | :--- |
| `MCoreUtils` | `asyn` |
| `autosave` | `busy` |
| `caPutLog` | `calc` |
| `ether_ip` | `linStat` |
| `iocStats` | `lua` |
| `pcas` | `mca` |
| `pscdrv` | `measComp` |
| `retools` | `modbus` |
| `snmp` | `motor` |
|  | `motorMotorSim` |
|  | `opcua` |
|  | `pmac` |
|  | `pvxs` |
|  | `recsync` |
|  | `scaler` |
|  | `sequencer` |
|  | `sscan` |
|  | `std` |
|  | `StreamDevice` |

## Validation

`CONFIG_MODS_DEPS` validates configure type declarations at Make parse time.
Every module derived from `SRC_PATH_MODULES` must declare `<module>_CONF_TYPE`,
and the value must be either `auto` or `custom`.

```makefile
define validate_conf_type
$(if $($(1)_CONF_TYPE),,$(error Missing $(1)_CONF_TYPE declaration))
$(if $(filter auto custom,$($(1)_CONF_TYPE)),,$(error Invalid $(1)_CONF_TYPE value: $($(1)_CONF_TYPE)))
endef
```

This makes missing declarations and spelling errors fail before any module
configuration or build recipe runs.

## Maintenance Rules

When adding or renaming a module, keep these declarations aligned.

1. `SRC_NAME_*` defines the source repository name.
2. `SRC_PATH_MODULES` defines the generated module key.
3. `<module>_DEPS` must use the generated module key.
4. `<module>_CONF_TYPE` must use the generated module key.
5. `RULES_MODS_CONFIG` must keep explicit `conf.*` rules until auto generation
   exists.
