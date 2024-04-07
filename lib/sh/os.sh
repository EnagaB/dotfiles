#!/bin/bash

function get_os() {
    if [[ $(uname -s) =~ ^CYGWIN ]]; then
        echo "cygwin"
        return 0
    fi
    local os_release=/etc/os-release
    if [ -f "$os_release" ]; then
        if grep "Ubuntu" "$os_release" &> /dev/null; then
            echo "ubuntu"
        else
            return 1
        fi
        return 0
    fi
    return 1
}

function is_ubuntu() {
    os_name="$(get_os)"
    [ "$os_name" = 'ubuntu' ] && return 0
    return 1
}
