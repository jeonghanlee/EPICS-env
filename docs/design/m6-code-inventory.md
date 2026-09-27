# Code inventory for the documentation rewrite

Status: unverified working input. This inventory lists the code surfaces the
documentation book must describe. It was gathered by reading the code at
e3cfaee on 2026-09-26, without using the existing documents. Its statements
are not verified; each one is checked against the code only when the book
page that uses it is verified (`docs/milestone-84ee626.md`, M6 / T2).

## 1. Build system (Makefile, configure/)

- Load order: `Makefile` -> `configure/CONFIG` (RELEASE, CONFIG_SITE,
  CONFIG_VARS, CONFIG_SRC, CONFIG_BASE, CONFIG_MODS + MODULESGEN.mk +
  CONFIG_MODS_DEPS, CONFIG_MODS_AUDIT) and `configure/RULES` (RULES_FUNC,
  RULES_PATCH, RULES_SRC, RULES_BASE, RULES_MODS [+CONF_AUTO, CONFIG, BUILD,
  AUDIT], RULES_INSTALL, RULES_ENV_CHECK, RULES_DEPS_CHECK, RULES_VARS,
  RULES_USER). Default goal `vars`. `.NOTPARALLEL`, `.DELETE_ON_ERROR`.
- Parse-time guards: python3 present; every module has `_CONF_TYPE`
  auto|custom; auto modules have one source path and one install name.
- Targets by purpose:
  - Source: `init` (`init.base`/`clone.base`, `init.modules`), per-module
    `<MODVAR>` clone targets, `reconf.modules`, `remove.genmk`,
    `show.genmk`.
  - Patch: `patch` (ordered set), `patch.revert`, per-set
    `.apply/.revert/.make`.
  - Configure: `conf` (`conf.base` = site + env, `conf.modules` =
    release + zero + one + c17), `conf.show`, `conf.gz.*`,
    `conf.<module>[.show]` (9 auto, 23 custom), `conf.modules.libera`,
    `user.conf`.
  - Build: `build`, `build.gz`, `build.base` (-j 4), `build.modules`,
    `build.<mod>` with `<mod>_DEPS` prerequisites.
  - Install: `install` (= install.base [+ setEpicsEnv.bash],
    install.modules, install.commoniocsh, src_version), `symlinks`,
    `symlink.<mod>`, `uninstall`, `uninstall.modules`, `remove.modules`.
  - Checks: `audit.module-deps`/`check.module-deps` (static, pre-build),
    `audit.deps`/`check.deps` (runpath, post-install),
    `audit.env`/`check.env` (setEpicsEnv.bash library paths),
    `readelf/ldd/chrpath.{base,modules,<mod>}`, `exist`, `exist.modules`.
  - Clean: `distclean` (+ .base/.modules/.modulesgen), `clean.base`,
    `clean.modules` (runs distclean inside modules), `src_clean`.
  - Print: `vars`/`env`/`default` (FILTER), `print-%`, `PRINT.%`, `ls.%`,
    `tree.%`, `cat.%`.
  - CI: `github` (init patch vars conf build symlinks), `github.check`
    (adds check.module-deps).
- User settings: CONFIG_SITE (`INSTALL_LOCATION` default `${HOME}/epics`,
  `ENV_RELEASE_VERS` 1.4.0), RELEASE (`SRC_URL_*`, base and 32 module
  `SRC_NAME/TAG/VER`, `VENDOR_ULDAQ_PATH`, `OPEN62541_PATH`), override files
  `$(TOP)/../*.local` then `$(TOP)/configure/*.local`; CONFIG_BASE `?=`
  (EPICS_TZ, EPICS_TS_NTP_INET, IOCSH_*, EPICS_IOC_LOG_*, EPICS_SITE_VERSION,
  cross archs); command line: VERBOSE, DEBUG_SHELL, LEVEL, FILTER, LSOPTS,
  MODULE, FORMAT, PLATFORM.
- Module set: 32 modules declared by RELEASE triples (MCoreUtils Linux
  only); MODULESGEN.mk generated (URL, install location, source path);
  12 URL overrides in CONFIG_MODS; `<mod>_DEPS` graph in CONFIG_MODS_DEPS;
  custom conf writes dependency paths into each module's RELEASE.local.
- Install tree: `$(INSTALL_LOCATION)/<ENV_RELEASE_VERS>/<os>-<ver>/<base ver>/`
  with `base/`, `setEpicsEnv.bash`, `.versions`, `modules/<name>-<ver>/`,
  `modules/<name>` symlinks (seq for sequencer),
  `modules/commonIocsh/iocsh/*.iocsh` (no version dir). SUDO added when
  INSTALL_LOCATION is not writable. RUNPATH via $ORIGIN and
  --enable-new-dtags.
- OS handling: /etc/os-release or sw_vers; ubuntu-26 gnu17 bridge; asyn
  TIRPC; mca/measComp flags; pmac SSH_LIB; Darwin-only mca patch;
  `configure/os/CONFIG_SITE.linux-x86_64.linux-arm` used only by
  scripts/build_base_libera.bash.

## 2. Tools, scripts, patch, user and site templates, CI

- tools/: check_deps.bash, check_env.bash, audit_module_deps.bash (make
  and CI callers); gen_dep_graph.bash, pvs_gets.bash, pv_snapshot.bash,
  verify_fix_build.bash, prep-vendors.bash, update-release.bash,
  tc32-expansion-query.cpp (no make or CI caller).
- scripts/: setEpicsEnv.bash (sourced; installed by install.base; exports
  EPICS_PATH/BASE/MODULES/HOST_ARCH, PATH, LD_LIBRARY_PATH);
  resetEpicsEnv.bash, selectEpicsEnv.bash (sourced); build_epics.bash,
  build_base_libera.bash, build_modules_libera.bash, install_apps.bash
  (executed; not installed).
- patch/: -p0 diffs; families: `<basever>.base`, `<basever>-prNNNN-*` and
  `<basever>-NN-<sha>-*` (18 for 7.0.10), `<pvxsver>-NN-<sha>-*` (12 for
  1.5.2), 8 fixed per-module patches; inactive: 3 old base patches and
  pvxs-1.3.1.
- configure_user/: CONFIG_USER, RULES_USER copied to ~/configure by
  `user.conf`.
- site-template/: only `.versions` is written and installed; the four
  tracked ChannelFinder/systemd templates have no rule.
- CI: six OS workflows (Debian 12/13, Rocky 8 run github.check + install;
  Rocky 10, Ubuntu 24.04/26.04 run init patch conf [vars] build install
  symlinks); all end with exist, check.env, check.deps; vendor uldaq and
  open62541 built into <epics>/vendor. docs.yml deploys mdBook; linter.yml
  runs super-linter Bash.

## 3. commonIocsh and examples

- 12 fragments in commonIocsh/iocsh/: autosave, caPutLog, iocLog,
  iocStatsAdmin, linStat (+Host, Proc, NIC, FS), reccaster, serial,
  setSerialParams. Installed to `modules/commonIocsh/iocsh/`.
- Usage pattern: module tops from envPaths; `epicsEnvSet IOCSH_TOP`, `IOC`;
  `iocshLoad("$(IOCSH_TOP)/iocsh/<frag>.iocsh", "<macros>")`; optional
  parts enabled by empty macros (NICENABLE, FSENABLE, SERIAL_ENABLE);
  iocLog before device setup; caPutLog needs a TRAPWRITE ACF.
- examples/commonIocsh: one example IOC (caPutLog), verify_caputlog.py,
  and tests/ (run_all.sh: linstat, reccaster, iocstatsadmin, autosave,
  ioclog, serial, caputlog, integrated; t3_run.sh isolation). Most tests
  use the external tc32sim IOC. Not built by the top-level make or CI.

## 4. Code observations

These are outside the documentation work. D17 assigns them to M7
(`IOCSH_TOP`), M8 (unused `site-template` files), and M9 (the rest) in
`docs/milestone-84ee626.md`.

Behavior or correctness:
- IOCSH_TOP means the commonIocsh top in fragments and tests, but the
  iocsh directory in the example IOC; linStat.iocsh cannot run under the
  example's meaning.
- site-template/application.properties[.in] carry `key-store-password=
  password` and a third-party LDAP URL; no rule uses the files.
- Every make run, even `print-%`, runs `mkdir -p $(INSTALL_LOCATION)` and
  may regenerate MODULESGEN.mk.
- `_DEPS` and conf-written RELEASE.local disagree for motorMotorSim, QPC,
  motor.
- Rocky 10 / Ubuntu 24.04 / 26.04 CI never runs check.module-deps; Rocky
  10 builds vendors with conf.rocky8.
- selectEpicsEnv.bash path layout disagrees with the install layout;
  build_modules_libera.bash asks for build.sequencer-2-2.
- prep-vendors.bash: unassigned EPICS_MODS_PATH and SRC_VER, site NTP
  host, overwrites CONFIG_SITE.local.
- Test defaults use absolute /home/jeonglee paths; tests depend on the
  external tc32sim IOC.
Hygiene: undefined `.PHONY` names, unused variables and rules, stale
comments, inconsistent clean target naming, unused patch files, script
usage-text defects (pvs_gets, update-release, gen_dep_graph,
pv_snapshot), leftover top-level RELEASE.local/CONFIG_SITE.local.
