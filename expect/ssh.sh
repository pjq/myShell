#!/usr/bin/expect
set host  [lindex $argv 0]
set name "pengjianqing"
set passwd "271773661"
spawn ssh ${name}@${host}.unix-center.net
expect "*(yes/no)?*"
send "yes\n"
expect "*assword:*"
send "$passwd\n"
expect "*$*"
send "ls -la\n"
expect "*$*"
send "who\n"
expect "*$*"
send "uname -a\n"
expect "*$*"
send "exit\n"
expect eof
