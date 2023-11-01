#!/bin/bash
#usage: ./collage_script.sh video.mp4 collage.jpg
input_video=$1
output_collage=$2

total_frames=$(mediainfo --Output="Video;%FrameCount%" "$input_video")
#check if total_frames is empty
if [ -z "$total_frames" ]; then
    echo "Error: Could not get total frames of video, fallback to packages"
    total_frames=$(ffprobe -show_packets  "$input_video"   2>/dev/null | grep video | wc -l)
    if [ -z "$total_frames" ]; then
        echo "Error: Could not get total frames of video, fallback didn't work either"
        exit 1
    fi
fi

#get fps of video
fps=$(mediainfo --Output="Video;%FrameRate%" "$input_video")

#check if fps is empty
if [ -z "$fps" ]; then
    #needed for variable bitrate media, it will just be a guess, but should be good enough for some timestamps
    echo "Error: Could not get fps of video"
    echo "Guess timestamps by total frames and duration"
    # get duration in seconds
    duration=$(mediainfo --Inform="Video;%Duration%" "$input_video")
    duration=$(echo "scale=2; $duration/1000" | bc)
    fps=$(echo "scale=2; $total_frames/($duration)" | bc)
    if [ -z "$fps" ]; then
        echo "Error: Could not get fps of video, fallback didn't work either"
        exit 1
    fi
fi
numframes=21

#create tmp directory if it doesn't exist

mkdir -p /tmp/collage
rm /tmp/collage/*
#generate 20 screenshots evenly spaced throughout the video
#ffmpeg get duration get lenght of video in seconds

rate=$(echo "scale=0; $total_frames/$numframes" | bc)
ffmpeg -i "$input_video" -f image2 -vf "select='not(mod(n,$rate))'" -frame_pts 1 -vframes $numframes -fps_mode vfr /tmp/collage/out-%06d.png

# get first file from /tmp/collage/ and remove it
first_file=$(ls /tmp/collage/ | head -n 1)

# remove first file
rm "/tmp/collage/$first_file"

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
