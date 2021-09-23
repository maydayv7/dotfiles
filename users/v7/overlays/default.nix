{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = 
  [
    (import ./discord.nix)
  ];
}
