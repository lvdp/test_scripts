#!/usr/bin/expect -f  

set sshport [lindex $argv 0]
set ip 127.0.0.1  
set password 123456 
set timeout 180 

spawn ssh -p $sshport root@$ip  
expect {  
 "*yes/no" { send "yes\r"; exp_continue}  
 "*password:" { send "123456\r" }  
}  

expect "#*"  
send "/opt/apache-tomcat-7.0.62/bin/shutdown.sh;\r"
send "/opt/apache-tomcat-7.0.62/bin/startup.sh;\r"  
send  "exit\r"  
expect eof
