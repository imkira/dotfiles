local user='%{$fg_bold[red]%}[%{$fg_bold[white]%}%n@%{$fg_bold[white]%}%m%{$fg_bold[red]%}]%{$reset_color%}'
local pwd='%{$fg_bold[yellow]%}%~%{$reset_color%}'
local repo='%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}'

PROMPT="${user} ${pwd} ${repo}%{$fg_bold[white]%}$%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="git(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
