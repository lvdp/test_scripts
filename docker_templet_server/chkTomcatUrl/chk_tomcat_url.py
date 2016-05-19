#!/usr/bin/python
#coding=utf-8

import urllib2
from urllib2 import URLError

resultUrl = []
cnt = 0
notOpen=0
okOpen=0
urlfile = open('urlTomcat.txt', 'r')
imgNotOpen = open('urlerr.txt', 'w+')

for line in urlfile:
	cnt += 1
	#print 'Checking url:',line.strip('\r\n')
	print "\033[1;33;40m%s %s\033[0m" % ("Checking url:",line.strip('\r\n'))
	try:
		response = urllib2.urlopen(line)
	except URLError, e:
		if hasattr(e, 'reason'): ##stand for URLError
			#print 'Can not reach a server, wrinting...'
			resultUrl.append(line)
			notOpen += 1
			imgNotOpen.write(line)
			#print "write url success!"
			#print line.strip('\r\n'), 'is unreachable! Error.Error.Error!!!'
			print "\033[1;31;40m%s %s %s\033[0m\n" % (line.strip('\r\n'), 'URLError! Error.Error.Error!!!',e)
		elif hasattr(e, 'code'): ##stand for HTTPError
			#print 'Find http error, wrinting...'
			resultUrl.append(line)
			notOpen += 1
			imgNotOpen.write(line)
			#print "write url success!"
			#print line.strip('\r\n'), 'is unreachable! Error.Error.Error!!!'
			print "\033[1;31;40m%s %s %s\033[0m\n" % (line.strip('\r\n'), 'HTTPError! Error.Error.Error!!!',e)
		else: ##stand for unknown error
			#print 'Unkonwn error, writing...'
			resultUrl.append(line)
			notOpen += 1
			imgNotOpen.write(line)
			#print "write url success!"
			#print line.strip('\r\n'), 'is unreachable! Error.Error.Error!!!'
			print "\033[1;31;40m%s %s %s\033[0m\n" % (line.strip('\r\n'), 'Unknown! Error.Error.Error!!!',e)
	else:
 	 	##print 'url is reachable!'
		okOpen += 1
		#print line.strip('\r\n'), 'is reachable! OK.OK.OK!!!\n'
		print "\033[1;32;40m%s %s\033[0m" % (line.strip('\r\n'), 'is reachable! OK.OK.OK!!!\n')
		response.close()
	finally:
		pass

print "Checking url finished:"
print "Check total: <",cnt,">"
print "Response 200: <",okOpen,">"
print "Can not response 200: <",notOpen,">"
#print resultUrl.append(line)

urlfile.close()
imgNotOpen.close()

