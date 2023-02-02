
This README shows how to configure and run a public minecraft server. The
server process is run via systemd using an unpriviledged system user and the
world is backuped nightly. Moreover the server console can be accessed locally
using mcrcon. A firewall is configured to only allow essential ports.

Update Linux after fresh install
```console
# update
apt update
apt upgrade
apt autoremove
update-alternatives --config editor # select highest up vim
shutdown -r now
```

Create a swapfile if no swap is configured
```console
swapon -s # this is used to check if swap is already available
fallocate -l 2g /swap # make at least as big as memory
chmod 0600 /swap 
mkswap /swap
swapon /swap
echo '/swap none swap defaults 0 0' | tee -a /etc/fstab
free -m # to show swap usage
```

Configure ssh keys
```console
ssh-keygen # do this at your main machine
scp pubkey servername:.ssh/authorized_keys
```

switch ssh to non-standard port
```console
sudo vi /etc/ssh/sshd_config # change Port to 23000
sudo systemctl restart ssh.service
```

Configure a firewall
```console
apt install ufw
ufw default deny
ufw limit 23000/tcp # we later start shd on this port
ufw limit 25565/tcp
ufw enable
ufw status verbose
```

Install the minecraft server
```console
sudo apt install openjdk-17-jre-headless tmux
sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft
tmux # from now on minecraft lives in tmux so we can attach upon ssh disconnects
su minecraft
cd /opt/minecraft
wget https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar
java -Xmx1024M -Xms1024M -jar server.jar nogui
vi eula.txt # set to true
vi server.properties # enable white-list, force-whitelist, rcon and set rcon password
java -Xmx1024M -Xms1024M -jar server.jar nogui # stop with /stop
```

Enter the following commands in the minecraft console for a basic setup
```console
/whitelist on
/gamemode keepInventory true
/op <insert_server_operator_user_here>
```

Afterwards edit manually to give proper operator level. See
https://minecraft.fandom.com/de/wiki/Server.properties#ops.json
```console
sudo -u minecraft vi /opt/minecraft/ops.json
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

