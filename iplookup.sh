#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Sun 11 May 2008 12:40:13 PM CST
# File Name: iplookup.sh
# Description: 
#########################################################################
#!/bin/bash
curl -s -d  "ip=$1&action=2" http://www.ip138.com/ips8.asp -o /tmp/ipsearch.html
w3m -no-cookie -dump /tmp/ipsearch.html
