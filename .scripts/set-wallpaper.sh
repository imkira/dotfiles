#!/bin/sh

RESOLUTION=$(xrandr --current | head -n 1 | sed 's/^.*,\s*current \([0-9]\+\)\s*x\s*\([0-9]\+\)\s*,.*$/\1x\2/')
SRC_URL="https://source.unsplash.com/featured/${RESOLUTION}/?beach"
DST_FILE=~/.wallpaper.jpg

if test -f "$DST_FILE"; then
  feh --bg-scale "$DST_FILE"
fi

curl -q -L "$SRC_URL" -o "$DST_FILE"
