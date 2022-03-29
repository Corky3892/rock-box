# !/bin/bash

echo 'Configuring date and time settings...'

# Set the timezone
sudo timedatectl set-timezone $1

# Not chrony for NTP sync is already included in this base box..