
### 1.3.0 2026-09-09 Jeong Han Lee <jeonghan.lee@gmail.com>

* Carry eighteen post-R7.0.10 EPICS base fixes as p0 patches until the next upstream release: the fifteen-fix security and correctness wave (#52), the dbChannel_put DBR_TIME_STRING and dbPutNotify type-check refresh (#60), and the RSRV scalar-string PUT fix for the regression the carried message validation introduced (epics-base/epics-base#949); record every carry in patch/README.md with its decision basis
* Carry twelve post-1.5.2 pvxs fixes as p0 patches, managed together with the base carry (#53)
* Adopt asyn R4-46 with the vxi11 driver off (DRV_VXI11=NO, TIRPC=NO) and drop the vxi11 registrar from the StreamDevice example so it links (#61)
* Bump the module set for 1.3.0: calc (4217e83, including the sCalcout Pxx string-field fix), sscan, std, pscdrv and the five floor modules; motor stays pinned until the coordinated motor+pmac move (#21)
* Support Ubuntu 26.04 on GCC 15: a per-module C17 bridge for the sequencer, iocStats and nine others (#29), the opcua unnamed-namespace export fix (#30), and a module-library audit for the same mangling (#31)
* Add upstream feed-core to the module set and retire the site-layer feed copy (#37); publish qpc and rgamv2 as public repositories and adopt them into the layer-1 set with a data-only QPC patch (#64, #67)
* Release the companion layers at 1.3.0: EPICS-env-support with ADCore ee039d2 and NDPluginPvxs (#66) and alsu-site-modules with siteApps 0.1.0 and unidrv 0.5.1, feed/qpc/rgamv2 leaving that layer (#65)
* Install the CI vendors (uldaq, open62541) into the tree so check.deps gates strict in every workflow, and ship cfg/CONFIG_MEASCOMP so a measComp consumer inherits ULDAQ_DIR (#51); forward-port the 1.2.2 DT_RUNPATH flag and gate hardening (#47); harden check_deps.bash for empty bin dirs, dual RPATH/RUNPATH and flag forwarding (#49)
* Harden the make system against environment pickup and injection in the module path, name and SNCSEQ harvests (#38, #40, #41), insulate nested make reads from the caller (#35, #39), stop uninstall.modules and distclean.modules from deleting outside the install root (#42, #43), regenerate a stale MODULESGEN.mk after a branch switch (#48), and fix check.module-deps under GNU Make 4.2.1 (#28)
* Reverse patch.revert so stacked patches unapply in reverse order (#32); make the update-release survey distinguish a complete survey from a failed remote lookup and bind every module to its own URL (#62)
* Fix the CI workflows: ubuntu22/ubuntu24 now run make patch and make symlinks (#26, #33), actions/checkout moves to v5 (#34)
* Stop resetEpicsEnv.bash from terminating the sourcing shell when EPICS_MODULES is absent (#27)
* Modernize the documentation and publish it as an mdBook site (#54); correct two procedures that led to a silently wrong result (#57), the prep-vendors help and open62541 spelling (#58), the audit document's print query name (#36), and mark the 1.2.0/1.2.1 release records as superseded (#55)
* Ship Debian 12 in both distributions: the internal set is now Debian 12, Debian 13 and Rocky Linux 8.10, and the public gz set adds Debian 12 beside Debian 13, Rocky Linux 8.10 and 10, Ubuntu 24.04 and 26.04
* EPICS base stays at 7.0.10; DT_RUNPATH linking and the strict check_deps gate carry over from 1.2.2

### 1.2.2 2026-07-23 Jeong Han Lee <jeonghan.lee@gmail.com>

* Emit DT_RUNPATH instead of DT_RPATH on base and module shared libraries via SHRLIB_LDFLAGS/LOADABLE_SHRLIB_LDFLAGS -Wl,--enable-new-dtags, so the tree relocates on the RHEL/Rocky linker default (#44)
* Confirm the uldaq and open62541 vendor libraries emit DT_RUNPATH on the rebuild (#46)
* Make tools/check_deps.bash a strict gate by default: it now exits 2 on any RPATH or non-system absolute runpath, where it previously always exited 0; --report-only restores the non-failing behavior (#45)
* Wire check_deps.bash into CI as make audit.deps, a report-only post-install audit in the platform workflows (#50)
* EPICS base stays at 7.0.10 and the module set is unchanged from 1.2.1

### 1.2.1 2026-07-10 Jeong Han Lee <jeonghan.lee@gmail.com>

* Set PYTHON=python3 in the base CONFIG_SITE.local so EPICS base 7.0.10 builds on python3-only hosts (#18)
* Remove the bundled-libevent path from setEpicsEnv.bash and resetEpicsEnv.bash (#24)
* Fix the OS_NAME fallback bug and the configure/ Makefile typos that corrupted the install path (#20)
* Compare tag-pinned modules against the newest upstream tag in update-release.bash check (#22)
* Add tools/check_env.bash and make check.env / audit.env as the installed-environment guard
* Add make check.module-deps as a strict module dependency audit gate in make github.check
* EPICS base stays at 7.0.10 and the module set is unchanged from 1.2.0

### 1.2.0 2026-02-28 Jeong Han Lee <jeonghan.lee@gmail.com>

* Set EPICS base to 7.0.10 and refresh the module set to the then-current upstream versions
* Add a simple module dependency check and tools/prep-vendors.bash to automate the uldaq and open62541 vendor library setup
* Harden update-release.bash: a default option, better error handling, and user input for a specific tag or commit
* Add CI badges for Rocky 8 and Ubuntu 24.04 and update the install-app scripts

### 1.1.2 2025-09-10 Jeong Han Lee <jeonghan.lee@gmail.com>

* Add opcua with its open62541 vendor setup and the OPEN62541_PATH vendor path defaulting to /usr/local, and add linStat
* Create the tools/ directory, moving caget_pvs there and adding tools/README, and extend check_deps.bash with absolute-path detection, an RPATH counter, and bin/so size totals
* Upgrade pvxs to 1.4.0 and add a Rocky 10 build

### 1.1.1 2025-08-21 Jeong Han Lee <jeonghan.lee@gmail.com>

* Make the installed tree relocatable: carry RUNPATH and $ORIGIN handling for base and modules and drop RPATH from module executables
* Add make build.gz to compress ELF debug information and reduce binary size
* Use the system libevent instead of the pvxs bundle, since pscdrv requires it as well
* Add pscdrv, update snmp to 1.1.0.4ja, and prepare the Debian 13 build

### 1.1.0 2024-05-16 Jeong Han Lee <jeonghan.lee@gmail.com>

* Update Sequencer 2.2.9 with the community github repo
* Add pvxs 1.3.1 since we would like to use QSRV2 as our own default
* Use the libevent local version within pvxs 1.3.1
* Introduce the ALS-U EPICS ENV version in the installation folder
