# Add the new module

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

Check generated variables accoridng to them

```bash
make reconf.modules
```

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
