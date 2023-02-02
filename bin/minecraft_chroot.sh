#!/bin/sh
cd /opt/minecraft

sudo -u minecraft mkdir etc etc/java-17-openjdk lib lib64 proc usr usr/lib usr/lib/jvm

sudo mount --bind /etc/java-17-openjdk etc/java-17-openjdk/
sudo mount --bind /lib lib
sudo mount --bind /lib64 lib64
sudo mount --bind /usr/lib/jvm usr/lib/jvm/
sudo mount proc proc -t proc

sudo chroot --userspec minecraft:minecraft . usr/lib/jvm/java-17-openjdk-amd64/bin/java

sudo umount etc/java-17-openjdk lib lib64 proc usr/lib/jvm
