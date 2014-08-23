#!/bin/sh

DELAY=3

echo "Ctrl+C to stop capturing time lapse footage"

while [ 1 ];
    do scrot -q 100 $(date +%Y%m%d%H%M%S).jpg;
    sleep $DELAY;
done
