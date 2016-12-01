#!/bin/sh

# directories
locdir=/Users/mmp/Documents/MATLAB/mmp/ArcticMix15
pubdir=/Volumes/public/Cruises/SKQ201511S/data/mmp_data/processed

# copy directories
echo 'copying...'
rsync -a $locdir/* $pubdir/
echo "done at $(date +'%H:%M:%S / %Y-%m-%d')."


