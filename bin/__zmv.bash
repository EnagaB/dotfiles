#!/usr/bin/env bash
set -u
# $ zmv *.txt *.dat
# mv a.txt,b.txt to a.dat,b.dat

# init
GLOBIGNORE=*
declare -r wc=* # wildcard

# error
# argument num
if [ ! $# -eq 2 ];then
  echo " [err] arg-num is not 2"
  unset GLOBIGNORE
  exit 1
fi
# arg1/arg2 = wildcard
if [ "$1" = "$wc" ] || [ "$2" = "$wc" ];then
  echo " [err] arg1/2=*"
  unset GLOBIGNORE
  exit 1
fi
# double wilecard
declare a1wcdn=$(echo "$1" | sed -E "s/\\$wc\\$wc/\\$wc\\$wc\n/g" | grep -c -E "\\$wc\\$wc")
declare a2wcdn=$(echo "$2" | sed -E "s/\\$wc\\$wc/\\$wc\\$wc\n/g" | grep -c -E "\\$wc\\$wc")
if [ ! "$a1wcdn" -eq 0 ] || [ ! "$a2wcdn" -eq 0 ];then
  echo " [err] consecutive wildcards exist"
  unset GLOBIGNORE
  exit 1
fi
# wildcard num
declare a1wcn=$(echo "$1" | sed -E "s/\\$wc/\\$wc\n/g" | grep -c -E "\\$wc")
declare a2wcn=$(echo "$2" | sed -E "s/\\$wc/\\$wc\n/g" | grep -c -E "\\$wc")
if [ ! "$a1wcn" -eq "$a2wcn" ];then
  echo " [err] the num of arg1's wildcard-num and arg2 is not equal"
  unset GLOBIGNORE
  exit 1
fi
# arg1's word and arg2's word before first wildcard / after last wildcard
declare -a a1awc=( $(echo "$1" | sed -E "s/\\$wc/ \\$wc /g") )
declare -a a2awc=( $(echo "$2" | sed -E "s/\\$wc/ \\$wc /g") )
declare logi=false
declare ws=$((${#a1awc[@]}-1))
if   [   "${a1awc[0]}"   = "$wc" ] && [ ! "${a2awc[0]}"   = "$wc" ];then logi=true
elif [ ! "${a1awc[0]}"   = "$wc" ] && [   "${a2awc[0]}"   = "$wc" ];then logi=true
elif [   "${a1awc[$ws]}" = "$wc" ] && [ ! "${a2awc[$ws]}" = "$wc" ];then logi=true
elif [ ! "${a1awc[$ws]}" = "$wc" ] && [   "${a2awc[$ws]}" = "$wc" ];then logi=true
fi
if $logi ;then
  echo " [err]"
  echo " arg1' word before first wildcard / after last wildcard and arg2"
  echo " either one exists or does not exist"
  unset GLOBIGNORE
  exit 1
fi

# exe
declare -r wcn="$a1wcn"
declare -r nwcn=$(($wcn+1))
declare -r befnm="$1"
declare -r aftnm="$2"
# mv
if [ $wcn -eq 0 ];then
  mv "$1" "$2"
  unset GLOBIGNORE
  exit 0
else
  declare -a mva1
  declare -a mva2
  declare an=0
  declare -a befstra
  declare -a aftstra
  for ii in $(seq 1 $nwcn) ; do
    befstra[$ii]=$(cut -d $wc -f $ii <<< $befnm)
    aftstra[$ii]=$(cut -d $wc -f $ii <<< $aftnm)
  done
  declare -r befstra
  declare -r aftstra
  unset GLOBIGNORE
  declare -a matchstra=( $befnm )
  # match files = 0 -> not expand wildcard
  declare -r mtch=$(echo "${matchstra[0]}" | sed -E "s/\\$wc/\\$wc\n/g" | grep -c -E "\\$wc")
  if [ ! "$mtch" -eq 0 ];then
    echo " [err] matching files/dirs and arg1 do not exist"
    unset GLOBIGNORE
    exit 1
  fi
  for fstr in "${matchstra[@]}" ; do
    anm=''
    bnm=''
    rmfs=''
    for ii in $(seq 1 $wcn) ; do
      befstr1=${befstra[$ii]}
      befstr2=${befstra[$(($ii+1))]}
      aftstr1=${aftstra[$ii]}
      aftstr2=${aftstra[$(($ii+1))]}
      if [ "$ii" -eq 1 ];then
        bnm=${befstr1}
        anm=${aftstr1}
      fi
      rmfs=${fstr#${bnm}}
      if [ ! -z ${befstr2} ];then
        rmfs=${rmfs%%${befstr2}*}
        bnm=${bnm}${rmfs}${befstr2}
        anm=${anm}${rmfs}${aftstr2}
      else
        anm=${anm}${rmfs}
      fi
    done
    mva1[$an]="${fstr}"
    mva2[$an]="${anm}"
    echo " mv [${mva1[$an]}] to [${mva2[$an]}]"
    an=$(($an+1))
  done
fi

echo -n ' ok? [y/N]: '
read ans
case $ans in
  y|Y) 
    for ii in $(seq 0 $(($an-1))) ; do
      mv "${mva1[$ii]}" "${mva2[$ii]}"
    done
    echo ' complete'
    ;;
  *)
    echo ' interrupted'
    unset GLOBIGNORE
    exit 1
    ;;
esac

# last
unset GLOBIGNORE
exit 0

# end
