# SPDX-License-Identifier: GPL-2.0-or-later
# opcua-IOC-demo startup for the installed iocsh.bash loader, against the
# open-source Eclipse Milo OPC UA demo server.
#
# Application: https://github.com/jeonghanlee/opcua-IOC-demo
# Revision:    674c5735623703ad83f9c3fded479affa88871fa
# Original:    iocBoot/iochome-opcua-IOC-demo/st.cmd
#
# This variant keeps the session setup of the original and loads the
# application's server database and its generic ai.template with node
# identifiers of the Milo demo server, because the application's Demo
# databases name nodes of the Unified Automation demo server. The namespace
# mapping of the original belongs to that server and is left out.
# OPCUA_IOC_DEMO_RUN names the directory that prepare.bash fills.

on error break

module opcua

epicsEnvSet("EPICS_CA_ADDR_LIST","127.255.255.255")

epicsEnvSet("TOP",                   "$(OPCUA_IOC_DEMO_RUN)/src")
epicsEnvSet("DB_TOP",                "$(OPCUA_IOC_DEMO_RUN)/db")
epicsEnvSet("TEMPLATE_TOP",          "$(TOP)/opcua-IOC-demoApp/Db")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")

epicsEnvSet("IOCNAME", "home-opcua-IOC-demo")
epicsEnvSet("IOC", "iochome-opcua-IOC-demo")

# One session with a 200ms subscription on top
opcuaSession OPC1 $(OPCUA_SERVER=opc.tcp://127.0.0.1:4840/milo)
opcuaSubscription SUB1 OPC1 200
# Switch off security
opcuaOptions OPC1 sec-mode=None

# Server information and statistics from the standard server nodes
dbLoadRecords "$(DB_TOP)/UaDemoServer-server.db", "P=OPC:,R=,SESS=OPC1,SUBS=SUB1"

# Changing values of the Milo demo server through the application template
dbLoadRecords "$(TEMPLATE_TOP)/ai.template", "P=OPC:,R=MILO:,SESS=OPC1,SUBS=SUB1,NAME=DynamicDouble,NSI=2,IDENT=Demo.Dynamic.Double"
dbLoadRecords "$(TEMPLATE_TOP)/ai.template", "P=OPC:,R=MILO:,SESS=OPC1,SUBS=SUB1,NAME=DynamicFloat,NSI=2,IDENT=Demo.Dynamic.Float"
dbLoadRecords "$(TEMPLATE_TOP)/ai.template", "P=OPC:,R=MILO:,SESS=OPC1,SUBS=SUB1,NAME=DynamicInt32,NSI=2,IDENT=Demo.Dynamic.Int32"

iocInit

ClockTime_Report
