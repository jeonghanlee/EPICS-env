# Add a module

* Edit `configure/RELEASE`
```bash
SRC_NAME_SCALER:=scaler
SRC_TAG_SCALER:=c7c0bf9
SRC_VER_SCALER:=c7c0bf9
```

* Edit `configure/CONFIG_MODS` if the module URL is not `github/epics-modules`

```
SRC_GITURL_MOTORSIM:=$(strip $(SRC_URL_MOTOR))/$(strip $(SRC_NAME_MOTORSIM))
```

* Edit `configure/CONFIG_MODS_DEPS`

```bash
scaler_DEPS:=null.base build.asyn
```

* Edit `configure/RULES_MODS_CONFIG`

Please consult `XXXApp/src/Makefile` to check its real dependency and add the proper configuration name in one of the following variables.

    - `MOD_ZERO_VARS` : This module has only EPICS base dependency.
    - `MOD_ONE_VARS` : This module has multiple EPICS modules dependencies.


```bash
MODS_ZERO_VARS:=conf.iocStats conf.MCoreUtils conf.retools conf.caPutLog conf.recsync conf.autosave conf.sncseq conf.ether_ip conf.sscan conf.snmp conf.opcua conf.pyDevSup
MODS_ONE_VARS:=conf.calc conf.asyn conf.modbus conf.lua conf.std conf.StreamDevice conf.busy conf.scaler conf.mca
```

Please add the corresponding configuration rule.

```bash
conf.scaler:
	@echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_SCALER)"  > $(TOP)/$(SRC_PATH_SCALER)/configure/CONFIG_SITE.local
	@echo "ASYN=$(INSTALL_LOCATION_ASYN)"               > $(TOP)/$(SRC_PATH_SCALER)/configure/RELEASE.local
	@echo "AUTOSAVE=$(INSTALL_LOCATION_AUTOSAVE)"      >> $(TOP)/$(SRC_PATH_SCALER)/configure/RELEASE.local

conf.scaler.show: conf.release.modules.show
	@cat -b $(TOP)/$(SRC_PATH_SCALER)/configure/CONFIG_SITE.local
	@cat -b $(TOP)/$(SRC_PATH_SCALER)/configure/RELEASE.local
```

* Commands 

```bash
make reconf.modules
make init.modules
make conf.scaler
make conf.scaler.show
     1	EPICS_BASE:=/home/jeonglee/epics/debian/10/e881cb1/base
     2	SUPPORT=
     1	CHECK_RELEASE = NO
     1	INSTALL_LOCATION:=/home/jeonglee/epics/debian/10/e881cb1/modules/scaler-c7c0bf9
     1	ASYN=/home/jeonglee/epics/debian/10/e881cb1/modules/asyn-4.41
     2	AUTOSAVE=/home/jeonglee/epics/debian/10/e881cb1/modules/autosave-5.10.2
make build.scaler
make install.scaler
```

## different url

* Edit `configure/RELEASE`

```bash
# github/jeonghanlee
104 SRC_NAME_MEASCOMP:=measComp
105 SRC_TAG_MEASCOMP:=tc32
106 SRC_VER_MEASCOMP:=tc32
```

## Edit `configure/CONFIG_MODS`

```bash
SRC_GITURL_MEASCOMP:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_MEASCOMP))
```

## Remove the existing directory

```bash
rm -rf measComp-src
```

## Commands

```bash
make init.modules

make conf.measComp

make conf.measComp.show

make build.measComp

make install.measComp

make symlink.measComp

make exist.modules LEVEL=0
/home/jeonglee/epics/debian/10/7.0.5/modules
├── measComp -> /home/jeonglee/epics/debian/10/7.0.5/modules/measComp-tc32
├── measComp-3.0.0
├── measComp-tc32

```
