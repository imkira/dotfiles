source /usr/local/share/antigen/antigen.zsh

ZSH_FILES=$HOME/.zsh

# for zsh-notify
TERM_PROGRAM='Apple_Terminal'

antigen use oh-my-zsh

# Load bundles
antigen bundles <<EOBUNDLES
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zdharma/history-search-multi-word
  kutsan/zsh-system-clipboard
  marzocchi/zsh-notify
  z
  history-substring-search
  colored-man-pages
  docker
  git
  fasd
  $ZSH_FILES/custom/themes imkira.zsh-theme --no-local-clone
EOBUNDLES

# Load the theme.
antigen theme imkira

# Tell Antigen that you're done.
antigen apply

# enable vi-mode
bindkey -v

# configure zsh-system-clipboard
typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'

# configure history-search-multi-word
bindkey "^r" history-search-multi-word
zstyle ":history-search-multi-word" page-size "4"

# Load configuration files.
if [[ -d $ZSH_FILES/init ]]; then for config_file ($ZSH_FILES/init/*.zsh) source $config_file; fi
if [[ -d $ZSH_FILES/private ]]; then for config_file ($ZSH_FILES/private/*.zsh) source $config_file; fi
