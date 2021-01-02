#!/usr/bin/env zsh

if [ -x "$(command -v pyenv)" ]; then
  export PYENV_ROOT=$(pyenv root)
  eval "$(pyenv init -)"
fi
