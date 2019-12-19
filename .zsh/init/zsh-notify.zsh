zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"

zstyle ':notify:*' enable-on-ssh yes
zstyle ':notify:*' blacklist-regex 'v|vim|find|git'
zstyle ':notify:*' command-complete-timeout 15
