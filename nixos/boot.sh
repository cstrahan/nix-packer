set -e
set -x

# Assuming a single disk (/dev/sda).
MB="1048576"
DISK_SIZE=$(fdisk -l | grep ^Disk | grep -v loop | awk -F" "  '{ print $5 }' | head -n 1)
DISK_SIZE=$(($DISK_SIZE / $MB))

# Create partitions.
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

# Generate hardware config.
nixos-generate-config --root /mnt

# Download configuration.
curl http://$HTTP_IP:$HTTP_PORT/configuration.nix > /mnt/etc/nixos/configuration.nix
curl http://$HTTP_IP:$HTTP_PORT/guest.nix > /mnt/etc/nixos/guest.nix
curl http://$HTTP_IP:$HTTP_PORT/graphical.nix > /mnt/etc/nixos/graphical.nix
curl http://$HTTP_IP:$HTTP_PORT/text.nix > /mnt/etc/nixos/text.nix
curl http://$HTTP_IP:$HTTP_PORT/users.nix > /mnt/etc/nixos/users.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-hostname.nix > /mnt/etc/nixos/vagrant-hostname.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-network.nix > /mnt/etc/nixos/vagrant-network.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant.nix > /mnt/etc/nixos/vagrant.nix


if [ -z "$GRAPHICAL" ]; then
  sed -i 's/graphical\.nix/text.nix/' /mnt/etc/nixos/configuration.nix
fi

nixos-install

sleep 2
reboot -f
