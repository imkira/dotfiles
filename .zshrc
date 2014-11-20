ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.zsh/custom
ZSH_THEME="imkira"

DISABLE_AUTO_UPDATE="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
COMPLETION_WAITING_DOTS="true"

plugins=(vi-mode git git-extras git-flow brew rvm npm ruby bundler node knife tmuxinator cap history-substring-search autojump wd vagrant docker aws web-search osx terminalapp catimg)

source $ZSH/oh-my-zsh.sh

# completely disable autocorrection
unsetopt correct_all

ZSH_FILES=$HOME/.zsh

# preconfiguration
for config_file ($ZSH_FILES/before/*.zsh) source $config_file
if [[ -d $ZSH_FILES/private ]]; then for config_file ($ZSH_FILES/private/*.zsh) source $config_file; fi

# configuration
for config_file ($ZSH_FILES/*.zsh) source $config_file

autoload -Uz compinit
compinit
