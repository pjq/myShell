#!/bin/bash

# this script can update date/version tag and English CVS version automatically
# before using this script, you need a checked-out cvs tree on your harddisk,
# and set the en_root_path variable below to that dir
#
# usage:
# 	1. cd $en_root_path
# 	2. cvs up
#       3. update zh_cn translations 
#       4. run this script
# 	5. check 'git diff' and 'git commit'

# please change this to the checked out cvs tree
en_root_path="/home/zhangle/gentoo/xml/"

getver() {
	grep -o 'Header.*v 1.[0-9]\+' $1 | sed 's/^.*v \(.*\)/\1/'
}
getversion() {
	grep -o '<version>.*</version>' $1 | sed 's/<version>\(.*\)<\/version>/\1/'
}
setver() {
	local ver=$(getver $2)
	sed -i -e "s/\(English CVS version: \).*\( -->\)/\1$ver\2/" $1
}
setversion() {
	local version=$(getversion $2)
	sed -i -e "s/\(<version>\).*\(<\/version>\)/\1$version\2/" $1
}
setdate() {
	sed -i -e "s/\(<date>\).*\(<\/date>\)/\1$(date +%Y-%m-%d)\2/" $1
}

file_path=$(pwd | sed -e "s/\(.*\)\(htdocs.*\)/\2/")

filelist=$(git status | grep modified | sed -e 's/.*modified:[ ]\+\([^ ]\+\)/\1/')
for i in $filelist
do
	echo "setting $i"
	fullpath=$en_root_path$file_path/$i
	en_fullpath=${fullpath/zh_cn/en}
	setver $i $en_fullpath
	setversion $i $en_fullpath
	setdate $i
done
