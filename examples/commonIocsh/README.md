# Common iocsh example

## Scope

This example currently exercises only the standalone caPutLog fragment.
It links the real EPICS Base and caPutLog libraries and loads the fragment
before iocInit. The IOC owns its TRAPWRITE access security configuration;
the common fragment schedules logger initialization with afterIocRunning.

Other services and the global startup are not implemented yet.

## Build

Set CAPUTLOG and EPICS_BASE to installed module and Base directories in
configure/RELEASE.local. Run make from this directory. The normal EPICS
release consistency check remains enabled.

```makefile
CAPUTLOG = /path/to/caPutLog
EPICS_BASE = /path/to/base
```

The caPutLog build configuration must name the same Base installation.
Both paths must provide their built libraries, headers, and DBD files.

## Verification

Run verify_caputlog.py with --base pointing to the same Base installation
used for the build. The script starts the built example IOC and Base's
iocLogServer, writes the installed test database PV through caput, and
checks the receiver's actual output. It requires Python 3, an available
TCP port 7004 for the default case, stdbuf, and local TCP/UDP sockets.

From this example directory:

```bash
python3 verify_caputlog.py --base /path/to/base --output /path/to/new-evidence
```

The default run uses the repository's commonIocsh/iocsh directory.
--iocsh-top selects another installed fragment directory. --output selects
a new evidence directory; existing directories are never overwritten.
The script retains IOC, receiver, client, and summary evidence on all exits.

The tests cover default port/option, explicit port and option overrides,
deferred initialization after iocInit, disabled logging, an invalid
option, and the missing required destination. These are local caPutLog checks, not completion of the OS matrix,
global startup, or installed-path verification.
