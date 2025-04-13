#!/bin/sh

# Set wallpaper
feh --bg-fill ~/Downloads/wall.png &

# Start compositor
#xcompmgr -c -f -D 3 &

# Kill any existing status bar scripts
pkill -f "while true; do xsetroot"

# Start status bar script with more reliable format
while true; do
  DATE=$(date '+%b %d %a')
  TIME=$(date '+%H:%M')
  xsetroot -name "$TIME|$DATE"
  sleep 30
done &
