#!/usr/bin/env bash
# source in (bash|zsh)rc

### Prompt
# 'normal'/'simple'/'adam'. Prompt style.
declare __prompt_style='simple'
# true/false. In zsh, vcs_info check_for_change.
declare __vcs_check_for_change=true

### tmux
# true/false. Tmux autostart.
declare -r __tmux_autostart=false

### wsl
declare -r __wsl_vcxsrv_autostart=false
declare -r __wsl_fcitx_autostart=false

### python
# default version
declare -r __python_defver=python3.9

# shell
[[ ! -z "${BASH_VERSION:-}" ]] && declare -r __shell='bash'
[[ ! -z  "${ZSH_VERSION:-}" ]] && declare -r __shell='zsh'

# os
declare -r __kernel_name=$(uname -s)
[[ "$__kernel_name" =~ ^CYGWIN ]] && declare -r __os='cygwin'
[[ ! -v __os ]] && declare -r __os='ubuntu'

# stty
[[ -t 0 ]] && stty -ixon

# LS_COLORS
eval $(dircolors -b "${HOME}/.dir_colors")

### tmux
alias tmux.attach='tmux a'
alias tmux.attach.name='tmux a -t'
alias tmux.ls='tmux ls'
# autostart
if ${__tmux_autostart:-false} && [[ ! -n "$TMUX" ]];then
  declare __tmuxid="$(tmux list-sessions 2>/dev/null)"
  if [[ -z "$__tmuxid" ]] ; then tmux -u new-session
  else
    tmux a
  fi
fi

### packages
# enhancd
# if [[ -d "${LOCAL}/src/enhancd" ]] ; then
#   export ENHANCD_FILTER=fzf:fzy:peco
#   SHELL="/bin/${__shell}" . "${LOCAL}/src/enhancd/init.sh"
# fi

### WSL
if [[ ! -z "${WSLENV:-}" ]] ; then
  # VcXsrv autostart
  if ${__wsl_vcxsrv_autostart:-false};then
    if [[ -e /mnt/c/WINDOWS/System32/wsl.exe ]] && [[ -z "$(tasklist.exe | grep vcxsrv)" ]] ; then
      cmd.exe /c config.xlaunch
    fi
  fi
  # fcitx autostart
  if ${__wsl_fcitx_autostart:-false} && [[ $SHLVL = 1 ]] ; then
    xset -r 49  &>/dev/null
    (fcitx-autostart &>/dev/null &)
  fi
  ### wsl alias
  # filer
  alias wf='/mnt/c/Windows/explorer.exe .'
fi

# Cygwin
if [[ "$__os" = 'cygwin' ]]; then
  alias wf='/cygdrive/c/Windows/explorer.exe .'
fi

# text editor
function __df_emacs_readonly() { emacs -nw "$@" --eval '(setq buffer-read-only t)' ; }
alias em='emacs -nw'
alias emr='__df_emacs_readonly'
if [[ "$__os" = 'cygwin' ]]; then
  alias vi='vim -X'
  alias vir='vim -X -M'
else
  if $(which nvim &> /dev/null); then
    alias vi='nvim'
    alias vir='nvim -M'
  else
    alias vi='vim'
    alias vir='vim -M'
  fi
fi
alias vim-def='vim -u NONE -N'
alias emacs='__guiapp_background emacs'
alias gvim='__guiapp_background gvim'

# image editor/viewer
alias inkscape='__guiapp_background inkscape'
alias feh='__guiapp_background feh'
alias eog='__guiapp_background eog'
alias evince='__guiapp_background evince'
alias okular='__guiapp_background okular'
alias zathura='__guiapp_background zathura'
# extension alias
alias png='__guiapp_background feh'
alias pgm='__guiapp_background feh'
alias bmp='__guiapp_background feh'
alias eps='__guiapp_background okular'
alias pdf='__guiapp_background zathura'
alias svg='__guiapp_background inkscape'

### alias/function for PC/shell/terminal/clipboard
# alias shutdown='sudo shutdown -h now'
# alias reboot='sudo shutdown -r now'
alias relogin='exec $SHELL -l'
# clipboard copy
alias cb='head -c -1 | xsel --clipboard --input'

### alias/function for cd/ls/mkdir/link
alias j='builtin cd'
alias jb='builtin cd ..'
alias l='ls --color=auto' ls='ls --color=auto' sl='ls --color=auto'
alias la='ls -A --color=auto'
alias lb='ls -d --color=auto .*'
alias ll='ls -AlFh --color=auto'
alias md='mkdir'
alias md.cd='__func_mdcd'
function __func_mdcd() { mkdir "$1" && cd "$1" ; }
alias ln='ln -snf'
alias unlinknull='find . -maxdepth 1 -xtype l | xargs rm'

### jump: record path (add/rm) and cd record-path
declare -r __jumpfile="${HOME}/.jumplist"
[[ -f "${DOTFILES}/bin/__jump.out" ]] && declare -r __jumpout="${DOTFILES}/bin/__jump.out"
[[ ! -v __jumpout ]] && declare -r __jumpout="${DOTFILES}/bin/__jump.py"
function __df_jumpfunc() {
  local tmp=$("$__jumpout" "$__jumpfile" "$@")
  [[ -d "$tmp" ]] && cd "$tmp" || echo "$tmp"
}
alias jj='__df_jumpfunc'

# package manager
alias apt='__apt_wrapper'

### programming
# parameters
declare -r __pg_cout_file='cout.txt'
declare -r __pg_exe_file='a.out'
# general
alias aout='./a.out'
alias ce="__compile_execute.bash ${__pg_cout_file} ${__pg_exe_file}"
alias ce.a="__compile_execute.bash -a ${__pg_cout_file} ${__pg_exe_file}"
alias ce.c="__compile_execute.bash -c ${__pg_cout_file} ${__pg_exe_file}"
alias ce.ac="__compile_execute.bash -a -c ${__pg_cout_file} ${__pg_exe_file}"
# python
declare -r __python_defver_rc=${__python_defver:-python}
declare -r __pipcmd="$__python_defver_rc -m pip"
alias py="$__python_defver_rc"
alias py.pip="$__pipcmd"
alias py.pip.install="$__pipcmd install"
alias py.pip.upgrade="$__pipcmd install --upgrade"
alias py.pip.uninstall="$__pipcmd uninstall"
alias py.pip.input="$__pipcmd install -r"
alias py.pip.output="$__pipcmd freeze -l >"

# gnuplot
alias gp='gnuplot'

# tex
alias tex.lts="__lts.bash"
alias tex.edit.lts="edit ${DOTFILES}/bin/__lts.bash"
alias tex.mk.pdf='latexmk  -gg -pdf    -pvc'
alias tex.mk.lua='latexmk  -gg -lualatex -pvc'
alias tex.mk.up='latexmk -gg -pdfdvi -pvc'

# docker
alias dkr='docker'

# compress
alias tgz='tar -zcvf'
alias tbz='tar -jcvf'
alias txz='tar -Jcvf'
alias zip='zip -r'
alias gz='gzip'
alias bz2='bzip2'
# extract
alias untgz='tar -zxvf'
alias untbz='tar -jxvf'
alias untxz='tar -Jxvf'
alias ungz='gzip -d'
alias unbz2='bzip2 -d'
function __extract() {
  for ff in "$@"; do
    case $ff in
      *.tar.gz|*.tgz)  tar xzvf   "$ff" ;;
      *.tar.xz)        tar Jxvf   "$ff" ;;
      *.zip)           unzip      "$ff" ;;
      *.lzh)           lha e      "$ff" ;;
      *.tar.bz2|*.tbz) tar xjvf   "$ff" ;;
      *.tar.Z)         tar zxvf   "$ff" ;;
      *.gz)            gzip -d    "$ff" ;;
      *.bz2)           bzip2 -dc  "$ff" ;;
      *.Z)             uncompress "$ff" ;;
      *.tar)           tar xvf    "$ff" ;;
      *.arj)           unarj      "$ff" ;;
    esac
  done
}

### cpu/gpu
alias cpu='htop'
alias gpu='intel_gpu_top'
# alias gpu='nvidia-smi'
alias disk='df -hP'

### alias e-cmd
# bash/zsh alias
if [[ "$__shell" = 'bash' ]] ; then
  function __reset_noglob() { local CMD="$1" ; shift ; $CMD "$@" ; set +f ; }
  alias zmv="set -f ; __reset_noglob __zmv.bash"
  alias fin="set -f ; __reset_noglob __fin.bash"
elif [[ "$__shell" = 'zsh' ]] ; then
  alias zmv="noglob __zmv.bash"
  alias fin="noglob __fin.bash"
fi
# dictionary
alias di='__ej_dictionary.bash chars'
alias di.w='__ej_dictionary.bash word'

### others
alias le='less'
alias tl='tail -f -n 100'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ngrep='grep -v --color=auto'
alias utf8unix='nkf -w -Lu --overwrite'
alias utf8dos='nkf -w -Lw --overwrite'
alias sjisdos='nkf -s -Lw --overwrite'

# local config
declare -r __shrc_loc="${HOME}/.shrc_local.bash"
[[ ! -f "$__shrc_loc" ]] && touch "$__shrc_loc"
[[ "$__shell" = 'zsh' ]] && __autozcomp "$__shrc_loc"
. "$__shrc_loc"

# end
