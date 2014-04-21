alias svn=colorsvn
alias svndiff='svn diff --diff-cmd colordiff'
alias grma='git ls-files --deleted -z | xargs -0 git rm'
alias gclone='for branch in `git branch -r | grep -v HEAD | grep -v master `; do git branch --track ${branch#remotes/origin/} $branch; done'
alias ggraph='git log --oneline --graph --decorate --all --date-order'
