#!/usr/bin/env bash
# bash <this> [--no-admin] [--no-install]
set -u

# paths
declare -r dotfiles_dir=${DOTFILES:-${HOME}/dotfiles}
declare -r local_dir=${LOCAL:-${HOME}/.local}
declare -r trashbox_dir=${TRASHBOX:-${HOME}/.t}
declare -r app_config_dir=${HOME}/.config
declare -r script_dir=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
declare -r utils_bash=${script_dir}/modules/utils.bash
declare -r dotfiles_bin_dir=${dotfiles_dir}/bin
declare -r dotfiles_src_dir=${dotfiles_dir}/src
declare -r dotfiles_etc_dir=${dotfiles_dir}/etc
declare -r dotfiles_shell_dir=${dotfiles_etc_dir}/shell
declare -r npm_default_dir="${HOME}/.npm-global"
declare -r fonts_dir="${HOME}/.fonts"
declare -ar init_directories=("${local_dir}/bin"
                              "${local_dir}/etc"
                              "${local_dir}/lib"
                              "${local_dir}/share"
                              "${local_dir}/src"
                              "${local_dir}/include"
                              "${local_dir}/tmp"
                              "${trashbox_dir}"
                              "${app_config_dir}/zathura"
                              "${HOME}/.w3m"
                              "$npm_default_dir"
                              "$fonts_dir")

# packages
declare -ar apt_repository_tools=(software-properties-common ppa-purge)
declare -ar apt_repositories=(ppa:jonathonf/vim ppa:neovim-ppa/stable)
declare -ar apt_packages=(bash zsh shellcheck
                          curl wget git unzip
                          emacs vim vim-gnome neovim
                          tmux
                          language-pack-ja manpages-ja manpages-ja-dev
                          fcitx fcitx-mozc
                          fontconfig fonts-ipafont fonts-ipaexfont fonts-noto
                          x11-apps x11-utils x11-xserver-utils dbus-x11 xauth
                          feh okular zathura # eog evince
                          build-essential cmake make gfortran gcc g++
                          liblapack-dev libblas-dev
                          python3.9 python3.9-distutils tk-dev python3-tk
                          golang rustc nodejs npm
                          gnuplot-x11 xsel xclip
                          w3m
                          fzf # peco fzy
                          file nkf bc
                          busybox)
declare -ar npm_global_packages=(wsl-open)

# fonts
declare -ar font_urls=(
  'https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
  'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
)

# link
declare -ar link2home=("${dotfiles_etc_dir}/tmux/.tmux.conf"
                       "${dotfiles_etc_dir}/tex/.latexmkrc"
                       "${dotfiles_etc_dir}/gnuplot/.gnuplot"
                       "${dotfiles_etc_dir}/gnuplot/.gnuplot-wxt"
                       "${dotfiles_shell_dir}/.inputrc"
                       "${dotfiles_shell_dir}/.bashrc"
                       "${dotfiles_shell_dir}/.bash_profile"
                       "${dotfiles_shell_dir}/.sudo_as_admin_successful"
                       "${dotfiles_shell_dir}/.zshenv"
                       "${dotfiles_shell_dir}/.dir_colors")
declare -ar link_template=("${dotfiles_etc_dir}/template" "${HOME}/.template")
declare -ar link_zathura=("${dotfiles_etc_dir}/zathurarc" "${app_config_dir}/zathura/zathurarc")
declare -ar link_w3mbookmark=("${dotfiles_etc_dir}/w3m/bookmark.html"
                              "${HOME}/.w3m/bookmark.html")
declare -ar link_w3mkeymap=("${dotfiles_etc_dir}/w3m/keymap" "${HOME}/.w3m/keymap")
declare -ar link_emacs=("${dotfiles_etc_dir}/emacs" "${HOME}/.emacs.d")
declare -ar link_vim=("${dotfiles_etc_dir}/template" "${HOME}/.template")
declare -ar link_neovim=("${dotfiles_etc_dir}/vim" "${app_config_dir}/nvim")

# non su
if [ "$EUID" -eq 0 ];then
  echo "Please run as non-root"
  exit 1
fi

# get option
for opt in "$@"; do
  case "$opt" in
    --no-admin) declare -r use_admin=false ;;
    --no-install) declare -r install_packages=false ;;
    *)
      echo "Error: Option ${opt} is not implemented."
      exit 1
      ;;
  esac
done
[[ ! -v use_admin ]] && declare -r use_admin=true
[[ ! -v install_packages ]] && declare -r install_packages=true

cd "$dotfiles_dir"
. "$utils_bash"

# make init directories
mkdir -pv "${init_directories[@]}"

# install packages
if "$install_packages" && "$use_admin" ; then
  if [[ "$(get_os)" == "ubuntu" ]]; then
    # apt
    install_packages "${apt_repository_tools[@]}"
    for repo in "${apt_repositories[@]}"; do
      add-apt-repository -y "$repo"
    done
    install_packages "${apt_packages[@]}"
    # npm
    npm config set prefix "$npm_default_dir"
    npm install -g npm
    npm install -g "${npm_global_packages[@]}"
  fi
fi

# download fonts
echo "Download fonts"
pushd "$fonts_dir"
for font_url in "${font_urls[@]}"; do
  clone_file=$(basename ${font_url})
  curl -L "$font_url" -o "$clone_file"
  unzip -o "$clone_file"
  rm "$clone_file"
done
rm *.md *.txt
fc-cache -fv "$fonts_dir"
popd

# git config
echo "Add git alias"
git config --global alias.s "status -s"
git config --global alias.d "diff"

# link
echo "Make links"
for link_file in "${link2home[@]}"; do
  link_filename=$(basename "$link_file")
  ln -snfv "$link_file" "${HOME}/${link_filename}"
done
ln -snfv "${link_template[@]}"
ln -snfv "${link_zathura[@]}"
ln -snfv "${link_w3mbookmark[@]}"
ln -snfv "${link_w3mkeymap[@]}"
ln -snfv "${link_emacs[@]}"
ln -snfv "${link_vim[@]}"
ln -snfv "${link_neovim[@]}"
