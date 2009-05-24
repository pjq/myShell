#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月07日 星期一 20时26分10秒
# File Name: hello2.sh
# Description: 
#########################################################################
#!/bin/bash
#!/bin/sh

yes_or_no() {
	echo "Is your name $* ?"
	while true
	do
		echo -n "Enter yes or no: "
		read x
		case "$x" in
			y | yes ) return 0;;
			n | no ) return 1;;
			* ) echo "Answer yes or no"
		esac
	done
}

echo "Original parameters are $*"

if yes_or_no "$1"
then
	echo "Hi $1, nice name"
else
	echo "Never mind" 
fi
