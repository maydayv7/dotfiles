{ system, version, lib, inputs, pkgs, ... }:
rec
{
  user = import ./user.nix { inherit system version lib inputs pkgs; };
  device = import ./device.nix { inherit system version lib user inputs pkgs; };
}
