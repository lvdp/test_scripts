#!/bin/bash
## Writer Date: 2015.12.12
## Modify Date: 2016.02.24

echo "======================================="
echo "Author by Deploy init docker container."
echo "======================================="

while read LINE; do
   #ignore annotation.
   echo "$LINE" |grep "^#" >/dev/null
   [ $? == 0 ] && continue

   #ignore blank line.
   [ -z "$LINE" ] && continue

   PORT=`echo $LINE |awk -F'/' '{print $1}'`
   DUBBOPORT=`echo $LINE |awk -F'/' '{print $2}'`
   MEMERY=`echo $LINE |awk -F'/' '{print $3}'`
   PROJECTNAME=`echo $LINE |awk -F'/' '{print $4}'`
   SSHPORT=`echo $LINE |awk -F'/' '{print $5}'`
   ADDHOST=`cat /etc/hosts |grep -v "#"|grep -v "localhost" |grep -v '^$' |awk '{print "--add-host " $2":"$1}'`
   MOUNT="/opt/lvmama_index/:/opt/lvmama_index/ -v /var/www/webapps/:/var/www/webapps/ -v /opt/apache-tomcat-$PROJECTNAME/logs/:/opt/apache-tomcat-7.0.62/logs/ -v /opt/apache-tomcat-$PROJECTNAME/conf/server.xml:/opt/apache-tomcat-7.0.62/conf/server.xml"
   #out=`sudo docker run -d -it -p $PORT -p $DUBBOPORT -p $SSHPORT  -v $MOUNT  $ADDHOST -h $PROJECTNAME --name $PROJECTNAME  -m $MEMERY --link=zk_dubbo:zk_dubbo centos7-tomcat-base`

   #docker ps -a |grep -w "$PROJECTNAME" >/dev/null
   docker ps -a |awk '{print $NF}' |grep -v 'NAMES\|zk_dubbo\|redis\|activemq\|memcached' |grep -E "^${PROJECTNAME}$" >/dev/null
   [ $? == 0 ] && {
       echo -e "\e[1;33m ######### <$PROJECTNAME> container already exists!!! ###########\e[0m"
       continue
   }
   out=`docker run -d -it -p $PORT -p $DUBBOPORT -p $SSHPORT  -v $MOUNT  $ADDHOST -h $PROJECTNAME --name $PROJECTNAME  -m $MEMERY --link=zk_dubbo:zk_dubbo centos7-tomcat-base`

   echo "success $out docker container $PROJECTNAME"
done < server.txt
