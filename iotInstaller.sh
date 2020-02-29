#!/bin/bash
#piPresents galaxyPi (updated for buster)
#IOT Module

# Add keys for Mosquitto
wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
sudo apt-key add mosquitto-repo.gpg.key

# Install Apt List
cd /etc/apt/sources.list.d/
sudo wget http://repo.mosquitto.org/debian/mosquitto-buster.list
cd ~

# Update and Install
sudo apt-get -y update
sudo apt-get -y install mosquitto nodered
sudo systemctl enable nodered.service

sudo reboot now
exit 0