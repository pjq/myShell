#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月05日 星期六 16时53分37秒
# File Name: url.sh
# Description: 
#########################################################################
#!/bin/bash
a=`echo "$1" | iconv -c -f utf-8 -t gb2312 | LANG=C sed 's/./&\n/g' | sed -n '$!l'` 
echo $a|while read str;do
	str=${str%$}
	if [ ${#str} -eq 3 ];then
		printf "%%%X" "0${str}"
	elif [ "X${str}" == "X" ];then
		echo -n '%20'
	else
		echo -n $str
	fi
done
#echo $a 
echo `
echo $a 
