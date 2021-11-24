{ system, version, files, lib, inputs, pkgs, ... }:
rec
{
  device = import ./device.nix { inherit system version files lib user inputs pkgs; };
  user = import ./user.nix { inherit system version files lib inputs pkgs; };
}
