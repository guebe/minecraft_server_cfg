

Manually start the minecraft server in a tmux session
with recommended flags. The script also traps
"Control-C" so that you do not stop the server
accidentally. Use command /stop to stop the server.
```console
sudo -u minecraft aikar.sh
```

Install mcrcon client
```console
sudo apt install git build-essential
git clone https://github.com/Tiiffi/mcrcon.git
cd mcrcon/
make
sudo make install
man mcrcon
```

Install and setup rclone (I use dropbox to backups world)
```console
sudo apt install rclone
rclone config
```

Manually do a backup
```console
tar cfz minecraft_world_test.tgz -C /opt minecraft/world
rclone copy minecraft_world_test.tgz mydropbox:backup
```

Restore a backup
```console
cd /opt
sudo -u minecraft rm -rf minecraft/world
sudo -u minecraft tar xfz /home/debian/minecraft_world.tgz 
```

Check server status
```console
systemctl status minecraft
```

