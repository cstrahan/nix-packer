# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box         = "cstrahan/nixos-14.04-x86_64"
  config.vm.box_version = "~> 0.1.0"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 4000
    v.gui = false
  end
end
