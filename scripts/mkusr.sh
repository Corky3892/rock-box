# !/bin/bash

# Create a new passwordless sudoer, requires that the users ssh key was created at /home/vagrant/id_rsa.pub in the previous step.
if id "$1" &>/dev/null; then
  echo "User $1 already exists, skipping..."
else
  # Validate that a id_rsa file was previous placed at the root of the vagrant directory.
  if [[ -f /home/vagrant/id_rsa.pub && -s /home/vagrant/id_rsa.pub ]]; then
    # Proceed with user creation.
    sudo adduser $1
    sudo usermod -aG wheel $1
    echo "%$1 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$1
    sudo mkdir /home/$1/.ssh -p
    sudo cat /home/vagrant/id_rsa.pub > /home/$1/.ssh/authorized_keys
    sudo rm /home/vagrant/id_rsa.pub
    sudo chown -R $1:$1 /home/$1
    echo "User $1 was created."
  else
    echo "id_rsa.pub not found"
    exit 1
  fi
fi