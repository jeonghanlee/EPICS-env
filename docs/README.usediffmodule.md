# Installation on different version module

This is a short instruction how we can install a different version of a module in the existing `EPICS-env` environment.

##

* Be in the `EPICS-env`

```bash
EPICS-env (master)$ pwd
/home/jeonglee/gitsrc/EPICS-env
```

* Clone a module which one install indepdently.

```bash
EPICS-env (master)$ git clone https://github.com/epics-modules/measComp
EPICS-env (master)$ cd measComp
measComp (master)$ git checkout 2e779c4
measComp ((2e779c4...))$
```

* Copy `RELEASE.local` and `CONFIG_SITE.local` from the existing module configuration

```bash
measComp ((2e779c4...))$ scp ../measComp-src/configure/RELEASE.local configure/
measComp ((2e779c4...))$ cat -b configure/RELEASE.local
     1	SNCSEQ=/usr/local/epics/rocky-8.5/7.0.6.1/modules/seq-2.2.8
     2	SSCAN=/usr/local/epics/rocky-8.5/7.0.6.1/modules/sscan-2-11-5
     3	CALC=/usr/local/epics/rocky-8.5/7.0.6.1/modules/calc-3.7.4
     4	ASYN=/usr/local/epics/rocky-8.5/7.0.6.1/modules/asyn-4.41
     5	AUTOSAVE=/usr/local/epics/rocky-8.5/7.0.6.1/modules/autosave-5.10.2
     6	BUSY=/usr/local/epics/rocky-8.5/7.0.6.1/modules/busy-1.7.3
     7	SCALER=/usr/local/epics/rocky-8.5/7.0.6.1/modules/scaler-c7c0bf9
     8	STD=/usr/local/epics/rocky-8.5/7.0.6.1/modules/std-3.6.2
     9	MCA=/usr/local/epics/rocky-8.5/7.0.6.1/modules/mca-89ddd38
measComp ((2e779c4...))$ scp ../measComp-src/configure/CONFIG_SITE.local configure/
measComp ((2e779c4...))$ cat -b configure/CONFIG_SITE.local
     1	INSTALL_LOCATION:=/usr/local/epics/rocky-8.5/7.0.6.1/modules/measComp-tc32
     2	LINUX_LIBUSB-1.0_INSTALLED = NO
     3	LINUX_NET_INSTALLED = NO
```

* Check the existing module path

```bash
measComp ((2e779c4...))$ make -C ../ exist LEVEL=2 |grep meas
│   ├── measComp -> /usr/local/epics/rocky-8.5/7.0.6.1/modules/measComp-tc32
│   ├── measComp-tc32
```

* Replace `INSTALL_LOCATION` with a different path

```bash
INSTALL_LOCATION:=/usr/local/epics/rocky-8.5/7.0.6.1/modules/measComp-2e779c4
```

* Build / Install

```bash
measComp ((2e779c4...))$ sudo make
measComp ((2e779c4...))$ sudo make install
measComp ((2e779c4...))$ make -C ../ exist LEVEL=2 |grep meas
│   ├── measComp -> /usr/local/epics/rocky-8.5/7.0.6.1/modules/measComp-tc32
│   ├── measComp-2e779c4
│   ├── measComp-tc32
```

* Enjoy!
