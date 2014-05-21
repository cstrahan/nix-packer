stop sshd

set -e
set -x

printChars () {
  for c in "$@"
  do
    printf "$c"
  done
}

printChars \
  "n"  \
  "\n" \
  "\n" \
  "\n" \
  "\n" \
  "\n" \
  "a"  \
  "\n" \
  "1"  \
  "\n" \
  "w"  \
  "\n" | fdisk /dev/sda

mkfs.ext4 -j -L nixos /dev/sda1
mount LABEL=nixos /mnt
nixos-generate-config --root /mnt
curl http://$HTTP_IP:$HTTP_PORT/configuration.nix > /mnt/etc/nixos/configuration.nix
curl http://$HTTP_IP:$HTTP_PORT/guest.nix > /mnt/etc/nixos/guest.nix
curl http://$HTTP_IP:$HTTP_PORT/graphical.nix > /mnt/etc/nixos/graphical.nix
curl http://$HTTP_IP:$HTTP_PORT/users.nix > /mnt/etc/nixos/users.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-hostname.nix > /mnt/etc/nixos/vagrant-hostname.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-network.nix > /mnt/etc/nixos/vagrant-network.nix
mkdir -p /mnt/etc/nixos/vagrant/pkgs/{biosdevname,mkpasswd}
curl http://$HTTP_IP:$HTTP_PORT/vagrant/pkgs/biosdevname/default.nix > /mnt/etc/nixos/vagrant/pkgs/biosdevname/default.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant/pkgs/biosdevname/makefile.patch > /mnt/etc/nixos/vagrant/pkgs/biosdevname/makefile.patch
curl http://$HTTP_IP:$HTTP_PORT/vagrant/pkgs/mkpasswd/default.nix > /mnt/etc/nixos/vagrant/pkgs/mkpasswd/default.nix

if [ -z "$GRAPHICAL" ]; then
  sed -i '/graphical\.nix/d' /mnt/etc/nixos/configuration.nix
fi

nixos-install && reboot
