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
cp ./config-files/hostapd.conf /etc/hostapd
cp ./config-files/hostapd /etc/default
cp ./config-files/sysctl.conf /etc
cp ./config-files/iptables.ipv4.nat /etc

touch /var/lib/misc/udhcpd.leases

service hostapd start
update-rc.d hostapd enable

service udhcpd start
update-rc.d udhcpd enable

sudo echo -e "${COL}Linux-router configured! Your computer will reboot in a few seconds.${NC}"

sleep 5
reboot

exit 0
