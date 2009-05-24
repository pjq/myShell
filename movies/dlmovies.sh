mkdir -p   "/tmp/movie"
tmp="/tmp/movie"
echo $tmp




#wget -O "${tmp}/movie"  "http://210.29.99.11:6666/view/list.exl?serch=&Submit3=%CB%D1%CB%F7"

iconv -c -f gb2312 -t utf8  "${tmp}/movie" >"${tmp}/movie-utf8"


list=`cat "${tmp}/movie-utf8" |grep "<font color=#FFFFFF>" |sed 's/<img src=\"images\/blank.gif\" align=\"absmiddle\" border=\"0\"><a href=\"list.exl?channel//g'|sed 's/<img id=\"i//g'|sed 's/src=\"images\/plus_1.gif\"  align=\"absmiddle\" border=0 ><font color=//g'|sed 's/<\/font><\/font><\/a><br>//g'|sed 's/><font color=#FFFFFF//g'|sed 's/<\/font><\/a>//g'|cut -d ">" -f2`
echo "$list"|less


read -p "请输入电影名:" movie
 
a=`echo "$movie" | iconv -c -f utf-8 -t gb2312 | LANG=C sed 's/./&\n/g' | sed -n '$!l' |
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

wget -O "${tmp}/movie"  "http://210.29.99.11:6666/view/list.exl?serch=${a}&Submit3=%CB%D1%CB%F7"

iconv -c -f gb2312 -t utf8  "${tmp}/movie" >"${tmp}/movie-utf8"



cat "${tmp}/movie-utf8" |grep "value"|awk -F " value=\"" '{print $2}'|awk -F "\"><img src=" '{print $1}'|grep -v ">"


#rm -r "${tmp}"



