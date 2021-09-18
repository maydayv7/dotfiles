{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = 
  [
    (import ./dconf.nix)
  ];
}
