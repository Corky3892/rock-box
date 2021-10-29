# !/bin/bash

# Create a new passwordless sudoer.
if id "$1" &>/dev/null; then
  echo "User $1 already exists, skipping..."
else
  sudo adduser $1
  sudo usermod -aG wheel $1
  echo "%$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1
  echo "User $1 was created."
  sudo mkdir /home/$1/.ssh -p
  sudo cat /home/vagrant/id_rsa.pub > /home/$1/.ssh/authorized_keys
  sudo rm /home/vagrant/id_rsa.pub
  sudo chown -R $1:$1 /home/$1
fi