#!/bin/bash
## NAME:   nettv.sh
## Author: zwhuang
## Email:  zwhuang@gmail.com
## Dated:  (Oct. 23, 2006)
## USAGE:  use IP address as input, the same as ``nmap''
##
##         nettv.sh -i 222.20.220.0/24
##    or
##         nettv.sh
##
PROG_NAME=nettv.sh
IP_ADDRESS=NULL
TMPFILE=/tmp/nettv.tmp
LSTFILE=/tmp/nettv.lst
LSTFLAG=0
PLAY_IT=1

## Usage; ##{{{
usage()
{
  echo "   [Usage]: nettv.sh [-h] [-d] [-i ip_address] [-f ip_listfile]"
  echo ""
  echo "     -i    specify the (i)p_address to be scanned;"
  echo "     -f    use an ip_list (f)ile;"
  echo "     -d    (d)aemon mode, only gets IPs, doesn't call mplayer."
  echo "     -h    (h)elp message;"
  echo ""
  exit 1
}
##}}}

## GetOpts; ##{{{
while getopts "i:f:dh" opt
do
  case $opt in
    i) IP_ADDRESS=$OPTARG;;
    f) LSTFLAG=1
       LSTFILE=$OPTARG;;
    d) PLAY_IT=0;;
    h) usage;;
    ?) usage;;
  esac
done
##}}}

if [ $LSTFLAG -eq 0 ] && [ "$IP_ADDRESS" != NULL ];then
  # getting valid IP address' with port 8888 open;
  nmap "$IP_ADDRESS" -p 8902 -oG $TMPFILE > /dev/null
  grep open $TMPFILE | sed 's/Host: \([0-9.]*\).*/\1/g' > $LSTFILE
fi

if [ ! -r $LSTFILE ];then
  echo "*** The NetTV IP list file [$LSTFILE] seems not reachable."
  echo "*** You'd better run <$PROG_NAME> with [-i ip_address]."
  exit 1
fi
# playing the video resource of these IP's one by one;
# you can switch to the next one by pressing ``q'' to quit from the present
# video;
cat $LSTFILE

if [ $PLAY_IT -eq 1 ];then
  for OPENIP in `cat $LSTFILE` 
  do
    echo ">>> Playing NetTV [#] $OPENIP"
    mplayer  -ontop -afm dmo http://$OPENIP:8902/1.asf > /dev/null
    sleep 0.25
  done
fi

# vim:fdm=marker:fmr=##{{{,##}}}:tw=78
