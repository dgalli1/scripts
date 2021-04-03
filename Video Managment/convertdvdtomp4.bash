#!/bin/bash
cat *.VOB > moviename.vob; ffmpeg -i moviename.vob -c:a aac -ac 2 -ab 128k -vcodec libx264 -preset fast -crf 20 -threads 0 moviename.mp4
