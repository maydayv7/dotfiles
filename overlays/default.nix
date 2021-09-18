{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = 
  [ 
    (import ./touchegg.nix)
    (import ./plymouth.nix)
    (import ./sof-firmware.nix)
    
    # Custom Packages
    (import ./packages)
  ];
}
