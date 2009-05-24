#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月08日 星期二 12时49分45秒
# File Name: weatherw3m.sh
# Description: 
#########################################################################
#!/bin/bash


read -p "input city in pinyin:" city

w3m -dump -no-cookie "http://php.weather.sina.com.cn/search.php?city=${city}&dpc=1"|grep ""
