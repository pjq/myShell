#!/bin/sh
# we have less than 3 arguments. Print the help text:
if [ $# -lt 3 ] ; then
cat < ren -- renames a number of files using sed regular expressions

USAGE: ren 'regexp' 'replacement' files...

EXAMPLE: rename all *.HTM files in *.html:
　ren 'HTM$' 'html' *.HTM

HELP
　exit 0
fi 
