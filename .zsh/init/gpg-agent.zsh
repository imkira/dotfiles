#!/usr/bin/env zsh

if [ -d ~/.gnupg ]; then
  PGP_AGENT_PID=$(pgrep gpg-agent)
  if [ -n "${PGP_AGENT_PID}" ]; then
    export GPG_AGENT_INFO="~/.gnupg/S.gpg-agent:${PGP_AGENT_PID}:1"
    export GPG_TTY=$(tty)
  else
    eval $(gpg-agent --daemon)
  fi
fi
