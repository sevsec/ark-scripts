#!/bin/bash

MAP="TheIsland"
ARKDIR=/home/steam/ark
# The ARKDIR above should be set according to your installation

cd "$ARKDIR/ShooterGame/Binaries/Linux/"
./ShooterGameServer $MAP?listen -server -log -servergamelog -gameplaylogging -USEALLAVAILABLECORES -usecache -nosteamclient -automanagedmods
