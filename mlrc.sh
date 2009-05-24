#!/bin/bash

#下载的歌词默认保存在~/.lyrics
TMPDIR=~/.lyrics/tmp 
LRCDIR=~/.lyrics

USAGE(){
  echo "Usage: lrc [options] [arguments]"
  echo
  echo "Options"
  echo
  echo "  -d, --download - download lyrics (see below for examples)"
  echo "  -mpd           - download and show lyrics in mpd"
  echo "  -mocp          - download and show lyrics in mocp"
  echo "  -h, --help     - display this"
  echo
  echo "Examples"
  echo
  echo "  mlrc -d TITLE ARTIST"
  echo "         download lyrics of specified song, not case sensitive"
  echo
  echo "  mlrc -mpd"
  echo "         download and show lyrics of current song in mpd"
  echo "  mlrc -mopc"
  echo "         download and show lyrics of current song in mopc"
  echo
  exit
}

option=$1
title=$2
artist=$3

GETNAME(){
  case "$option" in
  '-d'|'--download')
   echo "$title $artist";;
 '-mpd')
   echo "`mpc playlist | grep ">" | sed -e "s/.*)\ //"`";;
 '-mocp')
   echo "`mocp -i | grep "^Title: " | sed -e "s/.*-\ //"`";;
esac
}

DOWNLRC(){
  [ -d $TMPDIR ] || mkdir -p  $TMPDIR
  NM="$(GETNAME)"
  if [ `locale |grep "LANG"` == "LANG=zh_CN.UTF-8" ];then
    lang=1
  fi
  gb=`echo "$NM" | iconv -c -f utf-8 -t gb2312 |od -t x1 -A n |tr " " %`
  wget "http://mp3.sogou.com/gecisearch.so?query="$gb""  -O /tmp/lrc_file
  LINKS(){
    echo `cat /tmp/lrc_file | grep -i "downlrc" | sed -e '2,$d' | awk -F"\"" '{print $2}'`
  }
  wget http://mp3.sogou.com/"$(LINKS)" -O /tmp/lrctmp
  iconv -f gb2312 -t utf-8 -c /tmp/lrctmp -o $LRCDIR/"$NM".lrc
  rm /tmp/lrctmp
  rm $TMPDIR/"$NM"
  echo "download success"
}

READLRC(){
  NM="$(GETNAME)"
  ifs=$IFS
  IFS="NOTSPACE"
  [ -d $TMPDIR ] || mkdir -p  $TMPDIR
  awk '! /(\] *.?)$|^( *)$|^[^\[]/' $LRCDIR/"$NM"".lrc" | while read LINE
  do
    echo $LINE | awk -F"]" '{ \
        if (NF > 2){ \
          for (i = 1; i < NF; i++){  \
            print $i"]"$NF; \
          }
         }else{ print $0; }\
        }'
  done | sort > $TMPDIR/"$NM"
  IFS=$ifs
}

DISPLAY(){
  NM="$(GETNAME)"
  LAST=""
  N=1
  LRC="$(< $TMPDIR/"$NM")"
  clear
  echo  -e "\033[;32m****** $NM ****** \033[0m "
  echo "  "
  while [ true ] ; do
    if [ "$NM" != "$(GETNAME)" ] ; then
      NM="$(GETNAME)"
      while [ ! -s $LRCDIR/"$NM"".lrc" ] ; do
        DOWNLRC
        NM="$(GETNAME)"
      done
      [ -s $LRCDIR/"$NM"".lrc" ] && [ ! -s $TMPDIR/"$NM" ] &&  READLRC
      LRC="$(< $TMPDIR/"$NM")"
      clear
      echo  -e "\033[;32m****** $NM ****** \033[0m "
      echo "  "
      N=1
    fi
    if [ $option = "-mpd" ] ; then
      TM=`mpc | grep "/" | awk -F" " '{print $3}' | awk -F"/" '{print $1}'`
    else
      TM=`mocp -i | grep "CurrentTime" | sed -e 's/CurrentTime:\ //'`
    fi
    [ "$TM" = ""  ] && break
    NOW=`echo "$LRC" | sed -n "/$TM/p" |cut -d"]" -f 2`
    if [ "$NOW" != ""  -a  "$NOW" != "$LAST" ] ; then
      N=`expr $N + 1`
      if [ $N -ge "10" ] ; then
        N=1
        clear
        echo  -e "\033[;32m****** $NM ****** \033[0m "
        echo "  "
        echo $LAST
      fi
      LAST=$NOW
      echo $NOW
    fi
    sleep 0.3
  done
}

DEFAULT(){
  [ "$1" = "reload" ] && rm -f "$TMPDIR/*"
  clear
  NM="$(GETNAME)"
  echo "$NM"
  while [ ! -s $LRCDIR/"$NM"".lrc" ] ; do
    DOWNLRC
    NM="$(GETNAME)"
  done
  if [ -s $LRCDIR/"$NM"".lrc" ] ; then
    READLRC
    DISPLAY
  fi
}

case "$1" in
  '-d'|'--download')
    DOWNLRC;;
  '-mpd')
    DEFAULT;;
  '-mocp')
    DEFAULT;;
  '-h'|'--help')
    USAGE;;
  *)
    echo "Option '$1' is not recognized, see mlrc --help."
esac 
