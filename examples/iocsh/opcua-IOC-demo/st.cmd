# SPDX-License-Identifier: GPL-2.0-or-later
# opcua-IOC-demo startup for the installed iocsh.bash loader.
#
# Application: https://github.com/jeonghanlee/opcua-IOC-demo
# Revision:    674c5735623703ad83f9c3fded479affa88871fa
# Original:    iocBoot/iochome-opcua-IOC-demo/st.cmd
#
# The module directive replaces the envPaths include, the application DBD,
# and the compiled registrar of the original. OPCUA_IOC_DEMO_RUN names the
# directory that prepare.bash fills: the application checkout in src and the
# database files in db. The original cd commands into the application tree
# are left out so the IOC keeps the caller's working directory. The server
# address is a setting of the test environment.

on error break

module opcua

epicsEnvSet("EPICS_CA_ADDR_LIST","127.255.255.255")

epicsEnvSet("TOP",                   "$(OPCUA_IOC_DEMO_RUN)/src")
epicsEnvSet("DB_TOP",                "$(OPCUA_IOC_DEMO_RUN)/db")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")
epicsEnvSet("STREAM_PROTOCOL_PATH",  "$(DB_TOP)")
epicsEnvSet("IOCSH_LOCAL_TOP",       "$(TOP)/opcua-IOC-demoApp/iocsh")

epicsEnvSet("ENGINEER",  "jeonglee")
epicsEnvSet("LOCATION",  "SoftIOC")
epicsEnvSet("WIKI", "")

epicsEnvSet("IOCNAME", "home-opcua-IOC-demo")
epicsEnvSet("IOC", "iochome-opcua-IOC-demo")

epicsEnvSet("PRE", "AAAA:")
epicsEnvSet("REC", "BBBB:")

# Pretty minimal setup: one session with a 200ms subscription on top
opcuaSession OPC1 $(OPCUA_SERVER=opc.tcp://127.0.0.1:48020)
opcuaSubscription SUB1 OPC1 200
# Switch off security
opcuaOptions OPC1 sec-mode=None

# Set up a namespace mapping
# (the databases use ns=2, but the demo server >=v1.8 uses ns=3)
opcuaMapNamespace OPC1 2 "http://www.unifiedautomation.com/DemoServer/"

# Load the databases for the UaServerCpp demo server

dbLoadRecords "$(DB_TOP)/UaDemoServer-server.db", "P=OPC:,R=,SESS=OPC1,SUBS=SUB1"

dbLoadRecords "$(DB_TOP)/Demo.Dynamic.Arrays.db", "P=OPC:,R=DDA:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.Scalar.db", "P=OPC:,R=DDS:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.Arrays.db", "P=OPC:,R=DSA:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.Scalar.db", "P=OPC:,R=DSS:,SESS=OPC1,SUBS=SUB1"

dbLoadRecords "$(DB_TOP)/Demo.WorkOrder.db", "P=OPC:,SESS=OPC1,SUBS=SUB1"

# int64 and long string records need EPICS 7
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.ScalarE7.db", "P=OPC:,R=DDS:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.ArraysE7.db", "P=OPC:,R=DDA:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.ScalarE7.db", "P=OPC:,R=DSS:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.ArraysE7.db", "P=OPC:,R=DSA:,SESS=OPC1,SUBS=SUB1"

iocInit

ClockTime_Report
