#!/bin/bash

echo "==================================="
echo "可重启工程如下："
while read LINE; do
   #ignore annotation.
   echo "$LINE" |grep "^#" >/dev/null
   [ $? == 0 ] && continue

   #ignore blank line.
   [ -z "$LINE" ] && continue

   name=`echo $LINE |awk -F'/' '{print $4}'`
   echo "----> $name"
done < /opt/docker/server.txt
echo "==================================="
echo ''
