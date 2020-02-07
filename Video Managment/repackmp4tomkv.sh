find . -iname '*.mp4' -exec bash  -c 'ffmpeg -i "$0" -c copy "${0/mp4/mkv}"' {} \;
find . -iname '*.mp4' -exec rm -f {} \;
