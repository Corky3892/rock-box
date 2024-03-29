# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Address a potential security vulnerability (ref: https://phoenhex.re/2018-03-25/not-a-vagrant-bug).
VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

# Read in config.yaml
current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = configs['configs'][configs['configs']['use']]

# This provisioner was developed using 2.2.18 - untested on older version
Vagrant.require_version ">= 2.2.18"

# Configure the vagrant machine
Vagrant.configure("2") do |config|

  # If the box has already been intialized then connect using the created user
  if File.exists?('.initialized')
    config.ssh.username = vagrant_config['user']
    config.ssh.private_key_path = vagrant_config['private-key-path']
  end

  # Use the official Rocky Linux base box
  config.vm.box = vagrant_config['box']
  config.vm.box_version = vagrant_config['version']

  # Name the host
  config.vm.hostname = vagrant_config['hostname']

  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: vagrant_config['private-ip']

  # Disabled default synced folders
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Configure the machine using virtualBox
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  
    # Customize the amount of memory on the VM:
    vb.memory = vagrant_config['ram']
    vb.cpus = vagrant_config['cores']
  end

  # On destroy remove the .initialized file if it exists
  config.trigger.after :destroy do |trigger|
    trigger.info = "Removing .initialized file."
    trigger.run = {inline: 'rm .initialized'}    
  end

  # On up, provision create the initialized file
  config.trigger.after [:up, :provision] do |trigger|
    trigger.info = "Creating .initialized file."
    trigger.run = {inline: 'touch .initialized'}
  end

  # ------------------------
  # ------PROVISIONING------
  # ------------------------

  # If the box has not yet been initialized then perform those steps (this can only be done once)
  unless File.exists?('.initialized')
    config.vm.provision "file", source: vagrant_config['public-key-path'], destination: "~/"
    config.vm.provision :shell, path: "./scripts/mkusr.sh", :args => vagrant_config['user']
    config.vm.provision :shell, path: "./scripts/lockdown.sh", :args => [vagrant_config['user'], vagrant_config['private-ip']]  
  end
  config.vm.provision :shell, path: "./scripts/toolkit.sh"
  config.vm.provision :shell, path: "./scripts/disableipv6.sh"
  config.vm.provision :shell, path: "./scripts/datetime.sh", :args => vagrant_config['timezone']
  config.vm.provision :shell, path: "./scripts/codeserver.sh", :args => [
    vagrant_config['user'], vagrant_config['code-srv-pass'], vagrant_config['private-ip']
  ]
  config.vm.provision :shell, path: "./scripts/nodejs.sh", :args => vagrant_config['node-version']
  config.vm.provision :shell, path: "./scripts/mongo.sh", :args => vagrant_config['private-ip']
  config.vm.provision :shell, path: "./scripts/rmuser.sh"
end