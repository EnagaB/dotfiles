#!/usr/bin/env zsh

### zcompile function
function __autozcomp() {
  local file="$1"
  if [[ -f "${file}.zwc" ]] ; then
    local orifile="${file}"
    local zwcfile="${file}.zwc"
    [[ -L "$orifile" ]] && orifile=$(readlink $orifile)
    [[ -L "$zwcfile" ]] && zwcfile=$(readlink $zwcfile)
    if [[ "$zwcfile" -ot "$orifile" ]] ; then
      zcompile "${file}"
    fi
  else
    zcompile "${file}"
  fi
}

### zcompile .zshenv/.zshrc
__autozcomp "${HOME}/.zshenv"
__autozcomp "${ZDOTDIR}/.zshrc"

### init
autoload -Uz colors && colors
autoload -Uz is-at-least
autoload -Uz add-zsh-hook

### prompt
declare -r __prompt_style_fc=${__prompt_style:-'simple'}
if [ "$__prompt_style_fc" = 'adam' ];then
  autoload -Uz promptinit && promptinit
  prompt adam1 blue write green
else
  setopt prompt_subst
  if [ "$__prompt_style_fc" = 'normal' ];then
    declare -r __prompt_std=$'[%F{yellow}%n%f@%F{yellow}%m%f:%F{cyan}%~%f]'
    declare -r __prompt_date=$'[%F{cyan}%D{%F(%a)%T}%f]'
    declare -r __prompt_last=$'\n %# '
  elif [ "$__prompt_style_fc" = 'simple' ];then
    declare -r __prompt_std=$'%F{cyan}%~%f'
    declare -r __prompt_date=$''
    declare -r __prompt_last=$'\n%F{cyan}>%f '
  fi
  PROMPT=${__prompt_std}${__prompt_date}${__prompt_last}
  # vcs_info
  if is-at-least 4.3.11 ;then
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git hg
    if ${__vcs_check_for_change:-false}; then
      zstyle ':vcs_info:git:*' check-for-changes true
      zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
      zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
    else
      zstyle ':vcs_info:git:*' check-for-changes false
    fi
    if [ "$__prompt_style_fc" = 'normal' ];then
      zstyle ':vcs_info:*' formats "%F{green}%u%c[%b]%f"
      zstyle ':vcs_info:*' actionformats "[%b|%a]"
    elif [ "$__prompt_style_fc" = 'simple' ];then
      zstyle ':vcs_info:*' formats " %F{green}%u%c%b%f"
      zstyle ':vcs_info:*' actionformats " %b|%a"
    fi
    function __update_prompt() {
      PROMPT=${__prompt_std}
      local -a messages
      LANG=C vcs_info
      if [[ ! -z ${vcs_info_msg_0_} ]];then
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{green}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )
        PROMPT=${PROMPT}${(j: :)messages}
      fi
      PROMPT=${PROMPT}${__prompt_date}${__prompt_last}
    }
    add-zsh-hook precmd __update_prompt
  fi
fi

### history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt share_history
setopt hist_verify
setopt hist_no_store
setopt hist_ignore_space

### complement
autoload -Uz compinit && compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate _prefix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' insert-tab false

### keybindings
bindkey -d # reset keybindings
bindkey -e # set keybindings as emacs-mode
bindkey '^[[1;5D' backward-word # C-left
bindkey '^[[1;5C' forward-word  # C-right

### other
KEYTIMEOUT=1
setopt auto_cd
function chpwd() {
  local fn=$(ls -U1 --color=never | wc -l)
  local -r maxfn=100
  if [[ "$fn" -le "maxfn" ]] ; then
    ls --color=auto
  else
    echo "There are over ${maxfn} files."
  fi
}
# function precmd() {
#   if [ -z "$__NEW_LINE_BEFORE_PROMPT" ];then
#     __NEW_LINE_BEFORE_PROMPT=1
#   elif [ "$__NEW_LINE_BEFORE_PROMPT" -eq 1 ];then
#     echo ''
#   fi
# }
setopt auto_pushd
setopt pushd_ignore_dups
setopt no_beep
setopt nolistbeep
setopt correct
setopt extended_glob
setopt no_flow_control
limit coredumpsize 0
unsetopt promptcr
setopt long_list_jobs
setopt list_types
setopt auto_list
setopt auto_menu
setopt magic_equal_subst
setopt equals
setopt noautoremoveslash
setopt auto_param_slash
setopt auto_param_keys
setopt list_packed
setopt numeric_glob_sort
setopt no_tify

### select-word-style
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

### source rc
# local
[[ ! -f "${HOME}/.shrc_local.bash" ]] && cp "${DOTSH}/shrc_local.bash" "${HOME}/.shrc_local.bash"
__autozcomp "${HOME}/.shrc_local.bash"
. "${HOME}/.shrc_local.bash"
# glob
__autozcomp "${DOTSH}/shrc.bash"
[[ -f "${DOTSH}/shrc.bash" ]] && . "${DOTSH}/shrc.bash"

### alias
### suffix alias
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=__extract
alias -s {png,pgm,bmp,eps,pdf}=__view
alias -s svg=__edit
### global alias
alias -g L='| less'
alias -g GI='| grep -i'
alias -g GIV='| grep -i -v'
alias -g G='| grep '
alias -g GV='| grep -v'
alias -g C='| xsel --input --clipboard' # copy standard output to the clipboard
# C compile option
alias -g LOPENCV='-lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_videoio -lopencv_videostab -lopencv_objdetect -lopencv_calib3d -lopencv_flann -lopencv_imgcodecs'

# EOF
