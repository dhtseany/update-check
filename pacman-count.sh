#!/bin/bash
#Original author credit goes to HiImTye from the Arch Linux forums
#Built upon by Sean Snell
#Version 1.0.1

LOG_DIR=/var/log/update-check

DATE=$(date)
DOW=$(date +%u)
WEEK=$(date +%V)
MONTH=$(date +"%m")
YEAR=$(date +"%y")

# Check if LOG_DIR exists; if not create it
if [[ ! -d $LOG_DIR ]]
        then
                mkdir -p $LOG_DIR
        else
                echo &>/dev/null
fi

# Daily Log File clean up rotation to prevent failing RMM Daily Safety Checks.
# Comment out the next if statement to disable.
if [[ -f $LOG_DIR/backup.log ]]
        then
                mv $LOG_DIR/backup.log
$LOG_DIR/$YEAR-$MONTH-"$(($DOW-1))"-backup.log
        else
                touch $LOG_DIR/backup.log
fi
# End Log File rotation

pacmanUpdates=$(pacman -Syup | grep http:// | wc -l)
aurUpdates=$(yaourt -Qua | grep aur | wc -l)

if [ "$pacmanUpdates" -gt 0 ];
    then
        updateCount="$pacmanUpdates"
    elif [ "$aurUpdates" -gt 0 ];
        then
            updateCount="A$aurUpdates"
        else
            updateCount=0
fi

echo "$updateCount" > $LOG_DIR/updateCount.log
