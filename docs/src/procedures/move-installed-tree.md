# Move an installed tree

Refresh the installed build metadata and service launch paths after moving a
complete native Linux Experimental Physics and Industrial Control System
(EPICS) tree.

## Prerequisites

- A successful full `make install` provides `relocateEpicsEnv.pl` and
  `.epics-env-paths.json`. Partial or failed installation requires a successful
  full-install retry from the configured source checkout.
- The destination host runs the recorded Linux operating system version and EPICS host
  architecture, with the same external system libraries available.
- Perl with `JSON::PP` and the installed EPICS parser are available.
  Downstream builds also require GNU Make, the compiler, and their dependencies.
- Your user has write and search permission on the tree and every managed
  file's containing directory. Atomic replacement preserves installed file
  modes, including 0444.
- Both tree paths are absolute and contain no whitespace or make/shell
  metacharacters. Keep the complete tree, its relative module links, inventory,
  and retained backups together.
- `<new_tree>` does not exist; its parent exists and is writable.

1. Move the complete tree to its destination:

   ```bash
   mv <old_tree> <new_tree>
   ```

   `<old_tree>` and `<new_tree>` are the complete installed-tree paths. Stop
   consumers before moving a tree they use. This procedure does not update
   source checkout configuration or consumer IOC files.

2. Inspect the destination without changing files:

   ```bash
   perl <new_tree>/relocateEpicsEnv.pl --check
   ```

   Exit status 1 reports that managed metadata requires refresh. Status 2
   identifies invalid input, incomplete installation, or unfinished recovery.
   Follow the diagnostic before proceeding.

   Check and apply also print lines such as
   `External dependency preserved (unavailable): <path>` for external
   declarations that the tree keeps unchanged. They are informational; the
   exit status decides the result.

3. Refresh the managed paths:

   ```bash
   perl <new_tree>/relocateEpicsEnv.pl --apply
   ```

   Status 0 reports completed refresh or a verified no-op. Verified backups
   remain under `.epics-env-backups`; comments, settings, includes, and modes
   are preserved. Legitimate external dependencies retain their original paths.

   After an interrupted refresh, this invocation restores verified prior
   metadata and returns 3, including successful rollback. Run a separate
   `--apply` invocation for the update. Unknown contents or modes, missing
   backups, or damaged backups retain the recovery record and report the file.
   Preserve that record and its backups until recovery succeeds.

4. Select the moved environment in your shell:

   ```bash
   source <new_tree>/setEpicsEnv.bash
   ```

   Setup calculates shell paths from its own location and stays read-only.
   Repeated setup does not duplicate managed path entries.

5. Optional: reinstall an external systemd caRepeater service copy:

   On a Security-Enhanced Linux (SELinux) host, restore destination labels
   according to the host policy before starting the service:

   ```bash
   sudo restorecon -RF <new_tree>
   ```

   A copied home-directory label can prevent systemd from executing the binary
   even when Unix permissions allow access. Refresh does not change SELinux policy.

   Copy and reload the unit, then restart its process:

   ```bash
   sudo cp <new_tree>/base/bin/linux-x86_64/caRepeater.service /etc/systemd/system/caRepeater.service
   sudo chmod 664 /etc/systemd/system/caRepeater.service
   sudo systemctl daemon-reload
   sudo systemctl restart caRepeater
   ```

   Run these commands on the destination service host. The service user must
   be able to traverse the tree and execute its binaries. Refresh changes
   only the tree-local unit; external init scripts and service copies require
   their own operator installation. Existing running processes retain their
   paths until you restart them.


## Verification

Inspect the finalized destination metadata:

```bash
perl <new_tree>/relocateEpicsEnv.pl --check
```

Status 0 reports `Managed metadata is current`, followed by any external
dependency lines described in step 2. Repeating `--apply` at this
root changes no contents, modes, links, inventory, or backup count.

Build your downstream IOC with `CHECK_RELEASE=YES` against versioned module
paths under `<new_tree>`, then run it through `iocInit`. For a systemd
installation, inspect the selected launch path and process:

```bash
systemctl show caRepeater -p ExecStart -p MainPID
```

`ExecStart` must select `<new_tree>/base/bin/linux-x86_64/caRepeater`, and
`MainPID` must identify the running service. Loader verification remains
separate; see [Run the verification gates](run-verification-gates.md).
