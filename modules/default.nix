{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Package List
    ./packages.nix
    
    # GUI Configuration
    ./gui.nix
    
    # System Partitions
    ./partitions.nix
    
    # Program Configuration
    ./programs.nix
    
    # Device Specific Configuration
    ../volatile/device.nix
  ];
}
