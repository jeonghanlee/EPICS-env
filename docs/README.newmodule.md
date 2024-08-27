# New Module

I would like to add the following repository for the production environemnt.

https://github.com/DiamondLightSource/pmac

##

The commit is July 15, 2024 at the `dls-master` branch
In `configure/RELEASE`


```bash
# https://github.com/DiamondLightSource/pmac
# 2024-07-15 dls-master
SRC_URL_PMAC:=https://github.com/DiamondLightSource/pmac¶
SRC_NAME_PMAC:=pmac
SRC_TAG_PMAC:=3d2e73f
SRC_VER_PMAC:=3d2e73f
```

 Edit `configure/CONFIG_MODS` if the module URL is not `github/epics-modules`

```
SRC_GITURL_PMAC:=$(strip $(SRC_URL_PMAC))/$(strip $(SRC_NAME_PMAC))
```

 Edit `configure/CONFIG_MODS_DEPS`

```bash
pmac_DEPS:=null.base build.asyn build.calc build.motor build.busy¶
```



* Edit `configure/RULES_MODS_CONFIG`

Please consult `XXXApp/src/Makefile` to check its real dependency and add the proper configuration name in one of the following variables.

    - `MOD_ZERO_VARS` : This module has only EPICS base dependency.
    - `MOD_ONE_VARS` : This module has multiple EPICS modules dependencies.

pmac has asyn, calc, motor, busy dependencies. So add conf.pmc into MODS_ONE_VARS

```bash
MODS_ZERO_VARS:=conf.iocStats conf.MCoreUtils conf.retools conf.caPutLog conf.recsync conf.autosave conf.sncseq conf.ether_ip conf.sscan conf.snmp conf.opcua conf.pyDevSup
MODS_ONE_VARS:=conf.calc conf.asyn conf.modbus conf.lua conf.std conf.StreamDevice conf.busy conf.scaler conf.mca
```


