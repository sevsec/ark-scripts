#!/bin/bash

INTERFACE=eth0
IP=$(ifconfig $INTERFACE | grep -oP "inet addr:(\d{1,3}\.){3}\d" | grep -oP "(\d{1,3}\.){3}\d")
STEAMDIR=/home/steam
ARKDIR=/home/steam/ark/
LOGFILE=/var/log/ark_update.log
STEAMLOGFILE=/var/log/ark_update_steam.log

if ! [[ "$IP" =~ /([0-9]{1,3}\.){3}[0-9]{1,3}/ ]]; then
  echo "$(date +%m-%d-%Y) $(date +%H:%M:%S) Could not grab local IP address, exiting ..."
  exit -1
fi

if [[ $(netstat -paun | grep Shooter | grep "$IP" | wc -l) -eq 0 ]]; then
  echo "$(date +%m-%d-%Y) $(date +%H:%M:%S) Ark Server updating ..." >> "$LOGFILE"
  killall -s 2 ShooterGameServer
  sleep 5
  pushd "$STEAMDIR"
  ./steamcmd.sh +login anonymous +force_install_dir /home/steam/ark +app_update 376030 validate +quit >> "$STEAMLOGFILE"
  ./steamcmd.sh +login anonymous +force_install_dir /home/steam/ark-se +app_update 376030 validate +quit >> "$STEAMLOGFILE"
  echo "$(date +%m-%d-%Y) $(date +%H:%M:%S) Ark Server updated. Starting ..." >> "$LOGFILE"
  ./ark_start.sh &
  echo "Done."  >> "$LOGFILE"
  popd
  exit 
elif [[ $(netstat -paun | grep Shooter | grep "$IP" | wc -l) -gt 0 ]]; then
  echo "$(date +%m-%d-%Y) $(date +%H:%M:%S) Ark Server occupied, no updates applied." >> "$LOGFILE"
  exit 2
else
  echo "$(date +%m-%d-%Y) $(date +%H:%M:%S) Ark Server DEAD? Restarting ..." >> "$LOGFILE"
  killall -s 2 ShooterGameServer
  sleep 5
  pushd "$STEAMDIR"
  ./ark_start.sh &
  echo "Done."  >> "$LOGFILE"
  popd
  exit 1
fi
