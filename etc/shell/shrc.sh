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
alias l='ls --color=auto'
alias ls='ls --color=auto'
alias sl='ls --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -AlFh --color=auto'

# grep
alias grep='grep --color=auto'
alias ngrep='grep -v --color=auto'

# tex
alias texmk-pdf='latexmk -gg -pdf -pvc'
alias texmk-lua='latexmk -gg -lualatex -pvc'
alias texmk-up='latexmk -gg -pdfdvi -pvc'

# symbolic link jump
. "${DOTSH}/symbolic_link_jump.sh"
alias mkj='__make_symbolic_link_jump'
alias cdj='__cd_symbolic_link_jump'
alias lsj='echo "${__symlinks_dir}" && ll "${__symlinks_dir}"'

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
    alias op='wsl-open'
fi

# local config
declare -r __shrc_loc="${HOME}/.shrc_local.sh"
[[ ! -f "$__shrc_loc" ]] && touch "$__shrc_loc"
[[ "$__shell" = 'zsh' ]] && __autozcomp "$__shrc_loc"
. "$__shrc_loc"

# delete duplicated path
function __delete_duplicated_paths() {
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
    unset _p
    unset _path
}
__delete_duplicated_paths
