#!/bin/bash

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
libsh_dir="${root_dir}/lib/sh"
. "${libsh_dir}/apt_utils.sh"

_npm_upgraded=false
_npm_prefix_dir="${HOME}/.npm-global"

function _install_npm() {
    if is_apt_package_installed npm; then
        install_apt_packages npm
    fi
}

function _set_npm_prefix() {
    local pre=$(npm config get prefix)
    if [ "$pre" != "undefined" ]; then
        return 0
    fi
    if [ ! -d "$_npm_prefix_dir" ]; then
        mkdir -p "$_npm_prefix_dir"
    fi
    npm config set prefix "$_npm_prefix_dir"
}

function install_npm_global_packages() {
    _install_npm
    _set_npm_prefix
    if ! "$_npm_upgraded"; then
        npm install -g npm
        _npm_upgraded=true
    fi
    npm install -g "$@"
}
