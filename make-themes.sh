#!/bin/bash

cd $HOME/Code/gvcci/
for wallpaper in $HOME/wallpaper/*.jpg; do
  echo $wallpaper
  trimmed=$(basename -s .jpg $wallpaper)
  echo $trimmed
  [ -e "$wallpaper" ] || continue

  if [ ! -d $HOME/Code/wallpapers/$trimmed ]; then
    ./gvcci.sh $wallpaper
    cp ./examples.html $HOME/.gvcci/themes/$trimmed

    ## Make Swatch
    cd $HOME/.gvcci/themes/$trimmed
    python3 $HOME/Code/wallpapers/make-swatch.py
    cd $HOME/Code/gvcci/

    ## Write readme line
    echo "## ${trimmed}
![${trimmed}/example.html](${trimmed}/wallpaper.jpg)
![terminal colors for ${trimmed}](${trimmed}/swatch.jpg)" >> $HOME/Code/wallpapers/readme.md
  fi
done


mv $HOME/.gvcci/themes/* $HOME/Code/wallpapers

for examples in $HOME/Code/wallpapers/*/*.html; do
  sed -i -e "s+/home/jsck/wallpaper/.*.jpg+./wallpaper.jpg+g" $examples
done

for wal in $HOME/Code/wallpapers/*/wallpaper; do
  mv $wal $wal.jpg
done
