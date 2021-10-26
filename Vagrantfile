# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Read in config.yaml
current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vagrant_config = configs['configs'][configs['configs']['use']]

# This provisioner was developed using 2.2.18 - untested on older version
Vagrant.require_version ">= 2.2.18"

# Configure the vagrant machine
Vagrant.configure("2") do |config|

  # Use the official Rocky Linux base box
  config.vm.box = vagrant_config['box']
  config.vm.box_version = vagrant_config['version']

  # Name the host
  config.vm.hostname = vagrant_config['hostname']

  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: vagrant_config['private_ip']

  # Disabled shared folders
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # configure the machine using virtualBoxp
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  
    # Customize the amount of memory on the VM:
    vb.memory = vagrant_config['ram']
    vb.cpus = vagrant_config['cores']
  end

  # Run Provisioning scripts
  config.vm.provision "file", source: vagrant_config['public_key_path'], destination: "~/"
  config.vm.provision :shell, path: "./scripts/mkusr.sh", :args => vagrant_config['user']
  config.vm.provision :shell, path: "./scripts/lockdown.sh", :args => [vagrant_config['user'], vagrant_config['subnet']]
end