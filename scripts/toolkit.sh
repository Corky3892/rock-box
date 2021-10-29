# !/bin/bash

# Update dnf and install epel-release
sudo dnf update -y
sudo dnf install epel-release -y

# Install modules
sudo dnf install net-tools -y
sudo dnf install htop -y
sudo dnf install git -y
sudo dnf install vim -y