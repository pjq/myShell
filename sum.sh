#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月05日 星期六 15时27分17秒
# File Name: sum.sh
# Description: 
#########################################################################
#!/bin/bash
# filename: sum.sh
# usage: sh sum.sh test_file

file=$1

for i in `cat $file`
do
	        let "sum = $sum + $i"
	done
	echo $sum 
