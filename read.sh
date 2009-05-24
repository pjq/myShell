#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月05日 星期六 17时00分15秒
# File Name: read.sh
# Description: 
#########################################################################
#!/bin/bash
a=`cat number.txt`
echo "$a"
for str in "$a"
	echo $str
