#!/bin/bash
winid=$(xdotool getactivewindow)
maxSize=$(xdotool getdisplaygeometry)
eval "$(xdotool getwindowgeometry --shell $winid)"
screen=$(expr $X / 1920)
offsetPos="$(($screen*1920))"
xdotool windowmove $winid $offsetPos 0
xdotool windowsize $winid $maxSize
