#!/bin/bash

function is_snap_available() {
    if snap version &> /dev/null; then
        return 0
    fi
    return 1
}

function install_snap_packages_classic() {
    sudo snap install "$@" --classic
}
