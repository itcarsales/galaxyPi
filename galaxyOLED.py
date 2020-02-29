# Standard libraries
import RPi.GPIO as GPIO
import time
import math
import json
import requests
import subprocess

# Graphics libraries
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

# Adafruit library for I2C OLED screen
import Adafruit_SSD1306

# Define GPIO pins used by switch
GPIO.setmode(GPIO.BCM)
SWITCH = 17

# set up GPIO channels  
GPIO.setup(SWITCH, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Set delays
screen_delay = 12
boot_delay = 20

# 128x64 display with hardware I2C:
# disp = Adafruit_SSD1306.SSD1306_128_32(rst=None)
disp = Adafruit_SSD1306.SSD1306_128_64(rst=None)

# Initialize display.
disp.begin()

# Clear display.
disp.clear()
disp.display()

# Create blank image for drawing - based on device width and height.
# Make sure to create image with mode '1' for 1-bit color.
width = disp.width
height = disp.height
image = Image.new('1', (width, height))

# Get drawing object to draw on image.
draw = ImageDraw.Draw(image)

# Draw some shapes.
# First define some constants to allow easy resizing of shapes.
padding = 1
top = padding
bottom = height-padding
# Move left to right keeping track of the current x position for drawing shapes.
x = 0

# Load Truetype font 
font = ImageFont.load_default()

# Interupt routine for switch press - toggle screen on and off
def screenPowerToggle(channel):
  #Artificial DeBounce
  time.sleep(.2) 
  # Poll switch position and set screen
  screenPower = GPIO.input(SWITCH)
  if screenPower==True:
    disp.command(Adafruit_SSD1306.SSD1306_DISPLAYOFF)
  else:
    disp.command(Adafruit_SSD1306.SSD1306_DISPLAYON) 

# Add Event Watch for switch press 
GPIO.add_event_detect(SWITCH, GPIO.BOTH, callback=screenPowerToggle) 

# Set screen on or off at boot
screenPowerToggle(SWITCH)

# Draw a black filled box to clear the image.
def draw_black_box():
  draw.rectangle((0,0,width,height), outline=0, fill=0)

# Draw the image.
def draw_image_on_display():
  disp.image(image)
  disp.display()

# Set variables to "boot mode"
mode=1

# Program Start
try:

# Boot Screen and timer
  # Draw a black filled box to clear the image.
  draw_black_box()

  # Show Start Script text
  draw.text((x, top),      "   galaxyPi Display",  font=font, fill=255)
  draw.text((x, top+14),   "Waiting on startup....",  font=font, fill=255)
  draw_image_on_display()

  # Delay for network at boot
  time.sleep(boot_delay)
  
  while True:

    # Get Pi-Hole data
    r = requests.get("http://localhost/admin/api.php?summary")
    
    if mode==0:
      # Draw a black filled box to clear image.
      draw_black_box()

      draw.text((x, top),      "   Pi-Hole DNS Data",  font=font, fill=255)
      draw.text((x, top+14),   "Total queries today:", font=font, fill=255) 
      draw.text((x, top+23),   "%s" % r.json()["dns_queries_today"], font=font, fill=255)
      draw.text((x, top+34),   "Queries blocked today:", font=font, fill=255) 
      draw.text((x, top+43),   "%s" % r.json()["ads_blocked_today"], font=font, fill=255)
      draw.text((x, top+54),   "    %s%% Blocked" % r.json()["ads_percentage_today"],  font=font, fill=255)

      # Display image.
      draw_image_on_display()
      time.sleep(screen_delay)
      mode=1
      
    if mode==1:
      # Draw a black filled box to clear the image.
      draw_black_box() 

      # Get system data
      # Shell scripts for system monitoring from here : https://unix.stackexchange.com/questions/119126/command-to-display-memory-usage-disk-usage-and-cpu-load
      cmd = "hostname"
      HostName = subprocess.check_output(cmd, shell = True )
      cmd = "hostname -I | cut -d\' \' -f1"
      IP = subprocess.check_output(cmd, shell = True )
      cmd = "top -bn1 | grep load | awk '{printf \"CPU Load: %.2f\", $(NF-2)}'"
      CPU = subprocess.check_output(cmd, shell = True )
      cmd = "free -m | awk 'NR==2{printf \"Memory: %s/%sMB\", $3,$2 }'"
      MemUsage = subprocess.check_output(cmd, shell = True )
      cmd = "df -h | awk '$NF==\"/\"{printf \"Disk: %d/%dGB\", $3,$2}'"
      Disk = subprocess.check_output(cmd, shell = True )
      
      # Write Pi-Hole data
      draw.text((x, top),      "     System Data",  font=font, fill=255)
      draw.text((x, top+14),   "Hostname: " + str(HostName.decode('UTF-8')),  font=font, fill=255)
      draw.text((x, top+24),   "IP: " + str(IP.decode('UTF-8')),  font=font, fill=255)
      draw.text((x, top+34),   str(CPU.decode('UTF-8')),  font=font, fill=255)
      draw.text((x, top+44),   str(MemUsage.decode('UTF-8')),  font=font, fill=255)
      draw.text((x, top+54),   str(Disk.decode('UTF-8')),  font=font, fill=255)
      
      # Display image.
      draw_image_on_display()
      time.sleep(screen_delay)
      mode=0

except KeyboardInterrupt:
  print ("\nKeyboard Interupt - Program Stopped")

finally:
  draw_black_box()
  draw_image_on_display()
  GPIO.cleanup()
