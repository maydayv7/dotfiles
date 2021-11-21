{ system, version, files, secrets, lib, inputs, pkgs, ... }:
rec
{
  device = import ./device.nix { inherit system version files secrets lib user inputs pkgs; };
  user = import ./user.nix { inherit system version files secrets lib inputs pkgs; };
}
