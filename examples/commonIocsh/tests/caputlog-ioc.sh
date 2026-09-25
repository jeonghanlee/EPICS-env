#!/usr/bin/env bash
# Launch the example IOC with the caPutLog fragment for verification.
# Driven by environment; exec'd as an independent process by verify_caputlog.sh.
#   EX_IOC       : path to the built commonIocshExample binary
#   EXAMPLE_TOP  : example application top
#   IOCSH_TOP    : commonIocsh iocsh directory (holds caPutLog.iocsh)
#   LOG_PORT     : caPutLog / iocLogServer port
#   TEST_PREFIX  : record prefix (default M6TEST:)

set -euo pipefail
: "${EX_IOC:?EX_IOC required}"
: "${EXAMPLE_TOP:?EXAMPLE_TOP required}"
: "${IOCSH_TOP:?IOCSH_TOP required}"
: "${LOG_PORT:?LOG_PORT required}"
: "${TEST_PREFIX:=M6TEST:}"

export EXAMPLE_TOP TEST_PREFIX IOCSH_TOP
export CAPUTLOG_MACROS="LOG_INET=127.0.0.1,LOG_INET_PORT=${LOG_PORT},OPTION=0"
export EPICS_IOC_LOG_INET="127.0.0.1"
export EPICS_IOC_LOG_PORT="${LOG_PORT}"

cd "${EXAMPLE_TOP}/iocBoot"
exec "${EX_IOC}" caPutLog.cmd
