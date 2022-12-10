#!/bin/bash
# Exit if No File is Specified
if [[ "$#"  ==  '0' ]]; then
echo  -e 'ERROR: No File Specified!' && exit 1
fi

SERVER=$(curl -s https://apiv2.gofile.io/getServer | jq  -r '.data|.server')

for VAR in "$@"
do
    FILE=$(realpath "$VAR")
    # continue if FILE is same as $0
    if [[ "$FILE"  ==  "$0" ]]; then
        continue
    fi
    # continue if FILE is a directory
    if [[ -d "$FILE" ]]; then
        echo -e "ERROR: $FILE is a directory!" && exit 1
    fi
    # check if folder id is set
    if [[ ! -z "$FOLDER_ID" ]]; then
        # upload file
        UPLOAD=$(curl -F "token=${GUEST_TOKEN}" -F "folderId=${FOLDER_ID}" -F "file=@${FILE}" https://${SERVER}.gofile.io/uploadFile)
    else
        UPLOAD=$(curl -F "file=@${FILE}" https://${SERVER}.gofile.io/uploadFile)
        FOLDER_ID=$(echo $UPLOAD | jq -r '.data|.parentFolder')
        GUEST_TOKEN=$(echo $UPLOAD | jq -r '.data|.guestToken')
        echo $GUEST_TOKEN
    fi
    LINK=$(echo $UPLOAD | jq -r '.data|.downloadPage')
    echo "FILELINK: $LINK"
done
echo "Directory: https://gofile.io/d/$FOLDER_ID"
echo " "





