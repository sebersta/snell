#!/bin/bash

sudo systemctl stop snell.service
sudo systemctl disable snell.service
sudo rm -f /etc/systemd/system/snell.service

cd
ARCHITECTURE=$(uname -m)
rm -f snell-server-v4.0.1-linux-$ARCHITECTURE.zip
rm -f snell-server
rm -f snell-server.conf
