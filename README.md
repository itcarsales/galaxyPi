# galaxyPi
  galaxyPi will configure a Raspberry Pi to act as a home server with Pi-hole adblocking, NodeRED IOT management, and a 0.96" OLED for system info.  A toggle switch provides an interupting input to turn the screen on or off via software instead of simply cutting power.  This project does not walk a user through flashing images, or setting up wifi.  It assumes the user can image an SD card, add the blank "ssh" file, and connect to their fresh Raspbian install via SSH.  I will only touch on these steps.  I did design the project with new makers and commonly available parts in mind, so pin headers and jumper wires will work for both a breadboard, and fit inside the final, 3D printed case.
  
## Configures
- Fail2Ban and Automatic Updates (extra security)
- Pi-Hole
- NodeRED and Mosquitto

## Parts and Requirements:
- Raspberry Pi 2 or 3 with adequate Power Supply
  - I strongly recommmend a Pi2 - as it is more than enough to handle these tasks.....and puts an old device to a final use.
- 8Gb SD Card or larger
- Ethernet Connection
  - While this server will work over wifi with no code changes, I STRONGLY recommend against it.  Hardwire things your network relies on.
- Case - https://www.prusaprinters.org/prints/23922
- 0.96" OLED - SSD1306
- Toggle switch (any will do - 3 position automotive toggle is what I had a pile of in a drawer)
- Jumper wires - or soldered connections
- 4x M2x4 screws for OLED
- 4x M2.5x4 screws for Raspberry Pi
- 6x #4 3/4" screws for case

### Warning
  - It is never a good practice to blindly run random scripts from the internet.  This is a learning tool and shortcut.  Please review the comments and code.

# PART 1 - Raspbian

## Step 1)  SD Card Setup
  - Download the latest version of Raspbian Lite 
  https://www.raspberrypi.org/downloads/raspbian/ ( Raspbian Buster Lite 2020-02-13 at time of writing )
  - Image your SD card with Raspbian
  - Create a blank file and name it ```ssh``` on the boot partition (no dot, no file extension)
 
## Step 2) Initial Pi Setup
  - Insert SD Card in the Pi
  - Connect the Network Cable and Power Supply.
  - Wait a minute for it to boot, the connect via SSH (it will grab a DHCP IP Address - so I recommend checking your router to see which address was assigned)
    - ```ssh pi@PI.IP.ADDRESS.HERE```
    - Password: ```raspberry```
  - run the following command to download the setup script from this repo, then follow along with the prompts
    #MODIFY THIS
    - ```bash <(curl -Ls https://raw.githubusercontent.com/itcarsales/piHome/master/newPi.sh?token=ABN5HDN5LSZKTYAGXN5LXRC6MPOKC)```
    - Select your language, location, and timezone
      - I use ```en_US.UTF-8 UTF-8``` for US Language
  - Your Pi should complete the script and reboot automatically

## Step 3) Linux Preperation
  - Your Pi should have rebooted
  - You can now reconnect via SSH using ```piPresents``` as the new password
  - CHANGE THE PASSWORD NOW
    - type ```passwd``` and follow the prompts

## Part 1 Complete - You now have a starting point for most Raspberry Pi projects!
  - You can make changes by settings from this step by typing ```sudo raspi-config```
  - You can also modify newPi.sh to suit the config needs of your own projects


# Part 2 - Hardware

## Step 1) OLED
  - Secure the OLED to the hat using the 4x M2x4 screws
  - Connect it to the Pi following the wiring diagram below
    - It won't break anything if you mix up SCL and SDA, it just wont work.  DO NOT cross VCC and GND
      - All components can use a common ground, or any of the GPIO ground pins.  I used this wiring for simplicity and example.

  - PINOUT LINK FOR DIAGRAM

## Step 2) Switch
  - Mount the switch to the hat using its included nut and washer
  - Connect it to the Pi following the same wiring diagram as Step 1
    - All components can use a common ground, or any of the GPIO ground pins.  I used this wiring for simplicity and example.

## Part 2 Complete - Your project hat is all ready to go!

# Part 3 - Programs

## Step 1) Extra Security
  - This will install Fail2Ban and Automatic Updates with weekly reboot and clean
    - I made this an optional step, but I strongly recommend using them
  - run the following command to download the setup script
    - ```bash <(curl -Ls https://raw.githubusercontent.com/itcarsales/piHome/master/extraSecurity.sh?token=ABN5HDN2PBAU2U7DJORVDOK6MPXQU)```

## Step 2) Pi-Hole
  - run the following command to download the setup script
    - ```bash <(curl -Ls https://raw.githubusercontent.com/itcarsales/piHome/master/piHoleInstaller.sh?token=ABN5HDJC3YKMRTOFVJASOXK6MPVDO)```
  -I recommend the following choices:
    - Google or OpenDNS DNS Provider
    - Default Block Lists
    - Both IPv4 and IPv6
    - Changing the Network Settings in the next step is up to you, but I generally change it to an IP I can easily remember like .250
    - Verify your gateway address (generally your router)
    - I recommend leaving the rest of the settings on their defaults
  - The password generated by the installer will not be important
  - Your Pi should then continue the script for a few minutes, and reboot automatically
  - Verify the screen and button both work, and youre done!
  - You can reach the web UI at http://Your.IP.Address.Here/admin/ or simply http://Your.IP.Address.Here if you forget

## Step 3) NodeRED and Mosquitto
  - run the following command to download the setup script
    - ```bash <(curl -Ls https://raw.githubusercontent.com/itcarsales/piHome/master/iotInstaller.sh?token=ABN5HDIRJS7U3NTZVDYDJIC6MPZFO)```
  - Your Pi should complete the script and reboot automatically

  - Verify the server is running at http://Your.IP.Address.Here:1880
  - Chech the UI page at http://Your.IP.Address.Here:1880/ui


  <hr>

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MLRHALWRP3KJC)

bitcoin donations: 19J2vXb7Zj57fQxtGXHqmq6pFDoeW7jAVb






  