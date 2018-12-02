#!/bin/bash

loc=$(pwd)
for theme in themes/*; do
    cd $theme 
    $loc/scripts/post-gvcci.py $loc
    cd $loc   
done
