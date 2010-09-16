#!/bin/bash

proc_string=$1
signal=$2

pids=`ps -ef | grep $proc_string | grep -v grep | grep -v process_killer | awk '{print $2}'`

for pid in $pids
do
  for x in `pstree -p $pid | grep -o '[0-9]\{2,7\}'`
  do
    kill -${signal} $x
  done
done
exit 0

