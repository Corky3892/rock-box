# !/bin/bash

echo 'Disabling ipv6...'

# Update settings
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf

# Restart
sysctl -p

# Display result
ifconfig eth0