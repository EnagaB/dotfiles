#!/usr/bin/env bash
# source in (bash|zsh)rc

declare -r __symlinks_dir="${HOME}/.symlinks"

function __make_symbolic_link_jump() {
    usage="> command link_name"
    if [ ! -d "$__symlinks_dir" ]; then
        mkdir -p "$__symlinks_dir"
    fi
    n_args="$#"
    if [ "$n_args" -ne 1 ]; then
        echo "ERROR: Invalid arguments"
        echo "$usage"
        return 1
    fi
    link_name="$1"
    ln -snfv "$(pwd)" "${__symlinks_dir}/${link_name}"
}

function __cd_symbolic_link_jump() {
    usage="> command link_name"
    n_args="$#"
    if [ "$n_args" -ne 1 ]; then
        echo "ERROR: Invalid arguments"
        echo "$usage"
        return 1
    fi
    link_name="$1"
    link_path="${__symlinks_dir}/${link_name}"
    if [ ! -L "$link_path" ]; then
        echo "ERROR: Given link doesn't exist."
        return 1
    fi
    cd -P "$link_path"
}
