#!/bin/bash 
echo 1
borderxl=$1
borderyu=$2

borderxr=$3
borderyd=$4

check=0

if [ $borderxl -gt $borderxr ]
then
	check=1
fi

if [ $borderyu -gt $borderyd ]
then
	check=1
fi
if [ $check -ge "1" ]
then
	echo "Make sure the first coordinate pair refers to the upper left corner"
	echo "and the second pair refers to the lower right one."
fi

if [ $check -lt "1" ]
then
	while [ true ]
	do
		check=0
		xpos=`xdotool getmouselocation | awk '{ print $1}'`
		xpos=${xpos:2}
		#xpos=`getcurpos | awk '{ print $1}'`
		ypos=`xdotool getmouselocation | awk '{ print $2}'`
		ypos=${ypos:2}
		#ypos=`getcurpos | awk '{ print $2}'`
		
		if [ $xpos -gt $borderxr ]
		then
			check=1
			xpos=$borderxr
		fi
	
		if [ $ypos -gt $borderyd ]
		then
			check=1
			ypos=$borderyd
		fi
	
		if [ $xpos -lt $borderxl ]
		then
			check=1
			xpos=$borderxl
		fi
	
		if [ $ypos -lt $borderyu ]
		then
			check=1
			ypos=$borderyu
		fi
	
	
		if [ $check -ge "1" ]
		then
			xdotool mousemove $xpos $ypos
		fi
	done	
fi
