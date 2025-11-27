#!/bin/bash

echo "this is function"

#to make a function

function welcomenote(){
        echo "welcome"
        LIST=$(ls)
        WORKDIR=$(pwd)
        echo "Files: $LIST"
        echo "Directory: $WORKDIR"
}

#to call a function

welcomenote