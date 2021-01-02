#!/usr/bin/env zsh

ZSH_FILES="$HOME/.zsh"

source ~/.zplug/init.zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "kutsan/zsh-system-clipboard"
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/history-substring-search", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/fasd", from:oh-my-zsh
zplug "plugins/direnv", from:oh-my-zsh
zplug "themes/agnoster", from:oh-my-zsh
zplug load

# enable vi-mode
bindkey -v

# configure zsh-system-clipboard
typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'
typeset -g ZSH_SYSTEM_CLIPBOARD_SELECTION='PRIMARY'

# color for zsh-autosuggestions
if [ "${TERM}" = "linux" ]; then
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#333333"
else
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#777777"
fi

# save history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Load configuration files.
if [[ -d "$ZSH_FILES/init" ]]; then for config_file in "$ZSH_FILES"/init/*.zsh; do source "$config_file"; done; fi
if [[ -d "$ZSH_FILES/private" ]]; then for config_file in "$ZSH_FILES"/private/*.zsh; do source "$config_file"; done; fi
