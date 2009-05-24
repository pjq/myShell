#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月12日 星期六 12时13分20秒
# File Name: checkmail.sh
# Description: 
#########################################################################
#!/bin/bash

gmail_login="pengjianqing"
gmail_password="271773661"

dane="$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
https://${gmail_login}:${gmail_password}@mail.google.com/mail/feed/atom \
--no-check-certificate | grep 'fullcount' \
| sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//' 2>/dev/null)"
#echo  dane=$dane
if [ -z "$dane" ]; then
	echo "Connection Error !"
else
	echo "GMail: $dane list(Inbox)"
fi

