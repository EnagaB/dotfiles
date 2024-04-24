#!/bin/bash

function unset_wsl_functions() {
    unset -f is_wsl
    unset -f has_wslg
    unset -f unset_wsl_functions
}

function is_wsl() {
    if [ ! -z "${WSLENV:-}" ]; then
        return 0
    fi
    return 1
}

function has_wslg() {
    if [ -d '/mnt/wslg' ]; then
        return 0
    fi
    return 2
}
