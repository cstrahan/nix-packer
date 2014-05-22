# About

This is a [Packer](packer.io) definition for [NixOS](nixos.org). It
builds a [Vagrant](http://www.vagrantup.com/) box for NixOS 14.04
x86_64.

# Usage

Pre-built boxes are [hosted on
VagrantCloud](https://vagrantcloud.com/cstrahan). To use a pre-built
box, you just need to set the `config.vm.box` setting in your
Vagrantfile to `"cstrahan/nixos-14.04-x86_64"`. Here's a complete
example:

``` ruby
Vagrant.configure("2") do |config|
  config.vm.box         = "cstrahan/nixos-14.04-x86_64"
  config.vm.box_version = "~> 0.1.0"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 4000
    v.gui = false
  end
end
```
