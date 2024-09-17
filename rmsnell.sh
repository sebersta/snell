#!/bin/bash

sudo systemctl stop snell.service
sudo systemctl disable snell.service
sudo rm -f /etc/systemd/system/snell.service

cd
rm -f rm snell-server-v4*
rm -f snell-server
rm -f snell-server.conf
