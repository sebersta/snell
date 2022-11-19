#!/bin/bash

if cat /etc/issue | grep -q -E -i "debian|ubuntu|armbian|deepin|mint"; then 	# install dependencies
	apt-get install wget unzip -y
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
	yum install wget unzip -y
elif cat /proc/version | grep -q -E -i "arch|manjora"; then
	yes | pacman -S wget unzip
elif cat /proc/version | grep -q -E -i "fedora"; then
	dnf install wget unzip -y
fi

echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf	# enable bbr
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control

cd
ARCHITECTURE=$(dpkg --print-architecture)
wget -c https://dl.nssurge.com/snell/snell-server-v4.0.0-linux-$ARCHITECTURE.zip	# download binary
unzip -o snell-server-v4.0.0-linux-$ARCHITECTURE.zip

echo \					# create service
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
systemctl enable snell			# start service
systemctl start snell

echo
echo "Copy the following line to surge"			# print profile
echo "$(curl -s ipinfo.io/city) = snell, $(curl -s ipinfo.io/ip), $(cat snell-server.conf | grep -i listen | cut --delimiter=':' -f2), $(cat snell-server.conf |grep psk | sed 's/ //g'), version=4