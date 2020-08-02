# EPICS Configuration Enviornment

## BASE Setup

```bash
make init.base
make conf.base
make build.base
make install.base
```

## EPICS Module Setup

```bash
make init.modules      : Generate dynamicaly modules variables and clone all
make conf.modules      : make conf.modules.show will print out all local configuraiton files.
make clean.modules     : Some module have the infinite compiling loop, so we have to clean up exist things within git repositories.
make build.modules     : not working due to depenency
make install.modules   : we may not need this rule, beacuse of the standard EPICS buidling system default could be build and install
make uninstall.modules :
make exist.modules     : show where the modules are installed.
```

* Delete all download sources

```bash
make distclean.modules
```
