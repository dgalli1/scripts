#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

DIR="$1"
BASENAME=$(basename "$DIR")

sessionId=$(qdbus6 org.kde.yakuake /yakuake/sessions addSession)

settab() {
  local tabnum="$1"
  local title="$2"
  qdbus6 org.kde.yakuake /yakuake/tabs setTabTitle "$tabnum" "$title" >/dev/null 2>&1
}

settab "$sessionId" "$BASENAME"

terminalId=$(qdbus6 org.kde.yakuake /yakuake/sessions terminalIdsForSessionId "$sessionId")
terminalId=$(echo "$terminalId" | cut -d',' -f1)

qdbus6 org.kde.yakuake /yakuake/sessions runCommandInTerminal "$terminalId" "cd \"$DIR\""

sleep 0.1

qdbus6 org.kde.yakuake /yakuake/window toggleWindowState
