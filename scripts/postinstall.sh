#!/bin/sh

set -e
set -x

nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-14.04/ nixos

# Attempt to rebuild, but fail due to https://github.com/NixOS/nixpkgs/pull/2675
# then create the user manually,
# then run rebuild again.
nixos-rebuild switch --upgrade || true
useradd \
  -g "vagrant" \
  -G "users,vboxsf,wheel" \
  -s "/run/current-system/sw/bin/bash" \
  -d "/home/vagrant" \
  "vagrant"
nixos-rebuild switch --upgrade

# Cleanup any previous generations and delete old packages.
nix-collect-garbage -d

#################
# General cleanup
#################

# Clear history
unset HISTFILE
if [ -f /root/.bash_history ]; then
  rm /root/.bash_history
fi
if [ -f /home/vagrant/.bash_history ]; then
  rm /home/vagrant/.bash_history
fi

# Clear temporary folder
rm -rf /tmp/*

# Truncate the logs.
#find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Zero the unused space.
#count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
#let count--
#dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
#rm /tmp/whitespace;
