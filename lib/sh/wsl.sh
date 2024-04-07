#!/bin/bash

function is_wsl() {
    if [ ! -z "${WSLENV:-}" ]; then
        return 0
    fi
    return 1
}
