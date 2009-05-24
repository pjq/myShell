#!/usr/bin/expect
spawn ./talk.sh
expect "*name*"
send "gentoo\n"
expect "*happy*"
send "yes ,i am happy\n"
expect "why"
send "because it works\n"
expect eof

