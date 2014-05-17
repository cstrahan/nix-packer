#!/bin/sh

set -e
set -x

nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-14.04/ nixos
nixos-rebuild switch --upgrade

# Prevent collection of utilities needed by Vagrant.
ln -sv /etc/nix/vagrant /nix/var/nix/gcroots

# Build and symlink utilities needed by Vagrant.
mkdir -p /etc/nix/vagrant/bin
biosdevname_expr='((import <nixpkgs> {}).callPackage /etc/nixos/vagrant/pkgs/biosdevname {})'
echo "$biosdevname_expr" > biosdevname.nix
biosdevname=$(nix-build --no-out-link biosdevname.nix)/bin/biosdevname
ln -sv "$biosdevname" /etc/nix/vagrant/bin
rm biosdevname.nix

# Cleanup any previous generations and delete old packages.
nix-collect-garbage -d
