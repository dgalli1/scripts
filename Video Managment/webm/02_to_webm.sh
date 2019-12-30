#!/bin/bash
for var in "$@"
do
    TITLE="$(ffprobe -v error -show_format -show_streams "$var" | grep TAG:title= | cut -d '=' -f 2)"
    new_filename="$(echo $var | cut -d "." -f1).webm"

    ffmpeg -i "$var" -vcodec libvpx -acodec libvorbis "$new_filename"
done