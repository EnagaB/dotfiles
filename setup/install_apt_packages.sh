#!/bin/bash
set -u

echo "Install apt packages"

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")"; pwd)"
. "${setup_dir}/config.sh"

function install_packages() {
    sudo apt -o Acquire::Retries=10 update \
        && sudo apt -o Acquire::Retries=10 upgrade -y \
        && DEBIAN_FRONTEND=noninteractive sudo apt -o Acquire::Retries=10 install -y \
        "$@"
}

install_packages "${install_apt_repository_packages[@]}"
for repo in "${add_apt_repositories[@]}"; do
    sudo add-apt-repository -y "$repo"
done
install_packages "${install_apt_packages[@]}"
