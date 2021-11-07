#!/usr/bin/env bash
# create init directories
set -u

echo "[make init directories]"

for dir in "${make_initdir[@]}"; do
  echo -n "${dir}: "
  if [[ ! -d "$dir" ]] ; then
    echo "create the directory"
    mkdir -p "$dir"
  else
    echo "already created"
  fi
done

# EOF
