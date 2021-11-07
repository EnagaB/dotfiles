#!/usr/bin/env bash
set -eu

# parameters
declare -r maxcdt=10
declare -r td="$TRASHBOX"
declare -r esc="$(builtin printf '\033')"
declare -r reset="${esc}[m"
declare -r col_imp="${esc}[32m"
declare -r col_dng="${esc}[31m"

### clean
echo ${col_imp}"clean trash box: $td"${reset}
# show files/dirs
tdfd=( $(find ${td} -maxdepth 1 -mindepth 1) )
echo "clean files/dirs: "
for fd in ${tdfd[@]}; do
  base_fd=$(basename "$fd")
  [[ "$base_fd" = '.'  ]] && continue
  [[ "$base_fd" = '..' ]] && continue
  echo -n "$(basename "${fd}") "
done
echo ''
# countdown
for cdt in $(seq ${maxcdt} -1 1) ; do
  [[   "$cdt" -eq "${maxcdt}" ]] && echo -n ${col_imp}"countdown ${cdt} "
  [[ ! "$cdt" -eq "${maxcdt}" ]] && echo -n "${cdt} "
  sleep 1
done
echo ''${reset}
# clean
rm -rf $td
mkdir -p $td

# EOF
