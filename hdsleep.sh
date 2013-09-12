#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 device timeout(s)"
	echo "Example: $0 sdb 1800"
	exit
fi

DEV=$1
TIMEOUT=$2

echo `date`:hdsleep init

I=0
while true; do
	# Get status
	STATUS=`cat /proc/diskstats | grep $DEV\  | cut -d\  -f 20`

	# Check status
	if [ $STATUS -eq 0 ]; then
		I=$[$I+1]
		#echo `date`: No event detected. Increase counter.
	else
		I=0
		#echo `date` Event detected. Reset counter.
	fi

	# Suspend if necesary
	if [ $I -eq $TIMEOUT ]; then
		echo `date`: Suspending disk
		hdparm -y $DEV
	fi

	sleep 1
done
