#!/bin/bash
# check if ~/.config/kwinrc contains Meta=
if [ -f ~/.config/kwinrc ]; then
    if grep -q "Meta=" ~/.config/kwinrc; then
        kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta --delete
    else
        kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""
    fi
fi
qdbus org.kde.KWin /KWin reconfigure
