#!/bin/bash

NOW=$(date -u)
DT=$(date -u -d "$NOW + 10 minutes")
M=$(date +%M -d "$DT")
S=$(date +%S -d "$DT")
NEXT=$(date -u -d "$DT - $S seconds - $(bc <<< $M%10) minutes")
SLEEP_TIME=$(bc <<< $(date +%s -d "$NEXT")-$(date +%s -d "$NOW"))
#echo "called $SLEEP_TIME date $NOW" >> /root/scripts/log.log
sleep $SLEEP_TIME
