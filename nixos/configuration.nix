{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
    ./guest.nix
    ./users.nix
    ./vagrant.nix
  ];
}
