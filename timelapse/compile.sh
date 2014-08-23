#!/bin/sh

ls -1tr *.jpg > files.txt

mencoder -ovc x264 -oac mp3lame -mf w=1280:h=720:fps=20:type=jpg 'mf://@files.txt' -o screenlapse.avi
