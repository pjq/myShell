#!/bin/bash

# Happy Hack Week  :)
# A mini screensaver on console
# Written by John Shi - jshi@novell.com

init()
{
  echo -ne "[?25l"  # hide cursor
  echo -ne "[40m"   # black background
  echo -ne "[2J"    # clear screen
}

quit()
{
  ps axww | grep "$(basename "$0")" | awk '{print $1}' | xargs kill
  echo -ne "[0m"    # restore the setting of terminal
  echo -ne "[2J"    # clear screen
  echo -ne "[?25h"  # show cursor
  echo -ne "[1;1f"  # move cursor to position 1,1
  exit 0
}

flash()
{
  local row col char

  row=$1
  col=$2
  char=$3

  echo -ne "[37m[${row};${col}H${char}"   # white font
  sleep 0.07
  echo -ne "[32m[${row};${col}H${char}"   # green font
}

drip()
{
  local col top speed row i

  col=$1
  top=$2
  speed=$3

  for ((row=1,i=top; row<=rows; i++,row++)); do
    if ((top == -1)); then
      flash $row $col " "
    else
      flash $row $col ${chars[i%len]}
    fi
    sleep $speed
  done
}

main()
{
  local col speed

  trap "quit" INT
  trap ":" TERM

  init

  # get the size of terminal
  cols=$(tput cols)
  rows=$(tput lines)

  while :; do
    speed=$((RANDOM % 3))
    col=$((RANDOM % cols + 1))
    test -z "${pos[col]}" && pos[col]=$((RANDOM % len))
    if ((RANDOM % 4 == 0)); then
      drip $col ${pos[col]} 0.$speed &
    else
      drip $col -1 0.$speed &
    fi
    sleep 0.$speed
  done
}

declare -i cols
declare -i rows
declare -a chars=(2 V 3 \/ t 7 \] 0 - \= q w 6 e r \@ y u i 4 o p \[ a S s 5 d J f g h \! j k l \; \' z 9 x \} c W v b m \, \. \~ \# \$ X \% N \^ \( \+ Q E R n T \> Y _ U I \& O P \{ \| A D F \) G H 8 K L \: Z C \< 1 B M \?)
declare -i len=${#chars[@]}
declare -a pos

main
