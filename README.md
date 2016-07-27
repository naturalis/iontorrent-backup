iontorrent-backup
===================

Backup shell script for IonTorrent based on Rsync
- Script syncs results and archive directory to destination server. 
- results directory deleted files are purged only on the first day of the month to be able to get a little bit of history.
- archive directory is never purged, data should be kept in backup for atleast 6 years.


Installation
-------------
On server: 
- Create or use server used for destination.
- Create user on server (ionbackup) and create SSH key pair + put public key in authorized_keys on server and private key at SSHKEYLOCATION
On client: 
- Copy files in logrotate.d to /etc/logrotate.d
- Create directory /var/log/ionbackup
- Create cronjob and add :  0 19 * * * /opt/ionbackup/ionbackup.sh or another time if you prefer.


Parameters
-------------
Parameters are set in ionbackup.sh

```
THROTTLE=6400                                           # throttle max throughput in KB/s
PIDFILE=/var/run/ionbackup.pid                          # PID file location
DESTINATION=ionbackup@x.x.x.x:/data/ionbackup           # Server destination string replace x.x.x.x by DNS name or IP
SSHKEYLOCATION=/opt/ionbackup/ionbackup.key             # Location of private key used for SSH connection to destination
```


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>
