#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Sat 07 Feb 2009 12:19:10 PM CST
# File Name: automail.sh
# Description: 
#########################################################################
#!/bin/bash
IP=`w3m -dump -no-cookie http://www.net.cn/static/customercare/yourIP.asp|grep  -A 2 本地上网|tail -n 1|cut -b1-`
#echo IP=$IP
IP=`echo IP=$IP|cut -b5-`
#echo IP=$IP
echo This is generated by the server to notify the WAN IP address>mail.txt
echo The IP is:$IP >>mail.txt
echo You can visit it:>>mail.txt
echo The Home:http://$IP/>>mail.txt
echo File download:http://$IP/ftp/>>mail.txt
echo The Bbs:http://$IP/bbs/>>mail.txt
echo The Blog:http://$IP/blog/>>mail.txt
echo The Webmail:http://$IP/webmail/>>mail.txt
echo "**************************************************************">>mail.txt
echo If the phlinux works correctly,you also can visit:>>mail.txt
echo http://gentoo-pjq.vicp.net>>mail.txt
echo "**************************************************************">>mail.txt
echo Any probem,please contact me:>>mail.txt
echo Email:>>mail.txt
echo pengjianqing@sina.com:>>mail.txt
echo percy.peng@qisda.com:>>mail.txt
echo pjq@gentoo-pjq.vicp.net>>mail.txt
echo Phone or Fetion:>>mail.txt
echo "15950066537">>mail.txt
echo Skype:>>mail.txt
echo pengjianqing>>mail.txt
echo MSN:>>mail.txt
echo pengjianqing@sina.com>>mail.txt
echo QQ:>>mail.txt
echo "271773661">>mail.txt
echo "**************************************************************">>mail.txt
mail -s "IP Notice Mail" pengjianqing@sina.com <mail.txt
#mail -s "IP Notice Mail" percy.peng@qisda.com<mail.txt