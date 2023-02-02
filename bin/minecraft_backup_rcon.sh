#!/bin/sh
# Author: Guenter Ebermann

MCRCON_HOST="127.0.0.1"
MCRCON_PORT="25575"
MCRCON_PASS="change_then_enable"
LOCAL="/home/debian/minecraft_world.tgz"

bail_out ()
{
    logger "minecraft backup: ERROR $?: $1"
    exit 1
}

rcon ()
{
    /usr/local/bin/mcrcon "$1"
}

logger "minecraft backup: starting ..."
LOG=`rcon "save-off"` || bail_out "save-off"
logger "minecraft backup: $LOG"
LOG=`rcon "save-all"` || bail_out "save-all"
logger "minecraft backup: $LOG"
sleep 30

logger "minecraft backup: tar'ing ..."
tar cfz "$LOCAL" -C /opt minecraft/world || rcon "save-on"; bail_out "tar"

logger "minecraft backup: rclone'ing ..."
rclone copy "$LOCAL" mydropbox:backup || rcon "save-on"; bail_out "rclone"

LOG=`rcon "save-on"` || bail_out "save-on"
logger "minecraft backup: $LOG"
logger "minecraft backup: finished successfully"

