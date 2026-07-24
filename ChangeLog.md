
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

### v1.1.0 2024-05-16 Jeong Han Lee <jeonghan.lee@gmail.com>

* Update Sequencer 2.2.9 with the community github repo
* Add pvxs 1.3.1 since we would like to use QSRV2 as our own default
* Use the libevent local version within pvxs 1.3.1
* introduce the ALS-U EPICS ENV Version in the installation folder. 
* 
