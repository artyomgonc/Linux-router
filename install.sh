#!/bin/bash

COL='\033[1;33m'
NC='\033[0m'

sudo echo -e "${COL}Starting...${NC}"

apt-get -y -qq update
apt-get -y -qq install hostapd udhcpd

readonly CONFIG_FILES=(/etc/udhcpd.conf
	/etc/default/udhcpd
	/etc/network/interfaces
	/etc/hostapd/hostapd.conf
	/etc/default/hostapd
	/etc/sysctl.conf
	/etc/iptables.ipv4.nat)

for c in ${CONFIG_FILES[*]};
do
	if [ -f ${c} ]
	then
		cp -i ${c} ${c}.old
	fi
done

cp ./config-files/udhcpd_opendns.conf /etc/udhcpd.conf
cp ./config-files/udhcpd /etc/default
cp ./config-files/udhcpd.service /lib/systemd/system/

systemctl enable udhcpd.service

cp ./config-files/interfaces /etc/network

_PASSWORD1="0"
_PASSWORD2="1"
echo -e "${COL}
read -r -p "Enter name of your network (SSID): " _SSID
echo
read -r -s -p "Enter a new password at least 8 characters long (length is not checked): " _PASSWORD1
echo
read -r -s -p "Repeat your password again: " _PASSWORD2
echo
while [ ${_PASSWORD1} != ${_PASSWORD2} ]
do
	echo "Passwords are different. Try again."\
	echo
	read -r -s -p "Please enter a new password at least 8 characters long (length is not checked): " _PASSWORD1
	echo
	read -r -s -p "Please enter the new password again: " _PASSWORD2
	echo
done

echo -e "${NC}"

CONTENTS=$(<./config-files/hostapd.conf)
CONTENTS=${CONTENTS//wpa_passphrase=12345678/wpa_passphrase=${_PASSWORD1}}
CONTENTS=${CONTENTS//ssid=Linux-Router/ssid=${_SSID}}
echo "${CONTENTS}" > /etc/hostapd/hostapd.conf

cp ./config-files/hostapd /etc/default
cp ./config-files/sysctl.conf /etc
cp ./config-files/iptables.ipv4.nat /etc

touch /var/lib/misc/udhcpd.leases

service hostapd start
update-rc.d hostapd enable

service udhcpd start
update-rc.d udhcpd enable

echo -e "${COL}Linux-router configured! Your computer will reboot in a few seconds.${NC}"

sleep 5
reboot

exit 0
