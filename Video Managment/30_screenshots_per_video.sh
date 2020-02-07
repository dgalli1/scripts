#!/bin/bash
# Syntax 30_screenshots_per_video.sh path/to/video
# first try queries the container for result
FRAME_AMOUNT=30
FRAMES="$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $1)"
if [ "$FRAMES" = "N/A" ]; then
    # echo "Container foramt of $1 does not support quering, counting Frames, might take some time"
    FRAMES="$(ffmpeg -i $1 -vcodec copy -acodec copy -f null /dev/null 2>&1 | grep 'frame=' | cut -f 1 -d ' ' | cut -c7-)"
fi
SECONDS="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1 | cut -f 1 -d '.')"
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
PERFRAMES="$(expr $SECONDS / $FRAME_AMOUNT)"
echo $PERFRAMES
dirname=$(dirname "$1")
mkdir ${dirname}/${filename}_thumb
# you can change use png/jpg and almost every extension you desire (not webp (2020.02.02))
thumbfilepath="${dirname}/${filename}_thumb/%02d.png"
echo $thumbfilepath
#create thumbnails
ffmpeg -i $1 -vf fps=1/$PERFRAMES $thumbfilepath