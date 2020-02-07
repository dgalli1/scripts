#!/bin/bash
# Syntax 30_screenshots_per_video.sh path/to/video
# first try queries the container for result
FRAME_AMOUNT=30 #minimum of frames you want to create
THUMBIMGWIDTH=600 # Width of the resulting thumbnail file
SIZELIMIT=10000 # Max size
THUMBEXTENSION=".jpg" # Could also be gif or png 
FRAMES=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 "$1")
if [ "$FRAMES" = "N/A" ]; then
    # echo "Container foramt of $1 does not support quering, counting Frames, might take some time"
    FRAMES=$(ffmpeg -i "$1" -vcodec copy -acodec copy -f null /dev/null 2>&1 | grep 'frame=' | cut -f 1 -d ' ' | cut -c7-)
fi

if ((FRAMES < FRAME_AMOUNT)); then
    echo "Video has less then 30 Frames"
    FRAME_AMOUNT=FRAMES
fi
SECONDS="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1" | cut -f 1 -d '.')"
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
PERFRAMES="$(expr $SECONDS / $FRAME_AMOUNT)"
echo $PERFRAMES
dirname=$(dirname "$1")
thumdir=${dirname}/${filename}_thumb
mkdir "$thumdir"
# you can change use png/jpg and almost every extension you desire (not webp (2020.02.02))
thumbfilepath="${dirname}/${filename}_thumb/%02d.jpg"
#create thumbnails
ffmpeg -i $1 -vf fps=1/$PERFRAMES $thumbfilepath  
for f in "$thumdir/*" ; do
    mogrify "$f" -resize $THUMBIMGWIDTH "$f"
done



foldersize=$(du "$thumdir"|cut -f 1 -d$'\t')
echo $foldersize
if (($SIZELIMIT < $foldersize)); then 
    #hopefully this never happens anyways...
    echo "30 Screenshots are to big, try to shrink them"
    #recreate original files to not get a quality loose
    ffmpeg -i $1 -vf fps=1/$PERFRAMES $thumbfilepath  
    #resize them to something smaller
    # this logic is not perfect maybe your files will still be bigger but were getting pretty close
    smallersize=$(printf '%.0f\n' $(echo "$foldersize/$SIZELIMIT*$THUMBIMGWIDTH" | bc -l))
    for f in "$thumdir/*" ; do
     mogrify "$f" -resize $smallersize "$f"
    done
else
    #create more frames
    FRAME_AMOUNT=$(printf '%.0f\n' $(echo "($SIZELIMIT/$foldersize-1)*$FRAME_AMOUNT" | bc -l))
    PERFRAMES="$(expr $SECONDS / $FRAME_AMOUNT)"
    # you can change use png/jpg and almost every extension you desire (not webp (2020.02.02))
    thumbfilepath="${dirname}/${filename}_thumb/%02d.jpg"
    #create thumbnails
    ffmpeg -i $1 -vf fps=1/$PERFRAMES $thumbfilepath  
    for f in "$thumdir/*" ; do
        mogrify "$f" -resize $THUMBIMGWIDTH "$f"
    done
fi
