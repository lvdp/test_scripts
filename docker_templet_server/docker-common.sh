#!/bin/bash

#init common docker container eg: memcached mq  mysqldb oracledb like
sudo docker rm -f memcached >/dev/null 2>&1
sudo docker rm -f activemq >/dev/null 2>&1
sudo docker rm -f zk_dubbo >/dev/null 2>&1
sudo docker rm -f redis >/dev/null 2>&1
sudo docker run -d -p 12000:12000 -p 3301:22 -h memcached --name memcached  memcached memcached -u root -p 12000 -m 1024m
sudo docker run -d -p 7060:8080 -p 2181:2181 -p 7070:7070 -p 3302:22 --name zk_dubbo -v /opt/zookeeper/data/:/opt/zookeeper-3.4.6/data/ zk_dubbo
sudo docker run -d -p 61616:61616 -p 8161:8161 -p 3303:22  --name activemq activemq
sudo docker run -d -p 6379:6379 -p 3304:22  --name redis redis
