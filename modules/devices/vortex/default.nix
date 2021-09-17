{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Boot Configuration
    ./boot.nix
    
    # Package List
    ./packages.nix
    
    # Hardware Configuration
    ./hardware.nix
    
    # Additional Service Configuration
    ./services.nix
  ];
}
