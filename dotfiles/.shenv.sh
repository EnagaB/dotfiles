# shell environment

# dotfiles
export DOTFILES="${HOME}/dotfiles"
# local directories
export LOCAL="${HOME}/.local"
export TRASHCAN="${HOME}/.trashcan"

# PATH
[[ -d "${DOTFILES}/bin" ]]  && export PATH=$PATH:"${DOTFILES}/bin"
[[ -d "${LOCAL}/bin" ]] && export PATH=$PATH:"${LOCAL}/bin"
# Rust
[[ -f "${HOME}/.cargo/env" ]] && . "${HOME}/.cargo/env"
# Go
[[ -d "${LOCAL}/go/bin" ]] && export PATH=$PATH:"${LOCAL}/go/bin"
# npm
[[ -d "${HOME}/.npm-global" ]] && export PATH=$PATH:"${HOME}/.npm-global/bin"

# shell
export BASH_ENV="${HOME}/.bashenv"
export ZDOTDIR="${HOME}"

# .shrc.sh
export DOT_SHRC="${HOME}/.shrc.sh"
export SYMLINKS_JUMP_DIR="${HOME}/.jump_symlinks"

# terminal
export TERM=xterm-256color

# locale. Show available locale > locale -a
export LANG=ja_JP.UTF-8
export LC_TIME=C

### editor/pager
export EDITOR=nano
export PAGER=less
export LESS='-q -iMR -x2'
which lesspipe &>/dev/null && [[ -x "$(which lesspipe)" ]] && eval "$(SHELL=/bin/sh lesspipe)"

# gnuplot
export GNUTERM=x11
export GNUPLOT_LIB="${DOTFILES}/lib/gnuplot"

# C/C++
# export C_INCLUDE_PATH=""
export CPLUS_INCLUDE_PATH="${HOME}/.local/include"

# WSL
. "${DOTFILES}/lib/sh/wsl.sh"
if is_wsl; then
    if has_wslg; then
        export DISPLAY=:0
    else
        # use VcXsrv
        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
        export LIBGL_ALWAYS_INDIRECT=1
    fi
fi
unset_wsl_functions

# fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
# xset -r 49

# others
# tex/latex library directory
export TEXMFHOME="${DOTFILES}/lib/tex/texmf"
# w3m
export WWW_HOME="https://www.google.com"
# XDG Base Directory
export XDG_CONFIG_FILE="$HOME/.config"
