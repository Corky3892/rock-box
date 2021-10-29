# Rock Box
Rock Box is a set of security minded provisioning scripts built on top of Vagrant and Rocky Linux which aims to achieve the following goals.

  1. Strip away default vagrant access / user access.
  2. Provide secure firewall settings out of the box.
  3. Provide provisioning modules to install various utilities.

The ultimate goal is to create a secure Lab to run local development environments, play around with other new software or otherwise mess around in Rocky Linux.

## Bootstrapping
Please see the below guide to get started using the Rock-Box.

### Pre-Requisites

  1. A local [Vagrant](https://www.vagrantup.com/downloads) installation.
  2. A Vagrant Provider, [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is a great choice, as it is free.

### Installation
This assumes you are using bash or a bash-like terminal [Git SCM](https://git-scm.com/) works wonders from Windows Hosts.
```sh
# Create a directory to store the box
mkdir ~/boxes/{YOUR_BOX_BAME} -p
cd ~/boxes/{YOUR_BOX_NAME}

# Clone the Rock-Box project
git clone https://github.com/Corky3892/rock-box.git

# Generate a new ssh_keypair (can skip if you already have one)
ssh-keygen

# Create config.yaml
mv config.template.yaml config.yaml

# Update config.yaml
# User your favorite text editor

# Provision vagrant, this can take a while
vagrant up

# Connect
ssh YOUR_USER_NAME@YOUR_PRIVATE_IP
```

Go ahead and open your browser and navigate to your private IP, on port 8080 (eg: 192.168.33.10:8080) and enter the password you set up.
 
## Config
Description of config parameters within `config.yaml`.
```yaml
---
configs:
  use: default
  default:
    box: rockylinux/8             # The Base Box, don't recommend changing it
    version: 4.0.0                # Box version, as updated from time to time
    hostname: YOUR_HOST           # The hostname of the vm you are creating
    ram: 4096                     # The virtual ram to allocate the vm
    cores: 2                      # The virtual cores to allocate the bm
    private_ip: 192.168.33.10     # The private IP you wish to assign the box, really it can be anything
    user: YOUR_USER_NAME          # The username to create on the vm
    code-srv-pass: YOUR_PASSWORD  # The password you will use to log into code-server
    node_version: 14              # The nodejs version to install, valid options are: 10, 12, 13, or 14
    public_key_path: C:/Users/YOUR_USER_NAME/.ssh/id_rsa.pub  # Path to the public key which will be hoisted to the vm
```

## To - Do
  1. Improve `lockdown.sh` to change the root password.
  2. Improve `lockdown.sh` to limit outbound traffic to install repos only.
  3. Write `datetime.sh` with NTP for Time Syncronization.
  4. Write `disableipv6.sh` to disable IPv6.
  5. Write `rmuser.sh` to remove the default vagrant user and all references to it in the filesystem.