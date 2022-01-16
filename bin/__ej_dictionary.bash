#!/usr/bin/env bash
set -u

# parameters
declare -ar ejdicts=(
  "${LOCAL}/lib/ejdic-eijiro1448-utf8unix.dat.gz"
  "${DOTFILES}/lib/ejdic-hand-utf8unix.dat.gz"
)
declare -r stype="$1"
shift 1
declare -r sword="$@"

# dictionary
ii=0
for di in ${ejdicts[@]}; do
  [[ -f "$di" ]] && ii=1
  [[ "$ii" -eq 1 ]] && break
done
if [[ "$ii" -eq 0 ]];then
  echo 'err: dictionary file does not exist'
  exit 1
fi

# search
declare -r dfile="$di"
if [[ "$stype" = 'chars' ]];then
  zgrep "$sword" "$dfile" -E -i --color=always | less -R -FX
elif [[ "$stype" = 'word' ]];then
  zgrep "$sword" "$dfile" -E -iw --color=always | less -R -FX
fi

# end
