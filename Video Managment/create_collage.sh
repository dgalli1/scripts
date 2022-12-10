#!/bin/bash
#usage: ./collage_script.sh video.mp4 collage.jpg
input_video=$1
output_collage=$2

total_frames=$(mediainfo --Output="Video;%FrameCount%" $input_video)
#get fps of video
fps=$(mediainfo --Output="Video;%FrameRate%" $input_video)

numframes=21
# calculate duration of video in seconds

#create tmp directory if it doesn't exist

mkdir -p /tmp/collage
rm /tmp/collage/*
#generate 20 screenshots evenly spaced throughout the video
#ffmpeg get duration get lenght of video in seconds

rate=$(echo "scale=0; $total_frames/$numframes" | bc)
ffmpeg -i "$input_video" -f image2 -vf "select='not(mod(n,$rate))'" -frame_pts 1 -vframes $numframes -fps_mode vfr /tmp/collage/out-%06d.png

rm /tmp/collage/out-000000.png

mogrify -resize 400x /tmp/collage/out*.png
# loop through all created files
for file in /tmp/collage/out*.png; do
    frame=$(echo "$file" | cut -d"-" -f2 | cut -d"." -f1)
    
    # get timecode of frame
    timecode=$(echo "scale=2; $frame/$fps" | bc)
    #convert timecode to format 00:00:00
    timecode=$(date -d@$timecode -u +%H:%M:%S)
    # add timecode to image
    convert "$file" -gravity SouthEast -font Noto-Sans-Mono-Medium \
     -pointsize 24 \
          -stroke '#000C' -strokewidth 3 -annotate +4-2 "$timecode" \
          -stroke  none   -fill white    -annotate +4-2 "$timecode" \
      "$file"
done
    #remove first screenshot as this is usually a black frame

#create collage with 4 rows and 5 columns

montage /tmp/collage/out*.png -geometry 400x\>+2+2 -tile 5x4 /tmp/collage/collage.png


#get video duration
duration=$(mediainfo --Inform="Video;%Duration/String3%" "$input_video")
#get video size
size=$(mediainfo --Output="General;%FileSize/String3%" "$input_video")
#get video resolution
resolution=$(mediainfo --Output="Video;%Width% x %Height%" "$input_video")
#get video codec
codec=$(ffprobe -v error -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$input_video" | sed ':a;N;$!ba;s/\n/ \/ /g')
#get video bitrate
bitrate=$(mediainfo --Output="Video;%BitRate/String%" "$input_video")


convert /tmp/collage/collage.png \
    -background White \
    -font Noto-Sans-Medium \
    -gravity West \
    -pointsize 32 label:"File: $(basename "$input_video")\nSize: $size\nLength: $duration\nResolution: $resolution\nCodec: $codec\nBitrate: $bitrate\nFramerate: $fps" +swap \
    -append "$output_collage"

rm /tmp/collage/*
#xdg-open "$output_collage"
echo "Collage created successfully at $output_collage"
