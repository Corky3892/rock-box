# !/bin/bash

# Set the node target and install
sudo dnf module enable nodejs:$1 -y
sudo dnf install nodejs -y

# Install yarn
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
dnf install yarn -y