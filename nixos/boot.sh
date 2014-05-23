set -e
set -x

# Assuming a single disk (/dev/sda).
MB="1048576"
DISK_SIZE=`fdisk -l | grep ^Disk | awk -F" "  '{ print $5 }'`
DISK_SIZE=$(($DISK_SIZE / $MB))

# Create partitions
if [ -z "$SWAP" ]; then
  echo "n
p
1


a
w
" | fdisk /dev/sda
else
  PRIMARY_SIZE=$(($DISK_SIZE - $SWAP))
  echo "n
p
1

+${PRIMARY_SIZE}M
a
n
p
2


w
" | fdisk /dev/sda
  mkswap -L swap /dev/sda2
  swapon /dev/sda2
fi

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
