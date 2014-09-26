#!/bin/bash

for i in $(ls *.mp4); do
	n=${i: -15}
	mv $i $n
done
