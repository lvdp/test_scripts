#!/usr/bin/python
#coding:utf-8

try:
	import xml.etree.cElementTree as ET
except ImportError:
	import xml.etree.ElementTree as ET

import os,sys,re
import socket
import fcntl
import struct

def getIPAddress(ifname):
	s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	return socket.inet_ntoa(fcntl.ioctl(
		s.fileno(),
		0x8915,  # SIOCGIFADDR
		struct.pack('256s', ifname[:15])
		)[20:24])

#read dir filename
def listdirFun(dir):
	xmlfile = []
	lists = os.listdir(dir)
	pattern = re.compile("apache-tomcat-.*")
	for line in lists:
		if pattern.match(line):
			#print line
			str = '/'
			seq = ('/opt',line,'conf','server.xml')
                        filepath = str.join(seq)
			xmlfile.append(filepath)
	return xmlfile


#read xml file func
def showxmlFunc(file):
        fo = open('urlTomcat.txt', 'a')
	try:
		tree = ET.parse(file)
		root = tree.getroot()
	except Exception, e:
		print "Error: Cannot parse file: server.xml."
		sys.exit(1)

	for service in root.findall('Service'):
		#print service.attrib
		for connector in service.findall('Connector'):
			#print connector.attrib
			port = connector.get('port')
			#print 'Port -->',port
		for engine in service.findall('Engine'):
			#print engine.attrib
			for host in engine.findall('Host'):
				#print host.attrib
				for context in host.findall('Context'):
					#print context.attrib
					#displayname = context.get('displayName')
					#print "displayName -->",displayname
					#docbase = context.get('docBase')
					#print "docBase -->",docbase
					path = context.get('path')
					#print "Path -->",path
	IP = getIPAddress('eth0')
	fo.write('http://'+IP+':'+port+path+'/'+'checkversion.jsp'+'\n')
	fo.close()
	#print 'http://'+IP+':'+port+path+'/'+'checkversion.jsp'
	#print "***" * 20
	
	


if __name__ == '__main__':
	#print listdirFun('/opt')
        fo = open('urlTomcat.txt', 'w+')
	fo.close()
	for line in listdirFun('/opt'):
		#print 'Tomcat Project ->',line
		showxmlFunc(line)
	print getIPAddress('eth0')
