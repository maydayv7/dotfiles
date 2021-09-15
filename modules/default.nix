{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Package List
    ./packages.nix
    
    # Boot Configuration
    ./boot.nix
    
    # Hardware Configuration
    ./hardware.nix
    
    # GUI Configuration
    ./gui.nix
    
    # Program Configuration
    ./programs.nix
  ];
}
