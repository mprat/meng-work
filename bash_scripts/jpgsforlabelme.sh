#!/bin/bash

while read line
do
    name=$line
    echo "$name"
    # echo ${name:0:14};
    # mkdir ~/${name:0:14}-jpgs;
    # echo /data/vision/torralba/mooc-video/videos/$name;
    # echo ~/${name:0:14}-jpgs/%08d.jpg;
    sleep 1
    ffmpeg -i "/data/vision/torralba/mooc-video/videos/$name" -f image2 -vf fps=fps=1 ~/"${name%.*}"-jpgs/%08d.jpg &
    # echo "Text read from file - $name";
done < $1