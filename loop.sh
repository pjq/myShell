#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月05日 星期六 15时30分58秒
# File Name: loop.sh
# Description: 
#########################################################################
#!/bin/bash
let i=0
let sum=0;
while  [ $i -lt 100000 ] ;do
	let i+=1
#          ((i++))           #faster
	let sum+=$i
	
	echo $i  $sum
done
