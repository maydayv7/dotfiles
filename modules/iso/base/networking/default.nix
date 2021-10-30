{ config, lib, ... }:
let
  cfg = config.base.enable;
in rec
{
  ## Network Settings ##
  config = lib.mkIf (cfg == true)
  {
    networking =
    {
      networkmanager.enable = true;
      firewall.enable = false;
    };
  };
}
