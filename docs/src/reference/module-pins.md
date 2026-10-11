# Module pins and dependencies

`configure/RELEASE` pins the Experimental Physics and Industrial Control System
(EPICS) base and every module to one tag or commit.
The values below are the ones make computes from the tracked
`configure/RELEASE` and `configure/CONFIG_MODS`, with no override file.
When a `RELEASE.local` file overrides a pin, this command prints the value in
effect for one module in your checkout:

```bash
make print-SRC_TAG_<MODULE_KEY>
```

`<MODULE_KEY>` is the `Key` column below, such as `ASYN`.

## EPICS base repository pin

| Repository | Pin | Version | Install directory |
| --- | --- | --- | --- |
| <https://github.com/epics-base/epics-base> | `tags/R7.0.10` | `7.0.10` | `base` |

## Module repositories and pins

`Module` is the name the module's make targets use, such as `build.asyn`.
`Key` is the upper-case name of its `SRC_*` variables in `configure/RELEASE`.
`Install directory` is the directory under `modules/` in the installed tree;
`make symlinks` adds a link without the version suffix. `Depends on` lists
the modules that build first. MCoreUtils is part of the set only on Linux.

| Module | Key | Repository | Pin | Version | Install directory | Depends on |
| --- | --- | --- | --- | --- | --- | --- |
| asyn | `ASYN` | <https://github.com/epics-modules/asyn> | `tags/R4-46` | `4.46.0` | `asyn-4.46.0` | calc, sequencer, sscan |
| autosave | `AUTOSAVE` | <https://github.com/epics-modules/autosave> | `tags/R6-0` | `6.0.0` | `autosave-6.0.0` | EPICS base only |
| busy | `BUSY` | <https://github.com/epics-modules/busy> | `2dfe92d` | `2dfe92d` | `busy-2dfe92d` | asyn, autosave |
| calc | `CALC` | <https://github.com/epics-modules/calc> | `4217e83` | `4217e83` | `calc-4217e83` | sequencer, sscan |
| caPutLog | `CAPUTLOG` | <https://github.com/epics-modules/caPutLog> | `dafb0b2` | `dafb0b2` | `caPutLog-dafb0b2` | EPICS base only |
| ether_ip | `ETHERIP` | <https://github.com/epics-modules/ether_ip> | `tags/ether_ip-3-10` | `3.10.0` | `ether_ip-3.10.0` | EPICS base only |
| feed-core | `FEEDCORE` | <https://github.com/BerkeleyLab/feed-core> | `0472d88` | `0472d88` | `feed-core-0472d88` | EPICS base only |
| iocStats | `IOCSTATS` | <https://github.com/epics-modules/iocStats> | `tags/4.0.1` | `4.0.1` | `iocStats-4.0.1` | EPICS base only |
| linStat | `LINSTAT` | <https://github.com/mdavidsaver/linStat> | `tags/1.2.1` | `1.2.1` | `linStat-1.2.1` | EPICS base only |
| lua | `LUA` | <https://github.com/epics-modules/lua> | `17475b5` | `17475b5` | `lua-17475b5` | asyn |
| mca | `MCA` | <https://github.com/epics-modules/mca> | `687d563` | `687d563` | `mca-687d563` | asyn, autosave, busy, calc, scaler, sequencer, sscan, std |
| MCoreUtils | `MCOREUTILS` | <https://github.com/epics-modules/MCoreUtils> | `a86e5ed` | `a86e5ed` | `MCoreUtils-a86e5ed` | EPICS base only |
| measComp | `MEASCOMP` | <https://github.com/epics-modules/measComp> | `c38974e` | `c38974e` | `measComp-c38974e` | asyn, autosave, busy, calc, mca, scaler, sequencer, sscan, std |
| modbus | `MODBUS` | <https://github.com/epics-modules/modbus> | `tags/R3-4` | `3.4.0` | `modbus-3.4.0` | asyn |
| motor | `MOTOR` | <https://github.com/epics-modules/motor> | `285f44d` | `285f44d` | `motor-285f44d` | asyn, busy, lua, modbus, sequencer |
| motorMotorSim | `MOTORSIM` | <https://github.com/epics-motor/motorMotorSim> | `tags/R1-3` | `1.3.0` | `motorMotorSim-1.3.0` | asyn, motor |
| opcua | `OPCUA` | <https://github.com/epics-modules/opcua> | `tags/v0.11.2` | `0.11.2` | `opcua-0.11.2` | EPICS base only |
| pcas | `PCAS` | <https://github.com/epics-modules/pcas> | `e075fd4` | `e075fd4` | `pcas-e075fd4` | EPICS base only |
| pmac | `PMAC` | <https://github.com/DiamondLightSource/pmac> | `2-7-9` | `2.7.9` | `pmac-2.7.9` | asyn, busy, calc, motor |
| pscdrv | `PSCDRV` | <https://github.com/mdavidsaver/pscdrv> | `276daca` | `276daca` | `pscdrv-276daca` | EPICS base only |
| pvxs | `PVXS` | <https://github.com/epics-base/pvxs> | `tags/1.5.2` | `1.5.2` | `pvxs-1.5.2` | EPICS base only |
| pyDevSup | `PYDEVSUP` | <https://github.com/epics-modules/pyDevSup> | `4527ed0` | `4527ed0` | `pyDevSup-4527ed0` | EPICS base only |
| QPC | `QPC` | <https://github.com/jeonghanlee/QPC> | `913fad4` | `913fad4` | `QPC-913fad4` | asyn |
| recsync | `RECSYNC` | <https://github.com/ChannelFinder/recsync> | `9834b94` | `9834b94` | `recsync-9834b94` | EPICS base only |
| retools | `RETOOLS` | <https://github.com/brunoseivam/retools> | `5ada1e1` | `5ada1e1` | `retools-5ada1e1` | EPICS base only |
| rgamv2 | `RGAMV2` | <https://github.com/jeonghanlee/rgamv2> | `27fc633` | `27fc633` | `rgamv2-27fc633` | asyn |
| scaler | `SCALER` | <https://github.com/epics-modules/scaler> | `beb5521` | `beb5521` | `scaler-beb5521` | asyn, autosave |
| sequencer | `SNCSEQ` | <https://github.com/epics-modules/sequencer> | `tags/R2-2-9` | `2.2.9` | `seq-2.2.9` | EPICS base only |
| snmp | `SNMP` | <https://github.com/jeonghanlee/snmp> | `tags/v1.1.0.4ja` | `1.1.0.4ja` | `snmp-1.1.0.4ja` | EPICS base only |
| sscan | `SSCAN` | <https://github.com/epics-modules/sscan> | `ce9660c` | `ce9660c` | `sscan-ce9660c` | sequencer |
| std | `STD` | <https://github.com/epics-modules/std> | `5f2e442` | `5f2e442` | `std-5f2e442` | asyn, sequencer |
| StreamDevice | `STREAM` | <https://github.com/paulscherrerinstitute/StreamDevice> | `tags/2.8.26` | `2.8.26` | `StreamDevice-2.8.26` | asyn, calc |
