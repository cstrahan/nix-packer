stop sshd

set -e
set -x

echo "HTTP_IP:   $HTTP_IP\nHTTP_PORT: $HTTP_PORT"
sleep 5

echo "n




a
1
w
" | fdisk /dev/sda
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
nixos-install && reboot
