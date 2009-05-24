#!/usr/bin/expect
set ip "10.0.1.112"
set user "ftp"
set passwd "ftp"

spawn ftp $ip
expect "*Name*"
send "$user\n"
expect "Passowrd:"
send "$passwd\n"
expect "ftp> *"
send "get readme.txt\n"
expect "ftp> *\n"
send "ls -al\n"
expect "ftp> *"
send "quit\n"
expect eof

