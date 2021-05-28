# Add a module

Edit `configure/RELEASE`

SRC_NAME_SCALER:=scaler
SRC_TAG_SCALER:=c7c0bf9
SRC_VER_SCALER:=c7c0bf9


Edit `configure/CONFIG_MODS_DEPS`

scaler_DEPS:=null.base build.asyn


Edit `configure/RULES_MODS_CONFIG`

Consult scalerApp/src/Makefile to check its real dependency

MODS_ONE_VARS:=conf.calc conf.asyn conf.modbus conf.lua conf.std conf.StreamDevice conf.busy conf.scaler conf.mca

conf.scaler:
	@echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_SCALER)"  > $(TOP)/$(SRC_PATH_SCALER)/configure/CONFIG_SITE.local
	@echo "ASYN=$(INSTALL_LOCATION_ASYN)"               > $(TOP)/$(SRC_PATH_SCALER)/configure/RELEASE.local
	@echo "AUTOSAVE=$(INSTALL_LOCATION_AUTOSAVE)"      >> $(TOP)/$(SRC_PATH_SCALER)/configure/RELEASE.local

conf.scaler.show: conf.release.modules.show
	@cat -b $(TOP)/$(SRC_PATH_SCALER)/configure/CONFIG_SITE.local
	@cat -b $(TOP)/$(SRC_PATH_SCALER)/configure/RELEASE.local



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
