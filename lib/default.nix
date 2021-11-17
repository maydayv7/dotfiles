{ system, version, secrets, lib, inputs, pkgs, ... }:
rec
{
  device = import ./device { inherit system version secrets lib user inputs pkgs; };
  user = import ./user { inherit system version secrets lib inputs pkgs; };
}
