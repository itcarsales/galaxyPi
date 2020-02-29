#!/bin/bash
# piPresents newPi - galaxyPi - Raspberry Pi Initialization Script
# by Nick Haley

if ! [ $(id -u) -ne 0 ]; then
	echo "Setup cannot be run with sudo"
	exit 1
fi

echo && read -p "Would you like to initialize you raspberry pi? (y/n)" -n 1 -r -s installRPI && echo
if [[ $installRPI != "Y" && $installRPI != "y" ]]; then
	echo "newPi install cancelled."
	exit 1
fi

# Set Hostname
rHostname="galaxyPi"
sudo raspi-config nonint do_hostname $rHostname

# Set Password
(echo "raspberry" ; echo "piPresents" ; echo "piPresents") | passwd

# Select Location
sudo dpkg-reconfigure locales

# Select Timezone
sudo dpkg-reconfigure tzdata

# Set GUI and Autologin
sudo raspi-config nonint do_boot_behaviour B2

# Disable Splash Screen on Boot
sudo raspi-config nonint do_boot_splash 1

# Enable SSH Server
sudo raspi-config nonint do_ssh 0

# Expand File System
sudo raspi-config --expand-rootfs
echo "File System expanded"

# COMPLETE - Reboot
echo "Complete: Rebooting Now"
sudo reboot now
exit 0
