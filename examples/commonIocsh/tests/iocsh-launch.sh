#!/usr/bin/env bash
# Start an IOC with the caPutLog startup file through the installed iocsh.bash loader.
# It is the IOC_CMD of the IOC configuration that ioc-runner installs for the
# caPutLog verification; the environment comes from that configuration.
#   DIST_TOP     : installed distribution root (holds setEpicsEnv.bash and base)
#   EXAMPLE_TOP  : example application top (startup file and test database)
#   IOCSH_TOP, TEST_PREFIX, CAPUTLOG_MACROS, and the EPICS_* variables the startup reads

set -euo pipefail
: "${DIST_TOP:?DIST_TOP required}"
: "${EXAMPLE_TOP:?EXAMPLE_TOP required}"
: "${IOCSH_TOP:?IOCSH_TOP required}"
: "${TEST_PREFIX:?TEST_PREFIX required}"

# setEpicsEnv.bash reads its first argument as a fallback architecture, and a
# sourced file inherits the positional parameters of this script.
set --
# shellcheck source=/dev/null
source "${DIST_TOP}/setEpicsEnv.bash" > /dev/null
exec iocsh.bash "${EXAMPLE_TOP}/iocBoot/caPutLog-shell.cmd"
