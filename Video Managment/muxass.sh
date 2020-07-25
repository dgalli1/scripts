#!/bin/bash
#Theoractily also works for srt (just make sure to remove -r from sort)
#Also this works only if their no other subs already in the file, otherwhise you have to edite the mapping
ls | grep .ass | cut -d'.' -f1 | while read i;  do   find . -iname "$i.mkv" -o -iname "$i.ass" | sort -r | awk 'BEGIN{ RS = "" ; FS = "\n" }{print "ffmpeg -i \"" $1 "\" -i \"" $2 "\" -c:v copy -c:a copy -c:s copy -map 0:0 -map 0:1 -map 1:0 -y tempfile.mkv && rm \"" $2 "\" \"" $1 "\" && mv tempfile.mkv \"" $1 "\"" }' | bash;  done
