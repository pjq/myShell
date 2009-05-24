#########################################################################
# Author: pengjianqing@sina.com
# Created Time: Sun 11 May 2008 01:01:55 PM CST
# File Name: tonew.sh
# Description: 
#########################################################################
#!/bin/bash
grep 'REPORT COUNT=22985' -B5 -C1 file.txt >newfile.txt
