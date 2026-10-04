# SPDX-License-Identifier: GPL-2.0-or-later
# EPICS-IOC-Demo startup for the installed iocsh.bash loader.
#
# Application: https://github.com/jeonghanlee/EPICS-IOC-Demo
# Revision:    e4198269aaa9d8c367446fd1d5afe8c371b4c039
# Original:    iocBoot/iocB46-182-jeonglee-Demo/st2.cmd
#
# The module directive replaces the envPaths include, the application DBD,
# and the compiled registrar of the original. EPICS_IOC_DEMO_RUN names the
# directory that prepare.bash fills with the application checkout in src.
# The application fragment, database, and protocol are read from the
# application source directories, since nothing of the application is built.
# The original cd into the application tree is left out so the IOC keeps the
# caller's working directory.

on error break

module StreamDevice

epicsEnvSet("TOP",                  "$(EPICS_IOC_DEMO_RUN)/src")
epicsEnvSet("DB_TOP",               "$(TOP)/jeonglee-DemoApp/Db")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(DB_TOP)")
epicsEnvSet("IOCSH_LOCAL_TOP",      "$(TOP)/jeonglee-DemoApp/iocsh")

epicsEnvSet("PREFIX_MACRO", "jeonglee:")
epicsEnvSet("DEVICE_MACRO", "myoffice:")

epicsEnvSet("IOCNAME", "B46-182-jeonglee-Demo")
epicsEnvSet("IOC",     "iocB46-182-jeonglee-Demo")

# --- Asyn IP port of the training device simulator ---
epicsEnvSet("ASYN_PORT_NAME", "LocalTCPServer")
epicsEnvSet("TARGET_HOST",    "$(DEMO_TCP_HOST=127.0.0.1)")
epicsEnvSet("TARGET_PORT",    "$(DEMO_TCP_PORT=9399)")

iocshLoad("$(IOCSH_LOCAL_TOP)/training_device.iocsh", "PREFIX=$(PREFIX_MACRO),DEVICE=$(DEVICE_MACRO),DATABASE_TOP=$(DB_TOP),PORT_NAME=$(ASYN_PORT_NAME),HOST=$(TARGET_HOST),PORT=$(TARGET_PORT)")

iocInit

ClockTime_Report
