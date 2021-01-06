#!/bin/bash

# This script updates the time stamp of the file.
# This script is used to keep the file if the 
# server deletes old files.

# usage
# screen -AmdS FileKeep sh FileKeep.sh

logfile=FileKeep.log
pathdir=/mwork1/takiwkkz
 
cd ${pathdir}

while true; do

date
echo $host

date > $logfile
echo $host >> $logfile

find . -type f | xargs touch -ac

# 10 day
sleep 864000s

done
