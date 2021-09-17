{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Package List
    ./packages.nix
    
    # Hardware Configuration
    ./hardware.nix
  ];
}
