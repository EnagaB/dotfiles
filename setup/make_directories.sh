#!/bin/bash
set -u

echo "Make directories."

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"
. "${setup_dir}/config.sh"

resrc_sub_directories=(bin etc include lib share src tmp)

function _make_directory() {
    make_dir="$1"
    if [ -d "$make_dir" ]; then
        echo "${make_dir}: already exists."
        return 0
    fi
    mkdir -pv "$make_dir"
}

for resrc_dir in "${make_resrc_directories[@]}"; do
    for sub_dir in "${resrc_sub_directories[@]}"; do
        make_dir="${resrc_dir}/${sub_dir}"
        _make_directory "$make_dir"
    done
done

for make_dir in "${make_directories[@]}"; do
    _make_directory "$make_dir"
done
