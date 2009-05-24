#!/bin/bash
#coded by xiooli
#使用方法：downdocs.sh -f [文档类型] [待文件名],不加-f参数默认搜索lrc文件。
#文档类型包括lrc(歌词文件)、doc、xls、pdf、ppt等。
#参考了benqlk的部分代码：http://forum.ubuntu.org.cn/viewtopic.php?t=95073，在此表示感谢。
#下载的文件默认保存在~/docs/filetype目录，保存的文件名格式为：文件名.filetype
if [ $1 == "-f" ];then
   filetype=$2
   keyword=$3
else
   filetype="lrc"
   keyword=$1
fi
#在此改变文件的保存目录
save_dir=~/docs/$filetype
if ! [ -d ~/docs ];then
   mkdir ~/docs
fi
if ! [ -d $save_dir ];then
   mkdir $save_dir
fi
if [ `locale |grep "LANG"` == "LANG=zh_CN.UTF-8" ];then
   lang=1
fi
if [ $lang ];then
   tmp=`echo "$keyword" | iconv -c -f utf-8 -t gb2312`
else
   tmp=$keyword
fi
#把中文转换成16进制数字和字母不变(此段代码是参考的benqlk兄的)
a=`echo "$tmp" | LANG=C sed 's/./&\n/g' | sed -n '$!l' |
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
wget "http://www.baidu.com/s?wd=$a+filetype%3A$filetype&cl=3" -O /tmp/src_file
if [ $lang ];then
   iconv -f gb2312 -t utf-8 -c /tmp/src_file >/tmp/src_file_utf8
   cat /tmp/src_file_utf8 |grep -i "<b>【$filetype】</b>" |sed 's/href=\"/\n/g' |sed 's/.*cache.baidu.com.*//g' \
   |awk -F"</font>" '{print $1,$2}' |sed 's/ target=.*\">//g' |sed 's/<.*>//g;s/文件格式://g;s/ //g' \
   |grep "^http" |grep -n "^http">/tmp/links
else
   mv /tmp/src_file /tmp/src_file_utf8
   cat /tmp/src_file_utf8 |grep -i "<b>【$filetype】</b>" |sed 's/href=\"/\n/g' |sed 's/.*cache.baidu.com.*//g' \
   |awk -F"</font>" '{print $1,$2}' |sed 's/ target=.*\">//g' |sed 's/<.*>//g;s/�ļ���ʽ://g;s/ //g' \
   |grep "^http" |grep -n "^http">/tmp/links
fi
echo "文件类型：$filetype
"
cat /tmp/links |awk -F"\"" '{print $2}'   |grep -n ".*"
if  [ -s /tmp/links ];then
   read -p "请选择你要下载的文件:" num
   url=`cat /tmp/links |grep "^$num" |awk -F"\"" '{print $1}' |awk -F":" '{print $2":"$3}'`
   name=`cat /tmp/links |grep "^$num" |awk -F"\"" '{print $2}'`
   if [ -e $save_dir/$name.$filetype ];then
      echo "已存在同名文件！"
   else
      if [ $lang ] && [ $filetype == "lrc" ] ;then
         wget "$url" -O /tmp/$name.$filetype
         iconv -f gb2312 -t utf-8 -c /tmp/$name.$filetype -o $save_dir/$name.$filetype
         rm /tmp/$name.$filetype
      else
         wget "$url" -O $save_dir/$name.$filetype
      fi
   fi
else
   echo "未搜索到结果"
fi

