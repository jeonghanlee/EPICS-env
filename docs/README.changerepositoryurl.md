# Move the `epics-module` community repository

Sometime later after moving our own local `forked` version, one wants to back to the community `epics-module` repository. There are `configure/CONFIG_MODS` and `configure/RELEASE` files should be changed.


## `RELEASE`

Select the different tag or hash which one would like to use, for example,

```bash
-# github/jeonghanlee
+# github/epics-modules
 SRC_NAME_MEASCOMP:=measComp
-SRC_TAG_MEASCOMP:=tc32
-SRC_VER_MEASCOMP:=tc32
+SRC_TAG_MEASCOMP:=2e779c4
+SRC_VER_MEASCOMP:=2e779c4
```

## `CONFIG_MODS`

We don't need to define their `SRC_GITURL` if we want to switch `epics-modules`, because the default `SRC_GITURL` is `epics-module` repository url. Thus, one should comment out the existing module specific url. For example,

```bash
--- a/configure/CONFIG_MODS
+++ b/configure/CONFIG_MODS
@@ -33,7 +33,8 @@ SRC_GITURL_STREAM:=$(SRC_URL_PSI)/$(strip $(SRC_NAME_STREAM))
 SRC_GITURL_SNCSEQ:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_SNCSEQ))
 SRC_GITURL_SNMP:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_SNMP))
 SRC_GITURL_OPCUA:=$(SRC_URL_RALPH)/$(strip $(SRC_NAME_OPCUA))
-SRC_GITURL_MEASCOMP:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_MEASCOMP))
+# Move to the epics-module repository
+# SRC_GITURL_MEASCOMP:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_MEASCOMP))
 SRC_GITURL_MOTORSIM:=$(SRC_URL_MOTOR)/$(strip $(SRC_NAME_MOTORSIM))
```

## Commands

```bash
rm -rf measComp-src
make init.modules
make conf.measComp
make build.measComp
make install.measComp
make exist
```
