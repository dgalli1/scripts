#!/bin/bash
for var in "$@"
do
    TITLE="$(ffprobe -v error -show_format -show_streams "$var" | grep TAG:title= | cut -d '=' -f 2)"
    if [ -z "$TITLE" ]
    then
        echo "$var has no title, skipping"
    else
        new_filename="$TITLE.$(echo $var | cut -d "." -f2)"
        if [ "$new_filename" = "$var" ]; then
            echo "Skipping filename is identical"
        else
            read -p "Overwritte $var with $TITLE? [y/N]" -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                mv "$var" "$TITLE.$(echo $var | cut -d "." -f2)"
                # do dangerous stuff
            fi
        fi
    fi
done