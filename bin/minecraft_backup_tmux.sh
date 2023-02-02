#!/bin/sh
# Author: Guenter Ebermann

SESSION="0:0" # tmux session of server console
REMOTE="mydropbox:backup" # remote account name
LOCAL="/home/debian/minecraft_world.tgz" # local backup name

bail_out ()
{
    logger "$0 - ERROR $?: $1"
    exit 1
}

tmux_send ()
{
    tmux send-keys -t "$SESSION" "$1" ENTER || bail_out "tmux $1"
}

logger "$0 - starting backup"
tmux_send "/save-off"
tmux_send "/save-all"
sleep 60

logger "$0 - tar'ing to $LOCAL"
tar cfz "$LOCAL" -C /opt minecraft/world || bail_out "tar"

logger "$0 - rclone'ing to $REMOTE"
rclone copy "$LOCAL" "$REMOTE" || bail_out "rclone"

tmux_send "/save-on"
logger "$0 - finished backup successfully"

