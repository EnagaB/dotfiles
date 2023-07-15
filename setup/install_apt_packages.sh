#!/bin/bash
set -u

echo "Install apt packages"

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"
. "${setup_dir}/config.sh"
. "${setup_dir}/utils.sh"

install_apt_packages "${install_apt_repository_packages[@]}"
for repo in "${add_apt_repositories[@]}"; do
    sudo add-apt-repository -y "$repo"
done
install_apt_packages "${install_apt_packages[@]}"
