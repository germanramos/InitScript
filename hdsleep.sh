#!/bin/bash

if [ $# -ne 3 ]; then
	echo "Usage: $0 device timeout(s) logfile"
	echo "Example: $0 sdb 1800 /tmp/hdsleep.log"
	exit
fi

DEV=$1
TIMEOUT=$2
LOGFILE=$3

cp $LOGFILE $LOGFILE.old
echo `date`:hdsleep init>$LOGFILE

I=0
while true; do
	# Get status
	STATUS=`cat /proc/diskstats | grep $DEV\  | cut -d\  -f 20`

	# Check status
	if [ $STATUS -eq 0 ]; then
		I=$[$I+1]
		#echo `date`: No event detected. Increase counter>>$LOGFILE
	else
		I=0
		echo `date` Event detected. Reset counter>>$LOGFILE
	fi

	# Suspend if necesary
	if [ $I -eq $TIMEOUT ]; then
		echo `date`: Suspending disk>>$LOGFILE
		hdparm -y /dev/$DEV
	fi

	sleep 1
done
