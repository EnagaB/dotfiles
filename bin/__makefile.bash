#!/usr/bin/env bash
set -u
# make file: create new file or cp template
tpldir=${HOME}/.template

echo 'err: now creating'
exit 1

for ff in "$@"; do
  if [[ -e "$ff" ]];then
    echo "err: ${ff} exists."
  else
    case $ff in
      *.svg) ;;
        *)
    esac
  fi
done

# end
