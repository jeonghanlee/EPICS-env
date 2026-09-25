TOP = ..
include $(TOP)/configure/CONFIG
PROD_IOC = commonIocshExample
DBD += commonIocshExample.dbd
commonIocshExample_DBD += base.dbd caPutLog.dbd
commonIocshExample_SRCS += commonIocshExample_registerRecordDeviceDriver.cpp
commonIocshExample_SRCS += main.cpp
commonIocshExample_LIBS += caPutLog
commonIocshExample_LIBS += $(EPICS_BASE_IOC_LIBS)
include $(TOP)/configure/RULES
