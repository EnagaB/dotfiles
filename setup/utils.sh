#!/bin/bash

function make_root_directory() {
    local sub_dirnames=(bin etc include lib share src tmp)
    local root_dir sub_dirname make_dir
    for root_dir in "$@"; do
        for sub_dirname in "${sub_dirnames[@]}"; do
            make_dir="${root_dir}/${sub_dirname}"
            mkdir -p "$make_dir"
        done
    done
}
