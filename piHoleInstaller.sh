#!/bin/bash
#piPresents piHome (updated for buster)
#Pi-hole Module

# Install pi-Hole
curl -sSL https://install.pi-hole.net | bash

# Update and Install packages
sudo apt-get update -y
sudo apt-get -y install python3-dev python-smbus i2c-tools python3-pil python3-pip python3-setuptools python3-rpi.gpio git

#Enable IC2 Output
sudo raspi-config nonint do_i2c 0

# Install SSD1306 OLED
cd ~/
git clone https://github.com/adafruit/Adafruit_Python_SSD1306.git
cd Adafruit_Python_SSD1306
sudo python3 setup.py install
cd ~/
sudo rm -rf Adafruit_Python_SSD1306

# Add crontab to start at boot
crontab -l | { cat; echo "@reboot python3 /home/pi/oled.py &"; } | crontab -

# Download OLED script from repo
#EDIT THIS FOR RELEASE
curl https://raw.githubusercontent.com/itcarsales/galaxyPi/master/oled.py?token=ABN5HDJIGK3ZL3TOD2H5BES6MQCAW -o ~/oled.py

sudo reboot now
exit 0