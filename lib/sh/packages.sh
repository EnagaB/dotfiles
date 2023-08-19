function install_apt_packages() {
    sudo apt -o Acquire::Retries=10 update
    sudo apt -o Acquire::Retries=10 upgrade -y
    DEBIAN_FRONTEND=noninteractive sudo apt -o Acquire::Retries=10 install -y "$@"
}

function add_apt_repositories() {
    local repo
    for repo in "$@"; do
        sudo add-apt-repository -y "$repo"
    done
}

function install_npm_global_packages() {
    npm install -g npm
    npm install -g "$@"
}

function install_fonts_from_urls() {
    local fonts_dir="${HOME}/.fonts"
    [ ! -d "$fonts_dir" ] && mkdir -p "$fonts_dir"
    cd "$fonts_dir"
    local font_url
    for font_url in "$@"; do
        echo "install font: ${font_url}"
        font_filename="$(basename "${install_font}")"
        curl -L "$install_font" -o "$font_filename"
        if [ "${font_filename##*.}" = "zip" ]; then
            unzip -o "$font_filename"
        fi
        rm "$font_filename"
    done
    fc-cache -fv "$fonts_dir"
}
