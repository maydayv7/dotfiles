{ config, lib, pkgs, ... }:
{
  imports =
  [    
    # Boot Configuration
    ./boot.nix
    
    # GUI Configuration
    ./gui.nix
    
    # System Partitions
    ./partitions.nix
    
    # Program Configuration
    ./programs.nix
  ];
}
