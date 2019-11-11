#!/bin/bash
sudo apt-get -y install rsync
sudo cp rsyncd.conf /etc/rsyncd.conf
sudo rsync --daemon
mkdir -p /home/$USER/logs/health
# Change the IP address to lure's and change 'health' to the lure type
rsync -rtu --delete rsync://ubuntu@3.133.213.19/logs ~/logs/health
chmod +x rsync-pull.sh
sudo cp rsync-pull.sh /root/
sudo crontab -u root /root/rsync-config
