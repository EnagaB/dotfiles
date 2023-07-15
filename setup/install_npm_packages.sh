#!/bin/bash
set -u

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")"; pwd)"
. "${setup_dir}/config.sh"

npm config set prefix "$npm_dir"

npm install -g npm
npm install -g "${install_npm_packages[@]}"
