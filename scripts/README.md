# Scripts

## `caget_pvs.bash`

It is very useful to check your PVs through command line environment.

Here are several examples:


* Use the regular expression to filter only `Ti[1-8]` suffix PVs with 1 sec watch and reset your EPICS environment options

```bash
bash scripts/caget_pvs.bash -l /vxboot/PVnames/ioctest-tcmd -c -f "Ti[1-8]$" -w 1
```
