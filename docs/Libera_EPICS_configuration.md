
## unfar

$ sudo su
# mkdir /opt/libera
# mv Xilinx.tgz /opt/libera
# tar xvzf Xilinx.tgz
# exit

## EPICS-env

make init.base

scp configure/os/CONFIG_SITE.linux-x86_64.linux-arm epics-base-src/configure/os/

echo "CROSS_COMPILER_TARGET_ARCHS=linux-arm" > configure/CONFIG_SITE.local
# echo "INSTALL_LOCATION=/srv/liberablm" >> configure/CONFIG_SITE.local
make print-CROSS_COMPILER_TARGET_ARCHS

make conf.base
make conf.base.show
make patch.base

## We may need sudo dependent upon "installation location"
sudo make build.base
sudo make install.base

make init.modules
make conf.modules
make conf.modules.libera

make build.iocStats
make install.iocStats

make build.recsync
make install.recsync

make build.retools
make install.retools

make build.caPutLog
make install.caPutLog

make build.autosave
make install.autosave



make build.sequencer-2-2
make install.sequencer-2-2

make build.sscan
make install.sscan
 
make build.calc
make install.calc

make build.asyn
make install.asyn



source /opt/epics/debian-11/7.0.6.1/setEpicsEnv.bash "linux-arm"


