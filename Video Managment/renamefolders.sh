 
find . -type d -name "gersub" | while read FNAME; do mv "$FNAME" "${FNAME//gersub/Season 1}"; done
