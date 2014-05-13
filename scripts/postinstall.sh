#!/bin/sh

set -e

nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-14.04/ nixos
nixos-rebuild switch --upgrade

# Prevent collection of utilities needed by Vagrant.
nix-store --add-root --indirect /etc/nixos/vagrant

# Build and symlink utilities needed by Vagrant.
biosdevname_expr='((import <nixpkgs> {}).callPackage /etc/nixos/vagrant/biosdevname {})'
nix-store -r "$(nix-instantiate -E "$biosdevname_expr")"
biosdevname="$(nix-store -r $(nix-instantiate -E "$biosdevname_expr" 2>/dev/null) 2>/dev/null)"
mkdir -p /etc/nixos/vagrant/bin
ln -s $biosdevname /etc/nixos/vagrant/bin

# Cleanup any previous generations and delete old packages.
nix-collect-garbage -d
