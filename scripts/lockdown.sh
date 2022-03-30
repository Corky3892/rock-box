# !/bin/bash

# Lockdown ssh access to a target user.
if id "$1" &>/dev/null; then
  sudo sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
  sudo sed -i "s/#Port 22/Port $3/g" /etc/ssh/sshd_config
  sudo echo "# Restrict ssh access to the specific users" >> /etc/ssh/sshd_config  
  sudo echo "AllowUsers $1" >> /etc/ssh/sshd_config
  sudo systemctl restart sshd.service
  echo "SSH user access locked restricted to $1 only."
else
  echo "User $1 does not exist, unable to proceed with user based lockdown."
fi

# Lockdown the firewall
echo "Starting lockdown of firewall..."
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --new-zone=lab
sudo firewall-cmd --reload
sudo firewall-cmd --set-default-zone=lab
sudo firewall-cmd --set-target DROP --permanent
sudo firewall-cmd --permanent --zone=lab --add-rich-rule="rule family=ipv4 source address=10.0.2.2 service name=ssh accept"
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

# Randomnly generate root password and then disable root login
echo root:$(openssl rand -base64 14) | sudo chpasswd
sudo passwd -l root