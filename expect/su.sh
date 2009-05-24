#!/usr/bin/expect -f
set password "root"
spawn su 
expect "口令*"
send "$password"
expect eof

