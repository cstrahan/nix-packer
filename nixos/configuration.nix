{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
    ./guest.nix
    ./users.nix
    ./vagrant.nix
  ];

  nix.useChroot = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      # https://github.com/NixOS/nixpkgs/pull/2653
      mkpasswd = if (pkgs.stdenv.lib.versionOlder pkgs.mkpasswd.version "5.1.2")
        then pkgs.callPackage ./vagrant/pkgs/mkpasswd { }
        else pkgs.mkpasswd;
    };
  };
}
