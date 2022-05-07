# Libera Beam Loss Monitor EPICS Configuration

## Setup Cross Compiler 

```
$ sudo su
# mkdir /opt/libera
# mv Xilinx.tgz /opt/libera
# tar xvzf Xilinx.tgz
# exit
```

## Let System run cross compiler binary files

```
file  /opt/libera/Xilinx/ise/EDK/gnu/arm/lin/arm-xilinx-linux-gnueabi/bin/gcc
/opt/libera/Xilinx/ise/EDK/gnu/arm/lin/arm-xilinx-linux-gnueabi/bin/gcc: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux 2.2.5, stripped
```

```
file /usr/bin/x86_64-linux-gnu-gcc-10
/usr/bin/x86_64-linux-gnu-gcc-10: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=3fcaa8ea6cad2d3b12ca5bb1927960d46e019939, for GNU/Linux 3.2.0, stripped
```


```
# apt install gcc-multilib
```

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

make build.iocStats && make install.iocStats
make build.recsync && make install.recsync
make build.retools && make install.retools
make build.caPutLog && make install.caPutLog
make build.autosave && make install.autosave
make build.sequencer-2-2 && make install.sequencer-2-2
make build.sscan && make install.sscan

calc test makefile do not consider the cross compiler when calc has several 
dependency. So EPICS-env, conf.calc will remove tests rules in the top Makefile.
One can use PROD_LIBS += calc sscan seq in tests/Makefile

make build.calc && make install.calc
make build.asyn && make install.asyn



source /opt/epics/debian-11/7.0.6.1/setEpicsEnv.bash "linux-arm"


