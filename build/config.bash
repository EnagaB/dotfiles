#!/usr/bin/env bash
set -u

### make init dir
declare -ar make_initdir=(
  # local
  "${loc}/bin"
  "${loc}/etc"
  "${loc}/lib"
  "${loc}/share"
  "${loc}/src"
  "${loc}/include"
  "${loc}/tmp"
  # trashbox
  "${tbox}"
  # ~/.config
  "${appconfig}/nvim"
  "${appconfig}/zathura"
  # other
  "${HOME}/.fonts"
  "${HOME}/.w3m"
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
)
# packages
declare -ar apt_packs=(
  # shell
  bash
  zsh
  shellcheck
  # packages
  curl
  git
  # editor
  emacs
  vim
  vim-gnome
  neovim
  # terminal
  tmux
  # japanese env
  language-pack-ja
  manpages-ja
  manpages-ja-dev
  fcitx
  fcitx-mozc
  # font
  fontconfig
  fonts-ipafont
  fonts-ipaexfont
  fonts-noto
  # x11
  x11-apps
  x11-utils
  x11-xserver-utils
  dbus-x11
  xauth
  # image
  feh # eog
  okular # evince
  zathura
  inkscape # gimp
  # image library
  imagemagick
  poppler-utils
  pstoedit
  epstool
  # compiler
  build-essential
  gfortran
  gcc
  g++
  # prg library
  liblapack-dev
  libblas-dev
  # python (latest)
  python3.9
  python3.9-distutils
  tk-dev
  python3-tk
  # other prg
  # golang rustc nodejs npm
  # graph
  gnuplot-x11
  # tex
  texlive-latex-base
  texlive-latex-extra
  texlive-latex-recommended
  texlive-publishers
  texlive-extra-utils
  texlive-lang-japanese
  # texlive-lang-cjk
  xdvik-ja
  texlive-plain-generic
  texlive-fonts-recommended
  texlive-fonts-extra
  texlive-luatex
  latexmk
  # web browser
  w3m
  # other
  busybox
  file
  fzf # peco # fzy
  nkf
  bc
  xsel
  xclip
)

### other packages
declare -r curl_latest_neovim=false
declare -r git_fzf=true
declare -r git_enhancd=false
# fonts
declare -ar fonts_url=(
  'https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
  'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
)

### link
declare -ar link_tohome=(
  "${dfetc}/tmux/.tmux.conf"
  "${dfetc}/tex/.latexmkrc"
  "${dfetc}/gnuplot/.gnuplot"
  "${dfetc}/gnuplot/.gnuplot-wxt"
  "${dfsh}/.inputrc"
  "${dfsh}/.bashrc"
  "${dfsh}/.bash_profile"
  "${dfsh}/.sudo_as_admin_successful"
  "${dfsh}/.zshenv"
  "${dfsh}/.dir_colors"
)
declare -ar link_toany=(
  "${dfetc}/template"          "${HOME}/.template"
  "${dfetc}/zathurarc"         "${appconfig}/zathura/zathurarc"
  # w3m (not link directory, for cookie, history, ...)
  "${dfetc}/w3m/bookmark.html" "${HOME}/.w3m/bookmark.html"
  "${dfetc}/w3m/keymap"        "${HOME}/.w3m/keymap"
  # editor
  "${dfetc}/emacs"      "${HOME}/.emacs.d"
  "${dfetc}/vim"        "${HOME}/.vim"
  "${HOME}/.vim/vimrc"  "${HOME}/.vimrc"
  "${HOME}/.vim/gvimrc" "${HOME}/.gvimrc"
  "${HOME}/.vim/vimrc"  "${appconfig}/nvim/init.vim"
)

# EOF
