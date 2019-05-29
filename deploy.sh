#!/bin/bash
loc=$(pwd)
if [ -d themes/${1} ]; then
    cp themes/${1}/waybar.css $HOME/.config/waybar/style.css
    cp themes/${1}/termite-config $HOME/.config/termite/config
    cp themes/${1}/sway-colors $HOME/.config/sway/theme
    echo "output * bg ${loc}/wallpapers/${1}.jpg fill" >> $HOME/.config/sway/theme
    echo "exec swayidle timeout 300 'swaylock -f -u -i ${loc}/wallpapers/${1}.jpg' timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' before-sleep 'swaylock -f -u -i ${loc}/wallpapers/${1}.jpg'" >> $HOME/.config/sway/theme
    echo "bindsym \$lockbind exec swaylock -f -u -i ${loc}/wallpapers/${1}.jpg" >> $HOME/.config/sway/theme
    swaymsg -t command reload
    killall -USR1 termite
else
    echo "Not a theme"
    exit 1
fi
