# use vi key bindings
bindkey -v

# search backward for string
bindkey '^r' history-incremental-search-backward

# fuzy history search with up/down keys
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# move within line
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OF' end-of-line
