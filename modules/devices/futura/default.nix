{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Boot Configuration
    ./boot.nix
    
    # Hardware Configuration
    ./hardware.nix
  ];
}
