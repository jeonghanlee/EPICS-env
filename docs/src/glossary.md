# Glossary of EPICS-env terms

This page defines each term the book uses with a specific meaning. The pages
use each term only in the meaning given here.

## Abbreviations used in this book

| Abbreviation | Meaning |
| --- | --- |
| ACF | Access security configuration file that an input/output controller (IOC) loads with `asSetFilename` |
| ASCII | American Standard Code for Information Interchange |
| CA | Channel Access, the EPICS network protocol that `caget` and `caput` use |
| CI | Continuous integration: the GitHub Actions workflows under `.github/workflows/` |
| DBD | Database definition file |
| ELF | Executable and Linkable Format, the Linux binary format that `readelf` reads |
| EPICS | Experimental Physics and Industrial Control System |
| GCC | GNU Compiler Collection |
| IOC | Input/output controller: a process that serves EPICS records |
| IPv4 | Internet Protocol version 4 |
| NTP | Network Time Protocol |
| OS | Operating system |
| PR | Pull request |
| PV | Process variable: a named record field that clients read and write |
| PVA | pvAccess, the EPICS network protocol that `pvget` and `pvxget` use |
| RHEL | Red Hat Enterprise Linux |
| RPATH | Run-time search path entry in an ELF file; the link option `--enable-new-dtags` writes a RUNPATH entry instead |
| RUNPATH | Run-time library search path entry in an ELF file, written when the link uses `--enable-new-dtags` |
| SHA-256 | Secure Hash Algorithm 256-bit |
| TCP | Transmission Control Protocol |

## Build and installation terms

| Term | Meaning |
| --- | --- |
| `$ORIGIN` | The directory of the loaded ELF file; a RUNPATH entry that starts with it is relative to that file |
| configuration type | The `<module>_CONF_TYPE` value of a module: `auto` for a generated `conf.<module>` rule, `custom` for a hand-written one |
| declared dependencies | The `<module>_DEPS` list: the `build.<module>` targets that build before the module |
| installed tree | The directory `$(INSTALL_LOCATION)/<release>/<os_id>-<os_version>/<base_version>`, which `make print-INSTALL_LOCATION_EPICS` prints |
| module key | The upper-case name of a module's `SRC_*` variables in `configure/RELEASE`, such as `ASYN` |
| module set | The EPICS modules that `configure/RELEASE` declares, each with a pin |
| `MODULESGEN.mk` | The generated file `configure/MODULESGEN.mk` that holds each module's repository URL, install directory, and source directory |
| `null.base` | The empty target that stands for EPICS base as the root of every declared dependency list |
| pin | The tag or commit, `SRC_TAG_<module_key>`, that a module source checks out |
| release triple | The three variables `SRC_NAME_<module_key>`, `SRC_TAG_<module_key>`, and `SRC_VER_<module_key>` that declare one module |
| repository override | A `SRC_GITURL_<module_key>` line in `configure/CONFIG_MODS` for a module hosted outside `epics-modules` |
| unversioned link | The link `modules/<module>` that `make symlinks` creates to the versioned directory |
| vendor directory | The directory `vendor/` in the installed tree that holds the uldaq and open62541 libraries |
| versioned directory | The install directory `modules/<module>-<version>` of one module |

## Verification gate terms

| Term | Meaning |
| --- | --- |
| gate | The strict form of a check that stops a build or a CI run on a finding |
| lost runpath | A shared library in the installed tree that needs another library of the tree but has no `$ORIGIN` RUNPATH entry to find it |
| report form | The form of a check that prints its findings and exits 0 |
| strict form | The form of a check that exits with a failure code on a finding |

## Patch carry terms

| Term | Meaning |
| --- | --- |
| carry patch | A patch under `patch/` that carries an upstream fix onto the pinned EPICS base or pvxs source |
| carry set | Every carry patch whose name starts with the pinned version of its source |
| fixed module patch | A patch under `patch/` with a fixed name for one module, applied by its own `patch.<name>.apply` target |
| version-anchored name | A carry patch name that starts with the source version, so a version bump drops the whole carry set |

## Common iocsh fragment terms

| Term | Meaning |
| --- | --- |
| common iocsh fragment | One of the `*.iocsh` files that `make install` copies to `modules/commonIocsh/iocsh` in the installed tree |
| enable macro | A fragment macro that defaults to `#--`, which comments out an optional part; an empty value enables that part |
| evidence directory | The directory that `verify_caputlog.py` creates with `--output`; it must not exist beforehand |
| `IOCSH_TOP` | The IOC macro that names the installed `modules/commonIocsh` directory; an IOC loads a fragment as `$(IOCSH_TOP)/iocsh/<fragment>.iocsh`. The caPutLog example IOC takes the `iocsh` directory itself in `IOCSH_TOP` |
| serial configuration file | An iocsh file that an IOC owns and that calls `setSerialParams.iocsh` once per serial port |
| soft IOC | An IOC built from EPICS base alone, such as `softIoc` or `softIocPVX`, that loads records from a database file |
