# brew install highlight

export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS="-C -R "
alias less='less -m -N -g -i -J --underline-special --SILENT'
export PAGER="less -C"
