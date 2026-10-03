# SPDX-License-Identifier: GPL-2.0-or-later
# Minimal startup for the installed iocsh.bash loader.
#
# Source the selected tree's setEpicsEnv.bash, then run from any directory:
#   iocsh.bash <path>/examples/iocsh/st.cmd
# The wrapper consumes the module directive, loads linStat with its recorded
# dependencies from the installed metadata, sets LINSTAT to the selected
# module directory, registers the support, and runs the remaining commands
# through softIocPVX.

on error break

module linStat

# IOC identity. IOCSH_TOP names the installed commonIocsh fragments.
epicsEnvSet("IOC", "$(IOC=EPICSENV)")
epicsEnvSet("IOCSH_TOP", "$(IOCSH_TOP=$(EPICS_MODULES)/commonIocsh)")

# Host and process statistics, one network interface, and one filesystem.
# The interface name is host-specific: set NIC in the environment. The
# default is the loopback interface, which every Linux host has; it reports
# no link speed or duplex, so those two records stay INVALID until NIC names
# a physical interface.
iocshLoad("$(IOCSH_TOP)/iocsh/linStat.iocsh", "IOC=$(IOC),NICENABLE=,NIC=$(NIC=lo),FSENABLE=,FSID=ROOT,DIR=/")

iocInit()
