#!/usr/bin/env bash
# source in (bash|zsh)rc

# shell
[[ ! -z "${BASH_VERSION:-}" ]] && declare -r __shell='bash'
[[ ! -z  "${ZSH_VERSION:-}" ]] && declare -r __shell='zsh'

# stty
[[ -t 0 ]] && stty -ixon

# LS_COLORS
eval $(dircolors -b ${HOME}/.dir_colors)

### tmux
alias tmux.attach='tmux a'
alias tmux.attach.name='tmux a -t'
alias tmux.ls='tmux ls'
# autostart
if [[ "${__tmux_autostart:-0}" -ne 0 ]] && [[ ! -n "$TMUX" ]];then
  declare __tmuxid="$(tmux list-sessions 2>/dev/null)"
  if [[ -z "$__tmuxid" ]] ; then tmux -u new-session
  else
    tmux a
  fi
  unset -v __tmuxid
fi

### packages
# enhancd
if [[ -d "${LOCAL}/src/enhancd" ]] ; then
  export ENHANCD_FILTER=fzf:fzy:peco
  SHELL="/bin/${__shell}" . "${LOCAL}/src/enhancd/init.sh"
fi

### WSL
if [[ ! -z "${WSLENV:-}" ]] ; then
  # VcXsrv autostart
  if [[ "${__wsl_vcxsrv_autostart:-0}" -ne 0 ]];then
    if [[ -e /mnt/c/WINDOWS/System32/wsl.exe ]] && [[ -z "$(tasklist.exe | grep vcxsrv)" ]] ; then
      cmd.exe /c config.xlaunch
    fi
  fi
  # fcitx autostart
  if [[ "${__wsl_fcitx_autostart:-0}" -ne 0 ]] && [[ $SHLVL = 1 ]] ; then
    xset -r 49  &>/dev/null
    (fcitx-autostart &>/dev/null &)
  fi
  ### wsl alias
  # filer
  alias we='/mnt/c/Windows/explorer.exe .'
fi

### alias/function for edit/view
# emacs, vi/vim/nvim
alias em='emacs -nw'
alias em.g='__guiapp_bg.bash emacs'
alias em.r='__func_emacs_readonly'
alias vi='nvim'
alias vi.g='__guiapp_bg.bash gvim'
alias vi.r='nvim -M'
function __func_emacs_readonly() { emacs -nw "$@" --eval '(setq buffer-read-only t)' ; }
# inkscape
alias ink='__guiapp_bg.bash inkscape -f'
# edit
alias edit='__edit'
# view
alias fe='__guiapp_bg.bash feh'
alias eo='__guiapp_bg.bash eog'
alias ev='__guiapp_bg.bash evince'
alias ok='__guiapp_bg.bash okular'
alias za='__guiapp_bg.bash zathura'
alias view='__view'
# functions
function __edit() {
  [[ "$#" -eq 0 ]] && return 1
  case "$1" in
    *.svg) inkscape     "$@" & ;;
    *.png) inkscape     "$@" & ;;
    *.eps) inkscape     "$@" & ;;
    *.pdf) inkscape     "$@" & ;;
    *)     vim          "$@"   ;;
  esac
}
function __view() {
  [[ "$#" -eq 0 ]] && return 1
  case "$1" in
    *.png) feh      "$1" & ;;
    *.pgm) feh      "$1" & ;;
    *.bmp) feh      "$1" & ;;
    *.eps) okular   "$1" & ;;
    *.pdf) zathura  "$1" & ;;
    *.svg) inkscape "$1" & ;;
  esac
}

### alias/function for PC/shell/terminal/clipboard
alias shutdown='sudo shutdown -h now'
alias reboot='sudo shutdown -r now'
alias relogin='exec $SHELL -l'
# package
alias apt.install='sudo apt install'
alias apt.rm='sudo apt remove'
alias apt.show='apt show'
alias apt.search='apt search'
alias apt.upgrade='__upgrade.bash apt'
alias apt.upgrade.full='__upgrade.bash apt-full'
# clipboard copy
alias cb='head -c -1 | xsel --clipboard --input'

# git
alias git.status='git status'
alias git.log='git log -1'
alias git.clone='git clone'
alias git.clone1='git clone --depth 1'
alias git.push='__git.bash push'
alias git.pull='__git.bash pull'
alias git.set.def='__git.bash set.def'
alias git.set.name='__git.bash set.name'
alias git.set.email='__git.bash set.email'

### alias/function for cd/ls/mkdir/link
alias j='builtin cd'
alias jb='builtin cd ..'
alias J='__enhancd::cd'
alias l='ls --color=auto' ls='ls --color=auto' sl='ls --color=auto'
alias la='ls -A --color=auto'
alias lb='ls -d --color=auto .*'
alias ll='ls -AlFh --color=auto'
alias md='mkdir'
alias md.cd='__func_mdcd'
function __func_mdcd() { mkdir "$1" && cd "$1" ; }
alias ln='ln -snf'
alias unlinknull='find . -maxdepth 1 -xtype l | xargs rm'
alias mf='__makefile.bash'

### jump: record path (add/rm) and cd record-path
declare -r __jump_file=${HOME}/.jump
function __jumpfunc() {
  local tmp=$(__jump.out "$__jump_file" "${1:-}" "${2:-}")
  [[ -d "$tmp" ]] && cd "$tmp" || echo "$tmp"
}
alias jj="__jumpfunc"

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
declare -r __pipcmd="$__python_defver -m pip"
alias py="$__python_defver"
alias py.pip="$__pipcmd"
alias py.pip.install="$__pipcmd install"
alias py.pip.upgrade="$__pipcmd install --upgrade"
alias py.pip.uninstall="$__pipcmd uninstall"
alias py.pip.input="$__pipcmd install -r"
alias py.pip.output="$__pipcmd freeze -l >"

# gnuplot
alias gp='gnuplot'
### cprg
# atcoder-tools, install: $ pip3 install atcoder-tools
alias atc='__atcoder_tools_func'
function __atcoder_tools_func() {
  local cmd=$1
  local contest=$2
  atcoder-tools "$cmd" "$contest" --without-login
}

# tex
alias tex.lts="__lts.bash"
alias tex.edit.lts="edit ${DOTFILES}/bin/__lts.bash"
alias tex.mk.pdf='latexmk  -gg -pdf    -pvc'
alias tex.mk.lua='latexmk  -gg -lualatex -pvc'
alias tex.mk.up='latexmk -gg -pdfdvi -pvc'

# docker
alias dkr='docker'
alias dkr.img='docker image'
alias dkr.cnt='docker container'

### compress/extract
# tar
alias tar.show='tar -tf'
alias tar.cmp.tgz='tar -zcvf'
alias tar.cmp.tbz2='tar -jcvf'
alias tar.cmp.txz='tar -Jcvf'
alias tar.ext='tar -xvf'
# zip
alias zip.cmp.file='zip'
alias zip.cmp.dir='zip -r'
alias zip.ext='unzip'
# cmp/ext
alias cmp='__compress'
alias ext='__extract'
function __compress() {
  while true; do
    if [[ -f "$1" ]];then
      gzip "$1"
      shift 1
    elif [[ -d "$2" ]];then
      tar -zcvf "$1" "$2"
      shift 2
    fi
    [[ "$#" -eq 0 ]] && break
  done
}
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
alias ch.cpu='htop'
alias ch.gpu='intel_gpu_top'
# alias ch.gpu='nvidia-smi'

### echo
alias echo.date='date +"%Y%m%dT%H%M"'
alias echo.dateUTC='env TZ=UTC date +"%Y%m%dT%H%M"'
alias echo.dateUNIX='date +"%s"'

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
# mv args to trash box
alias trm='__mv_to_trashbox.bash'
alias trm.clean='__clean_trashbox.bash'
# backup
alias bu='__backup.bash'
# dictionary
alias di='__ej_dictionary.bash chars'
alias di.w='__ej_dictionary.bash word'
# image convert
alias cv='__image_convert.bash'

### others
alias le='less'
alias tl='tail -f -n 100'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ngrep='grep -v --color=auto'
alias df='df -hP'
alias utf8unix='nkf -w -Lu --overwrite'
alias utf8dos='nkf -w -Lw --overwrite'
alias sjisdos='nkf -s -Lw --overwrite'

# end
