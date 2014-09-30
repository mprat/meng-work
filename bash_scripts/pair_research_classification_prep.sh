#!/bin/bash

# run this inside the ed-vids directory.
for i in $(ls *.mp4 | rev | cut -c 5- | rev); do cp -r $i ~/Dropbox/pair_research/; done;