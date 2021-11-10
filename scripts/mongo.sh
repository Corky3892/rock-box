# !/bin/bash

# Add the MongoDB respository
sudo cat > /etc/yum.repos.d/mongodb.repo << 'EOL'
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOL

# Install mongoDB
sudo dnf install mongodb-org -y

# Configure IP binding
sudo sed -i "s/bindIp: 127.0.0.1/bindIp: 127.0.0.1,$1/g" /etc/mongod.conf

# Configure mongoDB to run as a service
sudo systemctl enable --now mongod

# Create a firewall rule
sudo firewall-cmd --permanent --zone=lab --add-rich-rule="rule family=ipv4 source address=$(awk -F"." '{print $1"."$2"."$3".0/24"}'<<<$1) port port=27017 protocol=tcp accept"
sudo firewall-cmd --reload
sudo firewall-cmd --list-all