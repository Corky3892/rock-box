# !/bin/bash

# Set the node target and install
sudo dnf module enable nodejs:$1 -y
sudo dnf install nodejs -y