{ system, version, lib, inputs, pkgs, ... }:
rec
{
  device = import ./device { inherit system version lib user inputs pkgs; };
  user = import ./user { inherit system version lib inputs pkgs; };
}
