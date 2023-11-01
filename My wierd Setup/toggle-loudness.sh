#!/bin/bash

if $(gsettings get com.github.wwmm.easyeffects bypass); then
    gsettings set com.github.wwmm.easyeffects bypass false
    # notify user
    notify-send --expire-time=1500 --urgency=normal -i audio-volume-high "Loudness Equalization" "Enabled"
else
    gsettings set com.github.wwmm.easyeffects bypass true
    notify-send --expire-time=1500 --urgency=normal -i audio-volume-muted "Loudness Equalization" "Disabled"
fi


