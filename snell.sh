#!/bin/bash
apt-get install wget unzip -y
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
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
echo "Copy the following line to surge"
echo "$(curl -s ipinfo.io/city) = snell, $(curl -s ipinfo.io/ip), $(cat snell-server.conf | grep -i listen | cut --delimiter=':' -f2), $(cat snell-server.conf |grep psk | sed 's/ //g'), version=4"

