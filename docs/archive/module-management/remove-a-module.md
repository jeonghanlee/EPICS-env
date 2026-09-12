# Remove a module

From time to time, we have to drop a specific module support due to the upstream repository maintenance and latest Linux compiler, and so on.
Here we shortly show how to remove the existing module from the environment.

## A module

`pyDevSup` was abandoned, and no usage case was found for the ALS-U project, and it is difficult to keep the modern Python environment compatibility, which is a typical and common issue on every Python application.

### `configure/RELEASE`

Remove the following lines
```makefile
## https://github.com/jeonghanlee/pyDevSup
## 2024-08-31
SRC_NAME_PYDEVSUP:=pyDevSup
SRC_TAG_PYDEVSUP:=796f7d7
SRC_VER_PYDEVSUP:=796f7d7
```

### `configure/CONFIG_MODS`

The `pyDevSup` is from my own forked and updated repository, please remove the following line in `CONFIG_MODS` as well.

```makefile
SRC_GITURL_PYDEVSUP:=$(strip $(SRC_URL_JEONGHANLEE))/$(strip $(SRC_NAME_PYDEVSUP))
```

### `configure/CONFIG_MODS_DEPS`

Please remove the following line in `CONFIG_MODS_DEPS`

```makefile
pyDevSup_DEPS:=null.base
```

### `configure/RULES_MODS_CONFIG`


* Remove `conf.pyDevSup` from `MODS_ZERO_CUSTOM_VARS`

  `MODS_ZERO_VARS` is derived from that list plus the generated auto-module
  targets, so deleting a name from the derived line has no effect and the
  module stays installed.

* Remove `conf.pyDevSup` and `conf.pyDevSup.show` rules completely.

```makefile
conf.pyDevSup:
	@echo "INSTALL_LOCATION:=$(INSTALL_LOCATION_PYDEVSUP)"        > $(TOP)/$(SRC_PATH_PYDEVSUP)/configure/CONFIG_SITE.local
	@echo "PYTHON:=python3"                                      >> $(TOP)/$(SRC_PATH_PYDEVSUP)/configure/CONFIG_SITE.local
	@$(PYTHON_CMD) $(TOP)/$(SRC_PATH_PYDEVSUP)/makehelper.py     >> $(TOP)/$(SRC_PATH_PYDEVSUP)/configure/CONFIG_SITE.local

conf.pyDevSup.show: conf.release.modules.show
	@echo "cat -b $(TOP)/$(SRC_PATH_PYDEVSUP)/configure/CONFIG_SITE.local"
	cat -b $(TOP)/$(SRC_PATH_PYDEVSUP)/configure/CONFIG_SITE.local
```


