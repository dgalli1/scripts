#!/bin/bash
cd /home/damian/git/matrix-docker-ansible-deploy/

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Matrix is Up-to-date"
elif [ $LOCAL = $BASE ]; then
    git pull
    echo "Check Changelog for manual changes & press enter once your ready"
    echo "https://github.com/spantaleev/matrix-docker-ansible-deploy/blob/master/CHANGELOG.md"
    
    while [ true ] ; do
    read -t 3 -n 1
    if [ $? = 0 ] ; then
    exit ;
    else
    echo "waiting for the keypress"
    fi
    done
    ansible-playbook -i inventory/hosts setup.yml --tags=stop
    ansible-playbook -i inventory/hosts setup.yml --tags=setup-all
    ansible-playbook -i inventory/hosts setup.yml --tags=start
    echo "Updated Matrix"
elif [ $REMOTE = $BASE ]; then
    echo "Matrix Local changes conflict"
else
    echo "Diverged branch error"
fi


echo "Now Updating all Docker Containers"
export TZ=UTC # force all timestamps to be in UTC (+00:00 / Z)
printf -v now '%(%s)T'
start_date_epoch=$(now)
printf -v start_date_iso8601 '%(%Y-%m-%dT%H:%M:%S+00:00)T' "$start_date_epoch"

# Declare an array of string with type
declare -a StringArray=("auth-stack" "bitwarden" "filerun" "languagetool" "media-stack" "monitoring"  "stasher" )
 
# Iterate the string array using for loop
for val in ${StringArray[@]}; do
   cd /data
   echo Now Updating $val
   cd $val
   docker-compose pull
   docker-compose up -d
done
while IFS= read -r -d '' name; do
  names+=( "$name" )
done < <(
    docker container ls --format="{{.Names}}" | xargs -n1 docker container inspect | jq -j --arg start_date "$start_date_iso8601" '.[] | select(.State.StartedAt > $start_date) | (.Name, "\u0000")'
)
echo "now Updating the system"
apt update
apt upgrade

echo "Updated those containers:"
for containername in ${names[@]}; do
    #if string does not contain matrix
    if [[ $containername != *"matrix"* ]]; then
        echo $containername
    fi
done



if [ -f /var/run/reboot-required ] 
then
    echo "[*** Hello $USER, you must reboot your machine ***]"
fi
