#!/bin/bash

cd $HOME/Code/gvcci/
for wallpaper in $HOME/wallpaper/*.jpg; do
  echo $wallpaper
  trimmed=$(basename -s .jpg $wallpaper)
  echo $trimmed
  [ -e "$wallpaper" ] || continue

  if [ ! -d $HOME/Code/wallpaper-with-theme/$trimmed ]; then
    ./gvcci.sh $wallpaper
    cp ./examples.html $HOME/.gvcci/themes/$trimmed

    ## Make Swatch
    cd $HOME/.gvcci/themes/$trimmed
    python3 $HOME/Code/wallpaper-with-theme/make-swatch.py
    cd $HOME/Code/gvcci/

    ## Write readme line
    echo "## ${trimmed}
![${trimmed}/example.html](${trimmed}/wallpaper.jpg)
![terminal colors for ${trimmed}](${trimmed}/swatch.jpg)" >> $HOME/Code/wallpaper-with-theme/readme.md
  fi
done


mv $HOME/.gvcci/themes/* $HOME/Code/wallpaper-with-theme/

for examples in $HOME/Code/wallpaper-with-theme/*/*.html; do
  sed -i -e "s+/home/jsck/wallpaper/.*.jpg+./wallpaper.jpg+g" $examples
done

for wal in $HOME/Code/wallpaper-with-theme/*/wallpaper; do
  mv $wal $wal.jpg
done

./fix-color.sh
