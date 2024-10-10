#!/bin/bash

[ ! -v _NPM_AVAILABLE_RV ] && _NPM_AVAILABLE_RV=-1 # return value of is_npm_available
_NPM_PREFIX_DIR="${HOME}/.npm-global"
_NPM_UPGRADED=false

function is_npm_available() {
    if [ "$_NPM_AVAILABLE_RV" -eq -1 ]; then
        _NPM_AVAILABLE_RV=1
        if npm version &> /dev/null; then
            _NPM_AVAILABLE_RV=0
        fi
    fi
    return "$_NPM_AVAILABLE_RV"
}

function install_npm_global_packages() {
    _set_npm_prefix
    if ! "$_NPM_UPGRADED"; then
        npm install -g npm
        _NPM_UPGRADED=true
    fi
    npm install -g "$@"
}

function _set_npm_prefix() {
    local pre=$(npm config get prefix)
    if [ "$pre" != "undefined" ]; then
        return 0
    fi
    if [ ! -d "$_NPM_PREFIX_DIR" ]; then
        mkdir -p "$_NPM_PREFIX_DIR"
    fi
    npm config set prefix "$_NPM_PREFIX_DIR"
}
