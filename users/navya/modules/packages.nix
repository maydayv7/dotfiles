{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs;
  [
    gscan2pdf
    teams
    zoom-us
  ];
}
