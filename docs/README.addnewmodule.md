# Add the new module

## TL;DL : Summary

Note that here I selct `snmp` as an example. So, all `snmp` or `SNMP` can be replaced by other module name (e.g., motor).

* `RELEASE` file : Define three variables


```bash
SRC_NAME_SNMP:=snmp
SRC_TAG_SNMP:=tags/v1.0.0.2j
SRC_VER_SNMP:=1.0.0.2j
```

* `CONFIG_MODS` : If they have the different git url instead of `github.com/epics-modules`

```bash
SRC_GITURL_SNMP:=$(SRC_URL_JEONGHANLEE)/$(strip $(SRC_NAME_SNMP))
```

* `CONFIG_MODS_DEPS` : Define the dependent order and modules

```bash
snmp_DEPS:=null.base
```

* `RULES_MODS_CONFIG` : Add the proper configuration for each module. Usually, `RELEASE.local` and `CONFIG_SITE.local`

Note that `CHECK_RELEASE` is not always needed, because we have the global rule. However, if module does not follow a most popular `.local` rule, one should consider to add it in each module `CONFIG_SITE.local`. One example is a `motor` module.`

```makefile
conf.snmp:
  @echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_SNMP)"  > $(TOP)/$(SRC_PATH_SNMP)/configure/CONFIG_SITE.local
  @echo "CHECK_RELEASE = NO"                        >> $(TOP)/$(SRC_PATH_MOTOR)/configure/CONFIG_SITE.local

conf.snmp.show: conf.release.modules.show
  @cat -b $(TOP)/$(SRC_PATH_SNMP)/configure/CONFIG_SITE.local
```

* add `conf.snmp` into the following rules

```
MODS_ZERO_VARS:=conf.iocStats conf.MCoreUtils conf.retools conf.caPutLog conf.recsync conf.autosave conf.sncseq conf.ether_ip conf.sscan conf.snmp conf.opcua

MODS_ONE_VARS:=conf.calc conf.asyn conf.modbus conf.lua conf.std conf.StreamDevice conf.busy conf.scaler conf.mca conf.measComp conf.motor conf.motorMotorSim
```

* `rm -rf snmp-src`

* `make init.modules`

* `make conf.snmp`

* `make build.snmp`

* `make install.snmp`

## `RELEASE`

### Define `SRC_URL`

* Example 1 : std

We don't need to define

```bash
SRC_URL_EPICSMODULES:=https://github.com/epics-modules
```

* Example 2 : StreamDevice

We have to define

```bash
SRC_URL_PSI:=https://github.com/paulscherrerinstitute
```

* Example 3 : opcua

In `RELEASE` file, define `SRC_URL_`

```bash
SRC_URL_RALPH:=https://github.com/ralphlange
```

### Define the following variables

* Example 1 : std

```bash
SRC_NAME_STD:=std
SRC_TAG_STD:=1dff82c
SRC_VER_STD:=1dff82c
```

* Example 2 : StreamDevice

```bash
SRC_NAME_STREAM:=StreamDevice
SRC_TAG_STREAM:=bf55d4c
SRC_VER_STREAM:=2.8.15-bf55d4c
```

* Exmaple 3 : opcua

```bash
SRC_NAME_OPCUA:=opcua
SRC_TAG_OPCUA:=tags/v0.7.0
SRC_VER_OPCUA:=0.7.0
```

Check generated variables accoridng to them

```bash
make reconf.modules
```

The generated `MODULESGEN.mk` file contains still the wrong URL, however, it will be OK
because of the overrided varialbe. One can check it through `make PRINT.SRC_GITURL_STREAM`.

```bash
$ more configure/MODULESGEN.mk

..............

SRC_GITURL_STD:=https://github.com/epics-modules/std
INSTALL_LOCATION_STD:=/home/jhlee/epics-7.0.4/epics-modules/std-1dff82c
SRC_PATH_STD:=std-src

.................

SRC_GITURL_STREAM:=https://github.com/epics-modules/StreamDevice
INSTALL_LOCATION_STREAM:=/home/jhlee/epics-7.0.4/epics-modules/StreamDevice-2.8.15
SRC_PATH_STREAM:=StreamDevice-src
```

```bash
$ make PRINT.SRC_GITURL_STREAM
SRC_GITURL_STREAM = https://github.com/epics-modules/StreamDevice
SRC_GITURL_STREAM's origin is file
```

StreamDevice has the wrong URL. So we have to override it by hand. Add the following URL in `configure/CONFIG_MODS`.

```bash
SRC_GITURL_STREAM:=$(SRC_URL_PSI)/$(strip $(SRC_NAME_STREAM))
```

We also have to add its dependency in `CONFIG_MODS_DEPS` such as

```bash
StreamDevice_DEPS:=null.base build.calc build.asyn
```

```bash
make reconf.modules
```

```bash
$ more configure/MODULESGEN.mk

..............
SRC_GITURL_STREAM:=https://github.com/epics-modules/StreamDevice
INSTALL_LOCATION_STREAM:=/home/jhlee/epics-7.0.4/epics-modules/StreamDevice-2.8.15
SRC_PATH_STREAM:=StreamDevice-src
```

```bash
$ make PRINT.SRC_GITURL_STREAM
SRC_GITURL_STREAM = https://github.com/paulscherrerinstitute/StreamDevice
SRC_GITURL_STREAM's origin is file
```

* Example 3

Check the OPCUA URL, it is wrong, because the default URL is `epics-modules`. Thus, we have to override it in `CONFIG_MODS`

```bash
make print-SRC_GITURL_OPCUA
https://github.com/epics-modules/opcua
```

Add the correct GITURL for opcua

```bash
SRC_GITURL_OPCUA:=$(SRC_URL_RALPH)/$(strip $(SRC_NAME_OPCUA))
```

Add its dependency into `CONFIG_MODS`

```bash
opcua_DEPS:=null.base
```

```bash
$ make reconf.modules
$ make print-SRC_GITURL_OPCUA
https://github.com/ralphlange/opcua
```

## Clone

```bash
Directory ether_ip-src exist. Please remove it first.
git clone  https://github.com/paulscherrerinstitute/StreamDevice StreamDevice-src; git -C StreamDevice-src checkout bf55d4c
Cloning into 'StreamDevice-src'...
X11 forwarding request failed on channel 0
remote: Enumerating objects: 34, done.
remote: Counting objects: 100% (34/34), done.
remote: Compressing objects: 100% (23/23), done.
remote: Total 3270 (delta 16), reused 23 (delta 11), pack-reused 3236
Receiving objects: 100% (3270/3270), 812.64 KiB | 1.52 MiB/s, done.
Resolving deltas: 100% (2443/2443), done.
Note: switching to 'bf55d4c'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at bf55d4c Do not use upper level configure and do not install to upper level any more. Drops backward compatibility to Stream 2.7
Directory autosave-src exist. Please remove it first.

```

## CONFIGURE `RELEASE` and `CONFIG_SITE`

### Global RELEASE.local and CONFIG_SITE.local

```bash
EPICS-env (master)$ cat -b *.local
1  CHECK_RELEASE = NO
2  EPICS_BASE:=/home/jhlee/epics-7.0.4/epics-base
3  SUPPORT=
```

### Modules Specific RELEASE.local, CONFIG_SITE.local, and more

Each module has their own configuration, so it is difficult to incooperation with the only global files.

Add two important rules per each module in `configure/RULES_MODS_CONFIG`.

* Example 1 : std

```bash
# asyn
conf.std:
    @echo "SNCSEQ=$(INSTALL_LOCATION_SNCSEQ)"            > $(SRC_PATH_STD)/configure/RELEASE.local
    @echo "ASYN=$(INSTALL_LOCATION_ASYN)"               >> $(SRC_PATH_STD)/configure/RELEASE.local
    @echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_STD)"    > $(SRC_PATH_STD)/configure/CONFIG_SITE.local

conf.std.show: conf.release.modules.show
    @cat -b $(SRC_PATH_STD)/configure/RELEASE.local
    @cat -b $(SRC_PATH_STD)/configure/CONFIG_SITE.local
```

* Example 2 : StreamDevice

```bash
# asyn, calc, pcre (not yet)
conf.stream:
    @echo -rm -f $(SRC_PATH_STREAM)/GNUmakefile
    @echo "ASYN=$(INSTALL_LOCATION_ASYN)"                 > $(SRC_PATH_STREAM)/configure/RELEASE.local
    @echo "CALC=$(INSTALL_LOCATION_CALC)"                >> $(SRC_PATH_STREAM)/configure/RELEASE.local
    @echo "PCRE="                                        >> $(SRC_PATH_STREAM)/configure/RELEASE.local
    @echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_STREAM)"  > $(SRC_PATH_STREAM)/configure/CONFIG_SITE.local
    @sed -i -e "/^CHECK_RELEASE/d"  $(SRC_PATH_STREAM)/configure/Makefile

conf.stream.show: conf.release.modules.show
    @cat -b $(SRC_PATH_STREAM)/configure/RELEASE.local
    @cat -b $(SRC_PATH_STREAM)/configure/CONFIG_SITE.local
```

## Module Building Dependency

We have to define `module_name_DEP` variable properly. For example, `ASYN` has the following

```bash
asyn_DEPS:=null.base build.sequencer-2-2 build.sscan build.calc
```

where the order is important, becuase they are used for the Prerequisites order of `build.asyn`.

## Add the new configuration rule

According to its dependency, one should add conf.* into one of them.

```bash
MODS_ZERO_VARS:=conf.iocStats conf.MCoreUtils conf.retools conf.caPutLog conf.recsync conf.autosave conf.sncseq conf.ether_ip conf.sscan conf.snmp conf.opcua
```

```bash
MODS_ONE_VARS:=conf.calc conf.asyn conf.modbus conf.lua conf.std conf.StreamDevice
```
