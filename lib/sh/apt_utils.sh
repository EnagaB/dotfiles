#!/bin/bash

[ ! -v _apt_upgraded ] && _apt_upgraded=false
[ ! -v _apt_repo_packs_installed ] && _apt_repo_packs_installed=false

_apt_repo_packs=(
    software-properties-common
    ppa-purge
)

function add_apt_repositories() {
    _add_apt_repo_packages
    local repo
    for repo in "$@"; do
        sudo add-apt-repository -y "$repo"
    done
    _apt_upgraded=false
}

function install_apt_packages() {
    _add_apt_retry_option
    _apt_upgrade
    DEBIAN_FRONTEND=noninteractive sudo apt install -y "$@"
}

function is_apt_package_installed() {
    local packname="$1"
    if dpkg-query -W -f='${Status}\n' "$packname" | grep 'installed' &> /dev/null; then
        return 0
    fi
    return 1
}

function _add_apt_repo_packages() {
    if ! "$_apt_repo_packs_installed"; then
        install_apt_packages "${_apt_repo_packs[@]}"
    fi
}

function _add_apt_retry_option() {
    local retry_opt='APT::Acquire::Retries'
    local retry_opt_file='/etc/apt/apt.conf.d/80-retries'
    if [ ! -z "$(cat "$retry_opt_file" | grep "$retry_opt")" ]; then
        return 0
    fi
    sudo sh -c "echo '${retry_opt} \"10\";' >> ${retry_opt_file}"
}

function _apt_upgrade() {
    if ! "$_apt_upgraded"; then
        sudo apt update && sudo apt upgrade -y
        _apt_upgraded=true
    fi
}
