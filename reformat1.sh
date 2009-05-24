#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月06日 星期日 14时25分21秒
# File Name: reformat1.sh
# Description: 
#########################################################################
#!/bin/bash
awk '
BEGIN{
FS="[ \t:]+"
"date"|getline
print "Today is",$2,$3

}  '
