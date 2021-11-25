{ system, version, lib, inputs, pkgs, files, ... }:
rec
{
  device = import ./device.nix { inherit system version lib user inputs pkgs files; };
  iso = import ./iso.nix { inherit system version lib inputs pkgs files; };
  user = import ./user.nix { inherit system version lib inputs pkgs files; };
}
