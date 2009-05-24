#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月09日 星期三 20时31分41秒
# File Name: k.sh
# Description: 
#########################################################################
#!/bin/bash
pid=`ps aux|grep $1|awk '{print $2}'`
ps aux|grep $1|awk '{print $1,$2,$11}'
#echo $1 pid=$pid
echo "starting kill $1 $pid"
for var in $pid ;do
let p=$var
let i=$p+1
echo p+1=$i
echo kill $1 $p
kill $p
echo "now $1  $p has been killed"
done
