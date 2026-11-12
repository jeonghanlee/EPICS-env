# Startup for the installed iocsh.bash loader: the module directive links caPutLog
# and registers its support, so no example IOC has to be built.
# Environment: EXAMPLE_TOP, IOCSH_TOP, TEST_PREFIX, CAPUTLOG_MACROS.
on error break

module caPutLog

asSetFilename("$(EXAMPLE_TOP)/iocBoot/test.acf")
dbLoadRecords("$(EXAMPLE_TOP)/fixtureDb/caPutLog.db", "P=$(TEST_PREFIX)")
iocshLoad("$(IOCSH_TOP)/iocsh/caPutLog.iocsh", "$(CAPUTLOG_MACROS)")
iocInit()
caPutLogShow(1)
