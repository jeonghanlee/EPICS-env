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

#INSTALL_LOCATION="$1";
#if [ -z "${INSTALL_LOCATION}" ]; then
#    INSTALL_LOCATION="/usr/local";
#fi

## Assumption : build_epics.bash was called before!
##
pushd "${SC_TOP}/.." || exit
IOCSTATS_PATH=$(make -s  print-INSTALL_LOCATION_IOCSTATS)
popd || exit

if [ -z "${IOCSTATS_PATH}" ]; then
    echo "${IOCSTATS_PATH} doesn't exit."
else
    echo "Create als db files in ${IOCSTATS_PATH}...";

    DB_PATH="${IOCSTATS_PATH}/db";
    cat > "${DB_PATH}/ioc_stats.db" <<"EOF"
record(stringin, "$(IOCNAME):STARTTOD")
{
    field(DESC, "Time and date of startup")
    field(DTYP, "Soft Timestamp")
    field(PINI, "YES")
    field(INP, "@%m/%d/%Y %H:%M:%S")
    info(archive,"policy:MonSparse")
}
record(calcout, "$(IOC):hb")
{
    field(DESC, "1 Hz counter since startup")
    field(CALC, "(A<2147483647)?A+1:1")
    field(SCAN, "1 second")
    field(INPA, "$(IOC):hb")
}
alias("$(IOC):hb", "$(IOCNAME):hb")
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
  info(archive,"policy:ThreeMinScan")
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
  info(archive,"policy:ThreeMinScan")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):CA_LCONN_CNT") {
  field(DESC, "Number of CA links")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@ca_lconn")
  field(HOPR, "5000")
  field(HIHI, "4500")
  #field(HIGH, "1")
  field(HHSV, "MAJOR")
  #field(HSV, "MAJOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):CA_LNCONN_CNT") {
  field(DESC, "CA Links Not Conncted")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@ca_lnconn")
  field(HOPR, "5000")
  field(HIHI, "1")
  #field(HIGH, "1")
  field(HHSV, "MAJOR")
  #field(HSV, "MAJOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
  field(FLNK,"$(IOCNAME):CA_LNCONN_CNT_ACQ_CHECK")
}
record(calcout,"$(IOCNAME):CA_LNCONN_CNT_ACQ_CHECK"){
  field(INPA,"$(IOCNAME):CA_LNCONN_CNT")
  field(INPB,"$(IOCNAME):CA_LNCONN_CNT_ACQ")
  field(CALC,"B > A && B>0? 1:0")
  field(OOPT,"When Non-zero")
  field(DOPT,"Use CALC")
  field(OUT,"$(IOCNAME):CA_LNCONN_CNT_ACQ.PROC") 
  field(FLNK,"$(IOCNAME):IOC_HEALTH")
}
record(ao,"$(IOCNAME):CA_LNCONN_CNT_ACQ"){
  field(DESC,"Acknowlege CA_LNCONN_CNT")
  field(OMSL,"closed_loop")
  field(DOL,"$(IOCNAME):CA_LNCONN_CNT")
  field(FLNK,"$(IOCNAME):IOC_HEALTH")
}
record(ai, "$(IOCNAME):CA_LDCONN_CNT") {
  field(DESC, "CA Links Disconnected")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@ca_ldconn")
  field(HOPR, "5000")
  field(HIHI, "1")
  #field(HIGH, "1")
  field(HHSV, "MAJOR")
  #field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
  field(FLNK,"$(IOCNAME):CA_LDCONN_CNT_ACQ_CHECK")  
}
record(calcout,"$(IOCNAME):CA_LDCONN_CNT_ACQ_CHECK"){
  field(INPA,"$(IOCNAME):CA_LDCONN_CNT")
  field(INPB,"$(IOCNAME):CA_LDCONN_CNT_ACQ")
  field(CALC,"B > A && B>0? 1:0")
  field(OOPT,"When Non-zero")
  field(DOPT,"Use CALC")
  field(OUT,"$(IOCNAME):CA_LDCONN_CNT_ACQ.PROC")
}
record(ao,"$(IOCNAME):CA_LDCONN_CNT_ACQ"){
  field(DESC,"Acknowlege CA_LDCONN_CNT")
  field(OMSL,"closed_loop")
  field(DOL,"$(IOCNAME):CA_LDCONN_CNT")
  field(FLNK,"$(IOCNAME):IOC_HEALTH")
}

record(ai, "$(IOCNAME):SEQ_PROG_CNT") {
  field(DESC, "Number SEQ Programs")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@seq_prog")
  field(HOPR, "5000")
  field(HIHI, "4500")
  #field(HIGH, "1")
  field(HHSV, "MAJOR")
  #field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):SEQ_PVS") {
  field(DESC, "Number SEQ Programs PVs")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@seq_pvs")
  field(HOPR, "5000")
  field(HIHI, "4500")
  #field(HIGH, "1")
  field(HHSV, "MAJOR")
  #field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
}
record(ai, "$(IOCNAME):SEQ_PVS_DCONN") {
  field(DESC, "Nr of SEQ Disonnected PVs")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@seq_pvs_dconn")
  field(HOPR, "5000")
  field(HIHI, "1")
  #field(HIGH, "1")
  field(HHSV, "MAJOR")
  #field(HSV, "MINOR")
  info(autosaveFields_pass0, "HOPR LOPR HIHI HIGH LOW LOLO HHSV HSV LSV LLSV")
  field(FLNK,"$(IOCNAME):SEQ_PVS_DCONN_ACQ_CHECK")
}
record(calcout,"$(IOCNAME):SEQ_PVS_DCONN_ACQ_CHECK"){
  field(INPA,"$(IOCNAME):SEQ_PVS_DCONN")
  field(INPB,"$(IOCNAME):SEQ_PVS_DCONN_ACQ")
  field(CALC,"B > A && B>0? 1:0")
  field(OOPT,"When Non-zero")
  field(DOPT,"Use CALC")
  field(OUT,"$(IOCNAME):SEQ_PVS_DCONN_ACQ.PROC")
}
record(ao,"$(IOCNAME):SEQ_PVS_DCONN_ACQ"){
  field(DESC,"Acknowlege SEQ_PVS_DCONN")
  field(OMSL,"closed_loop")
  field(DOL,"$(IOCNAME):SEQ_PVS_DCONN")
  field(FLNK,"$(IOCNAME):IOC_HEALTH")
}
record(calc, "$(IOCNAME):IOC_HEALTH"){
  field(DESC, "IOC Healthy=1")
  field(INPA,"$(IOCNAME):CA_LNCONN_CNT")
  field(INPB,"$(IOCNAME):CA_LNCONN_CNT_ACQ")
  field(INPC,"$(IOCNAME):SEQ_PVS_DCONN")
  field(INPD,"$(IOCNAME):SEQ_PVS_DCONN_ACQ")
  field(INPE,"$(IOCNAME):CA_LDCONN_CNT")
  field(INPF,"$(IOCNAME):CA_LDCONN_CNT_ACQ")
  field(CALC,"A>B || C>D || E>F? 0:1")
  field(HOPR, "1")
  field(LOLO, "0")
  #field(HIGH, "1")
  field(LLSV, "MAJOR")
  #field(HSV, "MINOR")
  info(archive,"policy:MonSparse")
}
record(ai, "$(IOCNAME):RECORD_CNT") {
  field(DESC, "Number of Records")
  field(PINI, "YES")
  field(DTYP, "IOC stats")
  field(INP, "@records")
  info(archive,"policy:MonSparse")
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
  info(archive,"policy:ThreeMinScan")
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
  field(DESC, "https://controls.als.lbl.gov/adp/VAL")
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
  info(archive,"policy:ThreeMinScan")
}
record(stringin, "$(IOCNAME):EPICS_VERS") {
  field(DESC, "EPICS Version")
  field(DTYP, "IOC stats")
  field(INP, "@epics_ver")
  field(PINI, "YES")
}
record(waveform, "$(IOCNAME):APP_DIR") {
  field(DESC, "Application Directory")
  field(DTYP, "IOC stats")
  field(INP, "@pwd")
  field(NELM, "160")
  field(FTVL, "CHAR")
  field(PINI, "YES")
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
  info(archive,"Slow")
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
  info(archive,"Slow")
  info(autosaveFields_pass0, "HOPR LOPR LOW LOLO LSV LLSV")
}
record(ai, "$(IOCNAME):MEM_MAX") {
  field(DESC, "Maximum Memory")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC stats")
  field(INP, "@total_bytes")
  info(archive,"VerySlow")
  field(EGU, "byte")
}
record(stringin, "$(IOCNAME):KERNEL_VERS") {
  field(DESC, "Kernel Version")
  field(DTYP, "IOC stats")
  field(INP, "@kernel_ver")
  field(PINI, "YES")
}
EOF

    cat > "${DB_PATH}/ioc_NetStats.db" <<"EOF"
record(stringin, "$(IOCNAME):NET_$(IF_NAME)")
{
  field(DESC,"IF $(INP_IF_NAME) IP address")
  field(DTYP, "IOC net stats")
  field(INP, "@netAddr:$(INP_IF_NAME)")
  field(PINI, "YES")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_PACKETS_TX") {
  field(DESC,"IF $(INP_IF_NAME) PACKETS_TX")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPacketsTx:$(INP_IF_NAME)")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_PACKETS_RX") {
  field(DESC,"IF $(INP_IF_NAME) PACKETS_RX")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPacketsRx:$(INP_IF_NAME)")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_ERRORS_TX") {
  field(DESC,"IF $(INP_IF_NAME) ERRORS_TX")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPErrorTx:$(INP_IF_NAME)")
  info(archive,"VerySlow")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_ERRORS_RX") {
  field(DESC,"IF $(INP_IF_NAME) ERRORS_RX")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPErrorRx:$(INP_IF_NAME)")
  info(archive,"VerySlow")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_DROPPED_TX") {
  field(DESC,"IF $(INP_IF_NAME) DROPPED_TX")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPDroppedTx:$(INP_IF_NAME)")
  info(archive,"VerySlow")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_DROPPED_RX") {
  field(DESC,"IF $(INP_IF_NAME) DROPPED_RX")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPDroppedRx:$(INP_IF_NAME)")
  info(archive,"VerySlow")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_COLLISIONS") {
  field(DESC,"IF $(INP_IF_NAME) COLLISIONS")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPCollisions:$(INP_IF_NAME)")
  info(archive,"VerySlow")
}
record(ai, "$(IOCNAME):NET_$(IF_NAME)_CARRIER_ERR") {
  field(DESC,"IF $(INP_IF_NAME) CARRIER Error")
  field(SCAN, "I/O Intr")
  field(DTYP, "IOC net stats")
  field(INP, "@netPCarrierErr:$(INP_IF_NAME)")
  info(archive,"VerySlow")
}
EOF

fi

mkdir -p /vxboot/PVenv /vxboot/PVnames
chomd -R 777 /vxboot

