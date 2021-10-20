{ lib, ... }:
{
  ## Network Settings ##
  networking =
  {
    networkmanager.enable = true;
    firewall.enable = false;
  };
}
