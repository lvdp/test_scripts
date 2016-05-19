#!/bin/bash

server=$1

if [ ! -z "$server" ]; then
   N=0
   dockersshport=0
   invalidName=''
   while read LINE; do
      #ignore annotation.
      echo "$LINE" |grep "^#" >/dev/null
      [ $? == 0 ] && continue

      #ignore blank line.
      [ -z "$LINE" ] && continue

      name=`echo $LINE |awk -F'/' '{print $4}'`

      if [ "$server" == "$name" ];then
         sshport=`echo $LINE |awk -F'/' '{print $5}'`
         dockersshport=`echo $sshport|awk -F ':' '{print $1}'`
         N=$name
         dockersshport=$dockersshport
         break
      else
         invalidName=${server}
      fi

   done < /opt/docker/server.txt
   [ $dockersshport != 0 ] && {
        echo "**** $N 正在重启... ****"
        expect /opt/docker/expect_docker_tomcat.sh $dockersshport >/dev/null
        echo "**** $N 重启完成!!! ****"
   } || {
        echo "#### <$invalidName> 没有权限重启!!! ####" 
   }

else
   echo "==================================="
   echo "没有选择任何工程或没有权限重启!!!"
   echo "==================================="
fi
