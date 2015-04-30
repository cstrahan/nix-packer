{ config, pkgs, ... }:

{
  # Enable guest additions.
  services.virtualboxGuest.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
