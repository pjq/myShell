#!/bin/bash
#Copyright (c) 2007 bones7456 (bones7456@gmail.com)
#License: GPLv3
#echo "please keyin the city in chinese"
#echo -n "city:"
#read city
city="常州"
city=`grep "$city" ~/shell/weather/city.txt |cut -d "-" -f1`
#城市代码，留空可自动检测（自动检测不一定精确），城市代码可在 http://weather.265.com 上查询，是个5位的数字
#city=

if [ -n "$city" ] ;then
	wid=${city}
else
	wget -q -O /tmp/weather.html 'http://weather.265.com/get_weather.php?action=get_city';
	wid=`iconv -f gbk -t utf8 /tmp/weather.html | grep 'wid_265=' | sed -e 's/document\.cookie\ =\ "wid_265=//' | sed -e 's/".*//g'`;
fi
#echo "wid=${wid}"
wget -q -O /tmp/weather.html "http://weather.265.com/weather/${wid}.htm";
str=`iconv -f gbk -t utf8 /tmp/weather.html | grep 'show_weather' | sed -e 's/show_weather("//g'|sed -e 's/),\ "hd\.htm.*//g' | sed -e 's/new Array(//g' | sed -e "s/[\"|\ ]//g" | sed -e "s/,'/ /g" |sed -e "s/'//g"|sed -e "s/index.htm#$wid//g"|sed -e "s/),);//g"|sed -e "s/),//g"|sed -e "s/hz.htm#$wid//g"|sed -e "s/);//g"|sed -e "s/[[xd]b|[xn]|[hd]|[hb]|[hz]|[ga]].htm#$wid//g"`;	
#echo "str=${str}";
AnArray=( ${str} );
time=`date +%k`;
#echo "time=$time"
#echo "**********************************************************"
#if [ ${time} -gt 18 ] ; then
	echo ${AnArray[0]}：
        echo "今天天气:"  
        echo 温度:${AnArray[1]} 上午:${AnArray[2]}     下午：${AnArray[3]}      今晚：${AnArray[4]}
        #echo 明天：${AnArray[6]}
        echo "明天天气:"
        echo 温度:${AnArray[5]} 上午:${AnArray[6]}     下午：${AnArray[7]}      明晚：${AnArray[8]}
#elif [ ${time} -gt 12 ] ; then
	#echo ${AnArray[0]}： ${AnArray[1]} 下午：${AnArray[3]}；晚上：${AnArray[4]}
#else
	#echo ${AnArray[0]}： ${AnArray[1]} 上午：${AnArray[2]}；下午：${AnArray[3]}
#fi
#echo "**********************************************************"
rm -f /tmp/weather.html;
exit 0;
