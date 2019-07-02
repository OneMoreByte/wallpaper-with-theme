#!/bin/bash

loc=$(pwd)

cd ./gvcci
for wallpaper in ${loc}/wallpapers/*.jpg; do
  echo $wallpaper
  trimmed=$(basename -s .jpg $wallpaper)
  echo $trimmed
  [ -e "$wallpaper" ] || continue

  if [ ! -d $loc/themes/$trimmed ]; then
    ./gvcci.sh $wallpaper
    cp ./examples.html $HOME/.gvcci/themes/$trimmed

    ## Make Swatch and other stuff
    cd $HOME/.gvcci/themes/$trimmed
    python3 $loc/scripts/post-gvcci.py $loc
    cd $loc/gvcci

    ## Write readme line
    echo "## ${trimmed}
![themes/${trimmed}/example.html](themes/${trimmed}/wallpaper-preview.jpg)
![terminal colors for themes/${trimmed}](themes/${trimmed}/swatch.jpg)" >> $loc/readme.md
  fi
done


mv $HOME/.gvcci/themes/* $loc/themes/

for examples in $loc/themes/*/*.html; do
  sed -i -e "s+/home/jsck/wallpaper/.*.jpg+./wallpaper-preview.jpg+g" $examples
done

# Clean up generic-ish named stuff
for wal in $loc/themes/*/wallpaper; do
  mv $wal $wal.jpg
done

# Make convience links for the mac side
#for theme in $loc/themes/*; do
#    name=${theme#"${loc}"}
#    ln -s $wal $loc/iterm-configs/${name}.itermcolors
#done

$loc/scripts/fix-color.sh
