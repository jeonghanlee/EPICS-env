# SPDX-License-Identifier: GPL-2.0-or-later
# tc32sim startup for the installed iocsh.bash loader.
#
# Application: https://github.com/jeonghanlee/tc32sim
# Revision:    61645aeb78f9e7239a20397c918e2e74508cb9da
# Original:    iocBoot/ioctestlab-tc32sim/st-linstat.cmd
#
# The module directives replace the envPaths include, the application DBD,
# and the compiled registrar of the original. TC32SIM_RUN names the directory
# that prepare.bash fills: the application checkout in src, the database
# files in db, the access security file, and the autosave storage. The
# application fragment, protocol, templates, and group definition are the
# application's own files. retools, autosave, and caPutLog are added through
# installed support, and the original cd into the application tree is left
# out so the IOC keeps the caller's working directory.

on error break

module StreamDevice
module linStat
module retools
module autosave
module caPutLog

epicsEnvSet("TOP",                  "$(TC32SIM_RUN)/src")
epicsEnvSet("DB_TOP",               "$(TC32SIM_RUN)/db")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(DB_TOP)")
epicsEnvSet("IOCSH_LOCAL_TOP",      "$(TOP)/tc32simApp/iocsh")
epicsEnvSet("IOCSH_TOP",            "$(IOCSH_TOP=$(EPICS_MODULES)/commonIocsh)")

epicsEnvSet("IOCNAME", "testlab-tc32sim")
epicsEnvSet("IOC",     "ioctestlab-tc32sim")

# IOC-owned access security: every write is trapped for caPutLog.
asSetFilename("$(TC32SIM_RUN)/tc32sim.acf")

# --- Device 01 (single simulator) ---
epicsEnvSet("PORT1",    "TCP001")
epicsEnvSet("P1",       "TC32:001:")
epicsEnvSet("TCPPORT1", "$(TC32SIM_TCP_PORT=9400)")
iocshLoad("$(IOCSH_LOCAL_TOP)/tc32sim.iocsh", "PORT=$(PORT1),P=$(P1),TCP_PORT=$(TCPPORT1),DATABASE_TOP=$(DB_TOP),PVX=")

# --- linStat: host and process by default; one NIC and one filesystem (/) enabled ---
iocshLoad("$(IOCSH_TOP)/iocsh/linStat.iocsh", "IOC=$(IOC),NICENABLE=,NIC=$(NIC=lo),FSENABLE=,FSID=ROOT,DIR=/")

# --- autosave: request files from the database info tags, storage under TC32SIM_RUN ---
iocshLoad("$(IOCSH_TOP)/iocsh/autosave.iocsh", "IOC=$(IOC),AS_TOP=$(TC32SIM_RUN)/autosave")

# --- caPutLog: starts after iocInit, when access security is active ---
iocshLoad("$(IOCSH_TOP)/iocsh/caPutLog.iocsh", "LOG_INET=$(LOG_INET=127.0.0.1),LOG_INET_PORT=$(LOG_INET_PORT=7004)")

iocInit

ClockTime_Report

# --- retools: list the record names of the first channel ---
reGrep("^TC32:001:Ti0$")

dbl > ${IOCNAME}
