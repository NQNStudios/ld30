#!/bin/sh

FRAMES="*.jpg"
FILES="files.txt"
VIDEO="screenlapse.avi"

for FRAME in $FRAMES; do
    rm "$FRAME"
done

if [ -e "$FILES" ]; then 
    rm "$FILES"
fi

if [ -e "$VIDEO" ]; then
    rm "$VIDEO"
fi
