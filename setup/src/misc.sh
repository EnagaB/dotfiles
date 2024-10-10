#!/bin/bash

function make_root_directory() {
    local sub_dirnames=(bin etc include lib share src tmp)
    local root_dir sub_dirname make_dir
    for root_dir in "$@"; do
        for sub_dirname in "${sub_dirnames[@]}"; do
            make_dir="${root_dir}/${sub_dirname}"
            if [ ! -d "$make_dir" ]; then
                echo "make $make_dir"
                mkdir -p "$make_dir"
            fi
        done
    done
}

function install_eza() {
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
}
