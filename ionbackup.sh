#!/bin/bash
#
# Rsync backup script for IONTorrent
#

# (Added by Atze)
# Max troughput, to limit 'other' performance issues speed is in KB/s
THROTTLE=6400
PIDFILE=/var/run/ionbackup.pid
DESTINATION=ionbackup@x.x.x.x:/data/ionbackup   # fill in IP of destination server
SSHKEYLOCATION=/opt/ionbackup/ionbackup.key
# remove files older than 2 years from /data/iontorrent ( not from backup! )
REMOVEFROMARCHIVE=730

if [ -e "$PIDFILE" ] ; then
    # our pidfile exists, let's make sure the process is still running though
    PID=`/bin/cat "$PIDFILE"`
    if /bin/kill -0 "$PID" > /dev/null 2>&1 ; then
        exit 0
    fi
 fi

# create or update the pidfile
/bin/echo "$$" > $PIDFILE

# find out day of the month.
monthday=$(date '+%d')

# Backup archive location, does not delete any files at target location. ( should be kept atleast 5 years )
rsync -e 'ssh -i '$SSHKEYLOCATION --bwlimit="$THROTTLE" -avz --timeout=300 --log-file="/var/log/ionbackup/rsyncbackup.log" /data/iontorrent/ $DESTINATION/archive/

# remove files older than REMOVEFROMARCHIVE days from /data/iontorrent
find /data/iontorrent -type f -mtime +$REMOVEFROMARCHIVE -ls -exec rm -f -- {} \;

# Backup results location, delete file in destination every 1st day of the month.
if [ "$monthday" = "01" ]; then
  rsync -e 'ssh -i '$SSHKEYLOCATION --bwlimit="$THROTTLE" -avz --del --timeout=300 --log-file="/var/log/ionbackup/rsyncbackup.log" /results/ $DESTINATION/results/
else
  rsync -e 'ssh -i '$SSHKEYLOCATION --bwlimit="$THROTTLE" -avz --timeout=300 --log-file="/var/log/ionbackup/rsyncbackup.log" /results/ $DESTINATION/results/
fi

# remove PIDfile
/bin/rm -f "$PIDFILE"

