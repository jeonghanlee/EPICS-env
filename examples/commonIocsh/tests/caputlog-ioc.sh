#!/usr/bin/env bash
# Launch an IOC with the caPutLog fragment through the installed iocsh.bash
# loader, for verification. Driven by environment; exec'd as an independent
# process by verify_caputlog.sh.
#   DIST_TOP     : installed distribution root (holds setEpicsEnv.bash and base)
#   EXAMPLE_TOP  : example application top (startup file and test database)
#   IOCSH_TOP    : commonIocsh module directory (holds iocsh/caPutLog.iocsh)
#   LOG_PORT     : caPutLog / iocLogServer port
#   TEST_PREFIX  : record prefix (default M6TEST:)

set -euo pipefail
: "${DIST_TOP:?DIST_TOP required}"
: "${EXAMPLE_TOP:?EXAMPLE_TOP required}"
: "${IOCSH_TOP:?IOCSH_TOP required}"
: "${LOG_PORT:?LOG_PORT required}"
: "${TEST_PREFIX:=M6TEST:}"

export EXAMPLE_TOP TEST_PREFIX IOCSH_TOP
export CAPUTLOG_MACROS="LOG_INET=127.0.0.1,LOG_INET_PORT=${LOG_PORT},OPTION=0"
export EPICS_IOC_LOG_INET="127.0.0.1"
export EPICS_IOC_LOG_PORT="${LOG_PORT}"

# setEpicsEnv.bash reads its first argument as a fallback architecture, and a
# sourced file inherits the positional parameters of this script.
set --
# shellcheck source=/dev/null
source "${DIST_TOP}/setEpicsEnv.bash" > /dev/null
cd "${EXAMPLE_TOP}/iocBoot"
exec iocsh.bash caPutLog-shell.cmd
