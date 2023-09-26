#!/bin/bash

# Check if script is run as root and exit if it is
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run it as a regular user." 
    exit 1
fi

sudo systemctl stop snell.service
sudo systemctl disable snell.service
sudo rm -f /etc/systemd/system/snell.service

cd
ARCHITECTURE=$(dpkg --print-architecture)
rm -f snell-server-v4.0.1-linux-$ARCHITECTURE.zip
rm -f snell-server
rm -f snell-server.conf
