#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.3

declare -g SC_SCRIPT;
declare -g SC_TOP;

SC_SCRIPT="$(realpath "$0")";
SC_TOP="${SC_SCRIPT%/*}"

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

INSTALL_LOCATION="$1";
if [ -z "${INSTALL_LOCATION}" ]; then
    INSTALL_LOCATION="/usr/local";
fi

## Assumption : build_epics.bash was called before!
##
pushd "${SC_TOP}/.." || exit
IOCSTATS_PATH=$(make -s  print-INSTALL_LOCATION_IOCSTATS)
popd || exit

if [ -z "${IOCSTAS_PATH}" ]; then

    DB_PATH="${IOCSTATS_PATH}/db";
    cat > "${DB_PATH}/ioc_stats.db" <<"EOF"
record(stringin, "$(IOCNAME):STARTTOD")
{
    field(DESC, "Time and date of startup")
    field(DTYP, "Soft Timestamp")
    field(PINI, "YES")
    field(INP, "@%m/%d/%Y %H:%M:%S")
}
record(calcout, "$(IOC):hb")
{
    field(DESC, "1 Hz counter since startup")
    field(CALC, "(A<2147483647)?A+1:1")
    field(SCAN, "1 second")
    field(INPA, "$(IOC):hb")
}
alias($(IOC):hb, $(IOCNAME):hb)
record(sub, "$(IOC):exit")
{
    alias("$(IOCNAME):exit")
    field(DESC, "IOC Restart" )
    field(SNAM, "rebootProc")
    field(BRSV,"INVALID")
    field(L,"1")
}
record(ai, "$(IOCNAME):CA_CLNT_CNT") {
  field(DESC, "Number of CA Clients")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@ca_clients")
  field(HOPR, "200")
  field(HIHI, "175")
  field(HIGH, "100")
  field(HHSV, "MAJOR")
  field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):CA_CONN_CNT") {
  field(DESC, "Number of CA Connections")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@ca_connections")
  field(HOPR, "5000")
  field(HIHI, "4500")
  field(HIGH, "4000")
  field(HHSV, "MAJOR")
  field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):RECORD_CNT") {
  field(DESC, "Number of Records")
  field(PINI, "YES")
  field(DTYP, "IOC stats")
  field(INP, "@records")
}
record(ai, "$(IOCNAME):IOC_CPU_LOAD") {
  alias("$(IOCNAME):LOAD")
  field(DESC, "IOC CPU Load")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@ioc_cpuload")
  field(EGU, "%")
  field(PREC, "1")
  field(HOPR, "100")
  field(HIHI, "80")
  field(HIGH, "70")
  field(HHSV, "MAJOR")
  field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(stringin, "$(IOCNAME):HOSTNAME") {
  field(DESC, "Host Name")
  field(DTYP, "IOC stats")
  field(INP, "@hostname")
  field(PINI, "YES")
}
record(stringin, "$(IOCNAME):UPTIME") {
  field(DESC, "Elapsed Time since Start")
  field(SCAN, "1 second")
  field(DTYP, "IOC stats")
  field(INP, "@up_time")
  field(PINI, "YES")
}
record(stringin, "$(IOCNAME):ENGINEER") {
  field(DESC, "Engineer")
  field(DTYP, "IOC stats")
  field(INP, "@engineer")
  field(PINI, "YES")
}
record(stringin, "$(IOCNAME):LOCATION") {
  field(DESC, "Location")
  field(DTYP, "IOC stats")
  field(INP, "@location")
  field(PINI, "YES")
}
record(stringin, "$(IOCNAME):WIKI") {
  field(DESC, "Wiki Link")
  field(DTYP, "IOC stats")
  field(INP, "@wiki")
  field(PINI, "YES")
}
record(ai, "$(IOCNAME):PROCESS_ID") {
  field(DESC, "Process ID")
  field(PINI, "YES")
  field(DTYP, "IOC stats")
  field(INP, "@proc_id")
}
record(ai, "$(IOCNAME):PARENT_ID") {
  field(DESC, "Parent Process ID")
  field(PINI, "YES")
  field(DTYP, "IOC stats")
  field(INP, "@parent_proc_id")
}
record(ai, "$(IOCNAME):MEM_USED") {
  field(DESC, "Allocated Memory")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@allocated_bytes")
  field(EGU, "byte")
}
EOF

    cat > "${DB_PATH}/sys_stats.db" <<"EOF"
record(stringin, "$(IOCNAME):TOD")
{
    field(DESC, "Current time and date")
    field(DTYP, "Soft Timestamp")
    field(SCAN, "1 second")
    field(INP, "@%m/%d/%Y %H:%M:%S")
}
record(ai, "$(IOCNAME):FD_MAX") {
  field(DESC, "Max File Descriptors")
  field(PINI, "YES")
  field(DTYP, "IOC stats")
  field(INP, "@maxfd")
}
record(ai, "$(IOCNAME):FD_CNT") {
  field(DESC, "Allocated File Descriptors")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(FLNK, "$(IOCNAME):FD_FREE  PP MS")
  field(INP, "@fd")
}
record(calc, "$(IOCNAME):FD_FREE") {
  field(DESC, "Available FDs")
  field(CALC, "B>0?B-A:C")
  field(INPA, "$(IOCNAME):FD_CNT  NPP MS")
  field(INPB, "$(IOCNAME):FD_MAX  NPP MS")
  field(INPC, "1000")
  field(HOPR, "150")
  field(LOLO, "5")
  field(LOW, "20")
  field(LLSV, "MAJOR")
  field(LSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR LOW LOLO LSV LLSV")
}
record(ai, "$(IOCNAME):SYS_CPU_LOAD") {
  field(DESC, "System CPU Load")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@sys_cpuload")
  field(EGU, "%")
  field(PREC, "1")
  field(HOPR, "100")
  field(HIHI, "80")
  field(HIGH, "70")
  field(HHSV, "MAJOR")
  field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):CPU_CNT") {
  field(DESC, "Number of CPUs")
  field(DTYP, "IOC stats")
  field(INP, "@no_of_cpus")
  field(PINI, "YES")
}
record(ai, "$(IOCNAME):SUSP_TASK_CNT") {
  field(DESC, "Number Suspended Tasks")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@suspended_tasks")
  field(HIHI, "1")
  field(HHSV, "MAJOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):MEM_FREE") {
  field(DESC, "Free Memory")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@free_bytes")
  field(EGU, "byte")
  field(LLSV, "MAJOR")
  field(LSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR LOW LOLO LSV LLSV")
}
record(ai, "$(IOCNAME):MEM_MAX") {
  field(DESC, "Maximum Memory")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@total_bytes")
  field(EGU, "byte")
}
record(stringin, "$(IOCNAME):KERNEL_VERS") {
  field(DESC, "Kernel Version")
  field(DTYP, "IOC stats")
  field(INP, "@kernel_ver")
  field(PINI, "YES")
}
EOF

fi
