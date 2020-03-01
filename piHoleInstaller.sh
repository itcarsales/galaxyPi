#!/bin/bash
#piPresents galaxyPi (updated for buster)
#Main Module

if ! [ $(id -u) -ne 0 ]; then
	echo "Setup cannot be run with sudo"
	exit 1
fi

echo && read -p "Would you like to install galaxyPi? (y/n)" -n 1 -r -s installRPI && echo
if [[ $installRPI != "Y" && $installRPI != "y" ]]; then
	echo "galaxyPi install cancelled."
	exit 1
fi

# Update and Install packages
sudo apt-get update -y
sudo apt-get -y install fail2ban unattended-upgrades python3-dev python-smbus i2c-tools python3-pil python3-pip python3-setuptools python3-rpi.gpio git

# Configure Unattended-Upgrades
sudo sed -i '/\/\/Unattended-Upgrade::Remove-Unused-Dependencies/c\Unattended-Upgrade::Remove-Unused-Dependencies "true";' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '/\/\/Unattended-Upgrade::Automatic-Reboot/c\Unattended-Upgrade::Automatic-Reboot "true";' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '/\/\/Unattended-Upgrade::Automatic-Reboot-Time/c\Unattended-Upgrade::Automatic-Reboot-Time "05:00";' /etc/apt/apt.conf.d/50unattended-upgrades

cat << EOT | sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOT

#Enable IC2 Output
sudo raspi-config nonint do_i2c 0

# Install SSD1306 OLED
cd /home/pi/
git clone https://github.com/adafruit/Adafruit_Python_SSD1306.git
cd Adafruit_Python_SSD1306
sudo python3 setup.py install
cd /home/pi/
sudo rm -rf /home/pi/Adafruit_Python_SSD1306

# Add crontab to start at boot
crontab -l | { cat; echo "@reboot python3 /home/pi/galaxyOLED.py &"; } | crontab -

# Download OLED script from repo
curl https://raw.githubusercontent.com/itcarsales/galaxyPi/master/galaxyOLED.py -o ~/galaxyOLED.py

# Install pi-Hole
curl -sSL https://install.pi-hole.net | bash

# Restart Pi
sudo reboot now
exit 0