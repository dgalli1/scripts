#!/bin/bash
# This script will merge part ts files into one, for other formats the ffmpeg command will have to be adjusted
# It will use the fillname to find parts and sort them alphabetically
# Programmed for file names like this : XXX-000A .. XXX-000C
# usage concat_ts.bash <folder> (--delete)
# get path from argument and save to variable
path=$1
delete=false
#check if flag --delete is set as a argument
if [ "$2" == "--delete" ]; then
    delete=true
fi

# check if path is directory
if [ -d $path ]; then
    # get all files in directory
    files=$(ls $path)
    blacklist=()

    # loop through files
    find $path -type f -print0 | sort -z | while IFS= read -r -d '' file; do
        # get all the characters until first space in file name
        name=$(echo $file | sed 's:.*/::' | cut -d ' ' -f 1)
        lastcharacter=${name: -1}
        startswith=${name%?}
        # check if startswith is in blacklist
        if [[ " ${blacklist[@]} " =~ " $startswith " ]]; then
            continue
        else
            blacklist+=($startswith)
        fi
        # check if last character is a number
        if [[ $lastcharacter =~ ^[0-9]$ ]]; then     
            continue
        fi
        # check if there are more than one in part
        count=0
        ffmpegFileList=""
        while IFS= read -r -d '' part; do
            count=$((count+1))
            ffmpegFileList+="file '$part'\n"
        done < <(find $path -type f -name "$startswith*" -print0 | sort -z)
        #check if count is higher than 1
        if [ $count -gt 1 ]; then
            newname=$(echo $file | sed 's:.*/::' |  cut -d " " -f 2-)
            newname="$startswith $newname"
            # check if newname exists
            if [ -f "$path/$newname" ]; then
                #delete all parts if flag is set
                if [ $delete == true ]; then
                    find $path -type f -regextype sed -regex '.*'$startswith'[^ ].*' -print0 | sort -z | while IFS= read -r -d '' partdelete; do
                        echo rm \"$partdelete\"
                    done
                    continue
                else
                    echo "file skiped: $newname, already exists"
                    continue
                fi
            fi
            echo -e "$ffmpegFileList" | ffmpeg -f concat -safe 0  -protocol_whitelist file,pipe,crypto -i - -c copy "$newname"
        else
            echo "skipped because of single file $count $startswith"
        fi
    done
else
    echo "Path is not a directory"
fi