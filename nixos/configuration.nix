{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
    ./guest.nix
    ./users.nix
    ./vagrant.nix
  ];

  #packageOverrides = pkgs: {
    # This is needed by Vagrant to support network configuration.
    # This override can be removed once `biosdevname' is in the official Nixpkgs.
    #biosdevname = pkgs.biosdevname or pkgs.callPackage (import ./vagrant/biosdevname);
  #};

  # `biosdevname' is needed by Vagrant to support network configuration.
  #environment.systemPackages = [ pkgs.biosdevname ];
}
