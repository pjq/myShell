#!/bin/bash
echo "What is your favourite OS?"
select var in "Linux" "Gnu Hurd" "Free BSD" "Other"; do
#echo "You have selected $var"
break
done
echo "You have selected $var"

