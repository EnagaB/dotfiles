#!/usr/bin/env bash
set -u

### parameters
# path
declare -r loc=${LOCAL:-${HOME}/.local}
declare -r tbox=${TRASHBOX:-${HOME}/.t}
declare -r dfetc=${df}/etc
declare -r dfsh=${dfetc}/shell
declare -r appconfig=${HOME}/.config
# src
declare -r sh_mkdir_init=${src}/mkdir_init.bash
declare -r sh_link=${src}/link.bash
declare -r sh_apt_install=${src}/apt_install.bash
declare -r sh_curl_install=${src}/curl_install.bash
declare -r sh_git_install=${src}/git_install.bash
declare -r sh_cpp_build=${src}/cpp_build.bash

### make init dir
declare -ar make_initdir=(
  ### local
  ${loc}/bin
  ${loc}/etc
  ${loc}/lib
  ${loc}/share
  ${loc}/src
  ${loc}/include
  ### trashbox
  ${tbox}
  ### ~/.config
  ${appconfig}/nvim
  ${appconfig}/zathura
  ### other
  ${HOME}/.fonts
  ${HOME}/.w3m
)

### apt
# repository
declare -ar apt_repo_packs=(
  software-properties-common
  ppa-purge
)
declare -ar apt_ppa_repos=(
  ppa:jonathonf/vim     # later vim
  ppa:neovim-ppa/stable # later neovim
  # ppa:mozillateam/ppa   # firefox-esr
  # ppa:japaneseteam/ppa  # Ubuntu Japanese Team
  # ppa:kelleyk/emacs     # later emacs (err?: ubuntu18.04)
  # ppa:webupd8team/atom  # atom (err?: ubuntu18.04)
)
# packages
declare -ar apt_packs=(
  ##### base
  ### shell
  bash
  zsh
  ### packages
  curl
  git
  ### measures
  busybox

  ##### std
  ### japanese
  language-pack-ja
  manpages-ja
  manpages-ja-dev
  ### insert jp
  fcitx
  fcitx-mozc
  ### font
  fontconfig
  fonts-ipafont
  fonts-ipaexfont
  fonts-noto
  ### x11
  x11-apps
  x11-utils
  x11-xserver-utils
  dbus-x11
  xauth
  ### terminal
  tmux
  ### editor
  emacs
  vim
  vim-gnome
  neovim

  ##### image
  eog
  evince
  feh
  okular
  zathura
  inkscape
  gimp
  # mupdf
  # mupdf-tools
  ### library
  imagemagick
  pstoedit
  python-lxml
  epstool
  poppler-utils

  ##### development/programming
  ### compiler
  build-essential
  gfortran
  gcc
  g++
  ### library
  liblapack-dev
  libblas-dev
  # libopencv-dev
  ### shell
  shellcheck
  ### C/C++
  ### python (latest)
  python3.9
  python3.9-distutils
  tk-dev
  python3-tk
  ### Go
  # golang
  ### Rust
  # rustc
  ### JavaScript
  # nodejs
  # npm
  ### graph
  gnuplot-x11
  ### tex
  texlive-latex-base
  texlive-latex-extra
  texlive-latex-recommended
  texlive-publishers
  texlive-extra-utils
  texlive-lang-japanese
  texlive-lang-cjk
  xdvik-ja
  texlive-plain-generic
  texlive-fonts-recommended
  texlive-fonts-extra
  texlive-luatex
  latexmk

  ##### other
  ### web browser
  w3m
  # firefox-esr
  # firefox
  # google-chrome
  ### other
  file
  jq
  peco
  fzy
  nkf
  bc
  xsel
  xclip
)

### other packages
declare -r curl_latest_neovim=false
declare -r git_fzf=true
declare -r git_enhancd=true
# fonts
declare -ar fonts_url=(
  'https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
  'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
)

### link
declare -ar link_tohome=(
  ${df}/.*
  ${dfetc}/tmux/.*
  ${dfetc}/tex/.*
  ${dfetc}/gnuplot/.*
  # shell
  ${dfsh}/.inputrc
  ${dfsh}/.bashrc
  ${dfsh}/.bash_profile
  ${dfsh}/.sudo_as_admin_successful
  ${dfsh}/.zshenv
  ${dfsh}/.dir_colors
)
declare -ar link_toany=(
  ${dfetc}/template          ${HOME}/.template
  ${dfetc}/zathurarc         ${appconfig}/zathura/zathurarc
  # w3m (not link directory, for cookie, history, ...)
  ${dfetc}/w3m/bookmark.html ${HOME}/.w3m/bookmark.html
  ${dfetc}/w3m/keymap        ${HOME}/.w3m/keymap
  # editor
  ${dfetc}/emacs      ${HOME}/.emacs.d
  ${dfetc}/vim        ${HOME}/.vim
  ${HOME}/.vim/vimrc  ${HOME}/.vimrc
  ${HOME}/.vim/gvimrc ${HOME}/.gvimrc
  ${HOME}/.vim/vimrc  ${appconfig}/nvim/init.vim
)

# EOF
