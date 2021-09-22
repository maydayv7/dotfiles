{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = 
  [ 
    (import ./touchegg.nix)
    (import ./plymouth.nix)
    (import ./sof-firmware.nix)
    (import ./gnome-terminal.nix)
    
    # Custom Packages
    (import ./packages)
  ];
}
