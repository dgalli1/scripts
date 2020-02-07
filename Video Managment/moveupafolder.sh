#!/bin/bash
#Moves file called video.mkv up a folder and renames the file to the name of the folder
find . ! -path . -type d -exec echo mv -n -- {}/video.mkv {}.mkv \; -empty -delete
