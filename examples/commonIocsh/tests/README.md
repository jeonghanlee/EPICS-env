# commonIocsh verification scripts

These scripts check every common iocsh fragment against the tc32sim test IOC
(<https://github.com/jeonghanlee/tc32sim>) and, for caPutLog, against the
example IOC in the parent directory. `run_all.sh` runs the eight `verify_*.sh`
scripts, and `t3_run.sh` runs the suite with no source tree present.

- The EPICS-env book page
  [Run the fragment verification suite](../../../docs/src/procedures/run-fragment-verification-suite.md),
  published at <https://jeonghanlee.github.io/EPICS-env/>, lists the prerequisites, the environment variables,
  and the expected output.
- Agents follow
  [`docs/procedures/commonIocsh-verification-procedure.md`](../../../docs/procedures/commonIocsh-verification-procedure.md),
  which describes each check and the installed-path and isolated-path runs.

Temporary workspaces and startup files move into `<repo>/work/trash` when
they are no longer active. `COMMONIOCSH_TEST_TRASH` selects a different
trash directory. Each UTC-stamped entry retains the artifact as `entry`
and records its original path in `source-path`; no automatic cleanup runs.
`KEEP_WORKSPACE=1` leaves the caPutLog and integrated-test workspaces at
their original locations instead. A failed move stops the script.
The T3 runner preserves an earlier marked bundle in
`<SRC_EPICS>/work/trash`; the isolated tests use `<bundle>/work/trash`
unless `COMMONIOCSH_TEST_TRASH` is set.
