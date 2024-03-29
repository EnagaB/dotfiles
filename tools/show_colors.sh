#!/usr/bin/env bash
set -eu
# check color, use ANSI escape code
# check: $ tput setaf 2 | xxd   -output->  .[32m

# output type, 1:output
declare -r tnormal=1
declare -r     tbg=1
declare -r   tbold=0
declare -r tboldbg=0

declare wd
declare ec
declare at
declare -r ecoff="\e[m"
function setwdlen(){
  local -r deflen=9
  local -r str="$1"
  local rtnstr="$str"
  local -r len="${#str}"
  local -r ddlen=$(($deflen-$len))
  local ii
  if [ "$ddlen" -ge 1 ];then
    for ii in $(seq 1 "${ddlen}") ; do
      rtnstr="_${rtnstr}"
    done
  fi
  echo "$rtnstr"
  return 0
}
function echobar(){
  local -r len=97
  local ii
  echo -n ' '
  for ii in $(seq 1 ${len}) ; do
    echo -n '-'
  done
  echo ''
}

echo ' [color]'
echo ' ANSI escape code'
echo ' 01: bold'
echo ' text/background color'
echo ' 30/40:black   90/100:light black'
echo ' 31/41:red     91/101:light red'
echo ' 32/42:green   92/102:light green'
echo ' 33/43:yellow  93/103:light yellow'
echo ' 34/44:blue    94/104:light blue'
echo ' 35/45:magenta 95/105:light magenta'
echo ' 36/46:cyan    96/106:light cyan'
echo ' 37/47:white   97/107:light white'
echo ' [show type]'
[[ "$tnormal" -eq 1 ]] && echo ' text color'
[[ "$tbg"     -eq 1 ]] && echo ' background color + text color'
[[ "$tbold"   -eq 1 ]] && echo ' bold + text color'
[[ "$tboldbg" -eq 1 ]] && echo ' bold + background color + text color'
echobar

# normal
if [ "$tnormal" -eq 1 ];then
  at=00
  for ia in $(seq 30 37) $(seq 90 97) ; do
    [[ "$ia" -eq 30 ]] && echo -n ' | '
    ec="\e[${at};${ia}m"
    wd=$(setwdlen "${at};${ia}")
    echo -en "${ec}${wd}${ecoff}"
    echo -n ' | '
    [[ "$ia" -eq 37 ]] && echo '' && echo -n ' | '
    [[ "$ia" -eq 97 ]] && echo ''
  done
fi

# bg
if [ "$tbg" -eq 1 ];then
  at=00
  for ib in $(seq 40 47) $(seq 100 107) ; do
    for ia in $(seq 30 37) $(seq 90 97) ; do
      [[ "$ia" -eq 30 ]] && echo -n ' | '
      ec="\e[${at};${ia};${ib}m"
      wd=$(setwdlen "${at};${ia};${ib}")
      echo -en "${ec}${wd}${ecoff}"
      echo -n ' | '
      [[ "$ia" -eq 37 ]] && echo '' && echo -n ' | '
      [[ "$ia" -eq 97 ]] && echo ''
    done
  done
fi

# bold
if [ "$tbold" -eq 1 ];then
  at=01
  for ia in $(seq 30 37) $(seq 90 97) ; do
    [[ "$ia" -eq 30 ]] && echo -n ' | '
    ec="\e[${at};${ia}m"
    wd=$(setwdlen "${at};${ia}")
    echo -en "${ec}${wd}${ecoff}"
    echo -n ' | '
    [[ "$ia" -eq 37 ]] && echo '' && echo -n ' | '
    [[ "$ia" -eq 97 ]] && echo ''
  done
fi

# bold + bg
if [ "$tboldbg" -eq 1 ];then
  at=01
  for ib in $(seq 40 47) $(seq 100 107) ; do
    for ia in $(seq 30 37) $(seq 90 97) ; do
      [[ "$ia" -eq 30 ]] && echo -n ' | '
      ec="\e[${at};${ia};${ib}m"
      wd=$(setwdlen "${at};${ia};${ib}")
      echo -en "${ec}${wd}${ecoff}"
      echo -n ' | '
      [[ "$ia" -eq 37 ]] && echo '' && echo -n ' | '
      [[ "$ia" -eq 97 ]] && echo ''
    done
  done
fi

echobar
