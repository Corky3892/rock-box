# !/bin/bash

# Lockdown ssh access to a target user.
if id "$1" &>/dev/null; then
  sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
  sudo echo "" >> /etc/ssh/sshd_config
  sudo echo "# Restrict ssh access to the specific users" >> /etc/ssh/sshd_config  
  sudo echo "AllowUsers $1" >> /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  echo "SSH user access locked restricted to $1 only."
else
  echo "User $1 does not exist, unable to proceed with user based lockdown."
fi

# Lockdown the firewall
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --new-zone=lab
sudo firewall-cmd --reload
sudo firewall-cmd --set-default-zone=lab
sudo firewall-cmd --set-target DROP --permanent
sudo firewall-cmd --permanent --zone=lab --add-rich-rule="rule family=ipv4 source address=$2 service name=ssh log prefix='SSH Access' level='notice' accept"
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

# To - Do
  # Change the default root password