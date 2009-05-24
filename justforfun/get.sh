#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Mon 26 May 2008 06:47:53 PM CST
# File Name: get.sh
# Description: 
#########################################################################
#!/bin/bash
let i=1
sum=16
while [ ${i} -lt ${sum} ];do 
	wget http://www.mjhy.cn/ebook/justforfun/${i}.htm
	((i++))
done

