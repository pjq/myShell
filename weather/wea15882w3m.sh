#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月08日 星期二 12时57分45秒
# File Name: weatherw3m2.sh
# Description: 
#########################################################################
#!/bin/bash




#read -p "input city in pinyin:" city

#notify-send -u critical -t 10000 "changzhou tianqi" "`w3m -dump -no-cookie "http://www.15882.com/tianqi/changzhou.htm"|grep ^20`"

w3m -dump -no-cookie "ftp://10.1.3.112/tianqi/changzhou.htm"|grep ^20>~/shell/weather/changzhou.txt
w3m -dump -no-cookie "ftp://10.1.3.112/tianqi/changzhou.htm"|grep ^20

#echo "just a test!~"
