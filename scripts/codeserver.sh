# !/bin/bash

# Install code-server 
curl -fsSL https://code-server.dev/install.sh | sh -s --version 4.1.0

# Set to run as a service
sudo systemctl enable --now code-server@$1

# Sleep for 10 seconds, we need to allow time for code-server to write the files which we are going to update in the next step.
sleep 10

# Configure password
sed -i "s/password: .*/password: $2/g" /home/$1/.config/code-server/config.yaml
sed -i "s/bind-addr: 127.0.0.1:8080/bind-addr: $3:8080/g" /home/$1/.config/code-server/config.yaml

# Restart code-server using the updated config
sudo systemctl restart code-server@$1

# Create a firewall rule
sudo firewall-cmd --permanent --zone=lab --add-rich-rule="rule family=ipv4 source address=$(awk -F"." '{print $1"."$2"."$3".0/24"}'<<<$3) port port=8080 protocol=tcp accept"
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

sed -i "s/password: .*/password: $2/g" /home/cconnor/.config/code-server/config.yaml
sed -i "s/bind-addr: 127.0.0.1:8080/bind-addr: $3:8080/g" /home/$1/.config/code-server/config.yaml