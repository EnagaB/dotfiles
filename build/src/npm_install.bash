#!/usr/bin/env bash
set -u

npm config set prefix "$npm_default_dir"

npm install -g npm
for pk in ${npm_packs[@]}; do
  npm install -g "$pk"
done

# EOF
