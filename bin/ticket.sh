#!/bin/bash

url="http://piao.kooxoo.com/search?City=%E5%8C%97%E4%BA%AC&From=%E5%8C%97%E4%BA%AC&vFrom=%E5%8C%97%E4%BA%AC&q=%E5%91%BC%E5%92%8C%E6%B5%A9%E7%89%B9&cp=TicketSale&T=Ticket&Cat=sale"

key1="卧"
key2="2月15日"
#key2="2月15日|2月14日"

while /bin/true ; do

        data=$(curl -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)" "$url" 2>/dev/null)
        sell=$(echo "$data" | sed -n '/<div id="ResultDiv">/,/<\/div>/p')
        sell=$(echo "$sell" | egrep "$key1" | egrep "$key2")

        clear

        phones=$(echo "$sell" | awk -F"," '{print $4}' | sed 's/"//g')

        include2=0

        for phone in $(echo "$phones");do
                include=0
                while read line;do
                        if [ "$phone" = "$line" ];then
                                include=1
                        fi
                done < pp
                if [ "$include" = 0 ];then
                        include2=1
                        echo -e "\033[0;31m$phone\33[0m"
                        echo "$phone" >> pp
                fi
        done

        echo "$sell" | awk -F"," '{print $5"___"$2"___"$4}' | sed 's/"//g'

        if [  "$include2" = 1 ];then
                echo -e "\n  ->$(date +%X) Found a new phone,press Enter to continue..."
                read f
        fi

        for ((i=1;i<=20;i++));do
                echo -n "$i..."
                sleep 1s
        done
done
