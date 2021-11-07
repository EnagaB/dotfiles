#!/usr/bin/env bash
set -u
# $ mv <item> $TRASHBOX
# or $ mv <item> ${TRASHBOX}/<item>.1 # 1 -> 2 -> 3 ...
# TRASHBOX is defined in advance.

# parameters
declare -r td="$TRASHBOX"

### err handling
# arg num
if [[ $# -eq 0 ]];then
  echo 'err: num of args is 0.'
  return 1
fi
# td
if [[ -z "${td:+a}" ]];then
  echo 'err: TRASHBOX is not defined.'
  return 1
fi

### make trashbox
if [[ ! -d "$td" ]];then
  mkdir -p "$td"
fi

### mv to trashbox
for ff in "$@" ; do
  # trash filename
  ff_file=$(basename "$ff")
  tff=${td}/${ff_file}
  if [[ -e "$tff" ]];then
    vn=1
    while :; do
      tff=${td}/${ff_file}.${vn}
      if [[ ! -e "$tff" ]];then
        break
      fi
      vn=$(($vn+1))
    done
  fi
  # mv to trashbox
  mv "$ff" "$tff"
done

# end
