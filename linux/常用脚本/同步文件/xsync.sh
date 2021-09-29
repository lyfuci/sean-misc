#!/bin/bash

if [ $# -lt 1 ]
then
  echo Not Enough Arguments!
fi

# you should change host list on your environment
host_list="hadoop102 hadoop103 hadoop104"

for host in $host_list
do
  echo ========== $host ==============
  for file in "$@"
  do
    if [ -e "$file" ]
    then
      pdir=$(cd -P $(dirname "$file"); pwd)
      fname=$(basename $file)
      ssh $host "mkdir -p $pdir"
      rsync -av $pdir/$fname $host:$pdir
    else
      echo $file does not exists!
    fi
  done
done