#!/bin/bash
is_running=false

trap ctrl_c INT

function ctrl_c() {
    pkill xpointerbarrier
    exit
}

while true 
do 
    test=$(xdotool getwindowfocus getwindowname)
    echo $test
    if [ "$test" = "League of Legends (TM) Client" ]; then
        if ! $is_running ; then
            # top left right bottom
            # i would recommnd putting left and right on 5 pxs if you have 3 monitors
            nohup xpointerbarrier 0 5 5 0 &>/dev/null &
        fi
    else
        pkill xpointerbarrier
        is_running=false
    fi 
    sleep 0.1
done
