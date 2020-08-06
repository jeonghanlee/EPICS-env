# EPICS Docker Image based on Debian Buster

This is the playground to understand how Docker works in terms of `mount` or `volume`. I think, there is no good usage scenario for this kind of Docker image.

## Standalone EPICS Envioronment within a Running Docker Container

```bash
docker run -it --rm --name=epics jeonghanlee/epics:latest
source epics-7.0.4/setEpicsEnv.bash
```

That's it. We may use this to run few IOCs, which contains only `startup` scripts and `database` files with `volume` option. For example,

```bash
jhlee@parity: ~$ docker run -it --network=host --v ${HOME}/test_ioc:/test_ioc --rm --name=epics jeonghanlee/epics:latest
root@56b41c7d4f6f:/epics# source epics-7.0.4/setEpicsEnv.bash
```

```bash
jhlee@parity: ~$ cd test_ioc/
jhlee@parity: test_ioc$ git clone https://github.com/shroffk/demo-resources
fatal: could not create work tree dir 'demo-resources': Permission denied
jhlee@parity: test_ioc$ sudo su
root@parity:/home/jhlee/test_ioc# git clone https://github.com/shroffk/demo-resources
Cloning into 'demo-resources'...
remote: Enumerating objects: 27, done.
remote: Total 27 (delta 0), reused 0 (delta 0), pack-reused 27
Unpacking objects: 100% (27/27), done.
root@parity:/home/jhlee/test_ioc#
```

```bash
root@56b41c7d4f6f:/test_ioc# cd demo-resources/
root@56b41c7d4f6f:/test_ioc/demo-resources# ls
32.softioc-motorsim.dbl  README.txt  control.db  demo-opis  fishtankDemo.db  tank.db
root@56b41c7d4f6f:/test_ioc/demo-resources# softIoc -m Num=1,user=demo -s -d fishtankDemo.db
dbLoadDatabase("/epics/epics-7.0.4/epics-base/bin/linux-x86_64/../../dbd/softIoc.dbd")
softIoc_registerRecordDeviceDriver(pdbbase)
dbLoadRecords("fishtankDemo.db", "Num=1,user=demo")
iocInit()
Starting iocInit
############################################################################
## EPICS R7.0.4
## Rev. R7.0.4-dirty
############################################################################
iocRun: All initialization complete
epics-7.0.4 > dbl
TST{Room:1}T-Sp
TST{Htr:1}V-Sp
TST{Tank:1}T-Sp
TST{Htr:1}Output-I
TST{Tank:1}T-Calc
TST{Tank:1}T-I
TST{Tank:1}T-Err
TST{Tank:1}T-Int
TST{Tank:1}T-PID
TST{Sensor:1}Sts
TST{Htr:1}Pwr-Cmd

```

```bash
jhlee@parity: ~$ camonitor TST{Tank:1}T-Sp
TST{Tank:1}T-Sp                2020-08-06 02:41:05.251229 30  
jhlee@parity: ~$ caput TST{Htr:1}Pwr-Cmd 1
Old : TST{Htr:1}Pwr-Cmd              On
New : TST{Htr:1}Pwr-Cmd              Off
jhlee@parity: ~$ camonitor TST{Tank:1}T-Sp
TST{Tank:1}T-Sp                2020-08-06 02:41:05.251229 30  
jhlee@parity: ~$ caput TST{Htr:1}Pwr-Cmd 0
Old : TST{Htr:1}Pwr-Cmd              Off
New : TST{Htr:1}Pwr-Cmd              On
jhlee@parity: ~$ caput TST{Htr:1}Pwr-Cmd 1
Old : TST{Htr:1}Pwr-Cmd              On
New : TST{Htr:1}Pwr-Cmd              Off
```

## Volume

So, far I don't figure out how I mount(?) the container folder to a host system. The option `-v` will void all `/epics/` folder within the container.

## Run with Volume mount

```bash
docker run -it --rm --name=epics --mount source=epics,target=/epics/epics-7.0.4 jeonghanlee/epics:latest
root@20dfbb3eb3c8:/epics#
source epics-7.0.4/setEpicsEnv.bash
```

```bash
$ docker volume ls
local               epics

$ docker volume inspect epics
[
    {
        "CreatedAt": "2020-08-06T01:56:14-07:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/epics/_data",
        "Name": "epics",
        "Options": null,
        "Scope": "local"
    }
]

$ source /var/lib/docker/volumes/epics/_data/epics-7.0.4/setEpicsEnv.bash
bash: /var/lib/docker/volumes/epics/_data/epics-7.0.4/setEpicsEnv.bash: Permission denied

$ sudo -E bash -c "source /var/lib/docker/volumes/epics/_data/epics-7.0.4/setEpicsEnv.bash"

Set the EPICS Environment as follows:
THIS Source NAME    : setEpicsEnv.bash
THIS Source PATH    : /var/lib/docker/volumes/epics/_data/epics-7.0.4
EPICS_BASE          : /var/lib/docker/volumes/epics/_data/epics-7.0.4/epics-base
EPICS_HOST_ARCH     : linux-x86_64
EPICS_MODULES       : /var/lib/docker/volumes/epics/_data/epics-7.0.4/epics-modules
PATH                : /var/lib/docker/volumes/epics/_data/epics-7.0.4/epics-base/bin/linux-x86_64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LD_LIBRARY_PATH     : /var/lib/docker/volumes/epics/_data/epics-7.0.4/epics-base/lib/linux-x86_64

Enjoy Everlasting EPICS!

```
