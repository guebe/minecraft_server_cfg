#!/bin/sh
# Author: Guenter Ebermann

LOCAL=$1

bail_out ()
{
    logger "minecraft backup: ERROR $?: $1"
    exit 1
}

logger "minecraft backup: stopping server"
sudo systemctl stop minecraft
sleep 60

logger "minecraft backup: tar'ing"
tar cfz "$LOCAL" -C /opt minecraft/world || bail_out "tar"

logger "minecraft backup: starting server"
sudo systemctl start minecraft

echo "$LOCAL" | grep "daily" -
if [ $? -eq 0 ]; then
    logger "minecraft backup: no rclone'ing of daily file"
else
    logger "minecraft backup: rclone'ing"
    rclone copy "$LOCAL" mydropbox:backup || bail_out "rclone"
fi

logger "minecraft backup: finished successfully"

