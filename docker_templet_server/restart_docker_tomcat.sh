#!/bin/bash

PROJECT=$1

if [ ! -z "$PROJECT" ]; then
   NAME=0
   dockersshport=0
   invalidName=''
   while read LINE; do
      #ignore annotation.
      echo "$LINE" |grep "^#" >/dev/null
      [ $? == 0 ] && continue

      #ignore blank line.
      [ -z "$LINE" ] && continue

      iname=`echo $LINE |awk -F'/' '{print $4}'`
      if [ "$PROJECT" == "$iname" ];then
         sshport=`echo $LINE |awk -F'/' '{print $5}'`
         dockersshport=`echo $sshport|awk -F ':' '{print $1}'`
         NAME=${iname}
         dockersshport=${dockersshport}
         break
      else
         invalidName=${PROJECT}
      fi
   done < /opt/docker/server.txt

   [ $dockersshport != 0 ] && {
       expect /opt/docker/expect_docker_tomcat.sh $dockersshport
       tail -f /opt/apache-tomcat-$NAME/logs/catalina.out;
   } || {
        echo -e "#### ${invalidName} 没有权限重启!!! ####\n" 
   }

else
   echo "================================="
   echo "Author by Deploy e.g.:"
   while read LINE; do
      #ignore annotation.
      echo "$LINE" |grep "^#" >/dev/null
      [ $? == 0 ] && continue

      #ignore blank line.
      [ -z "$LINE" ] && continue

      iname=`echo $LINE |awk -F'/' '{print $4}'`
      echo "./restart_docker_tomcat.sh ${iname}"
   done < /opt/docker/server.txt
   echo "================================="
fi
