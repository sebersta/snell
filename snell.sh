#!/bin/bash

# Check if script is run as root and exit if it is
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run it as a regular user." 
    exit 1
fi

# Install dependencies based on the Linux distribution
if cat /etc/*-release | grep -q -E -i "debian|ubuntu|armbian|deepin|mint"; then
    sudo apt-get install wget unzip dpkg -y
elif cat /etc/*-release | grep -q -E -i "centos|red hat|redhat"; then
    sudo yum install wget unzip dpkg -y
elif cat /etc/*-release | grep -q -E -i "arch|manjaro"; then
    sudo pacman -S wget dpkg unzip --noconfirm
elif cat /etc/*-release | grep -q -E -i "fedora"; then
    sudo dnf install wget unzip dpkg -y
fi

# Enable BBR
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo sysctl net.ipv4.tcp_available_congestion_control

cd
ARCHITECTURE=$(uname -m)
wget -c https://dl.nssurge.com/snell/snell-server-v4.0.1-linux-$ARCHITECTURE.zip
unzip -o snell-server-v4.0.1-linux-$ARCHITECTURE.zip

# Create systemd service
echo -e "[Unit]\nDescription=snell server\n[Service]\nUser=root\nWorkingDirectory=/root\nExecStart=/root/snell-server\nRestart=always\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/snell.service > /dev/null
echo "y" | sudo ./snell-server
sudo systemctl start snell
sudo systemctl enable snell

# Print profile
echo
echo "Copy the following line to surge"
echo "$(curl -s ipinfo.io/city) = snell, $(curl -s ipinfo.io/ip), $(cat snell-server.conf | grep -i listen | cut --delimiter=':' -f2),psk=$(grep 'psk' snell-server.conf | cut -d= -f2 | tr -d ' '), version=4, tfo=true"
