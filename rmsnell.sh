#!/bin/bash

systemctl stop snell.service
systemctl disable snell.service
rm /etc/systemd/system/snell.service

cd
ARCHITECTURE=$(dpkg --print-architecture)
rm snell-server-v4.0.0-linux-$ARCHITECTURE.zip
rm snell-server-v4.0.0-linux-$ARCHITECTURE
rm snell-server.conf
