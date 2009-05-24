#!/bin/bash

#******************
# coded by xiooli
#******************

LRCDIR=~/.lyrics  #lrc文件保存文件夹，可以自己改
[ ! -d "$LRCDIR" ] && mkdir "$LRCDIR"

#下载歌词的函数
DOWNLRC(){
   NM="$1"
   #判断当前locale，utf-8的locale将要使用编码转换
   [ `locale |grep "LANG=.*UTF-8"` ] && lang=1
   #将歌曲名字转换为urlencode，utf-8的locale必须先转换为gb的编码
     if [ "$lang" ];then
      #od的输出为每行16组，如果太长则会截断成两行，故而应该删除可能出现的换行符。
          gb=`echo "$NM" | iconv -c -f utf-8 -t gb2312 | od -t x1 -A n |tr "\n" " " |tr " " % |sed 's/%%/%/g'`
     else
          gb=`echo "$NM" | od -t x1 -A n |tr "\n" " " |tr " " % |sed 's/%%/%/g'`
     fi
   #从百度搜索里面找出当前歌曲的歌词下载页
     wget "http://www.baidu.com/s?wd="$gb"+filetype%3Alrc&cl=3" -O /dev/shm/lrc_file  -T 10 -q
   
   LINK=`cat /dev/shm/lrc_file |grep "LRC" |awk -F"href=\"" '{print $2}' |awk -F"\"" '{print $1}'`
   
     while [ "$LINK" ] && [ ! -s "$LRCDIR/$NM.lrc" ];do
      if [ "$lang" ];then
         wget "$LINK" -O /dev/shm/lrctmp  -T 5 -t 2 -q
         [ -s /dev/shm/lrctmp ] && iconv -f gb2312 -t utf-8 -c /dev/shm/lrctmp -o "$LRCDIR/$NM.lrc"
      else
         wget "$LINK" -O "$LRCDIR/$NM.lrc"  -T 5 -t 2 -q
      fi
      [ -s "$LRCDIR/$NM.lrc" ] && sed -i'' "s/\r/\n/g" "$LRCDIR/$NM.lrc" #去掉dos字符
      > /dev/shm/lrctmp
   done
   
}

#分割lrc文件的函数（仅取出时间信息并转换成秒）
LRC_SPLIT() {
   tm_arr=`cat "$1" |grep "\[[0-9]" |while read LINE
      do
         echo $LINE |sed "s/\[0/\[/g;s/\]\[/ /g;s/\[//g;s/\][^\[].*//g;s/:0/:/g;s/\]//g"
      done`
   for i in ${tm_arr[@]};do
      min=`echo $i |sed 's/:.*//'`
      sec=`echo $i |sed 's/\..*//;s/^.*://'`
      echo $(($min*60+$sec))
   done

}
#根据播放时间找出lrc中对应的时间（lrc时间中小于播放时间的最大时间）
FIND_LRC_TIME() {
   if [ "${TIME_LIST[0]}" ];then   
      pltm="$1"
      let tmp=-1
      for lrctm in ${TIME_LIST[@]};do
         if [ "$tmp" -lt "$pltm" ] && [ "$tmp" -lt "$lrctm" ] && [ "$pltm" -ge "$lrctm" ];then
            let tmp="$lrctm"
         fi
      done
   fi
   [ "$tmp" ] && printf '%.2d:%.2d' $(($tmp/60)) $(($tmp%60))
}
#osd模式显示(未安装gnome-osd则终端输出)
let n=1
OSD_SHOW() {
   if [ `which gnome-osd-client` ];then
      gnome-osd-client -f "<message id='myplugin' osd_fake_translucent_bg='off'>`echo "$*"`</message>" 2>/dev/null
   else   
      [ "$n" -eq 1 ]  && clear && echo  -e "\033[;32m******"$TITLE"****** \033[0m " && let n=5
      echo "$*" && let n="$n"-1
   fi
}

#显示歌词函数
DISPLAY() {
   if [ "$1" ] && [ "$2" ];then
      lrc_line=`echo $1 |awk -F"$2" '{print $2}' |sed "s/@.*//g;s/^.*\]//g"`
      if [ "$lrc_line" ] && [ "$line" != "$lrc_line" ];then
         OSD_SHOW "$lrc_line"
         line="$lrc_line"
      fi
   fi
}

#*******main******
dbus-monitor --session |while read a;do

   [ "$a" = "byte 0" ] && continue

   if [ "`echo "$a" |grep "file:///.*\.[mwo][mgp]"`" ];then
      go_on=1
   elif [ "`echo "$a" |grep "^uint"`" ];then
      go_on=2
   else
      continue
   fi

   #找到歌曲题目
   if    [ "$go_on" = 1 ];then

      title=`echo "$a" |awk -F'\"' '{print $2}'` && [ "$title" ] && [ "$title0" != "$title" ] && TITLE=`echo "$title" \
      |perl -p -e 's/%(..)/pack("c", hex($1))/eg' |sed 's/\.[mw].*//g;s/.*\///g'` && title0="$title" && title_changed=1

      if [ "$title_changed" ];then
         LRC=""
         TIME_LIST=""
         [ `which gnome-osd-client` ] && OSD_SHOW "******"$TITLE"******"
         notfound="no" && TIME_LIST="" && TIME="0" && sleep 1
         [ -s "$LRCDIR/$TITLE.lrc" ] && TIME_LIST=($(LRC_SPLIT "$LRCDIR/$TITLE.lrc")) \
         && LRC=$(cat "$LRCDIR/$TITLE.lrc" |grep "^\[" |tr "\n" "@" )
         title_changed=""

      fi
      go_on=""
   fi
   
   [ "$notfound" = yes ] && continue

   #下载歌词
   if [ ! -s "$LRCDIR/$TITLE.lrc" ] && [ "$TITLE" ];then

      DOWNLRC "$TITLE"
      [ ! -s "$LRCDIR/$TITLE.lrc" ] && OSD_SHOW "$TITLE:未找到lrc文件" && notfound="yes"
      [ -s "$LRCDIR/$TITLE.lrc" ] && TIME_LIST=($(LRC_SPLIT "$LRCDIR/$TITLE.lrc"))\
      && LRC=$(cat "$LRCDIR/$TITLE.lrc" |grep "^\[" |tr "\n" "@" )

   fi

   #取得播放时间并显示歌词
   if [ "$go_on" = 2 ];then

      t=`echo "$a" |sed 's/.*\ //g'`
      [ "$t" ] && [ -s "$LRCDIR/$TITLE.lrc" ] && TIME="$(FIND_LRC_TIME "$t")" && t="" \
      && DISPLAY "$LRC" "$TIME"
      go_on=""
   fi

done 
