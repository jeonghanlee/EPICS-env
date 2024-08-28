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
MODS_ONE_VARS:=conf.calc conf.asyn conf.modbus conf.lua conf.std conf.StreamDevice conf.busy conf.scaler conf.mca conf.pmac
```
Then, add `conf.pmac` and `conf.pmac.show` as follows

```bash
conf.pmac:
	@-rm -f $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE.linux-x86_64.Common
	@echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_PMAC)"  > $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "CHECK_RELEASE = NO"                         >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "BUILD_IOCS = NO"                            >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "USE_GRAPHICSMAGICK = NO"                    >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "SSH ="                                      >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "SSH_LIB ="                                  >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "SSH_INCLUDE ="                              >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "WITH_BOOST = NO"                            >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@echo "USR_LDFLAGS += -lssh2"                      >> $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	@-rm -f $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local.linux-x86_64
	@-rm -f $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.linux-x86_64.Common
	@echo "ASYN=$(INSTALL_LOCATION_ASYN)"               > $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local
	@echo "BUSY=$(INSTALL_LOCATION_BUSY)"              >> $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local
	@echo "CALC=$(INSTALL_LOCATION_CALC)"              >> $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local
	@echo "MOTOR=$(INSTALL_LOCATION_MOTOR)"            >> $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local
	@echo "EPICS_BASE:=$(INSTALL_LOCATION_BASE)"       >> $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local
	
conf.pmac.show: conf.release.modules.show
	cat -b $(TOP)/$(SRC_PATH_PMAC)/configure/CONFIG_SITE
	cat -b $(TOP)/$(SRC_PATH_PMAC)/configure/RELEASE.local
```

* Commands 

```bash
make reconf.modules
make init.modules
make conf.pmac
make conf.pmac.show
     1	EPICS_BASE:=/home/jeonglee/epics/debian/10/e881cb1/base
     2	SUPPORT=
     1	CHECK_RELEASE = NO
     1	INSTALL_LOCATION:=/home/jeonglee/epics/debian/10/e881cb1/modules/scaler-c7c0bf9
     1	ASYN=/home/jeonglee/epics/debian/10/e881cb1/modules/asyn-4.41
     2	AUTOSAVE=/home/jeonglee/epics/debian/10/e881cb1/modules/autosave-5.10.2
make build.pmac
make install.pmac
make symlinks
```

