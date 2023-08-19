function get_os_name() {
    if [[ $(uname -s) =~ ^CYGWIN ]]; then
        echo "cygwin"
        return 0
    fi
    local os_release=/etc/os-release
    if [ -f "$os_release" ]; then
        if grep "Ubuntu" "$os_release" &> /dev/null; then
            echo "ubuntu"
        else
            return 1
        fi
        return 0
    fi
    return 1
}

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
