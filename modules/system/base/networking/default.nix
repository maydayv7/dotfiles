{ config, lib, ... }:
with lib;
with builtins;
let
  cfg = config.base.enable;
in rec
{
  config = mkIf (cfg == true)
  {
    ## Network Settings ##
    networking =
    {
      networkmanager.enable = true;
      firewall.enable = false;
    };
  };
}
