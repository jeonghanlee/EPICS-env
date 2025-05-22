# Git

## To merge a specific file from another branch into working branch

```
git checkout debian13
git checkout master -- scripts/setEpicsEnv.bash
git add .
git commit -m "Merge file from master"
```
