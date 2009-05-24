#!/bin/bash
echo "start vsftp"
/usr/local/sbin/vsftpd &
status=`netstat -an|grep :21`
echo $status

