#!/bin/bash
#this shell is used to get the real URL of the movie on :http://210.29.99.11:6666
#
mkdir -p   "/tmp/movie"
tmp="/tmp/movie"
echo $tmp
wget -O ${tmp}/htm  "http://210.29.99.11:6666/view/list.exl"
page_number=`cat ${tmp}/htm|iconv -c -f gb2312 -t utf8|grep "共有"|cut -d "&" -f1|cut -d ":" -f3|sed 's/页//' `
let page_number=$page_number
echo "the total number of web is: $page_number "
let i=1
#i refers to  the number of the web
while [ $i -lt ${page_number} ];do
	echo "starting downloading page:$i"
wget -O "${tmp}/movie"  "http://210.29.99.11:6666/view/list.exl?page=${i}"
((i++))
iconv -c -f gb2312 -t utf8  "${tmp}/movie" >>"${tmp}/movie-utf8"
done

cat "${tmp}/movie-utf8" |grep "value"|awk -F " value=\"" '{print $2}'|awk -F "\"><img src=" '{print $1}'|grep -v ">" >movie.list


rm -r "${tmp}"



