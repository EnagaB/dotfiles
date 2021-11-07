#!/bin/bash
set -u
# usage : $ fin -f2 "*txt"
#       : $ fin "*txt"
#       : $ fin test.txt
# options (default: -f)
#  -f: search file      name in CWD
#  -F: search file      name in CWD and its subdirectories
#  -d: search directory name in CWD
#  -D: search directory name in CWD and its subdirectories
#  -i: search word in files  in CWD
#  -I: search word in files  in CWD and its subdirectories

# parameters
declare -r default_opt='f'

# functions
function egetopts() {
  local -a oaa=()
  local oa tmp oparg ii
  # local oaatmp
  if [ "$1" -eq 1 ];then
    # options
    shift 1
    for oa in "$@" ; do
      if [[ "$oa" =~ ^-[[:alnum:]] ]] ; then
        # short option
        tmp="${oa#-}"
        opha=''
        [[ "$tmp" =~ = ]] && opha="${tmp#${tmp%%?=*}}" # optional-arg
        [[ ! -z "$opha" ]] && tmp=${tmp%${opha}}
        for ii in $(fold -w 1 <<< "$tmp") ; do
          [[ ! "$ii" =~ [[:alnum:]] ]] && continue
          oaa+=( "$ii" )
        done
        [[ ! -z "$opha" ]] && [[ "${opha%%=*}" =~ [[:alnum:]] ]] && oaa+=( "$opha" )
      elif [[ "$oa" =~ ^--[[:alnum:][:punct:]] ]] ; then
        # long option
        oaa+=( "${oa#--}" )
      fi
    done
  elif [ "$1" -eq 2 ];then
    # non-option args
    shift 1
    for oa in "$@" ; do
      if [[ ! "$oa" =~ ^-[[:alnum:]] ]] && [[ ! "$oa" =~ ^--[[:alnum:][:punct:]] ]] ; then
        oaa+=( "${oa}" )
      fi
    done
  fi
  echo "${oaa[@]}"
}

# ignore wildcard expansion
GLOBIGNORE=*

# get args
declare -ar opts=( $(egetopts 1 "$@") )
declare -ar args=( $(egetopts 2 "$@") )

# err
[[   "${#opts[@]}" -ge 2 ]] && echo " [err] too many opts" && exit 1
[[ ! "${#args[@]}" -eq 1 ]] && echo " [err] num of non-opt-arg is not 1" && exit 1

# arg and opt (for bash/zsh supported)
declare -r arg="${args[@]}"
[[ "${#opts[@]}" -eq 0 ]] && declare op="${default_opt}"
[[ "${#opts[@]}" -eq 1 ]] && declare op="${opts[@]}"

# exe
[[ "${op}" = 'f' ]] && find . -maxdepth 1 -name "${arg}" -type f
[[ "${op}" = 'F' ]] && find . -name "${arg}" -type f
[[ "${op}" = 'd' ]] && find . -maxdepth 1 -name "${arg}" -type d
[[ "${op}" = 'D' ]] && find . -name "${arg}" -type d
[[ "${op}" = 'i' ]] && find . -maxdepth 1 -type f -print0 | xargs -0 grep "$arg"
[[ "${op}" = 'I' ]] && find . -type f -print0 | xargs -0 grep "$arg"

# ignore wildcard expansion
unset GLOBIGNORE

exit 0
# end
