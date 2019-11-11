#!/bin/bash
sudo apt-get -y install rsync
sudo cp rsyncd.conf /etc/rsyncd.conf
sudo rm /var/run/rsyncd.pid
sudo rsync --daemon
mkdir -p /home/$USER/logs/health
sudo cp rsync-pull.sh /root/
sudo crontab -u root rsync-config
