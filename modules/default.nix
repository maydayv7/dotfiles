{ config, lib, pkgs, ... }:
{
  imports =
  [    
    # GUI Configuration
    ./gui.nix
    
    # System Partitions
    ./partitions.nix
    
    # Program Configuration
    ./programs.nix
  ];
}
