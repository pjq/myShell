#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月19日 星期六 22时59分09秒
# File Name: lzu.sh
# Description: 
#########################################################################
#!/bin/bash
let i=2
while [ $i -lt 12 ];do
	echo "cctv${i} mms://tv1.lzu.edu.cn/cctv${i}" >>lzu.lst
	echo "cctv${i} mms://tv1.lzu.edu.cn/cctv${i}"
	((i++))
done
