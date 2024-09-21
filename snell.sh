#!/bin/bash


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

# Download and install snell
cd
ARCH=$(uname -m)
BASE_URL="https://dl.nssurge.com/snell/snell-server-v4.1.1-linux"
case $ARCH in
    "x86_64")
        PACKAGE="${BASE_URL}-amd64.zip"
        ;;
    "i686" | "i386")
        PACKAGE="${BASE_URL}-i386.zip"
        ;;
    "aarch64")
        PACKAGE="${BASE_URL}-aarch64.zip"
        ;;
    "armv7l")
        PACKAGE="${BASE_URL}-armv7l.zip"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
wget $PACKAGE

if [ $? -ne 0 ]; then
    echo "Download failed!"
    exit 1
fi
unzip -o ${PACKAGE##*/} 

# Create systemd service
echo -e "[Unit]\nDescription=snell server\n[Service]\nUser=$(whoami)\nWorkingDirectory=$HOME\nExecStart=$HOME/snell-server\nRestart=always\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/snell.service > /dev/null
echo "y" | sudo ./snell-server
sudo systemctl start snell
sudo systemctl enable snell

# print snell server info
echo
echo "Copy the following line to Surge, under the [Proxy] section:" 
echo "$(curl -s ipinfo.io/city) = snell, $(curl -s ipinfo.io/ip), $(cat snell-server.conf | grep -i listen | cut --delimiter=':' -f2), psk=$(grep 'psk' snell-server.conf | cut -d= -f2 | tr -d ' '), version=4, tfo=true"
