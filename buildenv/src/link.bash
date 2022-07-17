#!/usr/bin/env bash
set -u

echo "[link]"
declare -r lncmd=("ln" "-snfv")

# link to home
for ff in "${link_tohome[@]}"; do
  ffbase=$(basename "$ff")
  [[ "${ffbase}" = '.'           ]] && continue
  [[ "${ffbase}" = '..'          ]] && continue
  [[ "${ffbase}" = '.git'        ]] && continue
  [[ "${ffbase}" = '.gitconfig'  ]] && continue
  [[ "${ffbase}" = '.gitignore'  ]] && continue
  [[ "${ffbase}" = '.gitkeep'    ]] && continue
  [[ "${ffbase}" = '.gitmodules' ]] && continue
  [[ "${ffbase}" = '.DS_Store'   ]] && continue
  [[ "${ffbase}" = '.travis.yml' ]] && continue
  ${lncmd[@]} "$ff" "${HOME}/${ffbase}"
done

# link to any
for ((ii=0; ii<"${#link_toany[@]}"; ++ii)); do
  [[ $((ii%2)) -eq 1 ]] && continue
  ${lncmd[@]} "${link_toany[$ii]}" "${link_toany[$((ii+1))]}"
done

# EOF
