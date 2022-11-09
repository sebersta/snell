#!/bin/bash
apt-get install wget unzip -y
cd
wget -c https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-amd64.zip
unzip -o snell-server-v4.0.0-linux-amd64.zip
echo \
	'[Unit]
Description=snell server
[Service]
User=root
WorkingDirectory=/root
ExecStart=/root/snell-server
Restart=always
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/snell.service
y | ./snell-server
systemctl enable snell
systemctl start snell
echo
echo "Snell service is set up succesfully. Copy the following line to surge"
echo "$(curl -s ipinfo.io/city) = snell, $(curl -s ipinfo.io/ip), $(cat snell-server.conf | grep -i listen | cut --delimiter=':' -f2), $(cat snell-server.conf |grep psk | sed 's/ //g'), version=4"

