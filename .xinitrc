# Disable DPMS turning off the screen
xset -dpms
xset s off

# Disable bell
xset -b

# Set locales
unset LC_ALL
export LANG=en_US.UTF-8
export LC_MESSAGES=C
export LC_TIME=en_US.UTF-8

# Enable core dumps in case something goes wrong
ulimit -c unlimited

# map CAPS to CTRL
setxkbmap -option caps:ctrl_modifier

# Enable zapping (C-A-<Bksp> kills X)
setxkbmap -option terminate:ctrl_alt_bksp

# Execute i3-wm
exec i3
