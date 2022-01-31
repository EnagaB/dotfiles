#!/usr/bin/env bash
set -u

npm install -g npm
for pk in ${npm_packs[@]}; do
  npm install -g "$pk"
done

# EOF
