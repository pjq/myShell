#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Wed 04 Feb 2009 06:41:20 PM CST
# File Name: pp.sh
# Description: 
#########################################################################
#!/bin/bash
echo  -n Input the Music name:
read  music
list=`mpc listall|cat -n|grep -i $music`
echo "$list"
#mpc listall|cat -n|grep -i $music|cut -b-7|while read music 
#do
#echo mpc play $music
#mpc play $music&
#done

echo -n Input the Music Number:
read  music
name=`echo "$list"|grep $music`
echo "Now playing music:"
mpc play $music
