#!/bin/bash
#Copyright (c) 2007 percy (pengjianqing@sina.com.cn)
#License: GPLv3
#2008年 04月 07日 星期一 17:43:25 CST
#

mkdir -p   "/tmp/weathertmp"
tmp="/tmp/weathertmp"
echo $tmp


read -p "请输入要查询天气的城市名:" city      

a=`echo "$city" | iconv -c -f utf-8 -t gb2312 | LANG=C sed 's/./&\n/g' | sed -n '$!l' |
while read str;do
str=${str%$}
if [ ${#str} -eq 3 ];then
printf "%%%X" "0${str}"
elif [ "X${str}" == "X" ];then
echo -n '%20'
else
echo -n $str
fi
done
echo`



wget -O "${tmp}/sinaweather"  "http://php.weather.sina.com.cn/search.php?city=${a}&dpc=1"

iconv -c -f gb2312 -t utf8  "${tmp}/sinaweather" >"${tmp}/sina-utf8"


grep $city "${tmp}/sina-utf8" |cut -d ">" -f2|cut -d "<" -f1 |sed 's/^/########################/g'|sed 's/$/#######################/g' |head -n 3 >"${tmp}/DAY"     #今日，明日，后天

year=`date |cut -b3-7`
grep "$year" "${tmp}/sina-utf8" |cut -d ">" -f2|cut -d "<" -f1|sed 's/&nbsp;//g'|sed 's/^/YEAR/g' >"${tmp}/TIME"


grep  污染指数  "${tmp}/sina-utf8"  -n|awk -F "<span>" '{print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11}'|sed 's/<\/span>//g'|sed 's/<\/p>//g' |sed 's/<\/div>//g'>"${tmp}/INDEX"  #得到指数信息


grep "Weather_TP" "${tmp}/sina-utf8" |cut -d ">" -f2|cut -d "<" -f1|sed 's/^/TP/g'   >"${tmp}/TP"  #得到天气信息
grep "Weather_W" "${tmp}/sina-utf8" |cut -d ">" -f2|cut -d "<" -f1|cut -d ";" -f2 |sed 's/^/@/g' >"${tmp}/W"    #得到风力信息

cat "${tmp}/DAY" >"${tmp}/ALL"
cat "${tmp}/TIME" >>"${tmp}/ALL"
cat "${tmp}/TP" >>"${tmp}/ALL"
cat "${tmp}/W" >>"${tmp}/ALL"
cat "${tmp}/INDEX" >>"${tmp}/ALL"




awk '{a[NR]=$0}END{for(i=1;i<=NR/5;i++)printf "%s\t%s\t%s\t%s\t%s\n",a[i],a[i+NR/5],a[i+2*NR/5],a[i+3*NR/5],a[i+4*NR/5]}'  "${tmp}/ALL"  >"${tmp}/SUM1"
cat "${tmp}/SUM1"|sed   's/<p>/\n*/g'|sed 's/污染指数/\n* 污染指数/g'|sed 's/TP/\n天气：/g'|sed 's/@/\n/g'|sed 's/YEAR/\n/g'  >"${tmp}/SUM2"

cat "${tmp}/SUM2"




#rm -r "${tmp}"

