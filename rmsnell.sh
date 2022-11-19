#!/bin/bash

systemctl stop snell.service
systemctl disable snell.service
rm /etc/systemd/system/snell.service

cd
ARCHITECTURE=$(dpkg --print-architecture)
rm snell-server-v4.0.0-linux-$ARCHITECTURE.zip
y | rm snell-server
rm snell-server.conf
