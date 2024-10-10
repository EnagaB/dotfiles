#!/bin/bash

[ ! -v _SNAP_AVAILABLE_RV ] && _SNAP_AVAILABLE_RV=-1 # return value of is_snap_available

function is_snap_available() {
    if [ "$_SNAP_AVAILABLE_RV" -eq -1 ]; then
        _SNAP_AVAILABLE_RV=1
        if snap version &> /dev/null; then
            _SNAP_AVAILABLE_RV=0
        fi
    fi
    return "$_SNAP_AVAILABLE_RV"
}

function install_snap_packages_classic() {
    sudo snap install "$@" --classic
}
