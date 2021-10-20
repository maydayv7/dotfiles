{ config, lib, pkgs, ... }:
{
  ## Network Settings ##
  networking =
  {
    networkmanager.enable = true;
    firewall.enable = false;
  };
}
