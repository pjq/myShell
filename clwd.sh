#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Sun 28 Dec 2008 07:50:48 PM CST
# File Name: clwd.sh
# Description: 
# This file is used to clean your  world file.
#USAGE:
#     ./clwd.sh -y,Clean your world file automaticly.
#     ./clwd.sh -n,You need to answer the question by yourself.
#########################################################################
#!/bin/bash



cleanworld()
{
    echo "***********************************************"
    read -p "Back up the world file and regenerate the world file?[y/n]:" ANSWER 
    if [ "y"  = $ANSWER ];then
	echo "cp /var/lib/portage/world ~ && >/var/lib/portage/world"
	cp /var/lib/portage/world ~ && >/var/lib/portage/world
	echo "regenworld"
	regenworld
    fi

    echo "***********************************************"
    read -p "Execute emerge --depclean -p?[y/n]:" ANSWER
    if [ "y" = $ANSWER  ];then
	emerge --depclean -p
    fi

    echo "***********************************************"
    read -p "Execute emerge --depclean ?[y/n]:" ANSWER
    if [ "y" = $ANSWER  ];then
	emerge --depclean 
    fi

    echo "***********************************************"
    read -p "Execute emerge -uDN world -pv?[y/n]:" ANSWER
    if [ "y" = $ANSWER  ];then
	emerge -uDN world -pv
    fi

    echo "***********************************************"
    read -p "Execute emerge -uDN world ?[y/n]:" ANSWER
    if [ "y" = $ANSWER  ];then
	emerge -uDN world 
    fi


    echo "***********************************************"
    read -p "Execute revdep-rebuild?[y/n]:" ANSWER
    if [ "y" = $ANSWER  ];then
	revdep-rebuild
    fi

    echo "***********************************************"
}

autocleanworld()
{
    echo "***********************************************"
    echo "The system will do the follow steps automaticly:" 
    echo "1.cp /var/lib/portage/world ~ && >/var/lib/portage/world"
    echo "2.regenworld"
    echo "3.emerge --depclean -p"
    echo "4.emerge --depclean" 
    echo "5.emerge -uDN world -pv"
    echo "6.emerge -uDN world" 
    echo "7.revdep-rebuild"
    echo "***********************************************"

    read -p "Are you sure?[y/n]:" ANSWER

    if [ "y" = $ANSWER  ];then
	echo "***********************************************"
	cp /var/lib/portage/world ~ && >/var/lib/portage/world
	echo "***********************************************"
	regenworld
	echo "***********************************************"
	emerge --depclean -p
	echo "***********************************************"
	emerge --depclean 
	echo "***********************************************"
	emerge -uDN world -pv
	echo "***********************************************"
	emerge -uDN world 
	echo "***********************************************"
	revdep-rebuild
	echo "***********************************************"
    fi

}
help()
{
    echo "***********************************************"
    echo "-h:help"
    echo "-y:do the clean world automaticly."
    echo "-n:you need to answer the question one by one."
    echo "***********************************************"
    exit 0;
}
myexit()
{
    echo "Unknown parameter,exit"
    exit 0;
}

STARTTIME=`date|cut -d " " -f4`

echo "***********************************************"
echo "This is used to clean your world file"
echo "USAGE:"
echo "-h:help"
echo "-y:do the clean world automaticly."
echo "-n:you need to answer the question one bye one."
echo "***********************************************"

case "$1" in
    -y ) autocleanworld;;
    -n ) cleanworld;;
    -h ) help;;
    *  ) myexit;;
esac



read -p "Do you want to delete all the independency files in /usr/portage/distfiles/?[y/n]:" ANSWER

if [ "y" = $ANSWER  ];then
    eclean-dist -d -p   
fi

if [ "y" = $ANSWER ];then
    read -p "Are you sure to delete those files?[y/n]:" ANSWER

    if [ "y" = $ANSWER  ];then
	eclean-dist -d    
    fi
fi

FINISHEDTIME=`date|cut -d " " -f4`

echo "***********************************************"
echo "OK,All done!Enjoy your clean world:)"
echo "***********************************************"
echo Start at:$STARTTIME
echo Finished at:$FINISHEDTIME 
echo "***********************************************"

