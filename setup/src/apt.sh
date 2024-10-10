#!/bin/bash

[ ! -v _APT_UPGRADED ] && _APT_UPGRADED=false

function install_apt_packages() {
    _add_apt_retry_option
    _apt_upgrade
    DEBIAN_FRONTEND=noninteractive sudo apt install -y "$@"
}

function add_apt_repositories() {
    local repo
    for repo in "$@"; do
        sudo add-apt-repository -y "$repo"
    done
    _APT_UPGRADED=false
    _apt_upgrade
}

function _add_apt_retry_option() {
    local retry_opt='APT::Acquire::Retries'
    local retry_opt_file='/etc/apt/apt.conf.d/80-retries'
    if [ -f "$retry_opt_file" ] \
        && [ ! -z "$(cat "$retry_opt_file" | grep "$retry_opt")" ]; then
        return 0
    fi
    sudo sh -c "echo '${retry_opt} \"10\";' >> ${retry_opt_file}"
}

function _apt_upgrade() {
    if ! "$_APT_UPGRADED"; then
        sudo apt update && sudo apt upgrade -y
        _APT_UPGRADED=true
    fi
}
