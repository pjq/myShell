#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Wed 04 Jun 2008 11:02:41 AM CST
# File Name: p.sh
# Description: 
#########################################################################
#!/bin/bash
tvlist=/home/pjq/shell/tvedu/tvedu.list
grep -v "#" ${tvlist}  |grep -n ""

read -p "input the channel:"  tv  

mplayer  `grep -v "#" ${tvlist}  |grep -n ""|grep "${tv}:"|awk -F " " '{print $2}'`
