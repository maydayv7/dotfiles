{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = 
  [ 
    (import ./dash.nix)
  ];
}
