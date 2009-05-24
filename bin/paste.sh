#!/bin/bash

if [[ $# -eq 1 && -f $1 ]];then 
	nopaste $1
elif which $1 >/dev/null 2>&1 ; then
	$@ | nopaste
else
	echo "no such file: $1"
fi
