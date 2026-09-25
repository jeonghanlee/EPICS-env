# macOS, 11.1, build 20C69 on M1 Chip

## `EpicsHostArch.pl`

It extracts the `EPICS_HOST_ARCH` in `uname` return cpu value within its perl script. However, I have no idea how Apple makes it `x86_64` within ARM64 archtecture. Is it a virtual machine?


```bash
Darwin JeongLee-M70.local 20.2.0 Darwin Kernel Version 20.2.0: Wed Dec  2 20:40:21 PST 2020; root:xnu-7195.60.75~1/RELEASE_ARM64_T8101 x86_64
```

##  EPICS

It was identified by darwin-x86 by `EpicsHostArch.pl` due to the confusing return values of `uname`.

```bash
JeongLee@JeongLee-M70 EPICS-env % source ~/epics/macOS/11.1/7.0.4.1/setEpicsEnv.bash 

Set the EPICS Environment as follows:
THIS Source NAME    : setEpicsEnv.bash
THIS Source PATH    : /Users/JeongLee/epics/macOS/11.1/7.0.4.1
EPICS_BASE          : /Users/JeongLee/epics/macOS/11.1/7.0.4.1/base
EPICS_HOST_ARCH     : darwin-x86
EPICS_MODULES       : /Users/JeongLee/epics/macOS/11.1/7.0.4.1/modules
PATH                : /Users/JeongLee/epics/macOS/11.1/7.0.4.1/base/bin/darwin-x86:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/opt/homebrew/bin:/opt/homebrew/sbin
LD_LIBRARY_PATH     : /Users/JeongLee/epics/macOS/11.1/7.0.4.1/base/lib/darwin-x86

Enjoy Everlasting EPICS!
```

## SoftIoc

```bash
JeongLee@JeongLee-M70 EPICS-env % softIoc 
dbLoadDatabase("/Users/JeongLee/epics/macOS/11.1/7.0.4.1/base/bin/darwin-x86/../../dbd/softIoc.dbd")
softIoc_registerRecordDeviceDriver(pdbbase)
7.0.4.1 > iocInit
Starting iocInit
############################################################################
## EPICS R7.0.4.1-github.com/jeonghanlee/EPICS-env
## Rev. EPICS-env-7.0.4.1-v0.9.4-20-g97f14c2
############################################################################
iocRun: All initialization complete
7.0.4.1 > 
```
