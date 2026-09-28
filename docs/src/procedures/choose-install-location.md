# Choose the install location and release

Set the install location before any other `make` command in an EPICS-env
clone, because every run of `make` creates it, and the default is
`${HOME}/epics`.

## Prerequisites

- A clone of EPICS-env. Run every command from the repository top.
- An absolute directory path that your user can create or write to.
- `python3` on `PATH`; `make` stops while reading its configuration when it is
  missing.

1. In `configure/CONFIG_SITE.local`, set the install location:

   ```bash
   echo "INSTALL_LOCATION=<install_location>" > configure/CONFIG_SITE.local
   ```

   `<install_location>` is the absolute path of the directory that holds every
   installed tree, such as `/opt/epics`.

   The file is untracked, so the setting survives a `git pull`. A
   `CONFIG_SITE.local` in the directory that contains the repository applies to
   every clone in that directory; `configure/CONFIG_SITE.local` is read after it
   and wins.

2. Optional: to install under a release number other than the default `1.4.0`,
   add `ENV_RELEASE_VERS` to the same file:

   ```bash
   echo "ENV_RELEASE_VERS=<release>" >> configure/CONFIG_SITE.local
   ```

   `<release>` names the first directory level below `<install_location>`.
   Trees with different release numbers sit side by side under
   `<install_location>`.

3. To see where the installed tree goes, print its path:

   ```bash
   make print-INSTALL_LOCATION_EPICS
   ```

   With the default release, the output is:

   ```
   <install_location>/1.4.0/debian-13/7.0.10
   ```

   With `<release>` set to `1.4.0-site`, the output is:

   ```
   <install_location>/1.4.0-site/debian-13/7.0.10
   ```

   The path is `<install_location>/<release>/<os_id>-<os_version>/<base_version>`.
   `<os_id>` and `<os_version>` are the `ID` and `VERSION_ID` values from
   `/etc/os-release`, and `<base_version>` is the version of Experimental
   Physics and Industrial Control System (EPICS) base pinned in
   `configure/RELEASE`. The output above is from a Debian 13 host.

4. To check whether the build uses `sudo`, print `SUDO_INFO`:

   ```bash
   make print-SUDO_INFO
   ```

   For a location your user can create, the output is:

   ```
   0
   ```

   The value is `1` when `make` cannot create `<install_location>` as your
   user. `make` then runs the module build and install steps, the module links,
   and the `commonIocsh` install through `sudo`. The EPICS base build and install
   and the `.versions` install never use `sudo`, so a complete install needs a
   `<install_location>` that your user can write. To use a system directory such
   as `/opt/epics`, create it and give your user ownership of it before you build.

## Verification

- Print the value in effect and where it comes from:

  ```bash
  make PRINT.INSTALL_LOCATION
  ```

  The output names your path and the origin `file`:

  ```
  INSTALL_LOCATION = <install_location>
  INSTALL_LOCATION's origin is file
  ```

[Configuration variables and override files](../reference/configuration-variables.md#install-location-and-release)
lists the defaults and the read order of the override files. To build into the
chosen location, see [Build and install the environment](build-and-install.md).
