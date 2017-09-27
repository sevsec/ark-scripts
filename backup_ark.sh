#!/bin/bash

# How many days to keep rolling backups?
DAYS=7
LOGFILE=/var/log/ark_backup.log
BACKUPDIR=/var/backup
TEMPDIR=/var/tmp
ARKDIR=/home/steam/ark
FILENAME="ark-backup-$(date +%m-%d-%y_%H-%M-%S).tar.bz2"
OLDFILE="ark-backup-$(date -d "$DAYS days ago" +%m-%d-%y)*.tar.bz2"

echo "[$(date +%s)] Backup started: $FILENAME" >> "$LOGFILE"

# Copy the files so the state is static when we archive (close enough)
cd $TEMPDIR
cp -r "$ARKDIR/ShooterGame/Saved" .

cd "$BACKUPDIR"
tar -C "$TEMPDIR" -cvjf "$FILENAME" "Saved"

if [ $? -eq 0 ]; then
  echo "[$(date +%s)] tar creation successful" >> "$LOGFILE"
else
  echo "[$(date +%s)] tar creation failed, exiting." >> "$LOGFILE"
  exit -1
fi

rm -rf "$TEMPDIR/Saved"
rm "$OLDFILE"
echo "[$(date +%s)] Old files removed." >> "$LOGFILE"

# Comment if you want to skip S3-based backup
exit 0

# The following does a quick copy to S3. Remove the exit above to use.
pushd "$BACKUPDIR"
TODAYSFILES=$(sed 's/.\{17\}$//' <<< $FILENAME)
BUCKET=CHANGEME

if [ $(($(ls "$BACKUPDIR/$TODAYSFILES*" | wc -l) % 12)) -eq 0 ]; then
  echo "[$(date +%s)] s3 upload of $FILENAME started"
  aws s3 cp "$BACKUPDIR/$FILENAME.bz2" "s3://$BUCKET/" >> "$LOGFILE"
fi
