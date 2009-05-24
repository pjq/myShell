#!/bin/bash
if [  "$SHELL" = "/bin/bash" ]; then
 echo "your login shell is the bash"
 else
 echo "your login shell is not bash but $SHELL"
 fi
 file=~/shell/test
 if [ -f $file ];then
 echo "${file} is a file"
 else echo "${file} is not a file"
 fi
 if [ "ab" = $1 ];then
      echo "ab=$1"
  else echo "ab not =$1"
fi
i=1
if [ $i != 10000 ];then
       echo $i 
      $i=$i + 1       

fi
