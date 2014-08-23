#!/bin/sh

if [ ! -d bin ]; then
    mkdir bin
fi

mv data src

cd src

zip -r one.love *

mv one.love ../bin

mv data ../

