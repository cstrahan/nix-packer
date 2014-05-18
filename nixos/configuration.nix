{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
    ./graphical.nix
    ./guest.nix
    ./users.nix
    ./vagrant-network.nix
    ./vagrant-hostname.nix
  ];

  nix.useChroot = true;

  environment.systemPackages =
    [ pkgs.biosdevname # needed by the Vagrant plugin
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      # https://github.com/NixOS/nixpkgs/pull/2653
      mkpasswd = pkgs.callPackage ./vagrant/pkgs/mkpasswd { };
      biosdevname = pkgs.callPackage ./vagrant/pkgs/biosdevname { };
    };
  };
}
