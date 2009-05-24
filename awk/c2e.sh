#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月06日 星期日 14时41分49秒
# File Name: c2e.sh
# Description: 
#########################################################################
#!/bin/bash
awk '
BEGIN {
while(getline<ARGV[1]){
	English[++n]=$1
	Chinese[n]=$2
}
ARGV[1]="-"
srand()
question()
}

{
	if($1 !=English[ind])
	{print "Try again"
		getline
		question()
	}
	else{
		print "\nYou are rigth~!Press Enter to Continue---"
		getline
		question()

}
}
function question(){
ind=int(rand()*n)+1
system("clear")
print "Press\"ctrl-d\" to exit"
printf("\n%s",Chinese[ind]" 的英文生字是：")

	}
' $*
