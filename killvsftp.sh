#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月07日 星期一 21时45分06秒
# File Name: killvsftp.sh
# Description: 
#########################################################################
#!/bin/bash
pid=` ps aux|grep \/usr\/local\/sbin\/vsftpd|grep -v grep|awk -F"0.0" '{print $1}'|awk -F"      " '{print $2}'`
echo $pid
for var in $pid;do
	echo "kill pid=$var"
	kill $var
done
