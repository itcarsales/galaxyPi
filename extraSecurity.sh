#!/bin/bash
#piPresents galaxyPi (updated for buster)
#Extra Security Module

# Update and Install
sudo apt-get update -y
sudo apt-get -y install fail2ban unattended-upgrades

# Configure Unattended-Upgrades
#sudo sed -i '/\/\/Unattended-Upgrade::Mail "root"/c\Unattended-Upgrade::Mail "root";' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '/\/\/Unattended-Upgrade::Remove-Unused-Dependencies/c\Unattended-Upgrade::Remove-Unused-Dependencies "true";' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '/\/\/Unattended-Upgrade::Automatic-Reboot/c\Unattended-Upgrade::Automatic-Reboot "true";' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i '/\/\/Unattended-Upgrade::Automatic-Reboot-Time/c\Unattended-Upgrade::Automatic-Reboot-Time "05:00";' /etc/apt/apt.conf.d/50unattended-upgrades

cat << EOT | sudo tee /etc/apt/apt.conf.d/20auto-upgrades >/dev/null
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOT

exit 0