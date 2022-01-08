# shell environment

### usr local env variables
# dotfiles
export DOTFILES=${HOME}/df
# local directories
export LOCAL=${HOME}/.local
export TRASHBOX=${HOME}/.t
export T=$TRASHBOX

### font color (escape-sequence \e[3(COL1/2/3)m)
# export COL1=2 COL2=3 COL3=6
### shell library
# export ELIB_BASH=${DOTFILES}/lib/shell/elib.bash

### PATH
[[ -d "${DOTFILES}/bin" ]]  && export PATH=$PATH:${DOTFILES}/bin
[[ -d "${LOCAL}/bin" ]] && export PATH=$PATH:${LOCAL}/bin
# Rust
[[ -f "${HOME}/.cargo/env" ]] && . ${HOME}/.cargo/env
# Go
[[ -d "${LOCAL}/go/bin" ]] && export PATH=$PATH:${LOCAL}/go/bin

### shell
export DOTSH=${DOTFILES}/etc/shell
export BASH_ENV=${DOTSH}/.bashenv
export ZDOTDIR=${DOTSH}
[[ -z "$ZDOTDIR" ]] && export ZDOTDIR=$HOME

# terminal
export TERM=xterm-256color

### locale
# available locale $ locale -a
export LANG=ja_JP.UTF-8
export LC_TIME=C

### editor/pager
export EDITOR=nano
export PAGER=less
export LESS='-q -iMR -x2'
which lesspipe &>/dev/null && [[ -x "$(which lesspipe)" ]] && eval "$(SHELL=/bin/sh lesspipe)"

### gnuplot
export GNUTERM=x11
export GNUPLOT_LIB=${DOTFILES}/lib/gnuplot

### C/C++
export C_INCLUDE_PATH=${DOTFILES}/lib/c/include
export CPLUS_INCLUDE_PATH=${C_INCLUDE_PATH}
# local
export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:~/.local/include
# opencv
export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:/usr/include/opencv4

### Python
# library path
# export PYTHONPATH=$PYTHONPATH:${DOTFILES}/lib/python

### WSL (Windows Subsystem for Linux)
if [[ -d '/mnt/c/Windows' ]]; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
  export LIBGL_ALWAYS_INDIRECT=1
fi

### fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
# xset -r 49

### others
# tex/latex library directory
export TEXMFHOME=${DOTFILES}/lib/tex/texmf
# w3m
export WWW_HOME="https://www.google.com"
# XDG Base Directory
export XDG_CONFIG_FILE="$HOME/.config"
# Openmp
export OMP_NUM_THREADS=2

# end
