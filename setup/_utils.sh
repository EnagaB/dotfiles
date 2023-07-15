#!/bin/bash
set -u

function echo_error() {
    echo -en "\e[31m"
    echo -n "$@"
    echo -e "\e[m"
}

function get_os_name() {
    if [[ $(uname -s) =~ ^CYGWIN ]]; then
        echo "cygwin"
        return 0
    fi
    os_release=/etc/os-release
    if [ -f "$os_release" ]; then
        if grep "Ubuntu" "$os_release" &> /dev/null; then
            echo "ubuntu"
        else
            echo
            return 1
        fi
        return 0
    fi
    echo
    return 1
}

function build_cmake() {
    local -r src_dir="$1"
    local -r dst_out="$2"
    local -r build_dir="${src_dir}/build"
    local -r dst_filename=$(basename "$dst_out")
    [[ -f "$dst_out" ]] && rm "$dst_out"
    [[ -d "$build_dir" ]] && rm -r "$build_dir"
    pushd "$src_dir"
    mkdir build \
        && cd build \
        && cmake .. \
        && make \
        && ln -snfv "${build_dir}/${dst_filename}" "$dst_out"
    popd
}
