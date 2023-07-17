#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# rc/env dir
export DOTFILES=${HOME}/dotfiles
export DOTSH=${DOTFILES}/etc/shell

# .bashenv
[[ -f "${HOME}/.bashenv" ]] && . "${HOME}/.bashenv"

# disable starting message
if [ ! -f "${HOME}/.sudo_as_admin_successful" ];then
    true > "${HOME}/.sudo_as_admin_successful"
fi

# history
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# other
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
shopt -s checkwinsize

# prompt
PS1=''
function __prompt_git_branch() {
    branch=$(git symbolic-ref HEAD 2> /dev/null)
    echo "$branch" | sed 's/^refs\/heads\///'
}
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    PS1=${PS1}'${debian_chroot:+($debian_chroot)} '
fi
PS1=${PS1}'\[\033[33m\]'
[[ ! -z "$SSH_CONNECTION" ]] && PS1=${PS1}'\u@\h '
PS1=${PS1}'\w $(__prompt_git_branch)'
PS1=${PS1}'\n> '
PS1=${PS1}'\[\033[00m\]'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# non cd , directory name only -> auto cd
shopt -s autocd
# auto cd -> ls
function auto_cdls() {
    if [ "$OLDPWD" != "$PWD" ]; then
        local fn=$(ls -U1 --color=never | wc -l)
        local -r maxfn=100
        if [[ "$fn" -le "${maxfn}" ]] ; then
            ls --color=auto
        else
            echo "There are over ${maxfn} files."
        fi
        OLDPWD="$PWD"
    fi
}
PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'auto_cdls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

ulimit -c 0 # not output core files

[[ -f "${DOTSH}/shrc.sh" ]] && source "${DOTSH}/shrc.sh"
