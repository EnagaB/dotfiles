#!/usr/bin/env bash
# source in (bash|zsh)rc

# shell
[[ ! -z "${BASH_VERSION:-}" ]] && declare -r __shell='bash'
[[ ! -z  "${ZSH_VERSION:-}" ]] && declare -r __shell='zsh'

# stty
[[ -t 0 ]] && stty -ixon

# LS_COLORS
eval $(dircolors -b "${HOME}/.dir_colors")

# text editor
if which nvim &> /dev/null ; then
    alias vi='nvim'
    alias vir='nvim -M'
else
    alias vi='vim'
    alias vir='vim -M'
fi

# system
alias shutdown-now='sudo shutdown -h now'
alias relogin='exec "$SHELL" -l'

# ls
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlFh --color=auto'
# eza: https://github.com/eza-community
alias lsd='eza'

# grep
alias grep='grep --color=auto'
alias ngrep='grep -v --color=auto'

# tex
alias texmk-pdf='latexmk -gg -pdf -pvc'
alias texmk-lua='latexmk -gg -lualatex -pvc'
alias texmk-up='latexmk -gg -pdfdvi -pvc'

# symbolic link jump
function __make_symbolic_link_jump() {
    local usage="> command link_name"
    if [ ! -d "$SYMLINKS_JUMP_DIR" ]; then
        mkdir -p "$SYMLINKS_JUMP_DIR"
    fi
    if [ "$#" -ne 1 ]; then
        echo "ERROR: Invalid arguments"
        echo "$usage"
        return 1
    fi
    ln -snfv "$(pwd)" "${SYMLINKS_JUMP_DIR}/${1}"
}
function __cd_symbolic_link_jump() {
    local usage="> command link_name"
    if [ "$#" -ne 1 ]; then
        echo "ERROR: Invalid arguments"
        echo "$usage"
        return 1
    fi
    local link_path
    link_path="${SYMLINKS_JUMP_DIR}/${1}"
    if [ ! -L "$link_path" ]; then
        echo "ERROR: Given link doesn't exist."
        return 1
    fi
    cd -P "$link_path"
}
alias jmk='__make_symbolic_link_jump'
alias jcd='__cd_symbolic_link_jump'
alias jls='echo "${SYMLINKS_JUMP_DIR}" && ll "${SYMLINKS_JUMP_DIR}"'

# os
declare -r __kernel_name=$(uname -s)
[[ "$__kernel_name" =~ ^CYGWIN ]] && declare -r __os='cygwin'
[[ ! -v __os ]] && declare -r __os='ubuntu'
# settings by os
if [[ "$__os" = "cygwin" ]]; then
    alias winroot='cd /cygdrive/c'
    alias op='cygstart'
    alias vi='vim -X'
    alias vir='vim -X -M'
elif [[ "$__os" = "ubuntu" ]] && [[ ! -z "${WSLENV:-}" ]]; then
    alias winroot='cd /mnt/c'
    function __wsl_open() {
        local explorer_path='/mnt/c/Windows/explorer.exe'
        if [ $# != 1 ]; then
            "$explorer_path" .
        else
            if [ -e $1 ]; then
                "$explorer_path" $(wslpath -w $1) 2> /dev/null
            else
                echo "open: $1 : No such file or directory"
            fi
        fi
    }
    alias op='__wsl_open'
fi

# local config
declare -r __shrc_loc="${HOME}/.shrc_local.sh"
[[ ! -f "$__shrc_loc" ]] && touch "$__shrc_loc"
[[ "$__shell" = 'zsh' ]] && __autozcomp "$__shrc_loc"
. "$__shrc_loc"

# delete duplicated path
function __delete_duplicated_paths() {
    local _path
    local _p
    _path=""
    for _p in $(echo $PATH | tr ':' ' '); do
        case ":${_path}:" in
            *:"${_p}":* )
                ;;
            * )
                if [ "$_path" ]; then
                    _path="$_path:$_p"
                else
                    _path=$_p
                fi
                ;;
        esac
    done
    if [ ! -z "$_path" ]; then
        export PATH=$_path
    fi
}
__delete_duplicated_paths
